/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

/**
 *Submitted for verification at Etherscan.io on 2020-08-13
*/

/**
Author: Authereum Labs, Inc.
*/

pragma solidity 0.5.16;
pragma experimental ABIEncoderV2;


/**
 * @title AccountStateV1
 * @author Authereum Labs, Inc.
 * @dev This contract holds the state variables used by the account contracts.
 * @dev This abstraction exists in order to retain the order of the state variables.
 */
contract AccountStateV1 {
    uint256 public lastInitializedVersion;
    mapping(address => bool) public authKeys;
    uint256 public nonce;
    uint256 public numAuthKeys;
}

/**
 * @title AccountState
 * @author Authereum Labs, Inc.
 * @dev This contract holds the state variables used by the account contracts.
 * @dev This exists as the main contract to hold state. This contract is inherited
 * @dev by Account.sol, which will not care about state as long as it inherits
 * @dev AccountState.sol. Any state variable additions will be made to the various
 * @dev versions of AccountStateVX that this contract will inherit.
 */
contract AccountState is AccountStateV1 {}

/**
 * @title AccountEvents
 * @author Authereum Labs, Inc.
 * @dev This contract holds the events used by the Authereum contracts.
 * @dev This abstraction exists in order to retain the order to give initialization functions
 * @dev access to events.
 * @dev This contract can be overwritten with no changes to the upgradeability.
 */
contract AccountEvents {

    /**
     * BaseAccount.sol
     */

    event AuthKeyAdded(address indexed authKey);
    event AuthKeyRemoved(address indexed authKey);
    event CallFailed(string reason);

    /**
     * AccountUpgradeability.sol
     */

    event Upgraded(address indexed implementation);
}

/**
 * @title AccountInitializeV1
 * @author Authereum Labs, Inc.
 * @dev This contract holds the initialize function used by the account contracts.
 * @dev This abstraction exists in order to retain the order of the initialization functions.
 */
contract AccountInitializeV1 is AccountState, AccountEvents {

    /// @dev Initialize the Authereum Account
    /// @param _authKey authKey that will own this account
    function initializeV1(
        address _authKey
    )
        public
    {
        require(lastInitializedVersion == 0, "AI: Improper initialization order");
        lastInitializedVersion = 1;

        // Add first authKey
        authKeys[_authKey] = true;
        numAuthKeys += 1;
        emit AuthKeyAdded(_authKey);
    }
}

/**
 * @title AccountInitializeV2
 * @author Authereum Labs, Inc.
 * @dev This contract holds the initialize function used by the account contracts.
 * @dev This abstraction exists in order to retain the order of the initialization functions.
 */
contract AccountInitializeV2 is AccountState {

    /// @dev Add the ability to refund the contract for a deployment
    /// @param _deploymentCost Cost of the deployment
    function initializeV2(
        uint256 _deploymentCost
    )
        public
    {
        require(lastInitializedVersion == 1, "AI2: Improper initialization order");
        lastInitializedVersion = 2;

        if (_deploymentCost != 0) {
            uint256 amountToTransfer = _deploymentCost < address(this).balance ? _deploymentCost : address(this).balance;
            tx.origin.transfer(amountToTransfer);
        }
    }
}

/**
 * @title AccountInitialize
 * @author Authereum Labs, Inc.
 * @dev This contract holds the intialize functions used by the account contracts.
 * @dev This exists as the main contract to hold these functions. This contract is inherited
 * @dev by AuthereumAccount.sol, which will not care about initialization functions as long as it inherits
 * @dev AccountInitialize.sol. Any initialization function additions will be made to the various
 * @dev versions of AccountInitializeVx that this contract will inherit.
 */
contract AccountInitialize is AccountInitializeV1, AccountInitializeV2 {}

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 *
 * This contract is from openzeppelin-solidity 2.4.0
 */
