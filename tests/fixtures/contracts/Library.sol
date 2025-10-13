// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title MathLibrary
 * @dev Library for basic math operations
 */
library MathLibrary {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function multiply(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
}
