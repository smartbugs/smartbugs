pragma solidity 0.5.2;

// File: contracts/ERC20Interface.sol

// https://github.com/ethereum/EIPs/issues/20
interface ERC20 {
    function totalSupply() external view returns (uint supply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    function decimals() external view returns(uint digits);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


contract ERC20WithSymbol is ERC20 {
    function symbol() external view returns (string memory _symbol);
}

// File: contracts/PermissionGroups.sol

contract PermissionGroups {

    address public admin;
    address public pendingAdmin;
    mapping(address=>bool) internal operators;
    mapping(address=>bool) internal alerters;
    address[] internal operatorsGroup;
    address[] internal alertersGroup;
    uint constant internal MAX_GROUP_SIZE = 50;

    constructor() public {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Operation limited to admin");
        _;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "Operation limited to operator");
        _;
    }

    modifier onlyAlerter() {
        require(alerters[msg.sender], "Operation limited to alerter");
        _;
    }

    function getOperators () external view returns(address[] memory) {
        return operatorsGroup;
    }

    function getAlerters () external view returns(address[] memory) {
        return alertersGroup;
    }

    event TransferAdminPending(address pendingAdmin);

    /**
     * @dev Allows the current admin to set the pendingAdmin address.
     * @param newAdmin The address to transfer ownership to.
     */
    function transferAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "admin address cannot be 0");
        emit TransferAdminPending(pendingAdmin);
        pendingAdmin = newAdmin;
    }

    /**
     * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
     * @param newAdmin The address to transfer ownership to.
     */
    function transferAdminQuickly(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "admin address cannot be 0");
        emit TransferAdminPending(newAdmin);
        emit AdminClaimed(newAdmin, admin);
        admin = newAdmin;
    }

    event AdminClaimed( address newAdmin, address previousAdmin);

    /**
     * @dev Allows the pendingAdmin address to finalize the change admin process.
     */
    function claimAdmin() public {
        require(pendingAdmin == msg.sender, "admin address cannot be 0");
        emit AdminClaimed(pendingAdmin, admin);
        admin = pendingAdmin;
        pendingAdmin = address(0);
    }

    event AlerterAdded (address newAlerter, bool isAdd);

    function addAlerter(address newAlerter) public onlyAdmin {
        // prevent duplicates.
        require(!alerters[newAlerter], "alerter already configured");
        require(
            alertersGroup.length < MAX_GROUP_SIZE,
            "alerter group exceeding maximum size"
        );

        emit AlerterAdded(newAlerter, true);
        alerters[newAlerter] = true;
        alertersGroup.push(newAlerter);
    }

    function removeAlerter (address alerter) public onlyAdmin {
        require(alerters[alerter], "alerter not configured");
        alerters[alerter] = false;

        for (uint i = 0; i < alertersGroup.length; ++i) {
            if (alertersGroup[i] == alerter) {
                alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
                alertersGroup.length--;
                emit AlerterAdded(alerter, false);
                break;
            }
        }
    }

    event OperatorAdded(address newOperator, bool isAdd);

    function addOperator(address newOperator) public onlyAdmin {
        // prevent duplicates.
        require(!operators[newOperator], "operator already configured");
        require(
            operatorsGroup.length < MAX_GROUP_SIZE,
            "operator group exceeding maximum size"
        );

        emit OperatorAdded(newOperator, true);
        operators[newOperator] = true;
        operatorsGroup.push(newOperator);
    }

    function removeOperator (address operator) public onlyAdmin {
        require(operators[operator], "operator not configured");
        operators[operator] = false;

        for (uint i = 0; i < operatorsGroup.length; ++i) {
            if (operatorsGroup[i] == operator) {
                operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
                operatorsGroup.length -= 1;
                emit OperatorAdded(operator, false);
                break;
            }
        }
    }
}

// File: contracts/Withdrawable.sol

/**
 * @title Contracts that should be able to recover tokens or ethers
 * @author Ilan Doron
 * @dev This allows to recover any tokens or Ethers received in a contract.
 * This will prevent any accidental loss of tokens.
 */
contract Withdrawable is PermissionGroups {

    event TokenWithdraw(
        ERC20 indexed token,
        uint amount,
        address indexed sendTo
    );

    /**
     * @dev Withdraw all ERC20 compatible tokens
     * @param token ERC20 The address of the token contract
     */
    function withdrawToken(ERC20 token, uint amount, address sendTo) external onlyAdmin {
        require(token.transfer(sendTo, amount), "Could not transfer tokens");
        emit TokenWithdraw(token, amount, sendTo);
    }

    event EtherWithdraw(
        uint amount,
        address indexed sendTo
    );

    /**
     * @dev Withdraw Ethers
     */
    function withdrawEther(uint amount, address payable sendTo) external onlyAdmin {
        sendTo.transfer(amount);
        emit EtherWithdraw(amount, sendTo);
    }
}

// File: @gnosis.pm/util-contracts/contracts/Proxy.sol

/// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
/// @author Alan Lu - <alan@gnosis.pm>
contract Proxied {
    address public masterCopy;
}

/// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
/// @author Stefan George - <stefan@gnosis.pm>
contract Proxy is Proxied {
    /// @dev Constructor function sets address of master copy contract.
    /// @param _masterCopy Master copy address.
    constructor(address _masterCopy) public {
        require(_masterCopy != address(0), "The master copy is required");
        masterCopy = _masterCopy;
    }

    /// @dev Fallback function forwards all transactions and returns all received return data.
    function() external payable {
        address _masterCopy = masterCopy;
        assembly {
            calldatacopy(0, 0, calldatasize)
            let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
            returndatacopy(0, 0, returndatasize)
            switch success
                case 0 {
                    revert(0, returndatasize)
                }
                default {
                    return(0, returndatasize)
                }
        }
    }
}

// File: @gnosis.pm/util-contracts/contracts/Token.sol

/// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
pragma solidity ^0.5.2;

/// @title Abstract token contract - Functions to be implemented by token contracts
contract Token {
    /*
     *  Events
     */
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    /*
     *  Public functions
     */
    function transfer(address to, uint value) public returns (bool);
    function transferFrom(address from, address to, uint value) public returns (bool);
    function approve(address spender, uint value) public returns (bool);
    function balanceOf(address owner) public view returns (uint);
    function allowance(address owner, address spender) public view returns (uint);
    function totalSupply() public view returns (uint);
}

// File: @gnosis.pm/util-contracts/contracts/Math.sol

/// @title Math library - Allows calculation of logarithmic and exponential functions
/// @author Alan Lu - <alan.lu@gnosis.pm>
/// @author Stefan George - <stefan@gnosis.pm>
library GnosisMath {
    /*
     *  Constants
     */
    // This is equal to 1 in our calculations
    uint public constant ONE = 0x10000000000000000;
    uint public constant LN2 = 0xb17217f7d1cf79ac;
    uint public constant LOG2_E = 0x171547652b82fe177;

    /*
     *  Public functions
     */
    /// @dev Returns natural exponential function value of given x
    /// @param x x
    /// @return e**x
    function exp(int x) public pure returns (uint) {
        // revert if x is > MAX_POWER, where
        // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
        require(x <= 2454971259878909886679);
        // return 0 if exp(x) is tiny, using
        // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
        if (x < -818323753292969962227) return 0;
        // Transform so that e^x -> 2^x
        x = x * int(ONE) / int(LN2);
        // 2^x = 2^whole(x) * 2^frac(x)
        //       ^^^^^^^^^^ is a bit shift
        // so Taylor expand on z = frac(x)
        int shift;
        uint z;
        if (x >= 0) {
            shift = x / int(ONE);
            z = uint(x % int(ONE));
        } else {
            shift = x / int(ONE) - 1;
            z = ONE - uint(-x % int(ONE));
        }
        // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
        //
        // Can generate the z coefficients using mpmath and the following lines
        // >>> from mpmath import mp
        // >>> mp.dps = 100
        // >>> ONE =  0x10000000000000000
        // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
        // 0xb17217f7d1cf79ab
        // 0x3d7f7bff058b1d50
        // 0xe35846b82505fc5
        // 0x276556df749cee5
        // 0x5761ff9e299cc4
        // 0xa184897c363c3
        uint zpow = z;
        uint result = ONE;
        result += 0xb17217f7d1cf79ab * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x3d7f7bff058b1d50 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0xe35846b82505fc5 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x276556df749cee5 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x5761ff9e299cc4 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0xa184897c363c3 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0xffe5fe2c4586 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x162c0223a5c8 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1b5253d395e * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1e4cf5158b * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1e8cac735 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1c3bd650 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x1816193 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x131496 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0xe1b7 * zpow / ONE;
        zpow = zpow * z / ONE;
        result += 0x9c7 * zpow / ONE;
        if (shift >= 0) {
            if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
            return result << shift;
        } else return result >> (-shift);
    }

    /// @dev Returns natural logarithm value of given x
    /// @param x x
    /// @return ln(x)
    function ln(uint x) public pure returns (int) {
        require(x > 0);
        // binary search for floor(log2(x))
        int ilog2 = floorLog2(x);
        int z;
        if (ilog2 < 0) z = int(x << uint(-ilog2));
        else z = int(x >> uint(ilog2));
        // z = x * 2^-1log1x1
        // so 1 <= z < 2
        // and ln z = ln x - 1log1x1/log1e
        // so just compute ln z using artanh series
        // and calculate ln x from that
        int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
        int halflnz = term;
        int termpow = term * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 3;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 5;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 7;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 9;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 11;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 13;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 15;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 17;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 19;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 21;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 23;
        termpow = termpow * term / int(ONE) * term / int(ONE);
        halflnz += termpow / 25;
        return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
    }

    /// @dev Returns base 2 logarithm value of given x
    /// @param x x
    /// @return logarithmic value
    function floorLog2(uint x) public pure returns (int lo) {
        lo = -64;
        int hi = 193;
        // I use a shift here instead of / 2 because it floors instead of rounding towards 0
        int mid = (hi + lo) >> 1;
        while ((lo + 1) < hi) {
            if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
            else lo = mid;
            mid = (hi + lo) >> 1;
        }
    }

    /// @dev Returns maximum of an array
    /// @param nums Numbers to look through
    /// @return Maximum number
    function max(int[] memory nums) public pure returns (int maxNum) {
        require(nums.length > 0);
        maxNum = -2 ** 255;
        for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
    }

    /// @dev Returns whether an add operation causes an overflow
    /// @param a First addend
    /// @param b Second addend
    /// @return Did no overflow occur?
    function safeToAdd(uint a, uint b) internal pure returns (bool) {
        return a + b >= a;
    }

    /// @dev Returns whether a subtraction operation causes an underflow
    /// @param a Minuend
    /// @param b Subtrahend
    /// @return Did no underflow occur?
    function safeToSub(uint a, uint b) internal pure returns (bool) {
        return a >= b;
    }

    /// @dev Returns whether a multiply operation causes an overflow
    /// @param a First factor
    /// @param b Second factor
    /// @return Did no overflow occur?
    function safeToMul(uint a, uint b) internal pure returns (bool) {
        return b == 0 || a * b / b == a;
    }

    /// @dev Returns sum if no overflow occurred
    /// @param a First addend
    /// @param b Second addend
    /// @return Sum
    function add(uint a, uint b) internal pure returns (uint) {
        require(safeToAdd(a, b));
        return a + b;
    }

    /// @dev Returns difference if no overflow occurred
    /// @param a Minuend
    /// @param b Subtrahend
    /// @return Difference
    function sub(uint a, uint b) internal pure returns (uint) {
        require(safeToSub(a, b));
        return a - b;
    }

    /// @dev Returns product if no overflow occurred
    /// @param a First factor
    /// @param b Second factor
    /// @return Product
    function mul(uint a, uint b) internal pure returns (uint) {
        require(safeToMul(a, b));
        return a * b;
    }

    /// @dev Returns whether an add operation causes an overflow
    /// @param a First addend
    /// @param b Second addend
    /// @return Did no overflow occur?
    function safeToAdd(int a, int b) internal pure returns (bool) {
        return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
    }

    /// @dev Returns whether a subtraction operation causes an underflow
    /// @param a Minuend
    /// @param b Subtrahend
    /// @return Did no underflow occur?
    function safeToSub(int a, int b) internal pure returns (bool) {
        return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
    }

    /// @dev Returns whether a multiply operation causes an overflow
    /// @param a First factor
    /// @param b Second factor
    /// @return Did no overflow occur?
    function safeToMul(int a, int b) internal pure returns (bool) {
        return (b == 0) || (a * b / b == a);
    }

    /// @dev Returns sum if no overflow occurred
    /// @param a First addend
    /// @param b Second addend
    /// @return Sum
    function add(int a, int b) internal pure returns (int) {
        require(safeToAdd(a, b));
        return a + b;
    }

    /// @dev Returns difference if no overflow occurred
    /// @param a Minuend
    /// @param b Subtrahend
    /// @return Difference
    function sub(int a, int b) internal pure returns (int) {
        require(safeToSub(a, b));
        return a - b;
    }

    /// @dev Returns product if no overflow occurred
    /// @param a First factor
    /// @param b Second factor
    /// @return Product
    function mul(int a, int b) internal pure returns (int) {
        require(safeToMul(a, b));
        return a * b;
    }
}

