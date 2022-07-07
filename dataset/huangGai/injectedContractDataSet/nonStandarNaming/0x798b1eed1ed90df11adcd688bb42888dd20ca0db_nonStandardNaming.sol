pragma solidity ^0.5.2;

library SafeMath {
  function MUL925(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
    if (a == 0) {
      return 0;
    }
    uint c = a * b;
    require(c / a == b);
    return c;
  }

  function DIV533(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
    require(b > 0);
    uint c = a / b;
    return c;
  }

  function SUB977(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
  require(b <= a);
    uint c = a - b;
    return c;
  }

  function ADD680(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
    uint c = a + b;
    require(c >= a);
    return c;
  }
}

contract Token {
  function TOTALSUPPLY944() public returns (uint supply) {}	//inject NONSTANDARD NAMING
  function BALANCEOF651(address _owner) public returns (uint balance) {}	//inject NONSTANDARD NAMING
  function TRANSFER915(address _to, uint _value) public returns (bool success) {}	//inject NONSTANDARD NAMING
  function TRANSFERFROM250(address _from, address _to, uint _value) public  returns (bool success) {}	//inject NONSTANDARD NAMING
  function APPROVE235(address _spender, uint _value) public returns (bool success) {}	//inject NONSTANDARD NAMING
  function ALLOWANCE981(address _owner, address _spender) public returns (uint remaining) {}	//inject NONSTANDARD NAMING
  event TRANSFER161(address indexed _from, address indexed _to, uint _value);	//inject NONSTANDARD NAMING
  event APPROVAL494(address indexed _owner, address indexed _spender, uint _value);	//inject NONSTANDARD NAMING
  uint public decimals;
  string public name;
  string public symbol;
}

