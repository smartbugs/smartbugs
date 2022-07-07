/**
 *Submitted for verification at Etherscan.io on 2020-07-04
*/

/**
 *Submitted for verification at Etherscan.io on 2019-10-06
*/

pragma solidity 0.5.7;
// produced by the Solididy File Flattener (c) David Appleton 2018
// contact : dave@akomba.com
// released under Apache 2.0 licence
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
        //require(c >= a, "SafeMath: addition overflow");

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
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        //require(b <= a, errorMessage);
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
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
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
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _nominatedOwner;

    event NewOwnerNominated(address indexed previousOwner, address indexed nominee);
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
     * @dev Returns the address of the current nominated owner.
     */
    function nominatedOwner() external view returns (address) {
        return _nominatedOwner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        require(_msgSender() == _owner, "caller is not owner");
    }

    /**
     * @dev Nominates a new owner `newOwner`.
     * Requires a follow-up `acceptOwnership`.
     * Can only be called by the current owner.
     */
    function nominateNewOwner(address newOwner) external onlyOwner {
        require(newOwner != address(0), "new owner is 0 address");
        emit NewOwnerNominated(_owner, newOwner);
        _nominatedOwner = newOwner;
    }

    /**
     * @dev Accepts ownership of the contract.
     */
    function acceptOwnership() external {
        require(_nominatedOwner == _msgSender(), "unauthorized");
        emit OwnershipTransferred(_owner, _nominatedOwner);
        _owner = _nominatedOwner;
    }

    /** Set `_owner` to the 0 address.
     * Only do this to deliberately lock in the current permissions.
     *
     * THIS CANNOT BE UNDONE! Call this only if you know what you're doing and why you're doing it!
     */
    function renounceOwnership(string calldata declaration) external onlyOwner {
        string memory requiredDeclaration = "I hereby renounce ownership of this contract forever.";
        require(
            keccak256(abi.encodePacked(declaration)) ==
            keccak256(abi.encodePacked(requiredDeclaration)),
            "declaration incorrect");

        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

contract ReserveEternalStorage is Ownable {

    using SafeMath for uint256;


    // ===== auth =====

    address public reserveAddress;

    event ReserveAddressTransferred(
        address indexed oldReserveAddress,
        address indexed newReserveAddress
    );

    /// On construction, set auth fields.
    constructor() public {
        reserveAddress = _msgSender();
        emit ReserveAddressTransferred(address(0), reserveAddress);
    }

    /// Only run modified function if sent by `reserveAddress`.
    modifier onlyReserveAddress() {
        require(_msgSender() == reserveAddress, "onlyReserveAddress");
        _;
    }

    /// Set `reserveAddress`.
    function updateReserveAddress(address newReserveAddress) external {
        require(newReserveAddress != address(0), "zero address");
        require(_msgSender() == reserveAddress || _msgSender() == owner(), "not authorized");
        emit ReserveAddressTransferred(reserveAddress, newReserveAddress);
        reserveAddress = newReserveAddress;
    }



    // ===== balance =====

    mapping(address => uint256) public balance;

    /// Add `value` to `balance[key]`, unless this causes integer overflow.
    ///
    /// @dev This is a slight divergence from the strict Eternal Storage pattern, but it reduces
    /// the gas for the by-far most common token usage, it's a *very simple* divergence, and
    /// `setBalance` is available anyway.
    function addBalance(address key, uint256 value) external onlyReserveAddress {
        balance[key] = balance[key].add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    }

    /// Subtract `value` from `balance[key]`, unless this causes integer underflow.
    function subBalance(address key, uint256 value) external onlyReserveAddress {
        balance[key] = balance[key].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    }

    /// Set `balance[key]` to `value`.
    function setBalance(address key, uint256 value) external onlyReserveAddress {
        balance[key] = value;
    }



    // ===== allowed =====

    mapping(address => mapping(address => uint256)) public allowed;

    /// Set `to`'s allowance of `from`'s tokens to `value`.
    function setAllowed(address from, address to, uint256 value) external onlyReserveAddress {
        allowed[from][to] = value;
    }
}

interface ITXFee {
     function calculateFee(address from, address to, uint256 amount) external returns (uint256);
}
/**
 * @title The Reserve Token
 * @dev An ERC-20 token with minting, burning, pausing, and user freezing.
 * Based on OpenZeppelin's [implementation](https://github.com/OpenZeppelin/openzeppelin-solidity/blob/41aa39afbc13f0585634061701c883fe512a5469/contracts/token/ERC20/ERC20.sol).
 *
 * Non-constant-sized data is held in ReserveEternalStorage, to facilitate potential future upgrades.
 */
contract Reserve is IERC20, Ownable {
    using SafeMath for uint256;


    // ==== State ====


    // Non-constant-sized data
    ReserveEternalStorage internal trustedData;

    // TX Fee helper contract
    ITXFee public trustedTxFee;

    // Relayer
    address public trustedRelayer;

    // Basic token data
    uint256 public totalSupply;
    uint256 public maxSupply;

    // Paused data
    bool public paused;

    // Auth roles
    address public minter;
    address public pauser;
    address public feeRecipient;


    // ==== Events, Constants, and Constructor ====


    // Auth role change events
    event MinterChanged(address indexed newMinter);
    event PauserChanged(address indexed newPauser);
    event FeeRecipientChanged(address indexed newFeeRecipient);
    event MaxSupplyChanged(uint256 indexed newMaxSupply);
    event EternalStorageTransferred(address indexed newReserveAddress);
    event TxFeeHelperChanged(address indexed newTxFeeHelper);
    event TrustedRelayerChanged(address indexed newTrustedRelayer);

    // Pause events
    event Paused(address indexed account);
    event Unpaused(address indexed account);

    // Basic information as constants
    string public constant name = "Reserve";
    string public constant symbol = "RSV";
    uint8 public constant decimals = 18;

    /// Initialize critical fields.
    constructor(address eternalStorageAddr) public {
        pauser = msg.sender;
        feeRecipient = msg.sender;
        // minter defaults to the zero address.

        maxSupply = 2 ** 256 - 1;
        paused = true;

        trustedTxFee = ITXFee(address(0));
        trustedRelayer = address(0);
        if (eternalStorageAddr == address(0)) {
            trustedData = new ReserveEternalStorage();
            trustedData.nominateNewOwner(msg.sender);
        } else {
            trustedData = ReserveEternalStorage(eternalStorageAddr);
        }
    }

    /// Accessor for eternal storage contract address.
    function getEternalStorageAddress() external view returns(address) {
        return address(trustedData);
    }


    // ==== Admin functions ====


    /// Modifies a function to only run if sent by `role`.
    modifier only(address role) {
        require(msg.sender == role, "unauthorized: not role holder");
        _;
    }

    /// Modifies a function to only run if sent by `role` or the contract's `owner`.
    modifier onlyOwnerOr(address role) {
        require(msg.sender == owner() || msg.sender == role, "unauthorized: not owner or role");
        _;
    }

    /// Change who holds the `minter` role.
    function changeMinter(address newMinter) external onlyOwnerOr(minter) {
        minter = newMinter;
        emit MinterChanged(newMinter);
    }

    /// Change who holds the `pauser` role.
    function changePauser(address newPauser) external onlyOwnerOr(pauser) {
        pauser = newPauser;
        emit PauserChanged(newPauser);
    }

    function changeFeeRecipient(address newFeeRecipient) external onlyOwnerOr(feeRecipient) {
        feeRecipient = newFeeRecipient;
        emit FeeRecipientChanged(newFeeRecipient);
    }

    /// Make a different address the EternalStorage contract's reserveAddress.
    /// This will break this contract, so only do it if you're
    /// abandoning this contract, e.g., for an upgrade.
    function transferEternalStorage(address newReserveAddress) external onlyOwner isPaused {
        require(newReserveAddress != address(0), "zero address");
        emit EternalStorageTransferred(newReserveAddress);
        trustedData.updateReserveAddress(newReserveAddress);
    }

    /// Change the contract that is able to do metatransactions.
    function changeRelayer(address newTrustedRelayer) external onlyOwner {
        trustedRelayer = newTrustedRelayer;
        emit TrustedRelayerChanged(newTrustedRelayer);
    }

    /// Change the contract that helps with transaction fee calculation.
    function changeTxFeeHelper(address newTrustedTxFee) external onlyOwner {
        trustedTxFee = ITXFee(newTrustedTxFee);
        emit TxFeeHelperChanged(newTrustedTxFee);
    }

    /// Change the maximum supply allowed.
    function changeMaxSupply(uint256 newMaxSupply) external onlyOwner {
        maxSupply = newMaxSupply;
        emit MaxSupplyChanged(newMaxSupply);
    }

    /// Pause the contract.
    function pause() external only(pauser) {
        paused = true;
        emit Paused(pauser);
    }

    /// Unpause the contract.
    function unpause() external only(pauser) {
        paused = false;
        emit Unpaused(pauser);
    }

    /// Modifies a function to run only when the contract is paused.
    modifier isPaused() {
        require(paused, "contract is not paused");
        _;
    }

    /// Modifies a function to run only when the contract is not paused.
    modifier notPaused() {
        require(!paused, "contract is paused");
        _;
    }


    // ==== Token transfers, allowances, minting, and burning ====


    /// @return how many attoRSV are held by `holder`.
    function balanceOf(address holder) external view returns (uint256) {
        return trustedData.balance(holder);
    }

    /// @return how many attoRSV `holder` has allowed `spender` to control.
    function allowance(address holder, address spender) external view returns (uint256) {
        return trustedData.allowed(holder, spender);
    }

    /// Transfer `value` attoRSV from `msg.sender` to `to`.
    function transfer(address to, uint256 value)
        external
        notPaused
        returns (bool)
    {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * Approve `spender` to spend `value` attotokens on behalf of `msg.sender`.
     *
     * Beware that changing a nonzero allowance with this method brings the risk that
     * someone may use both the old and the new allowance by unfortunate transaction ordering. One
     * way to mitigate this risk is to first reduce the spender's allowance
     * to 0, and then set the desired value afterwards, per
     * [this ERC-20 issue](https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729).
     *
     * A simpler workaround is to use `increaseAllowance` or `decreaseAllowance`, below.
     *
     * @param spender address The address which will spend the funds.
     * @param value uint256 How many attotokens to allow `spender` to spend.
     */
    function approve(address spender, uint256 value)
        external
        notPaused
        returns (bool)
    {
        _approve(msg.sender, spender, value);
        return true;
    }

    /// Transfer approved tokens from one address to another.
    /// @param from address The address to send tokens from.
    /// @param to address The address to send tokens to.
    /// @param value uint256 The number of attotokens to send.
    function transferFrom(address from, address to, uint256 value)
        external
        notPaused
        returns (bool)
    {
        _transfer(from, to, value);
        _approve(from, msg.sender, trustedData.allowed(from, msg.sender).sub(value));
        return true;
    }

    /// Increase `spender`'s allowance of the sender's tokens.
    /// @dev From MonolithDAO Token.sol
    /// @param spender The address which will spend the funds.
    /// @param addedValue How many attotokens to increase the allowance by.
    function increaseAllowance(address spender, uint256 addedValue)
        external
        notPaused
        returns (bool)
    {
        _approve(msg.sender, spender, trustedData.allowed(msg.sender, spender).add(addedValue));
        return true;
    }

    /// Decrease `spender`'s allowance of the sender's tokens.
    /// @dev From MonolithDAO Token.sol
    /// @param spender The address which will spend the funds.
    /// @param subtractedValue How many attotokens to decrease the allowance by.
    function decreaseAllowance(address spender, uint256 subtractedValue)
        external
        notPaused
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            trustedData.allowed(msg.sender, spender).sub(subtractedValue)
        );
        return true;
    }

    /// Mint `value` new attotokens to `account`.
    function mint(address account, uint256 value)
        external
        notPaused
        only(minter)
    {
        require(account != address(0), "can't mint to address zero");

        totalSupply = totalSupply.add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        require(totalSupply < maxSupply, "max supply exceeded");
        trustedData.addBalance(account, value);
        emit Transfer(address(0), account, value);
    }

    /// Burn `value` attotokens from `account`, if sender has that much allowance from `account`.
    function burnFrom(address account, uint256 value)
        external
        notPaused
        only(minter)
    {
        _burn(account, value);
        _approve(account, msg.sender, trustedData.allowed(account, msg.sender).sub(value));
    }

    // ==== Relay functions === //
    
    /// Transfer `value` attotokens from `from` to `to`.
    /// Callable only by the relay contract.
    function relayTransfer(address from, address to, uint256 value) 
        external 
        notPaused
        only(trustedRelayer)
        returns (bool)
    {
        _transfer(from, to, value);
        return true;
    }

    /// Approve `value` attotokens to be spent by `spender` from `holder`.
    /// Callable only by the relay contract.
    function relayApprove(address holder, address spender, uint256 value) 
        external 
        notPaused
        only(trustedRelayer)
        returns (bool)
    {
        _approve(holder, spender, value);
        return true;
    }

    /// `spender` transfers `value` attotokens from `holder` to `to`.
    /// Requires allowance.
    /// Callable only by the relay contract.
    function relayTransferFrom(address holder, address spender, address to, uint256 value) 
        external 
        notPaused
        only(trustedRelayer)
        returns (bool)
    {
        _transfer(holder, to, value);
        _approve(holder, spender, trustedData.allowed(holder, spender).sub(value));
        return true;
    }

    /// @dev Transfer of `value` attotokens from `from` to `to`.
    /// Internal; doesn't check permissions.
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0), "can't transfer to address zero");
        trustedData.subBalance(from, value);
        uint256 fee = 0;

        if (address(trustedTxFee) != address(0)) {
            fee = trustedTxFee.calculateFee(from, to, value);
            require(fee <= value, "transaction fee out of bounds");

            trustedData.addBalance(feeRecipient, fee);
            emit Transfer(from, feeRecipient, fee);
        }

        trustedData.addBalance(to, value.sub(fee));
        emit Transfer(from, to, value.sub(fee));
    }

    /// @dev Burn `value` attotokens from `account`.
    /// Internal; doesn't check permissions.
    function _burn(address account, uint256 value) internal {
        require(account != address(0), "can't burn from address zero");

        totalSupply = totalSupply.sub(value);
        trustedData.subBalance(account, value);
        emit Transfer(account, address(0), value);
    }

    /// @dev Set `spender`'s allowance on `holder`'s tokens to `value` attotokens.
    /// Internal; doesn't check permissions.
    function _approve(address holder, address spender, uint256 value) internal {
        require(spender != address(0), "spender cannot be address zero");
        require(holder != address(0), "holder cannot be address zero");

        trustedData.setAllowed(holder, spender, value);
        emit Approval(holder, spender, value);
    }
}