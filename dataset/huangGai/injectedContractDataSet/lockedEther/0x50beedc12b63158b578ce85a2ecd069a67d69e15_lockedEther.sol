/**
 *Submitted for verification at Etherscan.io on 2020-02-28
*/

pragma solidity 0.5.10;

/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
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

/**
 * @title PayableOwnable
 * @dev The PayableOwnable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 * PayableOwnable is extended from open-zeppelin Ownable smart contract, with the difference of making the owner
 * a payable address.
 */
contract PayableOwnable {
    address payable internal _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address payable) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address payable newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address payable newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/// @title PumaPay Single Pull Payment - Contract that facilitates our pull payment protocol
/// The single pull payment smart contract allows for the amount to be defined in PMA rather than in FIAT.
/// This optimization reduces the gas costs that we had in place for the calculation of PMA amount from FIAT
/// compared to the previous versions of our smart contracts (v1 and v2). Also, we don't need to worry about PMA/FIAT rates
/// on the blockchain anymore since we are taking care of that on the wallet side by having the user signing the amount of PMA directly.
/// @author PumaPay Dev Team - <developers@pumapay.io>
contract SinglePullPaymentWithFunding is PayableOwnable {

    using SafeMath for uint256;
    /// ===============================================================================================================
    ///                                      Events
    /// ===============================================================================================================

    event LogExecutorAdded(address executor);
    event LogExecutorRemoved(address executor);
    event LogSmartContractActorFunded(string actorRole, address actor, uint256 timestamp);
    event LogPullPaymentExecuted(
        address customerAddress,
        address receiverAddress,
        uint256 amountInPMA,
        bytes32 paymentID,
        bytes32 businessID,
        string uniqueReferenceID
    );

    /// ===============================================================================================================
    ///                                      Constants
    /// ===============================================================================================================
    bytes32 constant private EMPTY_BYTES32 = "";
    uint256 constant private FUNDING_AMOUNT = 0.5 ether;                           /// Amount to transfer to owner/executor
    uint256 constant private MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS = 0.15 ether;     /// min amount of ETH for owner/executor

    /// ===============================================================================================================
    ///                                      Members
    /// ===============================================================================================================
    IERC20 public token;
    mapping(address => bool) public executors;
    mapping(bytes32 => PullPayment) public pullPayments;

    struct PullPayment {
        bytes32[2] paymentDetails;              /// [0] paymentID / [1] businessID
        uint256 paymentAmount;                  /// payment amount in fiat in cents
        address customerAddress;                /// wallet address of customer
        address receiverAddress;                /// address which pma tokens will be transfer to on execution
        string uniqueReferenceID;
    }
    /// ===============================================================================================================
    ///                                      Modifiers
    /// ===============================================================================================================
    modifier isExecutor() {
        require(executors[msg.sender], "msg.sender not an executor");
        _;
    }
    modifier executorExists(address _executor) {
        require(executors[_executor], "Executor does not exists.");
        _;
    }
    modifier executorDoesNotExists(address _executor) {
        require(!executors[_executor], "Executor already exists.");
        _;
    }
    modifier isValidAddress(address _address) {
        require(_address != address(0), "Invalid address - ZERO_ADDRESS provided");
        _;
    }
    modifier isValidNumber(uint256 _amount) {
        require(_amount > 0, "Invalid amount - Must be higher than zero");
        _;
    }
    modifier isValidByte32(bytes32 _text) {
        require(_text != EMPTY_BYTES32, "Invalid byte32 value.");
        _;
    }
    modifier pullPaymentDoesNotExists(address _customerAddress, bytes32 _paymentID) {
        require(pullPayments[_paymentID].paymentDetails[0] == EMPTY_BYTES32, "Pull payment already exists - Payment ID");
        require(pullPayments[_paymentID].paymentDetails[1] == EMPTY_BYTES32, "Pull payment already exists - Business ID");
        require(pullPayments[_paymentID].paymentAmount == 0, "Pull payment already exists - Payment Amount");
        require(pullPayments[_paymentID].receiverAddress == address(0), "Pull payment already exists - Receiver Address");
        _;
    }

    /// ===============================================================================================================
    ///                                      Constructor
    /// ===============================================================================================================
    /// @dev Contract constructor - sets the token address that the contract facilitates.
    /// @param _token Token Address.
    constructor(address _token)
    public {
        require(_token != address(0), "Invalid address for token - ZERO_ADDRESS provided");
        token = IERC20(_token);
    }

    // @notice Will receive any eth sent to the contract
    function() external payable {	//injected LOCKED ETHER
    }
    /// ===============================================================================================================
    ///                                      Public Functions - Owner Only
    /// ===============================================================================================================

    /// @dev Adds a new executor. - can be executed only by the owner.
    /// @param _executor - address of the executor which cannot be zero address.
    function addExecutor(address payable _executor)
    public
    onlyOwner
    isValidAddress(_executor)
    executorDoesNotExists(_executor)
    {
        executors[_executor] = true;
        if (isFundingNeeded(_executor)) {
            _executor.transfer(0);
            emit LogSmartContractActorFunded("executor", _executor, now);
        }

        if (isFundingNeeded(owner())) {
            owner().transfer(0);
            emit LogSmartContractActorFunded("owner", owner(), now);
        }

        emit LogExecutorAdded(_executor);
    }

    /// @dev Removes a new executor. - can be executed only by the owner.
    /// @param _executor - address of the executor which cannot be zero address.
    function removeExecutor(address payable _executor)
    public
    onlyOwner
    isValidAddress(_executor)
    executorExists(_executor)
    {
        executors[_executor] = false;

        if (isFundingNeeded(owner())) {
            owner().transfer(0);
            emit LogSmartContractActorFunded("owner", owner(), now);
        }

        emit LogExecutorRemoved(_executor);
    }

    /// ===============================================================================================================
    ///                                      Public Functions - Executors Only
    /// ===============================================================================================================

    /// @dev Registers a new pull payment to the PumaPay Pull Payment Contract - The method can be executed only
    /// by one of the executors of the PumaPay Pull Payment Contract.
    /// It creates a new pull payment in the 'pullPayments' mapping and it transfers the amount
    /// It also transfer the PMA amount from the customer address to the receiver address.
    /// Emits 'LogPullPaymentExecuted' with customer address, receiver address, PMA amount, the paymentID, businessID and uniqueReferenceID
    /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
    /// @param r - R output of ECDSA signature.
    /// @param s - S output of ECDSA signature.
    /// @param _paymentDetails - all the relevant id-related details for the payment.
    /// @param _addresses - all the relevant addresses for the payment.
    /// @param _paymentAmount - amount in PMA to be transferred to the receiver.
    /// @param _uniqueReferenceID - unique reference ID of the pull payment.
    function registerPullPayment(
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32[2] memory _paymentDetails, /// [0] paymentID, [1] businessID
        address[2] memory _addresses, /// [0] customerAddress, [1] receiverAddress
        uint256 _paymentAmount,
        string memory _uniqueReferenceID
    )
    public
    isExecutor()
    isValidByte32(_paymentDetails[0])
    isValidByte32(_paymentDetails[1])
    isValidNumber(_paymentAmount)
    isValidAddress(_addresses[0])
    isValidAddress(_addresses[1])
    pullPaymentDoesNotExists(_addresses[0], _paymentDetails[0])
    {
        bytes32[2] memory paymentDetails = _paymentDetails;

        pullPayments[paymentDetails[0]].paymentDetails = _paymentDetails;
        pullPayments[paymentDetails[0]].paymentAmount = _paymentAmount;
        pullPayments[paymentDetails[0]].customerAddress = _addresses[0];
        pullPayments[paymentDetails[0]].receiverAddress = _addresses[1];
        pullPayments[paymentDetails[0]].uniqueReferenceID = _uniqueReferenceID;

        require(isValidRegistration(
                v,
                r,
                s,
                pullPayments[paymentDetails[0]]),
            "Invalid pull payment registration - ECRECOVER_FAILED"
        );

        token.transferFrom(
            _addresses[0],
            _addresses[1],
            _paymentAmount
        );

        if (isFundingNeeded(msg.sender)) {
            msg.sender.transfer(0);
            emit LogSmartContractActorFunded("executor", msg.sender, now);
        }

        emit LogPullPaymentExecuted(
            _addresses[0],
            _addresses[1],
            _paymentAmount,
            paymentDetails[0],
            paymentDetails[1],
            _uniqueReferenceID
        );
    }

    /// ===============================================================================================================
    ///                                      Internal Functions
    /// ===============================================================================================================

    /// @dev Checks if a registration request is valid by comparing the v, r, s params
    /// and the hashed params with the customer address.
    /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
    /// @param r - R output of ECDSA signature.
    /// @param s - S output of ECDSA signature.
    /// @param _pullPayment - pull payment to be validated.
    /// @return bool - if the v, r, s params with the hashed params match the customer address
    function isValidRegistration(
        uint8 v,
        bytes32 r,
        bytes32 s,
        PullPayment memory _pullPayment
    )
    internal
    pure
    returns (bool)
    {
        return ecrecover(
            keccak256(
                abi.encodePacked(
                    _pullPayment.paymentDetails[0],
                    _pullPayment.paymentDetails[1],
                    _pullPayment.paymentAmount,
                    _pullPayment.customerAddress,
                    _pullPayment.receiverAddress,
                    _pullPayment.uniqueReferenceID
                )
            ),
            v, r, s) == _pullPayment.customerAddress;
    }

    /// @dev Checks if the address of an owner/executor needs to be funded.
    /// The minimum amount the owner/executors should always have is 0.15 ETH
    /// @param _address - address of owner/executors that the balance is checked against.
    /// @return bool - whether the address needs more ETH.
    function isFundingNeeded(address _address)
    private
    view
    returns (bool) {
        return address(_address).balance <= MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS;
    }
}