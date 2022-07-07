/*
    Moon Token for MoonTrader Platform and projects
    More information at https://moontrader.io/

    MoonTrader is a successor of the  MoonBot project, https://moon-bot.com/en/

    Mail us to: info@moontrader.io 

    Join the Telegram channel https://t.me/moontrader_news_en, 
    Visit BTT forum thread https://bitcointalk.org/index.php?topic=5143969 for more information.

 */

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.2;

/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
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

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.2;

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

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.5.2;



/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://eips.ethereum.org/EIPS/eip-20
 * Originally based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 *
 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
 * all accounts just by listening to said events. Note that this isn't required by the specification, and other
 * compliant implementations may not do it.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    /**
     * @dev Total number of tokens in existence
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param owner The address to query the balance of.
     * @return A uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
     * @dev Transfer token to a specified address
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _transfer(from, to, value);
        _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when _allowed[msg.sender][spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     * @dev Transfer token for a specified addresses
     * @param from The address to transfer from.
     * @param to The address to transfer to.
     * @param value The amount to be transferred.
     */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Approve an address to spend another addresses' tokens.
     * @param owner The address that owns the tokens.
     * @param spender The address that will spend the tokens.
     * @param value The number of tokens that can be spent.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _burn(account, value);
        _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
    }
}

// File: openzeppelin-solidity/contracts/access/Roles.sol

pragma solidity ^0.5.2;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an account access to this role
     */
    function add(Role storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer[account] = true;
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        role.bearer[account] = false;
    }

    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }
}

// File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol

pragma solidity ^0.5.2;


contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(isMinter(msg.sender));
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol

pragma solidity ^0.5.2;



/**
 * @title ERC20Mintable
 * @dev ERC20 minting logic
 */
contract ERC20Mintable is ERC20, MinterRole {
    /**
     * @dev Function to mint tokens
     * @param to The address that will receive the minted tokens.
     * @param value The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to, uint256 value) public onlyMinter returns (bool) {
        _mint(to, value);
        return true;
    }
}

// File: openzeppelin-solidity/contracts/utils/Address.sol

pragma solidity ^0.5.2;

/**
 * Utility library of inline functions on addresses
 */
library Address {
    /**
     * Returns whether the target address is a contract
     * @dev This function will return false if invoked during the constructor of a contract,
     * as the code is not actually created until after the constructor finishes.
     * @param account address of the account to check
     * @return whether the target address is a contract
     */
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // XXX Currently there is no better way to check if there is a contract in an address
        // than to check the size of the code at that address.
        // See https://ethereum.stackexchange.com/a/14016/36603
        // for more details about how this works.
        // TODO Check this again before the Serenity release, because all addresses will be
        // contracts then.
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.2;




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
        require((value == 0) || (token.allowance(address(this), spender) == 0));
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must equal true).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.

        require(address(token).isContract());

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success);

        if (returndata.length > 0) { // Return data is optional
            require(abi.decode(returndata, (bool)));
        }
    }
}

// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.2;

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

// File: contracts/Crowdsale/Core/Crowdsale.sol

pragma solidity ^0.5.2;





