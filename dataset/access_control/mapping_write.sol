/*
 * @source: https://smartcontractsecurity.github.io/SWC-registry/docs/SWC-124#mapping-writesol
 * @author: Suhabe Bugrara
 * @vulnerable_at_lines: 20
 */

 pragma solidity ^0.4.24;

 //This code is derived from the Capture the Ether https://capturetheether.com/challenges/math/mapping/

 contract Map {
     address public owner;
     uint256[] map;

     function set(uint256 key, uint256 value) public {
         if (map.length <= key) {
             map.length = key + 1;
         }
        // <yes> <report> ACCESS_CONTROL
         map[key] = value;
     }

     function get(uint256 key) public view returns (uint256) {
         return map[key];
     }
     function withdraw() public{
       require(msg.sender == owner);
       msg.sender.transfer(address(this).balance);
     }
 }
