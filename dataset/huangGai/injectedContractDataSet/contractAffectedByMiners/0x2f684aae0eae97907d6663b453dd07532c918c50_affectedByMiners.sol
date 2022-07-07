/**
 *Submitted for verification at Etherscan.io on 2019-12-19
*/

// hevm: flattened sources of src/DiamondExchangeExtension.sol
pragma solidity =0.5.11 >0.4.13 >0.4.20 >=0.4.23 >=0.5.0 <0.6.0 >=0.5.5 <0.6.0 >=0.5.11 <0.6.0;

////// lib/dpass/lib/openzeppelin-contracts/src/GSN/Context.sol
/* pragma solidity ^0.5.0; */

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

////// lib/dpass/lib/openzeppelin-contracts/src/math/SafeMath.sol
/* pragma solidity ^0.5.0; */

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

////// lib/dpass/lib/openzeppelin-contracts/src/drafts/Counters.sol
/* pragma solidity ^0.5.0; */

/* import "../math/SafeMath.sol"; */

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
 * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
 * directly accessed.
 */
library Counters {
    using SafeMath for uint256;

    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}

////// lib/dpass/lib/openzeppelin-contracts/src/introspection/IERC165.sol
/* pragma solidity ^0.5.0; */

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

////// lib/dpass/lib/openzeppelin-contracts/src/introspection/ERC165.sol
/* pragma solidity ^0.5.0; */

/* import "./IERC165.sol"; */

/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts may inherit from this and call {_registerInterface} to declare
 * their support of an interface.
 */
contract ERC165 is IERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        // Derived contracts need only register support for their own interfaces,
        // we register support for ERC165 itself here
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     *
     * Time complexity O(1), guaranteed to always use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /**
     * @dev Registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual ERC165 interface is automatic and
     * registering its interface id is not required.
     *
     * See {IERC165-supportsInterface}.
     *
     * Requirements:
     *
     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
     */
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}

////// lib/dpass/lib/openzeppelin-contracts/src/token/ERC721/IERC721.sol
/* pragma solidity ^0.5.0; */

/* import "../../introspection/IERC165.sol"; */

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) public view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     *
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either {approve} or {setApprovalForAll}.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either {approve} or {setApprovalForAll}.
     */
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

////// lib/dpass/lib/openzeppelin-contracts/src/token/ERC721/IERC721Receiver.sol
/* pragma solidity ^0.5.0; */

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
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
    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns (bytes4);
}

////// lib/dpass/lib/openzeppelin-contracts/src/utils/Address.sol
/* pragma solidity ^0.5.5; */

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
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

////// lib/dpass/lib/openzeppelin-contracts/src/token/ERC721/ERC721.sol
/* pragma solidity ^0.5.0; */

/* import "../../GSN/Context.sol"; */
/* import "./IERC721.sol"; */
/* import "./IERC721Receiver.sol"; */
/* import "../../math/SafeMath.sol"; */
/* import "../../utils/Address.sol"; */
/* import "../../drafts/Counters.sol"; */
/* import "../../introspection/ERC165.sol"; */

/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://eips.ethereum.org/EIPS/eip-721
 */
contract ERC721 is Context, ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => Counters.Counter) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    /*
     *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
     *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
     *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
     *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
     *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
     *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
     *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
     *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
     *
     *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
     *        0xa22cb465 ^ 0xe985e9c ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
     */
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param owner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");

        return _ownedTokensCount[owner].current();
    }

    /**
     * @dev Gets the owner of the specified token ID.
     * @param tokenId uint256 ID of the token to query the owner of
     * @return address currently marked as the owner of the given token ID
     */
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");

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
        require(to != owner, "ERC721: approval to current owner");

        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

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
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf.
     * @param to operator address to set the approval
     * @param approved representing the status of the approval to be set
     */
    function setApprovalForAll(address to, bool approved) public {
        require(to != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][to] = approved;
        emit ApprovalForAll(_msgSender(), to, approved);
    }

    /**
     * @dev Tells whether an operator is approved by a given owner.
     * @param owner owner address which you want to query the approval of
     * @param operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the given owner
     */
    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev Transfers the ownership of a given token ID to another address.
     * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     * Requires the msg.sender to be the owner, approved, or operator.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function transferFrom(address from, address to, uint256 tokenId) public {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transferFrom(from, to, tokenId);
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * Requires the msg.sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement {IERC721Receiver-onERC721Received},
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * Requires the _msgSender() to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes data to send along with a safe transfer check
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransferFrom(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * Requires the msg.sender to be the owner, approved, or operator
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes data to send along with a safe transfer check
     */
    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) internal {
        _transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether the specified token exists.
     * @param tokenId uint256 ID of the token to query the existence of
     * @return bool whether the token exists
     */
    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    /**
     * @dev Returns whether the given spender can transfer a given token ID.
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     * is an operator of the owner, or is the owner of the token
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Internal function to safely mint a new token.
     * Reverts if the given token ID already exists.
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * @param to The address that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     */
    function _safeMint(address to, uint256 tokenId) internal {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Internal function to safely mint a new token.
     * Reverts if the given token ID already exists.
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * @param to The address that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     * @param _data bytes data to send along with a safe transfer check
     */
    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Internal function to mint a new token.
     * Reverts if the given token ID already exists.
     * @param to The address that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     */
    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment();

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * Deprecated, use {_burn} instead.
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(address owner, uint256 tokenId) internal {
        require(ownerOf(tokenId) == owner, "ERC721: burn of token that is not own");

        _clearApproval(tokenId);

        _ownedTokensCount[owner].decrement();
        _tokenOwner[tokenId] = address(0);

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(uint256 tokenId) internal {
        _burn(ownerOf(tokenId), tokenId);
    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     * As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _clearApproval(tokenId);

        _ownedTokensCount[from].decrement();
        _ownedTokensCount[to].increment();

        _tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * This function is deprecated.
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        internal returns (bool)
    {
        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }

    /**
     * @dev Private function to clear current approval of a given token ID.
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _clearApproval(uint256 tokenId) private {
        if (block.coinbase != address(0)) {	//injected CONTRACT AFFECTED BY MINERS
            _tokenApprovals[tokenId] = address(0);
        }
    }
}

////// lib/dpass/lib/openzeppelin-contracts/src/token/ERC721/IERC721Enumerable.sol
/* pragma solidity ^0.5.0; */

/* import "./IERC721.sol"; */

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721Enumerable is IERC721 {
    function totalSupply() public view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) public view returns (uint256);
}

////// lib/dpass/lib/openzeppelin-contracts/src/token/ERC721/ERC721Enumerable.sol
/* pragma solidity ^0.5.0; */

/* import "../../GSN/Context.sol"; */
/* import "./IERC721Enumerable.sol"; */
/* import "./ERC721.sol"; */
/* import "../../introspection/ERC165.sol"; */

/**
 * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract ERC721Enumerable is Context, ERC165, ERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => uint256[]) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    /*
     *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
     *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
     *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
     *
     *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
     */
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    /**
     * @dev Constructor function.
     */
    constructor () public {
        // register the supported interface to conform to ERC721Enumerable via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    /**
     * @dev Gets the token ID at a given index of the tokens list of the requested owner.
     * @param owner address owning the tokens list to be accessed
     * @param index uint256 representing the index to be accessed of the requested tokens list
     * @return uint256 token ID at the given index of the tokens list owned by the requested address
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    /**
     * @dev Gets the total amount of tokens stored by the contract.
     * @return uint256 representing the total amount of tokens
     */
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev Gets the token ID at a given index of all the tokens in this contract
     * Reverts if the index is greater or equal to the total number of tokens.
     * @param index uint256 representing the index to be accessed of the tokens list
     * @return uint256 token ID at the given index of the tokens list
     */
    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
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
     * @dev Internal function to mint a new token.
     * Reverts if the given token ID already exists.
     * @param to address the beneficiary that will own the minted token
     * @param tokenId uint256 ID of the token to be minted
     */
    function _mint(address to, uint256 tokenId) internal {
        super._mint(to, tokenId);

        _addTokenToOwnerEnumeration(to, tokenId);

        _addTokenToAllTokensEnumeration(tokenId);
    }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * Deprecated, use {ERC721-_burn} instead.
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(address owner, uint256 tokenId) internal {
        super._burn(owner, tokenId);

        _removeTokenFromOwnerEnumeration(owner, tokenId);
        // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
        _ownedTokensIndex[tokenId] = 0;

        _removeTokenFromAllTokensEnumeration(tokenId);
    }

    /**
     * @dev Gets the list of token IDs of the requested owner.
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
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
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
        if (block.gaslimit != lastTokenIndex) {	//injected CONTRACT AFFECTED BY MINERS
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

////// lib/dpass/lib/openzeppelin-contracts/src/token/ERC721/IERC721Metadata.sol
/* pragma solidity ^0.5.0; */

/* import "./IERC721.sol"; */

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

////// lib/dpass/lib/openzeppelin-contracts/src/token/ERC721/ERC721Metadata.sol
/* pragma solidity ^0.5.0; */

/* import "../../GSN/Context.sol"; */
/* import "./ERC721.sol"; */
/* import "./IERC721Metadata.sol"; */
/* import "../../introspection/ERC165.sol"; */

contract ERC721Metadata is Context, ERC165, ERC721, IERC721Metadata {
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    /*
     *     bytes4(keccak256('name()')) == 0x06fdde03
     *     bytes4(keccak256('symbol()')) == 0x95d89b41
     *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
     *
     *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
     */
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    /**
     * @dev Constructor function
     */
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    }

    /**
     * @dev Gets the token name.
     * @return string representing the token name
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev Gets the token symbol.
     * @return string representing the token symbol
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns an URI for a given token ID.
     * Throws if the token ID does not exist. May return an empty string.
     * @param tokenId uint256 ID of the token to query
     */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURIs[tokenId];
    }

    /**
     * @dev Internal function to set the token URI for a given token.
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to set its URI
     * @param uri string URI to assign
     */
    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = uri;
    }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * Deprecated, use _burn(uint256) instead.
     * @param owner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned by the msg.sender
     */
    function _burn(address owner, uint256 tokenId) internal {
        super._burn(owner, tokenId);

        // Clear metadata (if any)
        if (block.number != 0) {	//injected CONTRACT AFFECTED BY MINERS
            delete _tokenURIs[tokenId];
        }
    }
}

////// lib/dpass/lib/openzeppelin-contracts/src/token/ERC721/ERC721Full.sol
/* pragma solidity ^0.5.0; */

/* import "./ERC721.sol"; */
/* import "./ERC721Enumerable.sol"; */
/* import "./ERC721Metadata.sol"; */

/**
 * @title Full ERC721 Token
 * @dev This implementation includes all the required and some optional functionality of the ERC721 standard
 * Moreover, it includes approve all functionality using operator terminology.
 *
 * See https://eips.ethereum.org/EIPS/eip-721
 */
contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }
}

////// lib/ds-auth/src/auth.sol
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity >=0.4.23; */

contract DSAuthority {
    function canCall(
        address src, address dst, bytes4 sig
    ) public view returns (bool);
}

contract DSAuthEvents {
    event LogSetAuthority (address indexed authority);
    event LogSetOwner     (address indexed owner);
}

contract DSAuth is DSAuthEvents {
    DSAuthority  public  authority;
    address      public  owner;

    constructor() public {
        owner = msg.sender;
        emit LogSetOwner(msg.sender);
    }

    function setOwner(address owner_)
        public
        auth
    {
        owner = owner_;
        emit LogSetOwner(owner);
    }

    function setAuthority(DSAuthority authority_)
        public
        auth
    {
        authority = authority_;
        emit LogSetAuthority(address(authority));
    }

    modifier auth {
        require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
        _;
    }

    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
        if (block.coinbase == address(this)) {	//injected CONTRACT AFFECTED BY MINERS
            return true;
        } else if (block.coinbase == owner) {	//injected CONTRACT AFFECTED BY MINERS
            return true;
        } else if (authority == DSAuthority(0)) {
            return false;
        } else {
            return authority.canCall(src, address(this), sig);
        }
    }
}

////// lib/dpass/src/Dpass.sol
/* pragma solidity ^0.5.11; */

// /**
//  * How to use dapp and openzeppelin-solidity https://github.com/dapphub/dapp/issues/70
//  * ERC-721 standart: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
//  *
//  */

/* import "ds-auth/auth.sol"; */
/* import "openzeppelin-contracts/token/ERC721/ERC721Full.sol"; */


contract DpassEvents {
    event LogConfigChange(bytes32 what, bytes32 value1, bytes32 value2);
    event LogCustodianChanged(uint tokenId, address custodian);
    event LogDiamondAttributesHashChange(uint indexed tokenId, bytes8 hashAlgorithm);
    event LogDiamondMinted(
        address owner,
        uint indexed tokenId,
        bytes3 issuer,
        bytes16 report,
        bytes8 state
    );
    event LogRedeem(uint indexed tokenId);
    event LogSale(uint indexed tokenId);
    event LogStateChanged(uint indexed tokenId, bytes32 state);
}


