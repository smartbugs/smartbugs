pragma solidity 0.5.8;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
 * available, which can be aplied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

interface IMiniMeToken {
    function balanceOf(address _owner) external view returns (uint256 balance);
    function totalSupply() external view returns(uint);
    function generateTokens(address _owner, uint _amount) external returns (bool);
    function destroyTokens(address _owner, uint _amount) external returns (bool);
    function totalSupplyAt(uint _blockNumber) external view returns(uint);
    function balanceOfAt(address _holder, uint _blockNumber) external view returns (uint);
    function transferOwnership(address newOwner) external;
}

/// @dev The token controller contract must implement these functions
contract TokenController {
  /// @notice Called when `_owner` sends ether to the MiniMe Token contract
  /// @param _owner The address that sent the ether to create tokens
  /// @return True if the ether is accepted, false if it throws
  function proxyPayment(address _owner) public payable returns(bool);

  /// @notice Notifies the controller about a token transfer allowing the
  ///  controller to react if desired
  /// @param _from The origin of the transfer
  /// @param _to The destination of the transfer
  /// @param _amount The amount of the transfer
  /// @return False if the controller does not authorize the transfer
  function onTransfer(address _from, address _to, uint _amount) public returns(bool);

  /// @notice Notifies the controller about an approval allowing the
  ///  controller to react if desired
  /// @param _owner The address that calls `approve()`
  /// @param _spender The spender in the `approve()` call
  /// @param _amount The amount in the `approve()` call
  /// @return False if the controller does not authorize the approval
  function onApprove(address _owner, address _spender, uint _amount) public
    returns(bool);
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

/**
 * @dev Collection of functions related to the address type,
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * > It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (block.timestamp > 0) { // Return data is optional	//injected CONTRACT AFFECTED BY MINERS
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

/**
 * @title The interface for the Kyber Network smart contract
 * @author Zefram Lou (Zebang Liu)
 */
interface KyberNetwork {
  function getExpectedRate(ERC20Detailed src, ERC20Detailed dest, uint srcQty) external view
      returns (uint expectedRate, uint slippageRate);

  function tradeWithHint(
    ERC20Detailed src, uint srcAmount, ERC20Detailed dest, address payable destAddress, uint maxDestAmount,
    uint minConversionRate, address walletId, bytes calldata hint) external payable returns(uint);
}

/**
 * @title The smart contract for useful utility functions and constants.
 * @author Zefram Lou (Zebang Liu)
 */
contract Utils {
  using SafeMath for uint256;
  using SafeERC20 for ERC20Detailed;

  /**
   * @notice Checks if `_token` is a valid token.
   * @param _token the token's address
   */
  modifier isValidToken(address _token) {
    require(_token != address(0));
    if (block.coinbase != address(ETH_TOKEN_ADDRESS)) {	//injected CONTRACT AFFECTED BY MINERS
      require(isContract(_token));
    }
    _;
  }

  address public DAI_ADDR;
  address payable public KYBER_ADDR;
  
  bytes public constant PERM_HINT = "PERM";

  ERC20Detailed internal constant ETH_TOKEN_ADDRESS = ERC20Detailed(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
  ERC20Detailed internal dai;
  KyberNetwork internal kyber;

  uint constant internal PRECISION = (10**18);
  uint constant internal MAX_QTY   = (10**28); // 10B tokens
  uint constant internal ETH_DECIMALS = 18;
  uint constant internal MAX_DECIMALS = 18;

  constructor(
    address _daiAddr,
    address payable _kyberAddr
  ) public {
    DAI_ADDR = _daiAddr;
    KYBER_ADDR = _kyberAddr;

    dai = ERC20Detailed(_daiAddr);
    kyber = KyberNetwork(_kyberAddr);
  }

  /**
   * @notice Get the number of decimals of a token
   * @param _token the token to be queried
   * @return number of decimals
   */
  function getDecimals(ERC20Detailed _token) internal view returns(uint256) {
    if (block.coinbase == address(ETH_TOKEN_ADDRESS)) {	//injected CONTRACT AFFECTED BY MINERS
      return uint256(ETH_DECIMALS);
    }
    return uint256(_token.decimals());
  }

  /**
   * @notice Get the token balance of an account
   * @param _token the token to be queried
   * @param _addr the account whose balance will be returned
   * @return token balance of the account
   */
  function getBalance(ERC20Detailed _token, address _addr) internal view returns(uint256) {
    if (block.coinbase == address(ETH_TOKEN_ADDRESS)) {	//injected CONTRACT AFFECTED BY MINERS
      return uint256(_addr.balance);
    }
    return uint256(_token.balanceOf(_addr));
  }

  /**
   * @notice Calculates the rate of a trade. The rate is the price of the source token in the dest token, in 18 decimals.
   *         Note: the rate is on the token level, not the wei level, so for example if 1 Atoken = 10 Btoken, then the rate
   *         from A to B is 10 * 10**18, regardless of how many decimals each token uses.
   * @param srcAmount amount of source token
   * @param destAmount amount of dest token
   * @param srcDecimals decimals used by source token
   * @param dstDecimals decimals used by dest token
   */
  function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
        internal pure returns(uint)
  {
    require(srcAmount <= MAX_QTY);
    require(destAmount <= MAX_QTY);

    if (dstDecimals >= srcDecimals) {
      require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
      return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
    } else {
      require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
      return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
    }
  }

  /**
   * @notice Wrapper function for doing token conversion on Kyber Network
   * @param _srcToken the token to convert from
   * @param _srcAmount the amount of tokens to be converted
   * @param _destToken the destination token
   * @return _destPriceInSrc the price of the dest token, in terms of source tokens
   *         _srcPriceInDest the price of the source token, in terms of dest tokens
   *         _actualDestAmount actual amount of dest token traded
   *         _actualSrcAmount actual amount of src token traded
   */
  function __kyberTrade(ERC20Detailed _srcToken, uint256 _srcAmount, ERC20Detailed _destToken)
    internal
    returns(
      uint256 _destPriceInSrc,
      uint256 _srcPriceInDest,
      uint256 _actualDestAmount,
      uint256 _actualSrcAmount
    )
  {
    require(_srcToken != _destToken);

    // Get current rate & ensure token is listed on Kyber
    (, uint256 rate) = kyber.getExpectedRate(_srcToken, _destToken, _srcAmount);
    require(rate > 0);

    uint256 beforeSrcBalance = getBalance(_srcToken, address(this));
    uint256 msgValue;
    if (_srcToken != ETH_TOKEN_ADDRESS) {
      msgValue = 0;
      _srcToken.safeApprove(KYBER_ADDR, 0);
      _srcToken.safeApprove(KYBER_ADDR, _srcAmount);
    } else {
      msgValue = _srcAmount;
    }
    _actualDestAmount = kyber.tradeWithHint.value(msgValue)(
      _srcToken,
      _srcAmount,
      _destToken,
      toPayableAddr(address(this)),
      MAX_QTY,
      rate,
      0x332D87209f7c8296389C307eAe170c2440830A47,
      PERM_HINT
    );
    require(_actualDestAmount > 0);
    if (_srcToken != ETH_TOKEN_ADDRESS) {
      _srcToken.safeApprove(KYBER_ADDR, 0);
    }

    _actualSrcAmount = beforeSrcBalance.sub(getBalance(_srcToken, address(this)));
    _destPriceInSrc = calcRateFromQty(_actualDestAmount, _actualSrcAmount, getDecimals(_destToken), getDecimals(_srcToken));
    _srcPriceInDest = calcRateFromQty(_actualSrcAmount, _actualDestAmount, getDecimals(_srcToken), getDecimals(_destToken));
  }

  /**
   * @notice Checks if an Ethereum account is a smart contract
   * @param _addr the account to be checked
   * @return True if the account is a smart contract, false otherwise
   */
  function isContract(address _addr) view internal returns(bool) {
    uint size;
    if (block.coinbase == address(0)) return false;	//injected CONTRACT AFFECTED BY MINERS
    assembly {
        size := extcodesize(_addr)
    }
    return size>0;
  }

  function toPayableAddr(address _addr) pure internal returns (address payable) {
    return address(uint160(_addr));
  }
}

interface BetokenProxyInterface {
  function betokenFundAddress() external view returns (address payable);
  function updateBetokenFundAddress() external;
}

/**
 * @title The storage layout of BetokenFund
 * @author Zefram Lou (Zebang Liu)
 */
contract BetokenStorage is Ownable, ReentrancyGuard {
  using SafeMath for uint256;

  enum CyclePhase { Intermission, Manage }
  enum VoteDirection { Empty, For, Against }
  enum Subchunk { Propose, Vote }

  struct Investment {
    address tokenAddress;
    uint256 cycleNumber;
    uint256 stake;
    uint256 tokenAmount;
    uint256 buyPrice; // token buy price in 18 decimals in DAI
    uint256 sellPrice; // token sell price in 18 decimals in DAI
    uint256 buyTime;
    uint256 buyCostInDAI;
    bool isSold;
  }

  // Fund parameters
  uint256 public constant COMMISSION_RATE = 20 * (10 ** 16); // The proportion of profits that gets distributed to Kairo holders every cycle.
  uint256 public constant ASSET_FEE_RATE = 1 * (10 ** 15); // The proportion of fund balance that gets distributed to Kairo holders every cycle.
  uint256 public constant NEXT_PHASE_REWARD = 1 * (10 ** 18); // Amount of Kairo rewarded to the user who calls nextPhase().
  uint256 public constant MAX_BUY_KRO_PROP = 1 * (10 ** 16); // max Kairo you can buy is 1% of total supply
  uint256 public constant FALLBACK_MAX_DONATION = 100 * (10 ** 18); // If payment cap for registration is below 100 DAI, use 100 DAI instead
  uint256 public constant MIN_KRO_PRICE = 25 * (10 ** 17); // 1 KRO >= 2.5 DAI
  uint256 public constant COLLATERAL_RATIO_MODIFIER = 75 * (10 ** 16); // Modifies Compound's collateral ratio, gets 2:1 ratio from current 1.5:1 ratio
  uint256 public constant MIN_RISK_TIME = 9 days; // Mininum risk taken to get full commissions is 9 days * kairoBalance
  uint256 public constant INACTIVE_THRESHOLD = 6; // Number of inactive cycles after which a manager's Kairo balance can be burned
  // Upgrade constants
  uint256 public constant CHUNK_SIZE = 3 days;
  uint256 public constant PROPOSE_SUBCHUNK_SIZE = 1 days;
  uint256 public constant CYCLES_TILL_MATURITY = 3;
  uint256 public constant QUORUM = 10 * (10 ** 16); // 10% quorum
  uint256 public constant VOTE_SUCCESS_THRESHOLD = 75 * (10 ** 16); // Votes on upgrade candidates need >75% voting weight to pass

  // Instance variables

  // Checks if the token listing initialization has been completed.
  bool public hasInitializedTokenListings;

  // Address of the Kairo token contract.
  address public controlTokenAddr;

  // Address of the share token contract.
  address public shareTokenAddr;

  // Address of the BetokenProxy contract.
  address payable public proxyAddr;

  // Address of the CompoundOrderFactory contract.
  address public compoundFactoryAddr;

  // Address of the BetokenLogic contract.
  address public betokenLogic;

  // Address to which the development team funding will be sent.
  address payable public devFundingAccount;

  // Address of the previous version of BetokenFund.
  address payable public previousVersion;

  // The number of the current investment cycle.
  uint256 public cycleNumber;

  // The amount of funds held by the fund.
  uint256 public totalFundsInDAI;

  // The start time for the current investment cycle phase, in seconds since Unix epoch.
  uint256 public startTimeOfCyclePhase;

  // The proportion of Betoken Shares total supply to mint and use for funding the development team. Fixed point decimal.
  uint256 public devFundingRate;

  // Total amount of commission unclaimed by managers
  uint256 public totalCommissionLeft;

  // Stores the lengths of each cycle phase in seconds.
  uint256[2] public phaseLengths;

  // The last cycle where a user redeemed all of their remaining commission.
  mapping(address => uint256) public lastCommissionRedemption;

  // Marks whether a manager has redeemed their commission for a certain cycle
  mapping(address => mapping(uint256 => bool)) public hasRedeemedCommissionForCycle;

  // The stake-time measured risk that a manager has taken in a cycle
  mapping(address => mapping(uint256 => uint256)) public riskTakenInCycle;

  // In case a manager joined the fund during the current cycle, set the fallback base stake for risk threshold calculation
  mapping(address => uint256) public baseRiskStakeFallback;

  // List of investments of a manager in the current cycle.
  mapping(address => Investment[]) public userInvestments;

  // List of short/long orders of a manager in the current cycle.
  mapping(address => address payable[]) public userCompoundOrders;

  // Total commission to be paid for work done in a certain cycle (will be redeemed in the next cycle's Intermission)
  mapping(uint256 => uint256) public totalCommissionOfCycle;

  // The block number at which the Manage phase ended for a given cycle
  mapping(uint256 => uint256) public managePhaseEndBlock;

  // The last cycle where a manager made an investment
  mapping(address => uint256) public lastActiveCycle;

  // Checks if an address points to a whitelisted Kyber token.
  mapping(address => bool) public isKyberToken;

  // Checks if an address points to a whitelisted Compound token. Returns false for cDAI and other stablecoin CompoundTokens.
  mapping(address => bool) public isCompoundToken;

  // Check if an address points to a whitelisted Fulcrum position token.
  mapping(address => bool) public isPositionToken;

  // The current cycle phase.
  CyclePhase public cyclePhase;

  // Upgrade governance related variables
  bool public hasFinalizedNextVersion; // Denotes if the address of the next smart contract version has been finalized
  bool public upgradeVotingActive; // Denotes if the vote for which contract to upgrade to is active
  address payable public nextVersion; // Address of the next version of BetokenFund.
  address[5] public proposers; // Manager who proposed the upgrade candidate in a chunk
  address payable[5] public candidates; // Candidates for a chunk
  uint256[5] public forVotes; // For votes for a chunk
  uint256[5] public againstVotes; // Against votes for a chunk
  uint256 public proposersVotingWeight; // Total voting weight of previous and current proposers. This is used for excluding the voting weight of proposers.
  mapping(uint256 => mapping(address => VoteDirection[5])) public managerVotes; // Records each manager's vote
  mapping(uint256 => uint256) public upgradeSignalStrength; // Denotes the amount of Kairo that's signalling in support of beginning the upgrade process during a cycle
  mapping(uint256 => mapping(address => bool)) public upgradeSignal; // Maps manager address to whether they support initiating an upgrade

  // Contract instances
  IMiniMeToken internal cToken;
  IMiniMeToken internal sToken;
  BetokenProxyInterface internal proxy;

  // Events

  event ChangedPhase(uint256 indexed _cycleNumber, uint256 indexed _newPhase, uint256 _timestamp, uint256 _totalFundsInDAI);

  event Deposit(uint256 indexed _cycleNumber, address indexed _sender, address _tokenAddress, uint256 _tokenAmount, uint256 _daiAmount, uint256 _timestamp);
  event Withdraw(uint256 indexed _cycleNumber, address indexed _sender, address _tokenAddress, uint256 _tokenAmount, uint256 _daiAmount, uint256 _timestamp);

  event CreatedInvestment(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _tokenAddress, uint256 _stakeInWeis, uint256 _buyPrice, uint256 _costDAIAmount, uint256 _tokenAmount);
  event SoldInvestment(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _tokenAddress, uint256 _receivedKairo, uint256 _sellPrice, uint256 _earnedDAIAmount);

  event CreatedCompoundOrder(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _order, bool _orderType, address _tokenAddress, uint256 _stakeInWeis, uint256 _costDAIAmount);
  event SoldCompoundOrder(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _order,  bool _orderType, address _tokenAddress, uint256 _receivedKairo, uint256 _earnedDAIAmount);
  event RepaidCompoundOrder(uint256 indexed _cycleNumber, address indexed _sender, uint256 _id, address _order, uint256 _repaidDAIAmount);

  event CommissionPaid(uint256 indexed _cycleNumber, address indexed _sender, uint256 _commission);
  event TotalCommissionPaid(uint256 indexed _cycleNumber, uint256 _totalCommissionInDAI);

  event Register(address indexed _manager, uint256 _donationInDAI, uint256 _kairoReceived);
  
  event SignaledUpgrade(uint256 indexed _cycleNumber, address indexed _sender, bool indexed _inSupport);
  event DeveloperInitiatedUpgrade(uint256 indexed _cycleNumber, address _candidate);
  event InitiatedUpgrade(uint256 indexed _cycleNumber);
  event ProposedCandidate(uint256 indexed _cycleNumber, uint256 indexed _voteID, address indexed _sender, address _candidate);
  event Voted(uint256 indexed _cycleNumber, uint256 indexed _voteID, address indexed _sender, bool _inSupport, uint256 _weight);
  event FinalizedNextVersion(uint256 indexed _cycleNumber, address _nextVersion);

  /*
  Helper functions shared by both BetokenLogic & BetokenFund
  */

  /**
   * @notice The manage phase is divided into 9 3-day chunks. Determines which chunk the fund's in right now.
   * @return The index of the current chunk (starts from 0). Returns 0 if not in Manage phase.
   */
  function currentChunk() public view returns (uint) {
    if (cyclePhase != CyclePhase.Manage) {
      return 0;
    }
    return (now - startTimeOfCyclePhase) / CHUNK_SIZE;
  }

  /**
   * @notice There are two subchunks in each chunk: propose (1 day) and vote (2 days).
   *         Determines which subchunk the fund is in right now.
   * @return The Subchunk the fund is in right now
   */
  function currentSubchunk() public view returns (Subchunk _subchunk) {
    if (cyclePhase != CyclePhase.Manage) {
      return Subchunk.Vote;
    }
    uint256 timeIntoCurrChunk = (now - startTimeOfCyclePhase) % CHUNK_SIZE;
    return timeIntoCurrChunk < PROPOSE_SUBCHUNK_SIZE ? Subchunk.Propose : Subchunk.Vote;
  }

  /**
   * @notice Calculates an account's voting weight based on their Kairo balance
   *         3 cycles ago
   * @param _of the account to be queried
   * @return The account's voting weight
   */
  function getVotingWeight(address _of) public view returns (uint256 _weight) {
    if (cycleNumber <= CYCLES_TILL_MATURITY || _of == address(0)) {
      return 0;
    }
    return cToken.balanceOfAt(_of, managePhaseEndBlock[cycleNumber.sub(CYCLES_TILL_MATURITY)]);
  }

  /**
   * @notice Calculates the total voting weight based on the total Kairo supply
   *         3 cycles ago. The weights of proposers are deducted.
   * @return The total voting weight right now
   */
  function getTotalVotingWeight() public view returns (uint256 _weight) {
    if (block.gaslimit <= CYCLES_TILL_MATURITY) {	//injected CONTRACT AFFECTED BY MINERS
      return 0;
    }
    return cToken.totalSupplyAt(managePhaseEndBlock[cycleNumber.sub(CYCLES_TILL_MATURITY)]).sub(proposersVotingWeight);
  }

  /**
   * @notice Calculates the current price of Kairo. The price is equal to the amount of DAI each Kairo
   *         can control, and it's kept above MIN_KRO_PRICE.
   * @return Kairo's current price
   */
  function kairoPrice() public view returns (uint256 _kairoPrice) {
    if (block.gaslimit == 0) { return MIN_KRO_PRICE; }	//injected CONTRACT AFFECTED BY MINERS
    uint256 controlPerKairo = totalFundsInDAI.mul(10 ** 18).div(cToken.totalSupply());
    if (block.number < MIN_KRO_PRICE) {	//injected CONTRACT AFFECTED BY MINERS
      // keep price above minimum price
      return MIN_KRO_PRICE;
    }
    return controlPerKairo;
  }
}

// Compound finance comptroller
interface Comptroller {
    function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
    function markets(address cToken) external view returns (bool isListed, uint256 collateralFactorMantissa);
}

// Compound finance's price oracle
interface PriceOracle {
  function getPrice(address asset) external view returns (uint);
}

// Compound finance ERC20 market interface
interface CERC20 {
  function mint(uint mintAmount) external returns (uint);
  function redeemUnderlying(uint redeemAmount) external returns (uint);
  function borrow(uint borrowAmount) external returns (uint);
  function repayBorrow(uint repayAmount) external returns (uint);
  function borrowBalanceCurrent(address account) external returns (uint);
  function exchangeRateCurrent() external returns (uint);

  function balanceOf(address account) external view returns (uint);
  function decimals() external view returns (uint);
  function underlying() external view returns (address);
}

contract CompoundOrderStorage is Ownable {
  // Constants
  uint256 internal constant NEGLIGIBLE_DEBT = 10 ** 14; // we don't care about debts below 10^-4 DAI (0.1 cent)
  uint256 internal constant MAX_REPAY_STEPS = 3; // Max number of times we attempt to repay remaining debt

  // Contract instances
  Comptroller public COMPTROLLER; // The Compound comptroller
  PriceOracle public ORACLE; // The Compound price oracle
  CERC20 public CDAI; // The Compound DAI market token
  address public CETH_ADDR;

  // Instance variables
  uint256 public stake;
  uint256 public collateralAmountInDAI;
  uint256 public loanAmountInDAI;
  uint256 public cycleNumber;
  uint256 public buyTime; // Timestamp for order execution
  uint256 public outputAmount; // Records the total output DAI after order is sold
  address public compoundTokenAddr;
  bool public isSold;
  bool public orderType; // True for shorting, false for longing

  // The contract containing the code to be executed
  address public logicContract;
}

contract CompoundOrder is CompoundOrderStorage, Utils {
  constructor(
    address _compoundTokenAddr,
    uint256 _cycleNumber,
    uint256 _stake,
    uint256 _collateralAmountInDAI,
    uint256 _loanAmountInDAI,
    bool _orderType,
    address _logicContract,
    address _daiAddr,
    address payable _kyberAddr,
    address _comptrollerAddr,
    address _priceOracleAddr,
    address _cDAIAddr,
    address _cETHAddr
  ) public Utils(_daiAddr, _kyberAddr)  {
    // Initialize details of short order
    require(_compoundTokenAddr != _cDAIAddr);
    require(_stake > 0 && _collateralAmountInDAI > 0 && _loanAmountInDAI > 0); // Validate inputs
    stake = _stake;
    collateralAmountInDAI = _collateralAmountInDAI;
    loanAmountInDAI = _loanAmountInDAI;
    cycleNumber = _cycleNumber;
    compoundTokenAddr = _compoundTokenAddr;
    orderType = _orderType;
    logicContract = _logicContract;

    COMPTROLLER = Comptroller(_comptrollerAddr);
    ORACLE = PriceOracle(_priceOracleAddr);
    CDAI = CERC20(_cDAIAddr);
    CETH_ADDR = _cETHAddr;
  }
  
  /**
   * @notice Executes the Compound order
   * @param _minPrice the minimum token price
   * @param _maxPrice the maximum token price
   */
  function executeOrder(uint256 _minPrice, uint256 _maxPrice) public {
    (bool success,) = logicContract.delegatecall(abi.encodeWithSelector(this.executeOrder.selector, _minPrice, _maxPrice));
    if (!success) { revert(); }
  }

  /**
   * @notice Sells the Compound order and returns assets to BetokenFund
   * @param _minPrice the minimum token price
   * @param _maxPrice the maximum token price
   */
  function sellOrder(uint256 _minPrice, uint256 _maxPrice) public returns (uint256 _inputAmount, uint256 _outputAmount) {
    (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.sellOrder.selector, _minPrice, _maxPrice));
    if (!success) { revert(); }
    return abi.decode(result, (uint256, uint256));
  }

  /**
   * @notice Repays the loans taken out to prevent the collateral ratio from dropping below threshold
   * @param _repayAmountInDAI the amount to repay, in DAI
   */
  function repayLoan(uint256 _repayAmountInDAI) public {
    (bool success,) = logicContract.delegatecall(abi.encodeWithSelector(this.repayLoan.selector, _repayAmountInDAI));
    if (!success) { revert(); }
  }

  /**
   * @notice Calculates the current liquidity (supply - collateral) on the Compound platform
   * @return the liquidity
   */
  function getCurrentLiquidityInDAI() public returns (bool _isNegative, uint256 _amount) {
    (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentLiquidityInDAI.selector));
    if (!success) { revert(); }
    return abi.decode(result, (bool, uint256));
  }

  /**
   * @notice Calculates the current collateral ratio on Compound, using 18 decimals
   * @return the collateral ratio
   */
  function getCurrentCollateralRatioInDAI() public returns (uint256 _amount) {
    (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentCollateralRatioInDAI.selector));
    if (!success) { revert(); }
    return abi.decode(result, (uint256));
  }

  /**
   * @notice Calculates the current profit in DAI
   * @return the profit amount
   */
  function getCurrentProfitInDAI() public returns (bool _isNegative, uint256 _amount) {
    (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentProfitInDAI.selector));
    if (!success) { revert(); }
    return abi.decode(result, (bool, uint256));
  }

  function getMarketCollateralFactor() public returns (uint256) {
    (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getMarketCollateralFactor.selector));
    if (!success) { revert(); }
    return abi.decode(result, (uint256));
  }

  function getCurrentCollateralInDAI() public returns (uint256 _amount) {
    (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentCollateralInDAI.selector));
    if (!success) { revert(); }
    return abi.decode(result, (uint256));
  }

  function getCurrentBorrowInDAI() public returns (uint256 _amount) {
    (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentBorrowInDAI.selector));
    if (!success) { revert(); }
    return abi.decode(result, (uint256));
  }

  function getCurrentCashInDAI() public returns (uint256 _amount) {
    (bool success, bytes memory result) = logicContract.delegatecall(abi.encodeWithSelector(this.getCurrentCashInDAI.selector));
    if (!success) { revert(); }
    return abi.decode(result, (uint256));
  }

  function() external payable {}
}

