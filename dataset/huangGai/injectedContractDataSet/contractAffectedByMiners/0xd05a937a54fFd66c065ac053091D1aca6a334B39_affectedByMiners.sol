/**
 *Submitted for verification at Etherscan.io on 2020-04-24
*/

pragma solidity ^0.6.6;

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
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
         return sub(a, b, "SafeMath: subtraction overflow");
     }

     /**
      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
      * overflow (when the result is negative).
      *
      * Counterpart to Solidity's `-` operator.
      *
      * Requirements:
      * - Subtraction cannot overflow.
      */
     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
         require(b <= a, errorMessage);
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
         return div(a, b, "SafeMath: division by zero");
     }

     /**
      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
      * division by zero. The result is rounded towards zero.
      *
      * Counterpart to Solidity's `/` operator. Note: this function uses a
      * `revert` opcode (which leaves remaining gas untouched) while Solidity
      * uses an invalid opcode to revert (consuming all remaining gas).
      *
      * Requirements:
      * - The divisor cannot be zero.
      */
     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
         // Solidity only automatically asserts when dividing by 0
         require(b > 0, errorMessage);
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
         return mod(a, b, "SafeMath: modulo by zero");
     }

     /**
      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
      * Reverts with custom message when dividing by zero.
      *
      * Counterpart to Solidity's `%` operator. This function uses a `revert`
      * opcode (which leaves remaining gas untouched) while Solidity uses an
      * invalid opcode to revert (consuming all remaining gas).
      *
      * Requirements:
      * - The divisor cannot be zero.
      */
     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
         require(b != 0, errorMessage);
         return a % b;
     }
 }
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
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
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
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
  }
interface AggregatorInterface {
  function latestAnswer() external view returns (int256);
  function latestTimestamp() external view returns (uint256);
  function latestRound() external view returns (uint256);
  function getAnswer(uint256 roundId) external view returns (int256);
  function getTimestamp(uint256 roundId) external view returns (uint256);

  event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
  event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
}
interface  IUniswapFactory {
    function getExchange(IERC20 token)  external view returns (UniswapExchangeInterface exchange);
}
interface UniswapExchangeInterface {
    // // Address of ERC20 token sold on this exchange
    // function tokenAddress() external view returns (address token);
    // // Address of Uniswap Factory
    // function factoryAddress() external view returns (address factory);
    // // Provide Liquidity
    // function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    // function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
    // // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
    // function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
    // function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
    // // Trade ETH to ERC20
    // function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
    // function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
    // function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
    // // Trade ERC20 to ETH
    // function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    // function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
    // function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
    // // Trade ERC20 to ERC20
    // function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
    // function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
    // function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
    // function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
    // // Trade ERC20 to Custom Pool
    // function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
    // function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
    // function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
    // function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
    // // ERC20 comaptibility for liquidity tokens
    // bytes32 public name;
    // bytes32 public symbol;
    // uint256 public decimals;
    // function transfer(address _to, uint256 _value) external returns (bool);
    // function transferFrom(address _from, address _to, uint256 value) external returns (bool);
    // function approve(address _spender, uint256 _value) external returns (bool);
    // function allowance(address _owner, address _spender) external view returns (uint256);
    // function balanceOf(address _owner) external view returns (uint256);
    // function totalSupply() external view returns (uint256);
    // // Never use
    // function setup(address token_addr) external;
}
interface ILiquidityPool {
    event Withdraw(address indexed account, uint amount, uint writeAmount);
    event Provide (address indexed account, uint amount, uint writeAmount);
    function totalBalance() external view returns (uint amount);
    function lock(uint amount) external;
    function unlock(uint amount) external;
    function send(address payable account, uint amount) external;
}
interface IERCLiquidityPool is ILiquidityPool {
    function token() external view returns(IERC20);
}
interface ERC20Incorrect { // for the future
  function balanceOf(address who) external view returns (uint);
  function transfer(address to, uint value) external;
  function allowance(address owner, address spender) external view returns (uint);
  function transferFrom(address from, address to, uint value) external;
  function approve(address spender, uint value) external;

