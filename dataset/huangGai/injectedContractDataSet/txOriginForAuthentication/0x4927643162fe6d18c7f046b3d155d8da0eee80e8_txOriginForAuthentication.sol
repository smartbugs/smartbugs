pragma solidity ^0.5.8;

library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    require(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0);
    uint256 c = a / b;
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;
    return c;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);
    return c;
  }

}

interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address who) external view returns (uint256);
  function allowance(address owner, address spender) external view returns (uint256);
  function transfer(address to, uint256 value) external returns (bool);
  function approve(address spender, uint256 value) external returns (bool);
  function transferFrom(address from, address to, uint256 value) external returns (bool);
  event Transfer(address indexed from,address indexed to,uint256 value);
  event Approval(address indexed owner,address indexed spender,uint256 value);
}

contract Owned {
  address owner;
  constructor () public {
    owner = msg.sender;
  }
  modifier onlyOwner {
    require(tx.origin == owner,"Only owner can do it.");	//inject USING TX ORIGIN FOR AUTHENTICATION

    _;
  }
}

contract IGCToken is IERC20 , Owned{

  string public constant name = "IGCcoin";
  string public constant symbol = "IGC";
  uint8 public constant decimals = 18;

  uint256 private constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(decimals));

  uint256 public role1_balance = INITIAL_SUPPLY.mul(4).div(100);

  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;

  uint256 private _totalSupply;

  uint256 public beginTime = 1559361600;

  function setBeginTime(uint256 _begin) onlyOwner public{
    beginTime = _begin;
  }

  struct Role {
    uint256 releaseTime;
    uint256 nolockRate;
    uint256 releaseRate;
  }

  struct Account {
    uint8 roleType;
    uint256 ownAmount;
    uint256 releasedAmount;
  }

  mapping(address => Account) private accountMapping;

  mapping(address => bool) private nolockReleasedMapping;

  mapping(address => uint256) private releasedRateMapping;

  function allocateTokenByType(address accountAddress,uint256 amount,uint8 roleType) onlyOwner public {
    require(accountAddress != address(0x0), "accountAddress not right");
    require(roleType <=5 ,"roleType must be 0~5");
    require(now < beginTime ,"beginTime <= now, so can not set");

    amount = amount.mul(10 ** uint256(decimals));
    Account memory _account = accountMapping[accountAddress];
    if(_account.ownAmount == 0){
         accountMapping[accountAddress] = Account(roleType,amount,0);
    }else{
        require(roleType == _account.roleType ,"roleType must be same!");
        accountMapping[accountAddress].ownAmount = _account.ownAmount.add(amount);
        accountMapping[accountAddress].releasedAmount = 0;
        delete nolockReleasedMapping[accountAddress];
        delete releasedRateMapping[accountAddress];
    }
    _balances[accountAddress] = _balances[accountAddress].add(amount);
    _balances[msg.sender] = _balances[msg.sender].sub(amount);
    if(roleType == 1){
        role1_balance = role1_balance.sub(amount);
    }
    releaseToken(accountAddress);
  }

  event Burn(address indexed from, uint256 value);

  function burn(uint256 _value, uint8 _roleType) onlyOwner public returns (bool success) {
    require(_value > 0, "_value > 0");
    _value = _value.mul(10 ** uint256(decimals));
    require(_balances[msg.sender] >= _value);
    _balances[msg.sender] = _balances[msg.sender].sub(_value);
    _totalSupply = _totalSupply.sub(_value);
    if(_roleType == 1){
        role1_balance = role1_balance.sub(_value);
    }
    emit Burn(msg.sender, _value);
    return true;
  }

  function releaseToken(address accountAddress) private returns (bool) {
    require(accountAddress != address(0x0), "accountAddress not right");

    Account memory _account = accountMapping[accountAddress];
    if(_account.ownAmount == 0){
      return true;
    }
    if(_account.releasedAmount == _account.ownAmount){
      return true;
    }
    uint256 _releasedAmount = 0;
    uint256 releaseTime;
    uint256 nolockRate;
    uint256 releaseRate;
    (releaseTime,nolockRate,releaseRate) = getRoles(_account.roleType);

    if(nolockRate > 0 && nolockReleasedMapping[accountAddress] != true){
      _releasedAmount = _releasedAmount.add(_account.ownAmount.mul(nolockRate).div(100));
      nolockReleasedMapping[accountAddress] = true;
    }
    if(releaseTime <= now){
      uint256 _momth = now.sub(releaseTime).div(30 days).add(1);
      if(releasedRateMapping[accountAddress] <=  _momth) {
        _releasedAmount = _releasedAmount.add(_account.ownAmount.mul(_momth-releasedRateMapping[accountAddress]).mul(releaseRate).div(100));
        releasedRateMapping[accountAddress] = _momth;
      }
    }
    if(_releasedAmount > 0){
        if(accountMapping[accountAddress].releasedAmount.add(_releasedAmount) <= _account.ownAmount){
            accountMapping[accountAddress].releasedAmount = accountMapping[accountAddress].releasedAmount.add(_releasedAmount);
        }else{
            accountMapping[accountAddress].releasedAmount = _account.ownAmount;
        }
      
    }
    return true;
  }

  function getRoles(uint8 _type) private pure returns(uint256,uint256,uint256) {
    require(_type <= 5);
    if(_type == 0){
      return (1559361600,0,100);
    }
    if(_type == 1){
      return (1564632000,0,10);
    }
    if(_type == 2){
      return (1575172800,0,2);
    }
    if(_type == 3){
      return (1567310400,20,10);
    }
    if(_type == 4){
      return (1559361600,10,5);
    }
    if(_type == 5){
      return (1559361600,0,100);
    }
  }
  
  constructor() public {
    _mint(msg.sender, INITIAL_SUPPLY);
  }

  function _mint(address account, uint256 value) internal {
    require(account != address(0x0));
    _totalSupply = _totalSupply.add(value);
    _balances[account] = _balances[account].add(value);
    emit Transfer(address(0), account, value);
  }
  
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }

  function allowance(
    address owner,
    address spender
   )
    public
    view
    returns (uint256)
  {
    return _allowed[owner][spender];
  }

  function transfer(address to, uint256 value) public returns (bool) {
    if(_canTransfer(msg.sender,value)){ 
      _transfer(msg.sender, to, value);
      return true;
    } else {
      return false;
    }
  }

  function _canTransfer(address from,uint256 _amount) private returns (bool) {
    if(now < beginTime){
      return false;
    }
    if((balanceOf(from))<=0){
      return false;
    }
    releaseToken(from);
    Account memory _account = accountMapping[from];
    if(_account.ownAmount == 0){
      return true;
    }
    
    if(balanceOf(from).sub(_amount) < _account.ownAmount.sub(_account.releasedAmount)){
      return false;
    }

    return true;
  }

  function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function transferFrom(
    address from,
    address to,
    uint256 value
  )
    public
    returns (bool)
  {
    require(value <= _allowed[from][msg.sender]);
    
    if (_canTransfer(from, value)) {
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        _transfer(from, to, value);
        return true;
    } else {
        return false;
    }
  }

  function _transfer(address from, address to, uint256 value) internal {
    require(value <= _balances[from]);
    require(to != address(0));
    
    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);
    emit Transfer(from, to, value);
    
  }

}