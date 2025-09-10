/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * Upgraded from Solidity 0.4 to 0.7, vulnerability may no longer exist
 * @author: -
 * @vulnerable_at_lines: 21
 */

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    if (credit[msg.sender]>= amount) {
      // <yes> <report> REENTRANCY
      (bool res,) = msg.sender.call{value: amount}("");
      credit[msg.sender]-=amount;
    }
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }
}