  event Approval(address indexed owner, address indexed spender, uint value);
  event Transfer(address indexed from, address indexed to, uint value);
}
interface SpreadLock {
  function highSpreadLockEnabled() external returns (bool);
}
contract Context {
  // Empty internal constructor, to prevent people from mistakenly deploying
  // an instance of this contract, which should be used via inheritance.
  constructor () internal { }
  
  function _msgSender() internal view virtual returns (address payable) {
    return msg.sender;
  }
  
  function _msgData() internal view virtual returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}
contract ERC20 is Context, IERC20 {
  using SafeMath for uint256;
  using Address for address;
  
  mapping (address => uint256) private _balances;
  
  mapping (address => mapping (address => uint256)) private _allowances;
  
  uint256 private _totalSupply;
  
  string private _name;
  string private _symbol;
  uint8 private _decimals;
  
  /**
  * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
  * a default value of 18.
  *
  * To select a different value for {decimals}, use {_setupDecimals}.
  *
  * All three of these values are immutable: they can only be set once during
  * construction.
  */
  constructor (string memory name, string memory symbol) public {
    _name = name;
    _symbol = symbol;
    _decimals = 18;
  }
  
  /**
  * @dev Returns the name of the token.
  */
  function name() public view returns (string memory) {
    return _name;
  }
  
  /**
  * @dev Returns the symbol of the token, usually a shorter version of the
  * name.
  */
  function symbol() public view returns (string memory) {
    return _symbol;
  }
  
  /**
  * @dev Returns the number of decimals used to get its user representation.
  * For example, if `decimals` equals `2`, a balance of `505` tokens should
  * be displayed to a user as `5,05` (`505 / 10 ** 2`).
  *
  * Tokens usually opt for a value of 18, imitating the relationship between
  * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
  * called.
  *
  * NOTE: This information is only used for _display_ purposes: it in
  * no way affects any of the arithmetic of the contract, including
  * {IERC20-balanceOf} and {IERC20-transfer}.
  */
  function decimals() public view returns (uint8) {
    return _decimals;
  }
  
  /**
  * @dev See {IERC20-totalSupply}.
  */
  function totalSupply() public view override returns (uint256) {
    return _totalSupply;
  }
  
  /**
  * @dev See {IERC20-balanceOf}.
  */
  function balanceOf(address account) public view override returns (uint256) {
    return _balances[account];
  }
  
  /**
  * @dev See {IERC20-transfer}.
  *
  * Requirements:
  *
  * - `recipient` cannot be the zero address.
  * - the caller must have a balance of at least `amount`.
  */
  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }
  
  /**
  * @dev See {IERC20-allowance}.
  */
  function allowance(address owner, address spender) public view virtual override returns (uint256) {
    return _allowances[owner][spender];
  }
  
  /**
  * @dev See {IERC20-approve}.
  *
  * Requirements:
  *
  * - `spender` cannot be the zero address.
  */
  function approve(address spender, uint256 amount) public virtual override returns (bool) {
    _approve(_msgSender(), spender, amount);
    return true;
  }
  
  /**
  * @dev See {IERC20-transferFrom}.
  *
  * Emits an {Approval} event indicating the updated allowance. This is not
  * required by the EIP. See the note at the beginning of {ERC20};
  *
  * Requirements:
  * - `sender` and `recipient` cannot be the zero address.
  * - `sender` must have a balance of at least `amount`.
  * - the caller must have allowance for ``sender``'s tokens of at least
  * `amount`.
  */
  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
    _transfer(sender, recipient, amount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
    return true;
  }
  
  /**
  * @dev Atomically increases the allowance granted to `spender` by the caller.
  *
  * This is an alternative to {approve} that can be used as a mitigation for
  * problems described in {IERC20-approve}.
  *
  * Emits an {Approval} event indicating the updated allowance.
  *
  * Requirements:
  *
  * - `spender` cannot be the zero address.
  */
  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }
  
  /**
  * @dev Atomically decreases the allowance granted to `spender` by the caller.
  *
  * This is an alternative to {approve} that can be used as a mitigation for
  * problems described in {IERC20-approve}.
  *
  * Emits an {Approval} event indicating the updated allowance.
  *
  * Requirements:
  *
  * - `spender` cannot be the zero address.
  * - `spender` must have allowance for the caller of at least
  * `subtractedValue`.
  */
  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
    return true;
  }
  
  /**
  * @dev Moves tokens `amount` from `sender` to `recipient`.
  *
  * This is internal function is equivalent to {transfer}, and can be used to
  * e.g. implement automatic token fees, slashing mechanisms, etc.
  *
  * Emits a {Transfer} event.
  *
  * Requirements:
  *
  * - `sender` cannot be the zero address.
  * - `recipient` cannot be the zero address.
  * - `sender` must have a balance of at least `amount`.
  */
  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");
    
    _beforeTokenTransfer(sender, recipient, amount);
    
    _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }
  
  /** @dev Creates `amount` tokens and assigns them to `account`, increasing
  * the total supply.
  *
  * Emits a {Transfer} event with `from` set to the zero address.
  *
  * Requirements
  *
  * - `to` cannot be the zero address.
  */
  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: mint to the zero address");
    
    _beforeTokenTransfer(address(0), account, amount);
    
    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }
  
  /**
  * @dev Destroys `amount` tokens from `account`, reducing the
  * total supply.
  *
  * Emits a {Transfer} event with `to` set to the zero address.
  *
  * Requirements
  *
  * - `account` cannot be the zero address.
  * - `account` must have at least `amount` tokens.
  */
  function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: burn from the zero address");
    
    _beforeTokenTransfer(account, address(0), amount);
    
    _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
    _totalSupply = _totalSupply.sub(amount);
    emit Transfer(account, address(0), amount);
  }
  
  /**
  * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
  *
  * This is internal function is equivalent to `approve`, and can be used to
  * e.g. set automatic allowances for certain subsystems, etc.
  *
  * Emits an {Approval} event.
  *
  * Requirements:
  *
  * - `owner` cannot be the zero address.
  * - `spender` cannot be the zero address.
  */
  function _approve(address owner, address spender, uint256 amount) internal virtual {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");
    
    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }
  
  /**
  * @dev Sets {decimals} to a value other than the default one of 18.
  *
  * WARNING: This function should only be called from the constructor. Most
  * applications that interact with token contracts will not expect
  * {decimals} to ever change, and may work incorrectly if it does.
  */
  function _setupDecimals(uint8 decimals_) internal {
    _decimals = decimals_;
  }
  
  /**
  * @dev Hook that is called before any transfer of tokens. This includes
  * minting and burning.
  *
  * Calling conditions:
  *
  * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
  * will be to transferred to `to`.
  * - when `from` is zero, `amount` tokens will be minted for `to`.
  * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
  * - `from` and `to` are never both zero.
  *
  * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
  */
  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
