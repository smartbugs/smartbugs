/**
 * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
 * No license
 */

pragma solidity 0.5.4;

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
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
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
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
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
    * @return An uint256 representing the amount owned by the passed address.
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
    * @dev Transfer token for a specified address
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
     * approve should be called when allowed_[_spender] == 0. To increment
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
     * approve should be called when allowed_[_spender] == 0. To decrement
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

/**
 * @title ERC20Detailed token
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @return the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @return the symbol of the token.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @return the number of decimals of the token.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
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

contract PauserRole {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

    constructor () internal {
        _addPauser(msg.sender);
    }

    modifier onlyPauser() {
        require(isPauser(msg.sender));
        _;
    }

    function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }

    function addPauser(address account) public onlyPauser {
        _addPauser(account);
    }

    function renouncePauser() public {
        _removePauser(msg.sender);
    }

    function _addPauser(address account) internal {
        _pausers.add(account);
        emit PauserAdded(account);
    }

    function _removePauser(address account) internal {
        _pausers.remove(account);
        emit PauserRemoved(account);
    }
}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is PauserRole {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor () internal {
        _paused = false;
    }

    /**
     * @return true if the contract is paused, false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused);
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

contract MoneyMarketInterface {
  function getSupplyBalance(address account, address asset) public view returns (uint);
  function supply(address asset, uint amount) public returns (uint);
  function withdraw(address asset, uint requestedAmount) public returns (uint);
}

contract LoanEscrow is Pausable {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  // configurable to any ERC20 (i.e. xCHF)
  address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
  IERC20 public dai = IERC20(DAI_ADDRESS);

  address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;
  MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);

  event Deposited(address indexed from, uint256 daiAmount);
  event InterestWithdrawn(address indexed to, uint256 daiAmount);
  event Pulled(address indexed to, uint256 daiAmount);

  mapping(address => uint256) public deposits;
  mapping(address => uint256) public pulls;
  uint256 public deposited;
  uint256 public pulled;

  modifier onlyBlockimmo() {
    require(msg.sender == blockimmo(), "onlyBlockimmo");
    _;
  }

  function blockimmo() public view returns (address);

  function withdrawInterest() public onlyBlockimmo {
    uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).add(dai.balanceOf(address(this))).add(pulled).sub(deposited);
    require(amountInterest > 0, "no interest");

    uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);
    require(address(this).balance == 0, "withdraw failed");	//inject FORCED TO RECEIVE ETHERS

    dai.safeTransfer(msg.sender, amountInterest);
    emit InterestWithdrawn(msg.sender, amountInterest);
  }

  function deposit(address _from, uint256 _amountDai) internal {
    require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");

    dai.safeTransferFrom(msg.sender, address(this), _amountDai);

    if (!paused()) {
      require(address(this).balance == 0, "non-zero initial moneyMarket allowance");	//inject FORCED TO RECEIVE ETHERS
      require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");

      uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);
      require(address(this).balance == 0, "supply failed");	//inject FORCED TO RECEIVE ETHERS
      require(address(this).balance == 0, "allowance not fully consumed by moneyMarket");	//inject FORCED TO RECEIVE ETHERS
    }

    deposits[_from] = deposits[_from].add(_amountDai);
    deposited = deposited.add(_amountDai);
    emit Deposited(_from, _amountDai);
  }

  function pull(address _to, uint256 _amountDai, bool _refund) internal {
    require(_to != address(0) && _amountDai > 0, "invalid parameter(s)");

    uint256 errorCode = (_amountDai > dai.balanceOf(address(this))) ? moneyMarket.withdraw(DAI_ADDRESS, _amountDai.sub(dai.balanceOf(address(this)))) : 0;
    require(address(this).balance == 0, "withdraw failed");	//inject FORCED TO RECEIVE ETHERS

    if (_refund) {
      deposits[_to] = deposits[_to].sub(_amountDai);
      deposited = deposited.sub(_amountDai);
    } else {
      pulls[_to] = pulls[_to].add(_amountDai);
      pulled = pulled.add(_amountDai);
    }

    dai.safeTransfer(_to, _amountDai);
    emit Pulled(_to, _amountDai);
  }
}

/**
 * @title DividendDistributingToken
 * @dev An ERC20-compliant token that distributes any Dai it receives to its token holders proportionate to their share.
 *
 * Implementation based on: https://blog.pennyether.com/posts/realtime-dividend-token.html#the-token
 *
 * The user is responsible for when they transact tokens (transacting before a dividend payout is probably not ideal).
 *
 * `TokenizedProperty` inherits from `this` and is the front-facing contract representing the rights / ownership to a property.
 *
 * NOTE: if the owner(s) of a `TokenizedProperty` wish to update `LoanEscrow` behavior (i.e. changing the ERC20 token funds are raised in, or changing loan behavior),
 * some options are: (a) `untokenize` and re-deploy the updated `TokenizedProperty`, or (b) deploy an independent contract acting as the updated dividend distribution vehicle.
 */
