pragma solidity 0.5.7;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * FUNCTIONS, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address internal owner;
    address internal newOwner;

    // MODIFIERS

    /// @dev Throws if called by any account other than the owner.
    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner");
        _;
    }

    /// @dev Throws if called by any account other than the new owner.
    modifier onlyNewOwner() {
        require(msg.sender == newOwner, "Only New Owner");
        _;
    }

    modifier notNull(address _address) {
        require(_address != address(0), "Address is Null");
        _;
    }

    // CONSTRUCTOR

    /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor() public {
        owner = msg.sender;
    }

    /// @dev Allows the current owner to transfer control of the contract to a newOwner.
    /// @param _newOwner The address to transfer ownership to.
    
    function transferOwnership(address _newOwner) public notNull(_newOwner) onlyOwner {
        newOwner = _newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /// @dev Allow the new owner to claim ownership and so proving that the newOwner is valid.
    function acceptOwnership() public onlyNewOwner {
        address oldOwner = owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        newOwner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit OwnershipTransferred(oldOwner, owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // EVENTS
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
}


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {

    bool internal paused = false;

    // MODIFIERS

    /**
    * @dev Modifier to make a function callable only when the contract is not paused.
    */
    modifier whenNotPaused() {
        require(!paused, "only when not paused");
        _;
    }

    /**
    * @dev Modifier to make a function callable only when the contract is paused.
    */
    modifier whenPaused() {
        require(paused, "only when paused");
        _;
    }

    /**
    * @dev called by the owner to pause, triggers stopped state
    */
    function pause() public onlyOwner whenNotPaused {
        paused = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Pause();
    }

    /**
    * @dev called by the owner to unpause, returns to normal state
    */
    function unpause() public onlyOwner whenPaused {
        paused = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Unpause();
    }

    // EVENTS

    event Pause();

    event Unpause();
}


// Abstract contract for the full ERC 20 Token standard
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md

contract ERC20Interface {
    /// total amount of tokens
    function totalSupply() public view returns(uint256 supply);

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public view returns (uint256 balance);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    // EVENTS
    
    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // require(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // require(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract ERC20Token is Ownable, ERC20Interface {

    using SafeMath for uint256;

    mapping(address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    uint256 internal _totalSupply;
    
    // CONSTRUCTOR

    constructor(uint256 initialAmount) public {
        if (initialAmount == 0)
            return;
        balances[msg.sender] = initialAmount;
        _totalSupply = initialAmount;
        emit Transfer(address(0), msg.sender, initialAmount);
    }

    // EXTERNAL FUNCTIONS

    // PUBLIC FUNCTIONS

    function totalSupply() public view returns(uint256 supply)
    {
        return _totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success) {

        return transferInternal(msg.sender, _to, _value);
    }

    /* ALLOW FUNCTIONS */

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    *
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    */
   
    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens   
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public notNull(_spender) returns (bool success) {
        allowed[msg.sender][_spender] = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowed[_from][msg.sender], "insufficient tokens");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return transferInternal(_from, _to, _value);
    }

    /**
     * @dev Returns balance of the `_owner`.
     *
     * @param _owner   The address whose balance will be returned.
     * @return balance Balance of the `_owner`.
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // INTERNAL FUNCTIONS

    /// @notice internal send `_value` token to `_to` from `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferInternal(address _from, address _to, uint256 _value) internal notNull(_from) notNull(_to) returns (bool) {
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }   

    // PRIVATE FUNCTIONS
}

/**
 * @title Pausable token
 *
 * @dev StandardToken modified with pausable transfers.
 **/

contract PausableToken is ERC20Token, Pausable {

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
        return super.transfer(_to, _value);
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
        return super.transferFrom(_from, _to, _value);
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
        return super.approve(_spender, _value);
    }
}


// module handling minting and burning of tokens and administration of minters

contract MintableToken is PausableToken
{
    using SafeMath for uint256;

    mapping(address => bool) internal minters; // list of allowed minters

    // MODIFIERS

    modifier onlyMinter {
        require(minters[msg.sender], "Caller not minter");
        _; 
    }

    // CONSTRUCTOR

    constructor() public {
        addMinter(msg.sender);   // Set the owner as minter
    }

    // EXTERNAL FUNCTIONS

    // PUBLIC FUNCTIONS

    /// @dev  mint tokens to address
    /// @notice mint `_value` token to `_to`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be minted
    function mint(address _to, uint256 _value) public onlyMinter {
        mintInternal(_to, _value);
    }

    /// @dev add minter
    /// @notice add minter address `_newMinter`
    /// @param _newMinter The address of the minter to add
    function addMinter(address _newMinter) public notNull(_newMinter) onlyOwner {
        if (minters[_newMinter])	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            return;
        minters[_newMinter] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit AddMinter(_newMinter);
    }

    /// @dev remove minter 
    /// @notice remove minter address  `_oldMinter`
    /// @param _oldMinter The address of the minter to remove
    function removeMinter(address _oldMinter) public notNull(_oldMinter) onlyOwner {
        if (!minters[_oldMinter])	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            return;
        minters[_oldMinter] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit RemoveMinter(_oldMinter);
    }

    /// @dev check minter
    /// @notice is address `_minter` a inter
    /// @param _minter The address of the minter to check
    function isMinter(address _minter) public notNull(_minter) view returns(bool)  {
        return minters[_minter];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // INTERNAL FUNCTIONS

    /// @dev  mint tokens to address
    /// @notice mint `_value` token to `_to`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be _totalSupply
    function mintInternal(address _to, uint256 _value) internal notNull(_to) {
        balances[_to] = balances[_to].add(_value);
        _totalSupply = _totalSupply.add(_value);
        emit Transfer(address(0), _to, _value);
    }

    /// @dev burn tokens, e.g. when migrating
    /// @notice burn `_value` token from `_from`
    /// @param _from The address of the recipient
    /// @param _value The amount of token to be _totalSupply from the callers account
    function burn(address _from, uint256 _value) internal notNull(_from) {
        balances[_from] = balances[_from].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        emit Transfer(_from, address(0), _value);
    }


    // PRIVATE FUNCTIONS

    // EVENTS
    
    event AddMinter(address indexed newMinter);
    
    event RemoveMinter(address indexed oldMinter);
}

/// @dev Migration Agent Base
contract MigrationAgent is Ownable, Pausable {

    address internal migrationToContract; // the contract to migrate to
    address internal migrationFromContract; // the conttactto migate from

    // MODIFIERS
    
    modifier onlyMigrationFromContract() {
        require(msg.sender == migrationFromContract, "Only from migration contract");
        _;
    }
    // EXTERNAL FUNCTIONS

    // PUBLIC FUNCTIONS

    /// @dev set contract to migrate to 
    /// @param _toContract Then contract address to migrate to
    function startMigrateToContract(address _toContract) public onlyOwner whenPaused {
        migrationToContract = _toContract;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(MigrationAgent(migrationToContract).isMigrationAgent(), "not a migratable contract");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit StartMigrateToContract(address(this), _toContract);
    }

    /// @dev set contract to migrate from
    /// @param _fromContract Then contract address to migrate from
    function startMigrateFromContract(address _fromContract) public onlyOwner whenPaused {
        migrationFromContract = _fromContract;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(MigrationAgent(migrationFromContract).isMigrationAgent(), "not a migratable contract");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit StartMigrateFromContract(_fromContract, address(this));
    }

    /// @dev Each user calls the migrate function on the original contract to migrate the users1 tokens to the migration agent migrateFrom on the `migrationToContract` contract
    function migrate() public;   

    /// @dev migrageFrom is called from the migrating contract `migrationFromContract`
    /// @param _from The account to be migrated into new contract
    /// @param _value The token balance to be migrated
    function migrateFrom(address _from, uint256 _value) public returns(bool);

    /// @dev is a valid migration agent
    /// @return true if contract is a migratable contract
    function isMigrationAgent() public pure returns(bool) {
        return true;
    }

    // INTERNAL FUNCTIONS

    // PRIVATE FUNCTIONS

    // EVENTS

    event StartMigrateToContract(address indexed fromContract, address indexed toContract);

    event StartMigrateFromContract(address indexed fromContract, address indexed toContract);

    event MigratedTo(address indexed owner, address indexed _contract, uint256 value);

    event MigratedFrom(address indexed owner, address indexed _contract, uint256 value);
}


contract ActiveBitcoinEtherCertificate is MintableToken, MigrationAgent {

    using SafeMath for uint256;

    string constant public name = "Active Bitcoin Ether Certificate";
    string constant public symbol = "ABEC";
    uint8 constant public decimals = 5;
    string constant public version = "1.0.0.0";

    address internal redeemAddress;
    string internal description;

    // CONSTRUCTOR

    constructor(address _redeemAddress) ERC20Token(0) notNull(_redeemAddress) public {
        redeemAddress = _redeemAddress;
    }

    // EXTERNAL FUNCTIONS

    /// @notice update contract description to  `_text` 
    /// @param _text The new description
    function updateDescription(string calldata _text) external onlyMinter {
        description = _text;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // PUBLIC FUNCTIONS

    /*
        MIGRATE FUNCTIONS
     */
    // safe migrate function
    /// @dev migrageFrom is called from the migrating contract `migrationFromContract`
    /// @param _from The account to be migrated into new contract
    /// @param _value The token balance to be migrated
    function migrateFrom(address _from, uint256 _value) public onlyMigrationFromContract whenNotPaused returns(bool) {
        mintInternal(_from, _value);

        emit MigratedFrom(_from, migrationFromContract, _value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }

    /// @dev Each user calls the migrate function on the original contract to migrate the users1 tokens to the migration agent migrateFrom on the `migrationToContract` contract
    function migrate() public whenNotPaused {
        require(migrationToContract != address(0), "not in migration mode"); // revert if not in migrate mode	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 value = balanceOf(msg.sender);
        require (value > 0, "no balance"); // revert if not value left to transfer
        burn(msg.sender, value);
        require(MigrationAgent(migrationToContract).migrateFrom(msg.sender, value)==true, "migrateFrom must return true");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit MigratedTo(msg.sender, migrationToContract, value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /*
        Helper FUNCTIONS
    */

    /// @dev helper function to return foreign tokens accidental send to contract address
    /// @param _tokenaddress Address of foreign ERC20 contract
    /// @param _to Address to send foreign tokens to
    function refundForeignTokens(address _tokenaddress,address _to) public notNull(_to) onlyMinter {
        require(_tokenaddress != address(this), "Must not be self");
        ERC20Interface token = ERC20Interface(_tokenaddress);

        // transfer current balance for this contract to _to  in token contract
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(abi.encodeWithSelector(token.transfer.selector, _to, token.balanceOf(address(this))));
        require(success);

        if (returndata.length > 0) { // Return data is optional
            require(abi.decode(returndata, (bool)));
        }        
    }

    /// @notice minter transfer account tokens from one address `_from` to new token owner address `_to`. If `_to` is the redeem address then tokens will be burned 
    /// @param _from The address of the original token owner
    /// @param _to The address of the new token owner
    /// @return Whether the transfer was successful or not
    function transferAccount(address _from, address _to) public onlyMinter returns (bool result) {
        uint256 balance = balanceOf(_from);
        if(_to == redeemAddress) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            result = transferInternal(_from, _to, balance);
        } else {
            result = super.transferInternal(_from, _to, balance);
        }
        emit TransferAccount(_from, _to);
    }

    // INTERNAL FUNCTIONS

    /// @notice internal send `_value` token to `_to` from `_from` 
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred 
    /// @return Whether the transfer was successful or not
    function transferInternal(address _from, address _to, uint256 _value) internal notNull(_from) returns (bool) {
        require(_to == redeemAddress, "Wrong destination address");
        // burn _value
        balances[_from] = balances[_from].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        // report as transfer + burn 
        emit Transfer(_from, _to, _value);
        emit Transfer(_to, address(0), _value);
        return true;
    }

    // PRIVATE FUNCTIONS

    event TransferAccount(address indexed _from, address indexed _to);
}