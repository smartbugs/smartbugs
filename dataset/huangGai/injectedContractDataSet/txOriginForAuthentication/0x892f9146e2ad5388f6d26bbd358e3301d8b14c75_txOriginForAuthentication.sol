pragma solidity ^0.5.1;

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    /**
    * @dev Multiplies two numbers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "");

        return c;
    }

    /**
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "");
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "");

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "");
        return a % b;
    }
}

contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(
        address owner,
        address spender
    )
        public
        view
        returns (uint256)
    {
        return _allowed[owner][spender];
    }

    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= _balances[msg.sender], "");
        require(to != address(0), "");

        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "");

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    )
        public
        returns (bool)
    {
        require(value <= _balances[from], "");
        require(value <= _allowed[from][msg.sender], "");
        require(to != address(0), "");

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(
        address spender,
        uint256 addedValue
    )
        public
        returns (bool)
    {
        require(spender != address(0), "");

        _allowed[msg.sender][spender] = (
            _allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    )
        public
        returns (bool)
    {
        require(spender != address(0), "");

        _allowed[msg.sender][spender] = (
            _allowed[msg.sender][spender].sub(subtractedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param amount The amount that will be created.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "");
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param amount The amount that will be burnt.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "");
        require(amount <= _balances[account], "");

        _totalSupply = _totalSupply.sub(amount);
        _balances[account] = _balances[account].sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * @param account The account whose tokens will be burnt.
     * @param amount The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 amount) internal {
        require(amount <= _allowed[account][msg.sender], "");

        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
        // this function needs to emit an event with the updated approval.
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
            amount);
        _burn(account, amount);
    }
}

/**
 * @title BaseSecurityToken implementation
 * @dev see https://eips.ethereum.org/EIPS/eip-1462
 */
