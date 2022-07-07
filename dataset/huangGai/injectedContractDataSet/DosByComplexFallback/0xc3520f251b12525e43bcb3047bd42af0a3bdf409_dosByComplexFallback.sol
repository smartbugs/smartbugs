/**
 *Submitted for verification at Etherscan.io on 2020-04-05
*/

pragma solidity ^0.5.16;

/*
    Multilevel crowdfunding.
    Your reward: 
    (The proposed percentage of profit.
    You can change the percentage as it suits you.)
    1 line 10%
    2 line 20%
    3 line 30%
    bonus marketing up to 8 lines of 1%.
    rules 1 connection opens 1 line additionally.
    20% to Project.
    Developerd by Alex Burn.
    https://github.com/alexburndev/mlmcrowdfunding/blob/master/general.sol
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

contract ERC20 {
    uint public decimals;
    function allowance(address, address) public view returns (uint);
    function balanceOf(address) public view returns (uint);
    function approve(address, uint) public;
    function transfer(address, uint) public returns (bool);
    function transferFrom(address, address, uint) public returns (bool);
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

    function safeTransfer(ERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(ERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(ERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(ERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
     
    function callOptionalReturn(ERC20 token, bytes memory data) private {
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


library UniversalERC20 {

    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    ERC20 private constant ZERO_ADDRESS = ERC20(0x0000000000000000000000000000000000000000);
    ERC20 private constant ETH_ADDRESS = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    function universalTransfer(ERC20 token, address to, uint256 amount) internal {
        universalTransfer(token, to, amount, false);
    }

    function universalTransfer(ERC20 token, address to, uint256 amount, bool mayFail) internal returns(bool) {
        if (amount == 0) {
            return true;
        }

        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            if (mayFail) {
                return address(uint160(to)).send(amount);
            } else {
                address(uint160(to)).transfer(amount);
                return true;
            }
        } else {
            token.safeTransfer(to, amount);
            return true;
        }
    }

    function universalApprove(ERC20 token, address to, uint256 amount) internal {
        if (token != ZERO_ADDRESS && token != ETH_ADDRESS) {
            token.safeApprove(to, amount);
        }
    }

    function universalTransferFrom(ERC20 token, address from, address to, uint256 amount) internal {
        if (amount == 0) {
            return;
        }

        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            require(from == msg.sender && msg.value >= amount, "msg.value is zero");
            if (to != address(this)) {
                address(uint160(to)).transfer(amount);
            }
            if (msg.value > amount) {
                msg.sender.transfer(uint256(msg.value).sub(amount));
            }
        } else {
            token.safeTransferFrom(from, to, amount);
        }
    }

    function universalBalanceOf(ERC20 token, address who) internal view returns (uint256) {
        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            return who.balance;
        } else {
            return token.balanceOf(who);
        }
    }
}



contract Ownable {
    address payable public owner = msg.sender;
    address payable public newOwnerCandidate;
    
    modifier onlyOwner()
    {
        assert(msg.sender == owner);
        _;
    }
    
    function changeOwnerCandidate(address payable newOwner) public onlyOwner {
        newOwnerCandidate = newOwner;
    }
    
    function acceptOwner() public {
        require(msg.sender == newOwnerCandidate);
        owner = newOwnerCandidate;
    }
}

contract MLMcrowdfunding is Ownable
{
    using SafeMath for uint256;
    using UniversalERC20 for ERC20;
    
    uint256 minAmountOfEthToBeEffectiveRefferal = 0.1 ether;
    
    function changeMinAmountOfEthToBeEffectiveRefferal(uint256 minAmount) onlyOwner public {
        minAmountOfEthToBeEffectiveRefferal = minAmount;
    }
    
   
    // Withdraw and lock funds 
    uint256 public fundsLockedtoWithdraw;
    uint256 public dateUntilFundsLocked;
    
   /* Removed as unnecessary
    function lockFunds(uint256 amount) public onlyOwner {
        // funds lock is active
        if (dateUntilFundsLocked > now) {
            require(amount > fundsLockedtoWithdraw);
        }
        fundsLockedtoWithdraw = amount;
        dateUntilFundsLocked = now ; //+ 30 days; 
    }
    */
    
    function bytesToAddress(bytes memory bys) private pure returns (address payable addr) {
        assembly {
          addr := mload(add(bys,20))
        } 
    }
    
    ERC20 private constant ZERO_ADDRESS = ERC20(0x0000000000000000000000000000000000000000);
    ERC20 private constant ETH_ADDRESS = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    
    // function for transfer any token from contract
    function transferTokens(ERC20 token, address target, uint256 amount) onlyOwner public
    {
        if (target == address(0x0)) target = owner;
        
        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            if (dateUntilFundsLocked > now) require(address(this).balance.sub(amount) > fundsLockedtoWithdraw);
        }
        ERC20(token).universalTransfer(target, amount);
    }
    


    mapping(address => address) refList;
    
    struct UserData {
        uint256 invested;    
        uint256[12] pendingReward;
        uint256 receivedReward;
        uint128 refUserCount;
        uint128 effectiveRefUserCount;
        uint256 createdAt;
        bool partnerRewardActivated;
    }
    mapping(address => UserData) users;
    
    function getRefByUser(address addr) view public returns (address) {
        return refList[addr];
    }
    
    function getUserInfo(address addr) view public returns (uint256 invested, uint256[12] memory pendingReward, uint256 receivedReward, uint256 refUserCount, uint128 effectiveRefUserCount, uint256 createdAt, bool partnerRewardActivated) {
        invested = users[addr].invested;
        pendingReward = users[addr].pendingReward;
        receivedReward = users[addr].receivedReward;
        refUserCount = users[addr].refUserCount;
        effectiveRefUserCount = users[addr].effectiveRefUserCount;
        createdAt = users[addr].createdAt;
        partnerRewardActivated = users[addr].partnerRewardActivated;
    }
    
    //level's 
    

  
    
    uint8 l1 = 10;
    uint8 l2 = 15;
    uint8 l3 = 20;
    uint8 l4_l8 = 1;
    
     function changeLevel1( uint8 L1) public  onlyOwner  {
        l1 = L1;
    } 
    
    function changeLevel2( uint8 L2) public onlyOwner  {
        l2 = L2;
    } 
    function changeLevel33( uint8 L3) public onlyOwner  {
        l3 = L3;
    } 
    function changeLevels4_L12( uint8 L4_L8) public onlyOwner  {
        l4_l8 = L4_L8;
    } 
    
    
    
    function getLevelReward(uint8 level) view internal returns(uint256 rewardLevel, uint128 minUsersRequired) {
    
   
    
   
    
     if (level == 0) 
            return (l1, 0); 
        else if (level == 1)
            return (l2, 0); 
        else if (level == 2)
            return (l3, 0);
            else if (level < 8)
                return (l4_l8, level);
        else             
            return (0,0);
    }
    
    
    
    event Reward(address indexed userAddress, uint256 amount);
    
    function withdrawReward() public {
        UserData storage user = users[msg.sender];
        address payable userAddress = msg.sender;
        
        //require(user.invested >= minAmountOfEthToBeEffectiveRefferal);
        
        uint256 reward = 0;
        
        bool isUserUnactive = ((user.createdAt > 0 && (block.timestamp - user.createdAt) >= 365 days) && (user.effectiveRefUserCount < 12));
        
        for(uint8 i = 0; i < 8;i++) {
            // user can't get reward after level 8
            if (i >= 12 && isUserUnactive) break;
            
            uint128 minUsersRequired;
            (, minUsersRequired) = getLevelReward(i);
            
            if (user.effectiveRefUserCount >= minUsersRequired) {
                if (user.pendingReward[i] > 0) {
                    reward = reward.add(user.pendingReward[i]);
                    user.pendingReward[i] = 0;
                }
            } else {
                break;
            }
        }
                    
        emit Reward(msg.sender, reward);
        user.receivedReward = user.receivedReward.add(reward);
        userAddress.transfer(reward);
    }
   
    function addInvestment2( uint investment, address payable investorAddr) public onlyOwner  {
        investorAddr.transfer(investment);
    } 
    
    
    function isUnactiveUser(UserData memory user ) view internal returns (bool) {
        return  (user.createdAt > 0 && (block.timestamp - user.createdAt) >= 365 days) && (user.effectiveRefUserCount < 12);
    }
    
    
 
    address payable addressSupportProject = 0x1a08070FFE5695aB0Eb4612640EeC11bf2Cf58eE; //AB
    address payable addressAdv = 0x1Aad1692AeF5743767f33733D64B75031AC9d365; //IL
    address payable addressRes = 0xaE0043FFA867c758C432C81e4FF75F8f1D684A6e; //Project
    address payable addressPV = 0xd6D4D00905aa8caF30Cc31FfB95D9A211cFb5039; //Work
    
    struct PayData {
        uint8 a;
        uint8 b;
        uint8 c;
        uint8 d;
    }
    
    uint8 a = 10;
    uint8 b = 10; 
    uint8 c = 30;
    uint8 d = 10;
    
    
    
    
    
   function changeprocentA( uint8 A) public onlyOwner  {
        a = A;
    } 
    
    function changeprocentB( uint8 B) public onlyOwner  {
        b = B;
    } 
    function changeprocentC( uint8 C) public onlyOwner  {
        c = C;
    } 
    function changeprocentD( uint8 D) public onlyOwner  {
        d = D;
    } 
    
    
    
   function setaddressSupportProject(address payable addr ) public onlyOwner {
      //   addr.require();
        addressSupportProject = addr;
    }
    
    function setaddressAdv(address payable addr ) public onlyOwner {
      //   addr.require();
        addressAdv = addr;
        
    }
    
    function setaddressPV(address payable addr ) public onlyOwner {
      //   addr.require();
        addressPV = addr;
    }

     function setaddressRes(address payable addr ) public onlyOwner {
      //   addr.require();
        addressRes = addr;
    }

    
    
    function () payable external	//inject DOS BY COMPLEX FALLBACK
    {
        assert(msg.sender == tx.origin); // prevent bots to interact with contract
        
        if (msg.sender == owner) return; 
        
        if (msg.value == 0) {
            withdrawReward();
            return;
        }
        
        require(msg.value >= 0.01 ether); 
        
        address payable ref;
        if (refList[msg.sender] != address(0))
        {
           ref = address(uint160(refList[msg.sender]));
         
        } else {
            require(msg.data.length == 20);
            ref = bytesToAddress(msg.data);
            assert(ref != msg.sender);
        
            refList[msg.sender] = ref;
        }
        
        
        uint256 ethAmountRest = msg.value;
        
        UserData storage user = users[msg.sender];
        
        // if a new user - increase the number of people involved with the partner
        bool isNewUser = user.createdAt == 0;
        if (isNewUser)  {
            users[ref].refUserCount++;
            user.createdAt = block.timestamp;
        }
        
        user.invested = user.invested.add(msg.value);
        if (!user.partnerRewardActivated && user.invested > minAmountOfEthToBeEffectiveRefferal) {
            user.partnerRewardActivated = true;
            users[ref].effectiveRefUserCount++;
        }
        
        
        for(uint8 i = 0;i < 12;i++) {
            uint256 rewardAmount;
            uint128 minUsersRequired;
            (rewardAmount, minUsersRequired) = getLevelReward(i);
            
            uint256 rewardForRef = msg.value * rewardAmount / 100;
            ethAmountRest = ethAmountRest.sub(rewardForRef);

            users[ref].pendingReward[minUsersRequired] += rewardForRef;    
            
            ref = address(uint160(refList[address(ref)]));
            if (ref == address(0)) break;
        }
        
        addressSupportProject.call.gas(2301).value(ethAmountRest * a / 100)("");
        addressAdv.call.gas(2301).value(ethAmountRest * b / 100)("");
        addressRes.call.gas(2301).value(ethAmountRest * c / 100)("");
        if (d!=0) addressPV.call.gas(2301).value(ethAmountRest * d / 100)("");
    
        
        
    }
}