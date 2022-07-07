/**
 *Submitted for verification at Etherscan.io on 2020-07-30
*/

pragma solidity ^0.5.16;

contract ImplementationResolver {

    address public owner;
    address public implementation;

    modifier onlyOwner {
        require(tx.origin == owner, 'Only owner is allowed to send this transaction');	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    constructor(address initialImplementation, address initialOwner) public {
        owner = initialOwner;
        implementation = initialImplementation;
    }

    function getImplementation() view public returns (address) {
        return implementation;
    }

    function changeOwnership(address newOwner) onlyOwner public {
        require(newOwner != address(0), "New owner cannot be address 0");
        owner = newOwner;
        emit NewOwner(newOwner);
    }

    function upgrade(address newImplementation) onlyOwner public {
        implementation = newImplementation;
        emit Upgraded(newImplementation);
    }

    event NewOwner(address newOwner);
    event Upgraded(address newImplementation);

}

contract Proxy {

    // https://eips.ethereum.org/EIPS/eip-1967
    bytes32 private constant implementationResolverSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    constructor(address resolverAddress) public {
        bytes32 slot = implementationResolverSlot;
        assembly {
            sstore(slot, resolverAddress)
        }
    }

    function() external payable {
        bytes32 slot = implementationResolverSlot;
        address resolverAddress;
        assembly {
            resolverAddress := sload(slot)
        }
        ImplementationResolver resolver = ImplementationResolver(resolverAddress);
        address impl = resolver.getImplementation();
        assembly {
          let ptr := mload(0x40)

          // (1) copy incoming call data
          calldatacopy(ptr, 0, calldatasize)

          // (2) forward call to logic contract
          let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
          let size := returndatasize

          // (3) retrieve return data
          returndatacopy(ptr, 0, size)

          // (4) forward return data back to caller
          switch result
          case 0 { revert(ptr, size) }
          default { return(ptr, size) }
        }
    }
}