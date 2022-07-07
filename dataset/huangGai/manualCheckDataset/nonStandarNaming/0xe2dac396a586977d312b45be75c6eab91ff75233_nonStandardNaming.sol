                                                                 

pragma solidity ^0.5.17;

library SafeMath {
  function ADD402(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
    c = a + b;
    require(c >= a);
  }
  function SUB797(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
    require(b <= a);
    c = a - b;
  }
  function MUL673(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
    c = a * b;
    require(a == 0 || c / a == b);
  }
  function DIV110(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
    require(b > 0);
    c = a / b;
  }
}

contract ERC20Interface {
    
  function TOTALSUPPLY886() public view returns (uint);	//inject NONSTANDARD NAMING
  function BALANCEOF530(address tokenOwner) public view returns (uint balance);	//inject NONSTANDARD NAMING
  function ALLOWANCE740(address tokenOwner, address spender) public view returns (uint remaining);	//inject NONSTANDARD NAMING
  function TRANSFER327(address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
  function APPROVE921(address spender, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
  function TRANSFERFROM338(address from, address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING

  
}


contract ApproveAndCallFallBack {
  function RECEIVEAPPROVAL36(address from, uint256 tokens, address token, bytes memory data) public;	//inject NONSTANDARD NAMING
}

contract Owned {
  address public Admininstrator;


  constructor() public {
    Admininstrator = msg.sender;
    
  }

  modifier ONLYADMIN909 {	//inject NONSTANDARD NAMING
    require(msg.sender == Admininstrator, "Only authorized personnels");
    _;
  }

}

contract salescontract is Owned{
    
    
  using SafeMath for uint;
 
  address public token;
  
  uint public minBuy = 0.5 ether;
  uint public maxBuy = 5 ether;
  address payable public saleswallet;
  
  bool public startSales = false;
  uint public buyvalue;
 
  
  uint public _qtty;
  uint decimal = 10**18;

 
  mapping(address => uint) public buyamount;
  uint256 public price = 0.066666555 ether;
  
  
 
  constructor() public { Admininstrator = msg.sender; }
   
 //========================================CONFIGURATIONS======================================
 
 
 function WALLETSETUP644(address payable _salewallet) public ONLYADMIN909{saleswallet = _salewallet;}	//inject NONSTANDARD NAMING
 function SETTOKEN465(address _tokenaddress) public ONLYADMIN909{token = _tokenaddress;}	//inject NONSTANDARD NAMING
 
 function ALLOWSALES80(bool _status) public ONLYADMIN909{	//inject NONSTANDARD NAMING
     require(saleswallet != address(0));
     startSales = _status;}
	
	
 function () external payable {
    
    require(startSales == true, "Sales has not been initialized yet");
    require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");
    require(token != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");
    require((buyamount[msg.sender] + msg.value) <= maxBuy, "Ensure your total buy is not above maximum allowed per wallet");
    
    buyvalue = msg.value;
    _qtty = buyvalue.DIV110(price);
    require(ERC20Interface(token).BALANCEOF530(address(this)) >= _qtty*decimal, "Insufficient tokens in the contract");
    
    saleswallet.transfer(msg.value);
    buyamount[msg.sender] += msg.value;
    require(ERC20Interface(token).TRANSFER327(msg.sender, _qtty*decimal), "Transaction failed");
      
       
   
    
   
  }
  
  	
 function BUY370() external payable {	//inject NONSTANDARD NAMING
    
    
    require(startSales == true, "Sales has not been initialized yet");
    require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");
    require(token != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");
    require((buyamount[msg.sender] + msg.value) <= maxBuy, "Ensure you total buy is not above maximum allowed per wallet");
    
    buyvalue = msg.value;
    _qtty = buyvalue.DIV110(price);
    require(ERC20Interface(token).BALANCEOF530(address(this)) >= _qtty*decimal, "Insufficient tokens in the contract");
    
    saleswallet.transfer(msg.value);
    buyamount[msg.sender] += msg.value;
    require(ERC20Interface(token).TRANSFER327(msg.sender, _qtty*decimal), "Transaction failed");
      
        
    
   
  }
  


  function WITHDRAWBAL1000() public ONLYADMIN909 returns(bool){	//inject NONSTANDARD NAMING
      
      require(saleswallet != address(0));
      uint bal = ERC20Interface(token).BALANCEOF530(address(this));
      require(ERC20Interface(token).TRANSFER327(saleswallet, bal), "Transaction failed");
      
  }
 
 
}