/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conforms
 * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
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

    // Hardcap in tokens
    uint256 private _supply;

    // Amount of sold tokens
    uint256 private _sold;

    /**
     * Event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value weis paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

    /**
     * Event for conversion rate changes logging
     * @param rate New rate
     */
    event RateUpdated(uint256 indexed rate);

    /**
     * Events for crowdsale state tracking
     */
    event CrowdsalePaused();
    event CrowdsaleUnpaused();

    /**
     * @param rate Number of token units a buyer gets per wei
     * @dev The rate is the conversion between wei and the smallest and indivisible
     * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
     * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
     * @param wallet Address where collected funds will be forwarded to
     * @param token Address of the token being sold
     */
    constructor (uint256 rate, uint256 supply, address payable wallet, IERC20 token) public {
        require(rate > 0);
        require(wallet != address(0));
        require(address(token) != address(0));

        _rate = rate;
        _supply = supply;
        _wallet = wallet;
        _token = token;
    }

    /**
     * @dev fallback function ***DO NOT OVERRIDE***
     * Note that other contracts will transfer funds with a base gas stipend
     * of 2300, which is not enough to call buyTokens. Consider calling
     * buyTokens directly when purchasing tokens from a contract.
     */
    function() external payable {
        buyTokens(msg.sender);
    }

    /**
     * @return the token being sold.
     */
    function token() public view returns (IERC20) {
        return _token;
    }

    /**
     * @return amount of supplied tokens.
     */
    function supply() internal view returns (uint256) {
        return _supply;
    }

    /**
     * @return amount of sold tokens.
     */
    function sold() public view returns (uint256) {
        return _sold;
    }

    /**
     * @dev Increase amount of sold tokens by tokenAmount.
     * @param tokenAmount Amount of last-purchased tokens
     */
    function _addSold(uint256 tokenAmount) internal {
        _sold = _sold.add(tokenAmount);
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

        uint256 surplus = _countSurplus(weiAmount);
        weiAmount -= surplus;

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(weiAmount);

        // update state
        _weiRaised = _weiRaised.add(weiAmount);

        _processPurchase(beneficiary, tokens);
        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);

        _updatePurchasingState(beneficiary, weiAmount);

        _forwardFunds(weiAmount);
        _returnSurplus(surplus);

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
        require(rate() > 0);
        require(_supply >= _sold + _getTokenAmount(weiAmount)); //todo
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
        _addSold(tokenAmount);
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
     * @param tokenAmount amount of tokens to be converted in wei
     * @return amount of wei to be spent on the purchase of tokenAmount tokens
     */
    function _getWeiAmount(uint256 tokenAmount) internal view returns (uint256) {
        return tokenAmount.div(_rate);
    }

    /**
     * @dev Determines how ETH is stored/forwarded on purchases.
     */
    function _forwardFunds(uint256 weiAmount) internal {
        _wallet.transfer(weiAmount);
    }

    /*
     * @dev Override to define the way in which surplus will be counted
     * @param weiAmount Amount of wei sent by user
     * @return surplus to be returned
     */
    function _countSurplus(uint256 weiAmount) internal returns (uint256){
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Override to change the way in which wei surplus returns to user
     * @param weiAmount Amount of wei to be returned
     */
    function _returnSurplus(uint256 weiAmount) internal {
        if (weiAmount > 0) {
            msg.sender.transfer(weiAmount);
        }
    }

    /**
     * @dev Changes conversion rate. Override for extend the way in which rate changing affects on crowdsale
     * @param newRate Value in tokens to be paid per 1 wei
     */
    function _changeRate(uint256 newRate) internal {
        if ((newRate > 0) && (_rate == 0)) {
            emit CrowdsaleUnpaused();
        } else if (newRate == 0) {
            emit CrowdsalePaused();
        }

        _rate = newRate;
        emit RateUpdated(newRate);
    }

}

// File: contracts/Crowdsale/Util/Role.sol

pragma solidity ^0.5.2;

