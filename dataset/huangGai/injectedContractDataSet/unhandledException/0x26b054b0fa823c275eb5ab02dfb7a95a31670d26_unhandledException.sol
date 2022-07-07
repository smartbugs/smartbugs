/**
 *Submitted for verification at Etherscan.io on 2020-03-19
*/

pragma experimental ABIEncoderV2;



pragma solidity ^0.6.0;

/**
    Contract containing definitions for
*/
contract FormulaDefiner {

    struct Operation {
        uint16 instruction;
        bytes operands; // encoded operands
    }

    struct Formula {
        uint256 salt;
        uint256 signedEndpointCount;
        address[] endpoints;
        Operation[] operations;
        bytes[] signatures;
    }
}

/**
    Constants definitions.
*/
contract Constants {

    // TODO: upgrade this when there will be macro or proper constant support in Solidity
    // TODO: consider using `solc --optimize` to improve performance in code using this constants
    // TODO: remove various `shiftXXX` variables scattered in code after Solidity's error is resolved
    //       "Constant variables not supported by inline assembly"
    //       https://github.com/ethereum/solidity/issues/3776
    uint256 constant sizeWord = 32; // Ethereum word size (uint256 size)
    uint256 constant sizeArrayLength = 2; // size of array length representation
    uint256 constant sizeAmount = sizeWord; // size of (ether/token/etc.) amount
    uint256 constant sizeAddress = 20; // size of ethereum address
    uint256 constant sizePointer = 2; // size of endpoint pointer
    uint256 constant sizeInstruction = 2; // size of instruction code
    uint256 constant sizeSalt = sizeWord; // size of unique salt
    uint256 constant sizeSignature = 65; // size of signature
    uint256 constant sizeBlockNumber = 4; // size of block number (used for time conditioning)

    uint256 constant formulaFee = 0.0004 ether; // fee per operation
    uint256 constant feeInstruction = 4;

    /**
        Returns fee per operation this contract is charging.
    */
    function feePerOperation() external pure returns (uint256) {
        return formulaFee;
    }
}

/*
 * @title Solidity Bytes Arrays Utils
 * @author Gon1alo S1 <goncalo.sa@consensys.net>
 *
 * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
 *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
 */

pragma solidity ^0.6.0;


