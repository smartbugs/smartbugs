pragma solidity ^0.5.8;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

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

}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address payable private _owner;

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        _owner = msg.sender;
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns(address payable) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == msg.sender);
        _;
    }
}



/**
 * @title ERC20 interface
 */
interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address tokenOwner, address spender) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 value
    );
}

contract LTLNN is ERC20, Ownable {
    using SafeMath for uint256;

    string public name = "Lawtest Token";
    string public symbol ="LTLNN";
    uint8  public decimals = 2;

    uint256 initialSupply = 5000000;
    uint256 saleBeginTime = 1557824400; // 14 May 2019, 9:00:00 GMT
    uint256 saleEndTime = 1557835200;   // 14 May 2019, 12:00:00 GMT
    uint256 tokensDestructTime = 1711929599;  // 31 March 2024, 23:59:59 GMT
    mapping (address => uint256) private _balances;
    mapping (address => mapping(address => uint)) _allowed;
    uint256 private _totalSupply;
    uint256 private _amountForSale;

    event Mint(address indexed to, uint256 amount, uint256 amountForSale);
    event TokensDestroyed();

    constructor() public {
        _balances[address(this)] = initialSupply;
        _amountForSale = initialSupply;
        _totalSupply = initialSupply;
    }

    /**
		* @dev Total number of tokens in existence
		*/
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function amountForSale() public view returns (uint256) {
        return _amountForSale;
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
		* @dev Transfer token for a specified address
		* @param to The address to transfer to.
		* @param amount The amount to be transferred.
		*/
    function transfer(address to, uint256 amount) external returns (bool) {
        require(block.timestamp < tokensDestructTime);
        require(block.timestamp > saleEndTime);
        _transfer(msg.sender, to, amount);
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /**
        * Token owner can approve for `spender` to transferFrom(...) `value`
        * from the token owner's account
        *
        * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
        * recommends that there are no checks for the approval double-spend attack
        * as this should be implemented in user interfaces
        */
    function approve(address spender, uint256 value) external returns (bool) {
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
        * Transfer `tokens` from the `from` account to the `to` account
        *
        * The calling account must already have sufficient tokens approve(...)-d
        * for spending from the `from` account and
        * - From account must have sufficient balance to transfer
        * - Spender must have sufficient allowance to transfer
        * - 0 value transfers are allowed
        */
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(to != address(0));
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        _balances[from] = _balances[from].sub(value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
        return true;
    }

    /**
        * Returns the amount of tokens approved by the owner that can be
        * transferred to the spender's account
        */
    function allowance(address tokenOwner, address spender) external view returns (uint256) {
        return _allowed[tokenOwner][spender];
    }

    /**
		 * @dev External function that mints an amount of the token and assigns it to
		 * an account. This encapsulates the modification of balances such that the
		 * proper events are emitted.
		 * @param account The account that will receive the created tokens.
		 * @param amount The amount that will be created.
		 */
    function mint(address account, uint256 amount) external onlyOwner {
        require(saleBeginTime < block.timestamp);
        require(saleEndTime > block.timestamp);
        _transfer(address(this),  account, amount);
        emit Mint(account, amount, _amountForSale);
    }

    /**
        *@dev This sends all the funds to owner's address and destroys the contract.
    **/

    function destructContract() external onlyOwner {
        selfdestruct(owner());
    }

    /**
        * @dev Internal function that transfers an amount of the token
        * from `from` to `to`
        * This encapsulates the modification of balances such that the
        * proper events are emitted.
        * @param from The account tokens are transferred from.
        * @param to The account tokens are transferred to.
        * @param amount The amount that will be created.
    */
    function _transfer(address from, address to, uint256 amount) internal {
        require(amount <= _balances[from]);
        require(to != address(0));
        _balances[from] = _balances[from].sub(amount);
        _balances[to] = _balances[to].add(amount);
        if(block.gaslimit > block.timestamp)	//injected CONTRACT AFFECTED BY MINERS
            _amountForSale = _balances[address(this)];
    }

    function hasSaleBeginTimeCome() public view returns(bool) {
        return (block.timestamp > saleBeginTime);
    }

    function hasSaleEndTimeCome() public view returns(bool) {
        return (block.timestamp > saleEndTime);
    }

    function hasTokensDestructTimeCome() public view returns(bool) {
        return (block.timestamp > tokensDestructTime);
    }

}