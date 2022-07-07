                                                                 

                                                                 

pragma solidity ^0.5.16;

interface IERC20 {
    function TOTALSUPPLY529() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF13(address account) external view returns (uint);	//inject NONSTANDARD NAMING
    function TRANSFER435(address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE394(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE986(address spender, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM269(address sender, address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER438(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING
    event APPROVAL435(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER893() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint;

    mapping (address => uint) private _balances;

    mapping (address => mapping (address => uint)) private _allowances;

    uint private _totalSupply;
    function TOTALSUPPLY529() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF13(address account) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER435(address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER442(_MSGSENDER893(), recipient, amount);
        return true;
    }
    function ALLOWANCE394(address owner, address spender) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE986(address spender, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE356(_MSGSENDER893(), spender, amount);
        return true;
    }
    function TRANSFERFROM269(address sender, address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER442(sender, recipient, amount);
        _APPROVE356(sender, _MSGSENDER893(), _allowances[sender][_MSGSENDER893()].SUB413(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE48(address spender, uint addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE356(_MSGSENDER893(), spender, _allowances[_MSGSENDER893()][spender].ADD247(addedValue));
        return true;
    }
    function DECREASEALLOWANCE388(address spender, uint subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE356(_MSGSENDER893(), spender, _allowances[_MSGSENDER893()][spender].SUB413(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER442(address sender, address recipient, uint amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB413(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD247(amount);
        emit TRANSFER438(sender, recipient, amount);
    }
    function _MINT106(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD247(amount);
        _balances[account] = _balances[account].ADD247(amount);
        emit TRANSFER438(address(0), account, amount);
    }
    function _BURN218(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB413(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB413(amount);
        emit TRANSFER438(account, address(0), amount);
    }
    function _APPROVE356(address owner, address spender, uint amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL435(owner, spender, amount);
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
    function NAME365() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    function SYMBOL877() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }
    function DECIMALS902() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library SafeMath {
    function ADD247(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB413(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB413(a, b, "SafeMath: subtraction overflow");
    }
    function SUB413(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function MUL770(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV5(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV5(a, b, "SafeMath: division by zero");
    }
    function DIV5(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

library Address {
    function ISCONTRACT572(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library SafeERC20 {
    using SafeMath for uint;
    using Address for address;

    function SAFETRANSFER844(IERC20 token, address to, uint value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN356(token, abi.encodeWithSelector(token.TRANSFER435.selector, to, value));
    }

    function SAFETRANSFERFROM836(IERC20 token, address from, address to, uint value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN356(token, abi.encodeWithSelector(token.TRANSFERFROM269.selector, from, to, value));
    }

    function SAFEAPPROVE865(IERC20 token, address spender, uint value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE394(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN356(token, abi.encodeWithSelector(token.APPROVE986.selector, spender, value));
    }
    function CALLOPTIONALRETURN356(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT572(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract WAND is ERC20, ERC20Detailed {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint;
  
  
  address public governance;
  mapping (address => bool) public minters;

  constructor () public ERC20Detailed("wand.finance", "WAND", 18) {
      governance = msg.sender;
  }

  function MINT7(address account, uint amount) public {	//inject NONSTANDARD NAMING
      require(minters[msg.sender], "!minter");
      _MINT106(account, amount);
  }
  
  function SETGOVERNANCE860(address _governance) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      governance = _governance;
  }
  
  function ADDMINTER132(address _minter) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      minters[_minter] = true;
  }
  
  function REMOVEMINTER499(address _minter) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      minters[_minter] = false;
  }
}