/**
 *Submitted for verification at Etherscan.io on 2020-10-12
*/

pragma solidity ^0.5.12;
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
// Safe maths
// ----------------------------------------------------------------------------
library SafeMath {
  function add(uint a, uint b) internal pure returns (uint c) {
    c = a + b;
    require(c >= a);
  }
  function sub(uint a, uint b) internal pure returns (uint c) {
    require(b <= a);
    c = a - b;
  }
  function mul(uint a, uint b) internal pure returns (uint c) {
    c = a * b;
    require(a == 0 || c / a == b); // the same as: if (a !=0 && c / a != b) {throw;}
  }
  function div(uint a, uint b) internal pure returns (uint c) {
    require(b > 0);
    c = a / b;
  }
}

// ----------------------------------------------------------------------------
// Ownable Contract
// ----------------------------------------------------------------------------
contract Ownable {
  address internal owner;
  address internal master;
  event MasterOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  event SetOwner(address indexed previousOwner, address indexed newOwner);
  
  // The Ownable constructor sets the original `owner` of the contract to the sender account
  constructor() public {
    owner = msg.sender;
    master = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner||msg.sender == master);
    _;
  }

  function setOwnership(address newOwner) public {
    require(msg.sender == master);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(newOwner != address(0));
    emit SetOwner(owner, newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  
  function transferMasterOwnership(address newOwner) public {
    require(msg.sender == master);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(newOwner != address(0));
    emit MasterOwnershipTransferred(owner, newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    master = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
}

// ----------------------------------------------------------------------------
// Pausable Contract
// ----------------------------------------------------------------------------
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool internal paused = false;

  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  modifier whenPaused() {
    require(paused);
    _;
  }

  //pause transfer when emergency
  function pause() onlyOwner whenNotPaused public {
    paused = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Pause();
  }

  function unpause() onlyOwner whenPaused public {
    paused = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Unpause();
  }
}

// ----------------------------------------------------------------------------
// BlackList Contract
// ----------------------------------------------------------------------------
contract BlackList is Ownable {

    event AddedBlackList(address indexed _user);
    event RemovedBlackList(address indexed _user);

    mapping (address => bool) internal isBlackListed;

    function getBlackListStatus(address _addr) public view returns (bool) {
        return isBlackListed[_addr];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function addBlackList (address _addr) public onlyOwner {
        isBlackListed[_addr] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit AddedBlackList(_addr);
    }

    function removeBlackList (address _addr) public onlyOwner {
        isBlackListed[_addr] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit RemovedBlackList(_addr);
    }
}

// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and an
// initial fixed supply
// ----------------------------------------------------------------------------
contract USDRToken is ERC20Interface, Pausable, BlackList {
  using SafeMath for uint;

  string public symbol;
  string public  name;
  uint8 public decimals;
  uint _totalSupply;

  mapping(address => uint) balances;
  mapping(address => mapping(address => uint)) allowed;
  
  event IncrementSupply(address indexed owner, uint256 increments);
  event BurnTokens(address indexed owner, uint256 amount);
  event BrunBlackTokens(address indexed blackListedUser, uint256 amount);  


  // ------------------------------------------------------------------------
  // Constructor
  // ------------------------------------------------------------------------
  constructor() public {
    symbol = "USDR";
    name = "USD Receipt";
    decimals = 18;
    _totalSupply = 5460000 * 10**uint(decimals);
    balances[msg.sender] = _totalSupply;
    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  // ------------------------------------------------------------------------
  // Total supply
  // ------------------------------------------------------------------------
  function totalSupply() public view returns (uint) {
    return _totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  // ------------------------------------------------------------------------
  // Get the token balance for account `tokenOwner`
  // ------------------------------------------------------------------------
  function balanceOf(address tokenOwner) public view returns (uint balance) {
    return balances[tokenOwner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  // ------------------------------------------------------------------------
  // Transfer the balance from token owner's account to `to` account
  // - Owner's account must have sufficient balance to transfer
  // - 0 value transfers are allowed
  // ------------------------------------------------------------------------
  function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
    require(!isBlackListed[msg.sender],"blocked address");  	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(to != address(0), "to address is a zero address"); 
    balances[msg.sender] = balances[msg.sender].sub(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[to] = balances[to].add(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
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
  function approve(address spender, uint tokens) public returns (bool success) {
    require(spender != address(0), "spender address is a zero address");   
    allowed[msg.sender][spender] = tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
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
  function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
    require(!isBlackListed[from],"blocked address");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(to != address(0), "to address is a zero address"); 
    balances[from] = balances[from].sub(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[to] = balances[to].add(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Transfer(from, to, tokens);
    return true;
  }

  // ------------------------------------------------------------------------
  // Returns the amount of tokens approved by the owner that can be
  // transferred to the spender's account
  // ------------------------------------------------------------------------
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    return allowed[tokenOwner][spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  
  // ------------------------------------------------------------------------
  // Increment supply
  // ------------------------------------------------------------------------
  function incrementSupply(uint256 increments) public onlyOwner returns (bool){
    require(increments > 0);
    uint256 curTotalSupply = _totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    uint256 previousBalance = balanceOf(msg.sender);
    _totalSupply = curTotalSupply.add(increments);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[msg.sender] = previousBalance.add(increments);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit IncrementSupply(msg.sender, increments);
    emit Transfer(address(0), msg.sender, increments);
    return true;
  }
  
  // ------------------------------------------------------------------------
  // Burns `amount` tokens from `owner`
  // @param amount The quantity of tokens being burned
  // @return True if the tokens are burned correctly
  // ------------------------------------------------------------------------
  function burnTokens(uint256 amount) public onlyOwner returns (bool) {
    require(amount > 0);
    uint256 curTotalSupply = _totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(curTotalSupply >= amount);
    uint256 previousBalanceTo = balanceOf(msg.sender);
    require(previousBalanceTo >= amount);
    _totalSupply = curTotalSupply.sub(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[msg.sender] = previousBalanceTo.sub(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit BurnTokens(msg.sender, amount);
    emit Transfer(msg.sender, address(0), amount);
    return true;
  }
  
  function brunBlackTokens (address blackListedUser) public onlyOwner returns (bool) {
    require(isBlackListed[blackListedUser]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    uint256 dirtyFunds = balanceOf(blackListedUser);
    require(dirtyFunds > 0);
    uint256 curTotalSupply = _totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(curTotalSupply >= dirtyFunds);
    balances[blackListedUser] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    _totalSupply = curTotalSupply.sub(dirtyFunds);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit BurnTokens(blackListedUser, dirtyFunds);
    emit Transfer(blackListedUser, address(0), dirtyFunds);
    emit BrunBlackTokens(blackListedUser, dirtyFunds);
    return true;    
  }  

}