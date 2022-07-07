/**
 *Submitted for verification at Etherscan.io on 2020-01-13
*/

pragma solidity ^0.5.7;

// Abstract contract for the full ERC 20 Token standard
// https://github.com/ethereum/EIPs/issues/20

interface ERC20Token {

    /**
     * @notice send `_value` token to `_to` from `msg.sender`
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return Whether the transfer was successful or not
     */
    function transfer(address _to, uint256 _value) external returns (bool success);

    /**
     * @notice `msg.sender` approves `_spender` to spend `_value` tokens
     * @param _spender The address of the account able to transfer the tokens
     * @param _value The amount of tokens to be approved for transfer
     * @return Whether the approval was successful or not
     */
    function approve(address _spender, uint256 _value) external returns (bool success);

    /**
     * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value The amount of token to be transferred
     * @return Whether the transfer was successful or not
     */
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    /**
     * @param _owner The address from which the balance will be retrieved
     * @return The balance
     */
    function balanceOf(address _owner) external view returns (uint256 balance);

    /**
     * @param _owner The address of the account owning tokens
     * @param _spender The address of the account able to transfer the tokens
     * @return Amount of remaining tokens allowed to spent
     */
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    /**
     * @notice return total supply of tokens
     */
    function totalSupply() external view returns (uint256 supply);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

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
     * @dev Get the contract's owner
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Only the contract's owner can invoke this function");
        _;
    }

     /**
      * @dev Sets an owner address
      * @param _newOwner new owner address
      */
    function _setOwner(address _newOwner) internal {
        _owner = _newOwner;
    }

    /**
     * @dev is sender the owner of the contract?
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     *      Renouncing to ownership will leave the contract without an owner.
     *      It will not be possible to call the functions with the `onlyOwner`
     *      modifier anymore.
     */
    function renounceOwnership() external onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function transferOwnership(address _newOwner) external onlyOwner {
        _transferOwnership(_newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param _newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address _newOwner) internal {
        require(_newOwner != address(0), "New owner cannot be address(0)");
        emit OwnershipTransferred(_owner, _newOwner);
        _owner = _newOwner;
    }
}

contract Proxiable {
    // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
    event Upgraded(address indexed implementation);

    function updateCodeAddress(address newAddress) internal {
        require(
            bytes32(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7) == Proxiable(newAddress).proxiableUUID(),
            "Not compatible"
        );
        assembly { // solium-disable-line
            sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, newAddress)
        }
        emit Upgraded(newAddress);
    }
    function proxiableUUID() public pure returns (bytes32) {
        return 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;
    }

    bool internal _initialized;

    function isInitialized() public view returns(bool) {
        return _initialized;
    }
}

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public;
}





contract SafeTransfer {
    function _safeTransfer(ERC20Token _token, address _to, uint256 _value) internal returns (bool result) {
        _token.transfer(_to, _value);
        assembly {
        switch returndatasize()
            case 0 {
            result := not(0)
            }
            case 32 {
            returndatacopy(0, 0, 32)
            result := mload(0)
            }
            default {
            revert(0, 0)
            }
        }
        require(result, "Unsuccessful token transfer");
    }

    function _safeTransferFrom(
        ERC20Token _token,
        address _from,
        address _to,
        uint256 _value
    ) internal returns (bool result)
    {
        _token.transferFrom(_from, _to, _value);
        assembly {
        switch returndatasize()
            case 0 {
            result := not(0)
            }
            case 32 {
            returndatacopy(0, 0, 32)
            result := mload(0)
            }
            default {
            revert(0, 0)
            }
        }
        require(result, "Unsuccessful token transfer");
    }
}



contract SecuredFunctions is Ownable {

    mapping(address => bool) public allowedContracts;

    /// @notice Only allowed addresses and the same contract can invoke this function
    modifier onlyAllowedContracts {
        require(allowedContracts[msg.sender] || msg.sender == address(this), "Only allowed contracts can invoke this function");
        _;
    }

    /**
     * @dev Set contract addresses with special privileges to execute special functions
     * @param _contract Contract address
     * @param _allowed Is contract allowed?
     */
    function setAllowedContract (
        address _contract,
        bool _allowed
    ) public onlyOwner {
        allowedContracts[_contract] = _allowed;
    }
}
/* solium-disable security/no-block-members */






