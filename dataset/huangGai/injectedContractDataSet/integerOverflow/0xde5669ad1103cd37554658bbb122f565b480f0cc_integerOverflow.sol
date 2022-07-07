/**
 *Submitted for verification at Etherscan.io on 2020-08-20
*/

pragma solidity 0.7.0;

// SPDX-License-Identifier: UNLICENSED

//======================================================================

//  ######  ######  ######  ########
//  ##      ##  ##  ##         ##
//  #####   ##  ##  ##         ##
//  ##      ##  ##  ##  ##     ##
//  ######  ######  ######     ##
//              ##


//      The EQUUSMiningToken (EQMT) is a ERC20, this token has 100000000**18 as the total supply its use is key towards
//  staking as the staking is done by pooling ETH / EQMT on UniswapV2 giving the process a proof-of-stake, the token has no
//  burning (deflamatory) capabilities to maximize the pooling and staking on the token.

//      The EQUUSGovernanceToken is a ERC777 and ERC20 with staking capabilities and implementation of ERC1820Registry, 
//  this token has 0 as the total supply as it's gonna be mined by staking, the staking is done by staking the UniswapV2 
//  tokens from the pool shares of the pair ETH / EQMT, these UniswapV2 tokens are sent to EQUUSGovernanceToken's address, 
//  then an authorized Operator set by the owner address can verify the transaction externally to then allowing the holders 
//  stake their UniswapV2 coins on the EQUUSGovernanceToken network, depending on the time of staking and the amount staked 
//  the following operations are run to mint EQUUSGovernanceToken, the EQUUSGovernanceToken has a deflamatory burning 
//  process as a mining multiplier, the total supply will depend on the holders staking and mining functions.

//  FORMULA to mint
//  ((( totalStaked * hoursStaked) * ( 7.13 / 744 )) * rankMultiplier) * BurnBonusMultiplier


//  BurnBonusMultiplier
//  5   *   (burnAmount / (((( totalStaked * 744 ) * ( 7.13 / 744 )) / 1000) * 5000))


//  BurnBonusMultiplier Max Amount to Burn
//  (((( totalStaked * 744 ) * ( 7.13 / 744 )) / 1000) * 5000)

//  This process only burns the above max to give a x1, there is a max to do it till x5


//  RankMultiplier
//  Multiplier (x2) given after 744 hours (31 days) staked

//  The burnAmount is the amount of EQUUSGovernanceToken tokens that they for want to burn.

// To simulate this token on a testnet deploy ERC1820Registry, and a TEST UniswapV2 Token to set the constructor to recognise and interact the token in the code




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

/* IERC20 Standards followed by OpenZeppelin Group libraries on Github */

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








/* ERC777 Standards followed by OpenZeppelin Group libraries on Github */

/**
 * @dev Interface of the ERC777Token standard as defined in the EIP.
 *
 * This contract uses the
 * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 registry standard] to let
 * token holders and recipients react to token movements by using setting implementers
 * for the associated interfaces in said registry. See {IERC1820Registry} and
 * {ERC1820Implementer}.
 */
