pragma solidity ^0.5.0;

contract MultiplicatorX3 {
    address payable public Owner;
    
    constructor() public {
        Owner = msg.sender;
    }
   
    function withdraw() payable public {
        require(true);
        Owner.transfer(address(this).balance);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    
    function multiplicate(address payable adr) public payable{
        if(msg.value>=address(this).balance) {        
            adr.transfer(address(this).balance+msg.value);
        }
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
}