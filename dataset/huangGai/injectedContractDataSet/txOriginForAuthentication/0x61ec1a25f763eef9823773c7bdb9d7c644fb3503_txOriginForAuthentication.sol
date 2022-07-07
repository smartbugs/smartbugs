pragma solidity 0.5.2;

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

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
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


library SafeERC20 {
    using SafeMath for uint256;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        require(token.transfer(to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        require(token.transferFrom(from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require((value == 0) || (token.allowance(msg.sender, spender) == 0));
        require(token.approve(spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        require(token.approve(spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        require(token.approve(spender, newAllowance));
    }
}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * Originally based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 *
 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
 * all accounts just by listening to said events. Note that this isn't required by the specification, and other
 * compliant implementations may not do it.
 */
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
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
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
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        _transfer(from, to, value);
        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Transfer token for a specified addresses
    * @param from The address to transfer from.
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
        _burn(account, value);
        emit Approval(account, msg.sender, _allowed[account][msg.sender]);
    }
}

contract Freeze is Ownable, ERC20 {
  
    using SafeMath for uint256;

    uint256 public endOfIco;
    uint256 public unlockSchema = 12;

    struct Group {
        address[] holders;
        uint until;
    }
    
    /**
    * @dev number of groups
    */
    uint public groups;
    
    address[] public gofindAllowedAddresses; // ADD 0xO ADDRESS AT FIRST PLACE
    
    /**
    * @dev link group ID ---> Group structure
    */
    mapping (uint => Group) public lockup;
    
    /**
    * @dev Check if holder under lock up
    */
    modifier lockupEnded (address _holder, address _recipient, uint256 actionAmount) {
        uint index = indexOf(_recipient, gofindAllowedAddresses);
        if (index == 0) {
            bool freezed;
            uint groupId;
            (freezed, groupId) = isFreezed(_holder);
            
            if (freezed) {
                if (lockup[groupId-1].until < block.timestamp)
                    _;
                    
                else if (getFullMonthAfterIco() != 0) {
                    uint256 available = getAvailableAmount();
                    if (actionAmount > available)
                        revert("Your holdings are freezed and your trying to use amount more than available");
                    else 
                        _;
                }
                else 
                    revert("Your holdings are freezed, wait until transfers become allowed");
            }
            else 
                _;
        }
        else
        _;
    }
    
    /**
     * @dev in timestamp
    */
    function changeEndOfIco (uint256 _date) public onlyOwner returns (bool) {
        endOfIco = _date;
    }
    
    function addGofindAllowedAddress (address _newAddress) public onlyOwner returns (bool) {
        require(indexOf(_newAddress, gofindAllowedAddresses) == 0, "that address already exists");
        gofindAllowedAddresses.push(_newAddress);
        return true;
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
     * @dev returns available tokens amount after linear release for msg.sender
     */
    function getAvailableAmount () internal view returns (uint256) {
        uint256 monthes = getFullMonthAfterIco();
        uint256 balance = balanceOf(msg.sender);
        uint256 monthShare = balance.div(unlockSchema);
        uint256 available = monthShare * monthes;
        return available;
    }
    
    /**
     * @dev calculate how much month have gone after end of ICO
     */
    function getFullMonthAfterIco () internal view returns (uint256) {
        uint256 currentTime = block.timestamp;
        if (currentTime < endOfIco)
            return 0;
        else {
            uint256 delta = currentTime - endOfIco;
            uint256 step = 2592000;
            if (delta > step) {
                uint256 times = delta.div(step);
                return times;
            }
            else {
                return 0;
            }
        }
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
 * @notice Inherit from it at ERC20, to make freezing functionality works
*/
contract PausableToken is Freeze {

    function transfer(address _to, uint256 _value) public lockupEnded(msg.sender, _to, _value) returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public lockupEnded(msg.sender, _to, _value) returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public lockupEnded(msg.sender, _spender, _value) returns (bool) {
        return super.approve(_spender, _value);
    }

    function increaseAllowance(address _spender, uint256 _addedValue)
        public lockupEnded(msg.sender, _spender, _addedValue) returns (bool success)
    {
        return super.increaseAllowance(_spender, _addedValue);
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue)
        public lockupEnded(msg.sender, _spender, _subtractedValue) returns (bool success)
    {
        return super.decreaseAllowance(_spender, _subtractedValue);
    }
}


contract SingleToken is PausableToken {

    using SafeMath for uint256;
    
    event TokensBurned(address from, uint256 value);
    event TokensMinted(address to, uint256 value);

    string  public constant name      = "Gofind XR"; 

    string  public constant symbol    = "XR";

    uint32  public constant decimals  = 8;

    uint256 public constant maxSupply = 13E16;
    
    constructor() public {
        totalSupply().add(maxSupply);
        super._mint(msg.sender, maxSupply);
    }
    
    function burn (address account, uint256 value) public onlyOwner returns (bool) {
        super._burn(account, value);
        return true;
    }
    
    function burnFrom (address account, uint256 value) public onlyOwner returns (bool) {
        super._burnFrom(account, value);
        return true;
    }
    
    function mint (address account, uint256 value) public onlyOwner returns (bool) {
        super._mint(account, value);
        return true;
    }
  
}