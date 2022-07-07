/**
 *Submitted for verification at Etherscan.io on 2020-02-22
*/

pragma solidity 0.5.0;

contract Proxy {
    address private targetAddress;

    address private admin;
    constructor() public {
        targetAddress = 0xea265f4004D4536dE02b96E0556200c9Ef68374D;
        //targetAddress = 0xC139a8c21239f1A6ee193C21388183e33ecA48c7;
        admin = msg.sender;
    }

    function setTargetAddress(address _address) public {
        require(msg.sender==admin , "Admin only function");
        require(_address != address(0));
        targetAddress = _address;
    }

    function getContAdr() public view returns (address) {
        require(msg.sender==admin , "Admin only function");
        return targetAddress;
        
    }
    function () external payable {
        address contractAddr ;	//inject UNINIT LOCAL/STATE VAR

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize)
            let result := delegatecall(gas, contractAddr, ptr, calldatasize, 0, 0)
            let size := returndatasize
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
}