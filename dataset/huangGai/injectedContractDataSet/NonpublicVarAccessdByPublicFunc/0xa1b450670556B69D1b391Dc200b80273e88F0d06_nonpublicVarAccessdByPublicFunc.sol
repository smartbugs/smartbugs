/**
 *Submitted for verification at Etherscan.io on 2020-09-30
*/

pragma solidity 0.5.16;


library Math {
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

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

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

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

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function mint(address account, uint amount) external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library Address {
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

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
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

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

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

/**
 * Reward Amount Interface
 */
contract IRewardDistributionRecipient is Ownable {
    address rewardDistribution;

    function notifyRewardAmount(uint256 reward) external;

    modifier onlyRewardDistribution() {
        require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
        _;
    }

    function setRewardDistribution(address _rewardDistribution)
        external
        onlyOwner
    {
        rewardDistribution = _rewardDistribution;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}

/**
 * Staking Token Wrapper
 */
pragma solidity 0.5.16;

contract GOFTokenWrapper {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    //GOF TOKEN 
    IERC20 internal gof = IERC20(0x488E0369f9BC5C40C002eA7c1fe4fd01A198801c);

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function stake(uint256 amount) public {
        _totalSupply = _totalSupply.add(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _balances[msg.sender] = _balances[msg.sender].add(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        gof.safeTransferFrom(msg.sender, address(this), amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function withdraw(uint256 amount) public {
        _totalSupply = _totalSupply.sub(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _balances[msg.sender] = _balances[msg.sender].sub(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        gof.safeTransfer(msg.sender, amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}

/**
 * GOF Pool
 */
contract GOFPool is GOFTokenWrapper, IRewardDistributionRecipient {

    uint256 internal constant DURATION = 7 days;
    uint256 internal constant FROZEN_STAKING_TIME = 24 hours;

    uint256 internal constant startTime = 1601467200; //utc+8 2020-09-30 20:00:00
    uint256 internal periodFinish = 0;
    uint256 internal rewardRate = 0;
    uint256 internal lastUpdateTime;
    uint256 internal rewardPerTokenStored = 0;
    bool private open = true;
    uint256 private constant _gunit = 1e18;
    mapping(address => uint256) internal userRewardPerTokenPaid; 
    mapping(address => uint256) internal rewards; // Unclaimed rewards

    mapping(address => uint256) internal lastStakeTimes;

    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event SetOpen(bool _open);

    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    function lastTimeRewardApplicable() public view returns (uint256) {
        return Math.min(block.timestamp, periodFinish);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * Calculate the rewards for each token
     */
    function rewardPerToken() public view returns (uint256) {
        if (totalSupply() == 0) {
            return rewardPerTokenStored;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        return
            rewardPerTokenStored.add(	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                lastTimeRewardApplicable()
                    .sub(lastUpdateTime)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    .mul(rewardRate)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    .mul(_gunit)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                    .div(totalSupply())
            );
    }

    function earned(address account) public view returns (uint256) {
        uint256 calculatedEarned = 
            balanceOf(account)
                .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                .div(_gunit)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                .add(rewards[account]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 poolBalance = gof.balanceOf(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (poolBalance < totalSupply()) return 0;
        if (calculatedEarned.add(totalSupply()) > poolBalance) return poolBalance.sub(totalSupply());
        return calculatedEarned;
    }

    function stake(uint256 amount) public checkOpen checkStart updateReward(msg.sender){ 
        require(amount > 0, "Golff-GOF-POOL: Cannot stake 0");
        super.stake(amount);
        lastStakeTimes[msg.sender] = block.timestamp;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Staked(msg.sender, amount);
    }

    function unfrozenStakeTime(address account) public view returns (uint256) {
        return lastStakeTimes[account] + FROZEN_STAKING_TIME;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function withdraw(uint256 amount) public checkStart updateReward(msg.sender){
        require(amount > 0, "Golff-GOF-POOL: Cannot withdraw 0");
        super.withdraw(amount);
        emit Withdrawn(msg.sender, amount);
    }

    function exit() external {
        withdraw(balanceOf(msg.sender));
        getReward();
    }

    function getReward() public checkStart updateReward(msg.sender){
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            rewards[msg.sender] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            gof.safeTransfer(msg.sender, reward);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            emit RewardPaid(msg.sender, reward);
        }
    }

    modifier checkStart(){
        require(block.timestamp > startTime,"Golff-GOF-POOL: not start");
        _;
    }

    modifier checkOpen() {
        require(open, "Golff-GOF-POOL: Pool is closed");
        _;
    }

    function getPeriodFinish() external view returns (uint256) {
        return periodFinish;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function isOpen() external view returns (bool) {
        return open;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setOpen(bool _open) external onlyOwner {
        open = _open;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit SetOpen(_open);
    }

    function notifyRewardAmount(uint256 reward)
        external
        onlyRewardDistribution
        checkOpen
        updateReward(address(0)) {
        if (block.timestamp > startTime){	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if (block.timestamp >= periodFinish) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                uint256 period = block.timestamp.sub(startTime).div(DURATION).add(1);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                periodFinish = startTime.add(period.mul(DURATION));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                rewardRate = reward.div(periodFinish.sub(block.timestamp));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            } else {
                uint256 remaining = periodFinish.sub(block.timestamp);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                uint256 leftover = remaining.mul(rewardRate);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                rewardRate = reward.add(leftover).div(remaining);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
            lastUpdateTime = block.timestamp;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }else {
          uint256 b = gof.balanceOf(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
          rewardRate = reward.add(b).div(DURATION);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
          periodFinish = startTime.add(DURATION);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
          lastUpdateTime = startTime;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }

        gof.mint(address(this),reward);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit RewardAdded(reward);

        // avoid overflow to lock assets
        _checkRewardRate();
    }
    
    function _checkRewardRate() internal view returns (uint256) {
        return DURATION.mul(rewardRate).mul(_gunit);
    }
}