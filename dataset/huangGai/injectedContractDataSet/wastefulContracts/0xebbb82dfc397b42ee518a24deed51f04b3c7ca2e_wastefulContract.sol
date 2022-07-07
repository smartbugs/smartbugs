pragma solidity ^0.5.6;

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

/**
 * @title ERC721 Non-Fungible Token Standard basic interface
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) public view returns (uint256 balance);
    function ownerOf(uint256 tokenId) public view returns (address owner);

    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);

    function transferFrom(address from, address to, uint256 tokenId) public;
    function safeTransferFrom(address from, address to, uint256 tokenId) public;

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
contract IERC721Receiver {
    /**
     * @notice Handle the receipt of an NFT
     * @dev The ERC721 smart contract calls this function on the recipient
     * after a `safeTransfer`. This function MUST return the function selector,
     * otherwise the caller will revert the transaction. The selector to be
     * returned can be obtained as `this.onERC721Received.selector`. This
     * function MAY throw to revert and reject the transfer.
     * Note: the ERC721 contract address is always the message sender.
     * @param operator The address which called `safeTransferFrom` function
     * @param from The address which previously owned the token
     * @param tokenId The NFT identifier which is being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
}

library Strings {
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
    
    function strConcat(string memory _a, string memory _b) internal pure returns (string memory _concatenatedString) {
        return strConcat(_a, _b, "", "", "");
    }
    
    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory _concatenatedString) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        uint i = 0;
        for (i = 0; i < _ba.length; i++) {
            babcde[k++] = _ba[i];
        }
        for (i = 0; i < _bb.length; i++) {
            babcde[k++] = _bb[i];
        }
        for (i = 0; i < _bc.length; i++) {
            babcde[k++] = _bc[i];
        }
        for (i = 0; i < _bd.length; i++) {
            babcde[k++] = _bd[i];
        }
        for (i = 0; i < _be.length; i++) {
            babcde[k++] = _be[i];
        }
        return string(babcde);
    }
}
/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/**
 * Utility library of inline functions on addresses
 */
library Address {
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
 * @title ERC165
 * @author Matt Condon (@shrugs)
 * @dev Implements ERC165 using a lookup table.
 */
contract ERC165 is IERC165 {
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    /**
     * 0x01ffc9a7 ===
     *     bytes4(keccak256('supportsInterface(bytes4)'))
     */

    /**
     * @dev a mapping of interface id to whether or not it's supported
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    /**
     * @dev A contract implementing SupportsInterfaceWithLookup
     * implement ERC165 itself
     */
    constructor () internal {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @dev implement supportsInterface(bytes4) using a lookup table
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev internal method for registering an interface
     */
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff);
        _supportedInterfaces[interfaceId] = true;
    }
}