interface IERC777 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the smallest part of the token that is not divisible. This
     * means all token operations (creation, movement and destruction) must have
     * amounts that are a multiple of this number.
     *
     * For most token contracts, this value will equal 1.
     */
    function granularity() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by an account (`owner`).
     */
    function balanceOf(address owner) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * If send or receive hooks are registered for the caller and `recipient`,
     * the corresponding functions will be called with `data` and empty
     * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
     *
     * Emits a {Sent} event.
     *
     * Requirements
     *
     * - the caller must have at least `amount` tokens.
     * - `recipient` cannot be the zero address.
     * - if `recipient` is a contract, it must implement the {IERC777Recipient}
     * interface.
     */
    function send(address recipient, uint256 amount, bytes calldata data) external;

    /**
     * @dev Destroys `amount` tokens from the caller's account, reducing the
     * total supply.
     *
     * If a send hook is registered for the caller, the corresponding function
     * will be called with `data` and empty `operatorData`. See {IERC777Sender}.
     *
     * Emits a {Burned} event.
     *
     * Requirements
     *
     * - the caller must have at least `amount` tokens.
     */
    function burn(uint256 amount, bytes calldata data) external;

    /**
     * @dev Returns true if an account is an operator of `tokenHolder`.
     * Operators can send and burn tokens on behalf of their owners. All
     * accounts are their own operator.
     *
     * See {operatorSend} and {operatorBurn}.
     */
    function isOperatorFor(address operator, address tokenHolder) external view returns (bool);

    /**
     * @dev Make an account an operator of the caller.
     *
     * See {isOperatorFor}.
     *
     * Emits an {AuthorizedOperator} event.
     *
     * Requirements
     *
     * - `operator` cannot be calling address.
     */
    function authorizeOperator(address operator) external;

    /**
     * @dev Revoke an account's operator status for the caller.
     *
     * See {isOperatorFor} and {defaultOperators}.
     *
     * Emits a {RevokedOperator} event.
     *
     * Requirements
     *
     * - `operator` cannot be calling address.
     */
    function revokeOperator(address operator) external;

    /**
     * @dev Returns the list of default operators. These accounts are operators
     * for all token holders, even if {authorizeOperator} was never called on
     * them.
     *
     * This list is immutable, but individual holders may revoke these via
     * {revokeOperator}, in which case {isOperatorFor} will return false.
     */
    //function defaultOperators() external view returns (address[] memory);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient`. The caller must
     * be an operator of `sender`.
     *
     * If send or receive hooks are registered for `sender` and `recipient`,
     * the corresponding functions will be called with `data` and
     * `operatorData`. See {IERC777Sender} and {IERC777Recipient}.
     *
     * Emits a {Sent} event.
     *
     * Requirements
     *
     * - `sender` cannot be the zero address.
     * - `sender` must have at least `amount` tokens.
     * - the caller must be an operator for `sender`.
     * - `recipient` cannot be the zero address.
     * - if `recipient` is a contract, it must implement the {IERC777Recipient}
     * interface.
     */
    function operatorSend(
        address sender,
        address recipient,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the total supply.
     * The caller must be an operator of `account`.
     *
     * If a send hook is registered for `account`, the corresponding function
     * will be called with `data` and `operatorData`. See {IERC777Sender}.
     *
     * Emits a {Burned} event.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     * - the caller must be an operator for `account`.
     */
    function operatorBurn(
        address account,
        uint256 amount,
        bytes calldata data,
        bytes calldata operatorData
    ) external;

    event Sent(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data,
        bytes operatorData
    );

    event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);

    event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);

    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);

    event RevokedOperator(address indexed operator, address indexed tokenHolder);
}




//ERC1820Registry And Client to interact with registry

interface ERC1820Registry {
    function setInterfaceImplementer(address _addr, bytes32 _interfaceHash, address _implementer) external;
    function getInterfaceImplementer(address _addr, bytes32 _interfaceHash) external view returns (address);
    function setManager(address _addr, address _newManager) external;
    function getManager(address _addr) external view returns (address);
}


/// Base client to interact with the registry.
contract ERC1820Client {
    ERC1820Registry constant ERC1820REGISTRY = ERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
    
    function setInterfaceImplementation(string memory _interfaceLabel, address _implementation) internal {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
        ERC1820REGISTRY.setInterfaceImplementer(address(this), interfaceHash, _implementation);
    }

    function interfaceAddr(address addr, string memory _interfaceLabel) internal view returns(address) {
        bytes32 interfaceHash = keccak256(abi.encodePacked(_interfaceLabel));
        return ERC1820REGISTRY.getInterfaceImplementer(addr, interfaceHash);
    }

    function delegateManagement(address _newManager) internal {
        ERC1820REGISTRY.setManager(address(this), _newManager);
    }
}

//ERC777TokensSender - https://eips.ethereum.org/EIPS/eip-777

/**
 * @dev Interface of the ERC777TokensSender standard as defined in the EIP.
 *
 * {IERC777} Token holders can be notified of operations performed on their
 * tokens by having a contract implement this interface (contract holders can be
 *  their own implementer) and registering it on the
 * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
 *
 * See {IERC1820Registry} and {ERC1820Implementer}.
 */
