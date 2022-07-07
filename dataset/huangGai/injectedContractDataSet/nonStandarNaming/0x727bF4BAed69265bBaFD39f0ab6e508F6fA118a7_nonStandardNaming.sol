                                                                 

pragma solidity ^0.5.7;


contract SafeTransfer {
    function _SAFETRANSFER911(ERC20Token _token, address _to, uint256 _value) internal returns (bool result) {	//inject NONSTANDARD NAMING
        _token.TRANSFER494(_to, _value);
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

    function _SAFETRANSFERFROM345(	//inject NONSTANDARD NAMING
        ERC20Token _token,
        address _from,
        address _to,
        uint256 _value
    ) internal returns (bool result)
    {
        _token.TRANSFERFROM513(_from, _to, _value);
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
                                                






// Abstract contract for the full ERC 20 Token standard
// https://github.com/ethereum/EIPs/issues/20


interface ERC20Token {

                                                                                                                                                                                                                                                 
    function TRANSFER494(address _to, uint256 _value) external returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                      
    function APPROVE813(address _spender, uint256 _value) external returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM513(address _from, address _to, uint256 _value) external returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                                    
    function BALANCEOF691(address _owner) external view returns (uint256 balance);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                      
    function ALLOWANCE536(address _owner, address _spender) external view returns (uint256 remaining);	//inject NONSTANDARD NAMING

                                                            
    function TOTALSUPPLY245() external view returns (uint256 supply);	//inject NONSTANDARD NAMING

    event TRANSFER151(address indexed _from, address indexed _to, uint256 _value);	//inject NONSTANDARD NAMING
    event APPROVAL845(address indexed _owner, address indexed _spender, uint256 _value);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                             
contract Ownable {
    address private _owner;

    event OWNERSHIPTRANSFERRED396(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                                                           
    constructor () internal {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED396(address(0), _owner);
    }

                                                                                             
    function OWNER296() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER677() {	//inject NONSTANDARD NAMING
        require(ISOWNER71(), "Only the contract's owner can invoke this function");
        _;
    }

                                                                                               
    function _SETOWNER235(address _newOwner) internal {	//inject NONSTANDARD NAMING
        _owner = _newOwner;
    }

                                                                                                                                  
    function ISOWNER71() public view returns (bool) {	//inject NONSTANDARD NAMING
        return msg.sender == _owner;
    }

                                                                                                                                                                                                                                                                                      
    function RENOUNCEOWNERSHIP275() external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED396(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                                                     
    function TRANSFEROWNERSHIP770(address _newOwner) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP486(_newOwner);
    }

                                                                                                                                          
    function _TRANSFEROWNERSHIP486(address _newOwner) internal {	//inject NONSTANDARD NAMING
        require(_newOwner != address(0), "New owner cannot be address(0)");
        emit OWNERSHIPTRANSFERRED396(_owner, _newOwner);
        _owner = _newOwner;
    }
}

contract ReentrancyGuard {
    
    bool public locked = false;

    modifier REENTRANCYGUARD399() {	//inject NONSTANDARD NAMING
        require(!locked, "Reentrant call detected!");
        locked = true;
        _;
        locked = false;
    }
}


contract Proxiable {
    // Code position in storage is keccak256("PROXIABLE") = "0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7"
    event UPGRADED572(address indexed implementation);	//inject NONSTANDARD NAMING

    function UPDATECODEADDRESS579(address newAddress) internal {	//inject NONSTANDARD NAMING
        require(
            bytes32(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7) == Proxiable(newAddress).PROXIABLEUUID20(),
            "Not compatible"
        );
        assembly { // solium-disable-line
            sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, newAddress)
        }
        emit UPGRADED572(newAddress);
    }
    function PROXIABLEUUID20() public pure returns (bytes32) {	//inject NONSTANDARD NAMING
        return 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;
    }

    bool internal _initialized;

    function ISINITIALIZED692() public view returns(bool) {	//inject NONSTANDARD NAMING
        return _initialized;
    }
}



contract SecuredFunctions is Ownable {

    mapping(address => bool) public allowedContracts;

                                                                                     
    modifier ONLYALLOWEDCONTRACTS234 {	//inject NONSTANDARD NAMING
        require(allowedContracts[msg.sender] || msg.sender == address(this), "Only allowed contracts can invoke this function");
        _;
    }

                                                                                                                                                                                            
    function SETALLOWEDCONTRACT466 (	//inject NONSTANDARD NAMING
        address _contract,
        bool _allowed
    ) public ONLYOWNER677 {
        allowedContracts[_contract] = _allowed;
    }
}
                                    
                                                



                                             
contract MessageSigned {

    constructor() internal {}

                                                                                                                                                                                                
    function _RECOVERADDRESS15(bytes32 _signHash, bytes memory _messageSignature)	//inject NONSTANDARD NAMING
        internal
        pure
        returns(address)
    {
        uint8 v;
        bytes32 r;
        bytes32 s;
        (v,r,s) = SIGNATURESPLIT549(_messageSignature);
        return ecrecover(_signHash, v, r, s);
    }

                                                                                                                                                     
    function _GETSIGNHASH525(bytes32 _hash) internal pure returns (bytes32 signHash) {	//inject NONSTANDARD NAMING
        signHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
    }

                                                                                                                                  
    function SIGNATURESPLIT549(bytes memory _signature)	//inject NONSTANDARD NAMING
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
    function RECEIVEAPPROVAL139(address from, uint256 _amount, address _token, bytes memory _data) public;	//inject NONSTANDARD NAMING
}
                                              
                                                








                                                            
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

    event BOUGHT91(address buyer, uint256 price);	//inject NONSTANDARD NAMING
    event PRICECHANGED925(uint256 _price);	//inject NONSTANDARD NAMING
    event BURNADDRESSCHANGED16(address sender, address prevBurnAddress, address newBurnAddress);	//inject NONSTANDARD NAMING

                                                                                                
    function SETBURNADDRESS147(address payable _burnAddress) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        emit BURNADDRESSCHANGED16(msg.sender, burnAddress, _burnAddress);
        burnAddress = _burnAddress;
    }

                                                                                                                                                                                                                   
    constructor(address _tokenAddress, uint256 _price, address _burnAddress) public {
        INIT444(_tokenAddress, _price, _burnAddress);
    }

                                                                                                                                                                                                                                                                                              
    function INIT444(	//inject NONSTANDARD NAMING
        address _tokenAddress,
        uint256 _price,
        address _burnAddress
    ) public {
        assert(_initialized == false);

        _initialized = true;

        price = _price;
        token = ERC20Token(_tokenAddress);
        burnAddress = _burnAddress;

        _SETOWNER235(msg.sender);
    }

    function UPDATECODE511(address newCode) public ONLYOWNER677 {	//inject NONSTANDARD NAMING
        UPDATECODEADDRESS579(newCode);
    }

                                                                                                                                          
    function ISLICENSEOWNER342(address _address) public view returns (bool) {	//inject NONSTANDARD NAMING
        return licenseDetails[_address].price != 0 && licenseDetails[_address].creationTime != 0;
    }

                                                                                                                                                                           
    function BUY699() external returns(uint) {	//inject NONSTANDARD NAMING
        uint id = _BUYFROM536(msg.sender);
        return id;
    }

                                                                                                                                                                       
    function _BUYFROM536(address _licenseOwner) internal returns(uint) {	//inject NONSTANDARD NAMING
        require(licenseDetails[_licenseOwner].creationTime == 0, "License already bought");

        licenseDetails[_licenseOwner] = LicenseDetails({
            price: price,
            creationTime: block.timestamp
        });

        uint idx = licenseOwners.push(_licenseOwner);
        idxLicenseOwners[_licenseOwner] = idx;

        emit BOUGHT91(_licenseOwner, price);

        require(_SAFETRANSFERFROM345(token, _licenseOwner, burnAddress, price), "Unsuccessful token transfer");

        return idx;
    }

                                                                                                                                                                        
    function SETPRICE121(uint256 _price) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        price = _price;
        emit PRICECHANGED925(_price);
    }

                                                                            
    function GETNUMLICENSEOWNERS215() external view returns (uint256) {	//inject NONSTANDARD NAMING
        return licenseOwners.length;
    }

                                                                                                                                                                                                                                                                                                                                            
    function RECEIVEAPPROVAL139(address _from, uint256 _amount, address _token, bytes memory _data) public {	//inject NONSTANDARD NAMING
        require(_amount == price, "Wrong value");
        require(_token == address(token), "Wrong token");
        require(_token == address(msg.sender), "Wrong call");
        require(_data.length == 4, "Wrong data length");

        require(_ABIDECODEBUY25(_data) == bytes4(0xa6f2ae3a), "Wrong method selector"); //bytes4(keccak256("buy()"))

        _BUYFROM536(_from);
    }

                                                                                                                                                           
    function _ABIDECODEBUY25(bytes memory _data) internal pure returns(bytes4 sig) {	//inject NONSTANDARD NAMING
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
      address payable destination;
      EscrowStatus status;
  }

  function CREATEESCROW_RELAYED829(	//inject NONSTANDARD NAMING
        address payable _sender,
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        address payable _destination,
        string calldata _contactData,
        string calldata _location,
        string calldata _username
    ) external returns(uint escrowId);

  function PAY204(uint _escrowId) external;	//inject NONSTANDARD NAMING

  function PAY_RELAYED312(address _sender, uint _escrowId) external;	//inject NONSTANDARD NAMING

  function CANCEL601(uint _escrowId) external;	//inject NONSTANDARD NAMING

  function CANCEL_RELAYED801(address _sender, uint _escrowId) external;	//inject NONSTANDARD NAMING

  function OPENCASE508(uint  _escrowId, uint8 _motive) external;	//inject NONSTANDARD NAMING

  function OPENCASE_RELAYED502(address _sender, uint256 _escrowId, uint8 _motive) external;	//inject NONSTANDARD NAMING

  function RATETRANSACTION74(uint _escrowId, uint _rate) external;	//inject NONSTANDARD NAMING

  function RATETRANSACTION_RELAYED289(address _sender, uint _escrowId, uint _rate) external;	//inject NONSTANDARD NAMING

  function GETBASICTRADEDATA166(uint _escrowId) external view returns(address payable buyer, address payable seller, address token, uint tokenAmount);	//inject NONSTANDARD NAMING

}







                                                                                 
contract Pausable is Ownable {

    event PAUSED628();	//inject NONSTANDARD NAMING
    event UNPAUSED643();	//inject NONSTANDARD NAMING

    bool public paused;

    constructor () internal {
        paused = false;
    }

    modifier WHENNOTPAUSED504() {	//inject NONSTANDARD NAMING
        require(!paused, "Contract must be unpaused");
        _;
    }

    modifier WHENPAUSED494() {	//inject NONSTANDARD NAMING
        require(paused, "Contract must be paused");
        _;
    }

                                                                                                                                                                                                                 
    function PAUSE819() external ONLYOWNER677 WHENNOTPAUSED504 {	//inject NONSTANDARD NAMING
        paused = true;
        emit PAUSED628();
    }

                                                                                                                                                                                                                 
    function UNPAUSE973() external ONLYOWNER677 WHENPAUSED494 {	//inject NONSTANDARD NAMING
        paused = false;
        emit UNPAUSED643();
    }
}



                                              




                                                                                         
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

    event ARBITRATORREQUESTED586(bytes32 id, address indexed seller, address indexed arbitrator);	//inject NONSTANDARD NAMING

    event REQUESTACCEPTED10(bytes32 id, address indexed arbitrator, address indexed seller);	//inject NONSTANDARD NAMING
    event REQUESTREJECTED172(bytes32 id, address indexed arbitrator, address indexed seller);	//inject NONSTANDARD NAMING
    event REQUESTCANCELED901(bytes32 id, address indexed arbitrator, address indexed seller);	//inject NONSTANDARD NAMING
    event BLACKLISTSELLER899(address indexed arbitrator, address indexed seller);	//inject NONSTANDARD NAMING
    event UNBLACKLISTSELLER540(address indexed arbitrator, address indexed seller);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                       
    constructor(address _tokenAddress, uint256 _price, address _burnAddress)
      License(_tokenAddress, _price, _burnAddress)
      public {}

                                                        
    function BUY699() external returns(uint) {	//inject NONSTANDARD NAMING
        return _BUY66(msg.sender, false);
    }

                                                                                                                                                                                           
    function BUY699(bool _acceptAny) external returns(uint) {	//inject NONSTANDARD NAMING
        return _BUY66(msg.sender, _acceptAny);
    }

                                                                                                                                                                                                                                                                                                               
    function _BUY66(address _sender, bool _acceptAny) internal returns (uint id) {	//inject NONSTANDARD NAMING
        id = _BUYFROM536(_sender);
        arbitratorlicenseDetails[_sender].id = id;
        arbitratorlicenseDetails[_sender].acceptAny = _acceptAny;
    }

                                                                                                                                                                     
    function CHANGEACCEPTANY798(bool _acceptAny) public {	//inject NONSTANDARD NAMING
        require(ISLICENSEOWNER342(msg.sender), "Message sender should have a valid arbitrator license");
        require(arbitratorlicenseDetails[msg.sender].acceptAny != _acceptAny,
                "Message sender should pass parameter different from the current one");

        arbitratorlicenseDetails[msg.sender].acceptAny = _acceptAny;
    }

                                                                                                                              
    function REQUESTARBITRATOR791(address _arbitrator) public {	//inject NONSTANDARD NAMING
       require(ISLICENSEOWNER342(_arbitrator), "Arbitrator should have a valid license");
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

       emit ARBITRATORREQUESTED586(_id, msg.sender, _arbitrator);
    }

                                                                                                                                                       
    function GETID524(address _arbitrator, address _account) external pure returns(bytes32){	//inject NONSTANDARD NAMING
        return keccak256(abi.encodePacked(_arbitrator,_account));
    }

                                                                                                          
    function ACCEPTREQUEST19(bytes32 _id) public {	//inject NONSTANDARD NAMING
        require(ISLICENSEOWNER342(msg.sender), "Arbitrator should have a valid license");
        require(requests[_id].status == RequestStatus.AWAIT, "This request is not pending");
        require(!arbitratorlicenseDetails[msg.sender].acceptAny, "Arbitrator already accepts all cases");
        require(requests[_id].arbitrator == msg.sender, "Invalid arbitrator");

        requests[_id].status = RequestStatus.ACCEPTED;

        address _seller = requests[_id].seller;
        permissions[msg.sender][_seller] = true;

        emit REQUESTACCEPTED10(_id, msg.sender, requests[_id].seller);
    }

                                                                                                 
    function REJECTREQUEST397(bytes32 _id) public {	//inject NONSTANDARD NAMING
        require(ISLICENSEOWNER342(msg.sender), "Arbitrator should have a valid license");
        require(requests[_id].status == RequestStatus.AWAIT || requests[_id].status == RequestStatus.ACCEPTED,
            "Invalid request status");
        require(!arbitratorlicenseDetails[msg.sender].acceptAny, "Arbitrator accepts all cases");
        require(requests[_id].arbitrator == msg.sender, "Invalid arbitrator");

        requests[_id].status = RequestStatus.REJECTED;
        requests[_id].date = block.timestamp;

        address _seller = requests[_id].seller;
        permissions[msg.sender][_seller] = false;

        emit REQUESTREJECTED172(_id, msg.sender, requests[_id].seller);
    }

                                                                                             
    function CANCELREQUEST262(bytes32 _id) public {	//inject NONSTANDARD NAMING
        require(requests[_id].seller == msg.sender,  "This request id does not belong to the message sender");
        require(requests[_id].status == RequestStatus.AWAIT || requests[_id].status == RequestStatus.ACCEPTED, "Invalid request status");

        address arbitrator = requests[_id].arbitrator;

        requests[_id].status = RequestStatus.CLOSED;
        requests[_id].date = block.timestamp;

        address _arbitrator = requests[_id].arbitrator;
        permissions[_arbitrator][msg.sender] = false;

        emit REQUESTCANCELED901(_id, arbitrator, requests[_id].seller);
    }

                                                                                                           
    function BLACKLISTSELLER470(address _seller) public {	//inject NONSTANDARD NAMING
        require(ISLICENSEOWNER342(msg.sender), "Arbitrator should have a valid license");

        blacklist[msg.sender][_seller] = true;

        emit BLACKLISTSELLER899(msg.sender, _seller);
    }

                                                                                                                           
    function UNBLACKLISTSELLER351(address _seller) public {	//inject NONSTANDARD NAMING
        require(ISLICENSEOWNER342(msg.sender), "Arbitrator should have a valid license");

        blacklist[msg.sender][_seller] = false;

        emit UNBLACKLISTSELLER540(msg.sender, _seller);
    }

                                                                                                                                                                          
    function ISALLOWED574(address _seller, address _arbitrator) public view returns(bool) {	//inject NONSTANDARD NAMING
        return (arbitratorlicenseDetails[_arbitrator].acceptAny && !blacklist[_arbitrator][_seller]) || permissions[_arbitrator][_seller];
    }

                                                                                                                                                                                                                                                                                                                                            
    function RECEIVEAPPROVAL139(address _from, uint256 _amount, address _token, bytes memory _data) public {	//inject NONSTANDARD NAMING
        require(_amount == price, "Wrong value");
        require(_token == address(token), "Wrong token");
        require(_token == address(msg.sender), "Wrong call");
        require(_data.length == 4, "Wrong data length");

        require(_ABIDECODEBUY25(_data) == bytes4(0xa6f2ae3a), "Wrong method selector"); //bytes4(keccak256("buy()"))

        _BUY66(_from, false);
    }
}











                                               
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

                                                                                                                                                         
    constructor(address _sellingLicenses, address _arbitrationLicenses) public
    {
        INIT444(_sellingLicenses, _arbitrationLicenses);
    }

                                                                                                                                                                                                                                    
    function INIT444(	//inject NONSTANDARD NAMING
        address _sellingLicenses,
        address _arbitrationLicenses
    ) public {
        assert(_initialized == false);

        _initialized = true;

        sellingLicenses = License(_sellingLicenses);
        arbitrationLicenses = ArbitrationLicense(_arbitrationLicenses);

        _SETOWNER235(msg.sender);
    }

    function UPDATECODE511(address newCode) public ONLYOWNER677 {	//inject NONSTANDARD NAMING
        UPDATECODEADDRESS579(newCode);
    }

    event LICENSESCHANGED569(address sender, address oldSellingLicenses, address newSellingLicenses, address oldArbitrationLicenses, address newArbitrationLicenses);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                    
    function SETLICENSES678(	//inject NONSTANDARD NAMING
        address _sellingLicenses,
        address _arbitrationLicenses
    ) public ONLYOWNER677 {
        emit LICENSESCHANGED569(msg.sender, address(sellingLicenses), address(_sellingLicenses), address(arbitrationLicenses), (_arbitrationLicenses));

        sellingLicenses = License(_sellingLicenses);
        arbitrationLicenses = ArbitrationLicense(_arbitrationLicenses);
    }

                                                                                                                                                                                                                                              
    function _DATAHASH273(string memory _username, string memory _contactData, uint _nonce) internal view returns (bytes32) {	//inject NONSTANDARD NAMING
        return keccak256(abi.encodePacked(address(this), _username, _contactData, _nonce));
    }

                                                                                                                                                                                     
    function GETDATAHASH823(string calldata _username, string calldata _contactData) external view returns (bytes32) {	//inject NONSTANDARD NAMING
        return _DATAHASH273(_username, _contactData, user_nonce[msg.sender]);
    }

                                                                                                                                                                                                                                                                                                                                                                             
    function _GETSIGNER107(	//inject NONSTANDARD NAMING
        string memory _username,
        string memory _contactData,
        uint _nonce,
        bytes memory _signature
    ) internal view returns(address) {
        bytes32 signHash = _GETSIGNHASH525(_DATAHASH273(_username, _contactData, _nonce));
        return _RECOVERADDRESS15(signHash, _signature);
    }

                                                                                                                                                                                                                                                                                                                  
    function GETMESSAGESIGNER993(	//inject NONSTANDARD NAMING
        string calldata _username,
        string calldata _contactData,
        uint _nonce,
        bytes calldata _signature
    ) external view returns(address) {
        return _GETSIGNER107(_username, _contactData, _nonce, _signature);
    }

                                                                                                                                                                                                                                                     
    function _ADDORUPDATEUSER76(	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                  
    function ADDORUPDATEUSER850(	//inject NONSTANDARD NAMING
        bytes calldata _signature,
        string calldata _contactData,
        string calldata _location,
        string calldata _username,
        uint _nonce
    ) external returns(address payable _user) {
        _user = address(uint160(_GETSIGNER107(_username, _contactData, _nonce, _signature)));

        require(_nonce == user_nonce[_user], "Invalid nonce");

        user_nonce[_user]++;
        _ADDORUPDATEUSER76(_user, _contactData, _location, _username);

        return _user;
    }

                                                                                                                                                                                                                                                 
    function ADDORUPDATEUSER850(	//inject NONSTANDARD NAMING
        string calldata _contactData,
        string calldata _location,
        string calldata _username
    ) external {
        _ADDORUPDATEUSER76(msg.sender, _contactData, _location, _username);
    }

                                                                                                                                                                                                                                                                                                                                                             
    function ADDORUPDATEUSER850(	//inject NONSTANDARD NAMING
        address _sender,
        string calldata _contactData,
        string calldata _location,
        string calldata _username
    ) external ONLYALLOWEDCONTRACTS234 {
        _ADDORUPDATEUSER76(_sender, _contactData, _location, _username);
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

    event BURNADDRESSCHANGED16(address sender, address prevBurnAddress, address newBurnAddress);	//inject NONSTANDARD NAMING
    event BASEPRICECHANGED745(address sender, uint prevPrice, uint newPrice);	//inject NONSTANDARD NAMING

    event STAKED319(uint indexed itemId, address indexed owner, uint amount);	//inject NONSTANDARD NAMING
    event UNSTAKED65(uint indexed itemId, address indexed owner, uint amount);	//inject NONSTANDARD NAMING
    event SLASHED89(uint indexed itemId, address indexed owner, address indexed slasher, uint amount);	//inject NONSTANDARD NAMING

    constructor(address payable _burnAddress) public {
        burnAddress = _burnAddress;
    }

                                                                                                
    function SETBURNADDRESS147(address payable _burnAddress) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        emit BURNADDRESSCHANGED16(msg.sender, burnAddress, _burnAddress);
        burnAddress = _burnAddress;
    }

                                                                                            
    function SETBASEPRICE977(uint _basePrice) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        emit BASEPRICECHANGED745(msg.sender, basePrice, _basePrice);
        basePrice = _basePrice;
    }

    function _STAKE330(uint _itemId, address payable _owner, address _tokenAddress) internal {	//inject NONSTANDARD NAMING
        require(stakes[_itemId].owner == address(0), "Already has/had a stake");

        stakeCounter[_owner]++;

        uint stakeAmount = basePrice * stakeCounter[_owner] * stakeCounter[_owner]; // y = basePrice * x^2

        // Using only ETH as stake for phase 0
        _tokenAddress = address(0);
        require(msg.value == stakeAmount, "ETH amount is required");

        // Uncomment to support tokens
                                                                                                                                                                                                                                                                                                                                                                                                                                                      

        stakes[_itemId].amount = stakeAmount;
        stakes[_itemId].owner = _owner;
        stakes[_itemId].token = _tokenAddress;

        emit STAKED319(_itemId,  _owner, stakeAmount);
    }

    function GETAMOUNTTOSTAKE537(address _owner) public view returns(uint){	//inject NONSTANDARD NAMING
        uint stakeCnt = stakeCounter[_owner] + 1;
        return basePrice * stakeCnt * stakeCnt; // y = basePrice * x^2
    }

    function _UNSTAKE786(uint _itemId) internal {	//inject NONSTANDARD NAMING
        Stake storage s = stakes[_itemId];

        if (s.amount == 0) return; // No stake for item

        uint amount = s.amount;
        s.amount = 0;

        assert(stakeCounter[s.owner] > 0);
        stakeCounter[s.owner]--;

        if (s.token == address(0)) {
            (bool success, ) = s.owner.call.value(amount)("");
            require(success, "Transfer failed.");
        } else {
            require(_SAFETRANSFER911(ERC20Token(s.token), s.owner, amount), "Couldn't transfer funds");
        }

        emit UNSTAKED65(_itemId, s.owner, amount);
    }

    function _SLASH319(uint _itemId) internal {	//inject NONSTANDARD NAMING
        Stake storage s = stakes[_itemId];

        // TODO: what happens if offer was previosly validated and the user removed the stake?
        if (s.amount == 0) return;

        uint amount = s.amount;
        s.amount = 0;

        if (s.token == address(0)) {
            (bool success, ) = burnAddress.call.value(amount)("");
            require(success, "Transfer failed.");
        } else {
            require(_SAFETRANSFER911(ERC20Token(s.token), burnAddress, amount), "Couldn't transfer funds");
        }

        emit SLASHED89(_itemId, s.owner, msg.sender, amount);
    }

    function _REFUNDSTAKE66(uint _itemId) internal {	//inject NONSTANDARD NAMING
        Stake storage s = stakes[_itemId];

        if (s.amount == 0) return;

        uint amount = s.amount;
        s.amount = 0;

        stakeCounter[s.owner]--;

        if (amount != 0) {
            if (s.token == address(0)) {
                (bool success, ) = s.owner.call.value(amount)("");
                require(success, "Transfer failed.");
            } else {
                require(_SAFETRANSFER911(ERC20Token(s.token), s.owner, amount), "Couldn't transfer funds");
            }
        }
    }

}



                                                 
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

    event OFFERADDED246(	//inject NONSTANDARD NAMING
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

    event OFFERREMOVED496(address owner, uint256 offerId);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                             
    constructor(address _userStore, address _sellingLicenses, address _arbitrationLicenses, address payable _burnAddress) public
        Stakable(_burnAddress)
    {
        INIT444(_userStore, _sellingLicenses, _arbitrationLicenses, _burnAddress);
    }

                                                                                                                                                                                                                                                                                                                                                        
    function INIT444(	//inject NONSTANDARD NAMING
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

        _SETOWNER235(msg.sender);
    }

    function UPDATECODE511(address newCode) public ONLYOWNER677 {	//inject NONSTANDARD NAMING
        UPDATECODEADDRESS579(newCode);
    }

    event LICENSESCHANGED569(address sender, address oldSellingLicenses, address newSellingLicenses, address oldArbitrationLicenses, address newArbitrationLicenses);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                    
    function SETLICENSES678(	//inject NONSTANDARD NAMING
        address _sellingLicenses,
        address _arbitrationLicenses
    ) public ONLYOWNER677 {
        emit LICENSESCHANGED569(msg.sender, address(sellingLicenses), address(_sellingLicenses), address(arbitrationLicenses), (_arbitrationLicenses));

        sellingLicenses = License(_sellingLicenses);
        arbitrationLicenses = ArbitrationLicense(_arbitrationLicenses);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function ADDOFFER296(	//inject NONSTANDARD NAMING
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

        require(arbitrationLicenses.ISALLOWED574(msg.sender, _arbitrator), "Arbitrator does not allow this transaction");

        require(_limitL <= _limitU, "Invalid limits");
        require(msg.sender != _arbitrator, "Cannot arbitrate own offers");

        userStore.ADDORUPDATEUSER850(
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

        emit OFFERADDED246(
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

        _STAKE330(offerId, msg.sender, _asset);
    }

                                                                                                                                                                           
    function REMOVEOFFER618(uint256 _offerId) external {	//inject NONSTANDARD NAMING
        require(offerWhitelist[msg.sender][_offerId], "Offer does not exist");

        offers[_offerId].deleted = true;
        offerWhitelist[msg.sender][_offerId] = false;
        emit OFFERREMOVED496(msg.sender, _offerId);

        _UNSTAKE786(_offerId);
    }

                                                                                                                                                                                                                         
    function OFFER296(uint256 _id) external view returns (	//inject NONSTANDARD NAMING
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
        if(!arbitrationLicenses.ISALLOWED574(theOffer.owner, offerArbitrator)){
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

                                                                                                                                               
    function GETOFFEROWNER81(uint256 _id) external view returns (address payable) {	//inject NONSTANDARD NAMING
        return (offers[_id].owner);
    }

                                                                                                                                                                
    function GETASSET816(uint256 _id) external view returns (address) {	//inject NONSTANDARD NAMING
        return (offers[_id].asset);
    }

                                                                                                                                                        
    function GETARBITRATOR107(uint256 _id) external view returns (address payable) {	//inject NONSTANDARD NAMING
        return (offers[_id].arbitrator);
    }

                                                                                                                
    function OFFERSSIZE507() external view returns (uint256) {	//inject NONSTANDARD NAMING
        return offers.length;
    }

                                                                                                                                                                                   
    function GETOFFERIDS508(address _address) external view returns (uint256[] memory) {	//inject NONSTANDARD NAMING
        return addressToOffers[_address];
    }

                                                                                                                                                     
    function SLASHSTAKE918(uint _offerId) external ONLYALLOWEDCONTRACTS234 {	//inject NONSTANDARD NAMING
        _SLASH319(_offerId);
    }

                                                                                                                                             
    function REFUNDSTAKE487(uint _offerId) external ONLYALLOWEDCONTRACTS234 {	//inject NONSTANDARD NAMING
        _REFUNDSTAKE66(_offerId);
    }
}








                                                                                     
contract Fees is Ownable, ReentrancyGuard, SafeTransfer {
    address payable public feeDestination;
    uint public feeMilliPercent;
    mapping(address => uint) public feeTokenBalances;
    mapping(uint => bool) public feePaid;

    event FEEDESTINATIONCHANGED311(address payable);	//inject NONSTANDARD NAMING
    event FEEMILLIPERCENTCHANGED580(uint amount);	//inject NONSTANDARD NAMING
    event FEESWITHDRAWN828(uint amount, address token);	//inject NONSTANDARD NAMING

                                                                                                                                                                          
    constructor(address payable _feeDestination, uint _feeMilliPercent) public {
        feeDestination = _feeDestination;
        feeMilliPercent = _feeMilliPercent;
    }

                                                                                                                                                    
    function SETFEEDESTINATIONADDRESS891(address payable _addr) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        feeDestination = _addr;
        emit FEEDESTINATIONCHANGED311(_addr);
    }

                                                                                                                                                 
    function SETFEEAMOUNT608(uint _feeMilliPercent) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        feeMilliPercent = _feeMilliPercent;
        emit FEEMILLIPERCENTCHANGED580(_feeMilliPercent);
    }

                                                                                                                                                                                                                                                                                                  
    function _RELEASEFEE319(address payable _arbitrator, uint _value, address _tokenAddress, bool _isDispute) internal REENTRANCYGUARD399 {	//inject NONSTANDARD NAMING
        uint _milliPercentToArbitrator;
        if (_isDispute) {
            _milliPercentToArbitrator = 100000; // 100%
        } else {
            _milliPercentToArbitrator = 10000; // 10%
        }

        uint feeAmount = _GETVALUEOFFMILLIPERCENT932(_value, feeMilliPercent);
        uint arbitratorValue = _GETVALUEOFFMILLIPERCENT932(feeAmount, _milliPercentToArbitrator);
        uint destinationValue = feeAmount - arbitratorValue;

        if (_tokenAddress != address(0)) {
            ERC20Token tokenToPay = ERC20Token(_tokenAddress);
            require(_SAFETRANSFER911(tokenToPay, _arbitrator, arbitratorValue), "Unsuccessful token transfer - arbitrator");
            if (destinationValue > 0) {
                require(_SAFETRANSFER911(tokenToPay, feeDestination, destinationValue), "Unsuccessful token transfer - destination");
            }
        } else {
            // EIP1884 fix
            (bool success, ) = _arbitrator.call.value(arbitratorValue)("");
            require(success, "Transfer failed.");

            if (destinationValue > 0) {
                // EIP1884 fix
                (bool success, ) = feeDestination.call.value(destinationValue)("");
                require(success, "Transfer failed.");

            }
        }
    }

                                                                                                                                                                                                                         
    function _GETVALUEOFFMILLIPERCENT932(uint _value, uint _milliPercent) internal pure returns(uint) {	//inject NONSTANDARD NAMING
        // To get the factor, we divide like 100 like a normal percent, but we multiply that by 1000 because it's a milliPercent
        // Eg: 1 % = 1000 millipercent => Factor is 0.01, so 1000 divided by 100 * 1000
        return (_value * _milliPercent) / (100 * 1000);
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function _PAYFEE642(address _from, uint _id, uint _value, address _tokenAddress) internal {	//inject NONSTANDARD NAMING
        if (feePaid[_id]) return;

        feePaid[_id] = true;
        uint feeAmount = _GETVALUEOFFMILLIPERCENT932(_value, feeMilliPercent);
        feeTokenBalances[_tokenAddress] += feeAmount;

        if (_tokenAddress != address(0)) {
            require(msg.value == 0, "Cannot send ETH with token address different from 0");

            ERC20Token tokenToPay = ERC20Token(_tokenAddress);
            require(_SAFETRANSFERFROM345(tokenToPay, _from, address(this), feeAmount + _value), "Unsuccessful token transfer");
        } else {
            require(msg.value == (_value + feeAmount), "ETH amount is required");
        }
    }
}

                                              




                                                              
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

    event ARBITRATORCHANGED687(address arbitrator);	//inject NONSTANDARD NAMING
    event ARBITRATIONCANCELED782(uint escrowId);	//inject NONSTANDARD NAMING
    event ARBITRATIONREQUIRED867(uint escrowId, uint timeout);	//inject NONSTANDARD NAMING
    event ARBITRATIONRESOLVED296(uint escrowId, ArbitrationResult result, address arbitrator);	//inject NONSTANDARD NAMING

                                                                                             
    constructor(address _arbitratorLicenses, address _fallbackArbitrator) public {
        arbitratorLicenses = ArbitrationLicense(_arbitratorLicenses);
        fallbackArbitrator = _fallbackArbitrator;
    }

                                                                                                                                                                                                                                                                                                   
    function _SOLVEDISPUTE500(uint _escrowId, bool _releaseFunds, address _arbitrator) internal;	//inject NONSTANDARD NAMING

                                                                                                    
    function _GETARBITRATOR209(uint _escrowId) internal view returns(address);	//inject NONSTANDARD NAMING

                                                                                                                                                      
    function ISDISPUTED635(uint _escrowId) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _ISDISPUTED184(_escrowId);
    }

    function _ISDISPUTED184(uint _escrowId) internal view returns (bool) {	//inject NONSTANDARD NAMING
        return arbitrationCases[_escrowId].open || arbitrationCases[_escrowId].result != ArbitrationResult.UNSOLVED;
    }

                                                                                                                                               
    function HADDISPUTE385(uint _escrowId) public view returns (bool) {	//inject NONSTANDARD NAMING
        return arbitrationCases[_escrowId].result != ArbitrationResult.UNSOLVED;
    }

                                                                                          
    function CANCELARBITRATION839(uint _escrowId) external {	//inject NONSTANDARD NAMING
        require(arbitrationCases[_escrowId].openBy == msg.sender, "Arbitration can only be canceled by the opener");
        require(arbitrationCases[_escrowId].result == ArbitrationResult.UNSOLVED && arbitrationCases[_escrowId].open,
                "Arbitration already solved or not open");

        delete arbitrationCases[_escrowId];

        emit ARBITRATIONCANCELED782(_escrowId);
    }

                                                                                                                                                                                                                                                                              
    function _OPENDISPUTE139(uint _escrowId, address _openBy, uint8 _motive) internal {	//inject NONSTANDARD NAMING
        require(arbitrationCases[_escrowId].result == ArbitrationResult.UNSOLVED && !arbitrationCases[_escrowId].open,
                "Arbitration already solved or has been opened before");

        address arbitratorAddress = _GETARBITRATOR209(_escrowId);

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

        emit ARBITRATIONREQUIRED867(_escrowId, timeout);
    }

                                                                                                                                                                                                              
    function SETARBITRATIONRESULT710(uint _escrowId, ArbitrationResult _result) external {	//inject NONSTANDARD NAMING
        require(arbitrationCases[_escrowId].open && arbitrationCases[_escrowId].result == ArbitrationResult.UNSOLVED,
                "Case must be open and unsolved");
        require(_result != ArbitrationResult.UNSOLVED, "Arbitration does not have result");
        require(arbitratorLicenses.ISLICENSEOWNER342(msg.sender), "Only arbitrators can invoke this function");

        if (block.timestamp > arbitrationCases[_escrowId].arbitratorTimeout) {
            require(arbitrationCases[_escrowId].arbitrator == msg.sender || msg.sender == fallbackArbitrator, "Invalid escrow arbitrator");
        } else {
            require(arbitrationCases[_escrowId].arbitrator == msg.sender, "Invalid escrow arbitrator");
        }

        arbitrationCases[_escrowId].open = false;
        arbitrationCases[_escrowId].result = _result;

        emit ARBITRATIONRESOLVED296(_escrowId, _result, msg.sender);

        if(_result == ArbitrationResult.BUYER){
            _SOLVEDISPUTE500(_escrowId, true, msg.sender);
        } else {
            _SOLVEDISPUTE500(_escrowId, false, msg.sender);
        }
    }
}




                                                                                 
contract Escrow is IEscrow, Pausable, MessageSigned, Fees, Arbitrable, Proxiable {

    EscrowTransaction[] public transactions;

    address public relayer;
    OfferStore public offerStore;
    UserStore public userStore;


    event CREATED284(uint indexed offerId, address indexed seller, address indexed buyer, uint escrowId);	//inject NONSTANDARD NAMING
    event FUNDED669(uint indexed escrowId, address indexed buyer, uint expirationTime, uint amount);	//inject NONSTANDARD NAMING
    event PAID949(uint indexed escrowId, address indexed seller);	//inject NONSTANDARD NAMING
    event RELEASED780(uint indexed escrowId, address indexed seller, address indexed buyer, address destination, bool isDispute);	//inject NONSTANDARD NAMING
    event CANCELED731(uint indexed escrowId, address indexed seller, address indexed buyer, bool isDispute);	//inject NONSTANDARD NAMING
    
    event RATING242(uint indexed offerId, address indexed participant, uint indexed escrowId, uint rating, bool ratingSeller);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    constructor(
        address _relayer,
        address _fallbackArbitrator,
        address _arbitratorLicenses,
        address _offerStore,
        address _userStore,
        address payable _feeDestination,
        uint _feeMilliPercent)
        Fees(_feeDestination, _feeMilliPercent)
        Arbitrable(_arbitratorLicenses, _fallbackArbitrator)
        public {
        _initialized = true;
        relayer = _relayer;
        offerStore = OfferStore(_offerStore);
        userStore = UserStore(_userStore);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function INIT444(	//inject NONSTANDARD NAMING
        address _fallbackArbitrator,
        address _relayer,
        address _arbitratorLicenses,
        address _offerStore,
        address _userStore,
        address payable _feeDestination,
        uint _feeMilliPercent
    ) external {
        assert(_initialized == false);

        _initialized = true;

        fallbackArbitrator = _fallbackArbitrator;
        arbitratorLicenses = ArbitrationLicense(_arbitratorLicenses);
        offerStore = OfferStore(_offerStore);
        userStore = UserStore(_userStore);
        relayer = _relayer;
        feeDestination = _feeDestination;
        feeMilliPercent = _feeMilliPercent;
        paused = false;
        _SETOWNER235(msg.sender);
    }

    function UPDATECODE511(address newCode) public ONLYOWNER677 {	//inject NONSTANDARD NAMING
        UPDATECODEADDRESS579(newCode);
    }

                                                                                                                                                         
    function SETRELAYER20(address _relayer) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        relayer = _relayer;
    }

                                                                                                                                                          
    function SETFALLBACKARBITRATOR834(address _fallbackArbitrator) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        fallbackArbitrator = _fallbackArbitrator;
    }

                                                                                                                                                 
    function SETARBITRATORLICENSE102(address _arbitratorLicenses) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        arbitratorLicenses = ArbitrationLicense(_arbitratorLicenses);
    }

                                                                                                                                                                             
    function SETMETADATASTORE408(address _offerStore, address _userStore) external ONLYOWNER677 {	//inject NONSTANDARD NAMING
        offerStore = OfferStore(_offerStore);
        userStore = UserStore(_userStore);
    }

                                                                                                                                                                                                                                                                                                                                                                                                       
    function _CREATETRANSACTION768(	//inject NONSTANDARD NAMING
        address payable _buyer,
        address payable _destination,
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount
    ) internal WHENNOTPAUSED504 returns(uint escrowId)
    {
        address payable seller;
        address payable arbitrator;
        bool deleted;
        address token;

        (token, , , , , , seller, arbitrator, deleted) = offerStore.OFFER296(_offerId);

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
        trx.destination = _destination;
        trx.arbitrator = arbitrator;
        trx.tokenAmount = _tokenAmount;
        trx.fiatAmount = _fiatAmount;

        emit CREATED284(
            _offerId,
            seller,
            _buyer,
            escrowId
        );
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function CREATEESCROW324(	//inject NONSTANDARD NAMING
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        address payable _destination,
        string memory _contactData,
        string memory _location,
        string memory _username
    ) public returns(uint escrowId) {
        userStore.ADDORUPDATEUSER850(msg.sender, _contactData, _location, _username);
        escrowId = _CREATETRANSACTION768(msg.sender, _destination, _offerId, _tokenAmount, _fiatAmount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function CREATEESCROW324(	//inject NONSTANDARD NAMING
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        address payable _destination,
        string memory _contactData,
        string memory _location,
        string memory _username,
        uint _nonce,
        bytes memory _signature
    ) public returns(uint escrowId) {
        address payable _buyer = userStore.ADDORUPDATEUSER850(_signature, _contactData, _location, _username, _nonce);
        escrowId = _CREATETRANSACTION768(_buyer, _destination, _offerId, _tokenAmount, _fiatAmount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function CREATEESCROW_RELAYED829(	//inject NONSTANDARD NAMING
        address payable _sender,
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        address payable _destination,
        string calldata _contactData,
        string calldata _location,
        string calldata _username
    ) external returns(uint escrowId) {
        assert(msg.sender == relayer);

        userStore.ADDORUPDATEUSER850(_sender, _contactData, _location, _username);
        escrowId = _CREATETRANSACTION768(_sender, _destination,  _offerId, _tokenAmount, _fiatAmount);
    }

                                                                                                                                                                                                                                                                                                                                                        
    function FUND899(uint _escrowId) external payable WHENNOTPAUSED504 {	//inject NONSTANDARD NAMING
        _FUND192(msg.sender, _escrowId);
    }

                                                                                                                                                                                                                                                                                                                                                                                           
    function _FUND192(address _from, uint _escrowId) internal WHENNOTPAUSED504 {	//inject NONSTANDARD NAMING
        require(transactions[_escrowId].seller == _from, "Only the seller can invoke this function");
        require(transactions[_escrowId].status == EscrowStatus.CREATED, "Invalid escrow status");

        transactions[_escrowId].expirationTime = block.timestamp + 5 days;
        transactions[_escrowId].status = EscrowStatus.FUNDED;

        uint tokenAmount = transactions[_escrowId].tokenAmount;

        address token = transactions[_escrowId].token;

        _PAYFEE642(_from, _escrowId, tokenAmount, token);

        emit FUNDED669(_escrowId, transactions[_escrowId].buyer, block.timestamp + 5 days, tokenAmount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    function CREATEANDFUND840 (	//inject NONSTANDARD NAMING
        uint _offerId,
        uint _tokenAmount,
        uint _fiatAmount,
        string memory _bContactData,
        string memory _bLocation,
        string memory _bUsername,
        uint _bNonce,
        bytes memory _bSignature
    ) public payable returns(uint escrowId) {
        address payable _buyer = userStore.ADDORUPDATEUSER850(_bSignature, _bContactData, _bLocation, _bUsername, _bNonce);
        escrowId = _CREATETRANSACTION768(_buyer, _buyer, _offerId, _tokenAmount, _fiatAmount);
        _FUND192(msg.sender, escrowId);
    }

                                                                                                                                                                  
    function _PAY687(address _sender, uint _escrowId) internal {	//inject NONSTANDARD NAMING
        EscrowTransaction storage trx = transactions[_escrowId];

        require(trx.status == EscrowStatus.FUNDED, "Transaction is not funded");
        require(trx.expirationTime > block.timestamp, "Transaction already expired");
        require(trx.buyer == _sender, "Only the buyer can invoke this function");

        trx.status = EscrowStatus.PAID;

        emit PAID949(_escrowId, trx.seller);
    }

                                                                                                                                              
    function PAY204(uint _escrowId) external {	//inject NONSTANDARD NAMING
        _PAY687(msg.sender, _escrowId);
    }

                                                                                                                                                                                                                                     
    function PAY_RELAYED312(address _sender, uint _escrowId) external {	//inject NONSTANDARD NAMING
        assert(msg.sender == relayer);
        _PAY687(_sender, _escrowId);
    }

                                                                                                                                                                                                                                                      
    function PAYSIGNHASH991(uint _escrowId) public view returns(bytes32){	//inject NONSTANDARD NAMING
        return keccak256(
            abi.encodePacked(
                address(this),
                "pay(uint256)",
                _escrowId
            )
        );
    }

                                                                                                                                                                                                                                                                                                                                                                                                                             
    function PAY204(uint _escrowId, bytes calldata _signature) external {	//inject NONSTANDARD NAMING
        address sender = _RECOVERADDRESS15(_GETSIGNHASH525(PAYSIGNHASH991(_escrowId)), _signature);
        _PAY687(sender, _escrowId);
    }

                                                                                                                                                                                                                                                    
    function _RELEASE35(uint _escrowId, EscrowTransaction storage _trx, bool _isDispute) internal {	//inject NONSTANDARD NAMING
        require(_trx.status != EscrowStatus.RELEASED, "Already released");
        _trx.status = EscrowStatus.RELEASED;

        if(!_isDispute){
            offerStore.REFUNDSTAKE487(_trx.offerId);
        }

        address token = _trx.token;
        if(token == address(0)){
            (bool success, ) = _trx.destination.call.value(_trx.tokenAmount)("");
            require(success, "Transfer failed.");
        } else {
            require(_SAFETRANSFER911(ERC20Token(token), _trx.buyer, _trx.tokenAmount), "Couldn't transfer funds");
        }

        _RELEASEFEE319(_trx.arbitrator, _trx.tokenAmount, token, _isDispute);

        emit RELEASED780(_escrowId, _trx.seller, _trx.buyer, _trx.destination, _isDispute);
    }

                                                                                                                                                                                                                                                                                  
    function RELEASE349(uint _escrowId) external {	//inject NONSTANDARD NAMING
        EscrowStatus mStatus = transactions[_escrowId].status;
        require(transactions[_escrowId].seller == msg.sender, "Only the seller can invoke this function");
        require(mStatus == EscrowStatus.PAID || mStatus == EscrowStatus.FUNDED, "Invalid transaction status");
        require(!_ISDISPUTED184(_escrowId), "Can't release a transaction that has an arbitration process");
        _RELEASE35(_escrowId, transactions[_escrowId], false);
    }

                                                                                                                                                                                                                                                                                 
    function CANCEL601(uint _escrowId) external WHENNOTPAUSED504 {	//inject NONSTANDARD NAMING
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

        _CANCEL322(_escrowId, trx, false);
    }

    // Same as cancel, but relayed by a contract so we get the sender as param
    function CANCEL_RELAYED801(address _sender, uint _escrowId) external {	//inject NONSTANDARD NAMING
        assert(msg.sender == relayer);

        EscrowTransaction storage trx = transactions[_escrowId];
        EscrowStatus mStatus = trx.status;
        require(trx.buyer == _sender, "Only the buyer can invoke this function");
        require(mStatus == EscrowStatus.FUNDED || mStatus == EscrowStatus.CREATED,
                "Only transactions in created or funded state can be canceled");

         _CANCEL322(_escrowId, trx, false);
    }

                                                                                                                                                                                                              
    function _CANCEL322(uint _escrowId, EscrowTransaction storage trx, bool isDispute) internal {	//inject NONSTANDARD NAMING
        EscrowStatus origStatus = trx.status;

        require(trx.status != EscrowStatus.CANCELED, "Already canceled");

        trx.status = EscrowStatus.CANCELED;

        if (origStatus == EscrowStatus.FUNDED) {
            address token = trx.token;
            uint amount = trx.tokenAmount;
            if (!isDispute) {
                amount += _GETVALUEOFFMILLIPERCENT932(trx.tokenAmount, feeMilliPercent);
            }

            if (token == address(0)) {
                (bool success, ) = trx.seller.call.value(amount)("");
                require(success, "Transfer failed.");
            } else {
                ERC20Token erc20token = ERC20Token(token);
                require(_SAFETRANSFER911(erc20token, trx.seller, amount), "Transfer failed");
            }
        }

        trx.status = EscrowStatus.CANCELED;

        emit CANCELED731(_escrowId, trx.seller, trx.buyer, isDispute);
    }


                                                                                                                                                                                                                                         
    function _RATETRANSACTION102(address _sender, uint _escrowId, uint _rate) internal {	//inject NONSTANDARD NAMING
        require(_rate >= 1, "Rating needs to be at least 1");
        require(_rate <= 5, "Rating needs to be at less than or equal to 5");
        EscrowTransaction storage trx = transactions[_escrowId];
        require(trx.status == EscrowStatus.RELEASED || HADDISPUTE385(_escrowId), "Transaction not completed yet");

        if (trx.buyer == _sender) {
            require(trx.sellerRating == 0, "Transaction already rated");
            emit RATING242(trx.offerId, trx.seller, _escrowId, _rate, true);
            trx.sellerRating = _rate;
        } else if (trx.seller == _sender) {
            require(trx.buyerRating == 0, "Transaction already rated");
            emit RATING242(trx.offerId, trx.buyer, _escrowId, _rate, false);
            trx.buyerRating = _rate;
        } else {
            revert("Only participants can invoke this function");
        }
    }

                                                                                                                                                                                                                                         
    function RATETRANSACTION74(uint _escrowId, uint _rate) external {	//inject NONSTANDARD NAMING
        _RATETRANSACTION102(msg.sender, _escrowId, _rate);
    }

    // Same as rateTransaction, but relayed by a contract so we get the sender as param
    function RATETRANSACTION_RELAYED289(address _sender, uint _escrowId, uint _rate) external {	//inject NONSTANDARD NAMING
        assert(msg.sender == relayer);
        _RATETRANSACTION102(_sender, _escrowId, _rate);

    }

                                                                                                                                                                        
    function GETBASICTRADEDATA166(uint _escrowId)	//inject NONSTANDARD NAMING
      external
      view
      returns(address payable buyer, address payable seller, address token, uint tokenAmount) {
        buyer = transactions[_escrowId].buyer;
        seller = transactions[_escrowId].seller;
        tokenAmount = transactions[_escrowId].tokenAmount;
        token = transactions[_escrowId].token;

        return (buyer, seller, token, tokenAmount);
    }

                                                                                                                                                                           
    function OPENCASE508(uint _escrowId, uint8 _motive) external {	//inject NONSTANDARD NAMING
        EscrowTransaction storage trx = transactions[_escrowId];

        require(!ISDISPUTED635(_escrowId), "Case already exist");
        require(trx.buyer == msg.sender || trx.seller == msg.sender, "Only participants can invoke this function");
        require(trx.status == EscrowStatus.PAID, "Cases can only be open for paid transactions");

        _OPENDISPUTE139(_escrowId, msg.sender, _motive);
    }

                                                                                                                                                                                                                
    function OPENCASE_RELAYED502(address _sender, uint256 _escrowId, uint8 _motive) external {	//inject NONSTANDARD NAMING
        assert(msg.sender == relayer);

        EscrowTransaction storage trx = transactions[_escrowId];

        require(!ISDISPUTED635(_escrowId), "Case already exist");
        require(trx.buyer == _sender, "Only the buyer can invoke this function");
        require(trx.status == EscrowStatus.PAID, "Cases can only be open for paid transactions");

        _OPENDISPUTE139(_escrowId, _sender, _motive);
    }

                                                                                                                                                                                                                                                                                                                                   
    function OPENCASE508(uint _escrowId, uint8 _motive, bytes calldata _signature) external {	//inject NONSTANDARD NAMING
        EscrowTransaction storage trx = transactions[_escrowId];

        require(!ISDISPUTED635(_escrowId), "Case already exist");
        require(trx.status == EscrowStatus.PAID, "Cases can only be open for paid transactions");

        address senderAddress = _RECOVERADDRESS15(_GETSIGNHASH525(OPENCASESIGNHASH754(_escrowId, _motive)), _signature);

        require(trx.buyer == senderAddress || trx.seller == senderAddress, "Only participants can invoke this function");

        _OPENDISPUTE139(_escrowId, msg.sender, _motive);
    }

                                                                                                                                                                                                                                                                               
    function _SOLVEDISPUTE500(uint _escrowId, bool _releaseFunds, address _arbitrator) internal {	//inject NONSTANDARD NAMING
        EscrowTransaction storage trx = transactions[_escrowId];

        require(trx.buyer != _arbitrator && trx.seller != _arbitrator, "Arbitrator cannot be part of transaction");

        if (_releaseFunds) {
            _RELEASE35(_escrowId, trx, true);
            offerStore.SLASHSTAKE918(trx.offerId);
        } else {
            _CANCEL322(_escrowId, trx, true);
            _RELEASEFEE319(trx.arbitrator, trx.tokenAmount, trx.token, true);
        }
    }

                                                                                                                        
    function _GETARBITRATOR209(uint _escrowId) internal view returns(address) {	//inject NONSTANDARD NAMING
        return transactions[_escrowId].arbitrator;
    }

                                                                                                                                                                                                                                            
    function OPENCASESIGNHASH754(uint _escrowId, uint8 _motive) public view returns(bytes32){	//inject NONSTANDARD NAMING
        return keccak256(
            abi.encodePacked(
                address(this),
                "openCase(uint256)",
                _escrowId,
                _motive
            )
        );
    }

                                                                                                                                                                                                                                                                                                                                                                                 
    function RECEIVEAPPROVAL139(address _from, uint256 _amount, address _token, bytes memory _data) public {	//inject NONSTANDARD NAMING
        require(_token == address(msg.sender), "Wrong call");
        require(_data.length == 36, "Wrong data length");

        bytes4 sig;
        uint256 escrowId;

        (sig, escrowId) = _ABIDECODEFUNDCALL446(_data);

        if (sig == bytes4(0xca1d209d)){ // fund(uint256)
            uint tokenAmount = transactions[escrowId].tokenAmount;
            require(_amount == tokenAmount + _GETVALUEOFFMILLIPERCENT932(tokenAmount, feeMilliPercent), "Invalid amount");
            _FUND192(_from, escrowId);
        } else {
            revert("Wrong method selector");
        }
    }

                                                                                                                                                          
    function _ABIDECODEFUNDCALL446(bytes memory _data) internal pure returns (bytes4 sig, uint256 escrowId) {	//inject NONSTANDARD NAMING
        assembly {
            sig := mload(add(_data, add(0x20, 0)))
            escrowId := mload(add(_data, 36))
        }
    }

                                                                                                                                                                                                                                                                   
    function WITHDRAW_EMERGENCY162(uint _escrowId) external WHENPAUSED494 {	//inject NONSTANDARD NAMING
        EscrowTransaction storage trx = transactions[_escrowId];
        require(trx.status == EscrowStatus.FUNDED, "Cannot withdraw from escrow in a stage different from FUNDED. Open a case");

        _CANCEL322(_escrowId, trx, false);
    }
}