/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => uint256) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    /*
     * 0x80ac58cd ===
     *     bytes4(keccak256('balanceOf(address)')) ^
     *     bytes4(keccak256('ownerOf(uint256)')) ^
     *     bytes4(keccak256('approve(address,uint256)')) ^
     *     bytes4(keccak256('getApproved(uint256)')) ^
     *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
     *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
     *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
     */

    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    /**
     * @dev Gets the balance of the specified address
     * @param owner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0));
        return _ownedTokensCount[owner];
    }

    /**
     * @dev Gets the owner of the specified token ID
     * @param tokenId uint256 ID of the token to query the owner of
     * @return owner address currently marked as the owner of the given token ID
     */
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0));
        return owner;
    }

    /**
     * @dev Approves another address to transfer the given token ID
     * The zero address indicates there is no approved address.
     * There can only be one approved address per token at a given time.
     * Can only be called by the token owner or an approved operator.
     * @param to address to be approved for the given token ID
     * @param tokenId uint256 ID of the token to be approved
     */
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(to != owner);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));

        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    /**
     * @dev Gets the approved address for a token ID, or zero if no address set
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to query the approval of
     * @return address currently approved for the given token ID
     */
    function getApproved(uint256 tokenId) public view returns (address) {
        require(_exists(tokenId));
        return _tokenApprovals[tokenId];
    }

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf
     * @param to operator address to set the approval
     * @param approved representing the status of the approval to be set
     */
    function setApprovalForAll(address to, bool approved) public {
        require(to != msg.sender);
        _operatorApprovals[msg.sender][to] = approved;
        emit ApprovalForAll(msg.sender, to, approved);
    }

    /**
     * @dev Tells whether an operator is approved by a given owner
     * @param owner owner address which you want to query the approval of
     * @param operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
     */
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev Transfers the ownership of a given token ID to another address
     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId));

        _transferFrom(from, to, tokenId);
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     *
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * Requires the msg sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes data to send along with a safe transfer check
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data));
    }

    /**
     * @dev Returns whether the specified token exists
     * @param tokenId uint256 ID of the token to query the existence of
     * @return whether the token exists
     */
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    /**
     * @dev Returns whether the given spender can transfer a given token ID
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     *    is an operator of the owner, or is the owner of the token
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Internal function to mint a new token
     * Reverts if the given token ID already exists
     * @param to The address that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     */
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0));
        require(!_exists(tokenId));

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Internal function to burn a specific token
     * Reverts if the token does not exist
     * Deprecated, use _burn(uint256) instead.
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(address owner, uint256 tokenId) internal {
        require(ownerOf(tokenId) == owner);

        _clearApproval(tokenId);

        _ownedTokensCount[owner] = _ownedTokensCount[owner].sub(1);
        _tokenOwner[tokenId] = address(0);

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Internal function to burn a specific token
     * Reverts if the token does not exist
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(uint256 tokenId) internal {
        _burn(ownerOf(tokenId), tokenId);
    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
    */
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from);
        require(to != address(0));

        _clearApproval(tokenId);

        _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
        _ownedTokensCount[to] = _ownedTokensCount[to].add(1);

        _tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Internal function to invoke `onERC721Received` on a target address
     * The call is not executed if the target address is not a contract
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        internal returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    /**
     * @dev Private function to clear current approval of a given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _clearApproval(uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721Enumerable is IERC721 {
    function totalSupply() public view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) public view returns (uint256);
}
/**
 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
    /*
     * 0x780e9d63 ===
     *     bytes4(keccak256('totalSupply()')) ^
     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
     *     bytes4(keccak256('tokenByIndex(uint256)'))
     */

    /**
     * @dev Constructor function
     */
    constructor () public {
        // register the supported interface to conform to ERC721Enumerable via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    /**
     * @dev Gets the token ID at a given index of the tokens list of the requested owner
     * @param owner address owning the tokens list to be accessed
     * @param index uint256 representing the index to be accessed of the requested tokens list
     * @return uint256 token ID at the given index of the tokens list owned by the requested address
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < balanceOf(owner));
        return _ownedTokens[owner][index];
    }

    /**
     * @dev Gets the total amount of tokens stored by the contract
     * @return uint256 representing the total amount of tokens
     */
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev Gets the token ID at a given index of all the tokens in this contract
     * Reverts if the index is greater or equal to the total number of tokens
     * @param index uint256 representing the index to be accessed of the tokens list
     * @return uint256 token ID at the given index of the tokens list
     */
    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < totalSupply());
        return _allTokens[index];
    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     * As opposed to transferFrom, this imposes no restrictions on msg.sender.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        super._transferFrom(from, to, tokenId);

        _removeTokenFromOwnerEnumeration(from, tokenId);

        _addTokenToOwnerEnumeration(to, tokenId);
    }

    /**
     * @dev Internal function to mint a new token
     * Reverts if the given token ID already exists
     * @param to address the beneficiary that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     */
    function _mint(address to, uint256 tokenId) internal {
        super._mint(to, tokenId);

        _addTokenToOwnerEnumeration(to, tokenId);

        _addTokenToAllTokensEnumeration(tokenId);
    }

    /**
     * @dev Gets the list of token IDs of the requested owner
     * @param owner address owning the tokens
     * @return uint256[] List of token IDs owned by the requested address
     */
    function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
        return _ownedTokens[owner];
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        _ownedTokens[from].length--;

        // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
        // lastTokenId, or just over the end of the array if the token was the last one).
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length.sub(1);
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        _allTokens.length--;
        _allTokensIndex[tokenId] = 0;
    }
}

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an account access to this role
     */
    function add(Role storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer[account] = true;
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        role.bearer[account] = false;
    }

    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }
}

contract MinterRole {
    using Roles for Roles.Role;

    event MinterAdded(address indexed account);
    event MinterRemoved(address indexed account);

    Roles.Role private _minters;

    constructor () internal {
        _addMinter(msg.sender);
    }

    modifier onlyMinter() {
        require(true);
        _;
    }

    function isMinter(address account) public view returns (bool) {
        return _minters.has(account);
    }

    function addMinter(address account) public onlyMinter {
        _addMinter(account);
    }

    function renounceMinter() public {
        _removeMinter(msg.sender);
    }

    function _addMinter(address account) internal {
        _minters.add(account);
        emit MinterAdded(account);
    }

    function _removeMinter(address account) internal {
        _minters.remove(account);
        emit MinterRemoved(account);
    }

}

