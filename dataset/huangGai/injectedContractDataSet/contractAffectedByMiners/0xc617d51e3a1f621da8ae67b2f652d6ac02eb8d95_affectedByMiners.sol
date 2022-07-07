pragma solidity ^0.5.8;


/// @title ERC20 Token Interface
/// @author Hoard Team
/// @notice See https://github.com/ethereum/EIPs/issues/20
contract ERC20Token {

    // PUBLIC INTERFACE

    // /// @dev Returns total amount of tokens
    // /// @notice params -> (uint256 totalSupply)
    // It's implamented as a variable which doesn't override this method. Commented to prevent compilation error.
    // function totalSupply    () constant public returns (uint256);

    /// @dev Returns balance of specified account
    /// @notice params -> (address _owner)
    function balanceOf      (address) view public returns (uint256);

    /// @dev  Transfers tokens from msg.sender to a specified address
    /// @notice params -> (address _to, uint256 _value)
    function transfer       (address, uint256) public returns (bool);

    /// @dev  Allowance mechanism - delegated transfer
    /// @notice params -> (address _from, address _to, uint256 _value)
    function transferFrom   (address, address, uint256) public returns (bool);

    /// @dev  Allowance mechanism - approve delegated transfer
    /// @notice params -> (address _spender, uint256 _value)
    function approve        (address, uint256) public returns (bool);

    /// @dev  Allowance mechanism - set allowance for specified address
    /// @notice params -> (address _owner, address _spender)
    function allowance      (address, address) public view returns (uint256);


    // EVENTS

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}


/// @title Safe Math
/// @author Open Zeppelin
/// @notice implementation from - https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
library SafeMath {
  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
  
  function max256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a >= b ? a : b;
  }

  function min256(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
  }

}



/// @title Standard ERC20 compliant token
/// @author Hoard Team
/// @notice Original taken from https://github.com/ethereum/EIPs/issues/20
/// @notice SafeMath used as specified by OpenZeppelin
/// @notice Comments and additional approval code from https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token
contract StandardToken is ERC20Token {

    using SafeMath for uint256;

    mapping (address => uint256) balances;

    mapping (address => mapping (address => uint256)) allowed;

    uint256 public totalSupply;

   /// @dev transfer token for a specified address
   /// @param _to The address to transfer to.
   /// @param _value The amount to be transferred.
   function transfer(address _to, uint256 _value) public returns (bool) {
        balances[msg.sender] = balances[msg.sender].safeSub(_value);
        balances[_to] = balances[_to].safeAdd(_value);

        emit Transfer(msg.sender, _to, _value);            

        return true;
    }

    /// @dev Transfer tokens from one address to another
    /// @param _from address The address which you want to send tokens from
    /// @param _to address The address which you want to transfer to
    /// @param _value uint256 the amount of tokens to be transferred
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        uint256 _allowance = allowed[_from][msg.sender];

        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
        // require (_value <= _allowance);        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {

        balances[_to] = balances[_to].safeAdd(_value);
        balances[_from] = balances[_from].safeSub(_value);
        allowed[_from][msg.sender] = _allowance.safeSub(_value);

        emit Transfer(_from, _to, _value);
            
        return true;
    }

    /// @dev Gets the balance of the specified address.
    /// @param _owner The address to query the the balance of. 
    /// @return An uint256 representing the amount owned by the passed address.
    function balanceOf(address _owner) view public returns (uint256) {
        return balances[_owner];
    }

   /// @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   /// @param _spender The address which will spend the funds.
   /// @param _value The amount of tokens to be spent.
   function approve(address _spender, uint256 _value) public returns (bool) {
        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));
        
        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

   /// @dev Function to check the amount of tokens that an owner allowed to a spender.
   /// @param _owner address The address which owns the funds.
   /// @param _spender address The address which will spend the funds.
   /// @return A uint256 specifying the amount of tokens still available for the spender.
   function allowance(address _owner, address _spender) view public returns (uint256) {
        return allowed[_owner][_spender];
    }

    /// @notice approve should be called when allowed[_spender] == 0. To increment
    /// allowed value it is better to use this function to avoid 2 calls (and wait until 
    /// the first transaction is mined)
    function increaseApproval (address _spender, uint256 _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].safeAdd(_addedValue);

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;
    }

    /// @notice approve should be called when allowed[_spender] == 0. To decrement
    /// allowed value it is better to use this function to avoid 2 calls (and wait until 
    /// the first transaction is mined)
    function decreaseApproval (address _spender, uint256 _subtractedValue) public returns (bool) {
        uint256 oldValue = allowed[msg.sender][_spender];
        
        if (block.timestamp > oldValue) {	//injected CONTRACT AFFECTED BY MINERS
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue - _subtractedValue;
        }

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;
    }

}


/// @title Migration Agent interface
/// @author Hoard Team
/// @notice Based on GNT implementation - https://github.com/golemfactory/golem-crowdfunding/blob/master/contracts/Token.sol
contract MigrationAgent {

    /// @dev migrates tokens or other "assets" from one contract to another (not yet specified)
    /// @notice parameters -> (address _from, uint _value)
    function migrateFrom(address, uint256) public;
}


