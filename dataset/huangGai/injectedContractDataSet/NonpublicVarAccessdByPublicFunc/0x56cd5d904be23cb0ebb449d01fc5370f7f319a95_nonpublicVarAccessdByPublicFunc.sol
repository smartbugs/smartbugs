pragma solidity ^0.5.4;

// ----------------------------------------------------------------------------
// 'vgna' token contract
//
// Deployed to : 
// Symbol      : VGNA
// Name        : VGNA Token
// Description : Virtual Geospatial Networking Asset
// Total supply: Dynamic ITO
// Decimals    : 18
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
        
    }
    function safeSub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address payable token, bytes memory data) public;
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address payable internal _owner;
    address payable private _newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        _owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == _owner);
        _;
    }

    function transferOwnership(address payable newOwner) public onlyOwner {
        _newOwner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function acceptOwnership() public {
        require(msg.sender == _newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit OwnershipTransferred(_owner, _newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = _newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _newOwner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and assisted
// token transfers
// ----------------------------------------------------------------------------
contract XYZZ is ERC20Interface, Owned, SafeMath {
    string public symbol;
    string public name;
    string public description;
    uint8 public decimals;    
    uint private _startDate;
    uint private _bonusEnds;
    uint private _endDate;
    
    uint256 private _internalCap;
    uint256 private _softCap;
    uint256 private _totalSupply;

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowed;
    mapping(address => bool) _freezeState;


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(
        address payable minter) public {
        
        name   = "VGNA Token";
        description = "Virtual Geospatial Networking Asset";
        symbol = "VGNA";
        decimals = 18;
        _internalCap = 25000000;
        _softCap     = 50000000;
        
        _bonusEnds = now + 3 days;
        _endDate = now + 1 weeks;
            
        _owner = minter;
        _balances[_owner] = _internalCap;  
        _totalSupply = _internalCap;
        emit Transfer(address(0), _owner, _internalCap);
    }

    modifier IcoSuccessful {
        require(now >= _endDate);
        require(_totalSupply >= _softCap);
        _;
    }


    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view returns (uint) {
        return _totalSupply - _balances[address(0)];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return _balances[tokenOwner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function isFreezed(address tokenOwner) public view returns (bool freezed) {
        return _freezeState[tokenOwner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint256 tokens) public IcoSuccessful returns (bool success) {
        require(_freezeState[msg.sender] == false);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        _balances[msg.sender] = safeSub(_balances[msg.sender], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _balances[to] = safeAdd(_balances[to], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(msg.sender, to, tokens);
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
    function approve(address spender, uint tokens) public IcoSuccessful returns (bool success) {
        require( _freezeState[spender] == false);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _allowed[msg.sender][spender] = tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, spender, tokens);
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
    function transferFrom(address from, address to, uint tokens) public IcoSuccessful returns (bool success) {
        require( _freezeState[from] == false && _freezeState[to] == false);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        _balances[from] = safeSub(_balances[from], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _allowed[from][msg.sender] = safeSub(_allowed[from][msg.sender], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _balances[to] = safeAdd(_balances[to], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(from, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        require(_freezeState[spender] == false);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return _allowed[tokenOwner][spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes memory data) public IcoSuccessful returns (bool success) {
        require(_freezeState[spender] == false);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _allowed[msg.sender][spender] = tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, _owner, data);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // 1 VGNA Tokens per 1 Wei
    // ------------------------------------------------------------------------
    function buy() public payable {
    
        require(msg.value >= 1 finney);
        require(now >= _startDate && now <= _endDate);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        uint256 weiValue = msg.value;
        uint256 tokens = 0;
        
        if (now <= _bonusEnds) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            tokens = safeMul(weiValue, 2);
        } else {
            tokens = safeMul(weiValue, 1);
        }
        
        _freezeState[msg.sender] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _balances[msg.sender] = safeAdd(_balances[msg.sender], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _totalSupply = safeAdd(_totalSupply, tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(address(0), msg.sender, tokens);
        _owner.transfer(msg.value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function () payable external {
        buy();
    }

    function burn(uint256 tokens) public onlyOwner returns (bool success) {
        require(_balances[msg.sender] >= tokens);   // Check if the sender has enough	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        address burner = msg.sender;
        _balances[burner] = safeSub(_balances[burner], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _totalSupply = safeSub(_totalSupply, tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(burner, address(0), tokens);
        return true;
    }
    
    function burnFrom(address account, uint256 tokens) public onlyOwner returns (bool success) {
        require(_balances[account] >= tokens);   // Check if the sender has enough	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        address burner = account;
        _balances[burner] = safeSub(_balances[burner], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _totalSupply = safeSub(_totalSupply, tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(burner, address(0), tokens);
        return true;
    }
    
    function freeze(address account) public onlyOwner returns (bool success) {
        require(account != _owner && account != address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _freezeState[account] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }
    
    function unfreeze(address account) public onlyOwner returns (bool success) {
        require(account != _owner && account != address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _freezeState[account] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }
    
    function mint(uint256 tokens) public onlyOwner returns (bool success)
    {
        require(now >= _startDate && now <= _endDate);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _balances[msg.sender] = safeAdd(_balances[msg.sender], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _totalSupply = safeAdd(_totalSupply, tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(address(0), msg.sender, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(_owner, tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}