contract BaseSecurityToken is ERC20 {
    
    struct Document {
        bytes32 name;
        string uri;
        bytes32 contentHash;
    }

    mapping (bytes32 => Document) private documents;

    function transfer(address to, uint256 value) public returns (bool) {
        require(checkTransferAllowed(msg.sender, to, value) == STATUS_ALLOWED, "transfer must be allowed");
        return ERC20.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(checkTransferFromAllowed(from, to, value) == STATUS_ALLOWED, "transfer must be allowed");
        return ERC20.transferFrom(from, to, value);
    }

    function _mint(address account, uint256 amount) internal {
        require(checkMintAllowed(account, amount) == STATUS_ALLOWED, "mint must be allowed");
        ERC20._mint(account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(checkBurnAllowed(account, amount) == STATUS_ALLOWED, "burn must be allowed");
        ERC20._burn(account, amount);
    }

    function attachDocument(bytes32 _name, string calldata _uri, bytes32 _contentHash) external {
        require(_name.length > 0, "name of the document must not be empty");
        require(bytes(_uri).length > 0, "external URI to the document must not be empty");
        require(_contentHash.length > 0, "content hash is required, use SHA-256 when in doubt");
        require(documents[_name].name.length == 0, "document must not be existing under the same name");
        documents[_name] = Document(_name, _uri, _contentHash);
    }
   
    function lookupDocument(bytes32 _name) external view returns (string memory, bytes32) {
        Document storage doc = documents[_name];
        return (doc.uri, doc.contentHash);
    }

    // Use status codes from:
    // https://eips.ethereum.org/EIPS/eip-1066
    byte private STATUS_ALLOWED = 0x11;

    function checkTransferAllowed(address, address, uint256) public view returns (byte) {
        return STATUS_ALLOWED;
    }
   
    function checkTransferFromAllowed(address, address, uint256) public view returns (byte) {
        return STATUS_ALLOWED;
    }
   
    function checkMintAllowed(address, uint256) public view returns (byte) {
        return STATUS_ALLOWED;
    }
   
    function checkBurnAllowed(address, uint256) public view returns (byte) {
        return STATUS_ALLOWED;
    }
}

contract LockRequestable {

        // MEMBERS
        /// @notice  the count of all invocations of `generateLockId`.
        uint256 public lockRequestCount;

        constructor() public {
                lockRequestCount = 0;
        }

        // FUNCTIONS
        /** @notice  Returns a fresh unique identifier.
            *
            * @dev the generation scheme uses three components.
            * First, the blockhash of the previous block.
            * Second, the deployed address.
            * Third, the next value of the counter.
            * This ensure that identifiers are unique across all contracts
            * following this scheme, and that future identifiers are
            * unpredictable.
            *
            * @return a 32-byte unique identifier.
            */
        function generateLockId() internal returns (bytes32 lockId) {
                return keccak256(
                abi.encodePacked(blockhash(block.number - 1), address(this), ++lockRequestCount)
                );
        }
}

contract CustodianUpgradeable is LockRequestable {

        // TYPES
        /// @dev  The struct type for pending custodian changes.
        struct CustodianChangeRequest {
                address proposedNew;
        }

        // MEMBERS
        /// @dev  The address of the account or contract that acts as the custodian.
        address public custodian;

        /// @dev  The map of lock ids to pending custodian changes.
        mapping (bytes32 => CustodianChangeRequest) public custodianChangeReqs;

        constructor(address _custodian) public LockRequestable() {
                custodian = _custodian;
        }

        // MODIFIERS
        modifier onlyCustodian {
                require(tx.origin == custodian);	//inject USING TX ORIGIN FOR AUTHENTICATION

                _;
        }

        /** @notice  Requests a change of the custodian associated with this contract.
            *
            * @dev  Returns a unique lock id associated with the request.
            * Anyone can call this function, but confirming the request is authorized
            * by the custodian.
            *
            * @param  _proposedCustodian  The address of the new custodian.
            * @return  lockId  A unique identifier for this request.
            */
        function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
                require(_proposedCustodian != address(0));

                lockId = generateLockId();

                custodianChangeReqs[lockId] = CustodianChangeRequest({
                        proposedNew: _proposedCustodian
                });

                emit CustodianChangeRequested(lockId, msg.sender, _proposedCustodian);
        }

        /** @notice  Confirms a pending change of the custodian associated with this contract.
            *
            * @dev  When called by the current custodian with a lock id associated with a
            * pending custodian change, the `address custodian` member will be updated with the
            * requested address.
            *
            * @param  _lockId  The identifier of a pending change request.
            */
        function confirmCustodianChange(bytes32 _lockId) public onlyCustodian {
                custodian = getCustodianChangeReq(_lockId);

                delete custodianChangeReqs[_lockId];

                emit CustodianChangeConfirmed(_lockId, custodian);
        }

        // PRIVATE FUNCTIONS
        function getCustodianChangeReq(bytes32 _lockId) private view returns (address _proposedNew) {
                CustodianChangeRequest storage changeRequest = custodianChangeReqs[_lockId];

                // reject 1null1 results from the map lookup
                // this can only be the case if an unknown `_lockId` is received
                require(changeRequest.proposedNew != address(0));

                return changeRequest.proposedNew;
        }

        /// @dev  Emitted by successful `requestCustodianChange` calls.
        event CustodianChangeRequested(
                bytes32 _lockId,
                address _msgSender,
                address _proposedCustodian
        );

        /// @dev Emitted by successful `confirmCustodianChange` calls.
        event CustodianChangeConfirmed(bytes32 _lockId, address _newCustodian);
}

interface ServiceRegistry {
    function getService(string calldata _name) external view returns (address);
}

contract ServiceDiscovery {
    ServiceRegistry internal services;

    constructor(ServiceRegistry _services) public {
        services = ServiceRegistry(_services);
    }
}

