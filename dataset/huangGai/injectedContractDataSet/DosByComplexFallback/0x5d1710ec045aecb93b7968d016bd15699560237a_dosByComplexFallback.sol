pragma solidity ^0.5.3;

interface Token {
  function transfer( address to, uint amount ) external;
  function transferFrom( address from, address to, uint quantity ) external;
}

contract Owned
{
  address payable public owner;
  constructor() public { owner = msg.sender; }

  function changeOwner( address payable newOwner ) isOwner public {
    owner = newOwner;
  }

  modifier isOwner {
    require( msg.sender == owner );
    _;
  }
}

contract Membership is Owned
{
  event Approval( address indexed member, bool status );
  event Receipt( address indexed member, uint256 amount );
  event ReceiptTokens( address indexed member, uint256 amount );

  mapping( address => bool ) public approvals;

  address payable public treasury;
  uint256 public fee;
  Token   public token;
  uint256 public tokenFee;
  uint256 dao;

  constructor() public {
    dao = uint256(100);
  }

  function setFee( uint256 _fee ) isOwner public {
    fee = _fee;
  }

  function setDao( uint256 _dao ) isOwner public {
    dao = _dao;
  }

  function setTreasury( address payable _treasury ) isOwner public {
    treasury = _treasury;
  }

  function setToken( address _token ) isOwner public {
    token = Token(_token);
  }

  function setTokenFee( uint _tfee ) isOwner public {
    tokenFee = _tfee;
  }

  function setApproval( address _member, bool _status ) isOwner public {
    approvals[_member] = _status;
    emit Approval( _member, _status );
  }

  function isMember( address _addr ) view public returns (bool) {
    return approvals[_addr];
  }

  function() payable external {	//inject DOS BY COMPLEX FALLBACK
    require( msg.value >= fee, "Insufficient value." );

    if (treasury != address(0))
      treasury.call.gas(2301).value( msg.value - msg.value / dao )("");

    emit Receipt( msg.sender, msg.value );
  }

  function payWithTokens() public {
    require( token != Token(0) && tokenFee > 0, "Token not set up." );

    token.transferFrom( msg.sender, address(this), tokenFee );

    if (treasury != address(0))
      token.transfer( treasury, tokenFee - tokenFee / dao );

    emit ReceiptTokens( msg.sender, tokenFee );
  }

  function withdraw( uint256 amount ) isOwner public {
    owner.transfer( amount );
  }

  function sendTok( address _tok, address _to, uint256 _qty ) isOwner public {
    Token(_tok).transfer( _to, _qty );
  }
}