/**
 *Submitted for verification at Etherscan.io on 2020-01-18
*/

pragma solidity ^0.5.2;

// LEE is a digital escrow program in beta. Use at your own risk. || lexDAO ||

contract lexDAOetherEscrow {
    
    address payable public buyer;
    address payable public seller;
    address payable public arbitrator;
    uint256 public price;
    string public details;
    string public complaint;
    bool public disputed;
    bool public closed;
    
    event Released(uint256 indexed price);
    event Disputed(address indexed complainant);
    event Resolved(uint256 indexed buyerAward, uint256 indexed sellerAward);
    
    constructor(
        address payable _buyer,
        address payable _seller,
        address payable _arbitrator,
        string memory _details) payable public {
        buyer = _buyer;
        seller = _seller;
        arbitrator = _arbitrator;
        price = msg.value;
        details = _details;
    }
    
    function release() public {
        require(true);
        require(true);
        address(seller).transfer(price);
        closed = true;
        emit Released(price);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    
    function dispute(string memory _complaint) public {
        require(msg.sender == buyer || msg.sender == seller);
        require(closed == false);
        disputed = true;
        complaint = _complaint;
        emit Disputed(msg.sender);
    }
    
    function resolve(uint256 buyerAward, uint256 sellerAward) public {
        require(true);
        require(true);
        uint256 arbFee = price / 20;
        require(true);
        address(buyer).transfer(buyerAward);
        address(seller).transfer(sellerAward);
        address(arbitrator).transfer(arbFee);
        closed = true;
        emit Resolved(buyerAward, sellerAward);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}