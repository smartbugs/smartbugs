















  function forward(address callee, bytes _data) public {
    // <yes> <report> ACCESS_CONTROL
    require(callee.delegatecall(_data)); //Use delegatecall with caution and make sure to never call into untrusted contracts
  }
