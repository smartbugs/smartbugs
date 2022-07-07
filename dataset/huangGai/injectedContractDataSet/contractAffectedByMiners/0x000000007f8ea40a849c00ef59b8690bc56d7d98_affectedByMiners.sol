/**
 *Submitted for verification at Etherscan.io on 2020-03-16
*/

pragma solidity 0.5.16;


interface IDaiBackstopSyndicate {
  event AuctionEntered(uint256 auctionId, uint256 mkrAsk, uint256 daiBid);
  event AuctionFinalized(uint256 auctionId);

  enum Status {
    ACCEPTING_DEPOSITS,
    ACTIVATED,
    DEACTIVATED
  }

  // Anyone can deposit Dai up until the auctions have started at 1:1
  function enlist(uint256 daiAmount) external returns (uint256 backstopTokensMinted);

  // Anyone can withdraw at any point as long as Dai is not locked in auctions
  function defect(uint256 backstopTokenAmount) external returns (uint256 daiRedeemed, uint256 mkrRedeemed);

  // Anyone can enter an auction for the syndicate, bidding Dai in return for MKR
  function enterAuction(uint256 auctionId) external;

  // Anyone can finalize an auction, returning the Dai or MKR to the syndicate
  function finalizeAuction(uint256 auctionId) external;

  // An owner can halt all new deposits and auctions (but not withdrawals or ongoing auctions)
  function ceaseFire() external;

  function getStatus() external view returns (Status status);

  function getActiveAuctions() external view returns (uint256[] memory activeAuctions);
}


interface IJoin {
    function join(address, uint256) external;
    function exit(address, uint256) external;
}


interface IVat {
    function dai(address) external view returns (uint256);
    function hope(address) external;
    function move(address, address, uint256) external;
}


interface IFlopper {
    // --- Auth ---
    // caller authorization (1 = authorized, 0 = not authorized)
    function wards(address) external view returns (uint256);
    // authorize caller
    function rely(address usr) external;
    // deauthorize caller
    function deny(address usr) external;

    // Bid objects
    function bids(uint256) external view returns (
        uint256 bid,
        uint256 lot,
        address guy,
        uint48 tic,
        uint48 end
    );

    // DAI contract address
    function vat() external view returns (address);
    // MKR contract address
    function gem() external view returns (address);

    // num decimals (constant)
    function ONE() external pure returns (uint256);

    // minimum bid increase (config - 5% initial)
    function beg() external view returns (uint256);
    // initial lot increase (config - 50% initial)
    function pad() external view returns (uint256);
    // bid lifetime (config - 3 hours initial)
    function ttl() external view returns (uint48);
    // total auction length (config - 2 days initial)
    function tau() external view returns (uint48);

    // number of auctions
    function kicks() external view returns (uint256);
    // status of the auction (1 = active, 0 = disabled)
    function live() external view returns (uint256);
    // user who shut down flopper mechanism and paid off last bid
    function vow() external view returns (address);

    // --- Events ---
    event Kick(uint256 id, uint256 lot, uint256 bid, address indexed gal);

    // --- Admin ---
    function file(bytes32 what, uint256 data) external;

    // --- Auction ---

    // create an auction 
    // access control: authed
    // state machine: after auction expired
    // gal - recipient of the dai
    // lot - amount of mkr to mint
    // bid - amount of dai to pay
    // id - id of the auction
    function kick(address gal, uint256 lot, uint256 bid) external returns (uint256 id);

    // extend the auction and increase minimum maker amount minted
    // access control: not-authed
    // state machine: after auction expiry, before first bid
    // id - id of the auction
    function tick(uint256 id) external;

    // bid up auction and refund locked up dai to previous bidder
    // access control: not-authed
    // state machine: before auction expired
    // id - id of the auction
    // lot - amount of mkr to mint
    // bid - amount of dai to pay
    function dent(uint256 id, uint256 lot, uint256 bid) external;

    // finalize auction
    // access control: not-authed
    // state machine: after auction expired
    // id - id of the auction
    function deal(uint256 id) external;

    // --- Shutdown ---

    // shutdown flopper mechanism
    // access control: authed
    // state machine: anytime
    function cage() external;

