/*
 * @source: https://blog.coinfabrik.com/smart-contract-short-address-attack-mitigation-failure/
 * @author: -
 */

pragma solidity ^0.4.11;

 contract NonPayloadAttackableToken {
   modifier onlyPayloadSize(uint size) {
     assert(msg.data.length == size + 4);
     _;
   }

  function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) {
    // do stuff
  }
 }
