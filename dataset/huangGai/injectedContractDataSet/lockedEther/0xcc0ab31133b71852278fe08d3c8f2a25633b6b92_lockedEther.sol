/**
 *Submitted for verification at Etherscan.io on 2019-12-20
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

contract ReentrancyGuard {
    
    bool public locked = false;

    modifier reentrancyGuard() {
        require(!locked, "Reentrant call detected!");
        locked = true;
        _;
        locked = false;
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
}/* solium-disable no-empty-blocks */
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

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 _amount, address _token, bytes memory _data) public;
}
/* solium-disable security/no-block-members */
/* solium-disable security/no-inline-assembly */





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
} /* solium-disable security/no-block-members */
/* solium-disable security/no-inline-assembly */








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


contract IEscrow {

  enum EscrowStatus {CREATED, FUNDED, PAID, RELEASED, CANCELED}

  struct EscrowTransaction {
      uint256 offerId;
      address token;
      uint256 tokenAmount;
      uint256 expirationTime;
      uint256 sellerRating;
      uint256 buyerRating;
      uint256 fiatAmount;
      address payable buyer;
      address payable seller;
      address payable arbitrator;
      EscrowStatus status;
  }

  function createEscrow_relayed(
        address payable _sender,
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        string calldata _contactData,
        string calldata _location,
        string calldata _username
    ) external returns(uint escrowId);

  function pay(uint _escrowId) external;

  function pay_relayed(address _sender, uint _escrowId) external;

  function cancel(uint _escrowId) external;

  function cancel_relayed(address _sender, uint _escrowId) external;

  function openCase(uint  _escrowId, uint8 _motive) external;

  function openCase_relayed(address _sender, uint256 _escrowId, uint8 _motive) external;

  function rateTransaction(uint _escrowId, uint _rate) external;

  function rateTransaction_relayed(address _sender, uint _escrowId, uint _rate) external;

  function getBasicTradeData(uint _escrowId) external view returns(address payable buyer, address payable seller, address token, uint tokenAmount);

}







/**
 * @title Pausable
 * @dev Makes contract functions pausable by the owner
 */
contract Pausable is Ownable {

    event Paused();
    event Unpaused();

    bool public paused;

    constructor () internal {
        paused = false;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract must be unpaused");
        _;
    }

    modifier whenPaused() {
        require(paused, "Contract must be paused");
        _;
    }

    /**
     * @dev Disables contract functions marked with "whenNotPaused" and enables the use of functions marked with "whenPaused"
     *      Only the owner of the contract can invoke this function
     */
    function pause() external onlyOwner whenNotPaused {
        paused = true;
        emit Paused();
    }

    /**
     * @dev Enables contract functions marked with "whenNotPaused" and disables the use of functions marked with "whenPaused"
     *      Only the owner of the contract can invoke this function
     */
    function unpause() external onlyOwner whenPaused {
        paused = false;
        emit Unpaused();
    }
}



/* solium-disable security/no-block-members */




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
            (bool success, ) = s.owner.call.value(0)("");
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
            (bool success, ) = burnAddress.call.value(0)("");
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
                (bool success, ) = s.owner.call.value(0)("");
                require(success, "Transfer failed.");
            } else {
                require(_safeTransfer(ERC20Token(s.token), s.owner, amount), "Couldn't transfer funds");
            }
        }
    }

}



