/**
 *Submitted for verification at Etherscan.io on 2019-12-16
*/

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.10;

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
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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

// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
 * available, which can be aplied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
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
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

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
        return _owner;
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
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
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

// File: openzeppelin-solidity/contracts/utils/Address.sol

pragma solidity ^0.5.0;

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

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

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

// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.0;




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

// File: contracts/IGST2.sol

pragma solidity 0.5.10;

interface IGST2 {

    function freeUpTo(uint256 value) external returns (uint256 freed);

    function balanceOf(address who) external view returns (uint256);

    function mint(uint256 value) external;
}

// File: contracts/TokenTransferProxy.sol

pragma solidity 0.5.10;





/**
* @dev Allows owner of the contract to transfer tokens on behalf of user.
* User will need to approve this contract to spend tokens on his/her behalf
* on Paraswap platform
*/
contract TokenTransferProxy is Ownable {
    using SafeERC20 for IERC20;

    /**
    * @dev Allows owner of the contract to transfer tokens on user's behalf
    * @dev Swapper contract will be the owner of this contract
    * @param token Address of the token
    * @param from Address from which tokens will be transferred
    * @param to Receipent address of the tokens
    * @param amount Amount of tokens to transfer
    */
    function transferFrom(
        address token,
        address from,
        address to,
        uint256 amount
    )
        public	//inject PUBLIC FUNC TO EXTERNAL
        onlyOwner
    {
        IERC20(token).safeTransferFrom(from, to, amount);
    }

}

// File: contracts/IWETH.sol

pragma solidity 0.5.10;



contract IWETH is IERC20 {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}

// File: contracts/AugustusSwapper.sol

pragma solidity 0.5.10;










