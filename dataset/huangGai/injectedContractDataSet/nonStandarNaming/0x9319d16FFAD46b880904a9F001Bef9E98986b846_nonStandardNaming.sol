                                                                 

pragma solidity ^0.5.17;

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
//
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function TOTALSUPPLY636() public view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF625(address tokenOwner) public view returns (uint balance);	//inject NONSTANDARD NAMING
    function ALLOWANCE575(address tokenOwner, address spender) public view returns (uint remaining);	//inject NONSTANDARD NAMING
    function TRANSFER756(address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
    function APPROVE785(address spender, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
    function TRANSFERFROM774(address from, address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING

    event TRANSFER823(address indexed from, address indexed to, uint tokens);	//inject NONSTANDARD NAMING
    event APPROVAL867(address indexed tokenOwner, address indexed spender, uint tokens);	//inject NONSTANDARD NAMING
}

// ----------------------------------------------------------------------------
// Safe Math Library 
// ----------------------------------------------------------------------------
contract SafeMath {
    function SAFEADD935(uint a, uint b) public pure returns (uint c) {	//inject NONSTANDARD NAMING
        c = a + b;
        require(c >= a);
    }
    function SAFESUB706(uint a, uint b) public pure returns (uint c) {	//inject NONSTANDARD NAMING
        require(b <= a); c = a - b; } function SAFEMUL773(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function SAFEDIV219(uint a, uint b) public pure returns (uint c) { require(b > 0);	//inject NONSTANDARD NAMING
        c = a / b;
    }
}


contract CasinoCoin is ERC20Interface, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
    
    uint256 public _totalSupply;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
                                                                                                                                       
    constructor() public {
        name = "CasinoCoin Phase 0";
        symbol = "CSIN0";
        decimals = 18;
        _totalSupply = 1000000000000000000000;
        
        balances[msg.sender] = _totalSupply;
        emit TRANSFER823(address(0), msg.sender, _totalSupply);
    }
    
    function TOTALSUPPLY636() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply  - balances[address(0)];
    }
    
    function BALANCEOF625(address tokenOwner) public view returns (uint balance) {	//inject NONSTANDARD NAMING
        return balances[tokenOwner];
    }
    
    function ALLOWANCE575(address tokenOwner, address spender) public view returns (uint remaining) {	//inject NONSTANDARD NAMING
        return allowed[tokenOwner][spender];
    }
    
    function APPROVE785(address spender, uint tokens) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][spender] = tokens;
        emit APPROVAL867(msg.sender, spender, tokens);
        return true;
    }
    
    function TRANSFER756(address to, uint tokens) public returns (bool success) {	//inject NONSTANDARD NAMING
        balances[msg.sender] = SAFESUB706(balances[msg.sender], tokens);
        balances[to] = SAFEADD935(balances[to], tokens);
        emit TRANSFER823(msg.sender, to, tokens);
        return true;
    }
    
    function TRANSFERFROM774(address from, address to, uint tokens) public returns (bool success) {	//inject NONSTANDARD NAMING
        balances[from] = SAFESUB706(balances[from], tokens);
        allowed[from][msg.sender] = SAFESUB706(allowed[from][msg.sender], tokens);
        balances[to] = SAFEADD935(balances[to], tokens);
        emit TRANSFER823(from, to, tokens);
        return true;
    }
   
    
}