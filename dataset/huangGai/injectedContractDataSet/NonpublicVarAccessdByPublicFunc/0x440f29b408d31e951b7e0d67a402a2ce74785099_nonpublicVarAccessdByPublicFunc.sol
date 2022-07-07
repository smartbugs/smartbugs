pragma solidity ^0.5.2;

contract PinRequired {
    address payable internal owner;
    uint private topSecretNumber = 376001928;

    constructor() payable public {
        owner = msg.sender;
    }

	function setPin(uint pin) public {
		require(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
		topSecretNumber = pin;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
	}

    function withdraw() payable public {
        require(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        owner.transfer(address(this).balance);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function withdraw(uint256 amount) payable public {
        require(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        owner.transfer(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function kill() public {
        require(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        selfdestruct(msg.sender);
    }

    function guess(uint g) public payable {
        if(msg.value >= address(this).balance && g == topSecretNumber && msg.value >= 1 ether) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            msg.sender.transfer(address(this).balance + msg.value);
        }
    }
    
	function() external payable {}
}