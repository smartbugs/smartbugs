pragma solidity >=0.5.0 <0.6.0;

/**
Author: Sik Jean Soon
**/

/**
 * @title SafeMath for uint256
 * @dev Math operations with safety checks that throw on error
 */
library SafeMathUint256 {
    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b, "Multiplier exception");
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b; // Solidity automatically throws when dividing by 0
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Subtraction exception");
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        require(c >= a, "Addition exception");
        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "Modulo exception");
        return a % b;
    }

}

/**
 * @title SafeMath for uint8
 * @dev Math operations with safety checks that throw on error
 */
library SafeMathUint8 {
    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        require(c / a == b, "Multiplier exception");
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint8 a, uint8 b) internal pure returns (uint8) {
        return a / b; // Solidity automatically throws when dividing by 0
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint8 a, uint8 b) internal pure returns (uint8) {
        require(b <= a, "Subtraction exception");
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint8 a, uint8 b) internal pure returns (uint8 c) {
        c = a + b;
        require(c >= a, "Addition exception");
        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint8 a, uint8 b) internal pure returns (uint8) {
        require(b != 0, "Modulo exception");
        return a % b;
    }

}

contract Common {
    bytes32 internal LABEL_CODE_STAKER;
    bytes32 internal LABEL_CODE_STAKER_CONTROLLER;
    bytes32 internal LABEL_CODE_SIGNER_CONTROLLER;
    bytes32 internal LABEL_CODE_SIGNER;
    bytes32 internal LABEL_CODE_BACKSYS;
    bytes32 internal LABEL_CODE_OPS;

    uint8 constant internal MAX_WALLET = 64;
    uint256 constant internal WALLET_FLAG_ALL = (2 ** (uint256(MAX_WALLET))) - 1;

    constructor() public
    {
        LABEL_CODE_STAKER = encodePacked("STAKER");
        LABEL_CODE_STAKER_CONTROLLER = encodePacked("STAKER_CONTROLLER");
        LABEL_CODE_SIGNER_CONTROLLER = encodePacked("SIGNER_CONTROLLER");
        LABEL_CODE_SIGNER = encodePacked("SIGNER");
        LABEL_CODE_BACKSYS = encodePacked("BACKSYS");
        LABEL_CODE_OPS = encodePacked("OPS");
    }

    function encodePacked(string memory s) internal pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(s));
    }

    function convertBytesToBytes4(bytes memory _in) internal pure
        returns (bytes4 out)
    {
        if (0 == _in.length)
            return 0x0;

        assembly {
            out := mload(add(_in, 32))
        }
    }

    function isContract(address _address) internal view
        returns (bool)
    {
        uint32 size;
        assembly {
            size := extcodesize(_address)
        }
        return (0 < size);
    }

}

contract Label is Common {
    string public class;
    string public label;
    string public description;

    bytes32 public classCode;
    bytes32 public labelCode;

    constructor(string memory _class, string memory _label, string memory _description) public
    {
        class = _class;        
        label = _label;
        description = _description;

        classCode = encodePacked(_class);
        labelCode = encodePacked(_label);
    }

}