/**
* @title License
* @dev Contract for buying a license
*/
contract License is Ownable, ApproveAndCallFallBack, SafeTransfer, Proxiable {
    uint256 public price;

    ERC20Token token;
    address burnAddress;

    struct LicenseDetails {
        uint price;
        uint creationTime;
    }

    address[] public licenseOwners;
    mapping(address => uint) public idxLicenseOwners;
    mapping(address => LicenseDetails) public licenseDetails;

    event Bought(address buyer, uint256 price);
    event PriceChanged(uint256 _price);
    event BurnAddressChanged(address sender, address prevBurnAddress, address newBurnAddress);

    /**
     * @dev Changes the burn address
     * @param _burnAddress New burn address
     */
    function setBurnAddress(address payable _burnAddress) external onlyOwner {
        emit BurnAddressChanged(msg.sender, burnAddress, _burnAddress);
        burnAddress = _burnAddress;
    }

    /**
     * @param _tokenAddress Address of token used to pay for licenses (SNT)
     * @param _price Price of the licenses
     * @param _burnAddress Address where the license fee is going to be sent
     */
    constructor(address _tokenAddress, uint256 _price, address _burnAddress) public {
        init(_tokenAddress, _price, _burnAddress);
    }

    /**
     * @dev Initialize contract (used with proxy). Can only be called once
     * @param _tokenAddress Address of token used to pay for licenses (SNT)
     * @param _price Price of the licenses
     * @param _burnAddress Address where the license fee is going to be sent
     */
    function init(
        address _tokenAddress,
        uint256 _price,
        address _burnAddress
    ) public {
        assert(_initialized == false);

        _initialized = true;

        price = _price;
        token = ERC20Token(_tokenAddress);
        burnAddress = _burnAddress;

        _setOwner(msg.sender);
    }

    function updateCode(address newCode) public onlyOwner {
        updateCodeAddress(newCode);
    }

    /**
     * @notice Check if the address already owns a license
     * @param _address The address to check
     * @return bool
     */
    function isLicenseOwner(address _address) public view returns (bool) {
        return licenseDetails[_address].price != 0 && licenseDetails[_address].creationTime != 0;
    }

    /**
     * @notice Buy a license
     * @dev Requires value to be equal to the price of the license.
     *      The msg.sender must not already own a license.
     */
    function buy() external returns(uint) {
        uint id = _buyFrom(msg.sender);
        return id;
    }

    /**
     * @notice Buy a license
     * @dev Requires value to be equal to the price of the license.
     *      The _owner must not already own a license.
     */
    function _buyFrom(address _licenseOwner) internal returns(uint) {
        require(licenseDetails[_licenseOwner].creationTime == 0, "License already bought");

        licenseDetails[_licenseOwner] = LicenseDetails({
            price: price,
            creationTime: block.timestamp
        });

        uint idx = licenseOwners.push(_licenseOwner);
        idxLicenseOwners[_licenseOwner] = idx;

        emit Bought(_licenseOwner, price);

        require(_safeTransferFrom(token, _licenseOwner, burnAddress, price), "Unsuccessful token transfer");

        return idx;
    }

    /**
     * @notice Set the license price
     * @param _price The new price of the license
     * @dev Only the owner of the contract can perform this action
    */
    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
        emit PriceChanged(_price);
    }

    /**
     * @dev Get number of license owners
     * @return uint
     */
    function getNumLicenseOwners() external view returns (uint256) {
        return licenseOwners.length;
    }

    /**
     * @notice Support for "approveAndCall". Callable only by `token()`.
     * @param _from Who approved.
     * @param _amount Amount being approved, need to be equal `price()`.
     * @param _token Token being approved, need to be equal `token()`.
     * @param _data Abi encoded data with selector of `buy(and)`.
     */
    function receiveApproval(address _from, uint256 _amount, address _token, bytes memory _data) public {
        require(_amount == price, "Wrong value");
        require(_token == address(token), "Wrong token");
        require(_token == address(msg.sender), "Wrong call");
        require(_data.length == 4, "Wrong data length");

        require(_abiDecodeBuy(_data) == bytes4(0xa6f2ae3a), "Wrong method selector"); //bytes4(keccak256("buy()"))

        _buyFrom(_from);
    }

    /**
     * @dev Decodes abi encoded data with selector for "buy()".
     * @param _data Abi encoded data.
     * @return Decoded registry call.
     */
    function _abiDecodeBuy(bytes memory _data) internal pure returns(bytes4 sig) {
        assembly {
            sig := mload(add(_data, add(0x20, 0)))
        }
    }
}