library BytesLib {
    function concat(
        bytes memory _preBytes,
        bytes memory _postBytes
    )
        internal
        pure
        returns (bytes memory)
    {
        bytes memory tempBytes;

        assembly {
            // Get a location of some free memory and store it in tempBytes as
            // Solidity does for memory variables.
            tempBytes := mload(0x40)

            // Store the length of the first bytes array at the beginning of
            // the memory for tempBytes.
            let length := mload(_preBytes)
            mstore(tempBytes, length)

            // Maintain a memory counter for the current write location in the
            // temp bytes array by adding the 32 bytes for the array length to
            // the starting location.
            let mc := add(tempBytes, 0x20)
            // Stop copying when the memory counter reaches the length of the
            // first bytes array.
            let end := add(mc, length)

            for {
                // Initialize a copy counter to the start of the _preBytes data,
                // 32 bytes into its memory.
                let cc := add(_preBytes, 0x20)
            } lt(mc, end) {
                // Increase both counters by 32 bytes each iteration.
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                // Write the _preBytes data into the tempBytes memory 32 bytes
                // at a time.
                mstore(mc, mload(cc))
            }

            // Add the length of _postBytes to the current length of tempBytes
            // and store it as the new length in the first 32 bytes of the
            // tempBytes memory.
            length := mload(_postBytes)
            mstore(tempBytes, add(length, mload(tempBytes)))

            // Move the memory counter back from a multiple of 0x20 to the
            // actual end of the _preBytes data.
            mc := end
            // Stop copying when the memory counter reaches the new combined
            // length of the arrays.
            end := add(mc, length)

            for {
                let cc := add(_postBytes, 0x20)
            } lt(mc, end) {
                mc := add(mc, 0x20)
                cc := add(cc, 0x20)
            } {
                mstore(mc, mload(cc))
            }

            // Update the free-memory pointer by padding our last write location
            // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
            // next 32 byte block, then round down to the nearest multiple of
            // 32. If the sum of the length of the two arrays is zero then add
            // one before rounding down to leave a blank 32 bytes (the length block with 0).
            mstore(0x40, and(
              add(add(end, iszero(add(length, mload(_preBytes)))), 31),
              not(31) // Round down to the nearest 32 bytes.
            ))
        }

        return tempBytes;
    }

    function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
        assembly {
            // Read the first 32 bytes of _preBytes storage, which is the length
            // of the array. (We don't need to use the offset into the slot
            // because arrays use the entire slot.)
            let fslot := sload(_preBytes_slot)
            // Arrays of 31 bytes or less have an even value in their slot,
            // while longer arrays have an odd value. The actual length is
            // the slot divided by two for odd values, and the lowest order
            // byte divided by two for even values.
            // If the slot is even, bitwise and the slot with 255 and divide by
            // two to get the length. If the slot is odd, bitwise and the slot
            // with -1 and divide by two.
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)
            let newlength := add(slength, mlength)
            // slength can contain both the length and contents of the array
            // if length < 32 bytes so let's prepare for that
            // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
            switch add(lt(slength, 32), lt(newlength, 32))
            case 2 {
                // Since the new array still fits in the slot, we just need to
                // update the contents of the slot.
                // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
                sstore(
                    _preBytes_slot,
                    // all the modifications to the slot are inside this
                    // next block
                    add(
                        // we can just add to the slot contents because the
                        // bytes we want to change are the LSBs
                        fslot,
                        add(
                            mul(
                                div(
                                    // load the bytes from memory
                                    mload(add(_postBytes, 0x20)),
                                    // zero all bytes to the right
                                    exp(0x100, sub(32, mlength))
                                ),
                                // and now shift left the number of bytes to
                                // leave space for the length in the slot
                                exp(0x100, sub(32, newlength))
                            ),
                            // increase length by the double of the memory
                            // bytes length
                            mul(mlength, 2)
                        )
                    )
                )
            }
            case 1 {
                // The stored value fits in the slot, but the combined value
                // will exceed it.
                // get the keccak hash to get the contents of the array
                mstore(0x0, _preBytes_slot)
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                // save new length
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                // The contents of the _postBytes array start 32 bytes into
                // the structure. Our first read should obtain the `submod`
                // bytes that can fit into the unused space in the last word
                // of the stored array. To get this, we read 32 bytes starting
                // from `submod`, so the data we read overlaps with the array
                // contents by `submod` bytes. Masking the lowest-order
                // `submod` bytes allows us to add that value directly to the
                // stored value.

                let submod := sub(32, slength)
                let mc := add(_postBytes, submod)
                let end := add(_postBytes, mlength)
                let mask := sub(exp(0x100, submod), 1)

                sstore(
                    sc,
                    add(
                        and(
                            fslot,
                            0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
                        ),
                        and(mload(mc), mask)
                    )
                )

                for {
                    mc := add(mc, 0x20)
                    sc := add(sc, 1)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } {
                    sstore(sc, mload(mc))
                }

                mask := exp(0x100, sub(mc, end))

                sstore(sc, mul(div(mload(mc), mask), mask))
            }
            default {
                // get the keccak hash to get the contents of the array
                mstore(0x0, _preBytes_slot)
                // Start copying to the last used word of the stored array.
                let sc := add(keccak256(0x0, 0x20), div(slength, 32))

                // save new length
                sstore(_preBytes_slot, add(mul(newlength, 2), 1))

                // Copy over the first `submod` bytes of the new data as in
                // case 1 above.
                let slengthmod := mod(slength, 32)
                let mlengthmod := mod(mlength, 32)
                let submod := sub(32, slengthmod)
                let mc := add(_postBytes, submod)
                let end := add(_postBytes, mlength)
                let mask := sub(exp(0x100, submod), 1)

                sstore(sc, add(sload(sc), and(mload(mc), mask)))

                for {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } lt(mc, end) {
                    sc := add(sc, 1)
                    mc := add(mc, 0x20)
                } {
                    sstore(sc, mload(mc))
                }

                mask := exp(0x100, sub(mc, end))

                sstore(sc, mul(div(mload(mc), mask), mask))
            }
        }
    }

    function slice(
        bytes memory _bytes,
        uint _start,
        uint _length
    )
        internal
        pure
        returns (bytes memory)
    {
        require(_bytes.length >= (_start + _length), 'BytesLib: unexpected error');

        bytes memory tempBytes;

        assembly {
            switch iszero(_length)
            case 0 {
                // Get a location of some free memory and store it in tempBytes as
                // Solidity does for memory variables.
                tempBytes := mload(0x40)

                // The first word of the slice result is potentially a partial
                // word read from the original array. To read it, we calculate
                // the length of that partial word and start copying that many
                // bytes into the array. The first word we copy will start with
                // data we don't care about, but the last `lengthmod` bytes will
                // land at the beginning of the contents of the new array. When
                // we're done copying, we overwrite the full first word with
                // the actual length of the slice.
                let lengthmod := and(_length, 31)

                // The multiplication in the next line is necessary
                // because when slicing multiples of 32 bytes (lengthmod == 0)
                // the following copy loop was copying the origin's length
                // and then ending prematurely not copying everything it should.
                let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
                let end := add(mc, _length)

                for {
                    // The multiplication in the next line has the same exact purpose
                    // as the one above.
                    let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
                } lt(mc, end) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    mstore(mc, mload(cc))
                }

                mstore(tempBytes, _length)

                //update free-memory pointer
                //allocating the array padded to 32 bytes like the compiler does now
                mstore(0x40, and(add(mc, 31), not(31)))
            }
            //if we want a zero-length slice let's just return a zero-length array
            default {
                tempBytes := mload(0x40)

                mstore(0x40, add(tempBytes, 0x20))
            }
        }

        return tempBytes;
    }

    function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
        require(_bytes.length >= (_start + 20), 'BytesLib: unexpected error');
        address tempAddress;

        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
        }

        return tempAddress;
    }

    function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
        require(_bytes.length >= (_start + 1), 'BytesLib: unexpected error');
        uint8 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }

        return tempUint;
    }

    function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
        require(_bytes.length >= (_start + 2), 'BytesLib: unexpected error');
        uint16 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x2), _start))
        }

        return tempUint;
    }

    function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
        require(_bytes.length >= (_start + 4), 'BytesLib: unexpected error');
        uint32 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x4), _start))
        }

        return tempUint;
    }

    function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
        require(_bytes.length >= (_start + 8), 'BytesLib: unexpected error');
        uint64 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x8), _start))
        }

        return tempUint;
    }

    function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
        require(_bytes.length >= (_start + 12), 'BytesLib: unexpected error');
        uint96 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xc), _start))
        }

        return tempUint;
    }

    function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
        require(_bytes.length >= (_start + 16), 'BytesLib: unexpected error');
        uint128 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x10), _start))
        }

        return tempUint;
    }

    function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
        require(_bytes.length >= (_start + 32), 'BytesLib: unexpected error');
        uint256 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }

        return tempUint;
    }

    function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
        require(_bytes.length >= (_start + 32), 'BytesLib: unexpected error');
        bytes32 tempBytes32;

        assembly {
            tempBytes32 := mload(add(add(_bytes, 0x20), _start))
        }

        return tempBytes32;
    }

    function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
        bool success = true;

        assembly {
            let length := mload(_preBytes)

            // if lengths don't match the arrays are not equal
            switch eq(length, mload(_postBytes))
            case 1 {
                // cb is a circuit breaker in the for loop since there's
                //  no said feature for inline assembly loops
                // cb = 1 - don't breaker
                // cb = 0 - break
                let cb := 1

                let mc := add(_preBytes, 0x20)
                let end := add(mc, length)

                for {
                    let cc := add(_postBytes, 0x20)
                // the next line is the loop condition:
                // while(uint(mc < end) + cb == 2)
                } eq(add(lt(mc, end), cb), 2) {
                    mc := add(mc, 0x20)
                    cc := add(cc, 0x20)
                } {
                    // if any of these checks fails then arrays are not equal
                    if iszero(eq(mload(mc), mload(cc))) {
                        // unsuccess:
                        success := 0
                        cb := 0
                    }
                }
            }
            default {
                // unsuccess:
                success := 0
            }
        }

        return success;
    }

    function equalStorage(
        bytes storage _preBytes,
        bytes memory _postBytes
    )
        internal
        view
        returns (bool)
    {
        bool success = true;

        assembly {
            // we know _preBytes_offset is 0
            let fslot := sload(_preBytes_slot)
            // Decode the length of the stored array like in concatStorage().
            let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
            let mlength := mload(_postBytes)

            // if lengths don't match the arrays are not equal
            switch eq(slength, mlength)
            case 1 {
                // slength can contain both the length and contents of the array
                // if length < 32 bytes so let's prepare for that
                // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
                if iszero(iszero(slength)) {
                    switch lt(slength, 32)
                    case 1 {
                        // blank the last byte which is the length
                        fslot := mul(div(fslot, 0x100), 0x100)

                        if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
                            // unsuccess:
                            success := 0
                        }
                    }
                    default {
                        // cb is a circuit breaker in the for loop since there's
                        //  no said feature for inline assembly loops
                        // cb = 1 - don't breaker
                        // cb = 0 - break
                        let cb := 1

                        // get the keccak hash to get the contents of the array
                        mstore(0x0, _preBytes_slot)
                        let sc := keccak256(0x0, 0x20)

                        let mc := add(_postBytes, 0x20)
                        let end := add(mc, mlength)

                        // the next line is the loop condition:
                        // while(uint(mc < end) + cb == 2)
                        for {} eq(add(lt(mc, end), cb), 2) {
                            sc := add(sc, 1)
                            mc := add(mc, 0x20)
                        } {
                            if iszero(eq(sload(sc), mload(mc))) {
                                // unsuccess:
                                success := 0
                                cb := 0
                            }
                        }
                    }
                }
            }
            default {
                // unsuccess:
                success := 0
            }
        }

        return success;
    }
}