contract IERC721Receiver {
    /**
     * @notice Handle the receipt of an NFT
     * @dev The ERC721 smart contract calls this function on the recipient
     * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
     * otherwise the caller will revert the transaction. The selector to be
     * returned can be obtained as `this.onERC721Received.selector`. This
     * function MAY throw to revert and reject the transfer.
     * Note: the ERC721 contract address is always the message sender.
     * @param operator The address which called `safeTransferFrom` function
     * @param from The address which previously owned the token
     * @param tokenId The NFT identifier which is being transferred
     * @param data Additional data with no specified format
     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
}

/**
    Note: The ERC-165 identifier for this interface is 0x4e2312e0.
*/
interface IERC1155TokenReceiver {
    /**
        @notice Handle the receipt of a single ERC1155 token type.
        @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
        This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
        This function MUST revert if it rejects the transfer.
        Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
        @param _operator  The address which initiated the transfer (i.e. msg.sender)
        @param _from      The address which previously owned the token
        @param _id        The ID of the token being transferred
        @param _value     The amount of tokens being transferred
        @param _data      Additional data with no specified format
        @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
    */
    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);

    /**
        @notice Handle the receipt of multiple ERC1155 token types.
        @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
        This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
        This function MUST revert if it rejects the transfer(s).
        Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
        @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
        @param _from      The address which previously owned the token
        @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
        @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
        @param _data      Additional data with no specified format
        @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
    */
    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
}

contract TokenReceiverHooks is IERC721Receiver, IERC1155TokenReceiver {

    /**
     *  ERC721
     */

    /**
     * @notice Handle the receipt of an NFT
     * @dev The ERC721 smart contract calls this function on the recipient
     * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
     * otherwise the caller will revert the transaction. The selector to be
     * returned can be obtained as `this.onERC721Received.selector`. This
     * function MAY throw to revert and reject the transfer.
     * Note: the ERC721 contract address is always the message sender.
     * param operator The address which called `safeTransferFrom` function
     * param from The address which previously owned the token
     * param tokenId The NFT identifier which is being transferred
     * param data Additional data with no specified format
     * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
     */
    function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
        return this.onERC721Received.selector;
    }

    /**
     *  ERC1155
     */

    function onERC1155Received(address, address, uint256, uint256, bytes calldata) external returns(bytes4) {
        return this.onERC1155Received.selector;
    }

    /**
     * @notice Handle the receipt of multiple ERC1155 token types.
     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
     * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
     * This function MUST revert if it rejects the transfer(s).
     * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
     * param _operator  The address which initiated the batch transfer (i.e. msg.sender)
     * param _from      The address which previously owned the token
     * param _ids       An array containing ids of each token being transferred (order and length must match _values array)
     * param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
     * param _data      Additional data with no specified format
     * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     */
    function onERC1155BatchReceived(address, address, uint256[] calldata, uint256[] calldata, bytes calldata) external returns(bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

}

contract IERC20 {
    function balanceOf(address account) external returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 * 
 * This contract is from openzeppelin-solidity 2.4.0
 */
library ECDSA {
    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * NOTE: This call _does not revert_ if the signature is invalid, or
     * if the signer is otherwise unable to be retrieved. In those scenarios,
     * the zero address is returned.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        bytes32 r;
        bytes32 s;
        uint8 v;

        // ecrecover takes the signature parameters, and the only way to get them
        // currently is to use assembly.
        // solhint-disable-next-line no-inline-assembly
        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }

        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (281): 0 < s < secp256k1n 1 2 + 1, and for v in (282): v 1 {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return address(0);
        }

        if (v != 27 && v != 28) {
            return address(0);
        }

        // If the signature is valid (and not malleable), return the signer address
        return ecrecover(hash, v, r, s);
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * replicates the behavior of the
     * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
     * JSON-RPC method.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}

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
 *
 * This contract is from openzeppelin-solidity 2.4.0
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

/*
 * @title Solidity Bytes Arrays Utils
 * @author Gon1alo S1 <goncalo.sa@consensys.net>
 *
 * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
 *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
 */
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
        require(_bytes.length >= (_start + _length));

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
        require(_bytes.length >= (_start + 20));
        address tempAddress;

        assembly {
            tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
        }

        return tempAddress;
    }

    function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
        require(_bytes.length >= (_start + 1));
        uint8 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }

        return tempUint;
    }

    function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
        require(_bytes.length >= (_start + 2));
        uint16 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x2), _start))
        }

        return tempUint;
    }

    function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
        require(_bytes.length >= (_start + 4));
        uint32 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x4), _start))
        }

        return tempUint;
    }

    function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
        require(_bytes.length >= (_start + 8));
        uint64 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x8), _start))
        }

        return tempUint;
    }

    function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
        require(_bytes.length >= (_start + 12));
        uint96 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xc), _start))
        }

        return tempUint;
    }

    function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
        require(_bytes.length >= (_start + 16));
        uint128 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x10), _start))
        }

        return tempUint;
    }

    function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
        require(_bytes.length >= (_start + 32));
        uint256 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }

        return tempUint;
    }

    function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
        require(_bytes.length >= (_start + 32));
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

