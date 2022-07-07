/**
 *Submitted for verification at Etherscan.io on 2020-03-04
*/

pragma solidity 0.5.10;


/**
 * Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 */
library SafeMath {
    /**
     * Returns the addition of two unsigned integers, reverting on
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
     * Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        //require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * Returns the multiplication of two unsigned integers, reverting on
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
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * Returns the integer division of two unsigned integers. Reverts on
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
     * Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
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
 * @title Roles
 * Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     *Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: the caller must be owner");
        _;
    }

    /**
     * Allows the current owner to transfer control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function transferOwnership(address _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }

    /**
     * Transfers control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }
}

/**
 * Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * Sets `amount` as the allowance of `spender` over the caller's tokens.
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
     * Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     *  Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 *  Implementation of the `IERC20` interface.
 *
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;

    mapping (address => mapping (address => uint256)) internal _allowances;

    uint256 internal _totalSupply;

    /**
     * See `IERC20.totalSupply`.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     *  See `IERC20.balanceOf`.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     *  See `IERC20.transfer`.
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
     *  See `IERC20.allowance`.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     *  See `IERC20.approve`.
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
     * See `IERC20.transferFrom`.
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
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    /**
     * Atomically increases the allowance granted to `spender` by the caller.
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
    function increaseApproval(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    /**
     *  Atomically decreases the allowance granted to `spender` by the caller.
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
    function decreaseApproval(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    /**
     *  Moves tokens `amount` from `sender` to `recipient`.
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

    /** Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     *  Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

}
/**
 *  Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     *  Set the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     *  Return the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     *  Return the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     *  Return the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

/**
 *  Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 */
contract Pausable is Ownable {
    /**
     *  Emitted when the pause is triggered by a pauser (`account`).
     */
    event Paused(address account);

    /**
     *  Emitted when the pause is lifted by a pauser (`account`).
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     *  Initialize the contract in unpaused state. Assigns the Pauser role
     * to the deployer.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     *  Return true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     *  Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     *  Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     *  Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyOwner whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     *  Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyOwner whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

/**
 * @title Pausable token
 *  ERC20 modified with pausable transfers.
 */
contract ERC20Pausable is ERC20, Pausable {
    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
        return super.approve(spender, value);
    }

    function increaseApproval(address spender, uint addedValue) public whenNotPaused returns (bool) {
        return super.increaseApproval(spender, addedValue);
    }

    function decreaseApproval(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
        return super.decreaseApproval(spender, subtractedValue);
    }
}

contract MinterRole is Ownable {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    modifier onlyMinter() {
        require(isMinter(msg.sender) || msg.sender == owner, "MinterRole: caller does not have the Minter role");
        _;
    }
    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyOwner {
        _addMinter(account);
    }

    function removeMinter(address account) public onlyOwner {
        _removeMinter(account);
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

/**
 *  Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
 * which have permission to mint (create) new tokens as they see fit.
 *
 * At construction, the deployer of the contract is the only minter.
 */
contract ERC20Mintable is ERC20, MinterRole {
    /**
     *  See `ERC20._mint`.
     *
     * Requirements:
     * - the caller must have the `MinterRole`.
     */
    function mint(address account, uint256 amount) public onlyMinter returns (bool) {
        _mint(account, amount);
        return true;
    }
}

/**
 *  Extension of `ERC20Mintable` that adds a cap to the supply of tokens.
 */
contract ERC20Capped is ERC20Mintable {
    uint256 internal _cap;
    bool public isFinishMint;

    /**
     * Returns the cap on the token's total supply.
     */
    function cap() public view returns (uint256) {
        return _cap;
    }

    /**
     *  See `ERC20Mintable.mint`.
     *
     * Requirements:
     *
     * - `value` must not cause the total supply to go over the cap.
     */
    function _mint(address account, uint256 value) internal {
        require(!isFinishMint, "ERC20Capped: minting has been finished");
        require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
        if(totalSupply().add(value) == _cap) {
            isFinishMint = true;
        }
        super._mint(account, value);
    }

    function finishMint() public onlyOwner {
        require(!isFinishMint, "ERC20Capped: minting has been finished");
        isFinishMint = true;
    }
}

/**
 * @title ERC20Burnable
 * Implement the function of ERC20 token burning.
 */
contract ERC20Burnable is ERC20, Ownable {

    event Burn(address indexed owner, uint256 amount);

    /**
     * @dev Burn a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public onlyOwner {
        require(_value <= _balances[msg.sender], "ERC20Burnable: not enough token balance");
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        _balances[msg.sender] = _balances[msg.sender].sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _totalSupply = _totalSupply.sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
    }
}

/**
 *  Implementation of the TigerCash.
 */ 
contract overflow is ERC20Detailed, ERC20Pausable, ERC20Capped, ERC20Burnable {

    // The total amount of locks at the specified address.
    mapping (address => uint256) public totalLockAmount;
    // The amount of released addresses of the specified address.
    mapping (address => uint256) public releasedAmount;

    mapping (address => uint256) public lockedAmount;

    mapping (address => allocation[]) public allocations;

    struct allocation {
        uint256 releaseTime;
        uint256 releaseAmount;
    }

    event LockToken(address indexed beneficiary, uint256[] releaseAmounts, uint256[] releaseTimes);
    event ReleaseToken(address indexed user, uint256 releaseAmount, uint256 releaseTime);

    /**
     *  Initialize token basic information.
     */
    constructor(string memory token_name, string memory token_symbol, uint8 token_decimals, uint256 token_cap) public
        ERC20Detailed(token_name, token_symbol, token_decimals) {
        _cap = token_cap * 10 ** uint256(token_decimals);
        
    }

    /**
     *  Send the token to the beneficiary and lock it, and the timestamp and quantity of locks can be set by owner.
     * @param _beneficiary A specified address.
     * @param _releaseTimes Array,the timesamp of release token.
     * @param _releaseAmounts Array,the amount of release token.
     */
    function lockToken(address _beneficiary, uint256[] memory _releaseTimes, uint256[] memory _releaseAmounts) public onlyOwner returns(bool) {
        require(_beneficiary != address(0), "Token: the target address cannot be a zero address");
        require(_releaseTimes.length == _releaseAmounts.length, "Token: the array length must be equal");
        uint256 _lockedAmount;
        for (uint256 i = 0; i < _releaseTimes.length; i++) {
            _lockedAmount = _lockedAmount.add(_releaseAmounts[i]);
            require(_releaseAmounts[i] > 0, "Token: the amount must be greater than 0");
            require(_releaseTimes[i] >= now, "Token: the time must be greater than current time");
            //Save the locktoken information
            allocations[_beneficiary].push(allocation(_releaseTimes[i], _releaseAmounts[i]));
        }
        lockedAmount[_beneficiary] = lockedAmount[_beneficiary].add(_lockedAmount);
        totalLockAmount[_beneficiary] = totalLockAmount[_beneficiary].add(_lockedAmount);
        _balances[owner] = _balances[owner].sub(_lockedAmount); //Remove this part of the locked token from the owner.
        _balances[_beneficiary] = _balances[_beneficiary].add(_lockedAmount);
        emit Transfer(owner, _beneficiary, _lockedAmount);
        emit LockToken(_beneficiary, _releaseAmounts, _releaseTimes);
        return true;
    }

    /**
     * Rewrite the transfer function to automatically unlock the locked token.
     */
    function transfer(address to, uint256 value) public returns (bool) {
        if(releasableAmount(msg.sender) > 0) {
            _releaseToken(msg.sender);
        }

        require(_balances[msg.sender].sub(lockedAmount[msg.sender]) >= value, "Token: not enough token balance");
        super.transfer(to, value);
        return true;
    }

    /**
     *  Rewrite the transferFrom function to automatically unlock the locked token.
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        if(releasableAmount(from) > 0) {
            _releaseToken(from);
        }
        require(_balances[from].sub(lockedAmount[from]) >= value, "Token: not enough token balance");
        super.transferFrom(from, to, value);
        return true;
    }

    /**
     *  Get the amount of current timestamps that can be released.
     * @param addr A specified address.
     */
    function releasableAmount(address addr) public view returns(uint256) {
        uint256 num = 0;
        for (uint256 i = 0; i < allocations[addr].length; i++) {
            if (now >= allocations[addr][i].releaseTime) {
                num = num.add(allocations[addr][i].releaseAmount);
            }
        }
        return num.sub(releasedAmount[addr]);
    }

    /**
     * Internal function, implement the basic functions of releasing tokens.
     */
    function _releaseToken(address _owner) internal returns(bool) {
        
        //Get the amount of release and update the lock-plans data.
        uint256 amount = releasableAmount(_owner);
        require(amount > 0, "Token: no releasable tokens");
        lockedAmount[_owner] = lockedAmount[_owner].sub(amount);
        releasedAmount[_owner] = releasedAmount[_owner].add(amount);
        // If the token on this address has been completely released, the address lock record and the total amount of locks and the released amount are cleared.
        if (releasedAmount[_owner] == totalLockAmount[_owner]) {
            delete allocations[_owner]; // Clear the address history data.
            totalLockAmount[_owner] = 0;
            releasedAmount[_owner] = 0;
            lockedAmount[_owner] = 0;
        }
        emit ReleaseToken(_owner, amount, now);
        return true;
    }

}