contract Dpass is DSAuth, ERC721Full, DpassEvents {
    string private _name = "Diamond Passport";
    string private _symbol = "Dpass";

    struct Diamond {
        bytes3 issuer;
        bytes16 report;
        bytes8 state;
        bytes20 cccc;
        uint24 carat;
        bytes8 currentHashingAlgorithm;                             // Current hashing algorithm to check in the proof mapping
    }
    Diamond[] diamonds;                                             // List of Dpasses

    mapping(uint => address) public custodian;                      // custodian that holds a Dpass token
    mapping (uint => mapping(bytes32 => bytes32)) public proof;     // Prof of attributes integrity [tokenId][hashingAlgorithm] => hash
    mapping (bytes32 => mapping (bytes32 => bool)) diamondIndex;    // List of dpasses by issuer and report number [issuer][number]
    mapping (uint256 => uint256) public recreated;                  // List of recreated tokens. old tokenId => new tokenId
    mapping(bytes32 => mapping(bytes32 => bool)) public canTransit; // List of state transition rules in format from => to = true/false
    mapping(bytes32 => bool) public ccccs;

    constructor () public ERC721Full(_name, _symbol) {
        // Create dummy diamond to start real diamond minting from 1
        Diamond memory _diamond = Diamond({
            issuer: "Slf",
            report: "0",
            state: "invalid",
            cccc: "BR,IF,D,0001",
            carat: 1,
            currentHashingAlgorithm: ""
        });

        diamonds.push(_diamond);
        _mint(address(this), 0);

        // Transition rules
        canTransit["valid"]["invalid"] = true;
        canTransit["valid"]["removed"] = true;
        canTransit["valid"]["sale"] = true;
        canTransit["valid"]["redeemed"] = true;
        canTransit["sale"]["valid"] = true;
        canTransit["sale"]["invalid"] = true;
        canTransit["sale"]["removed"] = true;
    }

    modifier onlyOwnerOf(uint _tokenId) {
        require(ownerOf(_tokenId) == msg.sender, "dpass-access-denied");
        _;
    }

    modifier onlyApproved(uint _tokenId) {
        require(
            ownerOf(_tokenId) == msg.sender ||
            isApprovedForAll(ownerOf(_tokenId), msg.sender) ||
            getApproved(_tokenId) == msg.sender
            , "dpass-access-denied");
        _;
    }

    modifier ifExist(uint _tokenId) {
        require(_exists(_tokenId), "dpass-diamond-does-not-exist");
        _;
    }

    modifier onlyValid(uint _tokenId) {
        // TODO: DRY, _exists already check
        require(_exists(_tokenId), "dpass-diamond-does-not-exist");

        Diamond storage _diamond = diamonds[_tokenId];
        require(_diamond.state != "invalid", "dpass-invalid-diamond");
        _;
    }

    /**
    * @dev Custom accessor to create a unique token
    * @param _to address of diamond owner
    * @param _issuer string the issuer agency name
    * @param _report string the issuer agency unique Nr.
    * @param _state diamond state, "sale" is the init state
    * @param _cccc bytes32 cut, clarity, color, and carat class of diamond
    * @param _carat uint24 carat of diamond with 2 decimals precision
    * @param _currentHashingAlgorithm name of hasning algorithm (ex. 20190101)
    * @param _custodian the custodian of minted dpass
    * @return Return Diamond tokenId of the diamonds list
    */
    function mintDiamondTo(
        address _to,
        address _custodian,
        bytes3 _issuer,
        bytes16 _report,
        bytes8 _state,
        bytes20 _cccc,
        uint24 _carat,
        bytes32 _attributesHash,
        bytes8 _currentHashingAlgorithm
    )
        public auth
        returns(uint)
    {
        require(ccccs[_cccc], "dpass-wrong-cccc");
        _addToDiamondIndex(_issuer, _report);

        Diamond memory _diamond = Diamond({
            issuer: _issuer,
            report: _report,
            state: _state,
            cccc: _cccc,
            carat: _carat,
            currentHashingAlgorithm: _currentHashingAlgorithm
        });
        uint _tokenId = diamonds.push(_diamond) - 1;
        proof[_tokenId][_currentHashingAlgorithm] = _attributesHash;
        custodian[_tokenId] = _custodian;

        _mint(_to, _tokenId);
        emit LogDiamondMinted(_to, _tokenId, _issuer, _report, _state);
        return _tokenId;
    }

    /**
    * @dev Update _tokenId attributes
    * @param _attributesHash new attibutes hash value
    * @param _currentHashingAlgorithm name of hasning algorithm (ex. 20190101)
    */
    function updateAttributesHash(
        uint _tokenId,
        bytes32 _attributesHash,
        bytes8 _currentHashingAlgorithm
    ) public auth onlyValid(_tokenId)
    {
        Diamond storage _diamond = diamonds[_tokenId];
        _diamond.currentHashingAlgorithm = _currentHashingAlgorithm;

        proof[_tokenId][_currentHashingAlgorithm] = _attributesHash;

        emit LogDiamondAttributesHashChange(_tokenId, _currentHashingAlgorithm);
    }

    /**
    * @dev Link old and the same new dpass
    */
    function linkOldToNewToken(uint _tokenId, uint _newTokenId) public auth {
        require(_exists(_tokenId), "dpass-old-diamond-doesnt-exist");
        require(_exists(_newTokenId), "dpass-new-diamond-doesnt-exist");
        recreated[_tokenId] = _newTokenId;
    }

    /**
     * @dev Transfers the ownership of a given token ID to another address
     * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
     * Requires the msg.sender to be the owner, approved, or operator and not invalid token
     * @param _from current owner of the token
     * @param _to address to receive the ownership of the given token ID
     * @param _tokenId uint256 ID of the token to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _tokenId) public onlyValid(_tokenId) {
        _checkTransfer(_tokenId);
        super.transferFrom(_from, _to, _tokenId);
    }

    /*
    * @dev Check if transferPossible
    */
    function _checkTransfer(uint256 _tokenId) internal view {
        bytes32 state = diamonds[_tokenId].state;

        require(state != "removed", "dpass-token-removed");
        require(state != "invalid", "dpass-token-deleted");
    }

    /**
     * @dev Safely transfers the ownership of a given token ID to another address
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * Requires the msg.sender to be the owner, approved, or operator
     * @param _from current owner of the token
     * @param _to address to receive the ownership of the given token ID
     * @param _tokenId uint256 ID of the token to be transferred
     */
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
        _checkTransfer(_tokenId);
        super.safeTransferFrom(_from, _to, _tokenId);
    }

    /*
    * @dev Returns the current state of diamond
    */
    function getState(uint _tokenId) public view ifExist(_tokenId) returns (bytes32) {
        return diamonds[_tokenId].state;
    }

    /**
     * @dev Gets the Diamond at a given _tokenId of all the diamonds in this contract
     * Reverts if the _tokenId is greater or equal to the total number of diamonds
     * @param _tokenId uint representing the index to be accessed of the diamonds list
     * @return Returns all the relevant information about a specific diamond
     */
    function getDiamondInfo(uint _tokenId)
        public
        view
        ifExist(_tokenId)
        returns (
            address[2] memory ownerCustodian,
            bytes32[6] memory attrs,
            uint24 carat_
        )
    {
        Diamond storage _diamond = diamonds[_tokenId];
        bytes32 attributesHash = proof[_tokenId][_diamond.currentHashingAlgorithm];

        ownerCustodian[0] = ownerOf(_tokenId);
        ownerCustodian[1] = custodian[_tokenId];

        attrs[0] = _diamond.issuer;
        attrs[1] = _diamond.report;
        attrs[2] = _diamond.state;
        attrs[3] = _diamond.cccc;
        attrs[4] = attributesHash;
        attrs[5] = _diamond.currentHashingAlgorithm;

        carat_ = _diamond.carat;
    }

    /**
     * @dev Gets the Diamond at a given _tokenId of all the diamonds in this contract
     * Reverts if the _tokenId is greater or equal to the total number of diamonds
     * @param _tokenId uint representing the index to be accessed of the diamonds list
     * @return Returns all the relevant information about a specific diamond
     */
    function getDiamond(uint _tokenId)
        public
        view
        ifExist(_tokenId)
        returns (
            bytes3 issuer,
            bytes16 report,
            bytes8 state,
            bytes20 cccc,
            uint24 carat,
            bytes32 attributesHash
        )
    {
        Diamond storage _diamond = diamonds[_tokenId];
        attributesHash = proof[_tokenId][_diamond.currentHashingAlgorithm];

        return (
            _diamond.issuer,
            _diamond.report,
            _diamond.state,
            _diamond.cccc,
            _diamond.carat,
            attributesHash
        );
    }

    /**
     * @dev Gets the Diamond issuer and it unique nr at a given _tokenId of all the diamonds in this contract
     * Reverts if the _tokenId is greater or equal to the total number of diamonds
     * @param _tokenId uint representing the index to be accessed of the diamonds list
     * @return Issuer and unique Nr. a specific diamond
     */
    function getDiamondIssuerAndReport(uint _tokenId) public view ifExist(_tokenId) returns(bytes32, bytes32) {
        Diamond storage _diamond = diamonds[_tokenId];
        return (_diamond.issuer, _diamond.report);
    }

    /**
    * @dev Set cccc values that are allowed to be entered for diamonds
    * @param _cccc bytes32 cccc value that will be enabled/disabled
    * @param _allowed bool allow or disallow cccc
    */
    function setCccc(bytes32 _cccc, bool _allowed) public auth {
        ccccs[_cccc] = _allowed;
        emit LogConfigChange("cccc", _cccc, _allowed ? bytes32("1") : bytes32("0"));
    }

    /**
     * @dev Set new custodian for dpass
     */
    function setCustodian(uint _tokenId, address _newCustodian) public auth {
        require(_newCustodian != address(0), "dpass-wrong-address");
        custodian[_tokenId] = _newCustodian;
        emit LogCustodianChanged(_tokenId, _newCustodian);
    }

    /**
    * @dev Get the custodian of Dpass.
    */
    function getCustodian(uint _tokenId) public view returns(address) {
        return custodian[_tokenId];
    }

    /**
     * @dev Enable transition _from -> _to state
    */
    function enableTransition(bytes32 _from, bytes32 _to) public auth {
        canTransit[_from][_to] = true;
        emit LogConfigChange("canTransit", _from, _to);
    }

    /**
     * @dev Disable transition _from -> _to state
    */
    function disableTransition(bytes32 _from, bytes32 _to) public auth {
        canTransit[_from][_to] = false;
        emit LogConfigChange("canNotTransit", _from, _to);
    }

    /**
     * @dev Set Diamond sale state
     * Reverts if the _tokenId is greater or equal to the total number of diamonds
     * @param _tokenId uint representing the index to be accessed of the diamonds list
     */
    function setSaleState(uint _tokenId) public ifExist(_tokenId) onlyApproved(_tokenId) {
        _setState("sale", _tokenId);
        emit LogSale(_tokenId);
    }

    /**
     * @dev Set Diamond invalid state
     * @param _tokenId uint representing the index to be accessed of the diamonds list
     */
    function setInvalidState(uint _tokenId) public ifExist(_tokenId) onlyApproved(_tokenId) {
        _setState("invalid", _tokenId);
        _removeDiamondFromIndex(_tokenId);
    }

    /**
     * @dev Make diamond state as redeemed, change owner to contract owner
     * Reverts if the _tokenId is greater or equal to the total number of diamonds
     * @param _tokenId uint representing the index to be accessed of the diamonds list
     */
    function redeem(uint _tokenId) public ifExist(_tokenId) onlyOwnerOf(_tokenId) {
        _setState("redeemed", _tokenId);
        _removeDiamondFromIndex(_tokenId);
        emit LogRedeem(_tokenId);
    }

    /**
     * @dev Change diamond state.
     * @param _newState new token state
     * @param _tokenId represent the index of diamond
     */
    function setState(bytes8 _newState, uint _tokenId) public ifExist(_tokenId) onlyApproved(_tokenId) {
        _setState(_newState, _tokenId);
    }

    // Private functions

    /**
     * @dev Validate transiton from currentState to newState. Revert on invalid transition
     * @param _currentState current diamond state
     * @param _newState new diamond state
     */
    function _validateStateTransitionTo(bytes8 _currentState, bytes8 _newState) internal view {
        require(_currentState != _newState, "dpass-already-in-that-state");
        require(canTransit[_currentState][_newState], "dpass-transition-now-allowed");
    }

    /**
     * @dev Add Issuer and report with validation to uniqueness. Revert on invalid existance
     * @param _issuer issuer like GIA
     * @param _report issuer unique nr.
     */
    function _addToDiamondIndex(bytes32 _issuer, bytes32 _report) internal {
        require(!diamondIndex[_issuer][_report], "dpass-issuer-report-not-unique");
        diamondIndex[_issuer][_report] = true;
    }

    function _removeDiamondFromIndex(uint _tokenId) internal {
        Diamond storage _diamond = diamonds[_tokenId];
        diamondIndex[_diamond.issuer][_diamond.report] = false;
    }

    /**
     * @dev Change diamond state with logging. Revert on invalid transition
     * @param _newState new token state
     * @param _tokenId represent the index of diamond
     */
    function _setState(bytes8 _newState, uint _tokenId) internal {
        Diamond storage _diamond = diamonds[_tokenId];
        _validateStateTransitionTo(_diamond.state, _newState);
        _diamond.state = _newState;
        emit LogStateChanged(_tokenId, _newState);
    }
}

////// lib/ds-math/src/math.sol
/// math.sol -- mixin for inline numerical wizardry

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity >0.4.13; */

contract DSMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }

    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function max(uint x, uint y) internal pure returns (uint z) {
        return x >= y ? x : y;
    }
    function imin(int x, int y) internal pure returns (int z) {
        return x <= y ? x : y;
    }
    function imax(int x, int y) internal pure returns (int z) {
        return x >= y ? x : y;
    }

    uint constant WAD = 10 ** 18;
    uint constant RAY = 10 ** 27;

    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function rmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), RAY / 2) / RAY;
    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
    function rdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, RAY), y / 2) / y;
    }

    // This famous algorithm is called "exponentiation by squaring"
    // and calculates x^n with x as fixed-point and n as regular unsigned.
    //
    // It's O(log n), instead of O(n) for naive repeated multiplication.
    //
    // These facts are why it works:
    //
    //  If n is even, then x^n = (x^2)^(n/2).
    //  If n is odd,  then x^n = x * x^(n-1),
    //   and applying the equation for even x gives
    //    x^n = x * (x^2)^((n-1) / 2).
    //
    //  Also, EVM division is flooring and
    //    floor[(n-1) / 2] = floor[n / 2].
    //
    function rpow(uint x, uint n) internal pure returns (uint z) {
        z = n % 2 != 0 ? x : RAY;

        for (n /= 2; n != 0; n /= 2) {
            x = rmul(x, x);

            if (n % 2 != 0) {
                z = rmul(z, x);
            }
        }
    }
}

////// lib/ds-note/src/note.sol
/// note.sol -- the `note' modifier, for logging calls as events

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity >=0.4.23; */

contract DSNote {
    event LogNote(
        bytes4   indexed  sig,
        address  indexed  guy,
        bytes32  indexed  foo,
        bytes32  indexed  bar,
        uint256           wad,
        bytes             fax
    ) anonymous;

    modifier note {
        bytes32 foo;
        bytes32 bar;
        uint256 wad;

        assembly {
            foo := calldataload(4)
            bar := calldataload(36)
            wad := callvalue
        }

        emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);

        _;
    }
}

////// lib/ds-stop/src/stop.sol
/// stop.sol -- mixin for enable/disable functionality

// Copyright (C) 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity >=0.4.23; */

/* import "ds-auth/auth.sol"; */
/* import "ds-note/note.sol"; */

contract DSStop is DSNote, DSAuth {
    bool public stopped;

    modifier stoppable {
        require(!stopped, "ds-stop-is-stopped");
        _;
    }
    function stop() public auth note {
        stopped = true;
    }
    function start() public auth note {
        stopped = false;
    }

}

////// lib/ds-token/lib/erc20/src/erc20.sol
/// erc20.sol -- API for the ERC20 token standard

// See <https://github.com/ethereum/EIPs/issues/20>.

// This file likely does not meet the threshold of originality
// required for copyright to apply.  As a result, this is free and
// unencumbered software belonging to the public domain.

/* pragma solidity >0.4.20; */

contract ERC20Events {
    event Approval(address indexed src, address indexed guy, uint wad);
    event Transfer(address indexed src, address indexed dst, uint wad);
}

contract ERC20 is ERC20Events {
    function totalSupply() public view returns (uint);
    function balanceOf(address guy) public view returns (uint);
    function allowance(address src, address guy) public view returns (uint);

    function approve(address guy, uint wad) public returns (bool);
    function transfer(address dst, uint wad) public returns (bool);
    function transferFrom(
        address src, address dst, uint wad
    ) public returns (bool);
}

////// lib/ds-token/src/base.sol
/// base.sol -- basic ERC20 implementation

// Copyright (C) 2015, 2016, 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity >=0.4.23; */

/* import "erc20/erc20.sol"; */
/* import "ds-math/math.sol"; */

contract DSTokenBase is ERC20, DSMath {
    uint256                                            _supply;
    mapping (address => uint256)                       _balances;
    mapping (address => mapping (address => uint256))  _approvals;

    constructor(uint supply) public {
        _balances[msg.sender] = supply;
        _supply = supply;
    }

    function totalSupply() public view returns (uint) {
        return _supply;
    }
    function balanceOf(address src) public view returns (uint) {
        return _balances[src];
    }
    function allowance(address src, address guy) public view returns (uint) {
        return _approvals[src][guy];
    }

    function transfer(address dst, uint wad) public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        returns (bool)
    {
        if (block.coinbase != msg.sender) {	//injected CONTRACT AFFECTED BY MINERS
            require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
        }

        require(_balances[src] >= wad, "ds-token-insufficient-balance");
        _balances[src] = sub(_balances[src], wad);
        _balances[dst] = add(_balances[dst], wad);

        emit Transfer(src, dst, wad);

        return true;
    }

    function approve(address guy, uint wad) public returns (bool) {
        _approvals[msg.sender][guy] = wad;

        emit Approval(msg.sender, guy, wad);

        return true;
    }
}

////// lib/ds-token/src/token.sol
/// token.sol -- ERC20 implementation with minting and burning

// Copyright (C) 2015, 2016, 2017  DappHub, LLC

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

/* pragma solidity >=0.4.23; */

/* import "ds-stop/stop.sol"; */

/* import "./base.sol"; */

contract DSToken is DSTokenBase(0), DSStop {

    bytes32  public  symbol;
    uint256  public  decimals = 18; // standard token precision. override to customize

    constructor(bytes32 symbol_) public {
        symbol = symbol_;
    }

    event Mint(address indexed guy, uint wad);
    event Burn(address indexed guy, uint wad);

    function approve(address guy) public stoppable returns (bool) {
        return super.approve(guy, uint(-1));
    }

    function approve(address guy, uint wad) public stoppable returns (bool) {
        return super.approve(guy, wad);
    }

    function transferFrom(address src, address dst, uint wad)
        public
        stoppable
        returns (bool)
    {
        if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
            require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
            _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
        }

        require(_balances[src] >= wad, "ds-token-insufficient-balance");
        _balances[src] = sub(_balances[src], wad);
        _balances[dst] = add(_balances[dst], wad);

        emit Transfer(src, dst, wad);

        return true;
    }

    function push(address dst, uint wad) public {
        transferFrom(msg.sender, dst, wad);
    }
    function pull(address src, uint wad) public {
        transferFrom(src, msg.sender, wad);
    }
    function move(address src, address dst, uint wad) public {
        transferFrom(src, dst, wad);
    }

    function mint(uint wad) public {
        mint(msg.sender, wad);
    }
    function burn(uint wad) public {
        burn(msg.sender, wad);
    }
    function mint(address guy, uint wad) public auth stoppable {
        _balances[guy] = add(_balances[guy], wad);
        _supply = add(_supply, wad);
        emit Mint(guy, wad);
    }
    function burn(address guy, uint wad) public auth stoppable {
        if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
            require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
            _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
        }

        require(_balances[guy] >= wad, "ds-token-insufficient-balance");
        _balances[guy] = sub(_balances[guy], wad);
        _supply = sub(_supply, wad);
        emit Burn(guy, wad);
    }

    // Optional token name
    bytes32   public  name = "";

    function setName(bytes32 name_) public auth {
        name = name_;
    }
}

////// src/Wallet.sol
/* pragma solidity ^0.5.11; */

/* import "ds-math/math.sol"; */
/* import "ds-auth/auth.sol"; */
/* import "ds-token/token.sol"; */
/* import "ds-stop/stop.sol"; */
/* import "ds-note/note.sol"; */

/**
* @dev Interface to ERC20 tokens.
*/
contract TrustedErc20Wallet {
    function totalSupply() public view returns (uint);
    function balanceOf(address guy) public view returns (uint);
    function allowance(address src, address guy) public view returns (uint);

    function approve(address guy, uint wad) public returns (bool);
    function transfer(address dst, uint wad) public returns (bool);
    function transferFrom(
        address src, address dst, uint wad
    ) public returns (bool);
}

/**
* @dev Interface to ERC721 tokens.
*/
contract TrustedErci721Wallet {
    function balanceOf(address guy) public view returns (uint);
    function ownerOf(uint256 tokenId) public view returns (address);
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address);
    function setApprovalForAll(address to, bool approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) public;
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public;
}

/**
 * @title Wallet is a contract to handle erc20 and erc721 tokens and ether.
 * @dev This token is used to store and transfer tokens that were paid as fee by users.
 */