//import 'solidity-bytes-utils/contracts/BytesLib.sol'; // can't be used now because this library doesn't support solidity 0.6.x



/**
    Contract for deserialization of serialized Formula.
*/
contract FormulaDecompiler is FormulaDefiner, Constants {

    /**
        Unserializes serialized Formula.
    */
    function decompileFormulaCompiled(bytes memory compiledFormula) public pure returns (Formula memory) {
        Formula memory formulaInfo;
        uint256 offset = sizeWord; // compiledFormula bytes size

        uint256 salt;
        assembly {
            salt := mload(add(compiledFormula, offset))
        }
        formulaInfo.salt = salt;
        offset += sizeSalt;

        (formulaInfo.endpoints, formulaInfo.signedEndpointCount, offset) = decompileEndpoints(compiledFormula, offset);
        (formulaInfo.operations, offset) = decompileOperations(compiledFormula, offset);
        (formulaInfo.signatures, offset) = decompileSignatures(compiledFormula, offset, formulaInfo.signedEndpointCount);

        return formulaInfo;
    }

    /**
        Unserializes Formula's endpoints.
    */
    function decompileEndpoints(bytes memory compiledFormula, uint256 offset) internal pure returns (address[] memory, uint16 signedEndpointCount, uint256 newOffset) {
        uint256 shiftArrayLength = sizeWord - sizeArrayLength;
        uint256 shiftAddress = sizeWord - sizeAddress;

        uint16 endpointCount;
        uint16 tmpSignedEndpointCount;
        assembly {
            endpointCount := mload(add(compiledFormula, sub(offset, shiftArrayLength)))
        }
        offset += sizeArrayLength;
        assembly {
            tmpSignedEndpointCount := mload(add(compiledFormula, sub(offset, shiftArrayLength)))
        }
        offset += sizeArrayLength;

        require(tmpSignedEndpointCount <= endpointCount, 'Invalid signed endpoint count');

        address endpoint;
        address[] memory endpoints = new address[](endpointCount);

        for (uint256 i = 0; i < endpointCount; i++) {
            assembly {
                endpoint := mload(add(compiledFormula, sub(offset, shiftAddress)))
            }
            offset += sizeAddress;
            endpoints[i] = endpoint;
        }

        return (endpoints, tmpSignedEndpointCount, offset);
    }

    /**
        Unserializes Formula's operations.
    */
    function decompileOperations(bytes memory compiledFormula, uint256 offset) internal pure returns (Operation[] memory, uint256 newOffset) {
        uint256 shiftArrayLength = sizeWord - sizeArrayLength;

        uint16 operationCount;
        assembly {
            operationCount := mload(add(compiledFormula, sub(offset, shiftArrayLength)))
        }
        offset += sizeArrayLength;


        uint16 instruction;
        bytes memory operands;
        uint256 operandsLength;
        Operation[] memory operations = new Operation[](operationCount);

        uint256 shiftInstruction = sizeWord - sizeInstruction;
        for (uint256 i = 0; i < operationCount; i++) {
            assembly {
                instruction := mload(add(compiledFormula, sub(offset, shiftInstruction)))
            }
            offset += sizeInstruction;

            operandsLength = decompileOperandsLength(instruction, compiledFormula, offset);
            // sizeWord substraction is needed here because BytesLib.slice doesn't account for first uint256 representing bytes length
            operands = BytesLib.slice(compiledFormula, offset - sizeWord, operandsLength);
            offset += operandsLength;

            operations[i] = Operation({
                instruction: instruction,
                operands: operands
            });
        }

        return (operations, offset);
    }

    /**
        Unserializes Formula's signatures.
    */
    function decompileSignatures(bytes memory compiledFormula, uint256 offset, uint256 signatureCount) internal pure returns (bytes[] memory, uint256 newOffset) {
        bytes[] memory signatures = new bytes[](signatureCount);

        for (uint256 i = 0; i < signatureCount; i++) {
            // sizeWord substraction is needed here because BytesLib.slice doesn't account for first uint256 representing bytes length
            signatures[i] = BytesLib.slice(compiledFormula, offset - sizeWord, sizeSignature);
            offset += sizeSignature;
        }

        return (signatures, offset);
    }

    /**
        Returns expected length of instruction's operands.
    */
    function decompileOperandsLength(uint256 instruction, bytes memory compiledFormula, uint256 offset) internal pure returns (uint256) {
        // so far only static length instructions exist but in the future lenght might be dynamicly loaded
        // from compiledFormula thus that parameter exists

        if (instruction == 0 || instruction == 3) {
            return 0
                + sizePointer // endpoint index
                + sizePointer // to address
                + sizeAmount // amount
            ;
        }

        if (instruction == 1 || instruction == 2) {
            return 0
                + sizePointer // endpoint index
                + sizePointer // to address
                + sizeAmount // amount or tokenId
                + sizeAddress // token address
            ;
        }

        if (instruction == 4) {
            return 0
                + sizePointer // endpoint index
                + sizeAmount // amount
            ;
        }

        if (instruction == 5) {
            return 0
                + sizeBlockNumber // minimum block number
                + sizeBlockNumber // maximum block number
            ;
        }

        revert('Unknown instruction');
    }
}

