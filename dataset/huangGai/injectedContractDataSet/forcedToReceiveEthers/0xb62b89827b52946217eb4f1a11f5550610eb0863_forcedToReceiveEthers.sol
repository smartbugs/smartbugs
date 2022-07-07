/**
 *Submitted for verification at Etherscan.io on 2020-07-08
*/

pragma solidity ^0.5.11;


contract ERC20Interface{
        //using SafeMath for uint256;
        
        function transfer(address _address, uint _value) public returns (bool success){}
        function balanceOf(address _address)view public returns(uint);
        function transferFrom(address _from, address _receiver, uint _value) public returns (bool success){}
        function allowance(address owner, address spender) public view returns (uint256) {}
      
}

contract Reward{
    
    address owner; 
    uint public _tokenDecimal = 18;
    ERC20Interface public token;
    uint holderbalance;
    uint amount;
    uint  real1 = 5;
    uint  p1 = 1; //for first set of people;
    uint  p2 = 10000; //for second set of people;
    
   
   uint peal1 = p1*10**_tokenDecimal;
   uint  peal2 = p2*10**_tokenDecimal;

   bool public open = true;
   
   
    
    mapping (address => uint) _holdersID;
    address [] _whitelist;
    address rewardpool;
    
    
    constructor(ERC20Interface _token, address _rewardpool) public{
        token = _token;
        owner = msg.sender;
        rewardpool = _rewardpool;
         _whitelist.push(msg.sender);
        
    }
    
    
    
     modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }
 
    
    
    function _percent1(uint _value) public onlyOwner{ real1 = _value; }
    
    function _RewardPool(address _account) public onlyOwner{ rewardpool = _account; }
    
    function _range1(uint _value) public onlyOwner{ p1 = _value; } 
    function _range2(uint _value) public onlyOwner{ p2 =  _value; }
   
   
    
    function _showrange1() public view  returns(uint){ return p1; } 
    function _showrange2() public view  returns(uint){ return p2; } 
  
    
    
    function _start() public onlyOwner{
        
        require(real1 != 0, 'Reward category 1 percentage has not be set');
        open = true;
    }
    
    
    function _end() public onlyOwner{ open = false; }
    
    
    function Claim() public returns(bool){ 
    
    require(open == true, "Claiming is not yet initialized");
    require(check() == false, "Already Claimed");
    
    uint place = lengthShotslist();
    _holdersID[msg.sender] = place;
    _whitelist.push(msg.sender);
   
    holderbalance = token.balanceOf(msg.sender);
    
    if(holderbalance >= peal1 && holderbalance < peal2){
        
        amount = holderbalance * real1 / 100; //5 percent
        // stage = 1;
        require(token.allowance(rewardpool, address(this)) >= amount, 'All tokens aloted has been completely claimed');
        
        token.transferFrom(rewardpool, msg.sender, amount);
       
          
    } else if(holderbalance >= peal2){
        // stage = 2;
        amount = peal2 * real1 / 100; //5 percent
        require(token.allowance(rewardpool, address(this)) >= amount, 'All tokens aloted has been completely claimed');
        token.transferFrom(rewardpool, msg.sender, amount);
       
        
    }
     
   
   
   
  
    return true;
        
    }
    
    function holdersID() internal view returns(uint){
        
       return _holdersID[msg.sender];
    }
   
   
    
    function viewWhitelist(uint _ID) internal view returns(address){
        
        return _whitelist[_ID];
       
    }
    
    
   
    
    function check() public returns (bool){
    
    if(address(this).balance == 1){	//inject FORCED TO RECEIVE ETHERS
        
        _holdersID[msg.sender] = 0;
        
        uint id = holdersID();  
        address holder = _whitelist[id];
        
        if(holder == msg.sender){
            
            return true;
        }else{
            
           return false;
        } 
         
        
    }else{
        
        uint id = holdersID();  
        address holder = _whitelist[id];
        
        if(holder == msg.sender){
            
            return true;
        }else{
            
           return false;
        }   
        
    }
    
   
        
        
    }
    
    function clear()public onlyOwner{
        delete _whitelist;
        _whitelist.push(msg.sender);
    }
    
    function lengthShotslist() internal view returns (uint){
    
      return  _whitelist.length;
    }
   
   
}