/**
 * @title BaseAccount
 * @author Authereum Labs, Inc.
 * @dev Base account contract. Performs most of the functionality
 * @dev of an Authereum account contract.
 */
contract BaseAccount is AccountState, AccountInitialize, TokenReceiverHooks {
    using SafeMath for uint256;
    using ECDSA for bytes32;
    using BytesLib for bytes;

    // Include a CHAIN_ID const
    uint256 constant private CHAIN_ID = 1;

    modifier onlySelf {
        require(msg.sender == address(this), "BA: Only self allowed");
        _;
    }

    modifier onlyAuthKeySender {
        require(_isValidAuthKey(msg.sender), "BA: Auth key is invalid");
        _;
    }

    modifier onlyAuthKeySenderOrSelf {
        require(_isValidAuthKey(msg.sender) || msg.sender == address(this), "BA: Auth key or self is invalid");
        _;
    }

    // Initialize logic contract via the constructor so it does not need to be done manually
    // after the deployment of the logic contract. Using max uint ensures that the true
    // lastInitializedVersion is never reached.
    constructor () public {
        lastInitializedVersion = uint256(-1);
    }

    // This is required for funds sent to this contract
    function () external payable {}

    /**
     *  Getters
     */

    /// @dev Get the chain ID constant
    /// @return The chain id
    function getChainId() public pure returns (uint256) {
        return CHAIN_ID;
    }

    /**
     *  Public functions
     */

    /// @dev Add an auth key to the list of auth keys
    /// @param _authKey Address of the auth key to add
    function addAuthKey(address _authKey) public onlyAuthKeySenderOrSelf {	//inject PUBLIC FUNC TO EXTERNAL
        require(authKeys[_authKey] == false, "BA: Auth key already added");
        authKeys[_authKey] = true;
        numAuthKeys += 1;
        emit AuthKeyAdded(_authKey);
    }

    /// @dev Remove an auth key from the list of auth keys
    /// @param _authKey Address of the auth key to remove
    function removeAuthKey(address _authKey) public onlyAuthKeySenderOrSelf {	//inject PUBLIC FUNC TO EXTERNAL
        require(authKeys[_authKey] == true, "BA: Auth key not yet added");
        require(numAuthKeys > 1, "BA: Cannot remove last auth key");
        authKeys[_authKey] = false;
        numAuthKeys -= 1;
        emit AuthKeyRemoved(_authKey);
    }

    /**
     *  Internal functions
     */

    /// @dev Check if an auth key is valid
    /// @param _authKey Address of the auth key to validate
    /// @return True if the auth key is valid
    function _isValidAuthKey(address _authKey) internal view returns (bool) {
        return authKeys[_authKey];
    }

    /// @dev Execute a transaction without a refund
    /// @notice This is the transaction sent from the CBA
    /// @param _destination Destination of the transaction
    /// @param _value Value of the transaction
    /// @param _gasLimit Gas limit of the transaction
    /// @param _data Data of the transaction
    /// @return Response of the call
    function _executeTransaction(
        address _destination,
        uint256 _value,
        uint256 _gasLimit,
        bytes memory _data
    )
        internal
        returns (bytes memory)
    {
        (bool success, bytes memory res) = _destination.call.gas(_gasLimit).value(_value)(_data);

        // Get the revert message of the call and revert with it if the call failed
        if (!success) {
            string memory _revertMsg = _getRevertMsg(res);
            revert(_revertMsg);
        }

        return res;
    }

    /// @dev Get the revert message from a call
    /// @notice This is needed in order to get the human-readable revert message from a call
    /// @param _res Response of the call
    /// @return Revert message string
    function _getRevertMsg(bytes memory _res) internal pure returns (string memory) {
        // If the _res length is less than 68, then the transaction failed silently (without a revert message)
        if (_res.length < 68) return 'BA: Transaction reverted silently';
        bytes memory revertData = _res.slice(4, _res.length - 4); // Remove the selector which is the first 4 bytes
        return abi.decode(revertData, (string)); // All that remains is the revert string
    }
}

contract IERC1271 {
    function isValidSignature(
        bytes memory _data,
        bytes memory _signature
    ) public view returns (bytes4 magicValue);
}

/**
 * @title ERC1271Account
 * @author Authereum Labs, Inc.
 * @dev Implements isValidSignature for ERC1271 compatibility
 */