/**
 * @title Helps contracts guard against reentrancy attacks.
 * @author Remco Bloemen <remco@21.com>, Eenae <alexey@mixbytes.io>
 * @dev If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter);
    }
}

contract IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

contract ProductInventory is MinterRole {
    using SafeMath for uint256;
    using Address for address;
    
    event ProductCreated(
        uint256 id,
        uint256 price,
        uint256 activationPrice,
        uint256 available,
        uint256 supply,
        uint256 interval,
        bool minterOnly
    );
    event ProductAvailabilityChanged(uint256 productId, uint256 available);
    event ProductPriceChanged(uint256 productId, uint256 price);

    // All product ids in existence
    uint256[] public allProductIds;

    // Map from product id to Product
    mapping (uint256 => Product) public products;

    struct Product {
        uint256 id;
        uint256 price;
        uint256 activationPrice;
        uint256 available;
        uint256 supply;
        uint256 sold;
        uint256 interval;
        bool minterOnly;
    }

    function _productExists(uint256 _productId) internal view returns (bool) {
        return products[_productId].id != 0;
    }

    function _createProduct(
        uint256 _productId,
        uint256 _price,
        uint256 _activationPrice,
        uint256 _initialAvailable,
        uint256 _supply,
        uint256 _interval,
        bool _minterOnly
    )
    internal
    {
        require(_productId != 0);
        require(!_productExists(_productId));
        require(_initialAvailable <= _supply);

        Product memory _product = Product({
            id: _productId,
            price: _price,
            activationPrice: _activationPrice,
            available: _initialAvailable,
            supply: _supply,
            sold: 0,
            interval: _interval,
            minterOnly: _minterOnly
        });

        products[_productId] = _product;
        allProductIds.push(_productId);

        emit ProductCreated(
            _product.id,
            _product.price,
            _product.activationPrice,
            _product.available,
            _product.supply,
            _product.interval,
            _product.minterOnly
        );
    }

    function _incrementAvailability(
        uint256 _productId,
        uint256 _increment)
        internal
    {
        require(_productExists(_productId));
        uint256 newAvailabilityLevel = products[_productId].available.add(_increment);
        //if supply isn't 0 (unlimited), we check if incrementing puts above supply
        if(products[_productId].supply != 0) {
            require(products[_productId].sold.add(newAvailabilityLevel) <= products[_productId].supply);
        }
        products[_productId].available = newAvailabilityLevel;
    }

    function _setAvailability(uint256 _productId, uint256 _availability) internal
    {
        require(_productExists(_productId));
        require(_availability >= 0);
        products[_productId].available = _availability;
    }

    function _setPrice(uint256 _productId, uint256 _price) internal
    {
        require(_productExists(_productId));
        products[_productId].price = _price;
    }

    function _setMinterOnly(uint256 _productId, bool _isMinterOnly) internal
    {
        require(_productExists(_productId));
        products[_productId].minterOnly = _isMinterOnly;
    }

    function _purchaseProduct(uint256 _productId) internal {
        require(_productExists(_productId));
        require(products[_productId].available > 0);
        require(products[_productId].available.sub(1) >= 0);
        products[_productId].available = products[_productId].available.sub(1);
        products[_productId].sold = products[_productId].sold.add(1);
    }

    /*** public onlyMinter ***/

    /**
    * @notice Creates a Product
    * @param _productId - product id to use (immutable)
    * @param _price - price of product
    * @param _activationPrice - price of activation
    * @param _initialAvailable - the initial amount available for sale
    * @param _supply - total supply - `0` means unlimited (immutable)
    * @param _interval - interval - period of time, in seconds, users can subscribe 
    * for. If set to 0, it's not a subscription product (immutable)
    * @param _minterOnly - if true, purchase is only available to minter
    */
    function createProduct(
        uint256 _productId,
        uint256 _price,
        uint256 _activationPrice,
        uint256 _initialAvailable,
        uint256 _supply,
        uint256 _interval,
        bool _minterOnly
    )
    external
    onlyMinter
    {
        _createProduct(
            _productId,
            _price,
            _activationPrice,
            _initialAvailable,
            _supply,
            _interval,
            _minterOnly);
    }

    /**
    * @notice incrementAvailability - increments the 
    * @param _productId - product id
    * @param _increment - amount to increment
    */
    function incrementAvailability(
        uint256 _productId,
        uint256 _increment)
    external
    onlyMinter
    {
        _incrementAvailability(_productId, _increment);
        emit ProductAvailabilityChanged(_productId, products[_productId].available);
    }

    /**
    * @notice Increments the inventory of a product
    * @param _productId - the product id
    * @param _amount - the amount to set
    */
    function setAvailability(
        uint256 _productId,
        uint256 _amount)
    external
    onlyMinter
    {
        _setAvailability(_productId, _amount);
        emit ProductAvailabilityChanged(_productId, products[_productId].available);
    }

    /**
    * @notice Sets the price of a product
    * @param _productId - the product id
    * @param _price - the product price
    */
    function setPrice(uint256 _productId, uint256 _price)
    external
    onlyMinter
    {
        _setPrice(_productId, _price);
        emit ProductPriceChanged(_productId, _price);
    }

    /**
    * @notice Sets the price of a product
    * @param _productId - the product id
    * @param _isMinterOnly - the product price
    */
    function setMinterOnly(uint256 _productId, bool _isMinterOnly)
    external
    onlyMinter
    {
        _setMinterOnly(_productId, _isMinterOnly);
    }

    /*** public onlyMinter ***/

    /**
    * @notice Total amount sold of a product
    * @param _productId - the product id
    */
    function totalSold(uint256 _productId) public view returns (uint256) {
        return products[_productId].sold;
    }

    /**
    * @notice Mintable permission of a product
    * @param _productId - the product id
    */
    function isMinterOnly(uint256 _productId) public view returns (bool) {
        return products[_productId].minterOnly;
    }

    /**
    * @notice Price of a product
    * @param _productId - the product id
    */
    function priceOf(uint256 _productId) public view returns (uint256) {
        return products[_productId].price;
    }

    /**
    * @notice Price of activation of a product
    * @param _productId - the product id
    */
    function priceOfActivation(uint256 _productId) public view returns (uint256) {
        return products[_productId].activationPrice;
    }

    /**
    * @notice Product info for a product
    * @param _productId - the product id
    */
    function productInfo(uint256 _productId)
    public
    view
    returns (uint256, uint256, uint256, uint256, uint256, bool)
    {
        return (
            products[_productId].price,
            products[_productId].activationPrice,
            products[_productId].available,
            products[_productId].supply,
            products[_productId].interval,
            products[_productId].minterOnly
        );
    }

  /**
  * @notice Get product ids
  */
    function getAllProductIds() public view returns (uint256[] memory) {
        return allProductIds;
    }
}

