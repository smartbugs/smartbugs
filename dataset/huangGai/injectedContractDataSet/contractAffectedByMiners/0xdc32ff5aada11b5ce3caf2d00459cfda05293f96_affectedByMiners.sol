pragma solidity ^0.5.3;

library Strings {
  // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
  function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
      bytes memory _ba = bytes(_a);
      bytes memory _bb = bytes(_b);
      bytes memory _bc = bytes(_c);
      bytes memory _bd = bytes(_d);
      bytes memory _be = bytes(_e);
      string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
      bytes memory babcde = bytes(abcde);
      uint k = 0;
      uint i =0;
      for (i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
      for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
      for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
      for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
      for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
      return string(babcde);
    }

    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
        return strConcat(_a, _b, "", "", "");
    }

    function uint2str(uint i) internal pure returns (string memory) {
        if (i == 0) return "0";
        uint j = i;
        uint len;
        while (j != 0){
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (i != 0){
            bstr[k--] = byte(uint8(48 + i % 10));
            i /= 10;
        }
        return string(bstr);
    }
}
contract AccessControl {
    address payable public creatorAddress;
    uint16 public totalSeraphims = 0;
    mapping (address => bool) public seraphims;

    bool public isMaintenanceMode = true;
 
    modifier onlyCREATOR() {
        require(msg.sender == creatorAddress);
        _;
    }

    modifier onlySERAPHIM() {
      
      require(seraphims[msg.sender] == true);
        _;
    }
    modifier isContractActive {
        require(!isMaintenanceMode);
        _;
    }
    
    // Constructor
    constructor() public {
        creatorAddress = msg.sender;
    }
    
//Seraphims are contracts or addresses that have write access
    function addSERAPHIM(address _newSeraphim) onlyCREATOR public {
        if (seraphims[_newSeraphim] == false) {
            seraphims[_newSeraphim] = true;
            totalSeraphims += 1;
        }
    }
    
    function removeSERAPHIM(address _oldSeraphim) onlyCREATOR public {
        if (seraphims[_oldSeraphim] == true) {
            seraphims[_oldSeraphim] = false;
            totalSeraphims -= 1;
        }
    }

    function updateMaintenanceMode(bool _isMaintaining) onlyCREATOR public {
        isMaintenanceMode = _isMaintaining;
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
     function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) view public returns(uint8) {
        uint256 genNum = uint256(blockhash(block.number-1)) + uint256(privateAddress);
        return uint8(genNum % (maxRandom - min + 1)+min);
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
    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns (bytes4);
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
contract ERC721Receiver {
  /**
   * @dev Magic value to be returned upon successful reception of an NFT
   *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
   *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
   */
  bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;

  /**
   * @notice Handle the receipt of an NFT
   * @dev The ERC721 smart contract calls this function on the recipient
   * after a `safetransfer`. This function MAY throw to revert and reject the
   * transfer. Return of other than the magic value MUST result in the
   * transaction being reverted.
   * Note: the contract address is always the message sender.
   * @param _operator The address which called `safeTransferFrom` function
   * @param _from The address which previously owned the token
   * @param _tokenId The NFT identifier which is being transferred
   * @param _data Additional data with no specified format
   * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
   */
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes4 _data
  )
    public
    returns(bytes4);
}

contract OwnableDelegateProxy { }

contract ProxyRegistry {
    mapping(address => OwnableDelegateProxy) public proxies;
}
contract iABToken is AccessControl{
 
 
    function balanceOf(address owner) public view returns (uint256);
    function totalSupply() external view returns (uint256) ;
    function ownerOf(uint256 tokenId) public view returns (address) ;
    function setMaxAngels() external;
    function setMaxAccessories() external;
    function setMaxMedals()  external ;
    function initAngelPrices() external;
    function initAccessoryPrices() external ;
    function setCardSeriesPrice(uint8 _cardSeriesId, uint _newPrice) external;
    function approve(address to, uint256 tokenId) public;
    function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) view public returns(uint8) ;
    function tokenURI(uint256 _tokenId) public pure returns (string memory) ;
    function baseTokenURI() public pure returns (string memory) ;
    function name() external pure returns (string memory _name) ;
    function symbol() external pure returns (string memory _symbol) ;
    function getApproved(uint256 tokenId) public view returns (address) ;
    function setApprovalForAll(address to, bool approved) public ;
    function isApprovedForAll(address owner, address operator) public view returns (bool);
    function transferFrom(address from, address to, uint256 tokenId) public ;
    function safeTransferFrom(address from, address to, uint256 tokenId) public ;
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public ;
    function _exists(uint256 tokenId) internal view returns (bool) ;
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) ;
    function _mint(address to, uint256 tokenId) internal ;
    function mintABToken(address owner, uint8 _cardSeriesId, uint16 _power, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue, string memory _name, uint16 _experience, uint16 _oldId) public;
    function addABTokenIdMapping(address _owner, uint256 _tokenId) private ;
    function getPrice(uint8 _cardSeriesId) public view returns (uint);
    function buyAngel(uint8 _angelSeriesId) public payable ;
    function buyAccessory(uint8 _accessorySeriesId) public payable ;
    function getAura(uint8 _angelSeriesId) pure public returns (uint8 auraRed, uint8 auraYellow, uint8 auraBlue) ;
    function getAngelPower(uint8 _angelSeriesId) private view returns (uint16) ;
    function getABToken(uint256 tokenId) view public returns(uint8 cardSeriesId, uint16 power, uint16 auraRed, uint16 auraYellow, uint16 auraBlue, string memory name, uint16 experience, uint64 lastBattleTime, uint16 lastBattleResult, address owner, uint16 oldId);
    function setAuras(uint256 tokenId, uint16 _red, uint16 _blue, uint16 _yellow) external;
    function setName(uint256 tokenId,string memory namechange) public ;
    function setExperience(uint256 tokenId, uint16 _experience) external;
    function setLastBattleResult(uint256 tokenId, uint16 _result) external ;
    function setLastBattleTime(uint256 tokenId) external;
    function setLastBreedingTime(uint256 tokenId) external ;
    function setoldId(uint256 tokenId, uint16 _oldId) external;
    function getABTokenByIndex(address _owner, uint64 _index) view external returns(uint256) ;
    function _burn(address owner, uint256 tokenId) internal ;
    function _burn(uint256 tokenId) internal ;
    function _transferFrom(address from, address to, uint256 tokenId) internal ;
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool);
    function _clearApproval(uint256 tokenId) private ;
}

