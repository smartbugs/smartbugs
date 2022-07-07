                                                                 

pragma solidity ^0.6.7;


contract Owned {
    modifier ONLYOWNER777() {	//inject NONSTANDARD NAMING
        require(msg.sender==owner);
        _;
    }
    address payable owner;
    address payable newOwner;
    function CHANGEOWNER518(address payable _newOwner) public ONLYOWNER777 {	//inject NONSTANDARD NAMING
        require(_newOwner!=address(0));
        newOwner = _newOwner;
    }
    function ACCEPTOWNERSHIP182() public {	//inject NONSTANDARD NAMING
        if (msg.sender==newOwner) {
            owner = newOwner;
        }
    }
}

abstract contract ERC20 {
    uint256 public totalSupply;
    function BALANCEOF776(address _owner) view public virtual returns (uint256 balance);	//inject NONSTANDARD NAMING
    function TRANSFER467(address _to, uint256 _value) public virtual returns (bool success);	//inject NONSTANDARD NAMING
    function TRANSFERFROM705(address _from, address _to, uint256 _value) public virtual returns (bool success);	//inject NONSTANDARD NAMING
    function APPROVE335(address _spender, uint256 _value) public virtual returns (bool success);	//inject NONSTANDARD NAMING
    function ALLOWANCE212(address _owner, address _spender) view public virtual returns (uint256 remaining);	//inject NONSTANDARD NAMING
    event TRANSFER557(address indexed _from, address indexed _to, uint256 _value);	//inject NONSTANDARD NAMING
    event APPROVAL765(address indexed _owner, address indexed _spender, uint256 _value);	//inject NONSTANDARD NAMING
}

contract Token is Owned,  ERC20 {
    string public symbol;
    string public name;
    uint8 public decimals;
    mapping (address=>uint256) balances;
    mapping (address=>mapping (address=>uint256)) allowed;
    
    function BALANCEOF776(address _owner) view public virtual override returns (uint256 balance) {return balances[_owner];}	//inject NONSTANDARD NAMING
    
    function TRANSFER467(address _to, uint256 _amount) public virtual override returns (bool success) {	//inject NONSTANDARD NAMING
        require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit TRANSFER557(msg.sender,_to,_amount);
        return true;
    }
  
    function TRANSFERFROM705(address _from,address _to,uint256 _amount) public virtual override returns (bool success) {	//inject NONSTANDARD NAMING
        require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[_from]-=_amount;
        allowed[_from][msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit TRANSFER557(_from, _to, _amount);
        return true;
    }
  
    function APPROVE335(address _spender, uint256 _amount) public virtual override returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender]=_amount;
        emit APPROVAL765(msg.sender, _spender, _amount);
        return true;
    }
    
    function ALLOWANCE212(address _owner, address _spender) view public virtual override returns (uint256 remaining) {	//inject NONSTANDARD NAMING
      return allowed[_owner][_spender];
    }
}

contract YBOOST is Token{
    
    constructor() public{
        symbol = "YBOOST";
        name = "YBOOST.FINANCE";
        decimals = 18;
        totalSupply = 29330000000000000000000;  
        owner = msg.sender;
        balances[owner] = totalSupply;
    }
    
    receive () payable external {
        require(msg.value>0);
        owner.transfer(msg.value);
    }
}