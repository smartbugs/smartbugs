pragma solidity ^0.5.7;

// Voken Public Sale
// 
// More info:
//   https://vision.network
//   https://voken.io
//
// Contact us:
//   support@vision.network
//   support@voken.io


/**
 * @title SafeMath for uint256
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath256 {
    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient,
     * reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return a / b;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/**
 * @title SafeMath for uint16
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath16 {
    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint16 a, uint16 b) internal pure returns (uint16) {
        assert(b <= a);
        return a - b;
    }

    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient,
     * reverts on division by zero.
     */
    function div(uint16 a, uint16 b) internal pure returns (uint16) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return a / b;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint16 a, uint16 b) internal pure returns (uint16) {
        require(b != 0);
        return a % b;
    }
}


/**
 * @title Ownable
 */
contract Ownable {
    address private _owner;
    address payable internal _receiver;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract
     * to the sender account.
     */
    constructor () internal {
        _owner = msg.sender;
        _receiver = msg.sender;
    }

    /**
     * @return The address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0));
        address __previousOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(__previousOwner, newOwner);
    }

    /**
     * @dev Change receiver.
     */
    function changeReceiver(address payable newReceiver) external onlyOwner {
        require(newReceiver != address(0));
        address __previousReceiver = _receiver;
        _receiver = newReceiver;
        emit ReceiverChanged(__previousReceiver, newReceiver);
    }

    /**
     * @dev Rescue compatible ERC20 Token
     *
     * @param tokenAddr ERC20 The address of the ERC20 token contract
     * @param receiver The address of the receiver
     * @param amount uint256
     */
    function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
        IERC20 _token = IERC20(tokenAddr);
        require(receiver != address(0));
        uint256 balance = _token.balanceOf(address(this));
        require(balance >= amount);

        assert(_token.transfer(receiver, amount));
    }

    /**
     * @dev Withdraw ether
     */
    function withdrawEther(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0));
        uint256 balance = address(this).balance;
        require(balance >= amount);

        to.transfer(amount);
    }
}


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
    bool private _paused;

    event Paused(address account);
    event Unpaused(address account);

    constructor () internal {
        _paused = false;
    }

    /**
     * @return Returns true if the contract is paused, false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Paused.");
        _;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function setPaused(bool state) external onlyOwner {
        if (_paused && !state) {
            _paused = false;
            emit Unpaused(msg.sender);
        } else if (!_paused && state) {
            _paused = true;
            emit Paused(msg.sender);
        }
    }
}


/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}


/**
 * @title Voken interface
 */
interface IVoken {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function inWhitelist(address account) external view returns (bool);
    function referrer(address account) external view returns (address);
    function refCount(address account) external view returns (uint256);
}


/**
 * @title Voken Public Sale
 */
