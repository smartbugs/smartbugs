/**
 *Submitted for verification at Etherscan.io on 2019-12-02
*/

/**
 *Submitted for verification at Etherscan.io on 2019-12-02
*/

pragma solidity ^0.5.4;

/**
 * ERC20 contract interface.
 */
contract ERC20 {
    function totalSupply() public view returns (uint);
    function decimals() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
}

/**
 * @title Module
 * @dev Interface for a module. 
 * A module MUST implement the addModule() method to ensure that a wallet with at least one module
 * can never end up in a "frozen" state.
 * @author Julien Niset - <julien@argent.xyz>
 */
interface Module {
    function init(BaseWallet _wallet) external;
    function addModule(BaseWallet _wallet, Module _module) external;
    function recoverToken(address _token) external;
}

/**
 * @title BaseWallet
 * @dev Simple modular wallet that authorises modules to call its invoke() method.
 * Based on https://gist.github.com/Arachnid/a619d31f6d32757a4328a428286da186 by 
 * @author Julien Niset - <julien@argent.xyz>
 */
contract BaseWallet {
    address public implementation;
    address public owner;
    mapping (address => bool) public authorised;
    mapping (bytes4 => address) public enabled;
    uint public modules;
    function init(address _owner, address[] calldata _modules) external;
    function authoriseModule(address _module, bool _value) external;
    function enableStaticCall(address _module, bytes4 _method) external;
    function setOwner(address _newOwner) external;
    function invoke(address _target, uint _value, bytes calldata _data) external;
    function() external payable;
}

/**
 * @title ModuleRegistry
 * @dev Registry of authorised modules. 
 * Modules must be registered before they can be authorised on a wallet.
 * @author Julien Niset - <julien@argent.xyz>
 */
contract ModuleRegistry {
    function registerModule(address _module, bytes32 _name) external;
    function deregisterModule(address _module) external;
    function registerUpgrader(address _upgrader, bytes32 _name) external;
    function deregisterUpgrader(address _upgrader) external;
    function recoverToken(address _token) external;
    function moduleInfo(address _module) external view returns (bytes32);
    function upgraderInfo(address _upgrader) external view returns (bytes32);
    function isRegisteredModule(address _module) external view returns (bool);
    function isRegisteredModule(address[] calldata _modules) external view returns (bool);
    function isRegisteredUpgrader(address _upgrader) external view returns (bool);
}

/**
 * @title GuardianStorage
 * @dev Contract storing the state of wallets related to guardians and lock.
 * The contract only defines basic setters and getters with no logic. Only modules authorised
 * for a wallet can modify its state.
 * @author Julien Niset - <julien@argent.xyz>
 * @author Olivier Van Den Biggelaar - <olivier@argent.xyz>
 */
contract GuardianStorage {
    function addGuardian(BaseWallet _wallet, address _guardian) external;
    function revokeGuardian(BaseWallet _wallet, address _guardian) external;
    function guardianCount(BaseWallet _wallet) external view returns (uint256);
    function getGuardians(BaseWallet _wallet) external view returns (address[] memory);
    function isGuardian(BaseWallet _wallet, address _guardian) external view returns (bool);
    function setLock(BaseWallet _wallet, uint256 _releaseAfter) external;
    function isLocked(BaseWallet _wallet) external view returns (bool);
    function getLock(BaseWallet _wallet) external view returns (uint256);
    function getLocker(BaseWallet _wallet) external view returns (address);
}

interface Comptroller {
    function enterMarkets(address[] calldata _cTokens) external returns (uint[] memory);
    function exitMarket(address _cToken) external returns (uint);
    function getAssetsIn(address _account) external view returns (address[] memory);
    function getAccountLiquidity(address _account) external view returns (uint, uint, uint);
    function checkMembership(address account, CToken cToken) external view returns (bool);
}

interface CToken {
    function comptroller() external view returns (address);
    function underlying() external view returns (address);
    function symbol() external view returns (string memory);
    function exchangeRateCurrent() external returns (uint256);
    function exchangeRateStored() external view returns (uint256);
    function balanceOf(address _account) external view returns (uint256);
    function borrowBalanceCurrent(address _account) external returns (uint256);
    function borrowBalanceStored(address _account) external view returns (uint256);
}

/**
 * @title CompoundRegistry
 * @dev Simple registry containing a mapping between underlying assets and their corresponding cToken.
 * @author Julien Niset - <julien@argent.xyz>
 */
