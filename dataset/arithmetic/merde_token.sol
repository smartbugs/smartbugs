/*
 * @source: https://github.com/Arachnid/uscc/blob/master/submissions-2017/doughoyte/MerdeToken.sol
 * @author: Suhabe Bugrara
 */

 pragma solidity ^0.4.13;

 contract MerdeToken {
     address public owner;
     address public trustedThirdParty;

     function MerdeToken(address _trustedThirdParty) {
         owner = msg.sender;
         trustedThirdParty = _trustedThirdParty;
     }

     modifier onlyOwner {
         require(msg.sender == owner);
         _;
     }

     modifier onlyTrustedThirdParty {
         require(msg.sender == trustedThirdParty);
         _;
     }


     mapping (address => uint) public balanceOf;
     uint public deposited;
     uint public withdrawLimit;

     function deposit() payable {
         require(deposited + msg.value > deposited);
         require(balanceOf[msg.sender] + msg.value > balanceOf[msg.sender]); // Check for overflows
         balanceOf[msg.sender] += msg.value;
         deposited += msg.value;
     }

     function balanceOf(address owner) constant returns (uint balance) {
         return balanceOf[owner];
     }

     function transfer(address to, uint value) {
         require(balanceOf[msg.sender] >= value);
         require(balanceOf[to] + value > balanceOf[to]); // Check for overflows
         balanceOf[msg.sender] -= value;
         balanceOf[to] += value;
     }

     function setWithdrawLimit(uint newWithdrawLimit) onlyTrustedThirdParty {
         withdrawLimit = newWithdrawLimit;
     }

     function withdraw(uint amount) onlyOwner {
         require(amount <= withdrawLimit);
         require(amount <= deposited);
         deposited -= amount;
         withdrawLimit -= amount;
         msg.sender.transfer(amount);
     }



     uint[] public bonusCodes;

     function pushBonusCode(uint code) onlyOwner {
         bonusCodes.push(code);
     }

     function popBonusCode() onlyOwner {
         require(bonusCodes.length >= 0);
         bonusCodes.length--; // No pop() method?
     }

     function modifyBonusCode(uint index, uint update) onlyOwner {
         require(index < bonusCodes.length);
         bonusCodes[index] = update;
     }
 }
