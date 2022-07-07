/**
 *Submitted for verification at Etherscan.io on 2020-02-10
*/

// File: contracts/commons/Ownable.sol

pragma solidity ^0.5.16;


contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/commons/Wallet.sol

pragma solidity ^0.5.16;



contract Wallet is Ownable {
    function execute(
        address payable _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyOwner returns (bool, bytes memory) {
        return _to.call.value(_value)(_data);
    }
}

// File: contracts/commons/Pausable.sol

pragma solidity ^0.5.16;



contract Pausable is Ownable {
    bool public paused;

    event SetPaused(bool _paused);

    constructor() public {
        emit SetPaused(false);
    }

    modifier notPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
        emit SetPaused(_paused);
    }
}

// File: contracts/interfaces/ERC20.sol

pragma solidity ^0.5.16;


interface ERC20 {
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function increaseApproval (address _spender, uint _addedValue) external returns (bool success);
    function balanceOf(address _owner) external view returns (uint256 balance);
}

// File: contracts/interfaces/Model.sol

pragma solidity ^0.5.11;


/**
    The abstract contract Model defines the whole lifecycle of a debt on the DebtEngine.

    Models can be used without previous approbation, this is meant
    to avoid centralization on the development of RCN; this implies that not all models are secure.
    Models can have back-doors, bugs and they have not guarantee of being autonomous.

    The DebtEngine is meant to be the User of this model,
    so all the methods with the ability to perform state changes should only be callable by the DebtEngine.

    All models should implement the 0xaf498c35 interface.

    @author Agustin Aguilar
*/
contract Model {
    // ///
    // Events
    // ///

    /**
        @dev This emits when create a new debt.
    */
    event Created(bytes32 indexed _id);

    /**
        @dev This emits when the status of debt change.

        @param _timestamp Timestamp of the registry
        @param _status New status of the registry
    */
    event ChangedStatus(bytes32 indexed _id, uint256 _timestamp, uint256 _status);

    /**
        @dev This emits when the obligation of debt change.

        @param _timestamp Timestamp of the registry
        @param _debt New debt of the registry
    */
    event ChangedObligation(bytes32 indexed _id, uint256 _timestamp, uint256 _debt);

    /**
        @dev This emits when the frequency of debt change.

        @param _timestamp Timestamp of the registry
        @param _frequency New frequency of each installment
    */
    event ChangedFrequency(bytes32 indexed _id, uint256 _timestamp, uint256 _frequency);

    /**
        @param _timestamp Timestamp of the registry
    */
    event ChangedDueTime(bytes32 indexed _id, uint256 _timestamp, uint256 _status);

    /**
        @param _timestamp Timestamp of the registry
        @param _dueTime New dueTime of each installment
    */
    event ChangedFinalTime(bytes32 indexed _id, uint256 _timestamp, uint64 _dueTime);

    /**
        @dev This emits when the call addDebt function.

        @param _amount New amount of the debt, old amount plus added
    */
    event AddedDebt(bytes32 indexed _id, uint256 _amount);

    /**
        @dev This emits when the call addPaid function.

        If the registry is fully paid on the call and the amount parameter exceeds the required
            payment amount, the event emits the real amount paid on the payment.

        @param _paid Real amount paid
    */
    event AddedPaid(bytes32 indexed _id, uint256 _paid);

    // Model interface selector
    bytes4 internal constant MODEL_INTERFACE = 0xaf498c35;

    uint256 public constant STATUS_ONGOING = 1;
    uint256 public constant STATUS_PAID = 2;
    uint256 public constant STATUS_ERROR = 4;

    // ///
    // Meta
    // ///

    /**
        @return Identifier of the model
    */
    function modelId() external view returns (bytes32);

    /**
        Returns the address of the contract used as Descriptor of the model

        @dev The descriptor contract should follow the ModelDescriptor.sol scheme

        @return Address of the descriptor
    */
    function descriptor() external view returns (address);

    /**
        If called for any address with the ability to modify the state of the model registries,
            this method should return True.

        @dev Some contracts may check if the DebtEngine is
            an operator to know if the model is operative or not.

        @param operator Address of the target request operator

        @return True if operator is able to modify the state of the model
    */
    function isOperator(address operator) external view returns (bool canOperate);

    /**
        Validates the data for the creation of a new registry, if returns True the
            same data should be compatible with the create method.

        @dev This method can revert the call or return false, and both meant an invalid data.

        @param data Data to validate

        @return True if the data can be used to create a new registry
    */
    function validate(bytes calldata data) external view returns (bool isValid);

    // ///
    // Getters
    // ///

    /**
        Exposes the current status of the registry. The possible values are:

        1: Ongoing - The debt is still ongoing and waiting to be paid
        2: Paid - The debt is already paid and
        4: Error - There was an Error with the registry

        @dev This method should always be called by the DebtEngine

        @param id Id of the registry

        @return The current status value
    */
    function getStatus(bytes32 id) external view returns (uint256 status);

    /**
        Returns the total paid amount on the registry.

        @dev it should equal to the sum of all real addPaid

        @param id Id of the registry

        @return Total paid amount
    */
    function getPaid(bytes32 id) external view returns (uint256 paid);

    /**
        If the returned amount does not depend on any interactions and only on the model logic,
            the defined flag will be True; if the amount is an estimation of the future debt,
            the flag will be set to False.

        If timestamp equals the current moment, the defined flag should always be True.

        @dev This can be a gas-intensive method to call, consider calling the run method before.

        @param id Id of the registry
        @param timestamp Timestamp of the obligation query

        @return amount Amount pending to pay on the given timestamp
        @return defined True If the amount returned is fixed and can't change
    */
    function getObligation(bytes32 id, uint64 timestamp) external view returns (uint256 amount, bool defined);

    /**
        The amount required to fully paid a registry.

        All registries should be payable in a single time, even when it has multiple installments.

        If the registry discounts interest for early payment, those discounts should be
            taken into account in the returned amount.

        @dev This can be a gas-intensive method to call, consider calling the run method before.

        @param id Id of the registry

        @return amount Amount required to fully paid the loan on the current timestamp
    */
    function getClosingObligation(bytes32 id) external view returns (uint256 amount);

    /**
        The timestamp of the next required payment.

        After this moment, if the payment goal is not met the debt will be considered overdue.

            The getObligation method can be used to know the required payment on the future timestamp.

        @param id Id of the registry

        @return timestamp The timestamp of the next due time
    */
    function getDueTime(bytes32 id) external view returns (uint256 timestamp);

    // ///
    // Metadata
    // ///

    /**
        If the loan has multiple installments returns the duration of each installment in seconds,
            if the loan has not installments it should return 1.

        @param id Id of the registry

        @return frequency Frequency of each installment
    */
    function getFrequency(bytes32 id) external view returns (uint256 frequency);

    /**
        If the loan has multiple installments returns the total of installments,
            if the loan has not installments it should return 1.

        @param id Id of the registry

        @return installments Total of installments
    */
    function getInstallments(bytes32 id) external view returns (uint256 installments);

    /**
        The registry could be paid before or after the date, but the debt will always be
            considered overdue if paid after this timestamp.

        This is the estimated final payment date of the debt if it's always paid on each exact dueTime.

        @param id Id of the registry

        @return timestamp Timestamp of the final due time
    */
    function getFinalTime(bytes32 id) external view returns (uint256 timestamp);

    /**
        Similar to getFinalTime returns the expected payment remaining if paid always on the exact dueTime.

        If the model has no interest discounts for early payments,
            this method should return the same value as getClosingObligation.

        @param id Id of the registry

        @return amount Expected payment amount
    */
    function getEstimateObligation(bytes32 id) external view returns (uint256 amount);

    // ///
    // State interface
    // ///

    /**
        Creates a new registry using the provided data and id, it should fail if the id already exists
            or if calling validate(data) returns false or throws.

        @dev This method should only be callable by an operator

        @param id Id of the registry to create
        @param data Data to construct the new registry

        @return success True if the registry was created
    */
    function create(bytes32 id, bytes calldata data) external returns (bool success);

    /**
        If the registry is fully paid on the call and the amount parameter exceeds the required
            payment amount, the method returns the real amount used on the payment.

        The payment taken should always be the same as the requested unless the registry
            is fully paid on the process.

        @dev This method should only be callable by an operator

        @param id If of the registry
        @param amount Amount to pay

        @return real Real amount paid
    */
    function addPaid(bytes32 id, uint256 amount) external returns (uint256 real);

    /**
        Adds a new amount to be paid on the debt model,
            each model can handle the addition of more debt freely.

        @dev This method should only be callable by an operator

        @param id Id of the registrya
        @param amount Debt amount to add to the registry

        @return added True if the debt was added
    */
    function addDebt(bytes32 id, uint256 amount) external returns (bool added);

    // ///
    // Utils
    // ///

    /**
        Runs the internal clock of a registry, this is used to compute the last changes on the state.
            It can make transactions cheaper by avoiding multiple calculations when calling views.

        Not all models have internal clocks, a model without an internal clock should always return false.

        Calls to this method should be possible from any address,
            multiple calls to run shouldn't affect the internal calculations of the model.

        @dev If the call had no effect the method would return False,
            that is no sign of things going wrong, and the call shouldn't be wrapped on a require

        @param id If of the registry

        @return effect True if the run performed a change on the state
    */
    function run(bytes32 id) external returns (bool effect);
}