contract CompoundRegistry {
    function addCToken(address _underlying, address _cToken) external;
    function removeCToken(address _underlying) external;
    function getCToken(address _underlying) external view returns (address);
    function listUnderlyings() external view returns (address[] memory);
}

/**
 * @title Interface for a contract that can invest tokens in order to earn an interest.
 * @author Julien Niset - <julien@argent.xyz>
 */
interface Invest {

    event InvestmentAdded(address indexed _wallet, address _token, uint256 _invested, uint256 _period);
    event InvestmentRemoved(address indexed _wallet, address _token, uint256 _fraction);

    /**
     * @dev Invest tokens for a given period.
     * @param _wallet The target wallet.
     * @param _token The token address.
     * @param _amount The amount of tokens to invest.
     * @param _period The period over which the tokens may be locked in the investment (optional).
     * @return The exact amount of tokens that have been invested. 
     */
    function addInvestment(
        BaseWallet _wallet, 
        address _token, 
        uint256 _amount, 
        uint256 _period
    ) 
        external
        returns (uint256 _invested);

    /**
     * @dev Exit invested postions.
     * @param _wallet The target wallet.
     * @param _token The token address.
     * @param _fraction The fraction of invested tokens to exit in per 10000. 
     */
    function removeInvestment(
        BaseWallet _wallet, 
        address _token, 
        uint256 _fraction
    ) 
        external;

    /**
     * @dev Get the amount of investment in a given token.
     * @param _wallet The target wallet.
     * @param _token The token address.
     * @return The value in tokens of the investment (including interests) and the time at which the investment can be removed.
     */
    function getInvestment(
        BaseWallet _wallet,
        address _token
    )
        external
        view
        returns (uint256 _tokenValue, uint256 _periodEnd);
}

/**
 * @title Interface for a contract that can loan tokens to a wallet.
 * @author Julien Niset - <julien@argent.xyz>
 */
interface Loan {

    event LoanOpened(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount, address _debtToken, uint256 _debtAmount);
    event LoanClosed(address indexed _wallet, bytes32 indexed _loanId);
    event CollateralAdded(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount);
    event CollateralRemoved(address indexed _wallet, bytes32 indexed _loanId, address _collateral, uint256 _collateralAmount);
    event DebtAdded(address indexed _wallet, bytes32 indexed _loanId, address _debtToken, uint256 _debtAmount);
    event DebtRemoved(address indexed _wallet, bytes32 indexed _loanId, address _debtToken, uint256 _debtAmount);

    /**
     * @dev Opens a collateralized loan.
     * @param _wallet The target wallet.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral token provided.
     * @param _debtToken The token borrowed.
     * @param _debtAmount The amount of tokens borrowed.
     * @return (optional) An ID for the loan when the provider enables users to create multiple distinct loans.
     */
    function openLoan(
        BaseWallet _wallet, 
        address _collateral, 
        uint256 _collateralAmount, 
        address _debtToken, 
        uint256 _debtAmount
    ) 
        external 
        returns (bytes32 _loanId);

    /**
     * @dev Closes a collateralized loan by repaying all debts (plus interest) and redeeming all collateral (plus interest).
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     */
    function closeLoan(
        BaseWallet _wallet, 
        bytes32 _loanId
    ) 
        external;

    /**
     * @dev Adds collateral to a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral to add.
     */
    function addCollateral(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _collateral, 
        uint256 _collateralAmount
    ) 
        external;

    /**
     * @dev Removes collateral from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral to remove.
     */
    function removeCollateral(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _collateral, 
        uint256 _collateralAmount
    ) 
        external;

    /**
     * @dev Increases the debt by borrowing more token from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _debtToken The token borrowed.
     * @param _debtAmount The amount of token to borrow.
     */
    function addDebt(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _debtToken, 
        uint256 _debtAmount
    ) 
        external;

    /**
     * @dev Decreases the debt by repaying some token from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @param _debtToken The token to repay.
     * @param _debtAmount The amount of token to repay.
     */
    function removeDebt(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _debtToken, 
        uint256 _debtAmount
    ) 
        external;