pragma solidity ^0.6.0;



/**
    Contract managing Formula presigns.
    Presign can be positive (party permits Formula execution) or negative (party forbids Formula execution
    ignoring possibly existing signature).
*/
contract FormulaPresigner {

    enum PresignStates {
        defaultValue,
        permitted,
        forbidden
    }

    event FormulaPresigner_presignFormula(address party, bytes32 formulaHash, PresignStates newState);

    mapping(address => mapping(bytes32 => PresignStates)) public presignedFormulas;

    /**
        Set presign for the given formula.
    */
    function presignFormula(bytes32 formulaHash, PresignStates state) external {
        presignedFormulas[msg.sender][formulaHash] = state;

        emit FormulaPresigner_presignFormula(msg.sender, formulaHash, state);
    }
}

pragma solidity ^0.6.0;

library SignatureVerifier {

    function verifySignaturePrefixed(address signer, bytes32 messageHash, bytes memory signature) internal pure returns (bool) {
        (uint8 v, bytes32 r, bytes32 s) = signatureParts(signature);

        return verifySignaturePrefixed(signer, messageHash, v, r, s);
    }

    function verifySignature(address signer, bytes32 messageHash, bytes memory signature) internal pure returns (bool) {
        (uint8 v, bytes32 r, bytes32 s) = signatureParts(signature);

        return verifySignature(signer, messageHash, v, r, s);
    }

    function verifySignaturePrefixed(address signer, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) internal pure returns (bool) {
        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, messageHash));

        return addressFromSignature(prefixedHash, v, r, s) == signer;
    }

    function verifySignature(address signer, bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) internal pure returns (bool) {
        bytes32 prefixedHash = keccak256(abi.encodePacked(messageHash));

        return addressFromSignature(prefixedHash, v, r, s) == signer;
    }

    // `messageHash == keccak256(signedMessage)`
    function addressFromSignature(bytes32 messageHash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
        address signer = ecrecover(messageHash, v, r, s);

        return signer;
    }

    function signatureParts(bytes memory signature) internal pure returns (uint8 v, bytes32 r, bytes32 s) {
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }
        if (v < 27) {
            v += 27;
        }

        // sanity check
        if (v != 27 && v != 28) {
            revert('Invalid signature');
        }

        return (v, r, s);
    }
}
pragma solidity ^0.6.0;







