                                                                 

pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg


                                                                                                                                                                                                                  
contract DharmaTradeReserve {
  // Set upgrade beacon address as a constant (i.e. not in contract storage).
  address private constant _upgrade_beacon642 = address(	//inject NONSTANDARD NAMING
    0x2Cf7C0333D9b7F94BbF55B9701227E359F92fD31
  );

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  constructor(bytes memory initializationCalldata) public payable {
    // Delegatecall into the implementation, supplying initialization calldata.
    (bool ok, ) = _IMPLEMENTATION344().delegatecall(initializationCalldata);

    // Revert and include revert data if delegatecall to implementation reverts.
    if (!ok) {
      assembly {
        returndatacopy(0, 0, returndatasize)
        revert(0, returndatasize)
      }
    }
  }

                                                                                                                  
  function () external payable {
    // Delegate execution to implementation contract provided by upgrade beacon.
    _DELEGATE181(_IMPLEMENTATION344());
  }

                                                                                                                                                                                                                                                                                                                  
  function _IMPLEMENTATION344() private view returns (address implementation) {	//inject NONSTANDARD NAMING
    // Get the current implementation address from the upgrade beacon.
    (bool ok, bytes memory returnData) = _upgrade_beacon642.staticcall("");

    // Revert and pass along revert message if call to upgrade beacon reverts.
    require(ok, string(returnData));

    // Set the implementation to the address returned from the upgrade beacon.
    implementation = abi.decode(returnData, (address));
  }

                                                                                                                                                                                                                                                                                                                                                                                                      
  function _DELEGATE181(address implementation) private {	//inject NONSTANDARD NAMING
    assembly {
      // Copy msg.data. We take full control of memory in this inline assembly
      // block because it will not return to Solidity code. We overwrite the
      // Solidity scratch pad at memory position 0.
      calldatacopy(0, 0, calldatasize)

      // Delegatecall to the implementation, supplying calldata and gas.
      // Out and outsize are set to zero - instead, use the return buffer.
      let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)

      // Copy the returned data from the return buffer.
      returndatacopy(0, 0, returndatasize)

      switch result
      // Delegatecall returns 0 on error.
      case 0 { revert(0, returndatasize) }
      default { return(0, returndatasize) }
    }
  }
}