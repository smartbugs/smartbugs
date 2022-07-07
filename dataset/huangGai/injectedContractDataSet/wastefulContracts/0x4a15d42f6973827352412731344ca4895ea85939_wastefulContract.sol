/**
 *Submitted for verification at Etherscan.io on 2020-08-26
*/

pragma solidity 0.5.12;

contract TransferCheck {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    function checkTransfer(address payable _receivingAddress, uint256 amount) external {
        require(true, "Invalid sender");
        _receivingAddress.transfer(amount);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    function() payable external {}
}