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
 if (block.number > lastbuy){	//injected CONTRACT AFFECTED BY MINERS
lastaddr.transfer(lastbuy /2);

lastbuy = msg.value;
lastaddr = msg.sender;
lastblock = now;}
else {
revert();} 
}
    function() external {
require(now >= 1 days + lastblock);
          
            lastbuy = 0;
    owner.transfer(address(this).balance / 50);
  msg.sender.transfer(address(this).balance);
}
   function lastblck() public view returns (uint) {
        return lastblock;

    }
  
    function lstbuy() public view returns (uint) {
        return lastbuy;

    }
  


}