contract DEX_Orgon {
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

  event ORDER901(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);	//inject NONSTANDARD NAMING
  event CANCEL650(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);	//inject NONSTANDARD NAMING
  event TRADE560(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);	//inject NONSTANDARD NAMING
  event DEPOSIT211(address token, address user, uint amount, uint balance);	//inject NONSTANDARD NAMING
  event WITHDRAW585(address token, address user, uint amount, uint balance);	//inject NONSTANDARD NAMING
  event ACTIVATETOKEN153(address token, string symbol);	//inject NONSTANDARD NAMING
  event DEACTIVATETOKEN237(address token, string symbol);	//inject NONSTANDARD NAMING

  constructor (address admin_, address feeAccount_) public {
    admin = admin_;
    feeAccount = feeAccount_;
  }

  function CHANGEADMIN303(address admin_) public {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    admin = admin_;
  }

  function CHANGEFEEACCOUNT535(address feeAccount_) public {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    feeAccount = feeAccount_;
  }

  function DEPOSIT962() public payable {	//inject NONSTANDARD NAMING
    uint feeDepositXfer = msg.value.MUL925(feeDeposit[address(0)]) / (1 ether);
    uint depositAmount = msg.value.SUB977(feeDepositXfer);
    tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].ADD680(depositAmount);
    tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].ADD680(feeDepositXfer);
    emit DEPOSIT211(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
  }

  function WITHDRAW601(uint amount) public {	//inject NONSTANDARD NAMING
    require (tokens[address(0)][msg.sender] >= amount);
    uint feeWithdrawXfer = amount.MUL925(feeWithdraw[address(0)]) / (1 ether);
    uint withdrawAmount = amount.SUB977(feeWithdrawXfer);
    tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].SUB977(amount);
    tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].ADD680(feeWithdrawXfer);
    msg.sender.transfer(withdrawAmount);
    emit WITHDRAW585(address(0), msg.sender, amount, tokens[address(0)][msg.sender]);
  }

  function DEPOSITTOKEN735(address token, uint amount) public {	//inject NONSTANDARD NAMING
    require (token != address(0));
    require (ISTOKENACTIVE523(token));
    require(Token(token).TRANSFERFROM250(msg.sender, address(this), amount));
    uint feeDepositXfer = amount.MUL925(feeDeposit[token]) / (1 ether);
    uint depositAmount = amount.SUB977(feeDepositXfer);
    tokens[token][msg.sender] = tokens[token][msg.sender].ADD680(depositAmount);
    tokens[token][feeAccount] = tokens[token][feeAccount].ADD680(feeDepositXfer);
    emit DEPOSIT211(token, msg.sender, amount, tokens[token][msg.sender]);
  }

  function WITHDRAWTOKEN844(address token, uint amount) public {	//inject NONSTANDARD NAMING
    require (token != address(0));
    require (tokens[token][msg.sender] >= amount);
    uint feeWithdrawXfer = amount.MUL925(feeWithdraw[token]) / (1 ether);
    uint withdrawAmount = amount.SUB977(feeWithdrawXfer);
    tokens[token][msg.sender] = tokens[token][msg.sender].SUB977(amount);
    tokens[token][feeAccount] = tokens[token][feeAccount].ADD680(feeWithdrawXfer);
    require (Token(token).TRANSFER915(msg.sender, withdrawAmount));
    emit WITHDRAW585(token, msg.sender, amount, tokens[token][msg.sender]);
  }

  function BALANCEOF651(address token, address user) view public returns (uint) {	//inject NONSTANDARD NAMING
    return tokens[token][user];
  }

  function ORDER93(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {	//inject NONSTANDARD NAMING
    require (ISTOKENACTIVE523(tokenGet) && ISTOKENACTIVE523(tokenGive));
    require (amountGet >= tokensMinAmountBuy[tokenGet]) ;
    require (amountGive >= tokensMinAmountSell[tokenGive]) ;
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    orders[msg.sender][hash] = true;
    emit ORDER901(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
  }

  function TRADE298(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {	//inject NONSTANDARD NAMING
    require (ISTOKENACTIVE523(tokenGet) && ISTOKENACTIVE523(tokenGive));
    //amount is in amountGet terms
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    require (
      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
      block.number <= expires &&
      orderFills[user][hash].ADD680(amount) <= amountGet
    );
    TRADEBALANCES341(tokenGet, amountGet, tokenGive, amountGive, user, amount);
    orderFills[user][hash] = orderFills[user][hash].ADD680(amount);
    emit TRADE560(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
  }

  function TRADEBALANCES341(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {	//inject NONSTANDARD NAMING
    uint feeMakeXfer = amount.MUL925(feeMake[tokenGet]) / (1 ether);
    uint feeTakeXfer = amount.MUL925(feeTake[tokenGet]) / (1 ether);
    tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].SUB977(amount.ADD680(feeTakeXfer));
    tokens[tokenGet][user] = tokens[tokenGet][user].ADD680(amount.SUB977(feeMakeXfer));
    tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].ADD680(feeMakeXfer.ADD680(feeTakeXfer));
    tokens[tokenGive][user] = tokens[tokenGive][user].SUB977(amountGive.MUL925(amount).DIV533(amountGet));
    tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].ADD680(amountGive.MUL925(amount).DIV533(amountGet));
  }

  function TESTTRADE501(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) view public returns(bool) {	//inject NONSTANDARD NAMING
    if (!ISTOKENACTIVE523(tokenGet) || !ISTOKENACTIVE523(tokenGive)) return false;
    if (!(
      tokens[tokenGet][sender] >= amount &&
      AVAILABLEVOLUME148(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
    )) return false;
    return true;
  }

  function AVAILABLEVOLUME148(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) view public returns(uint) {	//inject NONSTANDARD NAMING
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    if (!(
      (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
      block.number <= expires
    )) return 0;
    return AVAILABLE249(amountGet,  tokenGive,  amountGive, user, hash);
  }
  
  function AVAILABLE249(uint amountGet, address tokenGive, uint amountGive, address user, bytes32 hash) view private  returns(uint) {	//inject NONSTANDARD NAMING
    uint available1 = AVAILABLE1164(user, amountGet, hash);
    uint available2 = AVAILABLE265(user, tokenGive, amountGet, amountGive);
    if (available1 < available2) return available1;
    return available2;
  }
  
  
  function AVAILABLE1164(address user, uint amountGet, bytes32 orderHash) view private returns(uint) {	//inject NONSTANDARD NAMING
    return  amountGet.SUB977(orderFills[user][orderHash]);
  }

  function AVAILABLE265(address user, address tokenGive, uint amountGet, uint amountGive) view private returns(uint) {	//inject NONSTANDARD NAMING
    return tokens[tokenGive][user].MUL925(amountGet).DIV533(amountGive);
  }

  function AMOUNTFILLED138(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) view public returns(uint) {	//inject NONSTANDARD NAMING
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    return orderFills[user][hash];
  }

  function CANCELORDER664(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {	//inject NONSTANDARD NAMING
    bytes32 hash = sha256(abi.encodePacked(address(this), tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
    require (orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == msg.sender);
    orderFills[msg.sender][hash] = amountGet;
    emit CANCEL650(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
  }

  function ACTIVATETOKEN73(address token) public {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    activeTokens[token] = true;
    emit ACTIVATETOKEN153(token, Token(token).symbol());
  }

  function DEACTIVATETOKEN190(address token) public {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    activeTokens[token] = false;
    emit DEACTIVATETOKEN237(token, Token(token).symbol());
  }

  function ISTOKENACTIVE523(address token) view public returns(bool) {	//inject NONSTANDARD NAMING
    if (token == address(0))
      return true; // eth is always active
    return activeTokens[token];
  }
  
  function SETTOKENMINAMOUNTBUY334(address token, uint amount) public  {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    tokensMinAmountBuy[token] = amount;
  }

  function SETTOKENMINAMOUNTSELL817(address token, uint amount) public {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    tokensMinAmountSell[token] = amount;
  }
  
  function SETTOKENFEEMAKE257(address token, uint feeMake_) public {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    feeMake[token] = feeMake_;
  }

  function SETTOKENFEETAKE459(address token, uint feeTake_) public {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    feeTake[token] = feeTake_;
  }

  function SETTOKENFEEDEPOSIT880(address token, uint feeDeposit_) public {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    feeDeposit[token] = feeDeposit_;
  }

  function SETTOKENFEEWITHDRAW248(address token, uint feeWithdraw_) public {	//inject NONSTANDARD NAMING
    require (msg.sender == admin);
    feeWithdraw[token] = feeWithdraw_;
  }
}