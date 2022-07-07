/**
 *Submitted for verification at Etherscan.io on 2020-04-19
*/

pragma solidity ^0.5.17;

library SafeMath {
    
  function mul(uint256 a, uint256 b) internal pure returns (uint256){
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    //assert(b <= a);
    return a - b;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    //assert(c >= a);
    return c;
  }
}

contract Ownable {
  address payable internal _owner;
  address payable internal _potentialNewOwner;
 
  event OwnershipTransferred(address payable indexed from, address payable indexed to);

  constructor() internal {
    _owner = msg.sender;
  }
  modifier onlyOwner() {
    require(msg.sender == _owner);
    _;
  }
  function transferOwnership(address payable newOwner) external onlyOwner {
    _potentialNewOwner = newOwner;
  }
  function acceptOwnership() external {
    require(msg.sender == _potentialNewOwner);
    emit OwnershipTransferred(_owner, _potentialNewOwner);
    _owner = _potentialNewOwner;
  }
  function getOwner() view external returns(address){
      return _owner;
  }
  function getPotentialNewOwner() view external returns(address){
      return _potentialNewOwner;
  }
}

contract CircuitBreaker is Ownable {
    bool private isApplicationLockedDown;
    // External contract payment via collection
    bool private isECPVCLockedDown;
    // External contract payment
    bool private isECPLockedDown;

    constructor () internal {
        isApplicationLockedDown = false;
        isECPVCLockedDown = false;
        isECPLockedDown = false;
    }
    modifier applicationLockdown() {
        require(isApplicationLockedDown == false);
        _;
    }
    modifier ecpvcLockdown() {
        require(isECPVCLockedDown == false);
        _;
    }
    modifier ecpLockdown() {
        require(isECPVCLockedDown == false);
        _;
    }
    function updateApplicationLockdownState(bool state) public onlyOwner{
       isApplicationLockedDown = state;
    }
    function updateECPCVLockdownState(bool state) public onlyOwner{
        isECPVCLockedDown = state;
    }
    function updateECPLockdownState(bool state) public onlyOwner{
        isECPLockedDown = state;
    }
}

contract ERC20Interface {
    uint256 public totalSupply;
    function balanceOf(address owner) public view returns (uint256 balance);
    function transfer(address to, uint256 value) public returns (bool success);
    function transferFrom(address from, address to, uint256 value) public returns (bool success);
    function approve(address spender, uint256 value) public returns (bool success);
    function allowance(address owner, address spender) public view returns (uint256 remaining);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20 is ERC20Interface {
  using SafeMath for uint256;

  mapping(address => uint256) public balances;
  mapping (address => mapping (address => uint256)) private allowed;

  function balanceOf(address owner) view public returns (uint256 balance) {
    return balances[owner];
  }
  function transfer(address to, uint256 value) public returns (bool) {
    balances[msg.sender] = balances[msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    balances[to] = balances[to].add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Transfer(msg.sender, to, value);
    return true;
  }
  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    uint256 allowance = allowed[from][msg.sender];
    balances[from] = balances[from].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    allowed[from][msg.sender] = allowance.sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    balances[to] = balances[to].add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Transfer(from, to, value);
    return true;
  }
  function approve(address spender, uint256 value) public returns (bool) {
    require((value == 0) || (allowed[msg.sender][spender] == 0));
    allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }
  function allowance(address owner, address spender) view public returns (uint256 remaining) {
    return allowed[owner][spender];
  }
}

contract RecoverableToken is ERC20, Ownable {
  event RecoveredTokens(address token, address owner, uint tokens, uint time);
  
  function recoverTokens(ERC20 token) public onlyOwner {
    uint tokens = tokensToBeReturned(token);
    require(token.transfer(_owner, tokens) == true);
    emit RecoveredTokens(address(token), _owner,  tokens, now);
  }
  function tokensToBeReturned(ERC20 token) public view returns (uint256) {
    return token.balanceOf(address(this));
  }
}

contract IPurchasableToken{
    function purchase(ERC20 tokenAddress, string memory collectionName, address buyer, uint256 value) public returns(bool);
}

contract ITradableToken{
    function purchase(address tokenAddress, address buyer, uint256 value) public returns (bool success);
}

contract ExternalContractInvocations is ERC20{
  enum ExternalPurchaseType{
      Item,
      Token
  }
  
  event ApprovedAndInvokedExternalPurchase(ExternalPurchaseType typeOfPurchase, address tokenAddress, string collectionName, address buyer, uint256 value, uint256 time);
  event ApprovedAndInvokedExternalPurchase(ExternalPurchaseType typeOfPurchase, address tokenAddress, address buyer, uint256 value, uint256 time);
     
  function approveAndInvokePurchase(address tokenAddress, string memory collectionName, uint256 value) public returns(bool){
    require(approve(tokenAddress, value) == true);
    require(IPurchasableToken(tokenAddress).purchase(this, collectionName, msg.sender, value) == true);
    emit ApprovedAndInvokedExternalPurchase(ExternalPurchaseType.Item, tokenAddress, collectionName, msg.sender, value, now);
    return true;
  }
  
  function approveAndInvokePurchase(address tokenAddress, uint256 value) public returns(bool){
    require(approve(tokenAddress, value) == true);
    require(ITradableToken(tokenAddress).purchase(address(this), msg.sender, value) == true);
    emit ApprovedAndInvokedExternalPurchase(ExternalPurchaseType.Token, tokenAddress, msg.sender, value, now);
    return true;
  }
}

contract Crowdsale is Ownable{
  uint256 private _rate;
  uint256 internal _weiRaised;

  using SafeMath for uint256;

  event RateUpdate(uint256 rate);

  constructor (uint256 rate) public {
    require(rate > 0);
    _rate = rate;
  }

  function rate() external view returns (uint256) {
    return _rate;
  }

  function weiRaised() external view returns (uint256) {
    return _weiRaised;
  }
    
  function setRate(uint256 newRate) onlyOwner external{
    _rate = newRate;
    emit RateUpdate(newRate);
  }
    
  function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal pure {
    require(beneficiary != address(0));
    require(weiAmount != 0);
  }

  function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
    return weiAmount.mul(_rate);
  }
    
  function _forwardFunds() internal {
    _owner.transfer(msg.value);
  }
}

