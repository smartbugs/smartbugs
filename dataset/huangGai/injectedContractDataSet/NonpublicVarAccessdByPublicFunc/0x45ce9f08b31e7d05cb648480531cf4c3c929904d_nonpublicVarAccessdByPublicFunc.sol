pragma solidity 0.5.7;

// File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol

/**
 * @title Elliptic curve signature operations
 * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
 * TODO Remove this library once solidity supports passing a signature to ecrecover.
 * See https://github.com/ethereum/solidity/issues/864
 */

library ECDSA {
    /**
     * @dev Recover signer address from a message by using their signature
     * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
     * @param signature bytes signature, the signature is generated using web3.eth.sign()
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
     * toEthSignedMessageHash
     * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
     * and hash the result
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}

// File: contracts/AliorDurableMedium.sol

contract AliorDurableMedium {

    // ------------------------------------------------------------------------------------------ //
    // STRUCTS
    // ------------------------------------------------------------------------------------------ //
    
    // Defines a single document
    struct Document {
        string fileName;         // file name of the document
        bytes32 contentHash;     // hash of document's content
        address signer;          // address of the entity who signed the document
        address relayer;         // address of the entity who published the transaction
        uint40 blockNumber;      // number of the block in which the document was added
        uint40 canceled;         // block number in which document was canceled; 0 otherwise
    }

    // ------------------------------------------------------------------------------------------ //
    // MODIFIERS
    // ------------------------------------------------------------------------------------------ //

    // Restricts function use by verifying given signature with nonce
    modifier ifCorrectlySignedWithNonce(
        string memory _methodName,
        bytes memory _methodArguments,
        bytes memory _signature
    ) {
        bytes memory abiEncodedParams = abi.encode(address(this), nonce++, _methodName, _methodArguments);
        verifySignature(abiEncodedParams, _signature);
        _;
    }

    // Restricts function use by verifying given signature without nonce
    modifier ifCorrectlySigned(string memory _methodName, bytes memory _methodArguments, bytes memory _signature) {
        bytes memory abiEncodedParams = abi.encode(address(this), _methodName, _methodArguments);
        verifySignature(abiEncodedParams, _signature);
        _;
    }

    // Helper function used to verify signature for given bytes array
    function verifySignature(bytes memory abiEncodedParams, bytes memory signature) internal view {
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(keccak256(abiEncodedParams));
        address recoveredAddress = ECDSA.recover(ethSignedMessageHash, signature);
        require(recoveredAddress != address(0), "Error during the signature recovery");
        require(recoveredAddress == owner, "Signature mismatch");
    }

    // Restricts function use after contract's retirement
    modifier ifNotRetired() {
        require(upgradedVersion == address(0), "Contract is retired");
        _;
    } 

    // ------------------------------------------------------------------------------------------ //
    // EVENTS
    // ------------------------------------------------------------------------------------------ //

    // An event emitted when the contract gets retired
    event ContractRetired(address indexed upgradedVersion);

    // An event emitted when a new document is published on the contract
    event DocumentAdded(uint indexed documentId);

    // An event emitted when a document is canceled
    event DocumentCanceled(uint indexed documentId);
    
    // An event emitted when contract owner changes
    event OwnershipChanged(address indexed newOwner);

    // ------------------------------------------------------------------------------------------ //
    // FIELDS
    // ------------------------------------------------------------------------------------------ //

    address internal upgradedVersion;                           // if the contract gets retired; address of the new contract
    uint public nonce;                                        // ID of the next action
    uint private documentCount;                               // count of documents published on the contract
    mapping(uint => Document) private documents;              // document storage
    mapping(bytes32 => uint) private contentHashToDocumentId; // mapping that allows retrieving documentId by contentHash
    address internal owner;                                     // owner of the contract
    // (this address is checked in signature verification)

    // ------------------------------------------------------------------------------------------ //
    // CONSTRUCTOR
    // ------------------------------------------------------------------------------------------ //

    constructor(address _owner) public {
        require(_owner != address(0), "Owner cannot be initialised to a null address");
        owner = _owner;    // address given as a constructor parameter becomes the 'owner'
        nonce = 0;         // first nonce is 0
    }

    // ------------------------------------------------------------------------------------------ //
    // VIEW FUNCTIONS
    // ------------------------------------------------------------------------------------------ //

    // Returns the number of documents stored in the contract
    function getDocumentCount() public view
    returns (uint)
    {
        return documentCount;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // Returns all information about a single document
    function getDocument(uint _documentId) public view
    returns (
        uint documentId,             // id of the document
        string memory fileName,      // file name of the document
        bytes32 contentHash,         // hash of document's content
        address signer,              // address of the entity who signed the document
        address relayer,             // address of the entity who published the transaction
        uint40 blockNumber,          // number of the block in which the document was added
        uint40 canceled              // block number in which document was canceled; 0 otherwise
    )
    {
        Document memory doc = documents[_documentId];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return (
            _documentId, 
            doc.fileName, 
            doc.contentHash,
            doc.signer,
            doc.relayer,
            doc.blockNumber,
            doc.canceled
        );
    }

    // Gets the id of the document with given contentHash
    function getDocumentIdWithContentHash(bytes32 _contentHash) public view
    returns (uint) 
    {
        return contentHashToDocumentId[_contentHash];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // ------------------------------------------------------------------------------------------ //
    // STATE-CHANGING FUNCTIONS
    // ------------------------------------------------------------------------------------------ //

    // Changes the contract owner
    function transferOwnership(address _newOwner, bytes memory _signature) public
    ifCorrectlySignedWithNonce("transferOwnership", abi.encode(_newOwner), _signature)
    {
        require(_newOwner != address(0), "Owner cannot be changed to a null address");
        require(_newOwner != owner, "Cannot change owner to be the same address");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        owner = _newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit OwnershipChanged(_newOwner);
    }

    // Adds a new document
    function addDocument(
        string memory _fileName,
        bytes32 _contentHash,
        bytes memory _signature
    ) public
    ifNotRetired
    ifCorrectlySigned(
        "addDocument", 
        abi.encode(
            _fileName,
            _contentHash
        ),
        _signature
    )
    {
        require(contentHashToDocumentId[_contentHash] == 0, "Document with given hash is already published");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint documentId = documentCount + 1;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        contentHashToDocumentId[_contentHash] = documentId;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit DocumentAdded(documentId);
        documents[documentId] = Document(	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            _fileName, 
            _contentHash,
            owner,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            msg.sender,
            uint40(block.number),
            0
        );
        documentCount++;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // Cancels a published document
    function cancelDocument(uint _documentId, bytes memory _signature) public
    ifNotRetired
    ifCorrectlySignedWithNonce("cancelDocument", abi.encode(_documentId), _signature)
    {
        require(_documentId <= documentCount && _documentId > 0, "Cannot cancel a non-existing document");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(documents[_documentId].canceled == 0, "Cannot cancel an already canceled document");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        documents[_documentId].canceled = uint40(block.number);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit DocumentCanceled(_documentId);
    }

    // Retires this contract and saves the address of the new one
    function retire(address _upgradedVersion, bytes memory _signature) public
    ifNotRetired
    ifCorrectlySignedWithNonce("retire", abi.encode(_upgradedVersion), _signature)
    {
        upgradedVersion = _upgradedVersion;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit ContractRetired(upgradedVersion);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
}