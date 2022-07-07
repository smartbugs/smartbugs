// solium-disable linebreak-style
pragma solidity ^0.5.0;

contract CryptoTycoonsVIPLib{
    
    address payable public owner;
    
    // Accumulated jackpot fund.
    uint128 public jackpotSize;
    uint128 public rankingRewardSize;
    
    mapping (address => uint) userExpPool;
    mapping (address => bool) public callerMap;

    event RankingRewardPayment(address indexed beneficiary, uint amount);

    modifier onlyOwner {
        require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
        _;
    }

    modifier onlyCaller {
        bool isCaller = callerMap[msg.sender];
        require(isCaller, "onlyCaller methods called by non-caller.");
        _;
    }

    constructor() public{
        owner = msg.sender;
        callerMap[owner] = true;
    }

    // Fallback function deliberately left empty. It's primary use case
    // is to top up the bank roll.
    function () external payable {
    }

    function kill() external onlyOwner {
        selfdestruct(owner);
    }

    function addCaller(address caller) public onlyOwner{
        bool isCaller = callerMap[caller];
        if (isCaller == false){
            callerMap[caller] = true;
        }
    }

    function deleteCaller(address caller) external onlyOwner {
        bool isCaller = callerMap[caller];
        if (isCaller == true) {
            callerMap[caller] = false;
        }
    }

    function addUserExp(address addr, uint256 amount) public onlyCaller{
        uint exp = userExpPool[addr];
        exp = exp + amount;
        userExpPool[addr] = exp;
    }

    function getUserExp(address addr) public view returns(uint256 exp){
        return userExpPool[addr];
    }

    function getVIPLevel(address user) public view returns (uint256 level) {
        uint exp = userExpPool[user];

        if(exp >= 25 ether && exp < 125 ether){
            level = 1;
        } else if(exp >= 125 ether && exp < 250 ether){
            level = 2;
        } else if(exp >= 250 ether && exp < 1250 ether){
            level = 3;
        } else if(exp >= 1250 ether && exp < 2500 ether){
            level = 4;
        } else if(exp >= 2500 ether && exp < 12500 ether){
            level = 5;
        } else if(exp >= 12500 ether && exp < 25000 ether){
            level = 6;
        } else if(exp >= 25000 ether && exp < 125000 ether){
            level = 7;
        } else if(exp >= 125000 ether && exp < 250000 ether){
            level = 8;
        } else if(exp >= 250000 ether && exp < 1250000 ether){
            level = 9;
        } else if(exp >= 1250000 ether){
            level = 10;
        } else{
            level = 0;
        }

        return level;
    }

    function getVIPBounusRate(address user) public view returns (uint256 rate){
        uint level = getVIPLevel(user);
        return level;
    }

    // This function is used to bump up the jackpot fund. Cannot be used to lower it.
    function increaseJackpot(uint increaseAmount) external onlyCaller {
        require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
        require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");
        jackpotSize += uint128(increaseAmount);
    }

    function payJackpotReward(address payable to) external onlyCaller{
        to.transfer(jackpotSize);
        jackpotSize = 0;
    }

    function getJackpotSize() external view returns (uint256){
        return jackpotSize;
    }

    function increaseRankingReward(uint amount) public onlyCaller{
        require (amount <= address(this).balance, "Increase amount larger than balance.");
        require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");
        rankingRewardSize += uint128(amount);
    }

    function payRankingReward(address payable to) external onlyCaller {
        uint128 prize = rankingRewardSize / 2;
        rankingRewardSize = rankingRewardSize - prize;
        if(to.send(prize)){
            emit RankingRewardPayment(to, prize);
        }
    }

    function getRankingRewardSize() external view returns (uint128){
        return rankingRewardSize;
    }
}

