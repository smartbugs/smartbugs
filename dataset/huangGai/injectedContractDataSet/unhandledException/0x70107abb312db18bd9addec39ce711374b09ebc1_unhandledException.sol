/**
 *Submitted for verification at Etherscan.io on 2020-04-16
*/

pragma solidity 0.6.2;
pragma experimental ABIEncoderV2;


/**
 * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
 * `CREATE2` can be used to compute in advance the address where a smart
 * contract will be deployed, which allows for interesting new mechanisms known
 * as 'counterfactual interactions'.
 *
 * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
 * information.
 *
 * _Available since v2.5.0._
 */
library Create2 {
    /**
     * @dev Deploys a contract using `CREATE2`. The address where the contract
     * will be deployed can be known in advance via {computeAddress}. Note that
     * a contract cannot be deployed twice using the same salt.
     */
    function deploy(bytes32 salt, bytes memory bytecode) internal returns (address) {
        address addr;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)
        }
        require(addr != address(0), "Create2: Failed on deploy");
        return addr;
    }

    /**
     * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the `bytecode`
     * or `salt` will result in a new destination address.
     */
    function computeAddress(bytes32 salt, bytes memory bytecode) internal view returns (address) {
        return computeAddress(salt, bytecode, address(this));
    }

    /**
     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
     */
    function computeAddress(bytes32 salt, bytes memory bytecode, address deployer) internal pure returns (address) {
        return computeAddress(salt, keccak256(bytecode), deployer);
    }

    /**
     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
     */
    function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address) {
        bytes32 _data = keccak256(
            abi.encodePacked(bytes1(0xff), deployer, salt, bytecodeHash)
        );
        return address(bytes20(_data << 96));
    }
}


/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
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
 * A nonce store stores nonces
 */
interface IReplayProtectionAuthority {
    /**
     * Update a nonce in the store.
     * It should update nonce for msg.sender.
     * Must return TRUE or revert/false.
     */
    function update(bytes calldata nonce) external returns (bool);

    /**
     * Update a nonce in the store.
     * It should update nonce for H(msg.sender || target).
     * Must return TRUE or revert/false.
     */
    function updateFor(address target, bytes calldata nonce) external returns (bool);

}


contract ReplayProtection {
    mapping(bytes32 => uint256) public nonceStore;

    /**
     * Get Ethereum Chain ID
     * */
    function getChainID() public pure returns(uint) {
        // Fetch chainId
        uint256 chainId;
        assembly {chainId := chainid() }
    }

    /**
     * Checks the signer's replay protection and returns the signer's address.
     * Reverts if fails.
     *
     * Why is there no signing authority? An attacker can supply an address that returns a fixed signer
     * so we need to restrict it to a "pre-approved" list of authorities (DAO).

     * @param _callData Function name and data to be called
     * @param _replayProtectionAuthority What replay protection will we check?
     * @param _replayProtection Encoded replay protection
     * @param _signature Signer's signature
     */
    function verify(bytes memory _callData,
        bytes memory _replayProtection,
        address _replayProtectionAuthority,
        bytes memory _signature) internal returns(address){

        // Extract signer's address.
        address signer = verifySig(_callData, _replayProtection, _replayProtectionAuthority, getChainID(), _signature);

        // Check the user's replay protection.
        if(_replayProtectionAuthority == address(0x0000000000000000000000000000000000000000)) {
            // Assumes authority returns true or false. It may also revert.
            require(nonce(signer, _replayProtection), "Multinonce replay protection failed");
        } else if (_replayProtectionAuthority == address(0x0000000000000000000000000000000000000001)) {
            require(bitflip(signer, _replayProtection), "Bitflip replay protection failed");
        } else {
            require(IReplayProtectionAuthority(_replayProtectionAuthority).updateFor(signer, _replayProtection), "Replay protection from authority failed");
        }

        return signer;
    }

    /**
     * Verify signature on the calldata and replay protection.
     * @param _callData Contains target contract, value and function data.
     * @param _replayProtection Contains the replay protection nonces.
     * @param _replayProtectionAuthority Address to an external (or internal) relay protection mechanism.
     */
    function verifySig(bytes memory _callData,
        bytes memory _replayProtection,
        address _replayProtectionAuthority, uint chainId, bytes memory _signature) public view returns (address) {
        bytes memory encodedData = abi.encode(_callData, _replayProtection, _replayProtectionAuthority, address(this), chainId);
        return ECDSA.recover(ECDSA.toEthSignedMessageHash(keccak256(encodedData)), _signature);
    }

    /**
     * MultiNonce replay protection.
     * Explained: https://github.com/PISAresearch/metamask-comp#multinonce
     * Allows a user to send N queues of transactions, but transactions in each queue are accepted in order.
     * If nonce1==0, then it is the same as replace-by-version (e.g. increment nonce each time).
     * @param _replayProtection Contains a single nonce
     */
    function nonce(address _signer, bytes memory _replayProtection) internal returns(bool) {
        uint256 nonce1;
        uint256 nonce2;

        (nonce1, nonce2) = abi.decode(_replayProtection, (uint256, uint256));
        bytes32 index = keccak256(abi.encode(_signer, nonce1));
        uint256 storedNonce = nonceStore[index];

        // Increment stored nonce by one...
        if(nonce2 == storedNonce) {
            nonceStore[index] = storedNonce + 1;
            return true;
        }

        return false;
    }

    /**
     * Bitflip Replay Protection
     * Explained: https://github.com/PISAresearch/metamask-comp#bitflip
     * Allows a user to flip a bit in nonce2 as replay protection. Every nonce supports 256 bit flips.
     */
    function bitflip(address _signer, bytes memory _replayProtection) internal returns(bool) {
        (uint256 nonce1, uint256 bitsToFlip) = abi.decode(_replayProtection, (uint256, uint256));

        // It is unlikely that anyone will need to send 6174 concurrent transactions per block,
        // plus 6174 is a cool af number.
        require(nonce1 >= 6174, "Nonce1 must be at least 6174 to separate multinonce and bitflip");

        // Combine with msg.sender to get unique indexes per caller
        bytes32 senderIndex = keccak256(abi.encodePacked(_signer, nonce1));
        uint256 currentBitmap = nonceStore[senderIndex];
        require(currentBitmap & bitsToFlip != bitsToFlip, "Bit already flipped.");
        nonceStore[senderIndex] = currentBitmap | bitsToFlip;
    }
}



