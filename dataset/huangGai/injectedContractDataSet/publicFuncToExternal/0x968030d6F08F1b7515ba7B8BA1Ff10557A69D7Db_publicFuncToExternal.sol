/**
 *Submitted for verification at Etherscan.io on 2020-05-28
*/

pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;


interface IPlatformIntegration {

    /**
     * @dev Deposit the given bAsset to Lending platform
     * @param _bAsset bAsset address
     * @param _amount Amount to deposit
     */
    function deposit(address _bAsset, uint256 _amount, bool isTokenFeeCharged)
        external returns (uint256 quantityDeposited);

    /**
     * @dev Withdraw given bAsset from Lending platform
     */
    function withdraw(address _receiver, address _bAsset, uint256 _amount, bool _isTokenFeeCharged) external;

    /**
     * @dev Returns the current balance of the given bAsset
     */
    function checkBalance(address _bAsset) external returns (uint256 balance);
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

contract InitializableModuleKeys {

    // Governance
    bytes32 internal KEY_GOVERNANCE;
    bytes32 internal KEY_STAKING;
    bytes32 internal KEY_PROXY_ADMIN;

    // mStable
    bytes32 internal KEY_ORACLE_HUB;
    bytes32 internal KEY_MANAGER;
    bytes32 internal KEY_RECOLLATERALISER;
    bytes32 internal KEY_META_TOKEN;
    bytes32 internal KEY_SAVINGS_MANAGER;

    /**
     * @dev Initialize function for upgradable proxy contracts. This function should be called
     *      via Proxy to initialize constants in the Proxy contract.
     */
    function _initialize() internal {
        // keccak256() values are evaluated only once at the time of this function call.
        // Hence, no need to assign hard-coded values to these variables.
        KEY_GOVERNANCE = keccak256("Governance");
        KEY_STAKING = keccak256("Staking");
        KEY_PROXY_ADMIN = keccak256("ProxyAdmin");

        KEY_ORACLE_HUB = keccak256("OracleHub");
        KEY_MANAGER = keccak256("Manager");
        KEY_RECOLLATERALISER = keccak256("Recollateraliser");
        KEY_META_TOKEN = keccak256("MetaToken");
        KEY_SAVINGS_MANAGER = keccak256("SavingsManager");
    }
}

interface INexus {
    function governor() external view returns (address);
    function getModule(bytes32 key) external view returns (address);

    function proposeModule(bytes32 _key, address _addr) external;
    function cancelProposedModule(bytes32 _key) external;
    function acceptProposedModule(bytes32 _key) external;
    function acceptProposedModules(bytes32[] calldata _keys) external;

