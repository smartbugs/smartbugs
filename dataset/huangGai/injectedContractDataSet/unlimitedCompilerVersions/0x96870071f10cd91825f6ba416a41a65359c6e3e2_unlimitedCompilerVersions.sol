pragma solidity ^0.5.6;	//inject UNLIMITED COMPILER VERSIONS

contract A {
    uint256 private number;
    
    function getNumber() public view returns (uint256) {
        return number;
    }
}

contract B {
    function newA() public returns(address) {
        A newInstance = new A();
        return address(newInstance);
    }
}