// File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol

/**
 * Deprecated: Use Open Zeppeling one instead
 */
contract StandardTokenData {
    /*
     *  Storage
     */
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    uint totalTokens;
}

/**
 * Deprecated: Use Open Zeppeling one instead
 */
/// @title Standard token contract with overflow protection
contract GnosisStandardToken is Token, StandardTokenData {
    using GnosisMath for *;

    /*
     *  Public functions
     */
    /// @dev Transfers sender's tokens to a given address. Returns success
    /// @param to Address of token receiver
    /// @param value Number of tokens to transfer
    /// @return Was transfer successful?
    function transfer(address to, uint value) public returns (bool) {
        if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
            return false;
        }

        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
    /// @param from Address from where tokens are withdrawn
    /// @param to Address to where tokens are sent
    /// @param value Number of tokens to transfer
    /// @return Was transfer successful?
    function transferFrom(address from, address to, uint value) public returns (bool) {
        if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
            value
        ) || !balances[to].safeToAdd(value)) {
            return false;
        }
        balances[from] -= value;
        allowances[from][msg.sender] -= value;
        balances[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    /// @dev Sets approved amount of tokens for spender. Returns success
    /// @param spender Address of allowed account
    /// @param value Number of approved tokens
    /// @return Was approval successful?
    function approve(address spender, uint value) public returns (bool) {
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /// @dev Returns number of allowed tokens for given address
    /// @param owner Address of token owner
    /// @param spender Address of token spender
    /// @return Remaining allowance for spender
    function allowance(address owner, address spender) public view returns (uint) {
        return allowances[owner][spender];
    }

    /// @dev Returns number of tokens owned by given address
    /// @param owner Address of token owner
    /// @return Balance of owner
    function balanceOf(address owner) public view returns (uint) {
        return balances[owner];
    }

    /// @dev Returns total supply of tokens
    /// @return Total supply
    function totalSupply() public view returns (uint) {
        return totalTokens;
    }
}

// File: @gnosis.pm/dx-contracts/contracts/TokenFRT.sol

/// @title Standard token contract with overflow protection
contract TokenFRT is Proxied, GnosisStandardToken {
    address public owner;

    string public constant symbol = "MGN";
    string public constant name = "Magnolia Token";
    uint8 public constant decimals = 18;

    struct UnlockedToken {
        uint amountUnlocked;
        uint withdrawalTime;
    }

    /*
     *  Storage
     */
    address public minter;

    // user => UnlockedToken
    mapping(address => UnlockedToken) public unlockedTokens;

    // user => amount
    mapping(address => uint) public lockedTokenBalances;

    /*
     *  Public functions
     */

    // @dev allows to set the minter of Magnolia tokens once.
    // @param   _minter the minter of the Magnolia tokens, should be the DX-proxy
    function updateMinter(address _minter) public {
        require(msg.sender == owner, "Only the minter can set a new one");
        require(_minter != address(0), "The new minter must be a valid address");

        minter = _minter;
    }

    // @dev the intention is to set the owner as the DX-proxy, once it is deployed
    // Then only an update of the DX-proxy contract after a 30 days delay could change the minter again.
    function updateOwner(address _owner) public {
        require(msg.sender == owner, "Only the owner can update the owner");
        require(_owner != address(0), "The new owner must be a valid address");
        owner = _owner;
    }

    function mintTokens(address user, uint amount) public {
        require(msg.sender == minter, "Only the minter can mint tokens");

        lockedTokenBalances[user] = add(lockedTokenBalances[user], amount);
        totalTokens = add(totalTokens, amount);
    }

    /// @dev Lock Token
    function lockTokens(uint amount) public returns (uint totalAmountLocked) {
        // Adjust amount by balance
        uint actualAmount = min(amount, balances[msg.sender]);

        // Update state variables
        balances[msg.sender] = sub(balances[msg.sender], actualAmount);
        lockedTokenBalances[msg.sender] = add(lockedTokenBalances[msg.sender], actualAmount);

        // Get return variable
        totalAmountLocked = lockedTokenBalances[msg.sender];
    }

    function unlockTokens() public returns (uint totalAmountUnlocked, uint withdrawalTime) {
        // Adjust amount by locked balances
        uint amount = lockedTokenBalances[msg.sender];

        if (amount > 0) {
            // Update state variables
            lockedTokenBalances[msg.sender] = sub(lockedTokenBalances[msg.sender], amount);
            unlockedTokens[msg.sender].amountUnlocked = add(unlockedTokens[msg.sender].amountUnlocked, amount);
            unlockedTokens[msg.sender].withdrawalTime = now + 24 hours;
        }

        // Get return variables
        totalAmountUnlocked = unlockedTokens[msg.sender].amountUnlocked;
        withdrawalTime = unlockedTokens[msg.sender].withdrawalTime;
    }

    function withdrawUnlockedTokens() public {
        require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
        balances[msg.sender] = add(balances[msg.sender], unlockedTokens[msg.sender].amountUnlocked);
        unlockedTokens[msg.sender].amountUnlocked = 0;
    }

    function min(uint a, uint b) public pure returns (uint) {
        if (a < b) {
            return a;
        } else {
            return b;
        }
    }
    
    /// @dev Returns whether an add operation causes an overflow
    /// @param a First addend
    /// @param b Second addend
    /// @return Did no overflow occur?
    function safeToAdd(uint a, uint b) public pure returns (bool) {
        return a + b >= a;
    }

    /// @dev Returns whether a subtraction operation causes an underflow
    /// @param a Minuend
    /// @param b Subtrahend
    /// @return Did no underflow occur?
    function safeToSub(uint a, uint b) public pure returns (bool) {
        return a >= b;
    }

    /// @dev Returns sum if no overflow occurred
    /// @param a First addend
    /// @param b Second addend
    /// @return Sum
    function add(uint a, uint b) public pure returns (uint) {
        require(safeToAdd(a, b), "It must be a safe adition");
        return a + b;
    }

    /// @dev Returns difference if no overflow occurred
    /// @param a Minuend
    /// @param b Subtrahend
    /// @return Difference
    function sub(uint a, uint b) public pure returns (uint) {
        require(safeToSub(a, b), "It must be a safe substraction");
        return a - b;
    }
}

// File: @gnosis.pm/owl-token/contracts/TokenOWL.sol

contract TokenOWL is Proxied, GnosisStandardToken {
    using GnosisMath for *;

    string public constant name = "OWL Token";
    string public constant symbol = "OWL";
    uint8 public constant decimals = 18;

    struct masterCopyCountdownType {
        address masterCopy;
        uint timeWhenAvailable;
    }

    masterCopyCountdownType masterCopyCountdown;

    address public creator;
    address public minter;

    event Minted(address indexed to, uint256 amount);
    event Burnt(address indexed from, address indexed user, uint256 amount);

    modifier onlyCreator() {
        // R1
        require(msg.sender == creator, "Only the creator can perform the transaction");
        _;
    }
    /// @dev trickers the update process via the proxyMaster for a new address _masterCopy
    /// updating is only possible after 30 days
    function startMasterCopyCountdown(address _masterCopy) public onlyCreator {
        require(address(_masterCopy) != address(0), "The master copy must be a valid address");

        // Update masterCopyCountdown
        masterCopyCountdown.masterCopy = _masterCopy;
        masterCopyCountdown.timeWhenAvailable = now + 30 days;
    }

    /// @dev executes the update process via the proxyMaster for a new address _masterCopy
    function updateMasterCopy() public onlyCreator {
        require(address(masterCopyCountdown.masterCopy) != address(0), "The master copy must be a valid address");
        require(
            block.timestamp >= masterCopyCountdown.timeWhenAvailable,
            "It's not possible to update the master copy during the waiting period"
        );

        // Update masterCopy
        masterCopy = masterCopyCountdown.masterCopy;
    }

    function getMasterCopy() public view returns (address) {
        return masterCopy;
    }

    /// @dev Set minter. Only the creator of this contract can call this.
    /// @param newMinter The new address authorized to mint this token
    function setMinter(address newMinter) public onlyCreator {
        minter = newMinter;
    }

    /// @dev change owner/creator of the contract. Only the creator/owner of this contract can call this.
    /// @param newOwner The new address, which should become the owner
    function setNewOwner(address newOwner) public onlyCreator {
        creator = newOwner;
    }

    /// @dev Mints OWL.
    /// @param to Address to which the minted token will be given
    /// @param amount Amount of OWL to be minted
    function mintOWL(address to, uint amount) public {
        require(minter != address(0), "The minter must be initialized");
        require(msg.sender == minter, "Only the minter can mint OWL");
        balances[to] = balances[to].add(amount);
        totalTokens = totalTokens.add(amount);
        emit Minted(to, amount);
    }

    /// @dev Burns OWL.
    /// @param user Address of OWL owner
    /// @param amount Amount of OWL to be burnt
    function burnOWL(address user, uint amount) public {
        allowances[user][msg.sender] = allowances[user][msg.sender].sub(amount);
        balances[user] = balances[user].sub(amount);
        totalTokens = totalTokens.sub(amount);
        emit Burnt(msg.sender, user, amount);
    }
}

// File: @gnosis.pm/dx-contracts/contracts/base/SafeTransfer.sol

interface BadToken {
    function transfer(address to, uint value) external;
    function transferFrom(address from, address to, uint value) external;
}

contract SafeTransfer {
    function safeTransfer(address token, address to, uint value, bool from) internal returns (bool result) {
        if (from) {
            BadToken(token).transferFrom(msg.sender, address(this), value);
        } else {
            BadToken(token).transfer(to, value);
        }

        // solium-disable-next-line security/no-inline-assembly
        assembly {
            switch returndatasize
                case 0 {
                    // This is our BadToken
                    result := not(0) // result is true
                }
                case 32 {
                    // This is our GoodToken
                    returndatacopy(0, 0, 32)
                    result := mload(0) // result == returndata of external call
                }
                default {
                    // This is not an ERC20 token
                    result := 0
                }
        }
        return result;
    }
}

// File: @gnosis.pm/dx-contracts/contracts/base/AuctioneerManaged.sol

contract AuctioneerManaged {
    // auctioneer has the power to manage some variables
    address public auctioneer;

    function updateAuctioneer(address _auctioneer) public onlyAuctioneer {
        require(_auctioneer != address(0), "The auctioneer must be a valid address");
        auctioneer = _auctioneer;
    }

    // > Modifiers
    modifier onlyAuctioneer() {
        // Only allows auctioneer to proceed
        // R1
        // require(msg.sender == auctioneer, "Only auctioneer can perform this operation");
        require(msg.sender == auctioneer, "Only the auctioneer can nominate a new one");
        _;
    }
}

// File: @gnosis.pm/dx-contracts/contracts/base/TokenWhitelist.sol

contract TokenWhitelist is AuctioneerManaged {
    // Mapping that stores the tokens, which are approved
    // Only tokens approved by auctioneer generate frtToken tokens
    // addressToken => boolApproved
    mapping(address => bool) public approvedTokens;

    event Approval(address indexed token, bool approved);

    /// @dev for quick overview of approved Tokens
    /// @param addressesToCheck are the ERC-20 token addresses to be checked whether they are approved
    function getApprovedAddressesOfList(address[] calldata addressesToCheck) external view returns (bool[] memory) {
        uint length = addressesToCheck.length;

        bool[] memory isApproved = new bool[](length);

        for (uint i = 0; i < length; i++) {
            isApproved[i] = approvedTokens[addressesToCheck[i]];
        }

        return isApproved;
    }
    
    function updateApprovalOfToken(address[] memory token, bool approved) public onlyAuctioneer {
        for (uint i = 0; i < token.length; i++) {
            approvedTokens[token[i]] = approved;
            emit Approval(token[i], approved);
        }
    }

}

// File: @gnosis.pm/dx-contracts/contracts/base/DxMath.sol

contract DxMath {
    // > Math fns
    function min(uint a, uint b) public pure returns (uint) {
        if (a < b) {
            return a;
        } else {
            return b;
        }
    }

    function atleastZero(int a) public pure returns (uint) {
        if (a < 0) {
            return 0;
        } else {
            return uint(a);
        }
    }
    
    /// @dev Returns whether an add operation causes an overflow
    /// @param a First addend
    /// @param b Second addend
    /// @return Did no overflow occur?
    function safeToAdd(uint a, uint b) public pure returns (bool) {
        return a + b >= a;
    }

    /// @dev Returns whether a subtraction operation causes an underflow
    /// @param a Minuend
    /// @param b Subtrahend
    /// @return Did no underflow occur?
    function safeToSub(uint a, uint b) public pure returns (bool) {
        return a >= b;
    }

    /// @dev Returns whether a multiply operation causes an overflow
    /// @param a First factor
    /// @param b Second factor
    /// @return Did no overflow occur?
    function safeToMul(uint a, uint b) public pure returns (bool) {
        return b == 0 || a * b / b == a;
    }

    /// @dev Returns sum if no overflow occurred
    /// @param a First addend
    /// @param b Second addend
    /// @return Sum
    function add(uint a, uint b) public pure returns (uint) {
        require(safeToAdd(a, b));
        return a + b;
    }

    /// @dev Returns difference if no overflow occurred
    /// @param a Minuend
    /// @param b Subtrahend
    /// @return Difference
    function sub(uint a, uint b) public pure returns (uint) {
        require(safeToSub(a, b));
        return a - b;
    }

    /// @dev Returns product if no overflow occurred
    /// @param a First factor
    /// @param b Second factor
    /// @return Product
    function mul(uint a, uint b) public pure returns (uint) {
        require(safeToMul(a, b));
        return a * b;
    }
}

// File: @gnosis.pm/dx-contracts/contracts/Oracle/DSMath.sol

contract DSMath {
    /*
    standard uint256 functions
     */

    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assert((z = x + y) >= x);
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assert((z = x - y) <= x);
    }

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assert((z = x * y) >= x);
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
        z = x / y;
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x <= y ? x : y;
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        return x >= y ? x : y;
    }

    /*
    uint128 functions (h is for half)
     */

    function hadd(uint128 x, uint128 y) internal pure returns (uint128 z) {
        assert((z = x + y) >= x);
    }

    function hsub(uint128 x, uint128 y) internal pure returns (uint128 z) {
        assert((z = x - y) <= x);
    }

    function hmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
        assert((z = x * y) >= x);
    }

    function hdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
        z = x / y;
    }

    function hmin(uint128 x, uint128 y) internal pure returns (uint128 z) {
        return x <= y ? x : y;
    }

    function hmax(uint128 x, uint128 y) internal pure returns (uint128 z) {
        return x >= y ? x : y;
    }

    /*
    int256 functions
     */

    function imin(int256 x, int256 y) internal pure returns (int256 z) {
        return x <= y ? x : y;
    }

    function imax(int256 x, int256 y) internal pure returns (int256 z) {
        return x >= y ? x : y;
    }

    /*
    WAD math
     */

    uint128 constant WAD = 10 ** 18;

    function wadd(uint128 x, uint128 y) internal pure returns (uint128) {
        return hadd(x, y);
    }

    function wsub(uint128 x, uint128 y) internal pure returns (uint128) {
        return hsub(x, y);
    }

    function wmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
        z = cast((uint256(x) * y + WAD / 2) / WAD);
    }

    function wdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
        z = cast((uint256(x) * WAD + y / 2) / y);
    }

    function wmin(uint128 x, uint128 y) internal pure returns (uint128) {
        return hmin(x, y);
    }

    function wmax(uint128 x, uint128 y) internal pure returns (uint128) {
        return hmax(x, y);
    }

    /*
    RAY math
     */

    uint128 constant RAY = 10 ** 27;

    function radd(uint128 x, uint128 y) internal pure returns (uint128) {
        return hadd(x, y);
    }

    function rsub(uint128 x, uint128 y) internal pure returns (uint128) {
        return hsub(x, y);
    }

    function rmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
        z = cast((uint256(x) * y + RAY / 2) / RAY);
    }

    function rdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
        z = cast((uint256(x) * RAY + y / 2) / y);
    }

    function rpow(uint128 x, uint64 n) internal pure returns (uint128 z) {
        // This famous algorithm is called "exponentiation by squaring"
        // and calculates x^n with x as fixed-point and n as regular unsigned.
        //
        // It's O(log n), instead of O(n) for naive repeated multiplication.
        //
        // These facts are why it works:
        //
        //  If n is even, then x^n = (x^2)^(n/2).
        //  If n is odd,  then x^n = x * x^(n-1),
        //   and applying the equation for even x gives
        //    x^n = x * (x^2)^((n-1) / 2).
        //
        //  Also, EVM division is flooring and
        //    floor[(n-1) / 2] = floor[n / 2].

        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }

    function rmin(uint128 x, uint128 y) internal pure returns (uint128) {
        return hmin(x, y);
    }

    function rmax(uint128 x, uint128 y) internal pure returns (uint128) {
        return hmax(x, y);
    }

    function cast(uint256 x) internal pure returns (uint128 z) {
        assert((z = uint128(x)) == x);
    }

}