contract ERC1271Account is IERC1271, BaseAccount {

    // NOTE: Valid magic value bytes4(keccak256("isValidSignature(bytes,bytes)")
    bytes4 constant private VALID_SIG = 0x20c13b0b;
    // NOTE: Invalid magic value
    bytes4 constant private INVALID_SIG = 0xffffffff;

    /**
     *  Public functions
     */

    /// @dev Check if a message and signature pair is valid
    /// @notice The _signature parameter can either be one auth key signature or it can
    /// @notice be a login key signature and an auth key signature (signed login key)
    /// @param _data Data that was signed
    /// @param _signature Signature(s) of the data. Either a single signature (login) or two (login and auth)
    /// @return VALID_SIG or INVALID_SIG hex data
    function isValidSignature(
        bytes memory _data,
        bytes memory _signature
    )
        public
        view
        returns (bytes4)
    {
        if (_signature.length == 65) {
            return isValidAuthKeySignature(_data, _signature);
        } else if (_signature.length >= 130) {
            return isValidLoginKeySignature(_data, _signature);
        } else {
            revert("ERC1271: Invalid isValidSignature _signature length");
        }
    }

    /// @dev Check if a message and auth key signature pair is valid
    /// @param _data Data that was signed
    /// @param _signature Signature of the data signed by the authkey
    /// @return VALID_SIG or INVALID_SIG hex data
    function isValidAuthKeySignature(
        bytes memory _data,
        bytes memory _signature
    )
        public
        view
        returns (bytes4)
    {
        require(_signature.length == 65, "ERC1271: Invalid isValidAuthKeySignature _signature length");

        address authKeyAddress = _getEthSignedMessageHash(_data).recover(
            _signature
        );

        bytes4 magicValue = _isValidAuthKey(authKeyAddress) ? VALID_SIG : INVALID_SIG;
        return magicValue;
    }

    /// @dev Check if a message and login key signature pair is valid, as well as a signed login key by an auth key
    /// @param _data Message that was signed
    /// @param _signature Signature of the data. Signed msg data by the login key and signed login key by auth key
    /// @return VALID_SIG or INVALID_SIG hex data
    function isValidLoginKeySignature(
        bytes memory _data,
        bytes memory _signature
    )
        public
        view
        returns (bytes4)
    {
        require(_signature.length >= 130, "ERC1271: Invalid isValidLoginKeySignature _signature length");

        bytes memory msgHashSignature = _signature.slice(0, 65);
        bytes memory loginKeyAttestationSignature = _signature.slice(65, 65);
        uint256 restrictionDataLength = _signature.length.sub(130);
        bytes memory loginKeyRestrictionData = _signature.slice(130, restrictionDataLength);

        address _loginKeyAddress = _getEthSignedMessageHash(_data).recover(
            msgHashSignature
        );

        // NOTE: The OpenZeppelin toEthSignedMessageHash is used here (and not above)
        // NOTE: because the length is hard coded at 32 and we know that this will always
        // NOTE: be true for this line.
        bytes32 loginKeyAttestationMessageHash = keccak256(abi.encode(
            _loginKeyAddress, loginKeyRestrictionData
        )).toEthSignedMessageHash();

        address _authKeyAddress = loginKeyAttestationMessageHash.recover(
            loginKeyAttestationSignature
        );

        bytes4 magicValue = _isValidAuthKey(_authKeyAddress) ? VALID_SIG : INVALID_SIG;
        return magicValue;
    }

    /**
     *  Internal functions
     */

    /// @dev Adds ETH signed message prefix to bytes message and hashes it
    /// @param _data Bytes data before adding the prefix
    /// @return Prefixed and hashed message
    function _getEthSignedMessageHash(bytes memory _data) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", _uint2str(_data.length), _data));
    }

    /// @dev Convert uint to string
    /// @param _num Uint to be converted
    /// @return String equivalent of the uint
    function _uint2str(uint _num) private pure returns (string memory _uintAsString) {
        if (_num == 0) {
            return "0";
        }
        uint i = _num;
        uint j = _num;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (i != 0) {
            bstr[k--] = byte(uint8(48 + i % 10));
            i /= 10;
        }
        return string(bstr);
    }
}

/**
 * @title BaseMetaTxAccount
 * @author Authereum Labs, Inc.
 * @dev Contract that lays the foundations for meta transactions
 * @dev are performed in this contract as well.
 */
