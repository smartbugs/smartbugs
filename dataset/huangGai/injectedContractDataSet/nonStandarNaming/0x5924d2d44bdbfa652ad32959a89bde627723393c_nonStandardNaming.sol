                                                                 

pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

interface IERC20 {
    function TOTALSUPPLY57() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF949(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER654(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE664(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE585(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM949(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER751(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL265(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER315() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA742() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address payable private _owner;

    event OWNERSHIPTRANSFERRED883(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING
    constructor () internal {
        _owner = _MSGSENDER315();
        emit OWNERSHIPTRANSFERRED883(address(0), _owner);
    }
    function OWNER860() public view returns (address payable) {	//inject NONSTANDARD NAMING
        return _owner;
    }
    modifier ONLYOWNER684() {	//inject NONSTANDARD NAMING
        require(ISOWNER606(), "Ownable: caller is not the owner");
        _;
    }
    function ISOWNER606() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _MSGSENDER315() == _owner;
    }
    function RENOUNCEOWNERSHIP25() public ONLYOWNER684 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED883(_owner, address(0));
        _owner = address(0);
    }
    function TRANSFEROWNERSHIP520(address payable newOwner) public ONLYOWNER684 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP409(newOwner);
    }
    function _TRANSFEROWNERSHIP409(address payable newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED883(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 _totalSupply;
    function TOTALSUPPLY57() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF949(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER654(address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER957(_MSGSENDER315(), recipient, amount);
        return true;
    }
    function ALLOWANCE664(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE585(address spender, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE29(_MSGSENDER315(), spender, amount);
        return true;
    }
    function TRANSFERFROM949(address sender, address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER957(sender, recipient, amount);
        _APPROVE29(sender, _MSGSENDER315(), _allowances[sender][_MSGSENDER315()].SUB32(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE599(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE29(_MSGSENDER315(), spender, _allowances[_MSGSENDER315()][spender].ADD719(addedValue));
        return true;
    }
    function DECREASEALLOWANCE607(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE29(_MSGSENDER315(), spender, _allowances[_MSGSENDER315()][spender].SUB32(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER957(address sender, address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB32(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD719(amount);
        emit TRANSFER751(sender, recipient, amount);
    }
    function _MINT290(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD719(amount);
        _balances[account] = _balances[account].ADD719(amount);
        emit TRANSFER751(address(0), account, amount);
    }
    function _BURN535(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB32(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB32(amount);
        emit TRANSFER751(account, address(0), amount);
    }
    function _APPROVE29(address owner, address spender, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL265(owner, spender, amount);
    }
    function _BURNFROM245(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        _BURN535(account, amount);
        _APPROVE29(account, _MSGSENDER315(), _allowances[account][_MSGSENDER315()].SUB32(amount, "ERC20: burn amount exceeds allowance"));
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
    function NAME844() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    function SYMBOL911() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }
    function DECIMALS364() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library SafeMath {
    function ADD719(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB32(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB32(a, b, "SafeMath: subtraction overflow");
    }
    function SUB32(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function MUL297(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV972(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV972(a, b, "SafeMath: division by zero");
    }
    function DIV972(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function MOD124(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD124(a, b, "SafeMath: modulo by zero");
    }
    function MOD124(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract yeldTUSD is ERC20, ERC20Detailed, Ownable {
  using SafeMath for uint256;

  address public yTUSDAddress;
  uint256 public initialPrice = 10000;
  uint256 public fromYeldTTUSDoYeld = initialPrice * (10 ** 18); // Must be divided by 1e18 to get the real value
  uint256 public fromTTUSDoYeldTUSDPrice = fromYeldTTUSDoYeld / initialPrice; // Must be divided by 1e18 to get the real value
  uint256 public yeldReward = 1;
  uint256 public yeldTUSDDecimals = 18; // The price has 18 decimals meaning you'll have to divide by 1e18 to get the real value
  uint256 public lastPriceUpdate = now;
	uint256 public priceUpdatePeriod = 1 days;
  
  modifier ONLYYTUSD369 {	//inject NONSTANDARD NAMING
    require(msg.sender == yTUSDAddress);
    _;
  }

  constructor() public payable ERC20Detailed("yeld TUSD", "yeldTUSD", 18) {}

  function SETYTUSD712(address _yTUSDAddress) public ONLYOWNER684 {	//inject NONSTANDARD NAMING
    yTUSDAddress = _yTUSDAddress;
  }
  
  function MINT359(address _to, uint256 _amount) public ONLYYTUSD369 {	//inject NONSTANDARD NAMING
    _MINT290(_to, _amount);
  }

  function BURN815(address _to, uint256 _amount) public ONLYYTUSD369 {	//inject NONSTANDARD NAMING
    _BURN535(_to, _amount);
  }

	                                             
	                                                                            
	function CHANGEPRICERATIO481(uint256 _price) public ONLYOWNER684 {	//inject NONSTANDARD NAMING
		initialPrice = _price;
	}

	function CHECKIFPRICENEEDSUPDATING725() public view returns(bool) {	//inject NONSTANDARD NAMING
		return now >= lastPriceUpdate + priceUpdatePeriod;
	}

	                                      
	                                                                                      
	                                                                                            
	                                                                                    
	function UPDATEPRICE820() public {	//inject NONSTANDARD NAMING
		require(CHECKIFPRICENEEDSUPDATING725(), "The price can't be updated yet");
		// Update the price
        uint256 daysPassed = (now - lastPriceUpdate) / 1 days;
		yeldReward = daysPassed;
		lastPriceUpdate = now;
		fromYeldTTUSDoYeld = initialPrice.MUL297(10 ** yeldTUSDDecimals).DIV972(yeldReward);
		fromTTUSDoYeldTUSDPrice = fromYeldTTUSDoYeld.DIV972(initialPrice);
	}
  
  function EXTRACTTOKENSIFSTUCK927(address _token, uint256 _amount) public ONLYOWNER684 {	//inject NONSTANDARD NAMING
    IERC20(_token).TRANSFER654(msg.sender, _amount);
  }

  function EXTRACTETHIFSTUCK461() public ONLYOWNER684 {	//inject NONSTANDARD NAMING
    OWNER860().transfer(address(this).balance);
  }
}