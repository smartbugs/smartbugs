                                                                 

// SPDX-License-Identifier: MIT


                                                                                                                               

                                                                                                                                                                                
 


pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;


library SafeMath {
    function ADD802(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
 function ADD802(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, errorMessage);

        return c;
    }
 function SUB29(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB29(a, b, "SafeMath: subtraction underflow");
    }
 function SUB29(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
  function MUL631(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
       if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
  function MUL631(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
      if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, errorMessage);

        return c;
    }
  function DIV549(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV549(a, b, "SafeMath: division by zero");
    }
 function DIV549(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
  function MOD667(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD667(a, b, "SafeMath: modulo by zero");
    }
 function MOD667(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IKeep2r {
    function ADDVOTES925(address voter, uint amount) external;	//inject NONSTANDARD NAMING
    function REMOVEVOTES795(address voter, uint amount) external;	//inject NONSTANDARD NAMING
    function ADDKPRCREDIT324(address job, uint amount) external;	//inject NONSTANDARD NAMING
    function APPROVELIQUIDITY19(address liquidity) external;	//inject NONSTANDARD NAMING
    function REVOKELIQUIDITY95(address liquidity) external;	//inject NONSTANDARD NAMING
    function ADDJOB704(address job) external;	//inject NONSTANDARD NAMING
    function REMOVEJOB261(address job) external;	//inject NONSTANDARD NAMING
    function SETKEEP2RHELPER717(address _kprh) external;	//inject NONSTANDARD NAMING
    function SETGOVERNANCE887(address _governance) external;	//inject NONSTANDARD NAMING
    function ACCEPTGOVERNANCE419() external;	//inject NONSTANDARD NAMING
    function DISPUTE17(address keeper) external;	//inject NONSTANDARD NAMING
    function SLASH754(address bonded, address keeper, uint amount) external;	//inject NONSTANDARD NAMING
    function REVOKE96(address keeper) external;	//inject NONSTANDARD NAMING
    function RESOLVE192(address keeper) external;	//inject NONSTANDARD NAMING
    function GETPRIORVOTES700(address account, uint blockNumber) external view returns (uint);	//inject NONSTANDARD NAMING
    function TOTALBONDED836() external view returns (uint);	//inject NONSTANDARD NAMING
}

contract Governance {
    using SafeMath for uint;
                                         
    string public constant name820 = "Governance";	//inject NONSTANDARD NAMING

                                                                                                                                   
    uint public _quorumVotes = 5000; // % of total supply required

                                                                                      
    uint public _proposalThreshold = 5000;

    uint public constant base706 = 10000;	//inject NONSTANDARD NAMING

    function SETQUORUM684(uint quorum_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == address(this), "Governance::setQuorum: timelock only");
        require(quorum_ <= base706, "Governance::setQuorum: quorum_ > BASE");
        _quorumVotes = quorum_;
    }

    function QUORUMVOTES610() public view returns (uint) {	//inject NONSTANDARD NAMING
        return KPR.TOTALBONDED836().MUL631(_quorumVotes).DIV549(base706);
    }

    function PROPOSALTHRESHOLD741() public view returns (uint) {	//inject NONSTANDARD NAMING
        return KPR.TOTALBONDED836().MUL631(_proposalThreshold).DIV549(base706);
    }

    function SETTHRESHOLD755(uint threshold_) external {	//inject NONSTANDARD NAMING
        require(msg.sender == address(this), "Governance::setQuorum: timelock only");
        require(threshold_ <= base706, "Governance::setThreshold: threshold_ > BASE");
        _proposalThreshold = threshold_;
    }

                                                                                
    function PROPOSALMAXOPERATIONS305() public pure returns (uint) { return 10; } // 10 actions	//inject NONSTANDARD NAMING

                                                                                   
    function VOTINGDELAY891() public pure returns (uint) { return 1; } // 1 block	//inject NONSTANDARD NAMING

                                                               
    function VOTINGPERIOD297() public pure returns (uint) { return 40_320; } // ~7 days in blocks (assuming 15s blocks)	//inject NONSTANDARD NAMING

                                                   
    IKeep2r immutable public KPR;

                                             
    uint public proposalCount;

    struct Proposal {
        uint id;
        address proposer;
        uint eta;
        address[] targets;
        uint[] values;
        string[] signatures;
        bytes[] calldatas;
        uint startBlock;
        uint endBlock;
        uint forVotes;
        uint againstVotes;
        bool canceled;
        bool executed;
        mapping (address => Receipt) receipts;
    }

                                                 
    struct Receipt {
        bool hasVoted;
        bool support;
        uint votes;
    }

                                                         
    enum ProposalState {
        Pending,
        Active,
        Canceled,
        Defeated,
        Succeeded,
        Queued,
        Expired,
        Executed
    }

                                                                  
    mapping (uint => Proposal) public proposals;

                                                     
    mapping (address => uint) public latestProposalIds;

                                                              
    bytes32 public constant domain_typehash397 = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");	//inject NONSTANDARD NAMING
    
    
    bytes32 public immutable DOMAINSEPARATOR;

                                                                               
    bytes32 public constant ballot_typehash182 = keccak256("Ballot(uint256 proposalId,bool support)");	//inject NONSTANDARD NAMING

                                                               
    event PROPOSALCREATED434(uint id, address proposer, address[] targets, uint[] values, string[] signatures, bytes[] calldatas, uint startBlock, uint endBlock, string description);	//inject NONSTANDARD NAMING

                                                                        
    event VOTECAST909(address voter, uint proposalId, bool support, uint votes);	//inject NONSTANDARD NAMING

                                                                  
    event PROPOSALCANCELED450(uint id);	//inject NONSTANDARD NAMING

                                                                                
    event PROPOSALQUEUED490(uint id, uint eta);	//inject NONSTANDARD NAMING

                                                                                  
    event PROPOSALEXECUTED781(uint id);	//inject NONSTANDARD NAMING

    function PROPOSEJOB470(address job) public {	//inject NONSTANDARD NAMING
        require(msg.sender == address(KPR), "Governance::proposeJob: only VOTER can propose new jobs");
        address[] memory targets;
        targets[0] = address(KPR);

        string[] memory signatures;
        signatures[0] = "addJob(address)";

        bytes[] memory calldatas;
        calldatas[0] = abi.encode(job);

        uint[] memory values;
        values[0] = 0;

        _PROPOSE700(targets, values, signatures, calldatas, string(abi.encodePacked("Governance::proposeJob(): ", job)));
    }

    function PROPOSE926(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {	//inject NONSTANDARD NAMING
        require(KPR.GETPRIORVOTES700(msg.sender, block.number.SUB29(1)) >= PROPOSALTHRESHOLD741(), "Governance::propose: proposer votes below proposal threshold");
        require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "Governance::propose: proposal function information arity mismatch");
        require(targets.length != 0, "Governance::propose: must provide actions");
        require(targets.length <= PROPOSALMAXOPERATIONS305(), "Governance::propose: too many actions");

        uint latestProposalId = latestProposalIds[msg.sender];
        if (latestProposalId != 0) {
          ProposalState proposersLatestProposalState = STATE767(latestProposalId);
          require(proposersLatestProposalState != ProposalState.Active, "Governance::propose: one live proposal per proposer, found an already active proposal");
          require(proposersLatestProposalState != ProposalState.Pending, "Governance::propose: one live proposal per proposer, found an already pending proposal");
        }

        return _PROPOSE700(targets, values, signatures, calldatas, description);
    }

    function _PROPOSE700(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) internal returns (uint) {	//inject NONSTANDARD NAMING
        uint startBlock = block.number.ADD802(VOTINGDELAY891());
        uint endBlock = startBlock.ADD802(VOTINGPERIOD297());

        proposalCount++;
        Proposal memory newProposal = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            eta: 0,
            targets: targets,
            values: values,
            signatures: signatures,
            calldatas: calldatas,
            startBlock: startBlock,
            endBlock: endBlock,
            forVotes: 0,
            againstVotes: 0,
            canceled: false,
            executed: false
        });

        proposals[newProposal.id] = newProposal;
        latestProposalIds[newProposal.proposer] = newProposal.id;

        emit PROPOSALCREATED434(newProposal.id, msg.sender, targets, values, signatures, calldatas, startBlock, endBlock, description);
        return newProposal.id;
    }

    function QUEUE934(uint proposalId) public {	//inject NONSTANDARD NAMING
        require(STATE767(proposalId) == ProposalState.Succeeded, "Governance::queue: proposal can only be queued if it is succeeded");
        Proposal storage proposal = proposals[proposalId];
        uint eta = block.timestamp.ADD802(delay);
        for (uint i = 0; i < proposal.targets.length; i++) {
            _QUEUEORREVERT932(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], eta);
        }
        proposal.eta = eta;
        emit PROPOSALQUEUED490(proposalId, eta);
    }

    function _QUEUEORREVERT932(address target, uint value, string memory signature, bytes memory data, uint eta) internal {	//inject NONSTANDARD NAMING
        require(!queuedTransactions[keccak256(abi.encode(target, value, signature, data, eta))], "Governance::_queueOrRevert: proposal action already queued at eta");
        _QUEUETRANSACTION380(target, value, signature, data, eta);
    }

    function EXECUTE292(uint proposalId) public payable {	//inject NONSTANDARD NAMING
        require(guardian == address(0x0) || msg.sender == guardian, "Governance:execute: !guardian");
        require(STATE767(proposalId) == ProposalState.Queued, "Governance::execute: proposal can only be executed if it is queued");
        Proposal storage proposal = proposals[proposalId];
        proposal.executed = true;
        for (uint i = 0; i < proposal.targets.length; i++) {
            _EXECUTETRANSACTION42(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
        }
        emit PROPOSALEXECUTED781(proposalId);
    }

    function CANCEL285(uint proposalId) public {	//inject NONSTANDARD NAMING
        ProposalState state = STATE767(proposalId);
        require(state != ProposalState.Executed, "Governance::cancel: cannot cancel executed proposal");

        Proposal storage proposal = proposals[proposalId];
        require(proposal.proposer != address(KPR) && 
                KPR.GETPRIORVOTES700(proposal.proposer, block.number.SUB29(1)) < PROPOSALTHRESHOLD741(), "Governance::cancel: proposer above threshold");

        proposal.canceled = true;
        for (uint i = 0; i < proposal.targets.length; i++) {
            _CANCELTRANSACTION608(proposal.targets[i], proposal.values[i], proposal.signatures[i], proposal.calldatas[i], proposal.eta);
        }

        emit PROPOSALCANCELED450(proposalId);
    }

    function GETACTIONS567(uint proposalId) public view returns (address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas) {	//inject NONSTANDARD NAMING
        Proposal storage p = proposals[proposalId];
        return (p.targets, p.values, p.signatures, p.calldatas);
    }

    function GETRECEIPT636(uint proposalId, address voter) public view returns (Receipt memory) {	//inject NONSTANDARD NAMING
        return proposals[proposalId].receipts[voter];
    }

    function STATE767(uint proposalId) public view returns (ProposalState) {	//inject NONSTANDARD NAMING
        require(proposalCount >= proposalId && proposalId > 0, "Governance::state: invalid proposal id");
        Proposal storage proposal = proposals[proposalId];
        if (proposal.canceled) {
            return ProposalState.Canceled;
        } else if (block.number <= proposal.startBlock) {
            return ProposalState.Pending;
        } else if (block.number <= proposal.endBlock) {
            return ProposalState.Active;
        } else if (proposal.forVotes.ADD802(proposal.againstVotes) < QUORUMVOTES610()) {
            return ProposalState.Defeated;
        } else if (proposal.forVotes <= proposal.againstVotes) {
            return ProposalState.Defeated;
        } else if (proposal.eta == 0) {
            return ProposalState.Succeeded;
        } else if (proposal.executed) {
            return ProposalState.Executed;
        } else if (block.timestamp >= proposal.eta.ADD802(grace_period471)) {
            return ProposalState.Expired;
        } else {
            return ProposalState.Queued;
        }
    }

    function CASTVOTE458(uint proposalId, bool support) public {	//inject NONSTANDARD NAMING
        _CASTVOTE871(msg.sender, proposalId, support);
    }

    function CASTVOTEBYSIG199(uint proposalId, bool support, uint8 v, bytes32 r, bytes32 s) public {	//inject NONSTANDARD NAMING
        bytes32 structHash = keccak256(abi.encode(ballot_typehash182, proposalId, support));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAINSEPARATOR, structHash));
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "Governance::castVoteBySig: invalid signature");
        _CASTVOTE871(signatory, proposalId, support);
    }

    function _CASTVOTE871(address voter, uint proposalId, bool support) internal {	//inject NONSTANDARD NAMING
        require(STATE767(proposalId) == ProposalState.Active, "Governance::_castVote: voting is closed");
        Proposal storage proposal = proposals[proposalId];
        Receipt storage receipt = proposal.receipts[voter];
        require(receipt.hasVoted == false, "Governance::_castVote: voter already voted");
        uint votes = KPR.GETPRIORVOTES700(voter, proposal.startBlock);

        if (support) {
            proposal.forVotes = proposal.forVotes.ADD802(votes);
        } else {
            proposal.againstVotes = proposal.againstVotes.ADD802(votes);
        }

        receipt.hasVoted = true;
        receipt.support = support;
        receipt.votes = votes;

        emit VOTECAST909(voter, proposalId, support, votes);
    }

    function GETCHAINID291() internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint chainId;
        assembly { chainId := chainid() }
        return chainId;
    }

    event NEWDELAY307(uint indexed newDelay);	//inject NONSTANDARD NAMING
    event CANCELTRANSACTION220(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);	//inject NONSTANDARD NAMING
    event EXECUTETRANSACTION925(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);	//inject NONSTANDARD NAMING
    event QUEUETRANSACTION307(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);	//inject NONSTANDARD NAMING

    uint public constant grace_period471 = 14 days;	//inject NONSTANDARD NAMING
    uint public constant minimum_delay353 = 1 days;	//inject NONSTANDARD NAMING
    uint public constant maximum_delay422 = 30 days;	//inject NONSTANDARD NAMING

    uint public delay = minimum_delay353;
    
    address public guardian;
    address public pendingGuardian;
    
    function SETGUARDIAN20(address _guardian) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::setGuardian: !guardian");
        pendingGuardian = _guardian;
    }
    
    function ACCEPTGUARDIANSHIP599() external {	//inject NONSTANDARD NAMING
        require(msg.sender == pendingGuardian, "Keep2rGovernance::setGuardian: !pendingGuardian");
        guardian = pendingGuardian;
    }
    
    function ADDVOTES925(address voter, uint amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::addVotes: !guardian");
        KPR.ADDVOTES925(voter, amount);
    }
    function REMOVEVOTES795(address voter, uint amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::removeVotes: !guardian");
        KPR.REMOVEVOTES795(voter, amount);
    }
    function ADDKPRCREDIT324(address job, uint amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::addKPRCredit: !guardian");
        KPR.ADDKPRCREDIT324(job, amount);
    }
    function APPROVELIQUIDITY19(address liquidity) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::approveLiquidity: !guardian");
        KPR.APPROVELIQUIDITY19(liquidity);
    }
    function REVOKELIQUIDITY95(address liquidity) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::revokeLiquidity: !guardian");
        KPR.REVOKELIQUIDITY95(liquidity);
    }
    function ADDJOB704(address job) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::addJob: !guardian");
        KPR.ADDJOB704(job);
    }
    function REMOVEJOB261(address job) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::removeJob: !guardian");
        KPR.REMOVEJOB261(job);
    }
    function SETKEEP2RHELPER717(address kprh) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::setKeep2rHelper: !guardian");
        KPR.SETKEEP2RHELPER717(kprh);
    }
    function SETGOVERNANCE887(address _governance) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::setGovernance: !guardian");
        KPR.SETGOVERNANCE887(_governance);
    }
    function ACCEPTGOVERNANCE419() external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::acceptGovernance: !guardian");
        KPR.ACCEPTGOVERNANCE419();
    }
    function DISPUTE17(address keeper) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::dispute: !guardian");
        KPR.DISPUTE17(keeper);
    }
    function SLASH754(address bonded, address keeper, uint amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::slash: !guardian");
        KPR.SLASH754(bonded, keeper, amount);
    }
    function REVOKE96(address keeper) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::revoke: !guardian");
        KPR.REVOKE96(keeper);
    }
    function RESOLVE192(address keeper) external {	//inject NONSTANDARD NAMING
        require(msg.sender == guardian, "Keep2rGovernance::resolve: !guardian");
        KPR.RESOLVE192(keeper);
    }

    mapping (bytes32 => bool) public queuedTransactions;

    constructor(address token_) public {
        guardian = msg.sender;
        KPR = IKeep2r(token_);
        DOMAINSEPARATOR = keccak256(abi.encode(domain_typehash397, keccak256(bytes(name820)), GETCHAINID291(), address(this)));
    }

    receive() external payable { }

    function SETDELAY397(uint delay_) public {	//inject NONSTANDARD NAMING
        require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");
        require(delay_ >= minimum_delay353, "Timelock::setDelay: Delay must exceed minimum delay.");
        require(delay_ <= maximum_delay422, "Timelock::setDelay: Delay must not exceed maximum delay.");
        delay = delay_;

        emit NEWDELAY307(delay);
    }

    function _QUEUETRANSACTION380(address target, uint value, string memory signature, bytes memory data, uint eta) internal returns (bytes32) {	//inject NONSTANDARD NAMING
        require(eta >= GETBLOCKTIMESTAMP893().ADD802(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");
        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
        queuedTransactions[txHash] = true;

        emit QUEUETRANSACTION307(txHash, target, value, signature, data, eta);
        return txHash;
    }

    function _CANCELTRANSACTION608(address target, uint value, string memory signature, bytes memory data, uint eta) internal {	//inject NONSTANDARD NAMING
        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
        queuedTransactions[txHash] = false;

        emit CANCELTRANSACTION220(txHash, target, value, signature, data, eta);
    }

    function _EXECUTETRANSACTION42(address target, uint value, string memory signature, bytes memory data, uint eta) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
        require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn't been queued.");
        require(GETBLOCKTIMESTAMP893() >= eta, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");
        require(GETBLOCKTIMESTAMP893() <= eta.ADD802(grace_period471), "Timelock::executeTransaction: Transaction is stale.");

        queuedTransactions[txHash] = false;

        bytes memory callData;

        if (bytes(signature).length == 0) {
            callData = data;
        } else {
            callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
        }

        // solium-disable-next-line security/no-call-value
        (bool success, bytes memory returnData) = target.call{value:value}(callData);
        require(success, "Timelock::executeTransaction: Transaction execution reverted.");

        emit EXECUTETRANSACTION925(txHash, target, value, signature, data, eta);

        return returnData;
    }

    function GETBLOCKTIMESTAMP893() internal view returns (uint) {	//inject NONSTANDARD NAMING
        // solium-disable-next-line security/no-block-members
        return block.timestamp;
    }
}