contract BaseMetaTxAccount is BaseAccount {

    /**
     * Public functions
     */

    /// @dev Execute multiple meta transactions
    /// @notice This can only be called by self as a part of the atomic meta transaction
    /// @param _transactions Arrays of transaction data ([destination, value, gasLimit, data][...]...)
    /// @return The responses of the calls
    function executeMultipleMetaTransactions(bytes[] memory _transactions) public onlyAuthKeySenderOrSelf returns (bytes[] memory) {
        return _executeMultipleMetaTransactions(_transactions);
    }

    /**
     *  Internal functions
     */

    /// @dev Atomically execute a meta transaction
    /// @param _transactions Arrays of transaction data ([destination, value, gasLimit, data][...]...)
    /// @param _gasPrice Gas price set by the user
    /// @param _gasOverhead Gas overhead of the transaction calculated offchain
    /// @param _feeTokenAddress Address of the token used to pay a fee
    /// @param _feeTokenRate Rate of the token (in tokenGasPrice/ethGasPrice) used to pay a fee
    /// @return The _transactionMessageHash and responses of the calls
    function _atomicExecuteMultipleMetaTransactions(
        bytes[] memory _transactions,
        uint256 _gasPrice,
        uint256 _gasOverhead,
        address _feeTokenAddress,
        uint256 _feeTokenRate
    )
        internal
        returns (bytes32, bytes[] memory)
    {
        // Verify that the relayer gasPrice is acceptable
        require(_gasPrice <= tx.gasprice, "BMTA: Not a large enough tx.gasprice");

        // Hash the parameters
        bytes32 _transactionMessageHash = keccak256(abi.encode(
            address(this),
            msg.sig,
            getChainId(),
            nonce,
            _transactions,
            _gasPrice,
            _gasOverhead,
            _feeTokenAddress,
            _feeTokenRate
        )).toEthSignedMessageHash();

        // Increment nonce by the number of transactions being processed
        // NOTE: The nonce will still increment even if batched transactions fail atomically
        // NOTE: The reason for this is to mimic an EOA as closely as possible
        nonce += _transactions.length;

        bytes memory _encodedTransactions = abi.encodeWithSelector(
            this.executeMultipleMetaTransactions.selector,
            _transactions
        );

        (bool success, bytes memory res) = address(this).call(_encodedTransactions);

        // Check if any of the atomic transactions failed, if not, decode return data
        bytes[] memory _returnValues;
        if (!success) {
            string memory _revertMsg = _getRevertMsg(res);
            emit CallFailed(_revertMsg);
        } else {
            _returnValues = abi.decode(res, (bytes[]));
        }

        return (_transactionMessageHash, _returnValues);
    }

    /// @dev Execute a meta transaction
    /// @param _transactions Arrays of transaction data ([destination, value, gasLimit, data][...]...)
    /// @return The responses of the calls
    function _executeMultipleMetaTransactions(bytes[] memory _transactions) internal returns (bytes[] memory) {
        // Execute transactions individually
        bytes[] memory _returnValues = new bytes[](_transactions.length);
        for(uint i = 0; i < _transactions.length; i++) {
            // Execute the transaction
            _returnValues[i] = _decodeAndExecuteTransaction(_transactions[i]);
        }

        return _returnValues;
    }

    /// @dev Decode and execute a meta transaction
    /// @param _transaction Transaction (destination, value, gasLimit, data)
    /// @return Succcess status and response of the call
    function _decodeAndExecuteTransaction(bytes memory _transaction) internal returns (bytes memory) {
        (address _destination, uint256 _value, uint256 _gasLimit, bytes memory _data) = _decodeTransactionData(_transaction);

        // Execute the transaction
        return _executeTransaction(
            _destination, _value, _gasLimit, _data
        );
    }

    /// @dev Decode transaction data
    /// @param _transaction Transaction (destination, value, gasLimit, data)
    function _decodeTransactionData(bytes memory _transaction) internal pure returns (address, uint256, uint256, bytes memory) {
        return abi.decode(_transaction, (address, uint256, uint256, bytes));
    }

    /// @dev Issue a refund
    /// @param _startGas Starting gas at the beginning of the transaction
    /// @param _gasPrice Gas price to use when sending a refund
    /// @param _gasOverhead Gas overhead of the transaction calculated offchain
    /// @param _feeTokenAddress Address of the token used to pay a fee
    /// @param _feeTokenRate Rate of the token (in tokenGasPrice/ethGasPrice) used to pay a fee
    function _issueRefund(
        uint256 _startGas,
        uint256 _gasPrice,
        uint256 _gasOverhead,
        address _feeTokenAddress,
        uint256 _feeTokenRate
    )
        internal
    {
        uint256 _gasUsed = _startGas.sub(gasleft()).add(_gasOverhead);

        // Pay refund in ETH if _feeTokenAddress is 0. Else, pay in the token
        if (_feeTokenAddress == address(0)) {
            require(_gasUsed.mul(_gasPrice) <= address(this).balance, "BA: Insufficient gas (ETH) for refund");
            // NOTE: The return value is not checked because the relayer should not propagate a transaction that will revert
            // NOTE: and malicious behavior by the relayer here will cost the relayer, as the fee is already calculated
            msg.sender.call.value(_gasUsed.mul(_gasPrice))("");
        } else {
            IERC20 feeToken = IERC20(_feeTokenAddress);
            uint256 totalTokenFee = _gasUsed.mul(_feeTokenRate);
            require(totalTokenFee <= feeToken.balanceOf(address(this)), "BA: Insufficient gas (token) for refund");
            // NOTE: The return value is not checked because the relayer should not propagate a transaction that will revert
            feeToken.transfer(msg.sender, totalTokenFee);
        }
    }
}