contract VokenPublicSale is Ownable, Pausable{
    using SafeMath16 for uint16;
    using SafeMath256 for uint256;

    // Voken
    IVoken public VOKEN = IVoken(0x82070415FEe803f94Ce5617Be1878503e58F0a6a);

    // Start timestamp
    uint32 _startTimestamp;

    // Audit ether price
    uint256 private _etherPrice;    // 1 Ether = xx.xxxxxx USD, with 6 decimals

    // Referral rewards, 35% for 15 levels
    uint16 private WHITELIST_REF_REWARDS_PCT_SUM = 35;
    uint16[15] private WHITELIST_REF_REWARDS_PCT = [
        6,  // 6% for Level.1
        6,  // 6% for Level.2
        5,  // 5% for Level.3
        4,  // 4% for Level.4
        3,  // 3% for Level.5
        2,  // 2% for Level.6
        1,  // 1% for Level.7
        1,  // 1% for Level.8
        1,  // 1% for Level.9
        1,  // 1% for Level.10
        1,  // 1% for Level.11
        1,  // 1% for Level.12
        1,  // 1% for Level.13
        1,  // 1% for Level.14
        1   // 1% for Level.15
    ];

    // Wei & Gas
    uint72 private WEI_MIN = 0.1 ether;     // 0.1 Ether Minimum
    uint72 private WEI_MAX = 100 ether;     // 100 Ether Maximum
    uint72 private WEI_BONUS = 10 ether;    // >10 Ether for Bonus
    uint24 private GAS_MIN = 3000000;       // 3.0 Mwei gas Mininum
    uint24 private GAS_EX = 1500000;        // 1.5 Mwei gas for ex

    // Price
    uint256 private VOKEN_USD_PRICE_START = 1000;       // $      0.00100 USD    
    uint256 private VOKEN_USD_PRICE_STEP = 10;          // $    + 0.00001 USD
    uint256 private STAGE_USD_CAP_START = 100000000;    // $    100 USD
    uint256 private STAGE_USD_CAP_STEP = 1000000;       // $     +1 USD
    uint256 private STAGE_USD_CAP_MAX = 15100000000;    // $ 15,100 USD

    uint256 private _vokenUsdPrice = VOKEN_USD_PRICE_START;

    // Progress
    uint16 private STAGE_MAX = 60000;   // 60,000 stages total
    uint16 private SEASON_MAX = 100;    // 100 seasons total
    uint16 private SEASON_STAGES = 600; // each 600 stages is a season

    uint16 private _stage;
    uint16 private _season;

    // Sum
    uint256 private _txs;
    uint256 private _vokenTxs;
    uint256 private _vokenBonusTxs;
    uint256 private _vokenWhitelistTxs;
    uint256 private _vokenIssued;
    uint256 private _vokenBonus;
    uint256 private _vokenWhitelist;
    uint256 private _weiSold;
    uint256 private _weiRefRewarded;
    uint256 private _weiTopSales;
    uint256 private _weiTeam;
    uint256 private _weiPending;
    uint256 private _weiPendingTransfered;

    // Top-Sales
    uint256 private TOP_SALES_RATIO_START = 15000000;         // 15%, with 8 decimals
    uint256 private TOP_SALES_RATIO_DISTANCE = 50000000;      // 50%, with 8 decimals

    uint256 private _topSalesRatio = TOP_SALES_RATIO_START;   // 15% + 50% x(_stage/_stageMax)

    // During tx
    bool private _inWhitelist_;
    uint256 private _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;
    uint16[] private _rewards_;
    address[] private _referrers_;

    // Audit ether price auditor
    mapping (address => bool) private _etherPriceAuditors;

    // Stage
    mapping (uint16 => uint256) private _stageUsdSold;
    mapping (uint16 => uint256) private _stageVokenIssued;

    // Season
    mapping (uint16 => uint256) private _seasonWeiSold;
    mapping (uint16 => uint256) private _seasonWeiTopSales;
    mapping (uint16 => uint256) private _seasonWeiTopSalesTransfered;

    // Account
    mapping (address => uint256) private _accountVokenIssued;
    mapping (address => uint256) private _accountVokenBonus;
    mapping (address => uint256) private _accountVokenWhitelisted;
    mapping (address => uint256) private _accountWeiPurchased;
    mapping (address => uint256) private _accountWeiRefRewarded;

    // Ref
    mapping (uint16 => address[]) private _seasonRefAccounts;
    mapping (uint16 => mapping (address => bool)) private _seasonHasRefAccount;
    mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountPurchased;
    mapping (uint16 => mapping (address => uint256)) private _usdSeasonAccountRef;

    // Events
    event AuditEtherPriceChanged(uint256 value, address indexed account);
    event AuditEtherPriceAuditorChanged(address indexed account, bool state);

    event VokenBonusTransfered(address indexed to, uint256 amount);
    event VokenWhitelistTransfered(address indexed to, uint256 amount);
    event VokenIssuedTransfered(uint16 stageIndex, address indexed to, uint256 vokenAmount, uint256 auditEtherPrice, uint256 weiUsed);

    event StageClosed(uint256 _stageNumber, address indexed account);
    event SeasonClosed(uint16 _seasonNumber, address indexed account);

    event SeasonTopSalesWeiTransfered(uint16 seasonNumber, address indexed to, uint256 amount);
    event TeamWeiTransfered(address indexed to, uint256 amount);
    event PendingWeiTransfered(address indexed to, uint256 amount);


    /**
     * @dev Start timestamp.
     */
    function startTimestamp() public view returns (uint32) {
        return _startTimestamp;
    }

    /**
     * @dev Set start timestamp.
     */
    function setStartTimestamp(uint32 timestamp) external onlyOwner {
        _startTimestamp = timestamp;
    }

    /**
     * @dev Throws if not ether price auditor.
     */
    modifier onlyEtherPriceAuditor() {
        require(_etherPriceAuditors[msg.sender]);
        _;
    }

    /**
     * @dev Set audit ether price.
     */
    function setEtherPrice(uint256 value) external onlyEtherPriceAuditor {
        _etherPrice = value;
        emit AuditEtherPriceChanged(value, msg.sender);
    }

    /**
     * @dev Get ether price auditor state.
     */
    function etherPriceAuditor(address account) public view returns (bool) {
        return _etherPriceAuditors[account];
    }

    /**
     * @dev Get ether price auditor state.
     */
    function setEtherPriceAuditor(address account, bool state) external onlyOwner {
        _etherPriceAuditors[account] = state;
        emit AuditEtherPriceAuditorChanged(account, state);
    }

    /**
     * @dev Stage Voken price in USD, by stage index.
     */
    function stageVokenUsdPrice(uint16 stageIndex) private view returns (uint256) {
        return VOKEN_USD_PRICE_START.add(VOKEN_USD_PRICE_STEP.mul(stageIndex));
    }

    /**
     * @dev wei => USD
     */
    function wei2usd(uint256 amount) private view returns (uint256) {
        return amount.mul(_etherPrice).div(1 ether);
    }

    /**
     * @dev USD => wei
     */
    function usd2wei(uint256 amount) private view returns (uint256) {
        return amount.mul(1 ether).div(_etherPrice);
    }

    /**
     * @dev USD => voken
     */
    function usd2voken(uint256 usdAmount) private view returns (uint256) {
        return usdAmount.mul(1000000).div(_vokenUsdPrice);
    }

    /**
     * @dev USD => voken
     */
    function usd2vokenByStage(uint256 usdAmount, uint16 stageIndex) public view returns (uint256) {
        return usdAmount.mul(1000000).div(stageVokenUsdPrice(stageIndex));
    }

    /**
     * @dev Calculate season number, by stage index.
     */
    function calcSeason(uint16 stageIndex) private view returns (uint16) {
        if (stageIndex > 0) {
            uint16 __seasonNumber = stageIndex.div(SEASON_STAGES);

            if (stageIndex.mod(SEASON_STAGES) > 0) {
                return __seasonNumber.add(1);
            }
            
            return __seasonNumber;
        }
        
        return 1;
    }

    /**
     * @dev Transfer Top-Sales wei, by season number.
     */
    function transferTopSales(uint16 seasonNumber, address payable to) external onlyOwner {
        uint256 __weiRemain = seasonTopSalesRemain(seasonNumber);
        require(to != address(0));
        
        _seasonWeiTopSalesTransfered[seasonNumber] = _seasonWeiTopSalesTransfered[seasonNumber].add(__weiRemain);
        emit SeasonTopSalesWeiTransfered(seasonNumber, to, __weiRemain);
        to.transfer(__weiRemain);
    }

    /**
     * @dev Pending remain, in wei.
     */
    function pendingRemain() private view returns (uint256) {
        return _weiPending.sub(_weiPendingTransfered);
    }

    /**
     * @dev Transfer pending wei.
     */
    function transferPending(address payable to) external onlyOwner {
        uint256 __weiRemain = pendingRemain();
        require(to != address(0));

        _weiPendingTransfered = _weiPendingTransfered.add(__weiRemain);
        emit PendingWeiTransfered(to, __weiRemain);
        to.transfer(__weiRemain);
    }

    /**
     * @dev Transfer team wei.
     */
    function transferTeam(address payable to) external onlyOwner {
        uint256 __weiRemain = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
        require(to != address(0));

        _weiTeam = _weiTeam.add(__weiRemain);
        emit TeamWeiTransfered(to, __weiRemain);
        to.transfer(__weiRemain);
    }

    /**
     * @dev Status.
     */
    function status() public view returns (uint256 auditEtherPrice,
                                           uint16 stage,
                                           uint16 season,
                                           uint256 vokenUsdPrice,
                                           uint256 currentTopSalesRatio,
                                           uint256 txs,
                                           uint256 vokenTxs,
                                           uint256 vokenBonusTxs,
                                           uint256 vokenWhitelistTxs,
                                           uint256 vokenIssued,
                                           uint256 vokenBonus,
                                           uint256 vokenWhitelist) {
        auditEtherPrice = _etherPrice;

        if (_stage > STAGE_MAX) {
            stage = STAGE_MAX;
            season = SEASON_MAX;
        } else {
            stage = _stage;
            season = _season;
        }

        vokenUsdPrice = _vokenUsdPrice;
        currentTopSalesRatio = _topSalesRatio;

        txs = _txs;
        vokenTxs = _vokenTxs;
        vokenBonusTxs = _vokenBonusTxs;
        vokenWhitelistTxs = _vokenWhitelistTxs;
        vokenIssued = _vokenIssued;
        vokenBonus = _vokenBonus;
        vokenWhitelist = _vokenWhitelist;
    }

    /**
     * @dev Sum.
     */
    function sum() public view returns(uint256 weiSold,
                                       uint256 weiReferralRewarded,
                                       uint256 weiTopSales,
                                       uint256 weiTeam,
                                       uint256 weiPending,
                                       uint256 weiPendingTransfered,
                                       uint256 weiPendingRemain) {
        weiSold = _weiSold;
        weiReferralRewarded = _weiRefRewarded;
        weiTopSales = _weiTopSales;
        weiTeam = _weiTeam;
        weiPending = _weiPending;
        weiPendingTransfered = _weiPendingTransfered;
        weiPendingRemain = pendingRemain();
    }

    /**
     * @dev Throws if gas is not enough.
     */
    modifier enoughGas() {
        require(gasleft() > GAS_MIN);
        _;
    }

    /**
     * @dev Throws if not started.
     */
    modifier onlyOnSale() {
        require(_startTimestamp > 0 && now > _startTimestamp, "Voken Public-Sale has not started yet.");
        require(_etherPrice > 0, "Audit ETH price must be greater than zero.");
        require(!paused(), "Voken Public-Sale is paused.");
        require(_stage <= STAGE_MAX, "Voken Public-Sale Closed.");
        _;
    }

    /**
     * @dev Top-Sales ratio.
     */
    function topSalesRatio(uint16 stageIndex) private view returns (uint256) {
        return TOP_SALES_RATIO_START.add(TOP_SALES_RATIO_DISTANCE.mul(stageIndex).div(STAGE_MAX));
    }

    /**
     * @dev USD => wei, for Top-Sales
     */
    function usd2weiTopSales(uint256 usdAmount) private view returns (uint256) {
        return usd2wei(usdAmount.mul(_topSalesRatio).div(100000000));
    }

    /**
     * @dev Calculate stage dollor cap, by stage index.
     */
    function stageUsdCap(uint16 stageIndex) private view returns (uint256) {
        uint256 __usdCap = STAGE_USD_CAP_START.add(STAGE_USD_CAP_STEP.mul(stageIndex)); 

        if (__usdCap > STAGE_USD_CAP_MAX) {
            return STAGE_USD_CAP_MAX;
        }

        return __usdCap;
    }

    /**
     * @dev Stage Vokdn cap, by stage index.
     */
    function stageVokenCap(uint16 stageIndex) private view returns (uint256) {
        return usd2vokenByStage(stageUsdCap(stageIndex), stageIndex);
    }

    /**
     * @dev Stage status, by stage index.
     */
    function stageStatus(uint16 stageIndex) public view returns (uint256 vokenUsdPrice,
                                                                 uint256 vokenCap,
                                                                 uint256 vokenOnSale,
                                                                 uint256 vokenSold,
                                                                 uint256 usdCap,
                                                                 uint256 usdOnSale,
                                                                 uint256 usdSold,
                                                                 uint256 weiTopSalesRatio) {
        if (stageIndex > STAGE_MAX) {
            return (0, 0, 0, 0, 0, 0, 0, 0);
        }

        vokenUsdPrice = stageVokenUsdPrice(stageIndex);

        vokenSold = _stageVokenIssued[stageIndex];
        vokenCap = stageVokenCap(stageIndex);
        vokenOnSale = vokenCap.sub(vokenSold);

        usdSold = _stageUsdSold[stageIndex];
        usdCap = stageUsdCap(stageIndex);
        usdOnSale = usdCap.sub(usdSold);

        weiTopSalesRatio = topSalesRatio(stageIndex);
    }

    /**
     * @dev Season Top-Sales remain, in wei.
     */
    function seasonTopSalesRemain(uint16 seasonNumber) private view returns (uint256) {
        return _seasonWeiTopSales[seasonNumber].sub(_seasonWeiTopSalesTransfered[seasonNumber]);
    }

    /**
     * @dev Season Top-Sales rewards, by season number, in wei.
     */
    function seasonTopSalesRewards(uint16 seasonNumber) public view returns (uint256 weiSold,
                                                                             uint256 weiTopSales,
                                                                             uint256 weiTopSalesTransfered,
                                                                             uint256 weiTopSalesRemain) {
        weiSold = _seasonWeiSold[seasonNumber];
        weiTopSales = _seasonWeiTopSales[seasonNumber];
        weiTopSalesTransfered = _seasonWeiTopSalesTransfered[seasonNumber];
        weiTopSalesRemain = seasonTopSalesRemain(seasonNumber);
    }

    /**
     * @dev Query account.
     */
    function accountQuery(address account) public view returns (uint256 vokenIssued,
                                                                uint256 vokenBonus,
                                                                uint256 vokenWhitelisted,
                                                                uint256 weiPurchased,
                                                                uint256 weiReferralRewarded) {
        vokenIssued = _accountVokenIssued[account];
        vokenBonus = _accountVokenBonus[account];
        vokenWhitelisted = _accountVokenWhitelisted[account];
        weiPurchased = _accountWeiPurchased[account];
        weiReferralRewarded = _accountWeiRefRewarded[account];
    }

    /**
     * @dev Accounts in a specific season.
     */
    function seasonRefAccounts(uint16 seasonNumber) public view returns (address[] memory accounts) {
        accounts = _seasonRefAccounts[seasonNumber];
    }

    /**
     * @dev Season number => account => USD purchased.
     */
    function usdSeasonAccountPurchased(uint16 seasonNumber, address account) public view returns (uint256) {
        return _usdSeasonAccountPurchased[seasonNumber][account];
    }

    /**
     * @dev Season number => account => referral dollors.
     */
    function usdSeasonAccountRef(uint16 seasonNumber, address account) public view returns (uint256) {
        return _usdSeasonAccountRef[seasonNumber][account];
    }

    /**
     * @dev constructor
     */
    constructor () public {
        _etherPriceAuditors[msg.sender] = true;
        _stage = 0;
        _season = 1;
    }

    /**
     * @dev Receive ETH, and send Vokens.
     */
    function () external payable enoughGas onlyOnSale {	//inject DOS BY COMPLEX FALLBACK
        require(msg.value >= WEI_MIN);
        require(msg.value <= WEI_MAX);

        // Set temporary variables.
        setTemporaryVariables();
        uint256 __usdAmount = wei2usd(msg.value);
        uint256 __usdRemain = __usdAmount;
        uint256 __vokenIssued;
        uint256 __vokenBonus;
        uint256 __usdUsed;
        uint256 __weiUsed;

        // USD => Voken
        while (gasleft() > GAS_EX && __usdRemain > 0 && _stage <= STAGE_MAX) {
            uint256 __txVokenIssued;
            (__txVokenIssued, __usdRemain) = ex(__usdRemain);
            __vokenIssued = __vokenIssued.add(__txVokenIssued);
        }

        // Used
        __usdUsed = __usdAmount.sub(__usdRemain);
        __weiUsed = usd2wei(__usdUsed);

        // Bonus 10%
        if (msg.value >= WEI_BONUS) {
            __vokenBonus = __vokenIssued.div(10);
            assert(transferVokenBonus(__vokenBonus));
        }

        // Whitelisted
        // BUY-ONE-AND-GET-ONE-MORE-FREE
        if (_inWhitelist_ && __vokenIssued > 0) {
            // both issued and bonus
            assert(transferVokenWhitelisted(__vokenIssued.add(__vokenBonus)));

            // 35% for 15 levels
            sendWhitelistReferralRewards(__weiUsed);
        }

        // If wei remains, refund.
        if (__usdRemain > 0) {
            uint256 __weiRemain = usd2wei(__usdRemain);
            
            __weiUsed = msg.value.sub(__weiRemain);
            
            // Refund wei back
            msg.sender.call.gas(2301).value(__weiRemain)("");
        }

        // Counter
        if (__weiUsed > 0) {
            _txs = _txs.add(1);
            _weiSold = _weiSold.add(__weiUsed);
            _accountWeiPurchased[msg.sender] = _accountWeiPurchased[msg.sender].add(__weiUsed);
        }

        // Wei team
        uint256 __weiTeam;
        if (_season > SEASON_MAX)
            __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam);
        else
            __weiTeam = _weiSold.sub(_weiRefRewarded).sub(_weiTopSales).sub(_weiPending).sub(_weiTeam).div(0.01 ether).mul(0.01 ether);

        _weiTeam = _weiTeam.add(__weiTeam);
        _receiver.call.gas(2301).value(__weiTeam)("");

        // Assert finished
        assert(true);
    }

    /**
     * @dev Set temporary variables.
     */
    function setTemporaryVariables() private {
        delete _referrers_;
        delete _rewards_;

        _inWhitelist_ = VOKEN.inWhitelist(msg.sender);
        _pending_ = WHITELIST_REF_REWARDS_PCT_SUM;

        address __cursor = msg.sender;
        for(uint16 i = 0; i < WHITELIST_REF_REWARDS_PCT.length; i++) {
            address __refAccount = VOKEN.referrer(__cursor);

            if (__cursor == __refAccount)
                break;

            if (VOKEN.refCount(__refAccount) > i) {
                if (!_seasonHasRefAccount[_season][__refAccount]) {
                    _seasonRefAccounts[_season].push(__refAccount);
                    _seasonHasRefAccount[_season][__refAccount] = true;
                }

                _pending_ = _pending_.sub(WHITELIST_REF_REWARDS_PCT[i]);
                _rewards_.push(WHITELIST_REF_REWARDS_PCT[i]);                    
                _referrers_.push(__refAccount);
            }

            __cursor = __refAccount;
        }
    }

    /**
     * @dev USD => Voken
     */
    function ex(uint256 usdAmount) private returns (uint256, uint256) {
        uint256 __stageUsdCap = stageUsdCap(_stage);
        uint256 __vokenIssued;

        // in stage
        if (_stageUsdSold[_stage].add(usdAmount) <= __stageUsdCap) {
            exCount(usdAmount);

            __vokenIssued = usd2voken(usdAmount);
            assert(transfervokenIssued(__vokenIssued, usdAmount));

            // close stage, if stage dollor cap reached
            if (__stageUsdCap == _stageUsdSold[_stage]) {
                assert(closeStage());
            }

            return (__vokenIssued, 0);
        }

        // close stage
        uint256 __usdUsed = __stageUsdCap.sub(_stageUsdSold[_stage]);
        uint256 __usdRemain = usdAmount.sub(__usdUsed);

        exCount(__usdUsed);

        __vokenIssued = usd2voken(__usdUsed);
        assert(transfervokenIssued(__vokenIssued, __usdUsed));
        assert(closeStage());

        return (__vokenIssued, __usdRemain);
    }

    /**
     * @dev Ex counter.
     */
    function exCount(uint256 usdAmount) private {
        uint256 __weiSold = usd2wei(usdAmount);
        uint256 __weiTopSales = usd2weiTopSales(usdAmount);

        _usdSeasonAccountPurchased[_season][msg.sender] = _usdSeasonAccountPurchased[_season][msg.sender].add(usdAmount);   // season => address => purchased, in USD
        
        _stageUsdSold[_stage] = _stageUsdSold[_stage].add(usdAmount);                   // stage sold, in USD
        _seasonWeiSold[_season] = _seasonWeiSold[_season].add(__weiSold);               // season sold, in wei
        _seasonWeiTopSales[_season] = _seasonWeiTopSales[_season].add(__weiTopSales);   // season Top-Sales, in wei
        _weiTopSales = _weiTopSales.add(__weiTopSales);                                 // sum Top-Sales, in wei

        // season referral account
        if (_inWhitelist_) {
            for (uint16 i = 0; i < _rewards_.length; i++) {
                _usdSeasonAccountRef[_season][_referrers_[i]] = _usdSeasonAccountRef[_season][_referrers_[i]].add(usdAmount);
            }
        }
    }

    /**
     * @dev Transfer Voken issued.
     */
    function transfervokenIssued(uint256 amount, uint256 usdAmount) private returns (bool) {
        _vokenTxs = _vokenTxs.add(1);
        
        _vokenIssued = _vokenIssued.add(amount);
        _stageVokenIssued[_stage] = _stageVokenIssued[_stage].add(amount);
        _accountVokenIssued[msg.sender] = _accountVokenIssued[msg.sender].add(amount);

        assert(VOKEN.transfer(msg.sender, amount));
        emit VokenIssuedTransfered(_stage, msg.sender, amount, _etherPrice, usdAmount);
        return true;
    }

    /**
     * @dev Transfer Voken bonus.
     */
    function transferVokenBonus(uint256 amount) private returns (bool) {
        _vokenBonusTxs = _vokenBonusTxs.add(1);

        _vokenBonus = _vokenBonus.add(amount);
        _accountVokenBonus[msg.sender] = _accountVokenBonus[msg.sender].add(amount);

        assert(VOKEN.transfer(msg.sender, amount));
        emit VokenBonusTransfered(msg.sender, amount);
        return true;
    }

    /**
     * @dev Transfer Voken whitelisted.
     */
    function transferVokenWhitelisted(uint256 amount) private returns (bool) {
        _vokenWhitelistTxs = _vokenWhitelistTxs.add(1);

        _vokenWhitelist = _vokenWhitelist.add(amount);
        _accountVokenWhitelisted[msg.sender] = _accountVokenWhitelisted[msg.sender].add(amount);

        assert(VOKEN.transfer(msg.sender, amount));
        emit VokenWhitelistTransfered(msg.sender, amount);
        return true;
    }

    /**
     * Close current stage.
     */
    function closeStage() private returns (bool) {
        emit StageClosed(_stage, msg.sender);
        _stage = _stage.add(1);
        _vokenUsdPrice = stageVokenUsdPrice(_stage);
        _topSalesRatio = topSalesRatio(_stage);

        // Close current season
        uint16 __seasonNumber = calcSeason(_stage);
        if (_season < __seasonNumber) {
            emit SeasonClosed(_season, msg.sender);
            _season = __seasonNumber;
        }

        return true;
    }

    /**
     * @dev Send whitelist referral rewards.
     */
    function sendWhitelistReferralRewards(uint256 weiAmount) private {
        uint256 __weiRemain = weiAmount;
        for (uint16 i = 0; i < _rewards_.length; i++) {
            uint256 __weiReward = weiAmount.mul(_rewards_[i]).div(100);
            address payable __receiver = address(uint160(_referrers_[i]));

            _weiRefRewarded = _weiRefRewarded.add(__weiReward);
            _accountWeiRefRewarded[__receiver] = _accountWeiRefRewarded[__receiver].add(__weiReward);
            __weiRemain = __weiRemain.sub(__weiReward);

            __receiver.transfer(__weiReward);
        }
        
        if (_pending_ > 0)
            _weiPending = _weiPending.add(weiAmount.mul(_pending_).div(100));
    }
}