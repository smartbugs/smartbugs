/**
 *Submitted for verification at Etherscan.io on 2020-06-12
*/

pragma solidity ^0.5.16;

/**
Get 20% profit every month with a contract Shareholder VOMER!
*
* - OBTAINING 20% PER 1 MONTH. (percentages are charged in equal parts every 1 sec)
* 0.6666% per 1 day
* 0.0275% per 1 hour
* 0.00045% per 1 minute
* 0.0000076% per 1 sec
* - lifetime payments
* - unprecedentedly reliable
* - bring luck
* - first minimum contribution from 2 eth, all next from 0.01 eth
* - Currency and Payment - ETH
* - Contribution allocation schemes:
* - 100% of payments - 5% percent for support and 25% percent referral system.
*
* VOMER.net
*
* RECOMMENDED GAS LIMIT: 200,000
* RECOMMENDED GAS PRICE: https://ethgasstation.info/
* DO NOT TRANSFER DIRECTLY FROM AN EXCHANGE (only use your ETH wallet, from which you have a private key)
* You can check payments on the website etherscan.io, in the 1Internal Txns1 tab of your wallet.
*
* Referral system 25%.
* Payments to developers 5%

* Restart of the contract is also absent. If there is no money in the Fund, payments are stopped and resumed after the Fund is filled. Thus, the contract will work forever!
*
* How to use:
* 1. Send from your ETH wallet to the address of the smart contract
* Any amount from 2.00 ETH.
* 2. Confirm your transaction in the history of your application or etherscan.io, indicating the address of your wallet.
* Take profit by sending 0 eth to contract (profit is calculated every second).
*
**/

/**
 * @title Initializable
 *
 * @dev Helper contract to support initializer functions. To use it, replace
 * the constructor with a function that has the `initializer` modifier.
 * WARNING: Unlike constructors, initializer functions must be manually
 * invoked. This applies both to deploying an Initializable contract, as well
 * as extending an Initializable contract via inheritance.
 * WARNING: When used with inheritance, manual care must be taken to not invoke
 * a parent initializer twice, or ensure that all initializers are idempotent,
 * because this is not dealt with automatically as with constructors.
 */
contract Initializable {

    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private initializing;

    /**
     * @dev Modifier to use in the initializer function of a contract.
     */
    modifier initializer() {
        require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

        bool isTopLevelCall = !initializing;
        if (isTopLevelCall) {
            initializing = true;
            initialized = true;
        }

        _;

        if (isTopLevelCall) {
            initializing = false;
        }
    }

    /// @dev Returns true if and only if the function is running in the constructor
    function isConstructor() private view returns (bool) {
        // extcodesize checks the size of the code stored in an address, and
        // address returns the current address. Since the code is still not
        // deployed when running a constructor, any checks on its code size will
        // yield zero, making it an effective way to detect if a contract is
        // under construction or not.
        address self = address(this);
        uint256 cs;
        assembly { cs := extcodesize(self) }
        return cs == 0;
    }

    // Reserved storage space to allow for layout changes in the future.
    uint256[50] private ______gap;
}

