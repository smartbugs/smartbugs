/**
 *Submitted for verification at Etherscan.io on 2020-03-29
*/

/*
|| <$> Dai Savings Escrow (DSE) <$> || version 1

DEAR MSG.SENDER(S):

/ DSE is a project in beta.
// Please audit and use at your own risk.
/// Entry into DSE shall not create an attorney/client relationship.
//// Likewise, DSE should not be construed as legal advice or replacement for professional counsel.
///// STEAL THIS C0D3SL4W 

~presented by Open, ESQ || lexDAO LLC
*/

pragma solidity ^0.5.14;	//inject UNLIMITED COMPILER VERSIONS

/***************
OPENZEPPELIN REFERENCE CONTRACTS - Context, Role, SafeMath, IERC20 
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
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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

/**
 * @title Chai.money interface
 * @dev see https://github.com/dapphub/chai
 */
contract IChai {
    function transfer(address dst, uint wad) external returns (bool);
    // like transferFrom but dai-denominated
    function move(address src, address dst, uint wad) external returns (bool);
    function transferFrom(address src, address dst, uint wad) public returns (bool);
    function approve(address usr, uint wad) external returns (bool);
    function balanceOf(address usr) external returns (uint);

    // Approve by signature
    function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;

    function dai(address usr) external returns (uint wad);
    function dai(uint chai) external returns (uint wad);

    // wad is denominated in dai
    function join(address dst, uint wad) external;

    // wad is denominated in (1/chi) * dai
    function exit(address src, uint wad) public;

    // wad is denominated in dai
    function draw(address src, uint wad) external returns (uint chai);
}

/***************
DSE CONTRACT
***************/
contract DaiSavingsEscrow is LexDAORole {  
    using SafeMath for uint256;
    
    // $DAI details:
    address private daiAddress = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    IERC20 public dai = IERC20(daiAddress);
    
    // $CHAI details:
    address private chaiAddress = 0x06AF07097C9Eeb7fD685c692751D5C66dB49c215;
    IChai public chai = IChai(chaiAddress);
    
    // <$> DSE <$> details:
    address private vault = address(this);
    address public proposedManager;
    address payable public manager;
    uint8 public version = 1;
    uint256 public escrowFee;
    uint256 public dse; // index for registered escrows
    string public emoji = "11111";
    mapping (uint256 => Escrow) public escrow; 

    struct Escrow {  
        address client; 
        address provider;
        uint256 payment;
        uint256 wrap;
        uint256 termination;
        uint256 index;
        string details; 
        bool disputed; 
        bool released;
    }
    	
    // DSE Contract Events:
    event Registered(address indexed client, address indexed provider, uint256 indexed index);  
    event Released(uint256 indexed index); 
    event Disputed(uint256 indexed index, string indexed details); 
    event Resolved(uint256 indexed index, string indexed details); 
    event ManagerProposed(address indexed proposedManager, string indexed details);
    event ManagerTransferred(address indexed manager, string indexed details);
    
    constructor () public {
        dai.approve(chaiAddress, uint(-1));
        manager = msg.sender;
        escrowFee = 0;
    } 
    
    /***************
    ESCROW FUNCTIONS
    ***************/
    function register( // register $DAI escrow with DSR via $CHAI; arbitration via lexDAO
        address provider,
        uint256 payment, 
        uint256 termination,
        string memory details) public payable {
        require(msg.value == escrowFee);
	    uint256 index = dse.add(1); 
	    dse = dse.add(1);
	    
	    dai.transferFrom(msg.sender, vault, payment); // deposit $DAI
        uint256 balance = chai.balanceOf(vault);
        chai.join(vault, payment); // wrap into $CHAI and store in vault
                
            escrow[index] = Escrow( 
                msg.sender, 
                provider,
                payment, 
                chai.balanceOf(vault).sub(balance),
                termination,
                index,
                details, 
                false, 
                false);
        
        address(manager).transfer(msg.value);
        
        emit Registered(msg.sender, provider, index); 
    }
    
    function release(uint256 index) public { 
    	Escrow storage escr = escrow[index];
	    require(escr.disputed == false); // program safety check / status
    	require(now <= escr.termination); // program safety check / time
    	require(msg.sender == escr.client); // program safety check / authorization

    	chai.transfer(escr.provider, escr.wrap); 
        
        escr.released = true; 
        
	    emit Released(index); 
    }
    
    function withdraw(uint256 index) public { // client can withdraw $CHAI if termination time passes
    	Escrow storage escr = escrow[index];
        require(escr.disputed == false); // program safety check / status
    	require(now >= escr.termination); // program safety check / time
    	require(msg.sender == escr.client); // program safety check / authorization
        
    	chai.transfer(escr.client, escr.wrap); 
        
        escr.released = true; 
        
	    emit Released(index); 
    }
    
    /***************
    ARBITRATION FUNCTIONS
    ***************/
    function dispute(uint256 index, string memory details) public {
        Escrow storage escr = escrow[index]; 
        require(escr.released == false); // program safety check / status
        require(now <= escr.termination); // program safety check / time
        require(msg.sender == escr.client || msg.sender == escr.provider); // program safety check / authorization

	    escr.disputed = true; 
	    
	    emit Disputed(index, details);
    }
    
    function resolve(uint256 index, uint256 clientAward, uint256 providerAward, string memory details) public onlyLexDAO {
        Escrow storage escr = escrow[index];
	    uint256 lexFee = escr.wrap.div(20); // calculates 5% lexDAO resolution fee
	    require(escr.disputed == true); // program safety check / status
	    require(clientAward.add(providerAward) == escr.wrap.sub(lexFee)); // program safety check / economics
        require(msg.sender != escr.client || msg.sender != escr.provider); // program safety check / authorization  
        
        chai.transfer(escr.client, clientAward); 
        chai.transfer(escr.provider, providerAward); 
    	chai.transfer(msg.sender, lexFee); 
    	
	    escr.released = true; 
	    
	    emit Resolved(index, details);
    }
    
    /***************
    MGMT FUNCTIONS
    ***************/
    function newEscrowFee(uint256 weiAmount) public {
        require(msg.sender == manager);
        escrowFee = weiAmount;
    }
    
    function proposeManager(address _proposedManager, string memory details) public {
        require(msg.sender == manager);
        proposedManager = _proposedManager; // proposed DSE beneficiary account
        
        emit ManagerProposed(proposedManager, details);
    }
    
    function transferManager(string memory details) public {
        require(msg.sender == proposedManager);
        manager = msg.sender; // accepting DSE beneficiary account
        
        emit ManagerTransferred(manager, details);
    }
}