library Role {

    struct RoleContainer {
        address[] bearer;
    }

    /**
     * @param role role storage
     * @return amount of accounts in this role
     */
    function total (RoleContainer storage role) internal view returns (uint count) {
        for (uint i = 0; i < role.bearer.length; i++) {
            count += (role.bearer[i] == address(0)) ? 0 : 1;
        }
        return count;
    }


    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(RoleContainer storage role, address account) internal view returns (bool) {
        require(account != address(0));
        address[] memory list = role.bearer;
        uint len = role.bearer.length;
        for (uint index = 0; index < len; index++) {
            if (list[index] == account) {
                return true;
            }
        }
        return false;
    }

    /**
     * @dev give an account access to this role
     */
    function add(RoleContainer storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer.push(account);
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(RoleContainer storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        removeFromList(role, account);
    }

    /**
     * @dev Helper function. Iterates over array to find and
       remove given account from it
       @param role Role storage
       @param account Expelled account
     */
    function removeFromList(RoleContainer storage role, address account) private {
        address[] storage list = role.bearer;
        uint len = role.bearer.length;

        for (uint index = 0; index <= len; index++) {
            if (list[index] != account) {
                continue;
            }
            list[index] = list[len - 1];
            delete list[len - 1];
            return;
        }
    }
}

// File: contracts/Crowdsale/Util/Helpers.sol

pragma solidity ^0.5.2;

library Helpers {
    function majority(uint total) internal pure returns (uint) {
        return uint(total / 2) + 1;
    }

    function idFromAddress(address addr) internal pure returns (bytes32) {
        return keccak256(abi.encode(addr));
    }

    function idFromUint256(uint256 x) internal pure returns (bytes32) {
        return keccak256(abi.encode(x));
    }

    function mixId(address addr, uint256 x) internal pure returns (bytes32) {
        return keccak256(abi.encode(addr, x));
    }
}

// File: contracts/Crowdsale/Util/Votings.sol

pragma solidity ^0.5.2;


library Votings {

    struct Voting {
        mapping(bytes32 => address[]) process;
    }

    /**
     * @dev Votes and check if voting is completed. If vote is completed - deletes it
     * @param voting Storage
     * @param index Of voting process
     * @param issuer Voter
     * @param required Amount of votes for this process to be successful
     * @return (is voting completed?)
     */
    function voteAndCheck(Voting storage voting,
        bytes32 index, address issuer, uint required) internal returns (bool)
    {
        vote(voting, index, issuer);
        return isComplete(voting, index, required);
    }

    /**
     * @dev Check if voting is completed. If vote is completed - deletes it
     * @param voting Storage
     * @param index Of voting process
     * @param required Amount of votes for this process to be successful
     * @return (is voting completed?)
     */
    function isComplete(Voting storage voting,
        bytes32 index, uint required) internal returns (bool)
    {
        if (voting.process[index].length < required) {
            return false;
        }

        delete voting.process[index];
        return true;
    }



    /**
     * @dev Vote
     * @param voting Storage
     * @param index Of voting process
     * @param issuer Voter
     */
    function vote(Voting storage voting,
        bytes32 index, address issuer) internal
    {
        require(!hadVoted(voting, index, issuer));
        voting.process[index].push(issuer);
    }

    /**
     * @dev Check of issuer had voted on this process
     * @param voting Storage
     * @param index Of voting process
     * @param issuer Voter
     * @return bool
     */
    function hadVoted(Voting storage voting,
        bytes32 index, address issuer) internal view returns (bool)
    {
        address[] storage _process = voting.process[index];

        for (uint ind = 0; ind < _process.length; ind++) {
            if (_process[ind] == issuer) {
                return true;
            }
        }

        return false;
    }
}

// File: contracts/Crowdsale/Roles/AdminRole.sol

pragma solidity ^0.5.2;





contract AdminRole {
    using Role for Role.RoleContainer;
    using Votings for Votings.Voting;

    //admin storage
    Role.RoleContainer private _admins;

    //voting storage
    Votings.Voting private _addVoting;
    Votings.Voting private _expelVoting;

    /**
     * @dev events for "add admin" action logging
     * @param account New admin
     */
    event AdminAdded(address indexed account);

    /**
     * @dev events for "expel admin" action logging
     * @param account Expelled admin
     */
    event AdminRemoved(address indexed account);

    modifier AdminOnly() {
        require(isAdmin(msg.sender));
        _;
    }

    modifier WhileSetup() {
        require(isAdmin(msg.sender));
        require(countAdmins() == 1);
        _;
    }

    constructor () internal {
        _add(msg.sender);
    }

    /**
     * @param account to check
     * @return is this account contains in admin list
     */
    function isAdmin(address account) public view returns (bool) {
        return _admins.has(account);
    }

    /**
     * @return list of admins
     */
    function listAdmins() public view returns (address[] memory) {
        return _admins.bearer;
    }

    /**
     * @return amount of admins
     */
    function countAdmins() public view returns (uint) {
        return _admins.total();
    }

    /**
     * @dev initialize admin list while setup-stage of sale
     * @param defaultAdmins list of default admins
     */
    function initAdmins(address[] memory defaultAdmins) WhileSetup internal {
        for (uint256 index = 0; index < defaultAdmins.length; index++) {
            _add(defaultAdmins[index]);
        }
    }

    /**
     * @dev Vote and append given account to the admin list after consensus
     * @param account Account to be appended
     */
    function addAdmin(address account) AdminOnly public {
        if (_addAdminVoting(account)) {
            _add(account);
        }
    }

    /**
     * @dev Vote and remove given account from admin list after consensus
     * @param account Account to be removed
     */
    function expelAdmin(address account) AdminOnly public {
        if (_expelAdminVoting(account)) {
            _expel(account);
        }
    }


    /**
     * @dev require (N/2)+1 admins to be agreed with the add proposal
     * @param account Account to be appended
     * @return do (N/2)+1  admins agreed with the proposal?
     */
    function _addAdminVoting(address account) private returns (bool) {
        return _addVoting.voteAndCheck(
            Helpers.idFromAddress(account),
            msg.sender,
            Helpers.majority(countAdmins())
        );
    }

    /**
     * @dev require (N/2)+1 admins to be agreed with the removal proposal
     * @param account Account to be removed
     * @return do (N/2)+1  admins agreed with the proposal?
     */
    function _expelAdminVoting(address account) private returns (bool) {
        require(msg.sender != account);
        return _expelVoting.voteAndCheck(
            Helpers.idFromAddress(account),
            msg.sender,
            Helpers.majority(countAdmins())
        );
    }


    /**
     * @dev appends given account to admin list
     * @param account Account to be appended
     */
    function _add(address account) private {
        _admins.add(account);
        emit AdminAdded(account);
    }

    /**
     * @dev removes given account to admin list
     * @param account Account to be excluded
     */
    function _expel(address account) private {
        _admins.remove(account);
        emit AdminRemoved(account);
    }


}

// File: contracts/Crowdsale/Functionalities/InvestOnBehalf.sol

pragma solidity ^0.5.2;





contract InvestOnBehalf is AdminRole, Crowdsale {
    using Votings for Votings.Voting;

    // Current vote processes
    Votings.Voting private _votings;

    /**
     * Event for investOnBehalf actions logging
     * @param account Transfer target
     * @param tokens Amount of transferred tokens
     */
    event InvestedOnBehalf(address indexed account, uint256 indexed tokens);

    /**
     * @dev require (N/2)+1 admins to be agreed with the proposal
     * @param account Transfer target
     * @param tokens Amount of tokens to be transferred
     * @return do all admins agreed with the proposal?
     */
    function consensus(address account, uint256 tokens) private returns (bool) {
        return _votings.voteAndCheck(Helpers.mixId(account, tokens), msg.sender, Helpers.majority(countAdmins()));
    }


    /*
     * @dev Vote and add X tokens to the user balance after consensus
     * @param to Transfer target
     * @param tokens Amount of tokens to be transferred
     */
    function investOnBehalf(address to, uint256 tokens) AdminOnly public {
        if (consensus(to, tokens)) {
            _processPurchase(to, tokens * 1e18);
            emit InvestedOnBehalf(to, tokens * 1e18);
        }
    }
}

// File: contracts/Crowdsale/Functionalities/MilestonedCrowdsale.sol

pragma solidity ^0.5.2;



contract MilestonedCrowdsale is AdminRole, Crowdsale {
    event MilestoneReached(uint256 indexed milestone);

    /**
     * @dev Container for milestone ranges
     * @param start Milestone start timestamp
     * @param finish Milestone finish timestamp
     * @param fired
     */
    struct Milestone {
        uint256 start;
        uint256 finish;
        bool fired;
    }

    Milestone[] private _milestones;

    /**
     * @dev Creates single milestone in storage
     * @param start Timestamp from
     * @param finish Timestamp to
     */
    function _newMilestone(uint256 start, uint256 finish) private {
        require(start < finish);
        _milestones.push(Milestone(start, finish, false));
    }

    /**
     * @dev Initialize milestone storage
     * @param milestones Timerow of timestamps
     */
    function initMilestones(uint256[] memory milestones) WhileSetup internal {
        for (uint256 index = 0; index < milestones.length - 1; index++) {
            _newMilestone(milestones[index], milestones[index + 1]);
        }
    }

    /**
     * @dev Extends parent with counting surplus from milestones
     * @param weiAmount Amount of wei received
     * @return surplus above the last milestone
     */
    function _countSurplus(uint256 weiAmount) internal returns (uint256){
        return _getMilestoneOverhead(weiAmount);
    }

    /**
     * @dev Extends parent with pausing crowdsale if any surplus is returned
     * @param weiAmount Amount of surplus wei
     */
    function _returnSurplus(uint256 weiAmount) internal {
        super._returnSurplus(weiAmount);

        if (weiAmount > 0) {
            _changeRate(0);
        }
    }

    /**
     * @dev Iterates over milestones to make sure
     * that current transaction hasn't passed current milestone.
     * @param weiAmount Amount of wei received
     * @return If milestone has been reached, returns amount of wei above
     * milestone finish-line
     */
    function _getMilestoneOverhead(uint256 weiAmount) private returns (uint256){
        for (uint256 index = 0; index < _milestones.length; index++) {
            //every milestone could be reached only once
            if (_milestones[index].fired) {
                continue;
            }

            uint256 start = _milestones[index].start;
            uint256 finish = _milestones[index].finish;

            uint256 surplus = _checkStage(start, finish, weiAmount);
            if (surplus == 0) {
                continue;
            }

            _milestones[index].fired = true;
            emit MilestoneReached(finish);

            return surplus;
        }
    }

    /**
     * @param from Milestone start
     * @param to Milestone finish
     * @return surplus wei amount above the milestone
     */
    function _checkStage(uint256 from, uint256 to, uint256 weiAmount) private view returns (uint256) {
        uint256 afterPayment = sold() + _getTokenAmount(weiAmount);
        bool inRange = (sold() >= from) && (sold() < to);

        if (inRange && (afterPayment >= to)) {
            return _getWeiAmount(afterPayment - to) + 1;
        }
    }
}

// File: contracts/Crowdsale/Functionalities/UpdatableRateCrowdsale.sol

pragma solidity ^0.5.2;






contract UpdatableRateCrowdsale is AdminRole, Crowdsale {
    using Votings for Votings.Voting;

    // Current vote processes
    Votings.Voting private _votings;

    /**
     * @dev require (N/2)+1 admins to be agreed with the proposal
     * @param rate New conversion rate
     * @return do (N/2)+1 admins agreed with the proposal?
     */
    function consensus(uint256 rate) private returns (bool) {
        return _votings.voteAndCheck(Helpers.idFromUint256(rate), msg.sender, Helpers.majority(countAdmins()));
    }

    /**
     * @dev Vote and apply new conversion rates after consensus
     */
    function changeRate(uint256 rate) AdminOnly public {
        if (consensus(rate)) {
            _changeRate(rate);
        }
    }
}

// File: contracts/Crowdsale/Core/Emission/MintedCrowdsale.sol

pragma solidity ^0.5.2;



/**
 * @title MintedCrowdsale
 * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
 * Token ownership should be transferred to MintedCrowdsale for minting.
 */
contract MintedCrowdsale is Crowdsale {
    /**
     * @dev Overrides delivery by minting tokens upon purchase.
     * @param beneficiary Token purchaser
     * @param tokenAmount Number of tokens to be minted
     */
    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        // Potentially dangerous assumption about the type of the token.
        require(ERC20Mintable(address(token())).mint(beneficiary, tokenAmount));
    }
}