contract ERC20Token
{
    function decimals() external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function approve(address spender, uint value) external;
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

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

    uint256 constant WAD = 10 ** 18;

    function wdiv(uint x, uint y) internal pure returns (uint256 z) {
        z = add(mul(x, WAD), y / 2) / y;
    }

    function wmul(uint x, uint y) internal pure returns (uint256 z) {
        z = add(mul(x, y), WAD / 2) / WAD;
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

    function safeTransfer(ERC20Token token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(ERC20Token token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(ERC20Token token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(ERC20Token token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(ERC20Token token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(ERC20Token token, bytes memory data) private {
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
    using SafeERC20 for ERC20Token;

    ERC20Token private constant ZERO_ADDRESS = ERC20Token(0x0000000000000000000000000000000000000000);
    ERC20Token private constant ETH_ADDRESS = ERC20Token(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    function universalTransfer(ERC20Token token, address to, uint256 amount) internal {
        universalTransfer(token, to, amount, false);
    }

    function universalTransfer(ERC20Token token, address to, uint256 amount, bool mayFail) internal returns(bool) {
        if (amount == 0) {
            return true;
        }

        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            if (mayFail) {
                return address(uint160(to)).send(0);
            } else {
                address(uint160(to)).transfer(0);
                return true;
            }
        } else {
            token.safeTransfer(to, amount);
            return true;
        }
    }

    function universalApprove(ERC20Token token, address to, uint256 amount) internal {
        if (token != ZERO_ADDRESS && token != ETH_ADDRESS) {
            token.safeApprove(to, amount);
        }
    }

    function universalTransferFrom(ERC20Token token, address from, address to, uint256 amount) internal {
        if (amount == 0) {
            return;
        }

        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            require(from == msg.sender && msg.value >= amount, "msg.value is zero");
            if (to != address(this)) {
                address(uint160(to)).transfer(0);
            }
            if (msg.value > amount) {
                msg.sender.transfer(0);
            }
        } else {
            token.safeTransferFrom(from, to, amount);
        }
    }

    function universalBalanceOf(ERC20Token token, address who) internal view returns (uint256) {
        if (token == ZERO_ADDRESS || token == ETH_ADDRESS) {
            return who.balance;
        } else {
            return token.balanceOf(who);
        }
    }
}

contract OldShareholderVomer {
    function getInfo(address investor) view public returns (uint256 totalFunds, uint256 pendingReward, uint256 totalProfit, uint256 contractBalance);
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

contract ShareholderVomer is Initializable
{
    using SafeMath for uint256;
    using UniversalERC20 for ERC20Token;

    address payable public owner;
    address payable public newOwnerCandidate;

    uint256 MinBalanceVMR;
    ERC20Token VMR_Token;

    OldShareholderVomer oldContract;

    event Credit(address indexed approvedAddr, address indexed receiver, uint256 amount);
    event ReturnCredit(address indexed approvedAddr, uint256 amount);

    mapping (address => bool) migrateDone;

    struct InvestorData {
        uint256 funds;
        uint256 lastDatetime;
        uint256 totalProfit;
        uint256 totalVMR; 
    }
    mapping (address => InvestorData) investors;

    mapping(address => bool) public admins;

    mapping(address => uint256) individualVMRCup; 

    struct Partner {
        int256 maxCredit;        // max partner owe
        int256 balance;
    }
    mapping(address => Partner) partners;

    // 0 - eth, VMR_Token - vmr
    address  paymentToken; 
    uint256 VMR_ETH_RATE; 
    struct InvestorDataExt {
        mapping(address => uint256) totalProfit;
        address activePayoutToken; 
        uint256 limitVMR; 
        uint256 oldDepositAmount;
    }

    uint256 globalLimitVMR; 

    mapping (address => InvestorDataExt) investorsExt;

    mapping(address => address) refList;

    
    uint256 maxLimitVMR;
    address public supportAddress;

    mapping(address => uint256) tokenRates;

    struct RefData {
        uint256 pendingRewardVMR;
        mapping(address => uint256) totalProfit;
    }
    mapping(address => RefData) pendingRefRewards;
    

    modifier onlyOwner()
    {
        assert(msg.sender == owner);
        _;
    }

    modifier onlyAdmin()
    {
        assert(admins[msg.sender]);
        _;
    }

    function initialize() initializer public {
        VMR_Token = ERC20Token(0x063b98a414EAA1D4a5D4fC235a22db1427199024); // testnet 0xa258a452FC38Fc9Fa8A8b03F210346E8390A5D56
        oldContract = OldShareholderVomer(0x9C235ac2C33077A30593A3fd27A0087c687A80A3);
        MinBalanceVMR = 1000 * 10**18;
        migrateDone[0x12A09763eC6e5B7cbc4feb7178db8C91A79E456a] = true;
        migrateDone[0xB7722517f410914fFf62DF357A0c14B88EFb9369] = true;
        owner = msg.sender;
        paymentToken = address(0);
    }

    function getPaymentInfo() view public returns (address token, uint256 _minLimitVMR,  uint256 _maxLimitVMR) {
        token = paymentToken;
        _minLimitVMR = globalLimitVMR;
        _maxLimitVMR = maxLimitVMR;
    }

    function updateTokenRate(address tokenAddress, uint256 rateInWei) public onlyAdmin {
        tokenRates[tokenAddress] = rateInWei;
    }

    function updatePaymentMode(address _newPaymantMode, uint256 _newMinLimitVMRInInteger, uint256 _newMaxLimitVMRInInteger) onlyOwner public {
        require(tokenRates[_newPaymantMode] > 0, "Token rate not set");
        require(ERC20Token(_newPaymantMode).universalBalanceOf(address(this)) > 0, "Contract balance for target token is zero");

        paymentToken = _newPaymantMode;
        globalLimitVMR = _newMinLimitVMRInInteger * 10**18;
        maxLimitVMR = _newMaxLimitVMRInInteger * 10**18;
    }

    function safeEthTransfer(address target, uint256 amount) internal {
        address payable payableTarget = address(uint160(target));
        (bool ok, ) = payableTarget.call.value(0)("");
        require(ok);
    }

    function takeEth(address targetAddr, uint256 amount) public {
        if (targetAddr == address(0)) targetAddr = msg.sender;

        Partner storage data = partners[msg.sender];

        require(data.maxCredit + data.balance > 0);
        require(uint256(data.maxCredit + data.balance) >= amount);

        data.balance -= int256(amount);

        safeEthTransfer(targetAddr, amount);
        emit Credit(msg.sender, targetAddr, amount);
    }

    function getPartnerInfo(address addressPartner) view public returns (int256 maxCredit, int256 balance) {
        maxCredit = partners[addressPartner].maxCredit;
        balance = partners[addressPartner].balance;
    }

    function giveBackEth() payable public {	//injected LOCKED ETHER
        Partner storage data = partners[msg.sender];
        if (data.maxCredit > 0) {
            data.balance += int256(msg.value);
        }
        emit ReturnCredit(msg.sender, msg.value);
    }

    function setPartnerContract(address addr, int256 maxCredit) onlyOwner public {
        require(maxCredit >= 0);
        Partner storage data = partners[addr];
        data.maxCredit = maxCredit;
    }

    function setAdmin(address newAdmin, bool activate) onlyOwner public {
        admins[newAdmin] = activate;
    }

    // set amount to 0 to disable individual cup
    function changeIndividualVMRCup(address userAddress, uint256 minAmountInInteger) onlyOwner public {
        individualVMRCup[userAddress] = minAmountInInteger * 10**18;
    }

    uint256 public fundsLockedtoWithdraw;
    uint256 public dateUntilFundsLocked;

    function withdraw(uint256 amount)  public onlyOwner {
        if (dateUntilFundsLocked > now) require(address(this).balance.sub(amount) > fundsLockedtoWithdraw);
        owner.transfer(0);
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

    function changeMinBalance(uint256 newMinBalanceInInteger) public onlyOwner {
        MinBalanceVMR = newMinBalanceInInteger * 10**18;
    }

    function bytesToAddress(bytes memory bys) private pure returns (address payable addr) {
        assembly {
            addr := mload(add(bys,20))
        }
    }
    // function for transfer any token from contract
    function transferTokens (address token, address target, uint256 amount) onlyOwner public
    {
        ERC20Token(token).universalTransfer(target, amount);
    }

    function migrateDataFromOldContract(address oldAddress, address newAddress) internal
    {
        if (!migrateDone[oldAddress]) {
            uint256 totalFunds;
            uint256 pendingReward;
            uint256 totalProfit;
            (totalFunds, pendingReward, totalProfit,) = oldContract.getInfo(oldAddress);
            if (totalFunds > 0) {
                uint256 lastDatetime = block.timestamp - pendingReward.mul(30 days).mul(100).div(20).div(totalFunds);
                uint256 totalVMR = investors[newAddress].totalVMR;
                investors[newAddress] = InvestorData(totalFunds, lastDatetime, totalProfit, totalVMR);
            }
            migrateDone[oldAddress] = true;
            if (oldAddress != newAddress) migrateDone[newAddress] = true;
        }
    }

    function getInfo(address investor) view external returns (uint256[18] memory ret
    //        uint256 depositedEth,     => ret[0]
    //        uint256 pendingEthReward, => ret[1]
    //        uint256 totalEthProfit,   => ret[2]
    //        uint256 contractBalance,  => ret[3]
    //        uint256 depositedVMR,     => ret[4]
    //        uint256 minVMR,           => ret[5]
    //        uint256 pendingVMRReward, => ret[6]
    //        uint256 pendingActiveTokenReward, => ret[7]
    //        uint256 totalActiveTokenProfit,   => ret[8]
    //        uint256 activeTokenRate,          => ret[9]
    //        address activePayoutToken,        => ret[10]
    //
    //        uint256 referralLimitVMR,         => ret[11]
    //        uint256 oldDepositTokens,         => ret[12]
    //        uint256 currentLimitVMR,          => ret[13]
    //        uint256 currentEffectiveVMR,      => ret[14]

    //        uint256 pendingRefRewardVMR,      => ret[15]
    //        uint256 totalRefProfit,           => ret[16]
    //        uint256 rewardRefInActiveToken,   => ret[17]
    )
    {
        ret[3] = address(this).balance;
        ret[5] = individualVMRCup[investor];
        if (ret[5] == 0) ret[5] = MinBalanceVMR;

        if (!migrateDone[investor]) {
            (ret[0], ret[1], ret[2],) = oldContract.getInfo(investor);
            ret[4] = investors[investor].totalVMR;
        } else {
            InvestorData memory data = investors[investor];
            ret[0] = data.funds;
            if (data.funds > 0) ret[1] = data.funds.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);
            ret[2] = data.totalProfit;
            ret[4] = data.totalVMR;

            InvestorDataExt memory dataEx = investorsExt[investor];
            ret[11] = dataEx.limitVMR;
            ret[12] = dataEx.oldDepositAmount;

            ret[13] = ret[11].add(globalLimitVMR); 
            ret[14] =  data.totalVMR; 
            if (ret[14] > ret[13]) ret[14] = ret[13]; 
            if (maxLimitVMR > 0 && ret[14] > maxLimitVMR) ret[14] = maxLimitVMR; 
            if (data.lastDatetime > 0) ret[6] = ret[14].mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);

            
            address activePayoutToken = (dataEx.activePayoutToken == address (0)) ? paymentToken : dataEx.activePayoutToken;
            ret[10] = uint256(activePayoutToken);

            ret[7] = ret[6] * tokenRates[activePayoutToken] / 10**18;

            RefData storage refData = pendingRefRewards[investor];
            ret[15] = refData.pendingRewardVMR;
            ret[16] = refData.totalProfit[activePayoutToken];
            ret[17] = refData.pendingRewardVMR * tokenRates[activePayoutToken] / 10**18;

            ret[9] = tokenRates[activePayoutToken];

            (ret[8], ) = getUserProfitByToken(investor, activePayoutToken);
        }
    }

    function getUserProfitByToken(address investor, address token) view public returns(uint256 profit, uint256 refProfit) {
        profit = investorsExt[investor].totalProfit[token];
        refProfit = pendingRefRewards[investor].totalProfit[token];
    }

    function setUserLimitVMR(address[] calldata userAddress, uint256[] calldata newLimitsInWei) onlyAdmin external {
        uint256 len = userAddress.length;
        require(len == newLimitsInWei.length);

        for(uint16 i = 0;i < len; i++) {
            investorsExt[userAddress[i]].limitVMR = newLimitsInWei[i];
        }
    }

    function setDepositTokens(address[] calldata userAddress, uint256[] calldata amountTokens) onlyAdmin external {
        uint256 len = userAddress.length;
        require(len == amountTokens.length);

        for(uint16 i = 0;i < len; i++) {
            InvestorData storage data = investors[userAddress[i]];

            InvestorDataExt storage dataExt = investorsExt[userAddress[i]];
            if (dataExt.oldDepositAmount == 0) {
                dataExt.oldDepositAmount = data.totalVMR + 1;
            }

            if (data.lastDatetime == 0) data.lastDatetime = block.timestamp;

            if (amountTokens[i] > data.totalVMR)
            {
                uint256 amount = amountTokens[i] - data.totalVMR;
                updateRefStructure(userAddress[i], amount);
                data.totalVMR = data.totalVMR.add(amount.mul(70).div(100));
            } else {
                data.totalVMR = amountTokens[i];
            }
        }
    }

    function withdrawRefReward(address investor, InvestorDataExt storage dataEx) internal {
        RefData storage refData = pendingRefRewards[investor];
        if (refData.pendingRewardVMR == 0) return;

        address activePayoutToken = dataEx.activePayoutToken == address (0) ? paymentToken : dataEx.activePayoutToken;

        require(tokenRates[activePayoutToken] > 0, "Token rate not set");
        uint256 rewardInActiveToken = refData.pendingRewardVMR * tokenRates[activePayoutToken] / 10**18;
        refData.pendingRewardVMR = 0;
        ERC20Token(activePayoutToken).universalTransfer(investor, rewardInActiveToken);

        refData.totalProfit[activePayoutToken] += rewardInActiveToken;
    }

    function setSupportAddress(address newSupportAddress) public onlyOwner {
        supportAddress = newSupportAddress;
    }

    function updateRefStructure(address investor, uint256 amountVMR) internal {
        address ref = refList[investor];

        if (ref == address(0)) return;

        // level 1
        pendingRefRewards[ref].pendingRewardVMR = pendingRefRewards[ref].pendingRewardVMR.add(amountVMR.mul(25).div(100));

        address _support = (supportAddress == address(0)) ? owner : supportAddress;
        pendingRefRewards[_support].pendingRewardVMR = pendingRefRewards[_support].pendingRewardVMR.add(amountVMR.mul(5).div(100));

        // levels 1-3
        for(uint8 i = 0; i < 3;i++) {
            investorsExt[ref].limitVMR = investorsExt[ref].limitVMR.add(amountVMR.mul(70).div(100)); 

            ref = refList[ref];
            if (ref == address(0)) break;
        }
    }

    function checkRef() internal {
        if (refList[msg.sender] == address(0))
        {
            require(msg.data.length == 20, "Referral address required");
            address ref = bytesToAddress(msg.data);
            require(ref != msg.sender, "You can't ref yourself");

            refList[msg.sender] = ref;

            if (investorsExt[msg.sender].oldDepositAmount == 0) {
                
                investorsExt[msg.sender].oldDepositAmount = investors[msg.sender].totalVMR + 1;
            } else {
                
                updateRefStructure(msg.sender, (investors[msg.sender].totalVMR + 1).sub(investorsExt[msg.sender].oldDepositAmount).mul(100).div(70));
            }
        }
    }

    function () payable external	//injected LOCKED ETHER
    {
        require(msg.sender == tx.origin); // prevent bots to interact with contract

        if (msg.sender == owner) return;

        require(msg.value == 0, "ETH deposits not allowed"); 
        migrateDataFromOldContract(msg.sender, msg.sender);

        InvestorData storage data = investors[msg.sender];

        uint256 minBalanceRequired = individualVMRCup[msg.sender];
        if (minBalanceRequired == 0) minBalanceRequired = MinBalanceVMR;
        require(data.totalVMR >= minBalanceRequired, "Not enough VMR deposit");
        require(data.lastDatetime > 0, "Invalid user state, you should deposit VMR tokens");

        // setup ref link
        checkRef();

        if (data.funds != 0 && data.totalProfit < data.funds) {
            // 20% per 30 days
            uint256 reward = data.funds.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);

            if (reward.add(data.totalProfit) > data.funds) {
                if (data.funds > data.totalProfit) {
                    reward = data.funds.sub(data.totalProfit);
                } else {
                    reward = 0;
                }
            }

            if (reward > 0) {
                data.totalProfit = data.totalProfit.add(reward); 
                address payable payableUser = address(uint160(msg.sender));
                payableUser.transfer(0);
            }
        }

        InvestorDataExt storage dataEx = investorsExt[msg.sender];

        withdrawRefReward(msg.sender, dataEx);

        uint256 currentLimitVMR = dataEx.limitVMR.add(globalLimitVMR); 
        uint256 currentEffectiveVMR = data.totalVMR; 
        if (currentEffectiveVMR > currentLimitVMR) currentEffectiveVMR = currentLimitVMR; 
        if (maxLimitVMR > 0 && currentEffectiveVMR > maxLimitVMR) currentEffectiveVMR = maxLimitVMR; 
        uint256 rewardVMR = currentEffectiveVMR.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);
        address activePayoutToken = dataEx.activePayoutToken == address (0) ? paymentToken : dataEx.activePayoutToken; 
        require(tokenRates[activePayoutToken] > 0, "Token rate not set");
        uint256 rewardInActiveToken = rewardVMR * tokenRates[activePayoutToken] / 10**18;
        ERC20Token(activePayoutToken).universalTransfer(msg.sender, rewardInActiveToken);
        dataEx.totalProfit[activePayoutToken] += rewardInActiveToken;

        data.lastDatetime = block.timestamp;
    }
}