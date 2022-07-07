pragma solidity ^0.5.2;
contract erc20interface48 {	//inject NONSTANDARD NAMING
  string public name;
  string public symbol;
  uint8 public decimals;
  uint public totalSupply;

  function TRANSFER38(address _to, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING
  function TRANSFERFROM34(address _from, address _to, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING
  function APPROVE88(address _spender, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING
  function ALLOWANCE86(address _owner, address _spender) public view returns (uint256 remaining);	//inject NONSTANDARD NAMING

  event TRANSFER33(address indexed _from, address indexed _to, uint256 _value);	//inject NONSTANDARD NAMING
  event APPROVAL98(address indexed _owner, address indexed _spender, uint256 _value);	//inject NONSTANDARD NAMING
}

contract weex_contract83 is erc20interface48 {	//inject NONSTANDARD NAMING
  mapping (address => uint256) public balanceOf;
  mapping (address => mapping (address => uint256) ) internal allowed;

  constructor() public {
    name = "WEEX";
    symbol = "WEEX";
    decimals = 4;
    // 111011111114101
    totalSupply = 10000000000000;
    balanceOf[msg.sender] = totalSupply;
  }

  function TRANSFER38(address _to, uint256 _value) public returns (bool success){	//inject NONSTANDARD NAMING
    require(_to != address(0));
    require(balanceOf[msg.sender] >= _value);
    require(balanceOf[_to] + _value >= balanceOf[_to]);

    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    emit TRANSFER33(msg.sender, _to, _value);
    success = true;
  }

  function TRANSFERFROM34(address _from, address _to, uint256 _value) public returns (bool success){	//inject NONSTANDARD NAMING
    require(_to != address(0));
    require(balanceOf[_from] >= _value);
    require(allowed[_from][msg.sender]  >= _value);
    require(balanceOf[_to] + _value >= balanceOf[_to]);

    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    allowed[_from][msg.sender] -= _value;
    emit TRANSFER33(_from, _to, _value);
    success = true;
  }

  function APPROVE88(address _spender, uint256 _value) public returns (bool success){	//inject NONSTANDARD NAMING
      require((_value == 0)||(allowed[msg.sender][_spender] == 0));
      allowed[msg.sender][_spender] = _value;
      emit APPROVAL98(msg.sender, _spender, _value);
      success = true;
  }

  function ALLOWANCE86(address _owner, address _spender) public view returns (uint256 remaining){	//inject NONSTANDARD NAMING
    return allowed[_owner][_spender];
  }
}