// File: @gnosis.pm/dx-contracts/contracts/Oracle/DSAuth.sol

contract DSAuthority {
    function canCall(address src, address dst, bytes4 sig) public view returns (bool);
}


contract DSAuthEvents {
    event LogSetAuthority(address indexed authority);
    event LogSetOwner(address indexed owner);
}


contract DSAuth is DSAuthEvents {
    DSAuthority public authority;
    address public owner;

    constructor() public {
        owner = msg.sender;
        emit LogSetOwner(msg.sender);
    }

    function setOwner(address owner_) public auth {
        owner = owner_;
        emit LogSetOwner(owner);
    }

    function setAuthority(DSAuthority authority_) public auth {
        authority = authority_;
        emit LogSetAuthority(address(authority));
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig), "It must be an authorized call");
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (src == address(this)) {
            return true;
        } else if (src == owner) {
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, address(this), sig);
        }
    }
}

// File: @gnosis.pm/dx-contracts/contracts/Oracle/DSNote.sol

contract DSNote {
    event LogNote(
        bytes4 indexed sig,
        address indexed guy,
        bytes32 indexed foo,
        bytes32 bar,
        uint wad,
        bytes fax
    );

    modifier note {
        bytes32 foo;
        bytes32 bar;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
        }

        emit LogNote(
            msg.sig,
            msg.sender,
            foo,
            bar,
            msg.value,
            msg.data
        );

        _;
    }
}

// File: @gnosis.pm/dx-contracts/contracts/Oracle/DSThing.sol

contract DSThing is DSAuth, DSNote, DSMath {}

// File: @gnosis.pm/dx-contracts/contracts/Oracle/PriceFeed.sol

/// price-feed.sol

// Copyright (C) 2017  DappHub, LLC

// Licensed under the Apache License, Version 2.0 (the "License").
// You may not use this file except in compliance with the License.

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).



contract PriceFeed is DSThing {
    uint128 val;
    uint32 public zzz;

    function peek() public view returns (bytes32, bool) {
        return (bytes32(uint256(val)), block.timestamp < zzz);
    }

    function read() public view returns (bytes32) {
        assert(block.timestamp < zzz);
        return bytes32(uint256(val));
    }

    function post(uint128 val_, uint32 zzz_, address med_) public payable note auth {
        val = val_;
        zzz = zzz_;
        (bool success, ) = (false, bytes(msg.data));
	 med_.call(abi.encodeWithSignature("poke()"));	//inject UNHANDLED EXCEPTION

        require(success, "The poke must succeed");
    }

    function void() public payable note auth {
        zzz = 0;
    }

}

// File: @gnosis.pm/dx-contracts/contracts/Oracle/DSValue.sol

contract DSValue is DSThing {
    bool has;
    bytes32 val;
    function peek() public view returns (bytes32, bool) {
        return (val, has);
    }

    function read() public view returns (bytes32) {
        (bytes32 wut, bool _has) = peek();
        assert(_has);
        return wut;
    }

    function poke(bytes32 wut) public payable note auth {
        val = wut;
        has = true;
    }

    function void() public payable note auth {
        // unset the value
        has = false;
    }
}

// File: @gnosis.pm/dx-contracts/contracts/Oracle/Medianizer.sol

contract Medianizer is DSValue {
    mapping(bytes12 => address) public values;
    mapping(address => bytes12) public indexes;
    bytes12 public next = bytes12(uint96(1));
    uint96 public minimun = 0x1;

    function set(address wat) public auth {
        bytes12 nextId = bytes12(uint96(next) + 1);
        assert(nextId != 0x0);
        set(next, wat);
        next = nextId;
    }

    function set(bytes12 pos, address wat) public payable note auth {
        require(pos != 0x0, "pos cannot be 0x0");
        require(wat == address(0) || indexes[wat] == 0, "wat is not defined or it has an index");

        indexes[values[pos]] = bytes12(0); // Making sure to remove a possible existing address in that position

        if (wat != address(0)) {
            indexes[wat] = pos;
        }

        values[pos] = wat;
    }

    function setMin(uint96 min_) public payable note auth {
        require(min_ != 0x0, "min cannot be 0x0");
        minimun = min_;
    }

    function setNext(bytes12 next_) public payable note auth {
        require(next_ != 0x0, "next cannot be 0x0");
        next = next_;
    }

    function unset(bytes12 pos) public {
        set(pos, address(0));
    }

    function unset(address wat) public {
        set(indexes[wat], address(0));
    }

    function poke() public {
        poke(0);
    }

    function poke(bytes32) public payable note {
        (val, has) = compute();
    }

    function compute() public view returns (bytes32, bool) {
        bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
        uint96 ctr = 0;
        for (uint96 i = 1; i < uint96(next); i++) {
            if (values[bytes12(i)] != address(0)) {
                (bytes32 wut, bool wuz) = DSValue(values[bytes12(i)]).peek();
                if (wuz) {
                    if (ctr == 0 || wut >= wuts[ctr - 1]) {
                        wuts[ctr] = wut;
                    } else {
                        uint96 j = 0;
                        while (wut >= wuts[j]) {
                            j++;
                        }
                        for (uint96 k = ctr; k > j; k--) {
                            wuts[k] = wuts[k - 1];
                        }
                        wuts[j] = wut;
                    }
                    ctr++;
                }
            }
        }

        if (ctr < minimun)
            return (val, false);

        bytes32 value;
        if (ctr % 2 == 0) {
            uint128 val1 = uint128(uint(wuts[(ctr / 2) - 1]));
            uint128 val2 = uint128(uint(wuts[ctr / 2]));
            value = bytes32(uint256(wdiv(hadd(val1, val2), 2 ether)));
        } else {
            value = wuts[(ctr - 1) / 2];
        }

        return (value, true);
    }
}

// File: @gnosis.pm/dx-contracts/contracts/Oracle/PriceOracleInterface.sol

/*
This contract is the interface between the MakerDAO priceFeed and our DX platform.
*/




contract PriceOracleInterface {
    address public priceFeedSource;
    address public owner;
    bool public emergencyMode;

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do the operation");
        _;
    }

    /// @dev constructor of the contract
    /// @param _priceFeedSource address of price Feed Source -> should be maker feeds Medianizer contract
    constructor(address _owner, address _priceFeedSource) public {
        owner = _owner;
        priceFeedSource = _priceFeedSource;
    }
    
    /// @dev gives the owner the possibility to put the Interface into an emergencyMode, which will
    /// output always a price of 600 USD. This gives everyone time to set up a new pricefeed.
    function raiseEmergency(bool _emergencyMode) public onlyOwner {
        emergencyMode = _emergencyMode;
    }

    /// @dev updates the priceFeedSource
    /// @param _owner address of owner
    function updateCurator(address _owner) public onlyOwner {
        owner = _owner;
    }

    /// @dev returns the USDETH price
    function getUsdEthPricePeek() public view returns (bytes32 price, bool valid) {
        return Medianizer(priceFeedSource).peek();
    }

    /// @dev returns the USDETH price, ie gets the USD price from Maker feed with 18 digits, but last 18 digits are cut off
    function getUSDETHPrice() public view returns (uint256) {
        // if the contract is in the emergencyMode, because there is an issue with the oracle, we will simply return a price of 600 USD
        if (emergencyMode) {
            return 600;
        }
        (bytes32 price, ) = Medianizer(priceFeedSource).peek();

        // ensuring that there is no underflow or overflow possible,
        // even if the price is compromised
        uint priceUint = uint256(price)/(1 ether);
        if (priceUint == 0) {
            return 1;
        }
        if (priceUint > 1000000) {
            return 1000000; 
        }
        return priceUint;
    }
}

// File: @gnosis.pm/dx-contracts/contracts/base/EthOracle.sol