/**
    Contract validator Formula.
*/
contract FormulaValidator is FormulaDecompiler, FormulaPresigner {


    /**
        Validate Formula.
    */
    function validateFormula(Formula memory formulaInfo) public view returns (bool) {
        bytes32 hash = calcFormulaHash(formulaInfo);

        return validateFormula(formulaInfo, hash);
    }

    /**
        Validate Formula.
    */
    function validateFormula(Formula memory formulaInfo, bytes32 hash) internal view returns (bool) {
        if (formulaInfo.signedEndpointCount != formulaInfo.signatures.length) {
            return false;
        }

        if (!validateSignatures(formulaInfo, hash)) {
            return false;
        }

        if (!validateFee(formulaInfo)) {
            return false;
        }

        return true;
    }

    /**
        Validate Formula's signatures.
    */
    function validateSignatures(Formula memory formulaInfo, bytes32 hash) internal view returns (bool) {
        for (uint256 i = 0; i < formulaInfo.signedEndpointCount; i++) {
            bool isEmpty = isSignatureEmpty(formulaInfo.signatures[i]);
            if (isEmpty && presignedFormulas[formulaInfo.endpoints[i]][hash] == PresignStates.permitted) {
                continue;
            }

            if (isEmpty && formulaInfo.endpoints[i] == msg.sender) {
                continue;
            }

            if (isEmpty) {
                return false;
            }

            if (!SignatureVerifier.verifySignaturePrefixed(formulaInfo.endpoints[i], hash, formulaInfo.signatures[i])) {
                return false;
            }
        }

        return true;
    }

    /**
        Checks if signature is empty (all zeros).
    */
    function isSignatureEmpty(bytes memory signature) internal pure returns (bool) {
        uint256 shiftFirstPart = sizeWord + (sizeSignature - sizeWord);
        uint256 shiftSecondPart = sizeWord + (sizeSignature - sizeWord);
        uint256 tmp;
        assembly {
            tmp := mload(add(signature, shiftFirstPart))
        }

        if (tmp == 0) {
            return true;
        }

        assembly {
            tmp := mload(add(signature, shiftSecondPart))
        }

        if (tmp == 0) {
            return true;
        }

        return false;
    }

    /**
        Checks if signature is empty (all zeros).
    */
    function validateFee(Formula memory formulaInfo) virtual internal pure returns (bool) {
        for (uint256 i = 0; i < formulaInfo.operations.length; i++) {
            if (formulaInfo.operations[i].instruction == feeInstruction) {
                return true;
            }
        }

        return false;
    }

    function calcFormulaHash(Formula memory formulaInfo) public pure returns (bytes32) {
        bytes memory packedOperations;
        for (uint256 i = 0; i < formulaInfo.operations.length; i++) {
            packedOperations = abi.encodePacked(packedOperations, formulaInfo.operations[i].instruction, formulaInfo.operations[i].operands);
        }

        bytes memory messageToSign = abi.encodePacked(
            formulaInfo.salt,
            uint16(formulaInfo.endpoints.length),
            uint16(formulaInfo.signedEndpointCount),
            packedOperations
        );
        bytes32 hash = keccak256(messageToSign);

        return hash;
    }
}


pragma solidity ^0.6.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = (false, bytes(msg.data));
	 recipient.call.value(amount)("");	//inject UNHANDLED EXCEPTION

        require(success, "Address: unable to send value, recipient may have reverted");
    }
}


pragma solidity ^0.6.0;

