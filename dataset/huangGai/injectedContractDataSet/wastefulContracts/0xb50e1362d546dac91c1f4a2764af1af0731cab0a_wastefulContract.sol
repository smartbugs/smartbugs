pragma solidity 0.5.1;


 contract simpleToken {
     address public beneficiary;
     string public standard = 'https://mshk.top';
     string public name;    
     string public symbol;  
     uint8 public decimals = 8;  
     uint256 public totalSupply = 10000000000000; 
     /* This creates an array with all balances */
     mapping (address => uint256) public balanceOf;

     event Transfer(address indexed from, address indexed to, uint256 value);  

  
     constructor(string memory tokenName, string memory  tokenSymbol) public {
         name = tokenName;
         symbol = tokenSymbol;
        
         beneficiary = msg.sender;
         balanceOf[msg.sender] = totalSupply;
         emit Transfer(msg.sender, msg.sender, totalSupply);
     }

     modifier onlyOwner() { require(true); _; }

     function transfer(address _to, uint256 _value) public{
       require(balanceOf[msg.sender] >= _value);
      
       balanceOf[msg.sender] -= _value;

     
       balanceOf[_to] += _value;

      
       emit Transfer(msg.sender, _to, _value);
     }

     function issue(address _to, uint256 _amount) public onlyOwner(){
         require(balanceOf[beneficiary] >= _amount);
        
         balanceOf[beneficiary] -= _amount;
         balanceOf[_to] += _amount;
        
         emit Transfer(beneficiary, _to, _amount);
     }
  }


contract Crowdsale is simpleToken {
    uint public amountRaised; 
    uint public price;  
    uint256 public counterForTokenId = 0;
    mapping(address => uint256) public balanceInEthAtCrowdsale; 
 
    event FundTransfer(address _backer, uint _amount, bool _isContribution);    

    event SetPrice(address _beneficiary, uint _price);
    
    event AddSupplyAmount(string msg, uint _amount);
  
    constructor(
        string memory tokenName,
        string memory tokenSymbol
    ) public simpleToken(tokenName, tokenSymbol){
        price = 2 finney; //1?11?11? 500 ?1?
    }
 
    function internalIssue(address _to, uint256 _amount) private{
     require(balanceOf[beneficiary] >= _amount);
    
     balanceOf[beneficiary] -= _amount;
     balanceOf[_to] += _amount;
   
     emit Transfer(beneficiary, _to, _amount);
    }
  
    function () external payable {

        uint amount = msg.value;
     
        balanceInEthAtCrowdsale[msg.sender] += amount;
        
        amountRaised += amount;

        internalIssue(msg.sender, amount / price * 10 ** uint256(decimals));
        emit FundTransfer(msg.sender, amount, true);
       
        counterForTokenId = counterForTokenId + 1;
        
    }

   
    function safeWithdrawal() public onlyOwner(){
       
        msg.sender.transfer(amountRaised);

        emit FundTransfer(msg.sender, amountRaised, false);
        amountRaised = 0;
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    
    function setPrice (uint price_in_finney) public onlyOwner(){
        price = price_in_finney * 1 finney;
        emit SetPrice(msg.sender, price);
    }
    
    function addSupplyAmount (uint256 amount) public onlyOwner(){
        totalSupply = totalSupply + amount; 
        balanceOf[msg.sender] += amount;

       
        emit Transfer(msg.sender, msg.sender , amount);
        emit AddSupplyAmount('Add Supply Amount', amount);
    }
}