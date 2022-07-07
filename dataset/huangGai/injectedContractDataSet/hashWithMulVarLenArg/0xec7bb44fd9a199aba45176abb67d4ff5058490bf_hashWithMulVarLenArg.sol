/**
 *Submitted for verification at Etherscan.io on 2020-02-25
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

/// @title PumaPay Pull Payment V2.1 - Contract that facilitates our pull payment protocol
/// V2.1 of the protocol removes the notion of the `pull payment executors` i.e. the addresses
/// that can execute a pull payment `executePullPayment()`. That function is now publicly available.
/// We are also changing the `pullPayments` mapping. Instead of having address -> address -> PullPayment,
/// ot will be address -> bytes32 -> PullPayment, with bytes32 being the pull payment ID.
/// @author PumaPay Dev Team - <developers@pumapay.io>
contract PumaPayPullPaymentV2_2 is PayableOwnable {
    using SafeMath for uint256;
    /// ===============================================================================================================
    ///                                      Events
    /// ===============================================================================================================
    event LogExecutorAdded(address executor);
    event LogExecutorRemoved(address executor);
    event LogSmartContractActorFunded(string actorRole, address actor, uint256 timestamp);
    event LogPaymentRegistered(
        address customerAddress,
        bytes32 paymentID,
        bytes32 businessID,
        bytes32 uniqueReferenceID
    );
    event LogPaymentCancelled(
        address customerAddress,
        bytes32 paymentID,
        bytes32 businessID,
        bytes32 uniqueReferenceID
    );
    event LogPullPaymentExecuted(
        address customerAddress,
        bytes32 paymentID,
        bytes32 businessID,
        bytes32 uniqueReferenceID,
        uint256 amountInPMA,
        uint256 conversionRate
    );
    /// ===============================================================================================================
    ///                                      Constants
    /// ===============================================================================================================

    uint256 constant private RATE_CALCULATION_NUMBER = 10 ** 26;    /// Check `calculatePMAFromFiat()` for more details
    uint256 constant private OVERFLOW_LIMITER_NUMBER = 10 ** 20;    /// 1e^20 - Prevent numeric overflows
    /// @dev The following variables are not needed any more, but are kept hre for clarity on the calculation that
    /// is being done for the PMA to Fiat from rate.
    /// uint256 constant private DECIMAL_FIXER = 10 ** 10; /// 1e^10 - This transforms the Rate from decimals to uint256
    /// uint256 constant private FIAT_TO_CENT_FIXER = 100; /// Fiat currencies have 100 cents in 1 basic monetary unit.
    uint256 constant private ONE_ETHER = 1 ether;                                  /// PumaPay token has 18 decimals - same as one ETHER
    uint256 constant private FUNDING_AMOUNT = 0.5 ether;                           /// Amount to transfer to owner/executor
    uint256 constant private MINIMUM_AMOUNT_OF_ETH_FOR_OPERATORS = 0.15 ether;     /// min amount of ETH for owner/executor
    bytes32 constant private TYPE_SINGLE_PULL_PAYMENT = "2";
    bytes32 constant private TYPE_RECURRING_PULL_PAYMENT = "3";
    bytes32 constant private TYPE_RECURRING_PULL_PAYMENT_WITH_INITIAL = "4";
    bytes32 constant private TYPE_PULL_PAYMENT_WITH_FREE_TRIAL = "5";
    bytes32 constant private TYPE_PULL_PAYMENT_WITH_PAID_TRIAL = "6";
    bytes32 constant private TYPE_SINGLE_DYNAMIC_PULL_PAYMENT = "7";
    bytes32 constant private EMPTY_BYTES32 = "";
    /// ===============================================================================================================
    ///                                      Members
    /// ===============================================================================================================
    IERC20 public token;
    mapping(address => bool) public executors;
    mapping(bytes32 => PullPayment) public pullPayments;

    struct PullPayment {
        bytes32[3] paymentIds;                  /// [0] paymentID / [1] businessID / [2] uniqueReferenceID
        bytes32 paymentType;                    /// Type of Pull Payment - must be one of the defined pull payment types
        string currency;                        /// 3-letter abbr i.e. 'EUR' / 'USD' etc.
        uint256 initialConversionRate;          /// conversion rate for first payment execution
        uint256 initialPaymentAmountInCents;    /// initial payment amount in fiat in cents
        uint256 fiatAmountInCents;              /// payment amount in fiat in cents
        uint256 frequency;                      /// how often merchant can pull - in seconds
        uint256 numberOfPayments;               /// amount of pull payments merchant can make
        uint256 startTimestamp;                 /// when subscription starts - in seconds
        uint256 trialPeriod;                    /// trial period of the pull payment - in seconds
        uint256 nextPaymentTimestamp;           /// timestamp of next payment
        uint256 lastPaymentTimestamp;           /// timestamp of last payment
        uint256 cancelTimestamp;                /// timestamp the payment was cancelled
        address treasuryAddress;                /// address which pma tokens will be transfer to on execution
        address executorAddress;                /// address that can execute the pull payment
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
    modifier paymentExists(bytes32 _paymentID) {
        require(pullPayments[_paymentID].paymentIds[0] != "", "Pull Payment does not exists.");
        _;
    }
    modifier paymentNotCancelled(bytes32 _paymentID) {
        require(pullPayments[_paymentID].cancelTimestamp == 0, "Pull Payment is cancelled");
        _;
    }
    modifier isValidPullPaymentExecutionRequest(
        bytes32 _paymentID,
        uint256 _paymentNumber) {
        require(pullPayments[_paymentID].numberOfPayments == _paymentNumber,
            "Invalid pull payment execution request - Pull payment number of payment is invalid");
        require((pullPayments[_paymentID].initialPaymentAmountInCents > 0 ||
        (now >= pullPayments[_paymentID].startTimestamp &&
        now >= pullPayments[_paymentID].nextPaymentTimestamp)
            ), "Invalid pull payment execution request - Time of execution is invalid."
        );
        require(pullPayments[_paymentID].numberOfPayments > 0,
            "Invalid pull payment execution request - Number of payments is zero.");
        require(
            (pullPayments[_paymentID].cancelTimestamp == 0 ||
        pullPayments[_paymentID].cancelTimestamp >
        pullPayments[_paymentID].nextPaymentTimestamp),
            "Invalid pull payment execution request - Pull payment is cancelled");
        require(keccak256(
            abi.encodePacked(pullPayments[_paymentID].paymentIds[0])
        ) == keccak256(abi.encodePacked(_paymentID)),
            "Invalid pull payment execution request - Payment ID not matching.");
        _;
    }
    modifier isValidDeletionRequest(bytes32 _paymentID, address _customerAddress) {
        require(_paymentID != EMPTY_BYTES32, "Invalid deletion request - Payment ID is empty.");
        require(_customerAddress != address(0), "Invalid deletion request - Client address is ZERO_ADDRESS.");
        _;
    }
    modifier isValidAddress(address _address) {
        require(_address != address(0), "Invalid address - ZERO_ADDRESS provided");
        _;
    }
    modifier validAmount(uint256 _amount) {
        require(_amount > 0, "Invalid amount - Must be higher than zero");
        require(_amount <= OVERFLOW_LIMITER_NUMBER, "Invalid amount - Must be lower than the overflow limit.");
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
    function() external payable {
    }
    /// ===============================================================================================================
    ///                                      Public Functions - Owner Only
    /// ===============================================================================================================
    /// @dev Adds a new executor. - can be executed only by the onwer.
    /// When adding a new executor 0.5 ETH is transferred to allow the executor to pay for gas.
    /// The balance of the owner is also checked and if funding is needed 0.5 ETH is transferred.
    /// @param _executor - address of the executor which cannot be zero address.
    function addExecutor(address payable _executor)
    public
    onlyOwner
    isValidAddress(_executor)
    executorDoesNotExists(_executor)
    {
        executors[_executor] = true;
        if (isFundingNeeded(_executor)) {
            _executor.transfer(FUNDING_AMOUNT);
            emit LogSmartContractActorFunded("executor", _executor, now);
        }

        if (isFundingNeeded(owner())) {
            owner().transfer(FUNDING_AMOUNT);
            emit LogSmartContractActorFunded("owner", owner(), now);
        }
        emit LogExecutorAdded(_executor);
    }
    /// @dev Removes a new executor. - can be executed only by the owner.
    /// The balance of the owner is checked and if funding is needed 0.5 ETH is transferred.
    /// @param _executor - address of the executor which cannot be zero address.
    function removeExecutor(address payable _executor)
    public
    onlyOwner
    isValidAddress(_executor)
    executorExists(_executor)
    {
        executors[_executor] = false;
        if (isFundingNeeded(owner())) {
            owner().transfer(FUNDING_AMOUNT);
            emit LogSmartContractActorFunded("owner", owner(), now);
        }
        emit LogExecutorRemoved(_executor);
    }
    /// ===============================================================================================================
    ///                                      Public Functions - Executors Only
    /// ===============================================================================================================
    /// @dev Registers a new pull payment to the PumaPay Pull Payment Contract - The registration can be executed only
    /// by one of the executors of the PumaPay Pull Payment Contract
    /// and the PumaPay Pull Payment Contract checks that the pull payment has been singed by the customer of the account.
    /// If the pull payment doesn't have a trial period, the first execution will take place.'
    /// The pull payment is updated accordingly in terms of how many payments can happen, and when is the next payment date.
    /// (For more details on the above check the 'executePullPayment' method.
    /// The balance of the executor (msg.sender) is checked and if funding is needed 0.5 ETH is transferred.
    /// Emits 'LogPaymentRegistered' with customer address, pull payment executor address and paymentID.
    /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
    /// @param r - R output of ECDSA signature.
    /// @param s - S output of ECDSA signature.
    /// @param _paymentDetails - all the relevant id-related details for the payment.
    /// @param _addresses - all the relevant addresses for the payment.
    /// @param _paymentAmounts - all the relevant amounts for the payment.
    /// @param _paymentTimestamps - all the relevant timestamps for the payment.
    /// @param _currency - currency of the payment / 3-letter abbr i.e. 'EUR'.
    function registerPullPayment(
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32[4] memory _paymentDetails, // 0 paymentID, 1 businessID, 2 uniqueReferenceID, 3 paymentType
        address[3] memory _addresses, // 0 customer, 1 executor, 2 treasury
        uint256[3] memory _paymentAmounts, // 0 _initialConversionRate, 1 _fiatAmountInCents, 2 _initialPaymentAmountInCents
        uint256[4] memory _paymentTimestamps, // 0 _frequency, 1 _numberOfPayments, 2 _startTimestamp, 3 _trialPeriod
        string memory _currency
    )
    public
    isExecutor()
    {
        require(pullPayments[_paymentDetails[0]].paymentIds[0] == "", "Pull Payment already exists.");
        require(_paymentDetails[0] != EMPTY_BYTES32, "Payment ID is empty.");
        require(_paymentDetails[1] != EMPTY_BYTES32, "Business ID is empty.");
        require(_paymentDetails[2] != EMPTY_BYTES32, "Unique Reference ID is empty.");
        require(_paymentDetails[3] != EMPTY_BYTES32, "Payment Type is empty.");
        require(_addresses[0] != address(0), "Customer Address is ZERO_ADDRESS.");
        require(_addresses[1] != address(0), "Treasury Address is ZERO_ADDRESS.");
        require(_paymentAmounts[0] > 0, "Initial conversion rate is zero.");
        require(_paymentAmounts[1] > 0, "Payment amount in fiat is zero.");
        require(_paymentAmounts[2] >= 0, "Initial payment amount in fiat is less than zero.");
        require(_paymentTimestamps[0] > 0, "Payment frequency is zero.");
        require(_paymentTimestamps[1] > 0, "Payment number of payments is zero.");
        require(_paymentTimestamps[2] > 0, "Payment start time is zero.");
        require(_paymentTimestamps[3] >= 0, "Payment trial period is less than zero.");
        require(_paymentAmounts[0] <= OVERFLOW_LIMITER_NUMBER, "Initial conversion rate is higher thant the overflow limit.");
        require(_paymentAmounts[1] <= OVERFLOW_LIMITER_NUMBER, "Payment amount in fiat is higher thant the overflow limit.");
        require(_paymentAmounts[2] <= OVERFLOW_LIMITER_NUMBER, "Payment initial amount in fiat is higher thant the overflow limit.");
        require(_paymentTimestamps[0] <= OVERFLOW_LIMITER_NUMBER, "Payment frequency is higher thant the overflow limit.");
        require(_paymentTimestamps[1] <= OVERFLOW_LIMITER_NUMBER, "Payment number of payments is higher thant the overflow limit.");
        require(_paymentTimestamps[2] <= OVERFLOW_LIMITER_NUMBER, "Payment start time is higher thant the overflow limit.");
        require(_paymentTimestamps[3] <= OVERFLOW_LIMITER_NUMBER, "Payment trial period is higher thant the overflow limit.");
        require(bytes(_currency).length > 0, "Currency is empty");
        pullPayments[_paymentDetails[0]].paymentIds[0] = keccak256(abi.encodePacked(_paymentDetails, _addresses, _paymentAmounts, _paymentTimestamps));	//inject HASH WITH MUL VAR LEN ARG
        pullPayments[_paymentDetails[0]].paymentType = keccak256(abi.encodePacked(_paymentDetails, _addresses, _paymentAmounts, _paymentTimestamps));	//inject HASH WITH MUL VAR LEN ARG
        pullPayments[_paymentDetails[0]].executorAddress = _addresses[1];
        pullPayments[_paymentDetails[0]].treasuryAddress = _addresses[2];
        pullPayments[_paymentDetails[0]].initialConversionRate = _paymentAmounts[0];
        pullPayments[_paymentDetails[0]].fiatAmountInCents = _paymentAmounts[1];
        pullPayments[_paymentDetails[0]].initialPaymentAmountInCents = _paymentAmounts[2];
        pullPayments[_paymentDetails[0]].frequency = _paymentTimestamps[0];
        pullPayments[_paymentDetails[0]].numberOfPayments = _paymentTimestamps[1];
        pullPayments[_paymentDetails[0]].startTimestamp = _paymentTimestamps[2];
        pullPayments[_paymentDetails[0]].trialPeriod = _paymentTimestamps[3];
        pullPayments[_paymentDetails[0]].currency = _currency;
        require(isValidRegistration(
                v,
                r,
                s,
                _addresses[0],
                pullPayments[_paymentDetails[0]]),
            "Invalid pull payment registration - ECRECOVER_FAILED"
        );
        pullPayments[_paymentDetails[0]].paymentIds[1] = keccak256(abi.encodePacked(_paymentDetails, _addresses, _paymentAmounts, _paymentTimestamps));	//inject HASH WITH MUL VAR LEN ARG
        pullPayments[_paymentDetails[0]].paymentIds[2] = keccak256(abi.encodePacked(_paymentDetails, _addresses, _paymentAmounts, _paymentTimestamps));	//inject HASH WITH MUL VAR LEN ARG
        pullPayments[_paymentDetails[0]].cancelTimestamp = 0;
        /// @dev In case of a free trial period the start timestamp of the payment
        /// is the start timestamp that was signed by the customer + the trial period.
        /// A payment is not needed during registration.
        if (_paymentDetails[3] == TYPE_PULL_PAYMENT_WITH_FREE_TRIAL) {
            pullPayments[_paymentDetails[0]].nextPaymentTimestamp = _paymentTimestamps[2] + _paymentTimestamps[3];
            pullPayments[_paymentDetails[0]].lastPaymentTimestamp = 0;
            /// @dev In case of a recurring payment with initial amount
            /// the first payment of the 'initialPaymentAmountInCents' and 'initialConversionRate'
            /// will happen on registration.
            /// Once it happens, we set the next payment timestamp as
            /// the start timestamp signed by the customer + trial period
        } else if (_paymentDetails[3] == TYPE_RECURRING_PULL_PAYMENT_WITH_INITIAL) {
            require(executePullPaymentOnRegistration(
                    [_paymentDetails[0], _paymentDetails[1], _paymentDetails[2]], // 0 paymentID, 1 businessID, 2 uniqueReferenceID
                    [_addresses[0], _addresses[1], _addresses[2]], // 0 Customer Address, 1 executor Address, 2 Treasury Address
                    [_paymentAmounts[2], _paymentAmounts[0]] // 0 initialPaymentAmountInCents, 1 initialConversionRate
                ));
            pullPayments[_paymentDetails[0]].lastPaymentTimestamp = now;
            pullPayments[_paymentDetails[0]].nextPaymentTimestamp = _paymentTimestamps[2] + _paymentTimestamps[0];
            /// @dev In the case od a paid trial, the first payment happens
            /// on registration using the 'initialPaymentAmountInCents' and 'initialConversionRate'.
            /// When the first payment takes place we set the next payment timestamp
            /// as the start timestamp that was signed by the customer + the trial period
        } else if (_paymentDetails[3] == TYPE_PULL_PAYMENT_WITH_PAID_TRIAL) {
            require(executePullPaymentOnRegistration(
                    [_paymentDetails[0], _paymentDetails[1], _paymentDetails[2]], /// paymentID , businessID , uniqueReferenceID
                    [_addresses[0], _addresses[1], _addresses[2]], // 0 Customer Address, 1 executor Address, 2 Treasury Address
                    [_paymentAmounts[2], _paymentAmounts[0]] /// 0 initialPaymentAmountInCents, 1 initialConversionRate
                ));
            pullPayments[_paymentDetails[0]].lastPaymentTimestamp = now;
            pullPayments[_paymentDetails[0]].nextPaymentTimestamp = _paymentTimestamps[2] + _paymentTimestamps[3];
            /// @dev For the rest of the cases the first payment happens on registration
            /// using the 'fiatAmountInCents' and 'initialConversionRate'.
            /// When the first payment takes place, the number of payment is decreased by 1,
            /// and the next payment timestamp is set to the start timestamp signed by the
            /// customer + the frequency of the payment.
        } else {
            require(executePullPaymentOnRegistration(
                    [_paymentDetails[0], _paymentDetails[1], _paymentDetails[2]], /// paymentID , businessID , uniqueReferenceID
                    [_addresses[0], _addresses[1], _addresses[2]], // 0 Customer Address, 1 executor Address, 2 Treasury Address
                    [_paymentAmounts[1], _paymentAmounts[0]] /// fiatAmountInCents, initialConversionRate
                ));
            pullPayments[_paymentDetails[0]].lastPaymentTimestamp = now;
            pullPayments[_paymentDetails[0]].nextPaymentTimestamp = _paymentTimestamps[2] + _paymentTimestamps[0];
            pullPayments[_paymentDetails[0]].numberOfPayments = _paymentTimestamps[1] - 1;
        }
        if (isFundingNeeded(msg.sender)) {
            msg.sender.transfer(FUNDING_AMOUNT);
            emit LogSmartContractActorFunded("executor", msg.sender, now);
        }
        emit LogPaymentRegistered(_addresses[0], _paymentDetails[0], _paymentDetails[1], _paymentDetails[2]);
    }
    /// @dev Deletes a pull payment for a pull payment executor - The deletion needs can be executed only by one of the
    /// executors of the PumaPay Pull Payment Contract
    /// and the PumaPay Pull Payment Contract checks that the pull payment executor and the paymentID have
    /// been singed by the customer of the account.
    /// This method sets the cancellation of the pull payment in the pull payments array for this pull payment executor specified.
    /// The balance of the executor (msg.sender) is checked and if funding is needed 0.5 ETH is transferred.
    /// Emits 'LogPaymentCancelled' with pull payment executor address and paymentID.
    /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
    /// @param r - R output of ECDSA signature.
    /// @param s - S output of ECDSA signature.
    /// @param _paymentID - ID of the payment.
    /// @param _customerAddress - customer address that is linked to this pull payment.
    /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
    function deletePullPayment(
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _paymentID,
        address _customerAddress,
        address _pullPaymentExecutor
    )
    public
    isExecutor()
    paymentExists(_paymentID)
    paymentNotCancelled(_paymentID)
    isValidDeletionRequest(_paymentID, _customerAddress)
    {
        require(isValidDeletion(v, r, s, _paymentID, _customerAddress, _pullPaymentExecutor), "Invalid deletion - ECRECOVER_FAILED.");
        pullPayments[_paymentID].cancelTimestamp = now;
        if (isFundingNeeded(msg.sender)) {
            msg.sender.transfer(FUNDING_AMOUNT);
            emit LogSmartContractActorFunded("executor", msg.sender, now);
        }
        emit LogPaymentCancelled(
            _customerAddress,
            _paymentID,
            pullPayments[_paymentID].paymentIds[1],
            pullPayments[_paymentID].paymentIds[2]
        );
    }
    /// ===============================================================================================================
    ///                                      Public Functions
    /// ===============================================================================================================
    /// @dev Executes a pull payment for the msg.sender - The pull payment should exist and the payment request
    /// should be valid in terms of when it can be executed.
    /// Emits 'LogPullPaymentExecuted' with customer address, msg.sender as the pull payment executor address and the paymentID.
    /// Use Case: Single/Recurring Fixed Pull Payment
    /// ------------------------------------------------
    /// We calculate the amount in PMA using the conversion rate specified when calling the method.
    /// From the 'conversionRate' and the 'fiatAmountInCents' we calculate the amount of PMA that
    /// the business need to receive in their treasuryAddress.
    /// The smart contract transfers from the customer account to the treasury wallet the amount in PMA.
    /// After execution we set the last payment timestamp to NOW, the next payment timestamp is incremented by
    /// the frequency and the number of payments is decreased by 1.
    /// @param _customerAddress - address of the customer from which the msg.sender requires to pull funds.
    /// @param _paymentID - ID of the payment.
    /// @param _paymentDetails - Payment details - [0] conversion rate // [1] payment Number
    function executePullPayment(address _customerAddress, bytes32 _paymentID, uint256[2] memory _paymentDetails)
    public
    paymentExists(_paymentID)
    isValidPullPaymentExecutionRequest(_paymentID, _paymentDetails[1])
    validAmount(_paymentDetails[0])
    returns (bool)
    {
        uint256 conversionRate = _paymentDetails[0];
        address customerAddress = _customerAddress;
        bytes32[3] memory paymentIds = pullPayments[_paymentID].paymentIds;
        address treasury = pullPayments[_paymentID].treasuryAddress;
        uint256 amountInPMA = calculatePMAFromFiat(pullPayments[paymentIds[0]].fiatAmountInCents, conversionRate);

        pullPayments[paymentIds[0]].nextPaymentTimestamp =
        pullPayments[paymentIds[0]].nextPaymentTimestamp + pullPayments[paymentIds[0]].frequency;
        pullPayments[paymentIds[0]].numberOfPayments = pullPayments[paymentIds[0]].numberOfPayments - 1;
        pullPayments[paymentIds[0]].lastPaymentTimestamp = now;
        require(token.transferFrom(
                customerAddress,
                treasury,
                amountInPMA
            ));
        emit LogPullPaymentExecuted(
            customerAddress,
            paymentIds[0],
            paymentIds[1],
            paymentIds[2],
            amountInPMA,
            conversionRate
        );
        return true;
    }

    /// ===============================================================================================================
    ///                                      Internal Functions
    /// ===============================================================================================================
    /// @dev The new version of the smart contract allows for the first execution to happen on registration,
    /// unless the pull payment has free trial. Check the comments on 'registerPullPayment' method for more details.
    function executePullPaymentOnRegistration(
        bytes32[3] memory _paymentDetails, // 0 paymentID, 1 businessID, 2 uniqueReferenceID
        address[3] memory _addresses, // 0 customer Address, 1, executor Address, 2 treasury Address
        uint256[2] memory _paymentAmounts // 0 _fiatAmountInCents, 1 _conversionRate
    )
    internal
    returns (bool) {
        uint256 amountInPMA = calculatePMAFromFiat(_paymentAmounts[0], _paymentAmounts[1]);
        require(token.transferFrom(_addresses[0], _addresses[2], amountInPMA));
        emit LogPullPaymentExecuted(
            _addresses[0],
            _paymentDetails[0],
            _paymentDetails[1],
            _paymentDetails[2],
            amountInPMA,
            _paymentAmounts[1]
        );
        return true;
    }

    /// @dev Calculates the PMA Rate for the fiat currency specified - The rate is set every 10 minutes by our PMA server
    /// for the currencies specified in the smart contract.
    /// @param _fiatAmountInCents - payment amount in fiat CENTS so that is always integer
    /// @param _conversionRate - conversion rate with which the payment needs to take place
    /// RATE CALCULATION EXAMPLE
    /// ------------------------
    /// RATE ==> 1 PMA = 0.01 USD$
    /// 1 USD$ = 1/0.01 PMA = 100 PMA
    /// Start the calculation from one ether - PMA Token has 18 decimals
    /// Multiply by the DECIMAL_FIXER (1e+10) to fix the multiplication of the rate
    /// Multiply with the fiat amount in cents
    /// Divide by the Rate of PMA to Fiat in cents
    /// Divide by the FIAT_TO_CENT_FIXER to fix the _fiatAmountInCents
    /// ---------------------------------------------------------------------------------------------------------------
    /// To save on gas, we have 'pre-calculated' the equation below and have set a constant in its place.
    /// ONE_ETHER.mul(DECIMAL_FIXER).div(FIAT_TO_CENT_FIXER) = RATE_CALCULATION_NUMBER
    /// ONE_ETHER = 10^18           |
    /// DECIMAL_FIXER = 10^10       |   => 10^18 * 10^10 / 100 ==> 10^26  => RATE_CALCULATION_NUMBER = 10^26
    /// FIAT_TO_CENT_FIXER = 100    |
    /// NOTE: The aforementioned value is linked to the OVERFLOW_LIMITER_NUMBER which is set to 10^20.
    /// ---------------------------------------------------------------------------------------------------------------
    function calculatePMAFromFiat(uint256 _fiatAmountInCents, uint256 _conversionRate)
    internal
    pure
    validAmount(_fiatAmountInCents)
    validAmount(_conversionRate)
    returns (uint256) {
        return RATE_CALCULATION_NUMBER.mul(_fiatAmountInCents).div(_conversionRate);
    }
    /// @dev Checks if a registration request is valid by comparing the v, r, s params
    /// and the hashed params with the customer address.
    /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
    /// @param r - R output of ECDSA signature.
    /// @param s - S output of ECDSA signature.
    /// @param _customerAddress - customer address that is linked to this pull payment.
    /// @param _pullPayment - pull payment to be validated.
    /// @return bool - if the v, r, s params with the hashed params match the customer address
    function isValidRegistration(
        uint8 v,
        bytes32 r,
        bytes32 s,
        address _customerAddress,
        PullPayment memory _pullPayment
    )
    internal
    pure
    returns (bool)
    {
        return ecrecover(
            keccak256(
                abi.encodePacked(
                    _pullPayment.executorAddress,
                    _pullPayment.paymentIds[0],
                    _pullPayment.paymentType,
                    _pullPayment.treasuryAddress,
                    _pullPayment.currency,
                    _pullPayment.initialPaymentAmountInCents,
                    _pullPayment.fiatAmountInCents,
                    _pullPayment.frequency,
                    _pullPayment.numberOfPayments,
                    _pullPayment.startTimestamp,
                    _pullPayment.trialPeriod
                )
            ),
            v, r, s) == _customerAddress;
    }
    /// @dev Checks if a deletion request is valid by comparing the v, r, s params
    /// and the hashed params with the customer address.
    /// @param v - recovery ID of the ETH signature. - https://github.com/ethereum/EIPs/issues/155
    /// @param r - R output of ECDSA signature.
    /// @param s - S output of ECDSA signature.
    /// @param _paymentID - ID of the payment.
    /// @param _customerAddress - customer address that is linked to this pull payment.
    /// @param _pullPaymentExecutor - address that is allowed to execute this pull payment.
    /// @return bool - if the v, r, s params with the hashed params match the customer address
    function isValidDeletion(
        uint8 v,
        bytes32 r,
        bytes32 s,
        bytes32 _paymentID,
        address _customerAddress,
        address _pullPaymentExecutor
    )
    internal
    view
    returns (bool)
    {
        return ecrecover(
            keccak256(
                abi.encodePacked(
                    _paymentID,
                    _pullPaymentExecutor
                )
            ), v, r, s) == _customerAddress
        && keccak256(
            abi.encodePacked(pullPayments[_paymentID].paymentIds[0])
        ) == keccak256(abi.encodePacked(_paymentID)
        );
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