contract EthOracle is AuctioneerManaged, DxMath {
    uint constant WAITING_PERIOD_CHANGE_ORACLE = 30 days;

    // Price Oracle interface
    PriceOracleInterface public ethUSDOracle;
    // Price Oracle interface proposals during update process
    PriceOracleInterface public newProposalEthUSDOracle;

    uint public oracleInterfaceCountdown;

    event NewOracleProposal(PriceOracleInterface priceOracleInterface);

    function initiateEthUsdOracleUpdate(PriceOracleInterface _ethUSDOracle) public onlyAuctioneer {
        require(address(_ethUSDOracle) != address(0), "The oracle address must be valid");
        newProposalEthUSDOracle = _ethUSDOracle;
        oracleInterfaceCountdown = add(block.timestamp, WAITING_PERIOD_CHANGE_ORACLE);
        emit NewOracleProposal(_ethUSDOracle);
    }

    function updateEthUSDOracle() public {
        require(address(newProposalEthUSDOracle) != address(0), "The new proposal must be a valid addres");
        require(
            oracleInterfaceCountdown < block.timestamp,
            "It's not possible to update the oracle during the waiting period"
        );
        ethUSDOracle = newProposalEthUSDOracle;
        newProposalEthUSDOracle = PriceOracleInterface(0);
    }
}

// File: @gnosis.pm/dx-contracts/contracts/base/DxUpgrade.sol

contract DxUpgrade is Proxied, AuctioneerManaged, DxMath {
    uint constant WAITING_PERIOD_CHANGE_MASTERCOPY = 30 days;

    address public newMasterCopy;
    // Time when new masterCopy is updatabale
    uint public masterCopyCountdown;

    event NewMasterCopyProposal(address newMasterCopy);

    function startMasterCopyCountdown(address _masterCopy) public onlyAuctioneer {
        require(_masterCopy != address(0), "The new master copy must be a valid address");

        // Update masterCopyCountdown
        newMasterCopy = _masterCopy;
        masterCopyCountdown = add(block.timestamp, WAITING_PERIOD_CHANGE_MASTERCOPY);
        emit NewMasterCopyProposal(_masterCopy);
    }

    function updateMasterCopy() public {
        require(newMasterCopy != address(0), "The new master copy must be a valid address");
        require(block.timestamp >= masterCopyCountdown, "The master contract cannot be updated in a waiting period");

        // Update masterCopy
        masterCopy = newMasterCopy;
        newMasterCopy = address(0);
    }

}

// File: @gnosis.pm/dx-contracts/contracts/DutchExchange.sol

/// @title Dutch Exchange - exchange token pairs with the clever mechanism of the dutch auction
/// @author Alex Herrmann - <alex@gnosis.pm>
/// @author Dominik Teiml - <dominik@gnosis.pm>