/**
 * A minimal relay hub contract.
 * Verifies the signer's signature and replay protection before forwarding calldata to the target.
 * Delegates nonce verification to another contract.
 */
contract RelayHub is ReplayProtection {

     event Deployed(address signer, address addr);

     /**
     * Each signer has a contract account (signers address => contract address).
     * We check the signer has authorised the target contract and function call. Then, we pass it to the
     * signer's contract account to perform the final execution (to help us bypass msg.sender problem).
     * @param _target Target contract
     * @param _value Quantity of eth in account contract to send to target
     * @param _callData Function name plus arguments
     * @param _replayProtection Replay protection (e.g. multinonce)
     * @param _replayProtectionAuthority Identify the Replay protection, default is address(0)
     * @param _signer Signer's address
     * @param _signature Signature from signer
     */
    function forward(
        address _target,
        uint _value, // only used for accounts
        bytes memory _callData,
        bytes memory _replayProtection,
        address _replayProtectionAuthority,
        address _signer,
        bytes memory _signature) public {

        bytes memory encodedCallData = abi.encode(_target, _value, _callData);

        // // Reverts if fails.
        require(_signer == verify(encodedCallData, _replayProtection, _replayProtectionAuthority, _signature),
        "Signer did not sign this meta-transaction.");

        // Check if the user wants to send command from their contract account or signer address
        (bool success,) = (false, bytes(msg.data));
	 _target.call(abi.encodePacked(_callData, _signer));	//inject UNHANDLED EXCEPTION

        require(success, "Forwarding call failed.");
    }


    /**
     * User deploys a contract in a deterministic manner.
     * It re-uses the replay protection to authorise deployment as part of the salt.
     * @param _initCode Initialisation code for contract
     * @param _replayProtectionAuthority Identify the Replay protection, default is address(0)
     * @param _signature Signature from signer
     */
    function deployContract(
        bytes memory _initCode,
        bytes memory _replayProtection,
        address _replayProtectionAuthority,
        address _signer,
        bytes memory _signature) public {

        // Confirm the user wants to deploy the smart contract
        require(_signer == verify(_initCode, _replayProtection, _replayProtectionAuthority, _signature),
        "Signer must aurhotise deploying contract");

        // We can just abuse the replay protection as the salt :)
        address deployed = Create2.deploy(keccak256(abi.encode(_signer, _replayProtection)), _initCode);

        emit Deployed(_signer, deployed);
    }


}