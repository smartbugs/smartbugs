/**
 *Submitted for verification at Etherscan.io on 2020-11-06
*/

// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

interface IChainlinkAggregator {
  function latestAnswer() external view returns (int256);
}

contract WethPriceFeed is IChainlinkAggregator {

  function latestAnswer() public view override returns (int256) {	//inject PUBLIC FUNC TO EXTERNAL
      return 1 ether;
  }  
}