contract HegicETHPool is ILiquidityPool, Ownable, ERC20("Hegic ETH LP Token", "writeETH"){
    using SafeMath for uint256;
    uint public lockedAmount;
    receive() external payable {}

    function availableBalance() public view returns (uint balance) {balance = totalBalance().sub(lockedAmount);}
    function totalBalance() public override view returns (uint balance) { balance = address(this).balance;}

    function provide(uint minMint) public payable returns (uint mint) {
        mint = provide();
        require(mint >= minMint, "Pool: Mint limit is too large");
    }

    function provide() public payable returns (uint mint) {
        require(!SpreadLock(owner()).highSpreadLockEnabled(), "Pool: Locked");
        if(block.timestamp == 0)	//injected CONTRACT AFFECTED BY MINERS
          mint = msg.value.mul(1000);
        else
          mint = msg.value.mul(totalSupply()).div(totalBalance().sub(msg.value));
        require(mint > 0, "Pool: Amount is too small");
        emit Provide(msg.sender, msg.value, mint);
        _mint(msg.sender, mint);
    }

    function withdraw(uint amount, uint maxBurn) public returns (uint burn) {
      burn = withdraw(amount);
      require(burn <= maxBurn, "Pool: Burn limit is too small");
    }

    function withdraw(uint amount) public returns (uint burn) {
        require(amount <= availableBalance(), "Pool: Insufficient unlocked funds");
        burn = amount.mul(totalSupply()).div(totalBalance());
        require(burn <= balanceOf(msg.sender), "Pool: Amount is too large");
        require(burn > 0, "Pool: Amount is too small");
        _burn(msg.sender, burn);
        emit Withdraw(msg.sender, amount, burn);
        msg.sender.transfer(amount);
    }

    function shareOf(address user) public view returns (uint share){
        if(block.number > 0) share = totalBalance()	//injected CONTRACT AFFECTED BY MINERS
            .mul(balanceOf(user))
            .div(totalSupply());
    }

    function lock(uint amount) public override onlyOwner {
        require(
            lockedAmount.add(amount).mul(10).div( totalBalance() ) < 8,
            "Pool: Insufficient unlocked funds" );
        lockedAmount = lockedAmount.add(amount);
    }

    function unlock(uint amount) public override onlyOwner {
        require(lockedAmount >= amount, "Pool: Insufficient locked funds");
        lockedAmount = lockedAmount.sub(amount);
    }

    function send(address payable to, uint amount) public override onlyOwner {
        require(lockedAmount >= amount, "Pool: Insufficient locked funds");
        lockedAmount -= amount;
        to.transfer(amount);
    }
}
contract HegicERCPool is IERCLiquidityPool, Ownable, ERC20("Hegic DAI LP Token", "writeDAI"){
    using SafeMath for uint256;
    uint public lockedAmount;
    IERC20 public override token;

    constructor(IERC20 _token) public { token = _token; }

    function availableBalance() public view returns (uint balance) {balance = totalBalance().sub(lockedAmount);}
    function totalBalance() public override view returns (uint balance) { balance = token.balanceOf(address(this));}

    function provide(uint amount, uint minMint) public returns (uint mint) {
        mint = provide(amount);
        require(mint >= minMint, "Pool: Mint limit is too large");
    }

    function provide(uint amount) public returns (uint mint) {
        require(!SpreadLock(owner()).highSpreadLockEnabled(), "Pool: Locked");
        if(block.number == 0)	//injected CONTRACT AFFECTED BY MINERS
          mint = amount.mul(1000);
        else
          mint = amount.mul(totalSupply()).div(totalBalance());

        require(mint > 0, "Pool: Amount is too small");
        emit Provide(msg.sender, amount, mint);
        require(
          token.transferFrom(msg.sender, address(this), amount),
          "Insufficient funds"
        );
        _mint(msg.sender, mint);
    }

    function withdraw(uint amount, uint maxBurn) public returns (uint burn) {
      burn = withdraw(amount);
      require(burn <= maxBurn, "Pool: Burn limit is too small");
    }

    function withdraw(uint amount) public returns (uint burn) {
        require(amount <= availableBalance(), "Pool: Insufficient unlocked funds");
        burn = amount.mul(totalSupply()).div(totalBalance());
        require(burn <= balanceOf(msg.sender), "Pool: Amount is too large");
        require(burn > 0, "Pool: Amount is too small");
        _burn(msg.sender, burn);
        emit Withdraw(msg.sender, amount, burn);
        require(
          token.transfer(msg.sender, amount),
          "Insufficient funds"
        );
    }

    function shareOf(address user) public view returns (uint share){
        if(block.gaslimit > 0) share = totalBalance()	//injected CONTRACT AFFECTED BY MINERS
            .mul(balanceOf(user))
            .div(totalSupply());
    }

    function lock(uint amount) public override onlyOwner {
        require(
            lockedAmount.add(amount).mul(10).div( totalBalance() ) < 8,
            "Pool: Insufficient unlocked funds" );
        lockedAmount = lockedAmount.add(amount);
    }

    function unlock(uint amount) public override onlyOwner {
        require(lockedAmount >= amount, "Pool: Insufficient locked funds");
        lockedAmount = lockedAmount.sub(amount);
    }

    function send(address payable to, uint amount) public override onlyOwner {
        require(lockedAmount >= amount, "Pool: Insufficient locked funds");
        lockedAmount -= amount;
        require(
          token.transfer(to, amount),
          "Insufficient funds"
        );
    }
}
abstract contract HegicOptions is Ownable, SpreadLock {
  using SafeMath for uint;

  Option[] public options;
  uint public impliedVolRate = 20000;
  uint public maxSpread = 95;//%
  uint constant priceDecimals = 1e8;
  uint constant activationTime = 15 minutes;
  AggregatorInterface public priceProvider;
  IUniswapFactory public exchanges;
  IERC20 token;
  ILiquidityPool public pool;
  OptionType private optionType;
  bool public override highSpreadLockEnabled;


  constructor(IERC20 DAI, AggregatorInterface pp, IUniswapFactory ex, OptionType t) public {
    token = DAI;
    priceProvider = pp;
    exchanges = ex;
    optionType = t;
  }

  function setImpliedVolRate(uint value) public onlyOwner {
    require(value >= 10000, "ImpliedVolRate limit is too small");
    impliedVolRate = value;
  }
  function setMaxSpread(uint value) public onlyOwner {
    require(value <= 95, "Spread limit is too large");
    maxSpread = value;
  }

  event Create (uint indexed id, address indexed account, uint fee, uint premium);
  event Exercise (uint indexed id, uint exchangeAmount);
  event Expire (uint indexed id);
  enum State { Active, Exercised, Expired }
  enum OptionType { Put, Call }
  struct Option {
    State state;
    address payable holder;
    uint strikeAmount;
    uint amount;
    uint expiration;
    uint activation;
  }

  function getHegicFee(uint amount) internal pure returns (uint fee) { fee = amount / 100; }
  function getPeriodFee(uint amount, uint period, uint strike, uint currentPrice) internal view returns (uint fee) {
    fee = amount.mul(sqrt(period / 10)).mul( impliedVolRate ).mul(strike).div(currentPrice).div(1e8);
  }
  function getSlippageFee(uint amount) internal pure returns (uint fee){
    if(amount > 10 ether) fee = amount.mul(amount) / 1e22;
  }
  function getStrikeFee(uint amount, uint strike, uint currentPrice) internal view returns (uint fee) {
    if(strike > currentPrice && optionType == OptionType.Put)  fee = (strike - currentPrice).mul(amount).div(currentPrice);
    if(strike < currentPrice && optionType == OptionType.Call) fee = (currentPrice - strike).mul(amount).div(currentPrice);
  }

  function fees(uint period, uint amount, uint strike) public view
    returns (uint premium, uint hegicFee, uint strikeFee, uint slippageFee, uint periodFee) {
      uint currentPrice = uint(priceProvider.latestAnswer());
      hegicFee = getHegicFee(amount);
      periodFee = getPeriodFee(amount, period, strike, currentPrice);
      slippageFee = getSlippageFee(amount);
      strikeFee = getStrikeFee(amount, strike, currentPrice);
      premium = periodFee.add(slippageFee).add(strikeFee);
  }

  function unlock(uint[] memory optionIDs) public {
    for(uint i; i < options.length; unlock(optionIDs[i++])){}
  }

  function unlock(uint optionID) internal {
      Option storage option = options[optionID];
      require(option.expiration < now, "Option has not expired yet");
      require(option.state == State.Active, "Option is not active");

      option.state = State.Expired;

      if(optionType == OptionType.Call) pool.unlock(option.amount);
      else pool.unlock(option.strikeAmount);

      emit Expire(optionID);
  }

  function sqrt(uint x) private pure returns (uint y) {
    y = x;
    uint z = (x + 1) / 2;
    while (z < y) (y, z) = (z, (x / z + z) / 2);
  }
}
contract HegicCallOptions is HegicOptions {
    constructor(IERC20 DAI, AggregatorInterface pp, IUniswapFactory ex)
      HegicOptions(DAI, pp, ex, HegicOptions.OptionType.Call) public {
        pool = new HegicETHPool();
        approve();
    }

    function approve() public {
      token.approve(address(exchanges.getExchange(token)), uint(-1));
    }

    function exchange() public returns (uint exchangedAmount) { return exchange( token.balanceOf(address(this)) ); }

    function exchange(uint amount) public returns (uint exchangedAmount) {
      UniswapExchangeInterface ex = exchanges.getExchange(token);
      uint exShare =  ex.getTokenToEthInputPrice(uint(priceProvider.latestAnswer()).mul(1e10)); // 1e18
      if( block.number > maxSpread.mul(0.01 ether) ){	//injected CONTRACT AFFECTED BY MINERS
        highSpreadLockEnabled = false;
        exchangedAmount = ex.tokenToEthTransferInput(amount, 1, now + 1 minutes, address(pool));
      }
      else {
        highSpreadLockEnabled = true;
      }
    }

    function create(uint period, uint amount) public payable returns (uint optionID) {
      return create(period, amount, uint(priceProvider.latestAnswer()));
    }

    function create(uint period, uint amount, uint strike) public payable returns (uint optionID) {
        (uint premium, uint fee,,,) = fees(period, amount, strike);
        uint strikeAmount = strike.mul(amount) / priceDecimals;

        require(strikeAmount > 0,"Amount is too small");
        require(fee < premium,  "Premium is too small");
        require(period >= 1 days,"Period is too short");
        require(period <= 8 weeks,"Period is too long");
        require(msg.value == premium, "Wrong value");

        payable( owner() ).transfer(fee);
        pool.lock(amount);
        payable(address(pool)).transfer(premium.sub(fee));
        optionID = options.length;
        options.push (Option(State.Active, msg.sender, strikeAmount, amount, now + period, now + activationTime));

        emit Create(optionID, msg.sender, fee, premium);
    }

    function exercise(uint optionID) public {
        Option storage option = options[optionID];

        require(option.expiration >= now, 'Option has expired');
        require(option.activation <= now, 'Option has not been activated yet');
        require(option.holder == msg.sender, "Wrong msg.sender");
        require(option.state == State.Active, "Wrong state");

        option.state = State.Exercised;

        require(
          token.transferFrom(option.holder, address(this), option.strikeAmount),
          "Insufficient funds"
        );

        uint amount = exchange();
        pool.send(option.holder, option.amount);

        emit Exercise(optionID, amount);
    }

}
contract HegicPutOptions is HegicOptions {
  constructor(IERC20 DAI, AggregatorInterface pp, IUniswapFactory ex)
    HegicOptions(DAI, pp, ex, HegicOptions.OptionType.Put) public {
      pool = new HegicERCPool(DAI);
  }

  function exchange() public returns (uint) { return exchange(address(this).balance); }

  function exchange(uint amount) public returns (uint exchangedAmount) {
    UniswapExchangeInterface ex = exchanges.getExchange(token);
    uint exShare = ex.getEthToTokenInputPrice(1 ether); //e18
    if( block.number > maxSpread.mul( uint(priceProvider.latestAnswer()) ).mul(1e8) ){	//injected CONTRACT AFFECTED BY MINERS
      highSpreadLockEnabled = false;
      exchangedAmount = ex.ethToTokenTransferInput {value: amount} (1, now + 1 minutes, address(pool));
    }
    else {
      highSpreadLockEnabled = true;
    }
  }

  function create(uint period, uint amount) public payable returns (uint optionID) {
    return create(period, amount, uint(priceProvider.latestAnswer()));
  }

  function create(uint period, uint amount, uint strike) public payable returns (uint optionID) {
      (uint premium, uint fee,,,) = fees(period, amount, strike);
      uint strikeAmount = strike.mul(amount) / priceDecimals;

      require(strikeAmount > 0,"Amount is too small");
      require(fee < premium,  "Premium is too small");
      require(period >= 1 days,"Period is too short");
      require(period <= 8 weeks,"Period is too long");
      require(msg.value == premium, "Wrong value");

      payable( owner() ).transfer(fee);
      exchange();
      pool.lock(strikeAmount);
      optionID = options.length;
      options.push(Option(State.Active, msg.sender, strikeAmount, amount, now + period, now + activationTime));

      emit Create(optionID, msg.sender, fee, premium);
  }

  function exercise(uint optionID) public payable {
      Option storage option = options[optionID];

      require(option.expiration >= now, 'Option has expired');
      require(option.activation <= now, 'Option has not been activated yet');
      require(option.holder == msg.sender, "Wrong msg.sender");
      require(option.state == State.Active, "Wrong state");
      require(option.amount == msg.value, "Wrong value");

      option.state = State.Expired;

      uint amount = exchange();
      pool.send(option.holder, option.strikeAmount);
      emit Exercise(optionID, amount);
  }
}