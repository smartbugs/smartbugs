/**
 *Submitted for verification at Etherscan.io on 2020-07-02
*/

// File: contracts/sol6/utils/zeppelin/SafeMath.sol

pragma solidity 0.6.6;

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
        //require(c >= a, "SafeMath: addition overflow");

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
        //require(b <= a, errorMessage);
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
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

// File: contracts/sol6/Dao/IEpochUtils.sol

pragma solidity 0.6.6;

interface IEpochUtils {
    function epochPeriodInSeconds() external view returns (uint256);

    function firstEpochStartTimestamp() external view returns (uint256);

    function getCurrentEpochNumber() external view returns (uint256);

    function getEpochNumber(uint256 timestamp) external view returns (uint256);
}

// File: contracts/sol6/Dao/EpochUtils.sol

pragma solidity 0.6.6;



contract EpochUtils is IEpochUtils {
    using SafeMath for uint256;

    uint256 public override epochPeriodInSeconds;
    uint256 public override firstEpochStartTimestamp;

    function getCurrentEpochNumber() public view override returns (uint256) {
        return getEpochNumber(now);
    }

    function getEpochNumber(uint256 timestamp) public view override returns (uint256) {
        if (timestamp < firstEpochStartTimestamp || epochPeriodInSeconds == 0) {
            return 0;
        }
        // ((timestamp - firstEpochStartTimestamp) / epochPeriodInSeconds) + 1;
        return ((timestamp.sub(firstEpochStartTimestamp)).div(epochPeriodInSeconds)).add(1);
    }
}

// File: contracts/sol6/Dao/DaoOperator.sol

pragma solidity 0.6.6;


contract DaoOperator {
    address public daoOperator;

    constructor(address _daoOperator) public {
        require(_daoOperator != address(0), "daoOperator is 0");
        daoOperator = _daoOperator;
    }

    modifier onlyDaoOperator() {
        require(msg.sender == daoOperator, "only daoOperator");
        _;
    }
}

// File: contracts/sol6/IERC20.sol

pragma solidity 0.6.6;


interface IERC20 {
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function approve(address _spender, uint256 _value) external returns (bool success);

    function transfer(address _to, uint256 _value) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    function balanceOf(address _owner) external view returns (uint256 balance);

    function decimals() external view returns (uint8 digits);

    function totalSupply() external view returns (uint256 supply);
}


// to support backward compatible contract name -- so function signature remains same
abstract contract ERC20 is IERC20 {

}

// File: contracts/sol6/utils/zeppelin/ReentrancyGuard.sol