// File: contracts/interfaces/DebtEngine.sol

pragma solidity ^0.5.16;


interface DebtEngine {
    function pay(
        bytes32 _id,
        uint256 _amount,
        address _origin,
        bytes calldata _oracleData
    ) external returns (uint256 paid, uint256 paidToken);
}

// File: contracts/interfaces/LoanManager.sol

pragma solidity ^0.5.16;




interface LoanManager {
    function token() external view returns (ERC20);
    function debtEngine() external view returns (DebtEngine);
    function getStatus(uint256 _id) external view returns (uint256);
    function getModel(uint256 _id) external view returns (Model);
    function cosign(uint256 _id, uint256 _cost) external returns (bool);
    function getCreator(uint256 _id) external view returns (address);
}

// File: contracts/interfaces/Cosigner.sol

pragma solidity ^0.5.11;



/**
    @dev Defines the interface of a standard RCN cosigner.

    The cosigner is an agent that gives an insurance to the lender in the event of a defaulted loan, the confitions
    of the insurance and the cost of the given are defined by the cosigner.

    The lender will decide what cosigner to use, if any; the address of the cosigner and the valid data provided by the
    agent should be passed as params when the lender calls the "lend" method on the engine.

    When the default conditions defined by the cosigner aligns with the status of the loan, the lender of the engine
    should be able to call the "claim" method to receive the benefit; the cosigner can define aditional requirements to
    call this method, like the transfer of the ownership of the loan.
*/
contract Cosigner {
    uint256 public constant VERSION = 2;

    /**
        @return the url of the endpoint that exposes the insurance offers.
    */
    function url() external view returns (string memory);

    /**
        @dev Retrieves the cost of a given insurance, this amount should be exact.

        @return the cost of the cosign, in RCN wei
    */
    function cost(
        LoanManager manager,
        uint256 index,
        bytes calldata data,
        bytes calldata oracleData
    )
        external view returns (uint256);

    /**
        @dev The engine calls this method for confirmation of the conditions, if the cosigner accepts the liability of
        the insurance it must call the method "cosign" of the engine. If the cosigner does not call that method, or
        does not return true to this method, the operation fails.

        @return true if the cosigner accepts the liability
    */
    function requestCosign(
        LoanManager manager,
        uint256 index,
        bytes calldata data,
        bytes calldata oracleData
    )
        external returns (bool);

    /**
        @dev Claims the benefit of the insurance if the loan is defaulted, this method should be only calleable by the
        current lender of the loan.

        @return true if the claim was done correctly.
    */
    function claim(LoanManager manager, uint256 index, bytes calldata oracleData) external returns (bool);
}

