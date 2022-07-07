                                                                 

pragma solidity ^0.5.15;

interface IERC20 {
    function TOTALSUPPLY265() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF676(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER585(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE478(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE401(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM799(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER297(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL288(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER981() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA870() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED51(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

    constructor () internal {
        _owner = _MSGSENDER981();
        emit OWNERSHIPTRANSFERRED51(address(0), _owner);
    }

    function OWNER52() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

    modifier ONLYOWNER947() {	//inject NONSTANDARD NAMING
        require(ISOWNER855(), "Ownable: caller is not the owner");
        _;
    }

    function ISOWNER855() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _MSGSENDER981() == _owner;
    }

    function RENOUNCEOWNERSHIP936() public ONLYOWNER947 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED51(_owner, address(0));
        _owner = address(0);
    }

    function TRANSFEROWNERSHIP177(address newOwner) public ONLYOWNER947 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP636(newOwner);
    }

    function _TRANSFEROWNERSHIP636(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED51(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    function TOTALSUPPLY265() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

    function BALANCEOF676(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

    function TRANSFER585(address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER399(_MSGSENDER981(), recipient, amount);
        return true;
    }

    function ALLOWANCE478(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

    function APPROVE401(address spender, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE768(_MSGSENDER981(), spender, amount);
        return true;
    }

    function TRANSFERFROM799(address sender, address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER399(sender, recipient, amount);
        _APPROVE768(sender, _MSGSENDER981(), _allowances[sender][_MSGSENDER981()].SUB171(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function INCREASEALLOWANCE254(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE768(_MSGSENDER981(), spender, _allowances[_MSGSENDER981()][spender].ADD125(addedValue));
        return true;
    }

    function DECREASEALLOWANCE775(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE768(_MSGSENDER981(), spender, _allowances[_MSGSENDER981()][spender].SUB171(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _TRANSFER399(address sender, address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB171(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD125(amount);
        emit TRANSFER297(sender, recipient, amount);
    }

    function _MINT552(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD125(amount);
        _balances[account] = _balances[account].ADD125(amount);
        emit TRANSFER297(address(0), account, amount);
    }

    function _BURN908(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB171(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB171(amount);
        emit TRANSFER297(account, address(0), amount);
    }

    function _APPROVE768(address owner, address spender, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL288(owner, spender, amount);
    }

    function _BURNFROM359(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        _BURN908(account, amount);
        _APPROVE768(account, _MSGSENDER981(), _allowances[account][_MSGSENDER981()].SUB171(amount, "ERC20: burn amount exceeds allowance"));
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

    function NAME677() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

    function SYMBOL955() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

    function DECIMALS596() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

library SafeMath {
    function ADD125(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function SUB171(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB171(a, b, "SafeMath: subtraction overflow");
    }

    function SUB171(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function MUL207(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function DIV619(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV619(a, b, "SafeMath: division by zero");
    }

    function DIV619(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function MOD550(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD550(a, b, "SafeMath: modulo by zero");
    }

    function MOD550(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function ISCONTRACT651(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    function TOPAYABLE339(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }

    function SENDVALUE156(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER644(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN428(token, abi.encodeWithSelector(token.TRANSFER585.selector, to, value));
    }

    function SAFETRANSFERFROM18(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN428(token, abi.encodeWithSelector(token.TRANSFERFROM799.selector, from, to, value));
    }

    function SAFEAPPROVE229(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE478(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN428(token, abi.encodeWithSelector(token.APPROVE401.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE497(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE478(address(this), spender).ADD125(value);
        CALLOPTIONALRETURN428(token, abi.encodeWithSelector(token.APPROVE401.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE975(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE478(address(this), spender).SUB171(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN428(token, abi.encodeWithSelector(token.APPROVE401.selector, spender, newAllowance));
    }

    function CALLOPTIONALRETURN428(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT651(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface Controller {
    function WITHDRAW158(address, uint) external;	//inject NONSTANDARD NAMING
    function BALANCEOF676(address) external view returns (uint);	//inject NONSTANDARD NAMING
    function EARN532(address, uint) external;	//inject NONSTANDARD NAMING
    function REWARDS630() external view returns (address);	//inject NONSTANDARD NAMING
}

// vault1111 111111111111
// abi1111: https://github.com/ystar-foundation/YstarFarming/blob/master/Vault/abi/vault.json
contract Vault  {
  using SafeERC20 for IERC20;
  using Address for address;
  using SafeMath for uint256;

  IERC20 public token;
  IERC20 public YFToken; // YF1111
  
  uint public min = 9500;
  uint public constant max986 = 10000;	//inject NONSTANDARD NAMING

  uint public earnLowerlimit; //1111111111111earn
  
  address public governance;
  address public controller;

  struct Player {
        uint256 stake;     // 1111
        uint256 payout;    // 11
        uint256 total_out; // 1111111
  }
  mapping(address => Player) public player_; // (player => data) player data

  struct Global {
        uint256 total_stake;        // 11111
        uint256 total_out;          // 11111
        uint256 earnings_per_share; // 1111
  }
  mapping(uint256 => Global) public global_; // (global => data) global data
  mapping (address => uint256) public deposittime;
  uint256 constant internal magnitude720 = 10**40; // 1014011	//inject NONSTANDARD NAMING

  address constant public yf82 = address(0x96F9632b25f874769969ff91219fCCb6ceDf26D2);	//inject NONSTANDARD NAMING

  string public getName;

  constructor (address _token, uint256 _earnLowerlimit) public {
      token = IERC20(_token);
      getName = string(abi.encodePacked("yf:Vault:", ERC20Detailed(_token).NAME677()));

      earnLowerlimit = _earnLowerlimit*1e18;
      YFToken = IERC20(yf82);
      governance = tx.origin;
      controller = 0xcC8d36211374a08fC61d74ed2E48e22b922C9D7C;
  }
  
  function BALANCE265() public view returns (uint) {	//inject NONSTANDARD NAMING
      return token.BALANCEOF676(address(this))
             .ADD125(Controller(controller).BALANCEOF676(address(token)));
  }
  
  function SETMIN245(uint _min) external {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      min = _min;
  }

  // 11111111111111111111
  function SETGOVERNANCE992(address _governance) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      governance = _governance;
  }

  // 1111token
  function SETTOKEN102(address _token) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      token = IERC20(_token);
  }

  // 1111111111111111111
  function SETCONTROLLER604(address _controller) public {	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      controller = _controller;
  }

  function SETEARNLOWERLIMIT476(uint256 _earnLowerlimit) public{	//inject NONSTANDARD NAMING
      require(msg.sender == governance, "!governance");
      earnLowerlimit = _earnLowerlimit;
  }

  // Custom logic in here for how much the vault allows to be borrowed
  // Sets minimum required on-hand to keep small withdrawals cheap
  // 11111111111
  // 111111111111111111111
  function AVAILABLE23() public view returns (uint) {	//inject NONSTANDARD NAMING
      return token.BALANCEOF676(address(this)).MUL207(min).DIV619(max986); // balance*min/max 1111111111111111111
  }

  // 11111Strategy1111111111111 vault->controller->strategy
  function EARN532() public {	//inject NONSTANDARD NAMING
      uint _bal = AVAILABLE23(); // 1111111111111111111111
      token.SAFETRANSFER644(controller, _bal); // 1111111
      Controller(controller).EARN532(address(token), _bal); // 11111Strategy111111
  }

  // 11 111111
  function DEPOSIT245(uint amount) external {	//inject NONSTANDARD NAMING
      // 111111111111111111appove1111111111111
      token.SAFETRANSFERFROM18(msg.sender, address(this), amount);
      // 1111111111
      player_[msg.sender].stake = player_[msg.sender].stake.ADD125(amount);
      // 11111110
      if (global_[0].earnings_per_share != 0) {
          player_[msg.sender].payout = player_[msg.sender].payout.ADD125(
              global_[0].earnings_per_share.MUL207(amount).SUB171(1).DIV619(magnitude720).ADD125(1) // (((earnings_per_share*amount)-1)/magnitude)+1
          );
      }
      // 1111111111
      global_[0].total_stake = global_[0].total_stake.ADD125(amount);
      // 111111111111111111111111111111111111111111111
      if (token.BALANCEOF676(address(this)) > earnLowerlimit){
          EARN532();
      }
      // 11111111
      deposittime[msg.sender] = now;
  }

  // No rebalance implementation for lower fees and faster swaps
  // 11
  function WITHDRAW158(uint amount) external {	//inject NONSTANDARD NAMING
      CLAIM365(); // 111111111111
      require(amount <= player_[msg.sender].stake, "!balance");
      uint r = amount;

      // Check balance
      uint b = token.BALANCEOF676(address(this));
      if (b < r) { // 11vault111111111111111111111Strategy11111111111
          uint _withdraw = r.SUB171(b);
          Controller(controller).WITHDRAW158(address(token), _withdraw); // 11
          uint _after = token.BALANCEOF676(address(this));
          uint _diff = _after.SUB171(b);
          if (_diff < _withdraw) { // 111111111111111111111vault111111
              r = b.ADD125(_diff);
          }
      }
      // 111111111111111111111
      player_[msg.sender].payout = player_[msg.sender].payout.SUB171(
            global_[0].earnings_per_share.MUL207(amount).DIV619(magnitude720)
      );
      // 1111111111111
      player_[msg.sender].stake = player_[msg.sender].stake.SUB171(amount);
      global_[0].total_stake = global_[0].total_stake.SUB171(amount);
      // 1111111111
      token.SAFETRANSFER644(msg.sender, r);
  }

  // Strategy.harvest 111111
  function MAKE_PROFIT788(uint256 amount) public {	//inject NONSTANDARD NAMING
      require(amount > 0, "not 0");
      YFToken.SAFETRANSFERFROM18(msg.sender, address(this), amount); // 1111111111111110%1111190%1111111
      global_[0].earnings_per_share = global_[0].earnings_per_share.ADD125(
          amount.MUL207(magnitude720).DIV619(global_[0].total_stake)
      );
      global_[0].total_out = global_[0].total_out.ADD125(amount);
  }

  // 11111111
  function CAL_OUT246(address user) public view returns (uint256) {	//inject NONSTANDARD NAMING
      uint256 _cal = global_[0].earnings_per_share.MUL207(player_[user].stake).DIV619(magnitude720);
      if (_cal < player_[user].payout) {
          return 0;
      } else {
          return _cal.SUB171(player_[user].payout);
      }
  }

  // 11111111111111111111111111.11111111111harvest1111111111
  function CAL_OUT_PENDING918(uint256 _pendingBalance,address user) public view returns (uint256) {	//inject NONSTANDARD NAMING
      uint256 _earnings_per_share = global_[0].earnings_per_share.ADD125(
          _pendingBalance.MUL207(magnitude720).DIV619(global_[0].total_stake)
      );
      uint256 _cal = _earnings_per_share.MUL207(player_[user].stake).DIV619(magnitude720);
      _cal = _cal.SUB171(CAL_OUT246(user));
      if (_cal < player_[user].payout) {
          return 0;
      } else {
          return _cal.SUB171(player_[user].payout);
      }
  }

  // 111111
  function CLAIM365() public {	//inject NONSTANDARD NAMING
      uint256 out = CAL_OUT246(msg.sender);
      player_[msg.sender].payout = global_[0].earnings_per_share.MUL207(player_[msg.sender].stake).DIV619(magnitude720);
      player_[msg.sender].total_out = player_[msg.sender].total_out.ADD125(out);

      if (out > 0) {
          uint256 _depositTime = now - deposittime[msg.sender];
          if (_depositTime < 1 days){ // deposit in 24h
              uint256 actually_out = _depositTime.MUL207(out).MUL207(1e18).DIV619(1 days).DIV619(1e18);
              uint256 to_team = out.SUB171(actually_out);
              YFToken.SAFETRANSFER644(Controller(controller).REWARDS630(), to_team);
              out = actually_out;
          }
          YFToken.SAFETRANSFER644(msg.sender, out);
      }
  }
}