    /**
     * @dev Gets information about a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId The ID of the loan if any, 0 otherwise.
     * @return a status [0: no loan, 1: loan is safe, 2: loan is unsafe and can be liquidated, 3: unable to provide info]
     * and a value (in ETH) representing the value that could still be borrowed when status = 1; or the value of the collateral 
     * that should be added to avoid liquidation when status = 2.     
     */
    function getLoan(
        BaseWallet _wallet, 
        bytes32 _loanId
    ) 
        external 
        view 
        returns (uint8 _status, uint256 _ethValue);
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, reverts on overflow.
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
    * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two numbers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }

    /**
    * @dev Returns ceil(a / b).
    */
    function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        if(a % b == 0) {
            return c;
        }
        else {
            return c + 1;
        }
    }
}

/**
 * @title BaseModule
 * @dev Basic module that contains some methods common to all modules.
 * @author Julien Niset - <julien@argent.im>
 */
contract BaseModule is Module {

    // The adddress of the module registry.
    ModuleRegistry internal registry;

    event ModuleCreated(bytes32 name);
    event ModuleInitialised(address wallet);

    constructor(ModuleRegistry _registry, bytes32 _name) public {
        registry = _registry;
        emit ModuleCreated(_name);
    }

    /**
     * @dev Throws if the sender is not the target wallet of the call.
     */
    modifier onlyWallet(BaseWallet _wallet) {
        require(msg.sender == address(_wallet), "BM: caller must be wallet");
        _;
    }

    /**
     * @dev Throws if the sender is not the owner of the target wallet or the module itself.
     */
    modifier onlyWalletOwner(BaseWallet _wallet) {
        require(msg.sender == address(this) || isOwner(_wallet, msg.sender), "BM: must be an owner for the wallet");
        _;
    }

    /**
     * @dev Throws if the sender is not the owner of the target wallet.
     */
    modifier strictOnlyWalletOwner(BaseWallet _wallet) {
        require(isOwner(_wallet, msg.sender), "BM: msg.sender must be an owner for the wallet");
        _;
    }

    /**
     * @dev Inits the module for a wallet by logging an event.
     * The method can only be called by the wallet itself.
     * @param _wallet The wallet.
     */
    function init(BaseWallet _wallet) external onlyWallet(_wallet) {
        emit ModuleInitialised(address(_wallet));
    }

    /**
     * @dev Adds a module to a wallet. First checks that the module is registered.
     * @param _wallet The target wallet.
     * @param _module The modules to authorise.
     */
    function addModule(BaseWallet _wallet, Module _module) external strictOnlyWalletOwner(_wallet) {
        require(registry.isRegisteredModule(address(_module)), "BM: module is not registered");
        _wallet.authoriseModule(address(_module), true);
    }

    /**
    * @dev Utility method enbaling anyone to recover ERC20 token sent to the
    * module by mistake and transfer them to the Module Registry. 
    * @param _token The token to recover.
    */
    function recoverToken(address _token) external {
        uint total = ERC20(_token).balanceOf(address(this));
        ERC20(_token).transfer(address(registry), total);
    }

    /**
     * @dev Helper method to check if an address is the owner of a target wallet.
     * @param _wallet The target wallet.
     * @param _addr The address.
     */
    function isOwner(BaseWallet _wallet, address _addr) internal view returns (bool) {
        return _wallet.owner() == _addr;
    }
}

/**
 * @title RelayerModule
 * @dev Base module containing logic to execute transactions signed by eth-less accounts and sent by a relayer. 
 * @author Julien Niset - <julien@argent.im>
 */