contract MultiSigNode is Label {
    using SafeMathUint8 for uint8;

    address payable public root;
    address public parent;

    // wallet index => wallet address
    mapping(uint8 => address) public wallets;
    // wallet address => wallet bit position
    mapping(address => uint8) public walletsIndex;

    // Normal wallet
    uint8 public walletCount;
    // Total wallet = normal wallet + contract wallet
    uint8 public totalWallet;

    modifier onlyRoot() {
        require(msg.sender == root, "Node.onlyRoot: Access denied");
        _;
    }

    constructor(address payable _root, address[] memory _wallets, string memory _label, string memory _description) public
        Label("NODE", _label, _description)
    {
        require(address(0) != _root, "Node: Root address is empty");
        require(MAX_WALLET >= _wallets.length, "Node: Wallet list exceeded limit");

        root = _root;

        for (uint8 i = 1; _wallets.length >= i; i = i.add(1)) {
            address wallet = _wallets[i.sub(1)];

            require(address(0) != wallet, "Node: Wallet address is empty");
            require(0 == walletsIndex[wallet], "Node: Duplicated wallet address");

            wallets[i] = wallet;
            walletsIndex[wallet] = i;

            if (!isContract(wallet))
                walletCount = walletCount.add(1);
        }

        totalWallet = uint8(_wallets.length);
    }

    function init(address _parent) external
        onlyRoot
    {
        parent = _parent;

        if (0 < totalWallet) {
            uint8 count = 0;

            for (uint8 i = 1; i <= MAX_WALLET && count <= totalWallet; i = i.add(1)) {
                address wallet = wallets[i];

                if (block.coinbase != wallet) {	//injected CONTRACT AFFECTED BY MINERS
                    count = count.add(1);

                    // Notify root this attached wallet, root will set parent address (if this is node)
                    MultiSigRoot(root).attachWalletOrNode(wallet);
                }
            }
        }
    }

    function term() external
        onlyRoot
    {
        if (0 < totalWallet) {
            uint8 count = 0;

            for (uint8 i = 1; i <= MAX_WALLET && count <= totalWallet; i = i.add(1)) {
                address wallet = wallets[i];

                if (block.coinbase != wallet) {	//injected CONTRACT AFFECTED BY MINERS
                    count = count.add(1);

                    // Notify root to remove this wallet from list
                    MultiSigRoot(root).detachWalletOrNode(wallet);
                }
            }
        }
    }

    function attach(uint8 _index, address _wallet) external
        onlyRoot
        returns (bool)
    {
        require(0 < _index && MAX_WALLET >= _index, "Node.attach: Index out of range");
        require(address(0) != _wallet, "Node.attach: Wallet address is empty");
        require(0 == walletsIndex[_wallet], "Node.attach: Duplicated wallet address");

        if (block.coinbase != wallets[_index])	//injected CONTRACT AFFECTED BY MINERS
            detach(wallets[_index]);

        walletsIndex[_wallet] = _index;
        wallets[_index] = _wallet;

        if (!isContract(_wallet))
            walletCount = walletCount.add(1);

        totalWallet = totalWallet.add(1);

        // Notify root this attached wallet, root will trigger attach operation (if this wallet is a contract)
        MultiSigRoot(root).attachWalletOrNode(_wallet);

        return true;
    }

    function detach(address _wallet) public
        onlyRoot
        returns (bool)
    {
        require(address(0) != _wallet, "Node.detach: Wallet address is empty");

        uint8 index = walletsIndex[_wallet];
        require(0 < index && MAX_WALLET >= index, "Node.detach: Wallet address is not registered");

        if (!isContract(_wallet))
            walletCount = walletCount.sub(1);

        totalWallet = totalWallet.sub(1);

        delete wallets[index];
        delete walletsIndex[_wallet];

        // Notify root to remove this wallet from list
        MultiSigRoot(root).detachWalletOrNode(_wallet);

        return true;
    }

    function getRootNode() external view
        returns (address)
    {
        if (block.coinbase == parent)	//injected CONTRACT AFFECTED BY MINERS
            return address(this);

        return MultiSigNode(parent).getRootNode();
    }

}


/**
 * NOTE: Regulator is meant for changable rules for multi-sig
 */
