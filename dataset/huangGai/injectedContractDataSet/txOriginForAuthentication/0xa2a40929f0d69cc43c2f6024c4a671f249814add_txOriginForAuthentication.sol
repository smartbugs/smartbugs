pragma solidity 0.5.1;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract ReentrancyGuard {

  /**
   * @dev We use a single lock for the whole contract.
   */
  bool private reentrancyLock = false;

  /**
   * @dev Prevents a contract from calling itself, directly or indirectly.
   * @notice If you mark a function `nonReentrant`, you should also
   * mark it `external`. Calling one nonReentrant function from
   * another is not supported. Instead, you can implement a
   * `private` function doing the actual work, and a `external`
   * wrapper marked as `nonReentrant`.
   */
  modifier nonReentrant() {
    require(!reentrancyLock);
    reentrancyLock = true;
    _;
    reentrancyLock = false;
  }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }
}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender)
    public view returns (uint256);

  function transferFrom(address from, address to, uint256 value)
    public returns (bool);

  function approve(address spender, uint256 value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic, ReentrancyGuard {
  using SafeMath for uint256;

  mapping(address => uint256) public balances;

  uint256 public totalSupply_;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public nonReentrant returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    nonReentrant
    returns (bool)
  {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);

    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public nonReentrant returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }


  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    nonReentrant
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    nonReentrant
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract Freeze is Ownable, ReentrancyGuard {
  
  using SafeMath for uint256;

  struct Group {
    address[] holders;
    uint until;
  }
  
	/**
	 * @dev number of groups
	 */
  uint public groups;
  
	/**
	 * @dev link group ID ---> Group structure
	 */
  mapping (uint => Group) public lockup;
  
	/**
	 * @dev Check if holder under lock up
	 */
  modifier lockupEnded (address _holder) {
    bool freezed;
    uint groupId;
    (freezed, groupId) = isFreezed(_holder);
    
    if (freezed) {
      if (lockup[groupId-1].until < block.timestamp)
        _;
      else 
        revert("Your holdings are freezed, wait until transfers become allowed");
    }
    else 
      _;
  }
  
	/**
	 * @param _holder address of token holder to check
	 * @return bool - status of freezing and group
	 */
  function isFreezed (address _holder) public view returns(bool, uint) {
    bool freezed = false;
    uint i = 0;
    while (i < groups) {
      uint index  = indexOf(_holder, lockup[i].holders);

      if (index == 0) {
        if (checkZeroIndex(_holder, i)) {
          freezed = true;
          i++;
          continue;
        }  
        else {
          i++;
          continue;
        }
      }
      
      if (index != 0) {
        freezed = true;
        i++;
        continue;
      }
      i++;
    }
    if (!freezed) i = 0;
    
    return (freezed, i);
  }
  
	/**
	 * @dev internal usage to get index of holder in group
	 * @param element address of token holder to check
	 * @param at array of addresses that is group of holders
	 * @return index of holder at array
	 */
  function indexOf (address element, address[] memory at) internal pure returns (uint) {
    for (uint i=0; i < at.length; i++) {
      if (at[i] == element) return i;
    }
    return 0;
  }
  
	/**
	 * @dev internal usage to check that 0 is 0 index or it means that address not exists
	 * @param _holder address of token holder to check
	 * @param lockGroup id of group to check address existance in it
	 * @return true if holder at zero index at group false if holder doesn't exists
	 */
  function checkZeroIndex (address _holder, uint lockGroup) internal view returns (bool) {
    if (lockup[lockGroup].holders[0] == _holder)
      return true;
        
    else 
      return false;
  }
  
	/**
	 * @dev Will set group of addresses that will be under lock. When locked address can't
	  		  do some actions with token
	 * @param _holders array of addresses to lock
	 * @param _until   timestamp until that lock up will last
	 * @return bool result of operation
	 */
  function setGroup (address[] memory _holders, uint _until) public onlyOwner returns (bool) {
    lockup[groups].holders = _holders;
    lockup[groups].until   = _until;
    
    groups++;
    return true;
  }
}

/**
 * @dev This contract needed for inheritance of StandardToken interface,
        but with freezing modifiers. So, it have exactly same methods, but with 
        lockupEnded(msg.sender) modifier.
 * @notice Inherit from it at SingleToken, to make freezing functionality works
*/
contract PausableToken is StandardToken, Freeze {

  function transfer(
    address _to,
    uint256 _value
  )
    public
    lockupEnded(msg.sender)
    returns (bool)
  {
    return super.transfer(_to, _value);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    lockupEnded(msg.sender)
    returns (bool)
  {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(
    address _spender,
    uint256 _value
  )
    public
    lockupEnded(msg.sender)
    returns (bool)
  {
    return super.approve(_spender, _value);
  }

  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    lockupEnded(msg.sender)
    returns (bool success)
  {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    lockupEnded(msg.sender)
    returns (bool success)
  {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}


contract SingleToken is PausableToken {

  string  public constant name      = "Gofind XR"; 

  string  public constant symbol    = "XR";

  uint32  public constant decimals  = 8;

  uint256 public constant maxSupply = 13E16;
  
  constructor() public {
    totalSupply_ = totalSupply_.add(maxSupply);
    balances[msg.sender] = balances[msg.sender].add(maxSupply);
  }
}