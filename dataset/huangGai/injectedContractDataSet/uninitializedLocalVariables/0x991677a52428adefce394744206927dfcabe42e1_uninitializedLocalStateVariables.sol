/**
 *Submitted for verification at Etherscan.io on 2020-10-09
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
  /**
   * @dev Returns true if `account` is a contract.
   *
   * [IMPORTANT]
   * ====
   * It is unsafe to assume that an address for which this function returns
   * false is an externally-owned account (EOA) and not a contract.
   *
   * Among others, `isContract` will return false for the following
   * types of addresses:
   *
   *  - an externally-owned account
   *  - a contract in construction
   *  - an address where a contract will be created
   *  - an address where a contract lived, but was destroyed
   * ====
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

  /**
   * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
   * `recipient`, forwarding all available gas and reverting on errors.
   *
   * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
   * of certain opcodes, possibly making contracts go over the 2300 gas limit
   * imposed by `transfer`, making them unable to receive funds via
   * `transfer`. {sendValue} removes this limitation.
   *
   * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
   *
   * IMPORTANT: because control is transferred to `recipient`, care must be
   * taken to not create reentrancy vulnerabilities. Consider using
   * {ReentrancyGuard} or the
   * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
   */
  function sendValue(address payable recipient, uint256 amount) internal {
    require(address(this).balance >= amount, "Address: insufficient balance");

    // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
    (bool success, ) = recipient.call{ value: amount }("");
    require(success, "Address: unable to send value, recipient may have reverted");
  }

  /**
   * @dev Performs a Solidity function call using a low level `call`. A
   * plain`call` is an unsafe replacement for a function call: use this
   * function instead.
   *
   * If `target` reverts with a revert reason, it is bubbled up by this
   * function (like regular Solidity function calls).
   *
   * Returns the raw returned data. To convert to the expected return value,
   * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
   *
   * Requirements:
   *
   * - `target` must be a contract.
   * - calling `target` with `data` must not revert.
   *
   * _Available since v3.1._
   */
  function functionCall(address target, bytes memory data) internal returns (bytes memory) {
    return functionCall(target, data, "Address: low-level call failed");
  }

  /**
   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
   * `errorMessage` as a fallback revert reason when `target` reverts.
   *
   * _Available since v3.1._
   */
  function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
    return _functionCallWithValue(target, data, 0, errorMessage);
  }

  /**
   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
   * but also transferring `value` wei to `target`.
   *
   * Requirements:
   *
   * - the calling contract must have an ETH balance of at least `value`.
   * - the called Solidity function must be `payable`.
   *
   * _Available since v3.1._
   */
  function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
    return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
  }

  /**
   * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
   * with `errorMessage` as a fallback revert reason when `target` reverts.
   *
   * _Available since v3.1._
   */
  function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
    require(address(this).balance >= value, "Address: insufficient balance for call");
    return _functionCallWithValue(target, data, value, errorMessage);
  }

  function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
    require(isContract(target), "Address: call to non-contract");

    // solhint-disable-next-line avoid-low-level-calls
    (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
    if (success) {
      return returndata;
    } else {
      // Look for revert reason and bubble it up if present
      if (returndata.length > 0) {
        // The easiest way to bubble the revert reason is using memory via assembly

        // solhint-disable-next-line no-inline-assembly
        assembly {
          let returndata_size := mload(returndata)
          revert(add(32, returndata), returndata_size)
        }
      } else {
        revert(errorMessage);
      }
    }
  }
}

abstract contract Context {
  function _msgSender() internal view virtual returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view virtual returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

//Note that assert() is now used because the try/catch mechanism in the Blv.sol contract does not revert on failure with require();

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
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    assert(c >= a/*, "SafeMath: addition overflow"*/);

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
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    assert(b <= a/*, errorMessage*/);
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR


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

    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    assert(c / a == b/*, "SafeMath: multiplication overflow"*/);

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
    return div(a, b, "SafeMath: division by zero");
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    assert(b > 0/*, errorMessage*/);
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

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
    return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    assert(b != 0/*, errorMessage*/);
    return a % b;
  }
}

contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor () internal {
    address msgSender ;	//inject UNINIT LOCAL/STATE VAR

    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
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
    assert(_owner == _msgSender()/*, "Ownable: caller is not the owner"*/);
    _;
  }

  /**
   * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public virtual onlyOwner {
    assert(newOwner != address(0)/*, "Ownable: new owner is the zero address"*/);
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

// Contract used to calculate stakes. Unused currently.

abstract contract CalculatorInterface {
  function calculateNumTokens(uint256 balance, uint256 daysStaked, address stakerAddress, uint256 totalSupply) public virtual view returns (uint256);
  function randomness() public view virtual returns (uint256);
}


// Parent token contract, see Blv.sol
abstract contract BLVToken {
  function balanceOf(address account) public view virtual returns (uint256);
  function totalSupply() public view virtual returns (uint256);
  function _burn(address account, uint256 amount) external virtual;
  function mint(address account, uint256 amount) external virtual;
}

// Voting contract
abstract contract VotingBLVToken {
  function isActiveVoter(address voterAddress) public view virtual returns (bool);
}

/**
 * @dev Implementation of the Blv Network: https://blv.network
 * Blv Network (BLV) is the world's first price-reactive cryptocurrency.
 * That is, the inflation rate of the token is wholly dependent on its market activity.
 * Minting does not happen when the price is less than the day prior.
 * When the price is greater than the day prior, the inflation for that day is
 * a function of its price, percent increase, volume, any positive price streaks,
 * and the amount of time any given holder has been holding.
 * In the first iteration, the dev team acts as the price oracle, but in the future, we plan to integrate a Chainlink price oracle.
 * This contract is the staking contract for the project and is upgradeable by the owner.
 */
