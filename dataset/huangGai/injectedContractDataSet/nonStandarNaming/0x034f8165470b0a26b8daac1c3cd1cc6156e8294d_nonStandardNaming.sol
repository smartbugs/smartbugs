pragma solidity >=0.5.4 <0.6.0;

// ----------------------------------------------------------------------------
// 'ERCT' 'Eracoin Token' token contract
//
// Symbol      : ERCT
// Name        : Eracoin Token
// Total supply: 300,000,000.000000000000000000
// Decimals    : 18
//
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
library SafeMath {
    function ADD53(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
        c = a + b;
        require(c >= a);
    }
    function SUB848(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
        require(b <= a);
        c = a - b;
    }
    function MUL294(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function DIV305(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
        require(b > 0);
        c = a / b;
    }
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function TOTALSUPPLY404() public view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF531(address tokenOwner) public view returns (uint balance);	//inject NONSTANDARD NAMING
    function ALLOWANCE38(address tokenOwner, address spender) public view returns (uint remaining);	//inject NONSTANDARD NAMING
    function TRANSFER948(address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
    function APPROVE272(address spender, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
    function TRANSFERFROM23(address from, address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING

    function BURN816(uint256 value) public returns (bool success);	//inject NONSTANDARD NAMING
    function BURNFROM553(address from, uint256 value) public returns (bool success);	//inject NONSTANDARD NAMING
    
    function MINT414(address recipient, uint256 value) public returns (bool success);	//inject NONSTANDARD NAMING

    event TRANSFER511(address indexed from, address indexed to, uint tokens);	//inject NONSTANDARD NAMING
    event APPROVAL847(address indexed tokenOwner, address indexed spender, uint tokens);	//inject NONSTANDARD NAMING
    event BURN12(address indexed from, uint256 value);	//inject NONSTANDARD NAMING
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function RECEIVEAPPROVAL348(address from, uint256 tokens, address token, bytes memory data) public;	//inject NONSTANDARD NAMING
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OWNERSHIPTRANSFERRED483(address indexed _from, address indexed _to);	//inject NONSTANDARD NAMING

    constructor() public {
        owner = msg.sender;
    }

    modifier ONLYOWNER553 {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

    function TRANSFEROWNERSHIP255(address _newOwner) public ONLYOWNER553 {	//inject NONSTANDARD NAMING
        newOwner = _newOwner;
    }
    function ACCEPTOWNERSHIP507() public {	//inject NONSTANDARD NAMING
        require(msg.sender == newOwner);
        emit OWNERSHIPTRANSFERRED483(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and a
// fixed supply
// ----------------------------------------------------------------------------
contract EracoinToken is ERC20Interface, Owned {
    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    
    event TRANSFER511(address indexed from, address indexed to, uint tokens);	//inject NONSTANDARD NAMING
    event APPROVAL847(address indexed tokenOwner, address indexed spender, uint tokens);	//inject NONSTANDARD NAMING
    event BURN12(address indexed from, uint256 tokens);	//inject NONSTANDARD NAMING


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        symbol = "ERCT";
        name = "Eracoin Token";
        decimals = 18;
        _totalSupply = 300000000 * 10**uint(decimals);
        balances[owner] = _totalSupply;
        emit TRANSFER511(address(0), owner, _totalSupply);
    }


    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function TOTALSUPPLY404() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply.SUB848(balances[address(0)]);
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function BALANCEOF531(address tokenOwner) public view returns (uint balance) {	//inject NONSTANDARD NAMING
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function TRANSFER948(address to, uint tokens) public returns (bool success) {	//inject NONSTANDARD NAMING
        balances[msg.sender] = balances[msg.sender].SUB848(tokens);
        balances[to] = balances[to].ADD53(tokens);
        emit TRANSFER511(msg.sender, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces
    // ------------------------------------------------------------------------
    function APPROVE272(address spender, uint tokens) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][spender] = tokens;
        emit APPROVAL847(msg.sender, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function TRANSFERFROM23(address from, address to, uint tokens) public returns (bool success) {	//inject NONSTANDARD NAMING
        balances[from] = balances[from].SUB848(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].SUB848(tokens);
        balances[to] = balances[to].ADD53(tokens);
        emit TRANSFER511(from, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function ALLOWANCE38(address tokenOwner, address spender) public view returns (uint remaining) {	//inject NONSTANDARD NAMING
        return allowed[tokenOwner][spender];
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    function APPROVEANDCALL920(address spender, uint tokens, bytes memory data) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][spender] = tokens;
        emit APPROVAL847(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).RECEIVEAPPROVAL348(msg.sender, tokens, address(this), data);
        return true;
    }

                                                                                                                                                               
    function BURN816(uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(balances[msg.sender] >= _value);   // Check if the sender has enough
        balances[msg.sender] -= _value;            // Subtract from the sender
        _totalSupply -= _value;                      // Updates totalSupply
        emit BURN12(msg.sender, _value);
        return true;
    }

                                                                                                                                                                                                                                                      
    function BURNFROM553(address _from, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(balances[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowed[_from][msg.sender]);    // Check allowance
        balances[_from] -= _value;                         // Subtract from the targeted balance
        allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        _totalSupply -= _value;                              // Update totalSupply
        emit BURN12(_from, _value);
        return true;
    }
    
                                                                                                                                                                                                                                                    
    function MINT414(address _recipient, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        require(_totalSupply + _value >= _totalSupply); // Overflow check
    
        _totalSupply += _value;
        balances[_recipient] += _value;
        emit TRANSFER511(address(0), _recipient, _value);
        return true;
    }

    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () external payable {
        revert();
    }


    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function TRANSFERANYERC20TOKEN682(address tokenAddress, uint tokens) public ONLYOWNER553 returns (bool success) {	//inject NONSTANDARD NAMING
        return ERC20Interface(tokenAddress).TRANSFER948(owner, tokens);
    }
}