contract DutchExchange is DxUpgrade, TokenWhitelist, EthOracle, SafeTransfer {

    // The price is a rational number, so we need a concept of a fraction
    struct Fraction {
        uint num;
        uint den;
    }

    uint constant WAITING_PERIOD_NEW_TOKEN_PAIR = 6 hours;
    uint constant WAITING_PERIOD_NEW_AUCTION = 10 minutes;
    uint constant AUCTION_START_WAITING_FOR_FUNDING = 1;

    // > Storage
    // Ether ERC-20 token
    address public ethToken;

    // Minimum required sell funding for adding a new token pair, in USD
    uint public thresholdNewTokenPair;
    // Minimum required sell funding for starting antoher auction, in USD
    uint public thresholdNewAuction;
    // Fee reduction token (magnolia, ERC-20 token)
    TokenFRT public frtToken;
    // Token for paying fees
    TokenOWL public owlToken;

    // For the following three mappings, there is one mapping for each token pair
    // The order which the tokens should be called is smaller, larger
    // These variables should never be called directly! They have getters below
    // Token => Token => index
    mapping(address => mapping(address => uint)) public latestAuctionIndices;
    // Token => Token => time
    mapping (address => mapping (address => uint)) public auctionStarts;
    // Token => Token => auctionIndex => time
    mapping (address => mapping (address => mapping (uint => uint))) public clearingTimes;

    // Token => Token => auctionIndex => price
    mapping(address => mapping(address => mapping(uint => Fraction))) public closingPrices;

    // Token => Token => amount
    mapping(address => mapping(address => uint)) public sellVolumesCurrent;
    // Token => Token => amount
    mapping(address => mapping(address => uint)) public sellVolumesNext;
    // Token => Token => amount
    mapping(address => mapping(address => uint)) public buyVolumes;

    // Token => user => amount
    // balances stores a user's balance in the DutchX
    mapping(address => mapping(address => uint)) public balances;

    // Token => Token => auctionIndex => amount
    mapping(address => mapping(address => mapping(uint => uint))) public extraTokens;

    // Token => Token =>  auctionIndex => user => amount
    mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
    mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
    mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;

    function depositAndSell(address sellToken, address buyToken, uint amount)
        external
        returns (uint newBal, uint auctionIndex, uint newSellerBal)
    {
        newBal = deposit(sellToken, amount);
        (auctionIndex, newSellerBal) = postSellOrder(sellToken, buyToken, 0, amount);
    }

    function claimAndWithdraw(address sellToken, address buyToken, address user, uint auctionIndex, uint amount)
        external
        returns (uint returned, uint frtsIssued, uint newBal)
    {
        (returned, frtsIssued) = claimSellerFunds(sellToken, buyToken, user, auctionIndex);
        newBal = withdraw(buyToken, amount);
    }

    /// @dev for multiple claims
    /// @param auctionSellTokens are the sellTokens defining an auctionPair
    /// @param auctionBuyTokens are the buyTokens defining an auctionPair
    /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
    /// @param user is the user who wants to his tokens
    function claimTokensFromSeveralAuctionsAsSeller(
        address[] calldata auctionSellTokens,
        address[] calldata auctionBuyTokens,
        uint[] calldata auctionIndices,
        address user
    ) external returns (uint[] memory, uint[] memory)
    {
        uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);

        uint[] memory claimAmounts = new uint[](length);
        uint[] memory frtsIssuedList = new uint[](length);

        for (uint i = 0; i < length; i++) {
            (claimAmounts[i], frtsIssuedList[i]) = claimSellerFunds(
                auctionSellTokens[i],
                auctionBuyTokens[i],
                user,
                auctionIndices[i]
            );
        }

        return (claimAmounts, frtsIssuedList);
    }

    /// @dev for multiple claims
    /// @param auctionSellTokens are the sellTokens defining an auctionPair
    /// @param auctionBuyTokens are the buyTokens defining an auctionPair
    /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
    /// @param user is the user who wants to his tokens
    function claimTokensFromSeveralAuctionsAsBuyer(
        address[] calldata auctionSellTokens,
        address[] calldata auctionBuyTokens,
        uint[] calldata auctionIndices,
        address user
    ) external returns (uint[] memory, uint[] memory)
    {
        uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);

        uint[] memory claimAmounts = new uint[](length);
        uint[] memory frtsIssuedList = new uint[](length);

        for (uint i = 0; i < length; i++) {
            (claimAmounts[i], frtsIssuedList[i]) = claimBuyerFunds(
                auctionSellTokens[i],
                auctionBuyTokens[i],
                user,
                auctionIndices[i]
            );
        }

        return (claimAmounts, frtsIssuedList);
    }

    /// @dev for multiple withdraws
    /// @param auctionSellTokens are the sellTokens defining an auctionPair
    /// @param auctionBuyTokens are the buyTokens defining an auctionPair
    /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
    function claimAndWithdrawTokensFromSeveralAuctionsAsSeller(
        address[] calldata auctionSellTokens,
        address[] calldata auctionBuyTokens,
        uint[] calldata auctionIndices
    ) external returns (uint[] memory, uint frtsIssued)
    {
        uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);

        uint[] memory claimAmounts = new uint[](length);
        uint claimFrts = 0;

        for (uint i = 0; i < length; i++) {
            (claimAmounts[i], claimFrts) = claimSellerFunds(
                auctionSellTokens[i],
                auctionBuyTokens[i],
                msg.sender,
                auctionIndices[i]
            );

            frtsIssued += claimFrts;

            withdraw(auctionBuyTokens[i], claimAmounts[i]);
        }

        return (claimAmounts, frtsIssued);
    }

    /// @dev for multiple withdraws
    /// @param auctionSellTokens are the sellTokens defining an auctionPair
    /// @param auctionBuyTokens are the buyTokens defining an auctionPair
    /// @param auctionIndices are the auction indices on which an token should be claimedAmounts
    function claimAndWithdrawTokensFromSeveralAuctionsAsBuyer(
        address[] calldata auctionSellTokens,
        address[] calldata auctionBuyTokens,
        uint[] calldata auctionIndices
    ) external returns (uint[] memory, uint frtsIssued)
    {
        uint length = checkLengthsForSeveralAuctionClaiming(auctionSellTokens, auctionBuyTokens, auctionIndices);

        uint[] memory claimAmounts = new uint[](length);
        uint claimFrts = 0;

        for (uint i = 0; i < length; i++) {
            (claimAmounts[i], claimFrts) = claimBuyerFunds(
                auctionSellTokens[i],
                auctionBuyTokens[i],
                msg.sender,
                auctionIndices[i]
            );

            frtsIssued += claimFrts;

            withdraw(auctionSellTokens[i], claimAmounts[i]);
        }

        return (claimAmounts, frtsIssued);
    }

    function getMasterCopy() external view returns (address) {
        return masterCopy;
    }

    /// @dev Constructor-Function creates exchange
    /// @param _frtToken - address of frtToken ERC-20 token
    /// @param _owlToken - address of owlToken ERC-20 token
    /// @param _auctioneer - auctioneer for managing interfaces
    /// @param _ethToken - address of ETH ERC-20 token
    /// @param _ethUSDOracle - address of the oracle contract for fetching feeds
    /// @param _thresholdNewTokenPair - Minimum required sell funding for adding a new token pair, in USD
    function setupDutchExchange(
        TokenFRT _frtToken,
        TokenOWL _owlToken,
        address _auctioneer,
        address _ethToken,
        PriceOracleInterface _ethUSDOracle,
        uint _thresholdNewTokenPair,
        uint _thresholdNewAuction
    ) public
    {
        // Make sure contract hasn't been initialised
        require(ethToken == address(0), "The contract must be uninitialized");

        // Validates inputs
        require(address(_owlToken) != address(0), "The OWL address must be valid");
        require(address(_frtToken) != address(0), "The FRT address must be valid");
        require(_auctioneer != address(0), "The auctioneer address must be valid");
        require(_ethToken != address(0), "The WETH address must be valid");
        require(address(_ethUSDOracle) != address(0), "The oracle address must be valid");

        frtToken = _frtToken;
        owlToken = _owlToken;
        auctioneer = _auctioneer;
        ethToken = _ethToken;
        ethUSDOracle = _ethUSDOracle;
        thresholdNewTokenPair = _thresholdNewTokenPair;
        thresholdNewAuction = _thresholdNewAuction;
    }

    function updateThresholdNewTokenPair(uint _thresholdNewTokenPair) public onlyAuctioneer {
        thresholdNewTokenPair = _thresholdNewTokenPair;
    }

    function updateThresholdNewAuction(uint _thresholdNewAuction) public onlyAuctioneer {
        thresholdNewAuction = _thresholdNewAuction;
    }

    /// @param initialClosingPriceNum initial price will be 2 * initialClosingPrice. This is its numerator
    /// @param initialClosingPriceDen initial price will be 2 * initialClosingPrice. This is its denominator
    function addTokenPair(
        address token1,
        address token2,
        uint token1Funding,
        uint token2Funding,
        uint initialClosingPriceNum,
        uint initialClosingPriceDen
    ) public
    {
        // R1
        require(token1 != token2, "You cannot add a token pair using the same token");

        // R2
        require(initialClosingPriceNum != 0, "You must set the numerator for the initial price");

        // R3
        require(initialClosingPriceDen != 0, "You must set the denominator for the initial price");

        // R4
        require(getAuctionIndex(token1, token2) == 0, "The token pair was already added");

        // R5: to prevent overflow
        require(initialClosingPriceNum < 10 ** 18, "You must set a smaller numerator for the initial price");

        // R6
        require(initialClosingPriceDen < 10 ** 18, "You must set a smaller denominator for the initial price");

        setAuctionIndex(token1, token2);

        token1Funding = min(token1Funding, balances[token1][msg.sender]);
        token2Funding = min(token2Funding, balances[token2][msg.sender]);

        // R7
        require(token1Funding < 10 ** 30, "You should use a smaller funding for token 1");

        // R8
        require(token2Funding < 10 ** 30, "You should use a smaller funding for token 2");

        uint fundedValueUSD;
        uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();

        // Compute fundedValueUSD
        address ethTokenMem = ethToken;
        if (token1 == ethTokenMem) {
            // C1
            // MUL: 10^30 * 10^6 = 10^36
            fundedValueUSD = mul(token1Funding, ethUSDPrice);
        } else if (token2 == ethTokenMem) {
            // C2
            // MUL: 10^30 * 10^6 = 10^36
            fundedValueUSD = mul(token2Funding, ethUSDPrice);
        } else {
            // C3: Neither token is ethToken
            fundedValueUSD = calculateFundedValueTokenToken(
                token1,
                token2,
                token1Funding,
                token2Funding,
                ethTokenMem,
                ethUSDPrice
            );
        }

        // R5
        require(fundedValueUSD >= thresholdNewTokenPair, "You should surplus the threshold for adding token pairs");

        // Save prices of opposite auctions
        closingPrices[token1][token2][0] = Fraction(initialClosingPriceNum, initialClosingPriceDen);
        closingPrices[token2][token1][0] = Fraction(initialClosingPriceDen, initialClosingPriceNum);

        // Split into two fns because of 16 local-var cap
        addTokenPairSecondPart(token1, token2, token1Funding, token2Funding);
    }

    function deposit(address tokenAddress, uint amount) public returns (uint) {
        // R1
        require(safeTransfer(tokenAddress, msg.sender, amount, true), "The deposit transaction must succeed");

        uint newBal = add(balances[tokenAddress][msg.sender], amount);

        balances[tokenAddress][msg.sender] = newBal;

        emit NewDeposit(tokenAddress, amount);

        return newBal;
    }

    function withdraw(address tokenAddress, uint amount) public returns (uint) {
        uint usersBalance = balances[tokenAddress][msg.sender];
        amount = min(amount, usersBalance);

        // R1
        require(amount > 0, "The amount must be greater than 0");

        uint newBal = sub(usersBalance, amount);
        balances[tokenAddress][msg.sender] = newBal;

        // R2
        require(safeTransfer(tokenAddress, msg.sender, amount, false), "The withdraw transfer must succeed");
        emit NewWithdrawal(tokenAddress, amount);

        return newBal;
    }

    function postSellOrder(address sellToken, address buyToken, uint auctionIndex, uint amount)
        public
        returns (uint, uint)
    {
        // Note: if a user specifies auctionIndex of 0, it
        // means he is agnostic which auction his sell order goes into

        amount = min(amount, balances[sellToken][msg.sender]);

        // R1
        // require(amount >= 0, "Sell amount should be greater than 0");

        // R2
        uint latestAuctionIndex = getAuctionIndex(sellToken, buyToken);
        require(latestAuctionIndex > 0);

        // R3
        uint auctionStart = getAuctionStart(sellToken, buyToken);
        if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING || auctionStart > now) {
            // C1: We are in the 10 minute buffer period
            // OR waiting for an auction to receive sufficient sellVolume
            // Auction has already cleared, and index has been incremented
            // sell order must use that auction index
            // R1.1
            if (auctionIndex == 0) {
                auctionIndex = latestAuctionIndex;
            } else {
                require(auctionIndex == latestAuctionIndex, "Auction index should be equal to latest auction index");
            }

            // R1.2
            require(add(sellVolumesCurrent[sellToken][buyToken], amount) < 10 ** 30);
        } else {
            // C2
            // R2.1: Sell orders must go to next auction
            if (auctionIndex == 0) {
                auctionIndex = latestAuctionIndex + 1;
            } else {
                require(auctionIndex == latestAuctionIndex + 1);
            }

            // R2.2
            require(add(sellVolumesNext[sellToken][buyToken], amount) < 10 ** 30);
        }

        // Fee mechanism, fees are added to extraTokens
        uint amountAfterFee = settleFee(sellToken, buyToken, auctionIndex, amount);

        // Update variables
        balances[sellToken][msg.sender] = sub(balances[sellToken][msg.sender], amount);
        uint newSellerBal = add(sellerBalances[sellToken][buyToken][auctionIndex][msg.sender], amountAfterFee);
        sellerBalances[sellToken][buyToken][auctionIndex][msg.sender] = newSellerBal;

        if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING || auctionStart > now) {
            // C1
            uint sellVolumeCurrent = sellVolumesCurrent[sellToken][buyToken];
            sellVolumesCurrent[sellToken][buyToken] = add(sellVolumeCurrent, amountAfterFee);
        } else {
            // C2
            uint sellVolumeNext = sellVolumesNext[sellToken][buyToken];
            sellVolumesNext[sellToken][buyToken] = add(sellVolumeNext, amountAfterFee);

            // close previous auction if theoretically closed
            closeTheoreticalClosedAuction(sellToken, buyToken, latestAuctionIndex);
        }

        if (auctionStart == AUCTION_START_WAITING_FOR_FUNDING) {
            scheduleNextAuction(sellToken, buyToken);
        }

        emit NewSellOrder(sellToken, buyToken, msg.sender, auctionIndex, amountAfterFee);

        return (auctionIndex, newSellerBal);
    }

    function postBuyOrder(address sellToken, address buyToken, uint auctionIndex, uint amount)
        public
        returns (uint newBuyerBal)
    {
        // R1: auction must not have cleared
        require(closingPrices[sellToken][buyToken][auctionIndex].den == 0);

        uint auctionStart = getAuctionStart(sellToken, buyToken);

        // R2
        require(auctionStart <= now);

        // R4
        require(auctionIndex == getAuctionIndex(sellToken, buyToken));

        // R5: auction must not be in waiting period
        require(auctionStart > AUCTION_START_WAITING_FOR_FUNDING);

        // R6: auction must be funded
        require(sellVolumesCurrent[sellToken][buyToken] > 0);

        uint buyVolume = buyVolumes[sellToken][buyToken];
        amount = min(amount, balances[buyToken][msg.sender]);

        // R7
        require(add(buyVolume, amount) < 10 ** 30);

        // Overbuy is when a part of a buy order clears an auction
        // In that case we only process the part before the overbuy
        // To calculate overbuy, we first get current price
        uint sellVolume = sellVolumesCurrent[sellToken][buyToken];

        uint num;
        uint den;
        (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
        // 10^30 * 10^37 = 10^67
        uint outstandingVolume = atleastZero(int(mul(sellVolume, num) / den - buyVolume));

        uint amountAfterFee;
        if (amount < outstandingVolume) {
            if (amount > 0) {
                amountAfterFee = settleFee(buyToken, sellToken, auctionIndex, amount);
            }
        } else {
            amount = outstandingVolume;
            amountAfterFee = outstandingVolume;
        }

        // Here we could also use outstandingVolume or amountAfterFee, it doesn't matter
        if (amount > 0) {
            // Update variables
            balances[buyToken][msg.sender] = sub(balances[buyToken][msg.sender], amount);
            newBuyerBal = add(buyerBalances[sellToken][buyToken][auctionIndex][msg.sender], amountAfterFee);
            buyerBalances[sellToken][buyToken][auctionIndex][msg.sender] = newBuyerBal;
            buyVolumes[sellToken][buyToken] = add(buyVolumes[sellToken][buyToken], amountAfterFee);
            emit NewBuyOrder(sellToken, buyToken, msg.sender, auctionIndex, amountAfterFee);
        }

        // Checking for equality would suffice here. nevertheless:
        if (amount >= outstandingVolume) {
            // Clear auction
            clearAuction(sellToken, buyToken, auctionIndex, sellVolume);
        }

        return (newBuyerBal);
    }

    function claimSellerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
        public
        returns (
        // < (10^60, 10^61)
        uint returned,
        uint frtsIssued
    )
    {
        closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
        uint sellerBalance = sellerBalances[sellToken][buyToken][auctionIndex][user];

        // R1
        require(sellerBalance > 0);

        // Get closing price for said auction
        Fraction memory closingPrice = closingPrices[sellToken][buyToken][auctionIndex];
        uint num = closingPrice.num;
        uint den = closingPrice.den;

        // R2: require auction to have cleared
        require(den > 0);

        // Calculate return
        // < 10^30 * 10^30 = 10^60
        returned = mul(sellerBalance, num) / den;

        frtsIssued = issueFrts(
            sellToken,
            buyToken,
            returned,
            auctionIndex,
            sellerBalance,
            user
        );

        // Claim tokens
        sellerBalances[sellToken][buyToken][auctionIndex][user] = 0;
        if (returned > 0) {
            balances[buyToken][user] = add(balances[buyToken][user], returned);
        }
        emit NewSellerFundsClaim(
            sellToken,
            buyToken,
            user,
            auctionIndex,
            returned,
            frtsIssued
        );
    }

    function claimBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
        public
        returns (uint returned, uint frtsIssued)
    {
        closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);

        uint num;
        uint den;
        (returned, num, den) = getUnclaimedBuyerFunds(sellToken, buyToken, user, auctionIndex);

        if (closingPrices[sellToken][buyToken][auctionIndex].den == 0) {
            // Auction is running
            claimedAmounts[sellToken][buyToken][auctionIndex][user] = add(
                claimedAmounts[sellToken][buyToken][auctionIndex][user],
                returned
            );
        } else {
            // Auction has closed
            // We DON'T want to check for returned > 0, because that would fail if a user claims
            // intermediate funds & auction clears in same block (he/she would not be able to claim extraTokens)

            // Assign extra sell tokens (this is possible only after auction has cleared,
            // because buyVolume could still increase before that)
            uint extraTokensTotal = extraTokens[sellToken][buyToken][auctionIndex];
            uint buyerBalance = buyerBalances[sellToken][buyToken][auctionIndex][user];

            // closingPrices.num represents buyVolume
            // < 10^30 * 10^30 = 10^60
            uint tokensExtra = mul(
                buyerBalance,
                extraTokensTotal
            ) / closingPrices[sellToken][buyToken][auctionIndex].num;
            returned = add(returned, tokensExtra);

            frtsIssued = issueFrts(
                buyToken,
                sellToken,
                mul(buyerBalance, den) / num,
                auctionIndex,
                buyerBalance,
                user
            );

            // Auction has closed
            // Reset buyerBalances and claimedAmounts
            buyerBalances[sellToken][buyToken][auctionIndex][user] = 0;
            claimedAmounts[sellToken][buyToken][auctionIndex][user] = 0;
        }

        // Claim tokens
        if (returned > 0) {
            balances[sellToken][user] = add(balances[sellToken][user], returned);
        }

        emit NewBuyerFundsClaim(
            sellToken,
            buyToken,
            user,
            auctionIndex,
            returned,
            frtsIssued
        );
    }

    /// @dev allows to close possible theoretical closed markets
    /// @param sellToken sellToken of an auction
    /// @param buyToken buyToken of an auction
    /// @param auctionIndex is the auctionIndex of the auction
    function closeTheoreticalClosedAuction(address sellToken, address buyToken, uint auctionIndex) public {
        if (auctionIndex == getAuctionIndex(
            buyToken,
            sellToken
        ) && closingPrices[sellToken][buyToken][auctionIndex].num == 0) {
            uint buyVolume = buyVolumes[sellToken][buyToken];
            uint sellVolume = sellVolumesCurrent[sellToken][buyToken];
            uint num;
            uint den;
            (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
            // 10^30 * 10^37 = 10^67
            if (sellVolume > 0) {
                uint outstandingVolume = atleastZero(int(mul(sellVolume, num) / den - buyVolume));

                if (outstandingVolume == 0) {
                    postBuyOrder(sellToken, buyToken, auctionIndex, 0);
                }
            }
        }
    }

    /// @dev Claim buyer funds for one auction
    function getUnclaimedBuyerFunds(address sellToken, address buyToken, address user, uint auctionIndex)
        public
        view
        returns (
        // < (10^67, 10^37)
        uint unclaimedBuyerFunds,
        uint num,
        uint den
    )
    {
        // R1: checks if particular auction has ever run
        require(auctionIndex <= getAuctionIndex(sellToken, buyToken));

        (num, den) = getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);

        if (num == 0) {
            // This should rarely happen - as long as there is >= 1 buy order,
            // auction will clear before price = 0. So this is just fail-safe
            unclaimedBuyerFunds = 0;
        } else {
            uint buyerBalance = buyerBalances[sellToken][buyToken][auctionIndex][user];
            // < 10^30 * 10^37 = 10^67
            unclaimedBuyerFunds = atleastZero(
                int(mul(buyerBalance, den) / num - claimedAmounts[sellToken][buyToken][auctionIndex][user])
            );
        }
    }

    function getFeeRatio(address user)
        public
        view
        returns (
        // feeRatio < 10^4
        uint num,
        uint den
    )
    {
        uint totalSupply = frtToken.totalSupply();
        uint lockedFrt = frtToken.lockedTokenBalances(user);

        /*
          Fee Model:
            locked FRT range     Fee
            -----------------   ------
            [0, 0.01%)           0.5%
            [0.01%, 0.1%)        0.4%
            [0.1%, 1%)           0.3%
            [1%, 10%)            0.2%
            [10%, 100%)          0.1%
        */

        if (lockedFrt * 10000 < totalSupply || totalSupply == 0) {
            // Maximum fee, if user has locked less than 0.01% of the total FRT
            // Fee: 0.5%
            num = 1;
            den = 200;
        } else if (lockedFrt * 1000 < totalSupply) {
            // If user has locked more than 0.01% and less than 0.1% of the total FRT
            // Fee: 0.4%
            num = 1;
            den = 250;
        } else if (lockedFrt * 100 < totalSupply) {
            // If user has locked more than 0.1% and less than 1% of the total FRT
            // Fee: 0.3%
            num = 3;
            den = 1000;
        } else if (lockedFrt * 10 < totalSupply) {
            // If user has locked more than 1% and less than 10% of the total FRT
            // Fee: 0.2%
            num = 1;
            den = 500;
        } else {
            // If user has locked more than 10% of the total FRT
            // Fee: 0.1%
            num = 1;
            den = 1000;
        }
    }

    //@ dev returns price in units [token2]/[token1]
    //@ param token1 first token for price calculation
    //@ param token2 second token for price calculation
    //@ param auctionIndex index for the auction to get the averaged price from
    function getPriceInPastAuction(
        address token1,
        address token2,
        uint auctionIndex
    )
        public
        view
        // price < 10^31
        returns (uint num, uint den)
    {
        if (token1 == token2) {
            // C1
            num = 1;
            den = 1;
        } else {
            // C2
            // R2.1
            // require(auctionIndex >= 0);

            // C3
            // R3.1
            require(auctionIndex <= getAuctionIndex(token1, token2));
            // auction still running

            uint i = 0;
            bool correctPair = false;
            Fraction memory closingPriceToken1;
            Fraction memory closingPriceToken2;

            while (!correctPair) {
                closingPriceToken2 = closingPrices[token2][token1][auctionIndex - i];
                closingPriceToken1 = closingPrices[token1][token2][auctionIndex - i];

                if (closingPriceToken1.num > 0 && closingPriceToken1.den > 0 ||
                    closingPriceToken2.num > 0 && closingPriceToken2.den > 0)
                {
                    correctPair = true;
                }
                i++;
            }

            // At this point at least one closing price is strictly positive
            // If only one is positive, we want to output that
            if (closingPriceToken1.num == 0 || closingPriceToken1.den == 0) {
                num = closingPriceToken2.den;
                den = closingPriceToken2.num;
            } else if (closingPriceToken2.num == 0 || closingPriceToken2.den == 0) {
                num = closingPriceToken1.num;
                den = closingPriceToken1.den;
            } else {
                // If both prices are positive, output weighted average
                num = closingPriceToken2.den + closingPriceToken1.num;
                den = closingPriceToken2.num + closingPriceToken1.den;
            }
        }
    }

    function scheduleNextAuction(
        address sellToken,
        address buyToken
    )
        internal
    {
        (uint sellVolume, uint sellVolumeOpp) = getSellVolumesInUSD(sellToken, buyToken);

        bool enoughSellVolume = sellVolume >= thresholdNewAuction;
        bool enoughSellVolumeOpp = sellVolumeOpp >= thresholdNewAuction;
        bool schedule;
        // Make sure both sides have liquidity in order to start the auction
        if (enoughSellVolume && enoughSellVolumeOpp) {
            schedule = true;
        } else if (enoughSellVolume || enoughSellVolumeOpp) {
            // But if the auction didn't start in 24h, then is enough to have
            // liquidity in one of the two sides
            uint latestAuctionIndex = getAuctionIndex(sellToken, buyToken);
            uint clearingTime = getClearingTime(sellToken, buyToken, latestAuctionIndex - 1);
            schedule = clearingTime <= now - 24 hours;
        }

        if (schedule) {
            // Schedule next auction
            setAuctionStart(sellToken, buyToken, WAITING_PERIOD_NEW_AUCTION);
        } else {
            resetAuctionStart(sellToken, buyToken);
        }
    }

    function getSellVolumesInUSD(
        address sellToken,
        address buyToken
    )
        internal
        view
        returns (uint sellVolume, uint sellVolumeOpp)
    {
        // Check if auctions received enough sell orders
        uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();

        uint sellNum;
        uint sellDen;
        (sellNum, sellDen) = getPriceOfTokenInLastAuction(sellToken);

        uint buyNum;
        uint buyDen;
        (buyNum, buyDen) = getPriceOfTokenInLastAuction(buyToken);

        // We use current sell volume, because in clearAuction() we set
        // sellVolumesCurrent = sellVolumesNext before calling this function
        // (this is so that we don't need case work,
        // since it might also be called from postSellOrder())

        // < 10^30 * 10^31 * 10^6 = 10^67
        sellVolume = mul(mul(sellVolumesCurrent[sellToken][buyToken], sellNum), ethUSDPrice) / sellDen;
        sellVolumeOpp = mul(mul(sellVolumesCurrent[buyToken][sellToken], buyNum), ethUSDPrice) / buyDen;
    }

    /// @dev Gives best estimate for market price of a token in ETH of any price oracle on the Ethereum network
    /// @param token address of ERC-20 token
    /// @return Weighted average of closing prices of opposite Token-ethToken auctions, based on their sellVolume
    function getPriceOfTokenInLastAuction(address token)
        public
        view
        returns (
        // price < 10^31
        uint num,
        uint den
    )
    {
        uint latestAuctionIndex = getAuctionIndex(token, ethToken);
        // getPriceInPastAuction < 10^30
        (num, den) = getPriceInPastAuction(token, ethToken, latestAuctionIndex - 1);
    }

    function getCurrentAuctionPrice(address sellToken, address buyToken, uint auctionIndex)
        public
        view
        returns (
        // price < 10^37
        uint num,
        uint den
    )
    {
        Fraction memory closingPrice = closingPrices[sellToken][buyToken][auctionIndex];

        if (closingPrice.den != 0) {
            // Auction has closed
            (num, den) = (closingPrice.num, closingPrice.den);
        } else if (auctionIndex > getAuctionIndex(sellToken, buyToken)) {
            (num, den) = (0, 0);
        } else {
            // Auction is running
            uint pastNum;
            uint pastDen;
            (pastNum, pastDen) = getPriceInPastAuction(sellToken, buyToken, auctionIndex - 1);

            // If we're calling the function into an unstarted auction,
            // it will return the starting price of that auction
            uint timeElapsed = atleastZero(int(now - getAuctionStart(sellToken, buyToken)));

            // The numbers below are chosen such that
            // P(0 hrs) = 2 * lastClosingPrice, P(6 hrs) = lastClosingPrice, P(>=24 hrs) = 0

            // 10^5 * 10^31 = 10^36
            num = atleastZero(int((24 hours - timeElapsed) * pastNum));
            // 10^6 * 10^31 = 10^37
            den = mul((timeElapsed + 12 hours), pastDen);

            if (mul(num, sellVolumesCurrent[sellToken][buyToken]) <= mul(den, buyVolumes[sellToken][buyToken])) {
                num = buyVolumes[sellToken][buyToken];
                den = sellVolumesCurrent[sellToken][buyToken];
            }
        }
    }

    // > Helper fns
    function getTokenOrder(address token1, address token2) public pure returns (address, address) {
        if (token2 < token1) {
            (token1, token2) = (token2, token1);
        }

        return (token1, token2);
    }

    function getAuctionStart(address token1, address token2) public view returns (uint auctionStart) {
        (token1, token2) = getTokenOrder(token1, token2);
        auctionStart = auctionStarts[token1][token2];
    }

    function getAuctionIndex(address token1, address token2) public view returns (uint auctionIndex) {
        (token1, token2) = getTokenOrder(token1, token2);
        auctionIndex = latestAuctionIndices[token1][token2];
    }

    function calculateFundedValueTokenToken(
        address token1,
        address token2,
        uint token1Funding,
        uint token2Funding,
        address ethTokenMem,
        uint ethUSDPrice
    )
        internal
        view
        returns (uint fundedValueUSD)
    {
        // We require there to exist ethToken-Token auctions
        // R3.1
        require(getAuctionIndex(token1, ethTokenMem) > 0);

        // R3.2
        require(getAuctionIndex(token2, ethTokenMem) > 0);

        // Price of Token 1
        uint priceToken1Num;
        uint priceToken1Den;
        (priceToken1Num, priceToken1Den) = getPriceOfTokenInLastAuction(token1);

        // Price of Token 2
        uint priceToken2Num;
        uint priceToken2Den;
        (priceToken2Num, priceToken2Den) = getPriceOfTokenInLastAuction(token2);

        // Compute funded value in ethToken and USD
        // 10^30 * 10^30 = 10^60
        uint fundedValueETH = add(
            mul(token1Funding, priceToken1Num) / priceToken1Den,
            token2Funding * priceToken2Num / priceToken2Den
        );

        fundedValueUSD = mul(fundedValueETH, ethUSDPrice);
    }

    function addTokenPairSecondPart(
        address token1,
        address token2,
        uint token1Funding,
        uint token2Funding
    )
        internal
    {
        balances[token1][msg.sender] = sub(balances[token1][msg.sender], token1Funding);
        balances[token2][msg.sender] = sub(balances[token2][msg.sender], token2Funding);

        // Fee mechanism, fees are added to extraTokens
        uint token1FundingAfterFee = settleFee(token1, token2, 1, token1Funding);
        uint token2FundingAfterFee = settleFee(token2, token1, 1, token2Funding);

        // Update other variables
        sellVolumesCurrent[token1][token2] = token1FundingAfterFee;
        sellVolumesCurrent[token2][token1] = token2FundingAfterFee;
        sellerBalances[token1][token2][1][msg.sender] = token1FundingAfterFee;
        sellerBalances[token2][token1][1][msg.sender] = token2FundingAfterFee;

        // Save clearingTime as adding time
        (address tokenA, address tokenB) = getTokenOrder(token1, token2);
        clearingTimes[tokenA][tokenB][0] = now;

        setAuctionStart(token1, token2, WAITING_PERIOD_NEW_TOKEN_PAIR);
        emit NewTokenPair(token1, token2);
    }

    function setClearingTime(
        address token1,
        address token2,
        uint auctionIndex,
        uint auctionStart,
        uint sellVolume,
        uint buyVolume
    )
        internal
    {
        (uint pastNum, uint pastDen) = getPriceInPastAuction(token1, token2, auctionIndex - 1);
        // timeElapsed = (12 hours)*(2 * pastNum * sellVolume - buyVolume * pastDen)/
            // (sellVolume * pastNum + buyVolume * pastDen)
        uint numerator = sub(mul(mul(pastNum, sellVolume), 24 hours), mul(mul(buyVolume, pastDen), 12 hours));
        uint timeElapsed = numerator / (add(mul(sellVolume, pastNum), mul(buyVolume, pastDen)));
        uint clearingTime = auctionStart + timeElapsed;
        (token1, token2) = getTokenOrder(token1, token2);
        clearingTimes[token1][token2][auctionIndex] = clearingTime;
    }

    function getClearingTime(
        address token1,
        address token2,
        uint auctionIndex
    )
        public
        view
        returns (uint time)
    {
        (token1, token2) = getTokenOrder(token1, token2);
        time = clearingTimes[token1][token2][auctionIndex];
    }

    function issueFrts(
        address primaryToken,
        address secondaryToken,
        uint x,
        uint auctionIndex,
        uint bal,
        address user
    )
        internal
        returns (uint frtsIssued)
    {
        if (approvedTokens[primaryToken] && approvedTokens[secondaryToken]) {
            address ethTokenMem = ethToken;
            // Get frts issued based on ETH price of returned tokens
            if (primaryToken == ethTokenMem) {
                frtsIssued = bal;
            } else if (secondaryToken == ethTokenMem) {
                // 10^30 * 10^39 = 10^66
                frtsIssued = x;
            } else {
                // Neither token is ethToken, so we use getHhistoricalPriceOracle()
                uint pastNum;
                uint pastDen;
                (pastNum, pastDen) = getPriceInPastAuction(primaryToken, ethTokenMem, auctionIndex - 1);
                // 10^30 * 10^35 = 10^65
                frtsIssued = mul(bal, pastNum) / pastDen;
            }

            if (frtsIssued > 0) {
                // Issue frtToken
                frtToken.mintTokens(user, frtsIssued);
            }
        }
    }

    function settleFee(address primaryToken, address secondaryToken, uint auctionIndex, uint amount)
        internal
        returns (
        // < 10^30
        uint amountAfterFee
    )
    {
        uint feeNum;
        uint feeDen;
        (feeNum, feeDen) = getFeeRatio(msg.sender);
        // 10^30 * 10^3 / 10^4 = 10^29
        uint fee = mul(amount, feeNum) / feeDen;

        if (fee > 0) {
            fee = settleFeeSecondPart(primaryToken, fee);

            uint usersExtraTokens = extraTokens[primaryToken][secondaryToken][auctionIndex + 1];
            extraTokens[primaryToken][secondaryToken][auctionIndex + 1] = add(usersExtraTokens, fee);

            emit Fee(primaryToken, secondaryToken, msg.sender, auctionIndex, fee);
        }

        amountAfterFee = sub(amount, fee);
    }

    function settleFeeSecondPart(address primaryToken, uint fee) internal returns (uint newFee) {
        // Allow user to reduce up to half of the fee with owlToken
        uint num;
        uint den;
        (num, den) = getPriceOfTokenInLastAuction(primaryToken);

        // Convert fee to ETH, then USD
        // 10^29 * 10^30 / 10^30 = 10^29
        uint feeInETH = mul(fee, num) / den;

        uint ethUSDPrice = ethUSDOracle.getUSDETHPrice();
        // 10^29 * 10^6 = 10^35
        // Uses 18 decimal places <> exactly as owlToken tokens: 10**18 owlToken == 1 USD
        uint feeInUSD = mul(feeInETH, ethUSDPrice);
        uint amountOfowlTokenBurned = min(owlToken.allowance(msg.sender, address(this)), feeInUSD / 2);
        amountOfowlTokenBurned = min(owlToken.balanceOf(msg.sender), amountOfowlTokenBurned);

        if (amountOfowlTokenBurned > 0) {
            owlToken.burnOWL(msg.sender, amountOfowlTokenBurned);
            // Adjust fee
            // 10^35 * 10^29 = 10^64
            uint adjustment = mul(amountOfowlTokenBurned, fee) / feeInUSD;
            newFee = sub(fee, adjustment);
        } else {
            newFee = fee;
        }
    }

    // addClearTimes
    /// @dev clears an Auction
    /// @param sellToken sellToken of the auction
    /// @param buyToken  buyToken of the auction
    /// @param auctionIndex of the auction to be cleared.
    function clearAuction(
        address sellToken,
        address buyToken,
        uint auctionIndex,
        uint sellVolume
    )
        internal
    {
        // Get variables
        uint buyVolume = buyVolumes[sellToken][buyToken];
        uint sellVolumeOpp = sellVolumesCurrent[buyToken][sellToken];
        uint closingPriceOppDen = closingPrices[buyToken][sellToken][auctionIndex].den;
        uint auctionStart = getAuctionStart(sellToken, buyToken);

        // Update closing price
        if (sellVolume > 0) {
            closingPrices[sellToken][buyToken][auctionIndex] = Fraction(buyVolume, sellVolume);
        }

        // if (opposite is 0 auction OR price = 0 OR opposite auction cleared)
        // price = 0 happens if auction pair has been running for >= 24 hrs
        if (sellVolumeOpp == 0 || now >= auctionStart + 24 hours || closingPriceOppDen > 0) {
            // Close auction pair
            uint buyVolumeOpp = buyVolumes[buyToken][sellToken];
            if (closingPriceOppDen == 0 && sellVolumeOpp > 0) {
                // Save opposite price
                closingPrices[buyToken][sellToken][auctionIndex] = Fraction(buyVolumeOpp, sellVolumeOpp);
            }

            uint sellVolumeNext = sellVolumesNext[sellToken][buyToken];
            uint sellVolumeNextOpp = sellVolumesNext[buyToken][sellToken];

            // Update state variables for both auctions
            sellVolumesCurrent[sellToken][buyToken] = sellVolumeNext;
            if (sellVolumeNext > 0) {
                sellVolumesNext[sellToken][buyToken] = 0;
            }
            if (buyVolume > 0) {
                buyVolumes[sellToken][buyToken] = 0;
            }

            sellVolumesCurrent[buyToken][sellToken] = sellVolumeNextOpp;
            if (sellVolumeNextOpp > 0) {
                sellVolumesNext[buyToken][sellToken] = 0;
            }
            if (buyVolumeOpp > 0) {
                buyVolumes[buyToken][sellToken] = 0;
            }

            // Save clearing time
            setClearingTime(sellToken, buyToken, auctionIndex, auctionStart, sellVolume, buyVolume);
            // Increment auction index
            setAuctionIndex(sellToken, buyToken);
            // Check if next auction can be scheduled
            scheduleNextAuction(sellToken, buyToken);
        }

        emit AuctionCleared(sellToken, buyToken, sellVolume, buyVolume, auctionIndex);
    }

    function setAuctionStart(address token1, address token2, uint value) internal {
        (token1, token2) = getTokenOrder(token1, token2);
        uint auctionStart = now + value;
        uint auctionIndex = latestAuctionIndices[token1][token2];
        auctionStarts[token1][token2] = auctionStart;
        emit AuctionStartScheduled(token1, token2, auctionIndex, auctionStart);
    }

    function resetAuctionStart(address token1, address token2) internal {
        (token1, token2) = getTokenOrder(token1, token2);
        if (auctionStarts[token1][token2] != AUCTION_START_WAITING_FOR_FUNDING) {
            auctionStarts[token1][token2] = AUCTION_START_WAITING_FOR_FUNDING;
        }
    }

    function setAuctionIndex(address token1, address token2) internal {
        (token1, token2) = getTokenOrder(token1, token2);
        latestAuctionIndices[token1][token2] += 1;
    }

    function checkLengthsForSeveralAuctionClaiming(
        address[] memory auctionSellTokens,
        address[] memory auctionBuyTokens,
        uint[] memory auctionIndices
    ) internal pure returns (uint length)
    {
        length = auctionSellTokens.length;
        uint length2 = auctionBuyTokens.length;
        require(length == length2);

        uint length3 = auctionIndices.length;
        require(length2 == length3);
    }

    // > Events
    event NewDeposit(address indexed token, uint amount);

    event NewWithdrawal(address indexed token, uint amount);

    event NewSellOrder(
        address indexed sellToken,
        address indexed buyToken,
        address indexed user,
        uint auctionIndex,
        uint amount
    );

    event NewBuyOrder(
        address indexed sellToken,
        address indexed buyToken,
        address indexed user,
        uint auctionIndex,
        uint amount
    );

    event NewSellerFundsClaim(
        address indexed sellToken,
        address indexed buyToken,
        address indexed user,
        uint auctionIndex,
        uint amount,
        uint frtsIssued
    );

    event NewBuyerFundsClaim(
        address indexed sellToken,
        address indexed buyToken,
        address indexed user,
        uint auctionIndex,
        uint amount,
        uint frtsIssued
    );

    event NewTokenPair(address indexed sellToken, address indexed buyToken);

    event AuctionCleared(
        address indexed sellToken,
        address indexed buyToken,
        uint sellVolume,
        uint buyVolume,
        uint indexed auctionIndex
    );

    event AuctionStartScheduled(
        address indexed sellToken,
        address indexed buyToken,
        uint indexed auctionIndex,
        uint auctionStart
    );

    event Fee(
        address indexed primaryToken,
        address indexed secondarToken,
        address indexed user,
        uint auctionIndex,
        uint fee
    );
}

