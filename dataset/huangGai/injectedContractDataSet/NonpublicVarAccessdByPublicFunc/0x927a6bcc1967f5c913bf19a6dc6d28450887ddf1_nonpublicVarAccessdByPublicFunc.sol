pragma solidity 0.5.3;







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
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
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
        return msg.sender == _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     * @notice Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
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


/**
 * @title Secondary
 * @dev A Secondary contract can only be used by its primary account (the one that created it)
 */
contract OwnableSecondary is Ownable {
  address private _primary;

  event PrimaryTransferred(
    address recipient
  );

  /**
   * @dev Sets the primary account to the one that is creating the Secondary contract.
   */
  constructor() internal {
    _primary = msg.sender;
    emit PrimaryTransferred(_primary);
  }

  /**
   * @dev Reverts if called from any account other than the primary or the owner.
   */
   modifier onlyPrimaryOrOwner() {
     require(msg.sender == _primary || msg.sender == owner(), "not the primary user nor the owner");
     _;
   }

   /**
    * @dev Reverts if called from any account other than the primary.
    */
  modifier onlyPrimary() {
    require(msg.sender == _primary, "not the primary user");
    _;
  }

  /**
   * @return the address of the primary.
   */
  function primary() public view returns (address) {
    return _primary;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  /**
   * @dev Transfers contract to a new primary.
   * @param recipient The address of new primary.
   */
  function transferPrimary(address recipient) public onlyOwner {
    require(recipient != address(0), "new primary address is null");
    _primary = recipient;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit PrimaryTransferred(_primary);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
}


contract ImmutableEternalStorageInterface is OwnableSecondary {
  /********************/
  /** PUBLIC - WRITE **/
  /********************/
  function createUint(bytes32 key, uint value) external;

  function createString(bytes32 key, string calldata value) external;

  function createAddress(bytes32 key, address value) external;

  function createBytes(bytes32 key, bytes calldata value) external;

  function createBytes32(bytes32 key, bytes32 value) external;

  function createBool(bytes32 key, bool value) external;

  function createInt(bytes32 key, int value) external;

  /*******************/
  /** PUBLIC - READ **/
  /*******************/
  function getUint(bytes32 key) external view returns(uint);

  function uintExists(bytes32 key) external view returns(bool);

  function getString(bytes32 key) external view returns(string memory);

  function stringExists(bytes32 key) external view returns(bool);

  function getAddress(bytes32 key) external view returns(address);

  function addressExists(bytes32 key) external view returns(bool);

  function getBytes(bytes32 key) external view returns(bytes memory);

  function bytesExists(bytes32 key) external view returns(bool);

  function getBytes32(bytes32 key) external view returns(bytes32);

  function bytes32Exists(bytes32 key) external view returns(bool);

  function getBool(bytes32 key) external view returns(bool);

  function boolExists(bytes32 key) external view returns(bool);

  function getInt(bytes32 key) external view returns(int);

  function intExists(bytes32 key) external view returns(bool);
}


contract ImmutableEternalStorage is ImmutableEternalStorageInterface {
    struct UintEntity {
      uint value;
      bool isEntity;
    }
    struct StringEntity {
      string value;
      bool isEntity;
    }
    struct AddressEntity {
      address value;
      bool isEntity;
    }
    struct BytesEntity {
      bytes value;
      bool isEntity;
    }
    struct Bytes32Entity {
      bytes32 value;
      bool isEntity;
    }
    struct BoolEntity {
      bool value;
      bool isEntity;
    }
    struct IntEntity {
      int value;
      bool isEntity;
    }
    mapping(bytes32 => UintEntity) private uIntStorage;
    mapping(bytes32 => StringEntity) private stringStorage;
    mapping(bytes32 => AddressEntity) private addressStorage;
    mapping(bytes32 => BytesEntity) private bytesStorage;
    mapping(bytes32 => Bytes32Entity) private bytes32Storage;
    mapping(bytes32 => BoolEntity) private boolStorage;
    mapping(bytes32 => IntEntity) private intStorage;

    /********************/
    /** PUBLIC - WRITE **/
    /********************/
    function createUint(bytes32 key, uint value) onlyPrimaryOrOwner external {
        require(!uIntStorage[key].isEntity);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        uIntStorage[key].value = value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uIntStorage[key].isEntity = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function createString(bytes32 key, string calldata value) onlyPrimaryOrOwner external {
        require(!stringStorage[key].isEntity);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        stringStorage[key].value = value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        stringStorage[key].isEntity = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function createAddress(bytes32 key, address value) onlyPrimaryOrOwner external {
        require(!addressStorage[key].isEntity);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        addressStorage[key].value = value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        addressStorage[key].isEntity = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function createBytes(bytes32 key, bytes calldata value) onlyPrimaryOrOwner external {
        require(!bytesStorage[key].isEntity);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        bytesStorage[key].value = value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bytesStorage[key].isEntity = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function createBytes32(bytes32 key, bytes32 value) onlyPrimaryOrOwner external {
        require(!bytes32Storage[key].isEntity);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        bytes32Storage[key].value = value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        bytes32Storage[key].isEntity = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function createBool(bytes32 key, bool value) onlyPrimaryOrOwner external {
        require(!boolStorage[key].isEntity);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        boolStorage[key].value = value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        boolStorage[key].isEntity = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function createInt(bytes32 key, int value) onlyPrimaryOrOwner external {
        require(!intStorage[key].isEntity);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        intStorage[key].value = value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        intStorage[key].isEntity = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /*******************/
    /** PUBLIC - READ **/
    /*******************/
    function getUint(bytes32 key) external view returns(uint) {
        return uIntStorage[key].value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function uintExists(bytes32 key) external view returns(bool) {
      return uIntStorage[key].isEntity;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getString(bytes32 key) external view returns(string memory) {
        return stringStorage[key].value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function stringExists(bytes32 key) external view returns(bool) {
      return stringStorage[key].isEntity;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getAddress(bytes32 key) external view returns(address) {
        return addressStorage[key].value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function addressExists(bytes32 key) external view returns(bool) {
      return addressStorage[key].isEntity;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getBytes(bytes32 key) external view returns(bytes memory) {
        return bytesStorage[key].value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function bytesExists(bytes32 key) external view returns(bool) {
      return bytesStorage[key].isEntity;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getBytes32(bytes32 key) external view returns(bytes32) {
        return bytes32Storage[key].value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function bytes32Exists(bytes32 key) external view returns(bool) {
      return bytes32Storage[key].isEntity;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getBool(bytes32 key) external view returns(bool) {
        return boolStorage[key].value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function boolExists(bytes32 key) external view returns(bool) {
      return boolStorage[key].isEntity;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getInt(bytes32 key) external view returns(int) {
        return intStorage[key].value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function intExists(bytes32 key) external view returns(bool) {
      return intStorage[key].isEntity;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}