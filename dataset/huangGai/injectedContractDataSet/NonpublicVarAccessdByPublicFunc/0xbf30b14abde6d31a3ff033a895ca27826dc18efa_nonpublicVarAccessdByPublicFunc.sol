/**
 *Submitted for verification at Etherscan.io on 2020-08-27
*/

pragma solidity ^0.5.12;

interface PASTA {
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    function setFoodbank(address _foodbank) external;
    function setGovernance(address _governance) external;
}

contract ChefsTable {

    // --- Math ---
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }

    // token contract
    PASTA spaghetti;

    mapping(address=>uint) internal balances;

    struct Proposal {
        uint id;
        address proposer;
        mapping(address => uint) forVotes;
        mapping(address => uint) againstVotes;
        uint totalForVotes;
        uint totalAgainstVotes;
        uint start; // block start;
        uint end;   // start + period
        address newFood;
        address newGov;
    }

    mapping(address => uint) internal voteLock;
    mapping (uint => Proposal) internal proposals;
    uint internal proposalCount;
    uint internal period = 3 days; // voting period in blocks ~ 17280 3 days for 15s/block
    uint internal lock = 3 days;   // vote lock in blocks ~ 17280 3 days for 15s/block
    uint internal minimum = 1e18; // you need 1 PASTA to propose
    uint internal govLock;


    constructor(address _spaghetti) public {
        spaghetti = PASTA(_spaghetti);
        govLock = block.timestamp + 14 days;
    }

    function join(uint amount) public {
        uint bal = spaghetti.balanceOf(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(spaghetti.transferFrom(msg.sender, address(this), amount), "join/transferFrom-fail");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[msg.sender] += spaghetti.balanceOf(address(this)) - bal;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function free(uint amount) public {
        require(voteLock[msg.sender] < block.timestamp, "still votelocked");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(balances[msg.sender] <= amount, "amount too high");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[msg.sender] = sub(balances[msg.sender], amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(spaghetti.transfer(msg.sender, amount), "free/transfer-failed");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function propose(address _newFood, address _newGov) public {
        require(block.timestamp >= govLock, "No governance for 2 weeks");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(balances[msg.sender] > minimum, "<minimum");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        proposals[proposalCount++] = Proposal({	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            id: proposalCount,	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            proposer: msg.sender,
            totalForVotes: 0,
            totalAgainstVotes: 0,
            start: block.timestamp,
            end: add(block.timestamp, period),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            newFood: _newFood,
            newGov: _newGov
        });

        voteLock[msg.sender] = add(block.timestamp, lock);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function voteFor(uint id) public {
        require(proposals[id].start < block.timestamp , "<start");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(proposals[id].end > block.timestamp , ">end");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint votes = sub(balances[msg.sender], proposals[id].forVotes[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        proposals[id].totalForVotes = add(votes, proposals[id].totalForVotes);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        proposals[id].forVotes[msg.sender] = balances[msg.sender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        voteLock[msg.sender] = add(block.timestamp, lock);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function voteAgainst(uint id) public {
        require(proposals[id].start < block.timestamp , "<start");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(proposals[id].end > block.timestamp , ">end");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint votes = sub(balances[msg.sender], proposals[id].againstVotes[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        proposals[id].totalAgainstVotes = add(votes, proposals[id].totalAgainstVotes);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        proposals[id].againstVotes[msg.sender] = balances[msg.sender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        voteLock[msg.sender] = add(block.timestamp, lock);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function execute(uint id) public {
        // If the proposal is over, has passed, and has passed a 3 day pause 
        if ((proposals[id].end + lock) < block.timestamp && proposals[id].totalForVotes > proposals[id].totalAgainstVotes) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            if (proposals[id].newFood != address(0)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                spaghetti.setFoodbank(proposals[id].newFood);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
            if (proposals[id].newGov != address(0)) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                spaghetti.setGovernance(proposals[id].newGov);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            }
        }
    }

}