    function requestLockModule(bytes32 _key) external;
    function cancelLockModule(bytes32 _key) external;
    function lockModule(bytes32 _key) external;
}

contract InitializableModule is InitializableModuleKeys {

    INexus public nexus;

    /**
     * @dev Modifier to allow function calls only from the Governor.
     */
    modifier onlyGovernor() {
        require(msg.sender == _governor(), "Only governor can execute");
        _;
    }

    /**
     * @dev Modifier to allow function calls only from the Governance.
     *      Governance is either Governor address or Governance address.
     */
    modifier onlyGovernance() {
        require(
            msg.sender == _governor() || msg.sender == _governance(),
            "Only governance can execute"
        );
        _;
    }

    /**
     * @dev Modifier to allow function calls only from the ProxyAdmin.
     */
    modifier onlyProxyAdmin() {
        require(
            msg.sender == _proxyAdmin(), "Only ProxyAdmin can execute"
        );
        _;
    }

    /**
     * @dev Modifier to allow function calls only from the Manager.
     */
    modifier onlyManager() {
        require(msg.sender == _manager(), "Only manager can execute");
        _;
    }

    /**
     * @dev Initialization function for upgradable proxy contracts
     * @param _nexus Nexus contract address
     */
    function _initialize(address _nexus) internal {
        require(_nexus != address(0), "Nexus address is zero");
        nexus = INexus(_nexus);
        InitializableModuleKeys._initialize();
    }

    /**
     * @dev Returns Governor address from the Nexus
     * @return Address of Governor Contract
     */
    function _governor() internal view returns (address) {
        return nexus.governor();
    }

    /**
     * @dev Returns Governance Module address from the Nexus
     * @return Address of the Governance (Phase 2)
     */
    function _governance() internal view returns (address) {
        return nexus.getModule(KEY_GOVERNANCE);
    }

    /**
     * @dev Return Staking Module address from the Nexus
     * @return Address of the Staking Module contract
     */
    function _staking() internal view returns (address) {
        return nexus.getModule(KEY_STAKING);
    }

    /**
     * @dev Return ProxyAdmin Module address from the Nexus
     * @return Address of the ProxyAdmin Module contract
     */
    function _proxyAdmin() internal view returns (address) {
        return nexus.getModule(KEY_PROXY_ADMIN);
    }

    /**
     * @dev Return MetaToken Module address from the Nexus
     * @return Address of the MetaToken Module contract
     */
    function _metaToken() internal view returns (address) {
        return nexus.getModule(KEY_META_TOKEN);
    }

    /**
     * @dev Return OracleHub Module address from the Nexus
     * @return Address of the OracleHub Module contract
     */
    function _oracleHub() internal view returns (address) {
        return nexus.getModule(KEY_ORACLE_HUB);
    }

    /**
     * @dev Return Manager Module address from the Nexus
     * @return Address of the Manager Module contract
     */
    function _manager() internal view returns (address) {
        return nexus.getModule(KEY_MANAGER);
    }

    /**
     * @dev Return SavingsManager Module address from the Nexus
     * @return Address of the SavingsManager Module contract
     */
    function _savingsManager() internal view returns (address) {
        return nexus.getModule(KEY_SAVINGS_MANAGER);
    }

    /**
     * @dev Return Recollateraliser Module address from the Nexus
     * @return  Address of the Recollateraliser Module contract (Phase 2)
     */
    function _recollateraliser() internal view returns (address) {
        return nexus.getModule(KEY_RECOLLATERALISER);
    }
}

contract InitializablePausableModule is InitializableModule {

    /**
     * @dev Emitted when the pause is triggered by Governor
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by Governor
     */
    event Unpaused(address account);

    bool private _paused = false;

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
     * @dev Initializes the contract in unpaused state.
     * Hooks into the Module to give the Governor ability to pause
     * @param _nexus Nexus contract address
     */
    function _initialize(address _nexus) internal {
        InitializableModule._initialize(_nexus);
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     * @return Returns `true` when paused, otherwise `false`
     */
    function paused() public view returns (bool) {	//inject PUBLIC FUNC TO EXTERNAL
        return _paused;
    }

    /**
     * @dev Called by the Governor to pause, triggers stopped state.
     */
    function pause() public onlyGovernor whenNotPaused {	//inject PUBLIC FUNC TO EXTERNAL
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Called by Governor to unpause, returns to normal state.
     */
    function unpause() public onlyGovernor whenPaused {	//inject PUBLIC FUNC TO EXTERNAL
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

interface MassetStructs {

    /** @dev Stores high level basket info */
    struct Basket {

        /** @dev Array of Bassets currently active */
        Basset[] bassets;

        /** @dev Max number of bAssets that can be present in any Basket */
        uint8 maxBassets;

        /** @dev Some bAsset is undergoing re-collateralisation */
        bool undergoingRecol;

        /**
         * @dev In the event that we do not raise enough funds from the auctioning of a failed Basset,
         * The Basket is deemed as failed, and is undercollateralised to a certain degree.
         * The collateralisation ratio is used to calc Masset burn rate.
         */
        bool failed;
        uint256 collateralisationRatio;

    }

    /** @dev Stores bAsset info. The struct takes 5 storage slots per Basset */
    struct Basset {

        /** @dev Address of the bAsset */
        address addr;

        /** @dev Status of the basset,  */
        BassetStatus status; // takes uint8 datatype (1 byte) in storage

        /** @dev An ERC20 can charge transfer fee, for example USDT, DGX tokens. */
        bool isTransferFeeCharged; // takes a byte in storage

        /**
         * @dev 1 Basset * ratio / ratioScale == x Masset (relative value)
         *      If ratio == 10e8 then 1 bAsset = 10 mAssets
         *      A ratio is divised as 10^(18-tokenDecimals) * measurementMultiple(relative value of 1 base unit)
         */
        uint256 ratio;

        /** @dev Target weights of the Basset (100% == 1e18) */
        uint256 maxWeight;

        /** @dev Amount of the Basset that is held in Collateral */
        uint256 vaultBalance;

    }

    /** @dev Status of the Basset - has it broken its peg? */
    enum BassetStatus {
        Default,
        Normal,
        BrokenBelowPeg,
        BrokenAbovePeg,
        Blacklisted,
        Liquidating,
        Liquidated,
        Failed
    }

    /** @dev Internal details on Basset */
    struct BassetDetails {
        Basset bAsset;
        address integrator;
        uint8 index;
    }

    /** @dev All details needed to Forge with multiple bAssets */
    struct ForgePropsMulti {
        bool isValid; // Flag to signify that forge bAssets have passed validity check
        Basset[] bAssets;
        address[] integrators;
        uint8[] indexes;
    }

    /** @dev All details needed for proportionate Redemption */
    struct RedeemPropsMulti {
        uint256 colRatio;
        Basset[] bAssets;
        address[] integrators;
        uint8[] indexes;
    }
}

contract IBasketManager is MassetStructs {

    /** @dev Setters for mAsset to update balances */
    function increaseVaultBalance(
        uint8 _bAsset,
        address _integrator,
        uint256 _increaseAmount) external;
    function increaseVaultBalances(
        uint8[] calldata _bAsset,
        address[] calldata _integrator,
        uint256[] calldata _increaseAmount) external;
    function decreaseVaultBalance(
        uint8 _bAsset,
        address _integrator,
        uint256 _decreaseAmount) external;
    function decreaseVaultBalances(
        uint8[] calldata _bAsset,
        address[] calldata _integrator,
        uint256[] calldata _decreaseAmount) external;
    function collectInterest() external
        returns (uint256 interestCollected, uint256[] memory gains);

    /** @dev Setters for Gov to update Basket composition */
    function addBasset(
        address _basset,
        address _integration,
        bool _isTransferFeeCharged) external returns (uint8 index);
    function setBasketWeights(address[] calldata _bassets, uint256[] calldata _weights) external;
    function setTransferFeesFlag(address _bAsset, bool _flag) external;

    /** @dev Getters to retrieve Basket information */
    function getBasket() external view returns (Basket memory b);
    function prepareForgeBasset(address _token, uint256 _amt, bool _mint) external
        returns (bool isValid, BassetDetails memory bInfo);
    function prepareSwapBassets(address _input, address _output, bool _isMint) external view
        returns (bool, string memory, BassetDetails memory, BassetDetails memory);
    function prepareForgeBassets(address[] calldata _bAssets, uint256[] calldata _amts, bool _mint) external
        returns (ForgePropsMulti memory props);
    function prepareRedeemMulti() external view
        returns (RedeemPropsMulti memory props);
    function getBasset(address _token) external view
        returns (Basset memory bAsset);
    function getBassets() external view
        returns (Basset[] memory bAssets, uint256 len);

    /** @dev Recollateralisation */
    function handlePegLoss(address _basset, bool _belowPeg) external returns (bool actioned);
    function negateIsolation(address _basset) external;
}

contract Initializable {

  /**
   * @dev Indicates that the contract has been initialized.
   */
  bool private initialized;

  /**
   * @dev Indicates that the contract is in the process of being initialized.
   */
  bool private initializing;

  /**
   * @dev Modifier to use in the initializer function of a contract.
   */
  modifier initializer() {
    require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

  /// @dev Returns true if and only if the function is running in the constructor
  function isConstructor() private view returns (bool) {
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}

contract ModuleKeys {

    // Governance
    // ===========
                                                // Phases
    // keccak256("Governance");                 // 2.x
    bytes32 internal constant KEY_GOVERNANCE = 0x9409903de1e6fd852dfc61c9dacb48196c48535b60e25abf92acc92dd689078d;
    //keccak256("Staking");                     // 1.2
    bytes32 internal constant KEY_STAKING = 0x1df41cd916959d1163dc8f0671a666ea8a3e434c13e40faef527133b5d167034;
    //keccak256("ProxyAdmin");                  // 1.0
    bytes32 internal constant KEY_PROXY_ADMIN = 0x96ed0203eb7e975a4cbcaa23951943fa35c5d8288117d50c12b3d48b0fab48d1;

    // mStable
    // =======
    // keccak256("OracleHub");                  // 1.2
    bytes32 internal constant KEY_ORACLE_HUB = 0x8ae3a082c61a7379e2280f3356a5131507d9829d222d853bfa7c9fe1200dd040;
    // keccak256("Manager");                    // 1.2
    bytes32 internal constant KEY_MANAGER = 0x6d439300980e333f0256d64be2c9f67e86f4493ce25f82498d6db7f4be3d9e6f;
    //keccak256("Recollateraliser");            // 2.x
    bytes32 internal constant KEY_RECOLLATERALISER = 0x39e3ed1fc335ce346a8cbe3e64dd525cf22b37f1e2104a755e761c3c1eb4734f;
    //keccak256("MetaToken");                   // 1.1
    bytes32 internal constant KEY_META_TOKEN = 0xea7469b14936af748ee93c53b2fe510b9928edbdccac3963321efca7eb1a57a2;
    // keccak256("SavingsManager");             // 1.0
    bytes32 internal constant KEY_SAVINGS_MANAGER = 0x12fe936c77a1e196473c4314f3bed8eeac1d757b319abb85bdda70df35511bf1;
}

interface IBasicToken {
    function decimals() external view returns (uint8);
}

library CommonHelpers {

    /**
     * @notice Fetch the `decimals()` from an ERC20 token
     * @dev Grabs the `decimals()` from a contract and fails if
     *      the decimal value does not live within a certain range
     * @param _token Address of the ERC20 token
     * @return uint256 Decimals of the ERC20 token
     */
    function getDecimals(address _token)
    internal
    view
    returns (uint256) {
        uint256 decimals = IBasicToken(_token).decimals();
        require(decimals >= 4 && decimals <= 18, "Token must have sufficient decimal places");

        return decimals;
    }

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
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
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
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
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
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
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
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

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
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
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

library StableMath {

    using SafeMath for uint256;

    /**
     * @dev Scaling unit for use in specific calculations,
     * where 1 * 10**18, or 1e18 represents a unit '1'
     */
    uint256 private constant FULL_SCALE = 1e18;

    /**
     * @notice Token Ratios are used when converting between units of bAsset, mAsset and MTA
     * Reasoning: Takes into account token decimals, and difference in base unit (i.e. grams to Troy oz for gold)
     * @dev bAsset ratio unit for use in exact calculations,
     * where (1 bAsset unit * bAsset.ratio) / ratioScale == x mAsset unit
     */
    uint256 private constant RATIO_SCALE = 1e8;

    /**
     * @dev Provides an interface to the scaling unit
     * @return Scaling unit (1e18 or 1 * 10**18)
     */
    function getFullScale() internal pure returns (uint256) {
        return FULL_SCALE;
    }

    /**
     * @dev Provides an interface to the ratio unit
     * @return Ratio scale unit (1e8 or 1 * 10**8)
     */
    function getRatioScale() internal pure returns (uint256) {
        return RATIO_SCALE;
    }

    /**
     * @dev Scales a given integer to the power of the full scale.
     * @param x   Simple uint256 to scale
     * @return    Scaled value a to an exact number
     */
    function scaleInteger(uint256 x)
        internal
        pure
        returns (uint256)
    {
        return x.mul(FULL_SCALE);
    }

    /***************************************
              PRECISE ARITHMETIC
    ****************************************/

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit
     */
    function mulTruncate(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return mulTruncateScale(x, y, FULL_SCALE);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the given scale. For example,
     * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @param scale Scale unit
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit
     */
    function mulTruncateScale(uint256 x, uint256 y, uint256 scale)
        internal
        pure
        returns (uint256)
    {
        uint256 z = x.mul(y);
        return z.div(scale);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
     * @param x     Left hand input to multiplication
     * @param y     Right hand input to multiplication
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              scale unit, rounded up to the closest base unit.
     */
    function mulTruncateCeil(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        uint256 scaled = x.mul(y);
        uint256 ceil = scaled.add(FULL_SCALE.sub(1));
        return ceil.div(FULL_SCALE);
    }

    /**
     * @dev Precisely divides two units, by first scaling the left hand operand. Useful
     *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
     * @param x     Left hand input to division
     * @param y     Right hand input to division
     * @return      Result after multiplying the left operand by the scale, and
     *              executing the division on the right hand input.
     */
    function divPrecisely(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        uint256 z = x.mul(FULL_SCALE);
        return z.div(y);
    }


    /***************************************
                  RATIO FUNCS
    ****************************************/

    /**
     * @dev Multiplies and truncates a token ratio, essentially flooring the result
     *      i.e. How much mAsset is this bAsset worth?
     * @param x     Left hand operand to multiplication (i.e Exact quantity)
     * @param ratio bAsset ratio
     * @return      Result after multiplying the two inputs and then dividing by the ratio scale
     */
    function mulRatioTruncate(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256 c)
    {
        return mulTruncateScale(x, ratio, RATIO_SCALE);
    }

    /**
     * @dev Multiplies and truncates a token ratio, rounding up the result
     *      i.e. How much mAsset is this bAsset worth?
     * @param x     Left hand input to multiplication (i.e Exact quantity)
     * @param ratio bAsset ratio
     * @return      Result after multiplying the two inputs and then dividing by the shared
     *              ratio scale, rounded up to the closest base unit.
     */
    function mulRatioTruncateCeil(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256)
    {
        // e.g. How much mAsset should I burn for this bAsset (x)?
        // 1e18 * 1e8 = 1e26
        uint256 scaled = x.mul(ratio);
        // 1e26 + 9.99e7 = 100..00.999e8
        uint256 ceil = scaled.add(RATIO_SCALE.sub(1));
        // return 100..00.999e8 / 1e8 = 1e18
        return ceil.div(RATIO_SCALE);
    }


    /**
     * @dev Precisely divides two ratioed units, by first scaling the left hand operand
     *      i.e. How much bAsset is this mAsset worth?
     * @param x     Left hand operand in division
     * @param ratio bAsset ratio
     * @return      Result after multiplying the left operand by the scale, and
     *              executing the division on the right hand input.
     */
    function divRatioPrecisely(uint256 x, uint256 ratio)
        internal
        pure
        returns (uint256 c)
    {
        // e.g. 1e14 * 1e8 = 1e22
        uint256 y = x.mul(RATIO_SCALE);
        // return 1e22 / 1e12 = 1e10
        return y.div(ratio);
    }

    /***************************************
                    HELPERS
    ****************************************/

    /**
     * @dev Calculates minimum of two numbers
     * @param x     Left hand input
     * @param y     Right hand input
     * @return      Minimum of the two inputs
     */
    function min(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return x > y ? y : x;
    }

    /**
     * @dev Calculated maximum of two numbers
     * @param x     Left hand input
     * @param y     Right hand input
     * @return      Maximum of the two inputs
     */
    function max(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        return x > y ? x : y;
    }

    /**
     * @dev Clamps a value to an upper bound
     * @param x           Left hand input
     * @param upperBound  Maximum possible value to return
     * @return            Input x clamped to a maximum value, upperBound
     */
    function clamp(uint256 x, uint256 upperBound)
        internal
        pure
        returns (uint256)
    {
        return x > upperBound ? upperBound : x;
    }
}

contract InitializableReentrancyGuard {
    bool private _notEntered;

    function _initialize() internal {
        // Storing an initial non-zero value makes deployment a bit more
        // expensive, but in exchange the refund on every call to nonReentrant
        // will be lower in amount. Since refunds are capped to a percetange of
        // the total transaction's gas, it is best to keep them low in cases
        // like this one, to increase the likelihood of the full refund coming
        // into effect.
        _notEntered = true;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_notEntered, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _notEntered = false;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _notEntered = true;
    }
}

/**
 * @title   BasketManager
 * @notice  Manages the Basket composition for a particular mAsset. Feeds all required
 *          basket data to the mAsset and is responsible for keeping accurate records.
 *          BasketManager can also optimise lending pool integrations and perform
 *          re-collateralisation on failed bAssets.
 * @dev     VERSION: 1.0
 *          DATE:    2020-05-05
 */
contract BasketManager is
    Initializable,
    IBasketManager,
    InitializablePausableModule,
    InitializableReentrancyGuard
{
    using SafeMath for uint256;
    using StableMath for uint256;
    using SafeERC20 for IERC20;

    // Events for Basket composition changes
    event BassetAdded(address indexed bAsset, address integrator);
    event BassetRemoved(address indexed bAsset);
    event BasketWeightsUpdated(address[] bAssets, uint256[] maxWeights);
    event BassetStatusChanged(address indexed bAsset, BassetStatus status);
    event BasketStatusChanged();
    event TransferFeeEnabled(address indexed bAsset, bool enabled);

    // mAsset linked to the manager (const)
    address public mAsset;

    // Struct holding Basket details
    Basket public basket;
    // Mapping holds bAsset token address => array index
    mapping(address => uint8) private bAssetsMap;
    // Holds relative addresses of the integration platforms
    address[] public integrations;

    /**
     * @dev Initialization function for upgradable proxy contract.
     *      This function should be called via Proxy just after contract deployment.
     * @param _nexus            Address of system Nexus
     * @param _mAsset           Address of the mAsset whose Basket to manage
     * @param _bAssets          Array of erc20 bAsset addresses
     * @param _integrators      Matching array of the platform intergations for bAssets
     * @param _weights          Weightings of each bAsset, summing to 1e18
     * @param _hasTransferFees  Bool signifying if this bAsset has xfer fees
     */
    function initialize(
        address _nexus,
        address _mAsset,
        address[] calldata _bAssets,
        address[] calldata _integrators,
        uint256[] calldata _weights,
        bool[] calldata _hasTransferFees
    )
        external
        initializer
    {
        InitializableReentrancyGuard._initialize();
        InitializablePausableModule._initialize(_nexus);

        require(_mAsset != address(0), "mAsset address is zero");
        require(_bAssets.length > 0, "Must initialise with some bAssets");
        mAsset = _mAsset;

        // Defaults
        basket.maxBassets = 10;               // 10
        basket.collateralisationRatio = 1e18; // 100%

        for (uint256 i = 0; i < _bAssets.length; i++) {
            _addBasset(
                _bAssets[i],
                _integrators[i],
                StableMath.getRatioScale(),
                _hasTransferFees[i]
            );
        }
        _setBasketWeights(_bAssets, _weights, true);
    }

    /**
     * @dev Requires the overall basket composition to be healthy
     */
    modifier whenBasketIsHealthy() {
        require(!basket.failed, "Basket must be alive");
        _;
    }

    /**
     * @dev Requires the overall basket composition to be healthy
     */
    modifier whenNotRecolling() {
        require(!basket.undergoingRecol, "No bAssets can be undergoing recol");
        _;
    }

    /**
     * @dev Verifies that the caller either Manager or Gov
     */
    modifier managerOrGovernor() {
        require(
            _manager() == msg.sender || _governor() == msg.sender,
            "Must be manager or governor");
        _;
    }

    /**
     * @dev Verifies that the caller is governed mAsset
     */
    modifier onlyMasset() {
        require(mAsset == msg.sender, "Must be called by mAsset");
        _;
    }

    /***************************************
                VAULT BALANCE
    ****************************************/

    /**
     * @dev Called by only mAsset, and only when the basket is healthy, to add units to
     *      storage after they have been deposited into the vault
     * @param _bAssetIndex      Index of the bAsset
     * @param _increaseAmount   Units deposited
     */
    function increaseVaultBalance(
        uint8 _bAssetIndex,
        address /* _integrator */,
        uint256 _increaseAmount
    )
        public	//inject PUBLIC FUNC TO EXTERNAL
        onlyMasset
        whenBasketIsHealthy
        nonReentrant
    {
        basket.bassets[_bAssetIndex].vaultBalance =
            basket.bassets[_bAssetIndex].vaultBalance.add(_increaseAmount);
    }

    /**
     * @dev Called by only mAsset, and only when the basket is healthy, to add units to
     *      storage after they have been deposited into the vault
     * @param _bAssetIndices    Array of bAsset indexes
     * @param _increaseAmount   Units deposited
     */
    function increaseVaultBalances(
        uint8[] calldata _bAssetIndices,
        address[] calldata /* _integrator */,
        uint256[] calldata _increaseAmount
    )
        external
        onlyMasset
        whenBasketIsHealthy
        nonReentrant
    {
        uint256 len = _bAssetIndices.length;
        for(uint i = 0; i < len; i++) {
            basket.bassets[_bAssetIndices[i]].vaultBalance =
                basket.bassets[_bAssetIndices[i]].vaultBalance.add(_increaseAmount[i]);
        }
    }

    /**
     * @dev Called by mAsset after redeeming tokens. Simply reduce the balance in the vault
     * @param _bAssetIndex      Index of the bAsset
     * @param _decreaseAmount   Units withdrawn
     */
    function decreaseVaultBalance(
        uint8 _bAssetIndex,
        address /* _integrator */,
        uint256 _decreaseAmount
    )
        public	//inject PUBLIC FUNC TO EXTERNAL
        onlyMasset
        nonReentrant
    {
        basket.bassets[_bAssetIndex].vaultBalance =
            basket.bassets[_bAssetIndex].vaultBalance.sub(_decreaseAmount);
    }

    /**
     * @dev Called by mAsset after redeeming tokens. Simply reduce the balance in the vault
     * @param _bAssetIndices    Array of bAsset indexes
     * @param _decreaseAmount   Units withdrawn
     */
    function decreaseVaultBalances(
        uint8[] calldata _bAssetIndices,
        address[] calldata /* _integrator */,
        uint256[] calldata _decreaseAmount
    )
        external
        onlyMasset
        nonReentrant
    {
        uint256 len = _bAssetIndices.length;
        for(uint i = 0; i < len; i++) {
            basket.bassets[_bAssetIndices[i]].vaultBalance =
                basket.bassets[_bAssetIndices[i]].vaultBalance.sub(_decreaseAmount[i]);
        }
    }

    /**
     * @dev Called by mAsset to calculate how much interest has been generated in the basket
     *      and withdraw it. Cycles through the connected platforms to check the balances.
     * @return interestCollected   Total amount of interest collected, in mAsset terms
     * @return gains               Array of bAsset units gained
     */
    function collectInterest()
        public	//inject PUBLIC FUNC TO EXTERNAL
        onlyMasset
        whenNotPaused
        whenBasketIsHealthy
        nonReentrant
        returns (uint256 interestCollected, uint256[] memory gains)
    {
        // Get basket details
        (Basset[] memory allBassets, uint256 count) = _getBassets();
        gains = new uint256[](count);
        interestCollected = 0;

        // foreach bAsset
        for(uint8 i = 0; i < count; i++) {
            Basset memory b = allBassets[i];
            // call each integration to `checkBalance`
            uint256 balance = IPlatformIntegration(integrations[i]).checkBalance(b.addr);
            uint256 oldVaultBalance = b.vaultBalance;

            // accumulate interest (ratioed bAsset)
            if(balance > oldVaultBalance && b.status == BassetStatus.Normal) {
                // Update balance
                basket.bassets[i].vaultBalance = balance;

                uint256 interestDelta = balance.sub(oldVaultBalance);
                gains[i] = interestDelta;

                // Calc MassetQ
                uint256 ratioedDelta = interestDelta.mulRatioTruncate(b.ratio);
                interestCollected = interestCollected.add(ratioedDelta);
            } else {
                gains[i] = 0;
            }
        }
    }


    /***************************************
                BASKET MANAGEMENT
    ****************************************/

    /**
     * @dev External func to allow the Governor to conduct add operations on the Basket
     * @param _bAsset               Address of the ERC20 token to add to the Basket
     * @param _integration          Address of the vault integration to deposit and withdraw
     * @param _isTransferFeeCharged Bool - are transfer fees charged on this bAsset
     * @return index                Position of the bAsset in the Basket
     */
    function addBasset(address _bAsset, address _integration, bool _isTransferFeeCharged)
        public	//inject PUBLIC FUNC TO EXTERNAL
        onlyGovernor
        whenBasketIsHealthy
        whenNotRecolling
        returns (uint8 index)
    {
        index = _addBasset(
            _bAsset,
            _integration,
            StableMath.getRatioScale(),
            _isTransferFeeCharged
        );
    }

    /**
     * @dev Adds a bAsset to the Basket, fetching its decimals and calculating the Ratios
     * @param _bAsset               Address of the ERC20 token to add to the Basket
     * @param _integration          Address of the Platform Integration
     * @param _measurementMultiple  Base 1e8 var to determine measurement ratio
     *                              between bAsset:mAsset
     * @param _isTransferFeeCharged Bool - are transfer fees charged on this bAsset
     * @return index                Position of the bAsset in the Basket
     */
    function _addBasset(
        address _bAsset,
        address _integration,
        uint256 _measurementMultiple,
        bool _isTransferFeeCharged
    )
        internal
        returns (uint8 index)
    {
        require(_bAsset != address(0), "bAsset address must be valid");
        require(_integration != address(0), "Integration address must be valid");
        require(_measurementMultiple >= 1e6 && _measurementMultiple <= 1e10, "MM out of range");

        (bool alreadyInBasket, ) = _isAssetInBasket(_bAsset);
        require(!alreadyInBasket, "bAsset already exists in Basket");

        // Should fail if bAsset is not added to integration
        // Programmatic enforcement of bAsset validity should service through decentralised feed
        IPlatformIntegration(_integration).checkBalance(_bAsset);

        uint256 bAsset_decimals = CommonHelpers.getDecimals(_bAsset);
        uint256 delta = uint256(18).sub(bAsset_decimals);

        uint256 ratio = _measurementMultiple.mul(10 ** delta);

        uint8 numberOfBassetsInBasket = uint8(basket.bassets.length);
        require(numberOfBassetsInBasket < basket.maxBassets, "Max bAssets in Basket");

        bAssetsMap[_bAsset] = numberOfBassetsInBasket;

        integrations.push(_integration);
        basket.bassets.push(Basset({
            addr: _bAsset,
            ratio: ratio,
            maxWeight: 0,
            vaultBalance: 0,
            status: BassetStatus.Normal,
            isTransferFeeCharged: _isTransferFeeCharged
        }));

        emit BassetAdded(_bAsset, _integration);

        index = numberOfBassetsInBasket;
    }


    /**
     * @dev External call for the governor to set weightings of all bAssets
     * @param _bAssets Array of bAsset addresses
     * @param _weights Array of bAsset weights - summing 100% where 100% == 1e18
     */
    function setBasketWeights(
        address[] calldata _bAssets,
        uint256[] calldata _weights
    )
        external
        onlyGovernor
        whenBasketIsHealthy
    {
        _setBasketWeights(_bAssets, _weights, false);
    }

    /**
     * @notice Sets new Basket weightings
     * @dev Requires the modified bAssets to be in a Normal state
     * @param _bAssets Array of bAsset addresses
     * @param _weights Array of bAsset weights - summing 100% where 100% == 1e18
     * @param _isBootstrap True only on the first occurence of weight setting
     */
    function _setBasketWeights(
        address[] memory _bAssets,
        uint256[] memory _weights,
        bool _isBootstrap
    )
        internal
    {
        uint256 bAssetCount = _bAssets.length;
        require(bAssetCount > 0, "Empty bAssets array passed");
        require(bAssetCount == _weights.length, "Must be matching bAsset arrays");

        for (uint256 i = 0; i < bAssetCount; i++) {
            (bool exists, uint8 index) = _isAssetInBasket(_bAssets[i]);
            require(exists, "bAsset must exist");

            Basset memory bAsset = _getBasset(index);

            uint256 bAssetWeight = _weights[i];

            if(bAsset.status == BassetStatus.Normal) {
                require(
                    bAssetWeight <= 1e18,
                    "Asset weight must be <= 100%"
                );
                basket.bassets[index].maxWeight = bAssetWeight;
            } else {
                require(
                    bAssetWeight == basket.bassets[index].maxWeight,
                    "Affected bAssets must be static"
                );
            }
        }

        if(!_isBootstrap){
            _validateBasketWeight();
        }

        emit BasketWeightsUpdated(_bAssets, _weights);
    }

    /**
     * @dev Throws if the total Basket weight does not sum to 100
     */
    function _validateBasketWeight() internal view {
        uint256 len = basket.bassets.length;
        uint256 weightSum = 0;
        for(uint256 i = 0; i < len; i++) {
            weightSum = weightSum.add(basket.bassets[i].maxWeight);
        }
        require(weightSum >= 1e18 && weightSum <= 4e18, "Basket weight must be >= 100 && <= 400%");
    }

    /**
     * @dev Update transfer fee flag for a given bAsset, should it change its fee practice
     * @param _bAsset   bAsset address
     * @param _flag         Charge transfer fee when its set to 'true', otherwise 'false'
     */
    function setTransferFeesFlag(address _bAsset, bool _flag)
        public	//inject PUBLIC FUNC TO EXTERNAL
        managerOrGovernor
    {
        (bool exist, uint8 index) = _isAssetInBasket(_bAsset);
        require(exist, "bAsset does not exist");
        basket.bassets[index].isTransferFeeCharged = _flag;

        emit TransferFeeEnabled(_bAsset, _flag);
    }


    /**
     * @dev Removes a specific Asset from the Basket, given that its target/collateral
     *      level is already 0, throws if invalid.
     * @param _assetToRemove The asset to remove from the basket
     */
    function removeBasset(address _assetToRemove)
        public	//inject PUBLIC FUNC TO EXTERNAL
        whenBasketIsHealthy
        whenNotRecolling
        managerOrGovernor
    {
        _removeBasset(_assetToRemove);
    }

    /**
     * @dev Removes a specific Asset from the Basket, given that its target/collateral
     *      level is already 0, throws if invalid.
     * @param _assetToRemove The asset to remove from the basket
     */
    function _removeBasset(address _assetToRemove) internal {
        (bool exists, uint8 index) = _isAssetInBasket(_assetToRemove);
        require(exists, "bAsset does not exist");

        uint256 len = basket.bassets.length;
        Basset memory bAsset = basket.bassets[index];

        require(bAsset.maxWeight == 0, "bAsset must have a target weight of 0");
        require(bAsset.vaultBalance == 0, "bAsset vault must be empty");
        require(bAsset.status != BassetStatus.Liquidating, "bAsset must be active");

        uint8 lastIndex = uint8(len.sub(1));
        if(index == lastIndex) {
            basket.bassets.pop();
            bAssetsMap[_assetToRemove] = 0;
            integrations.pop();
        } else {
            // Swap the bassets
            basket.bassets[index] = basket.bassets[lastIndex];
            basket.bassets.pop();
            Basset memory swappedBasset = basket.bassets[index];
            // Update bassetsMap
            bAssetsMap[_assetToRemove] = 0;
            bAssetsMap[swappedBasset.addr] = index;
            // Update integrations
            integrations[index] = integrations[lastIndex];
            integrations.pop();
        }

        emit BassetRemoved(bAsset.addr);
    }


    /***************************************
                    GETTERS
    ****************************************/

    /**
     * @dev Get basket details for `MassetStructs.Basket`
     * @return b   Basket struct
     */
    function getBasket()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns (Basket memory b)
    {
        b = basket;
    }

    /**
     * @dev Prepare given bAsset for Forging. Currently returns integrator
     *      and essential minting info.
     * @param _bAsset    Address of the bAsset
     * @return props     Struct of all relevant Forge information
     */
    function prepareForgeBasset(address _bAsset, uint256 /*_amt*/, bool /*_mint*/)
        public	//inject PUBLIC FUNC TO EXTERNAL
        whenNotPaused
        whenNotRecolling
        returns (bool isValid, BassetDetails memory bInfo)
    {
        (bool exists, uint8 idx) = _isAssetInBasket(_bAsset);
        require(exists, "bAsset does not exist");
        isValid = true;
        bInfo = BassetDetails({
            bAsset: basket.bassets[idx],
            integrator: integrations[idx],
            index: idx
        });
    }

    /**
     * @dev Prepare given bAssets for swapping
     * @param _input     Address of the input bAsset
     * @param _output    Address of the output bAsset
     * @param _isMint    Is this swap actually a mint? i.e. output == address(mAsset)
     * @return props     Struct of all relevant Forge information
     */
    function prepareSwapBassets(address _input, address _output, bool _isMint)
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        whenNotPaused
        returns (bool, string memory, BassetDetails memory, BassetDetails memory)
    {
        BassetDetails memory input = BassetDetails({
            bAsset: basket.bassets[0],
            integrator: address(0),
            index: 0
        });
        BassetDetails memory output = input;
        // Check that basket state is healthy
        if(basket.failed || basket.undergoingRecol){
            return (false, "Basket is undergoing change", input, output);
        }

        // Fetch input bAsset
        (bool inputExists, uint8 inputIdx) = _isAssetInBasket(_input);
        if(!inputExists) {
            return (false, "Input asset does not exist", input, output);
        }
        input = BassetDetails({
            bAsset: basket.bassets[inputIdx],
            integrator: integrations[inputIdx],
            index: inputIdx
        });

        // If this is a mint, we don't need output bAsset
        if(_isMint) {
            return (true, "", input, output);
        }

        // Fetch output bAsset
        (bool outputExists, uint8 outputIdx) = _isAssetInBasket(_output);
        if(!outputExists) {
            return (false, "Output asset does not exist", input, output);
        }
        output = BassetDetails({
            bAsset: basket.bassets[outputIdx],
            integrator: integrations[outputIdx],
            index: outputIdx
        });
        return (true, "", input, output);
    }

    /**
     * @dev Prepare given bAsset addresses for Forging. Currently returns integrator
     *      and essential minting info for each bAsset
     * @param _bAssets   Array of bAsset addresses with which to forge
     * @return props     Struct of all relevant Forge information
     */
    function prepareForgeBassets(
        address[] calldata _bAssets,
        uint256[] calldata /*_amts*/,
        bool /* _isMint */
    )
        external
        whenNotPaused
        whenNotRecolling
        returns (ForgePropsMulti memory props)
    {
        // Pass the fetching logic to the internal view func to reduce SLOAD cost
        (Basset[] memory bAssets, uint8[] memory indexes, address[] memory integrators) = _fetchForgeBassets(_bAssets);
        props = ForgePropsMulti({
            isValid: true,
            bAssets: bAssets,
            integrators: integrators,
            indexes: indexes
        });
    }

    /**
     * @dev Prepare given bAsset addresses for RedeemMulti. Currently returns integrator
     *      and essential minting info for each bAsset
     * @return props     Struct of all relevant Forge information
     */
    function prepareRedeemMulti()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        whenNotPaused
        whenNotRecolling
        returns (RedeemPropsMulti memory props)
    {
        (Basset[] memory bAssets, uint256 len) = _getBassets();
        address[] memory orderedIntegrators = new address[](len);
        uint8[] memory indexes = new uint8[](len);
        for(uint8 i = 0; i < len; i++){
            orderedIntegrators[i] = integrations[i];
            indexes[i] = i;
        }
        props = RedeemPropsMulti({
            colRatio: basket.collateralisationRatio,
            bAssets: bAssets,
            integrators: orderedIntegrators,
            indexes: indexes
        });
    }

    /**
     * @dev Internal func to fetch an array of bAssets and their integrators from storage
     * @param _bAssets       Array of non-duplicate bAsset addresses with which to forge
     * @return bAssets       Array of bAsset structs for the given addresses
     * @return indexes       Array of indexes for the given addresses
     * @return integrators   Array of integrators for the given addresses
     */
    function _fetchForgeBassets(address[] memory _bAssets)
        internal
        view
        returns (
            Basset[] memory bAssets,
            uint8[] memory indexes,
            address[] memory integrators
        )
    {
        uint8 len = uint8(_bAssets.length);

        bAssets = new Basset[](len);
        integrators = new address[](len);
        indexes = new uint8[](len);

        // Iterate through the input
        for(uint8 i = 0; i < len; i++) {
            address current = _bAssets[i];

            // If there is a duplicate here, throw
            // Gas costs do not incur SLOAD
            for(uint8 j = i+1; j < len; j++){
                require(current != _bAssets[j], "Must have no duplicates");
            }

            // Fetch and log all the relevant data
            (bool exists, uint8 index) = _isAssetInBasket(current);
            require(exists, "bAsset must exist");
            indexes[i] = index;
            bAssets[i] = basket.bassets[index];
            integrators[i] = integrations[index];
        }
    }

    /**
     * @dev Get data for a all bAssets in basket
     * @return bAssets  Struct[] with full bAsset data
     * @return len      Number of bAssets in the Basket
     */
    function getBassets()
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns (
            Basset[] memory bAssets,
            uint256 len
        )
    {
        return _getBassets();
    }

    /**
     * @dev Get data for a specific bAsset, if it exists
     * @param _bAsset   Address of bAsset
     * @return bAsset  Struct with full bAsset data
     */
    function getBasset(address _bAsset)
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns (Basset memory bAsset)
    {
        (bool exists, uint8 index) = _isAssetInBasket(_bAsset);
        require(exists, "bAsset must exist");
        bAsset = _getBasset(index);
    }

    /**
     * @dev Get current integrator for a specific bAsset, if it exists
     * @param _bAsset      Address of bAsset
     * @return integrator  Address of current integrator
     */
    function getBassetIntegrator(address _bAsset)
        public	//inject PUBLIC FUNC TO EXTERNAL
        view
        returns (address integrator)
    {
        (bool exists, uint8 index) = _isAssetInBasket(_bAsset);
        require(exists, "bAsset must exist");
        integrator = integrations[index];
    }

    function _getBassets()
        internal
        view
        returns (
            Basset[] memory bAssets,
            uint256 len
        )
    {
        bAssets = basket.bassets;
        len = basket.bassets.length;
    }

    function _getBasset(uint8 _bAssetIndex)
        internal
        view
        returns (Basset memory bAsset)
    {
        bAsset = basket.bassets[_bAssetIndex];
    }


    /***************************************
                    HELPERS
    ****************************************/

    /**
     * @dev Checks if a particular asset is in the basket
     * @param _asset   Address of bAsset to look for
     * @return exists  bool to signal that the asset is in basket
     * @return index   uint256 Index of the bAsset
     */
    function _isAssetInBasket(address _asset)
        internal
        view
        returns (bool exists, uint8 index)
    {
        index = bAssetsMap[_asset];
        if(index == 0) {
            if(basket.bassets.length == 0) {
                return (false, 0);
            }
            return (basket.bassets[0].addr == _asset, 0);
        }
        return (true, index);
    }

    /**
     * @notice Determine whether or not a bAsset has already undergone re-collateralisation
     * @param _status   Status of the bAsset
     * @return          Bool to determine if undergone re-collateralisation
     */
    function _bAssetHasRecolled(BassetStatus _status)
        internal
        pure
        returns (bool)
    {
        if(_status == BassetStatus.Liquidating ||
            _status == BassetStatus.Liquidated ||
            _status == BassetStatus.Failed) {
            return true;
        }
        return false;
    }


    /***************************************
                RE-COLLATERALISATION
    ****************************************/

    /**
     * @dev Executes the Auto Redistribution event by isolating the bAsset from the Basket
     * @param _bAsset          Address of the ERC20 token to isolate
     * @param _belowPeg        Bool to describe whether the bAsset deviated below peg (t)
     *                         or above (f)
     * @return alreadyActioned Bool to show whether a bAsset had already been actioned
     */
    function handlePegLoss(address _bAsset, bool _belowPeg)
        public	//inject PUBLIC FUNC TO EXTERNAL
        managerOrGovernor
        whenBasketIsHealthy
        returns (bool alreadyActioned)
    {
        (bool exists, uint256 i) = _isAssetInBasket(_bAsset);
        require(exists, "bAsset must exist in Basket");

        BassetStatus oldStatus = basket.bassets[i].status;
        BassetStatus newStatus =
            _belowPeg ? BassetStatus.BrokenBelowPeg : BassetStatus.BrokenAbovePeg;

        if(oldStatus == newStatus || _bAssetHasRecolled(oldStatus)) {
            return true;
        }

        // If we need to update the status.. then do it
        basket.bassets[i].status = newStatus;
        emit BassetStatusChanged(_bAsset, newStatus);
        return false;
    }

    /**
     * @dev Negates the isolation of a given bAsset
     * @param _bAsset Address of the bAsset
     */
    function negateIsolation(address _bAsset)
        public	//inject PUBLIC FUNC TO EXTERNAL
        managerOrGovernor
    {
        (bool exists, uint256 i) = _isAssetInBasket(_bAsset);
        require(exists, "bAsset must exist");

        BassetStatus currentStatus = basket.bassets[i].status;
        if(currentStatus == BassetStatus.BrokenBelowPeg ||
            currentStatus == BassetStatus.BrokenAbovePeg ||
            currentStatus == BassetStatus.Blacklisted) {
            basket.bassets[i].status = BassetStatus.Normal;
            emit BassetStatusChanged(_bAsset, BassetStatus.Normal);
        }
    }

    /**
     * @dev Marks a bAsset as permanently deviated from peg
     * @param _bAsset Address of the bAsset
     */
    function failBasset(address _bAsset)
        public	//inject PUBLIC FUNC TO EXTERNAL
        onlyGovernor
    {
        (bool exists, uint256 i) = _isAssetInBasket(_bAsset);
        require(exists, "bAsset must exist");

        BassetStatus currentStatus = basket.bassets[i].status;
        require(
            currentStatus == BassetStatus.BrokenBelowPeg ||
            currentStatus == BassetStatus.BrokenAbovePeg,
            "bAsset must be affected"
        );
        basket.failed = true;
    }
}