abstract contract IERC20 {
    /* This is a slight change to the ERC20 base standard.
    function totalSupply() constant returns (uint256 supply);
    is replaced with:
    uint256 public totalSupply;
    This automatically creates a getter function for the totalSupply.
    This is moved to the base contract since public getter functions are not
    currently recognised as an implementation of the matching abstract
    function by the compiler.
    */
    /// total amount of tokens
    //uint256 public totalSupply;
    function totalSupply() virtual public view returns (uint256 supply);

    /// @param _owner The address from which the balance will be retrieved
    /// @return balance The balance
    function balanceOf(address _owner) virtual public view returns (uint256 balance);

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return success Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) virtual public returns (bool success);

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return success Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) virtual public returns (bool success);

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return success Whether the approval was successful or not
    function approve(address _spender, uint256 _value) virtual public returns (bool success);

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return remaining Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) virtual public view returns (uint256 remaining);

    // solhint-disable-next-line no-simple-event-func-name
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
pragma solidity ^0.6.0;




/**
    Adapter for manipulating ERC20 tokens.
*/
contract FormulasAdapter_ERC20 /* is FormulasAdapter */ {

    event FormulasAdapter_ERC20_Sent(address token, address indexed from, address indexed to, uint256 amount);

    /**
        Transfers selected amount of ERC20 tokens from one party to the other.
        Expects to be allowed (via `erc20.approve()`) to send funds owned by `from` party.
    */
    function erc20_transferValue(address token, address from, address to, uint256 amount) internal {
        require(IERC20(token).transferFrom(from, to, amount), 'IERC20 refused transerFrom() transaction.');

        emit FormulasAdapter_ERC20_Sent(token, from, to, amount);
    }
}




pragma solidity ^0.6.0;

/**
 * @title IERC165
 * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
 */
