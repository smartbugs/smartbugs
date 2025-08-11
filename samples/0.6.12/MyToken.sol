/*
 * @source: https://ericrafaloff.com/analyzing-the-erc20-short-address-attack/
 * Upgraded from Solidity 0.4 to 0.6, vulnerability may no longer exist
 * @author: -
 * @vulnerable_at_lines: 20
 */

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

 contract MyToken {
     mapping (address => uint) balances;

     event Transfer(address indexed _from, address indexed _to, uint256 _value);

     constructor() public {
         balances[tx.origin] = 10000;
     }
     // <yes> <report> SHORT_ADDRESSES
     function sendCoin(address to, uint amount) public returns(bool sufficient) {
         if (balances[msg.sender] < amount) return false;
         balances[msg.sender] -= amount;
         balances[to] += amount;
         emit Transfer(msg.sender, to, amount);
         return true;
     }

     function getBalance(address addr) public view returns(uint) {
         return balances[addr];
     }
 }