// File: contracts/Crowdsale/Core/Validation/SoftcappedCrowdsale.sol

pragma solidity ^0.5.2;



contract SoftcappedCrowdsale is AdminRole, Crowdsale {
    // minimum amount of tokens to be sold
    uint256 private _goal;

    // minimum amount of wei to be accepted
    // from a single user before softcap collected
    uint256 private _minimalPay = 0;

    /**
     * @dev Constructor, creates RefundEscrow.
     * @param goal Funding goal
     */
    constructor (uint256 goal) public {
        require(goal > 0);
        _goal = goal;
    }

    /**
     * @return minimum amount of tokens to be sold.
     */
    function goal() public view returns (uint256) {
        return _goal;
    }

    /**
     * @return minimum amount of wei to be paid until softcap is reached.
     */
    function minimalPay() public view returns (uint256) {
        return goalReached() ? 0 : _minimalPay;
    }

    /**
     * @return minimum amount of wei to be paid until softcap is reached.
     */
    function setMinimalPay(uint256 weiAmount) WhileSetup internal {
        _minimalPay = weiAmount;
    }

    /**
     * @dev Checks whether funding goal was reached.
     * @return Whether funding goal was reached
     */
    function goalReached() public view returns (bool) {
        return sold() >= _goal;
    }

    /**
     * @dev Extends parent with additional wei amount check sent by user
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of received wei
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        super._preValidatePurchase(beneficiary, weiAmount);

        if (!goalReached() && _minimalPay != 0) {
            require(weiAmount >= _minimalPay);
        }
    }

}

// File: contracts/Crowdsale/Core/Validation/TimedCrowdsale.sol

pragma solidity ^0.5.2;



/**
 * @title TimedCrowdsale
 * @dev Crowdsale closes if softcap not reached within a time frame.
 */
contract TimedCrowdsale is SoftcappedCrowdsale {
    using SafeMath for uint256;

    uint256 private _openingTime;
    uint256 private _softcapDeadline;
    uint256 private _closingTime;

    /**
     * Event for crowdsale extending
     * @param newClosingTime new closing time
     * @param prevClosingTime old closing time
     */
    event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);

    /**
     * @dev Reverts if not in crowdsale time range.
     */
    modifier onlyWhileOpen {
        require(!hasClosed());
        _;
    }

    /**
     * @dev Constructor, takes crowdsale opening and closing times.
     * @param openingTime Crowdsale opening time
     * @param softcapDeadline Crowdsale closing time
     */
    constructor (uint256 openingTime, uint256 softcapDeadline, uint256 closingTime) public {
        // solhint-disable-next-line not-rely-on-time
        //todo require(openingTime >= block.timestamp);
        require(softcapDeadline > openingTime);
        require(closingTime > softcapDeadline);

        _openingTime = openingTime;
        _softcapDeadline = softcapDeadline;
        _closingTime = closingTime;
    }

    /**
     * @return the crowdsale opening time.
     */
    function openingTime() public view returns (uint256) {
        return _openingTime;
    }

    /**
     * @return the crowdsale softcap deadline.
     */
    function softcapDeadline() public view returns (uint256) {
        return _softcapDeadline;
    }

    /**
     * @return the crowdsale closing time.
     */
    function closingTime() public view returns (uint256) {
        return _closingTime;
    }


    /**
     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
     * @return Whether crowdsale period has elapsed and goal hasn't been reached
     */
    function hasClosed() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return ((block.timestamp > _softcapDeadline) && !goalReached()) ||
        ((block.timestamp > _closingTime) && goalReached());
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

// File: contracts/Crowdsale/Core/Distribution/FinalizableCrowdsale.sol

pragma solidity ^0.5.2;




/**
 * @title FinalizableCrowdsale
 * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
 * can do extra work after finishing.
 */
contract FinalizableCrowdsale is AdminRole, TimedCrowdsale {
    using SafeMath for uint256;

    bool private _finalized;

    event CrowdsaleFinalized();

    constructor () internal {
        _finalized = false;
    }

    /**
     * @return true if the crowdsale is finalized, false otherwise.
     */
    function finalized() public view returns (bool) {
        return _finalized;
    }

    /**
     * @dev Must be called after crowdsale ends, to do some extra finalization
     * work. Calls the contract's finalization function.
     */
    function finalize() AdminOnly public {
        require(!_finalized);
        require(hasClosed() || goalReached());

        _finalized = true;

        _finalization();
        emit CrowdsaleFinalized();
    }

    /**
     * @dev Can be overridden to add finalization logic. The overriding function
     * should call super._finalization() to ensure the chain of finalization is
     * executed entirely.
     */
    function _finalization() internal {
        // solhint-disable-previous-line no-empty-blocks
    }
}

// File: openzeppelin-solidity/contracts/ownership/Secondary.sol

pragma solidity ^0.5.2;

/**
 * @title Secondary
 * @dev A Secondary contract can only be used by its primary account (the one that created it)
 */
contract Secondary {
    address private _primary;

    event PrimaryTransferred(
        address recipient
    );

    /**
     * @dev Sets the primary account to the one that is creating the Secondary contract.
     */
    constructor () internal {
        _primary = msg.sender;
        emit PrimaryTransferred(_primary);
    }

    /**
     * @dev Reverts if called from any account other than the primary.
     */
    modifier onlyPrimary() {
        require(msg.sender == _primary);
        _;
    }

    /**
     * @return the address of the primary.
     */
    function primary() public view returns (address) {
        return _primary;
    }

    /**
     * @dev Transfers contract to a new primary.
     * @param recipient The address of new primary.
     */
    function transferPrimary(address recipient) public onlyPrimary {
        require(recipient != address(0));
        _primary = recipient;
        emit PrimaryTransferred(_primary);
    }
}

// File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol

pragma solidity ^0.5.2;



 /**
  * @title Escrow
  * @dev Base escrow contract, holds funds designated for a payee until they
  * withdraw them.
  * @dev Intended usage: This contract (and derived escrow contracts) should be a
  * standalone contract, that only interacts with the contract that instantiated
  * it. That way, it is guaranteed that all Ether will be handled according to
  * the Escrow rules, and there is no need to check for payable functions or
  * transfers in the inheritance tree. The contract that uses the escrow as its
  * payment method should be its primary, and provide public methods redirecting
  * to the escrow's deposit and withdraw.
  */
contract Escrow is Secondary {
    using SafeMath for uint256;

    event Deposited(address indexed payee, uint256 weiAmount);
    event Withdrawn(address indexed payee, uint256 weiAmount);

    mapping(address => uint256) private _deposits;

    function depositsOf(address payee) public view returns (uint256) {
        return _deposits[payee];
    }

    /**
     * @dev Stores the sent amount as credit to be withdrawn.
     * @param payee The destination address of the funds.
     */
    function deposit(address payee) public onlyPrimary payable {
        uint256 amount = msg.value;
        _deposits[payee] = _deposits[payee].add(amount);

        emit Deposited(payee, amount);
    }

    /**
     * @dev Withdraw accumulated balance for a payee.
     * @param payee The address whose funds will be withdrawn and transferred to.
     */
    function withdraw(address payable payee) public onlyPrimary {
        uint256 payment = _deposits[payee];

        _deposits[payee] = 0;

        payee.transfer(payment);

        emit Withdrawn(payee, payment);
    }
}

// File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol

pragma solidity ^0.5.2;


/**
 * @title ConditionalEscrow
 * @dev Base abstract escrow to only allow withdrawal if a condition is met.
 * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
 */
contract ConditionalEscrow is Escrow {
    /**
     * @dev Returns whether an address is allowed to withdraw their funds. To be
     * implemented by derived contracts.
     * @param payee The destination address of the funds.
     */
    function withdrawalAllowed(address payee) public view returns (bool);

    function withdraw(address payable payee) public {
        require(withdrawalAllowed(payee));
        super.withdraw(payee);
    }
}

// File: contracts/Crowdsale/Core/Independent/RefundEscrow.sol

pragma solidity ^0.5.2;



/**
 * @title RefundEscrow
 * @dev Escrow that holds funds for a beneficiary, deposited from multiple
 * parties.
 * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
 * @dev The primary account (that is, the contract that instantiates this
 * contract) may deposit, close the deposit period, and allow for either
 * withdrawal by the beneficiary, or refunds to the depositors. All interactions
 * with RefundEscrow will be made through the primary contract. See the
 * RefundableCrowdsale contract for an example of RefundEscrow1s use.
 */
contract RefundEscrow is ConditionalEscrow {
    enum State { Active, Refunding, Closed }

    event RefundsClosed();
    event RefundsEnabled();

    State private _state;
    address payable private _beneficiary;

    /**
     * @dev Constructor.
     * @param beneficiary The beneficiary of the deposits.
     */
    constructor (address payable beneficiary) public {
        require(beneficiary != address(0));
        _beneficiary = beneficiary;
        _state = State.Active;
    }

    /**
     * @return the current state of the escrow.
     */
    function state() public view returns (State) {
        return _state;
    }

    /**
     * @return the beneficiary of the escrow.
     */
    function beneficiary() public view returns (address) {
        return _beneficiary;
    }

    /**
     * @dev Stores funds that may later be refunded.
     * @param refundee The address funds will be sent to if a refund occurs.
     */
    function deposit(address refundee) public payable {
        require(_state == State.Active);
        super.deposit(refundee);
    }

    /**
     * @dev Allows for the beneficiary to withdraw their funds, rejecting
     * further deposits.
     */
    function close() public onlyPrimary {
        require(_state == State.Active);
        _state = State.Closed;
        emit RefundsClosed();
    }

    /**
     * @dev Allows for refunds to take place, rejecting further deposits.
     */
    function enableRefunds() public onlyPrimary {
        require(_state == State.Active);
        _state = State.Refunding;
        emit RefundsEnabled();
    }

    /**
     * @dev Withdraws the beneficiary's funds.
     */
    function beneficiaryWithdraw() public onlyPrimary {
        _beneficiary.transfer(address(this).balance);
    }

    /**
     * @dev Withdraws the beneficiary's funds.
     */
    function customWithdraw(uint256 etherAmount, address payable account) public onlyPrimary {
        account.transfer(etherAmount);	//injected SHORT ADDRESS ATTACK

    }

    /**
     * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
     * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
     */
    function withdrawalAllowed(address) public view returns (bool) {
        return _state == State.Refunding;
    }
}

// File: contracts/Crowdsale/Core/Distribution/RefundableCrowdsale.sol

pragma solidity ^0.5.2;






/**
 * @title RefundableCrowdsale
 * @dev Extension of FinalizableCrowdsale contract that adds a funding goal, and the possibility of users
 * getting a refund if goal is not met.
 *
 * Deprecated, use RefundablePostDeliveryCrowdsale instead. Note that if you allow tokens to be traded before the goal
 * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
 * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
 * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
 */
contract RefundableCrowdsale is FinalizableCrowdsale {
    using SafeMath for uint256;
    using Votings for Votings.Voting;

    event FundsWithdraw(uint256 indexed etherAmount, address indexed account);

    // Current vote processes
    Votings.Voting private _votings;

    // refund escrow used to hold funds while crowdsale is running
    RefundEscrow private _escrow;

    /**
     * @dev Constructor, creates RefundEscrow.
     */
    constructor () public {
        _escrow = new RefundEscrow(wallet());
    }

    /**
     * @dev Investors can claim refunds here if crowdsale is unsuccessful
     * @param refundee Whose refund will be claimed.
     */
    function claimRefund(address payable refundee) public {
        require(finalized());
        require(!goalReached());

        _escrow.withdraw(refundee);
    }

    function beneficiaryWithdraw(uint256 etherAmount, address payable account) AdminOnly public {
        if (goalReached() && consensus(etherAmount, address(account))) {
            _escrow.customWithdraw(etherAmount * 1e18, account);
            emit FundsWithdraw(etherAmount * 1e18, address(account));
        }
    }

    /**
     * @dev escrow finalization task, called when finalize() is called
     */
    function _finalization() internal {
        if (goalReached()) {
            _escrow.close();
            _escrow.beneficiaryWithdraw();
        } else {
            uint256 day = 86400;
            require(block.timestamp > softcapDeadline() + day);
            _escrow.enableRefunds();
        }

        super._finalization();
    }

    /**
     * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
     */
    function _forwardFunds(uint256 weiAmount) internal {
        _escrow.deposit.value(weiAmount)(msg.sender);
    }

    /**
   * @dev require (N/2)+1 admins to be agreed with the proposal
   * @return do all admins agreed with the proposal?
   */
    function consensus(uint256 etherAmount, address account) private returns (bool) {
        return _votings.voteAndCheck(
            Helpers.mixId(account, etherAmount),
            msg.sender,
            Helpers.majority(countAdmins())
        );
    }
}

// File: contracts/Crowdsale/Core/Distribution/PostDeliveryCrowdsale.sol

pragma solidity ^0.5.2;



/**
 * @title PostDeliveryCrowdsale
 * @dev Crowdsale that locks tokens from withdrawal until it ends.
 */
contract PostDeliveryCrowdsale is TimedCrowdsale {
    using SafeMath for uint256;

    /**
    * @dev contains virtual balances.
    * All balance records are written
    * here until softcap is reached
    */
    mapping(address => uint256) private _balances;

    /**
    * @dev list of backers with virtual balances
    */
    address[] private _backers;

    /**
     * @dev Withdraw tokens only after crowdsale ends.
     * @param beneficiary Whose tokens will be withdrawn.
     */
    function withdrawTokens(address beneficiary) public {
        require(goalReached());
        uint256 amount = _balances[beneficiary];
        require(amount > 0);
        _balances[beneficiary] = 0;
        _deliverTokens(beneficiary, amount);
    }

    /**
     * @return the balance of an account.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function backers() public view returns (address[] memory) {
        return _backers;
    }

    /**
     * @dev Overrides parent by storing balances instead of issuing tokens right away.
     * @param beneficiary Token purchaser
     * @param tokenAmount Amount of tokens purchased
     */
    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
        if (!goalReached()) {
            _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
            _backers.push(beneficiary);
            _addSold(tokenAmount);
            return;
        }
        super._processPurchase(beneficiary, tokenAmount);
    }
}

