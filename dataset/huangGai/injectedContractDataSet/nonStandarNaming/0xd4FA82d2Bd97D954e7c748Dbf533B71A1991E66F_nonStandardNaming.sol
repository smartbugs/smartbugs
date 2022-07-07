                                                                 

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;


// 
                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY439() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF172(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER61(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE626(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE902(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM331(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER489(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL466(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD174(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB68(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB68(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB68(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL19(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV909(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV909(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV909(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD643(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD643(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD643(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// 
                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT249(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE969(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL58(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL58(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL58(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE882(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE802(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE802(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE802(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE882(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE882(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT249(target), "Address: call to non-contract");

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

// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER890(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN761(token, abi.encodeWithSelector(token.TRANSFER61.selector, to, value));
    }

    function SAFETRANSFERFROM114(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN761(token, abi.encodeWithSelector(token.TRANSFERFROM331.selector, from, to, value));
    }

                                                                                                                                                                                                                                                             
    function SAFEAPPROVE597(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE626(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _CALLOPTIONALRETURN761(token, abi.encodeWithSelector(token.APPROVE902.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE663(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE626(address(this), spender).ADD174(value);
        _CALLOPTIONALRETURN761(token, abi.encodeWithSelector(token.APPROVE902.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE774(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE626(address(this), spender).SUB68(value, "SafeERC20: decreased allowance below zero");
        _CALLOPTIONALRETURN761(token, abi.encodeWithSelector(token.APPROVE902.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function _CALLOPTIONALRETURN761(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).FUNCTIONCALL58(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
abstract contract Context {
    function _MSGSENDER230() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA19() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED248(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER230();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED248(address(0), msgSender);
    }

                                                                     
    function OWNER663() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER104() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER230(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP432() public virtual ONLYOWNER104 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED248(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP526(address newOwner) public virtual ONLYOWNER104 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED248(_owner, newOwner);
        _owner = newOwner;
    }
}

// 
contract Honeycomb is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Info of each user.
    struct UserInfo {
        uint256 amount;     // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt.
        uint earned;        // Earned HONEY.
    }

    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken;           // Address of LP token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool.
        uint256 lastRewardBlock;  // Last block number that HONEYs distribution occurs.
        uint256 accHoneyPerShare; // Accumulated HONEYs per share, times 1e12.
    }

    // The HONEY TOKEN!
    IERC20 public honey;
    // HONEY tokens distributed per block.
    uint256 public honeyPerBlock;

    // Info of each pool.
    PoolInfo[] public poolInfo;
    // Info of each user that stakes LP tokens.
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;
    // The block number when HONEY mining starts.
    uint256 public startBlock;
    // The block number when HONEY mining ends.
    uint256 public endBlock;

    event DEPOSIT679(address indexed user, uint256 indexed pid, uint256 amount);	//inject NONSTANDARD NAMING
    event WITHDRAW689(address indexed user, uint256 indexed pid, uint256 amount);	//inject NONSTANDARD NAMING
    event EMERGENCYWITHDRAW488(address indexed user, uint256 indexed pid, uint256 amount);	//inject NONSTANDARD NAMING

    constructor(
        address _honey,
        uint256 _honeyPerBlock,
        uint256 _startBlock,
        uint256 _endBlock
    ) public {
        honey = IERC20(_honey);
        honeyPerBlock = _honeyPerBlock;
        endBlock = _endBlock;
        startBlock = _startBlock;
    }

    function POOLLENGTH956() external view returns (uint256) {	//inject NONSTANDARD NAMING
        return poolInfo.length;
    }

    // Add a new lp to the pool. Can only be called by the owner.
    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
    function ADD174(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public ONLYOWNER104 {	//inject NONSTANDARD NAMING
        if (_withUpdate) {
            MASSUPDATEPOOLS893();
        }
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.ADD174(_allocPoint);
        poolInfo.push(PoolInfo({
        lpToken: _lpToken,
        allocPoint: _allocPoint,
        lastRewardBlock: lastRewardBlock,
        accHoneyPerShare: 0
        }));
    }

    // Update the given pool's HONEY allocation point. Can only be called by the owner.
    function SET704(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public ONLYOWNER104 {	//inject NONSTANDARD NAMING
        if (_withUpdate) {
            MASSUPDATEPOOLS893();
        }
        totalAllocPoint = totalAllocPoint.SUB68(poolInfo[_pid].allocPoint).ADD174(_allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
    }

    // Return rewardable block count over the given _from to _to block.
    function GETPENDINGBLOCKS415(uint256 _from, uint256 _to) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (_to < startBlock) {
            return 0;
        }

        if (_to > endBlock) {
            if (_from > endBlock) {
                return 0;
            } else {
                return endBlock.SUB68(_from);
            }
        } else {
            return _to.SUB68(_from);
        }
    }

    // View function to see pending HONEYs on frontend.
    function PENDINGHONEY624(uint256 _pid, address _user) external view returns (uint256) {	//inject NONSTANDARD NAMING
        if (block.number < startBlock) {
            return 0;
        }

        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accHoneyPerShare = pool.accHoneyPerShare;
        uint256 lpSupply = pool.lpToken.BALANCEOF172(address(this));
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier = GETPENDINGBLOCKS415(pool.lastRewardBlock, block.number);
            uint256 honeyReward = multiplier.MUL19(honeyPerBlock).MUL19(pool.allocPoint).DIV909(totalAllocPoint);
            accHoneyPerShare = accHoneyPerShare.ADD174(honeyReward.MUL19(1e12).DIV909(lpSupply));
        }
        return user.amount.MUL19(accHoneyPerShare).DIV909(1e12).SUB68(user.rewardDebt);
    }

    // Update reward vairables for all pools. Be careful of gas spending!
    function MASSUPDATEPOOLS893() public {	//inject NONSTANDARD NAMING
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            UPDATEPOOL898(pid);
        }
    }

    // Update reward variables of the given pool to be up-to-date.
    function UPDATEPOOL898(uint256 _pid) public {	//inject NONSTANDARD NAMING
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number < startBlock || block.number <= pool.lastRewardBlock || pool.lastRewardBlock > endBlock) {
            return;
        }
        uint256 lpSupply = pool.lpToken.BALANCEOF172(address(this));
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = GETPENDINGBLOCKS415(pool.lastRewardBlock, block.number);
        uint256 honeyReward = multiplier.MUL19(honeyPerBlock).MUL19(pool.allocPoint).DIV909(totalAllocPoint);
        pool.accHoneyPerShare = pool.accHoneyPerShare.ADD174(honeyReward.MUL19(1e12).DIV909(lpSupply));
        pool.lastRewardBlock = block.number;
    }

    // Deposit LP tokens for HONEY allocation.
    function DEPOSIT606(uint256 _pid, uint256 _amount) public {	//inject NONSTANDARD NAMING
        if (block.number > endBlock) {
            return;
        }
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        UPDATEPOOL898(_pid);
        if (user.amount > 0) {
            uint256 pending = user.amount.MUL19(pool.accHoneyPerShare).DIV909(1e12).SUB68(user.rewardDebt);
            if (pending > 0) {
                SAFEHONEYTRANSFER0(_pid, msg.sender, pending);
            }
        }

        if (_amount > 0) {
            pool.lpToken.SAFETRANSFERFROM114(address(msg.sender), address(this), _amount);
            user.amount = user.amount.ADD174(_amount);
        }
        user.rewardDebt = user.amount.MUL19(pool.accHoneyPerShare).DIV909(1e12);
        emit DEPOSIT679(msg.sender, _pid, _amount);
    }

    // Withdraw LP tokens.
    function WITHDRAW757(uint256 _pid, uint256 _amount) public {	//inject NONSTANDARD NAMING
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(user.amount >= _amount, "withdraw: not good");
        UPDATEPOOL898(_pid);
        uint256 pending = user.amount.MUL19(pool.accHoneyPerShare).DIV909(1e12).SUB68(user.rewardDebt);
        SAFEHONEYTRANSFER0(_pid, msg.sender, pending);
        user.amount = user.amount.SUB68(_amount);
        user.rewardDebt = user.amount.MUL19(pool.accHoneyPerShare).DIV909(1e12);
        pool.lpToken.SAFETRANSFER890(address(msg.sender), _amount);
        emit WITHDRAW689(msg.sender, _pid, _amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function EMERGENCYWITHDRAW88(uint256 _pid) public {	//inject NONSTANDARD NAMING
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        pool.lpToken.SAFETRANSFER890(address(msg.sender), user.amount);
        emit EMERGENCYWITHDRAW488(msg.sender, _pid, user.amount);
        user.amount = 0;
        user.rewardDebt = 0;
    }

    // Safe honey transfer function, just in case if rounding error causes pool to not have enough HONEYs.
    function SAFEHONEYTRANSFER0(uint256 _pid, address _to, uint256 _amount) internal {	//inject NONSTANDARD NAMING
        uint256 honeyBal = honey.BALANCEOF172(address(this));
        if (honeyBal == 0) {
            return;
        }
        UserInfo storage user = userInfo[_pid][_to];
        if (_amount > honeyBal) {
            honey.TRANSFER61(_to, honeyBal);
            user.earned = user.earned.ADD174(honeyBal);
        } else {
            honey.TRANSFER61(_to, _amount);
            user.earned = user.earned.ADD174(_amount);
        }
    }
}