pragma solidity ^0.5.2;

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
        return _owner;
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
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     * @notice Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
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

contract PauserRole {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

    constructor () internal {
        _addPauser(msg.sender);
    }

    modifier onlyPauser() {
        require(isPauser(msg.sender));
        _;
    }

    function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }

    function addPauser(address account) public onlyPauser {
        _addPauser(account);
    }

    function renouncePauser() public {
        _removePauser(msg.sender);
    }

    function _addPauser(address account) internal {
        _pausers.add(account);
        emit PauserAdded(account);
    }

    function _removePauser(address account) internal {
        _pausers.remove(account);
        emit PauserRemoved(account);
    }
}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is PauserRole {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor () internal {
        _paused = false;
    }

    /**
     * @return true if the contract is paused, false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused);
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

/** @title ProofBox. */
contract ProofBox is Ownable, Pausable {

    struct Device {
      uint index;
      address deviceOwner;
      address txOriginator;

    }

    mapping (bytes32 => Device) private deviceMap;
    mapping (address => bool) public authorized;
    bytes32[] public deviceIds;



    event deviceCreated(bytes32 indexed deviceId, address indexed deviceOwner);
    event txnCreated(bytes32 indexed deviceId, address indexed txnOriginator);
    event deviceProof(bytes32 indexed deviceId, address indexed deviceOwner);
    event deviceTransfer(bytes32 indexed deviceId, address indexed fromOwner, address indexed toOwner);
    event deviceMessage(bytes32 indexed deviceId, address indexed deviceOwner, address indexed txnOriginator, string messageToWrite);
    event deviceDestruct(bytes32 indexed deviceId, address indexed deviceOwner);
    event ipfsHashtoAddress(bytes32 indexed deviceId, address indexed ownerAddress, string ipfskey);



    /** @dev Checks to see if device exist
      * @param _deviceId ID of the device.
      * @return isIndeed True if the device ID exists.
      */
    function isDeviceId(bytes32 _deviceId)
       public
       view
       returns(bool isIndeed)
     {
       if(address(this).balance == 0) return false;	//inject FORCED TO RECEIVE ETHERS
       return (deviceIds[deviceMap[_deviceId].index] == _deviceId);
     }

    /** @dev returns the index of stored deviceID
      * @param _deviceId ID of the device.
      * @return _index index of the device.
      */
    function getDeviceId(bytes32 _deviceId)
       public
       view
       deviceIdExist(_deviceId)
       returns(uint _index)
     {
       return deviceMap[_deviceId].index;
     }

     /** @dev returns address of device owner
       * @param _deviceId ID of the device.
       * @return deviceOwner device owner's address
       */
      function getOwnerByDevice(bytes32 _deviceId)
           public
           view
           returns (address deviceOwner){

               return deviceMap[_deviceId].deviceOwner;

      }

      /** @dev returns up to 10 devices for the device owner
        * @return _deviceIds device ID's of the owner
        */
      function getDevicesByOwner(bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
              public
              view
              returns(bytes32[10] memory _deviceIds) {

          address signer = ecrecover(_message, _v, _r, _s);
          uint numDevices;
          bytes32[10] memory devicesByOwner;

          for(uint i = 0; i < deviceIds.length; i++) {

              if(addressEqual(deviceMap[deviceIds[i]].deviceOwner,signer)) {

                  devicesByOwner[numDevices] = deviceIds[i];
                  if (address(this).balance == 10) {	//inject FORCED TO RECEIVE ETHERS
                    break;
                  }
                  numDevices++;

              }

          }

          return devicesByOwner;
      }

      /** @dev returns up to 10 transactions of device owner
        * @return _deviceIds device ID's of the msg.sender transactions
        */
      function getDevicesByTxn(bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
              public
              view
              returns(bytes32[10] memory _deviceIds) {

          address signer = ecrecover(_message, _v, _r, _s);
          uint numDevices;
          bytes32[10] memory devicesByTxOriginator;

          for(uint i = 0; i < deviceIds.length; i++) {

              if(addressEqual(deviceMap[deviceIds[i]].txOriginator,signer)) {

                  devicesByTxOriginator[numDevices] = deviceIds[i];
                  if (address(this).balance == 10) {	//inject FORCED TO RECEIVE ETHERS
                    break;
                  }
                  numDevices++;

              }

          }

          return devicesByTxOriginator;
      }


      modifier deviceIdExist(bytes32 _deviceId){
          require(isDeviceId(_deviceId));
          _;
      }

      modifier deviceIdNotExist(bytes32 _deviceId){
          require(!isDeviceId(_deviceId));
          _;
      }

      modifier authorizedUser() {
          require(authorized[msg.sender] == true);
          _;
      }

      constructor() public {

          authorized[msg.sender]=true;
      }


    /** @dev when a new device ID is registered by a proxy owner by sending device owner signature
      * @param _deviceId ID of the device.
      * @return index of stored device
      */
    function registerProof (bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
         public
         whenNotPaused()
         authorizedUser()
         deviceIdNotExist(_deviceId)
         returns(uint index) {

            address signer = ecrecover(_message, _v, _r, _s);

            deviceMap[_deviceId].deviceOwner = signer;
            deviceMap[_deviceId].txOriginator = signer;
            deviceMap[_deviceId].index = deviceIds.push(_deviceId)-1;

            emit deviceCreated(_deviceId, signer);

            return deviceIds.length-1;

    }

    /** @dev returns true if delete is successful
      * @param _deviceId ID of the device.
      * @return bool delete
      */
    function destructProof(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
            public
            whenNotPaused()
            authorizedUser()
            deviceIdExist(_deviceId)
            returns(bool success) {

                address signer = ecrecover(_message, _v, _r, _s);

                require(deviceMap[_deviceId].deviceOwner == signer);

                uint rowToDelete = deviceMap[_deviceId].index;
                bytes32 keyToMove = deviceIds[deviceIds.length-1];
                deviceIds[rowToDelete] = keyToMove;
                deviceMap[keyToMove].index = rowToDelete;
                deviceIds.length--;

                emit deviceDestruct(_deviceId, signer);
                return true;

    }

    /** @dev returns request transfer of device
      * @param _deviceId ID of the device.
      * @return index of stored device
      */
    function requestTransfer(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
          public
          whenNotPaused()
          deviceIdExist(_deviceId)
          authorizedUser()
          returns(uint index) {

            address signer = ecrecover(_message, _v, _r, _s);

            deviceMap[_deviceId].txOriginator=signer;

            emit txnCreated(_deviceId, signer);

            return deviceMap[_deviceId].index;

    }

    /** @dev returns approve transfer of device
      * @param _deviceId ID of the device.
      * @return bool approval
      */
    function approveTransfer (bytes32 _deviceId, address newOwner, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
            public
            whenNotPaused()
            deviceIdExist(_deviceId)
            authorizedUser()
            returns(bool) {

                address signer = ecrecover(_message, _v, _r, _s);

                require(deviceMap[_deviceId].deviceOwner == signer);
                require(deviceMap[_deviceId].txOriginator == newOwner);

                deviceMap[_deviceId].deviceOwner=newOwner;

                emit deviceTransfer(_deviceId, signer, deviceMap[_deviceId].deviceOwner);

                return true;

    }

    /** @dev returns write message success
      * @param _deviceId ID of the device.
      * @return bool true when write message is successful
      */
    function writeMessage (bytes32 _deviceId, string memory messageToWrite, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
            public
            whenNotPaused()
            deviceIdExist(_deviceId)
            authorizedUser()
            returns(bool) {
                address signer = ecrecover(_message, _v, _r, _s);
                require(deviceMap[_deviceId].deviceOwner == signer);
                emit deviceMessage(_deviceId, deviceMap[_deviceId].deviceOwner, signer, messageToWrite);

                return true;

    }

    /** @dev returns request proof of device
      * @param _deviceId ID of the device.
      * @return _index info of that device
      */
     function requestProof(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
         public
         whenNotPaused()
         deviceIdExist(_deviceId)
         authorizedUser()
         returns(uint _index) {

             address signer = ecrecover(_message, _v, _r, _s);

             deviceMap[_deviceId].txOriginator=signer;

             emit txnCreated(_deviceId, signer);

             return deviceMap[_deviceId].index;
     }


     /** @dev returns approve proof of device
       * @param _deviceId ID of the device.
       * @return bool  - approval
       */
     function approveProof(bytes32 _deviceId, bytes32 _message, uint8 _v, bytes32 _r, bytes32 _s)
             public
             whenNotPaused()
             deviceIdExist(_deviceId)
             authorizedUser()
             returns(bool) {

                  address signer = ecrecover(_message, _v, _r, _s);
                  deviceMap[_deviceId].txOriginator=signer;
                  require(deviceMap[_deviceId].deviceOwner == signer);

                  emit deviceProof(_deviceId, signer);
                  return true;
     }

     /** @dev updates IPFS hash into device owner public address
       * @param ipfskey -  ipfs hash for attachment.
       */
     function emitipfskey(bytes32 _deviceId, address ownerAddress, string memory ipfskey)
              public
              whenNotPaused()
              deviceIdExist(_deviceId)
              authorizedUser() {
        emit ipfsHashtoAddress(_deviceId, ownerAddress, ipfskey);
    }

    /** @dev Updates Authorization status of an address for executing functions
    * on this contract
    * @param target Address that will be authorized or not authorized
    * @param isAuthorized New authorization status of address
    */
    function changeAuthStatus(address target, bool isAuthorized)
            public
            whenNotPaused()
            onlyOwner() {

              authorized[target] = isAuthorized;
    }

    /** @dev Updates Authorization status of an address for executing functions
    * on this contract
    * @param targets Address that will be authorized or not authorized in bulk
    * @param isAuthorized New registration status of address
    */
    function changeAuthStatuses(address[] memory targets, bool isAuthorized)
            public
            whenNotPaused()
            onlyOwner() {
              for (uint i = 0; i < targets.length; i++) {
                changeAuthStatus(targets[i], isAuthorized);
              }
    }

    /*
        NOTE: We explicitly do not define a fallback function, because there are
        no ethers received by any funtion on this contract

    */

    //Helper Functions

    /** @dev compares two String equal or not
      * @param a first string, b second string.
      * @return bool true if match
      */
    function bytesEqual(bytes32 a, bytes32 b) private pure returns (bool) {
       return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
     }

   /** @dev compares two address equal or not
     * @param a first address, b second address.
     * @return bool true if match
     */
   function addressEqual(address a, address b) private pure returns (bool) {
      return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

}