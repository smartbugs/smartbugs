                                                                 

                                                                                                                    

pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;


interface IWeth {
    function DEPOSIT413() external payable;	//inject NONSTANDARD NAMING
    function WITHDRAW1000(uint256 wad) external;	//inject NONSTANDARD NAMING
}

contract IERC20 {
    string public name;
    uint8 public decimals;
    string public symbol;
    function TOTALSUPPLY320() public view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF760(address _who) public view returns (uint256);	//inject NONSTANDARD NAMING
    function ALLOWANCE148(address _owner, address _spender) public view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE600(address _spender, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER238(address _to, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM597(address _from, address _to, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER322(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL667(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract IWethERC20 is IWeth, IERC20 {}

contract Constants {

    uint256 internal constant wei_precision427 = 10**18;	//inject NONSTANDARD NAMING
    uint256 internal constant wei_percent_precision736 = 10**20;	//inject NONSTANDARD NAMING

    uint256 internal constant days_in_a_year553 = 365;	//inject NONSTANDARD NAMING
    uint256 internal constant one_month196 = 2628000; // approx. seconds in a month	//inject NONSTANDARD NAMING

    string internal constant userrewardsid759 = "UserRewards";	//inject NONSTANDARD NAMING

    IWethERC20 public constant wethtoken696 = IWethERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);	//inject NONSTANDARD NAMING
    address public constant bzrxtokenaddress831 = 0x56d811088235F11C8920698a204A5010a788f4b3;	//inject NONSTANDARD NAMING
    address public constant vbzrxtokenaddress602 = 0xB72B31907C1C95F3650b64b2469e08EdACeE5e8F;	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                          
library EnumerableBytes32Set {

    struct Bytes32Set {
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping (bytes32 => uint256) index;
        bytes32[] values;
    }

                                                                                                                          
    function ADDADDRESS118(Bytes32Set storage set, address addrvalue)	//inject NONSTANDARD NAMING
        internal
        returns (bool)
    {
        bytes32 value;
        assembly {
            value := addrvalue
        }
        return ADDBYTES32720(set, value);
    }

                                                                                                                 
    function ADDBYTES32720(Bytes32Set storage set, bytes32 value)	//inject NONSTANDARD NAMING
        internal
        returns (bool)
    {
        if (!CONTAINS194(set, value)){
            set.index[value] = set.values.push(value);
            return true;
        } else {
            return false;
        }
    }

                                                                                                                                    
    function REMOVEADDRESS815(Bytes32Set storage set, address addrvalue)	//inject NONSTANDARD NAMING
        internal
        returns (bool)
    {
        bytes32 value;
        assembly {
            value := addrvalue
        }
        return REMOVEBYTES32129(set, value);
    }

                                                                                                                           
    function REMOVEBYTES32129(Bytes32Set storage set, bytes32 value)	//inject NONSTANDARD NAMING
        internal
        returns (bool)
    {
        if (CONTAINS194(set, value)){
            uint256 toDeleteIndex = set.index[value] - 1;
            uint256 lastIndex = set.values.length - 1;

            // If the element we're deleting is the last one, we can just remove it without doing a swap
            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set.values[lastIndex];

                // Move the last value to the index where the deleted value is
                set.values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set.index[lastValue] = toDeleteIndex + 1; // All indexes are 1-based
            }

            // Delete the index entry for the deleted value
            delete set.index[value];

            // Delete the old entry for the moved value
            set.values.pop();

            return true;
        } else {
            return false;
        }
    }

                                                                          
    function CONTAINS194(Bytes32Set storage set, bytes32 value)	//inject NONSTANDARD NAMING
        internal
        view
        returns (bool)
    {
        return set.index[value] != 0;
    }

                                                                          
    function CONTAINSADDRESS180(Bytes32Set storage set, address addrvalue)	//inject NONSTANDARD NAMING
        internal
        view
        returns (bool)
    {
        bytes32 value;
        assembly {
            value := addrvalue
        }
        return set.index[value] != 0;
    }

                                                                                                                                                                                                                                                                                                                                                          
    function ENUMERATE547(Bytes32Set storage set, uint256 start, uint256 count)	//inject NONSTANDARD NAMING
        internal
        view
        returns (bytes32[] memory output)
    {
        uint256 end = start + count;
        require(end >= start, "addition overflow");
        end = set.values.length < end ? set.values.length : end;
        if (end == 0 || start >= end) {
            return output;
        }

        output = new bytes32[](end-start);
        for (uint256 i = start; i < end; i++) {
            output[i-start] = set.values[i];
        }
        return output;
    }

                                                                            
    function LENGTH537(Bytes32Set storage set)	//inject NONSTANDARD NAMING
        internal
        view
        returns (uint256)
    {
        return set.values.length;
    }

                                                                                                                                                                                                                                                                                                                           
    function GET436(Bytes32Set storage set, uint256 index)	//inject NONSTANDARD NAMING
        internal
        view
        returns (bytes32)
    {
        return set.values[index];
    }

                                                                                                                                                                                                                                                                                                                           
    function GETADDRESS452(Bytes32Set storage set, uint256 index)	//inject NONSTANDARD NAMING
        internal
        view
        returns (address)
    {
        bytes32 value = set.values[index];
        address addrvalue;
        assembly {
            addrvalue := value
        }
        return addrvalue;
    }
}

                                                                                                                                                                                                                             
contract ReentrancyGuard {

                                                                                     
                                                                              
    uint256 internal constant reentrancy_guard_free973 = 1;	//inject NONSTANDARD NAMING

                                            
    uint256 internal constant reentrancy_guard_locked356 = 2;	//inject NONSTANDARD NAMING

                                                                      
    uint256 internal reentrancyLock = reentrancy_guard_free973;

                                                                                                                                                                                                                                                                                                                                                                                                 
    modifier NONREENTRANT587() {	//inject NONSTANDARD NAMING
        require(reentrancyLock == reentrancy_guard_free973, "nonReentrant");
        reentrancyLock = reentrancy_guard_locked356;
        _;
        reentrancyLock = reentrancy_guard_free973;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _MSGSENDER414() internal view returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA879() internal view returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

                                                                                                                                                                                                                                                                                                                                                                        
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED809(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER414();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED809(address(0), msgSender);
    }

                                                                     
    function OWNER514() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER855() {	//inject NONSTANDARD NAMING
        require(ISOWNER719(), "unauthorized");
        _;
    }

                                                                            
    function ISOWNER719() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _MSGSENDER414() == _owner;
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP334(address newOwner) public ONLYOWNER855 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP592(newOwner);
    }

                                                                                              
    function _TRANSFEROWNERSHIP592(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED809(_owner, newOwner);
        _owner = newOwner;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD350(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB395(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB395(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                                                             
    function SUB395(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL0(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV729(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV729(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function DIV729(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b != 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                  
    function DIVCEIL360(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIVCEIL360(a, b, "SafeMath: division by zero");
    }

                                                                                                  
    function DIVCEIL360(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b != 0, errorMessage);

        if (a == 0) {
            return 0;
        }
        uint256 c = ((a - 1) / b) + 1;

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD504(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD504(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function MOD504(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }

    function MIN256991(uint256 _a, uint256 _b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return _a < _b ? _a : _b;
    }
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function ISCONTRACT390(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                          
    function TOPAYABLE724(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function SENDVALUE363(address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER502(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN109(token, abi.encodeWithSelector(token.TRANSFER238.selector, to, value));
    }

    function SAFETRANSFERFROM715(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN109(token, abi.encodeWithSelector(token.TRANSFERFROM597.selector, from, to, value));
    }

    function SAFEAPPROVE311(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE148(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN109(token, abi.encodeWithSelector(token.APPROVE600.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE505(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE148(address(this), spender).ADD350(value);
        CALLOPTIONALRETURN109(token, abi.encodeWithSelector(token.APPROVE600.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE766(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE148(address(this), spender).SUB395(value, "SafeERC20: decreased allowance below zero");
        CALLOPTIONALRETURN109(token, abi.encodeWithSelector(token.APPROVE600.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function CALLOPTIONALRETURN109(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).ISCONTRACT390(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract LoanStruct {
    struct Loan {
        bytes32 id;                 // id of the loan
        bytes32 loanParamsId;       // the linked loan params id
        bytes32 pendingTradesId;    // the linked pending trades id
        uint256 principal;          // total borrowed amount outstanding
        uint256 collateral;         // total collateral escrowed for the loan
        uint256 startTimestamp;     // loan start time
        uint256 endTimestamp;       // for active loans, this is the expected loan end time, for in-active loans, is the actual (past) end time
        uint256 startMargin;        // initial margin when the loan opened
        uint256 startRate;          // reference rate when the loan opened for converting collateralToken to loanToken
        address borrower;           // borrower of this loan
        address lender;             // lender of this loan
        bool active;                // if false, the loan has been fully closed
    }
}

contract LoanParamsStruct {
    struct LoanParams {
        bytes32 id;                 // id of loan params object
        bool active;                // if false, this object has been disabled by the owner and can't be used for future loans
        address owner;              // owner of this object
        address loanToken;          // the token being loaned
        address collateralToken;    // the required collateral token
        uint256 minInitialMargin;   // the minimum allowed initial margin
        uint256 maintenanceMargin;  // an unhealthy loan when current margin is at or below this value
        uint256 maxLoanTerm;        // the maximum term for new loans (0 means there's no max term)
    }
}

contract OrderStruct {
    struct Order {
        uint256 lockedAmount;           // escrowed amount waiting for a counterparty
        uint256 interestRate;           // interest rate defined by the creator of this order
        uint256 minLoanTerm;            // minimum loan term allowed
        uint256 maxLoanTerm;            // maximum loan term allowed
        uint256 createdTimestamp;       // timestamp when this order was created
        uint256 expirationTimestamp;    // timestamp when this order expires
    }
}

contract LenderInterestStruct {
    struct LenderInterest {
        uint256 principalTotal;     // total borrowed amount outstanding of asset
        uint256 owedPerDay;         // interest owed per day for all loans of asset
        uint256 owedTotal;          // total interest owed for all loans of asset (assuming they go to full term)
        uint256 paidTotal;          // total interest paid so far for asset
        uint256 updatedTimestamp;   // last update
    }
}

contract LoanInterestStruct {
    struct LoanInterest {
        uint256 owedPerDay;         // interest owed per day for loan
        uint256 depositTotal;       // total escrowed interest for loan
        uint256 updatedTimestamp;   // last update
    }
}

contract Objects is
    LoanStruct,
    LoanParamsStruct,
    OrderStruct,
    LenderInterestStruct,
    LoanInterestStruct
{}

contract State is Constants, Objects, ReentrancyGuard, Ownable {
    using SafeMath for uint256;
    using EnumerableBytes32Set for EnumerableBytes32Set.Bytes32Set;

    address public priceFeeds;                                                              // handles asset reference price lookups
    address public swapsImpl;                                                               // handles asset swaps using dex liquidity

    mapping (bytes4 => address) public logicTargets;                                        // implementations of protocol functions

    mapping (bytes32 => Loan) public loans;                                                 // loanId => Loan
    mapping (bytes32 => LoanParams) public loanParams;                                      // loanParamsId => LoanParams

    mapping (address => mapping (bytes32 => Order)) public lenderOrders;                    // lender => orderParamsId => Order
    mapping (address => mapping (bytes32 => Order)) public borrowerOrders;                  // borrower => orderParamsId => Order

    mapping (bytes32 => mapping (address => bool)) public delegatedManagers;                // loanId => delegated => approved

    // Interest
    mapping (address => mapping (address => LenderInterest)) public lenderInterest;         // lender => loanToken => LenderInterest object
    mapping (bytes32 => LoanInterest) public loanInterest;                                  // loanId => LoanInterest object

    // Internals
    EnumerableBytes32Set.Bytes32Set internal logicTargetsSet;                               // implementations set
    EnumerableBytes32Set.Bytes32Set internal activeLoansSet;                                // active loans set

    mapping (address => EnumerableBytes32Set.Bytes32Set) internal lenderLoanSets;           // lender loans set
    mapping (address => EnumerableBytes32Set.Bytes32Set) internal borrowerLoanSets;         // borrow loans set
    mapping (address => EnumerableBytes32Set.Bytes32Set) internal userLoanParamSets;        // user loan params set

    address public feesController;                                                          // address controlling fee withdrawals

    uint256 public lendingFeePercent = 10 ether; // 10% fee                                 // fee taken from lender interest payments
    mapping (address => uint256) public lendingFeeTokensHeld;                               // total interest fees received and not withdrawn per asset
    mapping (address => uint256) public lendingFeeTokensPaid;                               // total interest fees withdraw per asset (lifetime fees = lendingFeeTokensHeld + lendingFeeTokensPaid)

    uint256 public tradingFeePercent = 0.15 ether; // 0.15% fee                             // fee paid for each trade
    mapping (address => uint256) public tradingFeeTokensHeld;                               // total trading fees received and not withdrawn per asset
    mapping (address => uint256) public tradingFeeTokensPaid;                               // total trading fees withdraw per asset (lifetime fees = tradingFeeTokensHeld + tradingFeeTokensPaid)

    uint256 public borrowingFeePercent = 0.09 ether; // 0.09% fee                           // origination fee paid for each loan
    mapping (address => uint256) public borrowingFeeTokensHeld;                             // total borrowing fees received and not withdrawn per asset
    mapping (address => uint256) public borrowingFeeTokensPaid;                             // total borrowing fees withdraw per asset (lifetime fees = borrowingFeeTokensHeld + borrowingFeeTokensPaid)

    uint256 public protocolTokenHeld;                                                       // current protocol token deposit balance
    uint256 public protocolTokenPaid;                                                       // lifetime total payout of protocol token

    uint256 public affiliateFeePercent = 30 ether; // 30% fee share                         // fee share for affiliate program

    mapping (address => mapping (address => uint256)) public liquidationIncentivePercent;   // percent discount on collateral for liquidators per loanToken and collateralToken

    mapping (address => address) public loanPoolToUnderlying;                               // loanPool => underlying
    mapping (address => address) public underlyingToLoanPool;                               // underlying => loanPool
    EnumerableBytes32Set.Bytes32Set internal loanPoolsSet;                                  // loan pools set

    mapping (address => bool) public supportedTokens;                                       // supported tokens for swaps

    uint256 public maxDisagreement = 5 ether;                                               // % disagreement between swap rate and reference rate

    uint256 public sourceBufferPercent = 5 ether;                                           // used to estimate kyber swap source amount

    uint256 public maxSwapSize = 1500 ether;                                                // maximum supported swap size in ETH


    function _SETTARGET405(	//inject NONSTANDARD NAMING
        bytes4 sig,
        address target)
        internal
    {
        logicTargets[sig] = target;

        if (target != address(0)) {
            logicTargetsSet.ADDBYTES32720(bytes32(sig));
        } else {
            logicTargetsSet.REMOVEBYTES32129(bytes32(sig));
        }
    }
}

interface IPriceFeeds {
    function QUERYRATE923(	//inject NONSTANDARD NAMING
        address sourceToken,
        address destToken)
        external
        view
        returns (uint256 rate, uint256 precision);

    function QUERYPRECISION662(	//inject NONSTANDARD NAMING
        address sourceToken,
        address destToken)
        external
        view
        returns (uint256 precision);

    function QUERYRETURN272(	//inject NONSTANDARD NAMING
        address sourceToken,
        address destToken,
        uint256 sourceAmount)
        external
        view
        returns (uint256 destAmount);

    function CHECKPRICEDISAGREEMENT80(	//inject NONSTANDARD NAMING
        address sourceToken,
        address destToken,
        uint256 sourceAmount,
        uint256 destAmount,
        uint256 maxSlippage)
        external
        view
        returns (uint256 sourceToDestSwapRate);

    function AMOUNTINETH718(	//inject NONSTANDARD NAMING
        address Token,
        uint256 amount)
        external
        view
        returns (uint256 ethAmount);

    function GETMAXDRAWDOWN818(	//inject NONSTANDARD NAMING
        address loanToken,
        address collateralToken,
        uint256 loanAmount,
        uint256 collateralAmount,
        uint256 maintenanceMargin)
        external
        view
        returns (uint256);

    function GETCURRENTMARGINANDCOLLATERALSIZE534(	//inject NONSTANDARD NAMING
        address loanToken,
        address collateralToken,
        uint256 loanAmount,
        uint256 collateralAmount)
        external
        view
        returns (uint256 currentMargin, uint256 collateralInEthAmount);

    function GETCURRENTMARGIN887(	//inject NONSTANDARD NAMING
        address loanToken,
        address collateralToken,
        uint256 loanAmount,
        uint256 collateralAmount)
        external
        view
        returns (uint256 currentMargin, uint256 collateralToLoanRate);

    function SHOULDLIQUIDATE902(	//inject NONSTANDARD NAMING
        address loanToken,
        address collateralToken,
        uint256 loanAmount,
        uint256 collateralAmount,
        uint256 maintenanceMargin)
        external
        view
        returns (bool);

    function GETFASTGASPRICE944(	//inject NONSTANDARD NAMING
        address payToken)
        external
        view
        returns (uint256);
}

contract FeesEvents {

    event PAYLENDINGFEE908(	//inject NONSTANDARD NAMING
        address indexed payer,
        address indexed token,
        uint256 amount
    );

    event PAYTRADINGFEE956(	//inject NONSTANDARD NAMING
        address indexed payer,
        address indexed token,
        bytes32 indexed loanId,
        uint256 amount
    );

    event PAYBORROWINGFEE80(	//inject NONSTANDARD NAMING
        address indexed payer,
        address indexed token,
        bytes32 indexed loanId,
        uint256 amount
    );

    event EARNREWARD21(	//inject NONSTANDARD NAMING
        address indexed receiver,
        address indexed token,
        bytes32 indexed loanId,
        uint256 amount
    );
}

contract FeesHelper is State, FeesEvents {
    using SafeERC20 for IERC20;

    // calculate trading fee
    function _GETTRADINGFEE787(	//inject NONSTANDARD NAMING
        uint256 feeTokenAmount)
        internal
        view
        returns (uint256)
    {
        return feeTokenAmount
            .MUL0(tradingFeePercent)
            .DIVCEIL360(wei_percent_precision736);
    }

    // calculate loan origination fee
    function _GETBORROWINGFEE631(	//inject NONSTANDARD NAMING
        uint256 feeTokenAmount)
        internal
        view
        returns (uint256)
    {
        return feeTokenAmount
            .MUL0(borrowingFeePercent)
            .DIVCEIL360(wei_percent_precision736);
    }

    // settle trading fee
    function _PAYTRADINGFEE747(	//inject NONSTANDARD NAMING
        address user,
        bytes32 loanId,
        address feeToken,
        uint256 tradingFee)
        internal
    {
        if (tradingFee != 0) {
            tradingFeeTokensHeld[feeToken] = tradingFeeTokensHeld[feeToken]
                .ADD350(tradingFee);

            emit PAYTRADINGFEE956(
                user,
                feeToken,
                loanId,
                tradingFee
            );

            _PAYFEEREWARD533(
                user,
                loanId,
                feeToken,
                tradingFee
            );
        }
    }

    // settle loan origination fee
    function _PAYBORROWINGFEE445(	//inject NONSTANDARD NAMING
        address user,
        bytes32 loanId,
        address feeToken,
        uint256 borrowingFee)
        internal
    {
        if (borrowingFee != 0) {
            borrowingFeeTokensHeld[feeToken] = borrowingFeeTokensHeld[feeToken]
                .ADD350(borrowingFee);

            emit PAYBORROWINGFEE80(
                user,
                feeToken,
                loanId,
                borrowingFee
            );

            _PAYFEEREWARD533(
                user,
                loanId,
                feeToken,
                borrowingFee
            );
        }
    }

    // settle lender (interest) fee
    function _PAYLENDINGFEE461(	//inject NONSTANDARD NAMING
        address user,
        address feeToken,
        uint256 lendingFee)
        internal
    {
        if (lendingFee != 0) {
            lendingFeeTokensHeld[feeToken] = lendingFeeTokensHeld[feeToken]
                .ADD350(lendingFee);

            emit PAYLENDINGFEE908(
                user,
                feeToken,
                lendingFee
            );

                                                                
        }
    }

    // settles and pays borrowers based on the fees generated by their interest payments
    function _SETTLEFEEREWARDFORINTERESTEXPENSE273(	//inject NONSTANDARD NAMING
        LoanInterest storage loanInterestLocal,
        bytes32 loanId,
        address feeToken,
        address user,
        uint256 interestTime)
        internal
    {
        uint256 updatedTimestamp = loanInterestLocal.updatedTimestamp;

        uint256 interestExpenseFee;
        if (updatedTimestamp != 0) {
            // this represents the fee generated by a borrower's interest payment
            interestExpenseFee = interestTime
                .SUB395(updatedTimestamp)
                .MUL0(loanInterestLocal.owedPerDay)
                .MUL0(lendingFeePercent)
                .DIV729(1 days * wei_percent_precision736);
        }

        loanInterestLocal.updatedTimestamp = interestTime;

        if (interestExpenseFee != 0) {
            _PAYFEEREWARD533(
                user,
                loanId,
                feeToken,
                interestExpenseFee
            );
        }
    }

    // pay protocolToken reward to user
    function _PAYFEEREWARD533(	//inject NONSTANDARD NAMING
        address user,
        bytes32 loanId,
        address feeToken,
        uint256 feeAmount)
        internal
    {
        // The protocol is designed to allow positions and loans to be closed, if for whatever reason
        // the price lookup is failing, returning 0, or is otherwise paused. Therefore, we allow this
        // call to fail silently, rather than revert, to allow the transaction to continue without a
        // BZRX token reward.
        uint256 rewardAmount;
        address _priceFeeds = priceFeeds;
        (bool success, bytes memory data) = _priceFeeds.staticcall(
            abi.encodeWithSelector(
                IPriceFeeds(_priceFeeds).QUERYRETURN272.selector,
                feeToken,
                bzrxtokenaddress831, // price rewards using BZRX price rather than vesting token price
                feeAmount / 2  // 50% of fee value
            )
        );
        assembly {
            if eq(success, 1) {
                rewardAmount := mload(add(data, 32))
            }
        }

        if (rewardAmount != 0) {
            uint256 tokenBalance = protocolTokenHeld;
            if (rewardAmount > tokenBalance) {
                rewardAmount = tokenBalance;
            }
            if (rewardAmount != 0) {
                protocolTokenHeld = tokenBalance
                    .SUB395(rewardAmount);

                bytes32 slot = keccak256(abi.encodePacked(user, userrewardsid759));
                assembly {
                    sstore(slot, add(sload(slot), rewardAmount))
                }

                emit EARNREWARD21(
                    user,
                    vbzrxtokenaddress602, // rewardToken
                    loanId,
                    rewardAmount
                );
            }
        }
    }
}

contract VaultController is Constants {
    using SafeERC20 for IERC20;

    event VAULTDEPOSIT514(	//inject NONSTANDARD NAMING
        address indexed asset,
        address indexed from,
        uint256 amount
    );
    event VAULTWITHDRAW726(	//inject NONSTANDARD NAMING
        address indexed asset,
        address indexed to,
        uint256 amount
    );

    function VAULTETHERDEPOSIT545(	//inject NONSTANDARD NAMING
        address from,
        uint256 value)
        internal
    {
        IWethERC20 _wethToken = wethtoken696;
        _wethToken.DEPOSIT413.value(value)();

        emit VAULTDEPOSIT514(
            address(_wethToken),
            from,
            value
        );
    }

    function VAULTETHERWITHDRAW1(	//inject NONSTANDARD NAMING
        address to,
        uint256 value)
        internal
    {
        if (value != 0) {
            IWethERC20 _wethToken = wethtoken696;
            uint256 balance = address(this).balance;
            if (value > balance) {
                _wethToken.WITHDRAW1000(value - balance);
            }
            Address.SENDVALUE363(to, value);

            emit VAULTWITHDRAW726(
                address(_wethToken),
                to,
                value
            );
        }
    }

    function VAULTDEPOSIT722(	//inject NONSTANDARD NAMING
        address token,
        address from,
        uint256 value)
        internal
    {
        if (value != 0) {
            IERC20(token).SAFETRANSFERFROM715(
                from,
                address(this),
                value
            );

            emit VAULTDEPOSIT514(
                token,
                from,
                value
            );
        }
    }

    function VAULTWITHDRAW131(	//inject NONSTANDARD NAMING
        address token,
        address to,
        uint256 value)
        internal
    {
        if (value != 0) {
            IERC20(token).SAFETRANSFER502(
                to,
                value
            );

            emit VAULTWITHDRAW726(
                token,
                to,
                value
            );
        }
    }

    function VAULTTRANSFER888(	//inject NONSTANDARD NAMING
        address token,
        address from,
        address to,
        uint256 value)
        internal
    {
        if (value != 0) {
            if (from == address(this)) {
                IERC20(token).SAFETRANSFER502(
                    to,
                    value
                );
            } else {
                IERC20(token).SAFETRANSFERFROM715(
                    from,
                    to,
                    value
                );
            }
        }
    }

    function VAULTAPPROVE996(	//inject NONSTANDARD NAMING
        address token,
        address to,
        uint256 value)
        internal
    {
        if (value != 0 && IERC20(token).ALLOWANCE148(address(this), to) != 0) {
            IERC20(token).SAFEAPPROVE311(to, 0);
        }
        IERC20(token).SAFEAPPROVE311(to, value);
    }
}

contract InterestUser is State, VaultController, FeesHelper {
    using SafeERC20 for IERC20;

    function _PAYINTEREST683(	//inject NONSTANDARD NAMING
        address lender,
        address interestToken)
        internal
    {
        LenderInterest storage lenderInterestLocal = lenderInterest[lender][interestToken];

        uint256 interestOwedNow = 0;
        if (lenderInterestLocal.owedPerDay != 0 && lenderInterestLocal.updatedTimestamp != 0) {
            interestOwedNow = block.timestamp
                .SUB395(lenderInterestLocal.updatedTimestamp)
                .MUL0(lenderInterestLocal.owedPerDay)
                .DIV729(1 days);

            lenderInterestLocal.updatedTimestamp = block.timestamp;

            if (interestOwedNow > lenderInterestLocal.owedTotal)
	            interestOwedNow = lenderInterestLocal.owedTotal;

            if (interestOwedNow != 0) {
                lenderInterestLocal.paidTotal = lenderInterestLocal.paidTotal
                    .ADD350(interestOwedNow);
                lenderInterestLocal.owedTotal = lenderInterestLocal.owedTotal
                    .SUB395(interestOwedNow);

                _PAYINTERESTTRANSFER995(
                    lender,
                    interestToken,
                    interestOwedNow
                );
            }
        } else {
            lenderInterestLocal.updatedTimestamp = block.timestamp;
        }
    }

    function _PAYINTERESTTRANSFER995(	//inject NONSTANDARD NAMING
        address lender,
        address interestToken,
        uint256 interestOwedNow)
        internal
    {
        uint256 lendingFee = interestOwedNow
            .MUL0(lendingFeePercent)
            .DIVCEIL360(wei_percent_precision736);

        _PAYLENDINGFEE461(
            lender,
            interestToken,
            lendingFee
        );

        // transfers the interest to the lender, less the interest fee
        VAULTWITHDRAW131(
            interestToken,
            lender,
            interestOwedNow
                .SUB395(lendingFee)
        );
    }
}

contract LiquidationHelper is State {

    function _GETLIQUIDATIONAMOUNTS758(	//inject NONSTANDARD NAMING
        uint256 principal,
        uint256 collateral,
        uint256 currentMargin,
        uint256 maintenanceMargin,
        uint256 collateralToLoanRate,
        uint256 incentivePercent)
        internal
        pure
        returns (uint256 maxLiquidatable, uint256 maxSeizable)
    {
        if (currentMargin > maintenanceMargin || collateralToLoanRate == 0) {
            return (maxLiquidatable, maxSeizable);
        } else if (currentMargin <= incentivePercent) {
            return (principal, collateral);
        }

        uint256 desiredMargin = maintenanceMargin
            .ADD350(5 ether); // 5 percentage points above maintenance

        // maxLiquidatable = ((1 + desiredMargin)*principal - collateralToLoanRate*collateral) / (desiredMargin - incentivePercent)
        maxLiquidatable = desiredMargin
            .ADD350(wei_percent_precision736)
            .MUL0(principal)
            .DIV729(wei_percent_precision736);
        maxLiquidatable = maxLiquidatable
            .SUB395(
                collateral
                    .MUL0(collateralToLoanRate)
                    .DIV729(wei_precision427)
            );
        maxLiquidatable = maxLiquidatable
            .MUL0(wei_percent_precision736)
            .DIV729(
                desiredMargin
                    .SUB395(incentivePercent)
            );
        if (maxLiquidatable > principal) {
            maxLiquidatable = principal;
        }

        // maxSeizable = maxLiquidatable * (1 + incentivePercent) / collateralToLoanRate
        maxSeizable = maxLiquidatable
            .MUL0(
                incentivePercent
                    .ADD350(wei_percent_precision736)
            );
        maxSeizable = maxSeizable
            .DIV729(collateralToLoanRate)
            .DIV729(100);
        if (maxSeizable > collateral) {
            maxSeizable = collateral;
        }

        return (maxLiquidatable, maxSeizable);
    }
}

contract SwapsEvents {

    event LOANSWAP63(	//inject NONSTANDARD NAMING
        bytes32 indexed loanId,
        address indexed sourceToken,
        address indexed destToken,
        address borrower,
        uint256 sourceAmount,
        uint256 destAmount
    );

    event EXTERNALSWAP169(	//inject NONSTANDARD NAMING
        address indexed user,
        address indexed sourceToken,
        address indexed destToken,
        uint256 sourceAmount,
        uint256 destAmount
    );
}

interface ISwapsImpl {
    function DEXSWAP890(	//inject NONSTANDARD NAMING
        address sourceTokenAddress,
        address destTokenAddress,
        address receiverAddress,
        address returnToSenderAddress,
        uint256 minSourceTokenAmount,
        uint256 maxSourceTokenAmount,
        uint256 requiredDestTokenAmount)
        external
        returns (uint256 destTokenAmountReceived, uint256 sourceTokenAmountUsed);

    function DEXEXPECTEDRATE181(	//inject NONSTANDARD NAMING
        address sourceTokenAddress,
        address destTokenAddress,
        uint256 sourceTokenAmount)
        external
        view
        returns (uint256);
}

contract SwapsUser is State, SwapsEvents, FeesHelper {

    function _LOANSWAP802(	//inject NONSTANDARD NAMING
        bytes32 loanId,
        address sourceToken,
        address destToken,
        address user,
        uint256 minSourceTokenAmount,
        uint256 maxSourceTokenAmount,
        uint256 requiredDestTokenAmount,
        bool bypassFee,
        bytes memory loanDataBytes)
        internal
        returns (uint256 destTokenAmountReceived, uint256 sourceTokenAmountUsed, uint256 sourceToDestSwapRate)
    {
        (destTokenAmountReceived, sourceTokenAmountUsed) = _SWAPSCALL433(
            [
                sourceToken,
                destToken,
                address(this), // receiver
                address(this), // returnToSender
                user
            ],
            [
                minSourceTokenAmount,
                maxSourceTokenAmount,
                requiredDestTokenAmount
            ],
            loanId,
            bypassFee,
            loanDataBytes
        );

        // will revert if swap size too large
        _CHECKSWAPSIZE456(sourceToken, sourceTokenAmountUsed);

        // will revert if disagreement found
        sourceToDestSwapRate = IPriceFeeds(priceFeeds).CHECKPRICEDISAGREEMENT80(
            sourceToken,
            destToken,
            sourceTokenAmountUsed,
            destTokenAmountReceived,
            maxDisagreement
        );

        emit LOANSWAP63(
            loanId,
            sourceToken,
            destToken,
            user,
            sourceTokenAmountUsed,
            destTokenAmountReceived
        );
    }

    function _SWAPSCALL433(	//inject NONSTANDARD NAMING
        address[5] memory addrs,
        uint256[3] memory vals,
        bytes32 loanId,
        bool miscBool, // bypassFee
        bytes memory loanDataBytes)
        internal
        returns (uint256, uint256)
    {
        //addrs[0]: sourceToken
        //addrs[1]: destToken
        //addrs[2]: receiver
        //addrs[3]: returnToSender
        //addrs[4]: user
        //vals[0]:  minSourceTokenAmount
        //vals[1]:  maxSourceTokenAmount
        //vals[2]:  requiredDestTokenAmount

        require(vals[0] != 0, "sourceAmount == 0");

        uint256 destTokenAmountReceived;
        uint256 sourceTokenAmountUsed;

        uint256 tradingFee;
        if (!miscBool) { // bypassFee
            if (vals[2] == 0) {
                // condition: vals[0] will always be used as sourceAmount

                tradingFee = _GETTRADINGFEE787(vals[0]);
                if (tradingFee != 0) {
                    _PAYTRADINGFEE747(
                        addrs[4], // user
                        loanId,
                        addrs[0], // sourceToken
                        tradingFee
                    );

                    vals[0] = vals[0]
                        .SUB395(tradingFee);
                }
            } else {
                // condition: unknown sourceAmount will be used

                tradingFee = _GETTRADINGFEE787(vals[2]);

                if (tradingFee != 0) {
                    vals[2] = vals[2]
                        .ADD350(tradingFee);
                }
            }
        }

        if (vals[1] == 0) {
            vals[1] = vals[0];
        } else {
            require(vals[0] <= vals[1], "min greater than max");
        }

        require(loanDataBytes.length == 0, "invalid state");
        (destTokenAmountReceived, sourceTokenAmountUsed) = _SWAPSCALL_INTERNAL704(
            addrs,
            vals
        );

        if (vals[2] == 0) {
            // there's no minimum destTokenAmount, but all of vals[0] (minSourceTokenAmount) must be spent, and amount spent can't exceed vals[0]
            require(sourceTokenAmountUsed == vals[0], "swap too large to fill");

            if (tradingFee != 0) {
                sourceTokenAmountUsed = sourceTokenAmountUsed + tradingFee; // will never overflow
            }
        } else {
            // there's a minimum destTokenAmount required, but sourceTokenAmountUsed won't be greater than vals[1] (maxSourceTokenAmount)
            require(sourceTokenAmountUsed <= vals[1], "swap fill too large");
            require(destTokenAmountReceived >= vals[2], "insufficient swap liquidity");

            if (tradingFee != 0) {
                _PAYTRADINGFEE747(
                    addrs[4], // user
                    loanId, // loanId,
                    addrs[1], // destToken
                    tradingFee
                );

                destTokenAmountReceived = destTokenAmountReceived - tradingFee; // will never overflow
            }
        }

        return (destTokenAmountReceived, sourceTokenAmountUsed);
    }

    function _SWAPSCALL_INTERNAL704(	//inject NONSTANDARD NAMING
        address[5] memory addrs,
        uint256[3] memory vals)
        internal
        returns (uint256 destTokenAmountReceived, uint256 sourceTokenAmountUsed)
    {
        bytes memory data = abi.encodeWithSelector(
            ISwapsImpl(swapsImpl).DEXSWAP890.selector,
            addrs[0], // sourceToken
            addrs[1], // destToken
            addrs[2], // receiverAddress
            addrs[3], // returnToSenderAddress
            vals[0],  // minSourceTokenAmount
            vals[1],  // maxSourceTokenAmount
            vals[2]   // requiredDestTokenAmount
        );

        bool success;
        (success, data) = swapsImpl.delegatecall(data);
        require(success, "swap failed");

        (destTokenAmountReceived, sourceTokenAmountUsed) = abi.decode(data, (uint256, uint256));
    }

    function _SWAPSEXPECTEDRETURN731(	//inject NONSTANDARD NAMING
        address sourceToken,
        address destToken,
        uint256 sourceTokenAmount)
        internal
        view
        returns (uint256)
    {
        uint256 tradingFee = _GETTRADINGFEE787(sourceTokenAmount);
        if (tradingFee != 0) {
            sourceTokenAmount = sourceTokenAmount
                .SUB395(tradingFee);
        }

        uint256 sourceToDestRate = ISwapsImpl(swapsImpl).DEXEXPECTEDRATE181(
            sourceToken,
            destToken,
            sourceTokenAmount
        );
        uint256 sourceToDestPrecision = IPriceFeeds(priceFeeds).QUERYPRECISION662(
            sourceToken,
            destToken
        );

        return sourceTokenAmount
            .MUL0(sourceToDestRate)
            .DIV729(sourceToDestPrecision);
    }

    function _CHECKSWAPSIZE456(	//inject NONSTANDARD NAMING
        address tokenAddress,
        uint256 amount)
        internal
        view
    {
        uint256 _maxSwapSize = maxSwapSize;
        if (_maxSwapSize != 0) {
            uint256 amountInEth;
            if (tokenAddress == address(wethtoken696)) {
                amountInEth = amount;
            } else {
                amountInEth = IPriceFeeds(priceFeeds).AMOUNTINETH718(tokenAddress, amount);
            }
            require(amountInEth <= _maxSwapSize, "swap too large");
        }
    }
}

interface ILoanPool {
    function TOKENPRICE528()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256 price);

    function BORROWINTERESTRATE911()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);

    function TOTALASSETSUPPLY606()	//inject NONSTANDARD NAMING
        external
        view
        returns (uint256);
}

contract ITokenHolderLike {
    function BALANCEOF760(address _who) public view returns (uint256);	//inject NONSTANDARD NAMING
    function FREEUPTO522(uint256 value) public returns (uint256);	//inject NONSTANDARD NAMING
    function FREEFROMUPTO607(address from, uint256 value) public returns (uint256);	//inject NONSTANDARD NAMING
}

contract GasTokenUser {

    ITokenHolderLike constant public gastoken34 = ITokenHolderLike(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);	//inject NONSTANDARD NAMING
    ITokenHolderLike constant public tokenholder491 = ITokenHolderLike(0x55Eb3DD3f738cfdda986B8Eff3fa784477552C61);	//inject NONSTANDARD NAMING

    modifier USESGASTOKEN390(address holder) {	//inject NONSTANDARD NAMING
        if (holder == address(0)) {
            holder = address(tokenholder491);
        }

        if (gastoken34.BALANCEOF760(holder) != 0) {
            uint256 gasCalcValue = gasleft();

            _;

            gasCalcValue = (_GASUSED486(gasCalcValue) + 14154) / 41947;

            if (holder == address(tokenholder491)) {
                tokenholder491.FREEUPTO522(
                    gasCalcValue
                );
            } else {
                tokenholder491.FREEFROMUPTO607(
                    holder,
                    gasCalcValue
                );
            }

        } else {
            _;
        }
    }

    function _GASUSED486(	//inject NONSTANDARD NAMING
        uint256 startingGas)
        internal
        view
        returns (uint256)
    {
        return 21000 +
            startingGas -
            gasleft() +
            16 *
            msg.data.length;

    }
}

contract LoanClosingsEvents {

    event CLOSEWITHDEPOSIT137(	//inject NONSTANDARD NAMING
        address indexed user,
        address indexed lender,
        bytes32 indexed loanId,
        address closer,
        address loanToken,
        address collateralToken,
        uint256 repayAmount,
        uint256 collateralWithdrawAmount,
        uint256 collateralToLoanRate,
        uint256 currentMargin
    );

    event CLOSEWITHSWAP232(	//inject NONSTANDARD NAMING
        address indexed user,
        address indexed lender,
        bytes32 indexed loanId,
        address collateralToken,
        address loanToken,
        address closer,
        uint256 positionCloseSize,
        uint256 loanCloseAmount,
        uint256 exitPrice, // one unit of collateralToken, denominated in loanToken
        uint256 currentLeverage
    );

    event LIQUIDATE807(	//inject NONSTANDARD NAMING
        address indexed user,
        address indexed liquidator,
        bytes32 indexed loanId,
        address lender,
        address loanToken,
        address collateralToken,
        uint256 repayAmount,
        uint256 collateralWithdrawAmount,
        uint256 collateralToLoanRate,
        uint256 currentMargin
    );

    event ROLLOVER791(	//inject NONSTANDARD NAMING
        address indexed user,
        address indexed caller,
        bytes32 indexed loanId,
        address lender,
        address loanToken,
        address collateralToken,
        uint256 collateralAmountUsed,
        uint256 interestAmountAdded,
        uint256 loanEndTimestamp,
        uint256 gasRebate
    );

}

contract LoanClosingsBase is State, LoanClosingsEvents, VaultController, InterestUser, GasTokenUser, SwapsUser, LiquidationHelper {

    enum CloseTypes {
        Deposit,
        Swap,
        Liquidation
    }

    function _LIQUIDATE208(	//inject NONSTANDARD NAMING
        bytes32 loanId,
        address receiver,
        uint256 closeAmount)
        internal
        returns (
            uint256 loanCloseAmount,
            uint256 seizedAmount,
            address seizedToken
        )
    {
        Loan memory loanLocal = loans[loanId];
        require(loanLocal.active, "loan is closed");

        LoanParams memory loanParamsLocal = loanParams[loanLocal.loanParamsId];

        (uint256 currentMargin, uint256 collateralToLoanRate) = IPriceFeeds(priceFeeds).GETCURRENTMARGIN887(
            loanParamsLocal.loanToken,
            loanParamsLocal.collateralToken,
            loanLocal.principal,
            loanLocal.collateral
        );
        require(
            currentMargin <= loanParamsLocal.maintenanceMargin,
            "healthy position"
        );

        if (receiver == address(0)) {
            receiver = msg.sender;
        }

        loanCloseAmount = closeAmount;

        (uint256 maxLiquidatable, uint256 maxSeizable) = _GETLIQUIDATIONAMOUNTS758(
            loanLocal.principal,
            loanLocal.collateral,
            currentMargin,
            loanParamsLocal.maintenanceMargin,
            collateralToLoanRate,
            liquidationIncentivePercent[loanParamsLocal.loanToken][loanParamsLocal.collateralToken]
        );

        if (loanCloseAmount < maxLiquidatable) {
            seizedAmount = maxSeizable
                .MUL0(loanCloseAmount)
                .DIV729(maxLiquidatable);
        } else {
            if (loanCloseAmount > maxLiquidatable) {
                // adjust down the close amount to the max
                loanCloseAmount = maxLiquidatable;
            }
            seizedAmount = maxSeizable;
        }

        require(loanCloseAmount != 0, "nothing to liquidate");

        // liquidator deposits the principal being closed
        _RETURNPRINCIPALWITHDEPOSIT767(
            loanParamsLocal.loanToken,
            address(this),
            loanCloseAmount
        );

        // a portion of the principal is repaid to the lender out of interest refunded
        uint256 loanCloseAmountLessInterest = _SETTLEINTERESTTOPRINCIPAL473(
            loanLocal,
            loanParamsLocal,
            loanCloseAmount,
            loanLocal.borrower
        );

        if (loanCloseAmount > loanCloseAmountLessInterest) {
            // full interest refund goes to the borrower
            _WITHDRAWASSET523(
                loanParamsLocal.loanToken,
                loanLocal.borrower,
                loanCloseAmount - loanCloseAmountLessInterest
            );
        }

        if (loanCloseAmountLessInterest != 0) {
            // The lender always gets back an ERC20 (even WETH), so we call withdraw directly rather than
            // use the _withdrawAsset helper function
            VAULTWITHDRAW131(
                loanParamsLocal.loanToken,
                loanLocal.lender,
                loanCloseAmountLessInterest
            );
        }

        seizedToken = loanParamsLocal.collateralToken;

        if (seizedAmount != 0) {
            loanLocal.collateral = loanLocal.collateral
                .SUB395(seizedAmount);

            _WITHDRAWASSET523(
                seizedToken,
                receiver,
                seizedAmount
            );
        }

        _EMITCLOSINGEVENTS670(
            loanParamsLocal,
            loanLocal,
            loanCloseAmount,
            seizedAmount,
            collateralToLoanRate,
            0, // collateralToLoanSwapRate
            currentMargin,
            CloseTypes.Liquidation
        );

        _CLOSELOAN770(
            loanLocal,
            loanCloseAmount
        );
    }

    function _ROLLOVER360(	//inject NONSTANDARD NAMING
        bytes32 loanId,
        uint256 startingGas,
        bytes memory loanDataBytes)
        internal
    {
        Loan memory loanLocal = loans[loanId];
        require(loanLocal.active, "loan is closed");
        require(
            block.timestamp > loanLocal.endTimestamp.SUB395(1 hours),
            "healthy position"
        );
        require(
            loanPoolToUnderlying[loanLocal.lender] != address(0),
            "invalid lender"
        );

        LoanParams memory loanParamsLocal = loanParams[loanLocal.loanParamsId];

        // pay outstanding interest to lender
        _PAYINTEREST683(
            loanLocal.lender,
            loanParamsLocal.loanToken
        );

        LoanInterest storage loanInterestLocal = loanInterest[loanLocal.id];
        LenderInterest storage lenderInterestLocal = lenderInterest[loanLocal.lender][loanParamsLocal.loanToken];

        _SETTLEFEEREWARDFORINTERESTEXPENSE273(
            loanInterestLocal,
            loanLocal.id,
            loanParamsLocal.loanToken,
            loanLocal.borrower,
            block.timestamp
        );

        // Handle back interest: calculates interest owned since the loan endtime passed but the loan remained open
        uint256 backInterestTime;
        uint256 backInterestOwed;
        if (block.timestamp > loanLocal.endTimestamp) {
            backInterestTime = block.timestamp
                .SUB395(loanLocal.endTimestamp);
            backInterestOwed = backInterestTime
                .MUL0(loanInterestLocal.owedPerDay);
            backInterestOwed = backInterestOwed
                .DIV729(24 hours);
        }

        uint256 maxDuration = loanParamsLocal.maxLoanTerm;

        if (maxDuration != 0) {
            // fixed-term loan, so need to query iToken for latest variable rate
            uint256 owedPerDay = loanLocal.principal
                .MUL0(ILoanPool(loanLocal.lender).BORROWINTERESTRATE911())
                .DIV729(days_in_a_year553 * wei_percent_precision736);

            lenderInterestLocal.owedPerDay = lenderInterestLocal.owedPerDay
                .ADD350(owedPerDay);
            lenderInterestLocal.owedPerDay = lenderInterestLocal.owedPerDay
                .SUB395(loanInterestLocal.owedPerDay);

            loanInterestLocal.owedPerDay = owedPerDay;
        } else {
            // loanInterestLocal.owedPerDay doesn't change
            maxDuration = one_month196;
        }

        if (backInterestTime >= maxDuration) {
            maxDuration = backInterestTime
                .ADD350(24 hours); // adds an extra 24 hours
        }

        // update loan end time
        loanLocal.endTimestamp = loanLocal.endTimestamp
            .ADD350(maxDuration);

        uint256 interestAmountRequired = loanLocal.endTimestamp
            .SUB395(block.timestamp);
        interestAmountRequired = interestAmountRequired
            .MUL0(loanInterestLocal.owedPerDay);
        interestAmountRequired = interestAmountRequired
            .DIV729(24 hours);

        loanInterestLocal.depositTotal = loanInterestLocal.depositTotal
            .ADD350(interestAmountRequired);

        lenderInterestLocal.owedTotal = lenderInterestLocal.owedTotal
            .ADD350(interestAmountRequired);

        // add backInterestOwed
        interestAmountRequired = interestAmountRequired
            .ADD350(backInterestOwed);

        // collect interest
        (,uint256 sourceTokenAmountUsed,) = _DOCOLLATERALSWAP473(
            loanLocal,
            loanParamsLocal,
            loanLocal.collateral,
            interestAmountRequired,
            true, // returnTokenIsCollateral
            loanDataBytes
        );
        loanLocal.collateral = loanLocal.collateral
            .SUB395(sourceTokenAmountUsed);

        if (backInterestOwed != 0) {
            // pay out backInterestOwed

            _PAYINTERESTTRANSFER995(
                loanLocal.lender,
                loanParamsLocal.loanToken,
                backInterestOwed
            );
        }

        uint256 gasRebate = _GETREBATE222(
            loanLocal,
            loanParamsLocal,
            startingGas
        );
        if (gasRebate != 0) {
            // pay out gas rebate to caller
            // the preceeding logic should ensure gasRebate <= collateral, but just in case, will use SafeMath here
            loanLocal.collateral = loanLocal.collateral
                .SUB395(gasRebate, "gasRebate too high");

            _WITHDRAWASSET523(
                loanParamsLocal.collateralToken,
                msg.sender,
                gasRebate
            );
        }

        _ROLLOVEREVENT507(
            loanLocal,
            loanParamsLocal,
            sourceTokenAmountUsed,
            interestAmountRequired,
            gasRebate
        );

        loans[loanId] = loanLocal;
    }

    function _CLOSEWITHDEPOSIT462(	//inject NONSTANDARD NAMING
        bytes32 loanId,
        address receiver,
        uint256 depositAmount) // denominated in loanToken
        internal
        returns (
            uint256 loanCloseAmount,
            uint256 withdrawAmount,
            address withdrawToken
        )
    {
        require(depositAmount != 0, "depositAmount == 0");

        Loan memory loanLocal = loans[loanId];
        _CHECKAUTHORIZED85(
            loanLocal.id,
            loanLocal.active,
            loanLocal.borrower
        );

        if (receiver == address(0)) {
            receiver = msg.sender;
        }

        LoanParams memory loanParamsLocal = loanParams[loanLocal.loanParamsId];

        // can't close more than the full principal
        loanCloseAmount = depositAmount > loanLocal.principal ?
            loanLocal.principal :
            depositAmount;

        uint256 loanCloseAmountLessInterest = _SETTLEINTERESTTOPRINCIPAL473(
            loanLocal,
            loanParamsLocal,
            loanCloseAmount,
            receiver
        );

        if (loanCloseAmountLessInterest != 0) {
            _RETURNPRINCIPALWITHDEPOSIT767(
                loanParamsLocal.loanToken,
                loanLocal.lender,
                loanCloseAmountLessInterest
            );
        }

        uint256 withdrawAmount;
        if (loanCloseAmount == loanLocal.principal) {
            // collateral is only withdrawn if the loan is closed in full
            withdrawAmount = loanLocal.collateral;
            withdrawToken = loanParamsLocal.collateralToken;
            loanLocal.collateral = 0;

            _WITHDRAWASSET523(
                withdrawToken,
                receiver,
                withdrawAmount
            );
        }

        _FINALIZECLOSE273(
            loanLocal,
            loanParamsLocal,
            loanCloseAmount,
            withdrawAmount, // collateralCloseAmount
            0, // collateralToLoanSwapRate
            CloseTypes.Deposit
        );
    }

    function _CLOSEWITHSWAP962(	//inject NONSTANDARD NAMING
        bytes32 loanId,
        address receiver,
        uint256 swapAmount,
        bool returnTokenIsCollateral,
        bytes memory loanDataBytes)
        internal
        returns (
            uint256 loanCloseAmount,
            uint256 withdrawAmount,
            address withdrawToken
        )
    {
        require(swapAmount != 0, "swapAmount == 0");

        Loan memory loanLocal = loans[loanId];
        _CHECKAUTHORIZED85(
            loanLocal.id,
            loanLocal.active,
            loanLocal.borrower
        );

        if (receiver == address(0)) {
            receiver = msg.sender;
        }

        LoanParams memory loanParamsLocal = loanParams[loanLocal.loanParamsId];

        if (swapAmount > loanLocal.collateral) {
            swapAmount = loanLocal.collateral;
        }

        loanCloseAmount = loanLocal.principal;
        if (swapAmount != loanLocal.collateral) {
            loanCloseAmount = loanCloseAmount
                .MUL0(swapAmount)
                .DIV729(loanLocal.collateral);
        }
        require(loanCloseAmount != 0, "loanCloseAmount == 0");

        uint256 loanCloseAmountLessInterest = _SETTLEINTERESTTOPRINCIPAL473(
            loanLocal,
            loanParamsLocal,
            loanCloseAmount,
            receiver
        );

        uint256 usedCollateral;
        uint256 collateralToLoanSwapRate;
        (usedCollateral, withdrawAmount, collateralToLoanSwapRate) = _COVERPRINCIPALWITHSWAP500(
            loanLocal,
            loanParamsLocal,
            swapAmount,
            loanCloseAmountLessInterest,
            returnTokenIsCollateral,
            loanDataBytes
        );

        if (loanCloseAmountLessInterest != 0) {
            // Repays principal to lender
            // The lender always gets back an ERC20 (even WETH), so we call withdraw directly rather than
            // use the _withdrawAsset helper function
            VAULTWITHDRAW131(
                loanParamsLocal.loanToken,
                loanLocal.lender,
                loanCloseAmountLessInterest
            );
        }

        if (usedCollateral != 0) {
            loanLocal.collateral = loanLocal.collateral
                .SUB395(usedCollateral);
        }

        withdrawToken = returnTokenIsCollateral ?
            loanParamsLocal.collateralToken :
            loanParamsLocal.loanToken;

        if (withdrawAmount != 0) {
            _WITHDRAWASSET523(
                withdrawToken,
                receiver,
                withdrawAmount
            );
        }

        _FINALIZECLOSE273(
            loanLocal,
            loanParamsLocal,
            loanCloseAmount,
            usedCollateral,
            collateralToLoanSwapRate,
            CloseTypes.Swap
        );
    }

    function _CHECKAUTHORIZED85(	//inject NONSTANDARD NAMING
        bytes32 _id,
        bool _active,
        address _borrower)
        internal
        view
    {
        require(_active, "loan is closed");
        require(
            msg.sender == _borrower ||
            delegatedManagers[_id][msg.sender],
            "unauthorized"
        );
    }

    function _SETTLEINTERESTTOPRINCIPAL473(	//inject NONSTANDARD NAMING
        Loan memory loanLocal,
        LoanParams memory loanParamsLocal,
        uint256 loanCloseAmount,
        address receiver)
        internal
        returns (uint256)
    {
        uint256 loanCloseAmountLessInterest = loanCloseAmount;

        uint256 interestRefundToBorrower = _SETTLEINTEREST436(
            loanParamsLocal,
            loanLocal,
            loanCloseAmountLessInterest
        );

        uint256 interestAppliedToPrincipal;
        if (loanCloseAmountLessInterest >= interestRefundToBorrower) {
            // apply all of borrower interest refund torwards principal
            interestAppliedToPrincipal = interestRefundToBorrower;

            // principal needed is reduced by this amount
            loanCloseAmountLessInterest -= interestRefundToBorrower;

            // no interest refund remaining
            interestRefundToBorrower = 0;
        } else {
            // principal fully covered by excess interest
            interestAppliedToPrincipal = loanCloseAmountLessInterest;

            // amount refunded is reduced by this amount
            interestRefundToBorrower -= loanCloseAmountLessInterest;

            // principal fully covered by excess interest
            loanCloseAmountLessInterest = 0;

            // refund overage
            _WITHDRAWASSET523(
                loanParamsLocal.loanToken,
                receiver,
                interestRefundToBorrower
            );
        }

        if (interestAppliedToPrincipal != 0) {
            // The lender always gets back an ERC20 (even WETH), so we call withdraw directly rather than
            // use the _withdrawAsset helper function
            VAULTWITHDRAW131(
                loanParamsLocal.loanToken,
                loanLocal.lender,
                interestAppliedToPrincipal
            );
        }

        return loanCloseAmountLessInterest;
    }

    // The receiver always gets back an ERC20 (even WETH)
    function _RETURNPRINCIPALWITHDEPOSIT767(	//inject NONSTANDARD NAMING
        address loanToken,
        address receiver,
        uint256 principalNeeded)
        internal
    {
        if (principalNeeded != 0) {
            if (msg.value == 0) {
                VAULTTRANSFER888(
                    loanToken,
                    msg.sender,
                    receiver,
                    principalNeeded
                );
            } else {
                require(loanToken == address(wethtoken696), "wrong asset sent");
                require(msg.value >= principalNeeded, "not enough ether");
                wethtoken696.DEPOSIT413.value(principalNeeded)();
                if (receiver != address(this)) {
                    VAULTTRANSFER888(
                        loanToken,
                        address(this),
                        receiver,
                        principalNeeded
                    );
                }
                if (msg.value > principalNeeded) {
                    // refund overage
                    Address.SENDVALUE363(
                        msg.sender,
                        msg.value - principalNeeded
                    );
                }
            }
        } else {
            require(msg.value == 0, "wrong asset sent");
        }
    }

    function _COVERPRINCIPALWITHSWAP500(	//inject NONSTANDARD NAMING
        Loan memory loanLocal,
        LoanParams memory loanParamsLocal,
        uint256 swapAmount,
        uint256 principalNeeded,
        bool returnTokenIsCollateral,
        bytes memory loanDataBytes)
        internal
        returns (uint256 usedCollateral, uint256 withdrawAmount, uint256 collateralToLoanSwapRate)
    {
        uint256 destTokenAmountReceived;
        uint256 sourceTokenAmountUsed;
        (destTokenAmountReceived, sourceTokenAmountUsed, collateralToLoanSwapRate) = _DOCOLLATERALSWAP473(
            loanLocal,
            loanParamsLocal,
            swapAmount,
            principalNeeded,
            returnTokenIsCollateral,
            loanDataBytes
        );

        if (returnTokenIsCollateral) {
            if (destTokenAmountReceived > principalNeeded) {
                // better fill than expected, so send excess to borrower
                _WITHDRAWASSET523(
                    loanParamsLocal.loanToken,
                    loanLocal.borrower,
                    destTokenAmountReceived - principalNeeded
                );
            }
            withdrawAmount = swapAmount > sourceTokenAmountUsed ?
                swapAmount - sourceTokenAmountUsed :
                0;
        } else {
            require(sourceTokenAmountUsed == swapAmount, "swap error");
            withdrawAmount = destTokenAmountReceived - principalNeeded;
        }

        usedCollateral = sourceTokenAmountUsed > swapAmount ?
            sourceTokenAmountUsed :
            swapAmount;
    }

    function _DOCOLLATERALSWAP473(	//inject NONSTANDARD NAMING
        Loan memory loanLocal,
        LoanParams memory loanParamsLocal,
        uint256 swapAmount,
        uint256 principalNeeded,
        bool returnTokenIsCollateral,
        bytes memory loanDataBytes)
        internal
        returns (uint256 destTokenAmountReceived, uint256 sourceTokenAmountUsed, uint256 collateralToLoanSwapRate)
    {
        (destTokenAmountReceived, sourceTokenAmountUsed, collateralToLoanSwapRate) = _LOANSWAP802(
            loanLocal.id,
            loanParamsLocal.collateralToken,
            loanParamsLocal.loanToken,
            loanLocal.borrower,
            swapAmount, // minSourceTokenAmount
            loanLocal.collateral, // maxSourceTokenAmount
            returnTokenIsCollateral ?
                principalNeeded :  // requiredDestTokenAmount
                0,
            false, // bypassFee
            loanDataBytes
        );
        require(destTokenAmountReceived >= principalNeeded, "insufficient dest amount");
        require(sourceTokenAmountUsed <= loanLocal.collateral, "excessive source amount");
    }

    // withdraws asset to receiver
    function _WITHDRAWASSET523(	//inject NONSTANDARD NAMING
        address assetToken,
        address receiver,
        uint256 assetAmount)
        internal
    {
        if (assetAmount != 0) {
            if (assetToken == address(wethtoken696)) {
                VAULTETHERWITHDRAW1(
                    receiver,
                    assetAmount
                );
            } else {
                VAULTWITHDRAW131(
                    assetToken,
                    receiver,
                    assetAmount
                );
            }
        }
    }

    function _FINALIZECLOSE273(	//inject NONSTANDARD NAMING
        Loan memory loanLocal,
        LoanParams memory loanParamsLocal,
        uint256 loanCloseAmount,
        uint256 collateralCloseAmount,
        uint256 collateralToLoanSwapRate,
        CloseTypes closeType)
        internal
    {
        _CLOSELOAN770(
            loanLocal,
            loanCloseAmount
        );

        address _priceFeeds = priceFeeds;
        uint256 currentMargin;
        uint256 collateralToLoanRate;

        // this is still called even with full loan close to return collateralToLoanRate
        (bool success, bytes memory data) = _priceFeeds.staticcall(
            abi.encodeWithSelector(
                IPriceFeeds(_priceFeeds).GETCURRENTMARGIN887.selector,
                loanParamsLocal.loanToken,
                loanParamsLocal.collateralToken,
                loanLocal.principal,
                loanLocal.collateral
            )
        );
        assembly {
            if eq(success, 1) {
                currentMargin := mload(add(data, 32))
                collateralToLoanRate := mload(add(data, 64))
            }
        }
                                                                                                                                        
        require(
            closeType == CloseTypes.Deposit ||
            loanLocal.principal == 0 || // loan fully closed
            currentMargin > loanParamsLocal.maintenanceMargin,
            "unhealthy position"
        );

        _EMITCLOSINGEVENTS670(
            loanParamsLocal,
            loanLocal,
            loanCloseAmount,
            collateralCloseAmount,
            collateralToLoanRate,
            collateralToLoanSwapRate,
            currentMargin,
            closeType
        );
    }

    function _CLOSELOAN770(	//inject NONSTANDARD NAMING
        Loan memory loanLocal,
        uint256 loanCloseAmount)
        internal
        returns (uint256)
    {
        require(loanCloseAmount != 0, "nothing to close");

        if (loanCloseAmount == loanLocal.principal) {
            loanLocal.principal = 0;
            loanLocal.active = false;
            loanLocal.endTimestamp = block.timestamp;
            loanLocal.pendingTradesId = 0;
            activeLoansSet.REMOVEBYTES32129(loanLocal.id);
            lenderLoanSets[loanLocal.lender].REMOVEBYTES32129(loanLocal.id);
            borrowerLoanSets[loanLocal.borrower].REMOVEBYTES32129(loanLocal.id);
        } else {
            loanLocal.principal = loanLocal.principal
                .SUB395(loanCloseAmount);
        }

        loans[loanLocal.id] = loanLocal;
    }

    function _SETTLEINTEREST436(	//inject NONSTANDARD NAMING
        LoanParams memory loanParamsLocal,
        Loan memory loanLocal,
        uint256 closePrincipal)
        internal
        returns (uint256)
    {
        // pay outstanding interest to lender
        _PAYINTEREST683(
            loanLocal.lender,
            loanParamsLocal.loanToken
        );

        LoanInterest storage loanInterestLocal = loanInterest[loanLocal.id];
        LenderInterest storage lenderInterestLocal = lenderInterest[loanLocal.lender][loanParamsLocal.loanToken];

        uint256 interestTime = block.timestamp;
        if (interestTime > loanLocal.endTimestamp) {
            interestTime = loanLocal.endTimestamp;
        }

        _SETTLEFEEREWARDFORINTERESTEXPENSE273(
            loanInterestLocal,
            loanLocal.id,
            loanParamsLocal.loanToken,
            loanLocal.borrower,
            interestTime
        );

        uint256 owedPerDayRefund;
        if (closePrincipal < loanLocal.principal) {
            owedPerDayRefund = loanInterestLocal.owedPerDay
                .MUL0(closePrincipal)
                .DIV729(loanLocal.principal);
        } else {
            owedPerDayRefund = loanInterestLocal.owedPerDay;
        }

        // update stored owedPerDay
        loanInterestLocal.owedPerDay = loanInterestLocal.owedPerDay
            .SUB395(owedPerDayRefund);
        lenderInterestLocal.owedPerDay = lenderInterestLocal.owedPerDay
            .SUB395(owedPerDayRefund);

        // update borrower interest
        uint256 interestRefundToBorrower = loanLocal.endTimestamp
            .SUB395(interestTime);
        interestRefundToBorrower = interestRefundToBorrower
            .MUL0(owedPerDayRefund);
        interestRefundToBorrower = interestRefundToBorrower
            .DIV729(24 hours);

        if (closePrincipal < loanLocal.principal) {
            loanInterestLocal.depositTotal = loanInterestLocal.depositTotal
                .SUB395(interestRefundToBorrower);
        } else {
            loanInterestLocal.depositTotal = 0;
        }

        // update remaining lender interest values
        lenderInterestLocal.principalTotal = lenderInterestLocal.principalTotal
            .SUB395(closePrincipal);

        uint256 owedTotal = lenderInterestLocal.owedTotal;
        lenderInterestLocal.owedTotal = owedTotal > interestRefundToBorrower ?
            owedTotal - interestRefundToBorrower :
            0;

        return interestRefundToBorrower;
    }

    function _GETREBATE222(	//inject NONSTANDARD NAMING
        Loan memory loanLocal,
        LoanParams memory loanParamsLocal,
        uint256 startingGas)
        internal
        returns (uint256 gasRebate)
    {
        // the amount of collateral drop needed to reach the maintenanceMargin level of the loan
        uint256 maxDrawdown = IPriceFeeds(priceFeeds).GETMAXDRAWDOWN818(
            loanParamsLocal.loanToken,
            loanParamsLocal.collateralToken,
            loanLocal.principal,
            loanLocal.collateral,
            loanParamsLocal.maintenanceMargin
        );
        require(maxDrawdown != 0, "unhealthy position");

        // gets the gas rebate denominated in collateralToken
        gasRebate = SafeMath.MUL0(
            IPriceFeeds(priceFeeds).GETFASTGASPRICE944(loanParamsLocal.collateralToken) * 2,
            _GASUSED486(startingGas)
        );

        // ensures the gas rebate will not drop the current margin below the maintenance level
        gasRebate = gasRebate
            .MIN256991(maxDrawdown);
    }

    function _ROLLOVEREVENT507(	//inject NONSTANDARD NAMING
        Loan memory loanLocal,
        LoanParams memory loanParamsLocal,
        uint256 sourceTokenAmountUsed,
        uint256 interestAmountRequired,
        uint256 gasRebate)
        internal
    {
        emit ROLLOVER791(
            loanLocal.borrower,                 // user (borrower)
            msg.sender,                         // caller
            loanLocal.id,                       // loanId
            loanLocal.lender,                   // lender
            loanParamsLocal.loanToken,          // loanToken
            loanParamsLocal.collateralToken,    // collateralToken
            sourceTokenAmountUsed,              // collateralAmountUsed
            interestAmountRequired,             // interestAmountAdded
            loanLocal.endTimestamp,             // loanEndTimestamp
            gasRebate                           // gasRebate
        );
    }

    function _EMITCLOSINGEVENTS670(	//inject NONSTANDARD NAMING
        LoanParams memory loanParamsLocal,
        Loan memory loanLocal,
        uint256 loanCloseAmount,
        uint256 collateralCloseAmount,
        uint256 collateralToLoanRate,
        uint256 collateralToLoanSwapRate,
        uint256 currentMargin,
        CloseTypes closeType)
        internal
    {
        if (closeType == CloseTypes.Deposit) {
            emit CLOSEWITHDEPOSIT137(
                loanLocal.borrower,                             // user (borrower)
                loanLocal.lender,                               // lender
                loanLocal.id,                                   // loanId
                msg.sender,                                     // closer
                loanParamsLocal.loanToken,                      // loanToken
                loanParamsLocal.collateralToken,                // collateralToken
                loanCloseAmount,                                // loanCloseAmount
                collateralCloseAmount,                          // collateralCloseAmount
                collateralToLoanRate,                           // collateralToLoanRate
                currentMargin                                   // currentMargin
            );
        } else if (closeType == CloseTypes.Swap) {
            // exitPrice = 1 / collateralToLoanSwapRate
            if (collateralToLoanSwapRate != 0) {
                collateralToLoanSwapRate = SafeMath.DIV729(wei_precision427 * wei_precision427, collateralToLoanSwapRate);
            }

            // currentLeverage = 100 / currentMargin
            if (currentMargin != 0) {
                currentMargin = SafeMath.DIV729(10**38, currentMargin);
            }

            emit CLOSEWITHSWAP232(
                loanLocal.borrower,                             // user (trader)
                loanLocal.lender,                               // lender
                loanLocal.id,                                   // loanId
                loanParamsLocal.collateralToken,                // collateralToken
                loanParamsLocal.loanToken,                      // loanToken
                msg.sender,                                     // closer
                collateralCloseAmount,                          // positionCloseSize
                loanCloseAmount,                                // loanCloseAmount
                collateralToLoanSwapRate,                       // exitPrice (1 / collateralToLoanSwapRate)
                currentMargin                                   // currentLeverage
            );
        } else { // closeType == CloseTypes.Liquidation
            emit LIQUIDATE807(
                loanLocal.borrower,                             // user (borrower)
                msg.sender,                                     // liquidator
                loanLocal.id,                                   // loanId
                loanLocal.lender,                               // lender
                loanParamsLocal.loanToken,                      // loanToken
                loanParamsLocal.collateralToken,                // collateralToken
                loanCloseAmount,                                // loanCloseAmount
                collateralCloseAmount,                          // collateralCloseAmount
                collateralToLoanRate,                           // collateralToLoanRate
                currentMargin                                   // currentMargin
            );
        }
    }
}

contract LoanClosingsWithGasToken is LoanClosingsBase {

    function INITIALIZE821(	//inject NONSTANDARD NAMING
        address target)
        external
        ONLYOWNER855
    {
        _SETTARGET405(this.LIQUIDATEWITHGASTOKEN944.selector, target);
        _SETTARGET405(this.ROLLOVERWITHGASTOKEN936.selector, target);
        _SETTARGET405(this.CLOSEWITHDEPOSITWITHGASTOKEN57.selector, target);
        _SETTARGET405(this.CLOSEWITHSWAPWITHGASTOKEN662.selector, target);
    }

    function LIQUIDATEWITHGASTOKEN944(	//inject NONSTANDARD NAMING
        bytes32 loanId,
        address receiver,
        address gasTokenUser,
        uint256 closeAmount) // denominated in loanToken
        external
        payable
        USESGASTOKEN390(gasTokenUser)
        NONREENTRANT587
        returns (
            uint256 loanCloseAmount,
            uint256 seizedAmount,
            address seizedToken
        )
    {
        return _LIQUIDATE208(
            loanId,
            receiver,
            closeAmount
        );
    }

    function ROLLOVERWITHGASTOKEN936(	//inject NONSTANDARD NAMING
        bytes32 loanId,
        address gasTokenUser,
        bytes calldata                  ) // for future use
        external
        USESGASTOKEN390(gasTokenUser)
        NONREENTRANT587
    {
        uint256 startingGas = 21000 + gasleft() + 16 * msg.data.length;

        // restrict to EOAs to prevent griefing attacks, during interest rate recalculation
        require(msg.sender == tx.origin, "only EOAs can call");

        return _ROLLOVER360(
            loanId,
            startingGas,
            "" // loanDataBytes
        );
    }

    function CLOSEWITHDEPOSITWITHGASTOKEN57(	//inject NONSTANDARD NAMING
        bytes32 loanId,
        address receiver,
        address gasTokenUser,
        uint256 depositAmount) // denominated in loanToken
        public
        payable
        USESGASTOKEN390(gasTokenUser)
        NONREENTRANT587
        returns (
            uint256 loanCloseAmount,
            uint256 withdrawAmount,
            address withdrawToken
        )
    {
        return _CLOSEWITHDEPOSIT462(
            loanId,
            receiver,
            depositAmount
        );
    }

    function CLOSEWITHSWAPWITHGASTOKEN662(	//inject NONSTANDARD NAMING
        bytes32 loanId,
        address receiver,
        address gasTokenUser,
        uint256 swapAmount, // denominated in collateralToken
        bool returnTokenIsCollateral, // true: withdraws collateralToken, false: withdraws loanToken
        bytes memory                  ) // for future use
        public
        USESGASTOKEN390(gasTokenUser)
        NONREENTRANT587
        returns (
            uint256 loanCloseAmount,
            uint256 withdrawAmount,
            address withdrawToken
        )
    {
        return _CLOSEWITHSWAP962(
            loanId,
            receiver,
            swapAmount,
            returnTokenIsCollateral,
            "" // loanDataBytes
        );
    }
}