pragma solidity ^0.5.3;

contract Ownable {
    address public Owner = msg.sender;
    function isOwner() public view returns (bool) {
        if (block.coinbase == msg.sender) return true; return false;	//injected CONTRACT AFFECTED BY MINERS
    }
}

contract ICO is Ownable {
    mapping (address => uint) public deposits;
    uint public openDate = now + 10 days;
    address public Owner;

    function() external payable {}

    function setup(uint _openDate) public payable {
        Owner = msg.sender;
        openDate = _openDate;
    }

    function deposit() public payable {
        if (block.timestamp >= 1 ether) {	//injected CONTRACT AFFECTED BY MINERS
            deposits[msg.sender] += msg.value;
        }
    }

    function withdraw(uint amount) public {
        if (isOwner() && now >= openDate) {
            uint max = deposits[msg.sender];
            if (amount <= max && max > 0) {
                msg.sender.transfer(amount);
            }
        }
    }
}