// File: contracts/RPCosignerV2.sol

pragma solidity ^0.5.16;










contract RPCosignerV2 is Cosigner, Ownable, Wallet, Pausable {
    uint256 public deltaPayment ;	//inject UNINIT LOCAL/STATE VAR

    bool public legacyEnabled ;	//inject UNINIT LOCAL/STATE VAR


    LoanManager public manager;
    DebtEngine public engine;

    mapping(address => bool) public originators;
    mapping(uint256 => bool) public liability;

    event SetOriginator(address _originator, bool _enabled);
    event SetDeltaPayment(uint256 _prev, uint256 _val);
    event SetLegacyEnabled(bool _enabled);
    event Cosigned(uint256 _id);
    event Paid(uint256 _id, uint256 _amount, uint256 _tokens);

    string private constant ERROR_PREFIX = "rpcosigner: ";

    string private constant ERROR_INVALID_MANAGER = string(abi.encodePacked(ERROR_PREFIX, "invalid loan manager"));
    string private constant ERROR_INVALID_ORIGINATOR = string(abi.encodePacked(ERROR_PREFIX, "invalid loan originator"));
    string private constant ERROR_DUPLICATED_LIABILITY = string(abi.encodePacked(ERROR_PREFIX, "duplicated liability"));
    string private constant ERROR_COSIGN_FAILED = string(abi.encodePacked(ERROR_PREFIX, "failed cosign"));
    string private constant ERROR_INVALID_LOAN_STATUS = string(abi.encodePacked(ERROR_PREFIX, "invalid loan status"));
    string private constant ERROR_LOAN_NOT_OUTSTANDING = string(abi.encodePacked(ERROR_PREFIX, "not outstanding loan"));
    string private constant ERROR_LEGACY_DISABLED = string(abi.encodePacked(ERROR_PREFIX, "legacy claim is disabled"));

    uint256 private constant LOAN_STATUS_LENT = 1;

    constructor(
        LoanManager _manager
    ) public {
        // Load cre variables
        ERC20 _token ;	//inject UNINIT LOCAL/STATE VAR

        DebtEngine tengine ;	//inject UNINIT LOCAL/STATE VAR

        // Approve token for payments
        _token.approve(address(tengine), uint(-1));
        // Save to storage
        manager = _manager;
        engine = tengine;
        // Emit initial events
        emit SetDeltaPayment(0, deltaPayment);
        emit SetLegacyEnabled(legacyEnabled);
    }

    function setOriginator(address _originator, bool _enabled) external onlyOwner {
        emit SetOriginator(_originator, _enabled);
        originators[_originator] = _enabled;
    }

    function setDeltaPayment(uint256 _delta) external onlyOwner {
        emit SetDeltaPayment(deltaPayment, _delta);
        deltaPayment = _delta;
    }

    function setLegacyEnabled(bool _enabled) external onlyOwner {
        emit SetLegacyEnabled(_enabled);
        legacyEnabled = _enabled;
    }

    function url() external view returns (string memory) {
        return "";
    }

    function cost(
        LoanManager,
        uint256,
        bytes calldata,
        bytes calldata
    ) external view returns (uint256) {
        return 0;
    }

    function requestCosign(
        LoanManager _manager,
        uint256 _index,
        bytes calldata,
        bytes calldata
    ) external notPaused returns (bool) {
        require(_manager == manager, ERROR_INVALID_MANAGER);
        require(originators[_manager.getCreator(_index)], ERROR_INVALID_ORIGINATOR);
        require(!liability[_index], ERROR_DUPLICATED_LIABILITY);
        liability[_index] = true;
        require(_manager.cosign(_index, 0), ERROR_COSIGN_FAILED);
        emit Cosigned(_index);
        return true;
    }

    function claim(
        LoanManager _manager,
        uint256 _index,
        bytes calldata _oracleData
    ) external returns (bool) {
        require(_manager == manager, ERROR_INVALID_MANAGER);
        require(_manager.getStatus(_index) == LOAN_STATUS_LENT, ERROR_INVALID_LOAN_STATUS);

        Model model ;	//inject UNINIT LOCAL/STATE VAR


        uint256 dueTime ;	//inject UNINIT LOCAL/STATE VAR

        require(dueTime + deltaPayment < now, ERROR_LOAN_NOT_OUTSTANDING);

        if (!liability[_index]) {
            require(originators[_manager.getCreator(_index)], ERROR_INVALID_ORIGINATOR);
            require(legacyEnabled, ERROR_LEGACY_DISABLED);
        }

        (uint256 paid, uint256 tokens) = engine.pay(bytes32(_index), uint(-1), address(this), _oracleData);
        emit Paid(_index, paid, tokens);
        return true;
    }
}