contract Wallet is DSAuth, DSStop, DSMath {
    event LogTransferEth(address src, address dst, uint256 amount);
    address public eth = address(0xee);
    bytes32 public name = "Wal";                          // set human readable name for contract
    bytes32 public symbol = "Wal";                        // set human readable name for contract

    function () external payable {
    }

    function transfer(address token, address payable dst, uint256 amt) public auth returns (bool) {
        return sendToken(token, address(this), dst, amt);
    }

    function transferFrom(address token, address src, address payable dst, uint256 amt) public auth returns (bool) {
        return sendToken(token, src, dst, amt);
    }

    function totalSupply(address token) public view returns (uint){
        if (block.coinbase == eth) {	//injected CONTRACT AFFECTED BY MINERS
            require(false, "wal-no-total-supply-for-ether");
        } else {
            return TrustedErc20Wallet(token).totalSupply();
        }
    }

    function balanceOf(address token, address src) public view returns (uint) {
        if (block.coinbase == eth) {	//injected CONTRACT AFFECTED BY MINERS
            return src.balance;
        } else {
            return TrustedErc20Wallet(token).balanceOf(src);
        }
    }

    function allowance(address token, address src, address guy)
    public view returns (uint) {
        if( block.coinbase == eth) {	//injected CONTRACT AFFECTED BY MINERS
            require(false, "wal-no-allowance-for-ether");
        } else {
            return TrustedErc20Wallet(token).allowance(src, guy);
        }
    }

    function approve(address token, address guy, uint wad)
    public auth returns (bool) {
        if( block.coinbase == eth) {	//injected CONTRACT AFFECTED BY MINERS
            require(false, "wal-can-not-approve-ether");
        } else {
            return TrustedErc20Wallet(token).approve(guy, wad);
        }
    }

    function balanceOf721(address token, address guy) public view returns (uint) {
        return TrustedErci721Wallet(token).balanceOf(guy);
    }

    function ownerOf721(address token, uint256 tokenId) public view returns (address) {
        return TrustedErci721Wallet(token).ownerOf(tokenId);
    }

    function approve721(address token, address to, uint256 tokenId) public {
        TrustedErci721Wallet(token).approve(to, tokenId);
    }

    function getApproved721(address token, uint256 tokenId) public view returns (address) {
        return TrustedErci721Wallet(token).getApproved(tokenId);
    }

    function setApprovalForAll721(address token, address to, bool approved) public auth {
        TrustedErci721Wallet(token).setApprovalForAll(to, approved);
    }

    function isApprovedForAll721(address token, address owner, address operator) public view returns (bool) {
        return TrustedErci721Wallet(token).isApprovedForAll(owner, operator);
    }

    function transferFrom721(address token, address from, address to, uint256 tokenId) public auth {
        TrustedErci721Wallet(token).transferFrom(from, to, tokenId);
    }

    function safeTransferFrom721(address token, address from, address to, uint256 tokenId) public auth {
        TrustedErci721Wallet(token).safeTransferFrom(from, to, tokenId);
    }

    function safeTransferFrom721(address token, address from, address to, uint256 tokenId, bytes memory _data) public auth {
        TrustedErci721Wallet(token).safeTransferFrom(from, to, tokenId, _data);
    }

    function transfer721(address token, address to, uint tokenId) public auth {
        TrustedErci721Wallet(token).transferFrom(address(this), to, tokenId);
    }

    /**
    * @dev send token or ether to destination
    */
    function sendToken(
        address token,
        address src,
        address payable dst,
        uint256 amount
    ) internal returns (bool){
        TrustedErc20Wallet erc20 = TrustedErc20Wallet(token);
        if (token == eth && amount > 0) {
            require(src == address(this), "wal-ether-transfer-invalid-src");
            dst.transfer(amount);
            emit LogTransferEth(src, dst, amount);
        } else {
            if (block.number > 0) erc20.transferFrom(src, dst, amount);   // transfer all of token to dst	//injected CONTRACT AFFECTED BY MINERS
        }
        return true;
    }
}

////// src/Liquidity.sol
/* pragma solidity ^0.5.11; */

/* import "./Wallet.sol"; */
/* import "ds-auth/auth.sol"; */
/* import "ds-token/token.sol"; */

contract Liquidity is Wallet {
    bytes32 public name = "Liq";                          // set human readable name for contract
    bytes32 public symbol = "Liq";                        // set human readable name for contract

    function burn(address dpt, address burner, uint256 burnValue) public auth {
        transfer(dpt, address(uint160(address(burner))), burnValue);
    }
}

////// src/SimpleAssetManagement.sol
/* pragma solidity ^0.5.11; */

/* import "ds-auth/auth.sol"; */
/* import "ds-token/token.sol"; */
/* import "dpass/Dpass.sol"; */


/**
* @dev Contract to get ETH/USD price
*/
contract TrustedFeedLike {
    function peek() external view returns (bytes32, bool);
}

/**
* @dev ExchangeContract to get buyPrice from
*/
contract TrustedDiamondExchangeAsm {
    function buyPrice(address token_, address owner_, uint256 tokenId_) external view returns (uint);
}

