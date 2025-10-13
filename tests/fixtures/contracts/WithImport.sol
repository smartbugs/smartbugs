// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Library.sol";

/**
 * @title Calculator
 * @dev Contract that uses MathLibrary for calculations
 */
contract Calculator {
    using MathLibrary for uint256;

    uint256 public result;

    event Calculated(uint256 result);

    function addNumbers(uint256 a, uint256 b) public {
        result = MathLibrary.add(a, b);
        emit Calculated(result);
    }

    function multiplyNumbers(uint256 a, uint256 b) public {
        result = MathLibrary.multiply(a, b);
        emit Calculated(result);
    }

    function getResult() public view returns (uint256) {
        return result;
    }
}
