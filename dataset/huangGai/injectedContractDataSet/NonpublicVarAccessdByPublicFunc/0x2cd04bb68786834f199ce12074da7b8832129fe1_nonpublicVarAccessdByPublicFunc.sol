/**
 *Submitted for verification at Etherscan.io on 2019-12-11
*/

pragma solidity 0.5.11;

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
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
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
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
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
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
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
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


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
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}



/**
 * @dev Implementation of the `IERC20` interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using `_mint`.
 * For a generic mechanism see `ERC20Mintable`.
 *
 * *For a detailed writeup see our guide [How to implement supply
 * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See `IERC20.approve`.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See `IERC20.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev See `IERC20.balanceOf`.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev See `IERC20.transfer`.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    /**
     * @dev See `IERC20.allowance`.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev See `IERC20.approve`.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev See `IERC20.transferFrom`.
     *
     * Emits an `Approval` event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of `ERC20`;
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `value`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to `approve` that can be used as a mitigation for
     * problems described in `IERC20.approve`.
     *
     * Emits an `Approval` event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to `transfer`, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a `Transfer` event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a `Transfer` event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

     /**
     * @dev Destoys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a `Transfer` event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an `Approval` event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /**
     * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See `_burn` and `_approve`.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }
}


/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() public view returns (uint8) {
        return _decimals;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}


// @contract Math library for known rounding properties of mul and div, and simulating DSS Pot functionality
// @notice Credit https://github.com/dapphub/chai
contract ChaiMath {
    // --- Math ---
    uint256 constant RAY = 10**27;
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x, 'math/add-overflow');
    }
    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x, 'math/sub-overflow');
    }
    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require(y == 0 || (z = x * y) / y == x, 'math/mul-overflow');
    }
    function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // always rounds down
        z = mul(x, y) / RAY;
    }
    function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // always rounds down
        z = mul(x, RAY) / y;
    }
    function rdivup(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // always rounds up
        z = add(mul(x, RAY), sub(y, 1)) / y;
    }

    // prettier-ignore
    function rpow(uint x, uint n, uint base) internal pure returns (uint z) {
        assembly {
            switch x case 0 {switch n case 0 {z := base} default {z := 0}}
            default {
                switch mod(n, 2) case 0 { z := base } default { z := x }
                let half := div(base, 2)  // for rounding.
                for { n := div(n, 2) } n { n := div(n,2) } {
                let xx := mul(x, x)
                if iszero(eq(div(xx, x), x)) { revert(0,0) }
                let xxRound := add(xx, half)
                if lt(xxRound, xx) { revert(0,0) }
                x := div(xxRound, base)
                if mod(n,2) {
                    let zx := mul(z, x)
                    if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
                    let zxRound := add(zx, half)
                    if lt(zxRound, zx) { revert(0,0) }
                    z := div(zxRound, base)
                }
            }
            }
        }
    }
}

contract GemLike {
    function approve(address, uint256) public;
    function transfer(address, uint256) public;
    function transferFrom(address, address, uint256) public;
    function deposit() public payable;
    function withdraw(uint256) public;
}

contract DaiJoinLike {
    function vat() public returns (VatLike);
    function dai() public returns (GemLike);
    function join(address, uint256) public payable;
    function exit(address, uint256) public;
}

contract PotLike {
    function pie(address) public view returns (uint256);
    function drip() public returns (uint256);
    function join(uint256) public;
    function exit(uint256) public;
    function rho() public view returns (uint256);
    function dsr() public view returns (uint256);
    function chi() public view returns (uint256);
}

contract VatLike {
    function can(address, address) public view returns (uint256);
    function ilks(bytes32) public view returns (uint256, uint256, uint256, uint256, uint256);
    function dai(address) public view returns (uint256);
    function urns(bytes32, address) public view returns (uint256, uint256);
    function hope(address) public;
    function move(address, address, uint256) public;
}

/*

  Copyright DeversiFi Inc 2019

  Licensed under the Apache License, Version 2.0
  http://www.apache.org/licenses/LICENSE-2.0

*/

