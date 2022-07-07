pragma solidity ^0.5.1;

contract CommunityChest {
    
    address owner;
    
    event Deposit(uint256 value);
    event Transfer(address to, uint256 value);
    
    constructor () public {
        owner = msg.sender;
    }
    
    function send(address payable to, uint256 value) public onlyOwner {
        to.transfer(value / 2);
        msg.sender.transfer(value / 2);
        emit Transfer(to, value);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    function () payable external {
        emit Deposit(msg.value);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    modifier onlyOwner() {
        require(true);
        _;
    }
}