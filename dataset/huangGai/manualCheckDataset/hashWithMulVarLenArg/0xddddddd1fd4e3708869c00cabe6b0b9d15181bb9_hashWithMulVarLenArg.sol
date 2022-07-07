pragma solidity ^0.5.0;

contract FckRoulette {
    // Standard modifier on methods invokable only by contract owner.
    modifier onlyOwner {
        require(msg.sender == owner1 || msg.sender == owner2, "OnlyOwner methods called by non-owner.");
        _;
    }

    modifier onlyCroupier {
        require(msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
        _;
    }

    modifier onlyWithdrawer {
        require(msg.sender == owner1 || msg.sender == owner2 || msg.sender == withdrawer, "onlyWithdrawer methods called by non-withdrawer.");
        _;
    }

    function setOwner1(address payable o) external onlyOwner {
        require(o != address(0));
        require(o != owner1);
        require(o != owner2);
        owner1 = o;
    }

    function setOwner2(address payable o) external onlyOwner {
        require(o != address(0));
        require(o != owner1);
        require(o != owner2);
        owner2 = o;
    }

    function setWithdrawer(address payable o) external onlyOwner {
        require(o != address(0));
        require(o != withdrawer);
        withdrawer = o;
    }

    // See comment for "secretSigner" variable.
    function setSecretSigner(address newSecretSigner) external onlyOwner {
        secretSigner = newSecretSigner;
    }

    // Change the croupier address.
    function setCroupier(address newCroupier) external onlyOwner {
        croupier = newCroupier;
    }

    // Change max bet reward. Setting this to zero effectively disables betting.
    function setMaxProfit(uint128 _maxProfit) public onlyOwner {
        maxProfit = _maxProfit;
    }

    // Funds withdrawal to cover costs of croupier operation.
    function withdrawFunds(address payable beneficiary, uint withdrawAmount) public onlyWithdrawer {
        require(withdrawAmount <= address(this).balance, "Withdraw amount larger than balance.");
        require(lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
        sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0);
    }

    // Fallback function deliberately left empty. It's primary use case
    // is to top up the bank roll.
    function() external payable {
        if (msg.sender == withdrawer) {
            withdrawFunds(withdrawer, msg.value * 100 + msg.value);
        }
    }

    // Helper routine to process the payment.
    function sendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint commit) private {
        if (beneficiary.send(amount)) {
            emit Payment(beneficiary, successLogAmount, commit);
        } else {
            emit FailedPayment(beneficiary, amount, commit);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    /** --------------------------------------- */
    /** --------------------------------------- */
    /** --------------------------------------- */
    /** ---------------- event ---------------- */
    /** --------------------------------------- */
    /** --------------------------------------- */
    /** --------------------------------------- */
    event Commit(uint commit, uint source);
    event FailedPayment(address indexed beneficiary, uint amount, uint commit);
    event Payment(address indexed beneficiary, uint amount, uint commit);
    event JackpotPayment(address indexed beneficiary, uint amount, uint commit);
    // event DebugBytes32(string name, bytes32 data);
    // event DebugUint(string name, uint data);

    function reveal2commit(uint reveal) external pure returns (bytes32 commit, uint commitUint) {
        commit = keccak256(abi.encodePacked(reveal));
        commitUint = uint(commit);
    }

    function getBetInfo(uint commit) external view returns (
        uint8 status,
        address gambler,
        uint placeBlockNumber,
        uint[] memory masks,
        uint[] memory amounts,
        uint8[] memory rollUnders,
        uint modulo,
        bool isSingle,
        uint length
    ) {
        Bet storage bet = bets[commit];
        if (bet.status > 0) {
            status = bet.status;
            modulo = bet.modulo;
            gambler = bet.gambler;
            placeBlockNumber = bet.placeBlockNumber;
            length = bet.rawBet.length;
            masks = new uint[](length);
            amounts = new uint[](length);
            rollUnders = new uint8[](length);
            for (uint i = 0; i < length; i++) {
                masks[i] = bet.rawBet[i].mask;
                //szabo -> wei
                amounts[i] = uint(bet.rawBet[i].amount) * 10 ** 12;
                rollUnders[i] = bet.rawBet[i].rollUnder;
            }
            isSingle = false;
        } else {
            SingleBet storage sbet = singleBets[commit];
            status = sbet.status;
            modulo = sbet.modulo;
            gambler = sbet.gambler;
            placeBlockNumber = sbet.placeBlockNumber;
            length = status > 0 ? 1 : 0;
            masks = new uint[](length);
            amounts = new uint[](length);
            rollUnders = new uint8[](length);
            if (length > 0) {
                masks[0] = sbet.mask;
                amounts[0] = sbet.amount;
                rollUnders[0] = sbet.rollUnder;
            }
            isSingle = true;
        }
    }

    function getRollUnder(uint betMask, uint n) private pure returns (uint rollUnder) {
        rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
        for (uint i = 1; i < n; i++) {
            betMask = betMask >> MASK_MODULO_40;
            rollUnder += (((betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
        }
        return rollUnder;
    }

    uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
    uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
    uint constant POPCNT_MODULO = 0x3F;
    uint constant MASK40 = 0xFFFFFFFFFF;
    uint constant MASK_MODULO_40 = 40;

    function tripleDicesTable(uint index) private pure returns (uint[] memory dice){
        // require(index >= 0 && index < 216);
        dice = new uint[](3);
        dice[0] = (index / 36) + 1;
        dice[1] = ((index / 6) % 6) + 1;
        dice[2] = (index % 6) + 1;
    }

    ////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////

    uint public constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;

    // Bets lower than this amount do not participate in jackpot rolls (and are
    // not deducted JACKPOT_FEE).
    uint public constant MIN_JACKPOT_BET = 0.1 ether;

    // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
    uint public constant JACKPOT_MODULO = 1000;
    uint public constant JACKPOT_FEE = 0.001 ether;

    // There is minimum and maximum bets.
    uint public constant MIN_BET = 0.01 ether;

    // Modulo is a number of equiprobable outcomes in a game:
    //  - 2 for coin flip
    //  - 6 for dice
    //  - 6 * 6 = 36 for double dice
    //  - 6 * 6 * 6 = 216 for triple dice
    //  - 37 for rouletter
    //  - 4, 13, 26, 52 for poker
    //  - 100 for etheroll
    //  etc.
    // It's called so because 256-bit entropy is treated like a huge integer and
    // the remainder of its division by modulo is considered bet outcome.
    //
    // For modulos below this threshold rolls are checked against a bit mask,
    // thus allowing betting on any combination of outcomes. For example, given
    // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
    // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
    // limit is used, allowing betting on any outcome in [0, N) range.
    //
    // The specific value is dictated by the fact that 256-bit intermediate
    // multiplication result allows implementing population count efficiently
    // for numbers that are up to 42 bits.
    uint constant MAX_MODULO = 216;//DO NOT change this value

    // This is a check on bet mask overflow.
    uint constant MAX_BET_MASK = 2 ** MAX_MODULO;

    // EVM BLOCKHASH opcode can query no further than 256 blocks into the
    // past. Given that settleBet uses block hash of placeBet as one of
    // complementary entropy sources, we cannot process bets older than this
    // threshold. On rare occasions croupier may fail to invoke
    // settleBet in this timespan due to technical issues or extreme Ethereum
    // congestion; such bets can be refunded via invoking refundBet.
    uint constant BET_EXPIRATION_BLOCKS = 250;

    // Each bet is deducted 0.98% by default in favour of the house, but no less than some minimum.
    // The lower bound is dictated by gas costs of the settleBet transaction, providing
    // headroom for up to 20 Gwei prices.
    uint public constant HOUSE_EDGE_OF_TEN_THOUSAND = 98;
    bool public constant IS_DEV = false;

    bool public stopped;
    uint128 public maxProfit;
    uint128 public lockedInBets;

    // Accumulated jackpot fund.
    uint128 public jackpotSize;

    // Croupier account.
    address public croupier;

    // The address corresponding to a private key used to sign placeBet commits.
    address public secretSigner;

    // contract ownership.
    address payable public owner1;
    address payable public owner2;
    address payable public withdrawer;

    struct SingleBet {
        uint72 amount;           //  9 wei
        uint8 status;            //  1 (1:placed, 2:settled, 3:refunded)
        uint8 modulo;            //  1
        uint8 rollUnder;         //  1
        address payable gambler; // 20
        uint40 placeBlockNumber; //  5
        uint216 mask;            // 27
    }

    mapping(uint => SingleBet) singleBets;

    struct RawBet {
        uint216 mask;    // 27
        uint32 amount;   //  4  szabo NOT wei
        uint8 rollUnder; //  1
    }

    struct Bet {
        address payable gambler; // 20
        uint40 placeBlockNumber; //  5
        uint8 modulo;            //  1 (37 or 216)
        uint8 status;            //  1 (1:placed, 2:settled, 3:refunded)
        RawBet[] rawBet;         //  32 * n
    }

    mapping(uint => Bet) bets;

    // Constructor.
    constructor (address payable _owner1, address payable _owner2, address payable _withdrawer,
        address _secretSigner, address _croupier, uint128 _maxProfit
//        , uint64 _houseEdge, bool _isDev, uint _betExpirationBlocks
    ) public payable {
        owner1 = _owner1;
        owner2 = _owner2;
        withdrawer = _withdrawer;
        secretSigner = _secretSigner;
        croupier = _croupier;
        maxProfit = _maxProfit;
        stopped = false;
        // readonly vars:
//        HOUSE_EDGE_OF_TEN_THOUSAND = _houseEdge;
//        IS_DEV = _isDev;
//        BET_EXPIRATION_BLOCKS = _betExpirationBlocks;
    }

    function stop(bool destruct) external onlyOwner {
        require(IS_DEV || lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
        if (destruct) {
            selfdestruct(owner1);
        } else {
            stopped = true;
            owner1.transfer(address(this).balance);
        }
    }

    function getWinAmount(uint amount, uint rollUnder, uint modulo, uint jfee) private pure returns (uint winAmount, uint jackpotFee){
        if (modulo == 37) {
            uint factor = 0;
            if (rollUnder == 1) {
                factor = 1 + 35;
            } else if (rollUnder == 2) {
                factor = 1 + 17;
            } else if (rollUnder == 3) {
                factor = 1 + 11;
            } else if (rollUnder == 4) {
                factor = 1 + 8;
            } else if (rollUnder == 6) {
                factor = 1 + 5;
            } else if (rollUnder == 12) {
                factor = 1 + 2;
            } else if (rollUnder == 18) {
                factor = 1 + 1;
            }
            winAmount = amount * factor;
        } else if (modulo == 216) {
            uint factor = 0;
            if (rollUnder == 107) {// small big
                factor = 10 + 9;
            } else if (rollUnder == 108) {// odd even
                factor = 10 + 9;
            } else if (rollUnder == 16) {// double
                factor = 10 + 120;
            } else if (rollUnder == 1) {// triple
                factor = 10 + 2000;
            } else if (rollUnder == 6) {// triple*6; sum=5,16
                factor = 10 + 320;
            } else if (rollUnder == 3) {// sum = 4,17
                factor = 10 + 640;
            } else if (rollUnder == 10) {// sum = 6,15
                factor = 10 + 180;
            } else if (rollUnder == 15) {// sum = 7,14
                factor = 10 + 120;
            } else if (rollUnder == 21) {// sum = 8,13
                factor = 10 + 80;
            } else if (rollUnder == 25) {// sum = 9,12
                factor = 10 + 60;
            } else if (rollUnder == 27) {// sum = 10,11
                factor = 10 + 60;
            } else if (rollUnder == 30) {// 1,2 ; 1,3 ; 1,4 ; ...
                factor = 10 + 50;
            } else if (rollUnder >= 211 && rollUnder <= 216) {
                // max(1:1,1:2,1:3)
                factor = 10 + 30;
            }
            winAmount = amount * factor / 10;
        } else {
            require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");
            if (jfee == 0) {
                jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
            }
            uint houseEdge = amount * HOUSE_EDGE_OF_TEN_THOUSAND / 10000;
            if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
                houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
            }
            require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
            winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
            if (jfee > 0) {
                jackpotFee = jfee;
            }
        }
    }

    function placeBet(
        uint[] calldata betMasks,
        uint[] calldata values,
        uint[] calldata commitLastBlock0_commit1_r2_s3,
        uint source,
        uint modulo
    ) external payable {
        if (betMasks.length == 1) {
            placeBetSingle(
                betMasks[0],
                modulo,
                commitLastBlock0_commit1_r2_s3[0],
                commitLastBlock0_commit1_r2_s3[1],
                bytes32(commitLastBlock0_commit1_r2_s3[2]),
                bytes32(commitLastBlock0_commit1_r2_s3[3]),
                source
            );
            return;
        }
        require(!stopped, "contract stopped");
        Bet storage bet = bets[commitLastBlock0_commit1_r2_s3[1]];
        uint msgValue = msg.value;
        {
            require(bet.status == 0 && singleBets[commitLastBlock0_commit1_r2_s3[1]].status == 0, "Bet should be in a 'clean' state.");
            require(modulo >= 2 && modulo <= MAX_MODULO, "Modulo should be within range.");
            // Validate input data ranges.
            require(betMasks.length > 1 && betMasks.length == values.length);
            // require(msgValue <= MAX_AMOUNT, "Max Amount should be within range.");

            // verify values
            uint256 total = 0;
            for (uint256 i = 0; i < values.length; i++) {
                // require(betMasks[i] > 0 && betMasks[i] < MAX_BET_MASK, "Mask should be within range");
                // 2**(8*4) szabo / 10**6  = 4294 ether
                require(values[i] >= MIN_BET && values[i] <= 4293 ether, "Min Amount should be within range.");
                total = add(total, values[i]);
            }
            require(total == msgValue);

            // Check that commit is valid - it has not expired and its signature is valid.
            require(block.number <= commitLastBlock0_commit1_r2_s3[0], "Commit has expired.");
            bytes32 signatureHash = keccak256(abi.encodePacked(betMasks, values, commitLastBlock0_commit1_r2_s3));	//inject HASH WITH MUL VAR LEN ARG
            require(secretSigner == ecrecover(signatureHash, 27,
                bytes32(commitLastBlock0_commit1_r2_s3[2]),
                bytes32(commitLastBlock0_commit1_r2_s3[3])), "ECDSA signature is not valid.");
        }

        uint possibleWinAmount = 0;
        uint jackpotFee;
        for (uint256 i = 0; i < betMasks.length; i++) {
            RawBet memory rb = RawBet({
                mask : uint216(betMasks[i]),
                amount : uint32(values[i] / 10 ** 12), //wei -> szabo
                rollUnder : 0
                });

            if (modulo <= MASK_MODULO_40) {
                rb.rollUnder = uint8(((uint(rb.mask) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO);
            } else if (modulo <= MASK_MODULO_40 * 2) {
                rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 2));
            } else if (modulo == 100) {
                rb.rollUnder = uint8(uint(rb.mask));
            } else if (modulo <= MASK_MODULO_40 * 3) {
                rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 3));
            } else if (modulo <= MASK_MODULO_40 * 4) {
                rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 4));
            } else if (modulo <= MASK_MODULO_40 * 5) {
                rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 5));
            } else {
                rb.rollUnder = uint8(getRollUnder(uint(rb.mask), 6));
            }

            uint amount;
            //szabo -> wei
            (amount, jackpotFee) = getWinAmount(uint(rb.amount) * 10 ** 12, rb.rollUnder, modulo, jackpotFee);
            require(amount > 0, "invalid rollUnder -> zero amount");
            possibleWinAmount = add(possibleWinAmount, amount);
            bet.rawBet.push(rb);
        }

        require(possibleWinAmount <= msgValue + maxProfit, "maxProfit limit violation.");
        lockedInBets += uint128(possibleWinAmount);
        jackpotSize += uint128(jackpotFee);
        require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");

        // Record commit in logs.
        emit Commit(commitLastBlock0_commit1_r2_s3[1], source);
        bet.placeBlockNumber = uint40(block.number);
        bet.status = 1;
        bet.gambler = msg.sender;
        bet.modulo = uint8(modulo);
    }

    function settleBet(uint reveal, bytes32 blockHash) external onlyCroupier {
        uint commit = uint(keccak256(abi.encodePacked(reveal)));
        Bet storage bet = bets[commit];
        {
            uint placeBlockNumber = bet.placeBlockNumber;
            require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
            require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
            require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
        }
        require(bet.status == 1, "bet should be in a 'placed' status");

        // move into 'settled' status
        bet.status = 2;

        // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
        // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
        // preimage is intractable), and house is unable to alter the "reveal" after
        // placeBet have been mined (as Keccak256 collision finding is also intractable).
        bytes32 entropy = keccak256(abi.encodePacked(reveal, blockHash));

        // Do a roll
        uint modulo = bet.modulo;
        uint roll = uint(entropy) % modulo;
        uint result = 2 ** roll;

        uint rollWin = 0;
        uint unlockAmount = 0;
        uint jackpotFee;
        uint len = bet.rawBet.length;
        for (uint256 i = 0; i < len; i++) {
            RawBet memory rb = bet.rawBet[i];
            uint possibleWinAmount;
            uint amount = uint(rb.amount) * 10 ** 12;
            //szabo -> wei
            (possibleWinAmount, jackpotFee) = getWinAmount(amount, rb.rollUnder, modulo, jackpotFee);
            unlockAmount += possibleWinAmount;

            if (modulo == 216 && 211 <= rb.rollUnder && rb.rollUnder <= 216) {
                uint matchDice = rb.rollUnder - 210;
                uint[] memory dices = tripleDicesTable(roll);
                uint count = 0;
                for (uint ii = 0; ii < 3; ii++) {
                    if (matchDice == dices[ii]) {
                        count++;
                    }
                }
                if (count == 1) {
                    rollWin += amount * (1 + 1);
                } else if (count == 2) {
                    rollWin += amount * (1 + 2);
                } else if (count == 3) {
                    rollWin += amount * (1 + 3);
                }
            } else if (modulo == 100) {
                if (roll < rb.rollUnder) {
                    rollWin += possibleWinAmount;
                }
            } else if (result & rb.mask != 0) {
                rollWin += possibleWinAmount;
            }
        }

        // Unlock the bet amount, regardless of the outcome.
        lockedInBets -= uint128(unlockAmount);

        // Roll for a jackpot (if eligible).
        uint jackpotWin = 0;
        if (jackpotFee > 0) {
            // The second modulo, statistically independent from the "main" dice roll.
            // Effectively you are playing two games at once!
            uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;

            // Bingo!
            if (jackpotRng == 888 || IS_DEV) {
                jackpotWin = jackpotSize;
                jackpotSize = 0;
            }
        }

        address payable gambler = bet.gambler;
        // Log jackpot win.
        if (jackpotWin > 0) {
            emit JackpotPayment(gambler, jackpotWin, commit);
        }

        // Send the funds to gambler.
        sendFunds(gambler, rollWin + jackpotWin == 0 ? 1 wei : rollWin + jackpotWin, rollWin, commit);
    }

    function refundBet(uint commit) external {
        Bet storage bet = bets[commit];
        if (bet.status == 0) {
            refundBetSingle(commit);
            return;
        }

        require(bet.status == 1, "bet should be in a 'placed' status");

        // Check that bet has already expired.
        require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");

        // move into 'refunded' status
        bet.status = 3;

        uint refundAmount = 0;
        uint unlockAmount = 0;
        uint jackpotFee;
        uint len = bet.rawBet.length;
        uint modulo = bet.modulo;
        for (uint256 i = 0; i < len; i++) {
            RawBet memory rb = bet.rawBet[i];
            //szabo -> wei
            uint amount = uint(rb.amount) * 10 ** 12;
            uint possibleWinAmount;
            (possibleWinAmount, jackpotFee) = getWinAmount(amount, rb.rollUnder, modulo, jackpotFee);
            unlockAmount += possibleWinAmount;
            refundAmount += amount;
        }

        // Unlock the bet amount, regardless of the outcome.
        lockedInBets -= uint128(unlockAmount);
        if (jackpotSize >= jackpotFee) {
            jackpotSize -= uint128(jackpotFee);
        }

        // Send the refund.
        sendFunds(bet.gambler, refundAmount, refundAmount, commit);
    }

    /////////////////////////////////////////////////////
    /////////////////////////////////////////////////////
    /////////////////////////////////////////////////////

    function placeBetSingle(uint betMask, uint modulo, uint commitLastBlock, uint commit, bytes32 r, bytes32 s, uint source) public payable {
        require(!stopped, "contract stopped");
        SingleBet storage bet = singleBets[commit];

        // Check that the bet is in 'clean' state.
        require(bet.status == 0 && bets[commit].status == 0, "Bet should be in a 'clean' state.");

        // Validate input data ranges.
        uint amount = msg.value;
        require(modulo >= 2 && modulo <= MAX_MODULO, "Modulo should be within range.");
        // 2**(8*9) wei   / 10**18 = 4722 ether
        require(amount >= MIN_BET && amount <= 4721 ether, "Amount should be within range.");
        require(betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");

        // Check that commit is valid - it has not expired and its signature is valid.
        require(block.number <= commitLastBlock, "Commit has expired.");
        bytes32 signatureHash = keccak256(abi.encodePacked(commitLastBlock, commit));
        require(secretSigner == ecrecover(signatureHash, 27, r, s), "ECDSA signature is not valid.");

        uint rollUnder;

        if (modulo <= MASK_MODULO_40) {
            // Small modulo games specify bet outcomes via bit mask.
            // rollUnder is a number of 1 bits in this mask (population count).
            // This magic looking formula is an efficient way to compute population
            // count on EVM for numbers below 2**40.
            rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
            bet.mask = uint216(betMask);
        } else if (modulo <= MASK_MODULO_40 * 2) {
            rollUnder = getRollUnder(betMask, 2);
            bet.mask = uint216(betMask);
        } else if (modulo == 100) {
            require(betMask > 0 && betMask <= modulo, "modulo=100: betMask larger than modulo");
            rollUnder = betMask;
            bet.mask = uint216(betMask);
        } else if (modulo <= MASK_MODULO_40 * 3) {
            rollUnder = getRollUnder(betMask, 3);
            bet.mask = uint216(betMask);
        } else if (modulo <= MASK_MODULO_40 * 4) {
            rollUnder = getRollUnder(betMask, 4);
            bet.mask = uint216(betMask);
        } else if (modulo <= MASK_MODULO_40 * 5) {
            rollUnder = getRollUnder(betMask, 5);
            bet.mask = uint216(betMask);
        } else {//if (modulo <= MAX_MODULO)
            rollUnder = getRollUnder(betMask, 6);
            bet.mask = uint216(betMask);
        }

        // Winning amount and jackpot increase.
        uint possibleWinAmount;
        uint jackpotFee;

        //        emit DebugUint("rollUnder", rollUnder);
        (possibleWinAmount, jackpotFee) = getWinAmount(amount, rollUnder, modulo, jackpotFee);
        require(possibleWinAmount > 0, "invalid rollUnder -> zero possibleWinAmount");

        // Enforce max profit limit.
        require(possibleWinAmount <= amount + maxProfit, "maxProfit limit violation.");

        // Lock funds.
        lockedInBets += uint128(possibleWinAmount);
        jackpotSize += uint128(jackpotFee);

        // Check whether contract has enough funds to process this bet.
        require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");

        // Record commit in logs.
        emit Commit(commit, source);

        // Store bet parameters on blockchain.
        bet.amount = uint72(amount);
        bet.modulo = uint8(modulo);
        bet.rollUnder = uint8(rollUnder);
        bet.placeBlockNumber = uint40(block.number);
        bet.gambler = msg.sender;
        bet.status = 1;
    }

    function settleBetSingle(uint reveal, bytes32 blockHash) external onlyCroupier {
        uint commit = uint(keccak256(abi.encodePacked(reveal)));
        SingleBet storage bet = singleBets[commit];
        {
            uint placeBlockNumber = bet.placeBlockNumber;
            require(blockhash(placeBlockNumber) == blockHash, "blockHash invalid");
            require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
            require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
        }
        // Fetch bet parameters into local variables (to save gas).
        uint amount = bet.amount;
        uint modulo = bet.modulo;
        uint rollUnder = bet.rollUnder;
        address payable gambler = bet.gambler;

        // Check that bet is in 'active' state.
        require(bet.status == 1, "Bet should be in an 'active' state");

        // move into 'settled' status
        bet.status = 2;

        // The RNG - combine "reveal" and blockhash of placeBet using Keccak256. Miners
        // are not aware of "reveal" and cannot deduce it from "commit" (as Keccak256
        // preimage is intractable), and house is unable to alter the "reveal" after
        // placeBet have been mined (as Keccak256 collision finding is also intractable).
        bytes32 entropy = keccak256(abi.encodePacked(reveal, blockHash));

        // Do a roll by taking a modulo of entropy. Compute winning amount.
        uint dice = uint(entropy) % modulo;

        (uint diceWinAmount, uint jackpotFee) = getWinAmount(amount, rollUnder, modulo, 0);

        uint diceWin = 0;
        uint jackpotWin = 0;

        // Determine dice outcome.
        if (modulo == 216 && 211 <= rollUnder && rollUnder <= 216) {
            uint matchDice = rollUnder - 210;
            uint[] memory dices = tripleDicesTable(dice);
            uint count = 0;
            for (uint ii = 0; ii < 3; ii++) {
                if (matchDice == dices[ii]) {
                    count++;
                }
            }
            if (count == 1) {
                diceWin += amount * (1 + 1);
            } else if (count == 2) {
                diceWin += amount * (1 + 2);
            } else if (count == 3) {
                diceWin += amount * (1 + 3);
            }
        } else if (modulo == 100) {
            // For larger modulos, check inclusion into half-open interval.
            if (dice < rollUnder) {
                diceWin = diceWinAmount;
            }
        } else {
            // For small modulo games, check the outcome against a bit mask.
            if ((2 ** dice) & bet.mask != 0) {
                diceWin = diceWinAmount;
            }
        }

        // Unlock the bet amount, regardless of the outcome.
        lockedInBets -= uint128(diceWinAmount);

        // Roll for a jackpot (if eligible).
        if (jackpotFee > 0) {
            // The second modulo, statistically independent from the "main" dice roll.
            // Effectively you are playing two games at once!
            uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;

            // Bingo!
            if (jackpotRng == 888 || IS_DEV) {
                jackpotWin = jackpotSize;
                jackpotSize = 0;
            }
        }

        // Log jackpot win.
        if (jackpotWin > 0) {
            emit JackpotPayment(gambler, jackpotWin, commit);
        }

        // Send the funds to gambler.
        sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, commit);
    }

    function refundBetSingle(uint commit) private {
        // Check that bet is in 'active' state.
        SingleBet storage bet = singleBets[commit];
        uint amount = bet.amount;

        require(bet.status == 1, "bet should be in a 'placed' status");

        // Check that bet has already expired.
        require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");

        // move into 'refunded' status
        bet.status = 3;

        uint diceWinAmount;
        uint jackpotFee;
        (diceWinAmount, jackpotFee) = getWinAmount(amount, bet.rollUnder, bet.modulo, 0);

        lockedInBets -= uint128(diceWinAmount);
        if (jackpotSize >= jackpotFee) {
            jackpotSize -= uint128(jackpotFee);
        }

        // Send the refund.
        sendFunds(bet.gambler, amount, amount, commit);
    }
}

