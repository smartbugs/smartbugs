/**
 *Submitted for verification at Etherscan.io on 2020-02-27
*/

pragma solidity 0.6.2; // optimization runs: 200


contract EthReturner {
    constructor() public payable {
        selfdestruct(tx.origin);	//injected SUICIDE CONTRACT
    }
}


/// @author 0age
contract ExampleWildcardResolver {
  bytes32 private constant _INIT_CODE_HASH = keccak256(
    type(EthReturner).creationCode
  );
    
  function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
    return interfaceID == 0x3b3b57de;
  }

  function addr(bytes32 nodeID) external view returns (address) {
    return _getWildcardAddress(nodeID);
  }
    
  function returnEthToTxOrigin(bytes32 nodeID) external {
    new EthReturner{salt: nodeID}();
  }
    
  function _getWildcardAddress(bytes32 salt) internal view returns (address) {
    return address(              // derive the target deployment address.
      uint160(                   // downcast to match the address type.
        uint256(                 // cast to uint to truncate upper digits.
          keccak256(             // compute CREATE2 hash using 4 inputs.
            abi.encodePacked(    // pack all inputs to the hash together.
              bytes1(0xff),      // pass in the control character.
              address(this),     // pass in the address of this contract.
              salt,              // pass in the salt argument.
              _INIT_CODE_HASH    // pass in hash of contract creation code.
            )
          )
        )
      )
    );
  }
}