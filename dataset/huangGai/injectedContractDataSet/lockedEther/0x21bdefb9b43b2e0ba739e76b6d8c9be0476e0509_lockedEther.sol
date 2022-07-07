pragma solidity ^0.5.3;

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // assert(_b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}

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
    // solium-disable-next-line security/no-inline-assembly
    assembly { size := extcodesize(account) }
    return size > 0;
  }

}

library SafeERC20 {
    function safeTransfer(
      ERC20Basic _token,
      address _to,
      uint256 _value
    )
      internal
    {
      require(_token.transfer(_to, _value));
    }
  
    function safeTransferFrom(
      ERC20 _token,
      address _from,
      address _to,
      uint256 _value
    )
      internal
    {
      require(_token.transferFrom(_from, _to, _value));
    }
  
    function safeApprove(
      ERC20 _token,
      address _spender,
      uint256 _value
    )
      internal
    {
        require(_token.approve(_spender, _value));
    }
}

contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    emit Unpause();
  }
}

contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address _who) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}
  
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) internal balances;

  uint256 internal totalSupply_;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value <= balances[msg.sender]);
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}

contract ERC20 is ERC20Basic {
  function allowance(address _owner, address _spender)
    public view returns (uint256);

  function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool);

  function approve(address _spender, uint256 _value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(_to != address(0));

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract PausableToken is StandardToken, Pausable {

  function transfer(
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.transfer(_to, _value);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(
    address _spender,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.approve(_spender, _value);
  }

  function increaseApproval(
    address _spender,
    uint _addedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(
    address _spender,
    uint _subtractedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}

contract AccessControl is Ownable, Pausable {

    /// @dev The addresses of the accounts (or contracts) that can execute actions within each roles.
    address payable public ceoAddress;
    address payable public cfoAddress;
    address payable public cooAddress;
    address payable public cmoAddress;
    address payable public BAEFeeAddress;
    address payable public owner = msg.sender;

    /// @dev Access modifier for CEO-only functionality
    modifier onlyCEO() {
        require(
            msg.sender == ceoAddress,
            "Only our CEO address can execute this function");
        _;
    }

    /// @dev Access modifier for CFO-only functionality
    modifier onlyCFO() {
        require(
            msg.sender == cfoAddress,
            "Only our CFO can can ll this function");
        _;
    }

    /// @dev Access modifier for COO-only functionality
    modifier onlyCOO() {
        require(
            msg.sender == cooAddress,
            "Only our COO can can ll this function");
        _;
    }

    /// @dev Access modifier for Clevel functions
    modifier onlyCLevelOrOwner() {
        require(
            msg.sender == cooAddress ||
            msg.sender == ceoAddress ||
            msg.sender == cfoAddress ||
            msg.sender == owner,
            "You need to be the owner or a Clevel @BAE to call this function"
        );
        _;
    }
    

    /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.
    /// @param _newCEO The address of the new CEO
    function setCEO(address payable _newCEO) external onlyCEO whenNotPaused {
        require(_newCEO != address(0));
        ceoAddress = _newCEO;
    }

    /// @dev Assigns a new address to act as the CFO. Only available to the current CEO.
    /// @param _newCFO The address of the new CFO
    function setCFO(address payable _newCFO) external onlyCLevelOrOwner whenNotPaused {
        require(_newCFO != address(0));
        cfoAddress = _newCFO;
    }

    /// @dev Assigns a new address to act as the COO. Only available to the current CEO.
    /// @param _newCOO The address of the new COO
    function setCOO(address payable _newCOO) external onlyCLevelOrOwner whenNotPaused {
        require(_newCOO != address(0));
        cooAddress = _newCOO;
    }
     /// @dev Assigns a new address to act as the CMO. 
    /// @param _newCMO The address of the new CMO
    function setCMO(address payable _newCMO) external onlyCLevelOrOwner whenNotPaused {
        require(_newCMO != address(0));
        cmoAddress = _newCMO;
    }

    function getBAEFeeAddress() external view onlyCLevelOrOwner returns (address) {
        return BAEFeeAddress;
    }

    function setBAEFeeAddress(address payable _newAddress) public onlyCLevelOrOwner {
        BAEFeeAddress = _newAddress;
    }

    // Only the CEO, COO, and CFO can execute this function:
    function pause() public onlyCLevelOrOwner whenNotPaused {
        paused = true;
        emit Pause();
    }

    function unpause() public onlyCLevelOrOwner whenPaused {
        paused = false;
        emit Unpause();
    }
}

contract Destructible is AccessControl {

    /**
    * @dev Transfers the current balance to the owner and terminates the contract
    *      onlyOwner needs to be changed to onlyBAE
    */
    function destroy() public onlyCLevelOrOwner whenPaused{
        selfdestruct(owner);
    }

    /**
    * @dev Transfers the current balance to the address and terminates the contract.
    */
    function destroyAndSend(address payable _recipient) public onlyCLevelOrOwner whenPaused {
        selfdestruct(_recipient);
    }
}

contract ArtShop is Destructible {
    using SafeMath for uint256;

    /// @dev this fires everytime an artpiece is created
    event NewArtpiece(uint pieceId, string  name, string artist);
    /// @dev this is set up to track how many changes the url has been changed
    event UrlChange(uint pieceId);

    /// @dev - both baeFeeLevel and royaltyFeeLevel are percentages and the combined should be
    ///        kept below 95% on first sale or 99% on secondary sale :)
    uint8 internal baeFeeLevel;
    uint8 internal royaltyFeeLevel;
    uint8 internal potFeeLevel = 5;

    /// @dev this is used to prevent constant movement of art   
    uint32 public timeUntilAbleToTransfer = 1 hours;

    /// @dev all metadata relating to an artpiece
    /// @dev this is done to prevent the error: Stacktrace too long as per 
    /// @dev https://ethereum.stackexchange.com/questions/7325/stack-too-deep-try-removing-local-variables
    struct ArtpieceMetaData {
        uint8 remainingPrintings;
        uint64 basePrice; ///@dev listing price
        uint256 dateCreatedByTheArtist;
        string notes;
        bool isFirstSale;
        bool physical;
    }

    /// @dev all properties of an artpiece
    struct Artpiece {
        string name; /// @dev - should this change? I don't think so
        string artist; ///@dev artist's name for now - might be good to be an id/hash
        string thumbnailUrl;
        string mainUrl;
        string grade;
        uint64 price; /// @dev current price
        uint8 feeLevel; /// @dev this is the royalty fee
        uint8 baeFeeLevel;
        ArtpieceMetaData metadata;
    }

    Artpiece[] artpieces;

    mapping (uint256 => address) public numArtInAddress;
    mapping (address => uint256) public artCollection;
    mapping (uint256 => address) public artpieceApproved;

    /// @dev contract-specific modifiers on fees
    modifier onlyWithGloballySetFee() {
        require(
            baeFeeLevel > 0,
            "Requires a fee level to be set up"
        );
        require(
            royaltyFeeLevel > 0,
            "Requires a an artist fee level to be set up"
        );
        _;
    }

    /// @dev this is the gloabal fee setter
    /// @dev setBAEFeeLevel should be 35 initially on first sale
    function setBAEFeeLevel(uint8 _newFee) public onlyCLevelOrOwner {
        baeFeeLevel = _newFee;
    }

    function setRoyaltyFeeLevel(uint8 _newFee) public onlyCLevelOrOwner {
        royaltyFeeLevel = _newFee;
    }
    
    function _createArtpiece(
        string memory _name,
        string memory _artist,
        string memory _thumbnailUrl,
        string memory _mainUrl,
        string memory _notes,
        string memory _grade,
        uint256 _dateCreatedByTheArtist,
        uint64 _price,
        uint64 _basePrice,
        uint8 _remainingPrintings,
        bool _physical
        )  
        internal
        onlyWithGloballySetFee
        whenNotPaused
        {
        
        ArtpieceMetaData memory metd = ArtpieceMetaData(
                _remainingPrintings,
                _basePrice,
                _dateCreatedByTheArtist,
                _notes,
                true,
                _physical
        ); 
            
        Artpiece memory newArtpiece = Artpiece(
            _name,
            _artist,
            _thumbnailUrl,
            _mainUrl,
            _grade,
            _price,
            royaltyFeeLevel,
            baeFeeLevel,
            metd
        );
        uint id = artpieces.push(newArtpiece) - 1;

        numArtInAddress[id] = msg.sender;
        artCollection[msg.sender] = artCollection[msg.sender].add(1);
            
        emit NewArtpiece(id, _name, _artist);
    }
}

contract Helpers is ArtShop {
    
        /// @dev modifiers for the ERC721-compliant functions
    modifier onlyOwnerOf(uint _artpieceId) {
        require(msg.sender == numArtInAddress[_artpieceId]);
        _;
    }
    
    /// @dev we use this so we can't delete artpieces once they are on auction
    ///      so people have the feeling they really own the 
    modifier onlyBeforeFirstSale(uint _tokenId) {
        (,,,,bool isFirstSale,) = getArtpieceMeta(_tokenId);
        require(isFirstSale == true);
        _;
    }

    event Printed(uint indexed _id, uint256 indexed _time);
    
    function getArtpieceData(uint _id) public view returns(string memory name, string memory artist, string memory thumbnailUrl, string memory grade, uint64 price) {
        return (
            artpieces[_id].name, 
            artpieces[_id].artist, 
            artpieces[_id].thumbnailUrl, 
            artpieces[_id].grade,
            artpieces[_id].price 
        );
    }
    
    function getArtpieceFeeLevels(uint _id) public view returns(uint8, uint8) {
        return (
            artpieces[_id].feeLevel,
            artpieces[_id].baeFeeLevel
        );
    }
    
    function getArtpieceMeta(uint _id) public view returns(uint8, uint64, uint256, string memory, bool, bool) {
        return (
            artpieces[_id].metadata.remainingPrintings, 
            artpieces[_id].metadata.basePrice, 
            artpieces[_id].metadata.dateCreatedByTheArtist, 
            artpieces[_id].metadata.notes, 
            artpieces[_id].metadata.isFirstSale, 
            artpieces[_id].metadata.physical
        );
    }
    
    function getMainUrl(uint _id) public view onlyOwnerOf(_id) returns(string memory) {
        return artpieces[_id].mainUrl;
    }

    function setArtpieceName(uint _id, string memory _name) public onlyCLevelOrOwner whenNotPaused {
        artpieces[_id].name = _name;
    }

    function setArtist(uint _id, string memory _artist) public onlyCLevelOrOwner whenNotPaused {
        artpieces[_id].artist = _artist;
    }

    function setThumbnailUrl(uint _id, string memory _newThumbnailUrl) public onlyCLevelOrOwner whenNotPaused {
        artpieces[_id].thumbnailUrl = _newThumbnailUrl;
    }

    // this used to be internal
    function setMainUrl(uint _id, string memory _newUrl) public onlyCLevelOrOwner whenNotPaused {
        artpieces[_id].mainUrl = _newUrl;
        emit UrlChange(_id);
    }

    function setGrade(uint _id, string memory _grade) public onlyCLevelOrOwner whenNotPaused returns (bool success) {
        artpieces[_id].grade = _grade;
        return true;
    }

    function setPrice(uint _id, uint64 _price) public onlyCLevelOrOwner whenNotPaused {
        artpieces[_id].price = _price;
    }

    function setArtpieceBAEFee(uint _id, uint8 _newFee) public onlyCLevelOrOwner whenNotPaused {
        artpieces[_id].baeFeeLevel = _newFee;
    }

    function setArtpieceRoyaltyFeeLevel(uint _id, uint8 _newFee) public onlyCLevelOrOwner whenNotPaused {
        artpieces[_id].feeLevel = _newFee;
    }

    function setRemainingPrintings(uint _id, uint8 _remainingPrintings) internal onlyCLevelOrOwner whenNotPaused {
        artpieces[_id].metadata.remainingPrintings = _remainingPrintings;
    }
    
    function setBasePrice(uint _id, uint64 _basePrice) public onlyCLevelOrOwner {
        artpieces[_id].metadata.basePrice = _basePrice;
    }

    function setDateCreateByArtist(uint _id, uint256 _dateCreatedByTheArtist) public onlyCLevelOrOwner {
        artpieces[_id].metadata.dateCreatedByTheArtist = _dateCreatedByTheArtist;
    }

    function setNotes(uint _id, string memory _notes) public onlyCLevelOrOwner {
        artpieces[_id].metadata.notes = _notes;
    }

    function setIsPhysical(uint _id, bool _physical) public onlyCLevelOrOwner {
        artpieces[_id].metadata.physical = _physical;
    }
    
    function getArtpiecesByOwner(address _owner) external view returns(uint[] memory) {
        uint[] memory result = new uint[](artCollection[_owner]);
        uint counter = 0;

        for ( uint i = 0; i < artpieces.length; i++ ) {
            if (numArtInAddress[i] == _owner) {
                result[counter] = i;
                counter = counter.add(1);
            }
        }

        return result;
    }
}

contract BAEToken is PausableToken, AccessControl  {
    using SafeMath for uint256;
    using SafeERC20 for ERC20;

    event Mint(address indexed to, uint256 amount);
    event MintFinished();
    event Burn(address indexed burner, uint256 value);
   
    string public constant name = "BAEToken";
    string public constant symbol = "BAE";
    uint public constant decimals = 6;
    uint public currentAmount = 0; // rate is 11 == 10 BAE based on 100 000 000 = 10,000,000
    uint public totalAllocated = 0;
    bool public mintingFinished = false;
    uint256 public currentIndex = 0;

    /// @dev - holder adresses by index
    mapping(uint => address) public holderAddresses;

    /// @dev total supply assigned to msg.sender directly
    constructor() public {
        totalSupply_ = 0;
    }

    modifier validDestination(address _to)
    {
        require(_to != address(0x0));
        require(_to != address(this)); 
        _;
    }

    modifier canMint() {
        require(
            !mintingFinished,
            "Still minting."
        );
        _;
    }

    modifier hasMintPermission() {
        require(
            msg.sender == owner,
            "Message sender is not owner."
        );
        _;
    }

    modifier onlyWhenNotMinting() {
        require(
            mintingFinished == false,
            "Minting needs to be stopped to execute this function"
        );
        _;
    }

    /** 
     * @dev getter for name
     */
    function getName() public pure returns (string memory) {
        return name;
    }

    /** 
     * @dev getter for token symbol
     */
    function getSymbol() public pure returns (string memory) {
        return symbol;
    }

    /** 
     * @dev getter for totalSupply_
     */
    function getTotalSupply() public view returns (uint) {
        return totalSupply_;
    }

    /** 
     * @dev getter for user amount
     */
    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    /// @dev this is a superuser function to check each wallet amount
    function getUserBalance(address _userAddress) public view onlyCLevelOrOwner returns(uint) {
        return balances[_userAddress];
    }
    
    /** 
     * @dev private 
     */
    function burn(address _who, uint256 _value) public onlyCEO whenNotPaused {
        require(
            _value <= balances[_who],
            "Value is smaller than the value the account in balances has"
        );
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        // BAEholders[_who] = BAEholders[_who].sub(_value);
        totalSupply_ = totalSupply_.sub(_value);
        totalAllocated = totalAllocated.sub(_value);
        balances[_who] = balances[_who].sub(_value);
        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }

    /**
    * @dev Function to mint tokens
    * @param _to The address that will receive the minted tokens.
    * @param _amount The amount of tokens to mint.
    * @return A boolean that indicates if the operation was successful.
    */
    function mint(
        address _to,
        uint256 _amount
    )
    public
    canMint
    onlyCLevelOrOwner
    whenNotPaused
    returns (bool) {
        totalSupply_ = totalSupply_.add(_amount);
        totalAllocated = totalAllocated.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    /**
    * @dev Function to stop minting new tokens.
    * @return True if the operation was successful.
    */
    function finishMinting() 
    public 
    onlyCEO
    canMint
    whenNotPaused
    returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }


    /** ------------------------------------------------------------------------
     *  @dev - Owner can transfer out ERC20 tokens
     *  ------------------------------------------------------------------------ 
    // */    

    /// @dev - we `override` the ability of calling those methods to be allowed only of the owner
    ///        or the C level as the tokens shouldn't have any money properties.
    function transfer(address _to, uint256 _value) public onlyCLevelOrOwner returns (bool) {
        /// @dev call the super function transfer as is
        super.transfer(_to, _value);
        
        /// @dev and add the required
        totalAllocated = totalAllocated.add(_value);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        holderAddresses[currentIndex] = _to;
        currentIndex = currentIndex.add(1);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
    public
    onlyCLevelOrOwner
    returns (bool) {
        super.transferFrom(_from, _to, _value);
        totalAllocated = totalAllocated.add(_value);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        holderAddresses[currentIndex] = _to;
        currentIndex = currentIndex.add(1);
        return true;
    }


    function approve(address _spender, uint256 _value) public onlyCLevelOrOwner returns (bool) {
        super.approve(_spender, _value);
    }
    

}

contract Payments is BAEToken {
    
    event PotPayout(address indexed _to, uint256 indexed value);

    BAECore public baeInstance;
    
    constructor() public {
        ceoAddress = msg.sender;
    }

    function setBAECoreAddress(address payable _address) public onlyCEO whenPaused {
        BAECore baeCandidate = BAECore(_address);
        baeInstance = baeCandidate;
    }
    
    /// @dev - Update balances - % of ownership
    function addToBAEHolders(address _to) public onlyCLevelOrOwner whenNotPaused {
        mint(_to, currentAmount);
    }
    
    function subToBAEHolders(address _from, address _to, uint _amount) public onlyCLevelOrOwner whenNotPaused {
        transferFrom(_from, _to, _amount);
    }
    
    function setFinalPriceInPounds(uint _finalPrice) public onlyCLevelOrOwner whenNotPaused {
        currentAmount = _finalPrice.mul(10000000);
    }
    
    function withdraw() public onlyCFO {
        cfoAddress.transfer(0);
    }
    
    function() external payable { }
}

interface IERC165 {

  /**
  * @notice Query if a contract implements an interface
  * @param interfaceId The interface identifier, as specified in ERC-165
  * @dev Interface identification is specified in ERC-165. This function
  * uses less than 30,000 gas.
  */
  function supportsInterface(bytes4 interfaceId)
    external
    view
    returns (bool);
}

contract IERC721 is IERC165 {

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 indexed tokenId
  );
  event Approval(
    address indexed owner,
    address indexed approved,
    uint256 indexed tokenId
  );
  event ApprovalForAll(
    address indexed owner,
    address indexed operator,
    bool approved
  );

  function balanceOf(address owner) public view returns (uint256 balance);
  function ownerOf(uint256 tokenId) public view returns (address owner);

  function approve(address to, uint256 tokenId) public;
  function getApproved(uint256 tokenId)
    public view returns (address operator);

  function setApprovalForAll(address operator, bool _approved) public;
  function isApprovedForAll(address owner, address operator)
    public view returns (bool);

  function transferFrom(address from, address to, uint256 tokenId) public;
  function safeTransferFrom(address from, address to, uint256 tokenId)
    public;

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory data
  )
    public;
}

contract IERC721Metadata is IERC721 {
  function name() external view returns (string memory);
  function symbol() external view returns (string memory);
  function tokenURI(uint256 tokenId) public view returns (string memory);
}

contract IERC721Enumerable is IERC721 {
  function totalSupply() public view returns (uint256);
  function tokenOfOwnerByIndex(
    address owner,
    uint256 index
  )
    public
    view
    returns (uint256 tokenId);

  function tokenByIndex(uint256 index) public view returns (uint256);
}

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
  function onERC721Received(
    address operator,
    address from,
    uint256 tokenId,
    bytes memory data
  )
    public
    returns(bytes4);
}

contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
}

contract ERC165 is IERC165 {

  bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
  /**
  * 0x01ffc9a7 ===
  *   bytes4(keccak256('supportsInterface(bytes4)'))
  */

  /**
  * @dev a mapping of interface id to whether or not it's supported
  */
  mapping(bytes4 => bool) internal _supportedInterfaces;

  /**
  * @dev A contract implementing SupportsInterfaceWithLookup
  * implement ERC165 itself
  */
  constructor()
    public
  {
    _registerInterface(_InterfaceId_ERC165);
  }

  /**
  * @dev implement supportsInterface(bytes4) using a lookup table
  */
  function supportsInterface(bytes4 interfaceId)
    external
    view
    returns (bool)
  {
    return _supportedInterfaces[interfaceId];
  }

  /**
  * @dev private method for registering an interface
  */
  function _registerInterface(bytes4 interfaceId)
    internal
  {
    require(interfaceId != 0xffffffff);
    _supportedInterfaces[interfaceId] = true;
  }
}

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

  bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
  /*
  * 0x80ac58cd ===
  *   bytes4(keccak256('balanceOf(address)')) ^
  *   bytes4(keccak256('ownerOf(uint256)')) ^
  *   bytes4(keccak256('approve(address,uint256)')) ^
  *   bytes4(keccak256('getApproved(uint256)')) ^
  *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
  *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
  *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
  *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
  *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
  */

  constructor()
    public
  {
    // register the supported interfaces to conform to ERC721 via ERC165
    _registerInterface(_InterfaceId_ERC721);
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
  function isApprovedForAll(
    address owner,
    address operator
  )
    public
    view
    returns (bool)
  {
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
  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  )
    public
  {
    require(_isApprovedOrOwner(msg.sender, tokenId));
    require(to != address(0));

    _clearApproval(from, tokenId);
    _removeTokenFrom(from, tokenId);
    _addTokenTo(to, tokenId);

    emit Transfer(from, to, tokenId);
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
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  )
    public
  {
    // solium-disable-next-line arg-overflow
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
  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  )
    public
  {
    transferFrom(from, to, tokenId);
    // solium-disable-next-line arg-overflow
    require(_checkAndCallSafeTransfer(from, to, tokenId, _data));
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
  *  is an operator of the owner, or is the owner of the token
  */
  function _isApprovedOrOwner(
    address spender,
    uint256 tokenId
  )
    internal
    view
    returns (bool)
  {
    address owner = ownerOf(tokenId);
    // Disable solium check because of
    // https://github.com/duaraghav8/Solium/issues/175
    // solium-disable-next-line operator-whitespace
    return (
      spender == owner ||
      getApproved(tokenId) == spender ||
      isApprovedForAll(owner, spender)
    );
  }

  /**
  * @dev Internal function to mint a new token
  * Reverts if the given token ID already exists
  * @param to The address that will own the minted token
  * @param tokenId uint256 ID of the token to be minted by the msg.sender
  */
  function _mint(address to, uint256 tokenId) internal {
    require(to != address(0));
    _addTokenTo(to, tokenId);
    emit Transfer(address(0), to, tokenId);
  }

  /**
  * @dev Internal function to burn a specific token
  * Reverts if the token does not exist
  * @param tokenId uint256 ID of the token being burned by the msg.sender
  */
  function _burn(address owner, uint256 tokenId) internal {
    _clearApproval(owner, tokenId);
    _removeTokenFrom(owner, tokenId);
    emit Transfer(owner, address(0), tokenId);
  }

  /**
  * @dev Internal function to clear current approval of a given token ID
  * Reverts if the given address is not indeed the owner of the token
  * @param owner owner of the token
  * @param tokenId uint256 ID of the token to be transferred
  */
  function _clearApproval(address owner, uint256 tokenId) internal {
    require(ownerOf(tokenId) == owner);
    if (_tokenApprovals[tokenId] != address(0)) {
      _tokenApprovals[tokenId] = address(0);
    }
  }

  /**
  * @dev Internal function to add a token ID to the list of a given address
  * @param to address representing the new owner of the given token ID
  * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
  */
  function _addTokenTo(address to, uint256 tokenId) internal {
    require(_tokenOwner[tokenId] == address(0));
    _tokenOwner[tokenId] = to;
    _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
  }

  /**
  * @dev Internal function to remove a token ID from the list of a given address
  * @param from address representing the previous owner of the given token ID
  * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
  */
  function _removeTokenFrom(address from, uint256 tokenId) internal {
    require(ownerOf(tokenId) == from);
    _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
    _tokenOwner[tokenId] = address(0);
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
  function _checkAndCallSafeTransfer(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  )
    internal
    returns (bool)
  {
    if (!to.isContract()) {
      return true;
    }
    bytes4 retval = IERC721Receiver(to).onERC721Received(
      msg.sender, from, tokenId, _data);
    return (retval == _ERC721_RECEIVED);
  }
}

contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
  // Token name
  string internal _name;

  // Token symbol
  string internal _symbol;

  // Optional mapping for token URIs
  mapping(uint256 => string) private _tokenURIs;

  bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
  /**
  * 0x5b5e139f ===
  *   bytes4(keccak256('name()')) ^
  *   bytes4(keccak256('symbol()')) ^
  *   bytes4(keccak256('tokenURI(uint256)'))
  */

  /**
  * @dev Constructor function
  */
  constructor(string memory name, string memory symbol) public {
    _name = name;
    _symbol = symbol;

    // register the supported interfaces to conform to ERC721 via ERC165
    _registerInterface(InterfaceId_ERC721Metadata);
  }

  /**
  * @dev Gets the token name
  * @return string representing the token name
  */
  function name() external view returns (string memory) {
    return _name;
  }

  /**
  * @dev Gets the token symbol
  * @return string representing the token symbol
  */
  function symbol() external view returns (string memory) {
    return _symbol;
  }

  /**
  * @dev Returns an URI for a given token ID
  * Throws if the token ID does not exist. May return an empty string.
  * @param tokenId uint256 ID of the token to query
  */
  function tokenURI(uint256 tokenId) public view returns (string memory) {
    require(_exists(tokenId));
    return _tokenURIs[tokenId];
  }

  /**
  * @dev Internal function to set the token URI for a given token
  * Reverts if the token ID does not exist
  * @param tokenId uint256 ID of the token to set its URI
  * @param uri string URI to assign
  */
  function _setTokenURI(uint256 tokenId, string memory uri) internal {
    require(_exists(tokenId));
    _tokenURIs[tokenId] = uri;
  }

  /**
  * @dev Internal function to burn a specific token
  * Reverts if the token does not exist
  * @param owner owner of the token to burn
  * @param tokenId uint256 ID of the token being burned by the msg.sender
  */
  function _burn(address owner, uint256 tokenId) internal {
    super._burn(owner, tokenId);

    // Clear metadata (if any)
    if (bytes(_tokenURIs[tokenId]).length != 0) {
      delete _tokenURIs[tokenId];
    }
  }
}

contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
  // Mapping from owner to list of owned token IDs
  mapping(address => uint256[]) private _ownedTokens;

  // Mapping from token ID to index of the owner tokens list
  mapping(uint256 => uint256) private _ownedTokensIndex;

  // Array with all token ids, used for enumeration
  uint256[] private _allTokens;

  // Mapping from token id to position in the allTokens array
  mapping(uint256 => uint256) private _allTokensIndex;

  bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
  /**
  * 0x780e9d63 ===
  *   bytes4(keccak256('totalSupply()')) ^
  *   bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
  *   bytes4(keccak256('tokenByIndex(uint256)'))
  */

  /**
  * @dev Constructor function
  */
  constructor() public {
    // register the supported interface to conform to ERC721 via ERC165
    _registerInterface(_InterfaceId_ERC721Enumerable);
  }

  /**
  * @dev Gets the token ID at a given index of the tokens list of the requested owner
  * @param owner address owning the tokens list to be accessed
  * @param index uint256 representing the index to be accessed of the requested tokens list
  * @return uint256 token ID at the given index of the tokens list owned by the requested address
  */
  function tokenOfOwnerByIndex(
    address owner,
    uint256 index
  )
    public
    view
    returns (uint256)
  {
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
  * @dev Internal function to add a token ID to the list of a given address
  * @param to address representing the new owner of the given token ID
  * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
  */
  function _addTokenTo(address to, uint256 tokenId) internal {
    super._addTokenTo(to, tokenId);
    uint256 length = _ownedTokens[to].length;
    _ownedTokens[to].push(tokenId);
    _ownedTokensIndex[tokenId] = length;
  }

  /**
  * @dev Internal function to remove a token ID from the list of a given address
  * @param from address representing the previous owner of the given token ID
  * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
  */
  function _removeTokenFrom(address from, uint256 tokenId) internal {
    super._removeTokenFrom(from, tokenId);

    // To prevent a gap in the array, we store the last token in the index of the token to delete, and
    // then delete the last slot.
    uint256 tokenIndex = _ownedTokensIndex[tokenId];
    uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
    uint256 lastToken = _ownedTokens[from][lastTokenIndex];

    _ownedTokens[from][tokenIndex] = lastToken;
    // This also deletes the contents at the last position of the array
    _ownedTokens[from].length--;

    // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
    // be zero. Then we can make sure that we will remove tokenId from the ownedTokens list since we are first swapping
    // the lastToken to the first position, and then dropping the element placed in the last position of the list

    _ownedTokensIndex[tokenId] = 0;
    _ownedTokensIndex[lastToken] = tokenIndex;
  }

  /**
  * @dev Internal function to mint a new token
  * Reverts if the given token ID already exists
  * @param to address the beneficiary that will own the minted token
  * @param tokenId uint256 ID of the token to be minted by the msg.sender
  */
  function _mint(address to, uint256 tokenId) internal {
    super._mint(to, tokenId);

    _allTokensIndex[tokenId] = _allTokens.length;
    _allTokens.push(tokenId);
  }

  /**
  * @dev Internal function to burn a specific token
  * Reverts if the token does not exist
  * @param owner owner of the token to burn
  * @param tokenId uint256 ID of the token being burned by the msg.sender
  */
  function _burn(address owner, uint256 tokenId) internal {
    super._burn(owner, tokenId);

    // Reorg all tokens array
    uint256 tokenIndex = _allTokensIndex[tokenId];
    uint256 lastTokenIndex = _allTokens.length.sub(1);
    uint256 lastToken = _allTokens[lastTokenIndex];

    _allTokens[tokenIndex] = lastToken;
    _allTokens[lastTokenIndex] = 0;

    _allTokens.length--;
    _allTokensIndex[tokenId] = 0;
    _allTokensIndex[lastToken] = tokenIndex;
  }
}

contract ERC721Full is ERC721, ERC721Enumerable, ERC721Metadata {
    constructor (string memory name, string memory symbol) public ERC721Metadata(name, symbol) {
        // solhint-disable-previous-line no-empty-blocks
    }
}

contract BAE is ERC721Full, Helpers {
    using SafeMath for uint256;

    /// @dev - extra events on the ERC721 contract
    event Sold(uint indexed _tokenId, address _from, address _to, uint indexed _price);
    event Deleted(uint indexed _tokenId, address _from);
    event PaymentsContractChange(address _prevAddress, address _futureAddress);
    event AuctionContractChange(address _prevAddress, address _futureAddress);

    Payments public tokenInterface;
    mapping (uint => address) artTransApprovals;

   constructor() ERC721Full("BlockchainArtExchange", "BAE") public {}
    
    /// @dev functions affecting ERC20 tokens
    function setPaymentAddress(address payable _newAddress) public onlyCEO whenPaused {
        Payments tokenInterfaceCandidate = Payments(_newAddress);
        tokenInterface = tokenInterfaceCandidate;
    }

  function createArtpiece(
        string memory _name,
        string memory _artist,
        string memory _thumbnailUrl,
        string memory _mainUrl,
        string memory _notes,
        string memory _grade,
        uint256 _dateCreatedByTheArtist,
        uint64 _price,
        uint64 _basePrice,
        uint8 _remainingPrintings,
        bool _physical
    ) 
      public 
    {
        super._createArtpiece(_name, _artist, _thumbnailUrl, _mainUrl, _notes, _grade, _dateCreatedByTheArtist, _price, _basePrice, _remainingPrintings, _physical);
        
        _mint(msg.sender, artpieces.length - 1);
    }
  
    function calculateFees(uint _tokenId) public payable whenNotPaused returns (uint baeFee, uint royaltyFee, uint potFee) {	//injected LOCKED ETHER
        /// @dev check this will not bring problems in the future or should we be using SafeMath library.
        uint baeFeeAmount = (uint(artpieces[_tokenId].baeFeeLevel) * msg.value) / 100;
        uint artistFeeAmount = (uint(artpieces[_tokenId].feeLevel) * msg.value) / 100;

        /// @dev any extra money will be added to the pot
        uint potFeeAmount = msg.value - (baeFeeAmount + artistFeeAmount);
        return (baeFeeAmount, artistFeeAmount, potFeeAmount);
    }

    /// @dev - this should be getting the royalty fee so we get the remaining as what is the bae fee
    function payFees(uint256 _baeFee, uint256 _royaltyFee, uint256 _potFee, address payable _seller) public payable whenNotPaused {	//injected LOCKED ETHER
        uint totalToPay = _baeFee + _royaltyFee + _potFee;
        require(
            msg.value >= totalToPay,
            "Value must be equal or greater than the cost of the fees"
        );

        BAEFeeAddress.transfer(0);
        _seller.transfer(0);

        // we send the value left of the message to the POT contract
        address(tokenInterface).transfer(0);
    }
    
    /// @dev set post-purchase data
    function _postPurchase(address _from, address _to, uint256 _tokenId) internal {
        artCollection[_to] = artCollection[_to].add(1);
        artCollection[_from] = artCollection[_from].sub(1);
        numArtInAddress[_tokenId] = _to;

        if (artpieces[_tokenId].metadata.isFirstSale) {
            artpieces[_tokenId].feeLevel = uint8(96);
            artpieces[_tokenId].baeFeeLevel = uint8(3);
            /// potFeeLevel is calculated from adding up (baeFeeLevel + royaltyFee) - 100
        }
        
        /// @dev we set this as not being the first sale anymore
        artpieces[_tokenId].metadata.isFirstSale = false;

        emit Sold(_tokenId, _from, _to, artpieces[_tokenId].price);
    }
    
    
    /// @dev this method is not part of erc-721 - not yet tested
    function deleteArtpiece(uint256 _tokenId) public onlyCLevelOrOwner whenNotPaused onlyBeforeFirstSale(_tokenId) returns (bool deleted) {
        address _from = numArtInAddress[_tokenId];
        delete numArtInAddress[_tokenId];
        artCollection[_from] = artCollection[_from].sub(1);
        _burn(_from, _tokenId);
        delete artpieces[_tokenId];
        emit Deleted(_tokenId, _from);
        return true;
    }

    /// @dev - we override this so only the CEO can call it.
    function pause() public onlyCEO whenNotPaused {
        super.pause();
    }
}

contract PerishableSimpleAuction is Destructible {
    using SafeMath for uint256;

    event AuctionCreated(uint id, address seller);
    event AuctionWon(uint tokenId, address _who);
    event SellerPaid(bool success, uint amount);
    
    BAECore public baeInstance;
    bool private currentAuction;

    struct Auction {
        uint256 tokenId;
        uint256 startingPrice;
        uint256 finalPrice;
        address payable seller;
        uint8 paid;
    }

    // When someone wins add it to this mapping 
    /// @dev address => uint === winnerAddress => tokenId
    mapping (uint => address) public winners;

    // Map from token ID to their corresponding auction.
    mapping (uint256 => Auction) public tokenIdToAuction;
    mapping (uint256 => uint256) public tokendIdToAuctionId;

    /// @dev auction array
    Auction[20] public auctions;

    /// @dev auction index
    uint public idx = 0;

    /// @dev cut on each auction
    uint256 public baeAuctionFee = 0.01 ether;

    modifier onlyAuctionOwner() {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyAuctionLord() {
        require(msg.sender == address(baeInstance));
        _;
    }
    
    constructor() public {
        paused = true;
        ceoAddress = msg.sender;
    }
    
    function setIsCurrentAuction(bool _current) external onlyCEO {
        currentAuction = _current;
    }
    
    /// @dev this should be done when paused  as it breaks functionality
    /// @dev changes the current contract interaccting with the auction
    function setBAEAddress(address payable _newAddress) public onlyAuctionOwner whenPaused {
        address currentInstance = address(baeInstance);
        BAECore candidate = BAECore(_newAddress);
        baeInstance = candidate;
        require(address(baeInstance) != address(0) && address(baeInstance) != currentInstance);
    }

    function createAuction(
        uint256 _tokenId,
        uint256 _startingPrice,
        uint256 _finalPrice,
        address payable _seller
    )
        external
        whenNotPaused
        onlyAuctionLord
    {
        if (tokendIdToAuctionId[_tokenId] != 0) {
            require(tokenIdToAuction[_tokenId].paid == 1);
        }
        require(idx <= 20);
        
        Auction memory newAuction = Auction(_tokenId, _startingPrice, _finalPrice, _seller, 0);
        auctions[idx] = newAuction;
        tokenIdToAuction[_tokenId] = newAuction; 
        tokendIdToAuctionId[_tokenId] = idx;
        idx = idx.add(1);
        
        emit AuctionCreated(idx,  _seller);
    }

    /// @dev this function sets who won that auction and allows the token to be marked as approved for sale.
    function hasWon(uint256 _auctionId, address _winner, uint256 _finalBidPrice) external whenNotPaused onlyAuctionLord {
        winners[auctions[_auctionId].tokenId] = _winner;
        auctions[_auctionId].finalPrice = _finalBidPrice;
        emit AuctionWon(auctions[_auctionId].tokenId, _winner);
    }

    function winnerCheckWireDetails(uint _auctionId, address _sender) external view whenNotPaused returns(address payable, uint, uint) {
        /// get the storage variables
        uint finalPrice = auctions[_auctionId].finalPrice;
        uint tokenId = auctions[_auctionId].tokenId;
        address winnerAddress = winners[tokenId];
        address payable seller = auctions[_auctionId].seller;

        /// get winner address and check it is in the winners' mapping
        require(_sender == winnerAddress);
        return (seller, tokenId, finalPrice);
    }
    
    function setPaid(uint _auctionId) external whenNotPaused onlyAuctionLord {
        require(auctions[_auctionId].paid == 0);
        auctions[_auctionId].paid = 1;
        emit SellerPaid(true, auctions[_auctionId].finalPrice);
    }
    
    /** Takes an auctionId to get the tokenId for the auction and returns the address of the winner. */
    function getAuctionWinnerAddress(uint _auctionId) external view whenNotPaused returns(address)  {
        return winners[auctions[_auctionId].tokenId];
    }
    
    function getFinalPrice(uint _auctionId) external view whenNotPaused returns(uint)  {
        return auctions[_auctionId].finalPrice;
    }

    function getAuctionDetails(uint _auctionId) external view whenNotPaused returns (uint, uint, uint, address, uint) {
        return (auctions[_auctionId].tokenId, auctions[_auctionId].startingPrice, auctions[_auctionId].finalPrice, auctions[_auctionId].seller, auctions[_auctionId].paid);
    }
    
    function getCurrentIndex() external view returns (uint) {
        uint val = idx - 1;
                
        if (val > 20) {
            return 0;
        }
        
        return val;
    }
    
    function getTokenIdToAuctionId(uint _tokenId) external view returns (uint) {
        return tokendIdToAuctionId[_tokenId];
    }
    
    function unpause() public onlyAuctionOwner whenPaused {
        require(address(baeInstance) != address(0));

        super.unpause();
    }
    
    function () external payable {
        revert();
    }
}

contract BAECore is BAE {
      using SafeMath for uint256;
 
    /// @dev this will be private so no one can see where it is living and will be deployed by another address
    PerishableSimpleAuction private instanceAuctionAddress;
    
    constructor() public {
        paused = true;
        ceoAddress = msg.sender;
    }

    function setAuctionAddress(address payable _newAddress) public onlyCEO whenPaused {
        PerishableSimpleAuction possibleAuctionInstance = PerishableSimpleAuction(_newAddress);
        instanceAuctionAddress = possibleAuctionInstance;
    }
    
    /// @dev we can also charge straight away by charging an amount and making this function payable
    function createAuction(uint _tokenId, uint _startingPrice, uint _finalPrice) external whenNotPaused {
        require(ownerOf( _tokenId) == msg.sender, "You can't transfer an artpiece which is not yours");
        require(_startingPrice >= artpieces[_tokenId].metadata.basePrice);
        instanceAuctionAddress.createAuction(_tokenId, _startingPrice,_finalPrice, msg.sender);
        
        /// @dev - approve the setWinnerAndPrice callers
        setApprovalForAll(owner, true);
        setApprovalForAll(ceoAddress, true);
        setApprovalForAll(cfoAddress, true);
        setApprovalForAll(cooAddress, true);
    }
    
    function getAuctionDetails(uint _auctionId) public view returns (uint) {
        (uint tokenId,,,,) = instanceAuctionAddress.getAuctionDetails(_auctionId);
        return tokenId;
    }
    
    /// @dev this should be cleared from the array if its called on a second time.
    function setWinnerAndPrice(uint256 _auctionId, address _winner, uint256 _finalPrice, uint256 _currentPrice) external onlyCLevelOrOwner whenNotPaused returns(bool hasWinnerInfo) 
    {   
        (uint tokenId,,,,) = instanceAuctionAddress.getAuctionDetails(_auctionId);
        require(_finalPrice >= uint256(artpieces[tokenId].metadata.basePrice));
        approve(_winner, tokenId);
        instanceAuctionAddress.hasWon(_auctionId, _winner, _finalPrice);
        tokenInterface.setFinalPriceInPounds(_currentPrice);
        return true;
    }
    
    function calculateFees(uint _tokenId, uint _fullAmount) internal view  whenNotPaused returns (uint baeFee, uint royaltyFee, uint potFee) {
        /// @dev check this will not bring problems in the future or should we be using SafeMath library.
        uint baeFeeAmount = (uint(artpieces[_tokenId].baeFeeLevel) * _fullAmount) / 100;
        uint artistFeeAmount = (uint(artpieces[_tokenId].feeLevel) * _fullAmount) / 100;

        /// @dev any extra money will be added to the pot
        uint potFeeAmount = _fullAmount - (baeFeeAmount + artistFeeAmount);
        return (baeFeeAmount, artistFeeAmount, potFeeAmount);
    }

    function payAndWithdraw(uint _auctionId) public payable {	//injected LOCKED ETHER
        // calculate the share of each of the stakeholders 
        (address payable seller, uint tokenId, uint finalPrice) = instanceAuctionAddress.winnerCheckWireDetails(_auctionId, msg.sender);
        (uint baeFeeAmount, uint artistFeeAmount,) = calculateFees(tokenId, finalPrice);
        
        // break msg.value it into the rightchunks
        require(msg.value >= finalPrice);
        uint baeFee = msg.value.sub(baeFeeAmount);
        uint artistFee = msg.value.sub(artistFeeAmount);
        
        // do the transfers
        BAEFeeAddress.transfer(0);
        seller.transfer(0);
        address(tokenInterface).transfer(0);
        
        // and when the money is sent, we mark the auccion as completed
        instanceAuctionAddress.setPaid(_auctionId);
        
        // and since it's paid then initiate the transfer mechanism
        transferFrom(seller, msg.sender, tokenId);
    }
    
    function getWinnerAddress(uint _auctionId) public view returns(address)  {
        return instanceAuctionAddress.getAuctionWinnerAddress(_auctionId);
    }
    
    function getHighestBid(uint _auctionId) public view returns(uint)  {
        return instanceAuctionAddress.getFinalPrice(_auctionId);
    }
    
    function getLatestAuctionIndex() public view returns(uint) {
        return instanceAuctionAddress.getCurrentIndex();
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public whenNotPaused {
        uint auctionId = instanceAuctionAddress.getTokenIdToAuctionId(_tokenId);
        (,,,,uint paid) = (instanceAuctionAddress.getAuctionDetails(auctionId));
        require(paid == 1);
        super.transferFrom(_from, _to, _tokenId);
        _postPurchase(_from, _to, _tokenId);
        
        /// @dev this gets paid even to non artists, if it's a seller he will get the same
        tokenInterface.addToBAEHolders(_from);
    }
    
    function unpause() public onlyCEO whenPaused {
        require(ceoAddress != address(0));
        require(address(instanceAuctionAddress) != address(0));
        require(address(tokenInterface) != address(0));
        require(address(BAEFeeAddress) != address(0));

        super.unpause();
    }
    
    /// @dev - we override this so only the CEO can call it.
    function pause() public onlyCEO whenNotPaused {
        super.pause();
    }
    
    function () external payable {}	//injected LOCKED ETHER
}