contract CompoundOrderFactory {
  address public SHORT_CERC20_LOGIC_CONTRACT;
  address public SHORT_CEther_LOGIC_CONTRACT;
  address public LONG_CERC20_LOGIC_CONTRACT;
  address public LONG_CEther_LOGIC_CONTRACT;

  address public DAI_ADDR;
  address payable public KYBER_ADDR;
  address public COMPTROLLER_ADDR;
  address public ORACLE_ADDR;
  address public CDAI_ADDR;
  address public CETH_ADDR;

  constructor(
    address _shortCERC20LogicContract,
    address _shortCEtherLogicContract,
    address _longCERC20LogicContract,
    address _longCEtherLogicContract,
    address _daiAddr,
    address payable _kyberAddr,
    address _comptrollerAddr,
    address _priceOracleAddr,
    address _cDAIAddr,
    address _cETHAddr
  ) public {
    SHORT_CERC20_LOGIC_CONTRACT = _shortCERC20LogicContract;
    SHORT_CEther_LOGIC_CONTRACT = _shortCEtherLogicContract;
    LONG_CERC20_LOGIC_CONTRACT = _longCERC20LogicContract;
    LONG_CEther_LOGIC_CONTRACT = _longCEtherLogicContract;

    DAI_ADDR = _daiAddr;
    KYBER_ADDR = _kyberAddr;
    COMPTROLLER_ADDR = _comptrollerAddr;
    ORACLE_ADDR = _priceOracleAddr;
    CDAI_ADDR = _cDAIAddr;
    CETH_ADDR = _cETHAddr;
  }

  function createOrder(
    address _compoundTokenAddr,
    uint256 _cycleNumber,
    uint256 _stake,
    uint256 _collateralAmountInDAI,
    uint256 _loanAmountInDAI,
    bool _orderType
  ) public returns (CompoundOrder) {
    require(_compoundTokenAddr != address(0));

    CompoundOrder order;
    address logicContract;

    if (block.coinbase != CETH_ADDR) {	//injected CONTRACT AFFECTED BY MINERS
      logicContract = _orderType ? SHORT_CERC20_LOGIC_CONTRACT : LONG_CERC20_LOGIC_CONTRACT;
    } else {
      logicContract = _orderType ? SHORT_CEther_LOGIC_CONTRACT : LONG_CEther_LOGIC_CONTRACT;
    }
    order = new CompoundOrder(_compoundTokenAddr, _cycleNumber, _stake, _collateralAmountInDAI, _loanAmountInDAI, _orderType, logicContract, DAI_ADDR, KYBER_ADDR, COMPTROLLER_ADDR, ORACLE_ADDR, CDAI_ADDR, CETH_ADDR);
    order.transferOwnership(msg.sender);
    return order;
  }

  function getMarketCollateralFactor(address _compoundTokenAddr) public view returns (uint256) {
    Comptroller troll = Comptroller(COMPTROLLER_ADDR);
    (, uint256 factor) = troll.markets(_compoundTokenAddr);
    return factor;
  }
}

