/**
 *Submitted for verification at Etherscan.io on 2020-10-11
*/

//SPDX-License-Identifier: UNLICENSED 
pragma solidity ^0.7.0;	//inject UNLIMITED COMPILER VERSIONS
 
interface ERC20 {
 
 
  function balanceOf(address _owner) external returns (uint256);
  function transfer(address _to, uint256 _value) external returns (bool);
  function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
  function approve(address _spender, uint256 _value) external returns (bool);
  function allowance(address _owner, address _spender) external returns (uint256);
 
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
 
}
 
 
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
 
  function div(uint256 a, uint256 b) internal  pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }
 
  function sub(uint256 a, uint256 b) internal  pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
 
  function add(uint256 a, uint256 b) internal pure  returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
 
contract xGemPresale  {
  using SafeMath for uint256;
  
  receive() payable external{
      buyTokens(msg.sender);
  }
 
  address public owner;
 
  // The token being sold
  ERC20 public token;
 
  // the token address
  address payable  public  tokenAddress = 0x3E60f39208aC7b8E80eaaFF8BF2Ae71949A9aA85;
 
 
 
  // address where funds are collected
  address payable  public  wallet = msg.sender;
 
  uint256 public tokensSold;
 
  uint256 public minInvestment= 0.2 * 10**18;
 
 
  // cap (tokens to sell max)
 
  uint256 public cap =  50_000 * 10**18; 
 
  // tokens per ether
  uint256 public rate = 500;

  bool public isFinalized = false;
  
  // Start timestamp
  uint256 public salesStartTimeStamp = 1602446400; // 8 PM UTC
 
 
  bool paused;
 
  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */ 
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
 
  /**
   * event for signaling finished crowdsale
   */
  event Finalized();
 
 
 
 
  constructor()  {
 
    require(wallet != address(0));
    require(minInvestment >= 0);
    token= ERC20(tokenAddress);
  }
 
 modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
 
/**
   * @dev modifier to allow actions only when the contract IS paused
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }
 
  /**
   * @dev modifier to allow actions only when the contract IS NOT paused
   */
  modifier whenPaused {
    require(paused);
    _;
  }
 
  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused returns (bool) {
    paused = true;
    return true;
  }
 
  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused returns (bool) {
    paused = false;
    return true;
  }
 
 
 
  /**
   * Low level token purchse function
   * @param beneficiary will recieve the tokens.
   */
  function buyTokens(address beneficiary) public payable whenNotPaused {
    require(beneficiary != address(0));
    require(validPurchase());
 
 
    uint256 weiAmount = msg.value;
    // compute amount of tokens created
    uint256 tokens = weiAmount.mul(rate);
 
    // check if there are enough tokens left 
    require(tokensSold.add(tokens)<=cap,"Not enough tokens left");
 
    // add tokens to amount sold
    tokensSold=tokensSold.add(tokens);
 
    // tokens are previously minted , send them to buyer
    token.transfer(beneficiary, tokens);
 
    emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
    forwardFunds();
  }
 
  // send ether to the fund collection wallet
  function forwardFunds() internal {
    wallet.transfer(msg.value);
  }
 
  // return true if the transaction can buy tokens
  function validPurchase() internal returns (bool) {
 
    bool notSmallAmount = msg.value >= minInvestment;
    bool salesActive = ( block.timestamp >= salesStartTimeStamp);
    return (notSmallAmount && salesActive && !isFinalized);
  }
 
  //allow owner to finalize and withdraw leftoverTokens
  function finalize() public onlyOwner {
    require(!isFinalized);
 
    emit Finalized();
 
    uint256 leftoverTokens = token.balanceOf(address(this));
    token.transfer(address(this),leftoverTokens);
 
    isFinalized = true;
  }
}