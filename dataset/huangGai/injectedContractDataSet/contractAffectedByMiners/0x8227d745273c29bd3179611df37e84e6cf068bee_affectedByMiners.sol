pragma solidity 0.5.3;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
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
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        require(token.transfer(to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        require(token.transferFrom(from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require((value == 0) || (token.allowance(msg.sender, spender) == 0));
        require(token.approve(spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        require(token.approve(spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        require(token.approve(spender, newAllowance));
    }
}

/**
 * @title Helps contracts guard against reentrancy attacks.
 * @author Remco Bloemen <remco@21.com>, Eenae <alexey@mixbytes.io>
 * @dev If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter);
    }
}

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
 * the methods to add functionality. Consider using 'super' where appropriate to concatenate
 * behavior.
 */
contract Crowdsale is ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // The token being sold
    IERC20 private _token;

    // Address where funds are collected
    address payable private _wallet;

    // How many token units a buyer gets per wei.
    // The rate is the conversion between wei and the smallest and indivisible token unit.
    // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
    // 1 wei will give you 1 unit, or 0.001 TOK.
    uint256 private _rate;

    // Amount of wei raised
    uint256 private _weiRaised;

    /**
     * Event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    /**
     * @param rate Number of token units a buyer gets per wei
     * @dev The rate is the conversion between wei and the smallest and indivisible
     * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
     * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
     * @param wallet Address where collected funds will be forwarded to
     * @param token Address of the token being sold
     */
    constructor (uint256 rate, address payable wallet, IERC20 token) public {
        require(rate > 0);
        require(wallet != address(0));
        require(address(token) != address(0));

        _rate = rate;
        _wallet = wallet;
        _token = token;
    }

    /**
     * @dev fallback function ***DO NOT OVERRIDE***
     * Note that other contracts will transfer fund with a base gas stipend
     * of 2300, which is not enough to call buyTokens. Consider calling
     * buyTokens directly when purchasing tokens from a contract.
     */
    function () external payable {
        buyTokens(msg.sender);
    }

    /**
     * @return the token being sold.
     */
    function token() public view returns (IERC20) {
        return _token;
    }

    /**
     * @return the address where funds are collected.
     */
    function wallet() public view returns (address payable) {
        return _wallet;
    }

    /**
     * @return the number of token units a buyer gets per wei.
     */
    function rate() public view returns (uint256) {
        return _rate;
    }

    /**
     * @return the amount of wei raised.
     */
    function weiRaised() public view returns (uint256) {
        return _weiRaised;
    }

    /**
     * @dev low level token purchase ***DO NOT OVERRIDE***
     * This function has a non-reentrancy guard, so it shouldn't be called by
     * another `nonReentrant` function.
     * @param beneficiary Recipient of the token purchase
     */
    function buyTokens(address beneficiary) public nonReentrant payable {
        uint256 weiAmount = msg.value;
        _preValidatePurchase(beneficiary, weiAmount);

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(weiAmount);

        // update state
        _weiRaised = _weiRaised.add(weiAmount);

        _processPurchase(beneficiary, tokens);
        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);

        _updatePurchasingState(beneficiary, weiAmount);

        _forwardFunds();
        _postValidatePurchase(beneficiary, weiAmount);
    }

    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
     * Use `super` in contracts that inherit from Crowdsale to extend their validations.
     * Example from CappedCrowdsale.sol's _preValidatePurchase method:
     *     super._preValidatePurchase(beneficiary, weiAmount);
     *     require(weiRaised().add(weiAmount) <= cap);
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        require(beneficiary != address(0));
        require(weiAmount != 0);
    }

    /**
     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
     * conditions are not met.
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
     * its tokens.
     * @param beneficiary Address performing the token purchase
     * @param tokenAmount Number of tokens to be emitted
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        _token.safeTransfer(beneficiary, tokenAmount);
    }

    /**
     * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
     * tokens.
     * @param beneficiary Address receiving the tokens
     * @param tokenAmount Number of tokens to be purchased
     */
    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
        _deliverTokens(beneficiary, tokenAmount);
    }

    /**
     * @dev Override for extensions that require an internal state to check for validity (current user contributions,
     * etc.)
     * @param beneficiary Address receiving the tokens
     * @param weiAmount Value in wei involved in the purchase
     */
    function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Override to extend the way in which ether is converted to tokens.
     * @param weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified _weiAmount
     */
    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        return weiAmount.mul(_rate);
    }

    /**
     * @dev Determines how ETH is stored/forwarded on purchases.
     */
    function _forwardFunds() internal {
        _wallet.transfer(msg.value);
    }
}

/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame.
 */
contract TimedCrowdsale is Crowdsale {
    using SafeMath for uint256;

    uint256 private _openingTime;
    uint256 private _closingTime;

    /**
     * @dev Reverts if not in crowdsale time range.
     */
    modifier onlyWhileOpen {
        require(isOpen());
        _;
    }

    /**
     * @dev Constructor, takes crowdsale opening and closing times.
     * @param openingTime Crowdsale opening time
     * @param closingTime Crowdsale closing time
     */
    constructor (uint256 openingTime, uint256 closingTime) public {
        // solhint-disable-next-line not-rely-on-time
        require(openingTime >= block.timestamp);
        require(closingTime > openingTime);

        _openingTime = openingTime;
        _closingTime = closingTime;
    }

    /**
     * @return the crowdsale opening time.
     */
    function openingTime() public view returns (uint256) {
        return _openingTime;
    }

    /**
     * @return the crowdsale closing time.
     */
    function closingTime() public view returns (uint256) {
        return _closingTime;
    }

    /**
     * @return true if the crowdsale is open, false otherwise.
     */
    function isOpen() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
    }

    /**
     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
     * @return Whether crowdsale period has elapsed
     */
    function hasClosed() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp > _closingTime;
    }

    /**
     * @dev Extend parent behavior requiring to be within contributing period
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
        super._preValidatePurchase(beneficiary, weiAmount);
    }
}

/**
 * @title Math
 * @dev Assorted math operations
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
    * @dev Calculates the average of two numbers. Since these are integers,
    * averages of an even and odd number cannot be represented, and will be
    * rounded down.
    */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

