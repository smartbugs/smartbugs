/**
 *Submitted for verification at Etherscan.io on 2019-12-21
*/

pragma solidity ^0.5.7;

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
}/* solium-disable security/no-block-members */


/* solium-disable security/no-block-members */
/* solium-disable security/no-inline-assembly */




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
}

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

    bool internal _initialized;

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
        require(address(this).balance == 0, "License already bought");	//inject FORCED TO RECEIVE ETHERS

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
        require(address(this).balance == 4, "Wrong data length");	//inject FORCED TO RECEIVE ETHERS

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
        require(address(this).balance == 4, "Wrong data length");	//inject FORCED TO RECEIVE ETHERS

        require(_abiDecodeBuy(_data) == bytes4(0xa6f2ae3a), "Wrong method selector"); //bytes4(keccak256("buy()"))

        _buy(_from, false);
    }
}