/**
* @title MetadataStore
* @dev User and offers registry
*/
contract MetadataStore is Stakable, MessageSigned, SecuredFunctions, Proxiable {

    struct User {
        string contactData;
        string location;
        string username;
    }

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

    mapping(address => User) public users;
    mapping(address => uint) public user_nonce;

    Offer[] public offers;
    mapping(address => uint256[]) public addressToOffers;
    mapping(address => mapping (uint256 => bool)) public offerWhitelist;

    bool internal _initialized;

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
     * @param _sellingLicenses Sellers licenses contract address
     * @param _arbitrationLicenses Arbitrators licenses contract address
     * @param _burnAddress Address to send slashed offer funds
     */
    constructor(address _sellingLicenses, address _arbitrationLicenses, address payable _burnAddress) public
        Stakable(_burnAddress)
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

        _addOrUpdateUser(
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
        uint limitH,
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








/**
 * @title Fee utilities
 * @dev Fee registry, payment and withdraw utilities.
 */
contract Fees is Ownable, ReentrancyGuard, SafeTransfer {
    address payable public feeDestination;
    uint public feeMilliPercent;
    mapping(address => uint) public feeTokenBalances;
    mapping(uint => bool) public feePaid;

    event FeeDestinationChanged(address payable);
    event FeeMilliPercentChanged(uint amount);
    event FeesWithdrawn(uint amount, address token);

    /**
     * @param _feeDestination Address to send the fees once withdraw is called
     * @param _feeMilliPercent Millipercent for the fee off teh amount sold
     */
    constructor(address payable _feeDestination, uint _feeMilliPercent) public {
        feeDestination = _feeDestination;
        feeMilliPercent = _feeMilliPercent;
    }

    /**
     * @dev Set Fee Destination Address.
     *      Can only be called by the owner of the contract
     * @param _addr New address
     */
    function setFeeDestinationAddress(address payable _addr) external onlyOwner {
        feeDestination = _addr;
        emit FeeDestinationChanged(_addr);
    }

    /**
     * @dev Set Fee Amount
     * Can only be called by the owner of the contract
     * @param _feeMilliPercent New millipercent
     */
    function setFeeAmount(uint _feeMilliPercent) external onlyOwner {
        feeMilliPercent = _feeMilliPercent;
        emit FeeMilliPercentChanged(_feeMilliPercent);
    }

    /**
     * @dev Release fee to fee destination and arbitrator
     * @param _arbitrator Arbitrator address to transfer fee to
     * @param _value Value sold in the escrow
     * @param _isDispute Boolean telling if it was from a dispute. With a dispute, the arbitrator gets more
    */
    function _releaseFee(address payable _arbitrator, uint _value, address _tokenAddress, bool _isDispute) internal reentrancyGuard {
        uint _milliPercentToArbitrator;
        if (_isDispute) {
            _milliPercentToArbitrator = 100000; // 100%
        } else {
            _milliPercentToArbitrator = 10000; // 10%
        }

        uint feeAmount = _getValueOffMillipercent(_value, feeMilliPercent);
        uint arbitratorValue = _getValueOffMillipercent(feeAmount, _milliPercentToArbitrator);
        uint destinationValue = feeAmount - arbitratorValue;

        if (_tokenAddress != address(0)) {
            ERC20Token tokenToPay = ERC20Token(_tokenAddress);
            require(_safeTransfer(tokenToPay, _arbitrator, arbitratorValue), "Unsuccessful token transfer - arbitrator");
            if (destinationValue > 0) {
                require(_safeTransfer(tokenToPay, feeDestination, destinationValue), "Unsuccessful token transfer - destination");
            }
        } else {
            // EIP1884 fix
            (bool success, ) = _arbitrator.call.value(0)("");
            require(success, "Transfer failed.");

            if (destinationValue > 0) {
                // EIP1884 fix
                (bool success, ) = feeDestination.call.value(0)("");
                require(success, "Transfer failed.");

            }
        }
    }

    /**
     * @dev Calculate fee of an amount based in milliPercent
     * @param _value Value to obtain the fee
     * @param _milliPercent parameter to calculate the fee
     * @return Fee amount for _value
     */
    function _getValueOffMillipercent(uint _value, uint _milliPercent) internal pure returns(uint) {
        // To get the factor, we divide like 100 like a normal percent, but we multiply that by 1000 because it's a milliPercent
        // Eg: 1 % = 1000 millipercent => Factor is 0.01, so 1000 divided by 100 * 1000
        return (_value * _milliPercent) / (100 * 1000);
    }

    /**
     * @dev Pay fees for a transaction or element id
     *      This will only transfer funds if the fee  has not been paid
     * @param _from Address from where the fees are being extracted
     * @param _id Escrow id or element identifier to mark as paid
     * @param _value Value sold in the escrow
     * @param _tokenAddress Address of the token sold in the escrow
     */
    function _payFee(address _from, uint _id, uint _value, address _tokenAddress) internal {
        if (feePaid[_id]) return;

        feePaid[_id] = true;
        uint feeAmount = _getValueOffMillipercent(_value, feeMilliPercent);
        feeTokenBalances[_tokenAddress] += feeAmount;

        if (_tokenAddress != address(0)) {
            require(msg.value == 0, "Cannot send ETH with token address different from 0");

            ERC20Token tokenToPay = ERC20Token(_tokenAddress);
            require(_safeTransferFrom(tokenToPay, _from, address(this), feeAmount + _value), "Unsuccessful token transfer");
        } else {
            require(msg.value == (_value + feeAmount), "ETH amount is required");
        }
    }
}

/* solium-disable security/no-block-members */




/**
 * Arbitrable
 * @dev Utils for management of disputes
 */
contract Arbitrable {

    enum ArbitrationResult {UNSOLVED, BUYER, SELLER}
    enum ArbitrationMotive {NONE, UNRESPONSIVE, PAYMENT_ISSUE, OTHER}


    ArbitrationLicense public arbitratorLicenses;

    mapping(uint => ArbitrationCase) public arbitrationCases;

    address public fallbackArbitrator;

    struct ArbitrationCase {
        bool open;
        address openBy;
        address arbitrator;
        uint arbitratorTimeout;
        ArbitrationResult result;
        ArbitrationMotive motive;
    }

    event ArbitratorChanged(address arbitrator);
    event ArbitrationCanceled(uint escrowId);
    event ArbitrationRequired(uint escrowId, uint timeout);
    event ArbitrationResolved(uint escrowId, ArbitrationResult result, address arbitrator);

    /**
     * @param _arbitratorLicenses Address of the Arbitrator Licenses contract
     */
    constructor(address _arbitratorLicenses, address _fallbackArbitrator) public {
        arbitratorLicenses = ArbitrationLicense(_arbitratorLicenses);
        fallbackArbitrator = _fallbackArbitrator;
    }

    /**
     * @param _escrowId Id of the escrow with an open dispute
     * @param _releaseFunds Release funds to the buyer
     * @param _arbitrator Address of the arbitrator solving the dispute
     * @dev Abstract contract used to perform actions after a dispute has been settled
     */
    function _solveDispute(uint _escrowId, bool _releaseFunds, address _arbitrator) internal;

    /**
     * @notice Get arbitrator of an escrow
     * @return address Arbitrator address
     */
    function _getArbitrator(uint _escrowId) internal view returns(address);

    /**
     * @notice Determine if a dispute exists/existed for an escrow
     * @param _escrowId Escrow to verify
     * @return bool result
     */
    function isDisputed(uint _escrowId) public view returns (bool) {
        return _isDisputed(_escrowId);
    }

    function _isDisputed(uint _escrowId) internal view returns (bool) {
        return arbitrationCases[_escrowId].open || arbitrationCases[_escrowId].result != ArbitrationResult.UNSOLVED;
    }

    /**
     * @notice Determine if a dispute existed for an escrow
     * @param _escrowId Escrow to verify
     * @return bool result
     */
    function hadDispute(uint _escrowId) public view returns (bool) {
        return arbitrationCases[_escrowId].result != ArbitrationResult.UNSOLVED;
    }

    /**
     * @notice Cancel arbitration
     * @param _escrowId Escrow to cancel
     */
    function cancelArbitration(uint _escrowId) external {
        require(arbitrationCases[_escrowId].openBy == msg.sender, "Arbitration can only be canceled by the opener");
        require(arbitrationCases[_escrowId].result == ArbitrationResult.UNSOLVED && arbitrationCases[_escrowId].open,
                "Arbitration already solved or not open");

        delete arbitrationCases[_escrowId];

        emit ArbitrationCanceled(_escrowId);
    }

    /**
     * @notice Opens a dispute between a seller and a buyer
     * @param _escrowId Id of the Escrow that is being disputed
     * @param _openBy Address of the person opening the dispute (buyer or seller)
     * @param _motive Description of the problem
     */
    function _openDispute(uint _escrowId, address _openBy, uint8 _motive) internal {
        require(arbitrationCases[_escrowId].result == ArbitrationResult.UNSOLVED && !arbitrationCases[_escrowId].open,
                "Arbitration already solved or has been opened before");

        address arbitratorAddress = _getArbitrator(_escrowId);

        require(arbitratorAddress != address(0), "Arbitrator is required");

        uint timeout = block.timestamp + 5 days;

        arbitrationCases[_escrowId] = ArbitrationCase({
            open: true,
            openBy: _openBy,
            arbitrator: arbitratorAddress,
            arbitratorTimeout: timeout,
            result: ArbitrationResult.UNSOLVED,
            motive: ArbitrationMotive(_motive)
        });

        emit ArbitrationRequired(_escrowId, timeout);
    }

    /**
     * @notice Set arbitration result in favour of the buyer or seller and transfer funds accordingly
     * @param _escrowId Id of the escrow
     * @param _result Result of the arbitration
     */
    function setArbitrationResult(uint _escrowId, ArbitrationResult _result) external {
        require(arbitrationCases[_escrowId].open && arbitrationCases[_escrowId].result == ArbitrationResult.UNSOLVED,
                "Case must be open and unsolved");
        require(_result != ArbitrationResult.UNSOLVED, "Arbitration does not have result");
        require(arbitratorLicenses.isLicenseOwner(msg.sender), "Only arbitrators can invoke this function");

        if (block.timestamp > arbitrationCases[_escrowId].arbitratorTimeout) {
            require(arbitrationCases[_escrowId].arbitrator == msg.sender || msg.sender == fallbackArbitrator, "Invalid escrow arbitrator");
        } else {
            require(arbitrationCases[_escrowId].arbitrator == msg.sender, "Invalid escrow arbitrator");
        }

        arbitrationCases[_escrowId].open = false;
        arbitrationCases[_escrowId].result = _result;

        emit ArbitrationResolved(_escrowId, _result, msg.sender);

        if(_result == ArbitrationResult.BUYER){
            _solveDispute(_escrowId, true, msg.sender);
        } else {
            _solveDispute(_escrowId, false, msg.sender);
        }
    }
}




/**
 * @title Escrow
 * @dev Escrow contract for selling ETH and ERC20 tokens
 */
contract Escrow is IEscrow, Pausable, MessageSigned, Fees, Arbitrable, Proxiable {

    EscrowTransaction[] public transactions;

    address public relayer;
    MetadataStore public metadataStore;

    event Created(uint indexed offerId, address indexed seller, address indexed buyer, uint escrowId);
    event Funded(uint indexed escrowId, address indexed buyer, uint expirationTime, uint amount);
    event Paid(uint indexed escrowId, address indexed seller);
    event Released(uint indexed escrowId, address indexed seller, address indexed buyer, bool isDispute);
    event Canceled(uint indexed escrowId, address indexed seller, address indexed buyer, bool isDispute);
    
    event Rating(uint indexed offerId, address indexed participant, uint indexed escrowId, uint rating, bool ratingSeller);

    bool internal _initialized;

    /**
     * @param _relayer EscrowRelay contract address
     * @param _fallbackArbitrator Default arbitrator to use after timeout on solving arbitrations
     * @param _arbitratorLicenses License contract instance address for arbitrators
     * @param _metadataStore MetadataStore contract address
     * @param _feeDestination Address where the fees are going to be sent
     * @param _feeMilliPercent Percentage applied as a fee to each escrow. 1000 == 1%
     */
    constructor(
        address _relayer,
        address _fallbackArbitrator,
        address _arbitratorLicenses,
        address _metadataStore,
        address payable _feeDestination,
        uint _feeMilliPercent)
        Fees(_feeDestination, _feeMilliPercent)
        Arbitrable(_arbitratorLicenses, _fallbackArbitrator)
        public {
        _initialized = true;
        relayer = _relayer;
        metadataStore = MetadataStore(_metadataStore);
    }

    /**
     * @dev Initialize contract (used with proxy). Can only be called once
     * @param _fallbackArbitrator Default arbitrator to use after timeout on solving arbitrations
     * @param _relayer EscrowRelay contract address
     * @param _arbitratorLicenses License contract instance address for arbitrators
     * @param _metadataStore MetadataStore contract address
     * @param _feeDestination Address where the fees are going to be sent
     * @param _feeMilliPercent Percentage applied as a fee to each escrow. 1000 == 1%
     */
    function init(
        address _fallbackArbitrator,
        address _relayer,
        address _arbitratorLicenses,
        address _metadataStore,
        address payable _feeDestination,
        uint _feeMilliPercent
    ) external {
        assert(_initialized == false);

        _initialized = true;

        fallbackArbitrator = _fallbackArbitrator;
        arbitratorLicenses = ArbitrationLicense(_arbitratorLicenses);
        metadataStore = MetadataStore(_metadataStore);
        relayer = _relayer;
        feeDestination = _feeDestination;
        feeMilliPercent = _feeMilliPercent;
        paused = false;
        _setOwner(msg.sender);
    }

    function updateCode(address newCode) public onlyOwner {
        updateCodeAddress(newCode);
    }

    /**
     * @dev Update relayer contract address. Can only be called by the contract owner
     * @param _relayer EscrowRelay contract address
     */
    function setRelayer(address _relayer) external onlyOwner {
        relayer = _relayer;
    }

    /**
     * @dev Update fallback arbitrator. Can only be called by the contract owner
     * @param _fallbackArbitrator New fallback arbitrator
     */
    function setFallbackArbitrator(address _fallbackArbitrator) external onlyOwner {
        fallbackArbitrator = _fallbackArbitrator;
    }

    /**
     * @dev Update license contract addresses
     * @param _arbitratorLicenses License contract instance address for arbitrators
     */
    function setArbitratorLicense(address _arbitratorLicenses) external onlyOwner {
        arbitratorLicenses = ArbitrationLicense(_arbitratorLicenses);
    }

    /**
     * @dev Update MetadataStore contract address
     * @param _metadataStore MetadataStore contract address
     */
    function setMetadataStore(address _metadataStore) external onlyOwner {
        metadataStore = MetadataStore(_metadataStore);
    }

    /**
     * @dev Escrow creation logic. Requires contract to be unpaused
     * @param _buyer Buyer Address
     * @param _offerId Offer
     * @param _tokenAmount Amount buyer is willing to trade
     * @param _fiatAmount Indicates how much FIAT will the user pay for the tokenAmount
     * @return Id of the Escrow
     */
    function _createTransaction(
        address payable _buyer,
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount
    ) internal whenNotPaused returns(uint escrowId)
    {
        address payable seller;
        address payable arbitrator;
        bool deleted;
        address token;

        (token, , , , , , seller, arbitrator, deleted) = metadataStore.offer(_offerId);

        require(!deleted, "Offer is not valid");
        require(seller != _buyer, "Seller and Buyer must be different");
        require(arbitrator != _buyer && arbitrator != address(0), "Cannot buy offers where buyer is arbitrator");
        require(_tokenAmount != 0 && _fiatAmount != 0, "Trade amounts cannot be 0");

        escrowId = transactions.length++;

        EscrowTransaction storage trx = transactions[escrowId];

        trx.offerId = _offerId;
        trx.token = token;
        trx.buyer = _buyer;
        trx.seller = seller;
        trx.arbitrator = arbitrator;
        trx.tokenAmount = _tokenAmount;
        trx.fiatAmount = _fiatAmount;

        emit Created(
            _offerId,
            seller,
            _buyer,
            escrowId
        );
    }

    /**
     * @notice Create a new escrow
     * @param _offerId Offer
     * @param _tokenAmount Amount buyer is willing to trade
     * @param _fiatAmount Indicates how much FIAT will the user pay for the tokenAmount
     * @param _contactData Contact Data   ContactType:UserId
     * @param _location The location on earth
     * @param _username The username of the user
     * @return Id of the new escrow
     * @dev Requires contract to be unpaused.
     */
    function createEscrow(
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        string memory _contactData,
        string memory _location,
        string memory _username
    ) public returns(uint escrowId) {
        metadataStore.addOrUpdateUser(msg.sender, _contactData, _location, _username);
        escrowId = _createTransaction(msg.sender, _offerId, _tokenAmount, _fiatAmount);
    }

    /**
     * @notice Create a new escrow
     * @param _offerId Offer
     * @param _tokenAmount Amount buyer is willing to trade
     * @param _fiatAmount Indicates how much FIAT will the user pay for the tokenAmount
     * @param _contactData Contact Data   ContactType:UserId
     * @param _username The username of the user
     * @param _nonce The nonce for the user (from MetadataStore.user_nonce(address))
     * @param _signature buyer's signature
     * @return Id of the new escrow
     * @dev Requires contract to be unpaused.
     *      The seller needs to be licensed.
     */
    function createEscrow(
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        string memory _contactData,
        string memory _location,
        string memory _username,
        uint _nonce,
        bytes memory _signature
    ) public returns(uint escrowId) {
        address payable _buyer = metadataStore.addOrUpdateUser(_signature, _contactData, _location, _username, _nonce);
        escrowId = _createTransaction(_buyer, _offerId, _tokenAmount, _fiatAmount);
    }

   /**
     * @dev Relay function for creating a transaction
     *      Can only be called by relayer address
     * @param _sender Address marking the transaction as paid
     * @param _offerId Offer
     * @param _tokenAmount Amount buyer is willing to trade
     * @param _fiatAmount Indicates how much FIAT will the user pay for the tokenAmount
     * @param _contactData Contact Data   ContactType:UserId
     * @param _location The location on earth
     * @param _username The username of the user
     * @return Id of the new escrow
     * @dev Requires contract to be unpaused.
     *      The seller needs to be licensed.
     */
    function createEscrow_relayed(
        address payable _sender,
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        string calldata _contactData,
        string calldata _location,
        string calldata _username
    ) external returns(uint escrowId) {
        assert(msg.sender == relayer);

        metadataStore.addOrUpdateUser(_sender, _contactData, _location, _username);
        escrowId = _createTransaction(_sender, _offerId, _tokenAmount, _fiatAmount);
    }

    /**
     * @notice Fund a new escrow
     * @param _escrowId Id of the escrow
     * @dev Requires contract to be unpaused.
     *      The expiration time must be at least 10min in the future
     *      For eth transfer, _amount must be equals to msg.value, for token transfer, requires an allowance and transfer valid for _amount
     */
    function fund(uint _escrowId) external payable whenNotPaused {	//injected LOCKED ETHER
        _fund(msg.sender, _escrowId);
    }

    /**
     * @dev Escrow funding logic
     * @param _from Seller address
     * @param _escrowId Id of the escrow
     * @dev Requires contract to be unpaused.
     *      The expiration time must be at least 10min in the future
     *      For eth transfer, _amount must be equals to msg.value, for token transfer, requires an allowance and transfer valid for _amount
     */
    function _fund(address _from, uint _escrowId) internal whenNotPaused {
        require(transactions[_escrowId].seller == _from, "Only the seller can invoke this function");
        require(transactions[_escrowId].status == EscrowStatus.CREATED, "Invalid escrow status");

        transactions[_escrowId].expirationTime = block.timestamp + 5 days;
        transactions[_escrowId].status = EscrowStatus.FUNDED;

        uint tokenAmount = transactions[_escrowId].tokenAmount;

        address token = transactions[_escrowId].token;

        _payFee(_from, _escrowId, tokenAmount, token);

        emit Funded(_escrowId, transactions[_escrowId].buyer, block.timestamp + 5 days, tokenAmount);
    }

    /**
     * @notice Create and fund a new escrow, as a seller, once you get a buyer signature
     * @param _offerId Offer
     * @param _tokenAmount Amount buyer is willing to trade
     * @param _fiatAmount Indicates how much FIAT will the user pay for the tokenAmount
     * @param _bContactData Contact Data   ContactType:UserId
     * @param _bLocation The location on earth
     * @param _bUsername The username of the user
     * @param _bNonce The nonce for the user (from MetadataStore.user_nonce(address))
     * @param _bSignature buyer's signature
     * @return Id of the new escrow
     * @dev Requires contract to be unpaused.
     *      Restrictions from escrow creation and funding applies
     */
    function createAndFund (	//injected LOCKED ETHER
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        string memory _bContactData,
        string memory _bLocation,
        string memory _bUsername,
        uint _bNonce,
        bytes memory _bSignature
    ) public payable returns(uint escrowId) {
        address payable _buyer = metadataStore.addOrUpdateUser(_bSignature, _bContactData, _bLocation, _bUsername, _bNonce);
        escrowId = _createTransaction(_buyer, _offerId, _tokenAmount, _fiatAmount);
        _fund(msg.sender, escrowId);
    }

    /**
     * @dev Buyer marks transaction as paid
     * @param _sender Address marking the transaction as paid
     * @param _escrowId Id of the escrow
     */
    function _pay(address _sender, uint _escrowId) internal {
        EscrowTransaction storage trx = transactions[_escrowId];

        require(trx.status == EscrowStatus.FUNDED, "Transaction is not funded");
        require(trx.expirationTime > block.timestamp, "Transaction already expired");
        require(trx.buyer == _sender, "Only the buyer can invoke this function");

        trx.status = EscrowStatus.PAID;

        emit Paid(_escrowId, trx.seller);
    }

    /**
     * @notice Mark transaction as paid
     * @param _escrowId Id of the escrow
     * @dev Can only be executed by the buyer
     */
    function pay(uint _escrowId) external {
        _pay(msg.sender, _escrowId);
    }

    /**
     * @dev Relay function for marking a transaction as paid
     *      Can only be called by relayer address
     * @param _sender Address marking the transaction as paid
     * @param _escrowId Id of the escrow
     */
    function pay_relayed(address _sender, uint _escrowId) external {
        assert(msg.sender == relayer);
        _pay(_sender, _escrowId);
    }

    /**
     * @notice Obtain message hash to be signed for marking a transaction as paid
     * @param _escrowId Id of the escrow
     * @return message hash
     * @dev Once message is signed, pass it as _signature of pay(uint256,bytes)
     */
    function paySignHash(uint _escrowId) public view returns(bytes32){
        return keccak256(
            abi.encodePacked(
                address(this),
                "pay(uint256)",
                _escrowId
            )
        );
    }

    /**
     * @notice Mark transaction as paid (via signed message)
     * @param _escrowId Id of the escrow
     * @param _signature Signature of the paySignHash result.
     * @dev There's a high probability of buyers not having ether to pay for the transaction.
     *      This allows anyone to relay the transaction.
     *      TODO: consider deducting funds later on release to pay the relayer (?)
     */
    function pay(uint _escrowId, bytes calldata _signature) external {
        address sender = _recoverAddress(_getSignHash(paySignHash(_escrowId)), _signature);
        _pay(sender, _escrowId);
    }

    /**
     * @dev Release funds to buyer
     * @param _escrowId Id of the escrow
     * @param _trx EscrowTransaction with data of transaction to be released
     * @param _isDispute indicates if the release happened due to a dispute
     */
    function _release(uint _escrowId, EscrowTransaction storage _trx, bool _isDispute) internal {
        require(_trx.status != EscrowStatus.RELEASED, "Already released");
        _trx.status = EscrowStatus.RELEASED;

        if(!_isDispute){
            metadataStore.refundStake(_trx.offerId);
        }

        address token = _trx.token;
        if(token == address(0)){
            (bool success, ) = _trx.buyer.call.value(0)("");
            require(success, "Transfer failed.");
        } else {
            require(_safeTransfer(ERC20Token(token), _trx.buyer, _trx.tokenAmount), "Couldn't transfer funds");
        }

        _releaseFee(_trx.arbitrator, _trx.tokenAmount, token, _isDispute);

        emit Released(_escrowId, _trx.seller, _trx.buyer, _isDispute);
    }

    /**
     * @notice Release escrow funds to buyer
     * @param _escrowId Id of the escrow
     * @dev Requires contract to be unpaused.
     *      Can only be executed by the seller
     *      Transaction must not be expired, or previously canceled or released
     */
    function release(uint _escrowId) external {
        EscrowStatus mStatus = transactions[_escrowId].status;
        require(transactions[_escrowId].seller == msg.sender, "Only the seller can invoke this function");
        require(mStatus == EscrowStatus.PAID || mStatus == EscrowStatus.FUNDED, "Invalid transaction status");
        require(!_isDisputed(_escrowId), "Can't release a transaction that has an arbitration process");
        _release(_escrowId, transactions[_escrowId], false);
    }

    /**
     * @dev Cancel an escrow operation
     * @param _escrowId Id of the escrow
     * @notice Requires contract to be unpaused.
     *         Can only be executed by the seller
     *         Transaction must be expired, or previously canceled or released
     */
    function cancel(uint _escrowId) external whenNotPaused {
        EscrowTransaction storage trx = transactions[_escrowId];

        EscrowStatus mStatus = trx.status;
        require(mStatus == EscrowStatus.FUNDED || mStatus == EscrowStatus.CREATED,
                "Only transactions in created or funded state can be canceled");

        require(trx.buyer == msg.sender || trx.seller == msg.sender, "Only participants can invoke this function");

        if(mStatus == EscrowStatus.FUNDED){
            if(msg.sender == trx.seller){
                require(trx.expirationTime < block.timestamp, "Can only be canceled after expiration");
            }
        }

        _cancel(_escrowId, trx, false);
    }

    // Same as cancel, but relayed by a contract so we get the sender as param
    function cancel_relayed(address _sender, uint _escrowId) external {
        assert(msg.sender == relayer);

        EscrowTransaction storage trx = transactions[_escrowId];
        EscrowStatus mStatus = trx.status;
        require(trx.buyer == _sender, "Only the buyer can invoke this function");
        require(mStatus == EscrowStatus.FUNDED || mStatus == EscrowStatus.CREATED,
                "Only transactions in created or funded state can be canceled");

         _cancel(_escrowId, trx, false);
    }

    /**
     * @dev Cancel transaction and send funds back to seller
     * @param _escrowId Id of the escrow
     * @param trx EscrowTransaction with details of transaction to be marked as canceled
     */
    function _cancel(uint _escrowId, EscrowTransaction storage trx, bool isDispute) internal {
        EscrowStatus origStatus = trx.status;

        require(trx.status != EscrowStatus.CANCELED, "Already canceled");

        trx.status = EscrowStatus.CANCELED;

        if (origStatus == EscrowStatus.FUNDED) {
            address token = trx.token;
            uint amount = trx.tokenAmount;
            if (!isDispute) {
                amount += _getValueOffMillipercent(trx.tokenAmount, feeMilliPercent);
            }

            if (token == address(0)) {
                (bool success, ) = trx.seller.call.value(0)("");
                require(success, "Transfer failed.");
            } else {
                ERC20Token erc20token = ERC20Token(token);
                require(_safeTransfer(erc20token, trx.seller, amount), "Transfer failed");
            }
        }

        trx.status = EscrowStatus.CANCELED;

        emit Canceled(_escrowId, trx.seller, trx.buyer, isDispute);
    }


    /**
     * @notice Rates a transaction
     * @param _escrowId Id of the escrow
     * @param _rate rating of the transaction from 1 to 5
     * @dev Can only be executed by the buyer
     *      Transaction must released
     */
    function _rateTransaction(address _sender, uint _escrowId, uint _rate) internal {
        require(_rate >= 1, "Rating needs to be at least 1");
        require(_rate <= 5, "Rating needs to be at less than or equal to 5");
        EscrowTransaction storage trx = transactions[_escrowId];
        require(trx.status == EscrowStatus.RELEASED || hadDispute(_escrowId), "Transaction not completed yet");

        if (trx.buyer == _sender) {
            require(trx.sellerRating == 0, "Transaction already rated");
            emit Rating(trx.offerId, trx.seller, _escrowId, _rate, true);
            trx.sellerRating = _rate;
        } else if (trx.seller == _sender) {
            require(trx.buyerRating == 0, "Transaction already rated");
            emit Rating(trx.offerId, trx.buyer, _escrowId, _rate, false);
            trx.buyerRating = _rate;
        } else {
            revert("Only participants can invoke this function");
        }
    }

    /**
     * @notice Rates a transaction
     * @param _escrowId Id of the escrow
     * @param _rate rating of the transaction from 1 to 5
     * @dev Can only be executed by the buyer
     *      Transaction must released
     */
    function rateTransaction(uint _escrowId, uint _rate) external {
        _rateTransaction(msg.sender, _escrowId, _rate);
    }

    // Same as rateTransaction, but relayed by a contract so we get the sender as param
    function rateTransaction_relayed(address _sender, uint _escrowId, uint _rate) external {
        assert(msg.sender == relayer);
        _rateTransaction(_sender, _escrowId, _rate);

    }

    /**
     * @notice Returns basic trade informations (buyer address, seller address, token address and token amount)
     * @param _escrowId Id of the escrow
     */
    function getBasicTradeData(uint _escrowId)
      external
      view
      returns(address payable buyer, address payable seller, address token, uint tokenAmount) {
        buyer = transactions[_escrowId].buyer;
        seller = transactions[_escrowId].seller;
        tokenAmount = transactions[_escrowId].tokenAmount;
        token = transactions[_escrowId].token;

        return (buyer, seller, token, tokenAmount);
    }

    /**
     * @notice Open case as a buyer or seller for arbitration
     * @param _escrowId Id of the escrow
     * @param _motive Motive for opening the dispute
     */
    function openCase(uint _escrowId, uint8 _motive) external {
        EscrowTransaction storage trx = transactions[_escrowId];

        require(!isDisputed(_escrowId), "Case already exist");
        require(trx.buyer == msg.sender || trx.seller == msg.sender, "Only participants can invoke this function");
        require(trx.status == EscrowStatus.PAID, "Cases can only be open for paid transactions");

        _openDispute(_escrowId, msg.sender, _motive);
    }

    /**
     * @dev Open case via relayer
     * @param _sender Address initiating the relayed transaction
     * @param _escrowId Id of the escrow
     * @param _motive Motive for opening the dispute
     */
    function openCase_relayed(address _sender, uint256 _escrowId, uint8 _motive) external {
        assert(msg.sender == relayer);

        EscrowTransaction storage trx = transactions[_escrowId];

        require(!isDisputed(_escrowId), "Case already exist");
        require(trx.buyer == _sender, "Only the buyer can invoke this function");
        require(trx.status == EscrowStatus.PAID, "Cases can only be open for paid transactions");

        _openDispute(_escrowId, _sender, _motive);
    }

    /**
     * @notice Open case as a buyer or seller for arbitration via a relay account
     * @param _escrowId Id of the escrow
     * @param _motive Motive for opening the dispute
     * @param _signature Signed message result of openCaseSignHash(uint256)
     * @dev Consider opening a dispute in aragon court.
     */
    function openCase(uint _escrowId, uint8 _motive, bytes calldata _signature) external {
        EscrowTransaction storage trx = transactions[_escrowId];

        require(!isDisputed(_escrowId), "Case already exist");
        require(trx.status == EscrowStatus.PAID, "Cases can only be open for paid transactions");

        address senderAddress = _recoverAddress(_getSignHash(openCaseSignHash(_escrowId, _motive)), _signature);

        require(trx.buyer == senderAddress || trx.seller == senderAddress, "Only participants can invoke this function");

        _openDispute(_escrowId, msg.sender, _motive);
    }

    /**
     * @notice Set arbitration result in favour of the buyer or seller and transfer funds accordingly
     * @param _escrowId Id of the escrow
     * @param _releaseFunds Release funds to buyer or cancel escrow
     * @param _arbitrator Arbitrator address
     */
    function _solveDispute(uint _escrowId, bool _releaseFunds, address _arbitrator) internal {
        EscrowTransaction storage trx = transactions[_escrowId];

        require(trx.buyer != _arbitrator && trx.seller != _arbitrator, "Arbitrator cannot be part of transaction");

        if (_releaseFunds) {
            _release(_escrowId, trx, true);
            metadataStore.slashStake(trx.offerId);
        } else {
            _cancel(_escrowId, trx, true);
            _releaseFee(trx.arbitrator, trx.tokenAmount, trx.token, true);
        }
    }

    /**
     * @notice Get arbitrator
     * @param _escrowId Id of the escrow
     * @return Arbitrator address
     */
    function _getArbitrator(uint _escrowId) internal view returns(address) {
        return transactions[_escrowId].arbitrator;
    }

    /**
     * @notice Obtain message hash to be signed for opening a case
     * @param _escrowId Id of the escrow
     * @return message hash
     * @dev Once message is signed, pass it as _signature of openCase(uint256,bytes)
     */
    function openCaseSignHash(uint _escrowId, uint8 _motive) public view returns(bytes32){
        return keccak256(
            abi.encodePacked(
                address(this),
                "openCase(uint256)",
                _escrowId,
                _motive
            )
        );
    }

    /**
     * @dev Support for "approveAndCall". Callable only by the fee token.
     * @param _from Who approved.
     * @param _amount Amount being approved, need to be equal `getPrice()`.
     * @param _token Token being approved, need to be equal `token()`.
     * @param _data Abi encoded data with selector of `register(bytes32,address,bytes32,bytes32)`.
     */
    function receiveApproval(address _from, uint256 _amount, address _token, bytes memory _data) public {
        require(_token == address(msg.sender), "Wrong call");
        require(_data.length == 36, "Wrong data length");

        bytes4 sig;
        uint256 escrowId;

        (sig, escrowId) = _abiDecodeFundCall(_data);

        if (sig == bytes4(0xca1d209d)){ // fund(uint256)
            uint tokenAmount = transactions[escrowId].tokenAmount;
            require(_amount == tokenAmount + _getValueOffMillipercent(tokenAmount, feeMilliPercent), "Invalid amount");
            _fund(_from, escrowId);
        } else {
            revert("Wrong method selector");
        }
    }

    /**
     * @dev Decodes abi encoded data with selector for "fund".
     * @param _data Abi encoded data.
     * @return Decoded registry call.
     */
    function _abiDecodeFundCall(bytes memory _data) internal pure returns (bytes4 sig, uint256 escrowId) {
        assembly {
            sig := mload(add(_data, add(0x20, 0)))
            escrowId := mload(add(_data, 36))
        }
    }

    /**
     * @dev Withdraws funds to the sellers in case of emergency
     *      Requires contract to be paused.
     *      Can be executed by anyone
     *      Transaction must not be canceled or released
     * @param _escrowId Id of the Escrow
     */
    function withdraw_emergency(uint _escrowId) external whenPaused {
        EscrowTransaction storage trx = transactions[_escrowId];
        require(trx.status == EscrowStatus.FUNDED, "Cannot withdraw from escrow in a stage different from FUNDED. Open a case");

        _cancel(_escrowId, trx, false);
    }
}