contract Morality is RecoverableToken, Crowdsale,
  ExternalContractInvocations, CircuitBreaker { 
      
  string public name;
  string public symbol;
  uint256 public decimals;
  address payable public creator;
  
  event TokensPurchased(address indexed beneficiary, uint256 value, uint256 amount);
  event LogFundsReceived(address sender, uint amount);

  constructor(uint256 totalTokensToMint, uint256 crowdsaleRate) Crowdsale(crowdsaleRate) public {
    name = "Morality";
    symbol = "MO";
    totalSupply = totalTokensToMint;
    decimals = 18;
    balances[msg.sender] = totalSupply;
    emit Transfer(address(0), msg.sender, totalSupply);
    creator = msg.sender;
  }
  
  function() payable external applicationLockdown {
    buyTokens();
    emit LogFundsReceived(msg.sender, msg.value);
  }
  
  function transfer(address to, uint256 value) public applicationLockdown returns (bool success){
    return super.transfer(to, value);
  }
  
  function transferFrom(address from, address to, uint256 value) public applicationLockdown returns (bool success){
    return super.transferFrom(from, to, value);
  }
  
  function multipleTransfer(address[] calldata toAddresses, uint256[] calldata toValues) external applicationLockdown returns (bool) {
    require(toAddresses.length == toValues.length);
    for(uint256 i = 0;i<toAddresses.length;i++){
       require(super.transfer(toAddresses[i], toValues[i]) == true);
    }
    return true;
  }
  
  function approve(address spender, uint256 value) public applicationLockdown returns (bool) {
    return super.approve(spender, value);
  }
  
  function approveAndInvokePurchase(address tokenAddress, string memory collectionName, uint256 value) public ecpvcLockdown applicationLockdown returns(bool){
    return super.approveAndInvokePurchase(tokenAddress, collectionName, value);
  }
  
  function approveAndInvokePurchase(address tokenAddress, uint256 value) public ecpLockdown applicationLockdown returns(bool){
    return super.approveAndInvokePurchase(tokenAddress, value);
  }
  
  function buyTokens() internal applicationLockdown {
    uint256 weiAmount = msg.value;
     _preValidatePurchase(msg.sender, weiAmount);
    uint256 tokens = _getTokenAmount(weiAmount);
    transfer(msg.sender, tokens);
    _weiRaised = _weiRaised.add(weiAmount);
    //Forwad the funds to admin
    _forwardFunds();
  }

  function updateApplicationLockdownState(bool state) onlyOwner public{
    super.updateApplicationLockdownState(state);
  }
  
  function updateECPLockdownState(bool state) onlyOwner public{
    super.updateECPLockdownState(state);
  }
  
  function updateECPCVLockdownState(bool state) onlyOwner public{
    super.updateECPCVLockdownState(state);
  }
  
  function recoverTokens(ERC20 token) onlyOwner public{
     super.recoverTokens(token);
  }
  
  function isToken() public pure returns (bool) {
    return true;
  }
}