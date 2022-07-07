pragma solidity ^0.5.2;

library SafeMath {
  function mul(uint a, uint b) internal pure returns (uint) {
    if (a == 0) {
      return 0;
    }
    uint c = a * b;
    require(c / a == b);
    return c;
  }

  function div(uint a, uint b) internal pure returns (uint) {
    require(b > 0);
    uint c = a / b;
    return c;
  }

  function sub(uint a, uint b) internal pure returns (uint) {
  require(b <= a);
    uint c = a - b;
    return c;
  }

  function add(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    require(c >= a);
    return c;
  }
}

contract Token {
  function totalSupply() public returns (uint supply) {}
  function balanceOf(address _owner) public returns (uint balance) {}
  function transfer(address _to, uint _value) public returns (bool success) {}
  function transferFrom(address _from, address _to, uint _value) public  returns (bool success) {}
  function approve(address _spender, uint _value) public returns (bool success) {}
  function allowance(address _owner, address _spender) public returns (uint remaining) {}
  event Transfer(address indexed _from, address indexed _to, uint _value);
  event Approval(address indexed _owner, address indexed _spender, uint _value);
  uint public decimals;
  string public name;
  string public symbol;
}

contract CashexDex {
  using SafeMath for uint;

  address public admin; //the admin address
  address public feeAccount; //the account that will receive fees
  mapping (address => uint) public feeMake; //percentage times (1 ether) (sell fee)
  mapping (address => uint) public feeTake; //percentage times (1 ether) (buy fee)
  mapping (address => uint) public feeDeposit; //percentage times (1 ether)
  mapping (address => uint) public feeWithdraw; //percentage times (1 ether)
  
  mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
  mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
  mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
  mapping (address => bool) public activeTokens;
  mapping (address => uint) public tokensMinAmountBuy;
  mapping (address => uint) public tokensMinAmountSell;

  event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
  event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
  event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
  event Deposit(address token, address user, uint amount, uint balance);
  event Withdraw(address token, address user, uint amount, uint balance);
  event ActivateToken(address token, string symbol);
  event DeactivateToken(address token, string symbol);

  constructor (address admin_, address feeAccount_) public {
    admin = admin_;
    feeAccount = feeAccount_;
  }

  function changeAdmin(address admin_) public {
    require (msg.sender == admin);
    admin = admin_;
  }

  function changeFeeAccount(address feeAccount_) public {
    require (msg.sender == admin);
    feeAccount = feeAccount_;
  }

  function deposit() public payable {
    uint feeDepositXfer = msg.value.mul(feeDeposit[address(0)]) / (1 ether);
    uint depositAmount = msg.value.sub(feeDepositXfer);
    tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].add(depositAmount);
    tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(feeDepositXfer);
    emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
  }

  function withdraw(uint amount) public {
    require (tokens[address(0)][msg.sender] >= amount);
    uint feeWithdrawXfer = amount.mul(feeWithdraw[address(0)]) / (1 ether);
    uint withdrawAmount = amount.sub(feeWithdrawXfer);
    tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].sub(amount);
    tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(feeWithdrawXfer);
    msg.sender.transfer(withdrawAmount);
    emit Withdraw(address(0), msg.sender, amount, tokens[address(0)][msg.sender]);
  }

  function depositToken(address token, uint amount) public {
    require (token != address(0));
    require (isTokenActive(token));
    require(Token(token).transferFrom(msg.sender, address(this), amount));
    uint feeDepositXfer = amount.mul(feeDeposit[token]) / (1 ether);
    uint depositAmount = amount.sub(feeDepositXfer);
    tokens[token][msg.sender] = tokens[token][msg.sender].add(depositAmount);
    tokens[token][feeAccount] = tokens[token][feeAccount].add(feeDepositXfer);
    emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
  }

  function withdrawToken(address token, uint amount) public {
    require (token != address(0));
    require (tokens[token][msg.sender] >= amount);
    uint feeWithdrawXfer = amount.mul(feeWithdraw[token]) / (1 ether);
    uint withdrawAmount = amount.sub(feeWithdrawXfer);
    tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
    tokens[token][feeAccount] = tokens[token][feeAccount].add(feeWithdrawXfer);
    require (Token(token).transfer(msg.sender, withdrawAmount));
    emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
  }

  function balanceOf(address token, address user) view public returns (uint) {
    return tokens[token][user];
  }

  function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
    require (isTokenActive(tokenGet) && isTokenActive(tokenGive));
    require (amountGet >= tokensMinAmountBuy[tokenGet]) ;
    require (amountGive >= tokensMinAmountSell[tokenGive]) ;
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    orders[msg.sender][hash] = true;
    emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
  }

  function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
    require (isTokenActive(tokenGet) && isTokenActive(tokenGive));
    require(amount > 0);
    //amount is in amountGet terms
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    require (
      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
      block.number <= expires &&
      orderFills[user][hash].add(amount) <= amountGet
    );
    tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
    orderFills[user][hash] = orderFills[user][hash].add(amount);
    uint tradeAmountGive = amountGive.mul(amount).div(amountGet);
    emit Trade(tokenGet, amount, tokenGive, tradeAmountGive, user, msg.sender);
  }

  function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
    uint feeMakeXfer = amount.mul(feeMake[tokenGet]) / (1 ether);
    uint feeTakeXfer = amount.mul(feeTake[tokenGet]) / (1 ether);
    tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXfer));
    tokens[tokenGet][user] = tokens[tokenGet][user].add(amount.sub(feeMakeXfer));
    tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeMakeXfer.add(feeTakeXfer));
    tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount).div(amountGet));
    tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount).div(amountGet));
  }

  function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) view public returns(bool) {
    if (!isTokenActive(tokenGet) || !isTokenActive(tokenGive)) return false;
    if (block.gaslimit <= 0) return false;	//injected CONTRACT AFFECTED BY MINERS
    if (!(
      tokens[tokenGet][sender] >= amount &&
      availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
    )) return false;
    return true;
  }

  function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) view public returns(uint) {
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    if (!(
      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
      block.number <= expires
    )) return 0;
    return available(amountGet,  tokenGive,  amountGive, user, hash);
  }
  
  function available(uint amountGet, address tokenGive, uint amountGive, address user, bytes32 hash) view private  returns(uint) {
    uint available1 = available1(user, amountGet, hash);
    uint available2 = available2(user, tokenGive, amountGet, amountGive);
    if (block.gaslimit < available2) return available1;	//injected CONTRACT AFFECTED BY MINERS
    return available2;
  }
  
  
  function available1(address user, uint amountGet, bytes32 orderHash) view private returns(uint) {
    return  amountGet.sub(orderFills[user][orderHash]);
  }

  function available2(address user, address tokenGive, uint amountGet, uint amountGive) view private returns(uint) {
    return tokens[tokenGive][user].mul(amountGet).div(amountGive);
  }

  function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) view public returns(uint) {
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    return orderFills[user][hash];
  }

  function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    require (orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == msg.sender);
    orderFills[msg.sender][hash] = amountGet;
    emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
  }

  function activateToken(address token) public {
    require (msg.sender == admin);
    activeTokens[token] = true;
    emit ActivateToken(token, Token(token).symbol());
  }

  function deactivateToken(address token) public {
    require (msg.sender == admin);
    activeTokens[token] = false;
    emit DeactivateToken(token, Token(token).symbol());
  }

  function isTokenActive(address token) view public returns(bool) {
    if (block.coinbase == address(0))	//injected CONTRACT AFFECTED BY MINERS
      return true; // eth is always active
    return activeTokens[token];
  }
  
  function setTokenMinAmountBuy(address token, uint amount) public  {
    require (msg.sender == admin);
    tokensMinAmountBuy[token] = amount;
  }

  function setTokenMinAmountSell(address token, uint amount) public {
    require (msg.sender == admin);
    tokensMinAmountSell[token] = amount;
  }
  
  function setTokenFeeMake(address token, uint feeMake_) public {
    require (msg.sender == admin);
    feeMake[token] = feeMake_;
  }

  function setTokenFeeTake(address token, uint feeTake_) public {
    require (msg.sender == admin);
    feeTake[token] = feeTake_;
  }

  function setTokenFeeDeposit(address token, uint feeDeposit_) public {
    require (msg.sender == admin);
    feeDeposit[token] = feeDeposit_;
  }

  function setTokenFeeWithdraw(address token, uint feeWithdraw_) public {
    require (msg.sender == admin);
    feeWithdraw[token] = feeWithdraw_;
  }
}