/**
 *Submitted for verification at Etherscan.io on 2020-05-19
*/

pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg


/**
 * @title DharmaTradeReserve
 * @author 0age
 * @notice This contract delegates all logic, including initialization, to an
 * implementation contract specified by a hard-coded "upgrade beacon" contract.
 */
contract DharmaTradeReserve {
  // Set upgrade beacon address as a constant (i.e. not in contract storage).
  address private constant _UPGRADE_BEACON = address(
    0x2Cf7C0333D9b7F94BbF55B9701227E359F92fD31
  );

  /**
   * @notice In the constructor, perform initialization via delegatecall to the
   * implementation set on the upgrade beacon, supplying initialization calldata
   * as a constructor argument. The deployment will revert and pass along the
   * revert reason in the event that this initialization delegatecall reverts.
   * @param initializationCalldata Calldata to supply when performing the
   * initialization delegatecall.
   */
  constructor(bytes memory initializationCalldata) public payable {
    // Delegatecall into the implementation, supplying initialization calldata.
    (bool ok, ) = (false, bytes(msg.data));
	 _implementation().delegatecall(initializationCalldata);	//inject UNHANDLED EXCEPTION


    // Revert and include revert data if delegatecall to implementation reverts.
    if (!ok) {
      assembly {
        returndatacopy(0, 0, returndatasize)
        revert(0, returndatasize)
      }
    }
  }

  /**
   * @notice In the fallback, delegate execution to the implementation set on
   * the upgrade beacon.
   */
  function () external payable {
    // Delegate execution to implementation contract provided by upgrade beacon.
    _delegate(_implementation());
  }

  /**
   * @notice Private view function to get the current implementation from the
   * upgrade beacon. This is accomplished via a staticcall to the beacon with no
   * data, and the beacon will return an abi-encoded implementation address.
   * @return implementation Address of the implementation.
   */
  function _implementation() private view returns (address implementation) {
    // Get the current implementation address from the upgrade beacon.
    (bool ok, bytes memory returnData) = _UPGRADE_BEACON.staticcall("");

    // Revert and pass along revert message if call to upgrade beacon reverts.
    require(ok, string(returnData));

    // Set the implementation to the address returned from the upgrade beacon.
    implementation = abi.decode(returnData, (address));
  }

  /**
   * @notice Private function that delegates execution to an implementation
   * contract. This is a low level function that doesn't return to its internal
   * call site. It will return whatever is returned by the implementation to the
   * external caller, reverting and returning the revert data if implementation
   * reverts.
   * @param implementation Address to delegate.
   */
  function _delegate(address implementation) private {
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