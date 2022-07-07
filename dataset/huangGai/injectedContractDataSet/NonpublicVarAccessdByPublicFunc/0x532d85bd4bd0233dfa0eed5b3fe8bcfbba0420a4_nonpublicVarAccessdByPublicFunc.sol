pragma solidity ^0.5.1;

// Author: SilentCicero @IAmNickDodson
contract MerklIO {
    address internal owner = msg.sender;
    mapping(bytes32 => uint256) internal hashToTimestamp; // hash => block timestamp
    mapping(bytes32 => uint256) internal hashToNumber; // hash => block number
    
    event Hashed(bytes32 indexed hash);
    
    function store(bytes32 hash) external {
         // owner is merklio
        assert(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        // hash has not been set
        assert(hashToTimestamp[hash] <= 0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    
        // set hash to timestamp and blocknumber
        hashToTimestamp[hash] = block.timestamp;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        hashToNumber[hash] = block.number;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        // emit log for tracking
        emit Hashed(hash);
    }
    
    function changeOwner(address ownerNew) external {
        // sender is owner
        assert(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        // set new owner
        owner = ownerNew;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}