/// @title Mintable token interface
/// @author Hoard Team
contract Mintable {

    /// @dev Mint new tokens  
    /// @notice params -> (address _recipient, uint256 _amount)
    function mintTokens         (address, uint256) public;
}


/// @title Migratable entity interface
/// @author Hoard Team
contract Migratable {

    /// @dev Migrates tokens for msg.sender  
    /// @notice params -> (uint256 _value)
    function migrate            (uint256) public;


    // EVENTS

    event Migrate               (address indexed _from, address indexed _to, uint256 _value);
}


/// @title Standard ERC20 compliant token
/// @author Hoard Team
contract ExtendedStandardToken is StandardToken, Migratable, Mintable {

    address public migrationAgent;
    uint256 public totalMigrated;


    // MODIFIERS

    modifier migrationAgentSet {
        require(migrationAgent != address(0));
        _;
    }

    modifier migrationAgentNotSet {
        require(migrationAgent == address(0));
        _;
    }

    /// @dev Internal constructor to prevent bare instances of this contract
    constructor () internal {
    }

    // MIGRATION LOGIC

    /// @dev Migrates tokens for msg.sender and burns them
    /// @param _value amount of tokens to migrate
    function migrate            (uint256 _value) public {

        // Validate input value
        require(_value > 0);
    
        //require(_value <= balances[msg.sender]);
        //not necessary as safeSub throws in case the above condition does not hold
    
        balances[msg.sender] = balances[msg.sender].safeSub(_value);
        totalSupply = totalSupply.safeSub(_value);
        totalMigrated = totalMigrated.safeAdd(_value);

        MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);

        emit Migrate(msg.sender, migrationAgent, _value);
    }


    // MINTING LOGIC

    /// @dev Mints additional tokens
    /// @param _recipient owner of new tokens 
    /// @param _amount amount of tokens to mint
    function mintTokens         (address _recipient, uint256 _amount) public {
        require(_amount > 0);

        balances[_recipient] = balances[_recipient].safeAdd(_amount);
        totalSupply = totalSupply.safeAdd(_amount);

        // Log token creation event
        emit Transfer(address(0), msg.sender, _amount);
    }


    // CONTROL LOGIC

    /// @dev Sets address of a new migration agent
    /// @param _address address of new migration agent 
    function setMigrationAgent  (address _address) public {
        migrationAgent = _address; 
    }

}



/// @title Hoard Token (HRD) - crowdfunding code for Hoard token
/// @author Hoard Team
/// @notice Based on MLN implementation - https://github.com/melonproject/melon/blob/master/contracts/tokens/MelonToken.sol
/// @notice Based on GNT implementation - https://github.com/golemfactory/golem-crowdfunding/blob/master/contracts/Token.sol
contract HoardToken is ExtendedStandardToken {

    // Token description fields
    string public constant name = "Hoard Token";
    string public constant symbol = "HRD";
    uint256 public constant decimals = 18;  // 18 decimal places, the same as ETH

    // contract supervision variables
    address public creator;
    address public hoard;
    address public migrationMaster;


    // MODIFIERS

    modifier onlyCreator {
        require(msg.sender == creator);
        _;
    }

    modifier onlyHoard {
        require(msg.sender == hoard);
        _;
    }

    modifier onlyMigrationMaster {
        require(msg.sender == migrationMaster);
        _;
    }

    // CONSTRUCTION

    /// @param _hoard Hoard multisig contract
    /// @param _migrationMaster migration master
    constructor (address _hoard, address _migrationMaster) public {
        require(_hoard != address(0));
        require(_migrationMaster != address(0));

        creator = msg.sender;
        hoard = _hoard;
        migrationMaster = _migrationMaster;
    }


    // BASE CLASS IMPLEMENTATION

    /// @notice ExtendedStandardToken is StandardToken
    function transfer               (address _to, uint256 _value) public
        returns (bool) 
    {
        return super.transfer(_to, _value);
    }


    /// @notice ExtendedStandardToken is StandardToken
    function transferFrom           (address _from, address _to, uint256 _value) public 
        returns (bool)
    {
        return super.transferFrom(_from, _to, _value);
    }


    /// @notice ExtendedStandardToken is Migratable
    function migrate                (uint256 _value) public migrationAgentSet {
        super.migrate(_value);    
    }

    /// @notice ExtendedStandardToken
    function setMigrationAgent      (address _address) public onlyMigrationMaster migrationAgentNotSet {
        require(_address != address(0));

        super.setMigrationAgent(_address);
    }

    /// @notice ExtendedStandardToken is Mintable
    function mintTokens             (address _recipient, uint256 _amount) public onlyCreator {
        super.mintTokens(_recipient, _amount);
    }

    // CONTROL LOGIC

    /// @dev changes Hoard multisig address to another one
    function changeHoardAddress     (address _address) onlyHoard external { hoard = _address; }

    /// @dev changes migration master address to another one
    function changeMigrationMaster  (address _address) onlyHoard external { migrationMaster = _address; }

}