// File: @gnosis.pm/util-contracts/contracts/EtherToken.sol

/// @title Token contract - Token exchanging Ether 1:1
/// @author Stefan George - <stefan@gnosis.pm>
contract EtherToken is GnosisStandardToken {
    using GnosisMath for *;

    /*
     *  Events
     */
    event Deposit(address indexed sender, uint value);
    event Withdrawal(address indexed receiver, uint value);

    /*
     *  Constants
     */
    string public constant name = "Ether Token";
    string public constant symbol = "ETH";
    uint8 public constant decimals = 18;

    /*
     *  Public functions
     */
    /// @dev Buys tokens with Ether, exchanging them 1:1
    function deposit() public payable {
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        totalTokens = totalTokens.add(msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    /// @dev Sells tokens in exchange for Ether, exchanging them 1:1
    /// @param value Number of tokens to sell
    function withdraw(uint value) public {
        // Balance covers value
        balances[msg.sender] = balances[msg.sender].sub(value);
        totalTokens = totalTokens.sub(value);
        msg.sender.transfer(value);
        emit Withdrawal(msg.sender, value);
    }
}

// File: contracts/KyberDxMarketMaker.sol

interface KyberNetworkProxy {
    function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty)
        external
        view
        returns (uint expectedRate, uint slippageRate);
}


contract KyberDxMarketMaker is Withdrawable {
    // This is the representation of ETH as an ERC20 Token for Kyber Network.
    ERC20 constant internal KYBER_ETH_TOKEN = ERC20(
        0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
    );

    // Declared in DutchExchange contract but not public.
    uint public constant DX_AUCTION_START_WAITING_FOR_FUNDING = 1;

    enum AuctionState {
        WAITING_FOR_FUNDING,
        WAITING_FOR_OPP_FUNDING,
        WAITING_FOR_SCHEDULED_AUCTION,
        AUCTION_IN_PROGRESS,
        WAITING_FOR_OPP_TO_FINISH,
        AUCTION_EXPIRED
    }

    // Exposing the enum values to external tools.
    AuctionState constant public WAITING_FOR_FUNDING = AuctionState.WAITING_FOR_FUNDING;
    AuctionState constant public WAITING_FOR_OPP_FUNDING = AuctionState.WAITING_FOR_OPP_FUNDING;
    AuctionState constant public WAITING_FOR_SCHEDULED_AUCTION = AuctionState.WAITING_FOR_SCHEDULED_AUCTION;
    AuctionState constant public AUCTION_IN_PROGRESS = AuctionState.AUCTION_IN_PROGRESS;
    AuctionState constant public WAITING_FOR_OPP_TO_FINISH = AuctionState.WAITING_FOR_OPP_TO_FINISH;
    AuctionState constant public AUCTION_EXPIRED = AuctionState.AUCTION_EXPIRED;

    DutchExchange public dx;
    EtherToken public weth;
    KyberNetworkProxy public kyberNetworkProxy;

    // Token => Token => auctionIndex
    mapping (address => mapping (address => uint)) public lastParticipatedAuction;

    constructor(
        DutchExchange _dx,
        KyberNetworkProxy _kyberNetworkProxy
    ) public {
        require(
            address(_dx) != address(0),
            "DutchExchange address cannot be 0"
        );
        require(
            address(_kyberNetworkProxy) != address(0),
            "KyberNetworkProxy address cannot be 0"
        );

        dx = DutchExchange(_dx);
        weth = EtherToken(dx.ethToken());
        kyberNetworkProxy = KyberNetworkProxy(_kyberNetworkProxy);
    }

    event KyberNetworkProxyUpdated(
        KyberNetworkProxy kyberNetworkProxy
    );

    function setKyberNetworkProxy(
        KyberNetworkProxy _kyberNetworkProxy
    )
        public
        onlyAdmin
        returns (bool)
    {
        require(
            address(_kyberNetworkProxy) != address(0),
            "KyberNetworkProxy address cannot be 0"
        );

        kyberNetworkProxy = _kyberNetworkProxy;
        emit KyberNetworkProxyUpdated(kyberNetworkProxy);
        return true;
    }

    event AmountDepositedToDx(
        address indexed token,
        uint amount
    );

    function depositToDx(
        address token,
        uint amount
    )
        public
        onlyOperator
        returns (uint)
    {
        require(ERC20(token).approve(address(dx), amount), "Cannot approve deposit");
        uint deposited = dx.deposit(token, amount);
        emit AmountDepositedToDx(token, deposited);
        return deposited;
    }

    event AmountWithdrawnFromDx(
        address indexed token,
        uint amount
    );

    function withdrawFromDx(
        address token,
        uint amount
    )
        public
        onlyOperator
        returns (uint)
    {
        uint withdrawn = dx.withdraw(token, amount);
        emit AmountWithdrawnFromDx(token, withdrawn);
        return withdrawn;
    }

    /**
      Claims funds from a specific auction.

      sellerFunds - the amount in token wei of *buyToken* that was returned.
      buyerFunds - the amount in token wei of *sellToken* that was returned.
      */
    function claimSpecificAuctionFunds(
        address sellToken,
        address buyToken,
        uint auctionIndex
    )
        public
        returns (uint sellerFunds, uint buyerFunds)
    {
        uint availableFunds;
        availableFunds = dx.sellerBalances(
            sellToken,
            buyToken,
            auctionIndex,
            address(this)
        );
        if (availableFunds > 0) {
            (sellerFunds, ) = dx.claimSellerFunds(
                sellToken,
                buyToken,
                address(this),
                auctionIndex
            );
        }

        availableFunds = dx.buyerBalances(
            sellToken,
            buyToken,
            auctionIndex,
            address(this)
        );
        if (availableFunds > 0) {
            (buyerFunds, ) = dx.claimBuyerFunds(
                sellToken,
                buyToken,
                address(this),
                auctionIndex
            );
        }
    }

    /**
        Participates in the auction by taking the appropriate step according to
        the auction state.

        Returns true if there is a step to be taken in this auction at this
        stage, false otherwise.
    */
    // TODO: consider removing onlyOperator limitation
    function step(
        address sellToken,
        address buyToken
    )
        public
        onlyOperator
        returns (bool)
    {
        // KyberNetworkProxy.getExpectedRate() always returns a rate between
        // tokens (and not between token wei as DutchX does).
        // For this reason the rate is currently compatible only for tokens that
        // have 18 decimals and is handled as though it is rate / 10**18.
        // TODO: handle tokens with number of decimals other than 18.
        require(
            ERC20(sellToken).decimals() == 18 && ERC20(buyToken).decimals() == 18,
            "Only 18 decimals tokens are supported"
        );

        // Deposit dxmm token balance to DutchX.
        depositAllBalance(sellToken);
        depositAllBalance(buyToken);

        AuctionState state = getAuctionState(sellToken, buyToken);
        uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
        emit CurrentAuctionState(sellToken, buyToken, auctionIndex, state);

        if (state == AuctionState.WAITING_FOR_FUNDING) {
            // Update the dutchX balance with the funds from the previous auction.
            claimSpecificAuctionFunds(
                sellToken,
                buyToken,
                lastParticipatedAuction[sellToken][buyToken]
            );
            require(fundAuctionDirection(sellToken, buyToken));
            return true;
        }

        if (state == AuctionState.WAITING_FOR_OPP_FUNDING ||
            state == AuctionState.WAITING_FOR_SCHEDULED_AUCTION) {
            return false;
        }

        if (state == AuctionState.AUCTION_IN_PROGRESS) {
            if (isPriceRightForBuying(sellToken, buyToken, auctionIndex)) {
                return buyInAuction(sellToken, buyToken);
            }
            return false;
        }

        if (state == AuctionState.WAITING_FOR_OPP_TO_FINISH) {
            return false;
        }

        if (state == AuctionState.AUCTION_EXPIRED) {
            dx.closeTheoreticalClosedAuction(sellToken, buyToken, auctionIndex);
            dx.closeTheoreticalClosedAuction(buyToken, sellToken, auctionIndex);
            return true;
        }

        // Should be unreachable.
        revert("Unknown auction state");
    }

    function willAmountClearAuction(
        address sellToken,
        address buyToken,
        uint auctionIndex,
        uint amount
    )
        public
        view
        returns (bool)
    {
        uint buyVolume = dx.buyVolumes(sellToken, buyToken);

        // Overbuy is when a part of a buy order clears an auction
        // In that case we only process the part before the overbuy
        // To calculate overbuy, we first get current price
        uint sellVolume = dx.sellVolumesCurrent(sellToken, buyToken);

        uint num;
        uint den;
        (num, den) = dx.getCurrentAuctionPrice(sellToken, buyToken, auctionIndex);
        // 10^30 * 10^37 = 10^67
        uint outstandingVolume = atleastZero(int(div(mul(sellVolume, num), sub(den, buyVolume))));
        return amount >= outstandingVolume;
    }

    // TODO: consider adding a "safety margin" to compensate for accuracy issues.
    function thresholdNewAuctionToken(
        address token
    )
        public
        view
        returns (uint)
    {
        uint priceTokenNum;
        uint priceTokenDen;
        (priceTokenNum, priceTokenDen) = dx.getPriceOfTokenInLastAuction(token);

        // TODO: maybe not add 1 if token is WETH
        // Rounding up to make sure we pass the threshold
        return 1 + div(
            // mul() takes care of overflows
            mul(
                dx.thresholdNewAuction(),
                priceTokenDen
            ),
            mul(
                dx.ethUSDOracle().getUSDETHPrice(),
                priceTokenNum
            )
        );
    }

    function calculateMissingTokenForAuctionStart(
        address sellToken,
        address buyToken
    )
        public
        view
        returns (uint)
    {
        uint currentAuctionSellVolume = dx.sellVolumesCurrent(sellToken, buyToken);
        uint thresholdTokenWei = thresholdNewAuctionToken(sellToken);

        if (thresholdTokenWei > currentAuctionSellVolume) {
            return sub(thresholdTokenWei, currentAuctionSellVolume);
        }

        return 0;
    }

    function addFee(
        uint amount
    )
        public
        view
        returns (uint)
    {
        uint num;
        uint den;
        (num, den) = dx.getFeeRatio(msg.sender);

        // amount / (1 - num / den)
        return div(
            mul(amount, den),
            sub(den, num)
        );
    }

    function getAuctionState(
        address sellToken,
        address buyToken
    )
        public
        view
        returns (AuctionState)
    {

        // Unfunded auctions have an auctionStart time equal to a constant (1)
        uint auctionStart = dx.getAuctionStart(sellToken, buyToken);
        if (auctionStart == DX_AUCTION_START_WAITING_FOR_FUNDING) {
            // Other side might also be not fully funded, but we're primarily
            // interested in this direction.
            if (calculateMissingTokenForAuctionStart(sellToken, buyToken) > 0) {
                return AuctionState.WAITING_FOR_FUNDING;
            } else {
                return AuctionState.WAITING_FOR_OPP_FUNDING;
            }
        }

        // DutchExchange logic uses auction start time.
        /* solhint-disable-next-line not-rely-on-time */
        if (auctionStart > now) {
            // After 24 hours have passed since last auction closed,
            // DutchExchange will trigger a new auction even if only the
            // opposite side is funded.
            // In these cases we want this side to be funded as well.
            if (calculateMissingTokenForAuctionStart(sellToken, buyToken) > 0) {
                return AuctionState.WAITING_FOR_FUNDING;
            } else {
                return AuctionState.WAITING_FOR_SCHEDULED_AUCTION;
            }
        }

        // If over 24 hours have passed, the auction is no longer viable and
        // should be closed.
        /* solhint-disable-next-line not-rely-on-time */
        if (now - auctionStart > 24 hours) {
            return AuctionState.AUCTION_EXPIRED;
        }

        uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
        uint closingPriceDen;
        (, closingPriceDen) = dx.closingPrices(sellToken, buyToken, auctionIndex);
        if (closingPriceDen == 0) {
            return AuctionState.AUCTION_IN_PROGRESS;
        }

        return AuctionState.WAITING_FOR_OPP_TO_FINISH;
    }

    function getKyberRate(
        address _sellToken,
        address _buyToken,
        uint amount
    )
        public
        view
        returns (uint num, uint den)
    {
        // KyberNetworkProxy.getExpectedRate() always returns a rate between
        // tokens (and not between token wei as DutchX does.
        // For this reason the rate is currently compatible only for tokens that
        // have 18 decimals and is handled as though it is rate / 10**18.
        // TODO: handle tokens with number of decimals other than 18.
        require(
            ERC20(_sellToken).decimals() == 18 && ERC20(_buyToken).decimals() == 18,
            "Only 18 decimals tokens are supported"
        );

        // Kyber uses a special constant address for representing ETH.
        ERC20 sellToken = _sellToken == address(weth) ? KYBER_ETH_TOKEN : ERC20(_sellToken);
        ERC20 buyToken = _buyToken == address(weth) ? KYBER_ETH_TOKEN : ERC20(_buyToken);
        uint rate;
        (rate, ) = kyberNetworkProxy.getExpectedRate(
            sellToken,
            buyToken,
            amount
        );

        return (rate, 10 ** 18);
    }

    function tokensSoldInCurrentAuction(
        address sellToken,
        address buyToken,
        uint auctionIndex,
        address account
    )
        public
        view
        returns (uint)
    {
        return dx.sellerBalances(sellToken, buyToken, auctionIndex, account);
    }

    // The amount of tokens that matches the amount sold by provided account in
    // specified auction index, deducting the amount that was already bought.
    function calculateAuctionBuyTokens(
        address sellToken,
        address buyToken,
        uint auctionIndex,
        address account
    )
        public
        view
        returns (uint)
    {
        uint sellVolume = tokensSoldInCurrentAuction(
            sellToken,
            buyToken,
            auctionIndex,
            account
        );

        uint num;
        uint den;
        (num, den) = dx.getCurrentAuctionPrice(
            sellToken,
            buyToken,
            auctionIndex
        );

        // No price for this auction, it is a future one.
        if (den == 0) return 0;

        uint wantedBuyVolume = div(mul(sellVolume, num), den);

        uint auctionSellVolume = dx.sellVolumesCurrent(sellToken, buyToken);
        uint buyVolume = dx.buyVolumes(sellToken, buyToken);
        uint outstandingBuyVolume = atleastZero(
            int(mul(auctionSellVolume, num) / den - buyVolume)
        );

        return wantedBuyVolume < outstandingBuyVolume
            ? wantedBuyVolume
            : outstandingBuyVolume;
    }

    function atleastZero(int a)
        public
        pure
        returns (uint)
    {
        if (a < 0) {
            return 0;
        } else {
            return uint(a);
        }
    }

    event AuctionDirectionFunded(
        address indexed sellToken,
        address indexed buyToken,
        uint indexed auctionIndex,
        uint sellTokenAmount,
        uint sellTokenAmountWithFee
    );

    function fundAuctionDirection(
        address sellToken,
        address buyToken
    )
        internal
        returns (bool)
    {
        uint missingTokens = calculateMissingTokenForAuctionStart(
            sellToken,
            buyToken
        );
        uint missingTokensWithFee = addFee(missingTokens);
        if (missingTokensWithFee == 0) return false;

        uint balance = dx.balances(sellToken, address(this));
        require(
            balance >= missingTokensWithFee,
            "Not enough tokens to fund auction direction"
        );

        uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
        dx.postSellOrder(sellToken, buyToken, auctionIndex, missingTokensWithFee);
        lastParticipatedAuction[sellToken][buyToken] = auctionIndex;

        emit AuctionDirectionFunded(
            sellToken,
            buyToken,
            auctionIndex,
            missingTokens,
            missingTokensWithFee
        );
        return true;
    }

    // TODO: check for all the requirements of dutchx
    event BoughtInAuction(
        address indexed sellToken,
        address indexed buyToken,
        uint auctionIndex,
        uint buyTokenAmount,
        bool clearedAuction
    );

    /**
        Will calculate the amount that the bot has sold in current auction and
        buy that amount.

        Returns false if ended up not buying.
        Reverts if no auction active or not enough tokens for buying.
    */
    function buyInAuction(
        address sellToken,
        address buyToken
    )
        internal
        returns (bool bought)
    {
        require(
            getAuctionState(sellToken, buyToken) == AuctionState.AUCTION_IN_PROGRESS,
            "No auction in progress"
        );

        uint auctionIndex = dx.getAuctionIndex(sellToken, buyToken);
        uint buyTokenAmount = calculateAuctionBuyTokens(
            sellToken,
            buyToken,
            auctionIndex,
            address(this)
        );

        if (buyTokenAmount == 0) {
            return false;
        }

        bool willClearAuction = willAmountClearAuction(
            sellToken,
            buyToken,
            auctionIndex,
            buyTokenAmount
        );
        if (!willClearAuction) {
            buyTokenAmount = addFee(buyTokenAmount);
        }

        require(
            dx.balances(buyToken, address(this)) >= buyTokenAmount,
            "Not enough buy token to buy required amount"
        );

        dx.postBuyOrder(sellToken, buyToken, auctionIndex, buyTokenAmount);
        emit BoughtInAuction(
            sellToken,
            buyToken,
            auctionIndex,
            buyTokenAmount,
            willClearAuction
        );
        return true;
    }

    function depositAllBalance(
        address token
    )
        internal
        returns (uint)
    {
        uint amount;
        uint balance = ERC20(token).balanceOf(address(this));
        if (balance > 0) {
            amount = depositToDx(token, balance);
        }
        return amount;
    }

    event CurrentAuctionState(
        address indexed sellToken,
        address indexed buyToken,
        uint auctionIndex,
        AuctionState auctionState
    );

    event PriceIsRightForBuying(
        address indexed sellToken,
        address indexed buyToken,
        uint auctionIndex,
        uint amount,
        uint dutchExchangePriceNum,
        uint dutchExchangePriceDen,
        uint kyberPriceNum,
        uint kyberPriceDen
    );

    function isPriceRightForBuying(
        address sellToken,
        address buyToken,
        uint auctionIndex
    )
        internal
        returns (bool)
    {
        uint amount = calculateAuctionBuyTokens(
            sellToken,
            buyToken,
            auctionIndex,
            address(this)
        );

        uint dNum;
        uint dDen;
        (dNum, dDen) = dx.getCurrentAuctionPrice(
            sellToken,
            buyToken,
            auctionIndex
        );

        uint kNum;
        uint kDen;
        (kNum, kDen) = getKyberRate(sellToken, buyToken, amount);

        // TODO: Check for overflow explicitly?
        bool shouldBuy = mul(dNum, kDen) <= mul(kNum, dDen);
        // TODO: should we add a boolean for shouldBuy?
        emit PriceIsRightForBuying(
            sellToken,
            buyToken,
            auctionIndex,
            amount,
            dNum,
            dDen,
            kNum,
            kDen
        );
        return shouldBuy;
    }

    // --- Safe Math functions ---
    // (https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol)
    /**
    * @dev Multiplies two numbers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero,
        // but the benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two numbers truncating the quotient, reverts on
        division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if
        subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }
}