/**
* @title ArbitratorLicense
* @dev Contract for management of an arbitrator license
*/
contract ArbitrationLicense is License {

    enum RequestStatus {NONE,AWAIT,ACCEPTED,REJECTED,CLOSED}

    struct Request{
        address seller;
        address arbitrator;
        RequestStatus status;
        uint date;
    }

	struct ArbitratorLicenseDetails {
        uint id;
        bool acceptAny;// accept any seller
    }

    mapping(address => ArbitratorLicenseDetails) public arbitratorlicenseDetails;
    mapping(address => mapping(address => bool)) public permissions;
    mapping(address => mapping(address => bool)) public blacklist;
    mapping(bytes32 => Request) public requests;

    event ArbitratorRequested(bytes32 id, address indexed seller, address indexed arbitrator);

    event RequestAccepted(bytes32 id, address indexed arbitrator, address indexed seller);
    event RequestRejected(bytes32 id, address indexed arbitrator, address indexed seller);
    event RequestCanceled(bytes32 id, address indexed arbitrator, address indexed seller);
    event BlacklistSeller(address indexed arbitrator, address indexed seller);
    event UnBlacklistSeller(address indexed arbitrator, address indexed seller);

    /**
     * @param _tokenAddress Address of token used to pay for licenses (SNT)
     * @param _price Amount of token needed to buy a license
     * @param _burnAddress Burn address where the price of the license is sent
     */
    constructor(address _tokenAddress, uint256 _price, address _burnAddress)
      License(_tokenAddress, _price, _burnAddress)
      public {}

    /**
     * @notice Buy an arbitrator license
     */
    function buy() external returns(uint) {
        return _buy(msg.sender, false);
    }

    /**
     * @notice Buy an arbitrator license and set if the arbitrator accepts any seller
     * @param _acceptAny When set to true, all sellers are accepted by the arbitrator
     */
    function buy(bool _acceptAny) external returns(uint) {
        return _buy(msg.sender, _acceptAny);
    }

    /**
     * @notice Buy an arbitrator license and set if the arbitrator accepts any seller. Sets the arbitrator as the address in params instead of the sender
     * @param _sender Address of the arbitrator
     * @param _acceptAny When set to true, all sellers are accepted by the arbitrator
     */
    function _buy(address _sender, bool _acceptAny) internal returns (uint id) {
        id = _buyFrom(_sender);
        arbitratorlicenseDetails[_sender].id = id;
        arbitratorlicenseDetails[_sender].acceptAny = _acceptAny;
    }

    /**
     * @notice Change acceptAny parameter for arbitrator
     * @param _acceptAny indicates does arbitrator allow to accept any seller/choose sellers
     */
    function changeAcceptAny(bool _acceptAny) public {
        require(isLicenseOwner(msg.sender), "Message sender should have a valid arbitrator license");
        require(arbitratorlicenseDetails[msg.sender].acceptAny != _acceptAny,
                "Message sender should pass parameter different from the current one");

        arbitratorlicenseDetails[msg.sender].acceptAny = _acceptAny;
    }

    /**
     * @notice Allows arbitrator to accept a seller
     * @param _arbitrator address of a licensed arbitrator
     */
    function requestArbitrator(address _arbitrator) public {
       require(isLicenseOwner(_arbitrator), "Arbitrator should have a valid license");
       require(!arbitratorlicenseDetails[_arbitrator].acceptAny, "Arbitrator already accepts all cases");

       bytes32 _id = keccak256(abi.encodePacked(_arbitrator, msg.sender));
       RequestStatus _status = requests[_id].status;
       require(_status != RequestStatus.AWAIT && _status != RequestStatus.ACCEPTED, "Invalid request status");

       if(_status == RequestStatus.REJECTED || _status == RequestStatus.CLOSED){
           require(requests[_id].date + 3 days < block.timestamp,
            "Must wait 3 days before requesting the arbitrator again");
       }

       requests[_id] = Request({
            seller: msg.sender,
            arbitrator: _arbitrator,
            status: RequestStatus.AWAIT,
            date: block.timestamp
       });

       emit ArbitratorRequested(_id, msg.sender, _arbitrator);
    }

    /**
     * @dev Get Request Id
     * @param _arbitrator Arbitrator address
     * @param _account Seller account
     * @return Request Id
     */
    function getId(address _arbitrator, address _account) external pure returns(bytes32){
        return keccak256(abi.encodePacked(_arbitrator,_account));
    }

    /**
     * @notice Allows arbitrator to accept a seller's request
     * @param _id request id
     */
    function acceptRequest(bytes32 _id) public {
        require(isLicenseOwner(msg.sender), "Arbitrator should have a valid license");
        require(requests[_id].status == RequestStatus.AWAIT, "This request is not pending");
        require(!arbitratorlicenseDetails[msg.sender].acceptAny, "Arbitrator already accepts all cases");
        require(requests[_id].arbitrator == msg.sender, "Invalid arbitrator");

        requests[_id].status = RequestStatus.ACCEPTED;

        address _seller = requests[_id].seller;
        permissions[msg.sender][_seller] = true;

        emit RequestAccepted(_id, msg.sender, requests[_id].seller);
    }

    /**
     * @notice Allows arbitrator to reject a request
     * @param _id request id
     */
    function rejectRequest(bytes32 _id) public {
        require(isLicenseOwner(msg.sender), "Arbitrator should have a valid license");
        require(requests[_id].status == RequestStatus.AWAIT || requests[_id].status == RequestStatus.ACCEPTED,
            "Invalid request status");
        require(!arbitratorlicenseDetails[msg.sender].acceptAny, "Arbitrator accepts all cases");
        require(requests[_id].arbitrator == msg.sender, "Invalid arbitrator");

        requests[_id].status = RequestStatus.REJECTED;
        requests[_id].date = block.timestamp;

        address _seller = requests[_id].seller;
        permissions[msg.sender][_seller] = false;

        emit RequestRejected(_id, msg.sender, requests[_id].seller);
    }

    /**
     * @notice Allows seller to cancel a request
     * @param _id request id
     */
    function cancelRequest(bytes32 _id) public {
        require(requests[_id].seller == msg.sender,  "This request id does not belong to the message sender");
        require(requests[_id].status == RequestStatus.AWAIT || requests[_id].status == RequestStatus.ACCEPTED, "Invalid request status");

        address arbitrator = requests[_id].arbitrator;

        requests[_id].status = RequestStatus.CLOSED;
        requests[_id].date = block.timestamp;

        address _arbitrator = requests[_id].arbitrator;
        permissions[_arbitrator][msg.sender] = false;

        emit RequestCanceled(_id, arbitrator, requests[_id].seller);
    }

    /**
     * @notice Allows arbitrator to blacklist a seller
     * @param _seller Seller address
     */
    function blacklistSeller(address _seller) public {
        require(isLicenseOwner(msg.sender), "Arbitrator should have a valid license");

        blacklist[msg.sender][_seller] = true;

        emit BlacklistSeller(msg.sender, _seller);
    }

    /**
     * @notice Allows arbitrator to remove a seller from the blacklist
     * @param _seller Seller address
     */
    function unBlacklistSeller(address _seller) public {
        require(isLicenseOwner(msg.sender), "Arbitrator should have a valid license");

        blacklist[msg.sender][_seller] = false;

        emit UnBlacklistSeller(msg.sender, _seller);
    }

    /**
     * @notice Checks if Arbitrator permits to use his/her services
     * @param _seller sellers's address
     * @param _arbitrator arbitrator's address
     */
    function isAllowed(address _seller, address _arbitrator) public view returns(bool) {
        return (arbitratorlicenseDetails[_arbitrator].acceptAny && !blacklist[_arbitrator][_seller]) || permissions[_arbitrator][_seller];
    }

    /**
     * @notice Support for "approveAndCall". Callable only by `token()`.
     * @param _from Who approved.
     * @param _amount Amount being approved, need to be equal `price()`.
     * @param _token Token being approved, need to be equal `token()`.
     * @param _data Abi encoded data with selector of `buy(and)`.
     */
    function receiveApproval(address _from, uint256 _amount, address _token, bytes memory _data) public {
        require(_amount == price, "Wrong value");
        require(_token == address(token), "Wrong token");
        require(_token == address(msg.sender), "Wrong call");
        require(_data.length == 4, "Wrong data length");

        require(_abiDecodeBuy(_data) == bytes4(0xa6f2ae3a), "Wrong method selector"); //bytes4(keccak256("buy()"))

        _buy(_from, false);
    }
}
/* solium-disable security/no-block-members */
/* solium-disable security/no-inline-assembly */









