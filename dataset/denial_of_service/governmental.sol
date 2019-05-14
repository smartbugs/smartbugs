/*
 * @source: https://github.com/trailofbits/not-so-smart-contracts/blob/master/denial_of_service/list_dos.sol#L30
 * @author: -
 */

pragma solidity ^0.4.15;

contract CrowdFundBad {
  address[] private refundAddresses;
  mapping(address => uint) public refundAmount;

  function refundDos() public {
    for(uint i; i < refundAddresses.length; i++) {
      require(refundAddresses[i].transfer(refundAmount[refundAddresses[i]]));
    }
  }
}