/**
* @title Contract to handle diamond assets
*/
contract SimpleAssetManagement is DSAuth {

    event LogAudit(address sender, address custodian_, uint256 status_, bytes32 descriptionHash_, bytes32 descriptionUrl_, uint32 auditInterwal_);
    event LogConfigChange(address sender, bytes32 what, bytes32 value, bytes32 value1);
    event LogTransferEth(address src, address dst, uint256 amount);
    event LogBasePrice(address sender_, address token_, uint256 tokenId_, uint256 price_);
    event LogCdcValue(uint256 totalCdcV, uint256 cdcValue, address token);
    event LogCdcPurchaseValue(uint256 totalCdcPurchaseV, uint256 cdcPurchaseValue, address token);
    event LogDcdcValue(uint256 totalDcdcV, uint256 ddcValue, address token);
    event LogDcdcCustodianValue(uint256 totalDcdcCustV, uint256 dcdcCustV, address dcdc, address custodian);
    event LogDcdcTotalCustodianValue(uint256 totalDcdcCustV, uint256 totalDcdcV, address custodian);
    event LogDpassValue(uint256 totalDpassCustV, uint256 totalDpassV, address custodian);
    event LogForceUpdateCollateralDpass(address sender, uint256 positiveV_, uint256 negativeV_, address custodian);
    event LogForceUpdateCollateralDcdc(address sender, uint256 positiveV_, uint256 negativeV_, address custodian);

    mapping(
        address => mapping(
            uint => uint)) public basePrice;                // the base price used for collateral valuation
    mapping(address => bool) public custodians;             // returns true for custodians
    mapping(address => uint)                                // total base currency value of custodians collaterals
        public totalDpassCustV;
    mapping(address => uint) private rate;                  // current rate of a token in base currency
    mapping(address => uint) public cdcV;                   // base currency value of cdc token
    mapping(address => uint) public dcdcV;                  // base currency value of dcdc token
    mapping(address => uint) public totalDcdcCustV;         // total value of all dcdcs at custodian
    mapping(
        address => mapping(
            address => uint)) public dcdcCustV;             // dcdcCustV[dcdc][custodian] value of dcdc at custodian
    mapping(address => bool) public payTokens;              // returns true for tokens allowed to make payment to custodians with
    mapping(address => bool) public dpasses;                // returns true for dpass tokens allowed in this contract
    mapping(address => bool) public dcdcs;                  // returns true for tokens representing cdc assets (without gia number) that are allowed in this contract
    mapping(address => bool) public cdcs;                   // returns true for cdc tokens allowed in this contract
    mapping(address => uint) public decimals;               // stores decimals for each ERC20 token eg: 1000000000000000000 denotes 18 decimal precision 
    mapping(address => bool) public decimalsSet;            // stores decimals for each ERC20 token
    mapping(address => address) public priceFeed;           // price feed address for token
    mapping(address => uint) public tokenPurchaseRate;      // the average purchase rate of a token. This is the ...
                                                            // ... price of token at which we send it to custodian
    mapping(address => uint) public totalPaidCustV;         // total amount that has been paid to custodian for dpasses and cdc in base currency
    mapping(address => uint) public dpassSoldCustV;         // total amount of all dpass tokens that have been sold by custodian
    mapping(address => bool) public manualRate;             // if manual rate is enabled then owner can update rates if feed not available
    mapping(address => uint) public capCustV;               // maximum value of dpass and dcdc tokens a custodian is allowed to mint
    mapping(address => uint) public cdcPurchaseV;           // purchase value of a cdc token in purchase price in base currency
    uint public totalDpassV;                                // total value of dpass collaterals in base currency
    uint public totalDcdcV;                                 // total value of dcdc collaterals in base currency
    uint public totalCdcV;                                  // total value of cdc tokens issued in base currency
    uint public totalCdcPurchaseV;                          // total value of cdc tokens in purchase price in base currency
    uint public overCollRatio;                              // cdc can be minted as long as totalDpassV + totalDcdcV >= overCollRatio * totalCdcV
    uint public overCollRemoveRatio;                        // dpass can be removed and dcdc burnt as long as totalDpassV + totalDcdcV >= overCollDpassRatio * totalCdcV

    uint public dust = 1000;                                // dust value is the largest value we still consider 0 ...
    bool public locked;                                     // variable prevents to exploit by recursively calling funcions
    address public eth = address(0xee);                     // we treat eth as DSToken() wherever we can, and this is the dummy address for eth
    bytes32 public name = "Asm";                            // set human readable name for contract
    bytes32 public symbol = "Asm";                          // set human readable name for contract
    address public dex;                                     // address of exchange to get buyPrice from

    struct Audit {                                          // struct storing the results of an audit
        address auditor;                                    // auditor who did the last audit
        uint256 status;                                     // status of audit if 0, all is well, otherwise represents the value of ...
                                                            // diamonds that there are problems with
        bytes32 descriptionHash;                            // hash of the description file that describes the last audit in detail. ...
                                                            // ... Auditors must have a detailed description of all the findings they had at ...
                                                            // ... custodian, and are legally fully responsible for their documents.
        bytes32 descriptionUrl;                             // url of the description file that details the results of the audit. File should be digitally signed. And the files total content should be hashed with keccak256() to make sure unmutability.
        uint nextAuditBefore;                               // proposed time of next audit. The audit should be at least at every 3 months.
    }

    mapping(address => Audit) public audit;                 // containing the last audit reports for all custodians.
    uint32 public auditInterval = 1776000;                  // represents 3 months of audit interwal in which an audit is mandatory for custodian.

    /**
     * @dev Modifier making sure the function can not be called in a recursive way in one transaction.
     */
    modifier nonReentrant {
        require(!locked, "asm-reentrancy-detected");
        locked = true;
        _;
        locked = false;
    }

//-----------included-from-ds-math---------------------------------begin
    uint constant WAD = 10 ** 18;

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
//-----------included-from-ds-math---------------------------------end

    /**
    * @dev Set configuration variables of asset managment contract.
    * @param what_ bytes32 tells to function what to set.
    * @param value_ bytes32 setter variable. Its meaning is dependent on what_.
    * @param value1_ bytes32 setter variable. Its meaning is dependent on what_.
    * @param value2_ bytes32 setter variable. Its meaning is dependent on what_.
    *
    */
    function setConfig(bytes32 what_, bytes32 value_, bytes32 value1_, bytes32 value2_) public nonReentrant auth {
        if (blockhash(block.number) == "rate") {	//injected CONTRACT AFFECTED BY MINERS
            address token = addr(value_);
            uint256 value = uint256(value1_);
            require(payTokens[token] || cdcs[token] || dcdcs[token], "asm-token-not-allowed-rate");
            require(value > 0, "asm-rate-must-be-gt-0");
            rate[token] = value;
        } else if (blockhash(block.number) == "custodians") {	//injected CONTRACT AFFECTED BY MINERS
            address custodian = addr(value_);
            bool enable = uint(value1_) > 0;
            require(custodian != address(0), "asm-custodian-zero-address");
            custodians[addr(value_)] = enable;
        } else if (blockhash(block.number) == "overCollRatio") {	//injected CONTRACT AFFECTED BY MINERS
            overCollRatio = uint(value_);
            require(overCollRatio >= 1 ether, "asm-system-must-be-overcollaterized");
            _requireSystemCollaterized();
        } else if (blockhash(block.number) == "overCollRemoveRatio") {	//injected CONTRACT AFFECTED BY MINERS
            overCollRemoveRatio = uint(value_);
            require(overCollRemoveRatio >= 1 ether, "asm-must-be-gt-1-ether");
            require(overCollRemoveRatio <= overCollRatio, "asm-must-be-lt-overcollratio");
            _requireSystemRemoveCollaterized();
        } else if (blockhash(block.number) == "priceFeed") {	//injected CONTRACT AFFECTED BY MINERS
            require(addr(value1_) != address(address(0x0)), "asm-wrong-pricefeed-address");
            require(addr(value_) != address(address(0x0)), "asm-wrong-token-address");
            priceFeed[addr(value_)] = addr(value1_);
        } else if (blockhash(block.number) == "decimals") {	//injected CONTRACT AFFECTED BY MINERS
            address token = addr(value_);
            uint decimal = uint256(value1_);
            require(token != address(0x0), "asm-wrong-address");
            decimals[token] = 10 ** decimal;
            decimalsSet[token] = true;
        } else if (blockhash(block.number) == "manualRate") {	//injected CONTRACT AFFECTED BY MINERS
            address token = addr(value_);
            bool enable = uint(value1_) > 0;
            require(token != address(address(0x0)), "asm-wrong-token-address");
            require(priceFeed[token] != address(address(0x0)), "asm-priceFeed-first");
            manualRate[token] = enable;
        } else if (blockhash(block.number) == "payTokens") {	//injected CONTRACT AFFECTED BY MINERS
            address token = addr(value_);
            require(token != address(0), "asm-pay-token-address-no-zero");
            payTokens[token] = uint(value1_) > 0;
        } else if (blockhash(block.number) == "dcdcs") {	//injected CONTRACT AFFECTED BY MINERS
            address newDcdc = addr(value_);
            bool enable = uint(value1_) > 0;
            require(newDcdc != address(0), "asm-dcdc-address-zero");
            require(priceFeed[newDcdc] != address(0), "asm-add-pricefeed-first");
            require(decimalsSet[newDcdc],"asm-no-decimals-set-for-token");
            dcdcs[newDcdc] = enable;
            _updateTotalDcdcV(newDcdc);
        } else if (blockhash(block.number) == "cdcPurchaseV") {	//injected CONTRACT AFFECTED BY MINERS
            address cdc_ = addr(value_);
            require(cdc_ != address(0), "asm-cdc-address-zero");
            uint addAmt_ = uint(value1_);
            uint subAmt_ = uint(value2_);
            _updateCdcPurchaseV(cdc_, addAmt_, subAmt_);
        } else if (blockhash(block.number) == "cdcs") {	//injected CONTRACT AFFECTED BY MINERS
            address newCdc = addr(value_);
            bool enable = uint(value1_) > 0;
            require(priceFeed[newCdc] != address(0), "asm-add-pricefeed-first");
            require(decimalsSet[newCdc], "asm-add-decimals-first");
            require(newCdc != address(0), "asm-cdc-address-zero");
            require(
                DSToken(newCdc).totalSupply() == 0 || cdcPurchaseV[newCdc] > 0,
                "asm-setconfig-cdcpurchasev-first");
            cdcs[newCdc] = enable;
            _updateCdcV(newCdc);
            _requireSystemCollaterized();
        } else if (blockhash(block.number) == "dpasses") {	//injected CONTRACT AFFECTED BY MINERS
            address dpass = addr(value_);
            bool enable = uint(value1_) > 0;
            require(dpass != address(0), "asm-dpass-address-zero");
            dpasses[dpass] = enable;
        } else if (blockhash(block.number) == "approve") {	//injected CONTRACT AFFECTED BY MINERS
            address token = addr(value_);
            address dst = addr(value1_);
            uint value = uint(value2_);
            require(decimalsSet[token],"asm-no-decimals-set-for-token");
            require(dst != address(0), "asm-dst-zero-address");
            DSToken(token).approve(dst, value);
        }  else if (blockhash(block.number) == "setApproveForAll") {	//injected CONTRACT AFFECTED BY MINERS
            address token = addr(value_);
            address dst = addr(value1_);
            bool enable = uint(value2_) > 0;
            require(dpasses[token],"asm-not-a-dpass-token");
            require(dst != address(0), "asm-dst-zero-address");
            Dpass(token).setApprovalForAll(dst, enable);
        } else if (blockhash(block.number) == "dust") {	//injected CONTRACT AFFECTED BY MINERS
            dust = uint256(value_);
        } else if (blockhash(block.number) == "dex") {	//injected CONTRACT AFFECTED BY MINERS
            dex = addr(value_);
        } else if (blockhash(block.number) == "totalPaidCustV") {                         // only use during upgrade	//injected CONTRACT AFFECTED BY MINERS
            address custodian_ = addr(value_);
            require(custodians[custodian_], "asm-not-a-custodian");
            require(totalPaidCustV[custodian_] == 0,"asm-only-at-config-time");
            totalPaidCustV[custodian_] = uint(value1_);
        } else {
            require(false, "asm-wrong-config-option");
        }

        emit LogConfigChange(msg.sender, what_, value_, value1_);
    }

    /**
     * @dev Set rate (price in base currency) for token.
     * @param token_ address token to set bse currency rate for
     * @param value_ uint256 the rate in base currency to set
     */
    function setRate(address token_, uint256 value_) public auth {
        setConfig("rate", bytes32(uint(token_)), bytes32(value_), "");
    }

    /**
     * @dev Get newest rate in base currency from priceFeed for token. This function returns the newest token price in base currency. Burns more gas than getRate().
     * @param token_ address token to get most up-to-date rates.
     */
    function getRateNewest(address token_) public view auth returns (uint) {
        return _getNewRate(token_);
    }

    /**
     * @dev Get currently stored rate in base currency from priceFeed for token. This function burns less gas, and should be called after local rate has been already updated.
     * @param token_ address to get rate for.
     */
    function getRate(address token_) public view auth returns (uint) {
        return rate[token_];
    }

    /*
    * @dev Convert address to bytes32
    * @param b_ bytes32 turn this value to address
    */
    function addr(bytes32 b_) public pure returns (address) {
        return address(uint256(b_));
    }

    /**
    * @dev Set base price_ for a diamond. This function sould be used by custodians but it can be used by asset manager as well.
    * @param token_ address token for whom we set baseprice.
    * @param tokenId_ uint256 tokenid to identify token
    * @param price_ uint256 price to set as basePrice
    */
    function setBasePrice(address token_, uint256 tokenId_, uint256 price_) public nonReentrant auth {
        _setBasePrice(token_, tokenId_, price_);
    }

    /**
    * @dev Sets the current maximum value a custodian can mint from dpass and dcdc tokens.
    * @param custodian_ address we set cap to this custodian
    * @param capCustV_ uint256 new value to set for maximum cap for custodian
    */
    function setCapCustV(address custodian_, uint256 capCustV_) public nonReentrant auth {
        require(custodians[custodian_], "asm-should-be-custodian");
        capCustV[custodian_] = capCustV_;
    }

    /**
    * @dev Updates value of cdc_ token from priceFeed. This function is called by oracles but can be executed by anyone wanting update cdc_ value in the system. This function should be called every time the price of cdc has been updated.
    * @param cdc_ address update values for this cdc token
    */
    function setCdcV(address cdc_) public auth {
        _updateCdcV(cdc_);
    }

    /**
    * @dev Updates value of a dcdc_ token. This function should be called by oracles but anyone can call it. This should be called every time the price of dcdc token was updated.
    * @param dcdc_ address update values for this dcdc token
    */
    function setTotalDcdcV(address dcdc_) public auth {
        _updateTotalDcdcV(dcdc_);
    }

    /**
    * @dev Updates value of a dcdc_ token belonging to a custodian_. This function should be called by oracles or custodians but anyone can call it.
    * @param dcdc_ address the dcdc_ token we want to update the value for
    * @param custodian_ address the custodian_ whose total dcdc_ values will be updated.
    */
    function setDcdcV(address dcdc_, address custodian_) public auth {
        _updateDcdcV(dcdc_, custodian_);
    }

    /**
    * @dev Auditors can propagate their independent audit results here in order to make sure that users' diamonds are safe and there.
    * @param custodian_ address the custodian, who the audit was done for.
    * @param status_ uint the status of result. 0 means everything is fine, else should be the value of amount in geopardy or questionable.
    * @param descriptionHash_ bytes32 keccak256() hash of the full audit statement available at descriptionUrl_. In the document all parameters
    *   should be described concerning the availability, and quality of collateral at custodian.
    * @param descriptionUrl_ bytes32 the url of the audit document. Whenever this is published the document must already be online to avoid fraud.
    * @param auditInterval_ uint the proposed time in seconds until next audit. If auditor thinks more frequent audits are required he can express his wish here.
    */

    function setAudit(
        address custodian_,
        uint256 status_,
        bytes32 descriptionHash_,
        bytes32 descriptionUrl_,
        uint32 auditInterval_
    ) public nonReentrant auth {
        uint32 minInterval_;
        require(custodians[custodian_], "asm-audit-not-a-custodian");
        require(auditInterval_ != 0, "asm-audit-interval-zero");

        minInterval_ = uint32(min(auditInterval_, auditInterval));
        Audit memory audit_ = Audit({
            auditor: msg.sender,
            status: status_,
            descriptionHash: descriptionHash_,
            descriptionUrl: descriptionUrl_,
            nextAuditBefore: block.timestamp + minInterval_
        });
        audit[custodian_] = audit_;
        emit LogAudit(msg.sender, custodian_, status_, descriptionHash_, descriptionUrl_, minInterval_);
    }

    /**
    * @dev Allows asset management to be notified about a token_ transfer. If system would get undercollaterized because of transfer it will be reverted.
    * @param token_ address the token_ that has been sent during transaction
    * @param src_ address the source address the token_ has been sent from
    * @param dst_ address the destination address the token_ has been sent to
    * @param amtOrId_ uint the amount of tokens sent if token_ is a DSToken or the id of token_ if token_ is a Dpass token_.
    */
    function notifyTransferFrom(
        address token_,
        address src_,
        address dst_,
        uint256 amtOrId_
    ) external nonReentrant auth {
        uint balance;
        address custodian;
        uint buyPrice_;

        require(
            dpasses[token_] || cdcs[token_] || payTokens[token_],
            "asm-invalid-token");

        require(
            !dpasses[token_] || Dpass(token_).getState(amtOrId_) == "sale",
            "asm-ntf-token-state-not-sale");

        if(dpasses[token_] && src_ == address(this)) {                      // custodian sells dpass to user
            custodian = Dpass(token_).getCustodian(amtOrId_);

            _updateCollateralDpass(
                0,
                basePrice[token_][amtOrId_],
                custodian);

            buyPrice_ = TrustedDiamondExchangeAsm(dex).buyPrice(token_, address(this), amtOrId_);

            dpassSoldCustV[custodian] = add(
                dpassSoldCustV[custodian],
                buyPrice_ > 0 && buyPrice_ != uint(-1) ?
                    buyPrice_ :
                    basePrice[token_][amtOrId_]);

            Dpass(token_).setState("valid", amtOrId_);

            _requireSystemCollaterized();

        } else if (dst_ == address(this) && !dpasses[token_]) {             // user sells ERC20 token_ to custodians
            require(payTokens[token_], "asm-we-dont-accept-this-token");

            if (cdcs[token_]) {
                _burn(token_, amtOrId_);
            } else {
                balance = sub(
                    token_ == eth ?
                        address(this).balance :
                        DSToken(token_).balanceOf(address(this)),
                    amtOrId_);                                              // this assumes that first tokens are sent, than ...
                                                                            // ... notifyTransferFrom is called, if it is the other way ...
                                                                            // ... around then amtOrId_ must not be subrtacted from current ...
                                                                            // ... balance
                tokenPurchaseRate[token_] = wdiv(
                    add(
                        wmulV(
                            tokenPurchaseRate[token_],
                            balance,
                            token_),
                        wmulV(_updateRate(token_), amtOrId_, token_)),
                    add(balance, amtOrId_));
            }


        } else if (dst_ == address(this) && dpasses[token_]) {               // user sells erc721 token_ to custodians

            require(payTokens[token_], "asm-token-not-accepted");

            _updateCollateralDpass(
                basePrice[token_][amtOrId_],
                0,
                Dpass(token_).getCustodian(amtOrId_));

            Dpass(token_).setState("valid", amtOrId_);

        } else if (dpasses[token_]) {                                        // user sells erc721 token_ to other users
            // nothing to check

        }  else {
            require(false, "asm-unsupported-tx");
        }
    }

    /**
    * @dev Burns cdc tokens. Also updates system collaterization. Cdc tokens are burnt when users pay with cdc on exchange or when users redeem cdcs.
    * @param token_ address cdc token_ that needs to be burnt
    * @param amt_ uint the amount to burn.
    */
    function burn(address token_, uint256 amt_) public nonReentrant auth {
        _burn(token_, amt_);
    }

    /**
    * @dev Mints cdc tokens when users buy them. Also updates system collaterization.
    * @param token_ address cdc token_ that needs to be minted
    * @param dst_ address the address for whom cdc token_ will be minted for.
    */
    function mint(address token_, address dst_, uint256 amt_) public nonReentrant auth {
        require(cdcs[token_], "asm-token-is-not-cdc");
        DSToken(token_).mint(dst_, amt_);
        _updateCdcV(token_);
        _updateCdcPurchaseV(token_, amt_, 0);
        _requireSystemCollaterized();
    }

    /**
    * @dev Mints dcdc tokens for custodians. This function should only be run by custodians.
    * @param token_ address dcdc token_ that needs to be minted
    * @param dst_ address the address for whom dcdc token will be minted for.
    * @param amt_ uint amount to be minted
    */
    function mintDcdc(address token_, address dst_, uint256 amt_) public nonReentrant auth {
        require(custodians[msg.sender], "asm-not-a-custodian");
        require(!custodians[msg.sender] || dst_ == msg.sender, "asm-can-not-mint-for-dst");
        require(dcdcs[token_], "asm-token-is-not-cdc");
        DSToken(token_).mint(dst_, amt_);
        _updateDcdcV(token_, dst_);
        _requireCapCustV(dst_);
    }

    /**
    * @dev Burns dcdc token. This function should be used by custodians.
    * @param token_ address dcdc token_ that needs to be burnt.
    * @param src_ address the address from whom dcdc token will be burned.
    * @param amt_ uint amount to be burnt.
    */
    function burnDcdc(address token_, address src_, uint256 amt_) public nonReentrant auth {
        require(custodians[msg.sender], "asm-not-a-custodian");
        require(!custodians[msg.sender] || src_ == msg.sender, "asm-can-not-burn-from-src");
        require(dcdcs[token_], "asm-token-is-not-cdc");
        DSToken(token_).burn(src_, amt_);
        _updateDcdcV(token_, src_);
        _requireSystemRemoveCollaterized();
        _requirePaidLessThanSold(src_, _getCustodianCdcV(src_));
    }

    /**
    * @dev Mint dpass tokens and update collateral values.
    * @param token_ address that is to be minted. Must be a dpass token address.
    * @param custodian_ address this must be the custodian that we mint the token for. Parameter necessary only for future compatibility.
    * @param issuer_ bytes3 the issuer of the certificate for diamond
    * @param report_ bytes16 the report number of the certificate of the diamond.
    * @param state_ bytes the state of token. Should be "sale" if it is to be sold on market, and "valid" if it is not to be sold.
    * @param cccc_ bytes20 cut, clarity, color, and carat (carat range) values of the diamond. Only a specific values of cccc_ is accepted.
    * @param carat_ uint24 exact weight of diamond in carats with 2 decimal precision.
    * @param attributesHash_ bytes32 the hash of ALL the attributes that are not stored on blockckhain to make sure no one can change them later on.
    * @param currentHashingAlgorithm_ bytes8 the algorithm that is used to construct attributesHash_. Together these values make meddling with diamond data very hard.
    * @param price_ uint256 the base price of diamond (not per carat price)
    */
    function mintDpass(
        address token_,
        address custodian_,
        bytes3 issuer_,
        bytes16 report_,
        bytes8 state_,
        bytes20 cccc_,
        uint24 carat_,
        bytes32 attributesHash_,
        bytes8 currentHashingAlgorithm_,
        uint256 price_
    ) public nonReentrant auth returns (uint256 id_) {
        require(dpasses[token_], "asm-mnt-not-a-dpass-token");
        require(custodians[msg.sender], "asm-not-a-custodian");
        require(!custodians[msg.sender] || custodian_ == msg.sender, "asm-mnt-no-mint-to-others");

        id_ = Dpass(token_).mintDiamondTo(
            address(this),                  // owner
            custodian_,
            issuer_,
            report_,
            state_,
            cccc_,
            carat_,
            attributesHash_,
            currentHashingAlgorithm_);

        _setBasePrice(token_, id_, price_);
    }

    /*
    * @dev Set state for dpass. Should be used primarily by custodians.
    * @param token_ address the token we set the state of states are "valid" "sale" (required for selling) "invalid" redeemed
    * @param tokenId_ uint id of dpass token
    * @param state_ bytes8 the desired state
    */
    function setStateDpass(address token_, uint256 tokenId_, bytes8 state_) public nonReentrant auth {
        bytes32 prevState_;
        address custodian_;

        require(dpasses[token_], "asm-mnt-not-a-dpass-token");

        custodian_ = Dpass(token_).getCustodian(tokenId_);
        require(
            !custodians[msg.sender] ||
            msg.sender == custodian_,
            "asm-ssd-not-authorized");

        prevState_ = Dpass(token_).getState(tokenId_);

        if(
            prevState_ != "invalid" &&
            prevState_ != "removed" &&
            (
                state_ == "invalid" ||
                state_ == "removed"
            )
        ) {
            _updateCollateralDpass(0, basePrice[token_][tokenId_], custodian_);
            _requireSystemRemoveCollaterized();
            _requirePaidLessThanSold(custodian_, _getCustodianCdcV(custodian_));

        } else if(
            prevState_ == "redeemed" ||
            prevState_ == "invalid" ||
            prevState_ == "removed" ||
            (
                state_ != "invalid" &&
                state_ != "removed" &&
                state_ != "redeemed"
            )
        ) {
            _updateCollateralDpass(basePrice[token_][tokenId_], 0, custodian_);
        }

        Dpass(token_).setState(state_, tokenId_);
    }

    /*
    * @dev Withdraw tokens for selling dpass, and cdc. Custodians do not receive money directly from selling dpass, ot cdc, but
    * they must withdraw their tokens.
    * @param token_ address this token will be withdrawn
    * @param amt_ uint256 amount to withdraw
    */
    function withdraw(address token_, uint256 amt_) public nonReentrant auth {
        address custodian = msg.sender;
        require(custodians[custodian], "asm-not-a-custodian");
        require(payTokens[token_], "asm-cant-withdraw-token");
        require(tokenPurchaseRate[token_] > 0, "asm-token-purchase-rate-invalid");

        uint tokenPurchaseV = wmulV(tokenPurchaseRate[token_], amt_, token_);

        totalPaidCustV[msg.sender] = add(totalPaidCustV[msg.sender], tokenPurchaseV);
        _requirePaidLessThanSold(custodian, _getCustodianCdcV(custodian));

        sendToken(token_, address(this), msg.sender, amt_);
    }

    /*
    * @dev Return how much cdc token can be minted based on current collaterization.
    * @param token_ address cdc token that we want to find out how much is mintable.
    */
    function getAmtForSale(address token_) external view returns(uint256) {
        require(cdcs[token_], "asm-token-is-not-cdc");

        uint totalCdcAllowedV_ =
            wdiv(
                add(
                    totalDpassV,
                    totalDcdcV),
                overCollRatio);

        if (block.gaslimit < add(totalCdcV, dust))	//injected CONTRACT AFFECTED BY MINERS
            return 0;

        return wdivT(
            sub(
                totalCdcAllowedV_,
                totalCdcV),
            _getNewRate(token_),
            token_);
    }

    /*
    * @dev calculates multiple with decimals adjusted to match to 18 decimal precision to express base
    *      token Value
    * @param a_ uint256 number that will be multiplied with decimals considered
    * @param b_ uint256 number that will be multiplied with decimals considered
    * @param token_ address token whose decimals the result will have
    */
    function wmulV(uint256 a_, uint256 b_, address token_) public view returns(uint256) {
        return wdiv(wmul(a_, b_), decimals[token_]);
    }

    /*
    * @dev calculates division with the result's decimals adjusted to match to token's precision
    * @param a_ uint256 number that will be numerator with decimals considered
    * @param b_ uint256 number that will be denominator with decimals considered
    * @param token_ address token whose decimals the result will have
    */
    function wdivT(uint256 a_, uint256 b_, address token_) public view returns(uint256) {
        return wmul(wdiv(a_,b_), decimals[token_]);
    }

    /*
    * @dev function should only be used in case of unexpected events at custodian!! 
    * It will update the system collateral value and collateral value of dpass tokens at custodian.
    * @param positiveV_ uint256 this value will be added to custodian's total dpass collateral value.
    * @param negativeV_ uint256 this value will be subtracted from custodian's total dpass collateral value.
    * @param custodian_ uint256 custodian for whom changes are made.
    */
    function setCollateralDpass(uint positiveV_, uint negativeV_, address custodian_) public auth {
        _updateCollateralDpass(positiveV_, negativeV_, custodian_);

        emit LogForceUpdateCollateralDpass(msg.sender, positiveV_, negativeV_, custodian_);
    }

    /*
    * @dev function should only be used in case of unexpected events at custodian!! 
    * It will update the system collateral value and collateral value of dcdc tokens of custodian.
    * @param positiveV_ uint256 this value will be added to custodian's total dcdc collateral value.
    * @param negativeV_ uint256 this value will be subtracted from custodian's total dcdc collateral value.
    * @param custodian_ uint256 custodian for whom changes are made.
    */
    function setCollateralDcdc(uint positiveV_, uint negativeV_, address custodian_) public auth {
        _updateCollateralDcdc(positiveV_, negativeV_, custodian_);
        emit LogForceUpdateCollateralDcdc(msg.sender, positiveV_, negativeV_, custodian_);
    }


    /**
    * @dev Set base price_ for a diamond. Base price is the total price of diamonds.
    */
    function _setBasePrice(address token_, uint256 tokenId_, uint256 price_) internal {
        bytes32 state_;
        address custodian_;
        require(dpasses[token_], "asm-invalid-token-address");
        state_ = Dpass(token_).getState(tokenId_);
        custodian_ = Dpass(token_).getCustodian(tokenId_);
        require(!custodians[msg.sender] || msg.sender == custodian_, "asm-not-authorized");

        if(Dpass(token_).ownerOf(tokenId_) == address(this) &&
          (state_ == "valid" || state_ == "sale")) {
            _updateCollateralDpass(price_, basePrice[token_][tokenId_], custodian_);
            if(block.number >= basePrice[token_][tokenId_])	//injected CONTRACT AFFECTED BY MINERS
                _requireCapCustV(custodian_);
        }

        basePrice[token_][tokenId_] = price_;
        emit LogBasePrice(msg.sender, token_, tokenId_, price_);
    }

    /*
    * @dev  Default function for eth payment. We accept ether as payment.
    */
    function () external payable {
        require(msg.value > 0, "asm-check-the-function-signature");
    }

    /*
    * @dev Burn cdc tokens and update cdc variables.
    */
    function _burn(address token_, uint256 amt_) internal {
        require(cdcs[token_], "asm-token-is-not-cdc");
        DSToken(token_).burn(amt_);
        _updateCdcV(token_);
        _updateCdcPurchaseV(token_, 0, amt_);
    }

    /**
    * @dev Get exchange rate for a token, and store it.
    */
    function _updateRate(address token_) internal returns (uint256 rate_) {
        require((rate_ = _getNewRate(token_)) > 0, "asm-updateRate-rate-gt-zero");
        rate[token_] = rate_;
    }

    /*
    * @dev updates totalCdcPurchaseV and cdcPurchaseV when addAmt_ is added, or when subAmt_ is removed from cdc_.
    */
    function _updateCdcPurchaseV(address cdc_, uint256 addAmt_, uint256 subAmt_) internal {
        uint currSupply_;
        uint prevPurchaseV_;

        if(block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS

            uint currentAddV_ = wmulV(addAmt_, _updateRate(cdc_), cdc_);
            cdcPurchaseV[cdc_] = add(cdcPurchaseV[cdc_], currentAddV_);
            totalCdcPurchaseV = add(totalCdcPurchaseV, currentAddV_);

        } else if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS

            currSupply_ = DSToken(cdc_).totalSupply();
            prevPurchaseV_ = cdcPurchaseV[cdc_];

            cdcPurchaseV[cdc_] = currSupply_ > dust ?
                wmul(
                    prevPurchaseV_,
                    wdiv(
                        currSupply_,
                        add(
                            currSupply_,
                            subAmt_)
                        )):
                0;

            totalCdcPurchaseV = sub(
                totalCdcPurchaseV,
                min(
                    sub(
                        prevPurchaseV_,
                        min(
                            cdcPurchaseV[cdc_], 
                            prevPurchaseV_)),
                    totalCdcPurchaseV));
        } else {
            require(false, "asm-add-or-sub-amount-must-be-0");
        }

        emit LogCdcPurchaseValue(totalCdcPurchaseV, cdcPurchaseV[cdc_], cdc_);
    }

    /*
    * @dev Updates totalCdcV and cdcV based on feed price of cdc token, and its total supply.
    */
    function _updateCdcV(address cdc_) internal {
        require(cdcs[cdc_], "asm-not-a-cdc-token");
        uint newValue = wmulV(DSToken(cdc_).totalSupply(), _updateRate(cdc_), cdc_);

        totalCdcV = sub(add(totalCdcV, newValue), cdcV[cdc_]);

        cdcV[cdc_] = newValue;

        emit LogCdcValue(totalCdcV, cdcV[cdc_], cdc_);
    }

    /*
    * @dev Updates totalDdcV and dcdcV based on feed price of dcdc token, and its total supply.
    */
    function _updateTotalDcdcV(address dcdc_) internal {
        require(dcdcs[dcdc_], "asm-not-a-dcdc-token");
        uint newValue = wmulV(DSToken(dcdc_).totalSupply(), _updateRate(dcdc_), dcdc_);
        totalDcdcV = sub(add(totalDcdcV, newValue), dcdcV[dcdc_]);
        dcdcV[dcdc_] = newValue;
        emit LogDcdcValue(totalDcdcV, cdcV[dcdc_], dcdc_);
    }

    /*
    * @dev Updates totalDdcCustV and dcdcCustV for a specific custodian, based on feed price of dcdc token, and its total supply.
    */
    function _updateDcdcV(address dcdc_, address custodian_) internal {
        require(dcdcs[dcdc_], "asm-not-a-dcdc-token");
        require(custodians[custodian_], "asm-not-a-custodian");
        uint newValue = wmulV(DSToken(dcdc_).balanceOf(custodian_), _updateRate(dcdc_), dcdc_);

        totalDcdcCustV[custodian_] = sub(
            add(
                totalDcdcCustV[custodian_],
                newValue),
            dcdcCustV[dcdc_][custodian_]);

        dcdcCustV[dcdc_][custodian_] = newValue;

        emit LogDcdcCustodianValue(totalDcdcCustV[custodian_], dcdcCustV[dcdc_][custodian_], dcdc_, custodian_);

        _updateTotalDcdcV(dcdc_);
    }

    /**
    * @dev Get token_ base currency rate from priceFeed
    * Revert transaction if not valid feed and manual value not allowed
    */
    function _getNewRate(address token_) private view returns (uint rate_) {
        bool feedValid;
        bytes32 usdRateBytes;

        require(
            address(0) != priceFeed[token_],                            // require token to have a price feed
            "asm-no-price-feed");

        (usdRateBytes, feedValid) =
            TrustedFeedLike(priceFeed[token_]).peek();                  // receive DPT/USD price
        if (feedValid) {                                                // if feed is valid, load DPT/USD rate from it
            rate_ = uint(usdRateBytes);
        } else {
            require(manualRate[token_], "Manual rate not allowed");     // if feed invalid revert if manualEthRate is NOT allowed
            rate_ = rate[token_];
        }
    }

    /*
    * @dev Get the total value share of custodian from the total cdc minted.
    */
    function _getCustodianCdcV(address custodian_) internal view returns(uint) {
        uint totalDpassAndDcdcV_ = add(totalDpassV, totalDcdcV);
        return wmul(
            totalCdcPurchaseV,
            totalDpassAndDcdcV_ > 0 ?
                wdiv(
                    add(
                        totalDpassCustV[custodian_],
                        totalDcdcCustV[custodian_]),
                    totalDpassAndDcdcV_):
                1 ether);
    }

    /**
    * @dev System must be overcollaterized at all time. When it is not, then no cdc can be minted.
    */
    function _requireSystemCollaterized() internal view returns(uint) {
        require(
            add(
                add(
                    totalDpassV,
                    totalDcdcV),
                dust) >=
            wmul(
                overCollRatio,
                totalCdcV)
            , "asm-system-undercollaterized");
    }

    /**
    * @dev System must be overcollaterized at all time. When total cdc value times overCollRatio is not greater but
    * equal to total dpass value plus total dcdc value: no more cdc can be minted, but since overCollRemoveRatio is
    * less than overCollRatio, diamonds still can be removed by custodians. This is very helpful for them if system
    * is low on collateral.
    */
    function _requireSystemRemoveCollaterized() internal view returns(uint) {
        require(
            add(
                add(
                    totalDpassV,
                    totalDcdcV),
                dust) >=
            wmul(
                overCollRemoveRatio,
                totalCdcV)
            , "asm-sys-remove-undercollaterized");
    }

    /**
    * @dev The total value paid to custodian (using withdraw()) must be less then the total value of current cdc 
    * share, and dpass sold.
    */
    function _requirePaidLessThanSold(address custodian_, uint256 custodianCdcV_) internal view {
        require(
            add(
                add(
                    custodianCdcV_,
                    dpassSoldCustV[custodian_]),
                dust) >=
                totalPaidCustV[custodian_],
            "asm-too-much-withdrawn");
    }

    /*
    * @dev This function will revert if custodian has reached his value cap (capCustV - custodian capacity
    * value in base currency). Asset management enables to limit how much total worth
    * of diamonds each custodian can mint. This helps to avoid overexposure to some custodians, and avoid some 
    * custodian fraud cases.
    */
    function _requireCapCustV(address custodian_) internal view {
        if(block.gaslimit != uint(-1))	//injected CONTRACT AFFECTED BY MINERS
        require(
            add(capCustV[custodian_], dust) >=
                add(
                    totalDpassCustV[custodian_],
                    totalDcdcCustV[custodian_]),
            "asm-custodian-reached-maximum-coll-value");
    }

    /*
    * @dev Updates total dpass value of a custodian, and the total dpass value.
    */
    function _updateCollateralDpass(uint positiveV_, uint negativeV_, address custodian_) internal {
        require(custodians[custodian_], "asm-not-a-custodian");

        totalDpassCustV[custodian_] = sub(
            add(
                totalDpassCustV[custodian_],
                positiveV_),
            negativeV_);

        totalDpassV = sub(
            add(
                totalDpassV,
                positiveV_),
            negativeV_);

        emit LogDpassValue(totalDpassCustV[custodian_], totalDpassV, custodian_);
    }

    /**
    * @dev Updates total dcdc customer value and total dcdc value based on custodian collateral change.
    */
    function _updateCollateralDcdc(uint positiveV_, uint negativeV_, address custodian_) internal {
        require(custodians[custodian_], "asm-not-a-custodian");

        totalDcdcCustV[custodian_] = sub(
            add(
                totalDcdcCustV[custodian_],
                positiveV_),
            negativeV_);

        totalDcdcV = sub(
            add(
                totalDcdcV,
                positiveV_),
            negativeV_);

        emit LogDcdcTotalCustodianValue(totalDcdcCustV[custodian_], totalDcdcV, custodian_);
    }

    /**
    * @dev Send token or ether to destination.
    */
    function sendToken(
        address token,
        address src,
        address payable dst,
        uint256 amount
    ) internal returns (bool){
        if (token == eth && amount > 0) {
            require(src == address(this), "wal-ether-transfer-invalid-src");
            dst.transfer(amount);
            emit LogTransferEth(src, dst, amount);
        } else {
            if (block.gaslimit > 0) DSToken(token).transferFrom(src, dst, amount);   // transfer all of token to dst	//injected CONTRACT AFFECTED BY MINERS
        }
        return true;
    }
}