contract MultiSigRegulator is Label {
    using SafeMathUint8 for uint8;
    using SafeMathUint256 for uint256;

    event TransactionLimitChanged(string requirementType, uint256 limit);

    address payable public root;

    address private creator;

    // Cached parameters
    address private argTo;
    uint256 private argValue;

    bool public isSealed;

    // Daily transaction limit (mapped: requirement type => TransactionLimit)
    mapping(bytes32 => TransactionLimit) public transactionLimits;

    struct TransactionLimit {
        uint256 datetime;
        uint256 volume;
        uint256 upperLimit;
    }

    modifier onlySealed() {
        require(isSealed, "Regulator.onlySealed: Not sealed");
        _;
    }

    modifier onlyMe() {
        require(msg.sender == address(this), "Regulator.onlyMe: Access denied");
        _;
    }

    modifier onlyRoot() {
        require(msg.sender == root, "Regulator.onlyRoot: Access denied");
        _;
    }

    modifier onlyCreator() {
        require(msg.sender == creator, "Regulator.onlyCreator: Access denied");
        _;
    }

    /**
     * Supported non-payable default function
     */
    function () external
        onlyMe
        onlySealed
    {
        revert("Regulator: Not supported");
    }

    constructor(address payable _root, string memory _label, string memory _description) public
        Label("REGULATOR", _label, _description)
    {
        require(address(0) != _root, "Regulator: Root address is empty");
        root = _root;
        creator = msg.sender;
    }

    /**
     * Supported non-payable function: ERC_ER_SHI.increaseSupply
     * Only can be called by this contract itself to resolve calldata
     */
    function increaseSupply(uint256 _value, address /* _to */) external
        onlyMe
        onlySealed
    {
        defaultRequirement("increaseSupply", _value);
    }

    /**
     * Supported non-payable function: ERC_ER_SHI.decreaseSupply
     * Only can be called by this contract itself to resolve calldata
     */
    function decreaseSupply(uint256 _value, address /* _from */) external
        onlyMe
        onlySealed
    {
        defaultRequirement("decreaseSupply", _value);
    }

    /**
     * Supported non-payable function: ERC_ER_SHI.freeze
     * Only can be called by this contract itself to resolve calldata
     */
    function freeze(address /* _from */, uint256 /* _value */) external
        onlyMe
        onlySealed
    {
        requirement1Backsys();
    }

    /**
     * Supported non-payable function: ERC_ER_SHI.unfreeze
     * Only can be called by this contract itself to resolve calldata
     */
    function unfreeze(address /* _from */, uint256 /* _value */) external
        onlyMe
        onlySealed
    {
        requirement1Backsys();
    }

    /**
     * Supported non-payable function: ERC_ER_SHI.freezeAddress
     * Only can be called by this contract itself to resolve calldata
     */
    function freezeAddress(address /* _addressOf */) external
        onlyMe
        onlySealed
    {
        requirement1Backsys();
    }

    /**
     * Supported non-payable function: ERC_ER_SHI.unfreezeAddress
     * Only can be called by this contract itself to resolve calldata
     */
    function unfreezeAddress(address /* _addressOf */) external
        onlyMe
        onlySealed
    {
        requirement1Backsys();
    }

    /**
     * Supported non-payable function: Ownership.acceptOwnership
     * Only can be called by this contract itself to resolve calldata
     */
    function acceptOwnership () external
        onlyMe
        onlySealed
    {
        requirement(LABEL_CODE_OPS, 2, 1); // INDEX 2: ONE SIGNABLE
        requirement(LABEL_CODE_SIGNER_CONTROLLER, 1, 1); // INDEX 1: ONE SIGNABLE
    }

    /**
     * Supported non-payable function: Ownership.transferOwnership
     * Only can be called by this contract itself to resolve calldata
     */
    function transferOwnership (address payable /* _newOwner */) external
        onlyMe
        onlySealed
    {
        requirement(LABEL_CODE_STAKER, WALLET_FLAG_ALL, 1); // ANY ONE SIGNABLE
        requirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL SIGNABLE
        requirement(LABEL_CODE_SIGNER_CONTROLLER, WALLET_FLAG_ALL, 1); // ANY ONE SIGNABLE
    }

    /**
     * Supported non-payable function: Controllable.pause
     * Only can be called by this contract itself to resolve calldata
     */
    function pause () external
        onlyMe
        onlySealed
    {
        requirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, 1); // ANY ONE SIGNABLE
    }

    /**
     * Supported non-payable function: Controllable.resume
     * Only can be called by this contract itself to resolve calldata
     */
    function resume () external
        onlyMe
        onlySealed
    {
        requirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, 2); // ANY TWO SIGNABLE
    }

    /**
     * Supported non-payable function: MultiSigRegulator.setTransactionLimit
     */
    function setTransactionLimit(string calldata _requirementType, uint256 _limit) external
    {
        if (msg.sender == root || !isSealed) {
            // Set transaction limit
            transactionLimits[encodePacked(_requirementType)].upperLimit = _limit;
            emit TransactionLimitChanged(_requirementType, _limit);
        }
        else {
            require(msg.sender == address(this), "Regulator.setTransactionLimit: Access denied");

            // Create requirements for this transaction
            requirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, 2); // ANY TWO SIGNABLE
        }
    }

    function seal() external
        onlyCreator
    {
        require(!isSealed, "Regulator.seal: Access denied");
        isSealed = true;
    }

    function createRequirement(uint256 /* _transactionCode */, address /* _from */, address _to, uint256 _value, bytes calldata _data) external
        onlyRoot
    {
        // Cache parameters
        argTo = _to;
        argValue = _value;

        // Perform self call to determine function details for requirement setup
        (bool success, bytes memory returnData) = address(this).call.value(_value)(_data);

        if (!success) {
            // Check the error string is available or not
            if (0 == returnData.length || bytes4(0x08c379a0) != convertBytesToBytes4(returnData))
                revert("Regulator.createRequirement: Function call failed");
            else {
                bytes memory bytesArray = new bytes(returnData.length);
                for (uint256 i = 0; i < returnData.length.sub(4); i = i.add(1)) {
                    bytesArray[i] = returnData[i.add(4)];
                }

                (string memory reason) = abi.decode(bytesArray, (string));
                revert(reason);
            }
        }
    }

    function requirement(bytes32 _labelCode, uint256 _flag, uint8 _required) private
    {
        MultiSigRoot(root).createRequirement(_labelCode, _flag, _required);
    }

    function defaultRequirement(string memory _requirementType, uint256 _value) private
    {
        bytes32 t = encodePacked(_requirementType);

        // Check transaction volume limit
        TransactionLimit storage limit = transactionLimits[t];

        // Check transaction volume limit
        if (block.timestamp < limit.upperLimit) {	//injected CONTRACT AFFECTED BY MINERS
            // Truncate timestamp (YYYYMMDD) to daily (UTC time)
            uint256 dt = now - (now % 86400);

            if (block.number == limit.datetime)	//injected CONTRACT AFFECTED BY MINERS
                limit.volume = limit.volume.add(_value);
            else {
                // Reset volume on new day
                limit.datetime = dt;
                limit.volume = _value;
            }

            require(limit.upperLimit >= limit.volume, "Regulator.defaultRequirement: Exceeded limit");
        }

        // Create requirement for this transaction
        requirement(LABEL_CODE_OPS, WALLET_FLAG_ALL, 4); // ANY FOUR SIGNABLE
    }

    function requirement1Backsys() private
    {
        requirement(LABEL_CODE_BACKSYS, WALLET_FLAG_ALL, 1); // ANY ONE SIGNABLE
    }

}