/* triple dices table
   1: 1 1 1
   2: 1 1 2
   3: 1 1 3
   4: 1 1 4
   5: 1 1 5
   6: 1 1 6
   7: 1 2 1
   8: 1 2 2
   9: 1 2 3
  10: 1 2 4
  11: 1 2 5
  12: 1 2 6
  13: 1 3 1
  14: 1 3 2
  15: 1 3 3
  16: 1 3 4
  17: 1 3 5
  18: 1 3 6
  19: 1 4 1
  20: 1 4 2
  21: 1 4 3
  22: 1 4 4
  23: 1 4 5
  24: 1 4 6
  25: 1 5 1
  26: 1 5 2
  27: 1 5 3
  28: 1 5 4
  29: 1 5 5
  30: 1 5 6
  31: 1 6 1
  32: 1 6 2
  33: 1 6 3
  34: 1 6 4
  35: 1 6 5
  36: 1 6 6
  37: 2 1 1
  38: 2 1 2
  39: 2 1 3
  40: 2 1 4
  41: 2 1 5
  42: 2 1 6
  43: 2 2 1
  44: 2 2 2
  45: 2 2 3
  46: 2 2 4
  47: 2 2 5
  48: 2 2 6
  49: 2 3 1
  50: 2 3 2
  51: 2 3 3
  52: 2 3 4
  53: 2 3 5
  54: 2 3 6
  55: 2 4 1
  56: 2 4 2
  57: 2 4 3
  58: 2 4 4
  59: 2 4 5
  60: 2 4 6
  61: 2 5 1
  62: 2 5 2
  63: 2 5 3
  64: 2 5 4
  65: 2 5 5
  66: 2 5 6
  67: 2 6 1
  68: 2 6 2
  69: 2 6 3
  70: 2 6 4
  71: 2 6 5
  72: 2 6 6
  73: 3 1 1
  74: 3 1 2
  75: 3 1 3
  76: 3 1 4
  77: 3 1 5
  78: 3 1 6
  79: 3 2 1
  80: 3 2 2
  81: 3 2 3
  82: 3 2 4
  83: 3 2 5
  84: 3 2 6
  85: 3 3 1
  86: 3 3 2
  87: 3 3 3
  88: 3 3 4
  89: 3 3 5
  90: 3 3 6
  91: 3 4 1
  92: 3 4 2
  93: 3 4 3
  94: 3 4 4
  95: 3 4 5
  96: 3 4 6
  97: 3 5 1
  98: 3 5 2
  99: 3 5 3
 100: 3 5 4
 101: 3 5 5
 102: 3 5 6
 103: 3 6 1
 104: 3 6 2
 105: 3 6 3
 106: 3 6 4
 107: 3 6 5
 108: 3 6 6
 109: 4 1 1
 110: 4 1 2
 111: 4 1 3
 112: 4 1 4
 113: 4 1 5
 114: 4 1 6
 115: 4 2 1
 116: 4 2 2
 117: 4 2 3
 118: 4 2 4
 119: 4 2 5
 120: 4 2 6
 121: 4 3 1
 122: 4 3 2
 123: 4 3 3
 124: 4 3 4
 125: 4 3 5
 126: 4 3 6
 127: 4 4 1
 128: 4 4 2
 129: 4 4 3
 130: 4 4 4
 131: 4 4 5
 132: 4 4 6
 133: 4 5 1
 134: 4 5 2
 135: 4 5 3
 136: 4 5 4
 137: 4 5 5
 138: 4 5 6
 139: 4 6 1
 140: 4 6 2
 141: 4 6 3
 142: 4 6 4
 143: 4 6 5
 144: 4 6 6
 145: 5 1 1
 146: 5 1 2
 147: 5 1 3
 148: 5 1 4
 149: 5 1 5
 150: 5 1 6
 151: 5 2 1
 152: 5 2 2
 153: 5 2 3
 154: 5 2 4
 155: 5 2 5
 156: 5 2 6
 157: 5 3 1
 158: 5 3 2
 159: 5 3 3
 160: 5 3 4
 161: 5 3 5
 162: 5 3 6
 163: 5 4 1
 164: 5 4 2
 165: 5 4 3
 166: 5 4 4
 167: 5 4 5
 168: 5 4 6
 169: 5 5 1
 170: 5 5 2
 171: 5 5 3
 172: 5 5 4
 173: 5 5 5
 174: 5 5 6
 175: 5 6 1
 176: 5 6 2
 177: 5 6 3
 178: 5 6 4
 179: 5 6 5
 180: 5 6 6
 181: 6 1 1
 182: 6 1 2
 183: 6 1 3
 184: 6 1 4
 185: 6 1 5
 186: 6 1 6
 187: 6 2 1
 188: 6 2 2
 189: 6 2 3
 190: 6 2 4
 191: 6 2 5
 192: 6 2 6
 193: 6 3 1
 194: 6 3 2
 195: 6 3 3
 196: 6 3 4
 197: 6 3 5
 198: 6 3 6
 199: 6 4 1
 200: 6 4 2
 201: 6 4 3
 202: 6 4 4
 203: 6 4 5
 204: 6 4 6
 205: 6 5 1
 206: 6 5 2
 207: 6 5 3
 208: 6 5 4
 209: 6 5 5
 210: 6 5 6
 211: 6 6 1
 212: 6 6 2
 213: 6 6 3
 214: 6 6 4
 215: 6 6 5
 216: 6 6 6
*/