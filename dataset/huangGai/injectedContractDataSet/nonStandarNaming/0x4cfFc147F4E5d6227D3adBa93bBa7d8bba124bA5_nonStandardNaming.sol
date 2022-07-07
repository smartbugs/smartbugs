                                                                 

// SPDX-License-Identifier: MIT

pragma solidity 0.6.8;


// 
                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT66(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE898(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL434(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL434(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL434(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE174(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE992(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE992(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE992(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE174(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE174(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT66(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// 
                                                                                                                                                                                                                                                                                                                                                                                                                             
abstract contract Proxy {

                                                                                 
  receive () payable external {
    _FALLBACK872();
  }

                                                                                  
  fallback () payable external {
    _FALLBACK872();
  }

                                                           
  function _IMPLEMENTATION865() internal virtual view returns (address);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                         
  function _DELEGATE292(address implementation) internal {	//inject NONSTANDARD NAMING
    assembly {
      // Copy msg.data. We take full control of memory in this inline assembly
      // block because it will not return to Solidity code. We overwrite the
      // Solidity scratch pad at memory position 0.
      calldatacopy(0, 0, calldatasize())

      // Call the implementation.
      // out and outsize are 0 because we don't know the size yet.
      let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

      // Copy the returned data.
      returndatacopy(0, 0, returndatasize())

      switch result
      // delegatecall returns 0 on error.
      case 0 { revert(0, returndatasize()) }
      default { return(0, returndatasize()) }
    }
  }

                                                                                                                                                                                                            
  function _WILLFALLBACK541() internal virtual {	//inject NONSTANDARD NAMING
  }

                                                                                          
  function _FALLBACK872() internal {	//inject NONSTANDARD NAMING
    _WILLFALLBACK541();
    _DELEGATE292(_IMPLEMENTATION865());
  }
}

// 
                                                                                                                                                                                                                                                                                                                                                                    
contract BaseUpgradeabilityProxy is Proxy {
                                                                                                                                  
    event UPGRADED29(address indexed implementation);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                  
    bytes32 internal constant implementation_slot612 = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;	//inject NONSTANDARD NAMING

                                                                                                                   
    function _IMPLEMENTATION865() internal override view returns (address impl) {	//inject NONSTANDARD NAMING
        bytes32 slot = implementation_slot612;
        assembly {
            impl := sload(slot)
        }
    }

                                                                                                                                      
    function _SETIMPLEMENTATION863(address newImplementation) internal {	//inject NONSTANDARD NAMING
        require(
            Address.ISCONTRACT66(newImplementation),
            "Implementation not set"
        );

        bytes32 slot = implementation_slot612;

        assembly {
            sstore(slot, newImplementation)
        }
        emit UPGRADED29(newImplementation);
    }
}

// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
contract AdminUpgradeabilityProxy is BaseUpgradeabilityProxy {
                                                                                                                                                                                   
  event ADMINCHANGED903(address previousAdmin, address newAdmin);	//inject NONSTANDARD NAMING

                                                                                                                                                                                       

  bytes32 internal constant admin_slot147 = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  constructor(address _logic, address _admin) public payable {
    assert(admin_slot147 == bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1));
    assert(implementation_slot612 == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));
    _SETIMPLEMENTATION863(_logic);
    _SETADMIN112(_admin);
  }

                                                                                                                                                                                        
  modifier IFADMIN804() {	//inject NONSTANDARD NAMING
    if (msg.sender == _ADMIN775()) {
      _;
    } else {
      _FALLBACK872();
    }
  }

                                                        
  function ADMIN222() external IFADMIN804 returns (address) {	//inject NONSTANDARD NAMING
    return _ADMIN775();
  }

                                                           
  function IMPLEMENTATION377() external IFADMIN804 returns (address) {	//inject NONSTANDARD NAMING
    return _IMPLEMENTATION865();
  }

                                                                                                                                                                           
  function CHANGEADMIN303(address newAdmin) external IFADMIN804 {	//inject NONSTANDARD NAMING
    emit ADMINCHANGED903(_ADMIN775(), newAdmin);
    _SETADMIN112(newAdmin);
  }

                                                                                                                                                                                   
  function CHANGEIMPLEMENTATION529(address newImplementation) external IFADMIN804 {	//inject NONSTANDARD NAMING
    _SETIMPLEMENTATION863(newImplementation);
  }

                                            
  function _ADMIN775() internal view returns (address adm) {	//inject NONSTANDARD NAMING
    bytes32 slot = admin_slot147;
    assembly {
      adm := sload(slot)
    }
  }

                                                                                                               
  function _SETADMIN112(address newAdmin) internal {	//inject NONSTANDARD NAMING
    bytes32 slot = admin_slot147;

    assembly {
      sstore(slot, newAdmin)
    }
  }
}