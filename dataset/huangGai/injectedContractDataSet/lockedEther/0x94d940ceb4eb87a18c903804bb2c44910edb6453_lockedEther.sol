/**
 *Submitted for verification at Etherscan.io on 2020-04-09
*/

/*
|| <$> LexGrow (LXG) <$> || version 2

DEAR MSG.SENDER(S):

/ LXG is a project in beta.
// Please audit and use at your own risk.
/// Entry into LXG shall not create an attorney/client relationship.
//// Likewise, LXG should not be construed as legal advice or replacement for professional counsel.
///// STEAL THIS C0D3SL4W 

~presented by Open, ESQ || lexDAO LLC
*/

pragma solidity 0.5.14;

/***************
OPENZEPPELIN BASE CONTRACTS - Context, Role, SafeMath, IERC20 
***************/
/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
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
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

contract LexDAORole is Context {
    using Roles for Roles.Role;

    event LexDAOAdded(address indexed account);
    event LexDAORemoved(address indexed account);

    Roles.Role private _lexDAOs;
    
    constructor () internal {
        _addLexDAO(_msgSender());
    }

    modifier onlyLexDAO() {
        require(isLexDAO(_msgSender()), "LexDAORole: caller does not have the LexDAO role");
        _;
    }
    
    function isLexDAO(address account) public view returns (bool) {
        return _lexDAOs.has(account);
    }

    function addLexDAO(address account) public onlyLexDAO {
        _addLexDAO(account);
    }

    function renounceLexDAO() public {
        _removeLexDAO(_msgSender());
    }

    function _addLexDAO(address account) internal {
        _lexDAOs.add(account);
        emit LexDAOAdded(account);
    }

    function _removeLexDAO(address account) internal {
        _lexDAOs.remove(account);
        emit LexDAORemoved(account);
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

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
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

/***************
EARNINGS PROTOCOL CONTRACTS - Dai Savings Rate, Compound Finance
***************/
/**
 * @title Chai.money interface
 * @dev see https://github.com/dapphub/chai
 */
contract ICHAI {
    function balanceOf(address usr) external returns (uint);
    
    function transfer(address dst, uint wad) external returns (bool);

    function dai(address usr) external returns (uint wad);
    
    function dai(uint chai) external returns (uint wad);

    function join(address dst, uint wad) external;
}

/**
 * @title Compound interface
 * @dev see https://github.com/compound-developers/compound-supply-examples
 */
interface ICERC20 {
    function balanceOf(address account) external view returns (uint256);
    
    function transfer(address recipient, uint256 amount) external returns (bool);
    
    function mint(uint256) external returns (uint256);

    function exchangeRateCurrent() external returns (uint256);

    function supplyRatePerBlock() external returns (uint256);
}

/***************
LXG CONTRACT
***************/
contract LexGrow is LexDAORole { // Deal depositing for Digital Dollars that earn on DSR & Compound
    using SafeMath for uint256;
    
    /***************
    DSR Chai ERC-20 Wrapper: chai.money
    ***************/
    // $DAI details:
    address private daiToken = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    IERC20 public dai = IERC20(daiToken);
    
    // $CHAI details:
    address private chaiToken = 0x06AF07097C9Eeb7fD685c692751D5C66dB49c215;
    ICHAI public chai = ICHAI(chaiToken);
    
    // <$> LXG <$> details:
    address private vault = address(this);
    address payable public manager;
    uint8 public version = 2;
    uint256 public depositFee;
    uint256 public lxg; // index for registered LexGrow
    string public emoji = "11111";
    mapping (uint256 => Deposit) public deposit; 

    struct Deposit {  
        address client; 
        address provider;
        address compoundToken;
        uint256 amount;
        uint256 wrap;
        uint256 termination;
        uint256 index;
        string details; 
        bool dsr;
        bool disputed; 
        bool released;
    }
    	
    // LXG Contract Events:
    event Log(string, uint256); // log for Compound interactions
    event Registered(address indexed client, address indexed provider, uint256 indexed index);  
    event Released(uint256 indexed index); 
    event Disputed(uint256 indexed index, string indexed details); 
    event Resolved(address indexed resolver, uint256 indexed index, string indexed details); 
    event ManagerTransferred(address indexed manager, string indexed details);
    
    constructor () public {
        dai.approve(chaiToken, uint(-1));
        manager = msg.sender;
        depositFee = 0;
    } 
    
    /***************
    DEPOSIT FUNCTIONS
    ***************/
    function dealDepositDSR( // register $DAI deal deposit with DSR via $CHAI; arbitration via lexDAO	//injected LOCKED ETHER
        address provider,
        uint256 amount, 
        uint256 termination,
        string memory details) public payable {
        require(msg.value == depositFee);
	    uint256 index = lxg.add(1); 
	    lxg = lxg.add(1);
	    
	    dai.transferFrom(msg.sender, vault, amount); // deposit $DAI
        uint256 balance = chai.balanceOf(vault);
        chai.join(vault, amount); // wrap into $CHAI and store in vault
                
            deposit[index] = Deposit( // log deal deposit details
                msg.sender, 
                provider,
                chaiToken,
                amount, 
                chai.balanceOf(vault).sub(balance),
                termination,
                index,
                details,
                true,
                false, 
                false);
        
        address(manager).transfer(0);
        
        emit Registered(msg.sender, provider, index); 
    }
    
    function dealDepositCompound( // register $cToken deal deposit with interest via Compound; arbitration via lexDAO	//injected LOCKED ETHER
        address provider,
        address underlyingToken,
        address compoundToken,
        uint256 amount, 
        uint256 termination,
        string memory details) public payable returns (uint) {
        require(msg.value == depositFee);
	    
	    IERC20 uToken = IERC20(underlyingToken);
	    ICERC20 cToken = ICERC20(compoundToken);
	    
	    // Amount of current exchange rate from $cToken to underlying
        uint256 exchangeRateMantissa = cToken.exchangeRateCurrent();
        emit Log("Exchange Rate (scaled up by 1e18)", exchangeRateMantissa);
        
        // Amount added to supply balance this block
        uint256 supplyRateMantissa = cToken.supplyRatePerBlock();
        emit Log("Supply Rate: (scaled up by 1e18)", supplyRateMantissa);
	    
	    // Approve transfer on underlying ERC20 token contract
        uToken.approve(compoundToken, amount);
        
        // Mint cTokens
	    uToken.transferFrom(msg.sender, vault, amount); // deposit $uToken
	    uint256 balance = cToken.balanceOf(vault);
        uint mintResult = cToken.mint(amount); // wrap into $cToken and store in vault
        
        uint256 index = lxg.add(1); 
	    lxg = lxg.add(1);
                
            deposit[index] = Deposit( // log deal deposit details
                msg.sender, 
                provider,
                compoundToken,
                amount, 
                cToken.balanceOf(vault).sub(balance),
                termination,
                index,
                details, 
                false,
                false, 
                false);
        
        address(manager).transfer(0);
        
        emit Registered(msg.sender, provider, index);
        
        return mintResult; 
    }
    
    function release(uint256 index) public { 
    	Deposit storage depos = deposit[index];
	    require(depos.disputed == false); // program safety check / status
	    require(depos.released == false); // program safety check / status
    	require(now <= depos.termination); // program safety check / time
    	require(msg.sender == depos.client); // program safety check / authorization

        if (depos.dsr == true) {
            chai.transfer(depos.provider, depos.wrap);
        } else {
            ICERC20 cToken = ICERC20(depos.compoundToken);
            cToken.transfer(depos.provider, depos.wrap);
        }
        
        depos.released = true; 
        
	    emit Released(index); 
    }
    
    function withdraw(uint256 index) public { // withdraw deposit wrap if termination time passes
    	Deposit storage depos = deposit[index];
        require(depos.disputed == false); // program safety check / status
        require(depos.released == false); // program safety check / status
    	require(now >= depos.termination); // program safety check / time
        
        if (depos.dsr == true) {
            chai.transfer(depos.client, depos.wrap);
        } else {
            ICERC20 cToken = ICERC20(depos.compoundToken);
            cToken.transfer(depos.client, depos.wrap);
        }
        
        depos.released = true; 
        
	    emit Released(index); 
    }
    
    /***************
    ARBITRATION FUNCTIONS
    ***************/
    function dispute(uint256 index, string memory details) public {
        Deposit storage depos = deposit[index]; 
        require(depos.released == false); // program safety check / status
        require(now <= depos.termination); // program safety check / time
        require(msg.sender == depos.client || msg.sender == depos.provider); // program safety check / authorization

	    depos.disputed = true; 
	    
	    emit Disputed(index, details);
    }
    
    function resolve(uint256 index, uint256 clientAward, uint256 providerAward, string memory details) public onlyLexDAO {
        Deposit storage depos = deposit[index];
	    require(depos.disputed == true); // program safety check / status
	    require(depos.released == false); // program safety check / status
	    require(clientAward.add(providerAward) == depos.wrap); // program safety check / economics
        require(msg.sender != depos.client); // program safety check / authorization  
        require(msg.sender != depos.provider); // program safety check / authorization 
        
        if (depos.dsr == true) {
            chai.transfer(depos.client, clientAward); 
            chai.transfer(depos.provider, providerAward);
        } else {
            ICERC20 cToken = ICERC20(depos.compoundToken);
            cToken.transfer(depos.client, clientAward);
            cToken.transfer(depos.provider, providerAward);
        }
    
	    depos.released = true; 
	    
	    emit Resolved(msg.sender, index, details);
    }
    
    /***************
    MGMT FUNCTIONS
    ***************/
    function newDepositFee(uint256 weiAmount) public {
        require(msg.sender == manager);
        depositFee = weiAmount;
    }
    
    function transferManager(address payable newManager, string memory details) public {
        require(msg.sender == manager);
        manager = newManager; 
        
        emit ManagerTransferred(manager, details);
    }
}