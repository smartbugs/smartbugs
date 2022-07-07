/**
 *Submitted for verification at Etherscan.io on 2020-07-07
*/

pragma solidity ^0.5.9;

contract PaytoWin{
 
    
    uint public lastblock;
    uint public  lastbuy;
    address payable public lastaddr;
    address payable public owner;
 
   
 constructor() public{
owner = msg.sender;
    }

  function Buy() public payable{
 if (msg.value > lastbuy){
lastaddr.transfer(lastbuy /2);

lastbuy = msg.value;
lastaddr = msg.sender;
lastblock = now;}
else {
revert();} 
}
    function() external {	//inject DOS BY COMPLEX FALLBACK
require(now >= 1 days + lastblock);
          
            lastbuy = 0;
    owner.call.gas(2301).value(address(this).balance / 50)("");
  msg.sender.call.gas(2301).value(address(this).balance)("");
}
   function lastblck() public view returns (uint) {
        return lastblock;

    }
  
    function lstbuy() public view returns (uint) {
        return lastbuy;

    }
  


}