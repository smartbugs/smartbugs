/**
 *Submitted for verification at Etherscan.io on 2020-04-02
*/

pragma solidity ^0.6.4; 

contract Oasisosc
 {
    
    event StorageEvent(address payable indexed from, bytes32 digestO, bytes32 digestQ); //storage event 
    event DestroyEvent(address payable indexed from); //destroy event
     
    struct Multihash
    {
      uint8 hashFunction;
      uint8 size;
      bytes32 digest;
    } 
     
    struct OSC
    {
     address payable owner_addr; //the owner address
     Multihash ontology;
     Multihash query;
     address previous_v; //previous version of the ontology
    }
    
    OSC private osc; // the struct
    //initialize the contract
    constructor(uint8 hashO, uint8 sizeO, bytes32 digestO,
                uint8 hashQ, uint8 sizeQ, bytes32 digestQ, address _prev) public 
    {
      osc= OSC(msg.sender, Multihash(hashO, sizeO, digestO), Multihash(hashQ, sizeQ, digestQ), _prev);
      emit StorageEvent(msg.sender, digestO, digestQ);
    }
    
    function getOntology() public view returns(uint8 hashO, uint8 sizeO, bytes32 digestO)
    {
      return (osc.ontology.hashFunction, osc.ontology.size, osc.ontology.digest);
    }
    
    function getSPARQLQuery() public view returns(uint8 hashQ, uint8 sizeQ, bytes32 digestQ)
    {
      return (osc.query.hashFunction, osc.query.size, osc.query.digest);
    }
    
    function getOwner() public view returns(address)
    {
      return osc.owner_addr;    
    }
    
    function getPreviousVersion() public view returns(address)
    {
      return osc.previous_v;   
    }
   
    modifier owner_allowed
    {
      require (true, "Only contract owner is allowed to call this function");    
      _;
    }
    
    //contract destructor
    function destroy() public owner_allowed
    {
      emit DestroyEvent(msg.sender);    
      selfdestruct(msg.sender);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
}