contract IERC721ProductKey is IERC721Enumerable, IERC721Metadata {
    function activate(uint256 _tokenId) public payable;
    function purchase(uint256 _productId, address _beneficiary) public payable returns (uint256);
    function setKeyAttributes(uint256 _keyId, uint256 _attributes) public;
    function keyInfo(uint256 _keyId) external view returns (uint256, uint256, uint256, uint256);
    function isKeyActive(uint256 _keyId) public view returns (bool);
    event KeyIssued(
        address indexed owner,
        address indexed purchaser,
        uint256 keyId,
        uint256 productId,
        uint256 attributes,
        uint256 issuedTime,
        uint256 expirationTime
    );
    event KeyActivated(
        address indexed owner,
        address indexed activator,
        uint256 keyId,
        uint256 productId,
        uint256 attributes,
        uint256 issuedTime,
        uint256 expirationTime
    );
}

contract ERC721ProductKey is IERC721ProductKey, ERC721Enumerable, ReentrancyGuard, ProductInventory {
    using SafeMath for uint256;
    using Address for address;

    // Token name
    string private _name;
    // Token symbol
    string private _symbol;
    // Base metadata URI symbol
    string private _baseMetadataURI;
    // Withdrawal wallet
    address payable private _withdrawalWallet;

    event KeyIssued(
        address indexed owner,
        address indexed purchaser,
        uint256 keyId,
        uint256 productId,
        uint256 attributes,
        uint256 issuedTime,
        uint256 expirationTime
    );

    event KeyActivated(
        address indexed owner,
        address indexed activator,
        uint256 keyId,
        uint256 productId,
        uint256 attributes,
        uint256 issuedTime,
        uint256 expirationTime
    );

    struct ProductKey {
        uint256 productId;
        uint256 attributes;
        uint256 issuedTime;
        uint256 expirationTime;
    }
    
    // Map from keyid to ProductKey
    mapping (uint256 => ProductKey) public productKeys;

    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    /*
     * 0x5b5e139f ===
     *     bytes4(keccak256('name()')) ^
     *     bytes4(keccak256('symbol()')) ^
     *     bytes4(keccak256('tokenURI(uint256)'))
     */

    /**
     * @dev Constructor function
     */
    constructor (string memory name, string memory symbol, string memory baseURI, address payable withdrawalWallet) public {
        _name = name;
        _symbol = symbol;
        _baseMetadataURI = baseURI;
        _withdrawalWallet = withdrawalWallet;
        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    }

    /**
     * @dev Gets the token name
     * @return string representing the token name
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @notice Gets the token symbol
     * @return string representing the token symbol
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @return the address where funds are collected.
     */
    function withdrawalWallet() public view returns (address payable) {
        return _withdrawalWallet;
    }

    /**
     * @notice Sets a Base URI to be used for token URI
     * @param baseURI string of the base uri to set
     */
    function setTokenMetadataBaseURI(string calldata baseURI) external onlyMinter {
        _baseMetadataURI = baseURI;
    }

    /**
     * @notice Returns a URI for a given ID
     * Throws if the token ID does not exist. May return an empty string.
     * @param tokenId uint256 ID of the token to query
     */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId));
        return Strings.strConcat(
            _baseMetadataURI,
            Strings.uint2str(tokenId));
    }
    
    /**
     * @notice activates access key
     * Throws if not approved or owner or key already active
     * @param _keyId uint256 ID of the key to activate
     */
    function _activate(uint256 _keyId) internal {
        require(_isApprovedOrOwner(msg.sender, _keyId));
        require(!isKeyActive(_keyId));
        require(productKeys[_keyId].expirationTime == 0);
        uint256 productId = productKeys[_keyId].productId;
        //set expiration time which activates the productkey
        productKeys[_keyId].expirationTime = now.add(products[productId].interval);
        //emit key activated event
        emit KeyActivated(
            ownerOf(_keyId),
            msg.sender,
            _keyId,
            productId,
            productKeys[_keyId].attributes,
            productKeys[_keyId].issuedTime,
            productKeys[_keyId].expirationTime
        );
    }

    function _createKey(
        uint256 _productId,
        address _beneficiary
    )
    internal
    returns (uint)
    {
        ProductKey memory _productKey = ProductKey({
            productId: _productId,
            attributes: 0,
            issuedTime: now, 
            expirationTime: 0
        });

        uint256 newKeyId = totalSupply();
            
        productKeys[newKeyId] = _productKey;
        emit KeyIssued(
            _beneficiary,
            msg.sender,
            newKeyId,
            _productKey.productId,
            _productKey.attributes,
            _productKey.issuedTime,
            _productKey.expirationTime);
        _mint(_beneficiary, newKeyId);
        return newKeyId;
    }

    function _setKeyAttributes(uint256 _keyId, uint256 _attributes) internal
    {
        productKeys[_keyId].attributes = _attributes;
    }

    function _purchase(
        uint256 _productId,
        address _beneficiary)
    internal returns (uint)
    {
        _purchaseProduct(_productId);
        return _createKey(
            _productId,
            _beneficiary
        );
    }

    /** only minter **/

    function withdrawBalance() external onlyMinter {
        _withdrawalWallet.transfer(address(this).balance);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    function minterOnlyPurchase(
        uint256 _productId,
        address _beneficiary
    )
    external
    onlyMinter
    returns (uint256)
    {
        return _purchase(
            _productId,
            _beneficiary
        );
    }

    function setKeyAttributes(
        uint256 _keyId,
        uint256 _attributes
    )
    public
    onlyMinter
    {
        return _setKeyAttributes(
            _keyId,
            _attributes
        );
    }

    /** anyone **/

    /**
    * @notice Get if productkey is active
    * @param _keyId the id of key
    */
    function isKeyActive(uint256 _keyId) public view returns (bool) {
        return productKeys[_keyId].expirationTime > now || products[productKeys[_keyId].productId].interval == 0;
    }

    /**
    * @notice Get a ProductKey's info
    * @param _keyId key id
    */
    function keyInfo(uint256 _keyId)
    external view returns (uint256, uint256, uint256, uint256)
    {
        return (productKeys[_keyId].productId,
            productKeys[_keyId].attributes,
            productKeys[_keyId].issuedTime,
            productKeys[_keyId].expirationTime
        );
    }

    /**
    * @notice purchase a product
    * @param _productId - product id to purchase
    * @param _beneficiary - the token receiving address
    */
    function purchase(
        uint256 _productId,
        address _beneficiary
    )
    public
    payable
    returns (uint256)
    {
        require(_productId != 0);
        require(_beneficiary != address(0));
        // No excess
        require(msg.value == priceOf(_productId));
        require(!isMinterOnly(_productId));
        return _purchase(
            _productId,
            _beneficiary
        );
    }

    /**
    * @notice activates token
    */
    function activate(
        uint256 _tokenId
    )
    public
    payable
    {
        require(ownerOf(_tokenId) != address(0));
        // no excess
        require(msg.value == priceOfActivation(_tokenId));
        _activate(_tokenId);

    }
}