interface IERC777Sender {
    /**
     * @dev Called by an {IERC777} token contract whenever a registered holder's
     * (`from`) tokens are about to be moved or destroyed. The type of operation
     * is conveyed by `to` being the zero address or not.
     *
     * This call occurs _before_ the token contract's state is updated, so
     * {IERC777-balanceOf}, etc., can be used to query the pre-operation state.
     *
     * This function may revert to prevent the operation from being executed.
     */
    function tokensToSend(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}

//IERC777Recipient - https://eips.ethereum.org/EIPS/eip-777

/**
 * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
 *
 * Accounts can be notified of {IERC777} tokens being sent to them by having a
 * contract implement this interface (contract holders can be their own
 * implementer) and registering it on the
 * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
 *
 * See {IERC1820Registry} and {ERC1820Implementer}.
 */
interface IERC777Recipient {
    /**
     * @dev Called by an {IERC777} token contract whenever tokens are being
     * moved or created into a registered account (`to`). The type of operation
     * is conveyed by `from` being the zero address or not.
     *
     * This call occurs _after_ the token contract's state is updated, so
     * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
     *
     * This function may revert to prevent the operation from being executed.
     */
    function tokensReceived(
        address operator,
        address from,
        address to,
        uint256 amount,
        bytes calldata userData,
        bytes calldata operatorData
    ) external;
}

/* Staking process is followed according to the ERC900: Simple Staking Interface #900 issue on Github */

interface Staking {
    
    event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
    
    event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);

    function stake(uint256 amount, bytes calldata data) external returns (bool);
    
    function unstake(uint256 amount, bytes calldata data) external returns (bool);
    
    function totalStakedFor(address addr) external view returns (uint256);
    
    function totalStaked() external view returns (uint256);
    
    function supportsHistory() external pure returns (bool);

}

/*EQUUS Protocol being created with the help of the above interfaces for compatibility*/

