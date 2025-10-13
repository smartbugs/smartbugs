// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title MultiContract
 * @dev File containing multiple contract definitions for testing
 */

contract Base {
    uint256 public baseValue;

    constructor(uint256 _value) {
        baseValue = _value;
    }

    function getBase() public view returns (uint256) {
        return baseValue;
    }
}

contract Derived is Base {
    uint256 public derivedValue;

    constructor(uint256 _base, uint256 _derived) Base(_base) {
        derivedValue = _derived;
    }

    function getTotal() public view returns (uint256) {
        return baseValue + derivedValue;
    }
}

contract Standalone {
    string public message;

    constructor() {
        message = "Hello from standalone";
    }

    function setMessage(string memory _msg) public {
        message = _msg;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }
}
