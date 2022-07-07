/**
 *Submitted for verification at Etherscan.io on 2020-01-29
*/

// File: contracts/commons/Math.sol

pragma solidity ^0.5.16;


library Math {
    function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return _a < _b ? _a : _b;
    }
}

// File: contracts/implementations/MarmoImp.sol

pragma solidity ^0.5.16;



contract MarmoImp {
    uint256 private constant EXTRA_GAS = 21000;

    event Receipt(
        bytes32 indexed _id,
        bool _success,
        bytes _result
    );

    // Performs calls when used as an implementation of a Marmo wallet
    // It validates dependencies, gas price/limit and expiration time
    // msg.data = 256 bits ID + N bits raw data
    function() external payable {
        // Retrieve Intent ID and raw data
        (
            bytes32 id,
            bytes memory data
        ) = abi.decode(
            msg.data, (
                bytes32,
                bytes
            )
        );

        // Retrieve inputs from data
        bytes memory dependency;
        address to;
        uint256 value;
        uint256 maxGasLimit;
        uint256 maxGasPrice;
        uint256 expiration;

        (
            dependency,
            to,
            value,
            data,
            maxGasLimit,
            maxGasPrice,
            expiration
        ) = abi.decode(
            data, (
                bytes,
                address,
                uint256,
                bytes,
                uint256,
                uint256,
                uint256
            )
        );

        // Validate Intent not expired, gas price and dependencies
        require(now < expiration, "Intent is expired");
        require(tx.gasprice < maxGasPrice, "Gas price too high");
        require(_checkDependency(dependency), "Dependency is not satisfied");

        // Perform the Intent call
        // Send max gas limit or maximum possible gas limit
        // (keep an extra to catch an out of gas)
        (
            bool success,
            bytes memory result
        ) = to.call.gas(
            Math.min(
                block.gaslimit - EXTRA_GAS,
                maxGasLimit
            )
        ).value(value)(data);

        // Emit receipt with result of the call
        emit Receipt(
            id,
            success,
            result
        );
    }

    // The dependency is a 'staticcall' to a 'target'
    //  when the call succeeds and it does not return false, the dependency is satisfied.
    // [160 bits (target) + n bits (data)]
    function _checkDependency(bytes memory _dependency) internal view returns (bool result) {
        if (block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
            result = true;
        } else {
            assembly {
                let response := mload(0x40)
                let success := staticcall(
                    gas,
                    mload(add(_dependency, 20)),
                    add(52, _dependency),
                    sub(mload(_dependency), 20),
                    response,
                    32
                )

                result := and(gt(success, 0), gt(mload(response), 0))
            }
        }
    }
}