////// src/Redeemer.sol
/* pragma solidity ^0.5.11; */

/* import "ds-math/math.sol"; */
/* import "ds-auth/auth.sol"; */
/* import "ds-token/token.sol"; */
/* import "ds-stop/stop.sol"; */
/* import "ds-note/note.sol"; */
/* import "./SimpleAssetManagement.sol"; */
/* import "./DiamondExchange.sol"; */
/* import "dpass/Dpass.sol"; */
/* import "./Liquidity.sol"; */

contract Redeemer is DSAuth, DSStop, DSMath {
    event LogRedeem(uint256 redeemId, address sender, address redeemToken_,uint256 redeemAmtOrId_, address feeToken_, uint256 feeAmt_, address payable custodian);
    address public eth = address(0xee);
    event LogTransferEth(address src, address dst, uint256 amount);
    event LogConfigChange(bytes32 what, bytes32 value, bytes32 value1, bytes32 value2);
    mapping(address => address) public dcdc;                 // dcdc[cdc] returns the dcdc token associated (having the same values) as cdc token
    uint256 public fixFee;                                  // Fixed part of fee charged by Cdiamondcoin from redeemToken_ in base currency
    uint256 public varFee;                                  // Variable part of fee charged by Cdiamondcoin from redeemToken_
    address public dpt;                                     // dpt token address
    SimpleAssetManagement public asm;                       // asset management contract
    DiamondExchange public dex;
    address payable public liq;                             // liquidity providing contract address
    bool public liqBuysDpt;                                 // true if liquidity contract buys dpt on the fly, false otherwise
    address payable public burner;                          // burner contract to take dpt owners' profit
    address payable wal;                                    // wallet to receive the operational costs
    uint public profitRate;                                 // profit that is sent from fees to dpt owners
    bool locked;                                            // variable to avoid reentrancy attacks against this contract
    uint redeemId;                                          // id of the redeem transaction user can refer to
    uint dust = 1000;                                       // dust value to handle round-off errors

    bytes32 public name = "Red";                            // set human readable name for contract
    bytes32 public symbol = "Red";                          // set human readable name for contract
    bool kycEnabled;                                        // if true then user must be on the kyc list in order to use the system
    mapping(address => bool) public kyc;                    // kyc list of users that are allowed to exchange tokens

    modifier nonReentrant {
        require(!locked, "red-reentrancy-detected");
        locked = true;
        _;
        locked = false;
    }

    modifier kycCheck(address sender) {
        require(!kycEnabled || kyc[sender], "red-you-are-not-on-kyc-list");
        _;
    }

    function () external payable {
    }

    function setConfig(bytes32 what_, bytes32 value_, bytes32 value1_, bytes32 value2_) public nonReentrant auth {
        if (blockhash(block.number) == "asm") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "red-zero-asm-address");

            asm = SimpleAssetManagement(address(uint160(addr(value_))));

        } else if (blockhash(block.number) == "fixFee") {	//injected CONTRACT AFFECTED BY MINERS

            fixFee = uint256(value_);

        } else if (blockhash(block.number) == "varFee") {	//injected CONTRACT AFFECTED BY MINERS

            varFee = uint256(value_);
            require(varFee <= 1 ether, "red-var-fee-too-high");

        } else if (blockhash(block.number) == "kyc") {	//injected CONTRACT AFFECTED BY MINERS

            address user_ = addr(value_);

            require(user_ != address(0x0), "red-wrong-address");

            kyc[user_] = uint(value1_) > 0;
        } else if (blockhash(block.number) == "dex") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "red-zero-red-address");

            dex = DiamondExchange(address(uint160(addr(value_))));

        } else if (blockhash(block.number) == "burner") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "red-wrong-address");

            burner = address(uint160(addr(value_)));

        } else if (blockhash(block.number) == "wal") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "red-wrong-address");

            wal = address(uint160(addr(value_)));

        } else if (blockhash(block.number) == "profitRate") {	//injected CONTRACT AFFECTED BY MINERS

            profitRate = uint256(value_);

            require(profitRate <= 1 ether, "red-profit-rate-out-of-range");

        } else if (blockhash(block.number) == "dcdcOfCdc") {	//injected CONTRACT AFFECTED BY MINERS

            require(address(asm) != address(0), "red-setup-asm-first");

            address cdc_ = addr(value_);
            address dcdc_ = addr(value1_);

            require(asm.cdcs(cdc_), "red-setup-cdc-in-asm-first");
            require(asm.dcdcs(dcdc_), "red-setup-dcdc-in-asm-first");

            dcdc[cdc_] = dcdc_;
        } else if (blockhash(block.number) == "dpt") {	//injected CONTRACT AFFECTED BY MINERS

            dpt = addr(value_);

            require(dpt != address(0x0), "red-wrong-address");

        } else if (blockhash(block.number) == "liqBuysDpt") {	//injected CONTRACT AFFECTED BY MINERS

            require(liq != address(0x0), "red-wrong-address");

            Liquidity(address(uint160(liq))).burn(dpt, address(uint160(burner)), 0);                // check if liq does have the proper burn function

            liqBuysDpt = uint256(value_) > 0;

        } else if (blockhash(block.number) == "liq") {	//injected CONTRACT AFFECTED BY MINERS

            liq = address(uint160(addr(value_)));

            require(liq != address(0x0), "red-wrong-address");

            require(dpt != address(0), "red-add-dpt-token-first");

            require(
                TrustedDSToken(dpt).balanceOf(liq) > 0,
                "red-insufficient-funds-of-dpt");

            if(liqBuysDpt) {

                Liquidity(liq).burn(dpt, burner, 0);            // check if liq does have the proper burn function
            }

        } else if (blockhash(block.number) == "kycEnabled") {	//injected CONTRACT AFFECTED BY MINERS

            kycEnabled = uint(value_) > 0;

        } else if (blockhash(block.number) == "dust") {	//injected CONTRACT AFFECTED BY MINERS
            dust = uint256(value_);
            require(dust <= 1 ether, "red-pls-decrease-dust");
        } else {
            require(false, "red-invalid-option");
        }
        emit LogConfigChange(what_, value_, value1_, value2_);
    }

    /*
    * @dev Convert address to bytes32
    */
    function addr(bytes32 b_) public pure returns (address) {
        return address(uint256(b_));
    }

    /*
    * @dev Pay redeem costs and redeem for diamond. Using this funcitn is non-reversible.
    * @param sender_ address ethereum account of user who wants to redeem
    * @param redeemToken_ address token address that user wants to redeem token can be both 
    * dpass and cdc tokens
    * @param redeemAmtOrId_ uint256 if token is cdc then represents amount, and if dpass then id of diamond
    * @param feeToken_ address token to pay fee with. This token can only be erc20.
    * @param feeAmt_ uint256 amount of token to be paid as redeem fee.
    * @param custodian_ address custodian to get diamond from. If token is dpass, then custodian must match 
    * the custodian of dpass token id, if cdc then any custodian can be who has enough matching dcdc tokens.
    */
    function redeem(
        address sender,
        address redeemToken_,
        uint256 redeemAmtOrId_,
        address feeToken_,
        uint256 feeAmt_,
        address payable custodian_
    ) public payable stoppable nonReentrant kycCheck(sender) returns (uint256) {

        require(feeToken_ != eth || feeAmt_ == msg.value, "red-eth-not-equal-feeamt");
        if( asm.dpasses(redeemToken_) ) {

            Dpass(redeemToken_).redeem(redeemAmtOrId_);
            require(custodian_ == address(uint160(Dpass(redeemToken_).getCustodian(redeemAmtOrId_))), "red-wrong-custodian-provided");

        } else if ( asm.cdcs(redeemToken_) ) {

            require(
                DSToken(dcdc[redeemToken_])
                    .balanceOf(custodian_) >
                redeemAmtOrId_,
                "red-custodian-has-not-enough-cdc");

            require(redeemAmtOrId_ % 10 ** DSToken(redeemToken_).decimals() == 0, "red-cdc-integer-value-pls");

            DSToken(redeemToken_).transfer(address(asm), redeemAmtOrId_);     // cdc token sent to asm to be burned

            asm.notifyTransferFrom(                         // burn cdc token at asm
                redeemToken_,
                address(this),
                address(asm),
                redeemAmtOrId_);

        } else {
            require(false, "red-token-nor-cdc-nor-dpass");
        }

        uint feeToCustodian_ = _sendFeeToCdiamondCoin(redeemToken_, redeemAmtOrId_, feeToken_, feeAmt_);

        _sendToken(feeToken_, address(this), custodian_, feeToCustodian_);

        emit LogRedeem(++redeemId, sender, redeemToken_, redeemAmtOrId_, feeToken_, feeAmt_, custodian_);

        return redeemId;
    }

    /**
    * @dev Put user on whitelist to redeem diamonds.
    * @param user_ address the ethereum account to enable
    * @param enable_ bool if true enables, otherwise disables user to use redeem
    */
    function setKyc(address user_, bool enable_) public auth {
        setConfig(
            "kyc",
            bytes32(uint(user_)), 
            enable_ ? bytes32(uint(1)) : bytes32(uint(0)),
            "");
    }

    /**
    * @dev send token or ether to destination
    */
    function _sendFeeToCdiamondCoin(
        address redeemToken_,
        uint256 redeemAmtOrId_,
        address feeToken_,
        uint256 feeAmt_
    ) internal returns (uint feeToCustodianT_){

        uint profitV_;
        uint redeemTokenV_ = _calcRedeemTokenV(redeemToken_, redeemAmtOrId_);

        uint feeT_ = _getFeeT(feeToken_, redeemTokenV_);

        uint profitT_ = wmul(profitRate, feeT_);

        if( block.coinbase == dpt) {	//injected CONTRACT AFFECTED BY MINERS

            DSToken(feeToken_).transfer(burner, profitT_);
            DSToken(feeToken_).transfer(wal, sub(feeT_, profitT_));

        } else {

            profitV_ = dex.wmulV(profitT_, dex.getLocalRate(feeToken_), feeToken_);

            if(liqBuysDpt) {
                Liquidity(liq).burn(dpt, burner, profitV_);
            } else {
                DSToken(dpt).transferFrom(
                    liq,
                    burner,
                    dex.wdivT(profitV_, dex.getLocalRate(dpt), dpt));
            }
            _sendToken(feeToken_, address(this), wal, feeT_);
        }

        require(add(feeAmt_,dust) >= feeT_, "red-not-enough-fee-sent");
        feeToCustodianT_ = sub(feeAmt_, feeT_);
    }

    /**
    * @dev Calculate costs for redeem. These are only concerning the fees the system charges.
    * Delivery costs charged by custodians are additional to these and must be added to the i
    * cost returned here.
    * @param redeemToken_ address token that will be redeemed. Cdc or dpass token address required.
    * @param redeemAmtOrId_ uint256 amount of token to be redeemed
    * @param feeToken_ address token that will be used to pay fee.
    * @return amount of fee token that must be sent as fee to system. Above this value users must 
    * add the handling fee of custodians to have a successfull redeem.
    */
    function getRedeemCosts(address redeemToken_, uint256 redeemAmtOrId_, address feeToken_) public view returns(uint feeT_) {
            require(asm.dpasses(redeemToken_) || redeemAmtOrId_ % 10 ** DSToken(redeemToken_).decimals() == 0, "red-cdc-integer-value-pls");
        uint redeemTokenV_ = _calcRedeemTokenV(redeemToken_, redeemAmtOrId_);
        feeT_ = _getFeeT(feeToken_, redeemTokenV_);
    }

    /**
    * @dev Calculdate the base currency value of redeem token if it is an erc20 or if it is an erc721 token.
    */
    function _calcRedeemTokenV(address redeemToken_, uint256 redeemAmtOrId_) internal view returns(uint redeemTokenV_) {
        if(asm.dpasses(redeemToken_)) {
            redeemTokenV_ = asm.basePrice(redeemToken_, redeemAmtOrId_);
        } else {
            redeemTokenV_ = dex.wmulV(
                redeemAmtOrId_,
                dex.getLocalRate(redeemToken_),
                redeemToken_);
        }
    }

    /**
    * @dev Calculate  amount of feeTokens to be paid as fee.
    */
    function _getFeeT(address feeToken_, uint256 redeemTokenV_) internal view returns (uint) {
        return 
            dex.wdivT(
                add(
                    wmul(
                        varFee,
                        redeemTokenV_),
                    fixFee),
                dex.getLocalRate(feeToken_),
                feeToken_);
    }

    /**
    * @dev send token or ether to destination.
    */
    function _sendToken(
        address token,
        address src,
        address payable dst,
        uint256 amount
    ) internal returns (bool){
        if (token == eth && amount > 0) {
            require(src == address(this), "wal-ether-transfer-invalid-src");
            dst.transfer(amount);
            emit LogTransferEth(src, dst, amount);
        } else {
            if (block.timestamp > 0) DSToken(token).transferFrom(src, dst, amount);   // transfer all of token to dst	//injected CONTRACT AFFECTED BY MINERS
        }
        return true;
    }
}