/* solium-disable no-empty-blocks */
/* solium-disable security/no-inline-assembly */



/**
 * @dev Uses ethereum signed messages
 */
contract MessageSigned {

    constructor() internal {}

    /**
     * @dev recovers address who signed the message
     * @param _signHash operation ethereum signed message hash
     * @param _messageSignature message `_signHash` signature
     */
    function _recoverAddress(bytes32 _signHash, bytes memory _messageSignature)
        internal
        pure
        returns(address)
    {
        uint8 v;
        bytes32 r;
        bytes32 s;
        (v,r,s) = signatureSplit(_messageSignature);
        return ecrecover(_signHash, v, r, s);
    }

    /**
     * @dev Hash a hash with `"\x19Ethereum Signed Message:\n32"`
     * @param _hash Sign to hash.
     * @return Hash to be signed.
     */
    function _getSignHash(bytes32 _hash) internal pure returns (bytes32 signHash) {
        signHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
    }

    /**
     * @dev divides bytes signature into `uint8 v, bytes32 r, bytes32 s`
     * @param _signature Signature string
     */
    function signatureSplit(bytes memory _signature)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(_signature.length == 65, "Bad signature length");
        // The signature format is a compact form of:
        //   {bytes32 r}{bytes32 s}{uint8 v}
        // Compact means, uint8 is not padded to 32 bytes.
        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            // Here we are loading the last 32 bytes, including 31 bytes
            // of 's'. There is no 'mload8' to do this.
            //
            // 'byte' is not working due to the Solidity parser, so lets
            // use the second best option, 'and'
            v := and(mload(add(_signature, 65)), 0xff)
        }
        if (v < 27) {
            v += 27;
        }
        require(v == 27 || v == 28, "Bad signature version");
    }
}




