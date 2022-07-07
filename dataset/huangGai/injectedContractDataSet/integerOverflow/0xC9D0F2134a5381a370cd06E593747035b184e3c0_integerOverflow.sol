/**
 *Submitted for verification at Etherscan.io on 2020-02-27
*/

pragma solidity 0.6.1;


library SafeMath {

  
  string constant OVERFLOW = "008001";
  string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
  string constant DIVISION_BY_ZERO = "008003";

  
  function mul(
    uint256 _factor1,
    uint256 _factor2
  )
    internal
    pure
    returns (uint256 product)
  {
    
    
    
    if (_factor1 == 0)
    {
      return 0;
    }

    product = _factor1 * _factor2;
    require(product / _factor1 == _factor2, OVERFLOW);
  }

  
  function div(
    uint256 _dividend,
    uint256 _divisor
  )
    internal
    pure
    returns (uint256 quotient)
  {
    
    require(_divisor > 0, DIVISION_BY_ZERO);
    quotient = _dividend / _divisor;
    
  }

  
  function sub(
    uint256 _minuend,
    uint256 _subtrahend
  )
    internal
    pure
    returns (uint256 difference)
  {
    require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
    difference = _minuend - _subtrahend;
  }

  
  function add(
    uint256 _addend1,
    uint256 _addend2
  )
    internal
    pure
    returns (uint256 sum)
  {
    sum = _addend1 + _addend2;
    //require(sum >= _addend1, OVERFLOW);
  }

  
  function mod(
    uint256 _dividend,
    uint256 _divisor
  )
    internal
    pure
    returns (uint256 remainder)
  {
    require(_divisor != 0, DIVISION_BY_ZERO);
    remainder = _dividend % _divisor;
  }

}

interface ERC165 {

  
  function supportsInterface(
    bytes4 _interfaceID
  )
    external
    view
    returns (bool);

}

contract SupportsInterface is
  ERC165
{

  
  mapping(bytes4 => bool) internal supportedInterfaces;

  
  constructor()
    public
  {
    supportedInterfaces[0x01ffc9a7] = true; 
  }

  
  function supportsInterface(
    bytes4 _interfaceID
  )
    external
    override
    view
    returns (bool)
  {
    return supportedInterfaces[_interfaceID];
  }

}

interface ERC20 {

  
  function name()
    external
    view
    returns (string memory _name);

  
  function symbol()
    external
    view
    returns (string memory _symbol);

  
  function decimals()
    external
    view
    returns (uint8 _decimals);

  
  function totalSupply()
    external
    view
    returns (uint256 _totalSupply);

  
  function balanceOf(
    address _owner
  )
    external
    view
    returns (uint256 _balance);

  
  function transfer(
    address _to,
    uint256 _value
  )
    external
    returns (bool _success);

  
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    external
    returns (bool _success);

  
  function approve(
    address _spender,
    uint256 _value
  )
    external
    returns (bool _success);

  
  function allowance(
    address _owner,
    address _spender
  )
    external
    view
    returns (uint256 _remaining);

  
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
  );

  
  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );

}

contract Token is
  ERC20,
  SupportsInterface
{
  using SafeMath for uint256;

  
  string constant NOT_ENOUGH_BALANCE = "001001";
  string constant NOT_ENOUGH_ALLOWANCE = "001002";

  
  string internal tokenName;

  
  string internal tokenSymbol;

  
  uint8 internal tokenDecimals;

  
  uint256 internal tokenTotalSupply;

  
  mapping (address => uint256) internal balances;

  
  mapping (address => mapping (address => uint256)) internal allowed;

  
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
  );

  
  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );

  
  constructor()
    public
  {
    supportedInterfaces[0x36372b07] = true; 
    supportedInterfaces[0x06fdde03] = true; 
    supportedInterfaces[0x95d89b41] = true; 
    supportedInterfaces[0x313ce567] = true; 
  }

  
  function name()
    external
    override
    view
    returns (string memory _name)
  {
    _name = tokenName;
  }

  
  function symbol()
    external
    override
    view
    returns (string memory _symbol)
  {
    _symbol = tokenSymbol;
  }

  
  function decimals()
    external
    override
    view
    returns (uint8 _decimals)
  {
    _decimals = tokenDecimals;
  }

  
  function totalSupply()
    external
    override
    view
    returns (uint256 _totalSupply)
  {
    _totalSupply = tokenTotalSupply;
  }

  
  function balanceOf(
    address _owner
  )
    external
    override
    view
    returns (uint256 _balance)
  {
    _balance = balances[_owner];
  }

  
  function allowance(
    address _owner,
    address _spender
  )
    external
    override
    view
    returns (uint256 _remaining)
  {
    _remaining = allowed[_owner][_spender];
  }

  
  function transfer(
    address _to,
    uint256 _value
  )
    public
    override
    returns (bool _success)
  {
    require(_value <= balances[msg.sender], NOT_ENOUGH_BALANCE);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW


    emit Transfer(msg.sender, _to, _value);
    _success = true;
  }

  
  function approve(
    address _spender,
    uint256 _value
  )
    public
    override
    returns (bool _success)
  {
    allowed[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);
    _success = true;
  }

  
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    override
    returns (bool _success)
  {
    require(_value <= balances[_from], NOT_ENOUGH_BALANCE);
    require(_value <= allowed[_from][msg.sender], NOT_ENOUGH_ALLOWANCE);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);
    _success = true;
  }

}

contract TokenCustom is
  Token
{
  constructor(
    string memory _name,
    string memory _symbol,
    uint256 _supply,
    uint8 _decimals,
    address _owner
  )
    public
  {
    tokenName = _name;
    tokenSymbol = _symbol;
    tokenDecimals = _decimals;
    tokenTotalSupply = _supply;
    balances[_owner] = tokenTotalSupply;
    emit Transfer(address(0), _owner, tokenTotalSupply);
  }
}

contract TokenDeployProxy {
  
  function deploy(
    string memory _name,
    string memory _symbol,
    uint256 _supply,
    uint8 _decimals,
    address _owner
  )
    public
    returns (address token)
  {
    token = address(
      new TokenCustom(
        _name, _symbol, _supply, _decimals, _owner
      )
    );
  }
}