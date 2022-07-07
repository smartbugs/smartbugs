pragma solidity ^0.5.3;

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
        require(isOwner(), "Ownable: caller is not the owner");
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
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// good enough for a hackathon right?
contract BirdFeeder is Ownable {

   mapping (address => uint) public contributors;
   mapping (uint => bool) public paid;
   
   address[8] public top8;

   uint public lowest; // index of loest entry sometimes
   uint public lowestAmount; // amount of lowest top8 entry

   constructor() public{
   }
   
   // fallback
   function() external payable {	//injected LOCKED ETHER

      // bump the users contribution
      contributors[msg.sender] = contributors[msg.sender]+msg.value;
      bool insert = true;

      // pass #1
      for (uint i=0; i<8; i++) {
        
        // see if lowest needs updating
        if(contributors[top8[i]] <= lowestAmount) {
            
            lowestAmount = contributors[top8[i]];
            lowest = i;
        }    
        
        // if user is already in top 8, we're done
        if(top8[i]==msg.sender){
            insert=false;
        }
        
      }
      
      if(contributors[top8[lowest]] < contributors[msg.sender] && insert){
        top8[lowest] = msg.sender; // replace the lowest memeber with 
        lowestAmount = contributors[msg.sender];
      }
      // lets just say the most recent is the lowest now
      // we'll correct that assumption before doing anything with it.
   }
   
   // track users that get paid
   function dispense(address payable dst, uint sum, uint userid) external onlyOwner {
       require(paid[userid]==false);
       paid[userid]=true;
       dst.transfer(0);
   }
   
   function getBalance() public view returns (uint){
       return address(this).balance;
   }

}