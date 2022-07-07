pragma solidity 0.5.6;

                                                                                                                                                                                                                      
library SafeMath {
                                                                                  
    function MUL223(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                           
    function DIV41(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                              
    function SUB337(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                            
    function ADD232(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                    
    function MOD295(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}

contract ERC20Interface {
    function TOTALSUPPLY507() public view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF692(address tokenOwner) public view returns (uint balance);	//inject NONSTANDARD NAMING
    function ALLOWANCE171(address tokenOwner, address spender) public view returns (uint remaining);	//inject NONSTANDARD NAMING
    function TRANSFER863(address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
    function APPROVE857(address spender, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
    function TRANSFERFROM994(address from, address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING

    uint8 public decimals;

    event TRANSFER332(address indexed from, address indexed to, uint tokens);	//inject NONSTANDARD NAMING
    event APPROVAL437(address indexed tokenOwner, address indexed spender, uint tokens);	//inject NONSTANDARD NAMING
}

contract DAIHardFactory {
    event NEWTRADE364(uint id, address tradeAddress, bool indexed initiatorIsPayer);	//inject NONSTANDARD NAMING

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

    function GETBUYERDEPOSIT760(uint tradeAmount)	//inject NONSTANDARD NAMING
    public
    pure
    returns (uint buyerDeposit) {
        return tradeAmount / 3;
    }

    function GETDEVFEE266(uint tradeAmount)	//inject NONSTANDARD NAMING
    public
    pure
    returns (uint devFee) {
        return tradeAmount / 100;
    }

    function GETEXTRAFEES516(uint tradeAmount)	//inject NONSTANDARD NAMING
    public
    pure
    returns (uint buyerDeposit, uint devFee) {
        return (GETBUYERDEPOSIT760(tradeAmount), GETDEVFEE266(tradeAmount));
    }

                                                                                                                                                                                                                                                                                                        

    function OPENDAIHARDTRADE782(address payable _initiator, bool initiatorIsBuyer, uint[5] calldata uintArgs, string calldata _totalPrice, string calldata _fiatTransferMethods, string calldata _commPubkey)	//inject NONSTANDARD NAMING
    external
    returns (DAIHardTrade) {
        uint transferAmount;
        uint[6] memory newUintArgs; // Note that this structure is not the same as the above comment describes. See below in DAIHardTrade.open.

        if (initiatorIsBuyer) {
            //transferAmount = getBuyerDeposit(uintArgs[0]) + uintArgs[1] + getDevFee(uintArgs[0]); (kept for legibility; SafeMath must be used)
            transferAmount = SafeMath.ADD232(SafeMath.ADD232(GETBUYERDEPOSIT760(uintArgs[0]), uintArgs[1]), GETDEVFEE266(uintArgs[0]));

            newUintArgs = [uintArgs[0], uintArgs[1], GETDEVFEE266(uintArgs[0]), uintArgs[2], uintArgs[3], uintArgs[4]];
        }
        else {
            //transferAmount = uintArgs[0] + uintArgs[1] + getDevFee(uintArgs[0]);  (kept for legibility; SafeMath must be used)
            transferAmount = SafeMath.ADD232(SafeMath.ADD232(uintArgs[0], uintArgs[1]), GETDEVFEE266(uintArgs[0]));

            newUintArgs = [GETBUYERDEPOSIT760(uintArgs[0]), uintArgs[1], GETDEVFEE266(uintArgs[0]), uintArgs[2], uintArgs[3], uintArgs[4]];
        }

        //create the new trade and add its creationInfo to createdTrades
        DAIHardTrade newTrade = new DAIHardTrade(daiContract, devFeeAddress);
        createdTrades.push(CreationInfo(address(newTrade), block.number));
        emit NEWTRADE364(createdTrades.length - 1, address(newTrade), initiatorIsBuyer);

        //transfer DAI to the trade and open it
        require(daiContract.TRANSFERFROM994(msg.sender, address(newTrade), transferAmount), "Token transfer failed. Did you call approve() on the DAI contract?");
        newTrade.OPEN777(_initiator, initiatorIsBuyer, newUintArgs, _totalPrice, _fiatTransferMethods, _commPubkey);
    }

    function GETNUMTRADES43()	//inject NONSTANDARD NAMING
    external
    view
    returns (uint num) {
        return createdTrades.length;
    }
}

contract DAIHardTrade {
    enum Phase {Created, Open, Committed, Claimed, Closed}
    Phase public phase;

    modifier INPHASE268(Phase p) {	//inject NONSTANDARD NAMING
        require(phase == p, "inPhase check failed.");
        _;
    }

    uint[5] public phaseStartTimestamps;

    function CHANGEPHASE108(Phase p)	//inject NONSTANDARD NAMING
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

    modifier ONLYINITIATOR28() {	//inject NONSTANDARD NAMING
        require(msg.sender == initiator, "msg.sender is not Initiator.");
        _;
    }
    modifier ONLYRESPONDER481() {	//inject NONSTANDARD NAMING
        require(msg.sender == responder, "msg.sender is not Responder.");
        _;
    }
    modifier ONLYBUYER57() {	//inject NONSTANDARD NAMING
        require (msg.sender == buyer, "msg.sender is not Buyer.");
        _;
    }
    modifier ONLYSELLER716() {	//inject NONSTANDARD NAMING
        require (msg.sender == seller, "msg.sender is not Seller.");
        _;
    }
    modifier ONLYCONTRACTPARTY42() { // Must be one of the two parties involved in the contract	//inject NONSTANDARD NAMING
        require(msg.sender == initiator || msg.sender == responder, "msg.sender is not a party in this contract.");
        _;
    }

    ERC20Interface daiContract;
    address payable devFeeAddress;

    constructor(ERC20Interface _daiContract, address payable _devFeeAddress)
    public {
        CHANGEPHASE108(Phase.Created);

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

                                                                                                                                                                       

    event OPENED397(string fiatTransferMethods, string commPubkey);	//inject NONSTANDARD NAMING

    function OPEN777(address payable _initiator, bool _initiatorIsBuyer, uint[6] memory uintArgs, string memory _price, string memory fiatTransferMethods, string memory commPubkey)	//inject NONSTANDARD NAMING
    public
    INPHASE268(Phase.Created) {
        require(GETBALANCE315() > 0, "You can't open a trade without first depositing DAI.");

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
            buyerDeposit = SafeMath.SUB337(GETBALANCE315(), SafeMath.ADD232(pokeReward, devFee));
        }
        else {
            seller = initiator;
            daiAmount = SafeMath.SUB337(GETBALANCE315(), SafeMath.ADD232(pokeReward, devFee));
            buyerDeposit = responderDeposit;
        }

        price = _price;

        CHANGEPHASE108(Phase.Open);
        emit OPENED397(fiatTransferMethods, commPubkey);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

    event RECALLED650();	//inject NONSTANDARD NAMING
    event COMMITTED568(address responder, string commPubkey);	//inject NONSTANDARD NAMING


    function RECALL905()	//inject NONSTANDARD NAMING
    external
    INPHASE268(Phase.Open)
    ONLYINITIATOR28() {
       INTERNALRECALL236();
    }

    function INTERNALRECALL236()	//inject NONSTANDARD NAMING
    internal {
        require(daiContract.TRANSFER863(initiator, GETBALANCE315()), "Recall of DAI to initiator failed!");

        CHANGEPHASE108(Phase.Closed);
        emit RECALLED650();
    }

    function AUTORECALLAVAILABLE89()	//inject NONSTANDARD NAMING
    public
    view
    INPHASE268(Phase.Open)
    returns(bool available) {
        return (block.timestamp >= SafeMath.ADD232(phaseStartTimestamps[uint(Phase.Open)], autorecallInterval));
    }

    function COMMIT855(string calldata commPubkey)	//inject NONSTANDARD NAMING
    external
    INPHASE268(Phase.Open) {
        require(daiContract.TRANSFERFROM994(msg.sender, address(this), responderDeposit), "Can't transfer the required deposit from the DAI contract. Did you call approve first?");
        require(!AUTORECALLAVAILABLE89(), "autorecallInterval has passed; this offer has expired.");

        responder = msg.sender;

        if (initiatorIsBuyer) {
            seller = responder;
        }
        else {
            buyer = responder;
        }

        CHANGEPHASE108(Phase.Committed);
        emit COMMITTED568(responder, commPubkey);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

    event CLAIMED907();	//inject NONSTANDARD NAMING
    event ABORTED68();	//inject NONSTANDARD NAMING

    function ABORT91()	//inject NONSTANDARD NAMING
    external
    INPHASE268(Phase.Committed)
    ONLYBUYER57() {
        INTERNALABORT901();
    }

    function INTERNALABORT901()	//inject NONSTANDARD NAMING
    internal {
        //Punishment amount is 1/4 the buyerDeposit for now,
        //but in a future version this might be set by the Initiator.
        uint burnAmount = buyerDeposit / 4;

        //Punish both parties equally by burning burnAmount.
        //Instead of burning burnAmount twice, just burn it all in one call (saves gas).
        require(daiContract.TRANSFER863(address(0x0), burnAmount*2), "Token burn failed!");

        //Send back deposits minus burned amounts.
        require(daiContract.TRANSFER863(buyer, SafeMath.SUB337(buyerDeposit, burnAmount)), "Token transfer to Buyer failed!");
        require(daiContract.TRANSFER863(seller, SafeMath.SUB337(daiAmount, burnAmount)), "Token transfer to Seller failed!");

        uint sendBackToInitiator = devFee;
        //If there was a pokeReward left, it should be sent back to the initiator
        if (!pokeRewardSent) {
            sendBackToInitiator = SafeMath.ADD232(sendBackToInitiator, pokeReward);
        }
        
        require(daiContract.TRANSFER863(initiator, sendBackToInitiator), "Token refund of devFee+pokeReward to Initiator failed!");
        
        //There may be a wei or two left over in the contract due to integer division. Not a big deal.

        CHANGEPHASE108(Phase.Closed);
        emit ABORTED68();
    }

    function AUTOABORTAVAILABLE128()	//inject NONSTANDARD NAMING
    public
    view
    INPHASE268(Phase.Committed)
    returns(bool passed) {
        return (block.timestamp >= SafeMath.ADD232(phaseStartTimestamps[uint(Phase.Committed)], autoabortInterval));
    }

    function CLAIM992()	//inject NONSTANDARD NAMING
    external
    INPHASE268(Phase.Committed)
    ONLYBUYER57() {
        require(!AUTOABORTAVAILABLE128(), "The deposit deadline has passed!");

        CHANGEPHASE108(Phase.Claimed);
        emit CLAIMED907();
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                            

    event RELEASED940();	//inject NONSTANDARD NAMING
    event BURNED656();	//inject NONSTANDARD NAMING

    function AUTORELEASEAVAILABLE963()	//inject NONSTANDARD NAMING
    public
    view
    INPHASE268(Phase.Claimed)
    returns(bool available) {
        return (block.timestamp >= SafeMath.ADD232(phaseStartTimestamps[uint(Phase.Claimed)], autoreleaseInterval));
    }

    function RELEASE38()	//inject NONSTANDARD NAMING
    external
    INPHASE268(Phase.Claimed)
    ONLYSELLER716() {
        INTERNALRELEASE836();
    }

    function INTERNALRELEASE836()	//inject NONSTANDARD NAMING
    internal {
        //If the pokeReward has not been sent, refund it to the initiator
        if (!pokeRewardSent) {
            require(daiContract.TRANSFER863(initiator, pokeReward), "Refund of pokeReward to Initiator failed!");
        }

        //Upon successful resolution of trade, the devFee is sent to the developers of DAIHard.
        require(daiContract.TRANSFER863(devFeeAddress, devFee), "Token transfer to devFeeAddress failed!");

        //Release the remaining balance to the buyer.
        require(daiContract.TRANSFER863(buyer, GETBALANCE315()), "Final release transfer to buyer failed!");

        CHANGEPHASE108(Phase.Closed);
        emit RELEASED940();
    }

    function BURN989()	//inject NONSTANDARD NAMING
    external
    INPHASE268(Phase.Claimed)
    ONLYSELLER716() {
        require(!AUTORELEASEAVAILABLE963());

        INTERNALBURN180();
    }

    function INTERNALBURN180()	//inject NONSTANDARD NAMING
    internal {
        require(daiContract.TRANSFER863(address(0x0), GETBALANCE315()), "Final DAI burn failed!");

        CHANGEPHASE108(Phase.Closed);
        emit BURNED656();
    }

                                                                      

    function GETSTATE363()	//inject NONSTANDARD NAMING
    external
    view
    returns(uint balance, Phase phase, uint phaseStartTimestamp, address responder) {
        return (GETBALANCE315(), this.phase(), phaseStartTimestamps[uint(this.phase())], this.responder());
    }

    function GETBALANCE315()	//inject NONSTANDARD NAMING
    public
    view
    returns(uint) {
        return daiContract.BALANCEOF692(address(this));
    }

    function GETPARAMETERS67()	//inject NONSTANDARD NAMING
    external
    view
    returns (address initiator, bool initiatorIsBuyer, uint daiAmount, string memory totalPrice, uint buyerDeposit, uint autorecallInterval, uint autoabortInterval, uint autoreleaseInterval, uint pokeReward)
    {
        return (this.initiator(), this.initiatorIsBuyer(), this.daiAmount(), this.price(), this.buyerDeposit(), this.autorecallInterval(), this.autoabortInterval(), this.autoreleaseInterval(), this.pokeReward());
    }

    // Poke function lets anyone move the contract along,
    // if it's due for some state transition.

    event POKE500();	//inject NONSTANDARD NAMING

    function POKENEEDED61()	//inject NONSTANDARD NAMING
    public
    view
    returns (bool needed) {
        return (  (phase == Phase.Open      && AUTORECALLAVAILABLE89() )
               || (phase == Phase.Committed && AUTOABORTAVAILABLE128()  )
               || (phase == Phase.Claimed   && AUTORELEASEAVAILABLE963())
               );
    }

    function POKE367()	//inject NONSTANDARD NAMING
    external 
    returns (bool moved) {
        if (POKENEEDED61()) {
            daiContract.TRANSFER863(msg.sender, pokeReward);
            pokeRewardSent = true;
            emit POKE500();
        }
        else return false;

        if (phase == Phase.Open) {
            if (AUTORECALLAVAILABLE89()) {
                INTERNALRECALL236();
                return true;
            }
        }
        else if (phase == Phase.Committed) {
            if (AUTOABORTAVAILABLE128()) {
                INTERNALABORT901();
                return true;
            }
        }
        else if (phase == Phase.Claimed) {
            if (AUTORELEASEAVAILABLE963()) {
                INTERNALRELEASE836();
                return true;
            }
        }
    }

    // StatementLogs allow a starting point for any necessary communication,
    // and can be used anytime by either party after a Responder commits (even in the Closed phase).


    event INITIATORSTATEMENTLOG161(string encryptedForInitiator, string encryptedForResponder);	//inject NONSTANDARD NAMING
    event RESPONDERSTATEMENTLOG369(string encryptedForInitiator, string encryptedForResponder);	//inject NONSTANDARD NAMING

    function INITIATORSTATEMENT924(string memory encryptedForInitiator, string memory encryptedForResponder)	//inject NONSTANDARD NAMING
    public
    ONLYINITIATOR28() {
        require(phase >= Phase.Committed);
        emit INITIATORSTATEMENTLOG161(encryptedForInitiator, encryptedForResponder);
    }

    function RESPONDERSTATEMENT364(string memory encryptedForInitiator, string memory encryptedForResponder)	//inject NONSTANDARD NAMING
    public
    ONLYRESPONDER481() {
        require(phase >= Phase.Committed);
        emit RESPONDERSTATEMENTLOG369(encryptedForInitiator, encryptedForResponder);
    }
}