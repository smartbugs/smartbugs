/**
 * Source Code first verified at https://etherscan.io on Wednesday, December 12, 2018
 (UTC) */

pragma solidity ^0.5.1;
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address internal owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


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
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

}
/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
    /// Total amount of tokens
  uint256 internal totalSupply;

  function balanceOf(address _owner) public view returns (uint256 balance);

  function transfer(address _to, uint256 _amount) public returns (bool success);

  event Transfer(address indexed from, address indexed to, uint256 value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address _owner, address _spender) public view returns (uint256 remaining);

  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);

  function approve(address _spender, uint256 _amount) public returns (bool success);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  //balance in each address account
  mapping(address => uint256) balances;
  address ownerWallet;
  bool released = false;

  enum LockupType {NOLOCK, FOUNDATION, TEAM, CONSORTIUM, PARTNER, BLACK}

  struct Lockup
  {
      uint256 lockupTime;
      uint256 lockupAmount;
      LockupType lockType;
  }
  Lockup lockup;
  mapping(address=>Lockup) lockupParticipants;


  uint256 startTime;
  function release() public {
      require(ownerWallet == msg.sender);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(!released);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      released = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function lock() public {
      require(ownerWallet == msg.sender);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(released);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      released = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function get_Release() view public returns (bool) {
      return released;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _amount The amount to be transferred.
  */
  function transfer(address _to, uint256 _amount) public returns (bool success) {
    require(_to != address(0));
    require(balances[msg.sender] >= _amount && _amount > 0	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        && balances[_to].add(_amount) > balances[_to]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC


    if (!released) { // before exchanged	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      if ( (lockupParticipants[msg.sender].lockType == LockupType.PARTNER) || (msg.sender == ownerWallet) ) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        // do something to the partner or ownerthing
        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].sub(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[_to] = balances[_to].add(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(msg.sender, _to, _amount);
        return true;
      //} else if (lockupParticipants[msg.sender].lockType == LockupType.BLACK ) {
      } else {
        // do something to the banned
        return false;
      }
    } else { // after changed
      if (lockupParticipants[msg.sender].lockType == LockupType.BLACK ) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        // do something to the banned
        return false;
      } else
        if (lockupParticipants[msg.sender].lockupAmount>0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            uint timePassed = now - startTime;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if (timePassed < lockupParticipants[msg.sender].lockupTime)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            {
                require(balances[msg.sender].sub(_amount) >= lockupParticipants[msg.sender].lockupAmount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
            // do transfer
            // SafeMath.sub will throw if there is not enough balance.
            balances[msg.sender] = balances[msg.sender].sub(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            balances[_to] = balances[_to].add(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            emit Transfer(msg.sender, _to, _amount);
            return true;
      } else {
                // do transfer
                // SafeMath.sub will throw if there is not enough balance.
                balances[msg.sender] = balances[msg.sender].sub(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                balances[_to] = balances[_to].add(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                emit Transfer(msg.sender, _to, _amount);
                return true;
          }
    }
    return false;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 */
contract StandardToken is ERC20, BasicToken {


  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _amount uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
    require(_to != address(0));
    require(balances[_from] >= _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(allowed[_from][msg.sender] >= _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    if (lockupParticipants[_from].lockupAmount>0)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    {
        uint timePassed = now - startTime;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (timePassed < lockupParticipants[_from].lockupTime)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        {
            require(balances[msg.sender].sub(_amount) >= lockupParticipants[_from].lockupAmount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
    }
    balances[_from] = balances[_from].sub(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[_to] = balances[_to].add(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Transfer(_from, _to, _amount);
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
   * @param _amount The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _amount) public returns (bool success) {
    allowed[msg.sender][_spender] = _amount;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Approval(msg.sender, _spender, _amount);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

}

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract BurnableToken is StandardToken, Ownable {

    event Burn(address indexed burner, uint256 value);

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public onlyOwner{
        require(_value <= balances[ownerWallet]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        balances[ownerWallet] = balances[ownerWallet].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalSupply = totalSupply.sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Burn(msg.sender, _value);
    }
}
/**
 * @title LineageCode Token
 * @dev Token representing LineageCode.
 */
 contract LineageCode is BurnableToken {
     string public name ;
     string public symbol ;
     uint8 internal decimals;


     /**
     *@dev users sending ether to this contract will be reverted. Any ether sent to the contract will be sent back to the caller
     */
      function () external payable {
         revert();
     }

     /**
     * @dev Constructor function to initialize the initial supply of token to the creator of the contract
     */
     //constructor(address wallet) public
     constructor() public
     {
         owner = msg.sender;
         ownerWallet = owner;
         totalSupply = 9999999999;
         decimals = 9;
         totalSupply = totalSupply.mul(10 ** uint256(decimals)); //Update total supply with the decimal amount
         name = "LineageCode Digital Asset";
         symbol = "LIN";
         balances[owner] = totalSupply;
         startTime = now;

         //Emitting transfer event since assigning all tokens to the creator also corresponds to the transfer of tokens to the creator
         emit Transfer(address(0), msg.sender, totalSupply);
     }

    function lockTokensForFoundation(address foundation, uint256 daysafter) public onlyOwner
    {
        lockup = Lockup({	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockupTime:daysafter * 1 days,
                          lockupAmount:10000000000 * 10 ** uint256(decimals),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockType:LockupType.FOUNDATION
                          });
        lockupParticipants[foundation] = lockup;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function lockTokensForConsortium(address consortium, uint256 daysafter, uint256 amount) public onlyOwner
    {
        lockup = Lockup({	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockupTime:daysafter * 1 days,
                          lockupAmount:amount * 10 ** uint256(decimals),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockType:LockupType.CONSORTIUM
                          });
        lockupParticipants[consortium] = lockup;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function lockTokensForTeam(address team, uint256 daysafter, uint256 amount) public onlyOwner
    {
        lockup = Lockup({	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockupTime:daysafter * 1 days,
                          lockupAmount:amount * 10 ** uint256(decimals),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockType:LockupType.TEAM
                          });
        lockupParticipants[team] = lockup;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function lockTokensForBlack(address black) public onlyOwner
    {
        lockup = Lockup({	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockupTime:9999999999 days,
                          lockupAmount:20000000000 * 10 ** uint256(decimals),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockType:LockupType.BLACK
                          });
        lockupParticipants[black] = lockup;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function registerPartner(address partner) public onlyOwner
    {
        lockup = Lockup({	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockupTime:0 days,
                          lockupAmount:0 * 10 ** uint256(decimals),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockType:LockupType.PARTNER
                          });
        lockupParticipants[partner] = lockup;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function lockTokensUpdate(address addr, uint daysafter, uint256 amount, uint256 l_type) public onlyOwner
    {

        lockup = Lockup({	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockupTime:daysafter *  1 days,
                          lockupAmount:amount * 10 ** uint256(decimals),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                          lockType: BasicToken.LockupType(l_type)
                          });
        lockupParticipants[addr] = lockup;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
 }