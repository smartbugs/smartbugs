pragma solidity ^0.5.3;

// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        //require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        //require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
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
// MPAY Token Contract
// ----------------------------------------------------------------------------
contract MPAY is ERC20Interface, Owned{
    using SafeMath for uint;
    
    string public symbol;
    string public name;
    uint8 public decimals;
    uint _totalSupply;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    mapping(address => uint) unLockedCoins; // this will keep number of unLockedCoins per address
    struct PC {
    uint256 lockingPeriod;
    uint256 coins;
    bool added;
    }
    mapping(address => PC[]) record; // this will keep record of Locking periods and coins per address

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor(address _owner) public{
        symbol = "MPAY";
        name = "MPAY";
        decimals = 18;
        owner = _owner;
        _totalSupply = 4e8; //400,000,000
        balances[owner] = totalSupply();
        emit Transfer(address(0),owner,totalSupply());
    }

    function totalSupply() public view returns (uint){
       return _totalSupply * 10**uint(decimals);
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        if(msg.sender != owner){
            _updateUnLockedCoins(msg.sender, tokens);
            unLockedCoins[msg.sender] = unLockedCoins[msg.sender].sub(tokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        }
        // prevent transfer to 0x0, use burn instead
        require(to != address(0));
        require(to != address(this));
        balances[msg.sender] = balances[msg.sender].sub(tokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[to] = balances[to].add(tokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Transfer(msg.sender,to,tokens);
        return true;
    }
    
    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns (bool success){
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender,spender,tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    // 
    // The calling account must already have sufficient tokens approve(...)
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public returns (bool success){
        if(msg.sender != owner){
            _updateUnLockedCoins(from, tokens);
            unLockedCoins[from] = unLockedCoins[from].sub(tokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        }
        require(to != address(0));
        require(tokens <= allowed[from][msg.sender]); //check allowance
        balances[from] = balances[from].sub(tokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        balances[to] = balances[to].add(tokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        emit Transfer(from,to,tokens);
        return true;
    }
    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
    
    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // - takes in locking Period to lock the tokens to be used
    // - if want to transfer without locking enter 0 in lockingPeriod argument 
    // ------------------------------------------------------------------------
    function distributeTokens(address to, uint tokens, uint256 lockingPeriod) onlyOwner public returns (bool success) {
        // transfer tokens to the "to" address
        transfer(to, tokens);
        // if there is no lockingPeriod, add coins to unLockedCoins per address
        if(lockingPeriod == 0)
            unLockedCoins[to] = unLockedCoins[to].add(tokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

        // if there is a lockingPeriod, add coins to record mapping
        else
            _addRecord(to, tokens, lockingPeriod);
        return true;
    }
    
    // ------------------------------------------------------------------------
    // Adds record of addresses with locking period and coins to lock
    // ------------------------------------------------------------------------
    function _addRecord(address to, uint tokens, uint256 lockingPeriod) private {
            record[to].push(PC(lockingPeriod,tokens, false));
    }
    
    // ------------------------------------------------------------------------
    // Checks if there is any uunLockedCoins available
    // ------------------------------------------------------------------------
    function _updateUnLockedCoins(address _from, uint tokens) private returns (bool success) {
        // if unLockedCoins are greater than "tokens" of "to", initiate transfer
        if(unLockedCoins[_from] >= tokens){
            return true;
        }
        // if unLockedCoins are less than "tokens" of "to", update unLockedCoins by checking record with "now" time
        else{
            _updateRecord(_from);
            // check if unLockedCoins are greater than "token" of "to", initiate transfer
            if(unLockedCoins[_from] >= tokens){
                return true;
            }
            // otherwise revert
            else{
                revert();
            }
        }
    }
    
    // ------------------------------------------------------------------------
    // Unlock the coins if lockingPeriod is expired
    // ------------------------------------------------------------------------
    function _updateRecord(address _address) private returns (bool success){
        PC[] memory tempArray = record[_address];
        uint tempCount = 0;
        for(uint i=0; i < tempArray.length; i++){
            if(tempArray[i].lockingPeriod < now && tempArray[i].added == false){
                tempCount = tempCount.add(tempArray[i].coins);
                tempArray[i].added = true;
                record[_address][i] = PC(tempArray[i].lockingPeriod, tempArray[i].coins, tempArray[i].added);
            }
        }
        unLockedCoins[_address] = unLockedCoins[_address].add(tempCount);
        return true;
    }
    
}