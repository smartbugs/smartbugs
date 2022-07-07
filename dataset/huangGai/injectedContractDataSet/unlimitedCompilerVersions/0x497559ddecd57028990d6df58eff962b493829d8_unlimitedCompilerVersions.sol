/**
 *Submitted for verification at Etherscan.io on 2020-04-12
*/

pragma solidity ^0.6.4;	//inject UNLIMITED COMPILER VERSIONS

contract Context {
  constructor () internal { }
  function _msgSender() internal view virtual returns (address payable) {
    return msg.sender;
  }
  function _msgData() internal view virtual returns (bytes memory) {
    this;
    return msg.data;
  }
}

contract Owned {
  address public owner;
  address public newOwner;

  event OwnershipTransferred(address indexed _from, address indexed _to);

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    newOwner = _newOwner;
  }
  function acceptOwnership() public {
    require(msg.sender == newOwner);
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
    newOwner = address(0);
  }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract brrrrrrr is IERC20, Context, Owned {
  using SafeMath for uint256;
  using NameFilter for string;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event iBailout(address account);
  event bBailout(address account, string kind, bytes32 message);

  constructor() public {
    symbol = "BRSD";
    name = "BRRRRRRR";
    decimals = 2;

    mostRecent = 604451600000000;
    lastUpdated = 1586304000;
    rate = 65018849;
    brr = true;

    bailoutEnd = 1590969600;
    individualBailoutAmount = 120000;
    individualBailoutMaxBalance = 10**18;

    bailoutRules[0].amount = 50 * 10**3 * 10**(decimals);
    bailoutRules[0].minBalance = 0;
    bailoutRules[0].kind = "Individual Plus";
    bailoutRules[0].cost = 10**15;

    bailoutRules[1].amount = 750 * 10**3 * 10**(decimals);
    bailoutRules[1].minBalance = 0;
    bailoutRules[1].kind = "Small Business";
    bailoutRules[1].cost = 10**16;

    bailoutRules[2].amount = 10 * 10**6 * 10**(decimals);
    bailoutRules[2].minBalance = 10**18;
    bailoutRules[2].kind = "Medium Business";
    bailoutRules[2].cost = 10**17;

    bailoutRules[3].amount = 200 * 10**6 * 10**(decimals);
    bailoutRules[3].minBalance = 10 * 10**18;
    bailoutRules[3].kind = "Big Business";
    bailoutRules[3].cost = 10**18;

    bailoutRules[4].amount = 100 * 10**9 * 10**(decimals);
    bailoutRules[4].minBalance = 250 * 10**18;
    bailoutRules[4].kind = "Big Bank";
    bailoutRules[4].cost = 25 * 10**18;

    _transfer(address(this), owner, 100 * 10**9 * 10**(decimals));
  }

  struct bailoutRulesStruct{
    uint256 amount;
    uint256 minBalance;
    string kind;
    uint256 cost;
  }

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  mapping (address => uint256) public lastBailout;

  uint256 private _totalSupply;

  string public name;
  string public symbol;
  uint256 public decimals;

  //BAILOUT VARIALBES
  uint256 public bailoutEnd;
  uint256 public individualBailoutAmount;
  uint256 public individualBailoutMaxBalance;
  mapping(uint256 => bailoutRulesStruct) public bailoutRules;

  //SUPPLY VARIABLES
  //CONTROLLING THE SUPPLY OF BRRSD RELATED TO THE FED RESERVE BALANCE SHEET
  //THIS WILL OVERCORRECT WHEN THE RATE OF CHANGE OF MONEY SUPPLY CHANGES
  //BUT WILL NEVER BE OFF BY MORE THAN A WEEK
  uint256 public mostRecent;    //VALUE FROM FED BALANCE SHEET..
  uint256 public lastUpdated;   //DATE LAST UPDATED IN SECONDS.
  uint256 public rate;          //RATE OF INCREASE PER SECOND. TAKEN FROM FED BALANCE SHEET INCREASE FROM PAST WEEK.
  bool public brr;              //CONTROLS IF NUMBER GOES UP OR DOWN. IF TRUE IT MEANS RATE IS ADDING,. IF FALSE IT'S DECREASING.

  function testView() public view returns(uint256){
    uint256 timeDiff = now - lastUpdated;
    return(timeDiff);
  }

  function adjustSupply() public {
    uint256 timeDiff = now.sub(lastUpdated);
    uint256 amount = timeDiff.mul(rate);
    if(brr) {
      uint256 supplyNew = amount.add(mostRecent);
      if(_totalSupply < supplyNew) {
        _mint(address(this), supplyNew.sub(_totalSupply));
      }
    }
    else {
      if(mostRecent > amount) {
        uint256 supplyNew = mostRecent.sub(amount);
        if (_totalSupply > supplyNew) {
          if(_balances[address(this)] >= amount) {
            _burn(address(this), amount);
          }
        }
      }
    }
  }

  function individualBailout() public {
    require(lastBailout[msg.sender] + 1 days < now, "You need to wait 1 day before claiming another bailout");
    require(now < bailoutEnd, "Bailouts are no longer available. No more government handouts bitch!");
    require(individualBailoutMaxBalance > msg.sender.balance, "You are too rich for an individual bailout.");
    lastBailout[msg.sender] = now;
    _transfer(address(this), msg.sender, individualBailoutAmount);
    emit iBailout(msg.sender);
  }
  function bigBailout(uint256 index, string memory message) public payable {
    bytes32 fname = message.nameFilter();
    require(msg.sender.balance >= bailoutRules[index].minBalance, "You are too poor to qualify for this bailout tier");
    require(now < bailoutEnd, "Bailouts are no longer available. No more government handouts bitch!");
    require(msg.value >= bailoutRules[index].cost, "Ethereum sent lower than cost.");
    _transfer(address(this), msg.sender, bailoutRules[index].amount);
    emit bBailout(msg.sender, bailoutRules[index].kind, fname);
  }
  //ADMIN only functions
  function setBailoutRule(uint256 index, uint256 amount, uint256 minBalance, string memory kind, uint256 cost) public onlyOwner() {
    bailoutRules[index].amount = amount;
    bailoutRules[index].minBalance = minBalance;
    bailoutRules[index].kind = kind;
    bailoutRules[index].cost = cost;
  }
  function setBailoutEnd(uint256 endtime) public onlyOwner() {
    bailoutEnd = endtime;
  }
  function setIndividualBailout(uint256 amount, uint256 max) public onlyOwner() {
    individualBailoutAmount = amount;
    individualBailoutMaxBalance = max;
  }
  function newFedData(uint256 _mostRecent, uint256 _lastUpdated, uint256 _rate, bool _brr) public onlyOwner() {
    mostRecent = _mostRecent;
    lastUpdated = _lastUpdated;
    rate = _rate;
    brr = _brr;
    if(_totalSupply >= _mostRecent) {
      if(_balances[address(this)] >= _totalSupply.sub(_mostRecent)) {
        _burn(address(this), _totalSupply.sub(_mostRecent));
      }
    }
    else if(_totalSupply < _mostRecent) {
      _mint(address(this), _mostRecent.sub(_totalSupply));
    }
  }
  function approveOtherContract(address account, uint256 amount) public onlyOwner() returns(bool) {
    _approve(address(this), account, amount);
    return true;
  }
  //allows admin to withdraw other ERC-20 tokens from the contract.
  function adminwithdrawal(IERC20 token, uint256 amount) public onlyOwner() {
    IERC20 thisToken = IERC20(address(this));
    require(token != thisToken);
    token.transfer(msg.sender, amount);
  }
  function clearETH() public onlyOwner() {
    address payable _owner = msg.sender;
    _owner.transfer(address(this).balance);
  }

  function totalSupply() public view override returns (uint256) {
      return _totalSupply;
  }
  function balanceOf(address account) public view override returns (uint256) {
      return _balances[account];
  }
  function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
      _transfer(_msgSender(), recipient, amount);
      return true;
  }
  function allowance(address owner, address spender) public view virtual override returns (uint256) {
      return _allowances[owner][spender];
  }
  function approve(address spender, uint256 amount) public virtual override returns (bool) {
      _approve(_msgSender(), spender, amount);
      return true;
  }
  function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
      _transfer(sender, recipient, amount);
      _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
      return true;
  }
  function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
      _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
      return true;
  }
  function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
      _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
      return true;
  }
  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
      require(sender != address(0), "ERC20: transfer from the zero address");
      require(recipient != address(0), "ERC20: transfer to the zero address");

      _beforeTokenTransfer(sender, recipient, amount);

      adjustSupply();

      _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
      _balances[recipient] = _balances[recipient].add(amount);
      emit Transfer(sender, recipient, amount);
  }
  function _mint(address account, uint256 amount) internal virtual {
      require(account != address(0), "ERC20: mint to the zero address");

      _beforeTokenTransfer(address(0), account, amount);

      _totalSupply = _totalSupply.add(amount);
      _balances[account] = _balances[account].add(amount);
      emit Transfer(address(0), account, amount);
  }
  function _burn(address account, uint256 amount) internal virtual {
      require(account != address(0), "ERC20: burn from the zero address");

      _beforeTokenTransfer(account, address(0), amount);

      _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
      _totalSupply = _totalSupply.sub(amount);
      emit Transfer(account, address(0), amount);
  }
  function _approve(address owner, address spender, uint256 amount) internal virtual {
      require(owner != address(0), "ERC20: approve from the zero address");
      require(spender != address(0), "ERC20: approve to the zero address");

      _allowances[owner][spender] = amount;
      emit Approval(owner, spender, amount);
  }
  function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");
    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;
    return c;
  }
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");
    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;
    return c;
  }
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

library NameFilter {

    function nameFilter(string memory _input)
        internal
        pure
        returns(bytes32)
    {
        bytes memory _temp = bytes(_input);
        uint256 _length = _temp.length;

        //sorry limited to 16 characters
        require (_length <= 16 && _length > 0, "string must be between 1 and 16 characters");
        // convert & check
        for (uint256 i = 0; i < _length; i++)
        {
          require
          (
              // require character is a space or period or @ or _ or #
              _temp[i] == 0x20 || _temp[i] == 0x2E || _temp[i] == 0x40 ||
              _temp[i] == 0x5F || _temp[i] == 0x23 ||
              // OR lowercase a-z
              (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
              //Or uppercase A-Z
              (_temp[i] > 0x40 && _temp[i] < 0x5b) ||
              // or 0-9
              (_temp[i] > 0x2f && _temp[i] < 0x3a),
              "string contains invalid characters"
          );
        }

        bytes32 _ret;
        assembly {
            _ret := mload(add(_temp, 32))
        }
        return (_ret);
    }
}