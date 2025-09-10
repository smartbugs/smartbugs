/*
 * @source: http://blockchain.unica.it/projects/ethereum-survey/attacks.html#simpledao
 * Upgraded from Solidity 0.4 to 0.5, vulnerability may no longer exist
 * @author: -
 * @vulnerable_at_lines: 20
 */

pragma solidity ^0.5.0;

contract SimpleDAO {
  mapping (address => uint) public credit;

  function donate(address to) public payable {
    credit[to] += msg.value;
  }

  function withdraw(uint amount) public {
    if (credit[msg.sender]>= amount) {
      // <yes> <report> REENTRANCY
      (bool res,) = msg.sender.call.value(amount)("");
      credit[msg.sender]-=amount;
    }
  }

  function queryCredit(address to) public view returns (uint){
    return credit[to];
  }
}