contract EQUUSGovernanceToken is IERC20, Staking, IERC777, ERC1820Client {
    
    /* Constant variables created for the ERC20 requirements*/
    
    string public override constant name = "EQUUSGovernanceToken";
    string public override constant symbol = "EQGT";
    uint8 public constant decimals = 18;
    
    //Burn address saved as constant for future burning processes
    address public constant burnaddress = 0x0000000000000000000000000000000000000000;
    IERC20 public uniaddress;

    mapping(address => uint256) balances; //EQUUS balance for all network participants
    
    mapping(address => uint256) public stakedbalances; //EQUUS stake balance to lock stakes
    
    mapping(address => uint256) public stakeMultipliers; //EQUUS stake multiplier per user staking
    
    mapping(address => uint256) public stakeMultipliersMax; //EQUUS stake multiplier per user staking
    
    mapping(address => uint) public staketimestamps; //EQUUS stake timestamp to record updates on staking for multipliers, this involves the idea that multipliers will reset upon staking

    mapping(address => mapping (address => uint256)) allowed; //Approval array to record delegation of thrid-party accounts to handle transaction per allowance
    
    
    /* Total variables created to record information */
    uint256 totalSupply_ = 0;
    uint256 totalstaked = 0;
    uint256 granularity_ = 1;
    
    // Set of arrays to hold operator authorization
    //address[] internal defaultOperators_;
    mapping(address => bool) internal isDefaultOperator_;
    mapping(address => mapping(address => bool)) internal revokedDefaultOperator_;
    mapping(address => mapping(address => bool)) authorizedOperator_;
    

    address theowner; //Owner address saved to recognise on future processes
    
    using SafeMath for uint256; //Important*** as this library provides security to handle maths without overflow attacks
    
    constructor(IERC20 tokenaddress) public {
        uniaddress = tokenaddress;
        theowner = msg.sender;
        setInterfaceImplementation("ERC777Token", address(this));
   } //Constructor stating the total supply as well as saving owner address
   
   
   
   //ERC777 functions ========================
   
   function granularity() public override view returns (uint256) {
       return granularity_;
   }
   
   //function defaultOperators() public override view returns (address[] memory) {
   //    return defaultOperators_;
   //}
   
   function setDefaultOperators(address addr) public returns (bool) {
       require(theowner != addr, "Owner address cannot be handled");
       require(theowner == msg.sender, "Only theowner can set default operators");
       
        isDefaultOperator_[addr] = true;
        emit AuthorizedOperator(addr, msg.sender);
   }
   
   function revokeDefaultOperators(address addr) public returns (bool) {
        require(theowner != addr, "Owner address cannot be revoked");
        
        isDefaultOperator_[addr] = false;
        emit RevokedOperator(addr, msg.sender);
   }
   
   function isOperatorFor( address operator_, address holder_) public override view returns (bool) {
        return (operator_ == holder_ || 
        authorizedOperator_[operator_][holder_] ||
        (isDefaultOperator_[operator_] &&
        !revokedDefaultOperator_[operator_][holder_]));
    }
    
    function authorizeOperator(address operator) public override {
        require(operator != msg.sender, "You can't authorize yourself");
        if (isDefaultOperator_[operator]) {
            revokedDefaultOperator_[operator][msg.sender] = false;
        } else {
            authorizedOperator_[operator][msg.sender] = true;
        }
        emit AuthorizedOperator(operator, msg.sender);
    }
    
    function revokeOperator(address operator) public override {
        require(operator != msg.sender, "You can't revoke yourself");
        if (isDefaultOperator_[operator]) {
            revokedDefaultOperator_[operator][msg.sender] = true;
        } else {
            authorizedOperator_[operator][msg.sender] = false;
        }
        emit RevokedOperator(operator, msg.sender);
    }
    
    function burn(uint256 amount, bytes memory data) public override {
        burning(msg.sender, msg.sender, amount, data, "");
    }
    
    function operatorBurn(
        address from,
        uint256 amount,
        bytes memory data,
        bytes memory operatorData
    ) public override {
        require(isOperatorFor(msg.sender, from), "Not an Operator");
        burning(msg.sender, from, amount, data, operatorData);
    }
    
    function burning(address operator, address from, uint256 amount, bytes memory data, bytes memory operatorData) internal {
        require(balances[from] >= amount, "Not enought funds");
        require(stakedbalances[from] != 0, "Nothing staked to mine for");
        require(stakeMultipliers[from] <= 500, "Max burn multiplier reached");
        require( getPercentageWithFive( stakeMultipliers[from] ) .add( getPercentageFromMax( amount, stakeMultipliersMax[from] ) ) <= 100 , "Too much to burn");
        
        balances[from] = balances[from].sub(amount);
        
        totalSupply_ = totalSupply_.sub(amount);
        
        
        uint256 multiplier = getPercentageFromMax(amount, stakeMultipliersMax[from]).mul(5);
        
        stakeMultipliers[from] = stakeMultipliers[from].add(multiplier);
        
        emit Burned(operator, from, amount, data, operatorData);
        emit Sent(operator, from, burnaddress, amount, data, operatorData);
    }
    
    
    
    function getPercentageFromMax(uint256 amount, uint256 maxForFuntion) public pure returns (uint256) {
        uint256 onePercent = maxForFuntion.div(100);
        return amount.div(onePercent);
    }
    
    function getPercentageWithFive(uint256 amount) public pure returns (uint256) {
        return amount.div(5);
    }
    
    
    function send(address to, uint256 amount, bytes memory data) public override {
        sending(msg.sender, msg.sender, to, amount, data, "", true);
    }
    
    function operatorSend(
        address from,
        address to,
        uint256 amount,
        bytes memory data,
        bytes memory operatorData
    ) public override {
        require(isOperatorFor(msg.sender, from), "Not an operator.");
        sending(msg.sender, from, to, amount, data, operatorData, true);
    }
    
    // ERC1820 implementer and send function ========================
    
    function sending(address operator,
        address from,
        address to,
        uint256 amount,
        bytes memory data,
        bytes memory operatorData,
        bool preventLocking) internal {
        
        
        checkSender(operator, from, to, amount, data, operatorData);
        
        require(to != burnaddress, "Can't send to 0x0");
        require(balances[from] >= amount, "Insufficient funds");
        
        balances[from] = balances[from].sub(amount);
        balances[to] = balances[to].add(amount);
        
        checkReceiver(operator, from, to, amount, data, operatorData, preventLocking);
        
        emit Sent(operator, from, to, amount, data, operatorData);
        
    }
    
    function checkSender(address operator, address from, address to, uint256 amount, bytes memory data, bytes memory operatorData) internal {
        address sender = interfaceAddr(from, "ERC777TokensSender");
        require(sender != burnaddress);
        IERC777Sender(sender).tokensToSend(
            operator, from, to, amount, data, operatorData);
    }
    
    function checkReceiver(address operator, address from, address to, uint256 amount, bytes memory data, bytes memory operatorData, bool preventLocking) internal {
        address recipient = interfaceAddr(to, "ERC777TokensRecipient");
        if (recipient != burnaddress) {
            IERC777Recipient(recipient).tokensReceived(
                operator, from, to, amount, data, operatorData);
        } else if (preventLocking) {
            require(isNormalAddress(to), "Cannot send to contract without ERC777TokensRecipient");
        }
    }
    
    function isNormalAddress(address addr) internal view returns(bool) {
        if (addr == burnaddress) { return false; }
        uint size;
        assembly { size := extcodesize(addr) } // solium-disable-line security/no-inline-assembly
        return size == 0;
    }
    
    //ERC20 implementation ========================
   
   //Function to report on totalsupply following ERC20 Standard
   function totalSupply() public override(IERC20, IERC777) view returns (uint256) {
       return totalSupply_;
   }
   
   //Function to report on account balance following ERC20 Standard
   function balanceOf(address tokenOwner) public override(IERC20, IERC777) view returns (uint) {
       return balances[tokenOwner];
   }
   
   //Function to report on account balance following ERC20 Standard
   function uniBalance(address tokenOwner) public view returns (uint) {
       return uniaddress.balanceOf(tokenOwner);
   }
   
   //Straight forward transfer following ERC20 Standard
   function transfer(address receiver, uint256 numTokens) public override returns (bool) {
       require(numTokens <= balances[msg.sender], 'Amount exceeds balance.');
       balances[msg.sender] = balances[msg.sender].sub(numTokens);
       
       balances[receiver] = balances[receiver].add(numTokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

       emit Transfer(msg.sender, receiver, numTokens);
       return true;
   }
   
   //Approve function following ERC20 Standard
   function approve(address delegate, uint256 numTokens) public override returns (bool) {
       require(numTokens <= balances[msg.sender], 'Amount exceeds balance.');
       allowed[msg.sender][delegate] = numTokens;
       emit Approval(msg.sender, delegate, numTokens);
       return true;
   }
   
   //Allowance function to verify allowance allowed on delegate address following ERC20 Standard
   function allowance(address owner, address delegate) public override view returns (uint) {
       return allowed[owner][delegate];
   }
   
   //The following function is added to mitigate ERC20 API: An Attack Vector on Approve/TransferFrom Methods
   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
       require(addedValue <= balances[msg.sender].sub(allowed[msg.sender][spender]), 'Amount exceeds balance.');
       
       allowed[msg.sender][spender] = allowed[msg.sender][spender].add(addedValue);
       
       emit Approval(msg.sender, spender, allowed[msg.sender][spender].add(addedValue));
       return true;
   }
   
   //The following function is added to mitigate ERC20 API: An Attack Vector on Approve/TransferFrom Methods
   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
       require(subtractedValue <= allowed[msg.sender][spender], 'Amount exceeds balance.');
       
       allowed[msg.sender][spender] = allowed[msg.sender][spender].sub(subtractedValue);
       
       emit Approval(msg.sender, spender, allowed[msg.sender][spender].sub(subtractedValue));
       return true;
   }
   
   //Transfer For function for allowed accounts to allow tranfers
   function transferFrom(address owner, address buyer, uint numTokens) public override returns (bool) {
       require(numTokens <= balances[owner], 'Amount exceeds balance.');
       require(numTokens <= allowed[owner][msg.sender], 'Amount exceeds allowance.');
       
       balances[owner] = balances[owner].sub(numTokens);
       allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
       balances[buyer] = balances[buyer].add(numTokens);	//injected INTEGER OVERFLOW OR UNDERFLOW

       emit Transfer(msg.sender, buyer, numTokens);
       return true;
   }
   
   //Staking processes ========================
   
   
   
   //Stake process created updating balances, stakebalances and also recording time on process run,
   function stake(uint256 amount, bytes memory data) public override returns (bool) {
       require(amount >= 105000);
       require(amount <= uniBalance(msg.sender));
       require(amount <= uniaddress.allowance(msg.sender, address(this)));
       
       //So add the user stake process into the data base
       
       uniaddress.transferFrom(msg.sender, address(this), amount);
       
       stakedbalances[msg.sender] = stakedbalances[msg.sender].add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

       totalstaked = totalstaked.add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

       staketimestamps[msg.sender] = block.timestamp;
       stakeMultipliers[msg.sender] = 100;
       
       //operation = = = ((((staked*744)*(7.13/744))/1000)*5000)
       uint256 max = amount;
       max = max.mul(744);
       max = max.mul(9583).div(1000000);
       
       max = max.div(1000);
       max = max.mul(5000);
       
       stakeMultipliersMax[msg.sender] = max; //Max amount of tokens to calculate the multiplier from
       
       uint256 total = stakedbalances[msg.sender];
       
       emit Staked(msg.sender, amount, total, data);
       return true;
   }
   
   //This function unstakes locked in amount, this also updates amounts on total supply
   function unstake(uint256 amount, bytes memory data) public override returns (bool) {
       require(amount <= stakedbalances[msg.sender]);
       require(amount <= totalstaked);
       
       stakedbalances[msg.sender] = stakedbalances[msg.sender].sub(amount);
       totalstaked = totalstaked.sub(amount);
       staketimestamps[msg.sender] = block.timestamp;
       stakeMultipliers[msg.sender] = 100;
       stakeMultipliersMax[msg.sender] = 0;
       
       uniaddress.transfer(msg.sender, amount);// Send tokens back to the holder
       
       emit Unstaked(msg.sender, amount, stakedbalances[msg.sender], data);
       return true;
   }
    
    
    // Minting operation
    
    //(((staked*hoursStaked)*(7.13/744))*rankMultiplier)*BBM =================
    
    
    function _mint(bytes memory data) public {
        require(stakedbalances[msg.sender] != 0, "Nothing staked to mine for");
        
        
        uint256 amount = operate(stakedbalances[msg.sender]);
        
        stakeMultipliers[msg.sender] = 100;
        staketimestamps[msg.sender] = block.timestamp;
        balances[msg.sender] = balances[msg.sender].add(amount);
        totalSupply_ = totalSupply_.add(amount);
        
        emit Minted(burnaddress, msg.sender, amount, data, data);
        emit Sent(burnaddress, burnaddress, msg.sender, amount, data, data);
        
    }
    
    function operate(uint256 number) public view returns (uint256) {
        uint256 amount = number;
        
        amount = amount.mul((stakeTimeFor(msg.sender).div(60)).div(60));
        
        require(amount > 104400, "Not enough time to mine tokens");
        
        //Sets a minimun to mine after the next operation to 1000 tokens
        
        amount = amount.mul(9583).div(1000000);
        
        if ((stakeTimeFor(msg.sender).div(60)).div(60) > 744) {
            amount = amount.mul(2);
        }
        uint256 multiplier = stakeMultipliers[msg.sender];
        amount = (amount.mul(multiplier)).div(100);
        return amount;
    }
   
   //Function to return multipliers
   function stakeMultiplierFor(address addr) public view returns (uint256) {
       return stakeMultipliers[addr];
   }
   
   //Function to return total staked on a single address
   function totalStakedFor(address addr) public override view returns (uint256) {
       return stakedbalances[addr];
   }
   
   //Function to shows timestamp on stake processes
   function stakeTimestampFor(address addr) public view returns (uint256) {
       return staketimestamps[addr];
   }
   
   //Function to find out time passed since last timestamp on address
   function stakeTimeFor(address addr) public view returns (uint256) {
       return block.timestamp.sub(staketimestamps[addr]);
   }
   
   //Total staked on all addresses
   function totalStaked() public override view returns (uint256) {
       return totalstaked;
   }
   
   //Support History variable to show support on optional stake details
   function supportsHistory() public override pure returns (bool) {
       return false;
   }
   
}