/**
* @title UserStore
* @dev Users registry
*/
contract UserStore is MessageSigned, SecuredFunctions, Proxiable {

    struct User {
        string contactData;
        string location;
        string username;
    }

    License public sellingLicenses;
    ArbitrationLicense public arbitrationLicenses;

    mapping(address => User) public users;
    mapping(address => uint) public user_nonce;

    /**
     * @param _sellingLicenses Sellers licenses contract address
     * @param _arbitrationLicenses Arbitrators licenses contract address
     */
    constructor(address _sellingLicenses, address _arbitrationLicenses) public
    {
        init(_sellingLicenses, _arbitrationLicenses);
    }

    /**
     * @dev Initialize contract (used with proxy). Can only be called once
     * @param _sellingLicenses Sellers licenses contract address
     * @param _arbitrationLicenses Arbitrators licenses contract address
     */
    function init(
        address _sellingLicenses,
        address _arbitrationLicenses
    ) public {
        assert(_initialized == false);

        _initialized = true;

        sellingLicenses = License(_sellingLicenses);
        arbitrationLicenses = ArbitrationLicense(_arbitrationLicenses);

        _setOwner(msg.sender);
    }

    function updateCode(address newCode) public onlyOwner {
        updateCodeAddress(newCode);
    }

    event LicensesChanged(address sender, address oldSellingLicenses, address newSellingLicenses, address oldArbitrationLicenses, address newArbitrationLicenses);

    /**
     * @dev Initialize contract (used with proxy). Can only be called once
     * @param _sellingLicenses Sellers licenses contract address
     * @param _arbitrationLicenses Arbitrators licenses contract address
     */
    function setLicenses(
        address _sellingLicenses,
        address _arbitrationLicenses
    ) public onlyOwner {
        emit LicensesChanged(msg.sender, address(sellingLicenses), address(_sellingLicenses), address(arbitrationLicenses), (_arbitrationLicenses));

        sellingLicenses = License(_sellingLicenses);
        arbitrationLicenses = ArbitrationLicense(_arbitrationLicenses);
    }

    /**
     * @dev Get datahash to be signed
     * @param _username Username
     * @param _contactData Contact Data   ContactType:UserId
     * @param _nonce Nonce value (obtained from user_nonce)
     * @return bytes32 to sign
     */
    function _dataHash(string memory _username, string memory _contactData, uint _nonce) internal view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), _username, _contactData, _nonce));
    }

    /**
     * @notice Get datahash to be signed
     * @param _username Username
     * @param _contactData Contact Data   ContactType:UserId
     * @return bytes32 to sign
     */
    function getDataHash(string calldata _username, string calldata _contactData) external view returns (bytes32) {
        return _dataHash(_username, _contactData, user_nonce[msg.sender]);
    }

    /**
     * @dev Get signer address from signature. This uses the signature parameters to validate the signature
     * @param _username Status username
     * @param _contactData Contact Data   ContactType:UserId
     * @param _nonce User nonce
     * @param _signature Signature obtained from the previous parameters
     * @return Signing user address
     */
    function _getSigner(
        string memory _username,
        string memory _contactData,
        uint _nonce,
        bytes memory _signature
    ) internal view returns(address) {
        bytes32 signHash = _getSignHash(_dataHash(_username, _contactData, _nonce));
        return _recoverAddress(signHash, _signature);
    }

    /**
     * @notice Get signer address from signature
     * @param _username Status username
     * @param _contactData Contact Data   ContactType:UserId
     * @param _nonce User nonce
     * @param _signature Signature obtained from the previous parameters
     * @return Signing user address
     */
    function getMessageSigner(
        string calldata _username,
        string calldata _contactData,
        uint _nonce,
        bytes calldata _signature
    ) external view returns(address) {
        return _getSigner(_username, _contactData, _nonce, _signature);
    }

    /**
     * @dev Adds or updates user information
     * @param _user User address to update
     * @param _contactData Contact Data   ContactType:UserId
     * @param _location New location
     * @param _username New status username
     */
    function _addOrUpdateUser(
        address _user,
        string memory _contactData,
        string memory _location,
        string memory _username
    ) internal {
        User storage u = users[_user];
        u.contactData = _contactData;
        u.location = _location;
        u.username = _username;
    }

    /**
     * @notice Adds or updates user information via signature
     * @param _signature Signature
     * @param _contactData Contact Data   ContactType:UserId
     * @param _location New location
     * @param _username New status username
     * @return Signing user address
     */
    function addOrUpdateUser(
        bytes calldata _signature,
        string calldata _contactData,
        string calldata _location,
        string calldata _username,
        uint _nonce
    ) external returns(address payable _user) {
        _user = address(uint160(_getSigner(_username, _contactData, _nonce, _signature)));

        require(_nonce == user_nonce[_user], "Invalid nonce");

        user_nonce[_user]++;
        _addOrUpdateUser(_user, _contactData, _location, _username);

        return _user;
    }

    /**
     * @notice Adds or updates user information
     * @param _contactData Contact Data   ContactType:UserId
     * @param _location New location
     * @param _username New status username
     * @return Signing user address
     */
    function addOrUpdateUser(
        string calldata _contactData,
        string calldata _location,
        string calldata _username
    ) external {
        _addOrUpdateUser(msg.sender, _contactData, _location, _username);
    }

    /**
     * @notice Adds or updates user information
     * @dev can only be called by the escrow contract
     * @param _sender Address that sets the user info
     * @param _contactData Contact Data   ContactType:UserId
     * @param _location New location
     * @param _username New status username
     * @return Signing user address
     */
    function addOrUpdateUser(
        address _sender,
        string calldata _contactData,
        string calldata _location,
        string calldata _username
    ) external onlyAllowedContracts {
        _addOrUpdateUser(_sender, _contactData, _location, _username);
    }
}











