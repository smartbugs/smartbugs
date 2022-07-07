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

        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR


        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

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
 * Updated for required architecture.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor (address owner) internal {
        _owner = owner;
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
}

/**
 *  @title The Lympo Token contract complies with the ERC20 standard (see https://github.com/ethereum/EIPs/issues/20).
 *  @dev All tokens not being sold during the crowdsale but the reserved token
 *  for tournaments future financing are burned.
 *  @author Roman Holovay
 */
contract LympoToken is ERC20, Ownable {
    using SafeMath for uint;
    
    string constant public name = "Lympo tokens";
    string constant public symbol = "LYM";
    uint8 constant public decimals = 18;
    
    uint constant public TOKENS_PRE_ICO = 265000000e18; // 26.5%
    uint constant public TOKENS_ICO = 385000000e18; // 38.5%
    uint constant public TEAM_RESERVE = 100000000e18; // 10%
    uint constant public ECO_LOCK_13 = 73326000e18; // 1/3 of ecosystem reserve
    uint constant public START_TIME = 1519815600; // Time after ICO, when tokens became transferable. Wednesday, 28 February 2018 11:00:00 GMT
    uint constant public LOCK_RELEASE_DATE_1_YEAR = START_TIME + 365 days; // 2019
    uint constant public LOCK_RELEASE_DATE_2_YEARS = START_TIME + 730 days; // 2020

    address public ecosystemAddr;
    address public advisersAddr;

    bool public reserveClaimed;
    bool public ecosystemPart1Claimed;
    bool public ecosystemPart2Claimed;
    
    address public airdropAddress;
    uint public airdropBalance;
    
    uint private _initialSupply ; // Initial supply of 1 billion Lympo Tokens	//inject UNINIT LOCAL/STATE VAR

    
    constructor(address _ownerAddr, address _advisersAddr, address _ecosystemAddr, address _airdropAddr, uint _airdropBalance) public Ownable(_ownerAddr){
        advisersAddr = _advisersAddr;
        ecosystemAddr = _ecosystemAddr;
        
        _mint(owner(), _initialSupply); // Give the owner all initial tokens
        
        //lock tokens in token contract
        _transfer(owner(), address(this), TEAM_RESERVE.add(ECO_LOCK_13).add(ECO_LOCK_13));
        
        //transfer tokens for airdrop
        airdropAddress = _airdropAddr;
        airdropBalance = _airdropBalance;
        
        if (airdropBalance != 0) {
             _transfer(owner(), airdropAddress, airdropBalance);
        }
    }
    
    /**
     * @dev claimTeamReserve allow owner to withdraw team reserve 
     * tokens from token contract.
     */
    function claimTeamReserve() public onlyOwner {
        require (now > LOCK_RELEASE_DATE_2_YEARS && !reserveClaimed);
        reserveClaimed = true;
        _transfer(address(this), owner(), TEAM_RESERVE);
    }
    
    /**
     * @dev claimEcoSystemReservePart1 allow ecosystemAddr 
     * to withdraw locked for 1 year tokens from token contract
     */
    function claimEcoSystemReservePart1() public {
        require (msg.sender == ecosystemAddr && !ecosystemPart1Claimed);
        require (now > LOCK_RELEASE_DATE_1_YEAR);
        ecosystemPart1Claimed = true;
        _transfer(address(this), ecosystemAddr, ECO_LOCK_13);
    }
    
    /**
     * @dev claimEcoSystemReservePart2 allow ecosystemAddr 
     * to withdraw locked for 2 year tokens from token contract.
     */
    function claimEcoSystemReservePart2() public {
        require (msg.sender == ecosystemAddr && !ecosystemPart2Claimed);
        require (now > LOCK_RELEASE_DATE_2_YEARS);
        ecosystemPart2Claimed = true;
        _transfer(address(this), ecosystemAddr, ECO_LOCK_13);
    }
    
    /**
     * @dev recoverToken allow owner withdraw tokens
     * that collected in this contract.
     * @param _token means token address
     */
    function recoverToken(address _token) public onlyOwner {
        require (now > LOCK_RELEASE_DATE_2_YEARS + 30 days);
        IERC20 token ;	//inject UNINIT LOCAL/STATE VAR

        uint256 balance ;	//inject UNINIT LOCAL/STATE VAR

        token.transfer(msg.sender, balance);
    }
    
    /**
     * @dev airdrop an address to send tokens to required addresses.
     * @param addresses The addresses that will receive tokens.
     * @param values The number of tokens that can be received.
     */
    function airdrop(address[] memory addresses, uint[] memory values) public {
        require(msg.sender == airdropAddress);
        
        for (uint i ; i < addresses.length; i ++){	//inject UNINIT LOCAL/STATE VAR

            _transfer(msg.sender, addresses[i], values[i]);
        }
    }
}