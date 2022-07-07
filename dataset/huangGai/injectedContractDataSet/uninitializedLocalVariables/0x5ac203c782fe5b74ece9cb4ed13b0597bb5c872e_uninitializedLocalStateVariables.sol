pragma solidity 0.5.8;

//TODO: third party auditory


/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns(uint256) {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     */
    function sub(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns(uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     */
    function div(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR


        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns(uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token Standard Interface
// ----------------------------------------------------------------------------
interface ERC20Interface {
    function totalSupply() external returns(uint);
    function balanceOf(address tokenOwner) external returns(uint balance);
    function allowance(address tokenOwner, address spender) external returns(uint remaining);
    function transfer(address to, uint tokens) external returns(bool success);
    function approve(address spender, uint tokens) external returns(bool success);
    function transferFrom(address from, address to, uint tokens) external returns(bool success);
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

/**
 * @title admined
 * @notice This contract is administered
 */
contract admined {
    //mapping to user levels
    mapping(address => uint8) public level;
    //0 normal user
    //1 basic admin
    //2 master admin

    constructor() internal {
        level[0x7a3a57c620fA468b304b5d1826CDcDe28E2b2b98] = 2; //Set initial admin to contract creator
        emit AdminshipUpdated(0x7a3a57c620fA468b304b5d1826CDcDe28E2b2b98, 2); //Log the admin set
    }

    /**
     * @dev This modifier limits function execution to the admin
     */
    modifier onlyAdmin(uint8 _level) { //A modifier to define admin-only functions
        //It require the user level to be more or equal than _level
        require(level[msg.sender] >= _level, "You dont have rights for this transaction");
        _;
    }

    /**
     * @notice This function transfer the adminship of the contract to _newAdmin
     * @param _newAdmin The new admin of the contract
     * @param _level Level to assign to the new admin of the contract
     */
    function adminshipLevel(address _newAdmin, uint8 _level) public onlyAdmin(2) {//Admin can be set
        require(_newAdmin != address(0), "Address cannot be zero"); //The new admin must not be zero address
        level[_newAdmin] = _level; //New level is set
        emit AdminshipUpdated(_newAdmin, _level); //Log the admin set
    }

    /**
     * @dev Log Events
     */
    event AdminshipUpdated(address _newAdmin, uint8 _level);

}

// ----------------------------------------------------------------------------
// Main Contract definition
// ----------------------------------------------------------------------------
contract ICO is admined {

    using SafeMath for uint256;

    enum State {
        //This ico have these states
        OnSale,
        Successful
    }

    //public variables

    //state related
    State public state ; //Set initial stage	//inject UNINIT LOCAL/STATE VAR


    //time related
    uint256 public SaleStartTime ;	//inject UNINIT LOCAL/STATE VAR

    uint256 public completedAt;

    //token related
    ERC20Interface public tokenReward;

    //funding related
    uint256 public totalRaised; //eth in wei
    uint256 public totalDistributed; //tokens distributed
    uint256 public totalBonusDistributed; //bonus tokens distributed
    uint256 public constant rate = 2941; //Rate
    uint256 public constant trancheSize = 52500000 * 1e18;
    uint256 public constant hardCap = 420000000 * 1e18;
    uint256 public constant softCap = 3000000 * 1e18;
    mapping(address => uint256) public invested;
    mapping(address => uint256) public received;
    mapping(address => uint256) public bonusReceived;

    //info
    address public owner;
    address payable public beneficiary;
    string public version ;	//inject UNINIT LOCAL/STATE VAR


    //events for log
    event LogFundingInitialized(address _owner);
    event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
    event LogContributorsPayout(address _addr, uint _amount);
    event LogBeneficiaryPaid(address _beneficiaryAddress);
    event LogFundingSuccessful(uint _totalRaised);

    modifier notFinished() {
        require(state != State.Successful, "Sale have finished");
        _;
    }

    /**
     * @notice ICO constructor
     * @param _addressOfTokenUsedAsReward is the token to distributed
     */
    constructor(ERC20Interface _addressOfTokenUsedAsReward) public {

        tokenReward = _addressOfTokenUsedAsReward;
        owner = 0x7a3a57c620fA468b304b5d1826CDcDe28E2b2b98;
        beneficiary = 0x8605409D35f707714A83410BE9C8025dcefa9faC;

        emit LogFundingInitialized(owner);

    }

    /**
     * @notice contribution handler
     */
    function contribute(address _target, uint256 _value) public notFinished payable {

        address user;
        uint valueHandler;

        uint tokenBought;
        uint tokenBonus;

        uint bonusStack;
        uint trancheLeft;
        uint remaining;

        if (_target != address(0) && level[msg.sender] >= 1) {
            user = _target;
            valueHandler = _value;
        } else {
            user = msg.sender;
            valueHandler = msg.value;
            //Refund through contract for eth contributors only
            invested[msg.sender] = invested[msg.sender].add(msg.value);
        }

        require(valueHandler >= 0.1 ether, "Not enough value for this transaction");

        totalRaised = totalRaised.add(valueHandler); //ether received updated

        //This keep the tokens bought
        tokenBought = valueHandler.mul(rate);
        //This keep the tokens to be bonus-analized
        remaining = valueHandler.mul(rate);

        //First Tranche Handler
        if (remaining > 0 &&
            totalDistributed < trancheSize
        ) {
            trancheLeft = trancheSize.sub(totalDistributed);

            if (remaining < trancheLeft) {
                bonusStack = remaining.mul(4);
                tokenBonus = bonusStack.div(10);

                totalDistributed = totalDistributed.add(remaining);

                remaining = 0;
                bonusStack = 0;
                trancheLeft = 0;
            } else {
                bonusStack = trancheLeft.mul(4);
                tokenBonus = bonusStack.div(10);

                totalDistributed = totalDistributed.add(trancheLeft);

                remaining = remaining.sub(trancheLeft);
                bonusStack = 0;
                trancheLeft = 0;
            }
        }

        //Second Tranche Handler
        if (remaining > 0 &&
            totalDistributed >= trancheSize &&
            totalDistributed < trancheSize.mul(2)
        ) {
            trancheLeft = trancheSize.mul(2).sub(totalDistributed);

            if (remaining < trancheLeft) {
                bonusStack = remaining.mul(35);
                tokenBonus = tokenBonus.add(bonusStack.div(100));

                totalDistributed = totalDistributed.add(remaining);

                remaining = 0;
                bonusStack = 0;
                trancheLeft = 0;
            } else {
                bonusStack = trancheLeft.mul(35);
                tokenBonus = tokenBonus.add(bonusStack.div(100));

                totalDistributed = totalDistributed.add(trancheLeft);

                remaining = remaining.sub(trancheLeft);
                bonusStack = 0;
                trancheLeft = 0;
            }
        }

        //Third Tranche Handler
        if (remaining > 0 &&
            totalDistributed >= trancheSize.mul(2) &&
            totalDistributed < trancheSize.mul(3)
        ) {
            trancheLeft = trancheSize.mul(3).sub(totalDistributed);

            if (remaining < trancheLeft) {
                bonusStack = remaining.mul(3);
                tokenBonus = tokenBonus.add(bonusStack.div(10));

                totalDistributed = totalDistributed.add(remaining);

                remaining = 0;
                bonusStack = 0;
                trancheLeft = 0;
            } else {
                bonusStack = trancheLeft.mul(3);
                tokenBonus = tokenBonus.add(bonusStack.div(10));

                totalDistributed = totalDistributed.add(trancheLeft);

                remaining = remaining.sub(trancheLeft);
                bonusStack = 0;
                trancheLeft = 0;
            }
        }

        //Fourth Tranche Handler
        if (remaining > 0 &&
            totalDistributed >= trancheSize.mul(3) &&
            totalDistributed < trancheSize.mul(4)
        ) {
            trancheLeft = trancheSize.mul(4).sub(totalDistributed);

            if (remaining < trancheLeft) {
                bonusStack = remaining.mul(2);
                tokenBonus = tokenBonus.add(bonusStack.div(10));

                totalDistributed = totalDistributed.add(remaining);

                remaining = 0;
                bonusStack = 0;
                trancheLeft = 0;
            } else {
                bonusStack = trancheLeft.mul(2);
                tokenBonus = tokenBonus.add(bonusStack.div(10));

                totalDistributed = totalDistributed.add(trancheLeft);

                remaining = remaining.sub(trancheLeft);
                bonusStack = 0;
                trancheLeft = 0;
            }
        }

        //Fifth Tranche Handler
        if (remaining > 0 &&
            totalDistributed >= trancheSize.mul(4) &&
            totalDistributed < trancheSize.mul(5)
        ) {
            trancheLeft = trancheSize.mul(5).sub(totalDistributed);

            if (remaining < trancheLeft) {
                tokenBonus = tokenBonus.add(remaining.div(10));

                totalDistributed = totalDistributed.add(remaining);

                remaining = 0;
                bonusStack = 0;
                trancheLeft = 0;
            } else {
                tokenBonus = tokenBonus.add(trancheLeft.div(10));

                totalDistributed = totalDistributed.add(trancheLeft);

                remaining = remaining.sub(trancheLeft);
                bonusStack = 0;
                trancheLeft = 0;
            }
        }

        //Sixth Tranche Handler
        if (remaining > 0 &&
            totalDistributed >= trancheSize.mul(5) &&
            totalDistributed < trancheSize.mul(6)
        ) {
            trancheLeft = trancheSize.mul(6).sub(totalDistributed);

            if (remaining < trancheLeft) {
                bonusStack = remaining.mul(5);
                tokenBonus = tokenBonus.add(bonusStack.div(100));

                totalDistributed = totalDistributed.add(remaining);

                remaining = 0;
                bonusStack = 0;
                trancheLeft = 0;
            } else {
                bonusStack = trancheLeft.mul(5);
                tokenBonus = tokenBonus.add(bonusStack.div(100));

                totalDistributed = totalDistributed.add(trancheLeft);

                remaining = remaining.sub(trancheLeft);
                bonusStack = 0;
                trancheLeft = 0;
            }
        }

        totalDistributed = totalDistributed.add(remaining);
        totalBonusDistributed = totalBonusDistributed.add(tokenBonus);

        tokenReward.transfer(user, tokenBought.add(tokenBonus));
        received[user] = received[user].add(tokenBought);
        bonusReceived[user] = bonusReceived[user].add(tokenBonus);

        emit LogFundingReceived(user, valueHandler, totalRaised); //Log the purchase

        checkIfFundingCompleteOrExpired(); //Execute state checks
    }

    /**
     * @notice check status
     */
    function checkIfFundingCompleteOrExpired() public {

        if (totalDistributed.add(totalBonusDistributed) > hardCap.sub(rate)) { //If we reach the PubSale deadline

            state = State.Successful; //ico becomes Successful

            completedAt = now; //ICO is complete

            emit LogFundingSuccessful(totalRaised); //we log the finish
            finished(); //and execute closure

        }
    }

    function withdrawEth() public onlyAdmin(2) {
        require(totalDistributed >= softCap, "Too early to retrieve funds");
        beneficiary.transfer(address(this).balance);
    }

    function getRefund() public notFinished {
        require(totalDistributed >= softCap, "Too early to retrieve funds");
        require(invested[msg.sender] > 0, "No eth to refund");
        require(
            tokenReward.transferFrom(
                msg.sender,
                address(this),
                received[msg.sender].add(bonusReceived[msg.sender])
            ),
            "Cannot retrieve tokens"
        );

        totalDistributed = totalDistributed.sub(received[msg.sender]);
        totalBonusDistributed = totalBonusDistributed.sub(bonusReceived[msg.sender]);
        received[msg.sender] = 0;
        bonusReceived[msg.sender] = 0;
        uint toTransfer ;	//inject UNINIT LOCAL/STATE VAR

        invested[msg.sender] = 0;
        msg.sender.transfer(toTransfer);
    }

    /**
     * @notice closure handler
     */
    function finished() public { //When finished, eth are transfered to beneficiary
        //Only on sucess
        require(state == State.Successful, "Wrong Stage");

        uint256 remanent ;	//inject UNINIT LOCAL/STATE VAR


        require(tokenReward.transfer(beneficiary, remanent), "Transfer could not be made");

        beneficiary.transfer(address(this).balance);
        emit LogBeneficiaryPaid(beneficiary);
    }

    /*
     * @notice direct payments handler
     */
    function () external payable {
        contribute(address(0), 0);
    }
}