/**
 *Submitted for verification at Etherscan.io on 2020-02-19
*/

pragma solidity >= 0.5.12;

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

contract Owned {
  address public owner;
  address public newOwner;

  event OwnershipTransferred(address indexed _from, address indexed _to);

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(true);
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

contract ERCWAR is Owned {

  event playerenter(address player, address token, uint256 amount, uint256 cost);
  event gameended(address winner, uint256 sttamount, uint256 pyroamount);

  constructor() public {
    stt = 0xaC9Bb427953aC7FDDC562ADcA86CF42D988047Fd;
    tokenbase[stt] = 10**20;

    pyro = 0x14409B0Fc5C7f87b5DAd20754fE22d29A3dE8217;
    tokenbase[pyro] = 25 * 10**18;

    stopblock = block.number + 6000;
  }

  uint256 public stopblock;
  address public winner;

  mapping(address => uint256) public entries;
  mapping(address => uint256) public tokenbase;
  mapping(address => uint256) public blockbalance;
  mapping(uint256 => address) public winpool;

  bool public ended;

  address stt;
  address pyro;


  modifier isEnded {
    require(ended == true);
    _;
  }

  modifier notEnded {
    require(ended == false);
    _;
  }



  function enter(address token, uint256 amount) public notEnded() {
    require(amount > 0);
    require(tokenbase[token] != 0);
    if(block.number >= stopblock){
      endgame();
    }
    else {
      IERC20 itoken = IERC20(token);
      uint256 blockcost = getblockcost(token);
      uint256 _cost = amount * blockcost;

      require(itoken.transferFrom(msg.sender, address(this), _cost));

      if(stopblock + amount - block.number > 6000) {
        stopblock = block.number + 6000;
      }
      else {
        stopblock = amount + stopblock;
      }
      entries[token] = amount + entries[token];
      winner = msg.sender;
      blockbalance[msg.sender] = blockbalance[msg.sender] + amount;

      poolhandler(msg.sender);

      emit playerenter(msg.sender, token, amount, _cost);
    }
  }

  function endgame() public notEnded() {
    if(block.number >= stopblock) {
      IERC20 _istt = IERC20(stt);
      IERC20 _ipyro = IERC20(pyro);
      uint256 _contractstt = _istt.balanceOf(address(this));
      uint256 _contractpyro = _ipyro.balanceOf(address(this));
      uint256 _sttshare = _contractstt / 25;
      uint256 _pyroshare = _contractpyro / 25;
      uint256 _sttwinner = _contractstt -  _sttshare * 5;
      uint256 _pyrowinner = _contractpyro -  _pyroshare * 5;

      uint256 _i = 0;
      for (_i = 0; _i < 5; _i++) {
        _istt.transfer(winpool[_i], _sttshare);
        _ipyro.transfer(winpool[_i], _pyroshare);
      }

      _istt.transfer(winner, _sttwinner);
      _ipyro.transfer(winner, _pyrowinner);
      ended = true;
      emit gameended(winner, _contractstt, _contractpyro);
    }
  }

  function poolhandler(address _addr) internal returns(bool){

    uint256 low = 0;

    for(uint256 i = 0; i < 5; i++) {
      if(winpool[i] == _addr){
        return(false);
      }
      if(blockbalance[winpool[low]] > blockbalance[winpool[i]]) {
        low = i;
      }
    }

    if(blockbalance[_addr] > blockbalance[winpool[low]]) {
      winpool[low] = _addr;
    }
    return(true);
  }


  //VIEW FUNCTIONS
  function getblockcost(address token) public view returns(uint256) {
    uint256 tmp = entries[pyro] + entries[stt];
    uint256 a;
    if (tmp >= 10**5) {
      a = 20 * tokenbase[token] *  entries[token] / tmp;
    }
    else {
      a = tokenbase[token] + (entries[token] * tokenbase[token]) / 10**4;
    }
    return(a);
  }

  //ADMIN FUNCTIONS
  function adminwithdrawal(address token, uint256 amount) public onlyOwner() isEnded() {
    IERC20 itoken = IERC20(token);
    itoken.transfer(msg.sender, amount);
  }
  function clearETH() public onlyOwner() {
    address payable _owner = msg.sender;
    _owner.transfer(address(this).balance);
  	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT


}