/**
* @dev The contract will allow swap of one token for another across multiple exchanges in one atomic transaction
* Kyber, Uniswap and Bancor are supported in phase-01
*/
contract AugustusSwapper is ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    using Address for address;

    //Ether token address used when to or from in swap is Ether
    address constant private ETH_ADDRESS = address(
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
    );

    //External call is allowed to whitelisted addresses only.
    //Contract address of all supported exchanges must be put in whitelist
    mapping(address => bool) private _whitelisteds;

    //for 2% enter 200. For 0.2% enter 20. Supports upto 2 decimal places
    uint256 private _fee;

    address payable private _feeWallet;

    IGST2 private _gasToken;

    bool private _paused;

    TokenTransferProxy private _tokenTransferProxy;

    event WhitelistAdded(address indexed account);
    event WhitelistRemoved(address indexed account);
    event Swapped(
        address indexed user,
        address indexed srcToken,
        address indexed destToken,
        uint256 srcAmount,
        uint256 receivedAmount,
        string referrer
    );

    event Payed(
        address indexed to,
        address indexed srcToken,
        address indexed destToken,
        uint256 srcAmount,
        uint256 receivedAmount,
        string referrer
    );
    event Paused();
    event Unpaused();

    modifier onlySelf() {
        require(
            msg.sender == address(this),
            "AugustusSwapper: Invalid access!!"
        );
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
    * @dev Constructor
    * It will whitelist the contarct itself
    */
    constructor(address payable feeWallet, address gasToken) public {
        require(feeWallet != address(0), "Invalid address!!");
        require(gasToken != address(0), "Invalid gas token!!");

        _feeWallet = feeWallet;
        _gasToken = IGST2(gasToken);

        _whitelisteds[address(this)] = true;
        _tokenTransferProxy = new TokenTransferProxy();

        emit WhitelistAdded(address(this));
    }

    /**
    * @dev Fallback method to allow exchanges to transfer back ethers for a particular swap
    * It will only allow contracts to send funds to it
    */
    function() external payable whenNotPaused {
        address account = msg.sender;
        require(
            account.isContract(),
            "Sender is not a contract"
        );
    }

    /**
    * @dev Returns address of TokenTransferProxy Contract
    */
    function getTokenTransferProxy() public view returns (address) {	//inject PUBLIC FUNC TO EXTERNAL
        return address(_tokenTransferProxy);
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {	//inject PUBLIC FUNC TO EXTERNAL
        return _paused;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyOwner whenNotPaused {	//inject PUBLIC FUNC TO EXTERNAL
        _paused = true;
        emit Paused();
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyOwner whenPaused {	//inject PUBLIC FUNC TO EXTERNAL
        _paused = false;
        emit Unpaused();
    }

    /**
    * @dev Allows owner to change fee wallet
    * @param feeWallet Address of the new fee wallet
    */
    function changeFeeWallet(address payable feeWallet) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        _feeWallet = feeWallet;
    }

    /**
    * @dev Returns the fee wallet address
    */
    function getFeeWallet() public view returns (address) {	//inject PUBLIC FUNC TO EXTERNAL
        return _feeWallet;
    }

    /**
    * @dev Allows owner to change fee
    * @param fee New fee percentage
    */
    function changeFee(uint256 fee) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        _fee = fee;
    }

    /**
    * @dev returns the current fee percentage
    */
    function getFee() public view returns (uint256) {	//inject PUBLIC FUNC TO EXTERNAL
        return _fee;
    }

    /**
    * @dev Allows owner of the contract to whitelist an address
    * @param account Address of the account to be whitelisted
    */
    function addWhitelisted(address account) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        _whitelisteds[account] = true;
        emit WhitelistAdded(account);
    }

    /**
    * @dev Allows owner of the contract to remove address from a whitelist
    * @param account Address of the account the be removed
    */
    function removeWhitelistes(address account) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        _whitelisteds[account] = false;
        emit WhitelistRemoved(account);
    }

    /**
    * @dev Allows onwers of the contract to whitelist addresses in bulk
    * @param accounts An array of addresses to be whitelisted
    */
    function addWhitelistedBulk(
        address[] calldata accounts
    )
    external
    onlyOwner
    {
        for (uint256 i = 0; i < accounts.length; i++) {
            _whitelisteds[accounts[i]] = true;
            emit WhitelistAdded(accounts[i]);
        }
    }

    /**
    * @dev Allows this contract to make approve call for a token
    * This method is expected to be called using externalCall method.
    * @param token The address of the token
    * @param to The address of the spender
    * @param amount The amount to be approved
    */
    function approve(
        address token,
        address to,
        uint256 amount
    )
    public	//inject PUBLIC FUNC TO EXTERNAL
    onlySelf
    {
        require(amount > 0, "Amount should be greater than 0!!");
        //1. Check for valid whitelisted address
        require(
            isWhitelisted(to),
            "AugustusSwapper: Not a whitelisted address!!"
        );

        //2. Check for ETH address
        if (token != ETH_ADDRESS) {
            //3. Approve
            IERC20 _token = IERC20(token);
            _token.safeApprove(to, amount);
        }

    }

    /**
    * @dev Allows owner of the contract to transfer tokens any tokens which are assigned to the contract
    * This method is for saftey if by any chance tokens or ETHs are assigned to the contract by mistake
    * @dev token Address of the token to be transferred
    * @dev destination Recepient of the token
    * @dev amount Amount of tokens to be transferred
    */
    function ownerTransferTokens(
        address token,
        address payable destination,
        uint256 amount
    )
    public	//inject PUBLIC FUNC TO EXTERNAL
    onlyOwner
    {
        transferTokens(token, destination, amount);
    }

    /**
    * @dev Allows owner of the contract to mint more gas tokens
    * @param amount Amount of gas tokens to mint
    */
    function mintGasTokens(uint256 amount) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        _gasToken.mint(amount);
    }

    /**
   * @dev This function sends the WETH returned during the exchange to the user.
   * @param token: The WETH Address
   */
    function withdrawAllWETH(IWETH token) public {	//inject PUBLIC FUNC TO EXTERNAL
        uint256 amount = token.balanceOf(address(this));
        token.withdraw(amount);
    }

    function pay(
        address payable receiver,
        address sourceToken,
        address destinationToken,
        uint256 sourceAmount,
        uint256 destinationAmount,
        address[] memory callees,
        bytes memory exchangeData,
        uint256[] memory startIndexes,
        uint256[] memory values,
        string memory referrer,
        uint256 mintPrice
    )
    public
    payable
    whenNotPaused
    nonReentrant
    {
        uint receivedAmount = performSwap(
            sourceToken,
            destinationToken,
            sourceAmount,
            destinationAmount,
            callees,
            exchangeData,
            startIndexes,
            values,
            mintPrice
        );

        address payable payer = msg.sender;

        transferTokens(destinationToken, receiver, destinationAmount);

        //Transfers the rest of destinationToken, if any, to the sender
        if (receivedAmount > destinationAmount) {
            uint rest = receivedAmount.sub(destinationAmount);

            transferTokens(destinationToken, payer, rest);
        }

        emit Payed(
            receiver,
            sourceToken,
            destinationToken,
            sourceAmount,
            receivedAmount,
            referrer
        );
    }

    /**
   * @dev The function which performs the actual swap.
   * The call data to the actual exchanges must be built offchain
   * and then sent to this method. It will be call those external exchanges using
   * data passed through externalCall function
   * It is a nonreentrant function
   * @param sourceToken Address of the source token
   * @param destinationToken Address of the destination token
   * @param sourceAmount Amount of source tokens to be swapped
   * @param minDestinationAmount Minimu destination token amount expected out of this swap
   * @param callees Address of the external callee. This will also contain address of exchanges
   * where actual swap will happen
   * @param exchangeData Concatenated data to be sent in external call to the above callees
   * @param startIndexes start index of calldata in above data structure for each callee
   * @param values Amount of ethers to be sent in external call to each callee
   * @param mintPrice Price of gas at the time of minting of gas tokens, if any. In wei
   */
    function swap(
        address sourceToken,
        address destinationToken,
        uint256 sourceAmount,
        uint256 minDestinationAmount,
        address[] memory callees,
        bytes memory exchangeData,
        uint256[] memory startIndexes,
        uint256[] memory values,
        string memory referrer,
        uint256 mintPrice
    )
    public
    payable
    whenNotPaused
    nonReentrant
    {
        uint receivedAmount = performSwap(
            sourceToken,
            destinationToken,
            sourceAmount,
            minDestinationAmount,
            callees,
            exchangeData,
            startIndexes,
            values,
            mintPrice
        );

        transferTokens(destinationToken, msg.sender, receivedAmount);

        emit Swapped(
            msg.sender,
            sourceToken,
            destinationToken,
            sourceAmount,
            receivedAmount,
            referrer
        );
    }

    function performSwap(
        address sourceToken,
        address destinationToken,
        uint256 sourceAmount,
        uint256 minDestinationAmount,
        address[] memory callees,
        bytes memory exchangeData,
        uint256[] memory startIndexes,
        uint256[] memory values,
        uint256 mintPrice
    )
    private
    returns (uint)
    {
        //Basic sanity check
        require(minDestinationAmount > 0, "minDestinationAmount is too low");
        require(callees.length > 0, "No callee provided!!");
        require(exchangeData.length > 0, "No exchangeData provided!!");
        require(
            callees.length + 1 == startIndexes.length,
            "Start indexes must be 1 greater then number of callees!!"
        );
        require(sourceToken != address(0), "Invalid source token!!");
        require(destinationToken != address(0), "Inavlid destination address");

        uint initialGas = gasleft();

        //If source token is not ETH than transfer required amount of tokens
        //from sender to this contract
        if (sourceToken != ETH_ADDRESS) {
            _tokenTransferProxy.transferFrom(
                sourceToken,
                msg.sender,
                address(this),
                sourceAmount
            );
        }

        for (uint256 i = 0; i < callees.length; i++) {

            require(isWhitelisted(callees[i]), "Callee is not whitelisted!!");
            require(
                callees[i] != address(_tokenTransferProxy),
                "Can not call TokenTransferProxy Contract !!"
            );

            bool result = externalCall(
                callees[i], //destination
                values[i], //value to send
                startIndexes[i], // start index of call data
                startIndexes[i + 1].sub(startIndexes[i]), // length of calldata
                exchangeData// total calldata
            );
            require(result, "External call failed!!");
        }

        uint256 receivedAmount = tokenBalance(destinationToken, address(this));

        require(
            receivedAmount >= minDestinationAmount,
            "Received amount of tokens are less then expected!!"
        );

        require(
            tokenBalance(sourceToken, address(this)) == 0,
            "The transaction wasn't entirely executed"
        );

        uint256 fee = calculateFee(
            sourceToken,
            receivedAmount,
            callees.length
        );

        if (fee > 0) {
            receivedAmount = receivedAmount.sub(fee);
            transferTokens(destinationToken, _feeWallet, fee);
        }

        if (mintPrice > 0) {
            refundGas(initialGas, mintPrice);
        }

        return receivedAmount;
    }

    /**
    * @dev Returns whether given addresses is whitelisted or not
    * @param account The account to be checked
    * @return bool
    */
    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisteds[account];
    }

    /**
    * @dev Helper method to refund gas using gas tokens
    */
    function refundGas(uint256 initialGas, uint256 mintPrice) private {

        uint256 mintBase = 32254;
        uint256 mintToken = 36543;
        uint256 freeBase = 14154;
        uint256 freeToken = 6870;
        uint256 reimburse = 24000;

        uint256 tokens = initialGas.sub(
            gasleft()).add(freeBase).div(reimburse.mul(2).sub(freeToken)
        );

        uint256 mintCost = mintBase.add(tokens.mul(mintToken));
        uint256 freeCost = freeBase.add(tokens.mul(freeToken));
        uint256 maxreimburse = tokens.mul(reimburse);

        uint256 efficiency = maxreimburse.mul(tx.gasprice).mul(100).div(
            mintCost.mul(mintPrice).add(freeCost.mul(tx.gasprice))
        );

        if (efficiency > 100) {
            freeGasTokens(tokens);
        }
    }

    /**
    * @dev Helper method to free gas tokens
    */
    function freeGasTokens(uint256 tokens) private {

        uint256 tokensToFree = tokens;
        uint256 safeNumTokens = 0;
        uint256 gas = gasleft();

        if (gas >= 27710) {
            safeNumTokens = gas.sub(27710).div(1148 + 5722 + 150);
        }

        if (tokensToFree > safeNumTokens) {
            tokensToFree = safeNumTokens;
        }

        uint256 gasTokenBal = _gasToken.balanceOf(address(this));

        if (tokensToFree > 0 && gasTokenBal >= tokensToFree) {
            _gasToken.freeUpTo(tokensToFree);
        }

    }

    /**
    * @dev Helper function to transfer tokens to the destination
    * @dev token Address of the token to be transferred
    * @dev destination Recepient of the token
    * @dev amount Amount of tokens to be transferred
    */
    function transferTokens(
        address token,
        address payable destination,
        uint256 amount
    )
    private
    {
        if (token == ETH_ADDRESS) {
            destination.transfer(amount);
        }
        else {
            IERC20(token).safeTransfer(destination, amount);
        }
    }

    /**
    * @dev Helper method to calculate fees
    * @param receivedAmount Received amount of tokens
    */
    function calculateFee(
        address sourceToken,
        uint256 receivedAmount,
        uint256 calleesLength
    )
    private
    view
    returns (uint256)
    {
        uint256 fee = 0;
        if (sourceToken == ETH_ADDRESS && calleesLength == 1) {
            return 0;
        }

        else if (sourceToken != ETH_ADDRESS && calleesLength == 2) {
            return 0;
        }

        if (_fee > 0) {
            fee = receivedAmount.mul(_fee).div(10000);
        }
        return fee;
    }

    /**
    * @dev Source take from GNOSIS MultiSigWallet
    * @dev https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
    */
    function externalCall(
        address destination,
        uint256 value,
        uint256 dataOffset,
        uint dataLength,
        bytes memory data
    )
    private
    returns (bool)
    {
        bool result = false;
        assembly {
            let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)

            let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
            result := call(
            sub(gas, 34710), // 34710 is the value that solidity is currently emitting
            // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
            // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
            destination,
            value,
            add(d, dataOffset),
            dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
            x,
            0                  // Output is ignored, therefore the output size is zero
            )
        }
        return result;
    }

    /**
    * @dev Helper function to returns balance of a user for a token
    * @param token Tokend address
    * @param account Account whose balances has to be returned
    */
    function tokenBalance(
        address token,
        address account
    )
    private
    view
    returns (uint256)
    {
        if (token == ETH_ADDRESS) {
            return account.balance;
        } else {
            return IERC20(token).balanceOf(account);
        }
    }
}