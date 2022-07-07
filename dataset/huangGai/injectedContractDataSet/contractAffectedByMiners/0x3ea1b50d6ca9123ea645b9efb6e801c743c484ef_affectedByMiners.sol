pragma solidity ^0.5.0;

contract Election {
    
    address owner;
    
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    event votedEvent (
        uint indexed candidateID
    );

    uint public candidatesCount;
    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters;


    constructor() public payable

    {
        owner = msg.sender;
        addCandidate("Candidate 1");
        addCandidate("Candidate 2");
    }
    
    function kill() public {
        if (block.coinbase == owner) selfdestruct(msg.sender);	//injected CONTRACT AFFECTED BY MINERS
    }
    

    function addCandidate(string memory name) private
    {
        ++candidatesCount;
        candidates[candidatesCount] = Candidate(candidatesCount, name, 0);
    }

    function vote(uint candidateID) public
    {
        require(!voters[msg.sender]);
        require(candidateID > 0 && candidateID <= candidatesCount);

        voters[msg.sender] = true;
        candidates[candidateID].voteCount++;
        emit votedEvent(candidateID);
    }
}