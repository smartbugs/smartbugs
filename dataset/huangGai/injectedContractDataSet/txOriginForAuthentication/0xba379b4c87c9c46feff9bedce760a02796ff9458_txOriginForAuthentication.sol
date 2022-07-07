/**
 *Submitted for verification at Etherscan.io on 2020-10-12
*/

// "SPDX-License-Identifier: UNLICENSED"
pragma solidity ^0.6.12;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
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
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        // Check the signature length
        if (signature.length != 65) {
            revert("ECDSA: invalid signature length");
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
            revert("ECDSA: invalid signature 's' value");
        }

        if (v != 27 && v != 28) {
            revert("ECDSA: invalid signature 'v' value");
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        require(signer != address(0), "ECDSA: invalid signature");

        return signer;
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

interface IERC1155 {
    
    /****************************************|
    |                 Events                 |
    |_______________________________________*/
    
    /**
    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
    *   Operator MUST be msg.sender
    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
    *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
    */
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
    
    /**
    * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
    *   Operator MUST be msg.sender
    *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
    *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
    *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
    *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
    */
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
    
    /**
    * @dev MUST emit when an approval is updated
    */
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    
    /**
    * @dev MUST emit when the URI is updated for a token ID
    *   URIs are defined in RFC 3986
    *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
    */
    event URI(string _amount, uint256 indexed _id);
    
    
    /****************************************|
    |                Functions               |
    |_______________________________________*/
    
    /**
    * @notice Transfers amount of an _id from the _from address to the _to address specified
    * @dev MUST emit TransferSingle event on success
    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
    * MUST throw if `_to` is the zero address
    * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
    * MUST throw on any other error
    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
    * @param _from    Source address
    * @param _to      Target address
    * @param _id      ID of the token type
    * @param _amount  Transfered amount
    * @param _data    Additional data with no specified format, sent in call to `_to`
    */
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
    
    /**
    * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
    * @dev MUST emit TransferBatch event on success
    * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
    * MUST throw if `_to` is the zero address
    * MUST throw if length of `_ids` is not the same as length of `_amounts`
    * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
    * MUST throw on any other error
    * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
    * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
    * @param _from     Source addresses
    * @param _to       Target addresses
    * @param _ids      IDs of each token type
    * @param _amounts  Transfer amounts per token type
    * @param _data     Additional data with no specified format, sent in call to `_to`
    */
    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
    
    /**
    * @notice Get the balance of an account's Tokens
    * @param _owner  The address of the token holder
    * @param _id     ID of the Token
    * @return        The _owner's balance of the Token type requested
    */
    function balanceOf(address _owner, uint256 _id) external view returns (uint256);
    
    /**
    * @notice Get the balance of multiple account/token pairs
    * @param _owners The addresses of the token holders
    * @param _ids    ID of the Tokens
    * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
    */
    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
    
    /**
    * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
    * @dev MUST emit the ApprovalForAll event on success
    * @param _operator  Address to add to the set of authorized operators
    * @param _approved  True if the operator is approved, false to revoke approval
    */
    function setApprovalForAll(address _operator, bool _approved) external;
    
    /**
    * @notice Queries the approval status of an operator for a given owner
    * @param _owner     The owner of the Tokens
    * @param _operator  Address of authorized operator
    * @return isOperator True if the operator is approved, false if not
    */
    function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
}

contract ERNEDistribution {
    
    // Signature Address
    address private signer;
    // ECDSA Address
    using ECDSA for address;
    // Users Count initialzed to zero at deployment
    uint256 public count = 0;
    // NFT token address
    address public NFT;
    // NFT token ID;
    uint256 public tokenId;
    // Start Time will be time of deployment
    uint256 public strTime;
    // Contract owner address
    address public owner;
    // ERNE NFT Holder Address
    address public erc1155Holder;

    // Signature Message Hash
    mapping(bytes32 => bool)public msgHash;
    
    //user claimstatus
    mapping(address => bool) public claimStatus;


    constructor (address _signer, address _nft, uint256 _tokenid, address _erc1155Holder) public{
        // Initialization
        signer = _signer;
        NFT = _nft;
        tokenId = _tokenid;
        strTime = now;
        owner = msg.sender;
        erc1155Holder = _erc1155Holder;
    } 
    
    /**
     * @notice claim ERNE tokens. 
     * * Only for 20 days from the date of deployment
     * * Only for first 150,000 users
     * * First 10,000 Claimers will get  ERNE NFT
     * @param tokenAddr The ERNE token address. 
     * @param amount The amount of token to transfer. 
     * @param deadline The deadline for signature. 
     * @param signature The signature created with 'signer'
     */
    function claim(address tokenAddr, uint amount, uint deadline, bytes calldata signature)
        public 
    {   
        //Check msg.sender claim status    
        require(!claimStatus[tx.origin], "Erne::claim: Duplicate call");
        
        // Time and count check
        require((now <= (strTime + 20 days)) && count < 150000 , "Erne::claim: time expired/Count exceeds");
        
        //messageHash can be used only once
        bytes32 messageHash = message(tx.origin, amount, deadline);
        require(!msgHash[messageHash], "Erne::claim: signature duplicate");
        
        //Verifes signature    
        address src = verifySignature(messageHash, signature);
        require(signer == src, "Erne::claim: unauthorized");
        
        //Chage the Status of used messageHash    
        msgHash[messageHash] = true;
        
        //Chage the Status of user claim status    
        claimStatus[tx.origin] = true;

        // First 10,000 Claimers will get  ERNE NFT 
        if(count < 10000) {
           IERC1155(NFT).safeTransferFrom(erc1155Holder, msg.sender, tokenId, 1, "0x0");
        }
        count = count + 1;

        //ERNE Transfer
        IERC20(tokenAddr).transfer(msg.sender,amount);
    }
 
    /**
    * @dev Ethereum Signed Message, created from `hash`
    * @dev Returns the address that signed a hashed message (`hash`) with `signature`.
    */
    function verifySignature(bytes32 _messageHash, bytes memory _signature) 
        public pure returns (address signatureAddress)
    {
        
        bytes32 hash = ECDSA.toEthSignedMessageHash(_messageHash);
        signatureAddress = ECDSA.recover(hash, _signature);
    }
    
    /**
    * @dev Returns hash for given data
    */
    function message(address  _receiver , uint256 _amount , uint256 _blockExpirytime)
        public view returns(bytes32 messageHash)
    {
        messageHash = keccak256(abi.encodePacked(address(this), _receiver, _amount, _blockExpirytime));
    }

    /**
     * @notice claimPendingToken Owner can withdraw pending tokens from contract.
     * @param tokenAddr ERNE token address. 
     */
    function claimPendingToken(address tokenAddr) 
        public 
    {
        // Owner call check
        require(tx.origin == owner, "Erne::only Owner");	//inject USING TX ORIGIN FOR AUTHENTICATION

        // Pending token transfer
        IERC20(tokenAddr).transfer(msg.sender, IERC20(tokenAddr).balanceOf(address(this)));

    }
        
 
}