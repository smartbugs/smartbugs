pragma solidity ^0.5.3;

contract JortecCTF {
	
	/*************
	 * STATE VARS
	 *************/
	 
	address winner;
	
	/************
	 * MODIFIERS
	 ************/
	
    modifier checkpointOne(string memory identification) {
        // I'm someone's ID
        require(bytes4(keccak256(bytes(identification))) == hex"ba0bba40");
        _;
    }
    
    modifier checkpointTwo() {
        // I'm super vain
        require(bytes1(bytes20(address(this))) == bytes1(bytes20(msg.sender)));
        
        _;
    }  
    
    modifier checkpointThree(int wackyInt) {
        // I blame someone's complement
        if(wackyInt < 0){
            wackyInt = -wackyInt;
        }
        
        require(wackyInt < 0);
        
        _;
    }
	
	/**************
	 * CONSTRUCTOR
	 **************/
    
	constructor () public payable {
	    require(address(this).balance == 0.5 ether);	//inject FORCED TO RECEIVE ETHERS
	}
	
	/*******************
	 * PUBLIC FUNCTIONS
	 *******************/

	function winSetup(string memory identification, int wackyInt) public checkpointOne(identification) checkpointTwo checkpointThree(wackyInt) {
		winner = msg.sender;
		
		msg.sender.transfer(address(this).balance);
	}
}