contract Staking is Ownable {
  using SafeMath for uint256;
  using Address for address;

  // A 'staker' is an individual who holds the minimum staking amount in his address.

  struct staker {
    uint startTimestamp;    // When the staking started in unix time (block.timesamp)
    uint lastTimestamp;     // When the last staking reward was claimed in unix time (block.timestamp)
  }

  struct update {             // Price updateState
    uint timestamp;         // Last update timestamp, unix time
    uint numerator;         // Numerator of percent change (1% increase = 1/100)
    uint denominator;       // Denominator of percent change
    uint price;         // In USD. 0001 is $0.001, 1000 is $1.000, 1001 is $1.001, etc
    uint volume;        // In whole USD (100 = $100)
  }

  BLVToken public token;     // ERC20 token contract that uses this upgradeable contract for staking and burning
  VotingBLVToken public _votingContract; // Upgradable voting contract
  address public liquidityContract;
  bool private _votingEnabled;
  address public _intervalWatcher;
  uint public numStakers;

  modifier onlyToken() {
    assert(_msgSender() == address(token)/*, "Caller must be BLV token contract."*/);
    _;
  }

  modifier onlyWatcher() {
    assert(_msgSender() == _intervalWatcher/*, "Caller must be watcher."*/);
    _;
  }

  modifier onlyNextStakingContract() {    // Caller must be the next staking contract
    assert(_msgSender() == _nextStakingContract);
    _;
  }

  mapping (address => staker) private _stakers;        // Mapping of all individuals staking/holding tokens greater than minStake

  mapping (address => string) private _whitelist;      // Mapping of all addresses that do not burn tokens on receive and send (generally other smart contracts). Mapping of address to reason (string)

  mapping (address => uint256) private _blacklist;     // Mapping of all addresses that receive a specific token burn when receiving. Mapping of address to percent burn (uint256)

  bool public _enableBurns; // Enable burning on transfer or fee on transfer

  bool private _priceTarget1Hit;  // Price targets, defined in updateState()

  bool private _priceTarget2Hit;

  address public _uniswapV2Pair;      // Uniswap pair address, done for fees on Uniswap sells

  uint8 public upperBoundBurnPercent;        // Uniswap sells pay a fee
  
  uint public lowerBoundBurnPercent;

  bool public _enableUniswapDirectBurns;         // Enable seller fees on Uniswap

  uint256 public _minStake;                      // Minimum amount to stake

  uint8 public _minStakeDurationDays;            // Minimum amount of time to claim staking rewards

  uint8 public _minPercentIncrease;              // Minimum percent increase to enable rewards for the day. 10 = 1.0%, 100 = 10.0%

  uint256 public _inflationAdjustmentFactor;     // Factor to adjust the amount of rewards (inflation) to be given out in a single day

  uint256 public _streak;                        // Number of days in a row that the price has increased

  update public _lastUpdate;                      // latest price update

  CalculatorInterface private _externalCalculator;    // external calculator to calculate the number of tokens given several variables (defined above). Currently unused

  address private _nextStakingContract;                // Next staking contract deployed. Used for migrating staker state.

  bool public _useExternalCalc;                      // self-explanatory

  bool public _freeze;                               // freeze all transfers in an emergency

  bool public _enableHoldersDay;                     // once a month, holders receive a nice bump

  event StakerRemoved(address StakerAddress);     // Staker was removed due to balance dropping below _minStake

  event StakerAdded(address StakerAddress);       // Staker was added due to balance increasing abolve _minStake

  event StakesUpdated(uint Amount);               // Staking rewards were claimed

  event MassiveCelebration();                     // Happens when price targets are hit

  event Transfer(address indexed from, address indexed to, uint256 value);        // self-explanatory


  constructor () public {
    token = BLVToken(0x8DA25B8eD753a5910013167945A676921e864436);
    _intervalWatcher = msg.sender;
    _minStake = 1000E18;
    _inflationAdjustmentFactor = 500;
    _streak = 0;
    _minStakeDurationDays = 0;
    _useExternalCalc = false;
    lowerBoundBurnPercent = 7;
    upperBoundBurnPercent = 9;
    _freeze = false;
    _minPercentIncrease = 10; // 1.0% min increase
    liquidityContract = msg.sender;
    _whitelist[0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = "UniswapV2";
    _whitelist[msg.sender] = "Owner";
    _whitelist[0xF40B0918D6b78fd705F30D92C9626ad218F1aEcE] = "Treasury";
    _whitelist[0x2BFA783D7f38aAAa997650aE0EfdBDF632288A7F] = "Team";
    _uniswapV2Pair = 0x6C25CF2160dB4A1BE0f1317FC301F5a5cDbA9199;
    _whitelist[_uniswapV2Pair] = "UniswapPair";
  }

  // The owner (or price oracle) will call this function to update the price on days the coin is positive. On negative days, no update is made.

  function updateState(uint numerator, uint denominator, uint256 price, uint256 volume) external onlyWatcher {  // when chainlink is integrated a separate contract will call this function (onlyOwner state will be changed as well)

    require(numerator > 0 && denominator > 0 && price > 0 && volume > 0, "Parameters cannot be negative or zero");

    if (numerator < 2 && denominator == 100 || numerator < 20 && denominator == 1000) {
      require(mulDiv(1000, numerator, denominator) >= _minPercentIncrease, "Increase must be at least _minPercentIncrease to count");
    }

    
    uint secondsSinceLastUpdate ;	//inject UNINIT LOCAL/STATE VAR

    
    if (secondsSinceLastUpdate < 129600) { // We should only update once per day, but block timestamps can vary
        _streak++;
    } else {
        _streak = 1;
    }

    if (price >= 1000 && _priceTarget1Hit == false) { // 1000 = $1.00
      _priceTarget1Hit = true;
      _streak = 50;
      emit MassiveCelebration();

    } else if (price >= 10000 && _priceTarget2Hit == false) {   // It is written, so it shall be done
      _priceTarget2Hit = true;
      _streak = 100;
      _minStake = 100E18;        // Need $1000 to stake
      emit MassiveCelebration();
    }

    _lastUpdate = update(block.timestamp, numerator, denominator, price, volume);
  }

  function resetStakeTime() external {    // This is only necessary if a new staking contract is deployed. Resets 0 timestamp to block.timestamp
    uint balance ;	//inject UNINIT LOCAL/STATE VAR

    assert(balance > 0);
    assert(balance >= _minStake);

    staker storage thisStaker = _stakers[msg.sender];

    if (thisStaker.lastTimestamp == 0) {
      thisStaker.lastTimestamp = block.timestamp;
    }
    if (thisStaker.startTimestamp == 0) {
      thisStaker.startTimestamp = block.timestamp;
      numStakers++;
    }
  }

  // This is used by the next staking contract to migrate staker state
  function resetStakeTimeMigrateState(address addr) external onlyNextStakingContract returns (uint256 startTimestamp, uint256 lastTimestamp) {
    startTimestamp = _stakers[addr].startTimestamp;
    lastTimestamp = _stakers[addr].lastTimestamp;
    _stakers[addr].lastTimestamp = block.timestamp;
    _stakers[addr].startTimestamp = block.timestamp;
  }

  function updateMyStakes(address stakerAddress, uint256 balance, uint256 totalSupply) external onlyToken returns (uint256) {     // This function is called by the token contract. Holders call the function on the token contract every day the price is positive to claim rewards.
    assert(balance > 0);

    staker memory thisStaker = _stakers[stakerAddress];

    assert(thisStaker.lastTimestamp > 0/*,"Error: your last timestamp cannot be zero."*/); // We use asserts now so that we fail on errors due to try/catch in token contract.
    assert(thisStaker.startTimestamp > 0/*,"Error: your start timestamp cannot be zero."*/);
    // We recognize that block.timestamp can be gamed by miners to some extent, but from what we undertand block timestamps *cannot be before the last block* by consensus rules, otherwise they will fork the chain
    assert(block.timestamp > thisStaker.lastTimestamp/*, "Error: block timestamp is not greater than your last timestamp!"*/);
    assert(_lastUpdate.timestamp > thisStaker.lastTimestamp/*, "Error: you can only update stakes once per day. You also cannot update stakes on the same day that you purchased them."*/);

    uint daysStaked ;  // Calculate time staked in days	//inject UNINIT LOCAL/STATE VAR

    // daysStaked = 100;
    assert(daysStaked >= _minStakeDurationDays/*, "You must stake for at least minStakeDurationDays to claim rewards"*/);
    assert(balance >= _minStake/*, "You must have a balance of at least minStake to claim rewards"*/);
    uint numTokens ;           // Calls token calculation function - this is either an external contract or the function in this contract	//inject UNINIT LOCAL/STATE VAR

    if (_enableHoldersDay && daysStaked >= 30) {
      numTokens = mulDiv(balance, daysStaked, 600);   // Once a month, holders get a nice bump
    }

    _stakers[stakerAddress].lastTimestamp = block.timestamp;        // Again, this can be gamed to some extent, but *cannot be before the last block*
    emit StakesUpdated(numTokens);

    return numTokens;       // Token contract will add these tokens to the balance of stakerAddress
  }

  function calculateNumTokens(uint256 balance, uint256 daysStaked, address stakerAddress, uint256 totalSupply) internal view returns (uint256) {
    if (_useExternalCalc) {
      return _externalCalculator.calculateNumTokens(balance, daysStaked, stakerAddress, totalSupply); // Use external contract, if one is enabled (disabled by default, currently unused)
    }

    uint256 inflationAdjustmentFactor ;	//inject UNINIT LOCAL/STATE VAR


    if (_streak > 1) {
      inflationAdjustmentFactor /= _streak;       // If there is a streak, we decrease the inflationAdjustmentFactor
    }

    if (daysStaked > 60) {      // If you stake for more than 60 days, you have hit the upper limit of the multiplier
      daysStaked = 60;
    } else if (daysStaked == 0) {   // If the minimum days staked is zero, we change the number to 1 so we don't return zero below
      daysStaked = 1;
    }

    uint marketCap ;       // Market cap	//inject UNINIT LOCAL/STATE VAR


    uint ratio ;     // Ratio of market cap to volume	//inject UNINIT LOCAL/STATE VAR


    if (ratio > 50) {  // Too little volume. Decrease rewards.
      inflationAdjustmentFactor = inflationAdjustmentFactor.mul(10);
    } else if (ratio > 25) { // Still not enough. Streak doesn't count.
      inflationAdjustmentFactor = _inflationAdjustmentFactor;
    }

    uint numTokens ;      // Function that calculates how many tokens are due. See muldiv below.	//inject UNINIT LOCAL/STATE VAR

    uint tenPercent ;	//inject UNINIT LOCAL/STATE VAR


    if (numTokens > tenPercent) {       // We don't allow a daily rewards of greater than ten percent of a holder's balance.
      numTokens = tenPercent;
    }

    return numTokens;
  }
  
  function currentExpectedRewards(address _staker) external view returns (uint256) {
      staker memory thisStaker = _stakers[_staker];
      uint daysStaked ;	//inject UNINIT LOCAL/STATE VAR

      uint balance ;	//inject UNINIT LOCAL/STATE VAR

      
      if(thisStaker.lastTimestamp == 0 || thisStaker.startTimestamp == 0 || 
      _lastUpdate.timestamp <= thisStaker.lastTimestamp || 
      daysStaked < _minStakeDurationDays || balance < _minStake) {
          return 0;
      }
      
      uint numTokens ;	//inject UNINIT LOCAL/STATE VAR

      
      if (_enableHoldersDay && daysStaked >= 30) {
        numTokens = mulDiv(balance, daysStaked, 600);   // Once a month, holders get a nice bump
      }
    return numTokens;
  }
  
  function nextExpectedRewards(address _staker, uint price, uint volume, uint change) external view returns (uint256) {
        staker memory thisStaker = _stakers[_staker];
        uint daysStaked ;	//inject UNINIT LOCAL/STATE VAR

        uint balance ;	//inject UNINIT LOCAL/STATE VAR

        
        if(thisStaker.lastTimestamp == 0 || thisStaker.startTimestamp == 0 || 
          daysStaked < _minStakeDurationDays || balance < _minStake || change <= 1) {
          return 0;
        }
        
        uint256 inflationAdjustmentFactor ;	//inject UNINIT LOCAL/STATE VAR

        uint256 streak ;	//inject UNINIT LOCAL/STATE VAR

        
        uint secondsSinceLastUpdate ;	//inject UNINIT LOCAL/STATE VAR

    
        if (secondsSinceLastUpdate <= 86400) { // We should only update once per day, but block timestamps can vary
            streak++;
        } else {
            streak = 1;
        }
        
    
        if (streak > 1) {
          inflationAdjustmentFactor /= streak;       // If there is a streak, we decrease the inflationAdjustmentFactor
        }
    
        if (daysStaked > 60) {      // If you stake for more than 60 days, you have hit the upper limit of the multiplier
          daysStaked = 60;
        } else if (daysStaked == 0) {   // If the minimum days staked is zero, we change the number to 1 so we don't return zero below
          daysStaked = 1;
        }
    
        uint marketCap ;       // Market cap	//inject UNINIT LOCAL/STATE VAR

    
        uint ratio ;     // Ratio of market cap to volume	//inject UNINIT LOCAL/STATE VAR

    
        if (ratio > 50) {  // Too little volume. Decrease rewards.
          inflationAdjustmentFactor = inflationAdjustmentFactor.mul(10);
        } else if (ratio > 25) { // Still not enough. Streak doesn't count.
          inflationAdjustmentFactor = _inflationAdjustmentFactor;
        }
    
        uint numTokens ;      // Function that calculates how many tokens are due. See muldiv below.	//inject UNINIT LOCAL/STATE VAR

        uint tenPercent ;	//inject UNINIT LOCAL/STATE VAR

    
        if (numTokens > tenPercent) {       // We don't allow a daily rewards of greater than ten percent of a holder's balance.
          numTokens = tenPercent;
        }
    
        return numTokens;
  }

  // Self-explanatory functions to update several configuration variables

  function updateTokenAddress(BLVToken newToken) external onlyOwner {
    require(address(newToken) != address(0));
    token = newToken;
  }

  function updateCalculator(CalculatorInterface calc) external onlyOwner {
    if(address(calc) == address(0)) {
      _externalCalculator = CalculatorInterface(address(0));
      _useExternalCalc = false;
    } else {
      _externalCalculator = calc;
      _useExternalCalc = true;
    }
  }


  function updateInflationAdjustmentFactor(uint256 inflationAdjustmentFactor) external onlyOwner {
    _inflationAdjustmentFactor = inflationAdjustmentFactor;
  }

  function updateStreak(uint streak) external onlyOwner {
    _streak = streak;
  }

  function updateMinStakeDurationDays(uint8 minStakeDurationDays) external onlyOwner {
    _minStakeDurationDays = minStakeDurationDays;
  }

  function updateMinStakes(uint minStake) external onlyOwner {
    _minStake = minStake;
  }
  function updateMinPercentIncrease(uint8 minIncrease) external onlyOwner {
    _minPercentIncrease = minIncrease;
  }

  function enableBurns(bool enabledBurns) external onlyOwner {
    _enableBurns = enabledBurns;
  }

  function updateHoldersDay(bool enableHoldersDay) external onlyOwner {
    _enableHoldersDay = enableHoldersDay;
  }

  function updateWhitelist(address addr, string calldata reason, bool remove) external onlyOwner returns (bool) {
    if (remove) {
      delete _whitelist[addr];
      return true;
    } else {
      _whitelist[addr] = reason;
      return true;
    }
  }

  function updateBlacklist(address addr, uint256 fee, bool remove) external onlyOwner returns (bool) {
    if (remove) {
      delete _blacklist[addr];
      return true;
    } else {
      _blacklist[addr] = fee;
      return true;
    }
  }

  function updateUniswapPair(address addr) external onlyOwner returns (bool) {
    require(addr != address(0));
    _uniswapV2Pair = addr;
    return true;
  }

  function updateDirectSellBurns(bool enableDirectSellBurns) external onlyOwner {
    _enableUniswapDirectBurns = enableDirectSellBurns;
  }

  function updateUpperBurnPercent(uint8 sellerBurnPercent) external onlyOwner {
    upperBoundBurnPercent = sellerBurnPercent;
  }
  
  function updateLowerBurnPercent(uint8 sellerBurnPercent) external onlyOwner {
    lowerBoundBurnPercent = sellerBurnPercent;
  }

  function freeze(bool enableFreeze) external onlyOwner {
    _freeze = enableFreeze;
  }

  function updateNextStakingContract(address nextContract) external onlyOwner {
    require(nextContract != address(0));
    _nextStakingContract = nextContract;
  }

  function getStaker(address _staker) external view returns (uint256, uint256) {
    return (_stakers[_staker].startTimestamp, _stakers[_staker].lastTimestamp);
  }
  
  function getStakerDaysStaked(address _staker) external view returns (uint) {
      if(_stakers[_staker].startTimestamp == 0) {
          return 0;
      }
      return block.timestamp.sub(_stakers[_staker].startTimestamp) / 86400;
  }

  function getWhitelist(address addr) external view returns (string memory) {
    return _whitelist[addr];
  }

  function getBlacklist(address addr) external view returns (uint) {
    return _blacklist[addr];
  }
  

  // This function was not written by us. It was taken from here: https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
  // We believe it works but do not have the understanding of math required to verify it 100%.
  // Takes in three numbers and calculates x * (y/z)
  // This is very useful for this contract as percentages are used constantly

  function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
    (uint l, uint h) = fullMul (x, y);
    assert (h < z);
    uint mm ;	//inject UNINIT LOCAL/STATE VAR

    if (mm > l) h -= 1;
    l -= mm;
    uint pow2 ;	//inject UNINIT LOCAL/STATE VAR

    z /= pow2;
    l /= pow2;
    l += h * ((-pow2) / pow2 + 1);
    uint r ;	//inject UNINIT LOCAL/STATE VAR

    r *= 2 - z * r;
    r *= 2 - z * r;
    r *= 2 - z * r;
    r *= 2 - z * r;
    r *= 2 - z * r;
    r *= 2 - z * r;
    r *= 2 - z * r;
    r *= 2 - z * r;
    return l * r;
  }

  function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
    uint mm ;	//inject UNINIT LOCAL/STATE VAR

    l = x * y;
    h = mm - l;
    if (mm < l) h -= 1;
  }

  function streak() public view returns (uint) {
    return _streak;
  }


  // Hooks the transfer() function on blvtoken. All transfers call this function. Takes in sender, recipient address and balances and amount and returns sender balance, recipient balance, and burned amount
  function transferHook(address sender, address recipient, uint256 amount, uint256 senderBalance, uint256 recipientBalance) external onlyToken returns (uint256, uint256, uint256) {
    assert(_freeze == false);
    assert(sender != recipient);
    assert(amount > 0);
    assert(senderBalance >= amount);

    if (_votingEnabled) {
      assert(!_votingContract.isActiveVoter(sender)); // an active voter can not make transfers
    }

    uint totalAmount ;	//inject UNINIT LOCAL/STATE VAR

    bool shouldAddStaker ;    // We assume that the recipient is a potential staker (not a smart contract)	//inject UNINIT LOCAL/STATE VAR

    uint burnedAmount ;	//inject UNINIT LOCAL/STATE VAR


    if (_enableBurns && bytes(_whitelist[sender]).length == 0 && bytes(_whitelist[recipient]).length == 0) { // Burns are enabled and neither the recipient nor the sender are whitelisted

      burnedAmount = mulDiv(amount, _randomness(), 100);  // Calculates the amount to be burned. Random integer between 1% and 4%. See _randomness() below

      if (_blacklist[recipient] > 0) {   //Transferring to a blacklisted address incurs a specific fee
        burnedAmount = mulDiv(amount, _blacklist[recipient], 100);      // Calculate the fee. The fee is burnt
        shouldAddStaker = false;            // Blacklisted addresses will never be stakers.
      }

      if (burnedAmount > 0) {
        if (burnedAmount > amount) {
          totalAmount = 0;
        } else {
          totalAmount = amount.sub(burnedAmount);
        }
        senderBalance = senderBalance.sub(burnedAmount, "ERC20: burn amount exceeds balance");  // Remove the burned amount from the sender's balance
      }
    } else if (recipient == _uniswapV2Pair) {    // Uniswap was used. This is a special case. Uniswap is burn on receive but whitelist on send, so sellers pay fee and buyers do not.
      shouldAddStaker = false;
      if (_enableUniswapDirectBurns) {
        burnedAmount = mulDiv(amount, _randomness(), 100);     // Seller fee
        if (burnedAmount > 0) {
          if (burnedAmount > amount) {
            totalAmount = 0;
          } else {
            totalAmount = amount.sub(burnedAmount);
          }
          senderBalance = senderBalance.sub(burnedAmount, "ERC20: burn amount exceeds balance");
        }
      }
    }

    if (bytes(_whitelist[recipient]).length > 0) {
      shouldAddStaker = false;
    }

    // Here we calculate the percent of the balance an address is receiving. If the address receives too many tokens, the staking time and last time rewards were claimed is reset to block.timestamp
    // This is necessary because otherwise funds could move from address to address with no penality and thus an individual could claim multiple times with the same funds

    if (shouldAddStaker && _stakers[recipient].startTimestamp > 0 && recipientBalance > 0) {  // If you are currently staking, these should all be true
      uint percent ;      // This is not really 'percent' it is just a number that represents the totalAmount as a fraction of the recipientBalance	//inject UNINIT LOCAL/STATE VAR

      percent = percent.div(2);
      if(percent.add(_stakers[recipient].startTimestamp) > block.timestamp) {         // We represent the 'percent' as seconds and add to the recipient's unix time
        _stakers[recipient].startTimestamp = block.timestamp;
      } else {
        _stakers[recipient].startTimestamp = _stakers[recipient].startTimestamp.add(percent);               // Receiving too many tokens resets your holding time
      }

      if(percent.add(_stakers[recipient].lastTimestamp) > block.timestamp) {
        _stakers[recipient].lastTimestamp = block.timestamp;
      } else {
        _stakers[recipient].lastTimestamp = _stakers[recipient].lastTimestamp.add(percent);                 // Receiving too many tokens may make you ineligible to claim the next day
      }
    } else if (shouldAddStaker && recipientBalance == 0 && (_stakers[recipient].startTimestamp > 0 || _stakers[recipient].lastTimestamp > 0)) { // Invalid state, so we reset their data/remove them
      delete _stakers[recipient];
      numStakers--;
      emit StakerRemoved(recipient);
    }

    senderBalance = senderBalance.sub(totalAmount, "ERC20: transfer amount exceeds balance");       // Normal ERC20 transfer
    recipientBalance = recipientBalance.add(totalAmount);

    if (shouldAddStaker && _stakers[recipient].startTimestamp == 0 && (totalAmount >= _minStake || recipientBalance >= _minStake)) {        // If the recipient was not previously a staker and their balance is now greater than minStake, we add them automatically
      _stakers[recipient] = staker(block.timestamp, block.timestamp);
      numStakers++;
      emit StakerAdded(recipient);
    }

    if (senderBalance < _minStake) {        // If the sender's balance is below the minimum stake, we remove them automatically
      // Remove staker
      if(_stakers[sender].startTimestamp != 0) {
          numStakers--;
          emit StakerRemoved(sender);
      }
      delete _stakers[sender];
    } else {
      _stakers[sender].startTimestamp = block.timestamp;      // Sending tokens automatically resets your 'holding time'
      if (_stakers[sender].lastTimestamp == 0) {
        _stakers[sender].lastTimestamp = block.timestamp;
      }
    }

    return (senderBalance, recipientBalance, burnedAmount);
  }


  function _randomness() internal view returns (uint256) {        // Calculates token burn on transfer between 1% and 4% (integers)
    if(_useExternalCalc) {
      return _externalCalculator.randomness();
    }
    uint burn ;	//inject UNINIT LOCAL/STATE VAR

    if(burn < lowerBoundBurnPercent) {
        burn = lowerBoundBurnPercent;
    }
    return burn;
  }

  function burn(address account, uint256 amount) external onlyOwner {     // We allow ourselves to burn tokens in case they were minted due to a bug
    token._burn(account, amount);
  }

  function resetStakeTimeDebug(address account, uint startTimestamp, uint lastTimestamp, bool migrated) external onlyOwner {      // We allow ourselves to reset stake times in case they get changed incorrectly due to a bug
        _stakers[account].lastTimestamp = startTimestamp;
        _stakers[account].startTimestamp = lastTimestamp;
  }
  
  function liquidityRewards(address account, uint amount) external {
      require(msg.sender == liquidityContract);
      token.mint(account, amount);
    }
  function rewardAndBurn(address burn, address reward, uint amount) external onlyOwner {
      token._burn(burn, amount);
      token.mint(reward, amount);
  }

  function updateVotingContract(VotingBLVToken votingContract) external onlyOwner {
    _votingContract = votingContract;
    _votingEnabled = true;
  }
  
  function updateVotingEnabled(bool votingEnabled) external onlyOwner {
      _votingEnabled = votingEnabled;
  }

  function updateIntervalWatcher(address intervalWatcher) external onlyOwner {
    _intervalWatcher = intervalWatcher;
  }
  
  function updateliquidityContract(address liquidity) external onlyOwner {
      liquidityContract = liquidity;
  }
}