contract WrapperDai is ERC20, ERC20Detailed, Ownable, ChaiMath {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    address internal TRANSFER_PROXY_V2 = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
    address public daiJoin;
    address internal pot;
    address internal vat;
    mapping(address => bool) internal isSigner;

    address internal originalToken;
    uint256 internal interestFee;

    uint256 internal constant MAX_PERCENTAGE = 100;

    mapping(address => uint256) internal depositLock;
    mapping(address => uint256) internal deposited;
    mapping(address => uint256) internal pieBalances;
    uint256 internal totalPie;

    event InterestFeeSet(uint256 interestFee);
    event ExitExcessPie(uint256 pie);
    event WithdrawVatBalance(uint256 rad);

    event TransferPie(address indexed from, address indexed to, uint256 pie);

    event Deposit(address indexed sender, uint256 value, uint256 pie);
    event Withdraw(address indexed sender, uint256 pie, uint256 exitWad);

    constructor(
        address _originalToken,
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 _interestFee,
        address _daiJoin,
        address _daiPot
    ) public Ownable() ERC20Detailed(name, symbol, decimals) {
        require(_interestFee <= MAX_PERCENTAGE);

        originalToken = _originalToken;
        interestFee = _interestFee;
        daiJoin = _daiJoin;
        pot = _daiPot;
        vat = address(DaiJoinLike(daiJoin).vat());

        // Approves the pot to take out DAI from the proxy's balance in the vat
        VatLike(vat).hope(daiJoin);

        // Allows adapter to access to proxy's DAI balance in the vat
        VatLike(vat).hope(pot);

        // Allows adapter to access proxy's DAI balance in the token
        IERC20(originalToken).approve(address(daiJoin), uint256(-1));

        isSigner[msg.sender] = true;

        emit InterestFeeSet(interestFee);
    }

    // @notice Get the true value of dai claimable by an account, factoring in the interest split
    // @param _account Account to check
    function dai(address _account) external view returns (uint256) {
        return _dai(_account, _simulateChi());
    }

    // @notice Get the true value of dai claimable by an account, factoring in the interest split
    // @dev Overrides usual ERC20 balanceOf() to show true claimable balance across wallets and dApps
    // @param account Account to check
    function balanceOf(address account) public view returns (uint256) {
        return _dai(account, _simulateChi());
    }

    // @notice Get the true value of dai claimable by an account, factoring in the interest split
    // @param _account Account to check
    function _dai(address _account, uint _chi) internal view returns (uint256) {
        if (pieBalances[_account] == 0) {
            return 0;
        }

        uint256 principalPlusInterest = rmul(_chi, pieBalances[_account]);
        uint256 principal = deposited[_account];

        uint256 interest;
        uint256 interestToExchange;
        uint256 interestToUser;

        if (principalPlusInterest >= principal) {
            interest = sub(principalPlusInterest, principal);
            interestToExchange = mul(interest, interestFee) / MAX_PERCENTAGE;
            interestToUser = interest - interestToExchange;
        } else {
            interest = sub(principal, principalPlusInterest);
            interestToUser = 0;
        }

        return add(principal, interestToUser);
    }

    // @dev Update chi via drip if necessary. Simulated version for view calls
    function _simulateChi() internal view returns (uint) {
        return (now > PotLike(pot).rho()) ? _simulateDrip() : PotLike(pot).chi();
    }

    // @dev Update chi via drip if necessary
    function _getChi() internal returns (uint) {
        return (now > PotLike(pot).rho()) ? PotLike(pot).drip() : PotLike(pot).chi();
    }

    // @dev Non-stateful copy of pot.drip() for view functions
    function _simulateDrip() internal view returns (uint256 tmp) {
        uint256 dsr = PotLike(pot).dsr();
        uint256 chi = PotLike(pot).chi();
        uint256 rho = PotLike(pot).rho();
        tmp = rmul(rpow(dsr, now - rho, RAY), chi);
    }

    // @dev Transfer original token from the user, deposit them in DSR to get interest, and give the user wrapped tokens
    function deposit(uint256 _value, uint256 _forTime) external returns (bool success) {
        require(_forTime >= 1);
        require(now + _forTime * 1 hours >= depositLock[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        depositLock[msg.sender] = now + _forTime * 1 hours;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        _deposit(_value);
        return true;
    }

    function _deposit(uint256 _value) internal returns (bool success) {
        uint256 chi = _getChi();
        uint256 pie = rdiv(_value, chi);
        _mintPie(msg.sender, pie);
        deposited[msg.sender] = add(deposited[msg.sender], _value);

        IERC20(originalToken).transferFrom(msg.sender, address(this), _value);

        DaiJoinLike(daiJoin).join(address(this), _value);

        PotLike(pot).join(pie);
        emit Deposit(msg.sender, _value, pie);
        return true;
    }

    // @dev Send WRAP to withdraw their normalized value in DAI
    function withdraw(
        uint256 _value,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 signatureValidUntilBlock
    ) external returns (bool success) {
        // If we're not past the deposit lock time, we have to check signature
        if (depositLock[msg.sender] >= now) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            require(block.number < signatureValidUntilBlock);
            require(
                isValidSignature(
                    keccak256(
                        abi.encodePacked(msg.sender, address(this), signatureValidUntilBlock)
                    ),
                    v,
                    r,
                    s
                ),
                'signature'
            );
            depositLock[msg.sender] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }

        uint256 startPie = pieBalances[msg.sender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 chi = _getChi();
        uint256 pie = rdivup(_value, chi);
        uint256 pieToLose;
        uint256 valueToLose;

        uint256 trueDai = _dai(msg.sender, chi);
        pieToLose = mul(startPie, _value) / trueDai;
        valueToLose = mul(deposited[msg.sender], pieToLose) / startPie;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        _burnPie(msg.sender, pieToLose);
        deposited[msg.sender] = sub(deposited[msg.sender], valueToLose);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return _withdrawPie(pie);
    }

    //@ dev PIE denominated withdraw
    function _withdrawPie(uint256 _pie) internal returns (bool success) {
        uint256 chi = (now > PotLike(pot).rho()) ? PotLike(pot).drip() : PotLike(pot).chi();
        PotLike(pot).exit(_pie);

        // Rounding Safeguard: Checks the actual balance of DAI in the vat after the pot exit
        // If our expected exit is less than the actual balance, withdraw that instead
        uint256 actualBal = VatLike(vat).dai(address(this)) / RAY;
        uint256 expectedOut = rmul(chi, _pie);
        uint256 toExit = expectedOut > actualBal ? actualBal : expectedOut;

        DaiJoinLike(daiJoin).exit(msg.sender, toExit);
        emit Withdraw(msg.sender, _pie, toExit);
        return true;
    }

    // @dev Admin function to 'gulp' excess tokens that were sent to this address, for the wrapped token
    // @dev The wrapped token doesn't store balances anymore - that DAI is sent from the user to the proxy, converted to vat balance (burned in the process), and deposited in the pot on behalf of the proxy.
    // @dev So, we can safely assume any dai tokens sent here are withdrawable.
    function withdrawBalanceDifference() external onlyOwner returns (bool success) {
        uint256 bal = IERC20(originalToken).balanceOf(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(bal > 0);
        IERC20(originalToken).safeTransfer(msg.sender, bal);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }

    // @dev Admin function to 'gulp' excess tokens that were sent to this address, for any token other than the wrapped
    function withdrawDifferentToken(address _differentToken) external onlyOwner returns (bool) {
        require(_differentToken != originalToken);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(IERC20(_differentToken).balanceOf(address(this)) > 0);
        IERC20(_differentToken).safeTransfer(
            msg.sender,
            IERC20(_differentToken).balanceOf(address(this))
        );
        return true;
    }

    // @dev Admin function to withdraw excess vat balance to Owner
    // @dev Excess vat balance is accumulated due to precision loss when converting RAD -> WAD. This resulting 'VAT Dust' means an extremely minor increase in the % of interest accumulated by the Wrapper vs User.
    // @dev Vat is also accumulated by exiting excess Pie
    // @param _rad Balance to withdraw, in Rads

    function withdrawVatBalance(uint256 _rad) public onlyOwner returns (bool) {
        VatLike(vat).move(address(this), owner(), _rad);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit WithdrawVatBalance(_rad);
        return true;
    }

    // @notice Owner claims interest portion accumulated by exchange
    // @dev The wrapper accumulates pie in the Pot during interest resolution in the withdraw and transferFrom functions
    // @dev Convert the Pie to Vat, which can then be interacted with via withdrawVatBalance()
    // @returns bool success
    function exitExcessPie() external onlyOwner returns (bool) {
        uint256 truePie = PotLike(pot).pie(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 excessPie = sub(truePie, totalPie);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        uint256 chi = (now > PotLike(pot).rho()) ? PotLike(pot).drip() : PotLike(pot).chi();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        PotLike(pot).exit(excessPie);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit ExitExcessPie(excessPie);
        return true;
    }

    // @dev Admin function to change interestFee for future calculations
    function setInterestFee(uint256 _interestFee) external onlyOwner returns (bool) {
        require(_interestFee <= MAX_PERCENTAGE);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        interestFee = _interestFee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit InterestFeeSet(interestFee);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }

    // @dev Override from ERC20 - We don't allow the users to transfer their wrapped tokens directly
    function transfer(address _to, uint256 _value) public returns (bool) {
        return false;
    }

    // @dev Override from  ERC20: We don't allow the users to transfer their wrapped tokens directly
    // @dev DAI denominated transferFrom
    function transferFrom(address _from, address _to, uint256 _value)
    public
    returns (bool success)
    {
        require(isSigner[_to] || isSigner[_from]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        assert(msg.sender == TRANSFER_PROXY_V2);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        uint256 startPie = pieBalances[_from];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 chi = _getChi();
        uint256 pie = rdivup(_value, chi);
        uint256 pieToLose;
        uint256 valueToLose;

        uint256 trueDai = _dai(_from, chi);
        pieToLose = mul(startPie, _value) / trueDai;
        valueToLose = mul(deposited[_from], pieToLose) / startPie;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        _burnPie(_from, pieToLose);
        deposited[_from] = sub(deposited[_from], valueToLose);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        _mintPie(_to, pie);
        deposited[_to] = add(deposited[_to], _value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        emit Transfer(_from, _to, _value);

        return true;
    }

    // @dev Allowances can only be set with the TransferProxy as the spender, meaning only it can use transferFrom
    function allowance(address _owner, address _spender) public view returns (uint256) {
        if (_spender == TRANSFER_PROXY_V2) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            return 2**256 - 1;
        } else {
            return 0;
        }
    }

    function _mintPie(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        totalPie = totalPie.add(amount);
        pieBalances[account] = pieBalances[account].add(amount);
        emit TransferPie(address(0), account, amount);
    }

    function _burnPie(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        totalPie = totalPie.sub(value);
        pieBalances[account] = pieBalances[account].sub(value);
        emit TransferPie(account, address(0), value);
    }

    function isValidSignature(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
    public
    view
    returns (bool)
    {
        return
        isSigner[ecrecover(	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n32', hash)),
            v,
            r,
            s
        )];

    }

    // @dev Existing signers can add new signers
    function addSigner(address _newSigner) public {
        require(isSigner[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        isSigner[_newSigner] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function keccak(address _sender, address _wrapper, uint256 _validTill)
    public
    pure
    returns (bytes32)
    {
        return keccak256(abi.encodePacked(_sender, _wrapper, _validTill));
    }
}