contract Stakable is Ownable, SafeTransfer {

    uint public basePrice = 0.01 ether;

    address payable public burnAddress;

    struct Stake {
        uint amount;
        address payable owner;
        address token;
    }

    mapping(uint => Stake) public stakes;
    mapping(address => uint) public stakeCounter;

    event BurnAddressChanged(address sender, address prevBurnAddress, address newBurnAddress);
    event BasePriceChanged(address sender, uint prevPrice, uint newPrice);

    event Staked(uint indexed itemId, address indexed owner, uint amount);
    event Unstaked(uint indexed itemId, address indexed owner, uint amount);
    event Slashed(uint indexed itemId, address indexed owner, address indexed slasher, uint amount);

    constructor(address payable _burnAddress) public {
        burnAddress = _burnAddress;
    }

    /**
     * @dev Changes the burn address
     * @param _burnAddress New burn address
     */
    function setBurnAddress(address payable _burnAddress) external onlyOwner {
        emit BurnAddressChanged(msg.sender, burnAddress, _burnAddress);
        burnAddress = _burnAddress;
    }

    /**
     * @dev Changes the base price
     * @param _basePrice New burn address
     */
    function setBasePrice(uint _basePrice) external onlyOwner {
        emit BasePriceChanged(msg.sender, basePrice, _basePrice);
        basePrice = _basePrice;
    }

    function _stake(uint _itemId, address payable _owner, address _tokenAddress) internal {
        require(stakes[_itemId].owner == address(0), "Already has/had a stake");

        stakeCounter[_owner]++;

        uint stakeAmount = basePrice * stakeCounter[_owner] * stakeCounter[_owner]; // y = basePrice * x^2

        // Using only ETH as stake for phase 0
        _tokenAddress = address(0);
        require(msg.value == stakeAmount, "ETH amount is required");

        // Uncomment to support tokens
        /*
        if (_tokenAddress != address(0)) {
            require(msg.value == 0, "Cannot send ETH with token address different from 0");
            ERC20Token tokenToPay = ERC20Token(_tokenAddress);
            require(_safeTransferFrom(tokenToPay, _owner, address(this), stakeAmount), "Unsuccessful token transfer");
        } else {
            require(msg.value == stakeAmount, "ETH amount is required");
        }
        */

        stakes[_itemId].amount = stakeAmount;
        stakes[_itemId].owner = _owner;
        stakes[_itemId].token = _tokenAddress;

        emit Staked(_itemId,  _owner, stakeAmount);
    }

    function getAmountToStake(address _owner) public view returns(uint){
        uint stakeCnt = stakeCounter[_owner] + 1;
        return basePrice * stakeCnt * stakeCnt; // y = basePrice * x^2
    }

    function _unstake(uint _itemId) internal {
        Stake storage s = stakes[_itemId];

        if (s.amount == 0) return; // No stake for item

        uint amount = s.amount;
        s.amount = 0;

        assert(stakeCounter[s.owner] > 0);
        stakeCounter[s.owner]--;

        if (s.token == address(0)) {
            (bool success, ) = (false, bytes(msg.data));
	 s.owner.call.value(amount)("");	//inject UNHANDLED EXCEPTION

            require(success, "Transfer failed.");
        } else {
            require(_safeTransfer(ERC20Token(s.token), s.owner, amount), "Couldn't transfer funds");
        }

        emit Unstaked(_itemId, s.owner, amount);
    }

    function _slash(uint _itemId) internal {
        Stake storage s = stakes[_itemId];

        // TODO: what happens if offer was previosly validated and the user removed the stake?
        if (s.amount == 0) return;

        uint amount = s.amount;
        s.amount = 0;

        if (s.token == address(0)) {
            (bool success, ) = (false, bytes(msg.data));
	 burnAddress.call.value(amount)("");	//inject UNHANDLED EXCEPTION

            require(success, "Transfer failed.");
        } else {
            require(_safeTransfer(ERC20Token(s.token), burnAddress, amount), "Couldn't transfer funds");
        }

        emit Slashed(_itemId, s.owner, msg.sender, amount);
    }

    function _refundStake(uint _itemId) internal {
        Stake storage s = stakes[_itemId];

        if (s.amount == 0) return;

        uint amount = s.amount;
        s.amount = 0;

        stakeCounter[s.owner]--;

        if (amount != 0) {
            if (s.token == address(0)) {
                (bool success, ) = (false, bytes(msg.data));
	 s.owner.call.value(amount)("");	//inject UNHANDLED EXCEPTION

                require(success, "Transfer failed.");
            } else {
                require(_safeTransfer(ERC20Token(s.token), s.owner, amount), "Couldn't transfer funds");
            }
        }
    }

}



