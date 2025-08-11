/*
 * @source: https://smartcontractsecurity.github.io/SWC-registry/docs/SWC-104#unchecked-return-valuesol
 * Upgraded from Solidity 0.4 to 0.5, vulnerability may no longer exist
 * @author: -
 * @vulnerable_at_lines: 19
 */

pragma solidity ^0.5.0;

contract ReturnValue {

  function callchecked(address callee) public {
    (bool success,) = callee.call("");
    require(success);
  }

  function callnotchecked(address callee) public {
     // <yes> <report> UNCHECKED_LL_CALLS
    callee.call("");
  }
}