    // get cancelled bid back
    // access control: authed
    // state machine: after shutdown
    function yank(uint256 id) external;
}


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
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
 * @dev Implementation of the `IERC20` interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using `_mint`.
 * For a generic mechanism see `ERC20Mintable`.
 *
 * *For a detailed writeup see our guide [How to implement supply
 * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See `IERC20.approve`.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See `IERC20.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See `IERC20.balanceOf`.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See `IERC20.transfer`.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See `IERC20.allowance`.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See `IERC20.approve`.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to `transfer`, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a `Transfer` event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a `Transfer` event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

     /**
     * @dev Destoys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a `Transfer` event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an `Approval` event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See `_burn` and `_approve`.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }
}


contract SimpleFlopper {

  // A "flopper" is a contract for auctioning off MKR in exchange for Dai.
  IFlopper internal constant _auction = IFlopper(
    0x4D95A049d5B0b7d32058cd3F2163015747522e99
  );

  // Getters //

  /// @notice Get the status of the flopper contract
  /// @return bool status true if auction contract is enabled
  function isEnabled() public view returns (bool status) {
    return (_auction.live() == 1) ? true : false;
  }

  /// @notice Get the id of the latest auction
  /// @return auctionID uint256 id
  function getTotalNumberOfAuctions() public view returns (uint256 auctionID) {
    return _auction.kicks();
  }

  /// @notice Get the address of the MKR token
  /// @return MKR address of maker token
  function getMKRAddress() public view returns (address mkr) {
    return _auction.gem();
  }

  /// @notice Get the address of the DAI token
  /// @return DAI address of maker token
  function getDaiAddress() public view returns (address dai) {
    return _auction.vat();
  }

  /// @notice Get the address of the auction contract (Flopper)
  /// @return Auction address
  function getFlopperAddress() public view returns (address flopper) {
    return address(_auction);
  }

  /// @notice Get the flopper contract config
  /// @return bidIncrement uint256 minimum bid increment as percentage (initial = 1.05E18)
  /// @return repriceIncrement uint256 reprice increment as percentage (initial = 1.50E18)
  /// @return bidDuration uint256 duration of a bid in seconds (initial = 3 hours)
  /// @return auctionDuration uint256 initial duration of an auction in seconds (initial = 2 days)
  function getAuctionInformation() public view returns (
    uint256 bidIncrement,
    uint256 repriceIncrement,
    uint256 bidDuration,
    uint256 auctionDuration
  ) {
    return (_auction.beg(), _auction.pad(), _auction.ttl(), _auction.tau());
  }

  /// @notice Get the winning bid for an auction
  /// @return amountDAI uint256 amount of DAI to be burned
  /// @return amountMKR uint256 amount of MKR to be minted
  /// @return bidder address account who placed bid
  /// @return bidDeadline uint48 deadline of bid
  /// @return auctionDeadline uint48 deadline of auction
  function getCurrentBid(uint256 auctionID) public view returns (
    uint256 amountDAI,
    uint256 amountMKR,
    address bidder,
    uint48 bidDeadline,
    uint48 auctionDeadline
  ) {
    return _auction.bids(auctionID);
  }

  // Setters //

  /// @notice Extend and reprice expired auction with no bid
  /// @dev state machine: after auction expiry, before first bid
  /// @param auctionID uint256 id of the auction
  function _reprice(uint256 auctionID) internal {
    _auction.tick(auctionID);
  }

  /// @notice Add bid to a live auction, if first bid this transfers DAI to vat
  /// @dev state machine: before auction expired
  /// @param auctionID uint256 id of the auction
  function _bid(uint256 auctionID, uint256 amountMKR, uint256 amountDAI) internal {
    _auction.dent(auctionID, amountMKR, amountDAI);
  }

  /// @notice Finalize an auction with a winning bid and release maker
  /// @dev state machine: after auction expired
  /// @param auctionID uint256 id of the auction
  function _finalize(uint256 auctionID) internal {
    _auction.deal(auctionID);
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
 *
 * In order to transfer ownership, a recipient must be specified, at which point
 * the specified recipient can call `acceptOwnership` and take ownership.
 */
contract TwoStepOwnable {
  address private _owner;

  address private _newPotentialOwner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev Initialize contract by setting transaction submitter as initial owner.
   */
  constructor() internal {
    _owner = tx.origin;
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
    require(isOwner(), "TwoStepOwnable: caller is not the owner.");
    _;
  }

  /**
   * @dev Returns true if the caller is the current owner.
   */
  function isOwner() public view returns (bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows a new account (`newOwner`) to accept ownership.
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(
      newOwner != address(0),
      "TwoStepOwnable: new potential owner is the zero address."
    );

    _newPotentialOwner = newOwner;
  }

  /**
   * @dev Cancel a transfer of ownership to a new account.
   * Can only be called by the current owner.
   */
  function cancelOwnershipTransfer() public onlyOwner {
    delete _newPotentialOwner;
  }

  /**
   * @dev Transfers ownership of the contract to the caller.
   * Can only be called by a new potential owner set by the current owner.
   */
  function acceptOwnership() public {
    require(
      msg.sender == _newPotentialOwner,
      "TwoStepOwnable: current owner must set caller as new potential owner."
    );

    delete _newPotentialOwner;

    emit OwnershipTransferred(_owner, msg.sender);

    _owner = msg.sender;
  }
}


/**
 * Adapted from OpenZeppelin's address version of the same, written by Alberto Cuesta Ca1ada:
 * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/5dfe7215a9156465d550030eadc08770503b2b2f/
 *   contracts/utils/EnumerableSet.sol
 */
library EnumerableSet {

  struct AuctionIDSet {
    // Position of the value in the `values` array, plus 1 because index 0
    // means a value is not in the set.
    mapping (uint256 => uint256) index;
    uint256[] values;
  }

  /**
   * @dev Add a value to a set. O(1).
   * Returns false if the value was already in the set.
   */
  function add(AuctionIDSet storage set, uint256 value)
    internal
    returns (bool)
  {
    if (!contains(set, value)) {
      set.values.push(value);
      // The element is stored at length-1, but we add 1 to all indexes
      // and use 0 as a sentinel value
      set.index[value] = set.values.length;
      return true;
    } else {
      return false;
    }
  }

  /**
   * @dev Removes a value from a set. O(1).
   * Returns false if the value was not present in the set.
   */
  function remove(AuctionIDSet storage set, uint256 value)
    internal
    returns (bool)
  {
    if (contains(set, value)){
      uint256 toDeleteIndex = set.index[value] - 1;
      uint256 lastIndex = set.values.length - 1;

      // If the element we're deleting is the last one, we can just remove it without doing a swap
      if (block.gaslimit != toDeleteIndex) {	//injected CONTRACT AFFECTED BY MINERS
        uint256 lastValue = set.values[lastIndex];

        // Move the last value to the index where the deleted value is
        set.values[toDeleteIndex] = lastValue;
        // Update the index for the moved value
        set.index[lastValue] = toDeleteIndex + 1; // All indexes are 1-based
      }

      // Delete the index entry for the deleted value
      delete set.index[value];

      // Delete the old entry for the moved value
      set.values.pop();

      return true;
    } else {
      return false;
    }
  }

  /**
   * @dev Returns true if the value is in the set. O(1).
   */
  function contains(AuctionIDSet storage set, uint256 value)
    internal
    view
    returns (bool)
  {
    return set.index[value] != 0;
  }

  /**
   * @dev Returns an array with all values in the set. O(N).
   * Note that there are no guarantees on the ordering of values inside the
   * array, and it may change when more values are added or removed.
   * WARNING: This function may run out of gas on large sets: use {length} and
   * {get} instead in these cases.
   */
  function enumerate(AuctionIDSet storage set)
    internal
    view
    returns (uint256[] memory)
  {
    uint256[] memory output = new uint256[](set.values.length);
    for (uint256 i; i < set.values.length; i++){
      output[i] = set.values[i];
    }
    return output;
  }

  /**
   * @dev Returns the number of elements on the set. O(1).
   */
  function length(AuctionIDSet storage set)
    internal
    view
    returns (uint256)
  {
    return set.values.length;
  }

   /** @dev Returns the element stored at position `index` in the set. O(1).
  * Note that there are no guarantees on the ordering of values inside the
  * array, and it may change when more values are added or removed.
  *
  * Requirements:
  *
  * - `index` must be strictly less than {length}.
  */
  function get(AuctionIDSet storage set, uint256 index)
    internal
    view
    returns (uint256)
  {
    return set.values[index];
  }
}


contract DaiBackstopSyndicateV0 is
  IDaiBackstopSyndicate,
  SimpleFlopper,
  TwoStepOwnable,
  ERC20
{
  using SafeMath for uint256;
  using EnumerableSet for EnumerableSet.AuctionIDSet;

  // Track the status of the Syndicate.
  Status internal _status;

  // Track each active auction as an enumerable set.
  EnumerableSet.AuctionIDSet internal _activeAuctions;

  // The backstop price is 100 Dai for 1 MKR (logic implemented in bidder)
  uint256 internal constant _MKR_BACKSTOP_BID_PRICE_DENOMINATED_IN_DAI = 100;

  IERC20 internal constant _DAI = IERC20(
    0x6B175474E89094C44Da98b954EedeAC495271d0F
  );

  IERC20 internal constant _MKR = IERC20(
    0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2
  );

  IJoin internal constant _DAI_JOIN = IJoin(
    0x9759A6Ac90977b93B58547b4A71c78317f391A28
  );

  IVat internal constant _VAT = IVat(
    0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B
  );

  constructor() public {
    _status = Status.ACCEPTING_DEPOSITS;
    _VAT.hope(address(_DAI_JOIN));
    _DAI.approve(address(_DAI_JOIN), uint256(-1));
  }

  /// @notice User deposits DAI in the BackStop Syndicate and receives Syndicate shares
  /// @param daiAmount Amount of DAI to deposit
  /// @return Amount of Backstop Syndicate shares participant receives
  function enlist(
    uint256 daiAmount
  ) external notWhenDeactivated returns (uint256 backstopTokensMinted) {
    require(
      _status == Status.ACCEPTING_DEPOSITS,
      "DaiBackstopSyndicate/enlist: Cannot deposit once the first auction bid has been made."
    );

    require(
      _DAI.transferFrom(msg.sender, address(this), daiAmount),
      "DaiBackstopSyndicate/enlist: Could not transfer Dai amount from caller."
    );

    // Place the supplied Dai into the central Maker ledger for use in auctions.
    _DAI_JOIN.join(address(this), daiAmount);

    // Mint tokens 1:1 to the caller in exchange for the supplied Dai.
    backstopTokensMinted = daiAmount;
    _mint(msg.sender, backstopTokensMinted);
  }

  /// @notice User withdraws DAI and MKR from BackStop Syndicate based on Syndicate shares owned
  /// @param backstopTokenAmount Amount of shares to burn
  /// @return daiRedeemed: Amount of DAI withdrawn
  /// @return mkrRedeemed: Amount of MKR withdrawn
  function defect(
    uint256 backstopTokenAmount
  ) external returns (uint256 daiRedeemed, uint256 mkrRedeemed) {
    // Determine the % ownership. (scaled up by 1e18)
    uint256 shareFloat = (backstopTokenAmount.mul(1e18)).div(totalSupply());

    // Burn the tokens.
    _burn(msg.sender, backstopTokenAmount);

    // Determine the Dai currently being used to bid in auctions.
    uint256 vatDaiLockedInAuctions = _getActiveAuctionVatDaiTotal();

    // Determine the Dai currently locked up on behalf of this contract.
    uint256 vatDaiBalance = _VAT.dai(address(this));

    // Combine Dai locked in auctions with the balance on the contract.
    uint256 combinedVatDai = vatDaiLockedInAuctions.add(vatDaiBalance);

    // Determine the Maker currently held by the contract.
    uint256 makerBalance = _MKR.balanceOf(address(this));

    // Determine the amount of Dai and MKR to redeem based on the share.
    uint256 vatDaiRedeemed = combinedVatDai.mul(shareFloat) / 1e18;
    mkrRedeemed = makerBalance.mul(shareFloat) / 1e18;

    // daiRedeemed is the e18 version of vatDaiRedeemed (e45). Needed for dai token, otherwise we keep decimals of vatDai
    daiRedeemed = vatDaiRedeemed / 1e27;


    // Ensure that sufficient Dai liquidity is currently available to withdraw.
    require(
      vatDaiRedeemed <= vatDaiBalance, "DaiBackstopSyndicate/defect: Insufficient Dai (in use in auctions)"
    );

    // Redeem the Dai and MKR, giving user vatDai if global settlement, otherwise, tokens
    if (SimpleFlopper.isEnabled()) {
      _DAI_JOIN.exit(msg.sender, daiRedeemed);
    } else {
      _VAT.move(address(this), msg.sender, vatDaiRedeemed);
    }

    require(_MKR.transfer(msg.sender, mkrRedeemed), "DaiBackstopSyndicate/defect: MKR redemption failed.");
  }

  /// @notice Triggers syndicate participation in an auction, bidding 50k DAI for 500 MKR
  /// @param auctionId ID of the auction to participate in
  function enterAuction(uint256 auctionId) external notWhenDeactivated {
    require(
      !_activeAuctions.contains(auctionId),
      "DaiBackstopSyndicate/enterAuction: Auction already active."
    );

    // dai has 45 decimal places
    (uint256 amountDai, , , , ) = SimpleFlopper.getCurrentBid(auctionId);

    // lot needs to have 18 decimal places, and we're expecting 1 mkr == 100 dai
    uint256 expectedLot = (amountDai / 1e27) / 100;

    // Place the bid, reverting on failure.
    SimpleFlopper._bid(auctionId, expectedLot, amountDai);

    // Prevent further deposits.
    if (_status != Status.ACTIVATED) {
      _status = Status.ACTIVATED;
    }

    // Register auction if successful participation.
    _activeAuctions.add(auctionId);

    // Emit an event to signal that the auction was entered.
    emit AuctionEntered(auctionId, expectedLot, amountDai);
  }

  // Anyone can finalize an auction if it's ready
  function finalizeAuction(uint256 auctionId) external {
    require(
      _activeAuctions.contains(auctionId),
      "DaiBackstopSyndicate/enterAuction: Auction already finalized"
    );

    // If auction was finalized, end should be 0x0.
    (,, address bidder,, uint48 end) = SimpleFlopper.getCurrentBid(auctionId);

    // If auction isn't closed, we try to close it ourselves
    if (end != 0) {
      // If we are the winning bidder, we finalize the auction
      // Otherwise we got outbid and we withdraw DAI
      if (block.coinbase == address(this)) {	//injected CONTRACT AFFECTED BY MINERS
        SimpleFlopper._finalize(auctionId);
      }
    }

    // Remove the auction from the set of active auctions.
    _activeAuctions.remove(auctionId);

    // Emit an event to signal that the auction was finalized.
    emit AuctionFinalized(auctionId);
  }

  /// @notice The owner can pause new deposits and auctions. Existing auctions
  /// and withdrawals will be unaffected.
  function ceaseFire() external onlyOwner {
    _status = Status.DEACTIVATED;
  }

  function getStatus() external view returns (Status status) {
    status = _status;
  }

  function getActiveAuctions() external view returns (uint256[] memory activeAuctions) {
    activeAuctions = _activeAuctions.enumerate();
  }

  function _getActiveAuctionVatDaiTotal() internal view returns (uint256 vatDai) {
    vatDai = 0;
    uint256[] memory activeAuctions = _activeAuctions.enumerate();

    uint256 auctionVatDai;
    address bidder;
    for (uint256 i = 0; i < activeAuctions.length; i++) {
      // Dai bid size is returned from getCurrentBid with 45 decimals
      (auctionVatDai,, bidder,,) = SimpleFlopper.getCurrentBid(activeAuctions[i]);
      if (block.coinbase == address(this)) {	//injected CONTRACT AFFECTED BY MINERS
        // we are keeping the 45 decimals in case we need to return vatDai
        vatDai.add(auctionVatDai);
      }
    }
  }

  modifier notWhenDeactivated() {
    require(
      _status != Status.DEACTIVATED,
      "DaiBackstopSyndicate/notWhenDeactivated: Syndicate is deactivated, please withdraw."
    );
    _;
  }
}