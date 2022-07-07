/**
 *Submitted for verification at Etherscan.io on 2020-02-02
*/

// File: contracts/interfaces/CERC20.sol

pragma solidity ^0.5.11;	//inject UNLIMITED COMPILER VERSIONS

interface CERC20 {
  function mint(uint256 mintAmount) external returns (uint256);
  function redeem(uint256 redeemTokens) external returns (uint256);
  function exchangeRateStored() external view returns (uint256);
  function supplyRatePerBlock() external view returns (uint256);

  function borrowRatePerBlock() external view returns (uint256);
  function totalReserves() external view returns (uint256);
  function getCash() external view returns (uint256);
  function totalBorrows() external view returns (uint256);
  function reserveFactorMantissa() external view returns (uint256);
  function interestRateModel() external view returns (address);
}

// File: contracts/interfaces/iERC20Fulcrum.sol

pragma solidity ^0.5.11;	//inject UNLIMITED COMPILER VERSIONS

interface iERC20Fulcrum {
  function mint(
    address receiver,
    uint256 depositAmount)
    external
    returns (uint256 mintAmount);

  function burn(
    address receiver,
    uint256 burnAmount)
    external
    returns (uint256 loanAmountPaid);

  function tokenPrice()
    external
    view
    returns (uint256 price);

  function supplyInterestRate()
    external
    view
    returns (uint256);

  function rateMultiplier()
    external
    view
    returns (uint256);
  function baseRate()
    external
    view
    returns (uint256);

  function borrowInterestRate()
    external
    view
    returns (uint256);

  function avgBorrowInterestRate()
    external
    view
    returns (uint256);

  function protocolInterestRate()
    external
    view
    returns (uint256);

  function spreadMultiplier()
    external
    view
    returns (uint256);

  function totalAssetBorrow()
    external
    view
    returns (uint256);

  function totalAssetSupply()
    external
    view
    returns (uint256);

  function nextSupplyInterestRate(uint256)
    external
    view
    returns (uint256);

  function nextBorrowInterestRate(uint256)
    external
    view
    returns (uint256);
  function nextLoanInterestRate(uint256)
    external
    view
    returns (uint256);

  function claimLoanToken()
    external
    returns (uint256 claimedAmount);

  function dsr()
    external
    view
    returns (uint256);

  function chaiPrice()
    external
    view
    returns (uint256);
}

// File: contracts/interfaces/ILendingProtocol.sol

pragma solidity ^0.5.11;	//inject UNLIMITED COMPILER VERSIONS

interface ILendingProtocol {
  function mint() external returns (uint256);
  function redeem(address account) external returns (uint256);
  function nextSupplyRate(uint256 amount) external view returns (uint256);
  function nextSupplyRateWithParams(uint256[] calldata params) external view returns (uint256);
  function getAPR() external view returns (uint256);
  function getPriceInToken() external view returns (uint256);
  function token() external view returns (address);
  function underlying() external view returns (address);
}

// File: contracts/interfaces/WhitePaperInterestRateModel.sol

pragma solidity ^0.5.11;	//inject UNLIMITED COMPILER VERSIONS

interface WhitePaperInterestRateModel {
  function getBorrowRate(uint256 cash, uint256 borrows, uint256 _reserves) external view returns (uint256, uint256);
  function getSupplyRate(uint256 cash, uint256 borrows, uint256 reserves, uint256 reserveFactorMantissa) external view returns (uint256);
  function multiplier() external view returns (uint256);
  function baseRate() external view returns (uint256);
  function blocksPerYear() external view returns (uint256);
  function dsrPerBlock() external view returns (uint256);
}

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.5.11;	//inject UNLIMITED COMPILER VERSIONS

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/ownership/Ownable.sol

pragma solidity ^0.5.11;	//inject UNLIMITED COMPILER VERSIONS

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = _msgSender();
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
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
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

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.11;	//inject UNLIMITED COMPILER VERSIONS

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
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
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.5.11;	//inject UNLIMITED COMPILER VERSIONS

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
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
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
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
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
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/IdleRebalancer.sol

/**
 * @title: Idle Rebalancer contract
 * @summary: Used for calculating amounts to lend on each implemented protocol.
 *           This implementation works with Compound and Fulcrum only,
 *           when a new protocol will be added this should be replaced
 * @author: William Bergamo, idle.finance
 */
pragma solidity ^0.5.11;	//inject UNLIMITED COMPILER VERSIONS