////// src/DiamondExchange.sol
/* pragma solidity ^0.5.11; */

/* import "ds-auth/auth.sol"; */
/* import "ds-token/token.sol"; */
/* import "ds-stop/stop.sol"; */
/* import "./Liquidity.sol"; */
/* import "dpass/Dpass.sol"; */
/* import "./Redeemer.sol"; */

/**
* @dev Interface to get ETH/USD price
*/
contract TrustedFeedLikeDex {
    function peek() external view returns (bytes32, bool);
}



/**
* @dev Interface to calculate user fee based on amount
*/
contract TrustedFeeCalculator {

    function calculateFee(
        address sender,
        uint256 value,
        address sellToken,
        uint256 sellAmtOrId,
        address buyToken,
        uint256 buyAmtOrId
    ) external view returns (uint);

    function getCosts(
        address user,                                                           // user for whom we want to check the costs for
        address sellToken_,
        uint256 sellId_,
        address buyToken_,
        uint256 buyAmtOrId_
    ) public view returns (uint256 sellAmtOrId_, uint256 feeDpt_, uint256 feeV_, uint256 feeSellT_) {
        // calculate expected sell amount when user wants to buy something anc only knows how much he wants to buy from a token and whishes to know how much it will cost.
    }
}

/**
* @dev Interface to do redeeming of tokens
*/
contract TrustedRedeemer {

function redeem(
    address sender,
    address redeemToken_,
    uint256 redeemAmtOrId_,
    address feeToken_,
    uint256 feeAmt_,
    address payable custodian_
) public payable returns (uint256);

}

/**
* @dev Interface for managing diamond assets
*/
contract TrustedAsm {
    function notifyTransferFrom(address token, address src, address dst, uint256 id721) external;
    function basePrice(address erc721, uint256 id721) external view returns(uint256);
    function getAmtForSale(address token) external view returns(uint256);
    function mint(address token, address dst, uint256 amt) external;
}


/**
* @dev Interface ERC721 contract
*/
contract TrustedErc721 {
    function transferFrom(address src, address to, uint256 amt) external;
    function ownerOf(uint256 tokenId) external view returns (address);
}


/**
* @dev Interface for managing diamond assets
*/
contract TrustedDSToken {
    function transferFrom(address src, address dst, uint wad) external returns (bool);
    function totalSupply() external view returns (uint);
    function balanceOf(address src) external view returns (uint);
    function allowance(address src, address guy) external view returns (uint);
}


/**
 * @dev Diamond Exchange contract for events.
 */
contract DiamondExchangeEvents {

    event LogBuyTokenWithFee(
        uint256 indexed txId,
        address indexed sender,
        address custodian20,
        address sellToken,
        uint256 sellAmountT,
        address buyToken,
        uint256 buyAmountT,
        uint256 feeValue
    );

    event LogConfigChange(bytes32 what, bytes32 value, bytes32 value1);

    event LogTransferEth(address src, address dst, uint256 val);
}

/**
 * @title Diamond Exchange contract
 * @dev This contract can exchange ERC721 tokens and ERC20 tokens as well. Primary
 * usage is to buy diamonds or buying diamond backed stablecoins.
 */