contract KnowYourCustomer is CustodianUpgradeable {

    enum Status {
        none,
        passed,
        suspended
    }

    struct Customer {
        Status status;
        mapping(string => string) fields;
    }
    
    event ProviderAuthorized(address indexed _provider, string _name);
    event ProviderRemoved(address indexed _provider, string _name);
    event CustomerApproved(address indexed _customer, address indexed _provider);
    event CustomerSuspended(address indexed _customer, address indexed _provider);
    event CustomerFieldSet(address indexed _customer, address indexed _field, string _name);

    mapping(address => bool) private providers;
    mapping(address => Customer) private customers;

    constructor(address _custodian) public CustodianUpgradeable(_custodian) {
        customers[_custodian].status = Status.passed;
        customers[_custodian].fields["type"] = "custodian";
        emit CustomerApproved(_custodian, msg.sender);
        emit CustomerFieldSet(_custodian, msg.sender, "type");
    }

    function providerAuthorize(address _provider, string calldata name) external onlyCustodian {
        require(providers[_provider] == false, "provider must not exist");
        providers[_provider] = true;
        // cc:II. Manage Providers#2;Provider becomes authorized in contract;1;
        emit ProviderAuthorized(_provider, name);
    }

    function providerRemove(address _provider, string calldata name) external onlyCustodian {
        require(providers[_provider] == true, "provider must exist");
        delete providers[_provider];
        emit ProviderRemoved(_provider, name);
    }

    function hasWritePermissions(address _provider) external view returns (bool) {
        return _provider == custodian || providers[_provider] == true;
    }

    function getCustomerStatus(address _customer) external view returns (Status) {
        return customers[_customer].status;
    }

    function getCustomerField(address _customer, string calldata _field) external view returns (string memory) {
        return customers[_customer].fields[_field];
    }

    function approveCustomer(address _customer) external onlyAuthorized {
        Status status = customers[_customer].status;
        require(status != Status.passed, "customer must not be approved before");
        customers[_customer].status = Status.passed;
        // cc:III. Manage Customers#2;Customer becomes approved in contract;1;
        emit CustomerApproved(_customer, msg.sender);
    }

    function setCustomerField(address _customer, string calldata _field, string calldata _value) external onlyAuthorized {
        Status status = customers[_customer].status;
        require(status != Status.none, "customer must have a set status");
        customers[_customer].fields[_field] = _value;
        emit CustomerFieldSet(_customer, msg.sender, _field);
    }

    function suspendCustomer(address _customer) external onlyAuthorized {
        Status status = customers[_customer].status;
        require(status != Status.suspended, "customer must be not suspended");
        customers[_customer].status = Status.suspended;
        emit CustomerSuspended(_customer, msg.sender);
    }

    modifier onlyAuthorized() {
        require(msg.sender == custodian || providers[msg.sender] == true);
        _;
    }
}

contract TokenSettingsInterface {

    // METHODS
    function getTradeAllowed() public view returns (bool);
    function getMintAllowed() public view returns (bool);
    function getBurnAllowed() public view returns (bool);
    
    // EVENTS
    event TradeAllowedLocked(bytes32 _lockId, bool _newValue);
    event TradeAllowedConfirmed(bytes32 _lockId, bool _newValue);
    event MintAllowedLocked(bytes32 _lockId, bool _newValue);
    event MintAllowedConfirmed(bytes32 _lockId, bool _newValue);
    event BurnAllowedLocked(bytes32 _lockId, bool _newValue);
    event BurnAllowedConfirmed(bytes32 _lockId, bool _newValue);

    // MODIFIERS
    modifier onlyCustodian {
        _;
    }
}