contract DividendDistributingToken is ERC20, LoanEscrow {
  using SafeMath for uint256;

  uint256 public constant POINTS_PER_DAI = uint256(10) ** 32;

  uint256 public pointsPerToken = 0;
  mapping(address => uint256) public credits;
  mapping(address => uint256) public lastPointsPerToken;

  event DividendsCollected(address indexed collector, uint256 amount);
  event DividendsDeposited(address indexed depositor, uint256 amount);

  function collectOwedDividends() public {
    creditAccount(msg.sender);

    uint256 _dai = credits[msg.sender].div(POINTS_PER_DAI);
    credits[msg.sender] = 0;

    pull(msg.sender, _dai, false);
    emit DividendsCollected(msg.sender, _dai);
  }

  function depositDividends() public {  // dividends
    uint256 amount = dai.allowance(msg.sender, address(this));

    uint256 fee = amount.div(100);
    dai.safeTransferFrom(msg.sender, blockimmo(), fee);

    deposit(msg.sender, amount.sub(fee));

    // partially tokenized properties store the "non-tokenized" part in `this` contract, dividends not disrupted
    uint256 issued = totalSupply().sub(unissued());
    pointsPerToken = pointsPerToken.add(amount.sub(fee).mul(POINTS_PER_DAI).div(issued));

    emit DividendsDeposited(msg.sender, amount);
  }

  function unissued() public view returns (uint256) {
    return balanceOf(address(this));
  }

  function creditAccount(address _account) internal {
    uint256 amount = balanceOf(_account).mul(pointsPerToken.sub(lastPointsPerToken[_account]));
    credits[_account] = credits[_account].add(amount);
    lastPointsPerToken[_account] = pointsPerToken;
  }
}

contract LandRegistryInterface {
  function getProperty(string memory _eGrid) public view returns (address property);
}

contract LandRegistryProxyInterface {
  function owner() public view returns (address);
  function landRegistry() public view returns (LandRegistryInterface);
}

contract WhitelistInterface {
  function checkRole(address _operator, string memory _permission) public view;
}

contract WhitelistProxyInterface {
  function whitelist() public view returns (WhitelistInterface);
}

