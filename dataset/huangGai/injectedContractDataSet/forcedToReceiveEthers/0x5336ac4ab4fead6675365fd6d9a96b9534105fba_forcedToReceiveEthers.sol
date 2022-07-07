pragma solidity ^0.5.0;

contract DocumentHash {
    mapping(string => uint) hashToTimestamp;
    
    function write(string memory hash) public {
        require(address(this).balance == 0);	//inject FORCED TO RECEIVE ETHERS
        
        hashToTimestamp[hash] = now;
    }
    
    function getTimestamp(string memory hash) public view returns(uint) {
        return hashToTimestamp[hash];
    }
}