/**
 *Submitted for verification at Etherscan.io on 2020-10-10
*/

pragma solidity 0.6.0;

//Standard safemath
library SafeMath {
  /**
  * @dev Multiplies two unsigned integers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    //Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    //benefit is lost if 'b' is also tested.
    //See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
    //Solidity only automatically asserts when dividing by 0
    require(b > 0);
    uint256 c = a / b;
    //assert(a == b * c + a % b); // There is no case in which this doesn't hold

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

//Standard ownable
contract Ownable {
  address public _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor () public {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), msg.sender);
  }

  function owner() public view returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(_owner == tx.origin, "Ownable: caller is not the owner");	//inject USING TX ORIGIN FOR AUTHENTICATION

    _;
  }

  //Remove ownership of the contract all together
  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }
	
  //Transfer contract ownership to a new address
  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract YFCYCLICToken is Ownable {
  using SafeMath for uint256;

  //Standard ERC20 variables. 
  string public constant name = "yfCyclic";
  string public constant symbol = "CYCL";
  uint256 public constant decimals = 18;
  //The supply will not exceed 20,000 CYCL
  uint256 private constant _maximumSupply = 20000 * 10 ** decimals;
  //Presale amount is 6000 tokens so only up to 6000 can be burned after presale.
  uint256 private constant _maximumPresaleBurnAmount = 6000 * 10 ** decimals;
  uint256 public _presaleBurnTotal = 0;
  uint256 public _stakingBurnTotal = 0;
  uint256 public _totalSupply;

  //Events
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  //Mappings
  mapping(address => uint256) public _balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  constructor() public override {
    //Transfer the entire supply into the address of the Contract creator.
    _owner = msg.sender;
    _totalSupply = _maximumSupply;
    _balanceOf[msg.sender] = _maximumSupply;
    emit Transfer(address(0x0), msg.sender, _maximumSupply);
  }

  //Return total supply
  function totalSupply () public view returns (uint256) {
    return _totalSupply; 
  }
  
  //Return balance of specific address
  function balanceOf (address who) public view returns (uint256) {
    return _balanceOf[who];
  }

  //Internal transfer (contract only)
  function _transfer(address _from, address _to, uint256 _value) internal {
    _balanceOf[_from] = _balanceOf[_from].sub(_value);
    _balanceOf[_to] = _balanceOf[_to].add(_value);
    emit Transfer(_from, _to, _value);
  }

  //Transfer tokens from sending address to new address
  function transfer(address _to, uint256 _value) public returns (bool success) {
    require(_balanceOf[msg.sender] >= _value);
    _transfer(msg.sender, _to, _value);
    return true;
  }

  //Handles presale burn and vault burn if a future vault cycle ever calls for it.
  function burn (uint256 _burnAmount, bool _presaleBurn) public onlyOwner returns (bool success) {
    if (_presaleBurn) {
      require(_presaleBurnTotal.add(_burnAmount) <= _maximumPresaleBurnAmount);
      require(_balanceOf[msg.sender] >= _burnAmount);
      _presaleBurnTotal = _presaleBurnTotal.add(_burnAmount);
      _transfer(_owner, address(0), _burnAmount);
      _totalSupply = _totalSupply.sub(_burnAmount);
    } else {
      require(_balanceOf[msg.sender] >= _burnAmount);
      _transfer(_owner, address(0), _burnAmount);
      _totalSupply = _totalSupply.sub(_burnAmount);
    }
    return true;
  }

  //Approve tokens
  function approve(address _spender, uint256 _value) public returns (bool success) {
    require(_spender != address(0));
    allowance[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  //Transfer tokens from one address to another
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(_value <= _balanceOf[_from]);
    require(_value <= allowance[_from][msg.sender]);
    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
    _transfer(_from, _to, _value);
    return true;
  }
}