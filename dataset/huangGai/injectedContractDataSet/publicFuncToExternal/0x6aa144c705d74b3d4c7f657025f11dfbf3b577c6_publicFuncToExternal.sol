pragma solidity 0.5.6;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
 * Code yanked from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    uint8 public decimals;

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract DAIHardFactory {
    event NewTrade(uint id, address tradeAddress, bool indexed initiatorIsPayer);

    ERC20Interface public daiContract;
    address payable public devFeeAddress;

    constructor(ERC20Interface _daiContract, address payable _devFeeAddress)
    public {
        daiContract = _daiContract;
        devFeeAddress = _devFeeAddress;
    }

    struct CreationInfo {
        address address_;
        uint blocknum;
    }

    CreationInfo[] public createdTrades;

    function getBuyerDeposit(uint tradeAmount)
    public
    pure
    returns (uint buyerDeposit) {
        return tradeAmount / 3;
    }

    function getDevFee(uint tradeAmount)
    public
    pure
    returns (uint devFee) {
        return tradeAmount / 100;
    }

    function getExtraFees(uint tradeAmount)
    public
    pure
    returns (uint buyerDeposit, uint devFee) {
        return (getBuyerDeposit(tradeAmount), getDevFee(tradeAmount));
    }

    /*
    The Solidity compiler can't handle much stack depth,
    so we have to pack some args together in annoying ways...
    Hence the 'uintArgs'. Here is its layout:
    0 - daiAmount
    1 - pokeReward
    2 - autorecallInterval
    3 - autoabortInterval
    4 - autoreleaseInterval
    */

    function openDAIHardTrade(address payable _initiator, bool initiatorIsBuyer, uint[5] calldata uintArgs, string calldata _totalPrice, string calldata _fiatTransferMethods, string calldata _commPubkey)
    external
    returns (DAIHardTrade) {
        uint transferAmount;
        uint[6] memory newUintArgs; // Note that this structure is not the same as the above comment describes. See below in DAIHardTrade.open.

        if (initiatorIsBuyer) {
            //transferAmount = getBuyerDeposit(uintArgs[0]) + uintArgs[1] + getDevFee(uintArgs[0]); (kept for legibility; SafeMath must be used)
            transferAmount = SafeMath.add(SafeMath.add(getBuyerDeposit(uintArgs[0]), uintArgs[1]), getDevFee(uintArgs[0]));

            newUintArgs = [uintArgs[0], uintArgs[1], getDevFee(uintArgs[0]), uintArgs[2], uintArgs[3], uintArgs[4]];
        }
        else {
            //transferAmount = uintArgs[0] + uintArgs[1] + getDevFee(uintArgs[0]);  (kept for legibility; SafeMath must be used)
            transferAmount = SafeMath.add(SafeMath.add(uintArgs[0], uintArgs[1]), getDevFee(uintArgs[0]));

            newUintArgs = [getBuyerDeposit(uintArgs[0]), uintArgs[1], getDevFee(uintArgs[0]), uintArgs[2], uintArgs[3], uintArgs[4]];
        }

        //create the new trade and add its creationInfo to createdTrades
        DAIHardTrade newTrade = new DAIHardTrade(daiContract, devFeeAddress);
        createdTrades.push(CreationInfo(address(newTrade), block.number));
        emit NewTrade(createdTrades.length - 1, address(newTrade), initiatorIsBuyer);

        //transfer DAI to the trade and open it
        require(daiContract.transferFrom(msg.sender, address(newTrade), transferAmount), "Token transfer failed. Did you call approve() on the DAI contract?");
        newTrade.open(_initiator, initiatorIsBuyer, newUintArgs, _totalPrice, _fiatTransferMethods, _commPubkey);
    }

    function getNumTrades()
    public	//inject PUBLIC FUNC TO EXTERNAL
    view
    returns (uint num) {
        return createdTrades.length;
    }
}

