                                                                 

pragma solidity ^0.5.17;

library safemath71 {	//inject NONSTANDARD NAMING
  function ADD2(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
    c = a + b;
    require(c >= a);
  }
  function SUB36(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
    require(b <= a);
    c = a - b;
  }
  function MUL54(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
    c = a * b;
    require(a == 0 || c / a == b);
  }
  function DIV84(uint a, uint b) internal pure returns (uint c) {	//inject NONSTANDARD NAMING
    require(b > 0);
    c = a / b;
  }
}

contract erc20interface61 {	//inject NONSTANDARD NAMING
    
  function TOTALSUPPLY49() public view returns (uint);	//inject NONSTANDARD NAMING
  function BALANCEOF74(address tokenOwner) public view returns (uint balance);	//inject NONSTANDARD NAMING
  function ALLOWANCE42(address tokenOwner, address spender) public view returns (uint remaining);	//inject NONSTANDARD NAMING
  function TRANSFER94(address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
  function APPROVE96(address spender, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING
  function TRANSFERFROM38(address from, address to, uint tokens) public returns (bool success);	//inject NONSTANDARD NAMING

  
}


contract approveandcallfallback35 {	//inject NONSTANDARD NAMING
  function RECEIVEAPPROVAL10(address from, uint256 tokens, address token, bytes memory data) public;	//inject NONSTANDARD NAMING
}

contract owned95 {	//inject NONSTANDARD NAMING
  address public Admininstrator;


  constructor() public {
    Admininstrator = msg.sender;
    
  }

  modifier ONLYADMIN42 {	//inject NONSTANDARD NAMING
    require(msg.sender == Admininstrator, "Only authorized personnels");
    _;
  }

}

contract salescontract2 is owned95{	//inject NONSTANDARD NAMING
    
    
  using safemath71 for uint;
 
  address public token;
  
  uint public minBuy = 1 ether;
  uint public maxBuy = 5 ether;
  address payable saleswallet;
  
  bool public startSales = true;
  uint public buyvalue;
  uint public price = 0.05 ether;
  uint _qtty;
  uint decimal = 10**8;
 

  mapping(address => uint) public buyamount;
 
  

 
  constructor() public { Admininstrator = msg.sender; }
   
 //========================================CONFIGURATIONS======================================
 
 
 function SETSALESWALLET27(address payable _salewallet) public ONLYADMIN42{saleswallet = _salewallet;}	//inject NONSTANDARD NAMING
 function SETTOKEN12(address _tokenaddress) public ONLYADMIN42{token = _tokenaddress;}	//inject NONSTANDARD NAMING
 
 function ALLOWSALES2(bool _status) public ONLYADMIN42{startSales = _status;}	//inject NONSTANDARD NAMING
	
	
 function () external payable {
    
     require(startSales == true, "Sales has not been initialized yet");
        
    require(msg.value >= minBuy && msg.value <= maxBuy, "Invalid buy amount, confirm the maximum and minimum buy amounts");
    require(token != 0x0000000000000000000000000000000000000000, "Selling token not yet configured");
    require((buyamount[msg.sender] + msg.value) <= maxBuy, "You have reached your buy cap");
    
    buyvalue = msg.value;
    _qtty = buyvalue.DIV84(price);
    require(erc20interface61(token).BALANCEOF74(address(this)) >= _qtty*decimal, "Insufficient tokens in the contract");
    
    saleswallet.transfer(msg.value);
    buyamount[msg.sender] += msg.value;
    require(erc20interface61(token).TRANSFER94(msg.sender, _qtty*decimal), "Transaction failed");
  
    
   
  }
  

  function RETRIEVETOKEN67() public ONLYADMIN42 returns(bool){	//inject NONSTANDARD NAMING
      
      uint bal = erc20interface61(token).BALANCEOF74(address(this));
      require(erc20interface61(token).TRANSFER94(saleswallet, bal), "Transaction failed");
      
  }
 
 
}