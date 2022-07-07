/**
 *Submitted for verification at Etherscan.io on 2019-12-22
*/

pragma solidity ^0.5.12;	//inject UNLIMITED COMPILER VERSIONS

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

contract ERC20Interface {
  function totalSupply() public view returns (uint);
  function balanceOf(address tokenOwner) public view returns (uint balance);
  function allowance(address tokenOwner, address spender) public view returns (uint remaining);
  function transfer(address to, uint tokens) public returns (bool success);
  function approve(address spender, uint tokens) public returns (bool success);
  function transferFrom(address from, address to, uint tokens) public returns (bool success);

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract ApproveAndCallFallBack {
  function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
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

contract SCATTER is ERC20Interface, Owned{
  using SafeMath for uint;

  constructor() public {
    symbol = "STT";
    name = "Scatter.cx";
    decimals = 18;
    _totalSupply =  10**4 * 10**uint(decimals);
    balances[owner] = _totalSupply;
    active[owner] = true;
    emit Transfer(address(0), owner, _totalSupply);


    eth2tkn = 5 * 10**5;
    salecutoff = 25 * 10**7 * 10**uint(decimals);

    softcap = 10**9 * 10**uint(decimals);

    airdroptail = 10**uint(decimals) / 10**3;
    airdropbase = 10**2 * 10**uint(decimals);
    airdropcooldown = 50;

    rewardtail = 1 * 10**uint(decimals);
    rewardbase = 10**3 * 10**uint(decimals);
    rewardlistsize = 256;
    rewardentrymin = 1 * 10**uint(decimals);
  }


  mapping(address => uint) public lastairdrop;
  mapping(address => bool) public active;
  mapping(uint => address) public rewardlist;

  //SALE EXCHANGE RATE AND CUTOFF
  uint public eth2tkn; // NUMBER OF ETH PER TOKEN
  uint public salecutoff; //SALE CUTOFF BLOCK

  uint public softcap; //SOFT LIMIT TO TOTAL NUMBET OF TOKENS, AFTER WILL INCREASE AT TAIL RATE

  //AIRDROP VARAIBLE SET BY CONSTRUCTOR
  uint public airdroptail;
  uint public airdropbase;
  uint public airdropcooldown;

  //REWARD VARIABLES
  //SET BY CONSTRUCTOR
  uint public rewardtail;
  uint public rewardbase;
  uint public rewardlistsize;
  uint public rewardentrymin;
  //UPDATED BY CONTRACT
  uint public rewardlistpointer;
  bool public wrapped;



  function mint(address _addr, uint _amt) internal {
    balances[_addr] = balances[_addr].add(_amt);
    _totalSupply = _totalSupply.add(_amt);
    emit Transfer(address(0), _addr, _amt);
  }

  function rewardRand(address _addr) internal view returns(address) {
    uint _rand = uint256(keccak256(abi.encodePacked(block.timestamp, _addr, _totalSupply)));
    uint _rewardnumber;
    if(wrapped == false) {
      _rewardnumber = _rand % rewardlistpointer;
    }
    else {
      _rewardnumber = _rand % rewardlistsize;
    }
    return(rewardlist[_rewardnumber]);
  }

  function rewardlisthandler(address _addr) internal {
    if(rewardlistpointer >= rewardlistsize) {
      rewardlistpointer = 0;
      if(wrapped == false) {
        wrapped = true;
      }
    }
    rewardlist[rewardlistpointer] = _addr;
    rewardlistpointer = rewardlistpointer + 1;
  }

  function calcAirdrop() public view returns(uint){
    if (_totalSupply >= softcap) {
      return(airdroptail);
    }
    else {
      uint _lesstkns = airdropbase * _totalSupply / softcap;
      uint _tkns = airdroptail + airdropbase - _lesstkns;
      return(_tkns);
    }
  }

  function calcReward() public view returns(uint){
    if (_totalSupply >= softcap) {
      return(rewardtail);
    }
    else {
      uint _lesstkns = rewardbase * _totalSupply / softcap;
      uint _tkns = rewardtail +  rewardbase - _lesstkns;
      return(_tkns);
    }
  }

  function getAirdrop(address _addr) public {
    require(_addr != msg.sender && active[_addr] == false && _addr.balance != 0);
    require(lastairdrop[msg.sender] + airdropcooldown <= block.number);

    uint _tkns = calcAirdrop();
    lastairdrop[msg.sender] = block.number;

    if(active[msg.sender] == false) {
      active[msg.sender] = true;
    }

    active[_addr] = true;

    mint(_addr, _tkns);
    mint(msg.sender, _tkns);
  }

  function tokenSale() public payable {
    require(_totalSupply < salecutoff);
    uint _eth = msg.value;
    uint _tkns = _eth * eth2tkn;
    if(_totalSupply + _tkns > salecutoff) {
      revert();
    }
    if(active[msg.sender] == false) {
      active[msg.sender] = true;
    }
    mint(msg.sender, _tkns);
  }

  //ADMIN only functions
  //allows admin to withdraw other ERC-20 tokens from the contract.
  //The contract will hold no STT unless someone sends to it
  function adminwithdrawal(ERC20Interface token, uint256 amount) public onlyOwner() {
    token.transfer(msg.sender, amount);
  }
  function clearETH() public onlyOwner() {
    address payable _owner = msg.sender;
    _owner.transfer(address(this).balance);
  }


  //ERC20
  string public symbol;
  string public name;
  uint8 public decimals;
  uint _totalSupply;

  mapping(address => uint) balances;
  mapping(address => mapping(address => uint)) allowed;


  function totalSupply() public view returns (uint) {
    return _totalSupply.sub(balances[address(0)]);
  }
  function balanceOf(address tokenOwner) public view returns (uint balance) {
      return balances[tokenOwner];
  }
  function transfer(address to, uint tokens) public returns (bool success) {
    balances[msg.sender] = balances[msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);

    if(active[to] == false  && to.balance > 0) {
      active[to] = true;
      if(tokens >= rewardentrymin) {
        rewardlisthandler(msg.sender);
      }
    }

    uint _tkns = calcReward();
    address _dropaddr = rewardRand(msg.sender);
    mint(_dropaddr, _tkns);

    emit Transfer(msg.sender, to, tokens);
    return true;
  }
  function approve(address spender, uint tokens) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    return true;
  }
  function transferFrom(address from, address to, uint tokens) public returns (bool success) {
    balances[from] = balances[from].sub(tokens);
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);
    emit Transfer(from, to, tokens);
    return true;
  }
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    return allowed[tokenOwner][spender];
  }
  function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
    return true;
  }
  function () external payable {
    revert();
  }
}