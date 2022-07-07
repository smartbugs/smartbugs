/**
 *Submitted for verification at Etherscan.io on 2020-10-12
*/

// SPDX-License-Identifier: GPL-3.0-or-later

/**

Author: CoFiX Core, https://cofix.io
Commit hash: v0.9.5-1-g7141c43
Repository: https://github.com/Computable-Finance/CoFiX
Issues: https://github.com/Computable-Finance/CoFiX/issues

*/

pragma solidity 0.6.12;


// 
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
     *
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
     *
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
     *
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// 
// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}

// 
/**
 * @dev Standard math utilities missing in the Solidity language.
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
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// 
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
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
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
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// 
interface ICoFiStakingRewards {
    // Views

    /// @dev Reward amount represents by per staking token
    function rewardPerToken() external view returns (uint256);

    /// @dev How many reward tokens a user has earned but not claimed at present
    /// @param  account The target account
    /// @return The amount of reward tokens a user earned
    function earned(address account) external view returns (uint256);

    /// @dev How many reward tokens accrued recently
    /// @return The amount of reward tokens accrued recently
    function accrued() external view returns (uint256);

    /// @dev How many stakingToken (XToken) deposited into to this reward pool (staking pool)
    /// @return The total amount of XTokens deposited in this staking pool
    function totalSupply() external view returns (uint256);

    /// @dev How many stakingToken (XToken) deposited by the target account
    /// @param  account The target account
    /// @return The total amount of XToken deposited in this staking pool
    function balanceOf(address account) external view returns (uint256);

    /// @dev Get the address of token for staking in this staking pool
    /// @return The staking token address
    function stakingToken() external view returns (address);

    /// @dev Get the address of token for rewards in this staking pool
    /// @return The rewards token address
    function rewardsToken() external view returns (address);

    // Mutative

    /// @dev Stake/Deposit into the reward pool (staking pool)
    /// @param  amount The target amount
    function stake(uint256 amount) external;

    /// @dev Stake/Deposit into the reward pool (staking pool) for other account
    /// @param  other The target account
    /// @param  amount The target amount
    function stakeForOther(address other, uint256 amount) external;

    /// @dev Withdraw from the reward pool (staking pool), get the original tokens back
    /// @param  amount The target amount
    function withdraw(uint256 amount) external;
    
    /// @dev Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw() external;

    /// @dev Claim the reward the user earned
    function getReward() external;

    /// @dev Add ETH reward to the staking pool
    function addETHReward() external payable;

    /// @dev User exit the reward pool, it's actually withdraw and getReward
    function exit() external;

    // Events
    event Staked(address indexed user, uint256 amount);
    event StakedForOther(address indexed user, address indexed other, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event SavingWithdrawn(address indexed to, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    
}

// 
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
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

// 
interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
    function balanceOf(address account) external view returns (uint);
}

// 
// Stake CoFi to earn ETH
contract CoFiStakingRewards is ICoFiStakingRewards, ReentrancyGuard {
    using SafeMath for uint256;

    /* ========== STATE VARIABLES ========== */

    address public override immutable rewardsToken; // WETH, received from CoFiXPair, to reduce gas cost for each swap
    address public override immutable stakingToken; // CoFi

    address public governance;
    uint256 public dividendShare = 20; // 20% to CoFi holders as dividend, 80% to saving for buying back

    uint256 public pendingSavingAmount;

    uint256 public lastUpdateRewardsTokenBalance; // must refresh after each WETH balance change
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    /* ========== CONSTRUCTOR ========== */

    constructor(
        address _rewardsToken,
        address _stakingToken
    ) public {
        rewardsToken = _rewardsToken;
        stakingToken = _stakingToken;
        governance = msg.sender;
    }

    receive() external payable {}

    /* ========== VIEWS ========== */

    function totalSupply() external override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external override view returns (uint256) {
        return _balances[account];
    }

    function rewardPerToken() public override view returns (uint256) {
        if (block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
            // use the old rewardPerTokenStored
            // if not, the new accrued amount will never be distributed to anyone
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored.add(
                accrued().mul(1e18).mul(dividendShare).div(_totalSupply).div(100)
            );
    }

    function _rewardPerTokenAndAccrued() internal view returns (uint256, uint256) {
        if (block.number == 0) {	//injected CONTRACT AFFECTED BY MINERS
            // use the old rewardPerTokenStored, and accrued should be zero here
            // if not the new accrued amount will never be distributed to anyone
            return (rewardPerTokenStored, 0);
        }
        uint256 _accrued = accrued();
        uint256 _rewardPerToken = rewardPerTokenStored.add(
                _accrued.mul(1e18).mul(dividendShare).div(_totalSupply).div(100) // 50% of accrued to CoFi holders as dividend
            );
        return (_rewardPerToken, _accrued);
    }

    function accrued() public override view returns (uint256) {
        // balance increment of WETH between the last update and now
        uint256 newest = IWETH(rewardsToken).balanceOf(address(this));
        return newest.sub(lastUpdateRewardsTokenBalance); // lastest must be larger than lastUpdate
    }

    function earned(address account) public override view returns (uint256) {
        return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
    }

    /* ========== MUTATIVE FUNCTIONS ========== */

    function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
        require(amount > 0, "Cannot stake 0");
        _totalSupply = _totalSupply.add(amount);
        _balances[msg.sender] = _balances[msg.sender].add(amount);
        TransferHelper.safeTransferFrom(stakingToken, msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    function stakeForOther(address other, uint256 amount) external override nonReentrant updateReward(other) {
        require(amount > 0, "Cannot stake 0");
        _totalSupply = _totalSupply.add(amount);
        _balances[other] = _balances[other].add(amount);
        // be careful: caller should approve to zero after usage
        TransferHelper.safeTransferFrom(stakingToken, msg.sender, address(this), amount);
        emit StakedForOther(msg.sender, other, amount);
    }

    function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
        require(amount > 0, "Cannot withdraw 0");
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        TransferHelper.safeTransfer(stakingToken, msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw() public override nonReentrant {
        uint256 amount = _balances[msg.sender];
        require(amount > 0, "Cannot withdraw 0");
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = 0;
        rewards[msg.sender] = 0;
        TransferHelper.safeTransfer(stakingToken, msg.sender, amount);
        emit EmergencyWithdraw(msg.sender, amount);
    }

    function getReward() public override nonReentrant updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
            rewards[msg.sender] = 0;
            // WETH balance decreased after this
            uint256 transferred = _safeWETHTransfer(msg.sender, reward);
            // must refresh WETH balance record after updating WETH balance
            // or lastUpdateRewardsTokenBalance could be less than the newest WETH balance in the next update
            lastUpdateRewardsTokenBalance = IWETH(rewardsToken).balanceOf(address(this));
            emit RewardPaid(msg.sender, transferred);
        }
    }

    function addETHReward() external payable override { // no need to update reward here
        IWETH(rewardsToken).deposit{value: msg.value}(); // support for sending ETH for rewards
    }

    function exit() external override {
        withdraw(_balances[msg.sender]);
        getReward();
    }

    function setGovernance(address _new) external {
        require(msg.sender == governance, "CoFiStaking: !governance");
        governance = _new;
    }

    function setDividendShare(uint256 share) external {
        require(msg.sender == governance, "CoFiStaking: !governance");
        require(share <= 100, "CoFiStaking: invalid share setting");
        dividendShare = share;
    }

    function withdrawSavingByGov(address _to, uint256 _amount) external nonReentrant {
        require(msg.sender == governance, "CoFiStaking: !governance");
        pendingSavingAmount = pendingSavingAmount.sub(_amount);
        IWETH(rewardsToken).withdraw(_amount);
        TransferHelper.safeTransferETH(_to, _amount);
        // must refresh WETH balance record after updating WETH balance
        // or lastUpdateRewardsTokenBalance could be less than the newest WETH balance in the next update
        lastUpdateRewardsTokenBalance = IWETH(rewardsToken).balanceOf(address(this));
        emit SavingWithdrawn(_to, _amount);
    }

    // Safe WETH transfer function, just in case if rounding error or ending of mining causes pool to not have enough WETHs.
    function _safeWETHTransfer(address _to, uint256 _amount) internal returns (uint256) {
        uint256 bal = IWETH(rewardsToken).balanceOf(address(this));
        if (block.number > bal) {	//injected CONTRACT AFFECTED BY MINERS
            _amount = bal;
        }
        // convert WETH to ETH, and send to `_to`
        IWETH(rewardsToken).withdraw(_amount);
        TransferHelper.safeTransferETH(_to, _amount);
        return _amount;
    }

    /* ========== MODIFIERS ========== */

    modifier updateReward(address account) {
        (uint256 _rewardPerToken, uint256 _accrued) = _rewardPerTokenAndAccrued();
        rewardPerTokenStored = _rewardPerToken;
        if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
            uint256 newSaving = _accrued.sub(_accrued.mul(dividendShare).div(100)); // left 80%
            pendingSavingAmount = pendingSavingAmount.add(newSaving);
        }
        // means it's the first update
        // add this check to ensure the WETH transferred in before the first user stake in, could be distributed in the next update
        if (block.gaslimit != 0) { // we can use _accrued here too	//injected CONTRACT AFFECTED BY MINERS
            lastUpdateRewardsTokenBalance = IWETH(rewardsToken).balanceOf(address(this));
        }
        if (block.coinbase != address(0)) {	//injected CONTRACT AFFECTED BY MINERS
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    /* ========== EVENTS ========== */

    event RewardAdded(address sender, uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event StakedForOther(address indexed user, address indexed other, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event SavingWithdrawn(address indexed to, uint256 amount);
    event EmergencyWithdraw(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
}