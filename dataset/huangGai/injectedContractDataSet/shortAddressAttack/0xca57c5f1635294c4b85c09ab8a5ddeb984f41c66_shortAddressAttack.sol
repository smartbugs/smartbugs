pragma solidity >= 0.5.0;

contract WinyDice {
    address payable private OWNER;

    // Each bet is deducted 0.98% in favour of the house, but no less than some minimum.
    // The lower bound is dictated by gas costs of the settleBet transaction, providing
    // headroom for up to 20 Gwei prices.
    uint public constant HOUSE_EDGE_OF_TEN_THOUSAND = 98;
    uint public constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;

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
    uint constant MAX_MODULO = 216;

    // For modulos below this threshold rolls are checked against a bit mask,
    // thus allowing betting on any combination of outcomes. For example, given
    // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
    // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
    // limit is used, allowing betting on any outcome in [0, N) range.
    //
    // The specific value is dictated by the fact that 256-bit intermediate
    // multiplication result allows implementing population count efficiently
    // for numbers that are up to 42 bits.
    uint constant MAX_MASK_MODULO = 216;

    // This is a check on bet mask overflow.
    uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;

    // Adjustable max bet profit. Used to cap bets against dynamic odds.
    uint public MAX_PROFIT;
    uint public MAX_PROFIT_PERCENT = 10;
    bool public KILLED;

    // Funds that are locked in potentially winning bets. Prevents contract from
    // committing to bets it cannot pay out.
    uint128 public LOCKED_IN_BETS;

    uint256 public JACKPOT_BALANCE = 0;

    bool public PAYOUT_PAUSED; 
    bool public GAME_PAUSED;

    //Minimum amount that can have a chance to win jackpot
    uint256 public constant MIN_JACKPOT_BET = 0.1 ether;
    uint256 public JACKPOT_CHANCE = 1000;   //0.1%
    uint256 public constant JACKPOT_FEE = 0.001 ether;

    uint constant MIN_BET = 0.01 ether;
    uint constant MAX_BET = 300000 ether;

     // This are some constants making O(1) population count in placeBet possible.
    // See whitepaper for intuition and proofs behind it.
    uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
    uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
    uint constant POPCNT_MODULO = 0x3F;
    uint constant MASK40 = 0xFFFFFFFFFF;
    uint constant MASK_MODULO_40 = 40;

    // A structure representing a single bet.
    struct Bet {
        // Wager amount in wei.
        uint80 Amount;//10
        // Modulo of a game.
        uint8 Modulo;//1
        // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
        // and used instead of mask for games with modulo > MAX_MASK_MODULO.
        uint8 RollUnder;//1
        // Address of a player, used to pay out winning bets.
        address payable Player;//20
        // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
        uint216 Mask;//27
        uint40 PlaceBlockNumber;
    }

    // Mapping from commits to all currently active & processed bets.
    mapping(uint => Bet) bets;
    // Croupier account.
    address private CROUPIER;

    // Events that are issued to make statistic recovery easier.
    event FailedPayment(address indexed playerAddress,uint indexed betId, uint amount,uint dice);
    event Payment(address indexed playerAddress,uint indexed betId, uint amount,uint dice);
    event JackpotPayment(address indexed playerAddress,uint indexed betId, uint amount);    
    // This event is emitted in placeBet to record commit in the logs.
    event BetPlaced(uint indexed betId, uint source);
    event LogTransferEther(address indexed SentToAddress, uint256 AmountTransferred);

    constructor (address payable _owner,address _croupier) public payable {
        OWNER = _owner;                
        CROUPIER = _croupier;
        KILLED = false;
    }

    modifier onlyOwner() {
        require(msg.sender == OWNER,"only owner can call this function.");
        _;
    }

    // Standard modifier on methods invokable only by Croupier.
    modifier onlyCroupier {
        require(msg.sender == CROUPIER, "OnlyCroupier methods called by non-croupier.");
        _;
    }

    modifier payoutsAreActive {
        if(PAYOUT_PAUSED == true) revert("payouts are currently paused.");
        _;
    } 

    modifier gameIsActive {
        if(GAME_PAUSED == true) revert("game is not active right now.");
        _;
    } 


    function GetChoiceCountForLargeModulo(uint inputMask, uint n) private pure returns (uint choiceCount) {
        choiceCount += (((inputMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
        for (uint i = 1; i < n; i++) {
            inputMask = inputMask >> MASK_MODULO_40;
            choiceCount += (((inputMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
        }
        return choiceCount;
    }

    function GetChoiceCount(uint inputMask ,uint modulo) private pure returns (uint choiceCount,uint mask) {

        if (modulo <= MASK_MODULO_40) {
            // Small modulo games specify bet outcomes via bit mask.
            // rollUnder is a number of 1 bits in this mask (population count).
            // This magic looking formula is an efficient way to compute population
            // count on EVM for numbers below 2**40.
            choiceCount = ((inputMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
            mask = inputMask;
        } else if (modulo <= MASK_MODULO_40 * 2) {
            choiceCount = GetChoiceCountForLargeModulo(inputMask, 2);
            mask = inputMask;
        } else if (modulo == 100) {
            require(inputMask > 0 && inputMask <= modulo, "High modulo range, betMask larger than modulo.");
            choiceCount = inputMask;
        } else if (modulo <= MASK_MODULO_40 * 3) {
            choiceCount = GetChoiceCountForLargeModulo(inputMask, 3);
            mask = inputMask;
        } else if (modulo <= MASK_MODULO_40 * 4) {
            choiceCount = GetChoiceCountForLargeModulo(inputMask, 4);
            mask = inputMask;
        } else if (modulo <= MASK_MODULO_40 * 5) {
            choiceCount = GetChoiceCountForLargeModulo(inputMask, 5);
            mask = inputMask;
        } else if (modulo <= MAX_MASK_MODULO) {
            choiceCount = GetChoiceCountForLargeModulo(inputMask, 6);
            mask = inputMask;
        } else {
            // Larger modulos specify the right edge of half-open interval of
            // winning bet outcomes.
            require(inputMask > 0 && inputMask <= modulo, "High modulo range, betMask larger than modulo.");
            choiceCount = inputMask;
        }        
    }

    // Get the expected win amount after house edge is subtracted.
    function GetDiceWinAmount(uint amount, uint modulo, uint choiceCount) private pure returns (uint winAmount, uint jackpotFee) {
        require(0 < choiceCount && choiceCount <= modulo, "Win probability out of range.");

        jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;

        uint houseEdge = amount * HOUSE_EDGE_OF_TEN_THOUSAND / 10000;

        if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
            houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
        }

        require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");

        winAmount = (amount - houseEdge - jackpotFee) * modulo / choiceCount;
    }    

    /// *** Betting logic

    // Bet states:
    //  amount == 0 && player == 0 - 'clean' (can place a bet)
    //  amount != 0 && player != 0 - 'active' (can be settled or refunded)
    //  amount == 0 && player != 0 - 'processed' (can clean storage)
    
    function PlaceBet(uint mask, uint modulo, uint betId , uint source) public payable gameIsActive {        
        if(KILLED == true) revert ("Contract Killed");
        // Check that the bet is in 'clean' state.
        MAX_PROFIT = (address(this).balance + msg.value - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;
        Bet storage bet = bets[betId];
        if(bet.Player != address(0)) revert("Bet should be in a 'clean' state.");

        // Validate input data ranges.
        if(modulo < 2 && modulo > MAX_MODULO) revert("Modulo should be within range.");
        if(msg.value < MIN_BET && msg.value > MAX_BET) revert("Amount should be within range.");
        if(mask < 0 && mask > MAX_BET_MASK) revert("Mask should be within range.");

        uint choiceCount;
        uint finalMask;
        (choiceCount,finalMask) = GetChoiceCount(mask,modulo);        

        // Winning amount and jackpot increase.
        uint possibleWinAmount;
        uint jackpotFee;

        (possibleWinAmount, jackpotFee) = GetDiceWinAmount(msg.value, modulo, choiceCount);

        // Enforce max profit limit.
        if(possibleWinAmount > MAX_PROFIT) revert("maxProfit limit violation.");

        // Lock funds.
        LOCKED_IN_BETS += uint128(possibleWinAmount);
        JACKPOT_BALANCE += uint128(jackpotFee);

        // Check whether contract has enough funds to process this bet.
        if((JACKPOT_BALANCE + LOCKED_IN_BETS) > address(this).balance) revert( "Cannot afford to lose this bet.");        

        // Record commit in logs.
        emit BetPlaced(betId, source);

        // Store bet parameters on blockchain.
        bet.Amount = uint80(msg.value);
        bet.Modulo = uint8(modulo);
        bet.RollUnder = uint8(choiceCount);
        bet.Mask = uint216(mask);
        bet.Player = msg.sender;
        bet.PlaceBlockNumber = uint40(block.number);
    }

    // Helper routine to process the payment.
    function SendFunds(address payable beneficiary, uint amount, uint successLogAmount, uint betId,uint dice) private {
        if (beneficiary.send(amount)) {
            emit Payment(beneficiary,betId, successLogAmount,dice);
            MAX_PROFIT = (address(this).balance - amount - JACKPOT_BALANCE - LOCKED_IN_BETS) * MAX_PROFIT_PERCENT / 100;
        } else {
            emit FailedPayment(beneficiary,betId,amount,dice);
        }
        
    }

    // Refund transaction - return the bet amount of a roll that was not processed in a
    // due timeframe. 
    // in a situation like this, just contact us, however nothing
    // precludes you from invoking this method yourself.
    function RefundBet(uint betId) external onlyOwner {
        // Check that bet is in 'active' state.
        Bet storage bet = bets[betId];
        uint amount = bet.Amount;

        if(amount == 0) revert("Bet should be in an 'active' state");

        // Move bet into 'processed' state, release funds.
        bet.Amount = 0;

        uint diceWinAmount;
        uint jackpotFee;
        (diceWinAmount, jackpotFee) = GetDiceWinAmount(amount, bet.Modulo, bet.RollUnder);

        LOCKED_IN_BETS -= uint128(diceWinAmount);
        if (JACKPOT_BALANCE >= jackpotFee) {
            JACKPOT_BALANCE -= uint128(jackpotFee);
        }       

        // Send the refund.
        SendFunds(bet.Player, amount, amount, betId,0);
        MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE - diceWinAmount) * MAX_PROFIT_PERCENT / 100;
        delete bets[betId];
    }

     // This is the method used to settle bets. 
    function SettleBet(string memory betString,bytes32 blockHash) public onlyCroupier {
        uint betId = uint(keccak256(abi.encodePacked(betString)));

        Bet storage bet = bets[betId];

         uint placeBlockNumber = bet.PlaceBlockNumber;

        if(block.number <= placeBlockNumber) revert("settleBet in the same block as placeBet, or before.");
        if(blockhash(placeBlockNumber) != blockHash) revert("Invalid BlockHash");        
        
        SettleBetCommon(bet,betId,blockHash);
    }

    // Common settlement code for settleBet.
    function SettleBetCommon(Bet storage bet, uint betId,bytes32 blockHash) private {
        uint amount = bet.Amount;
        uint modulo = bet.Modulo;
        uint rollUnder = bet.RollUnder;
        address payable player = bet.Player;

        // Check that bet is in 'active' state.        
        if(amount == 0) revert("Bet should be in an 'active' state");

        // Move bet into 'processed' state already.
        bet.Amount = 0;

        // The RNG - combine "betId" and blockHash of placeBet using Keccak256.
        bytes32 entropy = keccak256(abi.encodePacked(betId, blockHash));
        
        // Do a roll by taking a modulo of entropy. Compute winning amount.
        uint dice = uint(entropy) % modulo;

        uint diceWinAmount;
        uint _jackpotFee;
        (diceWinAmount, _jackpotFee) = GetDiceWinAmount(amount, modulo, rollUnder);

        uint diceWin = 0;
        uint jackpotWin = 0;

        // Determine dice outcome.
        if ((modulo != 100) && (modulo <= MAX_MASK_MODULO)) {
            // For small modulo games, check the outcome against a bit mask.
            if ((2 ** dice) & bet.Mask != 0) {
                diceWin = diceWinAmount;
            }
        } else {
            // For larger modulos, check inclusion into half-open interval.
            if (dice < rollUnder) {
                diceWin = diceWinAmount;
            }
        }

        // Unlock the bet amount, regardless of the outcome.
        LOCKED_IN_BETS -= uint128(diceWinAmount);

        // Roll for a jackpot (if eligible).
        if (amount >= MIN_JACKPOT_BET) {
            // The second modulo, statistically independent from the "main" dice roll.
            // Effectively you are playing two games at once!
            uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_CHANCE;

            // Bingo!
            if (jackpotRng == 0) {
                jackpotWin = JACKPOT_BALANCE;
                JACKPOT_BALANCE = 0;
            }
        }

        // Log jackpot win.
        if (jackpotWin > 0) {
            emit JackpotPayment(player,betId,jackpotWin);
        }        

        // Send the funds to player.
        SendFunds(player, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, betId,dice);
        MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE - diceWin) * MAX_PROFIT_PERCENT / 100;
        delete bets[betId];
    }

    function GetBetInfoByBetString(string memory betString) public view onlyOwner returns (uint _betId, uint amount, uint8 modulo, uint8 rollUnder, uint betId, uint mask, address player) {
        _betId = uint(keccak256(abi.encodePacked(betString)));
        (amount, modulo, rollUnder, betId, mask, player) = GetBetInfo(_betId);
    }

    function GetBetInfo(uint _betId) public view returns (uint amount, uint8 modulo, uint8 rollUnder, uint betId, uint mask, address player) {
        Bet storage bet = bets[_betId];
        amount = bet.Amount;
        modulo = bet.Modulo;
        rollUnder = bet.RollUnder;
        betId = _betId;
        mask = bet.Mask;
        player = bet.Player;
    }

    /* only owner address can set emergency pause #1 */
    function ownerPauseGame(bool newStatus) public onlyOwner {
        GAME_PAUSED = newStatus;
    }

    /* only owner address can set emergency pause #2 */
    function ownerPausePayouts(bool newPayoutStatus) public onlyOwner {
        PAYOUT_PAUSED = newPayoutStatus;
    }   

    /* only owner address can set emergency pause #2 */
    function ownerSetMaxProfit(uint _maxProfit) public onlyOwner {
        MAX_PROFIT = _maxProfit;
        MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;
    }

     /* only owner address can set emergency pause #2 */
    function ownerSetMaxProfitPercent(uint _maxProfitPercent) public onlyOwner {
        MAX_PROFIT_PERCENT = _maxProfitPercent;
        MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;
    }    

    /* only owner address can transfer ether */
    function TransferEther(address payable sendTo, uint amount) public onlyOwner {        
        /* safely update contract balance when sending out funds*/              
        if(!sendTo.send(amount)) 
            revert("owner transfer ether failed.");	//injected SHORT ADDRESS ATTACK

        if(KILLED == false)
        {
            MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;            
        }
        emit LogTransferEther(sendTo, amount); 
    }

    //Add ether to contract by owner
    function ChargeContract () external payable onlyOwner {
        /* safely update contract balance */ 
        MAX_PROFIT = (address(this).balance - LOCKED_IN_BETS - JACKPOT_BALANCE) * MAX_PROFIT_PERCENT / 100;       
    }

    // Contract may be destroyed only when there are no ongoing bets,
    // either settled or refunded. All funds are transferred to contract owner.
    function kill() external onlyOwner {
        require(LOCKED_IN_BETS == 0, "All bets should be processed (settled or refunded) before self-destruct.");
        KILLED = true;
        JACKPOT_BALANCE = 0;        
    }

     function ownerSetNewOwner(address payable newOwner) external onlyOwner {
        OWNER = newOwner;       
    }

    function ownerSetNewCroupier(address newCroupier) external onlyOwner {
        CROUPIER =  newCroupier  ; 
    }
}