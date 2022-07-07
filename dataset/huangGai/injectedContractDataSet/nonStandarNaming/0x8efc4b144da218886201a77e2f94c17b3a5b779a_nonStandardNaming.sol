pragma solidity ^0.5.1;

// File: contracts/Cogmento.sol

interface IERC20 {
  function TOTALSUPPLY452() external view returns (uint256);	//inject NONSTANDARD NAMING

  function BALANCEOF833(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

  function ALLOWANCE554(address owner, address spender)	//inject NONSTANDARD NAMING
    external view returns (uint256);

  function TRANSFER570(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

  function APPROVE66(address spender, uint256 value)	//inject NONSTANDARD NAMING
    external returns (bool);

  function TRANSFERFROM524(address from, address to, uint256 value)	//inject NONSTANDARD NAMING
    external returns (bool);

  event TRANSFER174(	//inject NONSTANDARD NAMING
    address indexed from,
    address indexed to,
    uint256 value
  );

  event APPROVAL465(	//inject NONSTANDARD NAMING
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

library SafeMath {

                                                                
  function MUL507(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

                                                                                                         
  function DIV872(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                            
  function SUB851(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

                                                          
  function ADD842(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

                                                                                                                               
  function MOD98(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b != 0);
    return a % b;
  }
}

contract Owned {
    address public owner;
    address public newOwner;
    modifier ONLYOWNER420 {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }
    function TRANSFEROWNERSHIP119(address _newOwner) public ONLYOWNER420 {	//inject NONSTANDARD NAMING
        newOwner = _newOwner;
    }
    function ACCEPTOWNERSHIP717() public {	//inject NONSTANDARD NAMING
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
        _balances[owner] = 1000000000 * 10 ** decimals102;
        _balances[contractAddress] = 1000000000 * 10 ** decimals102;
        emit TRANSFER174(address(0), owner, 1000000000 * 10 ** decimals102);
        emit TRANSFER174(address(0), contractAddress, 1000000000 * 10 ** decimals102);
    }
    
    // Events
    event ERROR503(string err);	//inject NONSTANDARD NAMING
    event MINT826(uint mintAmount, address to);	//inject NONSTANDARD NAMING
    event BURN394(uint burnAmount, address from);	//inject NONSTANDARD NAMING
    
    // Token Setup
    string public constant name276 = "Cogmento";	//inject NONSTANDARD NAMING
    string public constant symbol405 = "COGS";	//inject NONSTANDARD NAMING
    uint256 public constant decimals102 = 18;	//inject NONSTANDARD NAMING
    uint256 public supply = 1000000000 * 10 ** decimals102;
    
    address private contractAddress;
    uint256 public ICOPrice;
    
    // Balances for each account
    mapping(address => uint256) _balances;
 
    // Owner of account approves the transfer of an amount to another account
    mapping(address => mapping (address => uint256)) public _allowed;
 
    // Get the total supply of tokens
    function TOTALSUPPLY452() public view returns (uint) {	//inject NONSTANDARD NAMING
        return supply;
    }
 
    // Get the token balance for account `tokenOwner`
    function BALANCEOF833(address tokenOwner) public view returns (uint balance) {	//inject NONSTANDARD NAMING
        return _balances[tokenOwner];
    }
 
    // Get the allowance of funds beteen a token holder and a spender
    function ALLOWANCE554(address tokenOwner, address spender) public view returns (uint remaining) {	//inject NONSTANDARD NAMING
        return _allowed[tokenOwner][spender];
    }
 
    // Transfer the balance from owner's account to another account
    function TRANSFER570(address to, uint value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(_balances[msg.sender] >= value);
        require(to != contractAddress);
        _balances[msg.sender] = _balances[msg.sender].SUB851(value);
        _balances[to] = _balances[to].ADD842(value);
        emit TRANSFER174(msg.sender, to, value);
        return true;
    }
    
    // Sets how much a sender is allowed to use of an owners funds
    function APPROVE66(address spender, uint value) public returns (bool success) {	//inject NONSTANDARD NAMING
        _allowed[msg.sender][spender] = value;
        emit APPROVAL465(msg.sender, spender, value);
        return true;
    }
    
    // Transfer from function, pulls from allowance
    function TRANSFERFROM524(address from, address to, uint value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(value <= BALANCEOF833(from));
        require(value <= ALLOWANCE554(from, to));
        _balances[from] = _balances[from].SUB851(value);
        _balances[to] = _balances[to].ADD842(value);
        _allowed[from][to] = _allowed[from][to].SUB851(value);
        emit TRANSFER174(from, to, value);
        return true;
    }
    
    // Users Cannot acidentaly send ETH to the contract
    function () external payable {
        revert();
    }
    
    // Owner Can mint new tokens
    function MINT964(uint256 amount, address to) public ONLYOWNER420 {	//inject NONSTANDARD NAMING
        _balances[to] = _balances[to].ADD842(amount);
        supply = supply.ADD842(amount);
        emit MINT826(amount, to);
    }
    
    // Owner can burn existing tokens
    function BURN156(uint256 amount, address from) public ONLYOWNER420 {	//inject NONSTANDARD NAMING
        require(_balances[from] >= amount);
        _balances[from] = _balances[from].SUB851(amount);
        supply = supply.SUB851(amount);
        emit BURN394(amount, from);
    }
    
    // Change ICO Price
    function SETICOPRICE755(uint256 _newPrice) public ONLYOWNER420 {	//inject NONSTANDARD NAMING
        ICOPrice = _newPrice;
    }
    
    // See how many tokens are available to be purcahsed.
    function GETREMAININGICOBALANCE812() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[contractAddress];
    }
    
    // Top up ICO balance
    function TOPUPICO333(uint256 _amount) public ONLYOWNER420 {	//inject NONSTANDARD NAMING
        require(_balances[owner] >= _amount);
        _balances[owner] = _balances[owner].SUB851(_amount);
        _balances[contractAddress] = _balances[contractAddress].ADD842(_amount);
        emit TRANSFER174(msg.sender, contractAddress, _amount);
    }
    
    
    // Buy tokens
    function BUYTOKENS290() public payable {	//inject NONSTANDARD NAMING
        require(ICOPrice > 0);
        require(msg.value >= ICOPrice);
        uint256 affordAmount = msg.value / ICOPrice;
        require(_balances[contractAddress] >= affordAmount * 10 ** decimals102);
        _balances[contractAddress] = _balances[contractAddress].SUB851(affordAmount * 10 ** decimals102);
        _balances[msg.sender] = _balances[msg.sender].ADD842(affordAmount * 10 ** decimals102);
        emit TRANSFER174(contractAddress, msg.sender, affordAmount * 10 ** decimals102);
    }
    
    // Withdraw ETH
    function WITHDRAWCONTRACTBALANCE542() public ONLYOWNER420 {	//inject NONSTANDARD NAMING
        msg.sender.transfer(contractAddress.balance);
    }
    
    // Cancel and withdraw ICO tokens
    function WITHDRAWCONTRACTTOKENS839(uint256 _amount) public ONLYOWNER420 {	//inject NONSTANDARD NAMING
        require(_balances[contractAddress] >= _amount);
        _balances[contractAddress] = _balances[contractAddress].SUB851(_amount);
        _balances[owner] = _balances[owner].ADD842(_amount);
        emit TRANSFER174(contractAddress, owner, _amount);
    }
}