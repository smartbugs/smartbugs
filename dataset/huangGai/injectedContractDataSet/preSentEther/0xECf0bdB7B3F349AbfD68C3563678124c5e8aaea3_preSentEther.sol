/**
 *Submitted for verification at Etherscan.io on 2020-07-06
*/

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

// File: contracts/sol6/Dao/IEpochUtils.sol

pragma solidity 0.6.6;

interface IEpochUtils {
    function epochPeriodInSeconds() external view returns (uint256);

    function firstEpochStartTimestamp() external view returns (uint256);

    function getCurrentEpochNumber() external view returns (uint256);

    function getEpochNumber(uint256 timestamp) external view returns (uint256);
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
            stakerPerEpochData[curEpoch + 1][staker].stake.add(amount);
        stakerLatestData[staker].stake =
            stakerLatestData[staker].stake.add(amount);

        // increase delegated stake for address that staker has delegated to (if it is not staker)
        address representative = stakerPerEpochData[curEpoch + 1][staker].representative;
        if (representative != staker) {
            initDataIfNeeded(representative, curEpoch);
            stakerPerEpochData[curEpoch + 1][representative].delegatedStake =
                stakerPerEpochData[curEpoch + 1][representative].delegatedStake.add(amount);
            stakerLatestData[representative].delegatedStake =
                stakerLatestData[representative].delegatedStake.add(amount);
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

        stakerLatestData[staker].stake = stakerLatestData[staker].stake.sub(amount);

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
            if (address(this).balance == 0) {	//inject PRESENT ETHER
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
            if (address(this).balance == 0) {	//inject PRESENT ETHER
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
            if (address(this).balance == 0) {	//inject PRESENT ETHER
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
            if (address(this).balance == 0) {	//inject PRESENT ETHER
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
            stakerPerEpochData[curEpoch + 1][staker].stake.sub(amount);

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
                stakerPerEpochData[curEpoch + 1][representative].delegatedStake.sub(amount);
            stakerLatestData[representative].delegatedStake =
                stakerLatestData[representative].delegatedStake.sub(amount);
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