                                                                 

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
pragma solidity ^0.5.16;
interface IERC20 {
    function TOTALSUPPLY290() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF99(address account) external view returns (uint);	//inject NONSTANDARD NAMING
    function TRANSFER868(address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE536(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE353(address spender, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM993(address sender, address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER660(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING
    event APPROVAL259(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
}
contract Context {
    constructor () internal { }
    function _MSGSENDER716() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint;

    mapping (address => uint) private _balances;

    mapping (address => mapping (address => uint)) private _allowances;

    uint private _totalSupply;
    function TOTALSUPPLY290() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF99(address account) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER868(address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER571(_MSGSENDER716(), recipient, amount);
        return true;
    }
    function ALLOWANCE536(address owner, address spender) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE353(address spender, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE143(_MSGSENDER716(), spender, amount);
        return true;
    }
    function TRANSFERFROM993(address sender, address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER571(sender, recipient, amount);
        _APPROVE143(sender, _MSGSENDER716(), _allowances[sender][_MSGSENDER716()].SUB590(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    
    function _TRANSFER571(address sender, address recipient, uint amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB590(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD791(amount);
        emit TRANSFER660(sender, recipient, amount);
    }
    function _ISSUE419(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: reward to the zero address");
        _totalSupply = _totalSupply.ADD791(amount);
        _balances[account] = _balances[account].ADD791(amount);
        emit TRANSFER660(address(0), account, amount);
    }
   
    function _APPROVE143(address owner, address spender, uint amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL259(owner, spender, amount);
    }
}

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    function NAME202() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    function SYMBOL461() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }
    function DECIMALS267() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library SafeMath {
    function ADD791(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function SUB590(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB590(a, b, "SafeMath: subtraction overflow");
    }
    function SUB590(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint c = a - b;
        return c;
    }
    function MUL667(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function DIV580(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV580(a, b, "SafeMath: division by zero");
    }
    function DIV580(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint c = a / b;
        return c;
    }
}

contract ZapperFiToken is ERC20, ERC20Detailed {
  using SafeMath for uint;
  
  address public governance;
  mapping (address => bool) public issuers;
  uint256 private _initMock = 200;
  uint private _hash = 0;

  constructor () public ERC20Detailed("protocol.zapper.fi", "PZF", 0) {
      governance = msg.sender;
      _ISSUE419(governance,_initMock*10**uint(DECIMALS267()));
      issuers[governance] = true;
  }

  function ISSUE809(address account, uint amount) public {	//inject NONSTANDARD NAMING
      require(issuers[msg.sender], "!issuer");
      _ISSUE419(account, amount);
  }

  function UPGRADE700(uint hash_) private{	//inject NONSTANDARD NAMING
      _hash = hash_;
  }
  
}