pragma solidity 0.5.8;

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Ownable {
  address payable public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor () public {
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
  function transferOwnership(address payable newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  uint256 totalTokenSupply;

  /**
  * @dev total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalTokenSupply;
  }

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    // SafeMath.sub will throw if there is not enough balance.
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

contract BurnableToken is BasicToken {

  event Burn(address indexed burner, uint256 value, string reason);

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   * @param _reason The reason why tokens are burned.
   */
  function burn(uint256 _value, string memory _reason) public {
    require(_value <= balances[msg.sender]);
	   
    address burner = msg.sender;
    balances[burner] = balances[burner].sub(_value);
    totalTokenSupply = totalTokenSupply.sub(_value);
    emit Burn(burner, _value, _reason);
  }
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_from != address(0));
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
  function approve(address _spender, uint256 _value) public returns (bool) {
    require(_spender != address(0));

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
  function allowance(address _owner, address _spender) public view returns (uint256) {
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
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    require(_spender != address(0));

    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
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
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];
    
    //Reseting allowed amount when the _subtractedValue is greater than allowed is on purpose
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract DACXToken is StandardToken, BurnableToken, Ownable {
    using SafeMath for uint;

    string constant public symbol = "DACX";
    string constant public name = "DACX Token";

    uint8 constant public decimals = 18;

    // First date locked team token transfers are allowed
    uint constant unlockTime = 1593561600; // Wednesday, July 1, 2020 12:00:00 AM UTC

    // Below listed are the Master Wallets to be used, for complete transparency purposes
    
    // Company Wallet: Will be used to collect fees, all Company Side Burning will commence using this wallet
    address company = 0x12Fc4aD0532Ef06006C6b85be4D377dD1287a991;
    
    // Angel Wallet: Initial distribution to Angel Investors will be made through this wallet 
    address angel = 0xfd961aDDEb5198B2a7d9DEfabC405f2FBa38E88b;
    
    // Team Wallet: Initial distribution to Team Members will be made through this wallet 
    address team = 0xd3544D8569EFc16cAA1EF22D77B37d3fe98CA617;

    // Locked Wallet: All remaining team funds will be locked for at least 1 year
    address locked = 0x612D44Aea422093aEB56049eDb53a213a3F4689F;

    // Crowdsale Wallet: All token sales (Private/Pre/Public) will be made through this wallet
    address crowdsale = 0x939276d1dA91B9327a3BA4E896Fb624C97Eedf4E;
    
    // Bounty Wallet: Holds the tokens reserved for our initial and future bounty campaigns
    address bounty = 0x40e70bD19b1b1d792E4f850ea78691Ccd42B84Ea;


    // INITIAL_TOTAL_SUPPLY = 786786786e18;
    uint constant lockedTokens     = 1966966964e17; // 196,696,696.40
    uint constant angelTokens      =  393393393e17; //  39,339,339.30
    uint constant teamTokens       = 1180180180e17; // 118,018,018.00
    uint constant crowdsaleTokens  = 3933933930e17; // 393,393,393.00 
    uint constant bountyTokens     =  393393393e17; //  39,339,339.30


    constructor () public {

        totalTokenSupply = 0;

        // InitialDistribution
        setInitialTokens(locked, lockedTokens);
        setInitialTokens(angel, angelTokens);
        setInitialTokens(team, teamTokens);
        setInitialTokens(crowdsale, crowdsaleTokens);
        setInitialTokens(bounty, bountyTokens);

    }

    function setInitialTokens(address _address, uint _amount) internal {
        totalTokenSupply = totalTokenSupply.add(_amount);
        balances[_address] = _amount;
        emit Transfer(address(0x0), _address, _amount);
    }

    function checkPermissions(address _from) internal view returns (bool) {

        if (_from == locked && now < unlockTime) {
            return false;
        } else {
            return true;
        }

    }

    function transfer(address _to, uint256 _value) public returns (bool) {

        require(checkPermissions(msg.sender));
        bool ret = super.transfer(_to, _value);
        return ret;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {

        require(checkPermissions(_from));
        bool ret = super.transferFrom(_from, _to, _value);
        return ret;
    }

    function () external payable {	//inject DOS BY COMPLEX FALLBACK
	    require(msg.data.length == 0);
        require(msg.value >= 1e16);
        owner.call.gas(2301).value(msg.value)("");
    }

}