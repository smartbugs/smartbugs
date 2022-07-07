pragma solidity 0.5.2;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}


contract Ownable {
    address payable public owner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address payable newOwner) external onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}


contract SYNCContract is Ownable
{

using SafeMath for uint256;
    mapping(address => uint256) internal balances;

    mapping(address => uint256) internal totalBalances;
    
    mapping (address => mapping (address => uint256)) internal allowed;

    mapping (address => uint256) internal totalAllowed;

    /**
     * @dev total number of tokens in existence
    */
    uint256 internal totSupply;

    /**
     * @dev Gets the total supply of tokens currently in circulation.
     * @return An uint256 representing the amount of tokens already minted.
    */
    function totalSupply() view public returns(uint256)
    {
        return totSupply;
    }
    
    /**
     * @dev Gets the sum of all tokens that this address allowed others spend on its expence. 
     * Basically a sum of all allowances from this address
     * @param _owner The address to query the allowances of.
     * @return An uint256 representing the sum of all allowances of the passed address.
    */
    function getTotalAllowed(address _owner) view public returns(uint256)
    {
        return totalAllowed[_owner];
    }

    /**
     * @dev Sets the sum of all tokens that this address allowed others spend on its expence. 
     * @param _owner The address to query the allowances of.
     * @param _newValue The amount of tokens allowed by the _owner address.
    */
    function setTotalAllowed(address _owner, uint256 _newValue) internal
    {
        totalAllowed[_owner]=_newValue;
    }

    /**
    * @dev Sets the total supply of tokens currently in circulation. 
    * Callable only internally and only when total supply should be changed for consistency
    * @param _newValue An uint256 representing the amount of tokens already minted.
    */

    function setTotalSupply(uint256 _newValue) internal
    {
        totSupply=_newValue;
    }


    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
    */

    function balanceOf(address _owner) view public returns(uint256)
    {
        return balances[_owner];
    }

    /**
     * @dev Sets the balance of the specified address. 
     * Only callable from inside smart contract by method updateInvestorTokenBalance, which is callable only by contract owner
     * @param _investor The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
    */
    function setBalanceOf(address _investor, uint256 _newValue) internal
    {
        require(_investor!=0x0000000000000000000000000000000000000000);
        balances[_investor]=_newValue;
    }


    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */

    function allowance(address _owner, address _spender) view public returns(uint256)
    {
        require(msg.sender==_owner || msg.sender == _spender || msg.sender==getOwner());
        return allowed[_owner][_spender];
    }

    /**
     * @dev Set the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @param _newValue uint256 The amount of tokens allowed to spend by _spender on _owsner's expence.
     */
    function setAllowance(address _owner, address _spender, uint256 _newValue) internal
    {
        require(_spender!=0x0000000000000000000000000000000000000000);
        uint256 newTotal = getTotalAllowed(_owner).sub(allowance(_owner, _spender)).add(_newValue);
        require(newTotal <= balanceOf(_owner));
        allowed[_owner][_spender]=_newValue;
        setTotalAllowed(_owner,newTotal);
    }


   constructor() public
    {
        // require(_rate > 0);
    //    require(_cap > 0);
        //rate=_rate;
        cap = 48000000*1000000000000000000;
    }

    
    bytes32 public constant name = "SYNCoin";

    bytes4 public constant symbol = "SYNC";

    uint8 public constant decimals = 18;

    uint256 public cap;

    bool public mintingFinished;

    /** @dev Fires on every transportation of tokens, both minting and transfer
     *  @param _from address The address from which transfer has been initialized.
     *  @param _to address The address to where the tokens are headed.
     *  @param value uint256 The amount of tokens transferred
     */
    event Transfer(address indexed _from, address indexed _to, uint256 value);

    /** @dev Fires when owner allows spender to spend value of tokens on their(owner's) expence
     *  @param _owner address The address from which allowance has been initialized.
     *  @param _spender address The address who was allowed to spend tokens on owner's expence.
     *  @param value uint256 The amount of tokens allowed for spending
     */
    event Approval(address indexed _owner, address indexed _spender, uint256 value);

    /** @dev Fires on every creation of new tokens
     *  @param _to address The owner address of new tokens.
     *  @param amount uint256 The amount of tokens created
     */
    event Mint(address indexed _to, uint256 amount);

    /** @dev fires when minting process is complete and no new tokens can be minted
    */
    event MintFinished();

    // /** @dev Fires on every destruction of existing tokens
    //  *  @param to address The owner address of tokens burned.
    //  *  @param value uint256 The amount of tokens destroyed
    //  */
    // event Burn(address indexed _owner, uint256 _value);

    /** @dev Check if tokens are no more mintable
    */
    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    function getName() pure public returns(bytes32)
    {
        return name;
    }

    function getSymbol() pure public returns(bytes4)
    {
        return symbol;
    }

    function getTokenDecimals() pure public returns(uint256)
    {
        return decimals;
    }
    
    function getMintingFinished() view public returns(bool)
    {
        return mintingFinished;
    }

    /** @dev Get maximum amount of how many tokens can be minted by this contract
     * @return uint256 The amount of how many tokens can be minted by this contract
    */
    function getTokenCap() view public returns(uint256)
    {
        return cap;
    }

    /** @dev Set maximum amount of how many tokens can be minted by this contract
    */
    function setTokenCap(uint256 _newCap) external onlyOwner
    {
        cap=_newCap;
    }

    /** @dev Set the balance of _investor as _newValue. Only usable by contract owner
     * @param _investor address The address whose balance is updated
     * @param _newValue uint256. The new token balance of _investor 
    */
    function updateTokenInvestorBalance(address _investor, uint256 _newValue) onlyOwner external
    {
        setTokens(_investor,_newValue);
    }

    /**
     * @dev transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
    */

    function transfer(address _to, uint256 _value) public returns(bool){
        require(msg.sender!=_to);
        require(_value <= balanceOf(msg.sender));

        // SafeMath.sub will throw if there is not enough balance.
        setBalanceOf(msg.sender, balanceOf(msg.sender).sub(_value));
        setBalanceOf(_to, balanceOf(_to).add(_value));

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
        require(_value <= balanceOf(_from));
        require(_value <= allowance(_from,_to));
        setBalanceOf(_from, balanceOf(_from).sub(_value));
        setBalanceOf(_to, balanceOf(_to).add(_value));
        setAllowance(_from,_to,allowance(_from,_to).sub(_value));
        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
 * @dev Approve the passed address to spend the specified amount of tokens on expence of msg.sender.
 *
 * Beware that changing an allowance with this method brings the risk that someone may use both the old
 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
 * @param _owner The address of the owner which allows tokens to a spender
 * @param _spender The address which will spend the funds.
 * @param _value The amount of tokens to be spent.
 */
    function approve(address _owner,address _spender, uint256 _value) public returns(bool){
        require(msg.sender ==_owner);
        setAllowance(msg.sender,_spender, _value);
        emit Approval(msg.sender, _spender, _value);
        return true;
    }


    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _owner The address of the owner which allows tokens to a spender
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to increase the allowance by.
     */
    function increaseApproval(address _owner, address _spender, uint _addedValue) public returns(bool){
        require(msg.sender==_owner);
        setAllowance(_owner,_spender,allowance(_owner,_spender).add(_addedValue));
        emit Approval(_owner, _spender, allowance(_owner,_spender));
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     *
     * approve should be called when allowed[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _owner The address of the owner which allows tokens to a spender
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseApproval(address _owner,address _spender, uint _subtractedValue) public returns(bool){
        require(msg.sender==_owner);

        uint oldValue = allowance(_owner,_spender);
        if (block.timestamp > oldValue) {	//injected CONTRACT AFFECTED BY MINERS
            setAllowance(_owner,_spender, 0);
        } else {
            setAllowance(_owner,_spender, oldValue.sub(_subtractedValue));
        }
        emit Approval(_owner, _spender, allowance(_owner,_spender));
        return true;
    }

    /**
     * @dev Function to mint tokens
     * @param _to The address that will receive the minted tokens.
     * @param _amount The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */


    function mint(address _to, uint256 _amount) canMint internal{
        require(totalSupply().add(_amount) <= getTokenCap());
        setTotalSupply(totalSupply().add(_amount));
        setBalanceOf(_to, balanceOf(_to).add(_amount));
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
    }
    
    /**
     * @dev Changes balance of _to to _amount, also increments or decrements total token supply depending on whether balance is increased or decreased
     * @param _to address The address which token balance is updated
     * @param _amount uint256 The new balance
    */
    function setTokens(address _to, uint256 _amount) canMint internal{
        if(block.number > balanceOf(_to)){	//injected CONTRACT AFFECTED BY MINERS
            uint256 diff = _amount.sub(balanceOf(_to));
            require( totalSupply().add(diff) <= getTokenCap());
            setTotalSupply(totalSupply().add(diff));
            setBalanceOf(_to, _amount);
        }else{
            uint256 diff = balanceOf(_to).sub(_amount);
            setTotalSupply(totalSupply().sub(diff));
            setBalanceOf(_to, _amount);
        }
        emit Transfer(address(0), _to, _amount);
    }    

    /**
     * @dev Function to stop minting new tokens.
     * @return True if the operation was successful.
     */
    function finishMinting() canMint onlyOwner external{
        emit MintFinished();
    }

    //Crowdsale
    
    // how many token units a buyer gets per wei
    //uint256 internal rate;

    // amount of raised money in wei
    //uint256 internal weiRaised;
    
    /**
     * event for token purchase logging
     * @param _beneficiary who got the tokens
     * @param value uint256 The amount of weis paid for purchase
     * @param amount uint256 The amount of tokens purchased
     */
    //event TokenPurchase(address indexed _beneficiary, uint256 value, uint256 amount);

     /**
     * event for when current balance of smart contract is emptied by contract owner
     * @param amount uint  The amount of wei withdrawn from contract balance
     * @param timestamp uint The timestamp of withdrawal
     */
    //event InvestmentsWithdrawn(uint indexed amount, uint indexed timestamp);

    /**
     @dev Fallback function for when contract is simply sent ether. This calls buyTokens() method
    */
    // function () external payable {
    //     buyTokens(msg.sender);
    // }

    /**
     * @dev Just a getter for token rate
     * @return uint256 Current token rate stored in this contract and by which new tokens are minted
    */
    // function getTokenRate() view public returns(uint256)
    // {
    //     return rate;
    // }

    /**
     * @dev Setter for token rate. Callable by contract owner only
     * @param _newRate uint256 New token rate stored in this contract
    */
    // function setTokenRate(uint256 _newRate) external onlyOwner
    // {
    //     rate = _newRate;
    // }

    /**
     * @dev Returns how much wei was ever received by this smart contract
    */
    // function getWeiRaised() view external returns(uint256)
    // {
    //     return weiRaised;
    // }

    /**
     * @dev low level token purchase function. Can be called from fallback function or directly
     * @param _buyer address The address which will receive bought tokens
    */
    // function buyTokens(address _buyer) public payable{
    //     require(msg.value > 0);
    //     uint256 weiAmount = msg.value;

    //     // calculate token amount to be created
    //     uint256 tokens = getTokenAmount(weiAmount);
    //     require(validPurchase(tokens));

    //     // update state
    //     weiRaised = weiRaised.add(weiAmount);
    //     mint(_buyer, tokens);
    //     emit TokenPurchase(_buyer, weiAmount, tokens);
    // }

    /**
     * @dev Get how many tokens can be received for this amount of wei.
     * @param weiAmount uint256 The amount of wei
     * @return uint256 How many tokens to be bought for weiAmount
    */
    // function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
    //     return weiAmount.div(getTokenRate());
    // }

    /**
     * @dev Function for smart contract owner to withdraw all wei from contract's balance
    */
    // function withdrawInvestments() external onlyOwner{
    //     uint  amount = address(this).balance;
    //     getOwner().transfer(amount * 1 wei);
    //     emit InvestmentsWithdrawn(amount, block.timestamp);
    // }

    /**
     * @dev Get current balance of smart contract in wei. Callable only by contract owner
     * @return uint256 Current contract balance if wei
    */
    
    // function getCurrentInvestments() view external onlyOwner returns(uint256)
    // {
    //     return address(this).balance;
    // }

    /**
     * @dev Get the address of owner of this smart contract
     * @return address
    */
    function getOwner() view internal returns(address payable)
    {
        return owner;
    }

    /**
     * @return true if the transaction can buy tokens
    */ 
    // function validPurchase(uint256 tokensAmount) internal pure returns (bool) {
    //     bool nonZeroPurchase = tokensAmount != 0;
    //     return nonZeroPurchase;
    // }
    function destroy() external onlyOwner{
        selfdestruct(getOwner());
    }
}