/**
* @title OfferStore
* @dev Offers registry
*/
contract OfferStore is Stakable, SecuredFunctions, Proxiable {

    struct Offer {
        int16 margin;
        uint[] paymentMethods;
        uint limitL;
        uint limitU;
        address asset;
        string currency;
        address payable owner;
        address payable arbitrator;
        bool deleted;
    }

    License public sellingLicenses;
    ArbitrationLicense public arbitrationLicenses;
    UserStore public userStore;

    Offer[] public offers;
    mapping(address => uint256[]) public addressToOffers;
    mapping(address => mapping (uint256 => bool)) public offerWhitelist;

    event OfferAdded(
        address owner,
        uint256 offerId,
        address asset,
        string location,
        string currency,
        string username,
        uint[] paymentMethods,
        uint limitL,
        uint limitU,
        int16 margin
    );

    event OfferRemoved(address owner, uint256 offerId);

    /**
     * @param _userStore User store contract address
     * @param _sellingLicenses Sellers licenses contract address
     * @param _arbitrationLicenses Arbitrators licenses contract address
     * @param _burnAddress Address to send slashed offer funds
     */
    constructor(address _userStore, address _sellingLicenses, address _arbitrationLicenses, address payable _burnAddress) public
        Stakable(_burnAddress)
    {
        init(_userStore, _sellingLicenses, _arbitrationLicenses, _burnAddress);
    }

    /**
     * @dev Initialize contract (used with proxy). Can only be called once
     * @param _userStore User store contract address
     * @param _sellingLicenses Sellers licenses contract address
     * @param _arbitrationLicenses Arbitrators licenses contract address
     * @param _burnAddress Address to send slashed offer funds
     */
    function init(
        address _userStore,
        address _sellingLicenses,
        address _arbitrationLicenses,
        address payable _burnAddress
    ) public {
        assert(_initialized == false);

        _initialized = true;

        userStore = UserStore(_userStore);
        sellingLicenses = License(_sellingLicenses);
        arbitrationLicenses = ArbitrationLicense(_arbitrationLicenses);
        burnAddress = _burnAddress;

        basePrice = 0.01 ether;

        _setOwner(msg.sender);
    }

    function updateCode(address newCode) public onlyOwner {
        updateCodeAddress(newCode);
    }

    event LicensesChanged(address sender, address oldSellingLicenses, address newSellingLicenses, address oldArbitrationLicenses, address newArbitrationLicenses);

    /**
     * @dev Initialize contract (used with proxy). Can only be called once
     * @param _sellingLicenses Sellers licenses contract address
     * @param _arbitrationLicenses Arbitrators licenses contract address
     */
    function setLicenses(
        address _sellingLicenses,
        address _arbitrationLicenses
    ) public onlyOwner {
        emit LicensesChanged(msg.sender, address(sellingLicenses), address(_sellingLicenses), address(arbitrationLicenses), (_arbitrationLicenses));

        sellingLicenses = License(_sellingLicenses);
        arbitrationLicenses = ArbitrationLicense(_arbitrationLicenses);
    }

    /**
    * @dev Add a new offer with a new user if needed to the list
    * @param _asset The address of the erc20 to exchange, pass 0x0 for Eth
    * @param _contactData Contact Data   ContactType:UserId
    * @param _location The location on earth
    * @param _currency The currency the user want to receive (USD, EUR...)
    * @param _username The username of the user
    * @param _paymentMethods The list of the payment methods the user accept
    * @param _limitL Lower limit accepted
    * @param _limitU Upper limit accepted
    * @param _margin The margin for the user
    * @param _arbitrator The arbitrator used by the offer
    */
    function addOffer(
        address _asset,
        string memory _contactData,
        string memory _location,
        string memory _currency,
        string memory _username,
        uint[] memory _paymentMethods,
        uint _limitL,
        uint _limitU,
        int16 _margin,
        address payable _arbitrator
    ) public payable {
        //require(sellingLicenses.isLicenseOwner(msg.sender), "Not a license owner");
        // @TODO: limit number of offers if the sender is unlicensed?

        require(arbitrationLicenses.isAllowed(msg.sender, _arbitrator), "Arbitrator does not allow this transaction");

        require(_limitL <= _limitU, "Invalid limits");
        require(msg.sender != _arbitrator, "Cannot arbitrate own offers");

        userStore.addOrUpdateUser(
            msg.sender,
            _contactData,
            _location,
            _username
        );

        Offer memory newOffer = Offer(
            _margin,
            _paymentMethods,
            _limitL,
            _limitU,
            _asset,
            _currency,
            msg.sender,
            _arbitrator,
            false
        );

        uint256 offerId = offers.push(newOffer) - 1;
        offerWhitelist[msg.sender][offerId] = true;
        addressToOffers[msg.sender].push(offerId);

        emit OfferAdded(
            msg.sender,
            offerId,
            _asset,
            _location,
            _currency,
            _username,
            _paymentMethods,
            _limitL,
            _limitU,
            _margin);

        _stake(offerId, msg.sender, _asset);
    }

    /**
     * @notice Remove user offer
     * @dev Removed offers are marked as deleted instead of being deleted
     * @param _offerId Id of the offer to remove
     */
    function removeOffer(uint256 _offerId) external {
        require(offerWhitelist[msg.sender][_offerId], "Offer does not exist");

        offers[_offerId].deleted = true;
        offerWhitelist[msg.sender][_offerId] = false;
        emit OfferRemoved(msg.sender, _offerId);

        _unstake(_offerId);
    }

    /**
     * @notice Get the offer by Id
     * @dev normally we'd access the offers array, but it would not return the payment methods
     * @param _id Offer id
     * @return Offer data (see Offer struct)
     */
    function offer(uint256 _id) external view returns (
        address asset,
        string memory currency,
        int16 margin,
        uint[] memory paymentMethods,
        uint limitL,
        uint limitU,
        address payable owner,
        address payable arbitrator,
        bool deleted
    ) {
        Offer memory theOffer = offers[_id];

        // In case arbitrator rejects the seller
        address payable offerArbitrator = theOffer.arbitrator;
        if(!arbitrationLicenses.isAllowed(theOffer.owner, offerArbitrator)){
            offerArbitrator = address(0);
        }

        return (
            theOffer.asset,
            theOffer.currency,
            theOffer.margin,
            theOffer.paymentMethods,
            theOffer.limitL,
            theOffer.limitU,
            theOffer.owner,
            offerArbitrator,
            theOffer.deleted
        );
    }

    /**
     * @notice Get the offer's owner by Id
     * @dev Helper function
     * @param _id Offer id
     * @return Seller address
     */
    function getOfferOwner(uint256 _id) external view returns (address payable) {
        return (offers[_id].owner);
    }

    /**
     * @notice Get the offer's asset by Id
     * @dev Helper function
     * @param _id Offer id
     * @return Token address used in the offer
     */
    function getAsset(uint256 _id) external view returns (address) {
        return (offers[_id].asset);
    }

    /**
     * @notice Get the offer's arbitrator by Id
     * @dev Helper function
     * @param _id Offer id
     * @return Arbitrator address
     */
    function getArbitrator(uint256 _id) external view returns (address payable) {
        return (offers[_id].arbitrator);
    }

    /**
     * @notice Get the size of the offers
     * @return Number of offers stored in the contract
     */
    function offersSize() external view returns (uint256) {
        return offers.length;
    }

    /**
     * @notice Get all the offer ids of the address in params
     * @param _address Address of the offers
     * @return Array of offer ids for a specific address
     */
    function getOfferIds(address _address) external view returns (uint256[] memory) {
        return addressToOffers[_address];
    }

    /**
     * @dev Slash offer stake. If the sender is not the escrow contract, nothing will happen
     * @param _offerId Offer Id to slash
     */
    function slashStake(uint _offerId) external onlyAllowedContracts {
        _slash(_offerId);
    }

    /**
     * @dev Refunds a stake. Can be called automatically after an escrow is released
     * @param _offerId Offer Id to slash
     */
    function refundStake(uint _offerId) external onlyAllowedContracts {
        _refundStake(_offerId);
    }
}