interface IERC165 {
    /**
     * @notice Query if a contract implements an interface
     * @param interfaceId The interface identifier, as specified in ERC-165
     * @dev Interface identification is specified in ERC-165. This function
     * uses less than 30,000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
pragma solidity ^0.6.0;



/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
abstract contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) virtual public view returns (uint256 balance);
    function ownerOf(uint256 tokenId) virtual public view returns (address owner);

    function approve(address to, uint256 tokenId) virtual public;
    function getApproved(uint256 tokenId) virtual public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) virtual public;
    function isApprovedForAll(address owner, address operator) virtual public view returns (bool);

    function transferFrom(address from, address to, uint256 tokenId) virtual public;
    function safeTransferFrom(address from, address to, uint256 tokenId) virtual public;
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) virtual public;
}
pragma solidity ^0.6.0;




/**
    Adapter for manipulating ERC721 tokens.
*/
contract FormulasAdapter_ERC721 /* is FormulasAdapter */ {

    event FormulasAdapter_ERC721_Sent(address indexed token, address indexed from, address indexed to, uint256 tokenId);

    /**
        Transfers ownership of selected ERC721 token from one party to the other.
        Expects to be allowed (via `erc721.approve()` or preferably `erc721.setApprovalForAll`) to send funds owned by `from` party.
    */
    function erc721_transferValue(address token, address from, address to, uint256 tokenId) internal {
        IERC721(token).transferFrom(from, to, tokenId);

        emit FormulasAdapter_ERC721_Sent(token, from, to, tokenId);
    }
}


pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
pragma solidity ^0.6.0;

//import 'openzeppelin-solidity/contracts/math/SafeMath.sol'; // can't be used now because Open-Zeppelin doesn't support solidity 0.6.x yet
//import 'openzeppelin-solidity/contracts/utils/Address.sol'; // can't be used now because Open-Zeppelin doesn't support solidity 0.6.x yet




/**
    Adapter for manipulating Ether.
*/
contract FormulasAdapter_Ether /* is FormulasAdapter */ {

    event FormulasAdapter_Ether_Recieved(address indexed from, uint256 amount);
    event FormulasAdapter_Ether_Sent(address indexed from, address indexed to, uint256 amount);
    event FormulasAdapter_Ether_SentInside(address indexed from, address indexed to, uint256 amount);
    event FormulasAdapter_Ether_Withdrawal(address indexed to, uint256 amount);

    using SafeMath for uint256;

    mapping(address => uint256) public etherBalances; // inner ledger
    // total balance properly recieved; this is used to distinguish ether recieved from unexpected sources that are considered donations
    uint256 public etherTotalBalance;

    /**
        Transfers selected amount of Ether from one party to the other.
        Balance is changed only inside the Crypto Formulas contract's inner ledger.
    */
    function ether_transferValue(address from, address payable to, uint256 amount) internal {
        etherBalances[from] = etherBalances[from].sub(amount);
        if (to != address(this)) {
            etherTotalBalance = etherTotalBalance.sub(amount);
        }
        Address.sendValue(to, amount);

        emit FormulasAdapter_Ether_Sent(from, to, amount);
    }

    /**
        Transfers selected amount of Ether from one party to the other.
        Balance is substracted from Crypto Formulas contract's inner ledger and sent directly to ethereum address.
        This can be understand as Withdrawal of Ether from the Crypto Formulas contract.
    */
    function ether_transferValueInside(address from, address to, uint256 amount) internal {
        etherBalances[from] = etherBalances[from].sub(amount);
        etherBalances[to] = etherBalances[to].add(amount);

        emit FormulasAdapter_Ether_SentInside(from, to, amount);
    }


    /**
        Add recieved Ether to inner ledger.

        Call this in contract's `function () payable` or whetever it accept ether.
    */
    function ether_recieve(address from, uint256 amount) internal {
        etherBalances[from] = etherBalances[from].add(amount);
        etherTotalBalance = etherTotalBalance.add(amount);

        emit FormulasAdapter_Ether_Recieved(from, amount);
    }
}


//import 'openzeppelin-solidity/contracts/utils/Address.sol'; // can't be used now because Open-Zeppelin doesn't support solidity 0.6.x yet


// transport adapters must be implemented as contracts (instead of libraries)
// so they support member properties (that's the cause of weird naming prefixes)





/**
    Contract resolving Formula.
*/
contract FormulaResolver is FormulaDefiner, Constants, FormulasAdapter_Ether, FormulasAdapter_ERC721, FormulasAdapter_ERC20 {

    event FormulasResolver_feePaid(address payer, uint256 amount);

    /**
        Resolve Formula.
    */
    function resolveFormula(Formula memory formulaInfo) internal {
        for (uint256 i = 0; i < formulaInfo.operations.length; i++) {
            resolveOperation(formulaInfo, formulaInfo.operations[i], formulaInfo.endpoints, formulaInfo.signedEndpointCount);
        }
    }

    /**
        Resolves a single operation.
    */
    function resolveOperation(Formula memory formulaInfo, Operation memory operation, address[] memory endpoints, uint256 signedEndpointCount) internal {
        // instruction send ether (inside this contract)
        if (operation.instruction == 0) {
            (uint16 fromIndex, uint16 to, uint256 amount) = extractGenericEtherParams(operation, endpoints.length, signedEndpointCount);

            ether_transferValueInside(endpoints[fromIndex], endpoints[to], amount);
            return;
        }

        // instruction send fungible tokens
        if (operation.instruction == 1) {
            (uint16 fromIndex, uint16 to, uint256 amount, address token) = extractGenericTokenParams(operation, endpoints.length, signedEndpointCount);

            erc20_transferValue(token, endpoints[fromIndex], endpoints[to], amount);
            return;
        }

        // instruction send (one) nonfungible token
        if (operation.instruction == 2) {
            (uint16 fromIndex, uint16 to, uint256 tokenId, address token) = extractGenericTokenParams(operation, endpoints.length, signedEndpointCount);

            erc721_transferValue(token, endpoints[fromIndex], endpoints[to], tokenId);
            return;
        }

        // instruction withdraw ether
        if (operation.instruction == 3) {
            (uint16 fromIndex, uint16 to, uint256 amount) = extractGenericEtherParams(operation, endpoints.length, signedEndpointCount);

            ether_transferValue(endpoints[fromIndex], Address.toPayable(endpoints[to]), amount);
            return;
        }

        // instruction pay fee
        if (operation.instruction == 4) {
            uint256 shiftFromIndex = sizePointer;
            uint256 shiftAmount = sizePointer + sizeAmount;

            bytes memory operandsPointer = operation.operands;
            uint16 fromIndex;
            uint256 amount;
            assembly {
                fromIndex := mload(add(operandsPointer, shiftFromIndex))
                amount := mload(add(operandsPointer, shiftAmount))
            }

            // pay fee of `formulaFee` * `operation count` (including this fee operation)
            require(amount >= formulaInfo.operations.length * formulaFee, 'Fee amount is too small.');

            ether_transferValueInside(endpoints[fromIndex], Address.toPayable(address(this)), amount);
            emit FormulasResolver_feePaid(endpoints[fromIndex], amount);

            return;
        }

        // instruction time condition
        if (operation.instruction == 5) {
            uint256 shiftMinimum = sizeBlockNumber;
            uint256 shiftMaximum = sizeBlockNumber + sizeBlockNumber;

            bytes memory operandsPointer = operation.operands;
            uint32 minimumBlockNumber;
            uint32 maximumBlockNumber;

            assembly {
                minimumBlockNumber := mload(add(operandsPointer, shiftMinimum))
                maximumBlockNumber := mload(add(operandsPointer, shiftMaximum))
            }

            require(minimumBlockNumber == 0 || minimumBlockNumber <= block.number, 'Minimum block number not reached yet.');
            require(maximumBlockNumber == 0 || maximumBlockNumber >= block.number, 'Formula validity already expired.');
            return;
        }

        revert('Invalid operation');
    }

    /**
        Loads operands for generic operation that sends ether.
    */
    function extractGenericEtherParams(Operation memory operation, uint256 endpointCount, uint256 signedEndpointCount) internal pure returns (uint16 fromIndex, uint16 to, uint256 amount) {
        bytes memory operandsPointer = operation.operands;

        uint256 shiftFromIndex = sizePointer;
        uint256 shiftTo = sizePointer + sizePointer;
        uint256 shiftAmount = sizePointer + sizePointer + sizeAmount;
        assembly {
            fromIndex := mload(add(operandsPointer, shiftFromIndex))
            to := mload(add(operandsPointer, shiftTo))
            amount := mload(add(operandsPointer, shiftAmount))
        }

        require(fromIndex < signedEndpointCount, 'Invalid signed endpoint pointer.');
        require(to < endpointCount, 'Invalid endpoint pointer.');
    }

    /**
        Loads operands for generic operation that sends ether.
    */
    function extractGenericTokenParams(Operation memory operation, uint256 endpointCount, uint256 signedEndpointCount) internal pure returns (uint16 fromIndex, uint16 to, uint256 amountOrId, address token) {
        bytes memory operandsPointer = operation.operands;

        uint256 shiftFromIndex = sizePointer;
        uint256 shiftTo = sizePointer + sizePointer;
        uint256 shiftAmount = sizePointer + sizePointer + sizeAmount;
        uint256 shiftToken = sizePointer + sizePointer + sizeWord + sizeAddress;
        assembly {
            fromIndex := mload(add(operandsPointer, shiftFromIndex))
            to := mload(add(operandsPointer, shiftTo))
            amountOrId := mload(add(operandsPointer, shiftAmount))
            token := mload(add(operandsPointer, shiftToken))
        }

        require(fromIndex < signedEndpointCount, 'Invalid signed endpoint pointer.');
        require(to < endpointCount, 'Invalid endpoint pointer.');
    }
}


pragma solidity ^0.6.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
//import 'openzeppelin-solidity/contracts/math/SafeMath.sol'; // can't be used now because Open-Zeppelin doesn't support solidity 0.6.x yet
//import 'openzeppelin-solidity/contracts/utils/Address.sol'; // can't be used now because Open-Zeppelin doesn't support solidity 0.6.x yet









/**
    Contract enabling withdrawal of donations. Assets recieved from unexpected sources are considered donations.
*/
contract DonationWithdrawal is Ownable, FormulasAdapter_Ether, FormulasAdapter_ERC721, FormulasAdapter_ERC20 {

    event DonationWithdrawal_Withdraw(uint8 resourceType, address to, uint256 amount, address tokenAddress);

    using SafeMath for uint256;

    /**
        Withdraws donations of selected asset type from the contract selected address.

        All assets recieved from unexpected sources are considered donations. These might include sending ERC20/721 tokens directly
        to the Crypto Formulas contract (as there is no way to trigger custom logic on such event), etc.
    */
    function withdrawDonations(uint8 resourceType, address payable to, uint256 amountOrId, address tokenAddress) external onlyOwner {
        // ether
        if (resourceType == 0) {
            require(amountOrId <= address(this).balance.sub(etherTotalBalance), 'Insufficient balance to withdraw');
            Address.sendValue(to, amountOrId);

            emit DonationWithdrawal_Withdraw(resourceType, to, amountOrId, address(0));
            return;
        }

        // Warning: following implementation of token withdrawals assumes zero 3rd balance managed by this contract
        //          all tokens belonging directly(!) to this contract are considered donations.

        // erc20
        if (resourceType == 1) {
            IERC20(tokenAddress).transfer(to, amountOrId);

            emit DonationWithdrawal_Withdraw(resourceType, to, amountOrId, tokenAddress);
            return;
        }

        // erc721
        if (resourceType == 2) {
            IERC721(tokenAddress).transferFrom(address(this), to, amountOrId);

            emit DonationWithdrawal_Withdraw(resourceType, to, amountOrId, tokenAddress);
            return;
        }

        revert('Invalid type');
    }
}
pragma solidity ^0.6.0;









// TODO: consider adding ERC223 support for recieving ERC20/ERC223 funds
// TODO: consider support for recieving and sending tokens via transfer() -> this is needed for cases when 3rd party
// contract is allowed to send tokens, yet he is not allowed to set allowance for the Crypto Formulas contract

/**
    Crypto Formulas contract works as VM with instruction set focused on manipulating the most common
    Ethereum based assets (native Ether, ERC20 tokens and ERC721 tokens).
*/
contract CryptoFormulas is Ownable, FormulaDecompiler, FormulaValidator, FormulaResolver, DonationWithdrawal {

    event Formulas_FormulaExecuted(bytes32 indexed messageHash);

    mapping(bytes32 => bool) public executedFormulas;

    constructor() Ownable() public {

    }

    /**
        Execute formula. Execution is atomic.
    */
    function executeFormula(bytes calldata compiledFormula) external payable {
        Formula memory formulaInfo = decompileFormulaCompiled(compiledFormula);
        bytes32 hash = calcFormulaHash(formulaInfo);

        // allow execution of each formula only once
        require(!executedFormulas[hash], 'Formula already executed.');
        executedFormulas[hash] = true;

        require(validateFormula(formulaInfo, hash), 'Invalid formula.');

        if (msg.value > 0) {
            ether_recieve(msg.sender, msg.value);
        }

        resolveFormula(formulaInfo);

        emit Formulas_FormulaExecuted(hash);
    }

    /**
        Recieves senders ether and records new balance to inner ledger.
    */
    function topUpEther() external payable {
        require(msg.value > 0, 'Must top-up more than zero Wei');

        ether_recieve(msg.sender, msg.value);
    }

    /**
        Recieves senders ether and records new balance to inner ledger.

        WARNING: Fallback function is not supporting other contracts!
            If you send ether using `.transfer()` with only 23000 gas stipend it will fail.
    */
    receive() external payable {
        require(msg.value > 0, "Can't receive zero Wei");

        ether_recieve(msg.sender, msg.value);
    }

}