/**
 * @title LoginKeyMetaTxAccount
 * @author Authereum Labs, Inc.
 * @dev Contract used by login keys to send transactions. Login key firwall checks
 * @dev are performed in this contract as well.
 */
contract LoginKeyMetaTxAccount is BaseMetaTxAccount {

    /// @dev Execute an loginKey meta transaction
    /// @param _transactions Arrays of transaction data ([destination, value, gasLimit, data][...]...)
    /// @param _gasPrice Gas price set by the user
    /// @param _gasOverhead Gas overhead of the transaction calculated offchain
    /// @param _loginKeyRestrictionsData Contains restrictions to the loginKey's functionality
    /// @param _feeTokenAddress Address of the token used to pay a fee
    /// @param _feeTokenRate Rate of the token (in tokenGasPrice/ethGasPrice) used to pay a fee
    /// @param _transactionMessageHashSignature Signed transaction data
    /// @param _loginKeyAttestationSignature Signed loginKey
    /// @return Response of the call
    function executeMultipleLoginKeyMetaTransactions(
        bytes[] memory _transactions,
        uint256 _gasPrice,
        uint256 _gasOverhead,
        bytes memory _loginKeyRestrictionsData,
        address _feeTokenAddress,
        uint256 _feeTokenRate,
        bytes memory _transactionMessageHashSignature,
        bytes memory _loginKeyAttestationSignature
    )
        public
        returns (bytes[] memory)
    {
        uint256 startGas = gasleft();

        _validateLoginKeyRestrictions(
            _transactions,
            _loginKeyRestrictionsData
        );

        // Hash the parameters
        bytes32 _transactionMessageHash = keccak256(abi.encode(
            address(this),
            msg.sig,
            getChainId(),
            nonce,
            _transactions,
            _gasPrice,
            _gasOverhead,
            _feeTokenAddress,
            _feeTokenRate
        )).toEthSignedMessageHash();

        // Validate the signers
        // NOTE: This must be done prior to the _atomicExecuteMultipleMetaTransactions() call for security purposes
        _validateLoginKeyMetaTransactionSigs(
            _transactionMessageHash, _transactionMessageHashSignature, _loginKeyRestrictionsData, _loginKeyAttestationSignature
        );

        (, bytes[] memory _returnValues) = _atomicExecuteMultipleMetaTransactions(
            _transactions,
            _gasPrice,
            _gasOverhead,
            _feeTokenAddress,
            _feeTokenRate
        );

        // Refund gas costs
        _issueRefund(startGas, _gasPrice, _gasOverhead, _feeTokenAddress, _feeTokenRate);

        return _returnValues;
    }

    /**
     *  Internal functions
     */

    /// @dev validates all loginKey Restrictions
    /// @param _transactions Arrays of transaction data ([destination, value, gasLimit, data][...]...)
    /// @param _loginKeyRestrictionsData Contains restrictions to the loginKey's functionality
    function _validateLoginKeyRestrictions(
        bytes[] memory _transactions,
        bytes memory _loginKeyRestrictionsData
    )
        internal
        view
    {
        // Check that no calls are made to self
        address _destination;
        for(uint i = 0; i < _transactions.length; i++) {
            (_destination,,,) = _decodeTransactionData(_transactions[i]);
            require(_destination != address(this), "LKMTA: Login key is not able to call self");
        }

        // Check _validateLoginKeyRestrictions restrictions
        uint256 loginKeyExpirationTime = abi.decode(_loginKeyRestrictionsData, (uint256));

        // Check that loginKey is not expired
        require(loginKeyExpirationTime > now, "LKMTA: Login key is expired");
    }

    /// @dev Validate signatures from an auth key meta transaction
    /// @param _transactionsMessageHash Ethereum signed message of the transaction
    /// @param _transactionMessgeHashSignature Signed transaction data
    /// @param _loginKeyRestrictionsData Contains restrictions to the loginKey's functionality
    /// @param _loginKeyAttestationSignature Signed loginKey
    /// @return Address of the login key that signed the data
    function _validateLoginKeyMetaTransactionSigs(
        bytes32 _transactionsMessageHash,
        bytes memory _transactionMessgeHashSignature,
        bytes memory _loginKeyRestrictionsData,
        bytes memory _loginKeyAttestationSignature
    )
        internal
        view
    {
        address _transactionMessageSigner = _transactionsMessageHash.recover(
            _transactionMessgeHashSignature
        );

        bytes32 loginKeyAttestationMessageHash = keccak256(abi.encode(
            _transactionMessageSigner,
            _loginKeyRestrictionsData
        )).toEthSignedMessageHash();

        address _authKeyAddress = loginKeyAttestationMessageHash.recover(
            _loginKeyAttestationSignature
        );

        require(_isValidAuthKey(_authKeyAddress), "LKMTA: Auth key is invalid");
    }
}

