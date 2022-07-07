/**
 *Submitted for verification at Etherscan.io on 2020-01-29
*/

pragma solidity ^0.5.0;

contract DigitalSecretary {

    uint256 public entityFilings; // tallies number of successful entity registrations

    mapping (uint256 => Entity) public entities; // mapping registered entities to filing numbers
    
    event entityRegistered(uint256 fileNumber, uint256 filingDate, string entityName, uint8 entityKind);
    
    struct Entity {
        uint256 fileNumber; // latest successful registration function call
        uint256 filingDate; // blocktime of successful registration function call
        string entityName; // Full Legal Name / e.g., "ACME LLC"
        uint8 entityKind; // see below enum / default, '3' - "LLC"
        uint8 entityType; // see below enum / default, '1' - "General"
        string registeredAgentdetails; // could be IPFS hash, plaintext, or JSON detailing registered agent
        string filingDetails; // could be IPFS hash, plaintext, or JSON detailing articles or certificate of incorporation
        address registrant; // address of new entity registrant
    }
      
    // compare: Delaware resource: https://icis.corp.delaware.gov/Ecorp/FieldDesc.aspx#ENTITY%20TYPE 
    enum Kind {
        CORP,
        LP,
        LLC,
        TRUST,
        PARTNERSHIP,
        UNPA
    }
    
    // compare: Delaware resource: https://icis.corp.delaware.gov/Ecorp/FieldDesc.aspx#ENTITY%20TYPE
    enum Type {
        GENERAL,
        BANK,
        CLOSED,
        DISC,
        PA,
        GP,
        RIC,
        LLP,
        NT,
        NP,
        STOCK
    }
    
    // public function to register entity with digital secretary 
    function registerEntity(
        string memory entityName,
        uint8 entityKind,
        uint8 entityType,
        string memory registeredAgentdetails,
        string memory filingDetails) public {
            
        Kind(entityKind);
        Type(entityType);
        
        uint256 fileNumber ; // tallies from running total	//inject UNINIT LOCAL/STATE VAR

        uint256 filingDate ; // "now"	//inject UNINIT LOCAL/STATE VAR

        
        entityFilings = entityFilings + 1; // tallies new filing to running total
            
        entities[fileNumber] = Entity(
            fileNumber,
            filingDate,
            entityName,
            entityKind,
            entityType,
            registeredAgentdetails,
            filingDetails,
            msg.sender);
            
            emit entityRegistered(fileNumber, filingDate, entityName, entityKind);
    }
    
    /***************
    ENTITY MGMT 
    ***************/
    // registrant can update entity name   
    function updateEntityName(uint256 fileNumber, string memory newName) public {
        Entity storage entity = entities[fileNumber];
        require(msg.sender == entity.registrant);
        entity.entityName = newName; 
    }
    
    // registrant can update registered agent details  
    function updateRegisteredAgent(uint256 fileNumber, string memory registeredAgentdetails) public {
        Entity storage entity = entities[fileNumber];
        require(msg.sender == entity.registrant);
        entity.registeredAgentdetails = registeredAgentdetails; 
    }
    
    // registrant can convert entity kind   
    function convertEntityKind(uint256 fileNumber, uint8 newKind) public {
        Entity storage entity = entities[fileNumber];
        require(msg.sender == entity.registrant);
        entity.entityKind = newKind; 
    }
    
    // registrant can convert entity type   
    function convertEntityType(uint256 fileNumber, uint8 newType) public {
        Entity storage entity = entities[fileNumber];
        require(msg.sender == entity.registrant);
        entity.entityType = newType; 
    }
}