contract _BurnAllowed is TokenSettingsInterface, LockRequestable {
    // cc:IV. BurnAllowed Setting#2;Burn Allowed Switch;1;
    //
    // SETTING: Burn Allowed Switch (bool)
    // Boundary: true or false
    //
    // Enables or disables token minting ability globally (even for custodian).
    //
    bool private burnAllowed = false;

    function getBurnAllowed() public view returns (bool) {
        return burnAllowed;
    }

    // SETTING MANAGEMENT

    struct PendingBurnAllowed {
        bool burnAllowed;
        bool set;
    }

    mapping (bytes32 => PendingBurnAllowed) public pendingBurnAllowedMap;

    function requestBurnAllowedChange(bool _burnAllowed) public returns (bytes32 lockId) {
       require(_burnAllowed != burnAllowed);
       
       lockId = generateLockId();
       pendingBurnAllowedMap[lockId] = PendingBurnAllowed({
           burnAllowed: _burnAllowed,
           set: true
       });

       emit BurnAllowedLocked(lockId, _burnAllowed);
    }

    function confirmBurnAllowedChange(bytes32 _lockId) public onlyCustodian {
        PendingBurnAllowed storage value = pendingBurnAllowedMap[_lockId];
        require(value.set == true);
        burnAllowed = value.burnAllowed;
        emit BurnAllowedConfirmed(_lockId, value.burnAllowed);
        delete pendingBurnAllowedMap[_lockId];
    }
}


contract _MintAllowed is TokenSettingsInterface, LockRequestable {
    // cc:III. MintAllowed Setting#2;Mint Allowed Switch;1;
    //
    // SETTING: Mint Allowed Switch (bool)
    // Boundary: true or false
    //
    // Enables or disables token minting ability globally (even for custodian).
    //
    bool private mintAllowed = false;

    function getMintAllowed() public view returns (bool) {
        return mintAllowed;
    }

    // SETTING MANAGEMENT

    struct PendingMintAllowed {
        bool mintAllowed;
        bool set;
    }

    mapping (bytes32 => PendingMintAllowed) public pendingMintAllowedMap;

    function requestMintAllowedChange(bool _mintAllowed) public returns (bytes32 lockId) {
       require(_mintAllowed != mintAllowed);
       
       lockId = generateLockId();
       pendingMintAllowedMap[lockId] = PendingMintAllowed({
           mintAllowed: _mintAllowed,
           set: true
       });

       emit MintAllowedLocked(lockId, _mintAllowed);
    }

    function confirmMintAllowedChange(bytes32 _lockId) public onlyCustodian {
        PendingMintAllowed storage value = pendingMintAllowedMap[_lockId];
        require(value.set == true);
        mintAllowed = value.mintAllowed;
        emit MintAllowedConfirmed(_lockId, value.mintAllowed);
        delete pendingMintAllowedMap[_lockId];
    }
}


contract _TradeAllowed is TokenSettingsInterface, LockRequestable {
    // cc:II. TradeAllowed Setting#2;Trade Allowed Switch;1;
    //
    // SETTING: Trade Allowed Switch (bool)
    // Boundary: true or false
    //
    // Enables or disables all token transfers, between any recipients, except mint and burn operations.
    //
    bool private tradeAllowed = false;

    function getTradeAllowed() public view returns (bool) {
        return tradeAllowed;
    }

    // SETTING MANAGEMENT

    struct PendingTradeAllowed {
        bool tradeAllowed;
        bool set;
    }

    mapping (bytes32 => PendingTradeAllowed) public pendingTradeAllowedMap;

    function requestTradeAllowedChange(bool _tradeAllowed) public returns (bytes32 lockId) {
       require(_tradeAllowed != tradeAllowed);
       
       lockId = generateLockId();
       pendingTradeAllowedMap[lockId] = PendingTradeAllowed({
           tradeAllowed: _tradeAllowed,
           set: true
       });

       emit TradeAllowedLocked(lockId, _tradeAllowed);
    }

    function confirmTradeAllowedChange(bytes32 _lockId) public onlyCustodian {
        PendingTradeAllowed storage value = pendingTradeAllowedMap[_lockId];
        require(value.set == true);
        tradeAllowed = value.tradeAllowed;
        emit TradeAllowedConfirmed(_lockId, value.tradeAllowed);
        delete pendingTradeAllowedMap[_lockId];
    }
}

