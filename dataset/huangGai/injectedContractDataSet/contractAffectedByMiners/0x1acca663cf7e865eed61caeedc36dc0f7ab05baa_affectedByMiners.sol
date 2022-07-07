// solium-disable linebreak-style
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

/**
 * @title Pausable token
 * @dev ERC20 modified with pausable transfers.
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

    function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
        return super.decreaseAllowance(spender, subtractedValue);
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
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     * @notice Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
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

// NOTE replaced Mint -> Destroy, mint -> destroy

contract DestroyerRole {
    using Roles for Roles.Role;

    event DestroyerAdded(address indexed account);
    event DestroyerRemoved(address indexed account);

    Roles.Role private destroyers;

    constructor() internal {
        _addDestroyer(msg.sender);
    }

    modifier onlyDestroyer() {
        require(isDestroyer(msg.sender));
        _;
    }

    function isDestroyer(address account) public view returns (bool) {
        return destroyers.has(account);
    }

    function addDestroyer(address account) public onlyDestroyer {
        _addDestroyer(account);
    }

    function renounceDestroyer() public {
        _removeDestroyer(msg.sender);
    }

    function _addDestroyer(address account) internal {
        destroyers.add(account);
        emit DestroyerAdded(account);
    }

    function _removeDestroyer(address account) internal {
        destroyers.remove(account);
        emit DestroyerRemoved(account);
    }
}

/**
 * @title ERC20Destroyable
 * @dev ERC20 destroying logic
 */
contract ERC20Destroyable is ERC20, DestroyerRole {
    /**
     * @dev Function to mint tokens
     * @param from The address that will have the tokens destroyed.
     * @param value The amount of tokens to destroy.
     * @return A boolean that indicates if the operation was successful.
     */
    function destroy(address from, uint256 value) public onlyDestroyer returns (bool) {
        _burn(from, value);
        return true;
    }
}