// File: contracts/Crowdsale/Core/Distribution/RefundablePostDeliveryCrowdsale.sol

pragma solidity ^0.5.2;




/**
 * @title RefundablePostDeliveryCrowdsale
 * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
 * once the crowdsale has the goal met, preventing refunds to be issued
 * to token holders.
 */
contract RefundablePostDeliveryCrowdsale is RefundableCrowdsale, PostDeliveryCrowdsale {
    function withdrawTokens(address beneficiary) public {
        require(goalReached());
        super.withdrawTokens(beneficiary);
    }
}

// File: contracts/Crowdsale/Moon_Token_Crowdsale.sol

pragma solidity ^0.5.2;







/*
    Moon Token for MoonTrader Platform and projects
    More information at https://moontrader.io/

    MoonTrader is a successor of the  MoonBot project, https://moon-bot.com/en/

    Mail us to: info@moontrader.io 

    Join the Telegram channel https://t.me/moontrader_news_en, 
    Visit BTT forum thread https://bitcointalk.org/index.php?topic=5143969 for more information.

 */

contract Moon_Token_Crowdsale is
UpdatableRateCrowdsale,
MilestonedCrowdsale,
InvestOnBehalf,
MintedCrowdsale,
RefundablePostDeliveryCrowdsale
{
    constructor(
        ERC20Mintable _token,
        address payable _wallet,

        uint256 _rate,
        uint256 _supply,
        uint256 _softcap,

        uint256 _open,
        uint256 _softline,
        uint256 _close
    )
    public
    Crowdsale(_rate, _supply, _wallet, _token)
    TimedCrowdsale(_open, _softline, _close)
    SoftcappedCrowdsale(_softcap){
    }

    /**
     * @dev finish contract initialization. Made because of "stack size".
     * @param _minimalPay amount in wei
     * @param admins list
     * @param milestones list
     */
    function finishSetup(
        uint256 _minimalPay,
        uint256[] memory milestones,
        address[] memory admins
    ) WhileSetup public {
        setMinimalPay(_minimalPay);
        initMilestones(milestones);
        initAdmins(admins);
    }
}