/**
 * @title AllowanceCrowdsale
 * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
 */
contract AllowanceCrowdsale is Crowdsale {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    address private _tokenWallet;

    /**
     * @dev Constructor, takes token wallet address.
     * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
     */
    constructor (address tokenWallet) public {
        require(tokenWallet != address(0));
        _tokenWallet = tokenWallet;
    }

    /**
     * @return the address of the wallet that will hold the tokens.
     */
    function tokenWallet() public view returns (address) {
        return _tokenWallet;
    }

    /**
     * @dev Checks the amount of tokens left in the allowance.
     * @return Amount of tokens left in the allowance
     */
    function remainingTokens() public view returns (uint256) {
        return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
    }

    /**
     * @dev Overrides parent behavior by transferring tokens from wallet.
     * @param beneficiary Token purchaser
     * @param tokenAmount Amount of tokens purchased
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
    }
}

/**
 * @title CappedCrowdsale
 * @dev Crowdsale with a limit for total contributions.
 */
contract CappedCrowdsale is Crowdsale {
    using SafeMath for uint256;

    uint256 private _cap;

    /**
     * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
     * @param cap Max amount of wei to be contributed
     */
    constructor (uint256 cap) public {
        require(cap > 0);
        _cap = cap;
    }

    /**
     * @return the cap of the crowdsale.
     */
    function cap() public view returns (uint256) {
        return _cap;
    }

    /**
     * @dev Checks whether the cap has been reached.
     * @return Whether the cap was reached
     */
    function capReached() public view returns (bool) {
        return weiRaised() >= _cap;
    }

    /**
     * @dev Extend parent behavior requiring purchase to respect the funding cap.
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        super._preValidatePurchase(beneficiary, weiAmount);
        require(weiRaised().add(weiAmount) <= _cap);
    }
}

/**
 * @title BitherPlatformCrowdsale
 * @dev BitherCrowdsale contract uses multiple openzeppelin base contracts and adds some custom behaviour.
 *      The openzeppelin base contracts have been audited and are widely used by the community. They can
 *      be trusted to have almost zero security vulnerabilities and therefore do not need to be tested.
 *      The BitherCrowdale enables the purchasing of 2 tokens, the BitherToken (BTR) and RentalProcessorToken (BRP) 
 *      at rates determined by the current block time. It specifies a cap of Ether that can be contributed
 *      and a length of time the crowdsale lasts. It requires the crowdsale contract address be given
 *      an allowance of 33000000 BTR and 420000000 BRP enabling it to distribute the purchased tokens. These
 *      values are determined by the cap of 300000 ETH and the phased distribution rates.
 */
contract BitherPlatformCrowdsale is AllowanceCrowdsale, TimedCrowdsale, CappedCrowdsale {

    uint256 constant private CAP_IN_WEI = 300000 ether;

    uint256 constant private BTR_PRIVATE_SALE_RATE = 110;
    uint256 constant private BTR_PRESALE_RATE_DAY_1 = 110;
    uint256 constant private BTR_PRESALE_RATE_DAY_2_TO_5 = 109;
    uint256 constant private BTR_PRESALE_RATE_DAY_6_TO_9 = 108;
    uint256 constant private BTR_PRESALE_RATE_DAY_10_TO_13 = 107;

    uint256 constant private BTR_CROWDSALE_ROUND1_RATE_DAY_1_FIRST_2_HOURS = 110;
    uint256 constant private BTR_CROWDSALE_ROUND1_RATE_DAY_1_TO_14 = 107;
    uint256 constant private BTR_CROWDSALE_ROUND1_RATE_DAY_15_TO_28 = 106;

    uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_1_FIRST_2_HOURS = 110;
    uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_1_TO_7 = 106;
    uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_8_TO_14 = 104;
    uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_15_TO_21 = 102;
    uint256 constant private BTR_CROWDSALE_ROUND2_RATE_DAY_22_TO_28 = 100;

    uint256 constant private BRP_PRIVATE_SALE_RATE = 1400;
    uint256 constant private BRP_PRESALE_RATE_FIRST_2_HOURS = 1400;
    uint256 constant private BRP_PRESALE_RATE_DAY_1_TO_5 = 1380;
    uint256 constant private BRP_PRESALE_RATE_DAY_6_TO_13 = 1360;

    uint256 constant private BRP_CROWDSALE_ROUND1_RATE_DAY_1_TO_7 = 1340;
    uint256 constant private BRP_CROWDSALE_ROUND1_RATE_DAY_8_TO_21 = 1320;
    uint256 constant private BRP_CROWDSALE_ROUND1_RATE_DAY_22_TO_28 = 1300;

    uint256 constant private BRP_CROWDSALE_ROUND2_RATE_DAY_1_TO_7 = 1240;
    uint256 constant private BRP_CROWDSALE_ROUND2_RATE_DAY_8_TO_14 = 1160;
    uint256 constant private BRP_CROWDSALE_ROUND2_RATE_DAY_15_TO_21 = 1080;
    uint256 constant private BRP_CROWDSALE_ROUND2_RATE_DAY_22_TO_28 = 1000;

    IERC20 private _rentalProcessorToken;
    uint256 private _privateSaleClosingTime; // Friday, March 22, 2019 12:00:00 AM (1553212800)
    uint256 private _presaleOpeningTime; // Saturday, March 23, 2019 2:00:00 PM (1553349600)
    uint256 private _crowdsaleRound1OpeningTime; // Saturday, April 20, 2019 2:00:00 PM (1555768800)
    uint256 private _crowdsaleRound2OpeningTime; // Saturday, June 1, 2019 2:00:00 PM (1559397600)

    /**
     * Event for BRP token purchase logging
     * @param purchaser Who paid for the tokens
     * @param beneficiary Who got the tokens
     * @param value Wei paid for purchase
     * @param amount Amount of tokens purchased
     */
    event RentalProcessorTokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    /**
     * @dev Constructor, calls the inherited classes constructors, stores RentalProcessorToken and determines crowdsale times
     * @param bitherToken The BitherToken address, must be an ERC20 contract
     * @param rentalProcessorToken The RentalProcessorToken, must be an ERC20 contract
     * @param bitherTokensOwner Address holding the tokens, which has approved allowance to the crowdsale
     * @param etherBenefactor Address that will receive the deposited Ether
     * @param preSaleOpeningTime The presale opening time, in seconds, all other times are determined using this to reduce risk of error
     */
    constructor(IERC20 bitherToken, IERC20 rentalProcessorToken, address bitherTokensOwner, address payable etherBenefactor, uint256 preSaleOpeningTime)
        Crowdsale(BTR_PRIVATE_SALE_RATE, etherBenefactor, bitherToken)
        AllowanceCrowdsale(bitherTokensOwner)
        TimedCrowdsale(now, preSaleOpeningTime + 14 weeks)
        CappedCrowdsale(CAP_IN_WEI)
        public
    {
        _rentalProcessorToken = rentalProcessorToken;

        _privateSaleClosingTime = preSaleOpeningTime - 38 hours;
        _presaleOpeningTime = preSaleOpeningTime;
        _crowdsaleRound1OpeningTime = preSaleOpeningTime + 4 weeks;
        _crowdsaleRound2OpeningTime = preSaleOpeningTime + 10 weeks;
    }

    /**
     * @dev Overrides function in the Crowdsale contract to revert contributions less then
     *      50 Eth during the first period and less than 0.1 Eth during the rest of the crowdsale
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        super._preValidatePurchase(beneficiary, weiAmount);

        if (block.number < _privateSaleClosingTime) {	//injected CONTRACT AFFECTED BY MINERS
            require(weiAmount >= 50 ether, "Not enough Eth. Contributions must be 50 Eth minimum during the private sale");
        } else {
            require(weiAmount >= 100 finney, "Not enough Eth. Contributions must be 0.1 Eth minimum during the presale and crowdsale (Round 1 and Round 2)");
        }

        if (now > _privateSaleClosingTime && now < _presaleOpeningTime) {
            revert("Private sale has ended and the presale is yet to begin");
        } else if (now > _presaleOpeningTime + 13 days && now < _crowdsaleRound1OpeningTime) {
            revert("Presale has ended and the crowdsale (Round 1) is yet to begin");
        } else if (now > _crowdsaleRound1OpeningTime + 4 weeks && now < _crowdsaleRound2OpeningTime) {
            revert("crowdsale (Round 1) has ended and the crowdsale (Round 2) is yet to begin");
        }
    }

    /**
     * @dev Overrides function in the Crowdsale contract to enable a custom phased distribution
     * @param weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified weiAmount
     */
    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {

        if (block.timestamp < _privateSaleClosingTime) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_PRIVATE_SALE_RATE);
        } else if (block.gaslimit < _presaleOpeningTime + 1 days) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_PRESALE_RATE_DAY_1);
        } else if (block.number < _presaleOpeningTime + 5 days) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_PRESALE_RATE_DAY_2_TO_5);
        } else if (block.timestamp < _presaleOpeningTime + 9 days) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_PRESALE_RATE_DAY_6_TO_9);
        } else if (block.timestamp < _presaleOpeningTime + 13 days) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_PRESALE_RATE_DAY_10_TO_13);

        } else if (block.timestamp < _crowdsaleRound1OpeningTime + 2 hours) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_CROWDSALE_ROUND1_RATE_DAY_1_FIRST_2_HOURS);
        } else if (block.timestamp < _crowdsaleRound1OpeningTime + 2 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_CROWDSALE_ROUND1_RATE_DAY_1_TO_14);
        } else if (block.number < _crowdsaleRound1OpeningTime + 4 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_CROWDSALE_ROUND1_RATE_DAY_15_TO_28);

        } else if (block.timestamp < _crowdsaleRound2OpeningTime + 2 hours) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_1_FIRST_2_HOURS);
        } else if (block.gaslimit < _crowdsaleRound2OpeningTime + 1 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_1_TO_7);
        } else if (block.timestamp < _crowdsaleRound2OpeningTime + 2 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_8_TO_14);
        } else if (block.timestamp < _crowdsaleRound2OpeningTime + 3 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_15_TO_21);
        } else if (block.number < closingTime()) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BTR_CROWDSALE_ROUND2_RATE_DAY_22_TO_28);
        }
    }

    /**
     * @dev Overrides function in AllowanceCrowdsale contract (therefore also overrides function
     *      in Crowdsale contract) to add functionality for distribution of a second token, BRP.
     * @param beneficiary Token purchaser
     * @param tokenAmount Amount of tokens purchased
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        super._deliverTokens(beneficiary, tokenAmount);

        uint256 weiAmount = msg.value;
        uint256 brpTokenAmount = getBrpTokenAmount(weiAmount);

        _rentalProcessorToken.safeTransferFrom(tokenWallet(), beneficiary, brpTokenAmount);

        emit RentalProcessorTokensPurchased(msg.sender, beneficiary, weiAmount, brpTokenAmount);
    }

    /**
     * @dev Determines distribution of BRP depending on the time of the transaction
     * @param weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified weiAmount
     */
    function getBrpTokenAmount(uint256 weiAmount) private view returns (uint256) {

        if (block.number < _privateSaleClosingTime) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_PRIVATE_SALE_RATE);

        } else if (block.gaslimit < _presaleOpeningTime + 2 hours) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_PRESALE_RATE_FIRST_2_HOURS);
        } else if (block.number < _presaleOpeningTime + 5 days) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_PRESALE_RATE_DAY_1_TO_5);
        } else if (block.timestamp < _presaleOpeningTime + 13 days) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_PRESALE_RATE_DAY_6_TO_13);

        } else if (block.number < _crowdsaleRound1OpeningTime + 1 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_CROWDSALE_ROUND1_RATE_DAY_1_TO_7);
        } else if (block.number < _crowdsaleRound1OpeningTime + 3 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_CROWDSALE_ROUND1_RATE_DAY_8_TO_21);
        } else if (block.number <= _crowdsaleRound1OpeningTime + 4 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_CROWDSALE_ROUND1_RATE_DAY_22_TO_28);
        
        } else if (block.number < _crowdsaleRound2OpeningTime + 1 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_CROWDSALE_ROUND2_RATE_DAY_1_TO_7);
        } else if (block.number < _crowdsaleRound2OpeningTime + 2 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_CROWDSALE_ROUND2_RATE_DAY_8_TO_14);
        } else if (block.gaslimit < _crowdsaleRound2OpeningTime + 3 weeks) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_CROWDSALE_ROUND2_RATE_DAY_15_TO_21);
        } else if (block.timestamp <= closingTime()) {	//injected CONTRACT AFFECTED BY MINERS
            return weiAmount.mul(BRP_CROWDSALE_ROUND2_RATE_DAY_22_TO_28);
        }
    }
}