/**
 * @title AuthKeyMetaTxAccount
 * @author Authereum Labs, Inc.
 * @dev Contract used by auth keys to send transactions.
 */
contract AuthKeyMetaTxAccount is BaseMetaTxAccount {

    /// @dev Execute multiple authKey meta transactions
    /// @param _transactions Arrays of transaction data ([destination, value, gasLimit, data][...]...)
    /// @param _gasPrice Gas price set by the user
    /// @param _gasOverhead Gas overhead of the transaction calculated offchain
    /// @param _feeTokenAddress Address of the token used to pay a fee
    /// @param _feeTokenRate Rate of the token (in tokenGasPrice/ethGasPrice) used to pay a fee
    /// @param _transactionMessageHashSignature Signed transaction data
    function executeMultipleAuthKeyMetaTransactions(
        bytes[] memory _transactions,
        uint256 _gasPrice,
        uint256 _gasOverhead,
        address _feeTokenAddress,
        uint256 _feeTokenRate,
        bytes memory _transactionMessageHashSignature
    )
        public
        returns (bytes[] memory)
    {
        uint256 _startGas = gasleft();

        // Hash the parameters
        bytes32 _transactionMessageHash = keccak256(abi.encode(
            address(this),
            msg.sig,
            getChainId(),
            nonce,
            _transactions,
            _gasPrice,
            _gasOverhead,
            _feeTokenAddress,
            _feeTokenRate
        )).toEthSignedMessageHash();

        // Validate the signer
        // NOTE: This must be done prior to the _atomicExecuteMultipleMetaTransactions() call for security purposes
        _validateAuthKeyMetaTransactionSigs(
            _transactionMessageHash, _transactionMessageHashSignature
        );

        (, bytes[] memory _returnValues) = _atomicExecuteMultipleMetaTransactions(
            _transactions,
            _gasPrice,
            _gasOverhead,
            _feeTokenAddress,
            _feeTokenRate
        );

        if (_shouldRefund(_transactions)) {
          _issueRefund(_startGas, _gasPrice, _gasOverhead, _feeTokenAddress, _feeTokenRate);
        }

        return _returnValues;
    }

    /**
     *  Internal functions
     */

    /// @dev Validate signatures from an auth key meta transaction
    /// @param _transactionMessageHash Ethereum signed message of the transaction
    /// @param _transactionMessageHashSignature Signed transaction data
    /// @return Address of the auth key that signed the data
    function _validateAuthKeyMetaTransactionSigs(
        bytes32 _transactionMessageHash,
        bytes memory _transactionMessageHashSignature
    )
        internal
        view
    {
        address _authKey = _transactionMessageHash.recover(_transactionMessageHashSignature);
        require(_isValidAuthKey(_authKey), "AKMTA: Auth key is invalid");
    }

    /// @dev Check whether a refund should be issued
    /// @notice A refund should not be issued if the account is performing an Authereum-related update
    /// @param _transactions Arrays of transaction data ([destination, value, gasLimit, data][...]...)
    /// @return True if a refund should be issued
    function _shouldRefund(bytes[] memory _transactions) internal view returns (bool) {
        address _destination;
        for(uint i = 0; i < _transactions.length; i++) {
            (_destination,,,) = _decodeTransactionData(_transactions[i]);
            if (_destination != address(this)) return true;
        }

        return false;
    }
}