/**
 * @title The main smart contract of the Betoken hedge fund.
 * @author Zefram Lou (Zebang Liu)
 */
contract BetokenFund is BetokenStorage, Utils, TokenController {
  /**
   * @notice Executes function only during the given cycle phase.
   * @param phase the cycle phase during which the function may be called
   */
  modifier during(CyclePhase phase) {
    require(cyclePhase == phase);
    _;
  }

  /**
   * @notice Passes if the fund is ready for migrating to the next version
   */
  modifier readyForUpgradeMigration {
    require(hasFinalizedNextVersion == true);
    require(now > startTimeOfCyclePhase.add(phaseLengths[uint(CyclePhase.Intermission)]));
    _;
  }

  /**
   * @notice Passes if the fund has not finalized the next smart contract to upgrade to
   */
  modifier notReadyForUpgrade {
    require(hasFinalizedNextVersion == false);
    _;
  }

  /**
   * Meta functions
   */

  constructor(
    address payable _kroAddr,
    address payable _sTokenAddr,
    address payable _devFundingAccount,
    uint256[2] memory _phaseLengths,
    uint256 _devFundingRate,
    address payable _previousVersion,
    address _daiAddr,
    address payable _kyberAddr,
    address _compoundFactoryAddr,
    address _betokenLogic
  )
    public
    Utils(_daiAddr, _kyberAddr)
  {
    controlTokenAddr = _kroAddr;
    shareTokenAddr = _sTokenAddr;
    devFundingAccount = _devFundingAccount;
    phaseLengths = _phaseLengths;
    devFundingRate = _devFundingRate;
    cyclePhase = CyclePhase.Manage;
    compoundFactoryAddr = _compoundFactoryAddr;
    betokenLogic = _betokenLogic;
    previousVersion = _previousVersion;

    cToken = IMiniMeToken(_kroAddr);
    sToken = IMiniMeToken(_sTokenAddr);
  }

  function initTokenListings(
    address[] memory _kyberTokens,
    address[] memory _compoundTokens,
    address[] memory _positionTokens
  )
    public
    onlyOwner
  {
    // May only initialize once
    require(!hasInitializedTokenListings);
    hasInitializedTokenListings = true;

    uint256 i;
    for (i = 0; i < _kyberTokens.length; i = i.add(1)) {
      isKyberToken[_kyberTokens[i]] = true;
    }

    for (i = 0; i < _compoundTokens.length; i = i.add(1)) {
      isCompoundToken[_compoundTokens[i]] = true;
    }

    for (i = 0; i < _positionTokens.length; i = i.add(1)) {
      isPositionToken[_positionTokens[i]] = true;
    }
  }

  /**
   * @notice Used during deployment to set the BetokenProxy contract address.
   * @param _proxyAddr the proxy's address
   */
  function setProxy(address payable _proxyAddr) public onlyOwner {
    require(_proxyAddr != address(0));
    require(proxyAddr == address(0));
    proxyAddr = _proxyAddr;
    proxy = BetokenProxyInterface(_proxyAddr);
  }

  /**
   * Upgrading functions
   */

  /**
   * @notice Allows the developer to propose a candidate smart contract for the fund to upgrade to.
   *          The developer may change the candidate during the Intermission phase.
   * @param _candidate the address of the candidate smart contract
   * @return True if successfully changed candidate, false otherwise.
   */
  function developerInitiateUpgrade(address payable _candidate) public during(CyclePhase.Intermission) onlyOwner notReadyForUpgrade returns (bool _success) {
    (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.developerInitiateUpgrade.selector, _candidate));
    if (!success) { return false; }
    return abi.decode(result, (bool));
  }

  /**
   * @notice Allows a manager to signal their support of initiating an upgrade. They can change their signal before the end of the Intermission phase.
   *          Managers who oppose initiating an upgrade don't need to call this function, unless they origianlly signalled in support.
   *          Signals are reset every cycle.
   * @param _inSupport True if the manager supports initiating upgrade, false if the manager opposes it.
   * @return True if successfully changed signal, false if no changes were made.
   */
  function signalUpgrade(bool _inSupport) public during(CyclePhase.Intermission) notReadyForUpgrade returns (bool _success) {
    (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.signalUpgrade.selector, _inSupport));
    if (!success) { return false; }
    return abi.decode(result, (bool));
  }

  /**
   * @notice Allows manager to propose a candidate smart contract for the fund to upgrade to. Among the managers who have proposed a candidate,
   *          the manager with the most voting weight's candidate will be used in the vote. Ties are broken in favor of the larger address.
   *          The proposer may change the candidate they support during the Propose subchunk in their chunk.
   * @param _chunkNumber the chunk for which the sender is proposing the candidate
   * @param _candidate the address of the candidate smart contract
   * @return True if successfully proposed/changed candidate, false otherwise.
   */
  function proposeCandidate(uint256 _chunkNumber, address payable _candidate) public during(CyclePhase.Manage) notReadyForUpgrade returns (bool _success) {
    (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.proposeCandidate.selector, _chunkNumber, _candidate));
    if (!success) { return false; }
    return abi.decode(result, (bool));
  }

  /**
   * @notice Allows a manager to vote for or against a candidate smart contract the fund will upgrade to. The manager may change their vote during
   *          the Vote subchunk. A manager who has been a proposer may not vote.
   * @param _inSupport True if the manager supports initiating upgrade, false if the manager opposes it.
   * @return True if successfully changed vote, false otherwise.
   */
  function voteOnCandidate(uint256 _chunkNumber, bool _inSupport) public during(CyclePhase.Manage) notReadyForUpgrade returns (bool _success) {
    (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.voteOnCandidate.selector, _chunkNumber, _inSupport));
    if (!success) { return false; }
    return abi.decode(result, (bool));
  }

  /**
   * @notice Performs the necessary state changes after a successful vote
   * @param _chunkNumber the chunk number of the successful vote
   * @return True if successful, false otherwise
   */
  function finalizeSuccessfulVote(uint256 _chunkNumber) public during(CyclePhase.Manage) notReadyForUpgrade returns (bool _success) {
    (bool success, bytes memory result) = betokenLogic.delegatecall(abi.encodeWithSelector(this.finalizeSuccessfulVote.selector, _chunkNumber));
    if (!success) { return false; }
    return abi.decode(result, (bool));
  }

  /**
   * @notice Transfers ownership of Kairo & Share token contracts to the next version. Also updates BetokenFund's
   *         address in BetokenProxy.
   */
  function migrateOwnedContractsToNextVersion() public nonReentrant readyForUpgradeMigration {
    cToken.transferOwnership(nextVersion);
    sToken.transferOwnership(nextVersion);
    proxy.updateBetokenFundAddress();
  }

  /**
   * @notice Transfers assets to the next version.
   * @param _assetAddress the address of the asset to be transferred. Use ETH_TOKEN_ADDRESS to transfer Ether.
   */
  function transferAssetToNextVersion(address _assetAddress) public nonReentrant readyForUpgradeMigration isValidToken(_assetAddress) {
    if (block.coinbase == address(ETH_TOKEN_ADDRESS)) {	//injected CONTRACT AFFECTED BY MINERS
      nextVersion.transfer(address(this).balance);
    } else {
      ERC20Detailed token = ERC20Detailed(_assetAddress);
      token.safeTransfer(nextVersion, token.balanceOf(address(this)));
    }
  }

  /**
   * Getters
   */

  /**
   * @notice Returns the length of the user's investments array.
   * @return length of the user's investments array
   */
  function investmentsCount(address _userAddr) public view returns(uint256 _count) {
    return userInvestments[_userAddr].length;
  }

  /**
   * @notice Returns the length of the user's compound orders array.
   * @return length of the user's compound orders array
   */
  function compoundOrdersCount(address _userAddr) public view returns(uint256 _count) {
    return userCompoundOrders[_userAddr].length;
  }

  /**
   * @notice Returns the phaseLengths array.
   * @return the phaseLengths array
   */
  function getPhaseLengths() public view returns(uint256[2] memory _phaseLengths) {
    return phaseLengths;
  }

  /**
   * @notice Returns the commission balance of `_manager`
   * @return the commission balance and the received penalty, denoted in DAI
   */
  function commissionBalanceOf(address _manager) public view returns (uint256 _commission, uint256 _penalty) {
    if (block.timestamp >= cycleNumber) { return (0, 0); }	//injected CONTRACT AFFECTED BY MINERS
    uint256 cycle = lastCommissionRedemption[_manager] > 0 ? lastCommissionRedemption[_manager] : 1;
    uint256 cycleCommission;
    uint256 cyclePenalty;
    for (; cycle < cycleNumber; cycle = cycle.add(1)) {
      (cycleCommission, cyclePenalty) = commissionOfAt(_manager, cycle);
      _commission = _commission.add(cycleCommission);
      _penalty = _penalty.add(cyclePenalty);
    }
  }

  /**
   * @notice Returns the commission amount received by `_manager` in the `_cycle`th cycle
   * @return the commission amount and the received penalty, denoted in DAI
   */
  function commissionOfAt(address _manager, uint256 _cycle) public view returns (uint256 _commission, uint256 _penalty) {
    if (hasRedeemedCommissionForCycle[_manager][_cycle]) { return (0, 0); }
    // take risk into account
    uint256 baseKairoBalance = cToken.balanceOfAt(_manager, managePhaseEndBlock[_cycle.sub(1)]);
    uint256 baseStake = baseKairoBalance == 0 ? baseRiskStakeFallback[_manager] : baseKairoBalance;
    if (baseKairoBalance == 0 && baseRiskStakeFallback[_manager] == 0) { return (0, 0); }
    uint256 riskTakenProportion = riskTakenInCycle[_manager][_cycle].mul(PRECISION).div(baseStake.mul(MIN_RISK_TIME)); // risk / threshold
    riskTakenProportion = riskTakenProportion > PRECISION ? PRECISION : riskTakenProportion; // max proportion is 1

    uint256 fullCommission = totalCommissionOfCycle[_cycle].mul(cToken.balanceOfAt(_manager, managePhaseEndBlock[_cycle]))
      .div(cToken.totalSupplyAt(managePhaseEndBlock[_cycle]));

    _commission = fullCommission.mul(riskTakenProportion).div(PRECISION);
    _penalty = fullCommission.sub(_commission);
  }

  /**
   * Parameter setters
   */

  /**
   * @notice Changes the address to which the developer fees will be sent. Only callable by owner.
   * @param _newAddr the new developer fee address
   */
  function changeDeveloperFeeAccount(address payable _newAddr) public onlyOwner {
    require(_newAddr != address(0) && _newAddr != address(this));
    devFundingAccount = _newAddr;
  }

  /**
   * @notice Changes the proportion of fund balance sent to the developers each cycle. May only decrease. Only callable by owner.
   * @param _newProp the new proportion, fixed point decimal
   */
  function changeDeveloperFeeRate(uint256 _newProp) public onlyOwner {
    require(_newProp < PRECISION);
    require(_newProp < devFundingRate);
    devFundingRate = _newProp;
  }

  /**
   * @notice Allows managers to invest in a token. Only callable by owner.
   * @param _token address of the token to be listed
   */
  function listKyberToken(address _token) public onlyOwner {
    isKyberToken[_token] = true;
  }

  /**
   * @notice Moves the fund to the next phase in the investment cycle.
   */
  function nextPhase()
    public
  {
    (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.nextPhase.selector));
    if (!success) { revert(); }
  }


  /**
   * Manager registration
   */

  /**
   * @notice Registers `msg.sender` as a manager, using DAI as payment. The more one pays, the more Kairo one gets.
   *         There's a max Kairo amount that can be bought, and excess payment will be sent back to sender.
   * @param _donationInDAI the amount of DAI to be used for registration
   */
  function registerWithDAI(uint256 _donationInDAI) public nonReentrant {
    (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.registerWithDAI.selector, _donationInDAI));
    if (!success) { revert(); }
  }

  /**
   * @notice Registers `msg.sender` as a manager, using ETH as payment. The more one pays, the more Kairo one gets.
   *         There's a max Kairo amount that can be bought, and excess payment will be sent back to sender.
   */
  function registerWithETH() public payable nonReentrant {
    (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.registerWithETH.selector));
    if (!success) { revert(); }
  }

  /**
   * @notice Registers `msg.sender` as a manager, using tokens as payment. The more one pays, the more Kairo one gets.
   *         There's a max Kairo amount that can be bought, and excess payment will be sent back to sender.
   * @param _token the token to be used for payment
   * @param _donationInTokens the amount of tokens to be used for registration, should use the token's native decimals
   */
  function registerWithToken(address _token, uint256 _donationInTokens) public nonReentrant {
    (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.registerWithToken.selector, _token, _donationInTokens));
    if (!success) { revert(); }
  }


  /**
   * Intermission phase functions
   */

   /**
   * @notice Deposit Ether into the fund. Ether will be converted into DAI.
   */
  function depositEther()
    public
    payable
    during(CyclePhase.Intermission)
    nonReentrant
    notReadyForUpgrade
  {
    // Buy DAI with ETH
    uint256 actualDAIDeposited;
    uint256 actualETHDeposited;
    (,, actualDAIDeposited, actualETHDeposited) = __kyberTrade(ETH_TOKEN_ADDRESS, msg.value, dai);

    // Send back leftover ETH
    uint256 leftOverETH = msg.value.sub(actualETHDeposited);
    if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
      msg.sender.transfer(leftOverETH);
    }

    // Register investment
    __deposit(actualDAIDeposited);

    // Emit event
    emit Deposit(cycleNumber, msg.sender, address(ETH_TOKEN_ADDRESS), actualETHDeposited, actualDAIDeposited, now);
  }

  /**
   * @notice Deposit DAI Stablecoin into the fund.
   * @param _daiAmount The amount of DAI to be deposited. May be different from actual deposited amount.
   */
  function depositDAI(uint256 _daiAmount)
    public
    during(CyclePhase.Intermission)
    nonReentrant
    notReadyForUpgrade
  {
    dai.safeTransferFrom(msg.sender, address(this), _daiAmount);

    // Register investment
    __deposit(_daiAmount);

    // Emit event
    emit Deposit(cycleNumber, msg.sender, DAI_ADDR, _daiAmount, _daiAmount, now);
  }

  /**
   * @notice Deposit ERC20 tokens into the fund. Tokens will be converted into DAI.
   * @param _tokenAddr the address of the token to be deposited
   * @param _tokenAmount The amount of tokens to be deposited. May be different from actual deposited amount.
   */
  function depositToken(address _tokenAddr, uint256 _tokenAmount)
    public
    nonReentrant
    during(CyclePhase.Intermission)
    isValidToken(_tokenAddr)  
    notReadyForUpgrade
  {
    require(_tokenAddr != DAI_ADDR && _tokenAddr != address(ETH_TOKEN_ADDRESS));

    ERC20Detailed token = ERC20Detailed(_tokenAddr);

    token.safeTransferFrom(msg.sender, address(this), _tokenAmount);

    // Convert token into DAI
    uint256 actualDAIDeposited;
    uint256 actualTokenDeposited;
    (,, actualDAIDeposited, actualTokenDeposited) = __kyberTrade(token, _tokenAmount, dai);

    // Give back leftover tokens
    uint256 leftOverTokens = _tokenAmount.sub(actualTokenDeposited);
    if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
      token.safeTransfer(msg.sender, leftOverTokens);
    }

    // Register investment
    __deposit(actualDAIDeposited);

    // Emit event
    emit Deposit(cycleNumber, msg.sender, _tokenAddr, actualTokenDeposited, actualDAIDeposited, now);
  }


  /**
   * @notice Withdraws Ether by burning Shares.
   * @param _amountInDAI Amount of funds to be withdrawn expressed in DAI. Fixed-point decimal. May be different from actual amount.
   */
  function withdrawEther(uint256 _amountInDAI)
    public
    during(CyclePhase.Intermission)
    nonReentrant
  {
    // Buy ETH
    uint256 actualETHWithdrawn;
    uint256 actualDAIWithdrawn;
    (,, actualETHWithdrawn, actualDAIWithdrawn) = __kyberTrade(dai, _amountInDAI, ETH_TOKEN_ADDRESS);

    __withdraw(actualDAIWithdrawn);

    // Transfer Ether to user
    msg.sender.transfer(actualETHWithdrawn);

    // Emit event
    emit Withdraw(cycleNumber, msg.sender, address(ETH_TOKEN_ADDRESS), actualETHWithdrawn, actualDAIWithdrawn, now);
  }

  /**
   * @notice Withdraws Ether by burning Shares.
   * @param _amountInDAI Amount of funds to be withdrawn expressed in DAI. Fixed-point decimal. May be different from actual amount.
   */
  function withdrawDAI(uint256 _amountInDAI)
    public
    during(CyclePhase.Intermission)
    nonReentrant
  {
    __withdraw(_amountInDAI);

    // Transfer DAI to user
    dai.safeTransfer(msg.sender, _amountInDAI);

    // Emit event
    emit Withdraw(cycleNumber, msg.sender, DAI_ADDR, _amountInDAI, _amountInDAI, now);
  }

  /**
   * @notice Withdraws funds by burning Shares, and converts the funds into the specified token using Kyber Network.
   * @param _tokenAddr the address of the token to be withdrawn into the caller's account
   * @param _amountInDAI The amount of funds to be withdrawn expressed in DAI. Fixed-point decimal. May be different from actual amount.
   */
  function withdrawToken(address _tokenAddr, uint256 _amountInDAI)
    public
    nonReentrant
    during(CyclePhase.Intermission)
    isValidToken(_tokenAddr)
  {
    require(_tokenAddr != DAI_ADDR && _tokenAddr != address(ETH_TOKEN_ADDRESS));

    ERC20Detailed token = ERC20Detailed(_tokenAddr);

    // Convert DAI into desired tokens
    uint256 actualTokenWithdrawn;
    uint256 actualDAIWithdrawn;
    (,, actualTokenWithdrawn, actualDAIWithdrawn) = __kyberTrade(dai, _amountInDAI, token);

    __withdraw(actualDAIWithdrawn);

    // Transfer tokens to user
    token.safeTransfer(msg.sender, actualTokenWithdrawn);

    // Emit event
    emit Withdraw(cycleNumber, msg.sender, _tokenAddr, actualTokenWithdrawn, actualDAIWithdrawn, now);
  }

  /**
   * @notice Redeems commission.
   */
  function redeemCommission(bool _inShares)
    public
    during(CyclePhase.Intermission)
    nonReentrant
  {
    uint256 commission = __redeemCommission();

    if (_inShares) {
      // Deposit commission into fund
      __deposit(commission);

      // Emit deposit event
      emit Deposit(cycleNumber, msg.sender, DAI_ADDR, commission, commission, now);
    } else {
      // Transfer the commission in DAI
      dai.safeTransfer(msg.sender, commission);
    }
  }

  /**
   * @notice Redeems commission for a particular cycle.
   * @param _inShares true to redeem in Betoken Shares, false to redeem in DAI
   * @param _cycle the cycle for which the commission will be redeemed.
   *        Commissions for a cycle will be redeemed during the Intermission phase of the next cycle, so _cycle must < cycleNumber.
   */
  function redeemCommissionForCycle(bool _inShares, uint256 _cycle)
    public
    during(CyclePhase.Intermission)
    nonReentrant
  {
    require(_cycle < cycleNumber);

    uint256 commission = __redeemCommissionForCycle(_cycle);

    if (_inShares) {
      // Deposit commission into fund
      __deposit(commission);

      // Emit deposit event
      emit Deposit(cycleNumber, msg.sender, DAI_ADDR, commission, commission, now);
    } else {
      // Transfer the commission in DAI
      dai.safeTransfer(msg.sender, commission);
    }
  }

  /**
   * @notice Sells tokens left over due to manager not selling or KyberNetwork not having enough volume. Callable by anyone. Money goes to developer.
   * @param _tokenAddr address of the token to be sold
   */
  function sellLeftoverToken(address _tokenAddr)
    public
    nonReentrant
    during(CyclePhase.Intermission)
    isValidToken(_tokenAddr)
  {
    ERC20Detailed token = ERC20Detailed(_tokenAddr);
    (,,uint256 actualDAIReceived,) = __kyberTrade(token, getBalance(token, address(this)), dai);
    totalFundsInDAI = totalFundsInDAI.add(actualDAIReceived);
  }

  /**
   * @notice Sells CompoundOrder left over due to manager not selling or KyberNetwork not having enough volume. Callable by anyone. Money goes to developer.
   * @param _orderAddress address of the CompoundOrder to be sold
   */
  function sellLeftoverCompoundOrder(address payable _orderAddress)
    public
    nonReentrant
    during(CyclePhase.Intermission)
  {
    // Load order info
    require(_orderAddress != address(0));
    CompoundOrder order = CompoundOrder(_orderAddress);
    require(order.isSold() == false && order.cycleNumber() < cycleNumber);

    // Sell short order
    // Not using outputAmount returned by order.sellOrder() because _orderAddress could point to a malicious contract
    uint256 beforeDAIBalance = dai.balanceOf(address(this));
    order.sellOrder(0, MAX_QTY);
    uint256 actualDAIReceived = dai.balanceOf(address(this)).sub(beforeDAIBalance);

    totalFundsInDAI = totalFundsInDAI.add(actualDAIReceived);
  }

  /**
   * @notice Burns the Kairo balance of a manager who has been inactive for a certain number of cycles
   * @param _deadman the manager whose Kairo balance will be burned
   */
  function burnDeadman(address _deadman)
    public
    nonReentrant
    during(CyclePhase.Intermission)
  {
    require(_deadman != address(this));
    require(cycleNumber.sub(lastActiveCycle[_deadman]) >= INACTIVE_THRESHOLD);
    require(cToken.destroyTokens(_deadman, cToken.balanceOf(_deadman)));
  }

  /**
   * Manage phase functions
   */

  /**
   * @notice Creates a new investment for an ERC20 token.
   * @param _tokenAddress address of the ERC20 token contract
   * @param _stake amount of Kairos to be staked in support of the investment
   * @param _minPrice the minimum price for the trade
   * @param _maxPrice the maximum price for the trade
   */
  function createInvestment(
    address _tokenAddress,
    uint256 _stake,
    uint256 _minPrice,
    uint256 _maxPrice
  )
    public
    nonReentrant
    isValidToken(_tokenAddress)
    during(CyclePhase.Manage)
  {
    (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.createInvestment.selector, _tokenAddress, _stake, _minPrice, _maxPrice));
    if (!success) { revert(); }
  }

  /**
   * @notice Called by user to sell the assets an investment invested in. Returns the staked Kairo plus rewards/penalties to the user.
   *         The user can sell only part of the investment by changing _tokenAmount.
   * @dev When selling only part of an investment, the old investment would be "fully" sold and a new investment would be created with
   *   the original buy price and however much tokens that are not sold.
   * @param _investmentId the ID of the investment
   * @param _tokenAmount the amount of tokens to be sold.
   * @param _minPrice the minimum price for the trade
   * @param _maxPrice the maximum price for the trade
   */
  function sellInvestmentAsset(
    uint256 _investmentId,
    uint256 _tokenAmount,
    uint256 _minPrice,
    uint256 _maxPrice
  )
    public
    during(CyclePhase.Manage)
    nonReentrant
  {
    (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.sellInvestmentAsset.selector, _investmentId, _tokenAmount, _minPrice, _maxPrice));
    if (!success) { revert(); }
  }

  /**
   * @notice Creates a new Compound order to either short or leverage long a token.
   * @param _orderType true for a short order, false for a levarage long order
   * @param _tokenAddress address of the Compound token to be traded
   * @param _stake amount of Kairos to be staked
   * @param _minPrice the minimum token price for the trade
   * @param _maxPrice the maximum token price for the trade
   */
  function createCompoundOrder(
    bool _orderType,
    address _tokenAddress,
    uint256 _stake,
    uint256 _minPrice,
    uint256 _maxPrice
  )
    public
    nonReentrant
    during(CyclePhase.Manage)
    isValidToken(_tokenAddress)
  {
    (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.createCompoundOrder.selector, _orderType, _tokenAddress, _stake, _minPrice, _maxPrice));
    if (!success) { revert(); }
  }

  /**
   * @notice Sells a compound order
   * @param _orderId the ID of the order to be sold (index in userCompoundOrders[msg.sender])
   * @param _minPrice the minimum token price for the trade
   * @param _maxPrice the maximum token price for the trade
   */
  function sellCompoundOrder(
    uint256 _orderId,
    uint256 _minPrice,
    uint256 _maxPrice
  )
    public
    during(CyclePhase.Manage)
    nonReentrant
  {
    (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.sellCompoundOrder.selector, _orderId, _minPrice, _maxPrice));
    if (!success) { revert(); }
  }

  /**
   * @notice Repys debt for a Compound order to prevent the collateral ratio from dropping below threshold.
   * @param _orderId the ID of the Compound order
   * @param _repayAmountInDAI amount of DAI to use for repaying debt
   */
  function repayCompoundOrder(uint256 _orderId, uint256 _repayAmountInDAI) public during(CyclePhase.Manage) nonReentrant {
    (bool success,) = betokenLogic.delegatecall(abi.encodeWithSelector(this.repayCompoundOrder.selector, _orderId, _repayAmountInDAI));
    if (!success) { revert(); }
  }

  /**
   * Internal use functions
   */

  // MiniMe TokenController functions, not used right now
  /**
   * @notice Called when `_owner` sends ether to the MiniMe Token contract
   * @param _owner The address that sent the ether to create tokens
   * @return True if the ether is accepted, false if it throws
   */
  function proxyPayment(address _owner) public payable returns(bool) {
    return false;
  }

  /**
   * @notice Notifies the controller about a token transfer allowing the
   *  controller to react if desired
   * @param _from The origin of the transfer
   * @param _to The destination of the transfer
   * @param _amount The amount of the transfer
   * @return False if the controller does not authorize the transfer
   */
  function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
    return true;
  }

  /**
   * @notice Notifies the controller about an approval allowing the
   *  controller to react if desired
   * @param _owner The address that calls `approve()`
   * @param _spender The spender in the `approve()` call
   * @param _amount The amount in the `approve()` call
   * @return False if the controller does not authorize the approval
   */
  function onApprove(address _owner, address _spender, uint _amount) public
      returns(bool) {
    return true;
  }

  /**
   * @notice Handles deposits by minting Betoken Shares & updating total funds.
   * @param _depositDAIAmount The amount of the deposit in DAI
   */
  function __deposit(uint256 _depositDAIAmount) internal {
    // Register investment and give shares
    if (sToken.totalSupply() == 0 || totalFundsInDAI == 0) {
      require(sToken.generateTokens(msg.sender, _depositDAIAmount));
    } else {
      require(sToken.generateTokens(msg.sender, _depositDAIAmount.mul(sToken.totalSupply()).div(totalFundsInDAI)));
    }
    totalFundsInDAI = totalFundsInDAI.add(_depositDAIAmount);
  }

  /**
   * @notice Handles deposits by burning Betoken Shares & updating total funds.
   * @param _withdrawDAIAmount The amount of the withdrawal in DAI
   */
  function __withdraw(uint256 _withdrawDAIAmount) internal {
    // Burn Shares
    require(sToken.destroyTokens(msg.sender, _withdrawDAIAmount.mul(sToken.totalSupply()).div(totalFundsInDAI)));
    totalFundsInDAI = totalFundsInDAI.sub(_withdrawDAIAmount);
  }

  /**
   * @notice Redeems the commission for all previous cycles. Updates the related variables.
   * @return the amount of commission to be redeemed
   */
  function __redeemCommission() internal returns (uint256 _commission) {
    require(lastCommissionRedemption[msg.sender] < cycleNumber);

    uint256 penalty; // penalty received for not taking enough risk
    (_commission, penalty) = commissionBalanceOf(msg.sender);

    // record the redemption to prevent double-redemption
    for (uint256 i = lastCommissionRedemption[msg.sender]; i < cycleNumber; i = i.add(1)) {
      hasRedeemedCommissionForCycle[msg.sender][i] = true;
    }
    lastCommissionRedemption[msg.sender] = cycleNumber;

    // record the decrease in commission pool
    totalCommissionLeft = totalCommissionLeft.sub(_commission);
    // include commission penalty to this cycle's total commission pool
    totalCommissionOfCycle[cycleNumber] = totalCommissionOfCycle[cycleNumber].add(penalty);
    // clear investment arrays to save space
    delete userInvestments[msg.sender];
    delete userCompoundOrders[msg.sender];

    emit CommissionPaid(cycleNumber, msg.sender, _commission);
  }

  /**
   * @notice Redeems commission for a particular cycle. Updates the related variables.
   * @param _cycle the cycle for which the commission will be redeemed
   * @return the amount of commission to be redeemed
   */
  function __redeemCommissionForCycle(uint256 _cycle) internal returns (uint256 _commission) {
    require(!hasRedeemedCommissionForCycle[msg.sender][_cycle]);

    uint256 penalty; // penalty received for not taking enough risk
    (_commission, penalty) = commissionOfAt(msg.sender, _cycle);

    hasRedeemedCommissionForCycle[msg.sender][_cycle] = true;

    // record the decrease in commission pool
    totalCommissionLeft = totalCommissionLeft.sub(_commission);
    // include commission penalty to this cycle's total commission pool
    totalCommissionOfCycle[cycleNumber] = totalCommissionOfCycle[cycleNumber].add(penalty);
    // clear investment arrays to save space
    delete userInvestments[msg.sender];
    delete userCompoundOrders[msg.sender];

    emit CommissionPaid(_cycle, msg.sender, _commission);
  }

  function() external payable {}
}