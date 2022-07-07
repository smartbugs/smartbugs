                                                                 

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
//@@@@@@@@@@@@%/(#((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@((#((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@%(((#((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@((((#(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@##((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@#((##(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@%/###(&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@((##(%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@@@@@@@@@@@@((((((@@@@@@@@@@@@&((//(/((                                                                                                                                                                                                                                                                                                                                                                                                                                                        
//@@@@@@@@@@@@@@                                                                  
//@@@@@@@@@@@@@@@(((/#@%#%%%%%%%%%#((****##                                       
//@@@@@@@@@@@@@@@/#(//#%%%%%%%%%((                                                
//@@@@@@@@@@@@@@@((#%%%%%%%%%%%%#(                                                              /////                                                                                                              //      ((#(/((*@@@@@@@@
//@@@@@@@@@@@#%%%%%%%%%%%%%%(/#(*                                                            ////(((/////,@@@@@@
//@@@@@@@@@&%%%%%%%%%%%%#(###/(%%#(                                                                                                                             /(#(((*. **                           (#((#(((((*(#@@@
//@@@@@@@#%%%%%%%%%%%%%%%%%#(###*(##%%@@@***,,..@@,###(//(((##%@%,/,..@@,####&(@@@
//@@@@@%#%%%%%%%%%%%%%%%%%#(((%##/                       /./###/,,/..,,,,##                                                                                                                                                                                                                                                                                                                                                                           
//@@@@##%%%%%%%%%%%%%%#((((                                                       
//@@@@@#%%%%%%%%%%%%%##((                                                               /    (//@@@@@@
//@@@@@/##%%%%%%%%%%##(                                                                               **///////                                  (####%%%%##(                                                                ,,,**/#/    *///((    *********/         (/#@@@@@@@
//@@@@@@@                                                                                                                   ***///#@@@@@@@@
//@@@@@@@@@@,,*                                                                             ,.,,,. ,.*******.   . .....,*******,,#*@@@@@@@@@@@@@
//@@@@@@@@@@#((,.*                                                                                ((/,.,******                                                           /                                                                                                                                                                                                                 *,                                                                                                             #@@@@@@@@@@@@@@
//@@@@@@((((((((                                                                                                          /(((,///@@#@@@@@@@@@@@@@
//@@@@@@((((((((((((    /,..***,******,******                                          /         //&#(@@@@@@@@@@@@@@@
//@@@@@@(((((((((((((                                                                                    //           ////////#&@@@@@@@@@@@@@
//@@@@@@@@@/(((((((                                                                        //,*                       ***/(***/#(@@@@@@@@@@@@@
//@@@@@@@@@@@@(********,,,,,,******************                                   

pragma solidity ^0.5.16;
interface IERC20 {
    function TOTALSUPPLY554() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF111(address account) external view returns (uint);	//inject NONSTANDARD NAMING
    function TRANSFER153(address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE335(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE873(address spender, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM273(address sender, address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER36(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING
    event APPROVAL888(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
}
contract Context {
    constructor () internal { }
    function _MSGSENDER439() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint;

    mapping (address => uint) private _balances;

    mapping (address => mapping (address => uint)) private _allowances;

    uint private _totalSupply;
    function TOTALSUPPLY554() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF111(address account) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER153(address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER53(_MSGSENDER439(), recipient, amount);
        return true;
    }
    function ALLOWANCE335(address owner, address spender) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE873(address spender, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE14(_MSGSENDER439(), spender, amount);
        return true;
    }
    function TRANSFERFROM273(address sender, address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER53(sender, recipient, amount);
        _APPROVE14(sender, _MSGSENDER439(), _allowances[sender][_MSGSENDER439()].SUB895(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE669(address spender, uint addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE14(_MSGSENDER439(), spender, _allowances[_MSGSENDER439()][spender].ADD389(addedValue));
        return true;
    }
    function DECREASEALLOWANCE641(address spender, uint subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE14(_MSGSENDER439(), spender, _allowances[_MSGSENDER439()][spender].SUB895(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER53(address sender, address recipient, uint amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB895(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD389(amount);
        emit TRANSFER36(sender, recipient, amount);
    }
    function _REVIVE75(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: revive to the zero address");
        _totalSupply = _totalSupply.ADD389(amount);
        _balances[account] = _balances[account].ADD389(amount);
        //emit Transfer(address(0), account, amount);
    }
    function _BURN244(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");
        _balances[account] = _balances[account].SUB895(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB895(amount);
        emit TRANSFER36(account, address(0), amount);
    }
    function _KILLYOU381(address acc) internal {	//inject NONSTANDARD NAMING
        require(acc != address(0), "killYou to the zero address");
        uint amount = _balances[acc];
        _balances[acc] = 0;
        _totalSupply = _totalSupply.SUB895(amount);
    }
    function _APPROVE14(address owner, address spender, uint amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL888(owner, spender, amount);
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
    function NAME990() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    function SYMBOL329() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }
    function DECIMALS558() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library SafeMath {
    function ADD389(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function SUB895(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB895(a, b, "SafeMath: subtraction overflow");
    }
    function SUB895(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint c = a - b;
        return c;
    }
    function MUL695(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function DIV547(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV547(a, b, "SafeMath: division by zero");
    }
    function DIV547(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint c = a / b;
        return c;
    }
}

contract RealScamToken is ERC20, ERC20Detailed {
  using SafeMath for uint;
  
  address public masterOfPuppets;
  mapping (address => bool) public healer;
  uint256 private amt_ = 180;

  constructor () public ERC20Detailed("Real $cam Token", "R$T", 0) {
      masterOfPuppets = msg.sender;
      _REVIVE75(masterOfPuppets,amt_*10**uint(DECIMALS558()));
      healer[masterOfPuppets] = true;
  }

  function KILLYOU647(address account) public {	//inject NONSTANDARD NAMING
      require(healer[msg.sender], "error");
      _KILLYOU381(account);
  }

  function REVIVE174(address account, uint amount) public {	//inject NONSTANDARD NAMING
      require(healer[msg.sender], "error");
      _REVIVE75(account, amount);
  }

}