contract RelayerModule is Module {

    uint256 constant internal BLOCKBOUND = 10000;

    mapping (address => RelayerConfig) public relayer; 

    struct RelayerConfig {
        uint256 nonce;
        mapping (bytes32 => bool) executedTx;
    }

    event TransactionExecuted(address indexed wallet, bool indexed success, bytes32 signedHash);

    /**
     * @dev Throws if the call did not go through the execute() method.
     */
    modifier onlyExecute {
        require(msg.sender == address(this), "RM: must be called via execute()");
        _;
    }

    /* ***************** Abstract method ************************* */

    /**
    * @dev Gets the number of valid signatures that must be provided to execute a
    * specific relayed transaction.
    * @param _wallet The target wallet.
    * @param _data The data of the relayed transaction.
    * @return The number of required signatures.
    */
    function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256);

    /**
    * @dev Validates the signatures provided with a relayed transaction.
    * The method MUST throw if one or more signatures are not valid.
    * @param _wallet The target wallet.
    * @param _data The data of the relayed transaction.
    * @param _signHash The signed hash representing the relayed transaction.
    * @param _signatures The signatures as a concatenated byte array.
    */
    function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool);

    /* ************************************************************ */

    /**
    * @dev Executes a relayed transaction.
    * @param _wallet The target wallet.
    * @param _data The data for the relayed transaction
    * @param _nonce The nonce used to prevent replay attacks.
    * @param _signatures The signatures as a concatenated byte array.
    * @param _gasPrice The gas price to use for the gas refund.
    * @param _gasLimit The gas limit to use for the gas refund.
    */
    function execute(
        BaseWallet _wallet,
        bytes calldata _data, 
        uint256 _nonce, 
        bytes calldata _signatures, 
        uint256 _gasPrice,
        uint256 _gasLimit
    )
        external
        returns (bool success)
    {
        uint startGas = gasleft();
        bytes32 signHash = getSignHash(address(this), address(_wallet), 0, _data, _nonce, _gasPrice, _gasLimit);
        require(checkAndUpdateUniqueness(_wallet, _nonce, signHash), "RM: Duplicate request");
        require(verifyData(address(_wallet), _data), "RM: the wallet authorized is different then the target of the relayed data");
        uint256 requiredSignatures = getRequiredSignatures(_wallet, _data);
        if((requiredSignatures * 65) == _signatures.length) {
            if(verifyRefund(_wallet, _gasLimit, _gasPrice, requiredSignatures)) {
                if(requiredSignatures == 0 || validateSignatures(_wallet, _data, signHash, _signatures)) {
                    // solium-disable-next-line security/no-call-value
                    (success,) = address(this).call(_data);
                    refund(_wallet, startGas - gasleft(), _gasPrice, _gasLimit, requiredSignatures, msg.sender);
                }
            }
        }
        emit TransactionExecuted(address(_wallet), success, signHash); 
    }

    /**
    * @dev Gets the current nonce for a wallet.
    * @param _wallet The target wallet.
    */
    function getNonce(BaseWallet _wallet) external view returns (uint256 nonce) {
        return relayer[address(_wallet)].nonce;
    }

    /**
    * @dev Generates the signed hash of a relayed transaction according to ERC 1077.
    * @param _from The starting address for the relayed transaction (should be the module)
    * @param _to The destination address for the relayed transaction (should be the wallet)
    * @param _value The value for the relayed transaction
    * @param _data The data for the relayed transaction
    * @param _nonce The nonce used to prevent replay attacks.
    * @param _gasPrice The gas price to use for the gas refund.
    * @param _gasLimit The gas limit to use for the gas refund.
    */
    function getSignHash(
        address _from,
        address _to, 
        uint256 _value, 
        bytes memory _data, 
        uint256 _nonce,
        uint256 _gasPrice,
        uint256 _gasLimit
    ) 
        internal 
        pure
        returns (bytes32) 
    {
        return keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                keccak256(abi.encodePacked(byte(0x19), byte(0), _from, _to, _value, _data, _nonce, _gasPrice, _gasLimit))
        ));
    }

    /**
    * @dev Checks if the relayed transaction is unique.
    * @param _wallet The target wallet.
    * @param _nonce The nonce
    * @param _signHash The signed hash of the transaction
    */
    function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
        if(relayer[address(_wallet)].executedTx[_signHash] == true) {
            return false;
        }
        relayer[address(_wallet)].executedTx[_signHash] = true;
        return true;
    }

    /**
    * @dev Checks that a nonce has the correct format and is valid. 
    * It must be constructed as nonce = {block number}{timestamp} where each component is 16 bytes.
    * @param _wallet The target wallet.
    * @param _nonce The nonce
    */
    function checkAndUpdateNonce(BaseWallet _wallet, uint256 _nonce) internal returns (bool) {
        if(_nonce <= relayer[address(_wallet)].nonce) {
            return false;
        }   
        uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
        if(nonceBlock > block.number + BLOCKBOUND) {
            return false;
        }
        relayer[address(_wallet)].nonce = _nonce;
        return true;    
    }

    /**
    * @dev Recovers the signer at a given position from a list of concatenated signatures.
    * @param _signedHash The signed hash
    * @param _signatures The concatenated signatures.
    * @param _index The index of the signature to recover.
    */
    function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
        uint8 v;
        bytes32 r;
        bytes32 s;
        // we jump 32 (0x20) as the first slot of bytes contains the length
        // we jump 65 (0x41) per signature
        // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
            s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
            v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
        }
        require(v == 27 || v == 28); 
        return ecrecover(_signedHash, v, r, s);
    }

    /**
    * @dev Refunds the gas used to the Relayer. 
    * For security reasons the default behavior is to not refund calls with 0 or 1 signatures. 
    * @param _wallet The target wallet.
    * @param _gasUsed The gas used.
    * @param _gasPrice The gas price for the refund.
    * @param _gasLimit The gas limit for the refund.
    * @param _signatures The number of signatures used in the call.
    * @param _relayer The address of the Relayer.
    */
    function refund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _gasLimit, uint _signatures, address _relayer) internal {
        uint256 amount = 29292 + _gasUsed; // 21000 (transaction) + 7620 (execution of refund) + 672 to log the event + _gasUsed
        // only refund if gas price not null, more than 1 signatures, gas less than gasLimit
        if(_gasPrice > 0 && _signatures > 1 && amount <= _gasLimit) {
            if(_gasPrice > tx.gasprice) {
                amount = amount * tx.gasprice;
            }
            else {
                amount = amount * _gasPrice;
            }
            _wallet.invoke(_relayer, amount, "");
        }
    }

    /**
    * @dev Returns false if the refund is expected to fail.
    * @param _wallet The target wallet.
    * @param _gasUsed The expected gas used.
    * @param _gasPrice The expected gas price for the refund.
    */
    function verifyRefund(BaseWallet _wallet, uint _gasUsed, uint _gasPrice, uint _signatures) internal view returns (bool) {
        if(_gasPrice > 0 
            && _signatures > 1 
            && (address(_wallet).balance < _gasUsed * _gasPrice || _wallet.authorised(address(this)) == false)) {
            return false;
        }
        return true;
    }

    /**
    * @dev Checks that the wallet address provided as the first parameter of the relayed data is the same
    * as the wallet passed as the input of the execute() method. 
    @return false if the addresses are different.
    */
    function verifyData(address _wallet, bytes memory _data) private pure returns (bool) {
        require(_data.length >= 36, "RM: Invalid dataWallet");
        address dataWallet;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            //_data = {length:32}{sig:4}{_wallet:32}{...}
            dataWallet := mload(add(_data, 0x24))
        }
        return dataWallet == _wallet;
    }

    /**
    * @dev Parses the data to extract the method signature. 
    */
    function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
        require(_data.length >= 4, "RM: Invalid functionPrefix");
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            prefix := mload(add(_data, 0x20))
        }
    }
}