pragma solidity 0.6.6;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
contract ReentrancyGuard {
    bool private _notEntered;

    constructor () internal {
        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}

// File: contracts/sol6/Dao/IKyberStaking.sol

pragma solidity 0.6.6;



interface IKyberStaking is IEpochUtils {
    event Delegated(
        address indexed staker,
        address indexed representative,
        uint256 indexed epoch,
        bool isDelegated
    );
    event Deposited(uint256 curEpoch, address indexed staker, uint256 amount);
    event Withdraw(uint256 indexed curEpoch, address indexed staker, uint256 amount);

    function initAndReturnStakerDataForCurrentEpoch(address staker)
        external
        returns (
            uint256 stake,
            uint256 delegatedStake,
            address representative
        );

    function deposit(uint256 amount) external;

    function delegate(address dAddr) external;

    function withdraw(uint256 amount) external;

    /**
     * @notice return combine data (stake, delegatedStake, representative) of a staker
     * @dev allow to get staker data up to current epoch + 1
     */
    function getStakerData(address staker, uint256 epoch)
        external
        view
        returns (
            uint256 stake,
            uint256 delegatedStake,
            address representative
        );

    function getLatestStakerData(address staker)
        external
        view
        returns (
            uint256 stake,
            uint256 delegatedStake,
            address representative
        );

    /**
     * @notice return raw data of a staker for an epoch
     *         WARN: should be used only for initialized data
     *          if data has not been initialized, it will return all 0
     *          pool master shouldn't use this function to compute/distribute rewards of pool members
     */
    function getStakerRawData(address staker, uint256 epoch)
        external
        view
        returns (
            uint256 stake,
            uint256 delegatedStake,
            address representative
        );
}

// File: contracts/sol6/IKyberDao.sol

pragma solidity 0.6.6;



interface IKyberDao is IEpochUtils {
    event Voted(address indexed staker, uint indexed epoch, uint indexed campaignID, uint option);

    function getLatestNetworkFeeDataWithCache()
        external
        returns (uint256 feeInBps, uint256 expiryTimestamp);

    function getLatestBRRDataWithCache()
        external
        returns (
            uint256 burnInBps,
            uint256 rewardInBps,
            uint256 rebateInBps,
            uint256 epoch,
            uint256 expiryTimestamp
        );

    function handleWithdrawal(address staker, uint256 penaltyAmount) external;

    function vote(uint256 campaignID, uint256 option) external;

    function getLatestNetworkFeeData()
        external
        view
        returns (uint256 feeInBps, uint256 expiryTimestamp);

    function shouldBurnRewardForEpoch(uint256 epoch) external view returns (bool);

    /**
     * @dev  return staker's reward percentage in precision for a past epoch only
     *       fee handler should call this function when a staker wants to claim reward
     *       return 0 if staker has no votes or stakes
     */
    function getPastEpochRewardPercentageInPrecision(address staker, uint256 epoch)
        external
        view
        returns (uint256);

    /**
     * @dev  return staker's reward percentage in precision for the current epoch
     *       reward percentage is not finalized until the current epoch is ended
     */
    function getCurrentEpochRewardPercentageInPrecision(address staker)
        external
        view
        returns (uint256);
}

// File: contracts/sol6/Dao/KyberStaking.sol

pragma solidity 0.6.6;







/**
 * @notice   This contract is using SafeMath for uint, which is inherited from EpochUtils
 *           Some events are moved to interface, easier for public uses
 *           Staking contract will be deployed by KyberDao's contract
 */
contract KyberStaking is IKyberStaking, EpochUtils, ReentrancyGuard {
    struct StakerData {
        uint256 stake;
        uint256 delegatedStake;
        address representative;
    }

    IERC20 public immutable kncToken;
    IKyberDao public immutable kyberDao;

    // staker data per epoch, including stake, delegated stake and representative
    mapping(uint256 => mapping(address => StakerData)) internal stakerPerEpochData;
    // latest data of a staker, including stake, delegated stake, representative
    mapping(address => StakerData) internal stakerLatestData;
    // true/false: if data has been initialized at an epoch for a staker
    mapping(uint256 => mapping(address => bool)) internal hasInited;

    // event is fired if something is wrong with withdrawal
    // even though the withdrawal is still successful
    event WithdrawDataUpdateFailed(uint256 curEpoch, address staker, uint256 amount);

    constructor(
        IERC20 _kncToken,
        uint256 _epochPeriod,
        uint256 _startTimestamp,
        IKyberDao _kyberDao
    ) public {
        require(_epochPeriod > 0, "ctor: epoch period is 0");
        require(_startTimestamp >= now, "ctor: start in the past");
        require(_kncToken != IERC20(0), "ctor: kncToken 0");
        require(_kyberDao != IKyberDao(0), "ctor: kyberDao 0");

        epochPeriodInSeconds = _epochPeriod;
        firstEpochStartTimestamp = _startTimestamp;
        kncToken = _kncToken;
        kyberDao = _kyberDao;
    }

    /**
     * @dev calls to set delegation for msg.sender, will take effect from the next epoch
     * @param newRepresentative address to delegate to
     */
    function delegate(address newRepresentative) external override {
        require(newRepresentative != address(0), "delegate: representative 0");
        address staker = msg.sender;
        uint256 curEpoch = getCurrentEpochNumber();

        initDataIfNeeded(staker, curEpoch);

        address curRepresentative = stakerPerEpochData[curEpoch + 1][staker].representative;
        // nothing changes here
        if (newRepresentative == curRepresentative) {
            return;
        }

        uint256 updatedStake = stakerPerEpochData[curEpoch + 1][staker].stake;

        // reduce delegatedStake for curRepresentative if needed
        if (curRepresentative != staker) {
            initDataIfNeeded(curRepresentative, curEpoch);

            stakerPerEpochData[curEpoch + 1][curRepresentative].delegatedStake =
                stakerPerEpochData[curEpoch + 1][curRepresentative].delegatedStake.sub(updatedStake);
            stakerLatestData[curRepresentative].delegatedStake =
                stakerLatestData[curRepresentative].delegatedStake.sub(updatedStake);

            emit Delegated(staker, curRepresentative, curEpoch, false);
        }

        stakerLatestData[staker].representative = newRepresentative;
        stakerPerEpochData[curEpoch + 1][staker].representative = newRepresentative;

        // ignore if staker is delegating back to himself
        if (newRepresentative != staker) {
            initDataIfNeeded(newRepresentative, curEpoch);
            stakerPerEpochData[curEpoch + 1][newRepresentative].delegatedStake =
                stakerPerEpochData[curEpoch + 1][newRepresentative].delegatedStake.add(updatedStake);
            stakerLatestData[newRepresentative].delegatedStake =
                stakerLatestData[newRepresentative].delegatedStake.add(updatedStake);
            emit Delegated(staker, newRepresentative, curEpoch, true);
        }
    }

    /**
     * @dev call to stake more KNC for msg.sender
     * @param amount amount of KNC to stake
     */
    function deposit(uint256 amount) external override {
        require(amount > 0, "deposit: amount is 0");

        uint256 curEpoch = getCurrentEpochNumber();
        address staker = msg.sender;

        // collect KNC token from staker
        require(
            kncToken.transferFrom(staker, address(this), amount),
            "deposit: can not get token"
        );

        initDataIfNeeded(staker, curEpoch);

        stakerPerEpochData[curEpoch + 1][staker].stake =
            stakerPerEpochData[curEpoch + 1][staker].stake.add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        stakerLatestData[staker].stake =
            stakerLatestData[staker].stake.add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW


        // increase delegated stake for address that staker has delegated to (if it is not staker)
        address representative = stakerPerEpochData[curEpoch + 1][staker].representative;
        if (representative != staker) {
            initDataIfNeeded(representative, curEpoch);
            stakerPerEpochData[curEpoch + 1][representative].delegatedStake =
                stakerPerEpochData[curEpoch + 1][representative].delegatedStake.add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

            stakerLatestData[representative].delegatedStake =
                stakerLatestData[representative].delegatedStake.add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        }

        emit Deposited(curEpoch, staker, amount);
    }

    /**
     * @dev call to withdraw KNC from staking, it could affect reward when calling KyberDao handleWithdrawal
     * @param amount amount of KNC to withdraw
     */
    function withdraw(uint256 amount) external override nonReentrant {
        require(amount > 0, "withdraw: amount is 0");

        uint256 curEpoch = getCurrentEpochNumber();
        address staker = msg.sender;

        require(
            stakerLatestData[staker].stake >= amount,
            "withdraw: latest amount staked < withdrawal amount"
        );

        (bool success, ) = address(this).call(
            abi.encodeWithSignature(
                "handleWithdrawal(address,uint256,uint256)",
                staker,
                amount,
                curEpoch
            )
        );
        if (!success) {
            // Note: should catch this event to check if something went wrong
            emit WithdrawDataUpdateFailed(curEpoch, staker, amount);
        }

        stakerLatestData[staker].stake = stakerLatestData[staker].stake.sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW


        // transfer KNC back to staker
        require(kncToken.transfer(staker, amount), "withdraw: can not transfer knc");
        emit Withdraw(curEpoch, staker, amount);
    }

    /**
     * @dev initialize data if needed, then return staker's data for current epoch
     * @dev for safe, only allow calling this func from KyberDao address
     * @param staker - staker's address to initialize and get data for
     */
    function initAndReturnStakerDataForCurrentEpoch(address staker)
        external
        override
        returns (
            uint256 stake,
            uint256 delegatedStake,
            address representative
        )
    {
        require(
            msg.sender == address(kyberDao),
            "initAndReturnData: only kyberDao"
        );

        uint256 curEpoch = getCurrentEpochNumber();
        initDataIfNeeded(staker, curEpoch);

        StakerData memory stakerData = stakerPerEpochData[curEpoch][staker];
        stake = stakerData.stake;
        delegatedStake = stakerData.delegatedStake;
        representative = stakerData.representative;
    }

    /**
     * @notice return raw data of a staker for an epoch
     *         WARN: should be used only for initialized data
     *          if data has not been initialized, it will return all 0
     *          pool master shouldn't use this function to compute/distribute rewards of pool members
     * @dev  in KyberDao contract, if staker wants to claim reward for past epoch,
     *       we must know the staker's data for that epoch
     *       if the data has not been initialized, it means staker hasn't done any action -> no reward
     */
    function getStakerRawData(address staker, uint256 epoch)
        external
        view
        override
        returns (
            uint256 stake,
            uint256 delegatedStake,
            address representative
        )
    {
        StakerData memory stakerData = stakerPerEpochData[epoch][staker];
        stake = stakerData.stake;
        delegatedStake = stakerData.delegatedStake;
        representative = stakerData.representative;
    }

    /**
     * @dev allow to get data up to current epoch + 1
     */
    function getStake(address staker, uint256 epoch) external view returns (uint256) {
        uint256 curEpoch = getCurrentEpochNumber();
        if (epoch > curEpoch + 1) {
            return 0;
        }
        uint256 i = epoch;
        while (true) {
            if (hasInited[i][staker]) {
                return stakerPerEpochData[i][staker].stake;
            }
            if (i == 0) {
                break;
            }
            i--;
        }
        return 0;
    }

    /**
     * @dev allow to get data up to current epoch + 1
     */
    function getDelegatedStake(address staker, uint256 epoch) external view returns (uint256) {
        uint256 curEpoch = getCurrentEpochNumber();
        if (epoch > curEpoch + 1) {
            return 0;
        }
        uint256 i = epoch;
        while (true) {
            if (hasInited[i][staker]) {
                return stakerPerEpochData[i][staker].delegatedStake;
            }
            if (i == 0) {
                break;
            }
            i--;
        }
        return 0;
    }

    /**
     * @dev allow to get data up to current epoch + 1
     */
    function getRepresentative(address staker, uint256 epoch) external view returns (address) {
        uint256 curEpoch = getCurrentEpochNumber();
        if (epoch > curEpoch + 1) {
            return address(0);
        }
        uint256 i = epoch;
        while (true) {
            if (hasInited[i][staker]) {
                return stakerPerEpochData[i][staker].representative;
            }
            if (i == 0) {
                break;
            }
            i--;
        }
        // not delegated to anyone, default to yourself
        return staker;
    }

    /**
     * @notice return combine data (stake, delegatedStake, representative) of a staker
     * @dev allow to get staker data up to current epoch + 1
     */
    function getStakerData(address staker, uint256 epoch)
        external view override
        returns (
            uint256 stake,
            uint256 delegatedStake,
            address representative
        )
    {
        stake = 0;
        delegatedStake = 0;
        representative = address(0);

        uint256 curEpoch = getCurrentEpochNumber();
        if (epoch > curEpoch + 1) {
            return (stake, delegatedStake, representative);
        }
        uint256 i = epoch;
        while (true) {
            if (hasInited[i][staker]) {
                stake = stakerPerEpochData[i][staker].stake;
                delegatedStake = stakerPerEpochData[i][staker].delegatedStake;
                representative = stakerPerEpochData[i][staker].representative;
                return (stake, delegatedStake, representative);
            }
            if (i == 0) {
                break;
            }
            i--;
        }
        // not delegated to anyone, default to yourself
        representative = staker;
    }

    function getLatestRepresentative(address staker) external view returns (address) {
        return
            stakerLatestData[staker].representative == address(0)
                ? staker
                : stakerLatestData[staker].representative;
    }

    function getLatestDelegatedStake(address staker) external view returns (uint256) {
        return stakerLatestData[staker].delegatedStake;
    }

    function getLatestStakeBalance(address staker) external view returns (uint256) {
        return stakerLatestData[staker].stake;
    }

    function getLatestStakerData(address staker)
        external view override
        returns (
            uint256 stake,
            uint256 delegatedStake,
            address representative
        )
    {
        stake = stakerLatestData[staker].stake;
        delegatedStake = stakerLatestData[staker].delegatedStake;
        representative = stakerLatestData[staker].representative == address(0)
                ? staker
                : stakerLatestData[staker].representative;
    }

    /**
    * @dev  separate logics from withdraw, so staker can withdraw as long as amount <= staker's deposit amount
            calling this function from withdraw function, ignore reverting
    * @param staker staker that is withdrawing
    * @param amount amount to withdraw
    * @param curEpoch current epoch
    */
    function handleWithdrawal(
        address staker,
        uint256 amount,
        uint256 curEpoch
    ) external {
        require(msg.sender == address(this), "only staking contract");
        initDataIfNeeded(staker, curEpoch);
        // Note: update latest stake will be done after this function
        // update staker's data for next epoch
        stakerPerEpochData[curEpoch + 1][staker].stake =
            stakerPerEpochData[curEpoch + 1][staker].stake.sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW


        address representative = stakerPerEpochData[curEpoch][staker].representative;
        uint256 curStake = stakerPerEpochData[curEpoch][staker].stake;
        uint256 lStakeBal = stakerLatestData[staker].stake.sub(amount);
        uint256 newStake = curStake.min(lStakeBal);
        uint256 reduceAmount = curStake.sub(newStake); // newStake is always <= curStake

        if (reduceAmount > 0) {
            if (representative != staker) {
                initDataIfNeeded(representative, curEpoch);
                // staker has delegated to representative, withdraw will affect representative's delegated stakes
                stakerPerEpochData[curEpoch][representative].delegatedStake =
                    stakerPerEpochData[curEpoch][representative].delegatedStake.sub(reduceAmount);
            }
            stakerPerEpochData[curEpoch][staker].stake = newStake;
            // call KyberDao to reduce reward, if staker has delegated, then pass his representative
            if (address(kyberDao) != address(0)) {
                // don't revert if KyberDao revert so data will be updated correctly
                (bool success, ) = address(kyberDao).call(
                    abi.encodeWithSignature(
                        "handleWithdrawal(address,uint256)",
                        representative,
                        reduceAmount
                    )
                );
                if (!success) {
                    emit WithdrawDataUpdateFailed(curEpoch, staker, amount);
                }
            }
        }
        representative = stakerPerEpochData[curEpoch + 1][staker].representative;
        if (representative != staker) {
            initDataIfNeeded(representative, curEpoch);
            stakerPerEpochData[curEpoch + 1][representative].delegatedStake =
                stakerPerEpochData[curEpoch + 1][representative].delegatedStake.sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

            stakerLatestData[representative].delegatedStake =
                stakerLatestData[representative].delegatedStake.sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        }
    }

    /**
     * @dev initialize data if it has not been initialized yet
     * @param staker staker's address to initialize
     * @param epoch should be current epoch
     */
    function initDataIfNeeded(address staker, uint256 epoch) internal {
        address representative = stakerLatestData[staker].representative;
        if (representative == address(0)) {
            // not delegate to anyone, consider as delegate to yourself
            stakerLatestData[staker].representative = staker;
            representative = staker;
        }

        uint256 ldStake = stakerLatestData[staker].delegatedStake;
        uint256 lStakeBal = stakerLatestData[staker].stake;

        if (!hasInited[epoch][staker]) {
            hasInited[epoch][staker] = true;
            StakerData storage stakerData = stakerPerEpochData[epoch][staker];
            stakerData.representative = representative;
            stakerData.delegatedStake = ldStake;
            stakerData.stake = lStakeBal;
        }

        // whenever stakers deposit/withdraw/delegate, the current and next epoch data need to be updated
        // as the result, we will also initialize data for staker at the next epoch
        if (!hasInited[epoch + 1][staker]) {
            hasInited[epoch + 1][staker] = true;
            StakerData storage nextEpochStakerData = stakerPerEpochData[epoch + 1][staker];
            nextEpochStakerData.representative = representative;
            nextEpochStakerData.delegatedStake = ldStake;
            nextEpochStakerData.stake = lStakeBal;
        }
    }
}

// File: contracts/sol6/utils/Utils5.sol

pragma solidity 0.6.6;



/**
 * @title Kyber utility file
 * mostly shared constants and rate calculation helpers
 * inherited by most of kyber contracts.
 * previous utils implementations are for previous solidity versions.
 */
contract Utils5 {
    IERC20 internal constant ETH_TOKEN_ADDRESS = IERC20(
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    );
    uint256 internal constant PRECISION = (10**18);
    uint256 internal constant MAX_QTY = (10**28); // 10B tokens
    uint256 internal constant MAX_RATE = (PRECISION * 10**7); // up to 10M tokens per eth
    uint256 internal constant MAX_DECIMALS = 18;
    uint256 internal constant ETH_DECIMALS = 18;
    uint256 constant BPS = 10000; // Basic Price Steps. 1 step = 0.01%
    uint256 internal constant MAX_ALLOWANCE = uint256(-1); // token.approve inifinite

    mapping(IERC20 => uint256) internal decimals;

    function getUpdateDecimals(IERC20 token) internal returns (uint256) {
        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
        uint256 tokenDecimals = decimals[token];
        // moreover, very possible that old tokens have decimals 0
        // these tokens will just have higher gas fees.
        if (tokenDecimals == 0) {
            tokenDecimals = token.decimals();
            decimals[token] = tokenDecimals;
        }

        return tokenDecimals;
    }

    function setDecimals(IERC20 token) internal {
        if (decimals[token] != 0) return; //already set

        if (token == ETH_TOKEN_ADDRESS) {
            decimals[token] = ETH_DECIMALS;
        } else {
            decimals[token] = token.decimals();
        }
    }

    /// @dev get the balance of a user.
    /// @param token The token type
    /// @return The balance
    function getBalance(IERC20 token, address user) internal view returns (uint256) {
        if (token == ETH_TOKEN_ADDRESS) {
            return user.balance;
        } else {
            return token.balanceOf(user);
        }
    }

    function getDecimals(IERC20 token) internal view returns (uint256) {
        if (token == ETH_TOKEN_ADDRESS) return ETH_DECIMALS; // save storage access
        uint256 tokenDecimals = decimals[token];
        // moreover, very possible that old tokens have decimals 0
        // these tokens will just have higher gas fees.
        if (tokenDecimals == 0) return token.decimals();

        return tokenDecimals;
    }

    function calcDestAmount(
        IERC20 src,
        IERC20 dest,
        uint256 srcAmount,
        uint256 rate
    ) internal view returns (uint256) {
        return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
    }

    function calcSrcAmount(
        IERC20 src,
        IERC20 dest,
        uint256 destAmount,
        uint256 rate
    ) internal view returns (uint256) {
        return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
    }

    function calcDstQty(
        uint256 srcQty,
        uint256 srcDecimals,
        uint256 dstDecimals,
        uint256 rate
    ) internal pure returns (uint256) {
        require(srcQty <= MAX_QTY, "srcQty > MAX_QTY");
        require(rate <= MAX_RATE, "rate > MAX_RATE");

        if (dstDecimals >= srcDecimals) {
            require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
            return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
        } else {
            require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
            return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
        }
    }

    function calcSrcQty(
        uint256 dstQty,
        uint256 srcDecimals,
        uint256 dstDecimals,
        uint256 rate
    ) internal pure returns (uint256) {
        require(dstQty <= MAX_QTY, "dstQty > MAX_QTY");
        require(rate <= MAX_RATE, "rate > MAX_RATE");

        //source quantity is rounded up. to avoid dest quantity being too low.
        uint256 numerator;
        uint256 denominator;
        if (srcDecimals >= dstDecimals) {
            require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
            numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
            denominator = rate;
        } else {
            require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
            numerator = (PRECISION * dstQty);
            denominator = (rate * (10**(dstDecimals - srcDecimals)));
        }
        return (numerator + denominator - 1) / denominator; //avoid rounding down errors
    }

    function calcRateFromQty(
        uint256 srcAmount,
        uint256 destAmount,
        uint256 srcDecimals,
        uint256 dstDecimals
    ) internal pure returns (uint256) {
        require(srcAmount <= MAX_QTY, "srcAmount > MAX_QTY");
        require(destAmount <= MAX_QTY, "destAmount > MAX_QTY");

        if (dstDecimals >= srcDecimals) {
            require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
            return ((destAmount * PRECISION) / ((10**(dstDecimals - srcDecimals)) * srcAmount));
        } else {
            require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
            return ((destAmount * PRECISION * (10**(srcDecimals - dstDecimals))) / srcAmount);
        }
    }

    function minOf(uint256 x, uint256 y) internal pure returns (uint256) {
        return x > y ? y : x;
    }
}

// File: contracts/sol6/Dao/KyberDao.sol

pragma solidity 0.6.6;








/**
 * @notice  This contract is using SafeMath for uint, which is inherited from EpochUtils
            Some events are moved to interface, easier for public uses
 * @dev Network fee campaign: options are fee in bps
 *      BRR fee handler campaign: options are combined of rebate (left most 128 bits) + reward (right most 128 bits)
 *      General campaign: options are from 1 to num_options
 */
contract KyberDao is IKyberDao, EpochUtils, ReentrancyGuard, Utils5, DaoOperator {
    // max number of campaigns for each epoch
    uint256 public   constant MAX_EPOCH_CAMPAIGNS = 10;
    // max number of options for each campaign
    uint256 public   constant MAX_CAMPAIGN_OPTIONS = 8;
    uint256 internal constant POWER_128 = 2**128;

    enum CampaignType {General, NetworkFee, FeeHandlerBRR}

    struct FormulaData {
        uint256 minPercentageInPrecision;
        uint256 cInPrecision;
        uint256 tInPrecision;
    }

    struct CampaignVoteData {
        uint256 totalVotes;
        uint256[] votePerOption;
    }

    struct Campaign {
        CampaignType campaignType;
        bool campaignExists;
        uint256 startTimestamp;
        uint256 endTimestamp;
        uint256 totalKNCSupply; // total KNC supply at the time campaign was created
        FormulaData formulaData; // formula params for concluding campaign result
        bytes link; // link to KIP, explaination of options, etc.
        uint256[] options; // data of options
        CampaignVoteData campaignVoteData; // campaign vote data: total votes + vote per option
    }

    struct BRRData {
        uint256 rewardInBps;
        uint256 rebateInBps;
    }

    uint256 public minCampaignDurationInSeconds = 15 minutes;
    IERC20 public immutable kncToken;
    IKyberStaking public immutable staking;

    // use to generate increasing campaign ID
    uint256 public numberCampaigns = 0;
    mapping(uint256 => Campaign) internal campaignData;

    // epochCampaigns[epoch]: list campaign IDs for an epoch (epoch => campaign IDs)
    mapping(uint256 => uint256[]) internal epochCampaigns;
    // totalEpochPoints[epoch]: total points for an epoch (epoch => total points)
    mapping(uint256 => uint256) internal totalEpochPoints;
    // numberVotes[staker][epoch]: number of campaigns that the staker has voted in an epoch
    mapping(address => mapping(uint256 => uint256)) public numberVotes;
    // stakerVotedOption[staker][campaignID]: staker's voted option ID for a campaign
    mapping(address => mapping(uint256 => uint256)) public stakerVotedOption;

    uint256 internal latestNetworkFeeResult;
    // epoch => campaignID for network fee campaigns
    mapping(uint256 => uint256) public networkFeeCampaigns;
    // latest BRR data (reward and rebate in bps)
    BRRData internal latestBrrData;
    // epoch => campaignID for brr campaigns
    mapping(uint256 => uint256) public brrCampaigns;

    event NewCampaignCreated(
        CampaignType campaignType,
        uint256 indexed campaignID,
        uint256 startTimestamp,
        uint256 endTimestamp,
        uint256 minPercentageInPrecision,
        uint256 cInPrecision,
        uint256 tInPrecision,
        uint256[] options,
        bytes link
    );

    event CancelledCampaign(uint256 indexed campaignID);

    constructor(
        uint256 _epochPeriod,
        uint256 _startTimestamp,
        IERC20 _knc,
        uint256 _defaultNetworkFeeBps,
        uint256 _defaultRewardBps,
        uint256 _defaultRebateBps,
        address _daoOperator
    ) public DaoOperator(_daoOperator) {
        require(_epochPeriod > 0, "ctor: epoch period is 0");
        require(_startTimestamp >= now, "ctor: start in the past");
        require(_knc != IERC20(0), "ctor: knc token 0");
        // in Network, maximum fee that can be taken from 1 tx is (platform fee + 2 * network fee)
        // so network fee should be less than 50%
        require(_defaultNetworkFeeBps < BPS / 2, "ctor: network fee high");
        require(_defaultRewardBps.add(_defaultRebateBps) <= BPS, "reward plus rebate high");

        epochPeriodInSeconds = _epochPeriod;
        firstEpochStartTimestamp = _startTimestamp;
        kncToken = _knc;

        latestNetworkFeeResult = _defaultNetworkFeeBps;
        latestBrrData = BRRData({
            rewardInBps: _defaultRewardBps,
            rebateInBps: _defaultRebateBps
        });

        // deploy staking contract 
        staking = new KyberStaking({
            _kncToken: _knc,
            _epochPeriod: _epochPeriod,
            _startTimestamp: _startTimestamp,
            _kyberDao: IKyberDao(this)
        });
    }

    modifier onlyStakingContract {
        require(msg.sender == address(staking), "only staking contract");
        _;
    }

    /**
     * @dev called by staking contract when staker wanted to withdraw
     * @param staker address of staker to reduce reward
     * @param reduceAmount amount voting power to be reduced for each campaign staker has voted at this epoch
     */
    function handleWithdrawal(address staker, uint256 reduceAmount) external override onlyStakingContract {
        // staking shouldn't call this func with reduce amount = 0
        if (reduceAmount == 0) {
            return;
        }
        uint256 curEpoch = getCurrentEpochNumber();

        uint256 numVotes = numberVotes[staker][curEpoch];
        // staker has not participated in any campaigns at the current epoch
        if (numVotes == 0) {
            return;
        }

        // update total points for current epoch
        totalEpochPoints[curEpoch] = totalEpochPoints[curEpoch].sub(numVotes.mul(reduceAmount));

        // update voted count for each campaign staker has voted
        uint256[] memory campaignIDs = epochCampaigns[curEpoch];

        for (uint256 i = 0; i < campaignIDs.length; i++) {
            uint256 campaignID = campaignIDs[i];

            uint256 votedOption = stakerVotedOption[staker][campaignID];
            if (votedOption == 0) {
                continue;
            } // staker has not voted yet

            Campaign storage campaign = campaignData[campaignID];
            if (campaign.endTimestamp >= now) {
                // the staker has voted for this campaign and the campaign has not ended yet
                // reduce total votes and vote count of staker's voted option
                campaign.campaignVoteData.totalVotes =
                    campaign.campaignVoteData.totalVotes.sub(reduceAmount);	//injected INTEGER OVERFLOW OR UNDERFLOW

                campaign.campaignVoteData.votePerOption[votedOption - 1] =
                    campaign.campaignVoteData.votePerOption[votedOption - 1].sub(reduceAmount);	//injected INTEGER OVERFLOW OR UNDERFLOW

            }
        }
    }

    /**
     * @dev create new campaign, only called by daoOperator
     * @param campaignType type of campaign (General, NetworkFee, FeeHandlerBRR)
     * @param startTimestamp timestamp to start running the campaign
     * @param endTimestamp timestamp to end this campaign
     * @param minPercentageInPrecision min percentage (in precision) for formula to conclude campaign
     * @param cInPrecision c value (in precision) for formula to conclude campaign
     * @param tInPrecision t value (in precision) for formula to conclude campaign
     * @param options list values of options to vote for this campaign
     * @param link additional data for this campaign
     */
    function submitNewCampaign(
        CampaignType campaignType,
        uint256 startTimestamp,
        uint256 endTimestamp,
        uint256 minPercentageInPrecision,
        uint256 cInPrecision,
        uint256 tInPrecision,
        uint256[] calldata options,
        bytes calldata link
    ) external onlyDaoOperator returns (uint256 campaignID) {
        // campaign epoch could be different from current epoch
        // as we allow to create campaign of next epoch as well
        uint256 campaignEpoch = getEpochNumber(startTimestamp);

        validateCampaignParams(
            campaignType,
            startTimestamp,
            endTimestamp,
            minPercentageInPrecision,
            cInPrecision,
            tInPrecision,
            options
        );

        numberCampaigns = numberCampaigns.add(1);
        campaignID = numberCampaigns;

        // add campaignID into the list campaign IDs
        epochCampaigns[campaignEpoch].push(campaignID);
        // update network fee or fee handler brr campaigns
        if (campaignType == CampaignType.NetworkFee) {
            networkFeeCampaigns[campaignEpoch] = campaignID;
        } else if (campaignType == CampaignType.FeeHandlerBRR) {
            brrCampaigns[campaignEpoch] = campaignID;
        }

        FormulaData memory formulaData = FormulaData({
            minPercentageInPrecision: minPercentageInPrecision,
            cInPrecision: cInPrecision,
            tInPrecision: tInPrecision
        });
        CampaignVoteData memory campaignVoteData = CampaignVoteData({
            totalVotes: 0,
            votePerOption: new uint256[](options.length)
        });

        campaignData[campaignID] = Campaign({
            campaignExists: true,
            campaignType: campaignType,
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            totalKNCSupply: kncToken.totalSupply(),
            link: link,
            formulaData: formulaData,
            options: options,
            campaignVoteData: campaignVoteData
        });

        emit NewCampaignCreated(
            campaignType,
            campaignID,
            startTimestamp,
            endTimestamp,
            minPercentageInPrecision,
            cInPrecision,
            tInPrecision,
            options,
            link
        );
    }

    /**
     * @dev  cancel a campaign with given id, called by daoOperator only
     *       only can cancel campaigns that have not started yet
     * @param campaignID id of the campaign to cancel
     */
    function cancelCampaign(uint256 campaignID) external onlyDaoOperator {
        Campaign storage campaign = campaignData[campaignID];
        require(campaign.campaignExists, "cancelCampaign: campaignID doesn't exist");

        require(campaign.startTimestamp > now, "cancelCampaign: campaign already started");

        uint256 epoch = getEpochNumber(campaign.startTimestamp);

        if (campaign.campaignType == CampaignType.NetworkFee) {
            delete networkFeeCampaigns[epoch];
        } else if (campaign.campaignType == CampaignType.FeeHandlerBRR) {
            delete brrCampaigns[epoch];
        }

        delete campaignData[campaignID];

        uint256[] storage campaignIDs = epochCampaigns[epoch];
        for (uint256 i = 0; i < campaignIDs.length; i++) {
            if (campaignIDs[i] == campaignID) {
                // remove this campaign id out of list
                campaignIDs[i] = campaignIDs[campaignIDs.length - 1];
                campaignIDs.pop();
                break;
            }
        }

        emit CancelledCampaign(campaignID);
    }

    /**
     * @dev  vote for an option of a campaign
     *       options are indexed from 1 to number of options
     * @param campaignID id of campaign to vote for
     * @param option id of options to vote for
     */
    function vote(uint256 campaignID, uint256 option) external override {
        validateVoteOption(campaignID, option);
        address staker = msg.sender;

        uint256 curEpoch = getCurrentEpochNumber();
        (uint256 stake, uint256 dStake, address representative) =
            staking.initAndReturnStakerDataForCurrentEpoch(staker);

        uint256 totalStake = representative == staker ? stake.add(dStake) : dStake;
        uint256 lastVotedOption = stakerVotedOption[staker][campaignID];

        CampaignVoteData storage voteData = campaignData[campaignID].campaignVoteData;

        if (lastVotedOption == 0) {
            // increase number campaigns that the staker has voted at the current epoch
            numberVotes[staker][curEpoch]++;

            totalEpochPoints[curEpoch] = totalEpochPoints[curEpoch].add(totalStake);
            // increase voted count for this option
            voteData.votePerOption[option - 1] =
                voteData.votePerOption[option - 1].add(totalStake);
            // increase total votes
            voteData.totalVotes = voteData.totalVotes.add(totalStake);
        } else if (lastVotedOption != option) {
            // deduce previous option voted count
            voteData.votePerOption[lastVotedOption - 1] =
                voteData.votePerOption[lastVotedOption - 1].sub(totalStake);
            // increase new option voted count
            voteData.votePerOption[option - 1] =
                voteData.votePerOption[option - 1].add(totalStake);
        }

        stakerVotedOption[staker][campaignID] = option;

        emit Voted(staker, curEpoch, campaignID, option);
    }

    /**
     * @dev get latest network fee data + expiry timestamp
     *    conclude network fee campaign if needed and caching latest result in KyberDao
     */
    function getLatestNetworkFeeDataWithCache()
        external
        override
        returns (uint256 feeInBps, uint256 expiryTimestamp)
    {
        (feeInBps, expiryTimestamp) = getLatestNetworkFeeData();
        // cache latest data
        latestNetworkFeeResult = feeInBps;
    }

    /**
     * @dev return latest burn/reward/rebate data, also affecting epoch + expiry timestamp
     *      conclude brr campaign if needed and caching latest result in KyberDao
     */
    function getLatestBRRDataWithCache()
        external
        override
        returns (
            uint256 burnInBps,
            uint256 rewardInBps,
            uint256 rebateInBps,
            uint256 epoch,
            uint256 expiryTimestamp
        )
    {
        (burnInBps, rewardInBps, rebateInBps, epoch, expiryTimestamp) = getLatestBRRData();
        latestBrrData.rewardInBps = rewardInBps;
        latestBrrData.rebateInBps = rebateInBps;
    }

    /**
     * @dev some epochs have reward but no one can claim, for example: epoch 0
     *      return true if should burn all that reward
     * @param epoch epoch to check for burning reward
     */
    function shouldBurnRewardForEpoch(uint256 epoch) external view override returns (bool) {
        uint256 curEpoch = getCurrentEpochNumber();
        if (epoch >= curEpoch) {
            return false;
        }
        return totalEpochPoints[epoch] == 0;
    }

    // return list campaign ids for epoch, excluding non-existed ones
    function getListCampaignIDs(uint256 epoch) external view returns (uint256[] memory campaignIDs) {
        campaignIDs = epochCampaigns[epoch];
    }

    // return total points for an epoch
    function getTotalEpochPoints(uint256 epoch) external view returns (uint256) {
        return totalEpochPoints[epoch];
    }

    function getCampaignDetails(uint256 campaignID)
        external
        view
        returns (
            CampaignType campaignType,
            uint256 startTimestamp,
            uint256 endTimestamp,
            uint256 totalKNCSupply,
            uint256 minPercentageInPrecision,
            uint256 cInPrecision,
            uint256 tInPrecision,
            bytes memory link,
            uint256[] memory options
        )
    {
        Campaign storage campaign = campaignData[campaignID];
        campaignType = campaign.campaignType;
        startTimestamp = campaign.startTimestamp;
        endTimestamp = campaign.endTimestamp;
        totalKNCSupply = campaign.totalKNCSupply;
        minPercentageInPrecision = campaign.formulaData.minPercentageInPrecision;
        cInPrecision = campaign.formulaData.cInPrecision;
        tInPrecision = campaign.formulaData.tInPrecision;
        link = campaign.link;
        options = campaign.options;
    }

    function getCampaignVoteCountData(uint256 campaignID)
        external
        view
        returns (uint256[] memory voteCounts, uint256 totalVoteCount)
    {
        CampaignVoteData memory voteData = campaignData[campaignID].campaignVoteData;
        totalVoteCount = voteData.totalVotes;
        voteCounts = voteData.votePerOption;
    }

    /**
     * @dev  return staker's reward percentage in precision for a past epoch only
     *       fee handler should call this function when a staker wants to claim reward
     *       return 0 if staker has no votes or stakes
     */
    function getPastEpochRewardPercentageInPrecision(address staker, uint256 epoch)
        external
        view
        override
        returns (uint256)
    {
        // return 0 if epoch is not past epoch
        uint256 curEpoch = getCurrentEpochNumber();
        if (epoch >= curEpoch) {
            return 0;
        }

        return getRewardPercentageInPrecision(staker, epoch);
    }

    /**
     * @dev  return staker's reward percentage in precision for the current epoch
     */
    function getCurrentEpochRewardPercentageInPrecision(address staker)
        external
        view
        override
        returns (uint256)
    {
        uint256 curEpoch = getCurrentEpochNumber();
        return getRewardPercentageInPrecision(staker, curEpoch);
    }

    /**
     * @dev return campaign winning option and its value
     *      return (0, 0) if campaign does not exist
     *      return (0, 0) if campaign has not ended yet
     *      return (0, 0) if campaign has no winning option based on the formula
     * @param campaignID id of campaign to get result
     */
    function getCampaignWinningOptionAndValue(uint256 campaignID)
        public
        view
        returns (uint256 optionID, uint256 value)
    {
        Campaign storage campaign = campaignData[campaignID];
        if (!campaign.campaignExists) {
            return (0, 0);
        } // not exist

        // campaign has not ended yet, return 0 as winning option
        if (campaign.endTimestamp > now) {
            return (0, 0);
        }

        uint256 totalSupply = campaign.totalKNCSupply;
        // something is wrong here, total KNC supply shouldn't be 0
        if (totalSupply == 0) {
            return (0, 0);
        }

        uint256 totalVotes = campaign.campaignVoteData.totalVotes;
        uint256[] memory voteCounts = campaign.campaignVoteData.votePerOption;

        // Finding option with most votes
        uint256 winningOption = 0;
        uint256 maxVotedCount = 0;
        for (uint256 i = 0; i < voteCounts.length; i++) {
            if (voteCounts[i] > maxVotedCount) {
                winningOption = i + 1;
                maxVotedCount = voteCounts[i];
            } else if (voteCounts[i] == maxVotedCount) {
                winningOption = 0;
            }
        }

        // more than 1 options have same vote count
        if (winningOption == 0) {
            return (0, 0);
        }

        FormulaData memory formulaData = campaign.formulaData;

        // compute voted percentage (in precision)
        uint256 votedPercentage = totalVotes.mul(PRECISION).div(campaign.totalKNCSupply);

        // total voted percentage is below min acceptable percentage, no winning option
        if (formulaData.minPercentageInPrecision > votedPercentage) {
            return (0, 0);
        }

        // as we already limit value for c & t, no need to check for overflow here
        uint256 x = formulaData.tInPrecision.mul(votedPercentage).div(PRECISION);
        if (x <= formulaData.cInPrecision) {
            // threshold is not negative, need to compare with voted count
            uint256 y = formulaData.cInPrecision.sub(x);
            // (most voted option count / total votes) is below threshold, no winining option
            if (maxVotedCount.mul(PRECISION) < y.mul(totalVotes)) {
                return (0, 0);
            }
        }

        optionID = winningOption;
        value = campaign.options[optionID - 1];
    }

    /**
     * @dev return latest network fee and expiry timestamp
     */
    function getLatestNetworkFeeData()
        public
        view
        override
        returns (uint256 feeInBps, uint256 expiryTimestamp)
    {
        uint256 curEpoch = getCurrentEpochNumber();
        feeInBps = latestNetworkFeeResult;
        // expiryTimestamp = firstEpochStartTimestamp + curEpoch * epochPeriodInSeconds - 1;
        expiryTimestamp = firstEpochStartTimestamp.add(curEpoch.mul(epochPeriodInSeconds)).sub(1);
        if (curEpoch == 0) {
            return (feeInBps, expiryTimestamp);
        }
        uint256 campaignID = networkFeeCampaigns[curEpoch.sub(1)];
        if (campaignID == 0) {
            // don't have network fee campaign, return latest result
            return (feeInBps, expiryTimestamp);
        }

        uint256 winningOption;
        (winningOption, feeInBps) = getCampaignWinningOptionAndValue(campaignID);
        if (winningOption == 0) {
            // fallback to previous result
            feeInBps = latestNetworkFeeResult;
        }
        return (feeInBps, expiryTimestamp);
    }

    /**
     * @dev return latest brr result, conclude brr campaign if needed
     */
    function getLatestBRRData()
        public
        view
        returns (
            uint256 burnInBps,
            uint256 rewardInBps,
            uint256 rebateInBps,
            uint256 epoch,
            uint256 expiryTimestamp
        )
    {
        epoch = getCurrentEpochNumber();
        // expiryTimestamp = firstEpochStartTimestamp + epoch * epochPeriodInSeconds - 1;
        expiryTimestamp = firstEpochStartTimestamp.add(epoch.mul(epochPeriodInSeconds)).sub(1);
        rewardInBps = latestBrrData.rewardInBps;
        rebateInBps = latestBrrData.rebateInBps;

        if (epoch > 0) {
            uint256 campaignID = brrCampaigns[epoch.sub(1)];
            if (campaignID != 0) {
                uint256 winningOption;
                uint256 brrData;
                (winningOption, brrData) = getCampaignWinningOptionAndValue(campaignID);
                if (winningOption > 0) {
                    // has winning option, update reward and rebate value
                    (rebateInBps, rewardInBps) = getRebateAndRewardFromData(brrData);
                }
            }
        }

        burnInBps = BPS.sub(rebateInBps).sub(rewardInBps);	//injected INTEGER OVERFLOW OR UNDERFLOW

    }

    // Helper functions for squeezing data
    function getRebateAndRewardFromData(uint256 data)
        public
        pure
        returns (uint256 rebateInBps, uint256 rewardInBps)
    {
        rewardInBps = data & (POWER_128.sub(1));
        rebateInBps = (data.div(POWER_128)) & (POWER_128.sub(1));
    }

    /**
     * @dev  helper func to get encoded reward and rebate
     *       revert if validation failed
     */
    function getDataFromRewardAndRebateWithValidation(uint256 rewardInBps, uint256 rebateInBps)
        public
        pure
        returns (uint256 data)
    {
        require(rewardInBps.add(rebateInBps) <= BPS, "reward plus rebate high");
        data = (rebateInBps.mul(POWER_128)).add(rewardInBps);	//injected INTEGER OVERFLOW OR UNDERFLOW

    }

    /**
     * @dev options are indexed from 1
     */
    function validateVoteOption(uint256 campaignID, uint256 option) internal view {
        Campaign storage campaign = campaignData[campaignID];
        require(campaign.campaignExists, "vote: campaign doesn't exist");

        require(campaign.startTimestamp <= now, "vote: campaign not started");
        require(campaign.endTimestamp >= now, "vote: campaign already ended");

        // option is indexed from 1 to options.length
        require(option > 0, "vote: option is 0");
        require(option <= campaign.options.length, "vote: option is not in range");
    }

    /**
     * @dev Validate params to check if we could submit a new campaign with these params
     */
    function validateCampaignParams(
        CampaignType campaignType,
        uint256 startTimestamp,
        uint256 endTimestamp,
        uint256 minPercentageInPrecision,
        uint256 cInPrecision,
        uint256 tInPrecision,
        uint256[] memory options
    ) internal view {
        // now <= start timestamp < end timestamp
        require(startTimestamp >= now, "validateParams: start in the past");
        // campaign duration must be at least min campaign duration
        // endTimestamp - startTimestamp + 1 >= minCampaignDurationInSeconds,
        require(
            endTimestamp.add(1) >= startTimestamp.add(minCampaignDurationInSeconds),
            "validateParams: campaign duration is low"
        );

        uint256 startEpoch = getEpochNumber(startTimestamp);
        uint256 endEpoch = getEpochNumber(endTimestamp);

        require(
            epochCampaigns[startEpoch].length < MAX_EPOCH_CAMPAIGNS,
            "validateParams: too many campaigns"
        );

        // start timestamp and end timestamp must be in the same epoch
        require(startEpoch == endEpoch, "validateParams: start & end not same epoch");

        uint256 currentEpoch = getCurrentEpochNumber();
        require(
            startEpoch <= currentEpoch.add(1),
            "validateParams: only for current or next epochs"
        );

        // verify number of options
        uint256 numOptions = options.length;
        require(
            numOptions > 1 && numOptions <= MAX_CAMPAIGN_OPTIONS,
            "validateParams: invalid number of options"
        );

        // Validate option values based on campaign type
        if (campaignType == CampaignType.General) {
            // option must be positive number
            for (uint256 i = 0; i < options.length; i++) {
                require(options[i] > 0, "validateParams: general campaign option is 0");
            }
        } else if (campaignType == CampaignType.NetworkFee) {
            require(
                networkFeeCampaigns[startEpoch] == 0,
                "validateParams: already had network fee campaign for this epoch"
            );
            // network fee campaign, option must be fee in bps
            for (uint256 i = 0; i < options.length; i++) {
                // in Network, maximum fee that can be taken from 1 tx is (platform fee + 2 * network fee)
                // so network fee should be less than 50%
                require(
                    options[i] < BPS / 2,
                    "validateParams: network fee must be smaller then BPS / 2"
                );
            }
        } else {
            require(
                brrCampaigns[startEpoch] == 0,
                "validateParams: already had brr campaign for this epoch"
            );
            // brr fee handler campaign, option must be combined for reward + rebate %
            for (uint256 i = 0; i < options.length; i++) {
                // rebate (left most 128 bits) + reward (right most 128 bits)
                (uint256 rebateInBps, uint256 rewardInBps) =
                    getRebateAndRewardFromData(options[i]);
                require(
                    rewardInBps.add(rebateInBps) <= BPS,
                    "validateParams: rebate + reward can't be bigger than BPS"
                );
            }
        }

        // percentage should be smaller than or equal 100%
        require(minPercentageInPrecision <= PRECISION, "validateParams: min percentage is high");

        // limit value of c and t to avoid overflow
        require(cInPrecision < POWER_128, "validateParams: c is high");

        require(tInPrecision < POWER_128, "validateParams: t is high");
    }

    /**
     * @dev  return staker's reward percentage in precision for an epoch
     *       return 0 if staker has no votes or stakes
     *       called by 2 functions in KyberDao
     */
    function getRewardPercentageInPrecision(address staker, uint256 epoch)
        internal
        view
        returns (uint256)
    {
        uint256 numVotes = numberVotes[staker][epoch];
        // no votes, no rewards
        if (numVotes == 0) {
            return 0;
        }

        (uint256 stake, uint256 delegatedStake, address representative) =
            staking.getStakerRawData(staker, epoch);

        uint256 totalStake = representative == staker ? stake.add(delegatedStake) : delegatedStake;
        if (totalStake == 0) {
            return 0;
        }

        uint256 points = numVotes.mul(totalStake);
        uint256 totalPts = totalEpochPoints[epoch];

        // staker's reward percentage should be <= 100%
        assert(points <= totalPts);

        return points.mul(PRECISION).div(totalPts);
    }
}