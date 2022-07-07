/**
 * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
 * Non-Profit Open Software License 3.0 (NPOSL-3.0)
 * https://opensource.org/licenses/NPOSL-3.0
 */

pragma solidity ^0.5.2;

/**
 * @title Math
 * @dev Assorted math operations
 */
library Math {
    /**
    * @dev Returns the largest of two numbers.
    */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
    * @dev Returns the smallest of two numbers.
    */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
    * @dev Calculates the average of two numbers. Since these are integers,
    * averages of an even and odd number cannot be represented, and will be
    * rounded down.
    */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/**
 * @title Secondary
 * @dev A Secondary contract can only be used by its primary account (the one that created it)
 */
contract Secondary {
    address private _primary;

    event PrimaryTransferred(
        address recipient
    );

    /**
     * @dev Sets the primary account to the one that is creating the Secondary contract.
     */
    constructor () internal {
        _primary = msg.sender;
        emit PrimaryTransferred(_primary);
    }

    /**
     * @dev Reverts if called from any account other than the primary.
     */
    modifier onlyPrimary() {
        require(msg.sender == _primary);
        _;
    }

    /**
     * @return the address of the primary.
     */
    function primary() public view returns (address) {
        return _primary;
    }

    /**
     * @dev Transfers contract to a new primary.
     * @param recipient The address of new primary.
     */
    function transferPrimary(address recipient) public onlyPrimary {
        require(recipient != address(0));
        _primary = recipient;
        emit PrimaryTransferred(_primary);
    }
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        require(token.transfer(to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        require(token.transferFrom(from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require((value == 0) || (token.allowance(msg.sender, spender) == 0));
        require(token.approve(spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        require(token.approve(spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        require(token.approve(spender, newAllowance));
    }
}

contract MoneyMarketInterface {
  function getSupplyBalance(address account, address asset) public view returns (uint);
  function supply(address asset, uint amount) public returns (uint);
  function withdraw(address asset, uint requestedAmount) public returns (uint);
}

contract LoanEscrow is Secondary {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
  IERC20 public dai = IERC20(DAI_ADDRESS);

  address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;
  MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);

  event Deposited(address indexed from, uint256 daiAmount);
  event Pulled(address indexed to, uint256 daiAmount);
  event InterestWithdrawn(address indexed to, uint256 daiAmount);

  mapping(address => uint256) public deposits;
  mapping(address => uint256) public pulls;
  uint256 public deposited;
  uint256 public pulled;

  function withdrawInterest() public onlyPrimary {
    uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).sub(deposited).add(pulled);
    require(amountInterest > 0, "no interest");

    uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);
    require(address(this).balance == 0, "withdraw failed");	//inject PRESENT ETHER

    dai.safeTransfer(msg.sender, amountInterest);
    emit InterestWithdrawn(msg.sender, amountInterest);
  }

  function deposit(address _from, uint256 _amountDai) internal {
    require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
    dai.safeTransferFrom(msg.sender, address(this), _amountDai);

    require(address(this).balance == 0, "non-zero initial moneyMarket allowance");	//inject PRESENT ETHER
    require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");

    uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);
    require(address(this).balance == 0, "supply failed");	//inject PRESENT ETHER
    require(address(this).balance == 0, "allowance not fully consumed by moneyMarket");	//inject PRESENT ETHER

    deposits[_from] = deposits[_from].add(_amountDai);
    deposited = deposited.add(_amountDai);
    emit Deposited(_from, _amountDai);
  }

  function pull(address _to, uint256 _amountDai, bool refund) internal {
    uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, _amountDai);
    require(address(this).balance == 0, "withdraw failed");	//inject PRESENT ETHER

    if (refund) {
      deposits[_to] = deposits[_to].sub(_amountDai);
      deposited = deposited.sub(_amountDai);
    } else {
      pulls[_to] = pulls[_to].add(_amountDai);
      pulled = pulled.add(_amountDai);
    }

    dai.safeTransfer(_to, _amountDai);
    emit Pulled(_to, _amountDai);
  }
}

contract WhitelistInterface {
  function hasRole(address _operator, string memory _role) public view returns (bool);
}

contract WhitelistProxyInterface {
  function whitelist() public view returns (WhitelistInterface);
}

contract Exchange is LoanEscrow {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  uint256 public constant POINTS = uint256(10) ** 32;

  address public constant WHITELIST_PROXY_ADDRESS = 0x77eb36579e77e6a4bcd2Ca923ada0705DE8b4114;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
  WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);

  struct Order {
    bool buy;
    uint256 closingTime;
    uint256 numberOfTokens;
    uint256 numberOfDai;
    IERC20 token;
    address from;
  }

  mapping(bytes32 => Order) public orders;

  event OrderDeleted(bytes32 indexed order);
  event OrderFilled(bytes32 indexed order, uint256 numberOfTokens, uint256 numberOfDai, address indexed to);
  event OrderPosted(bytes32 indexed order, bool indexed buy, uint256 closingTime, uint256 numberOfTokens, uint256 numberOfDai, IERC20 indexed token, address from);

  function deleteOrder(bytes32 _hash) public {
    Order memory o = orders[_hash];
    require(o.from == msg.sender || !isValid(_hash));

    if (o.buy)
      pull(o.from, o.numberOfDai, true);

    _deleteOrder(_hash);
  }

  function fillOrders(bytes32[] memory _hashes, address _from, uint256 numberOfTokens) public {
    uint256 remainingTokens = numberOfTokens;
    uint256 remainingDai = dai.allowance(msg.sender, address(this));

    for (uint256 i = 0; i < _hashes.length; i++) {
      bytes32 hash = _hashes[i];
      require(isValid(hash), "invalid order");

      Order memory o = orders[hash];

      uint256 coefficient = (o.buy ? remainingTokens : remainingDai).mul(POINTS).div(o.buy ? o.numberOfTokens : o.numberOfDai);

      uint256 nTokens = o.numberOfTokens.mul(Math.min(coefficient, POINTS)).div(POINTS);
      uint256 vDai = o.numberOfDai.mul(Math.min(coefficient, POINTS)).div(POINTS);

      o.buy ? remainingTokens -= nTokens : remainingDai -= vDai;
      o.buy ? pull(_from, vDai, false) : dai.safeTransferFrom(msg.sender, o.from, vDai);
      o.token.safeTransferFrom(o.buy ? _from : o.from, o.buy ? o.from : _from, nTokens);

      emit OrderFilled(hash, nTokens, vDai, _from);
      _deleteOrder(hash);

      if (coefficient < POINTS)
        _postOrder(o.buy, o.closingTime, o.numberOfTokens.sub(nTokens), o.numberOfDai.sub(vDai), o.token, o.from);
    }

    dai.safeTransferFrom(msg.sender, _from, remainingDai);
    require(address(this).balance == 0);	//inject PRESENT ETHER
  }

  function isValid(bytes32 _hash) public view returns (bool valid) {
    Order memory o = orders[_hash];

    valid = o.buy || (o.token.balanceOf(o.from) >= o.numberOfTokens && o.token.allowance(o.from, address(this)) >= o.numberOfTokens);
    valid = valid && now <= o.closingTime && o.closingTime <= now.add(1 weeks);
    valid = valid && o.numberOfTokens > 0 && o.numberOfDai > 0;
    valid = valid && whitelistProxy.whitelist().hasRole(address(o.token), "authorized");
  }

  function postOrder(bool _buy, uint256 _closingTime, address _from, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token) public {
    if (_buy)
      deposit(_from, _numberOfDai);

    _postOrder(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
  }

  function _deleteOrder(bytes32 _hash) internal {
    delete orders[_hash];
    emit OrderDeleted(_hash);
  }

  function _postOrder(bool _buy, uint256 _closingTime, uint256 _numberOfTokens, uint256 _numberOfDai, IERC20 _token, address _from) internal {
    bytes32 hash = keccak256(abi.encodePacked(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from));
    orders[hash] = Order(_buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);

    require(isValid(hash), "invalid order");
    emit OrderPosted(hash, _buy, _closingTime, _numberOfTokens, _numberOfDai, _token, _from);
  }
}