/**
 * Utility library of inline functions on addresses
 *
 * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
 * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
 * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
 * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
 */
library OpenZeppelinUpgradesAddress {
    /**
     * Returns whether the target address is a contract
     * @dev This function will return false if invoked during the constructor of a contract,
     * as the code is not actually created until after the constructor finishes.
     * @param account address of the account to check
     * @return whether the target address is a contract
     */
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // XXX Currently there is no better way to check if there is a contract in an address
        // than to check the size of the code at that address.
        // See https://ethereum.stackexchange.com/a/14016/36603
        // for more details about how this works.
        // TODO Check this again before the Serenity release, because all addresses will be
        // contracts then.
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

/**
 * @title AccountUpgradeability
 * @author Authereum Labs, Inc.
 * @dev The upgradeability logic for an Authereum account.
 */
contract AccountUpgradeability is BaseAccount {
    /// @dev Storage slot with the address of the current implementation
    /// @notice This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted 
    /// @notice by 1, and is validated in the constructor
    bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     *  Public functions
     */

    /// @dev Upgrades the proxy to the newest implementation of a contract and 
    /// @dev forwards a function call to it
    /// @notice This is useful to initialize the proxied contract
    /// @param _newImplementation Address of the new implementation
    /// @param _data Array of initialize data
    function upgradeToAndCall(
        address _newImplementation, 
        bytes memory _data
    ) 
        public 
        onlySelf
    {
        _setImplementation(_newImplementation);
        (bool success, bytes memory res) = _newImplementation.delegatecall(_data);

        // Get the revert message of the call and revert with it if the call failed
        string memory _revertMsg = _getRevertMsg(res);
        require(success, _revertMsg);
        emit Upgraded(_newImplementation);
    }

    /**
     *  Internal functions
     */

    /// @dev Sets the implementation address of the proxy
    /// @notice This is only meant to be called when upgrading self
    /// @notice The initial setImplementation for a proxy is set during
    /// @notice the proxy's initialization, not with this call
    /// @param _newImplementation Address of the new implementation
    function _setImplementation(address _newImplementation) internal {
        require(OpenZeppelinUpgradesAddress.isContract(_newImplementation), "AU: Cannot set a proxy implementation to a non-contract address");

        bytes32 slot = IMPLEMENTATION_SLOT;

        assembly {
            sstore(slot, _newImplementation)
        }
    }
}

contract IAuthereumAccount is IERC1271, IERC721Receiver, IERC1155TokenReceiver {

    function () external payable;
    function authereumVersion() external view returns(string memory);
    function getChainId() external pure returns (uint256);
    function addAuthKey(address _authKey) external;
    function removeAuthKey(address _authKey) external;
    function isValidAuthKeySignature(bytes calldata _data, bytes calldata _signature) external view returns (bytes4);
    function isValidLoginKeySignature(bytes calldata _data, bytes calldata _signature) external view returns (bytes4);
    function executeMultipleMetaTransactions(bytes[] calldata _transactions) external returns (bytes[] memory);

    function executeMultipleAuthKeyMetaTransactions(
        bytes[] calldata _transactions,
        uint256 _gasPrice,
        uint256 _gasOverhead,
        address _feeTokenAddress,
        uint256 _feeTokenRate,
        bytes calldata _transactionMessageHashSignature
    ) external returns (bytes[] memory);

    function executeMultipleLoginKeyMetaTransactions(
        bytes[] calldata _transactions,
        uint256 _gasPrice,
        uint256 _gasOverhead,
        bytes calldata _loginKeyRestrictionsData,
        address _feeTokenAddress,
        uint256 _feeTokenRate,
        bytes calldata _transactionMessageHashSignature,
        bytes calldata _loginKeyAttestationSignature
    ) external returns (bytes[] memory);
}

/**
 * @title AuthereumAccount
 * @author Authereum Labs, Inc.
 * @dev Top-level contract used when creating an Authereum account.
 * @dev This contract is meant to only hold the version. All other logic is inherited.
 */
contract AuthereumAccount is
    IAuthereumAccount,
    BaseAccount,
    ERC1271Account,
    LoginKeyMetaTxAccount,
    AuthKeyMetaTxAccount,
    AccountUpgradeability
{
    string constant public authereumVersion = "2020060100";
}