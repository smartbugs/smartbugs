/*
 * @source: https://github.com/SmartContractSecurity/SWC-registry/blob/master/test_cases/unprotected_critical_functions/simple_suicide.sol
 * @author: -
 */

//added prgma version
pragma solidity ^0.4.0;

contract SimpleSuicide {

  function sudicideAnyone() {
    selfdestruct(msg.sender);
  }

}