contract CardRPS {
    /// *** Constants section

    // Each bet is deducted 1% in favour of the house, but no less than some minimum.
    // The lower bound is dictated by gas costs of the settleBet transaction, providing
    // headroom for up to 10 Gwei prices.
    uint constant HOUSE_EDGE_PERCENT = 1;
    uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether;

    // Bets lower than this amount do not participate in jackpot rolls (and are
    // not deducted JACKPOT_FEE).
    uint constant MIN_JACKPOT_BET = 0.1 ether;

    // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
    uint constant JACKPOT_MODULO = 1000;
    uint constant JACKPOT_FEE = 0.001 ether;

    // There is minimum and maximum bets.
    uint constant MIN_BET = 0.01 ether;
    uint constant MAX_AMOUNT = 10 ether;

    // Modulo is a number of equiprobable outcomes in a game:
    // - 2 for coin flip
    // - 6 for dice
    // - 6*6 = 36 for double dice
    // - 100 for etheroll
    // - 37 for roulette
    // etc.
    // It's called so because 256-bit entropy is treated like a huge integer and
    // the remainder of its division by modulo is considered bet outcome.
    // uint constant MAX_MODULO = 100;

    // For modulos below this threshold rolls are checked against a bit mask,
    // thus allowing betting on any combination of outcomes. For example, given
    // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
    // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
    // limit is used, allowing betting on any outcome in [0, N) range.
    //
    // The specific value is dictated by the fact that 256-bit intermediate
    // multiplication result allows implementing population count efficiently
    // for numbers that are up to 42 bits, and 40 is the highest multiple of
    // eight below 42.
    uint constant MAX_MASK_MODULO = 40;

    // This is a check on bet mask overflow.
    uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;

    // EVM BLOCKHASH opcode can query no further than 256 blocks into the
    // past. Given that settleBet uses block hash of placeBet as one of
    // complementary entropy sources, we cannot process bets older than this
    // threshold. On rare occasions AceDice croupier may fail to invoke
    // settleBet in this timespan due to technical issues or extreme Ethereum
    // congestion; such bets can be refunded via invoking refundBet.
    uint constant BET_EXPIRATION_BLOCKS = 250;

    // Some deliberately invalid address to initialize the secret signer with.
    // Forces maintainers to invoke setSecretSigner before processing any bets.
    address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    // Standard contract ownership transfer.
    address payable public owner;
    address payable private nextOwner;

    // Adjustable max bet profit. Used to cap bets against dynamic odds.
    uint public maxProfit;

    // The address corresponding to a private key used to sign placeBet commits.
    address public secretSigner;

    // Funds that are locked in potentially winning bets. Prevents contract from
    // committing to bets it cannot pay out.
    uint128 public lockedInBets;

    // A structure representing a single bet.
    struct Bet {
        // Wager amount in wei.
        uint amount;
        // Block number of placeBet tx.
        uint40 placeBlockNumber;
        // Address of a gambler, used to pay out winning bets.
        address payable gambler;
        // Address of inviter
        address payable inviter;
    }

    struct RandomNumber{
        uint8 playerNum1;
        uint8 playerNum2;
        uint8 npcNum1;
        uint8 npcNum2;
        uint8 rouletteIndex;
    }

    // Mapping from commits to all currently active & processed bets.
    mapping (uint => Bet) bets;

    // Croupier account.
    mapping (address => bool ) croupierMap;

    address payable public VIPLibraryAddress;

    // Events that are issued to make statistic recovery easier.
    event FailedPayment(address indexed beneficiary, uint amount);
    event Payment(address indexed beneficiary, uint amount, uint playerNum1, uint playerNum2, uint npcNum1, uint npcNum2, uint betAmount);
    event JackpotPayment(address indexed beneficiary, uint amount, uint playerNum1, uint playerNum2, uint npcNum1, uint npcNum2, uint betAmount);
    event VIPPayback(address indexed beneficiary, uint amount);

    // This event is emitted in placeBet to record commit in the logs.
    event Commit(uint commit);

    // Constructor. Deliberately does not take any parameters.
    constructor () public {
        owner = msg.sender;
        secretSigner = DUMMY_ADDRESS;
    }

    // Standard modifier on methods invokable only by contract owner.
    modifier onlyOwner {
        require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
        _;
    }

    // Standard modifier on methods invokable only by contract owner.
    modifier onlyCroupier {
    bool isCroupier = croupierMap[msg.sender];
        require(isCroupier, "OnlyCroupier methods called by non-croupier.");
        _;
    }

    // Standard contract ownership transfer implementation,
    function approveNextOwner(address payable _nextOwner) external onlyOwner {
        require (_nextOwner != owner, "Cannot approve current owner.");
        nextOwner = _nextOwner;
    }

    function acceptNextOwner() external {
        require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
        owner = nextOwner;
    }

    // Fallback function deliberately left empty. It's primary use case
    // is to top up the bank roll.
    function () external payable {
    }

    // See comment for "secretSigner" variable.
    function setSecretSigner(address newSecretSigner) external onlyOwner {
        secretSigner = newSecretSigner;
    }

    function getSecretSigner() external onlyOwner view returns(address){
        return secretSigner;
    }

    function addCroupier(address newCroupier) external onlyOwner {
        bool isCroupier = croupierMap[newCroupier];
        if (isCroupier == false) {
            croupierMap[newCroupier] = true;
        }
    }
    
    function deleteCroupier(address newCroupier) external onlyOwner {
        bool isCroupier = croupierMap[newCroupier];
        if (isCroupier == true) {
            croupierMap[newCroupier] = false;
        }
    }

    function setVIPLibraryAddress(address payable addr) external onlyOwner{
        VIPLibraryAddress = addr;
    }

    // Change max bet reward. Setting this to zero effectively disables betting.
    function setMaxProfit(uint _maxProfit) public onlyOwner {
        require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
        maxProfit = _maxProfit;
    }

    // Funds withdrawal to cover costs of AceDice operation.
    function withdrawFunds(address payable beneficiary, uint withdrawAmount) external onlyOwner {
        require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
        require (lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
        sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0, 0, 0, 0, 0);
    }

    function kill() external onlyOwner {
        require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
        selfdestruct(owner);
    }

    function encodePacketCommit(uint commitLastBlock, uint commit) private pure returns(bytes memory){
        return abi.encodePacked(uint40(commitLastBlock), commit);
    }

    function verifyCommit(uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) private view {
        // Check that commit is valid - it has not expired and its signature is valid.
        require (block.number <= commitLastBlock, "Commit has expired.");
        //bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes memory message = encodePacketCommit(commitLastBlock, commit);
        bytes32 messageHash = keccak256(abi.encodePacked(prefix, keccak256(message)));
        require (secretSigner == ecrecover(messageHash, v, r, s), "ECDSA signature is not valid.");
    }

    function placeBet(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s) external payable {
        // Check that the bet is in 'clean' state.
        Bet storage bet = bets[commit];
        require (bet.gambler == address(0), "Bet should be in a 'clean' state.");

        // Validate input data ranges.
        uint amount = msg.value;
        //require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
        require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
        require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");

        verifyCommit(commitLastBlock, commit, v, r, s);

        // Winning amount and jackpot increase.
        uint possibleWinAmount = amount * 5;
        uint jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;

        // Enforce max profit limit.
        require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");

        // Lock funds.
        lockedInBets += uint128(possibleWinAmount);

        // Check whether contract has enough funds to process this bet.
        require (jackpotFee + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");

        // Record commit in logs.
        emit Commit(commit);

        // Store bet parameters on blockchain.
        bet.amount = amount;
        bet.placeBlockNumber = uint40(block.number);
        bet.gambler = msg.sender;

        CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
        vipLib.addUserExp(msg.sender, amount);
    }

    function placeBetWithInviter(uint betMask, uint commitLastBlock, uint commit, uint8 v, bytes32 r, bytes32 s, address payable inviter) external payable {
        // Check that the bet is in 'clean' state.
        Bet storage bet = bets[commit];
        require (bet.gambler == address(0), "Bet should be in a 'clean' state.");

        // Validate input data ranges.
        uint amount = msg.value;
        // require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
        require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
        require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
        require (address(this) != inviter && inviter != address(0), "cannot invite mysql");

        verifyCommit(commitLastBlock, commit, v, r, s);

        // Winning amount and jackpot increase.
        uint possibleWinAmount = amount * 5;
        uint jackpotFee  = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;

        // Enforce max profit limit.
        require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");

        // Lock funds.
        lockedInBets += uint128(possibleWinAmount);
        // jackpotSize += uint128(jackpotFee);

        // Check whether contract has enough funds to process this bet.
        require (jackpotFee + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");

        // Record commit in logs.
        emit Commit(commit);

        // Store bet parameters on blockchain.
        bet.amount = amount;
        // bet.modulo = uint8(modulo);
        //bet.rollUnder = uint8(betMask);
        bet.placeBlockNumber = uint40(block.number);
        //bet.mask = uint40(mask);
        bet.gambler = msg.sender;
        bet.inviter = inviter;

        CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
        vipLib.addUserExp(msg.sender, amount);
    }
    
    function applyVIPLevel(address payable gambler, uint amount) private {
        CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
        uint rate = vipLib.getVIPBounusRate(gambler);

        if (rate <= 0)
            return;

        uint vipPayback = amount * rate / 10000;
        if(gambler.send(vipPayback)){
            emit VIPPayback(gambler, vipPayback);
        }
    }

    function getMyAccuAmount() external view returns (uint){
        CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
        return vipLib.getUserExp(msg.sender);
    }

    function getJackpotSize() external view returns (uint){
        CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
        return vipLib.getJackpotSize();
    }

    // This is the method used to settle 99% of bets. To process a bet with a specific
    // "commit", settleBet should supply a "reveal" number that would Keccak256-hash to
    // "commit". "blockHash" is the block hash of placeBet block as seen by croupier; it
    // is additionally asserted to prevent changing the bet outcomes on Ethereum reorgs.
    function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
        uint commit = uint(keccak256(abi.encodePacked(reveal)));

        Bet storage bet = bets[commit];
        uint placeBlockNumber = bet.placeBlockNumber;

        // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
        require (block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
        require (block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
        require (blockhash(placeBlockNumber) == blockHash);

        // Settle bet using reveal and blockHash as entropy sources.
        settleBetCommon(bet, reveal, blockHash);
    }

        // Common settlement code for settleBet & settleBetUncleMerkleProof.
    function settleBetCommon(Bet storage bet, uint reveal, bytes32 entropyBlockHash) private {
        // Fetch bet parameters into local variables (to save gas).
        uint amount = bet.amount;
        // uint modulo = bet.modulo;
        //uint rollUnder = bet.rollUnder;
        // address payable gambler = bet.gambler;

        // Check that bet is in 'active' state.
        require (amount != 0, "Bet should be in an 'active' state");

        applyVIPLevel(bet.gambler, amount);

        // Move bet into 'processed' state already.
        bet.amount = 0;

        // Unlock the bet amount, regardless of the outcome.
        lockedInBets -= uint128(amount * 5);

        // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
        // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
        // preimage is intractable), and house is unable to alter the "reveal" after
        // placeBet have been mined (as Keccak256 collision finding is also intractable).
        uint entropy = uint(keccak256(abi.encodePacked(reveal, entropyBlockHash)));
        uint seed = entropy;
        // Do a roll by taking a modulo of entropy. Compute winning amount.

        RandomNumber memory randomNumber = RandomNumber(0, 0, 0, 0, 0);
        // uint mask = 2 ** 8;
        randomNumber.playerNum1 = uint8(seed % 3);
        seed = seed / 2 ** 8;
        
        randomNumber.playerNum2 = uint8(seed % 3);        
        seed = seed / 2 ** 8;

        randomNumber.npcNum1 = uint8(seed % 3);
        seed = seed / 2 ** 8;

        randomNumber.npcNum2 = uint8(seed % 3);
        seed = seed / 2 ** 8;

        randomNumber.rouletteIndex = uint8(seed % 12);
        seed = seed / 2 ** 8;

        uint jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;

        uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;

        if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
            houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
        }
        amount = amount - houseEdge - jackpotFee;

        uint8 winValue = calculateWinValue(randomNumber); // 0 -> draw, 1 -> user win, 2 -> npc win

        uint winAmount;

        if (winValue == 0) {
            // draw
            winAmount = amount;
        } else if (winValue == 1) {
            // user win
            winAmount = amount * getRouletteRate(randomNumber.rouletteIndex) / 10;
        } else {

        }

        if(bet.inviter != address(0)){
            // pay 10% of house edge to inviter
            bet.inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * 7 /100);
        }
        
        processVIPAndJackpotLogic(bet, amount, houseEdge, randomNumber, seed, jackpotFee);

        // Send the funds to gambler.
        sendFunds(bet.gambler, winAmount == 0 ? 1 wei : winAmount, winAmount, 
                    randomNumber.playerNum1, 
                    randomNumber.playerNum2, 
                    randomNumber.npcNum1, 
                    randomNumber.npcNum2, 
                    amount);
    }

    function processVIPAndJackpotLogic(Bet memory bet, uint amount, uint houseEdge, RandomNumber memory randomNumber, uint entropy, uint jackpotFee) private{
        CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
        
        if (jackpotFee > 0){
            VIPLibraryAddress.transfer(jackpotFee);
            vipLib.increaseJackpot(jackpotFee);
        }

        handleJackpotStatus(bet, amount, randomNumber, entropy, vipLib);

        // uint128 rankingRewardFee = uint128(amount * HOUSE_EDGE_PERCENT / 100 * 9 /100);
        VIPLibraryAddress.transfer(uint128(houseEdge * 7 /100));
        vipLib.increaseRankingReward(uint128(houseEdge * 7 /100));
    }

    function handleJackpotStatus(Bet memory bet, uint amount, RandomNumber memory randomNumber, uint seed, CryptoTycoonsVIPLib vipLib) private {
        uint jackpotWin = 0;
        // Roll for a jackpot (if eligible).
        if (amount >= MIN_JACKPOT_BET) {
            // The second modulo, statistically independent from the "main" dice roll.
            // Effectively you are playing two games at once!
            // uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;

            // Bingo!
            if (address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
                jackpotWin = vipLib.getJackpotSize();
                vipLib.payJackpotReward(bet.gambler);
            }
        }

        // Log jackpot win.
        if (jackpotWin > 0) {
            emit JackpotPayment(bet.gambler, 
                    jackpotWin, 
                    randomNumber.playerNum1, 
                    randomNumber.playerNum2, 
                    randomNumber.npcNum1, 
                    randomNumber.npcNum2, 
                    amount);
        }
    }

    function calculateWinValue(RandomNumber memory randomNumber) private pure returns (uint8){
        uint8 playerNum1 = randomNumber.playerNum1;
        uint8 playerNum2 = randomNumber.playerNum2;
        uint8 npcNum1 = randomNumber.npcNum1;
        uint8 npcNum2 = randomNumber.npcNum2;

        uint8 winValue = 0;
        if (playerNum1 == npcNum1){ // num 0 -> scissors, 1 -> rock, 2 -> papper
            if (playerNum2 == npcNum2){
                winValue = 0;
            } else if(playerNum2 == 0 && npcNum2 == 2){
                winValue = 1; // user win
            } else if(playerNum2 == 1 && npcNum2 == 0){
                winValue = 1; // user win
            } else if(playerNum2 == 2 && npcNum2 == 1){
                winValue = 1; // user win
            } else{
                winValue = 2; // npc win
            }
        } else if(playerNum1 == 0 && npcNum1 == 2){
            winValue = 1; // user win
        } else if(playerNum1 == 1 && npcNum1 == 0){
            winValue = 1; // user win
        } else if(playerNum1 == 2 && npcNum1 == 1){
            winValue = 1; // user win
        } else{
            winValue = 2; // npc win
        } 
        return winValue;
    }

    function getRouletteRate(uint index) private pure returns (uint8){
        uint8 rate = 11;
        if (index == 0){
            rate = 50;
        } else if(index== 1){
            rate = 11;
        } else if(index== 2){
            rate = 20;
        } else if(index== 3){
            rate = 15;
        } else if(index== 4){
            rate = 20;
        } else if(index== 5){
            rate = 11;
        } else if(index== 6){
            rate = 20;
        } else if(index== 7){
            rate = 15;
        } else if(index== 8){
            rate = 20;
        } else if(index== 9){
            rate = 11;
        } else if(index== 10){
            rate = 20;
        } else if(index== 11){
            rate = 15;
        }
        return rate;
    }

    // Refund transaction - return the bet amount of a roll that was not processed in a
    // due timeframe. Processing such blocks is not possible due to EVM limitations (see
    // BET_EXPIRATION_BLOCKS comment above for details). In case you ever find yourself
    // in a situation like this, just contact the AceDice support, however nothing
    // precludes you from invoking this method yourself.
    function refundBet(uint commit) external {
        // Check that bet is in 'active' state.
        Bet storage bet = bets[commit];
        uint amount = bet.amount;

        require (amount != 0, "Bet should be in an 'active' state");

        // Check that bet has already expired.
        require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");

        // Move bet into 'processed' state, release funds.
        bet.amount = 0;

        uint diceWinAmount = amount * 5;

        lockedInBets -= uint128(diceWinAmount);

        // Send the refund.
        sendFunds(bet.gambler, amount, amount, 0,0, 0, 0, 0);
    }

    // Get the expected win amount after house edge is subtracted.
    // function getDiceWinAmount(uint amount, uint rollUnder) private pure returns (uint jackpotFee) {
    //     require (0 < rollUnder && rollUnder <= 100, "Win probability out of range.");

    //     jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;

    //     uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;

    //     if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
    //     houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
    //     }

    //     // require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
    //     // winAmount = (amount - houseEdge - jackpotFee) * 100 / rollUnder;
    // }

    // Helper routine to process the payment.
    function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint playerNum1, uint playerNum2, uint npcNum1, uint npcNum2, uint betAmount) private {
        if (beneficiary.send(amount)) {
            emit Payment(beneficiary, successLogAmount, playerNum1, playerNum2, npcNum1, npcNum2, betAmount);
        } else {
            emit FailedPayment(beneficiary, amount);
        }
    }

    function thisBalance() public view returns(uint) {
        return address(this).balance;
    }

    function payTodayReward(address payable to) external onlyOwner {
        CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
        vipLib.payRankingReward(to);
    }

    function getRankingRewardSize() external view returns (uint128) {
        CryptoTycoonsVIPLib vipLib = CryptoTycoonsVIPLib(VIPLibraryAddress);
        return vipLib.getRankingRewardSize();
    }
}