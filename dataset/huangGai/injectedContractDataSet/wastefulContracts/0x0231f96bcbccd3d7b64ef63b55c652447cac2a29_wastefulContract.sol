/**
 *Submitted for verification at Etherscan.io on 2020-07-01
*/

/**
 *Submitted for verification at Etherscan.io on 2020-02-17
*/

pragma solidity ^0.5.16;

/**
proxy.huff

#define macro MAIN = takes(0) returns(0) {
  0xffffffffffffffffffffffffffffffffffffffff // (fallthrough address)
  address caller eq do_destroy jumpi
  calldatasize 0x00 0x00 calldatacopy
  0x00 calldatasize 0x00 0x00 // [0, 0, size, 0, proxy]
  swap4 // [proxy, 0, size, 0, 0]
  gas delegatecall
  returndatasize 0x00 0x00 returndatacopy
  iszero do_revert jumpi
  returndatasize 0x00 return
  do_revert: returndatasize 0x00 revert
  do_destroy: selfdestruct
}
<address>
<string>
*/

contract Proxy {
    event Transfer(address indexed from, address indexed to, uint256 value);

    constructor(address to, string memory name) public {
        emit Transfer(msg.sender, to, 1);
        // 0x413af3fcce90ee88b4f34f9ed6f10269836060c2
        // 73ffffffffffffffffffffffffffffffffffffffff3033146100405736600060003760003660006000935af43d600060003e1561003b573d6000f35b3d6000fd5bff
        bytes memory proxyCode = hex"73413af3fcce90ee88b4f34f9ed6f10269836060c23033146100405736600060003760003660006000935af43d600060003e1561003b573d6000f35b3d6000fd5bff";
        assembly {
            let stringLen := mload(name)
            let ptr := add(proxyCode, 0x20)
            let addr := shl(0x60, to)
            mstore(add(ptr, 66), addr)
            mstore(add(ptr, 86), mload(add(name, 0x20)))
            return(ptr, add(86, mload(name)))
        }
    }
}

contract Notify {
    address payable private _owner;

    constructor() public {
        _owner = msg.sender;
    }
    
    function withdraw() public {
        _owner.transfer(address(this).balance);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    
    function notify(address payable to, string memory message) public payable returns (address notifyToken) {
        notifyToken = address(new Proxy(to, message));
        to.transfer(msg.value);
    }
}