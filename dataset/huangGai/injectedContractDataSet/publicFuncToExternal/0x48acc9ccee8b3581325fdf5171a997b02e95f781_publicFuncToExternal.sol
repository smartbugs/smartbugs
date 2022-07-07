/**
 *Submitted for verification at Etherscan.io on 2020-07-08
*/

// File: contracts/IERC165.sol

pragma solidity ^0.5.11;


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

// File: contracts/IERC721.sol

pragma solidity ^0.5.11;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed tokenOwner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed tokenOwner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address tokenOwner) public view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address tokenOwner);

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
    function isApprovedForAll(address tokenOwner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

// File: contracts/IERC721Receiver.sol

pragma solidity ^0.5.11;


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

// File: contracts/SafeMath.sol

pragma solidity ^0.5.11;


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
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
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

     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
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
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/Address.sol

pragma solidity ^0.5.11;


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
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
}

// File: contracts/Counters.sol

pragma solidity ^0.5.11;


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

// File: contracts/ERC165.sol

pragma solidity ^0.5.11;


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
    function supportsInterface(bytes4 interfaceId) public view returns (bool) {	//inject PUBLIC FUNC TO EXTERNAL
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

// File: contracts/ERC721.sol

pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

/**
 * @title ERC721 Customized for Microsponsors from:
 * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721MetadataMintable.sol
 */








/**
 * @title Deployed Microsponsors Registry smart contract interface.
 * @dev We just use the signatures of the parts we need to interact with:
 */
contract DeployedRegistry {
    function isContentIdRegisteredToCaller(uint32 federationId, string memory contentId) public view returns(bool);
    function isMinter(uint32 federationId, address account) public view returns (bool);
    function isAuthorizedTransferFrom(uint32 federationId, address from, address to, uint256 tokenId, address minter, address owner) public view returns(bool);
}


/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://eips.ethereum.org/EIPS/eip-721
 */
contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;


    /***  Contract data  ***/


    /// @dev owner1, owner2 Admins of this contract.
    address public owner1;
    address public owner2;

    /// @dev paused Admin only. Set to `true` to stop token minting and transfers.
    bool public paused = false;

    /// @dev mintFee Admin only. Set minting fee; default fee is below (in wei).
    uint256 public mintFee = 100000000000000;

    /// @dev DeployedRegistry The Microsponsors Registry Contract that verifies participants.
    ///      Admin can update the contract address here to upgrade Registry.
    DeployedRegistry public registry;

    /// @title _tokenIds All Token IDs minted, incremented starting at 1
    Counters.Counter _tokenIds;

    /// @dev _tokenOwner mapping from Token ID to Token Owner
    mapping (uint256 => address) private _tokenOwner;

    /// @dev _ownedTokensCount mapping from Token Owner to # of owned tokens
    mapping (address => Counters.Counter) private _ownedTokensCount;

    /// @dev _mintedTokensCount mapping from Token Minter to # of minted tokens
    mapping (address => Counters.Counter) private _mintedTokensCount;

    /// @dev tokenToFederationId see notes on path to federation in Microsponsors Registry contract
    mapping (uint256 => uint32) public tokenToFederationId;

    /// @dev TimeSlot metadata struct for each token
    ///      TimeSlots timestamps are stored as uint48:
    ///      https://medium.com/@novablitz/storing-structs-is-costing-you-gas-774da988895e
    struct TimeSlot {
        address minter; // the address of the user who mint()'ed this time slot
        string contentId; // the users' registered contentId containing the Property
        string propertyName; // describes the Property within the contentId that is tokenized into time slots
        uint48 startTime; // min timestamp (when time slot begins)
        uint48 endTime; // max timestamp (when time slot ends)
        uint48 auctionEndTime; // max timestamp (when auction for time slot ends)
        uint16 category; // integer that represents the category (see Microsponsors utils.js)
        bool isSecondaryTradingEnabled; // if true, first buyer can trade to others
    }
    /// @dev _tokenToTimeSlot mapping from Token ID to TimeSlot struct
    ///      Use tokenTimeSlot() public method to read
    mapping(uint256 => TimeSlot) private _tokenToTimeSlot;

    /// @dev PropertyNameStruct: name of the time slot
    struct PropertyNameStruct {
        string propertyName;
    }
    /// @dev _tokenMinterToPropertyName mapping from Minter => Content ID => array of Property Names
    ///      Used to display all tokenized Time Slots on a given Property.
    ///      Using struct because there is no mapping to a dynamic array of bytes32 in Solidity at this time.
    mapping(address => mapping(string => PropertyNameStruct[])) private _tokenMinterToPropertyNames;

    /// @dev ContentIdStruct The registered Content ID, verified by Registry contract
    struct ContentIdStruct {
        string contentId;
    }
    /// @dev _tokenMinterToContentIds Mapping from Token Minter to array of Content IDs
    ///      that they have *ever* minted tokens for
    mapping(address => ContentIdStruct[]) private _tokenMinterToContentIds;

    /// @dev _tokenURIs Mapping from Token ID to Token URIs
    mapping(uint256 => string) private _tokenURIs;

    /// @dev _tokenApprovals Mapping from Token ID to Approved Address
    mapping (uint256 => address) private _tokenApprovals;

    /// @dev _operatorApprovals Mapping from Token Owner to Operator Approvals
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

    // @dev Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;


    constructor () public {

        // Register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);

        // Set the contract owners to msg.sender by default
        owner1 = _msgSender();
        owner2 = _msgSender();

    }


    /**
     * @dev Provides information about the current execution context, including the
     * sender of the transaction and its data. While these are generally available
     * via msg.sender and msg.data, they not should not be accessed in such a direct
     * manner, since when dealing with GSN meta-transactions the account sending and
     * paying for execution may not be the actual sender (as far as an application
     * is concerned).
     */

    function _msgSender() internal view returns (address) {

        return msg.sender;

    }

    function _msgData() internal view returns (bytes memory) {

        this; // silence state mutability warning without generating bytecode -
              // see https://github.com/ethereum/solidity/issues/2691
        return msg.data;

    }


    /***  Owner (Administrator) functions  ***/


    /**
     * @dev Sets the contract's owner (administrator)
     * Based on 0x's Ownable, but modified here
     */
    modifier onlyOwner() {
        require(
            (_msgSender() == owner1) || (_msgSender() == owner2),
            "ONLY_CONTRACT_OWNER"
        );
        _;
    }

    /**
     * @dev Transfer owner (admin) functions to another address
     * @param newOwner Address of new owner/ admin of contract
     */
    function transferOwnership1(address newOwner)
        public
        onlyOwner
    {
        if (newOwner != address(0)) {
            owner1 = newOwner;
        }
    }


    function transferOwnership2(address newOwner)
        public
        onlyOwner
    {
        if (newOwner != address(0)) {
            owner2 = newOwner;
        }
    }

    /**
     * @dev Update contract address for Microsponsors Registry contract
     * @param newAddress where the Registry contract lives
     */
    function updateRegistryAddress(address newAddress)
        public
        onlyOwner
    {
        registry = DeployedRegistry(newAddress);
    }

    /**
     * @dev Update the fee (in wei) charged for minting a single token
     */
    function updateMintFee(uint256 val)
        public
        onlyOwner
    {

        mintFee = val;

    }

    /// @dev Pausable (adapted from OpenZeppelin via Cryptokitties)
    /// @dev Modifier to allow actions only when the contract IS NOT paused
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /// @dev Modifier to allow actions only when the contract IS paused
    modifier whenPaused {
        require(paused);
        _;
    }

    /// @dev Called by contract owner to pause minting and transfers.
    function pause() public onlyOwner whenNotPaused {
        paused = true;
    }

    /// @dev Called by contract owner to unpause minting and transfers.
    function unpause() public onlyOwner whenPaused {
        paused = false;
    }

    /// @dev Admin withdraws entire balance from contract.
    function withdrawBalance() public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL

        // Ref: https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/
        uint balance = address(this).balance;
        (bool success, ) = msg.sender.call.value(balance)("");
        require(success, "WITHDRAW_FAILED");

    }


    /***  Minting tokens  ***/


    /**
     * @dev Function to mint tokens.
     * @return tokenId
     */
    function mint(
        string memory contentId,
        string memory propertyName,
        uint48 startTime,
        uint48 endTime,
        uint48 auctionEndTime,
        uint16 category,
        bool isSecondaryTradingEnabled,
        uint32 federationId
    )
        public
        payable
        whenNotPaused
        returns (uint256)
    {

        require(msg.value >= mintFee);

        require(federationId > 0, "INVALID_FEDERATION_ID");

        require(
            registry.isMinter(federationId, _msgSender()),
            "CALLER_NOT_AUTHORIZED_FOR_MINTER_ROLE"
        );

        require(
            _isValidTimeSlot(contentId, startTime, endTime, auctionEndTime, federationId),
            "INVALID_TIME_SLOT"
        );

        uint256 tokenId = _mint(_msgSender());
        _setTokenTimeSlot(tokenId, contentId, propertyName, startTime, endTime, auctionEndTime, category, isSecondaryTradingEnabled);
        tokenToFederationId[tokenId] = federationId;

        return tokenId;

    }

    /**
     * @dev Function to mint tokens.
     * @param tokenURI The token URI of the minted token.
     * @return tokenId
     */
    function mintWithTokenURI(
        string memory contentId,
        string memory propertyName,
        uint48 startTime,
        uint48 endTime,
        uint48 auctionEndTime,
        uint16 category,
        bool isSecondaryTradingEnabled,
        uint32 federationId,
        string memory tokenURI
    )
        public
        payable
        whenNotPaused
        returns (uint256)
    {

        require(msg.value >= mintFee);

        require(federationId > 0, "INVALID_FEDERATION_ID");

        require(
            registry.isMinter(federationId, _msgSender()),
            "CALLER_NOT_AUTHORIZED_FOR_MINTER_ROLE"
        );

        require(
            _isValidTimeSlot(contentId, startTime, endTime, auctionEndTime, federationId),
            "INVALID_TIME_SLOT"
        );

        uint256 tokenId = _mint(_msgSender());
        _setTokenTimeSlot(tokenId, contentId, propertyName, startTime, endTime, auctionEndTime, category, isSecondaryTradingEnabled);
        _setTokenURI(tokenId, tokenURI);
        tokenToFederationId[tokenId] = federationId;

        return tokenId;

    }

    /**
     * @dev Function to safely mint tokens.
     * @return tokenId
     */
    function safeMint(
        string memory contentId,
        string memory propertyName,
        uint48 startTime,
        uint48 endTime,
        uint48 auctionEndTime,
        uint16 category,
        bool isSecondaryTradingEnabled,
        uint32 federationId
    )
        public
        payable
        whenNotPaused
        returns (uint256)
    {

        require(msg.value >= mintFee);

        require(federationId > 0, "INVALID_FEDERATION_ID");

        require(
            registry.isMinter(federationId, _msgSender()),
            "CALLER_NOT_AUTHORIZED_FOR_MINTER_ROLE"
        );

        require(
            _isValidTimeSlot(contentId, startTime, endTime, auctionEndTime, federationId),
            "INVALID_TIME_SLOT"
        );

        uint256 tokenId = _safeMint(_msgSender());
        _setTokenTimeSlot(tokenId, contentId, propertyName, startTime, endTime, auctionEndTime, category, isSecondaryTradingEnabled);
        tokenToFederationId[tokenId] = federationId;

        return tokenId;

    }

    /**
     * @dev Function to safely mint tokens.
     * @param data bytes data to send along with a safe transfer check.
     * @return tokenId
     */
    function safeMint(
        string memory contentId,
        string memory propertyName,
        uint48 startTime,
        uint48 endTime,
        uint48 auctionEndTime,
        uint16 category,
        bool isSecondaryTradingEnabled,
        uint32 federationId,
        bytes memory data
    )
        public
        payable
        whenNotPaused
        returns (uint256)
    {

        require(msg.value >= mintFee);

        require(federationId > 0, "INVALID_FEDERATION_ID");

        require(
            registry.isMinter(federationId, _msgSender()),
            "CALLER_NOT_AUTHORIZED_FOR_MINTER_ROLE"
        );

        require(
            _isValidTimeSlot(contentId, startTime, endTime, auctionEndTime, federationId),
            "INVALID_TIME_SLOT"
        );

        uint256 tokenId = _safeMint(_msgSender(), data);
        _setTokenTimeSlot(tokenId, contentId, propertyName, startTime, endTime, auctionEndTime, category, isSecondaryTradingEnabled);
        tokenToFederationId[tokenId] = federationId;

        return tokenId;

    }

    /**
     * @param tokenURI The token URI of the minted token.
     * @return tokenId
     */
    function safeMintWithTokenURI(
        string memory contentId,
        string memory propertyName,
        uint48 startTime,
        uint48 endTime,
        uint48 auctionEndTime,
        uint16 category,
        bool isSecondaryTradingEnabled,
        uint32 federationId,
        string memory tokenURI
    )
        public
        payable
        whenNotPaused
        returns (uint256)
    {

        require(msg.value >= mintFee);

        require(federationId > 0, "INVALID_FEDERATION_ID");

        require(
            registry.isMinter(federationId, _msgSender()),
            "CALLER_NOT_AUTHORIZED_FOR_MINTER_ROLE"
        );

        require(
            _isValidTimeSlot(contentId, startTime, endTime, auctionEndTime, federationId),
            "INVALID_TIME_SLOT"
        );

        uint256 tokenId = _safeMint(_msgSender());
        _setTokenTimeSlot(tokenId, contentId, propertyName, startTime, endTime, auctionEndTime, category, isSecondaryTradingEnabled);
        _setTokenURI(tokenId, tokenURI);
        tokenToFederationId[tokenId] = federationId;

        return tokenId;

    }

    /**
     * @dev Internal function to safely mint a new token.
     * Reverts if the given token ID already exists.
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * @param to The address that will own the minted token
     * @return tokenId
     */
    function _safeMint(address to) internal returns (uint256) {

        uint256 tokenId = _safeMint(to, "");
        return tokenId;

    }

    /**
     * @dev Internal function to safely mint a new token.
     * Reverts if the given token ID already exists.
     * If the target address is a contract, it must implement `onERC721Received`,
     * which is called upon a safe transfer, and return the magic value
     * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
     * the transfer is reverted.
     * @param to The address that will own the minted token
     * @param data bytes data to send along with a safe transfer check
     * @return tokenId
     */
    function _safeMint(address to, bytes memory data) internal returns (uint256) {

        uint256 tokenId = _mint(to);

        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "TRANSFER_TO_NON_ERC721RECEIVER_IMPLEMENTER"
        );

        return tokenId;

    }

    /**
     * @dev Internal function to mint a new token.
     * Reverts if the given token ID already exists.
     * @param to The address that will own the minted token
     */
    function _mint(address to) internal returns (uint256) {

        require(to != address(0), "MINT_TO_ZERO_ADDRESS");

        _tokenIds.increment();
        uint256 tokenId = _tokenIds.current();

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment();
        _mintedTokensCount[to].increment();

        emit Transfer(address(0), to, tokenId);

        return tokenId;

    }


    /***  Token URIs  ***/


    /**
     * @dev Internal function to set the token URI for a given token.
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to set its URI
     * @param uri string URI to assign
     */
    function _setTokenURI(uint256 tokenId, string memory uri) internal {

        require(
            _exists(tokenId),
            "NON_EXISTENT_TOKEN"
        );

        _tokenURIs[tokenId] = uri;

    }

    /**
     * Throws if the token ID does not exist. May return an empty string.
     * @param tokenId uint256 ID of the token to query
     * @return URI for a given token ID.
     */
    function tokenURI(uint256 tokenId) public view returns (string memory) {	//inject PUBLIC FUNC TO EXTERNAL

        require(
            _exists(tokenId),
            "NON_EXISTENT_TOKEN"
        );

        return _tokenURIs[tokenId];

    }


    /***  Token TimeSlot data and metadata  ***/


    function _isValidTimeSlot(
        string memory contentId,
        uint48 startTime,
        uint48 endTime,
        uint48 auctionEndTime,
        uint32 federationId
    ) internal view returns (bool) {

        require(
            registry.isContentIdRegisteredToCaller(federationId, contentId),
            "CONTENT_ID_NOT_REGISTERED_TO_CALLER"
        );

        require(
            startTime > auctionEndTime,
            "START_TIME_AFTER_AUCTION_END_TIME"
        );

        require(
            endTime > startTime,
            "START_TIME_AFTER_END_TIME"
        );

        return true;

    }


    function _isContentIdMappedToMinter(
        string memory contentId
    )  internal view returns (bool) {

        ContentIdStruct[] memory a = _tokenMinterToContentIds[msg.sender];
        bool foundMatch = false;
        for (uint i = 0; i < a.length; i++) {
            if (stringsMatch(contentId, a[i].contentId)) {
                foundMatch = true;
            }
        }

        return foundMatch;
    }


    function _isPropertyNameMappedToMinter(
        string memory contentId,
        string memory propertyName
    )  internal view returns (bool) {

        PropertyNameStruct[] memory a = _tokenMinterToPropertyNames[msg.sender][contentId];
        bool foundMatch = false;
        for (uint i = 0; i < a.length; i++) {
            if (stringsMatch(propertyName, a[i].propertyName)) {
                foundMatch = true;
            }
        }

        return foundMatch;
    }


    function _setTokenTimeSlot(
        uint256 tokenId,
        string memory contentId,
        string memory propertyName,
        uint48 startTime,
        uint48 endTime,
        uint48 auctionEndTime,
        uint16 category,
        bool isSecondaryTradingEnabled
    ) internal {

        require(
            _exists(tokenId),
            "NON_EXISTENT_TOKEN"
        );

        TimeSlot memory _timeSlot = TimeSlot({
            minter: address(_msgSender()),
            contentId: string(contentId),
            propertyName: string(propertyName),
            startTime: uint48(startTime),
            endTime: uint48(endTime),
            auctionEndTime: uint48(auctionEndTime),
            category: uint16(category),
            isSecondaryTradingEnabled: bool(isSecondaryTradingEnabled)

        });

        _tokenToTimeSlot[tokenId] = _timeSlot;

        if (!_isContentIdMappedToMinter(contentId)) {
            _tokenMinterToContentIds[_msgSender()].push( ContentIdStruct(contentId) );
        }

        if (!_isPropertyNameMappedToMinter(contentId, propertyName)) {
            _tokenMinterToPropertyNames[_msgSender()][contentId].push( PropertyNameStruct(propertyName) );
        }

    }


    function tokenTimeSlot(uint256 tokenId) public view returns (
        address minter,
        address owner,
        string memory contentId,
        string memory propertyName,
        uint48 startTime,
        uint48 endTime,
        uint48 auctionEndTime,
        uint16 category,
        bool isSecondaryTradingEnabled,
        uint32 federationId
    ) {

        require(
            _exists(tokenId),
            "NON_EXISTENT_TOKEN"
        );

        TimeSlot memory _timeSlot = _tokenToTimeSlot[tokenId];
        uint32 _federationId = tokenToFederationId[tokenId];

        return (
            _timeSlot.minter,
            ownerOf(tokenId),
            _timeSlot.contentId,
            _timeSlot.propertyName,
            _timeSlot.startTime,
            _timeSlot.endTime,
            _timeSlot.auctionEndTime,
            _timeSlot.category,
            _timeSlot.isSecondaryTradingEnabled,
            _federationId
        );

    }


    /***  Token minter queries  ***/


    /// @dev Look up all Content IDs a Minter has tokenized TimeSlots for.
    ///      We're not getting this from the Registry because we want to keep
    ///      a separate record here of all Content ID's the acct has *ever*
    ///      minted tokens for. The registry is for keeping track of their
    ///      current (not necessarily past) Content ID registrations.
    function tokenMinterContentIds(address minter) public view returns (string[] memory) {	//inject PUBLIC FUNC TO EXTERNAL

        ContentIdStruct[] memory m = _tokenMinterToContentIds[minter];
        string[] memory r = new string[](m.length);

        for (uint i = 0; i < m.length; i++) {
            r[i] = m[i].contentId;
        }

        return r;

    }

    /// @dev Look up all Property Names a Minter has created Time Slots for
    ///      with a particular Content ID
    function tokenMinterPropertyNames(
        address minter,
        string calldata contentId
    ) external view returns (string[] memory) {

        PropertyNameStruct[] memory m = _tokenMinterToPropertyNames[minter][contentId];
        string[] memory r = new string[](m.length);

        for (uint i = 0; i < m.length; i++) {
            r[i] =  m[i].propertyName;
        }

        return r;

    }


    /**
     * Return all the Token IDs minted by a given account.
     * @dev This method MUST NEVER be called by smart contract code. First, it's fairly
     *  expensive (it walks the entire _tokenIds array looking for tokens belonging to minter),
     *  but it also returns a dynamic array, which is only supported for web3 calls, and
     *  not contract-to-contract calls (at this time).
     */
    function tokensMintedBy(address minter) public view returns (uint256[] memory) {	//inject PUBLIC FUNC TO EXTERNAL

        require(
            minter != address(0),
            "CANNOT_QUERY_ZERO_ADDRESS"
        );

        uint256 tokenCount = _mintedTokensCount[minter].current();
        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 totalTokens = totalSupply();
            uint256 resultIndex = 0;

            // All Tokens have IDs starting at 1 and increase
            // sequentially up to the total supply count.
            uint256 tokenId;

            for (tokenId = 1; tokenId <= totalTokens; tokenId++) {
                if (_tokenToTimeSlot[tokenId].minter == minter) {
                    result[resultIndex] = tokenId;
                    resultIndex++;
                }
            }

            return result;
        }

    }


    /***  Token balance and ownership queries  ***/


    /**
     * @dev Gets the total number of tokens ever minted.
     */
    function totalSupply() public view returns (uint256) {

        return _tokenIds.current();

    }

    /**
     * @dev Gets the balance of the specified address.
     * @param tokenOwner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function balanceOf(address tokenOwner) public view returns (uint256) {

        require(
            tokenOwner != address(0),
            "CANNOT_QUERY_ZERO_ADDRESS"
        );

        return _ownedTokensCount[tokenOwner].current();

    }

    /**
     * @dev Gets the owner of the specified token ID.
     * @param tokenId uint256 ID of the token to query the owner of
     * @return address currently marked as the owner of the given token ID
     */
    function ownerOf(uint256 tokenId) public view returns (address) {

        address tokenOwner = _tokenOwner[tokenId];

        return tokenOwner;

    }

    /**
     * @param tokenOwner The owner whose tokens we are interested in.
     * @dev This method MUST NEVER be called by smart contract code. First, it's fairly
     *  expensive (it walks the entire _tokenIds array looking for tokens belonging to owner),
     *  but it also returns a dynamic array, which is only supported for web3 calls, and
     *  not contract-to-contract calls (at this time).
    */
    function tokensOfOwner(address tokenOwner) public view returns(uint256[] memory) {	//inject PUBLIC FUNC TO EXTERNAL
        uint256 tokenCount = balanceOf(tokenOwner);
        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 totalTokens = totalSupply();
            uint256 resultIndex = 0;

            // All Tokens have IDs starting at 1 and increase
            // sequentially up to the total count.
            uint256 tokenId;

            for (tokenId = 1; tokenId <= totalTokens; tokenId++) {
                if (_tokenOwner[tokenId] == tokenOwner) {
                    result[resultIndex] = tokenId;
                    resultIndex++;
                }
            }

            return result;
        }
    }


    /***  Approvals & Transfers  ***/


    /**
     * @dev Approves another address to transfer the given token ID
     * The zero address indicates there is no approved address.
     * There can only be one approved address per token at a given time.
     * Can only be called by the token owner or an approved operator.
     * @param to address to be approved for the given token ID
     * @param tokenId uint256 ID of the token to be approved
     */
    function approve(address to, uint256 tokenId)
        public
        whenNotPaused
    {

        address tokenOwner = ownerOf(tokenId);

        require(
            to != tokenOwner,
            "APPROVAL_IS_REDUNDANT"
        );

        require(
            _msgSender() == tokenOwner || isApprovedForAll(tokenOwner, _msgSender()),
            "CALLER_NOT_AUTHORIZED"
        );

        _tokenApprovals[tokenId] = to;
        emit Approval(tokenOwner, to, tokenId);

    }

    /**
     * @dev Gets the approved address for a token ID, or zero if no address set
     * Reverts if the token ID does not exist.
     * @param tokenId uint256 ID of the token to query the approval of
     * @return address currently approved for the given token ID
     */
    function getApproved(uint256 tokenId) public view returns (address) {

        require(
            _exists(tokenId),
            "NON_EXISTENT_TOKEN"
        );

        return _tokenApprovals[tokenId];

    }

    /**
     * @dev Sets or unsets the approval of a given operator
     * An operator is allowed to transfer all tokens of the sender on their behalf.
     * @param to operator address to set the approval
     * @param approved representing the status of the approval to be set
     */
    function setApprovalForAll(address to, bool approved)
        public
        whenNotPaused
    {

        require(to != _msgSender(), "CALLER_CANNOT_APPROVE_SELF");

        _operatorApprovals[_msgSender()][to] = approved;
        emit ApprovalForAll(_msgSender(), to, approved);

    }

    /**
     * @dev Tells whether an operator is approved by a given token owner.
     * @param tokenOwner token owner address which you want to query the approval of
     * @param operator operator address which you want to query the approval of
     * @return bool whether the given operator is approved by the token owner
     */
    function isApprovedForAll(address tokenOwner, address operator)
        public
        view
        returns (bool)
    {

        return _operatorApprovals[tokenOwner][operator];

    }

    /**
     * @dev Transfers the ownership of a given token ID to another address.
     * Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     * Requires the msg.sender to be the owner, approved, or operator.
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function transferFrom(address from, address to, uint256 tokenId)
        public
        whenNotPaused
    {

        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "UNAUTHORIZED_TRANSFER"
        );

        address minter = _tokenToTimeSlot[tokenId].minter;
        address owner = ownerOf(tokenId);
        uint32 federationId = tokenToFederationId[tokenId];

        if (_tokenToTimeSlot[tokenId].isSecondaryTradingEnabled == false) {
            require(
                isSecondaryTrade(from, to, tokenId) == false,
                "SECONDARY_TRADING_DISABLED"
            );
        }

        require(
            registry.isAuthorizedTransferFrom(federationId, from, to, tokenId, minter, owner),
            "UNAUTHORIZED_TRANSFER"
        );

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
     * @param data bytes data to send along with a safe transfer check
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
        public
        whenNotPaused
    {

        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "UNAUTHORIZED_TRANSFER"
        );

        address minter = _tokenToTimeSlot[tokenId].minter;
        address owner = ownerOf(tokenId);
        uint32 federationId = tokenToFederationId[tokenId];

        if (_tokenToTimeSlot[tokenId].isSecondaryTradingEnabled == false) {
            require(
                isSecondaryTrade(from, to, tokenId) == false,
                "SECONDARY_TRADING_DISABLED"
            );
        }

        require(
            registry.isAuthorizedTransferFrom(federationId, from, to, tokenId, minter, owner),
            "UNAUTHORIZED_TRANSFER"
        );

        _safeTransferFrom(from, to, tokenId, data);

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
     * @param data bytes data to send along with a safe transfer check
     */
    function _safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
        internal
    {

        _transferFrom(from, to, tokenId);

        require(
            _checkOnERC721Received(from, to, tokenId, data),
            "TRANSFER_TO_NON_ERC721RECEIVER_IMPLEMENTER"
        );

    }

    /**
     * @dev Returns whether the specified token exists.
     * @param tokenId uint256 ID of the token to query the existence of
     * @return bool whether the token exists
     */
    function _exists(uint256 tokenId) internal view returns (bool) {

        address tokenOwner = _tokenOwner[tokenId];

        return tokenOwner != address(0);

    }

    /**
     * @dev Returns whether the given spender can transfer a given token ID.
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     * is an operator of the owner, or is the owner of the token
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {

        require(
            _exists(tokenId),
            "NON_EXISTENT_TOKEN"
        );

        address tokenOwner = ownerOf(tokenId);

        return (spender == tokenOwner || getApproved(tokenId) == spender || isApprovedForAll(tokenOwner, spender));

    }

    /**
     * @dev Internal function to transfer ownership of a given token ID to another address.
     *      As opposed to {transferFrom}, this imposes no restrictions on msg.sender
     * @param from current owner of the token
     * @param to address to receive the ownership of the given token ID
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _transferFrom(address from, address to, uint256 tokenId) internal {

        require(
            ownerOf(tokenId) == from,
            "UNAUTHORIZED_TRANSFER"
        );

        require(
            to != address(0),
            "TRANSFER_TO_ZERO_ADDRESS"
        );

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
     * @param data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data)
        internal
        returns (bool)
    {

        if (!to.isContract()) {
            return true;
        }

        bytes4 retval = IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data);
        return (retval == _ERC721_RECEIVED);

    }

    /**
     * @dev Private function to clear current approval of a given token ID.
     * @param tokenId uint256 ID of the token to be transferred
     */
    function _clearApproval(uint256 tokenId) private {

        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }

    }


    /***  Burn Tokens  ***/


    // solhint-disable
    /**
     * @dev Customized for Microsponsors
     *      https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721Burnable.sol     * @dev Burns a specific ERC721 token.
     * @param tokenId uint256 id of the ERC721 token to be burned
     */
     // solhint-enable
    function burn(uint256 tokenId) public whenNotPaused {

        address minter = _tokenToTimeSlot[tokenId].minter;
        address tokenOwner = ownerOf(tokenId);
        uint32 federationId = tokenToFederationId[tokenId];

        if (tokenOwner == minter) {
            require(
                registry.isMinter(federationId, _msgSender()),
                "UNAUTHORIZED_BURN"
            );
        }

        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "UNAUTHORIZED_BURN"
        );

        _burn(tokenId);

    }


    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * Deprecated, use {_burn} instead.
     * @param tokenOwner owner of the token to burn
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(address tokenOwner, uint256 tokenId) internal {

        require(
            ownerOf(tokenId) == tokenOwner,
            "UNAUTHORIZED_BURN"
        );

        _clearApproval(tokenId);

        _ownedTokensCount[tokenOwner].decrement();
        _tokenOwner[tokenId] = address(0);

        // Clear token URIs (if any)
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }

        // Clear time slot data
        delete _tokenToTimeSlot[tokenId];

        emit Transfer(tokenOwner, address(0), tokenId);

    }

    /**
     * @dev Internal function to burn a specific token.
     * Reverts if the token does not exist.
     * @param tokenId uint256 ID of the token being burned
     */
    function _burn(uint256 tokenId) internal {

        _burn(ownerOf(tokenId), tokenId);

    }


    /***  Helper fns  ***/

    function stringsMatch (
        string memory a,
        string memory b
    )
        private
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }

    function isSecondaryTrade (
        address from,
        address to,
        uint256 tokenId
    )
        internal
        view
        returns (bool)
    {

        address minter = _tokenToTimeSlot[tokenId].minter;

        if (from == minter || to == minter) {
            return false;
        } else {
            return true;
        }

    }

}

// File: contracts/Microsponsors.sol


/**
 * Customized for Microsponsors
 * from Open Zeppelin's ERC721Metadata contract, which is MIT Licensed:
 * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721Metadata.sol

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

*/

contract Microsponsors is ERC721 {

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;


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
    constructor (string memory name, string memory symbol, address registryAddress) public {

        _name = name;
        _symbol = symbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);

        super.updateRegistryAddress(registryAddress);

    }

    /**
     * @dev Gets the token name.
     * @return string representing the token name
     */
    function name() public view returns (string memory) {	//inject PUBLIC FUNC TO EXTERNAL
        return _name;
    }

    /**
     * @dev Gets the token symbol.
     * @return string representing the token symbol
     */
    function symbol() public view returns (string memory) {	//inject PUBLIC FUNC TO EXTERNAL
        return _symbol;
    }

}