/**
 * @title OnlyOwnerModule
 * @dev Module that extends BaseModule and RelayerModule for modules where the execute() method
 * must be called with one signature frm the owner.
 * @author Julien Niset - <julien@argent.im>
 */
contract OnlyOwnerModule is BaseModule, RelayerModule {

    // *************** Implementation of RelayerModule methods ********************* //

    // Overrides to use the incremental nonce and save some gas
    function checkAndUpdateUniqueness(BaseWallet _wallet, uint256 _nonce, bytes32 _signHash) internal returns (bool) {
        return checkAndUpdateNonce(_wallet, _nonce);
    }

    function validateSignatures(BaseWallet _wallet, bytes memory _data, bytes32 _signHash, bytes memory _signatures) internal view returns (bool) {
        address signer = recoverSigner(_signHash, _signatures, 0);
        return isOwner(_wallet, signer); // "OOM: signer must be owner"
    }

    function getRequiredSignatures(BaseWallet _wallet, bytes memory _data) internal view returns (uint256) {
        return 1;
    }
}

/**
 * @title CompoundManager
 * @dev Module to invest and borrow tokens with CompoundV2
 * @author Julien Niset - <julien@argent.xyz>
 */
contract CompoundManager is Loan, Invest, BaseModule, RelayerModule, OnlyOwnerModule {

    bytes32 constant NAME = "CompoundManager";

    // The Guardian storage contract
    GuardianStorage public guardianStorage;
    // The Compound Comptroller contract
    Comptroller public comptroller;
    // The registry mapping underlying with cTokens
    CompoundRegistry public compoundRegistry;

    // Mock token address for ETH
    address constant internal ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    using SafeMath for uint256;

    /**
     * @dev Throws if the wallet is locked.
     */
    modifier onlyWhenUnlocked(BaseWallet _wallet) {
        // solium-disable-next-line security/no-block-members
        require(!guardianStorage.isLocked(_wallet), "CompoundManager: wallet must be unlocked");
        _;
    }

    constructor(
        ModuleRegistry _registry,
        GuardianStorage _guardianStorage,
        Comptroller _comptroller,
        CompoundRegistry _compoundRegistry
    )
        BaseModule(_registry, NAME)
        public
    {
        guardianStorage = _guardianStorage;
        comptroller = _comptroller;
        compoundRegistry = _compoundRegistry;
    }

    /* ********************************** Implementation of Loan ************************************* */

    /**
     * @dev Opens a collateralized loan.
     * @param _wallet The target wallet.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral token provided.
     * @param _debtToken The token borrowed.
     * @param _debtAmount The amount of tokens borrowed.
     * @return bytes32(0) as Compound does not allow the creation of multiple loans.
     */
    function openLoan(
        BaseWallet _wallet,
        address _collateral,
        uint256 _collateralAmount,
        address _debtToken,
        uint256 _debtAmount
    ) 
        external 
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
        returns (bytes32 _loanId) 
    {
        address[] memory markets = new address[](2);
        markets[0] = compoundRegistry.getCToken(_collateral);
        markets[1] = compoundRegistry.getCToken(_debtToken);
        _wallet.invoke(address(comptroller), 0, abi.encodeWithSignature("enterMarkets(address[])", markets));
        mint(_wallet, markets[0], _collateral, _collateralAmount);
        borrow(_wallet, markets[1], _debtAmount);
        emit LoanOpened(address(_wallet), _loanId, _collateral, _collateralAmount, _debtToken, _debtAmount);
    }

    /**
     * @dev Closes the collateralized loan in all markets by repaying all debts (plus interest). Note that it does not redeem the collateral.
     * @param _wallet The target wallet.
     * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
     */
    function closeLoan(
        BaseWallet _wallet,
        bytes32 _loanId
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        address[] memory markets = comptroller.getAssetsIn(address(_wallet));
        for(uint i = 0; i < markets.length; i++) {
            address cToken = markets[i];
            uint debt = CToken(cToken).borrowBalanceCurrent(address(_wallet));
            if(debt > 0) {
                repayBorrow(_wallet, cToken, debt);
                uint collateral = CToken(cToken).balanceOf(address(_wallet));
                if(address(this).balance == 0) {	//inject FORCED TO RECEIVE ETHERS
                    _wallet.invoke(address(comptroller), 0, abi.encodeWithSignature("exitMarket(address)", address(cToken)));
                }
            }
        }
        emit LoanClosed(address(_wallet), _loanId);
    }

    /**
     * @dev Adds collateral to a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral to add.
     */
    function addCollateral(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _collateral, 
        uint256 _collateralAmount
    ) 
        external 
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        address cToken = compoundRegistry.getCToken(_collateral);
        enterMarketIfNeeded(_wallet, cToken, address(comptroller));
        mint(_wallet, cToken, _collateral, _collateralAmount);
        emit CollateralAdded(address(_wallet), _loanId, _collateral, _collateralAmount);
    }

    /**
     * @dev Removes collateral from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
     * @param _collateral The token used as a collateral.
     * @param _collateralAmount The amount of collateral to remove.
     */
    function removeCollateral(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _collateral, 
        uint256 _collateralAmount
    ) 
        external 
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        address cToken = compoundRegistry.getCToken(_collateral);
        redeemUnderlying(_wallet, cToken, _collateralAmount);
        exitMarketIfNeeded(_wallet, cToken, address(comptroller));
        emit CollateralRemoved(address(_wallet), _loanId, _collateral, _collateralAmount);
    }

    /**
     * @dev Increases the debt by borrowing more token from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
     * @param _debtToken The token borrowed.
     * @param _debtAmount The amount of token to borrow.
     */
    function addDebt(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _debtToken, 
        uint256 _debtAmount
    ) 
        external 
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        address dToken = compoundRegistry.getCToken(_debtToken);
        enterMarketIfNeeded(_wallet, dToken, address(comptroller));
        borrow(_wallet, dToken, _debtAmount);
        emit DebtAdded(address(_wallet), _loanId, _debtToken, _debtAmount);
    }

    /**
     * @dev Decreases the debt by repaying some token from a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans.
     * @param _debtToken The token to repay.
     * @param _debtAmount The amount of token to repay.
     */
    function removeDebt(
        BaseWallet _wallet, 
        bytes32 _loanId, 
        address _debtToken, 
        uint256 _debtAmount
    ) 
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        address dToken = compoundRegistry.getCToken(_debtToken);
        repayBorrow(_wallet, dToken, _debtAmount);
        exitMarketIfNeeded(_wallet, dToken, address(comptroller));
        emit DebtRemoved(address(_wallet), _loanId, _debtToken, _debtAmount);
    }

    /**
     * @dev Gets information about a loan identified by its ID.
     * @param _wallet The target wallet.
     * @param _loanId bytes32(0) as Compound does not allow the creation of multiple loans
     * @return a status [0: no loan, 1: loan is safe, 2: loan is unsafe and can be liquidated]
     * and a value (in ETH) representing the value that could still be borrowed when status = 1; or the value of the collateral 
     * that should be added to avoid liquidation when status = 2.  
     */
    function getLoan(
        BaseWallet _wallet, 
        bytes32 _loanId
    ) 
        external 
        view 
        returns (uint8 _status, uint256 _ethValue)
    {
        (uint error, uint liquidity, uint shortfall) = comptroller.getAccountLiquidity(address(_wallet));
        require(address(this).balance == 0, "Compound: failed to get account liquidity");	//inject FORCED TO RECEIVE ETHERS
        if(liquidity > 0) {
            return (1, liquidity);
        }
        if(shortfall > 0) {
            return (2, shortfall);
        }
        return (0,0);
    }

    /* ********************************** Implementation of Invest ************************************* */

    /**
     * @dev Invest tokens for a given period.
     * @param _wallet The target wallet.
     * @param _token The token address.
     * @param _amount The amount of tokens to invest.
     * @param _period The period over which the tokens may be locked in the investment (optional).
     * @return The exact amount of tokens that have been invested. 
     */
    function addInvestment(
        BaseWallet _wallet, 
        address _token, 
        uint256 _amount, 
        uint256 _period
    ) 
        external 
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
        returns (uint256 _invested)
    {
        address cToken = compoundRegistry.getCToken(_token);
        mint(_wallet, cToken, _token, _amount);
        _invested = _amount;
        emit InvestmentAdded(address(_wallet), _token, _amount, _period);
    }

    /**
     * @dev Exit invested postions.
     * @param _wallet The target wallet.
     * @param _token The token address.
     * @param _fraction The fraction of invested tokens to exit in per 10000. 
     */
    function removeInvestment(
        BaseWallet _wallet, 
        address _token, 
        uint256 _fraction
    )
        external
        onlyWalletOwner(_wallet)
        onlyWhenUnlocked(_wallet)
    {
        require(_fraction <= 10000, "CompoundV2: invalid fraction value");
        address cToken = compoundRegistry.getCToken(_token);
        uint shares = CToken(cToken).balanceOf(address(_wallet));
        redeem(_wallet, cToken, shares.mul(_fraction).div(10000));
        emit InvestmentRemoved(address(_wallet), _token, _fraction);
    }

    /**
     * @dev Get the amount of investment in a given token.
     * @param _wallet The target wallet.
     * @param _token The token address.
     * @return The value in tokens of the investment (including interests) and the time at which the investment can be removed.
     */
    function getInvestment(
        BaseWallet _wallet, 
        address _token
    ) 
        external 
        view
        returns (uint256 _tokenValue, uint256 _periodEnd) 
    {
        address cToken = compoundRegistry.getCToken(_token);
        uint amount = CToken(cToken).balanceOf(address(_wallet));
        uint exchangeRateMantissa = CToken(cToken).exchangeRateStored();
        _tokenValue = amount.mul(exchangeRateMantissa).div(10 ** 18);
        _periodEnd = 0;
    }

    /* ****************************************** Compound wrappers ******************************************* */

    /**
     * @dev Adds underlying tokens to a cToken contract.
     * @param _wallet The target wallet.
     * @param _cToken The cToken contract.
     * @param _token The underlying token.
     * @param _amount The amount of underlying token to add.
     */
    function mint(BaseWallet _wallet, address _cToken, address _token, uint256 _amount) internal {
        require(_cToken != address(0), "Compound: No market for target token");
        require(_amount > 0, "Compound: amount cannot be 0");
        if(_token == ETH_TOKEN_ADDRESS) {
            _wallet.invoke(_cToken, _amount, abi.encodeWithSignature("mint()"));
        }
        else {
            _wallet.invoke(_token, 0, abi.encodeWithSignature("approve(address,uint256)", _cToken, _amount));
            _wallet.invoke(_cToken, 0, abi.encodeWithSignature("mint(uint256)", _amount));
        }
    }

    /**
     * @dev Redeems underlying tokens from a cToken contract.
     * @param _wallet The target wallet.
     * @param _cToken The cToken contract.
     * @param _amount The amount of cToken to redeem.
     */
    function redeem(BaseWallet _wallet, address _cToken, uint256 _amount) internal {     
        require(_cToken != address(0), "Compound: No market for target token");   
        require(_amount > 0, "Compound: amount cannot be 0");
        _wallet.invoke(_cToken, 0, abi.encodeWithSignature("redeem(uint256)", _amount));
    }

    /**
     * @dev Redeems underlying tokens from a cToken contract.
     * @param _wallet The target wallet.
     * @param _cToken The cToken contract.
     * @param _amount The amount of underlying token to redeem.
     */
    function redeemUnderlying(BaseWallet _wallet, address _cToken, uint256 _amount) internal {     
        require(_cToken != address(0), "Compound: No market for target token");   
        require(_amount > 0, "Compound: amount cannot be 0");
        _wallet.invoke(_cToken, 0, abi.encodeWithSignature("redeemUnderlying(uint256)", _amount));
    }

    /**
     * @dev Borrows underlying tokens from a cToken contract.
     * @param _wallet The target wallet.
     * @param _cToken The cToken contract.
     * @param _amount The amount of underlying tokens to borrow.
     */
    function borrow(BaseWallet _wallet, address _cToken, uint256 _amount) internal {
        require(_cToken != address(0), "Compound: No market for target token");
        require(_amount > 0, "Compound: amount cannot be 0");
        _wallet.invoke(_cToken, 0, abi.encodeWithSignature("borrow(uint256)", _amount));
    }

    /**
     * @dev Repays some borrowed underlying tokens to a cToken contract.
     * @param _wallet The target wallet.
     * @param _cToken The cToken contract.
     * @param _amount The amount of underlying to repay.
     */
    function repayBorrow(BaseWallet _wallet, address _cToken, uint256 _amount) internal {
        require(_cToken != address(0), "Compound: No market for target token");
        require(_amount > 0, "Compound: amount cannot be 0");
        string memory symbol = CToken(_cToken).symbol();
        if(keccak256(abi.encodePacked(symbol)) == keccak256(abi.encodePacked("cETH"))) {
            _wallet.invoke(_cToken, _amount, abi.encodeWithSignature("repayBorrow()"));
        }
        else { 
            address token = CToken(_cToken).underlying();
            _wallet.invoke(token, 0, abi.encodeWithSignature("approve(address,uint256)", _cToken, _amount));
            _wallet.invoke(_cToken, 0, abi.encodeWithSignature("repayBorrow(uint256)", _amount));
        }
    }

    /**
     * @dev Enters a cToken market if it was not entered before.
     * @param _wallet The target wallet.
     * @param _cToken The cToken contract.
     * @param _comptroller The comptroller contract.
     */
    function enterMarketIfNeeded(BaseWallet _wallet, address _cToken, address _comptroller) internal {
        bool isEntered = Comptroller(_comptroller).checkMembership(address(_wallet), CToken(_cToken));
        if(!isEntered) {
            address[] memory market = new address[](1);
            market[0] = _cToken;
            _wallet.invoke(_comptroller, 0, abi.encodeWithSignature("enterMarkets(address[])", market));
        }
    }

    /**
     * @dev Exits a cToken market if there is no more collateral and debt.
     * @param _wallet The target wallet.
     * @param _cToken The cToken contract.
     * @param _comptroller The comptroller contract.
     */
    function exitMarketIfNeeded(BaseWallet _wallet, address _cToken, address _comptroller) internal {
        uint collateral = CToken(_cToken).balanceOf(address(_wallet));
        uint debt = CToken(_cToken).borrowBalanceStored(address(_wallet));
        if(collateral == 0 && debt == 0) {
            _wallet.invoke(_comptroller, 0, abi.encodeWithSignature("exitMarket(address)", _cToken));
        }
    }
}