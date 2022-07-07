/**
 *Submitted for verification at Etherscan.io on 2020-01-02
*/

pragma solidity ^0.5.15;


library SafeMath 
{
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

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }
}


/******************************************/
/*       nerveShares starts here          */
/******************************************/

contract nerveShares {

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public totalDividends;

    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
    mapping (address => uint256) internal lastDividends;
    mapping (address => bool) public lockedAccounts;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Claim(address indexed _from, uint256 value);
    event Locked(address indexed _from, bool state);

    using SafeMath for uint256;

    constructor() public
    {
        decimals = 18;                              // decimals  
        totalSupply = 1000000*10**18;               // initialSupply
        name = "Nerve";                             // Set the name for display purposes
        symbol = "NRV";                             // Set the symbol for display purposes

        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    /**
    * @dev Get the current dividends of a user. Take prior payoffs into account.
    * @param account The address of the user.
    */
    function dividendBalanceOf(address account) public view returns (uint256) 
    {
        uint256 newDividends = totalDividends.sub(lastDividends[account]);
        uint256 product = balanceOf[account].mul(newDividends);
        return product.div(totalSupply);
    }   

    /**
    * @dev Internal dividendBalanceOf.
    * @param account The address of the user.
    */
    function internalDividendBalanceOf(address account, uint256 tempLastDividends) internal view returns (uint256) 
    {
        uint256 newDividends = totalDividends.sub(tempLastDividends);
        uint256 product = balanceOf[account].mul(newDividends);
        return product.div(totalSupply);
    }   

    /**
    * @dev Claim dividends. Restrict dividends to new income.
    */
    function claimDividend() external 
    {
        uint256 tempLastDividends = lastDividends[msg.sender];
        lastDividends[msg.sender] = totalDividends;
        uint256 owing = internalDividendBalanceOf(msg.sender, tempLastDividends);

        require(owing > 0, "No dividends to claim.");

        msg.sender.transfer(owing);
        
        emit Claim(msg.sender, owing);
    }

    /**
    * @dev Open or close sending address for trade.
    * @param lock True -> can't send or receive NRV.
    */
    function lockToken(bool lock) external
    {
        lockedAccounts[msg.sender] = lock;
        
        emit Locked(msg.sender, lock);
    }

    /**
    * @dev Transfer tokens.
    * @param to The address of the recipient.
    * @param value The amount to send.
    */
    function transfer(address payable to, uint256 value) external returns(bool success)
    {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
    * @dev Transfer tokens. Spread open dividends across all users.
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function _transfer(address payable from, address payable to, uint256 value) internal
    {   
        require(value > 0, "Transferred value has to be grater than 0.");
        require(to != address(0), "0x00 address not allowed.");
        require(lockedAccounts[to] == false, "Target address is locked.");
        require(lockedAccounts[from] == false, "Sending address is locked.");
        require(value <= balanceOf[from], "Not enough funds on sender address.");
        require(balanceOf[to] + value >= balanceOf[to], "Overflow protection.");
 
        uint256 fromOwing = dividendBalanceOf(from);
        uint256 toOwing = dividendBalanceOf(to);

        lastDividends[to] = totalDividends;
        lastDividends[from] = totalDividends;

        totalDividends = totalDividends.add(fromOwing);
        totalDividends = totalDividends.add(toOwing);

        balanceOf[from] -= value;
        balanceOf[to] += value;
 
        emit Transfer(from, to, value);
    }

    /**
    * @dev ERC20 transferFrom.
    * @param from Address to transfer from.
    * @param to Address to transfer to.
    * @param value Amount to transfer.
    * @return success of transfer.
    */
    function transferFrom(address payable from, address payable to, uint value) external returns (bool success)
    {     
        require(allowance[from][msg.sender] >= value, "Funds not approved."); 
        require(balanceOf[from] >= value, "Not enough funds on sender address.");
        require(balanceOf[to] + value >= balanceOf[to], "Overflow protection.");

        allowance[from][msg.sender] -= value;
  
        _transfer(from, to, value);

        return true;
    }

    /**
    * @dev `msg.sender` approves `addr` to spend `value` tokens.
    * @param spender The address of the account able to transfer the tokens.
    * @param value The amount of wei to be approved for transfer.
    */
    function approve(address spender, uint value) external returns (bool) 
    {
        allowance[msg.sender][spender] = value;	//injected TRANSACTION ORDER DEPENDENCE
        emit Approval(msg.sender, spender, value);
        return true;
    }
   
    /**
    * @dev Get contract ETH amount. 
    */ 
    function contractBalance() external view returns(uint256 amount)
    {
        return (address(this).balance);
    }
    
    /**
    * @dev Receive ETH from CONTRACT and increase the total historic amount of dividend eligible earnings.
    */
    function receiveETH() external payable
    {
        totalDividends = totalDividends.add(msg.value);
    }
    
    /**
    * @dev Receive ETH and increase the total historic amount of dividend eligible earnings.
    */
    function () external payable 
    {
        totalDividends = totalDividends.add(msg.value);
    }
    
}