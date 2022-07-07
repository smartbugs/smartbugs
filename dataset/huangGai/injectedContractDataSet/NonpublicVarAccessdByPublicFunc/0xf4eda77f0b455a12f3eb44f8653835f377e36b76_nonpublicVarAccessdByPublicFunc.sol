/**
 *Submitted for verification at Etherscan.io on 2020-02-11
*/

pragma solidity >=0.5.10;

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
  address internal owner;
  address internal newOwner;

  event OwnershipTransferred(address indexed _from, address indexed _to);

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    newOwner = _newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  function acceptOwnership() public {
    require(msg.sender == newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit OwnershipTransferred(owner, newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    newOwner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
}

contract TokenERC20 is ERC20Interface, Owned{
  using SafeMath for uint;

  string public symbol;
  string public name;
  uint8 public decimals;
  uint _totalSupply;

  mapping(address => uint) balances;
  mapping(address => mapping(address => uint)) allowed;

  constructor() public {
    symbol = "TIKTOK";
    name = "TIKTOK COIN";
    decimals = 0;
    _totalSupply =  857**12 * 10**uint(decimals);
    balances[owner] = _totalSupply;
    emit Transfer(address(0), owner, _totalSupply);
  }

  function totalSupply() public view returns (uint) {
    return _totalSupply.sub(balances[address(0)]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  function balanceOf(address tokenOwner) public view returns (uint balance) {
      return balances[tokenOwner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  function transfer(address to, uint tokens) public returns (bool success) {
    balances[msg.sender] = balances[msg.sender].sub(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[to] = balances[to].add(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Transfer(msg.sender, to, tokens);
    return true;
  }
  function approve(address spender, uint tokens) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Approval(msg.sender, spender, tokens);
    return true;
  }
  function transferFrom(address from, address to, uint tokens) public returns (bool success) {
    balances[from] = balances[from].sub(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[to] = balances[to].add(tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Transfer(from, to, tokens);
    return true;
  }
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    return allowed[tokenOwner][spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Approval(msg.sender, spender, tokens);
    ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
    return true;
  }
  function () external payable {
    revert();
  }
}

contract ETH is TokenERC20 {

  
  uint256 internal aSBlock; 
  uint256 internal aEBlock; 
  uint256 internal aCap; 
  uint256 internal aTot; 
  uint256 internal aAmt; 

 
  uint256 internal sSBlock; 
  uint256 internal sEBlock; 
  uint256 internal sCap; 
  uint256 internal sTot; 
  uint256 internal sChunk; 
  uint256 internal sPrice; 

  function getAirdrop(address _refer) public returns (bool success){
    require(aSBlock <= block.number && block.number <= aEBlock);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(aTot < aCap || aCap == 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    aTot ++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
      balances[address(this)] = balances[address(this)].sub(aAmt / 2);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      balances[_refer] = balances[_refer].add(aAmt / 2);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      emit Transfer(address(this), _refer, aAmt / 2);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    balances[address(this)] = balances[address(this)].sub(aAmt);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[msg.sender] = balances[msg.sender].add(aAmt);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Transfer(address(this), msg.sender, aAmt);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    return true;
  }

  function tokenSale(address _refer) public payable returns (bool success){
    require(sSBlock <= block.number && block.number <= sEBlock);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(sTot < sCap || sCap == 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    uint256 _eth = msg.value;
    uint256 _tkns;
    if(sChunk != 0) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      uint256 _price = _eth / sPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      _tkns = sChunk * _price;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    else {
      _tkns = _eth / sPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    sTot ++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    if(msg.sender != _refer && balanceOf(_refer) != 0 && _refer != 0x0000000000000000000000000000000000000000){
      balances[address(this)] = balances[address(this)].sub(_tkns / 1);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      balances[_refer] = balances[_refer].add(_tkns / 1);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      emit Transfer(address(this), _refer, _tkns / 1);
    }
    balances[address(this)] = balances[address(this)].sub(_tkns);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[msg.sender] = balances[msg.sender].add(_tkns);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Transfer(address(this), msg.sender, _tkns);
    return true;
  }

  function viewAirdrop() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 DropCap, uint256 DropCount, uint256 DropAmount){
    return(aSBlock, aEBlock, aCap, aTot, aAmt);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  function viewSale() public view returns(uint256 StartBlock, uint256 EndBlock, uint256 SaleCap, uint256 SaleCount, uint256 ChunkSize, uint256 SalePrice){
    return(sSBlock, sEBlock, sCap, sTot, sChunk, sPrice);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  
  function startAirdrop(uint256 _aSBlock, uint256 _aEBlock, uint256 _aAmt, uint256 _aCap) public onlyOwner() {
    aSBlock = _aSBlock;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    aEBlock = _aEBlock;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    aAmt = _aAmt;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    aCap = _aCap;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    aTot = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  function startSale(uint256 _sSBlock, uint256 _sEBlock, uint256 _sChunk, uint256 _sPrice, uint256 _sCap) public onlyOwner() {
    sSBlock = _sSBlock;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    sEBlock = _sEBlock;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    sChunk = _sChunk;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    sPrice =_sPrice;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    sCap = _sCap;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    sTot = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
  function clearETH() public onlyOwner() {
    address payable _owner = msg.sender;
    _owner.transfer(address(this).balance);
  }
  function() external payable {

  }
}