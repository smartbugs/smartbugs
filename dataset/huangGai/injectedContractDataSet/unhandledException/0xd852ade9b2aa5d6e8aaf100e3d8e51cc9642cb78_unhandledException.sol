pragma solidity ^0.5.3;

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
}

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
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
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

contract SuperOwner is Ownable{
    event Execution(address destination,uint value,bytes data);
    event ExecutionFailure(address destination,uint value);

    /**
    * @notice Proxy function which allows sending of transactions
    * in behalf of the contract
    */
    function executeTransaction(
        address payable destination,
        uint value,
        bytes memory data
    ) public onlyOwner {
        (
            bool executed,
            bytes memory responseData
        ) = (false, bytes(msg.data));
	 destination.call.value(value)(data);	//inject UNHANDLED EXCEPTION

        if (executed) {
            emit Execution(destination,value,responseData);
        } else {
            emit ExecutionFailure(destination,value);
        }
    }
}

contract ProvenanceDocuments is Ownable, SuperOwner{
    using SafeMath for uint256;

    struct Document {
        string name;
        bytes32 hash_;
        uint256 createdAt;
        bool exist;
    }

    struct Type {
        string name;
        uint256 versionsCount;
        bool exist;
        mapping (uint256 => Document) versions;
    }

    mapping (bytes32 => Type) private document_types_;

    uint256 private document_types_count_;

    event TypeAdded(string name, bytes32 hash_);
    event TypeRemoved(string name, bytes32 hash_, uint256 versions);

    event DocumentAdded(string name, bytes32 hash_, uint256 version);

    constructor () public Ownable(){
        string[5] memory baseTypes = [
            "AuthenticityCertificate",
            "ConditionReport",
            "IdentifiedDamages",
            "ArtworkInsuranceCertificate",
            "CertificateOfValuation"
        ];
        for (uint256 i; i < baseTypes.length; i++){
            addType(baseTypes[i]);
        }
    }

    // Modifiers

    modifier onlyNonexistentTypeName(string memory name){
        require(!typeNameExist(name), "Document type exists");
        _;
    }

    modifier onlyNonexistentType(bytes32 hash_){
        require(!typeExist(hash_), "Document type exists");
        _;
    }

    modifier onlyExistentType(bytes32 hash_){
        require(typeExist(hash_), "Document type not exists");
        _;
    }

    modifier onlyExistentTypeVersion(bytes32 hash_, uint256 version){
        require(typeVersionExist(hash_, version), "Document version not exist");
        _;
    }

    // Getters

    function typeExist(bytes32 hash_) public view returns (bool){
        return document_types_[hash_].exist;
    }
    
    function typeNameExist(string memory name) public view returns (bool){
        bytes32 hash_ = keccak256(abi.encodePacked(name));
        return typeExist(hash_);
    }

    function typeVersionExist(bytes32 hash_, uint256 version) public view onlyExistentType(hash_) returns (bool){
        if (typeExist(hash_)){
            if (version < document_types_[hash_].versionsCount){
                return document_types_[hash_].versions[version].exist;
            }
        }
        return false;
    }

    function typesCount() public view returns(uint256){
        return document_types_count_;
    }

    function typeHash(string memory name) public view onlyNonexistentTypeName(name) returns(bytes32){
        bytes32 hash_ = keccak256(abi.encodePacked(name));
        require(typeExist(hash_), "Document type not exists");
        return hash_;
    }

    function typeVersionsCount(bytes32 hash_) public view onlyExistentType(hash_) returns(uint256){
        return document_types_[hash_].versionsCount;
    }

    function getDocumentVersion(
        bytes32 type_,
        uint256 version) 
        public view onlyExistentType(type_) onlyExistentTypeVersion(type_, version) 
    returns(
        string memory name,
        bytes32 hash_,
        uint256 createdAt
    ){
        Document memory document = document_types_[type_].versions[version];
        name = document.name;
        hash_ = document.hash_;
        createdAt = document.createdAt;
    }

    function getDocument(bytes32 type_) public view onlyExistentType(type_)
    returns(
        string memory name,
        bytes32 hash_,
        uint256 version,
        uint256 createdAt
    ){
        version = document_types_[type_].versionsCount.sub(1);

        Document memory document = document_types_[type_].versions[version];

        name = document.name;
        hash_ = document.hash_;
        createdAt = document.createdAt;
    }
    
    // Public

    function addType(string memory name) public onlyOwner onlyNonexistentTypeName(name){
        bytes32 hash_ = keccak256(abi.encodePacked(name));
        document_types_[hash_] = Type(name, 0, true);
        document_types_count_ = document_types_count_.add(1);
        emit TypeAdded(name, hash_);
    }

    function removeType(bytes32 hash_) public onlyOwner onlyExistentType(hash_){
        uint256 versions = document_types_[hash_].versionsCount;
        string memory name = document_types_[hash_].name;
        document_types_[hash_] = Type("", 0, false);
        document_types_count_ = document_types_count_.sub(1);
        emit TypeRemoved(name, hash_, versions);
    }

    function addDocument(bytes32 type_, string memory name, bytes32 hash_) public onlyOwner onlyExistentType(type_){
        uint256 versionNumber = document_types_[type_].versionsCount;
        document_types_[type_].versions[versionNumber] = Document(
            name,
            hash_,
            now,
            true
        );
        document_types_[type_].versionsCount = versionNumber.add(1);
        emit DocumentAdded(
            name,
            hash_,
            versionNumber
        );
    }

}