pragma solidity 0.6.2;

/*
tx.origin is not without its proper application, such 
as the following statement that effectively rejects 
the contract call. tx.origin in this contract is innocent.
*/

contract gray_badTxorigin{
    uint256 public visitTimes;
    address owner;
    
    constructor() public{
        visitTimes = 0;
        owner = msg.sender;
        address owner1 = msg.sender;
    }

    modifier onlyOwner() {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        require(tx.origin == owner, "hahaha");	//inject USING TX ORIGIN FOR AUTHENTICATION

        assert(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    
    //Only real user access is recorded, not contract access.
    function visitContract() onlyOwner external{
        require(owner == tx.origin);	//inject USING TX ORIGIN FOR AUTHENTICATION

        visitTimes += 1;
    }
    
    function getTimes() view external returns(uint256){
        return visitTimes;
    }
}