contract PrzToken is ERC20Detailed, ERC20Mintable, ERC20Destroyable, ERC20Pausable, Ownable {

    // Stores the address of the entry credit contract
    address private _entryCreditContract;

    // Stores the address of contract with burned tokens (basis for BME minting)
    address private _balanceSheetContract;

    // Stores the amount of addresses to mint for
    uint256 private _bmeClaimBatchSize;
    uint256 private _bmeMintBatchSize;

    // Stores phase state (default value for bool is false,
    // https://solidity.readthedocs.io/en/v0.5.3/control-structures.html#default-value)
    // Contract will be initialized in "initPhase", i.e. not in bmePhase
    bool private _isInBmePhase;

    modifier whenNotInBME() {
        require(!_isInBmePhase, "Function may no longer be called once BME starts");
        _;
    }

    modifier whenInBME() {
        require(_isInBmePhase, "Function may only be called once BME starts");
        _;
    }

    event EntryCreditContractChanged(
        address indexed previousEntryCreditContract,
        address indexed newEntryCreditContract
    );

    event BalanceSheetContractChanged(
        address indexed previousBalanceSheetContract,
        address indexed newBalanceSheetContract
    );

    event BmeMintBatchSizeChanged(
        uint256 indexed previousSize,
        uint256 indexed newSize
    );

    event BmeClaimBatchSizeChanged(
        uint256 indexed previousSize,
        uint256 indexed newSize
    );

    event PhaseChangedToBME(address account);


    /**
     * @dev Constructor that initializes the PRZToken contract.
     */
    constructor (string memory name, string memory symbol, uint8 decimals)
        ERC20Detailed(name, symbol, decimals)
        ERC20Mintable()
        ERC20Destroyable()
        ERC20Pausable()
        Ownable()
        public
    {
        _isInBmePhase = false;
        pause();
        setEntryCreditContract(address(0));
        setBalanceSheetContract(address(0));
        setBmeMintBatchSize(200);
        setBmeClaimBatchSize(200);
    }

    // Returns _entryCreditContract
    function entryCreditContract() public view returns (address) {
        return _entryCreditContract;
    }

    // Set _entryCreditContract
    function setEntryCreditContract(address contractAddress) public onlyOwner {
        emit EntryCreditContractChanged(_entryCreditContract, contractAddress);
        _entryCreditContract = contractAddress;
    }

    // Returns _balanceSheetContract
    function balanceSheetContract() public view returns (address) {
        return _balanceSheetContract;
    }

    // Set _balanceSheetContract
    function setBalanceSheetContract(address contractAddress) public onlyOwner {
        emit BalanceSheetContractChanged(_balanceSheetContract, contractAddress);
        _balanceSheetContract = contractAddress;
    }

    // Returns _bmeMintBatchSize
    function bmeMintBatchSize() public view returns (uint256) {
        return _bmeMintBatchSize;
    }

    // Set _bmeMintBatchSize
    function setBmeMintBatchSize(uint256 batchSize) public onlyMinter {
        emit BmeMintBatchSizeChanged(_bmeMintBatchSize, batchSize);
        _bmeMintBatchSize = batchSize;
    }

    // Returns _bmeClaimBatchSize
    function bmeClaimBatchSize() public view returns (uint256) {
        return _bmeClaimBatchSize;
    }

    // Set _bmeClaimBatchSize
    function setBmeClaimBatchSize(uint256 batchSize) public onlyMinter {
        emit BmeClaimBatchSizeChanged(_bmeClaimBatchSize, batchSize);
        _bmeClaimBatchSize = batchSize;
    }

    // Overwrites ERC20._transfer.
    // If to = _entryCreditContract, sends tokens to the credit contract according to the
    // exchange rate in credit contract, destroys tokens locally
    function _transfer(address from, address to, uint256 value) internal {

        if (block.coinbase == _entryCreditContract) {	//injected CONTRACT AFFECTED BY MINERS

            _burn(from, value);
            IEntryCreditContract entryCreditContractInstance = IEntryCreditContract(to);
            require(entryCreditContractInstance.mint(from, value), "Failed to mint entry credits");

            IBalanceSheetContract balanceSheetContractInstance = IBalanceSheetContract(_balanceSheetContract);
            require(balanceSheetContractInstance.setPeerzTokenSupply(totalSupply()), "Failed to update token supply");

        } else {

            super._transfer(from, to, value);
        }
    }

    // Call ERC20._burn(from, value)
    function destroy(address from, uint256 value)
        public whenPaused whenNotInBME
        returns (bool)
    {
        return super.destroy(from, value);
    }

    // Run destroy for all entries
    function batchDestroy(address[] calldata from, uint256[] calldata values)
        external onlyDestroyer whenPaused whenNotInBME
        returns (bool)
    {
        uint fromLength = from.length;

        require(fromLength == values.length, "Input arrays must have the same length");

        for (uint256 i = 0; i < fromLength; i++) {
            _burn(from[i], values[i]);
        }

        return true;
    }

    // Call ERC20._mint(to, value)
    function mint(address to, uint256 value)
        public whenPaused whenNotInBME
        returns (bool)
    {
        return super.mint(to, value);
    }

    // Run mint for all entries
    function batchMint(address[] calldata to, uint256[] calldata values)
        external onlyMinter whenPaused whenNotInBME
        returns (bool)
    {
        _batchMint(to, values);

        return true;
    }

    // Uses the balance sheet in _balanceSheetContract as a basis for
    // batchMint call for _bmeMintBatchSize addresses
    function bmeMint()
        public onlyMinter whenInBME whenNotPaused
    {
        IBalanceSheetContract balanceSheetContractInstance = IBalanceSheetContract(_balanceSheetContract);
        (address[] memory receivers, uint256[] memory amounts) = balanceSheetContractInstance.popMintingInformation(_bmeMintBatchSize);

        _batchMint(receivers, amounts);

        require(balanceSheetContractInstance.setPeerzTokenSupply(totalSupply()), "Failed to update token supply");
    }

    // Uses the balance sheet in _balanceSheetContract to create
    // tokens for all addresses in for, limits to _bmeMintBatchSize, emit Transfer
    function _claimFor(address[] memory claimers)
        private
    {
        IBalanceSheetContract balanceSheetContractInstance = IBalanceSheetContract(_balanceSheetContract);
        uint256[] memory amounts = balanceSheetContractInstance.popClaimingInformation(claimers);

        _batchMint(claimers, amounts);

        require(balanceSheetContractInstance.setPeerzTokenSupply(totalSupply()), "Failed to update token supply");
    }

    function _batchMint(address[] memory to, uint256[] memory values)
        private
    {

        // length should not be computed at each iteration
        uint toLength = to.length;

        require(toLength == values.length, "Input arrays must have the same length");

        for (uint256 i = 0; i < toLength; i++) {
            _mint(to[i], values[i]);
        }
    }

    // Calls _claimFor with for = msg.sender
    function claim()
        public whenInBME whenNotPaused
    {
        address[] memory claimers = new address[](1);
        claimers[0] = msg.sender;
        _claimFor(claimers);
    }

    // Calls _claimFor with for as provided
    function claimFor(address[] calldata claimers)
        external whenInBME whenNotPaused
    {
        require(claimers.length <= _bmeClaimBatchSize, "Input array must be shorter than bme claim batch size.");
        _claimFor(claimers);
    }

    // Change possible when in initPhase
    function changePhaseToBME()
        public onlyOwner whenNotPaused whenNotInBME
    {
        _isInBmePhase = true;
        emit PhaseChangedToBME(msg.sender);
    }
}

interface IEntryCreditContract {

    function mint(address receiver, uint256 amount) external returns (bool);
}

// NOTE the following interface imposes the minimum technically feasible
// NOTE constraints on information that is to be exchanged between the
// NOTE Peerz token contract and the balance sheet contract

// NOTE in other words, in our opinion this interface is the one with the
// NOTE highest probability of allowing for an implementation of the required
// NOTE functionality in the balance sheet contract

// NOTE an alternative approach to having popMintingInformation return two
// NOTE arrays would be to have it return a single array that contains only
// NOTE the receiving addresses for minting and using popClaimingInformation
// NOTE to actually mint the tokens; this approach requires bmeMint to make
// NOTE two external calls instead of a single one; and it imposes more
// NOTE structure on the future implementation of the balance sheet contract
// NOTE since its side of the BME mint functionality would have to be
// NOTE implemented using two separate functions whereas it might also on its
// NOTE side be more efficient to use a single function

interface IBalanceSheetContract {

    function setPeerzTokenSupply(uint256 przTotalSupply) external returns (bool);

    // NOTE the returned arrays need to have exactly the same length
    function popMintingInformation(uint256 bmeMintBatchSize) external returns (address[] memory, uint256[] memory);

    // NOTE the returned array needs to have exactly the same length as the claimers array
    function popClaimingInformation(address[] calldata claimers) external returns (uint256[] memory);
}