contract IdleRebalancer is Ownable {
  using SafeMath for uint256;
  // IdleToken address
  address public idleToken;
  // protocol token (cToken) address
  address public cToken;
  // protocol token (iToken) address
  address public iToken;
  // cToken protocol wrapper IdleCompound
  address public cWrapper;
  // iToken protocol wrapper IdleFulcrum
  address public iWrapper;
  // max % difference between next supply rate of Fulcrum and Compound
  uint256 public maxRateDifference; // 10**17 -> 0.1 %
  // max % difference between off-chain user supplied params for rebalance and actual amount to be rebalanced
  uint256 public maxSupplyedParamsDifference; // 100000 -> 0.001%
  // max number of recursive calls for bisection algorithm
  uint256 public maxIterations;

  /**
   * @param _cToken : cToken address
   * @param _iToken : iToken address
   * @param _cWrapper : cWrapper address
   * @param _iWrapper : iWrapper address
   */
  constructor(address _cToken, address _iToken, address _cWrapper, address _iWrapper) public {
    require(_cToken != address(0) && _iToken != address(0) && _cWrapper != address(0) && _iWrapper != address(0), 'some addr is 0');

    cToken = _cToken;
    iToken = _iToken;
    cWrapper = _cWrapper;
    iWrapper = _iWrapper;
    maxRateDifference = 10**17; // 0.1%
    maxSupplyedParamsDifference = 100000; // 0.001%
    maxIterations = 30;
  }

  /**
   * Throws if called by any account other than IdleToken contract.
   */
  modifier onlyIdle() {
    require(msg.sender == idleToken, "Ownable: caller is not IdleToken contract");
    _;
  }

  // onlyOwner
  /**
   * sets idleToken address
   * NOTE: can be called only once. It's not on the constructor because we are deploying this contract
   *       after the IdleToken contract
   * @param _idleToken : idleToken address
   */
  function setIdleToken(address _idleToken)
    external onlyOwner {
      require(idleToken == address(0), "idleToken addr already set");
      require(_idleToken != address(0), "_idleToken addr is 0");
      idleToken = _idleToken;
  }

  /**
   * sets maxIterations for bisection recursive calls
   * @param _maxIterations : max number of iterations for the bisection algorithm
   */
  function setMaxIterations(uint256 _maxIterations)
    external onlyOwner {
      maxIterations = _maxIterations;
  }

  /**
   * sets maxRateDifference
   * @param _maxDifference : max rate difference in percentage scaled by 10**18
   */
  function setMaxRateDifference(uint256 _maxDifference)
    external onlyOwner {
      maxRateDifference = _maxDifference;
  }

  /**
   * sets maxSupplyedParamsDifference
   * @param _maxSupplyedParamsDifference : max slippage between the rebalance params given from the client
   *                                       and actual amount to be rebalanced
   */
  function setMaxSupplyedParamsDifference(uint256 _maxSupplyedParamsDifference)
    external onlyOwner {
      maxSupplyedParamsDifference = _maxSupplyedParamsDifference;
  }
  // end onlyOwner

  /**
   * Used by IdleToken contract to calculate the amount to be lended
   * on each protocol in order to get the best available rate for all funds.
   *
   * @param _rebalanceParams : first param is the total amount to be rebalanced,
   *                           all other elements are client side calculated amounts to put on each lending protocol
   * @return tokenAddresses : array with all token addresses used,
   *                          currently [cTokenAddress, iTokenAddress]
   * @return amounts : array with all amounts for each protocol in order,
   *                   currently [amountCompound, amountFulcrum]
   */
  function calcRebalanceAmounts(uint256[] calldata _rebalanceParams)
    external view onlyIdle
    returns (address[] memory tokenAddresses, uint256[] memory amounts)
  {
    // Get all params for calculating Compound nextSupplyRateWithParams
    CERC20 _cToken = CERC20(cToken);
    WhitePaperInterestRateModel white = WhitePaperInterestRateModel(_cToken.interestRateModel());
    uint256[] memory paramsCompound = new uint256[](10);
    paramsCompound[0] = 10**18; // j
    paramsCompound[1] = white.baseRate(); // a
    paramsCompound[2] = _cToken.totalBorrows(); // b
    paramsCompound[3] = white.multiplier(); // c
    paramsCompound[4] = _cToken.totalReserves(); // d
    paramsCompound[5] = paramsCompound[0].sub(_cToken.reserveFactorMantissa()); // e
    paramsCompound[6] = _cToken.getCash(); // s
    paramsCompound[7] = white.blocksPerYear(); // k
    paramsCompound[8] = 100; // f

    // Get all params for calculating Fulcrum nextSupplyRateWithParams
    iERC20Fulcrum _iToken = iERC20Fulcrum(iToken);
    uint256[] memory paramsFulcrum = new uint256[](4);
    paramsFulcrum[0] = _iToken.protocolInterestRate(); // a1
    paramsFulcrum[1] = _iToken.totalAssetBorrow(); // b1
    paramsFulcrum[2] = _iToken.totalAssetSupply(); // s1

    tokenAddresses = new address[](2);
    tokenAddresses[0] = cToken;
    tokenAddresses[1] = iToken;

    // _rebalanceParams should be [totAmountToRebalance, amountCompound, amountFulcrum];
    if (_rebalanceParams.length == 3) {
      (bool amountsAreCorrect, uint256[] memory checkedAmounts) = checkRebalanceAmounts(_rebalanceParams, paramsCompound, paramsFulcrum);
      if (amountsAreCorrect) {
        return (tokenAddresses, checkedAmounts);
      }
    }

    // Initial guess for shrinking initial bisection interval
    /*
      Compound: (getCash returns the available supply only, not the borrowed one)
      getCash + totalBorrows = totalSuppliedCompound

      Fulcrum:
      totalSupply = totalSuppliedFulcrum

      we try to correlate borrow and supply on both markets
      totC = totalSuppliedCompound + totalBorrowsCompound
      totF = totalSuppliedFulcrum + totalBorrowsFulcrum

      n : (totC + totF) = x : totF
      x = n * totF / (totC + totF)
    */

    uint256 amountFulcrum = _rebalanceParams[0].mul(paramsFulcrum[2].add(paramsFulcrum[1])).div(
      paramsFulcrum[2].add(paramsFulcrum[1]).add(paramsCompound[6].add(paramsCompound[2]).add(paramsCompound[2]))
    );

    // Recursive bisection algorithm
    amounts = bisectionRec(
      _rebalanceParams[0].sub(amountFulcrum), // amountCompound
      amountFulcrum,
      maxRateDifference, // 0.1% of rate difference,
      0, // currIter
      maxIterations, // maxIter
      _rebalanceParams[0],
      paramsCompound,
      paramsFulcrum
    ); // returns [amountCompound, amountFulcrum]

    return (tokenAddresses, amounts);
  }
  /**
   * Used by IdleToken contract to check if provided amounts
   * causes the rates of Fulcrum and Compound to be balanced
   * (counting a tolerance)
   *
   * @param rebalanceParams : first element is the total amount to be rebalanced,
   *                   the rest is an array with all amounts for each protocol in order,
   *                   currently [amountCompound, amountFulcrum]
   * @param paramsCompound : array with all params (except for the newDAIAmount)
   *                          for calculating next supply rate of Compound
   * @param paramsFulcrum : array with all params (except for the newDAIAmount)
   *                          for calculating next supply rate of Fulcrum
   * @return bool : if provided amount correctly rebalances the pool
   */
  function checkRebalanceAmounts(
    uint256[] memory rebalanceParams,
    uint256[] memory paramsCompound,
    uint256[] memory paramsFulcrum
  )
    internal view
    returns (bool, uint256[] memory checkedAmounts)
  {
    // This is the amount that should be rebalanced no more no less
    uint256 actualAmountToBeRebalanced = rebalanceParams[0]; // n
    // interest is earned between when tx was submitted and when it is mined so params sent by users
    // should always be slightly less than what should be rebalanced
    uint256 totAmountSentByUser;
    for (uint8 i = 1; i < rebalanceParams.length; i++) {
      totAmountSentByUser = totAmountSentByUser.add(rebalanceParams[i]);
    }

    // check if amounts sent from user are less than actualAmountToBeRebalanced and
    // at most `actualAmountToBeRebalanced - 0.001% of (actualAmountToBeRebalanced)`
    if (totAmountSentByUser > actualAmountToBeRebalanced ||
        totAmountSentByUser.add(totAmountSentByUser.div(maxSupplyedParamsDifference)) < actualAmountToBeRebalanced) {
      return (false, new uint256[](2));
    }

    uint256 interestToBeSplitted = actualAmountToBeRebalanced.sub(totAmountSentByUser);

    // sets newDAIAmount for each protocol
    paramsCompound[9] = rebalanceParams[1].add(interestToBeSplitted.div(2));
    paramsFulcrum[3] = rebalanceParams[2].add(interestToBeSplitted.sub(interestToBeSplitted.div(2)));

    // calculate next rates with amountCompound and amountFulcrum

    // For Fulcrum see https://github.com/bZxNetwork/bZx-monorepo/blob/development/packages/contracts/extensions/loanTokenization/contracts/LoanToken/LoanTokenLogicV3.sol#L1418
    // fulcrumUtilRate = fulcrumBorrow.mul(10**20).div(assetSupply);
    uint256 currFulcRate = (paramsFulcrum[1].mul(10**20).div(paramsFulcrum[2])) > 90 ether ?
      ILendingProtocol(iWrapper).nextSupplyRate(paramsFulcrum[3]) :
      ILendingProtocol(iWrapper).nextSupplyRateWithParams(paramsFulcrum);
    uint256 currCompRate = ILendingProtocol(cWrapper).nextSupplyRateWithParams(paramsCompound);
    bool isCompoundBest = currCompRate > currFulcRate;
    // |fulcrumRate - compoundRate| <= tolerance
    bool areParamsOk = (currFulcRate.add(maxRateDifference) >= currCompRate && isCompoundBest) ||
      (currCompRate.add(maxRateDifference) >= currFulcRate && !isCompoundBest);

    uint256[] memory actualParams = new uint256[](2);
    actualParams[0] = paramsCompound[9];
    actualParams[1] = paramsFulcrum[3];

    return (areParamsOk, actualParams);
  }

  /**
   * Internal implementation of our bisection algorithm
   *
   * @param amountCompound : amount to be lended in compound in current iteration
   * @param amountFulcrum : amount to be lended in Fulcrum in current iteration
   * @param tolerance : max % difference between next supply rate of Fulcrum and Compound
   * @param currIter : current iteration
   * @param maxIter : max number of iterations
   * @param n : amount of underlying tokens (eg. DAI) to rebalance
   * @param paramsCompound : array with all params (except for the newDAIAmount)
   *                          for calculating next supply rate of Compound
   * @param paramsFulcrum : array with all params (except for the newDAIAmount)
   *                          for calculating next supply rate of Fulcrum
   * @return amounts : array with all amounts for each protocol in order,
   *                   currently [amountCompound, amountFulcrum]
   */
  function bisectionRec(
    uint256 amountCompound, uint256 amountFulcrum,
    uint256 tolerance, uint256 currIter, uint256 maxIter, uint256 n,
    uint256[] memory paramsCompound,
    uint256[] memory paramsFulcrum
  )
    internal view
    returns (uint256[] memory amounts) {

    // sets newDAIAmount for each protocol
    paramsCompound[9] = amountCompound;
    paramsFulcrum[3] = amountFulcrum;

    // calculate next rates with amountCompound and amountFulcrum

    // For Fulcrum see https://github.com/bZxNetwork/bZx-monorepo/blob/development/packages/contracts/extensions/loanTokenization/contracts/LoanToken/LoanTokenLogicV3.sol#L1418
    // fulcrumUtilRate = fulcrumBorrow.mul(10**20).div(assetSupply);
    uint256 currFulcRate = (paramsFulcrum[1].mul(10**20).div(paramsFulcrum[2])) > 90 ether ?
      ILendingProtocol(iWrapper).nextSupplyRate(amountFulcrum) :
      ILendingProtocol(iWrapper).nextSupplyRateWithParams(paramsFulcrum);

    uint256 currCompRate = ILendingProtocol(cWrapper).nextSupplyRateWithParams(paramsCompound);
    bool isCompoundBest = currCompRate > currFulcRate;

    // bisection interval update, we choose to halve the smaller amount
    uint256 step = amountCompound < amountFulcrum ? amountCompound.div(2) : amountFulcrum.div(2);

    // base case
    // |fulcrumRate - compoundRate| <= tolerance
    if (
      ((currFulcRate.add(tolerance) >= currCompRate && isCompoundBest) ||
      (currCompRate.add(tolerance) >= currFulcRate && !isCompoundBest)) ||
      currIter >= maxIter
    ) {
      amounts = new uint256[](2);
      amounts[0] = amountCompound;
      amounts[1] = amountFulcrum;
      return amounts;
    }

    return bisectionRec(
      isCompoundBest ? amountCompound.add(step) : amountCompound.sub(step),
      isCompoundBest ? amountFulcrum.sub(step) : amountFulcrum.add(step),
      tolerance, currIter + 1, maxIter, n,
      paramsCompound, // paramsCompound[9] would be overwritten on next iteration
      paramsFulcrum // paramsFulcrum[3] would be overwritten on next iteration
    );
  }
}