contract DiamondExchange is DSAuth, DSStop, DiamondExchangeEvents {
    TrustedDSToken public cdc;                              // CDC token contract
    address public dpt;                                     // DPT token contract

    mapping(address => uint256) private rate;               // exchange rate for a token
    mapping(address => uint256) public smallest;            // set minimum amount of sellAmtOrId_
    mapping(address => bool) public manualRate;             // manualRate is allowed for a token (if feed invalid)

    mapping(address => TrustedFeedLikeDex)
    public priceFeed;                                       // price feed address for token

    mapping(address => bool) public canBuyErc20;            // stores allowed ERC20 tokens to buy
    mapping(address => bool) public canSellErc20;           // stores allowed ERC20 tokens to sell
    mapping(address => bool) public canBuyErc721;           // stores allowed ERC20 tokens to buy
    mapping(address => bool) public canSellErc721;          // stores allowed ERC20 tokens to sell
    mapping(address => mapping(address => bool))            // stores tokens that seller does not accept, ...
        public denyToken;                                   // ... and also token pairs that can not be traded
    mapping(address => uint) public decimals;               // stores decimals for each ERC20 token
    mapping(address => bool) public decimalsSet;            // stores if decimals were set for ERC20 token
    mapping(address => address payable) public custodian20; // custodian that holds an ERC20 token for Exchange
    mapping(address => bool) public handledByAsm;           // defines if token is managed by Asset Management
    mapping(
        address => mapping(
            address => mapping(
                uint => uint))) public buyPrice;            // buyPrice[token][owner][tokenId] price of dpass token ...
                                                            // ... defined by owner of dpass token
    mapping(address => bool) redeemFeeToken;                // tokens allowed to pay redeem fee with
    TrustedFeeCalculator public fca;                        // fee calculator contract

    address payable public liq;                             // contract providing DPT liquidity to pay for fee
    address payable public wal;                             // wallet address, where we keep all the tokens we received as fee
    address public burner;                                  // contract where accured fee of DPT is stored before being burned
    TrustedAsm public asm;                                  // Asset Management contract
    uint256 public fixFee;                                  // Fixed part of fee charged for buying 18 decimals precision in base currency
    uint256 public varFee;                                  // Variable part of fee charged for buying 18 decimals precision in base currency
    uint256 public profitRate;                              // the percentage of profit that is burned on all fees received. ...
                                                            // ... 18 decimals precision
    uint256 public callGas = 2500;                          // using this much gas when Ether is transferred
    uint256 public txId;                                    // Unique id of each transaction.
    bool public takeProfitOnlyInDpt = true;                 // If true, it takes cost + profit in DPT, if false only profit in DPT

    uint256 public dust = 10000;                            // Numbers below this amount are considered 0. Can only be used ...
    bytes32 public name = "Dex";                            // set human readable name for contract
    bytes32 public symbol = "Dex";                          // set human readable name for contract
                                                            // ... along with 18 decimal precisions numbers.

    bool liqBuysDpt;                                        // if true then liq contract is called directly to buy necessary dpt, otherwise we...
                                                            // ... just send DPT from liq contracts address to burner.

    bool locked;                                            // protect against reentrancy attacks
    address eth = address(0xee);                            // to handle ether the same way as tokens we associate a fake address to it
    bool kycEnabled;                                        // if true then user must be on the kyc list in order to use the system
    mapping(address => bool) public kyc;                    // kyc list of users that are allowed to exchange tokens
    address payable public redeemer;                        // redeemer contract to handle physical diamond delivery to users

//-----------included-from-ds-math---------------------------------begin
    uint constant WAD = 1 ether;

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
//-----------included-from-ds-math---------------------------------end

    modifier nonReentrant {
        require(!locked, "dex-reentrancy-detected");
        locked = true;
        _;
        locked = false;
    }

    modifier kycCheck {
        require(!kycEnabled || kyc[msg.sender], "dex-you-are-not-on-kyc-list");
        _;
    }

    /**
    * @dev Fallback function to buy tokens.
    */
    function () external payable {
        buyTokensWithFee(eth, msg.value, address(cdc), uint(-1));
    }

    /**
    * @dev Set configuration values for contract. Instead of several small functions
    * that bloat the abi, this monolitic function can be used to configure Diamond i
    * Exchange contract.
    * @param what_ bytes32 determines what change the owner(contract) wants to make.
    * @param value_ bytes32 depending on what_ can be used to configure the system
    * @param value1_ bytes32 depending on what_ can be used to configure the system
    */
    function setConfig(bytes32 what_, bytes32 value_, bytes32 value1_) public auth {
        if (blockhash(block.number) == "profitRate") {	//injected CONTRACT AFFECTED BY MINERS

            profitRate = uint256(value_);

            require(profitRate <= 1 ether, "dex-profit-rate-out-of-range");

        } else if (blockhash(block.number) == "rate") {	//injected CONTRACT AFFECTED BY MINERS
            address token = addr(value_);
            uint256 value = uint256(value1_);

            require(
                canSellErc20[token] ||
                canBuyErc20[token],
                "dex-token-not-allowed-rate");

            require(value > 0, "dex-rate-must-be-greater-than-0");

            rate[token] = value;

        } else if (blockhash(block.number) == "kyc") {	//injected CONTRACT AFFECTED BY MINERS

            address user_ = addr(value_);

            require(user_ != address(0x0), "dex-wrong-address");

            kyc[user_] = uint(value1_) > 0;
        } else if (blockhash(block.number) == "allowTokenPair") {	//injected CONTRACT AFFECTED BY MINERS

            address sellToken_ = addr(value_);
            address buyToken_ = addr(value1_);

            require(canSellErc20[sellToken_] || canSellErc721[sellToken_],
                "dex-selltoken-not-listed");
            require(canBuyErc20[buyToken_] || canBuyErc721[buyToken_],
                "dex-buytoken-not-listed");

            denyToken[sellToken_][buyToken_] = false;
        } else if (blockhash(block.number) == "denyTokenPair") {	//injected CONTRACT AFFECTED BY MINERS

            address sellToken_ = addr(value_);
            address buyToken_ = addr(value1_);

            require(canSellErc20[sellToken_] || canSellErc721[sellToken_],
                "dex-selltoken-not-listed");
            require(canBuyErc20[buyToken_] || canBuyErc721[buyToken_],
                "dex-buytoken-not-listed");

            denyToken[sellToken_][buyToken_] = true;
        } else if (blockhash(block.number) == "fixFee") {	//injected CONTRACT AFFECTED BY MINERS

            fixFee = uint256(value_);

        } else if (blockhash(block.number) == "varFee") {	//injected CONTRACT AFFECTED BY MINERS

            varFee = uint256(value_);

            require(varFee <= 1 ether, "dex-var-fee-too-high");

        } else if (blockhash(block.number) == "redeemFeeToken") {	//injected CONTRACT AFFECTED BY MINERS

            address token = addr(value_);
            require(token != address(0), "dex-zero-address-redeemfee-token");
            redeemFeeToken[token] = uint256(value1_) > 0;

        } else if (blockhash(block.number) == "manualRate") {	//injected CONTRACT AFFECTED BY MINERS

            address token = addr(value_);

            require(
                canSellErc20[token] ||
                canBuyErc20[token],
                "dex-token-not-allowed-manualrate");

            manualRate[token] = uint256(value1_) > 0;

        } else if (blockhash(block.number) == "priceFeed") {	//injected CONTRACT AFFECTED BY MINERS

            require(canSellErc20[addr(value_)] || canBuyErc20[addr(value_)],
                "dex-token-not-allowed-pricefeed");

            require(addr(value1_) != address(address(0x0)),
                "dex-wrong-pricefeed-address");

            priceFeed[addr(value_)] = TrustedFeedLikeDex(addr(value1_));

        } else if (blockhash(block.number) == "takeProfitOnlyInDpt") {	//injected CONTRACT AFFECTED BY MINERS

            takeProfitOnlyInDpt = uint256(value_) > 0;

        } else if (blockhash(block.number) == "liqBuysDpt") {	//injected CONTRACT AFFECTED BY MINERS

            require(liq != address(0x0), "dex-wrong-address");

            Liquidity(liq).burn(dpt, burner, 0);                // check if liq does have the proper burn function

            liqBuysDpt = uint256(value_) > 0;

        } else if (blockhash(block.number) == "liq") {	//injected CONTRACT AFFECTED BY MINERS

            liq = address(uint160(addr(value_)));

            require(liq != address(0x0), "dex-wrong-address");

            require(dpt != address(0), "dex-add-dpt-token-first");

            require(
                TrustedDSToken(dpt).balanceOf(liq) > 0,
                "dex-insufficient-funds-of-dpt");

            if(liqBuysDpt) {

                Liquidity(liq).burn(dpt, burner, 0);            // check if liq does have the proper burn function
            }

        } else if (blockhash(block.number) == "handledByAsm") {	//injected CONTRACT AFFECTED BY MINERS

            address token = addr(value_);

            require(canBuyErc20[token] || canBuyErc721[token],
                    "dex-token-not-allowed-handledbyasm");

            handledByAsm[token] = uint256(value1_) > 0;

        } else if (blockhash(block.number) == "asm") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            asm = TrustedAsm(addr(value_));

        } else if (blockhash(block.number) == "burner") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            burner = address(uint160(addr(value_)));

        } else if (blockhash(block.number) == "cdc") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            cdc = TrustedDSToken(addr(value_));

        } else if (blockhash(block.number) == "fca") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            fca = TrustedFeeCalculator(addr(value_));

        } else if (blockhash(block.number) == "custodian20") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            custodian20[addr(value_)] = address(uint160(addr(value1_)));

        } else if (blockhash(block.number) == "smallest") {	//injected CONTRACT AFFECTED BY MINERS
            address token = addr(value_);
            uint256 value = uint256(value1_);

            require(
                canSellErc20[token] ||
                canBuyErc20[token],
                "dex-token-not-allowed-small");

            smallest[token] = value;

        } else if (blockhash(block.number) == "decimals") {	//injected CONTRACT AFFECTED BY MINERS

            address token_ = addr(value_);

            require(token_ != address(0x0), "dex-wrong-address");

            uint decimal = uint256(value1_);

            decimals[token_] = 10 ** decimal;

            decimalsSet[token_] = true;

        } else if (blockhash(block.number) == "wal") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            wal = address(uint160(addr(value_)));

        } else if (blockhash(block.number) == "callGas") {	//injected CONTRACT AFFECTED BY MINERS

            callGas = uint256(value_);

        } else if (blockhash(block.number) == "dust") {	//injected CONTRACT AFFECTED BY MINERS

            dust = uint256(value_);

        } else if (blockhash(block.number) == "canBuyErc20") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            require(decimalsSet[addr(value_)], "dex-buytoken-decimals-not-set");

            canBuyErc20[addr(value_)] = uint(value1_) > 0;

        } else if (blockhash(block.number) == "canSellErc20") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            require(decimalsSet[addr(value_)], "dex-selltoken-decimals-not-set");

            canSellErc20[addr(value_)] = uint(value1_) > 0;

        } else if (blockhash(block.number) == "canBuyErc721") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            canBuyErc721[addr(value_)] = uint(value1_) > 0;

        } else if (blockhash(block.number) == "canSellErc721") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-address");

            canSellErc721[addr(value_)] = uint(value1_) > 0;

        } else if (blockhash(block.number) == "kycEnabled") {	//injected CONTRACT AFFECTED BY MINERS

            kycEnabled = uint(value_) > 0;

        } else if (blockhash(block.number) == "dpt") {	//injected CONTRACT AFFECTED BY MINERS

            dpt = addr(value_);

            require(dpt != address(0x0), "dex-wrong-address");

            require(decimalsSet[dpt], "dex-dpt-decimals-not-set");

        } else if (blockhash(block.number) == "redeemer") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dex-wrong-redeemer-address");

            redeemer = address(uint160(addr(value_)));

        } else {
            value1_;
            require(false, "dex-no-such-option");
        }

        emit LogConfigChange(what_, value_, value1_);
    }

    /**
    * @dev Redeem token and pay fee for redeem.
    * @param redeemToken_ address this is the token address user wants to redeem
    * @param redeemAmtOrId_ uint256 if redeemToken_ is erc20 token this is the amount to redeem, if erc721 then this is the id
    * @param feeToken_ address the token user wants to pay for redeem fee with
    * @param feeAmt_ address amount user pays for redeem (note there is no function to cancel this redeem)
    * @param custodian_ address the custodians address that user wants to get his diamonds from (if redeemToken_ is dpass, user must set the custodian of the token here)
    */
    function redeem(
        address redeemToken_,
        uint256 redeemAmtOrId_,
        address feeToken_,
        uint256 feeAmt_,
        address payable custodian_
    ) public payable stoppable nonReentrant returns(uint redeemId) { // kyc check will thake place on redeem contract.

        require(redeemFeeToken[feeToken_] || feeToken_ == dpt, "dex-token-not-to-pay-redeem-fee");

        if(canBuyErc721[redeemToken_] || canSellErc721[redeemToken_]) {

            Dpass(redeemToken_)                                // transfer token to redeemer
            .transferFrom(
                msg.sender,
                redeemer,
                redeemAmtOrId_);

        } else if (canBuyErc20[redeemToken_] || canSellErc20[redeemToken_]) {

            _sendToken(redeemToken_, msg.sender, redeemer, redeemAmtOrId_);

        } else {
            require(false, "dex-token-can-not-be-redeemed");
        }

        if(block.coinbase == eth) {	//injected CONTRACT AFFECTED BY MINERS

            return TrustedRedeemer(redeemer)
                .redeem
                .value(msg.value)
                (msg.sender, redeemToken_, redeemAmtOrId_, feeToken_, feeAmt_, custodian_);

        } else {

            _sendToken(feeToken_, msg.sender, redeemer, feeAmt_);

            return TrustedRedeemer(redeemer)
            .redeem(msg.sender, redeemToken_, redeemAmtOrId_, feeToken_, feeAmt_, custodian_);
        }
    }

    /**
    * @dev 1oken purchase with fee. (If user has DPT he must approve this contract,
    * otherwise transaction will fail.)
    * @param sellToken_ address token user wants to sell
    * @param sellAmtOrId_ uint256 if sellToken_ is erc20 token then this is the amount (if set to highest possible, it means user wants to exchange all necessary tokens in his posession to buy the buyToken_), if token is Dpass(erc721) token, then this is the tokenId
    * @param buyToken_ address token user wants to buy
    * @param buyAmtOrId_ uint256 if buyToken_ is erc20, then this is the amount(setting highest integer will make buy as much buyTokens: as possible), and it is tokenId otherwise
    */
    function buyTokensWithFee (
        address sellToken_,
        uint256 sellAmtOrId_,
        address buyToken_,
        uint256 buyAmtOrId_
    ) public payable stoppable nonReentrant kycCheck {
        uint buyV_;
        uint sellV_;
        uint feeV_;
        uint sellT_;
        uint buyT_;

        require(!denyToken[sellToken_][buyToken_], "dex-cant-use-this-token-to-buy");
        require(smallest[sellToken_] <= sellAmtOrId_, "dex-trade-value-too-small");

        _updateRates(sellToken_, buyToken_);    // update currency rates

        (buyV_, sellV_) = _getValues(           // calculate highest possible buy and sell values (here they might not match)
            sellToken_,
            sellAmtOrId_,
            buyToken_,
            buyAmtOrId_);

        feeV_ = calculateFee(                   // calculate fee user has to pay for exchange
            msg.sender,
            min(buyV_, sellV_),
            sellToken_,
            sellAmtOrId_,
            buyToken_,
            buyAmtOrId_);

        (sellT_, buyT_) = _takeFee(             // takes the calculated fee from user in DPT or sellToken_ ...
            feeV_,                              // ... calculates final sell and buy values (in base currency)
            sellV_,
            buyV_,
            sellToken_,
            sellAmtOrId_,
            buyToken_,
            buyAmtOrId_);

        _transferTokens(                        // transfers tokens to user and seller
            sellT_,
            buyT_,
            sellToken_,
            sellAmtOrId_,
            buyToken_,
            buyAmtOrId_,
            feeV_);
    }

    /**
    * @dev Get sell and buy token values in base currency
    */
    function _getValues(
        address sellToken_,
        uint256 sellAmtOrId_,
        address buyToken_,
        uint256 buyAmtOrId_
    ) internal returns (uint256 buyV, uint256 sellV) {
        uint sellAmtT_ = sellAmtOrId_;
        uint buyAmtT_ = buyAmtOrId_;
        uint maxT_;

        require(buyToken_ != eth, "dex-we-do-not-sell-ether");          // we can not sell Ether with this smart contract currently
        require(sellToken_ == eth || msg.value == 0,                    // we don't accept ETH if user wants to sell other token
                "dex-do-not-send-ether");

        if (canSellErc20[sellToken_]) {                                 // if sellToken_ is a valid ERC20 token

            maxT_ = sellToken_ == eth ?
                msg.value :
                min(
                    TrustedDSToken(sellToken_).balanceOf(msg.sender),
                    TrustedDSToken(sellToken_).allowance(
                        msg.sender, address(this)));

            require(maxT_ > 0, "dex-please-approve-us");

            require(
                sellToken_ == eth ||                                    // disregard Ether
                sellAmtOrId_ == uint(-1) ||                             // disregard uint(-1) as it has a special meaning
                sellAmtOrId_ <= maxT_,                                  // sellAmtOrId_ should be less then sellToken_ available to this contract
                "dex-sell-amount-exceeds-allowance");

            require(
                sellToken_ != eth ||                                    // regard Ether only
                sellAmtOrId_ == uint(-1) ||                             // disregard uint(-1) as it has a special meaning
                sellAmtOrId_ <= msg.value,                              // sellAmtOrId_ sold should be less than the Ether we received from user
                "dex-sell-amount-exceeds-ether-value");

            if (block.gaslimit > maxT_ ) {                                   // if user wants to sell maxTimum possible	//injected CONTRACT AFFECTED BY MINERS

                sellAmtT_ = maxT_;
            }

            sellV = wmulV(sellAmtT_, rate[sellToken_], sellToken_);     // sell value in base currency

        } else if (canSellErc721[sellToken_]) {                         // if sellToken_ is a valid ERC721 token

            sellV = getPrice(sellToken_, sellAmtOrId_);                 // get price from Asset Management

        } else {

            require(false, "dex-token-not-allowed-to-be-sold");

        }

        if (canBuyErc20[buyToken_]) {                                   // if buyToken_ is a valid ERC20 token

            maxT_ = handledByAsm[buyToken_] ?                           // set buy amount to maxT_ possible
                asm.getAmtForSale(buyToken_) :                          // if managed by asset management get available
                min(                                                    // if not managed by asset management get maxT_ available
                    TrustedDSToken(buyToken_).balanceOf(
                        custodian20[buyToken_]),
                    TrustedDSToken(buyToken_).allowance(
                        custodian20[buyToken_], address(this)));

            require(maxT_ > 0, "dex-0-token-is-for-sale");

            require(                                                    // require token's buy amount to be less or equal than available to us
                buyToken_ == eth ||                                     // disregard Ether
                buyAmtOrId_ == uint(-1) ||                              // disregard uint(-1) as it has a special meaning
                buyAmtOrId_ <= maxT_,                                   // amount must be less or equal that maxT_ available
                "dex-buy-amount-exceeds-allowance");

            if (block.gaslimit > maxT_) {                                  // user wants to buy the maxTimum possible	//injected CONTRACT AFFECTED BY MINERS

                buyAmtT_ = maxT_;
            }

            buyV = wmulV(buyAmtT_, rate[buyToken_], buyToken_);         // final buy value in base currency

        } else if (canBuyErc721[buyToken_]) {                           // if buyToken_ is a valid ERC721 token

            require(canSellErc20[sellToken_],                           // require that at least one of sell and buy token is ERC20
                    "dex-one-of-tokens-must-be-erc20");

            buyV = getPrice(                                            // calculate price with Asset Management contract
                buyToken_,
                buyAmtOrId_);

        } else {
            require(false, "dex-token-not-allowed-to-be-bought");       // token can not be bought here
        }
    }

    /**
    * @dev Calculate fee locally or using an external smart contract
    * @return the fee amount in base currency
    * @param sender_ address user we want to get the fee for
    * @param value_ uint256 base currency value of transaction for which the fee will be derermined
    * @param sellToken_ address token to be sold by user
    * @param sellAmtOrId_ uint256 amount or id of token
    * @param buyToken_ address token to be bought by user
    * @param buyAmtOrId_ uint256 amount or id of buytoken
    */
    function calculateFee(
        address sender_,
        uint256 value_,
        address sellToken_,
        uint256 sellAmtOrId_,
        address buyToken_,
        uint256 buyAmtOrId_
    ) public view returns (uint256) {

        if (fca == TrustedFeeCalculator(0)) {

            return add(fixFee, wmul(varFee, value_));                       // calculate proportional fee locally

        } else {

            return fca.calculateFee(                                    // calculate fee using external smart contract
                sender_,
                value_,
                sellToken_,
                sellAmtOrId_,
                buyToken_,
                buyAmtOrId_);
        }
    }

    /**
    * @dev Taking feeV_ from user. If user has DPT takes it, if there is none buys it for user.
    * @return the amount of remaining ETH after buying feeV_ if it was required
    */
    function _takeFee(
        uint256 feeV_,
        uint256 sellV_,
        uint256 buyV_,
        address sellToken_,
        uint256 sellAmtOrId_,
        address buyToken_,
        uint256 buyAmtOrId_
    )
    internal
    returns(uint256 sellT, uint256 buyT) {
        uint feeTakenV_;
        uint amtT_;
        address token_;
        address src_;
        uint restFeeV_;

        feeTakenV_ = sellToken_ != dpt ?                            // if sellToken_ is not dpt then try to take feeV_ in DPT
            min(_takeFeeInDptFromUser(feeV_), feeV_) :
            0;

        restFeeV_ = sub(feeV_, feeTakenV_);

        if (feeV_ - feeTakenV_ > dust                               // if we could not take all fees from user in ...
            && feeV_ - feeTakenV_ <= feeV_) {                       // ... DPT (with round-off errors considered)

            if (canSellErc20[sellToken_]) {

                require(
                    canBuyErc20[buyToken_] ||                       // apply rule below to ERC721 buyTokens only
                    sellV_ + dust >=                                // for erc721 buy tokens the sellValue must be buyValue plus restFeeV_
                        buyV_ + restFeeV_,
                    "dex-not-enough-user-funds-to-sell");

                token_ = sellToken_;                                // fees are sent in this token_
                src_ = msg.sender;                                  // owner of token_ is sender
                amtT_ = sellAmtOrId_;                               // max amount user wants to sell

                if (block.number <                             // if buy value is too big	//injected CONTRACT AFFECTED BY MINERS
                    add(buyV_, restFeeV_)) {

                    buyV_ = sub(sellV_, restFeeV_);                 // buyValue is adjusted
                }

                sellV_ = buyV_;                                     // reduce sellValue to buyValue plus restFeeV_

            } else if (canBuyErc20[buyToken_]) {                    // if sellToken_ is an ERC721 token_ and buyToken_ is an ERC20 token_
                require(
                    sellV_ <= buyV_ + dust,                         // check if user can be supplied with enough buy tokens
                    "dex-not-enough-tokens-to-buy");


                token_ = buyToken_;                                 // fees are paid in buy token_

                src_ = custodian20[token_];                         // source of funds is custodian

                amtT_ = buyAmtOrId_;                                // max amount the user intended to buy

                if (block.timestamp <= add(add(buyV_, restFeeV_), dust))	//injected CONTRACT AFFECTED BY MINERS

                    buyV_ = sub(sellV_, restFeeV_);

            } else {

                require(false,                                      // not allowed to have both buy and sell tokens to be ERC721. ...
                    "dex-no-token-to-get-fee-from");                // ... We should never end up here since dex-one-of-tokens-must-be-erc20 ...
                                                                    // ... will be fired first. It is here for precaution.


            }

            assert(                                                 // buy value must be less or equal to sell value
                token_ != buyToken_ ||
                sub(buyV_, restFeeV_) <= add(sellV_, dust));

            assert(                                                 // buy value must be less or equal to sell value
                token_ != sellToken_ ||
                buyV_ <= add(sellV_, dust));

            _takeFeeInToken(                                        // send profit and costs in sellToken_
                restFeeV_,
                feeTakenV_,
                token_,
                src_,
                amtT_);

        } else {                                                    // no feeV_ must be payed with sellToken_
            require(buyV_ <= sellV_ || canBuyErc20[buyToken_],
                "dex-not-enough-funds");

            require(buyV_ >= sellV_ || canSellErc20[sellToken_],
                "dex-not-enough-tokens-to-buy");

            sellV_ = min(buyV_, sellV_);

            buyV_ = sellV_;
        }

        sellT = canSellErc20[sellToken_] ?                          // calculate token_ amount to be sold
            wdivT(sellV_, rate[sellToken_], sellToken_) :
            sellAmtOrId_;

        buyT = canBuyErc20[buyToken_] ?
            wdivT(buyV_, rate[buyToken_], buyToken_) :
            buyAmtOrId_;

        if (block.coinbase == eth) {                                    // send unused Ether back to user	//injected CONTRACT AFFECTED BY MINERS

            amtT_ = wdivT(
                restFeeV_,
                rate[sellToken_],
                sellToken_);

            _sendToken(
                eth,
                address(this),
                msg.sender,
                sub(msg.value, add(sellT, amtT_)));
        }
    }

    /**
    * @dev Transfer sellToken from user and buyToken to user
    */
    function _transferTokens(
        uint256 sellT_,                                                 // sell token amount
        uint256 buyT_,                                                  // buy token amount
        address sellToken_,                                             // token sold by user
        uint256 sellAmtOrId_,                                           // sell amount or sell token id
        address buyToken_,                                              // token bought by user
        uint256 buyAmtOrId_,                                            // buy amount or buy id
        uint256 feeV_                                                   // value of total fees in base currency
    ) internal {
        address payable payTo_;

        if (canBuyErc20[buyToken_]) {

            payTo_ = handledByAsm[buyToken_] ?
                address(uint160(address(asm))):
                custodian20[buyToken_];                                 // we do not pay directly to custodian but through asm

            _sendToken(buyToken_, payTo_, msg.sender, buyT_);           // send buyToken_ from custodian to user
        }

        if (canSellErc20[sellToken_]) {                                 // if sellToken_ is a valid ERC20 token

            if (canBuyErc721[buyToken_]) {                              // if buyToken_ is a valid ERC721 token

                payTo_ = address(uint160(address(                       // we pay to owner
                    Dpass(buyToken_).ownerOf(buyAmtOrId_))));

                asm.notifyTransferFrom(                                 // notify Asset management about the transfer
                    buyToken_,
                    payTo_,
                    msg.sender,
                    buyAmtOrId_);

                TrustedErc721(buyToken_)                                // transfer buyToken_ from custodian to user
                .transferFrom(
                    payTo_,
                    msg.sender,
                    buyAmtOrId_);


            }

            _sendToken(sellToken_, msg.sender, payTo_, sellT_);         // send token or Ether from user to custodian

        } else {                                                        // if sellToken_ is a valid ERC721 token

            TrustedErc721(sellToken_)                                   // transfer ERC721 token from user to custodian
            .transferFrom(
                msg.sender,
                payTo_,
                sellAmtOrId_);

            sellT_ = sellAmtOrId_;
        }

        require(!denyToken[sellToken_][payTo_],
            "dex-token-denied-by-seller");

        if (payTo_ == address(asm) ||
            (canSellErc721[sellToken_] && handledByAsm[buyToken_]))

            asm.notifyTransferFrom(                                     // notify Asset Management contract about transfer
                               sellToken_,
                               msg.sender,
                               payTo_,
                               sellT_);

        _logTrade(sellToken_, sellT_, buyToken_, buyT_, buyAmtOrId_, feeV_);
    }

    /*
    * @dev Token sellers can deny accepting any token_ they want.
    * @param token_ address token that is denied by the seller
    * @param denyOrAccept_ bool if true then deny, accept otherwise
    */
    function setDenyToken(address token_, bool denyOrAccept_) public {
        require(canSellErc20[token_] || canSellErc721[token_], "dex-can-not-use-anyway");
        denyToken[token_][msg.sender] = denyOrAccept_;
    }

    /*
    * @dev Whitelist of users being able to convert tokens.
    * @param user_ address is candidate to be whitelisted (if whitelist is enabled)
    * @param allowed_ bool set if user should be allowed (uf true), or denied using system
    */
    function setKyc(address user_, bool allowed_) public auth {
        require(user_ != address(0), "asm-kyc-user-can-not-be-zero");
        kyc[user_] = allowed_;
    }

    /**
    * @dev Get marketplace price of dpass token for which users can buy the token.
    * @param token_ address token to get the buyPrice for.
    * @param tokenId_ uint256 token id to get buy price for.
    */
    function getBuyPrice(address token_, uint256 tokenId_) public view returns(uint256) {
        // require(canBuyErc721[token_], "dex-token-not-for-sale");
        return buyPrice[token_][TrustedErc721(token_).ownerOf(tokenId_)][tokenId_];
    }

    /**
    * @dev Set marketplace price of dpass token so users can buy it on for this price.
    * @param token_ address price is set for this token.
    * @param tokenId_ uint256 tokenid to set price for
    * @param price_ uint256 marketplace price to set
    */
    function setBuyPrice(address token_, uint256 tokenId_, uint256 price_) public {
        address seller_ = msg.sender;
        require(canBuyErc721[token_], "dex-token-not-for-sale");

        if (
            msg.sender == Dpass(token_).getCustodian(tokenId_) &&
            address(asm) == Dpass(token_).ownerOf(tokenId_)
        ) seller_ = address(asm);

        buyPrice[token_][seller_][tokenId_] = price_;
    }

    /**
    * @dev Get final price of dpass token. Function tries to get rpce from marketplace
    * price (buyPrice) and if that is zero, then from basePrice.
    * @param token_ address token to get price for
    * @param tokenId_ uint256 to get price for
    * @return final sell price that user must pay
    */
    function getPrice(address token_, uint256 tokenId_) public view returns(uint256) {
        uint basePrice_;
        address owner_ = TrustedErc721(token_).ownerOf(tokenId_);
        uint buyPrice_ = buyPrice[token_][owner_][tokenId_];
        require(canBuyErc721[token_], "dex-token-not-for-sale");
        if( buyPrice_ == 0 || buyPrice_ == uint(-1)) {
            basePrice_ = asm.basePrice(token_, tokenId_);
            require(basePrice_ != 0, "dex-zero-price-not-allowed");
            return basePrice_;
        } else {
            return buyPrice_;
        }
    }

    /**
    * @dev Get exchange rate in base currency. This function burns small amount of gas, because it returns the locally stored exchange rate for token_. It should only be used if user is sure that the rate was recently updated.
    * @param token_ address get rate for this token
    */
    function getLocalRate(address token_) public view auth returns(uint256) {
        return rate[token_];
    }

    /**
    * @dev Return true if token is allowed to exchange.
    * @param token_ the token_ addres in question
    * @param buy_ if true we ask if user can buy_ the token_ from exchange,
    * otherwise if user can sell to exchange.
    */
    function getAllowedToken(address token_, bool buy_) public view auth returns(bool) {
        if (buy_) {
            return canBuyErc20[token_] || canBuyErc721[token_];
        } else {
            return canSellErc20[token_] || canSellErc721[token_];
        }
    }

    /**
    * @dev Convert address to bytes32
    * @param b_ bytes32 value to convert to address to.
    */
    function addr(bytes32 b_) public pure returns (address) {
        return address(uint256(b_));
    }

    /**
    * @dev Retrieve the decimals of a token. Decimals are stored in a special way internally to apply the least calculations to get precision adjusted results.
    * @param token_ address the decimals are calculated for this token
    */
    function getDecimals(address token_) public view returns (uint8) {
        require(decimalsSet[token_], "dex-token-with-unset-decimals");
        uint dec = 0;
        while(dec <= 77 && decimals[token_] % uint(10) ** dec == 0){
            dec++;
        }
        dec--;
        return uint8(dec);
    }

    /**
    * @dev Get token_ / quote_currency rate from priceFeed
    * Revert transaction if not valid feed and manual value not allowed
    * @param token_ address get rate for this token
    */
    function getRate(address token_) public view auth returns (uint) {
        return _getNewRate(token_);
    }

    /*
    * @dev calculates multiple with decimals adjusted to match to 18 decimal precision to express base token value.
    * @param a_ uint256 multiply this number
    * @param b_ uint256 multiply this number
    * @param token_ address get results with the precision of this token
    */
    function wmulV(uint256 a_, uint256 b_, address token_) public view returns(uint256) {
        return wdiv(wmul(a_, b_), decimals[token_]);
    }

    /*
    * @dev calculates division with decimals adjusted to match to tokens precision
    * @param a_ uint256 divide this number
    * @param b_ uint256 divide by this number
    * @param token_ address get result with the precision of this token
    */
    function wdivT(uint256 a_, uint256 b_, address token_) public view returns(uint256) {
        return wmul(wdiv(a_,b_), decimals[token_]);
    }

    /**
    * @dev Get token_ / quote_currency rate from priceFeed
    * Revert transaction if not valid feed and manual value not allowed
    */
    function _getNewRate(address token_) internal view returns (uint rate_) {
        bool feedValid_;
        bytes32 baseRateBytes_;

        require(
            TrustedFeedLikeDex(address(0x0)) != priceFeed[token_],          // require token to have a price feed
            "dex-no-price-feed-for-token");

        (baseRateBytes_, feedValid_) = priceFeed[token_].peek();            // receive DPT/USD price

        if (feedValid_) {                                                   // if feed is valid, load DPT/USD rate from it

            rate_ = uint(baseRateBytes_);

        } else {

            require(manualRate[token_], "dex-feed-provides-invalid-data");  // if feed invalid revert if manualEthRate is NOT allowed

            rate_ = rate[token_];
        }
    }

    //
    // internal functions
    //

    /*
    * @dev updates locally stored rates of tokens from feeds
    */
    function _updateRates(address sellToken_, address buyToken_) internal {
        if (canSellErc20[sellToken_]) {
            _updateRate(sellToken_);
        }

        if (canBuyErc20[buyToken_]){
            _updateRate(buyToken_);
        }

        _updateRate(dpt);
    }

    /*
    * @dev log the trade event
    */
    function _logTrade(
        address sellToken_,
        uint256 sellT_,
        address buyToken_,
        uint256 buyT_,
        uint256 buyAmtOrId_,
        uint256 feeV_
    ) internal {

        address custodian_ = canBuyErc20[buyToken_] ?
            custodian20[buyToken_] :
            Dpass(buyToken_).getCustodian(buyAmtOrId_);

        txId++;

        emit LogBuyTokenWithFee(
            txId,
            msg.sender,
            custodian_,
            sellToken_,
            sellT_,
            buyToken_,
            buyT_,
            feeV_);
    }

    /**
    * @dev Get exchange rate for a token
    */
    function _updateRate(address token) internal returns (uint256 rate_) {
        require((rate_ = _getNewRate(token)) > 0, "dex-rate-must-be-greater-than-0");
        rate[token] = rate_;
    }

    /**
    * @dev Calculate and send profit and cost
    */
    function _takeFeeInToken(
        uint256 feeV_,                                              // feeV_ that user still owes to CDiamondCoin after paying feeV_ in DPT
        uint256 feeTakenV_,                                         // feeV_ already taken from user in DPT
        address token_,                                             // token_ that must be sent as feeV_
        address src_,                                               // source of token_ sent
        uint256 amountT_                                            // total amount of tokens the user wanted to pay initially
    ) internal {
        uint profitV_;
        uint profitDpt_;
        uint feeT_;
        uint profitPaidV_;
        uint totalProfitV_;

        totalProfitV_ = wmul(add(feeV_, feeTakenV_), profitRate);

        profitPaidV_ = takeProfitOnlyInDpt ?                        // profit value paid already in base currency
            feeTakenV_ :
            wmul(feeTakenV_, profitRate);

        profitV_ = sub(                                             // profit value still to be paid in base currency
            totalProfitV_,
            min(
                profitPaidV_,
                totalProfitV_));

        profitDpt_ = wdivT(profitV_, rate[dpt], dpt);               // profit in DPT still to be paid

        feeT_ = wdivT(feeV_, rate[token_], token_);                 // convert feeV_ from base currency to token amount

        require(
            feeT_ < amountT_,                                       // require that the cost we pay is less than user intended to pay
            "dex-not-enough-token-to-pay-fee");

        if (block.coinbase == dpt) {	//injected CONTRACT AFFECTED BY MINERS
            _sendToken(dpt, src_, address(uint160(address(burner))), profitDpt_);

            _sendToken(dpt, src_, wal, sub(feeT_, profitDpt_));

        } else {

            if (liqBuysDpt) {

                Liquidity(liq).burn(dpt, burner, profitV_);         // if liq contract buys DPT on the fly

            } else {

                _sendToken(dpt,                                     // if liq contract stores DPT that can be sent to burner by us
                           liq,
                           address(uint160(address(burner))),
                           profitDpt_);
            }

            _sendToken(token_, src_, wal, feeT_);                   // send user token_ to wallet
        }
    }

    /**
    * @dev Take fee in DPT from user if it has any
    * @param feeV_ the fee amount in base currency
    * @return the remaining fee amount in DPT
    */
    function _takeFeeInDptFromUser(
        uint256 feeV_                                               // total feeV_ to be paid
    ) internal returns(uint256 feeTakenV_) {
        TrustedDSToken dpt20_ = TrustedDSToken(dpt);
        uint profitDpt_;
        uint costDpt_;
        uint feeTakenDpt_;

        uint dptUser = min(
            dpt20_.balanceOf(msg.sender),
            dpt20_.allowance(msg.sender, address(this))
        );

        if (block.gaslimit == 0) return 0;	//injected CONTRACT AFFECTED BY MINERS

        uint feeDpt = wdivT(feeV_, rate[dpt], dpt);                 // feeV_ in DPT

        uint minDpt = min(feeDpt, dptUser);                         // get the maximum possible feeV_ amount


        if (block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS

            if (takeProfitOnlyInDpt) {                              // only profit is paid in dpt

                profitDpt_ = min(wmul(feeDpt, profitRate), minDpt);

            } else {

                profitDpt_ = wmul(minDpt, profitRate);

                costDpt_ = sub(minDpt, profitDpt_);

                _sendToken(dpt, msg.sender, wal, costDpt_);         // send cost
            }

            _sendToken(dpt,                                         // send profit to burner
                       msg.sender,
                       address(uint160(address(burner))),
                       profitDpt_);

            feeTakenDpt_ = add(profitDpt_, costDpt_);               // total feeV_ taken in DPT

            feeTakenV_ = wmulV(feeTakenDpt_, rate[dpt], dpt);       // total feeV_ taken in base currency value
        }

    }

    /**
    * @dev send token or ether to destination
    */
    function _sendToken(
        address token_,
        address src_,
        address payable dst_,
        uint256 amount_
    ) internal returns(bool) {

        if (token_ == eth && amount_ > dust) {                          // if token_ is Ether and amount_ is higher than dust limit
            require(src_ == msg.sender || src_ == address(this),
                    "dex-wrong-src-address-provided");
            dst_.transfer(amount_);

            emit LogTransferEth(src_, dst_, amount_);

        } else {

            if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
                if( handledByAsm[token_] && src_ == address(asm)) {     // if token_ is handled by asm (so it is minted and burnt) and we have to mint it
                    asm.mint(token_, dst_, amount_);
                } else {
                    TrustedDSToken(token_).transferFrom(src_, dst_, amount_);           // transfer all of token_ to dst_
                }
            }
        }
        return true;
    }
}

