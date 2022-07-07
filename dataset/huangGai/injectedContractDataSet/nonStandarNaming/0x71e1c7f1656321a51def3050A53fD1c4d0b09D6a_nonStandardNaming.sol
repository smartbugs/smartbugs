                                                                 

                                                                                                                                                                                                                                                                                                                                                                 
pragma solidity ^0.5.16;

interface IERC20 {
    function TOTALSUPPLY152() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF516(address account) external view returns (uint);	//inject NONSTANDARD NAMING
    function TRANSFER165(address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE180(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE884(address spender, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM740(address sender, address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER666(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING
    event APPROVAL764(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER480() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint;

    address admin;

    uint burnFee = 5;

    mapping (address => uint) private _balances;

    mapping (address => mapping (address => uint)) private _allowances;

    uint private _totalSupply;
    function TOTALSUPPLY152() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF516(address account) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER165(address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER36(_MSGSENDER480(), recipient, amount);
        return true;
    }
    function ALLOWANCE180(address owner, address spender) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE884(address spender, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE223(_MSGSENDER480(), spender, amount);
        return true;
    }
    function TRANSFERFROM740(address sender, address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER36(sender, recipient, amount);
        _APPROVE223(sender, _MSGSENDER480(), _allowances[sender][_MSGSENDER480()].SUB13(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE882(address spender, uint addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE223(_MSGSENDER480(), spender, _allowances[_MSGSENDER480()][spender].ADD65(addedValue));
        return true;
    }
    function DECREASEALLOWANCE188(address spender, uint subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE223(_MSGSENDER480(), spender, _allowances[_MSGSENDER480()][spender].SUB13(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER36(address sender, address recipient, uint amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        uint amountRec = amount;
        uint amountBurn = 0;

        if(sender != admin && recipient != admin){   //this is for the initial Pool Liquidity
            amountBurn = amount.MUL68(burnFee).DIV539(100);
            amountRec = amount.SUB13(amountBurn);
        }
        

        _balances[sender] = _balances[sender].SUB13(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD65(amountRec);
        _totalSupply = _totalSupply.SUB13(amountBurn);

        emit TRANSFER666(sender, recipient, amountRec);
        emit TRANSFER666(sender, address(0), amountBurn);
        
    }

    function _BURN151(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB13(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB13(amount);
        emit TRANSFER666(account, address(0), amount);
    }

    function ADDBALANCE187(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: add to the zero address");

        _balances[account] = _balances[account].ADD65(amount);
        _totalSupply = _totalSupply.ADD65(amount);
        emit TRANSFER666(address(0), account, amount);
    }



    function _APPROVE223(address owner, address spender, uint amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL764(owner, spender, amount);
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
    function NAME274() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    function SYMBOL422() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }
    function DECIMALS957() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library SafeMath {
    function ADD65(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB13(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB13(a, b, "SafeMath: subtraction overflow");
    }
    function SUB13(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function MUL68(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV539(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV539(a, b, "SafeMath: division by zero");
    }
    function DIV539(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

library Address {
    function ISCONTRACT481(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library SafeERC20 {
    using SafeMath for uint;
    using Address for address;

    function SAFETRANSFER478(IERC20 token, address to, uint value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN555(token, abi.encodeWithSelector(token.TRANSFER165.selector, to, value));
    }

    function SAFETRANSFERFROM992(IERC20 token, address from, address to, uint value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN555(token, abi.encodeWithSelector(token.TRANSFERFROM740.selector, from, to, value));
    }

    function SAFEAPPROVE661(IERC20 token, address spender, uint value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE180(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN555(token, abi.encodeWithSelector(token.APPROVE884.selector, spender, value));
    }
    function CALLOPTIONALRETURN555(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT481(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract VEGA is ERC20, ERC20Detailed {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint;

  
  constructor () public ERC20Detailed("UniLaunchpad.com | VEGA", "VGA", 18) {
      admin = msg.sender;
      ADDBALANCE187(admin,300000e18);  //Initial tokens for Uniswap Liquidity Pool
  }

   function BURN610(uint256 amount) public {	//inject NONSTANDARD NAMING
      _BURN151(msg.sender, amount);
  }

  function() external payable {

  }

   function WITHDRAW177() external {	//inject NONSTANDARD NAMING
      require(msg.sender == admin, "!not allowed");
      msg.sender.transfer(address(this).balance);
  }

}