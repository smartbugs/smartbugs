pragma solidity ^0.5.8;

/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library IterableMap {
    
    struct IMap {
        mapping(address => uint256) mapToData;
        mapping(address => uint256) mapToIndex; // start with index 1
        address[] indexes;
    }
    
    function insert(IMap storage self, address _address, uint256 _value) internal returns (bool replaced) {
      
        require(_address != address(0));
        
        if(self.mapToIndex[_address] == 0){
            
            // add new
            self.indexes.push(_address);
            self.mapToIndex[_address] = self.indexes.length;
            self.mapToData[_address] = _value;
            return false;
        }
        
        // replace
        self.mapToData[_address] = _value;
        return true;
    }
    
    function remove(IMap storage self, address _address) internal returns (bool success) {
       
        require(_address != address(0));
        
        // not existing
        if(self.mapToIndex[_address] == 0){
            return false;   
        }
        
        uint256 deleteIndex = self.mapToIndex[_address];
        if(deleteIndex <= 0 || deleteIndex > self.indexes.length){
            return false;
        }
       
         // if index to be deleted is not the last index, swap position.
        if (deleteIndex < self.indexes.length) {
            // swap 
            self.indexes[deleteIndex-1] = self.indexes[self.indexes.length-1];
            self.mapToIndex[self.indexes[deleteIndex-1]] = deleteIndex;
        }
        self.indexes.length -= 1;
        delete self.mapToData[_address];
        delete self.mapToIndex[_address];
       
        return true;
    }
  
    function contains(IMap storage self, address _address) internal view returns (bool exists) {
        return self.mapToIndex[_address] > 0;
    }
      
    function size(IMap storage self) internal view returns (uint256) {
        return self.indexes.length;
    }
  
    function get(IMap storage self, address _address) internal view returns (uint256) {
        return self.mapToData[_address];
    }

    // start with index 0
    function getKey(IMap storage self, uint256 _index) internal view returns (address) {
        
        if(_index < self.indexes.length){
            return self.indexes[_index];
        }
        return address(0);
    }
}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
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
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

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
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract ZmineVoteKeep is Ownable {
  
    // Use itmap for all functions on the struct
    using IterableMap for IterableMap.IMap;
    using SafeMath for uint256;
    
    // ERC20 basic token contract being held
    IERC20 public token;
  
    // map address => vote
    IterableMap.IMap voteRecordMap;
    // map address => token available for reclaim
    IterableMap.IMap reclaimTokenMap;
    
    // time to start vote period
    uint256 public timestampStartVote;
    // time to end vote period
    uint256 public timestampEndVote;
    // time to enable reclaim token process
    uint256 public timestampReleaseToken;
    
    // cumulative count for total vote
    uint256 _totalVote;
    
    constructor(IERC20 _token) public {

        token = _token;
        
        // (Mainnet) May 22, 2019 GMT (epoch time 1558483200)
        // (Kovan) from now
        timestampStartVote = 1558483200; 
        
        // (Mainnet) May 28, 2019 GMT (epoch time 1559001600)
        // (Kovan) period for 10 years
        timestampEndVote = 1559001600; 
        
        // (Mainnet) May 30, 2019 GMT (epoch time 1559174400)
        // (Kovan) from now
        timestampReleaseToken = 1559174400; 
    }
    
    /**
     * modifier
     */
     
    // during the votable period?
    modifier onlyVotable() {
        require(isVotable());
        _;
    }
    
    // during the reclaimable period?
    modifier onlyReclaimable() {
        require(isReclaimable());
        _;
    }
  
    /**
     * public methods
     */
     
    function isVotable() public view returns (bool){
        return (timestampStartVote <= block.timestamp && block.timestamp <= timestampEndVote);
    }
    
    function isReclaimable() public view returns (bool){
        return (block.timestamp >= timestampReleaseToken);
    }
    
    function countVoteUser() public view returns (uint256){
        return voteRecordMap.size();
    }
    
    function countVoteScore() public view returns (uint256){
        return _totalVote;
    }
    
    function getVoteByAddress(address _address) public view returns (uint256){
        return voteRecordMap.get(_address);
    }
    
    // vote by transfer token into this contract as collateral
    // This process require approval from sender, to allow contract transfer token on the sender behalf.
    function voteKeep(uint256 amount) public onlyVotable {

        require(token.balanceOf(msg.sender) >= amount);
        
        // transfer token on the sender behalf.
        token.transferFrom(msg.sender, address(this), amount);
        
        // calculate cumulative vote
        uint256 newAmount = voteRecordMap.get(msg.sender).add(amount);
        
        // save to map
        reclaimTokenMap.insert(msg.sender, newAmount);
        voteRecordMap.insert(msg.sender, newAmount);
        
        // cumulative count total vote
        _totalVote = _totalVote.add(amount);
    }
    
    // Take the token back to the sender after reclaimable period has come.
    function reclaimToken() public onlyReclaimable {
      
        uint256 amount = reclaimTokenMap.get(msg.sender);
        require(amount > 0);
        require(token.balanceOf(address(this)) >= amount);
          
        // transfer token back to sender
        token.transfer(msg.sender, amount);
        
        // remove from map
        reclaimTokenMap.remove(msg.sender);
    }
    
    /**
     * admin methods
     */
     
    function adminCountReclaimableUser() public view onlyOwner returns (uint256){
        return reclaimTokenMap.size();
    }
    
    function adminCheckReclaimableAddress(uint256 index) public view onlyOwner returns (address){
        
        require(index >= 0); 
        
        if(reclaimTokenMap.size() > index){
            return reclaimTokenMap.getKey(index);
        }else{
            return address(0);
        }
    }
    
    function adminCheckReclaimableToken(uint256 index) public view onlyOwner returns (uint256){
    
        require(index >= 0); 
    
        if(reclaimTokenMap.size() > index){
            return reclaimTokenMap.get(reclaimTokenMap.getKey(index));
        }else{
            return 0;
        }
    }
    
    function adminCheckVoteAddress(uint256 index) public view onlyOwner returns (address){
        
        require(index >= 0); 
        
        if(voteRecordMap.size() > index){
            return voteRecordMap.getKey(index);
        }else{
            return address(0);
        }
    }
    
    function adminCheckVoteToken(uint256 index) public view onlyOwner returns (uint256){
    
        require(index >= 0); 
    
        if(voteRecordMap.size() > index){
            return voteRecordMap.get(voteRecordMap.getKey(index));
        }else{
            return 0;
        }
    }
    
    // perform reclaim token by admin 
    function adminReclaimToken(address _address) public onlyOwner {
      
        uint256 amount = reclaimTokenMap.get(_address);
        require(amount > 0);
        require(token.balanceOf(address(this)) >= amount);
          
        token.transfer(_address, amount);
        
        // remove from map
        reclaimTokenMap.remove(_address);
    }
    
    // Prevent deposit tokens by accident to a contract with the transfer function? 
    // The transaction will succeed but this will not be recognized by the contract.
    // After reclaim process was ended, admin will able to transfer the remain tokens to himself. 
    // And return the remain tokens to senders by manual process.
    function adminSweepMistakeTransferToken() public onlyOwner {
        
        require(reclaimTokenMap.size() == 0);
        require(token.balanceOf(address(this)) > 0);
        token.transfer(owner, token.balanceOf(address(this)));
    }
}