contract DAIHardTrade {
    enum Phase {Created, Open, Committed, Claimed, Closed}
    Phase public phase;

    modifier inPhase(Phase p) {
        require(phase == p, "inPhase check failed.");
        _;
    }

    uint[5] public phaseStartTimestamps;

    function changePhase(Phase p)
    internal {
        phase = p;
        phaseStartTimestamps[uint(p)] = block.timestamp;
    }


    address payable public initiator;
    address payable public responder;

    //The contract only has two parties, but depending on how it's opened,
    //the initiator for example might be either the buyer OR the seller.

    bool public initiatorIsBuyer;
    address payable public buyer;
    address payable public seller;

    modifier onlyInitiator() {
        require(msg.sender == initiator, "msg.sender is not Initiator.");
        _;
    }
    modifier onlyResponder() {
        require(msg.sender == responder, "msg.sender is not Responder.");
        _;
    }
    modifier onlyBuyer() {
        require (msg.sender == buyer, "msg.sender is not Buyer.");
        _;
    }
    modifier onlySeller() {
        require (msg.sender == seller, "msg.sender is not Seller.");
        _;
    }
    modifier onlyContractParty() { // Must be one of the two parties involved in the contract
        require(msg.sender == initiator || msg.sender == responder, "msg.sender is not a party in this contract.");
        _;
    }

    ERC20Interface daiContract;
    address payable devFeeAddress;

    constructor(ERC20Interface _daiContract, address payable _devFeeAddress)
    public {
        changePhase(Phase.Created);

        daiContract = _daiContract;
        devFeeAddress = _devFeeAddress;

        pokeRewardSent = false;
    }

    uint public daiAmount;
    string public price;
    uint public buyerDeposit;

    uint public responderDeposit; // This will be equal to either daiAmount or buyerDeposit, depending on initiatorIsBuyer

    uint public autorecallInterval;
    uint public autoabortInterval;
    uint public autoreleaseInterval;

    uint public pokeReward;
    uint public devFee;

    bool public pokeRewardSent;

    /*
    uintArgs:
    0 - responderDeposit
    1 - pokeReward
    2 - devFee
    3 - autorecallInterval
    4 - autoabortInterval
    5 - autoreleaseInterval
    */

    event Opened(string fiatTransferMethods, string commPubkey);

    function open(address payable _initiator, bool _initiatorIsBuyer, uint[6] memory uintArgs, string memory _price, string memory fiatTransferMethods, string memory commPubkey)
    public
    inPhase(Phase.Created) {
        require(getBalance() > 0, "You can't open a trade without first depositing DAI.");

        responderDeposit = uintArgs[0];
        pokeReward = uintArgs[1];
        devFee = uintArgs[2];

        autorecallInterval = uintArgs[3];
        autoabortInterval = uintArgs[4];
        autoreleaseInterval = uintArgs[5];

        initiator = _initiator;
        initiatorIsBuyer = _initiatorIsBuyer;
        if (initiatorIsBuyer) {
            buyer = initiator;
            daiAmount = responderDeposit;
            buyerDeposit = SafeMath.sub(getBalance(), SafeMath.add(pokeReward, devFee));
        }
        else {
            seller = initiator;
            daiAmount = SafeMath.sub(getBalance(), SafeMath.add(pokeReward, devFee));
            buyerDeposit = responderDeposit;
        }

        price = _price;

        changePhase(Phase.Open);
        emit Opened(fiatTransferMethods, commPubkey);
    }

    /* ---------------------- OPEN PHASE --------------------------

    In the Open phase, the Initiator waits for a Responder.
    We move to the Commited phase once someone becomes the Responder
    by executing commit() and including msg.value = responderDeposit.

    At any time, the Initiator can cancel the whole thing by calling recall().

    After autorecallInterval has passed, the only state change allowed is to recall(),
    which can be triggered by anyone via poke().

    ------------------------------------------------------------ */

    event Recalled();
    event Committed(address responder, string commPubkey);


    function recall()
    public	//inject PUBLIC FUNC TO EXTERNAL
    inPhase(Phase.Open)
    onlyInitiator() {
       internalRecall();
    }

    function internalRecall()
    internal {
        require(daiContract.transfer(initiator, getBalance()), "Recall of DAI to initiator failed!");

        changePhase(Phase.Closed);
        emit Recalled();
    }

    function autorecallAvailable()
    public
    view
    inPhase(Phase.Open)
    returns(bool available) {
        return (block.timestamp >= SafeMath.add(phaseStartTimestamps[uint(Phase.Open)], autorecallInterval));
    }

    function commit(string calldata commPubkey)
    external
    inPhase(Phase.Open) {
        require(daiContract.transferFrom(msg.sender, address(this), responderDeposit), "Can't transfer the required deposit from the DAI contract. Did you call approve first?");
        require(!autorecallAvailable(), "autorecallInterval has passed; this offer has expired.");

        responder = msg.sender;

        if (initiatorIsBuyer) {
            seller = responder;
        }
        else {
            buyer = responder;
        }

        changePhase(Phase.Committed);
        emit Committed(responder, commPubkey);
    }

    /* ---------------------- COMMITTED PHASE ---------------------

    In the Committed phase, the Buyer is expected to deposit fiat for the DAI,
    then call claim().

    Otherwise, the Buyer can call abort(), which cancels the contract,
    incurs a small penalty on both parties, and returns the remainder to each party.

    After autoabortInterval has passed, the only state change allowed is to abort(),
    which can be triggered by anyone via poke().

    ------------------------------------------------------------ */

    event Claimed();
    event Aborted();

    function abort()
    public	//inject PUBLIC FUNC TO EXTERNAL
    inPhase(Phase.Committed)
    onlyBuyer() {
        internalAbort();
    }

    function internalAbort()
    internal {
        //Punishment amount is 1/4 the buyerDeposit for now,
        //but in a future version this might be set by the Initiator.
        uint burnAmount = buyerDeposit / 4;

        //Punish both parties equally by burning burnAmount.
        //Instead of burning burnAmount twice, just burn it all in one call (saves gas).
        require(daiContract.transfer(address(0x0), burnAmount*2), "Token burn failed!");

        //Send back deposits minus burned amounts.
        require(daiContract.transfer(buyer, SafeMath.sub(buyerDeposit, burnAmount)), "Token transfer to Buyer failed!");
        require(daiContract.transfer(seller, SafeMath.sub(daiAmount, burnAmount)), "Token transfer to Seller failed!");

        uint sendBackToInitiator = devFee;
        //If there was a pokeReward left, it should be sent back to the initiator
        if (!pokeRewardSent) {
            sendBackToInitiator = SafeMath.add(sendBackToInitiator, pokeReward);
        }
        
        require(daiContract.transfer(initiator, sendBackToInitiator), "Token refund of devFee+pokeReward to Initiator failed!");
        
        //There may be a wei or two left over in the contract due to integer division. Not a big deal.

        changePhase(Phase.Closed);
        emit Aborted();
    }

    function autoabortAvailable()
    public
    view
    inPhase(Phase.Committed)
    returns(bool passed) {
        return (block.timestamp >= SafeMath.add(phaseStartTimestamps[uint(Phase.Committed)], autoabortInterval));
    }

    function claim()
    public	//inject PUBLIC FUNC TO EXTERNAL
    inPhase(Phase.Committed)
    onlyBuyer() {
        require(!autoabortAvailable(), "The deposit deadline has passed!");

        changePhase(Phase.Claimed);
        emit Claimed();
    }

    /* ---------------------- CLAIMED PHASE -----------------------

    In the Claimed phase, the Seller can call release() or burn(),
    and is expected to call burn() only if the Buyer did not transfer
    the amount of money described in totalPrice.

    After autoreleaseInterval has passed, the only state change allowed is to release,
    which can be triggered by anyone via poke().

    ------------------------------------------------------------ */

    event Released();
    event Burned();

    function autoreleaseAvailable()
    public
    view
    inPhase(Phase.Claimed)
    returns(bool available) {
        return (block.timestamp >= SafeMath.add(phaseStartTimestamps[uint(Phase.Claimed)], autoreleaseInterval));
    }

    function release()
    public	//inject PUBLIC FUNC TO EXTERNAL
    inPhase(Phase.Claimed)
    onlySeller() {
        internalRelease();
    }

    function internalRelease()
    internal {
        //If the pokeReward has not been sent, refund it to the initiator
        if (!pokeRewardSent) {
            require(daiContract.transfer(initiator, pokeReward), "Refund of pokeReward to Initiator failed!");
        }

        //Upon successful resolution of trade, the devFee is sent to the developers of DAIHard.
        require(daiContract.transfer(devFeeAddress, devFee), "Token transfer to devFeeAddress failed!");

        //Release the remaining balance to the buyer.
        require(daiContract.transfer(buyer, getBalance()), "Final release transfer to buyer failed!");

        changePhase(Phase.Closed);
        emit Released();
    }

    function burn()
    public	//inject PUBLIC FUNC TO EXTERNAL
    inPhase(Phase.Claimed)
    onlySeller() {
        require(!autoreleaseAvailable());

        internalBurn();
    }

    function internalBurn()
    internal {
        require(daiContract.transfer(address(0x0), getBalance()), "Final DAI burn failed!");

        changePhase(Phase.Closed);
        emit Burned();
    }

    /* ---------------------- OTHER METHODS ----------------------- */

    function getState()
    public	//inject PUBLIC FUNC TO EXTERNAL
    view
    returns(uint balance, Phase phase, uint phaseStartTimestamp, address responder) {
        return (getBalance(), this.phase(), phaseStartTimestamps[uint(this.phase())], this.responder());
    }

    function getBalance()
    public
    view
    returns(uint) {
        return daiContract.balanceOf(address(this));
    }

    function getParameters()
    public	//inject PUBLIC FUNC TO EXTERNAL
    view
    returns (address initiator, bool initiatorIsBuyer, uint daiAmount, string memory totalPrice, uint buyerDeposit, uint autorecallInterval, uint autoabortInterval, uint autoreleaseInterval, uint pokeReward)
    {
        return (this.initiator(), this.initiatorIsBuyer(), this.daiAmount(), this.price(), this.buyerDeposit(), this.autorecallInterval(), this.autoabortInterval(), this.autoreleaseInterval(), this.pokeReward());
    }

    // Poke function lets anyone move the contract along,
    // if it's due for some state transition.

    event Poke();

    function pokeNeeded()
    public
    view
    returns (bool needed) {
        return (  (phase == Phase.Open      && autorecallAvailable() )
               || (phase == Phase.Committed && autoabortAvailable()  )
               || (phase == Phase.Claimed   && autoreleaseAvailable())
               );
    }

    function poke()
    public 	//inject PUBLIC FUNC TO EXTERNAL
    returns (bool moved) {
        if (pokeNeeded()) {
            daiContract.transfer(msg.sender, pokeReward);
            pokeRewardSent = true;
            emit Poke();
        }
        else return false;

        if (phase == Phase.Open) {
            if (autorecallAvailable()) {
                internalRecall();
                return true;
            }
        }
        else if (phase == Phase.Committed) {
            if (autoabortAvailable()) {
                internalAbort();
                return true;
            }
        }
        else if (phase == Phase.Claimed) {
            if (autoreleaseAvailable()) {
                internalRelease();
                return true;
            }
        }
    }

    // StatementLogs allow a starting point for any necessary communication,
    // and can be used anytime by either party after a Responder commits (even in the Closed phase).


    event InitiatorStatementLog(string encryptedForInitiator, string encryptedForResponder);
    event ResponderStatementLog(string encryptedForInitiator, string encryptedForResponder);

    function initiatorStatement(string memory encryptedForInitiator, string memory encryptedForResponder)
    public
    onlyInitiator() {
        require(phase >= Phase.Committed);
        emit InitiatorStatementLog(encryptedForInitiator, encryptedForResponder);
    }

    function responderStatement(string memory encryptedForInitiator, string memory encryptedForResponder)
    public
    onlyResponder() {
        require(phase >= Phase.Committed);
        emit ResponderStatementLog(encryptedForInitiator, encryptedForResponder);
    }
}