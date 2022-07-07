/**
 *Submitted for verification at Etherscan.io on 2020-02-28
*/

pragma solidity >= 0.5.12;

library SafeMath {
  function add(uint a, uint b) internal pure returns (uint c) {
    c = a + b;
    require(c >= a);
  }
  function sub(uint a, uint b) internal pure returns (uint c) {
    require(b <= a);
    c = a - b;
  }
  function mul(uint a, uint b) internal pure returns (uint c) {
    c = a * b;
    require(a == 0 || c / a == b);
  }
  function div(uint a, uint b) internal pure returns (uint c) {
    require(b > 0);
    c = a / b;
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

contract LastBuy_beta_2 is Owned {
  using SafeMath for uint;

  event playerenter(address player, address token, uint256 amount, uint256 cost);
  event winnerclaim(address winner, address token, uint256 amount);
  event poolclaim(address player, address token, uint256 amount);

  constructor() public {
    //stt
    tokenlist[0] = 0xaC9Bb427953aC7FDDC562ADcA86CF42D988047Fd;
    tokenbase[tokenlist[0]] = 4 * 10**20;
    //pyro
    tokenlist[1] = 0x14409B0Fc5C7f87b5DAd20754fE22d29A3dE8217;
    tokenbase[tokenlist[1]] = 1 * 10**20;
    //shuf
    tokenlist[2] = 0x3A9FfF453d50D4Ac52A6890647b823379ba36B9E;
    tokenbase[tokenlist[2]] = 16 * 10**16;
    //shock
    tokenlist[3] = 0x62d69910f45b839903eFfd217559307AEc307076;
    tokenbase[tokenlist[3]] = 3 * 10**17;
  }


  mapping(uint256 => address) public tokenlist;

  uint256 public stopblock;
  address public winner;

  mapping(address => uint256) public entries;
  mapping(address => uint256) public tokenbase;
  mapping(address => uint256) public blockbalance;
  mapping(address => uint256) public endbalance;
  mapping(uint256 => address) public winpool;
  mapping(uint256 => bool) public winpoolclaimed;

  bool public jackpotclaimed;

  bool public started;
  bool public ended;

  modifier notStarted {
    require(started == false);
    _;
  }
  modifier isStarted {
    require(started == true);
    _;
  }
  modifier notEnded {
    require(ended == false);
    _;
  }
  modifier isEnded {
    require(ended == true);
    _;
  }



  function enter(address token, uint256 amount) public isStarted() notEnded() {
    require(amount > 0);
    require(tokenbase[token] != 0);

    if(block.number >= stopblock) {
      endgame();
    }
    else {
      IERC20 itoken = IERC20(token);
      uint256 blockcost = getblockcost(token);
      uint256 _cost = amount.mul(blockcost);

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

  function endgame() public isStarted() notEnded() {
    if(block.number >= stopblock) {
      IERC20 _itmp;
      for(uint256 i = 0; i < 4; i++) {
        _itmp = IERC20(tokenlist[i]);
        endbalance[tokenlist[i]] = _itmp.balanceOf(address(this));
      }
      ended = true;
    }
  }

  function claim(uint256 plyr) public isEnded() {
    require(winpoolclaimed[plyr] == false);
    address _addr = winpool[plyr];
    require(_addr != 0x0000000000000000000000000000000000000000);
    IERC20 _itmp;
    uint256 _shareamt;
    winpoolclaimed[plyr] = true;
    for(uint256 i = 0; i < 4; i++) {
      _itmp = IERC20(tokenlist[i]);
      _shareamt = endbalance[tokenlist[i]] / 40;
      _itmp.transfer(_addr, _shareamt);
      emit poolclaim(_addr, tokenlist[i], _shareamt);
    }

  }

  function claimjackpot() public isEnded() {
    require(jackpotclaimed == false);
    IERC20 _itmp;
    uint256 _contractbal;
    uint256 _shareamt;
    uint256 _winamt;
    jackpotclaimed = true;
    for(uint256 i = 0; i < 4; i++) {
      _itmp = IERC20(tokenlist[i]);
      _contractbal = endbalance[tokenlist[i]];
      _shareamt = _contractbal / 40;
      _winamt = _contractbal - _shareamt * 8;
      _itmp.transfer(winner, _winamt);
      emit winnerclaim(winner, tokenlist[i], _contractbal);
    }
  }

  function poolhandler(address _addr) internal returns(bool) {

    uint256 low = 0;

    for(uint256 i = 0; i < 8; i++) {
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
    return(tokenbase[token] + (entries[token] * tokenbase[token]) / 10**4);
  }

  //ADMIN FUNCTIONS

  function adminStart(uint256 numblocks) public onlyOwner() notStarted() {
    stopblock = block.number + numblocks;
    started = true;
  }

  function adminwithdrawal(address token, uint256 amount) public onlyOwner() isEnded() {
    require(jackpotclaimed == true);
    IERC20 itoken = IERC20(token);
    itoken.transfer(msg.sender, amount);
  }
  function clearETH() public onlyOwner() {
    address payable _owner = msg.sender;
    _owner.transfer(address(this).balance);
  	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT


}