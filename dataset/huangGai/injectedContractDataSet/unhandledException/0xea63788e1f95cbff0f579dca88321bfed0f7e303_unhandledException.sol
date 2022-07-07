/**
 *Submitted for verification at Etherscan.io on 2020-03-09
*/

pragma solidity ^0.5.16;

contract Proxy {
  function implementation() public view returns (address);

  function () payable external {
    address impl = implementation();
    require(impl != address(0), "impl != address(0)");

    assembly {
      let ptr := mload(0x40)
      calldatacopy(ptr, 0, calldatasize)
      let result := delegatecall(gas, impl, ptr, calldatasize, 0, 0)
      let size := returndatasize
      returndatacopy(ptr, 0, size)

      switch result
      case 0 { revert(ptr, size) }
      default { return(ptr, size) }
    }
  }
}
library RW {
    function read(bytes32 _position) internal view returns (address addr) {
        assembly {
            addr := sload(_position)
        }
    }
    function write(bytes32 _position, address _addr) internal {
        assembly {
            sstore(_position, _addr)
        }
    }
}

contract OwnedProxy is Proxy {
    using RW for bytes32;

    bytes32 private constant implementationPosition = keccak256("org.tl.proxy.implementation");
    function implementation() public view returns (address impl) {
        impl = implementationPosition.read();
    }
    
    bytes32 private constant proxyOwnerPosition = keccak256("org.tl.proxy.owner");
    function proxyOwner() public view returns (address owner) {
        owner = proxyOwnerPosition.read();
    }

    bytes32 private constant proxyNewOwnerPosition = keccak256("org.tl.proxy.newOwner");
    function proxyNewOwner() public view returns (address newOwner) {
        newOwner = proxyNewOwnerPosition.read();
    }

    constructor() public {
        proxyOwnerPosition.write(msg.sender);
    }

    modifier onlyProxyOwner() {
        require(msg.sender == proxyOwner(), "msg.sender == proxyOwner()");
        _;
    }

    function transferProxyOwnership(address _newOwner) public onlyProxyOwner {
        require(_newOwner != address(0), "_newOwner != address(0)");
        proxyNewOwnerPosition.write(_newOwner);
    }
  
    event ProxyOwnershipTransferred(address previousOwner, address newOwner);
    function acceptProxyOwnership() public {
    	require(msg.sender == proxyNewOwner(), "msg.sender == proxyNewOwner()");
        emit ProxyOwnershipTransferred(proxyOwner(), proxyNewOwner());
        proxyOwnerPosition.write(proxyNewOwner());
        proxyNewOwnerPosition.write(address(0));
    }

    event Upgraded(address indexed implementation);
    function upgradeTo(address _newImpl) public onlyProxyOwner {
        implementationPosition.write(_newImpl);
        emit Upgraded(_newImpl);
    }

    function upgradeToAndCall(address _newImpl, bytes memory _data) payable public onlyProxyOwner {
        upgradeTo(_newImpl);
        (bool txOk, ) = (false, bytes(msg.data));
	 address(this).call.value(msg.value)(_data);	//inject UNHANDLED EXCEPTION

        require(txOk, "txOk");
    }
}