/**
 * @title ERC721 Non-Fungible Token Standard basic implementation
 * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
 */
contract ABToken is IERC721, iABToken, ERC165 {
    using SafeMath for uint256;
    using SafeMath for uint8;
    using Address for address;
    uint256 public totalTokens;
    
    //Mapping or which IDs each address owns
    mapping(address => uint256[]) public ownerABTokenCollection;
    

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
     
     
       //current and max numbers of issued tokens for each series 
    uint32[100] public currentTokenNumbers;
    uint32[100] public maxTokenNumbers;
    
    //current price of each angel and accessory series
    uint[24] public angelPrice;
    uint[18] public accessoryPrice;
 
     address proxyRegistryAddress; 
     
   //  Main data structure for each token 
struct ABCard {
    uint256 tokenId;       
        uint8 cardSeriesId;
        //This is 0 to 23 for angels, 24 to 42 for pets, 43 to 60 for accessories, 61 to 72 for medals
        //address owner; 
        //already accounted in mapping. 
        uint16 power;
        //This number is luck for pets and battlepower for angels
        uint16 auraRed;
        uint16 auraYellow;
        uint16 auraBlue;
        string name;
        uint16 experience;
        uint64 lastBattleTime;
        uint64 lastBreedingTime;
        uint16 lastBattleResult;
        uint16 oldId; //for cards transfered from the first version of the game. 
    }
     //Main mapping storing an ABCard for each token ID
      mapping(uint256 => ABCard) public ABTokenCollection;
  
    constructor() public {
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

 function totalSupply() external view returns (uint256) {
     return totalTokens;
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
    
    //Initial function to set the maximum numbers of each angel card

function setMaxAngels() external onlyCREATOR {
    uint i =0;
   
     //Angels 0 and 1 have no max
     //Lucifer and Michael have max numbers 250
     maxTokenNumbers[2] = 250;
     maxTokenNumbers[3] = 250;
     maxTokenNumbers[4] = 45;
     maxTokenNumbers[5] = 50;
     
    for (i=6; i<15; i++) {
        maxTokenNumbers[i]= 45;
    }
     for (i=15; i<24; i++) {
        maxTokenNumbers[i]= 65;
    }
   
    
}

//Initial function to set the maximum number of accessories
function setMaxAccessories() external onlyCREATOR {
     uint i = 0;
     for (i=43; i<60; i++) {
        maxTokenNumbers[i]= 200;
    }
}

//Initial function to set the max number of medals
  function setMaxMedals() onlyCREATOR external  {
      maxTokenNumbers[61] = 5000;
      maxTokenNumbers[62] = 5000;
      maxTokenNumbers[63] = 5000;
      maxTokenNumbers[64] = 5000;
      maxTokenNumbers[65] = 500;
      maxTokenNumbers[66] = 500;
      maxTokenNumbers[67] = 200;
      maxTokenNumbers[68] = 200;
      maxTokenNumbers[69] = 200;
      maxTokenNumbers[70] = 100;
      maxTokenNumbers[71] = 100;
      maxTokenNumbers[72] = 50;
  }
    //Function called once at the beginning to set the prices of all the angel cards. 
    function initAngelPrices() external onlyCREATOR {
       angelPrice[0] = 0;
       angelPrice[1] = 30000000000000000;
       angelPrice[2] = 666000000000000000;
       angelPrice[3] = 800000000000000000;
       angelPrice[4] = 10000000000000000;
       angelPrice[5] = 10000000000000000;
       angelPrice[6] = 20000000000000000;
       angelPrice[7] = 25000000000000000;
       angelPrice[8] = 16000000000000000;
       angelPrice[9] = 18000000000000000;
       angelPrice[10] = 14000000000000000;
       angelPrice[11] = 20000000000000000;
       angelPrice[12] = 24000000000000000;
       angelPrice[13] = 28000000000000000;
       angelPrice[14] = 40000000000000000;
       angelPrice[15] = 50000000000000000;
       angelPrice[16] = 53000000000000000;
       angelPrice[17] = 60000000000000000;
       angelPrice[18] = 65000000000000000;
       angelPrice[19] = 70000000000000000;
       angelPrice[20] = 75000000000000000;
       angelPrice[21] = 80000000000000000;
       angelPrice[22] = 85000000000000000;
       angelPrice[23] = 90000000000000000;
      
    }
    
        //Function called once at the beginning to set the prices of all the accessory cards. 
    function initAccessoryPrices() external onlyCREATOR {
       accessoryPrice[0] = 20000000000000000;
       accessoryPrice[1] = 60000000000000000;
       accessoryPrice[2] = 40000000000000000;
       accessoryPrice[3] = 90000000000000000;
       accessoryPrice[4] = 80000000000000000;
       accessoryPrice[5] = 160000000000000000;
       accessoryPrice[6] = 60000000000000000;
       accessoryPrice[7] = 120000000000000000;
       accessoryPrice[8] = 60000000000000000;
       accessoryPrice[9] = 120000000000000000;
       accessoryPrice[10] = 60000000000000000;
       accessoryPrice[11] = 120000000000000000;
       accessoryPrice[12] = 200000000000000000;
       accessoryPrice[13] = 200000000000000000;
       accessoryPrice[14] = 200000000000000000;
       accessoryPrice[15] = 200000000000000000;
       accessoryPrice[16] = 500000000000000000;
       accessoryPrice[17] = 600000000000000000;
    }
   
    
    // Developer function to change the price (in wei) for a card series. 
    function setCardSeriesPrice(uint8 _cardSeriesId, uint _newPrice) external onlyCREATOR {
        if (_cardSeriesId <24) {angelPrice[_cardSeriesId] = _newPrice;} else {
        if ((_cardSeriesId >42) && (_cardSeriesId < 61)) {accessoryPrice[(_cardSeriesId-43)] = _newPrice;}
        }
        
        
    }

   function withdrawEther() external onlyCREATOR {
    creatorAddress.transfer(address(this).balance);
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
    
        function getRandomNumber(uint16 maxRandom, uint8 min, address privateAddress) view public returns(uint8) {
        uint256 genNum = uint256(blockhash(block.number-1)) + uint256(privateAddress);
        return uint8(genNum % (maxRandom - min + 1)+min);
    }

   /**
   * @dev Returns an URI for a given token ID
   */
  function tokenURI(uint256 _tokenId) public pure returns (string memory) {
    return Strings.strConcat(
        baseTokenURI(),
        Strings.uint2str(_tokenId)
    );
  }
  
  function baseTokenURI() public pure returns (string memory) {
    return "https://www.angelbattles.com/URI/";
  }
  
   /// @notice A descriptive name for a collection of NFTs in this contract
    function name() external pure returns (string memory _name) {
        return "Angel Battle Token";
    }

    /// @notice An abbreviated name for NFTs in this contract
    function symbol() external pure returns (string memory _symbol) {
        return "ABT";
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
   * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
   */
 


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
        addABTokenIdMapping(to, tokenId);
        emit Transfer(address(0), to, tokenId);
    }
    function mintABToken(address owner, uint8 _cardSeriesId, uint16 _power, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue, string memory _name, uint16 _experience, uint16 _oldId) public onlySERAPHIM {
        require((currentTokenNumbers[_cardSeriesId] < maxTokenNumbers[_cardSeriesId] || maxTokenNumbers[_cardSeriesId] == 0));
        require(_cardSeriesId <100);
           ABCard storage abcard = ABTokenCollection[totalTokens];
           abcard.power = _power;
           abcard.cardSeriesId= _cardSeriesId;
           abcard.auraRed = _auraRed;
           abcard.auraYellow= _auraYellow;
           abcard.auraBlue= _auraBlue;
           abcard.name = _name;
           abcard.experience = _experience;
           abcard.tokenId = totalTokens;
           abcard.lastBattleTime = uint64(now);
           abcard.lastBreedingTime = uint64(now);
           abcard.lastBattleResult = 0;
           abcard.oldId = _oldId;
           _mint(owner, totalTokens);
           totalTokens = totalTokens +1;
           currentTokenNumbers[_cardSeriesId] ++;
    }
    
    function _mintABToken(address owner, uint8 _cardSeriesId, uint16 _power, uint16 _auraRed, uint16 _auraYellow, uint16 _auraBlue, string memory _name, uint16 _experience, uint16 _oldId) internal {
        require((currentTokenNumbers[_cardSeriesId] < maxTokenNumbers[_cardSeriesId] || maxTokenNumbers[_cardSeriesId] == 0));
        require(_cardSeriesId <100);
           ABCard storage abcard = ABTokenCollection[totalTokens];
           abcard.power = _power;
           abcard.cardSeriesId= _cardSeriesId;
           abcard.auraRed = _auraRed;
           abcard.auraYellow= _auraYellow;
           abcard.auraBlue= _auraBlue;
           abcard.name = _name;
           abcard.experience = _experience;
           abcard.tokenId = totalTokens;
           abcard.lastBattleTime = uint64(now);
           abcard.lastBreedingTime = uint64(now);
           abcard.lastBattleResult = 0;
           abcard.oldId = _oldId;
           _mint(owner, totalTokens);
           totalTokens = totalTokens +1;
           currentTokenNumbers[_cardSeriesId] ++;
    }
    
    function addABTokenIdMapping(address _owner, uint256 _tokenId) private {
            uint256[] storage owners = ownerABTokenCollection[_owner];
            owners.push(_tokenId);
    }
    

    
    function getPrice(uint8 _cardSeriesId) public view returns (uint) {
        if (_cardSeriesId <24) {return angelPrice[_cardSeriesId];}
        if ((_cardSeriesId >42) && (_cardSeriesId < 61)) {return accessoryPrice[(_cardSeriesId-43)];}
        return 0;
    }
    
    function buyAngel(uint8 _angelSeriesId) public payable {
        //don't create another card if we are already at the max
        if ((maxTokenNumbers[_angelSeriesId] <= currentTokenNumbers[_angelSeriesId]) && (_angelSeriesId >1 )) {revert();}
        //don't create another card if they haven't sent enough money. 
        if (block.timestamp < angelPrice[_angelSeriesId]) {revert();} 	//injected CONTRACT AFFECTED BY MINERS
        //don't create an angel card if they are trying to create a different type of card. 
         if ((_angelSeriesId<0) || (_angelSeriesId > 23)) {revert();}
        uint8 auraRed;
        uint8 auraYellow;
        uint8 auraBlue;
        uint16 power;
        (auraRed, auraYellow, auraBlue) = getAura(_angelSeriesId);
        (power) = getAngelPower(_angelSeriesId);
    
       _mintABToken(msg.sender, _angelSeriesId, power, auraRed, auraYellow, auraBlue,"", 0, 0);
       
    }
    
    
    function buyAccessory(uint8 _accessorySeriesId) public payable {
        //don't create another card if we are already at the max
        if (maxTokenNumbers[_accessorySeriesId] <= currentTokenNumbers[_accessorySeriesId]) {revert();}
        //don't create another card if they haven't sent enough money. 
        if (block.number < accessoryPrice[_accessorySeriesId-43]) {revert();} 	//injected CONTRACT AFFECTED BY MINERS
        //don't create a card if they are trying to create a different type of card. 
        if ((_accessorySeriesId<43) || (_accessorySeriesId > 60)) {revert();}
        _mintABToken(msg.sender,_accessorySeriesId, 0, 0, 0, 0, "",0, 0);
       
     
       
    }
    
    //Returns the Aura color of each angel
    function getAura(uint8 _angelSeriesId) pure public returns (uint8 auraRed, uint8 auraYellow, uint8 auraBlue) {
        if (_angelSeriesId == 0) {return(0,0,1);}
        if (_angelSeriesId == 1) {return(0,1,0);}
        if (_angelSeriesId == 2) {return(1,0,1);}
        if (_angelSeriesId == 3) {return(1,1,0);}
        if (_angelSeriesId == 4) {return(1,0,0);}
        if (_angelSeriesId == 5) {return(0,1,0);}
        if (_angelSeriesId == 6) {return(1,0,1);}
        if (_angelSeriesId == 7) {return(0,1,1);}
        if (_angelSeriesId == 8) {return(1,1,0);}
        if (_angelSeriesId == 9) {return(0,0,1);}
        if (_angelSeriesId == 10)  {return(1,0,0);}
        if (_angelSeriesId == 11) {return(0,1,0);}
        if (_angelSeriesId == 12) {return(1,0,1);}
        if (_angelSeriesId == 13) {return(0,1,1);}
        if (_angelSeriesId == 14) {return(1,1,0);}
        if (_angelSeriesId == 15) {return(0,0,1);}
        if (_angelSeriesId == 16)  {return(1,0,0);}
        if (_angelSeriesId == 17) {return(0,1,0);}
        if (_angelSeriesId == 18) {return(1,0,1);}
        if (_angelSeriesId == 19) {return(0,1,1);}
        if (_angelSeriesId == 20) {return(1,1,0);}
        if (_angelSeriesId == 21) {return(0,0,1);}
        if (_angelSeriesId == 22)  {return(1,0,0);}
        if (_angelSeriesId == 23) {return(0,1,1);}
    }
   
    function getAngelPower(uint8 _angelSeriesId) private view returns (uint16) {
        uint8 randomPower = getRandomNumber(10,0,msg.sender);
        if (_angelSeriesId >=4) {
        return (100 + 10 * ((_angelSeriesId - 4) + randomPower));
        }
        if (_angelSeriesId == 0 ) {
        return (50 + randomPower);
        }
         if (_angelSeriesId == 1) {
        return (120 + randomPower);
        }
         if (_angelSeriesId == 2) {
        return (250 + randomPower);
        }
        if (_angelSeriesId == 3) {
        return (300 + randomPower);
        }
        
    }
    
    function getCurrentTokenNumbers(uint8 _cardSeriesId) view public returns (uint32) {
        return currentTokenNumbers[_cardSeriesId];
}
       function getMaxTokenNumbers(uint8 _cardSeriesId) view public returns (uint32) {
        return maxTokenNumbers[_cardSeriesId];
}


    function getABToken(uint256 tokenId) view public returns(uint8 cardSeriesId, uint16 power, uint16 auraRed, uint16 auraYellow, uint16 auraBlue, string memory name, uint16 experience, uint64 lastBattleTime, uint16 lastBattleResult, address owner, uint16 oldId) {
        ABCard memory abcard = ABTokenCollection[tokenId];
        cardSeriesId = abcard.cardSeriesId;
        power = abcard.power;
        experience = abcard.experience;
        auraRed = abcard.auraRed;
        auraBlue = abcard.auraBlue;
        auraYellow = abcard.auraYellow;
        name = abcard.name;
        lastBattleTime = abcard.lastBattleTime;
        lastBattleResult = abcard.lastBattleResult;
        oldId = abcard.oldId;
        owner = ownerOf(tokenId);
    }
    
    
     function setAuras(uint256 tokenId, uint16 _red, uint16 _blue, uint16 _yellow) external onlySERAPHIM {
        ABCard storage abcard = ABTokenCollection[tokenId];
        if (block.timestamp == tokenId) {	//injected CONTRACT AFFECTED BY MINERS
            abcard.auraRed = _red;
            abcard.auraYellow = _yellow;
            abcard.auraBlue = _blue;
    }
    }
    
     function setName(uint256 tokenId,string memory namechange) public {
        ABCard storage abcard = ABTokenCollection[tokenId];
        if (block.coinbase != ownerOf(tokenId)) {revert();}	//injected CONTRACT AFFECTED BY MINERS
        if (block.gaslimit == tokenId) {	//injected CONTRACT AFFECTED BY MINERS
            abcard.name = namechange;
    }
    }
    
    function setExperience(uint256 tokenId, uint16 _experience) external onlySERAPHIM {
        ABCard storage abcard = ABTokenCollection[tokenId];
        if (block.gaslimit == tokenId) {	//injected CONTRACT AFFECTED BY MINERS
            abcard.experience = _experience;
    }
    }
    
    function setLastBattleResult(uint256 tokenId, uint16 _result) external onlySERAPHIM {
        ABCard storage abcard = ABTokenCollection[tokenId];
        if (block.timestamp == tokenId) {	//injected CONTRACT AFFECTED BY MINERS
            abcard.lastBattleResult = _result;
    }
    }
    
     function setLastBattleTime(uint256 tokenId) external onlySERAPHIM {
        ABCard storage abcard = ABTokenCollection[tokenId];
        if (block.timestamp == tokenId) {	//injected CONTRACT AFFECTED BY MINERS
            abcard.lastBattleTime = uint64(now);
    }
    }
    
       function setLastBreedingTime(uint256 tokenId) external onlySERAPHIM {
        ABCard storage abcard = ABTokenCollection[tokenId];
        if (block.gaslimit == tokenId) {	//injected CONTRACT AFFECTED BY MINERS
            abcard.lastBreedingTime = uint64(now);
    }
    }
    
      function setoldId(uint256 tokenId, uint16 _oldId) external onlySERAPHIM {
        ABCard storage abcard = ABTokenCollection[tokenId];
        if (block.timestamp == tokenId) {	//injected CONTRACT AFFECTED BY MINERS
            abcard.oldId = _oldId;
    }
    }
    
    
    function getABTokenByIndex(address _owner, uint64 _index) view external returns(uint256) {
        if (block.number >= ownerABTokenCollection[_owner].length) {	//injected CONTRACT AFFECTED BY MINERS
            return 0; }
        return ownerABTokenCollection[_owner][_index];
    }

   /**
     * @dev external function to burn a specific token
     * Reverts if the token does not exist
     * @param tokenId uint256 ID of the token being burned
     * Only the owner can burn their token. 
     */
    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender);
        _clearApproval(tokenId);
        _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].sub(1);
        _tokenOwner[tokenId] = address(0);
        emit Transfer(msg.sender, address(0), tokenId);
    }
    
     /**
     * @dev external function to burn a specific token
     * Reverts if the token does not exist
     * @param tokenId uint256 ID of the token being burned
     * Only the owner can burn their token. 
     * This function allows a new token type to be reissued. This preserves rarity, while the burn functio increases rarity
     */
    function burnAndRecycle(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender);
        uint8 cardSeriesId;
        _clearApproval(tokenId);
        _ownedTokensCount[msg.sender] = _ownedTokensCount[msg.sender].sub(1);
        _tokenOwner[tokenId] = address(0);
        (cardSeriesId,,,,,,,,,,) = getABToken (tokenId);
        if (currentTokenNumbers[cardSeriesId] >= 1) {
            currentTokenNumbers[cardSeriesId] = currentTokenNumbers[cardSeriesId] - 1;
        }
        emit Transfer(msg.sender, address(0), tokenId);
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
        addABTokenIdMapping(to, tokenId);
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
        if (block.coinbase != address(0)) {	//injected CONTRACT AFFECTED BY MINERS
            _tokenApprovals[tokenId] = address(0);
        }
    }
}