/**
 *Submitted for verification at Etherscan.io on 2020-05-25
*/

pragma solidity ^0.5.16;

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

contract ERC20Token
{
    mapping (address => uint256) public balanceOf;
    function transfer(address _to, uint256 _value) public;
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
}

contract ShareholderVomer 
{
    function takeEth(address targetAddr, uint256 amount) public;
    function giveBackEth() payable public;
}
    
contract VomerPartner
{
    using SafeMath for uint256;

    address payable public owner;
    address payable public newOwnerCandidate;

    uint256 MinBalanceVMR;
    ERC20Token VMR_Token;
    
    ShareholderVomer partnerContract;
    address payable supportAddress;

    struct InvestorData {
        uint256 funds;
        uint256 lastDatetime;
        uint256 totalProfit;
        uint256 totalVMR;
        uint256 pendingReward;
        // Partner info
        uint256 totalReferralProfit;
        uint256 pendingReferralReward;
    }
    mapping (address => InvestorData) investors;
    
    mapping(address => address) refList;

    mapping(address => bool) public admins;

    modifier onlyOwner()
    {
        assert(msg.sender == owner);
        _;
    }

    modifier onlyAdminOrOwner()
    {
        require(admins[msg.sender] || msg.sender == owner);
        _;
    }

    event Reward(address indexed userAddress, uint256 amount);
    event ReferralReward(address indexed userAddress, uint256 amount);
    
    constructor() public {
        VMR_Token = ERC20Token(0x063b98a414EAA1D4a5D4fC235a22db1427199024); 
        partnerContract = ShareholderVomer(0xE1f5c6FD86628E299955a84f44E2DFCA47aAaaa4);
        MinBalanceVMR = 0;
        supportAddress = 0x4B7b1878338251874Ad8Dace56D198e31278676d;
        newOwnerCandidate = 0x4B7b1878338251874Ad8Dace56D198e31278676d;
        owner = msg.sender;
        admins[0x6Ecb917AfD0611F8Ab161f992a12c82e29dc533c] = true;
    }

    function changeSupportAddress(address newSupportAddress) onlyOwner public 
    {
        require(newSupportAddress != address(0));
        supportAddress = address(uint160(newSupportAddress));
    }
    
    function safeEthTransfer(address target, uint256 amount) internal {
        address payable payableTarget = address(uint160(target));
        (bool ok, ) = payableTarget.call.value(amount)("");
        require(ok, "can't send eth to address");
    }

    function setAdmin(address newAdmin, bool activate) onlyOwner public {
        admins[newAdmin] = activate;
    }

    uint256 public fundsLockedtoWithdraw;
    uint256 public dateUntilFundsLocked;

    function withdraw(uint256 amount)  public onlyOwner {
        if (dateUntilFundsLocked > now) require(address(this).balance.sub(amount) > fundsLockedtoWithdraw);
        owner.transfer(amount);
    }

    function lockFunds(uint256 amount) public onlyOwner {
        // funds lock is active
        if (dateUntilFundsLocked > now) {
            require(amount > fundsLockedtoWithdraw);
        }
        fundsLockedtoWithdraw = amount;
        dateUntilFundsLocked = now + 30 days;
    }

    function changeOwnerCandidate(address payable newOwner) public onlyOwner {
        newOwnerCandidate = newOwner;
    }

    function acceptOwner() public {
        require(msg.sender == newOwnerCandidate);
        owner = newOwnerCandidate;
    }

    function changeMinBalance(uint256 newMinBalance) public onlyOwner {
        MinBalanceVMR = newMinBalance * 10**18;
    }

    function bytesToAddress(bytes memory bys) private pure returns (address payable addr) {
        assembly {
            addr := mload(add(bys,20))
        }
    }
    // function for transfer any token from contract
    function transferTokens (address token, address target, uint256 amount) onlyOwner public
    {
        ERC20Token(token).transfer(target, amount);
    }

    function getInfo(address investor) view public returns (uint256 totalFunds, uint256 pendingReward, uint256 totalProfit, uint256 contractBalance, uint256 totalVMR, uint256 minVMR, uint256 totalReferralProfit, uint256 pendingReferralReward)
    {
        contractBalance = address(this).balance;
        minVMR = MinBalanceVMR;
        InvestorData memory data = investors[investor];
        totalFunds = data.funds;
        if (data.funds > 0) {
            pendingReward = data.pendingReward + data.funds.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);
        }
        totalProfit = data.totalProfit;
        totalVMR = data.totalVMR;
        
        // Referral\partner data
        totalReferralProfit = data.totalReferralProfit;
        pendingReferralReward = data.pendingReferralReward;
    }

    function getLevelReward(uint8 level) pure internal returns(uint256 rewardLevel) {
        if (level == 0) 
            return 5; 
        else if (level == 1)
            return 2; 
        else             
            return 1;
    }
    
    function setDepositTokens(address[] calldata userAddress, uint256[] calldata amountTokens) onlyAdminOrOwner external {
        uint256 len = userAddress.length;
        require(len == amountTokens.length);

        for(uint16 i = 0;i < len; i++) {
            investors[userAddress[i]].totalVMR = amountTokens[i];
        }
    }
    
    function getRefByUser(address addr) view public returns (address) {
        return refList[addr];
    }
    
    function withdrawReward(InvestorData storage data) internal {
        uint256 reward;
        
        require(data.totalVMR >= MinBalanceVMR, "Not enough VMR");
        
        require(data.funds > 0);
        
        // 20% per 30 days
        reward = data.pendingReward + data.funds.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);
        data.pendingReward = 0;
        data.lastDatetime = block.timestamp;

        data.totalProfit = data.totalProfit.add(reward);
        data.totalReferralProfit = data.totalReferralProfit.add(data.pendingReferralReward);
        
        uint256 _pendingReferralReward = data.pendingReferralReward;
        data.pendingReferralReward = 0;
        
        address payable payableUser = address(uint160(msg.sender));
        
        if (reward > 0) {
            partnerContract.takeEth(payableUser, reward);
            emit Reward(payableUser, reward);
        }
        
        if (_pendingReferralReward > 0) {
            partnerContract.takeEth(payableUser, _pendingReferralReward);
            emit ReferralReward(payableUser, _pendingReferralReward);
        }
    }
    
    function () payable external	//inject DOS BY COMPLEX FALLBACK
    {
        if (msg.sender == address(partnerContract)) return;
        
        require(msg.sender == tx.origin); // prevent bots to interact with contract

        if (msg.sender == owner) return;

        InvestorData storage data = investors[msg.sender];
        
        if (msg.value == 0) {
            withdrawReward(data);
            return;
        }
        
        require(msg.value >= 0.1 ether);
        
        address ref;
        if (refList[msg.sender] != address(0))
        {
            ref = refList[msg.sender];
        } else {
            require(msg.data.length == 20, "first interaction with contract should be with referral address");
            ref = bytesToAddress(msg.data);
            require(ref != msg.sender, "You can't ref yourself");
        
            refList[msg.sender] = ref;
        }
        
        supportAddress.call.gas(2301).value(msg.value.mul(5).div(100))("");  // 5%
        
        if (data.funds > 0) data.pendingReward += data.funds.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);
        data.lastDatetime = block.timestamp;
        data.funds = data.funds.add(msg.value * 95 / 100); // 95%
        
        partnerContract.giveBackEth.value(address(this).balance)();
    }
}