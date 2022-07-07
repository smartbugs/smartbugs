pragma solidity ^0.5.1;

// File: contracts/Cogmento.sol

interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR


    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

contract Owned {
    address public owner;
    address public newOwner;
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        owner = newOwner;
    }
}

contract CogmentoToken is IERC20, Owned {
    using SafeMath for uint256;
    
    // Constructor - Sets the token Owner
    constructor() public {
        owner = 0xFCAeeDcC9DfEB56af067f3d4e79caB8ABDd31cF7;
        contractAddress = address(this);
        _balances[owner] = 1000000000 * 10 ** decimals;
        _balances[contractAddress] = 1000000000 * 10 ** decimals;
        emit Transfer(address(0), owner, 1000000000 * 10 ** decimals);
        emit Transfer(address(0), contractAddress, 1000000000 * 10 ** decimals);
    }
    
    // Events
    event Error(string err);
    event Mint(uint mintAmount, address to);
    event Burn(uint burnAmount, address from);
    
    // Token Setup
    string public constant name = "Cogmento";
    string public constant symbol = "COGS";
    uint256 public constant decimals = 18;
    uint256 public supply ;	//inject UNINIT LOCAL/STATE VAR

    
    address private contractAddress;
    uint256 public ICOPrice;
    
    // Balances for each account
    mapping(address => uint256) _balances;
 
    // Owner of account approves the transfer of an amount to another account
    mapping(address => mapping (address => uint256)) public _allowed;
 
    // Get the total supply of tokens
    function totalSupply() public view returns (uint) {
        return supply;
    }
 
    // Get the token balance for account `tokenOwner`
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return _balances[tokenOwner];
    }
 
    // Get the allowance of funds beteen a token holder and a spender
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return _allowed[tokenOwner][spender];
    }
 
    // Transfer the balance from owner's account to another account
    function transfer(address to, uint value) public returns (bool success) {
        require(_balances[msg.sender] >= value);
        require(to != contractAddress);
        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    // Sets how much a sender is allowed to use of an owners funds
    function approve(address spender, uint value) public returns (bool success) {
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    // Transfer from function, pulls from allowance
    function transferFrom(address from, address to, uint value) public returns (bool success) {
        require(value <= balanceOf(from));
        require(value <= allowance(from, to));
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowed[from][to] = _allowed[from][to].sub(value);
        emit Transfer(from, to, value);
        return true;
    }
    
    // Users Cannot acidentaly send ETH to the contract
    function () external payable {
        revert();
    }
    
    // Owner Can mint new tokens
    function mint(uint256 amount, address to) public onlyOwner {
        _balances[to] = _balances[to].add(amount);
        supply = supply.add(amount);
        emit Mint(amount, to);
    }
    
    // Owner can burn existing tokens
    function burn(uint256 amount, address from) public onlyOwner {
        require(_balances[from] >= amount);
        _balances[from] = _balances[from].sub(amount);
        supply = supply.sub(amount);
        emit Burn(amount, from);
    }
    
    // Change ICO Price
    function setICOPrice(uint256 _newPrice) public onlyOwner {
        ICOPrice = _newPrice;
    }
    
    // See how many tokens are available to be purcahsed.
    function getRemainingICOBalance() public view returns (uint256) {
        return _balances[contractAddress];
    }
    
    // Top up ICO balance
    function topUpICO(uint256 _amount) public onlyOwner {
        require(_balances[owner] >= _amount);
        _balances[owner] = _balances[owner].sub(_amount);
        _balances[contractAddress] = _balances[contractAddress].add(_amount);
        emit Transfer(msg.sender, contractAddress, _amount);
    }
    
    
    // Buy tokens
    function buyTokens() public payable {
        require(ICOPrice > 0);
        require(msg.value >= ICOPrice);
        uint256 affordAmount ;	//inject UNINIT LOCAL/STATE VAR

        require(_balances[contractAddress] >= affordAmount * 10 ** decimals);
        _balances[contractAddress] = _balances[contractAddress].sub(affordAmount * 10 ** decimals);
        _balances[msg.sender] = _balances[msg.sender].add(affordAmount * 10 ** decimals);
        emit Transfer(contractAddress, msg.sender, affordAmount * 10 ** decimals);
    }
    
    // Withdraw ETH
    function withdrawContractBalance() public onlyOwner {
        msg.sender.transfer(contractAddress.balance);
    }
    
    // Cancel and withdraw ICO tokens
    function withdrawContractTokens(uint256 _amount) public onlyOwner {
        require(_balances[contractAddress] >= _amount);
        _balances[contractAddress] = _balances[contractAddress].sub(_amount);
        _balances[owner] = _balances[owner].add(_amount);
        emit Transfer(contractAddress, owner, _amount);
    }
}