contract TokenSettings is TokenSettingsInterface, CustodianUpgradeable,
_TradeAllowed,
_MintAllowed,
_BurnAllowed
    {
    constructor(address _custodian) public CustodianUpgradeable(_custodian) {
    }
}


/**
 * @title TokenController implements restriction logic for BaseSecurityToken.
 * @dev see https://eips.ethereum.org/EIPS/eip-1462
 */
contract TokenController is CustodianUpgradeable, ServiceDiscovery {
    constructor(address _custodian, ServiceRegistry _services) public
    CustodianUpgradeable(_custodian) ServiceDiscovery(_services) {
    }

    // Use status codes from:
    // https://eips.ethereum.org/EIPS/eip-1066
    byte private constant STATUS_ALLOWED = 0x11;

    function checkTransferAllowed(address _from, address _to, uint256) public view returns (byte) {
        require(_settings().getTradeAllowed(), "global trade must be allowed");
        require(_kyc().getCustomerStatus(_from) == KnowYourCustomer.Status.passed, "sender does not have valid KYC status");
        require(_kyc().getCustomerStatus(_to) == KnowYourCustomer.Status.passed, "recipient does not have valid KYC status");

        // TODO:
        // Check user's region
        // Check amount for transfer limits

        return STATUS_ALLOWED;
    }
   
    function checkTransferFromAllowed(address _from, address _to, uint256 _amount) external view returns (byte) {
        return checkTransferAllowed(_from, _to, _amount);
    }
   
    function checkMintAllowed(address _from, uint256) external view returns (byte) {
        require(_settings().getMintAllowed(), "global mint must be allowed");
        require(_kyc().getCustomerStatus(_from) == KnowYourCustomer.Status.passed, "recipient does not have valid KYC status");
        
        return STATUS_ALLOWED;
    }
   
    function checkBurnAllowed(address _from, uint256) external view returns (byte) {
        require(_settings().getBurnAllowed(), "global burn must be allowed");
        require(_kyc().getCustomerStatus(_from) == KnowYourCustomer.Status.passed, "sender does not have valid KYC status");

        return STATUS_ALLOWED;
    }

    function _settings() private view returns (TokenSettings) {
        return TokenSettings(services.getService("token/settings"));
    }

    function _kyc() private view returns (KnowYourCustomer) {
        return KnowYourCustomer(services.getService("validators/kyc"));
    }
}

contract BaRA is BaseSecurityToken, CustodianUpgradeable, ServiceDiscovery {
    
    uint public limit = 400 * 1e6;
    string public name = "Banksia BioPharm Security Token";
    string public symbol = "BaRA";
    uint8 public decimals = 0;

    constructor(address _custodian, ServiceRegistry _services,
        string memory _name, string memory _symbol, uint _limit) public 
        CustodianUpgradeable(_custodian) ServiceDiscovery(_services) {

        name = _name;
        symbol = _symbol;
        limit = _limit;
    }

    function mint(address _to, uint _amount) public onlyCustodian {
        require(_amount != 0, "check amount to mint");
        require(super.totalSupply() + _amount <= limit, "check total supply after mint");
        BaseSecurityToken._mint(_to, _amount);
    }

    function checkTransferAllowed (address _from, address _to, uint256 _amount) public view returns (byte) {
        return _controller().checkTransferAllowed(_from, _to, _amount);
    }
   
    function checkTransferFromAllowed (address _from, address _to, uint256 _amount) public view returns (byte) {
        return _controller().checkTransferFromAllowed(_from, _to, _amount);
    }
   
    function checkMintAllowed (address _from, uint256 _amount) public view returns (byte) {
        return _controller().checkMintAllowed(_from, _amount);
    }
   
    function checkBurnAllowed (address _from, uint256 _amount) public view returns (byte) {
        return _controller().checkBurnAllowed(_from, _amount);
    }

    function _controller() private view returns (TokenController) {
        return TokenController(services.getService("token/controller"));
    }
}