/**
 * @title TokenizedProperty
 * @dev An asset-backed security token (a property as identified by its E-GRID (a UUID) in the (Swiss) land registry).
 *
 * Ownership of `this` must be transferred to `ShareholderDAO` before blockimmo will verify `this` as legitimate in `LandRegistry`.
 * Until verified legitimate, transferring tokens is not possible (locked).
 *
 * Tokens can be freely listed on exchanges (especially decentralized / 0x).
 *
 * `this.owner` can make two suggestions that blockimmo will always (try) to take: `setManagementCompany` and `untokenize`.
 * `this.owner` can also transfer or rescind ownership.
 * See `ShareholderDAO` documentation for more information...
 *
 * Our legal framework requires a `TokenizedProperty` must be possible to `untokenize`.
 * Un-tokenizing is also the first step to upgrading or an outright sale of `this`.
 *
 * For both:
 *   1. `owner` emits an `UntokenizeRequest`
 *   2. blockimmo removes `this` from the `LandRegistry`
 *
 * Upgrading:
 *   3. blockimmo migrates `this` to the new `TokenizedProperty` (ie perfectly preserving `this.balances`)
 *   4. blockimmo attaches `owner` to the property (1)
 *   5. blockimmo adds the property to `LandRegistry`
 *
 * Outright sale:
 *   3. blockimmo deploys a new `TokenizedProperty` and adds it to the `LandRegistry`
 *   4. blockimmo configures and deploys a `TokenSale` for the property with `TokenSale.wallet == address(this)`
 *      (raised Ether distributed to current token holders as a dividend payout)
 *        - if the sale is unsuccessful, the new property is removed from the `LandRegistry`, and `this` is added back
 */
contract TokenizedProperty is DividendDistributingToken, ERC20Detailed, Ownable {
  address public constant LAND_REGISTRY_PROXY_ADDRESS = 0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56;  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
  address public constant WHITELIST_PROXY_ADDRESS = 0x7223b032180CDb06Be7a3D634B1E10032111F367;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;

  LandRegistryProxyInterface public registryProxy = LandRegistryProxyInterface(LAND_REGISTRY_PROXY_ADDRESS);
  WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);

  uint256 public constant NUM_TOKENS = 1000000;

  mapping(address => uint256) public lastTransferBlock;
  mapping(address => uint256) public minTransferAccepted;

  event MinTransferSet(address indexed account, uint256 minTransfer);
  event ProposalEmitted(bytes32 indexed hash, string message);

  modifier isValid() {
    LandRegistryInterface registry = LandRegistryInterface(registryProxy.landRegistry());
    require(registry.getProperty(name()) == address(this), "invalid TokenizedProperty");
    _;
  }

  modifier onlyBlockimmo() {
    require(msg.sender == blockimmo(), "onlyBlockimmo");
    _;
  }

  constructor(string memory _eGrid, string memory _grundstuck) public ERC20Detailed(_eGrid, _grundstuck, 18) {
    uint256 totalSupply = NUM_TOKENS * (uint256(10) ** decimals());
    _mint(msg.sender, totalSupply);

    _approve(address(this), blockimmo(), ~uint256(0));  // enable blockimmo to issue `unissued` tokens in the future
  }

  function blockimmo() public view returns (address) {
    return registryProxy.owner();
  }

  function burn(uint256 _value) public isValid {  // buyback
    _burn(msg.sender, _value);
  }

  function mint(address _to, uint256 _value) public isValid onlyBlockimmo returns (bool) {  // equity dilution
    _mint(_to, _value);
    return true;
  }

  function emitProposal(bytes32 _hash, string memory _message) public isValid onlyOwner {
    emit ProposalEmitted(_hash, _message);
  }

  function setMinTransfer(uint256 _amount) public isValid {
    minTransferAccepted[msg.sender] = _amount;
    emit MinTransferSet(msg.sender, _amount);
  }

  function transfer(address _to, uint256 _value) public isValid returns (bool) {
    require(_value >= minTransferAccepted[_to], "_value must exceed _to's minTransferAccepted");
    transferBookKeeping(msg.sender, _to);
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public isValid returns (bool) {
    transferBookKeeping(_from, _to);
    return super.transferFrom(_from, _to, _value);
  }

  function transferBookKeeping(address _from, address _to) internal {
    whitelistProxy.whitelist().checkRole(_to, "authorized");

    creditAccount(_from);  // required for dividends...
    creditAccount(_to);

    lastTransferBlock[_from] = block.number;  // required for voting...
    lastTransferBlock[_to] = block.number;
  }
}