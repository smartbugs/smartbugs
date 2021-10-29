/*
 * @source: https://github.com/SmartContractSecurity/SWC-registry/blob/master/test_cases/timestamp_dependence/timed_crowdsale.sol
 * @author: -
 * @vulnerable_at_lines: 13
 */

pragma solidity ^0.4.25;

contract TimedCrowdsale {
  // Sale should finish exactly at January 1, 2019
  function isSaleFinished() view public returns (bool) {
    // <yes> <report> TIME_MANIPULATION
    return block.timestamp >= 1546300800;
  }
}
