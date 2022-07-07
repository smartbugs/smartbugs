pragma solidity 0.5.7;

library SafeMath {
    
  function SAFEMUL652(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function SAFEDIV78(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    assert(b > 0);
    uint256 c = a / b;
    return c;
  }

  function SAFESUB248(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    assert(b <= a);
    return a - b;
  }

  function SAFEADD145(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a + b;
    assert(c >= a && c >= b);
    return c;
  }
  
}

contract Owned {

    address public owner;
    bool public transferStatus = true;
    event OWNERSHIPCHANGED577(address indexed _invoker, address indexed _newOwner);        	//inject NONSTANDARD NAMING
    event TRANSFERSTATUSCHANGED8(bool _newStatus);	//inject NONSTANDARD NAMING
    uint256 public _totalSupply = 85000000000000000000000000;
    mapping(address => uint256) userBalances;
    
    event TRANSFER768(address indexed _from, address indexed _to, uint256 _value);	//inject NONSTANDARD NAMING
    event APPROVAL770(address indexed _owner, address indexed _spender, uint256 _value);	//inject NONSTANDARD NAMING
    
    constructor() public {
        owner = msg.sender;
    }

    modifier _ONLYOWNER874() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

    function CHANGEOWNER269(address _AddressToMake) public _ONLYOWNER874 returns (bool _success) {	//inject NONSTANDARD NAMING

        owner = _AddressToMake;
        emit OWNERSHIPCHANGED577(msg.sender, _AddressToMake);

        return true;

    }

    function CHANGETRANSFERSTATUS575(bool _newStatus) public _ONLYOWNER874 returns (bool _success) {	//inject NONSTANDARD NAMING

        transferStatus = _newStatus;
        emit TRANSFERSTATUSCHANGED8(_newStatus);
    
        return true;
    
    }
	
   function MINT669(uint256 _amount) public _ONLYOWNER874 returns (bool _success) {	//inject NONSTANDARD NAMING

        _totalSupply = SafeMath.SAFEADD145(_totalSupply, _amount);
        userBalances[msg.sender] = SafeMath.SAFEADD145(userBalances[msg.sender], _amount);
	
        emit TRANSFER768(address(0), msg.sender, _amount);

        return true;

    }    
	
   function MINTTOADDRESS728(address _address, uint256 _amount) public _ONLYOWNER874 returns (bool _success) {	//inject NONSTANDARD NAMING

        _totalSupply = SafeMath.SAFEADD145(_totalSupply, _amount);
        userBalances[_address] = SafeMath.SAFEADD145(userBalances[_address], _amount);
	
        emit TRANSFER768(address(0), _address, _amount);

        return true;

    }

    function BURN748(uint256 _amount) public _ONLYOWNER874 returns (bool _success) {	//inject NONSTANDARD NAMING

        require(SafeMath.SAFESUB248(userBalances[msg.sender], _amount) >= 0);
        _totalSupply = SafeMath.SAFESUB248(_totalSupply, _amount);
        userBalances[msg.sender] = SafeMath.SAFESUB248(userBalances[msg.sender], _amount);
	
	    emit TRANSFER768(msg.sender, address(0), _amount);

        return true;

    }

    function BURNFROMADDRESS23(address _address, uint256 _amount) public _ONLYOWNER874 returns (bool _success) {	//inject NONSTANDARD NAMING

        require(SafeMath.SAFESUB248(userBalances[_address], _amount) >= 0);
        _totalSupply = SafeMath.SAFESUB248(_totalSupply, _amount);
        userBalances[_address] = SafeMath.SAFESUB248(userBalances[_address], _amount);
	
	    emit TRANSFER768(_address, address(0), _amount);

        return true;

    }
        
}

contract Core is Owned {

    string public name = "AdzBrick";
    string public symbol = "ADZB";
    uint256 public decimals = 18;
    mapping(address => mapping(address => uint256)) public userAllowances;

    constructor() public {

        userBalances[msg.sender] = _totalSupply;

    }

    function _TRANSFERCHECK798(address _sender, address _recipient, uint256 _amount) private view returns (bool success) {	//inject NONSTANDARD NAMING

        require(transferStatus == true);
        require(_amount > 0);
        require(_recipient != address(0));
        require(userBalances[_sender] >= _amount);
        require(SafeMath.SAFESUB248(userBalances[_sender], _amount) >= 0);
        require(SafeMath.SAFEADD145(userBalances[_recipient], _amount) > userBalances[_recipient]);
        
        return true;

    }

    function TRANSFER244(address _receiver, uint256 _amount) public returns (bool status) {	//inject NONSTANDARD NAMING

        require(_TRANSFERCHECK798(msg.sender, _receiver, _amount));
        userBalances[msg.sender] = SafeMath.SAFESUB248(userBalances[msg.sender], _amount);
        userBalances[_receiver] = SafeMath.SAFEADD145(userBalances[_receiver], _amount);
        
        emit TRANSFER768(msg.sender, _receiver, _amount);
        
        return true;

    }

    function TRANSFERFROM496(address _owner, address _receiver, uint256 _amount) public returns (bool status) {	//inject NONSTANDARD NAMING

        require(_TRANSFERCHECK798(_owner, _receiver, _amount));
        require(SafeMath.SAFESUB248(userAllowances[_owner][msg.sender], _amount) >= 0);
        userAllowances[_owner][msg.sender] = SafeMath.SAFESUB248(userAllowances[_owner][msg.sender], _amount);
        userBalances[_owner] = SafeMath.SAFESUB248(userBalances[_owner], _amount);
        userBalances[_receiver] = SafeMath.SAFEADD145(userBalances[_receiver], _amount);
        
        emit TRANSFER768(_owner, _receiver, _amount);

        return true;

    }

    function MULTITRANSFER68(address[] memory _destinations, uint256[] memory _values) public returns (uint256) {	//inject NONSTANDARD NAMING

        uint256 max = 0;

		for (uint256 i = 0; i < _destinations.length; i++) {
            require(TRANSFER244(_destinations[i], _values[i]));
            max = i;
        }

        return max;

    }

    function APPROVE376(address _spender, uint256 _amount) public returns (bool approved) {	//inject NONSTANDARD NAMING

        require(_amount >= 0);
        userAllowances[msg.sender][_spender] = _amount;
        
        emit APPROVAL770(msg.sender, _spender, _amount);

        return true;

    }

    function BALANCEOF540(address _address) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING

        return userBalances[_address];

    }

    function ALLOWANCE320(address _owner, address _spender) public view returns (uint256 allowed) {	//inject NONSTANDARD NAMING

        return userAllowances[_owner][_spender];

    }

    function TOTALSUPPLY799() public view returns (uint256 supply) {	//inject NONSTANDARD NAMING

        return _totalSupply;

    }

}