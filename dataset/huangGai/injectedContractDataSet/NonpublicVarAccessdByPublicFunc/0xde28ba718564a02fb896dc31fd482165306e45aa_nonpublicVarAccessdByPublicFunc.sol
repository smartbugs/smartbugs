pragma solidity 0.5.7;

library SafeMath {
    
  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b > 0);
    uint256 c = a / b;
    return c;
  }

  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a && c >= b);
    return c;
  }
  
}

contract Owned {

    address internal owner;
    bool internal transferStatus = true;
    event ownershipChanged(address indexed _invoker, address indexed _newOwner);        
    event transferStatusChanged(bool _newStatus);
    uint256 internal _totalSupply = 100000000000000000000000000;
    mapping(address => uint256) userBalances;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    constructor() public {
        owner = msg.sender;
    }

    modifier _onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address _AddressToMake) public _onlyOwner returns (bool _success) {

        owner = _AddressToMake;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit ownershipChanged(msg.sender, _AddressToMake);

        return true;

    }

    function changeTransferStatus(bool _newStatus) public _onlyOwner returns (bool _success) {

        transferStatus = _newStatus;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit transferStatusChanged(_newStatus);
    
        return true;
    
    }
	
   function mint(uint256 _amount) public _onlyOwner returns (bool _success) {

        _totalSupply = SafeMath.safeAdd(_totalSupply, _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userBalances[msg.sender] = SafeMath.safeAdd(userBalances[msg.sender], _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	
        emit Transfer(address(0), msg.sender, _amount);

        return true;

    }    
	
   function mintToAddress(address _address, uint256 _amount) public _onlyOwner returns (bool _success) {

        _totalSupply = SafeMath.safeAdd(_totalSupply, _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userBalances[_address] = SafeMath.safeAdd(userBalances[_address], _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	
        emit Transfer(address(0), _address, _amount);

        return true;

    }

    function burn(uint256 _amount) public _onlyOwner returns (bool _success) {

        require(SafeMath.safeSub(userBalances[msg.sender], _amount) >= 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _totalSupply = SafeMath.safeSub(_totalSupply, _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userBalances[msg.sender] = SafeMath.safeSub(userBalances[msg.sender], _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	
	    emit Transfer(msg.sender, address(0), _amount);

        return true;

    }
        
}

contract Core is Owned {

    string public name = "STOKX";
    string public symbol = "STOKX";
    uint256 public decimals = 18;
    mapping(address => mapping(address => uint256)) internal userAllowances;

    constructor() public {

        userBalances[msg.sender] = _totalSupply;

    }

    function _transferCheck(address _sender, address _recipient, uint256 _amount) private view returns (bool success) {

        require(transferStatus == true);
        require(_recipient != address(0));
        require(userBalances[_sender] >= _amount);
        require(SafeMath.safeSub(userBalances[_sender], _amount) >= 0);
        require(SafeMath.safeAdd(userBalances[_recipient], _amount) >= userBalances[_recipient]);
        
        return true;

    }

    function transfer(address _receiver, uint256 _amount) public returns (bool status) {

        require(_transferCheck(msg.sender, _receiver, _amount));
        userBalances[msg.sender] = SafeMath.safeSub(userBalances[msg.sender], _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userBalances[_receiver] = SafeMath.safeAdd(userBalances[_receiver], _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        emit Transfer(msg.sender, _receiver, _amount);
        
        return true;

    }

    function transferFrom(address _owner, address _receiver, uint256 _amount) public returns (bool status) {

        require(_transferCheck(_owner, _receiver, _amount));
        require(SafeMath.safeSub(userAllowances[_owner][msg.sender], _amount) >= 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userAllowances[_owner][msg.sender] = SafeMath.safeSub(userAllowances[_owner][msg.sender], _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userBalances[_owner] = SafeMath.safeSub(userBalances[_owner], _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        userBalances[_receiver] = SafeMath.safeAdd(userBalances[_receiver], _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        emit Transfer(_owner, _receiver, _amount);

        return true;

    }

    function multiTransfer(address[] memory _destinations, uint256[] memory _values) public returns (uint256) {

        uint256 max = 0;
        uint256 totalSent = 0;

		for (uint256 i = 0; i < _destinations.length; i++) {

            require(_transferCheck(msg.sender, _destinations[i], _values[i]));
            userBalances[_destinations[i]] = SafeMath.safeAdd(userBalances[_destinations[i]], _values[i]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            totalSent += _values[i];

            emit Transfer(msg.sender, _destinations[i], _values[i]);

            max = i;

        }

        userBalances[msg.sender] = SafeMath.safeSub(userBalances[msg.sender], totalSent);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        return max;

    }

    function approve(address _spender, uint256 _amount) public returns (bool approved) {

        require(_amount >= 0);
        userAllowances[msg.sender][_spender] = _amount;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        emit Approval(msg.sender, _spender, _amount);

        return true;

    }

    function balanceOf(address _address) public view returns (uint256 balance) {

        return userBalances[_address];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    }

    function allowance(address _owner, address _spender) public view returns (uint256 allowed) {

        return userAllowances[_owner][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    }

    function totalSupply() public view returns (uint256 supply) {

        return _totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    }

}