////// src/DiamondExchangeExtension.sol
/* pragma solidity ^0.5.11; */

/* import "./DiamondExchange.sol"; */
/* import "dpass/Dpass.sol"; */
/* import "ds-auth/auth.sol"; */
/* import "./Redeemer.sol"; */

contract TrustedAsmExt {
    function getAmtForSale(address token) external view returns(uint256);
}

/**
* @dev Contract to calculate user fee based on amount
*/
contract TrustedFeeCalculatorExt {

    function calculateFee(
        address sender,
        uint256 value,
        address sellToken,
        uint256 sellAmtOrId,
        address buyToken,
        uint256 buyAmtOrId
    ) external view returns (uint);

    function getCosts(
        address user,                                                           // user for whom we want to check the costs for
        address sellToken_,
        uint256 sellId_,
        address buyToken_,
        uint256 buyAmtOrId_
    ) public view returns (uint256 sellAmtOrId_, uint256 feeDpt_, uint256 feeV_, uint256 feeSellT_) {
        // calculate expected sell amount when user wants to buy something anc only knows how much he wants to buy from a token and whishes to know how much it will cost.
    }
}

contract DiamondExchangeExtension is DSAuth {

    uint public dust = 1000;
    bytes32 public name = "Dee";                          // set human readable name for contract
    bytes32 public symbol = "Dee";                        // set human readable name for contract
    TrustedAsmExt public asm;
    DiamondExchange public dex;
    Redeemer public red;
    TrustedFeeCalculatorExt public fca;

    uint private buyV;
    uint private dptBalance;
    uint private feeDptV;
//-----------included-from-ds-math---------------------------------begin
    uint constant WAD = 1 ether;

    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, "ds-math-add-overflow");
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, "ds-math-sub-underflow");
    }
    function min(uint x, uint y) internal pure returns (uint z) {
        return x <= y ? x : y;
    }
    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
    }
    function wmul(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, y), WAD / 2) / WAD;
    }
    function wdiv(uint x, uint y) internal pure returns (uint z) {
        z = add(mul(x, WAD), y / 2) / y;
    }
//-----------included-from-ds-math---------------------------------end

    function setConfig(bytes32 what_, bytes32 value_, bytes32 value1_) public auth {
        if (blockhash(block.number) == "asm") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dee-wrong-address");

            asm = TrustedAsmExt(addr(value_));

        } else if (blockhash(block.number) == "dex") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dee-wrong-address");

            dex = DiamondExchange(address(uint160(addr(value_))));

        } else if (blockhash(block.number) == "red") {	//injected CONTRACT AFFECTED BY MINERS

            require(addr(value_) != address(0x0), "dee-wrong-address");

            red = Redeemer(address(uint160(addr(value_))));

        } else if (blockhash(block.number) == "dust") {	//injected CONTRACT AFFECTED BY MINERS

            dust = uint256(value_);

        } else {
            value1_; // disable warning of unused variable
            require(false, "dee-no-such-option");
        }
    }

    /**
    * @dev Convert address to bytes32
    */
    function addr(bytes32 b_) public pure returns (address) {
        return address(uint256(b_));
    }

    /**
    * @dev Collect all available info about a diamond
    * Returns diamond data with following arguments
    *
    * ownerCustodian_[0]    = owner
    * ownerCustodian_[1]    = custodian
    * attrs_[0]             = issuer
    * attrs_[1]             = report
    * attrs_[2]             = state eg.: "valid" "invalid" "sale"
    * attrs_[3]             = cccc ( cut, clarity, color, carat)
    * attrs_[4]             = attributeHash
    * attrs_[5]             = currentHashingAlgorithm
    * carat_                = weight in carats
    * priceV_               = current effective sale price in base currency
    */
    function getDiamondInfo(address token_, uint256 tokenId_)
    public view returns(
        address[2] memory ownerCustodian_,
        bytes32[6] memory attrs_,
        uint24 carat_,
        uint priceV_
    ) {
        require(dex.canBuyErc721(token_) || dex.canSellErc721(token_), "dee-token-not-a-dpass-token");
        (ownerCustodian_, attrs_, carat_) = Dpass(token_).getDiamondInfo(tokenId_);
        priceV_ = dex.getPrice(token_, tokenId_);
    }

    /*
    * @dev Returns true if seller accepts token as payment
    */
    function sellerAcceptsToken(address token_, address seller_)
    public view returns (bool) {

        return (dex.canSellErc20(token_) ||
                dex.canSellErc721(token_)) &&
                !dex.denyToken(token_, seller_);
    }

    /**
    * @dev calculates how much of a certain token user must spend in order to buy certain amount of token with fees.
    * @param user_ address this is the address that will initiate buy transaction
    * @param sellToken_ address token user wants to pay with 
    * @param sellId_ uint256 if sellToken_ is dpass then this is the tokenId otherwise ignored
    * @param buyToken_ address token user wants to buy
    * @param buyAmtOrId_ uint256 amount or id of buyToken_
    * @return the sellAmount or if sellToken is dpass 1 if sell can be made and 0 if not, and the amount of additional dpt fee,
    */
    function getCosts(
        address user_,                                                           // user for whom we want to check the costs for
        address sellToken_,                                                     // token we want to know how much we must pay of
        uint256 sellId_,                                                        // if sellToken_ is dpass then this is the tokenId otherwise ignored
        address buyToken_,                                                      // the token user wants to buy
        uint256 buyAmtOrId_                                                     // the amount user wants to buy
    ) public view
    returns (
        uint256 sellAmtOrId_,                                                   // the calculated amount of tokens needed to be solc to get buyToken_
        uint256 feeDpt_,                                                        // the fee paid in DPT if user has DPT ...
                                                                                // ... (if you dont want to calculate with user DPT set user address to 0x0
        uint256 feeV_,                                                          // total fee to be paid in base currency
        uint256 feeSellT_                                                       // fee to be paid in sellTokens (this amount will be subtracted as fee from user)
    ) {
        uint buyV_;
        uint feeDptV_;

        if(fca == TrustedFeeCalculatorExt(0)) {

            require(user_ != address(0),
                "dee-user_-address-zero");

            require(
                dex.canSellErc20(sellToken_) ||
                dex.canSellErc721(sellToken_),
                "dee-selltoken-invalid");

            require(
                dex.canBuyErc20(buyToken_) ||
                dex.canBuyErc721(buyToken_),
                "dee-buytoken-invalid");

            require(
                !(dex.canBuyErc721(buyToken_) &&
                dex.canSellErc721(sellToken_)),
                "dee-both-tokens-dpass");

            require(dex.dpt() != address(0), "dee-dpt-address-zero");

            if(dex.canBuyErc20(buyToken_)) {

                buyV_ = _getBuyV(buyToken_, buyAmtOrId_);

            } else {

                buyV_ = dex.getPrice(buyToken_, buyAmtOrId_);
            }

            feeV_ = add(
                wmul(buyV_, dex.varFee()),
                dex.fixFee());

            feeDpt_ = wmul(
                dex.wdivT(
                    feeV_,
                    dex.getRate(dex.dpt()),
                    dex.dpt()),
                dex.takeProfitOnlyInDpt() ? dex.profitRate() : 1 ether);

            sellAmtOrId_ = min(
                DSToken(dex.dpt()).balanceOf(user_), 
                DSToken(dex.dpt()).allowance(user_, address(dex)));

            if(dex.canSellErc20(sellToken_)) {

                if(block.timestamp <= add(feeDpt_, dust)) {	//injected CONTRACT AFFECTED BY MINERS

                    feeDptV_ = dex.wmulV(
                        sellAmtOrId_,
                        dex.getRate(dex.dpt()),
                        dex.dpt());

                    feeDpt_ = sellAmtOrId_;

                } else {

                    feeDptV_ = dex.wmulV(feeDpt_, dex.getRate(dex.dpt()), dex.dpt());

                    feeDpt_ = feeDpt_;

                }

                feeSellT_ = dex.wdivT(sub(feeV_, min(feeV_, feeDptV_)), dex.getRate(sellToken_), sellToken_);

                sellAmtOrId_ = add(
                    dex.wdivT(
                        buyV_,
                        dex.getRate(sellToken_),
                        sellToken_),
                    feeSellT_);

            } else {

                sellAmtOrId_ = add(buyV_, dust) >= dex.getPrice(sellToken_, sellId_) ? 1 : 0;
                feeDpt_ = min(feeDpt_, Dpass(dex.dpt()).balanceOf(user_));
            }

        } else {
            return fca.getCosts(user_, sellToken_, sellId_, buyToken_, buyAmtOrId_);
        }
    }

    function getRedeemCosts(
        address redeemToken_,
        uint256 redeemAmtOrId_,
        address feeToken_
    ) public view returns(uint) {
        return red.getRedeemCosts(redeemToken_, redeemAmtOrId_, feeToken_);
    }

    function _getBuyV(address buyToken_, uint256 buyAmtOrId_) internal view returns (uint buyV_) {
        uint buyT_;

        buyT_ = dex.handledByAsm(buyToken_) ?                       // set buy amount to max possible
            asm.getAmtForSale(buyToken_) :                          // if managed by asset management get available
            min(                                                    // if not managed by asset management get buyV_ available
                DSToken(buyToken_).balanceOf(
                    dex.custodian20(buyToken_)),
                DSToken(buyToken_).allowance(
                    dex.custodian20(buyToken_), address(dex)));

        buyT_ = min(buyT_, buyAmtOrId_);

        buyV_ = dex.wmulV(buyT_, dex.getRate(buyToken_), buyToken_);
    }
}