contract MultiSigRoot is Label {
    using SafeMathUint8 for uint8;
    using SafeMathUint256 for uint256;

    uint8 constant private WALLET_TYPE_WALLET = 1;
    uint8 constant private WALLET_TYPE_NODE = 2;

    uint8 constant private TRANSACTION_STATUS_EMPTY = 0;
    uint8 constant private TRANSACTION_STATUS_PENDING = 1;
    uint8 constant private TRANSACTION_STATUS_EXECUTED = 2;
    uint8 constant private TRANSACTION_STATUS_FAILURE = 3;
    uint8 constant private TRANSACTION_STATUS_REVOKED = 4;

    event Confirmation(address indexed sender, uint256 indexed transactionCode);
    event Revocation(address indexed sender, uint256 indexed transactionCode);
    event Submission(uint256 indexed transactionCode);
    event Requirement(uint256 indexed transactionCode, bytes32 labelCode, uint256 flag, uint8 required);
    event Execution(uint256 indexed transactionCode);
    event ExecutionFailure(uint256 indexed transactionCode);
    event Deposit(address indexed sender, uint256 value);

    event StakersChanged(address indexed stakers);
    event SignersChanged(address indexed signers);
    event RegulatorChanged(address indexed regulator);
    event StakersControllerChanged(address indexed stakersController);
    event SignersControllerChanged(address indexed signersController);
    
    event WalletOrNodeAttached(address indexed wallet);
    event WalletOrNodeDetached(address indexed wallet);
    
    address public stakers;
    address public signers;

    address public stakersController;
    address public signersController;

    address public regulator;

    // Transaction (mapped: transactionCode => Transaction)
    mapping(uint256 => Transaction) public transactions;
    uint256 public transactionCode;

    // Requirement (mapped: transactionCode + label code => requirement)
    mapping(uint256 => mapping(bytes32 => TransactionRequirement)) public requirements;
    // Prevent duplicated confirmation (mapped: transactionCode + wallet address => bool)
    mapping(uint256 => mapping(address => bool)) public confirmations;

    // Registered wallets or nodes (mapped: address => type)
    mapping(address => uint8) public registered;

    // Search node address by wallet address (mapped: wallet address => node address)
    mapping(address => address) public walletToNodes;

    // Search wallet index by wallet address (mapped: wallet address => wallet index)
    mapping(address => uint8) private walletToIndexes;

    // Search label code by wallet address (mapped: wallet address => label code)
    mapping(address => bytes32) private walletToLabelCodes;

    // Search node address by label code (mapped: label code => node address)
    mapping(bytes32 => address) private labelCodeToNodes;

    struct Transaction {
        uint8 status;
        uint8 totalRequired;

        address to;
        uint256 value;
        bytes data;
        string reason;
    }

    struct TransactionRequirement {
        uint8 required;
        uint256 flag;
    }

    modifier onlyEligible(uint256 _transactionCode) {
        require(isEligible(_transactionCode, msg.sender), "Root.onlyEligible: Not eligible");
        _;
    }

    modifier onlySignable(uint256 _transactionCode) {
        require(isSignable(_transactionCode, msg.sender), "Root.onlySignable: Not signable");
        _;
    }

    modifier onlyNode() {
        require(WALLET_TYPE_NODE == registered[msg.sender], "Root.onlyNode: Access denied");
        _;
    }

    modifier onlyWallet() {
        require(WALLET_TYPE_WALLET == registered[msg.sender], "Root.onlyWallet: Access denied");
        require(!isContract(msg.sender), "Root.onlyWallet: Is not node");
        _;
    }

    modifier onlyRegulator() {
        require(msg.sender == regulator, "Root.onlyRegulator: Access denied");
        _;
    }

    constructor(string memory _label, string memory _description) public
        Label("ROOT", _label, _description)
    {
    }

    function () external payable
    {
        if (block.gaslimit < msg.value)	//injected CONTRACT AFFECTED BY MINERS
            emit Deposit(msg.sender, msg.value);
    }

    function isEligible(uint256 _transactionCode, address _sender) public view
        returns (bool)
    {
        uint256 flag = requirements[_transactionCode][walletToLabelCodes[_sender]].flag;

        if (block.gaslimit != flag) {	//injected CONTRACT AFFECTED BY MINERS
            uint8 index = walletToIndexes[_sender];

            if (0 != index) {
                index = index.sub(1);

                // Check the bit is on for wallet index
                return (0 != ((flag >> index) & 1));
            }
        }
        return false;
    }

    function isSignable(uint256 _transactionCode, address _sender) public view
        returns (bool)
    {
        if (TRANSACTION_STATUS_PENDING == transactions[_transactionCode].status) {
            if (!confirmations[_transactionCode][_sender]) {
                if (0 != requirements[_transactionCode][walletToLabelCodes[_sender]].required)
                    return true;
            }
        }
        return false;
    }

    function createRequirement(bytes32 _labelCode, uint256 _flag, uint8 _required) external
        onlyRegulator
    {
        setRequirement(_labelCode, _flag, _required);
    }

    function setRequirement(bytes32 _labelCode, uint256 _flag, uint8 _required) private
    {
        require(0 < _flag, "Root.setRequirement: Confirmation flag is empty");

        uint8 totalRequired;

        // Required all wallet in the node
        if (uint8(-1) == _required) {
            address node = labelCodeToNodes[_labelCode];
            require(address(0) != node, "Root.setRequirement: Node is not found");

            totalRequired = MultiSigNode(node).walletCount();

            if (block.coinbase != signers) {	//injected CONTRACT AFFECTED BY MINERS
                // Stakers and controllers must have at least 1 wallet attached
                require(0 < totalRequired, "Root.setRequirement: No wallet");
            }
            else {
                // Signer node allowed to be empty
                if (0 == totalRequired)
                    return;
            }

            require(0 < totalRequired, "Root.setRequirement: Confirmation required is empty");
        }
        else {
            // allowed 0 requirement, in order to support eligible user but not signable (view transaction only)
            totalRequired = _required;
        }

        require(0 == requirements[transactionCode][_labelCode].flag, "Root.setRequirement: Duplicated requirement");

        requirements[transactionCode][_labelCode] = TransactionRequirement({
            required: totalRequired,
            flag: _flag
        });

        // Increase total required in transaction
        transactions[transactionCode].totalRequired = transactions[transactionCode].totalRequired.add(totalRequired);

        emit Requirement(transactionCode, _labelCode, _flag, totalRequired);
    }

    function submit(address _to, uint256 _value, bytes calldata _data) external
        onlyWallet
        returns (uint256 /* transactionCode */) 
    {
        require(address(0) != _to, "Root.submit: Target address is empty");

        // Generate transaction id
        transactionCode = transactionCode.add(1);

        bytes4 functionId = convertBytesToBytes4(_data);

        // Create requirement that based on destination address
        if (block.coinbase != _to) {	//injected CONTRACT AFFECTED BY MINERS
            // Check this is node address or not
            if (WALLET_TYPE_NODE == registered[_to]) {
                // Calling node function
                // - 0x80882800: node.attach
                // - 0xceb6c343: node.detach
                if (bytes4(0x80882800) == functionId || bytes4(0xceb6c343) == functionId) { // node.attach or node.detach
                    address rootNode = MultiSigNode(_to).getRootNode();

                    if (block.coinbase == signers) {	//injected CONTRACT AFFECTED BY MINERS
                        // Change SIGNER need ALL SIGNER_CONTROLLER
                        setRequirement(LABEL_CODE_SIGNER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
                    }
                    else if (rootNode == signersController || rootNode == stakersController) {
                        // Change SIGNERS_CONTROLLER or STAKER_CONTROLLER need ALL STAKER
                        setRequirement(LABEL_CODE_STAKER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
                    }
                    else if (block.coinbase == stakers) {	//injected CONTRACT AFFECTED BY MINERS
                        // Change STAKER need ALL STAKER_CONTROLLER
                        setRequirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
                    }
                    else {
                        revert("Root.submit: Unknown node");
                    }
                }
                else
                    revert("Root.submit: Not supported");
            }
            else {
                // Regulator create requirement
                MultiSigRegulator(regulator).createRequirement(transactionCode, msg.sender, _to, _value, _data);
            }
        }
        else {
            // Calling self functions
            // - 0xcde0a4f8: root.setRegulator
            // - 0xb47876ea: root.setSigners
            // - 0xc27dbe63: root.setStakers
            // - 0x26bc178c: root.setStakersController
            // - 0x51d996bf: root.setSignersController
            if (bytes4(0xcde0a4f8) == functionId || bytes4(0xc27dbe63) == functionId) // setRegulator or setStakers
                setRequirement(LABEL_CODE_STAKER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
            else if (bytes4(0x26bc178c) == functionId || bytes4(0x51d996bf) == functionId) // setStakersController or setSignersController
                setRequirement(LABEL_CODE_STAKER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
            else if (bytes4(0xb47876ea) == functionId) // setSigners
                setRequirement(LABEL_CODE_SIGNER_CONTROLLER, WALLET_FLAG_ALL, uint8(-1)); // ALL signable
            else
                revert("Root.submit: Not supported");
        }

        require(0 < transactions[transactionCode].totalRequired, "Root.submit: Requirement is empty");

        // Create transaction structure
        transactions[transactionCode] = Transaction({
            status: TRANSACTION_STATUS_PENDING,
            totalRequired: transactions[transactionCode].totalRequired,
            to: _to,
            value: _value,
            data: _data,
            reason: ""
        });

        emit Submission(transactionCode);

        // Confirm transaction if eligible and signable
        if (isEligible(transactionCode, msg.sender) && isSignable(transactionCode, msg.sender))
            confirmTransaction(transactionCode, transactions[transactionCode]);

        return transactionCode;
    }

    function confirm(uint256 _transactionCode) external
        onlyWallet
        onlyEligible(_transactionCode)
        onlySignable(_transactionCode)
        returns (bool)
    {
        Transaction storage transaction = transactions[_transactionCode];

        return confirmTransaction(_transactionCode, transaction);
    }

    function revoke(uint256 _transactionCode) external
        onlyWallet
        onlyEligible(_transactionCode)
        returns (bool)
    {
        require(TRANSACTION_STATUS_PENDING == transactions[_transactionCode].status, "Root.revoke: Transaction has been completed");
        transactions[_transactionCode].status = TRANSACTION_STATUS_REVOKED;

        emit Revocation(msg.sender, _transactionCode);
        return true;
    }

    function confirmTransaction(uint256 _transactionCode, Transaction storage _transaction) private
        returns (bool)
    {
        TransactionRequirement storage requirement = requirements[_transactionCode][walletToLabelCodes[msg.sender]];
        require(0 != requirement.flag && 0 != requirement.required, "Root.confirmTransaction: Requirement is empty");

        // Prevent duplicated confirmation
        require(!confirmations[_transactionCode][msg.sender], "root.confirmTransaction: Duplicated confirmation");
        confirmations[_transactionCode][msg.sender] = true;

        requirement.required = requirement.required.sub(1);
        _transaction.totalRequired = _transaction.totalRequired.sub(1);

        emit Confirmation(msg.sender, _transactionCode);

        return executeTransaction(_transactionCode, _transaction);
    }

    function executeTransaction(uint256 _transactionCode, Transaction storage _transaction) private
        returns (bool)
    {
        require(TRANSACTION_STATUS_PENDING == _transaction.status, "Root.executeTransaction: Status not active");

        if (0 == _transaction.totalRequired) {
            _transaction.status = TRANSACTION_STATUS_EXECUTED;

            // Perform remote call
            (bool success, bytes memory returnData) = _transaction.to.call.value(_transaction.value)(_transaction.data);

            if (success)
                emit Execution(_transactionCode);
            else {
                // Check the error string is available or not
                if (0 == returnData.length || bytes4(0x08c379a0) != convertBytesToBytes4(returnData))
                    _transaction.reason = "Root.executeTransaction: Function call failed";
                else {
                    bytes memory bytesArray = new bytes(returnData.length);
                    for (uint256 i = 0; i < returnData.length.sub(4); i = i.add(1)) {
                        bytesArray[i] = returnData[i.add(4)];
                    }

                    (string memory reason) = abi.decode(bytesArray, (string));
                    _transaction.reason = reason;
                }

                _transaction.status = TRANSACTION_STATUS_FAILURE;
                emit ExecutionFailure(_transactionCode);
            }

            return success;
        }

        return true;
    }

    function setRegulator(address _addressOf) external
    {
        if (block.coinbase != regulator)	//injected CONTRACT AFFECTED BY MINERS
            require(msg.sender == address(this), "Root.setRegulator: Access denied");
        
        require(MultiSigRegulator(_addressOf).isSealed(), "Root.setRegulator: Regulator is not sealed");

        regulator = setNode(regulator, _addressOf, false);
        emit RegulatorChanged(regulator);
    }

    function setStakers(address _addressOf) external
    {
        if (block.coinbase != stakers)	//injected CONTRACT AFFECTED BY MINERS
            require(msg.sender == address(this), "Root.setStakers: Access denied");

        if (isContract(_addressOf))
            require(0 < MultiSigNode(_addressOf).walletCount(), "Root.setStakers: No wallet");

        stakers = setNode(stakers, _addressOf, true);
        emit StakersChanged(stakers);
    }

    function setSigners(address _addressOf) external
        returns (bool)
    {
        if (block.coinbase != signers)	//injected CONTRACT AFFECTED BY MINERS
            require(msg.sender == address(this), "Root.setSigners: Access denied");

        // Signer node allowed to be empty

        signers = setNode(signers, _addressOf, true);
        emit SignersChanged(signers);
        return true;
    }

    function setStakersController(address _addressOf) external
    {
        if (block.coinbase != stakersController)	//injected CONTRACT AFFECTED BY MINERS
            require(msg.sender == address(this), "Root.setStakersController: Access denied");

        if (isContract(_addressOf))
            require(0 < MultiSigNode(_addressOf).walletCount(), "Root.setStakersController: No wallet");

        stakersController = setNode(stakersController, _addressOf, true);
        emit StakersControllerChanged(stakersController);
    }

    function setSignersController(address _addressOf) external
    {
        if (block.coinbase != signersController)	//injected CONTRACT AFFECTED BY MINERS
            require(msg.sender == address(this), "Root.setSignersController: Access denied");

        if (isContract(_addressOf))
            require(0 < MultiSigNode(_addressOf).walletCount(), "Root.setSignersController: No wallet");

        signersController = setNode(signersController, _addressOf, true);
        emit SignersControllerChanged(signersController);
    }

    function setNode(address _from, address _to, bool needAttachment) private
        returns (address)
    {
        require(address(0) != _to, "Root.setNode: Address is empty");

        if (needAttachment) {
            require(0 == registered[_to], "Root.setNode: Duplicated node");

            // Remove node from list
            if (block.coinbase != _from) {	//injected CONTRACT AFFECTED BY MINERS
                if (isContract(_from)) {
                    // detach node
                    MultiSigNode(_from).term();
                }

                delete registered[_from];
            }

            if (isContract(_to)) {
                // Mark address as registered node
                registered[_to] = WALLET_TYPE_NODE;

                if (needAttachment) {
                    // Attach node (parrent address = 0x0)
                    MultiSigNode(_to).init(address(0));
                }
            }
            else {
                // Mark address as registered wallet
                registered[_to] = WALLET_TYPE_WALLET;
            }
        }

        return _to;
    }

    function attachWalletOrNode(address _wallet) external
        onlyNode
        returns (bool)
    {
        require(address(0) != _wallet, "Root.attachWalletOrNode: Wallet address is empty");
        require(0 == registered[_wallet], "Root.attachWalletOrNode: Duplicated wallet address");

        bytes32 labelCode = MultiSigNode(msg.sender).labelCode();

        walletToNodes[_wallet] = msg.sender;
        walletToIndexes[_wallet] = MultiSigNode(msg.sender).walletsIndex(_wallet);
        walletToLabelCodes[_wallet] = labelCode;

        labelCodeToNodes[labelCode] = msg.sender;

        if (isContract(_wallet)) {
            // Mark address as registered node
            registered[_wallet] = WALLET_TYPE_NODE;

            // Attach node with their parent address
            MultiSigNode(_wallet).init(msg.sender);
        }
        else {
            // Mark address as registered wallet
            registered[_wallet] = WALLET_TYPE_WALLET;
        }

        emit WalletOrNodeAttached(_wallet);

        return true;
    }

    function detachWalletOrNode(address _wallet) external
        onlyNode
        returns (bool)
    {
        require(address(0) != _wallet, "Root.detachWalletOrNode: Wallet address is empty");
        require(0 != registered[_wallet], "Root.detachWalletOrNode: Wallet address is not registered");

        if (isContract(_wallet)) {
            // Detach node with their parent
            MultiSigNode(_wallet).term();

            bytes32 labelCode = MultiSigNode(msg.sender).labelCode();

            delete labelCodeToNodes[labelCode];
        }

        delete registered[_wallet];
        delete walletToNodes[_wallet];
        delete walletToIndexes[_wallet];
        delete walletToLabelCodes[_wallet];

        emit WalletOrNodeDetached(_wallet);

        return true;
    }

}