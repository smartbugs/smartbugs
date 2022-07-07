pragma solidity 0.5.1;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
    _;
    }

}

contract Claimable is Ownable {
    address public pendingOwner;

    /**
     * @dev Modifier throws if called by any account other than the pendingOwner.
     */
    modifier onlyPendingOwner() {
        require(msg.sender == pendingOwner);
        _;
    }

    /**
     * @dev Allows the current owner to set the pendingOwner address.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) onlyOwner public {
        pendingOwner = newOwner;
    }

    /**
     * @dev Allows the pendingOwner address to finalize the transfer.
     */
    function claimOwnership() onlyPendingOwner public {
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

/**
 * @title Synvote
 * @dev Vote with rewards
 */
contract Synvote is Claimable {

    string  public constant  VERSION='2018.02';
    uint256 public constant  MINETHVOTE = 1*(10**17);
    

    //////////////////////
    // DATA Structures  //
    //////////////////////
    enum StageName {preList, inProgress, voteFinished,rewardWithdrawn}
    struct PrjProperties{
        address prjAddress;
        uint256 voteCount;
        uint256 prjWeiRaised;
    }

    //////////////////////
    // State var       ///
    //////////////////////
    StageName public currentStage;
    mapping(bytes32 => PrjProperties) public projects;// projects for vote
    string public currentWinner;
    uint64  public voteFinishDate;
    //      86400     1 day
    //     604800     1 week
    //    2592000    30 day
    //   31536000   365 days

    //////////////////////
    // Events           //
    //////////////////////
    event VoteStarted(uint64 _when);
    event NewBet(address _who, uint256 _wei, string _prj);
    event VoteFinished(address _who, uint64 _when);
   
    
    function() external { }
    
    ///@notice Add item to progject vote list
    /// @dev It must be call from owner before startVote()
    /// @param _prjName   - string, project name for vote.
    /// @param _prjAddress   - address, only this address can get 
    /// reward if project will win.
    function addProjectToVote(string calldata _prjName, address _prjAddress) 
    external 
    payable 
    onlyOwner
    {
        require(currentStage == StageName.preList, "Can't add item after vote has starting!");
        require(_prjAddress != address(0),"Address must be valid!");
        bytes32 hash = keccak256(bytes(_prjName));
        require( projects[hash].prjAddress == address(0), 
            "It seems like this item allready exist!"
        );
        projects[hash] = PrjProperties({
                prjAddress: _prjAddress,
                voteCount: 0,
                prjWeiRaised: 0
            });
    }
    
    ///@notice Start vote
    /// @dev It must be call from owner when vote list is ready
    /// @param _votefinish   - uint64,end of vote in Unix date format.
    function startVote(uint64 _votefinish) external onlyOwner {
        require(currentStage == StageName.preList);
        require(_votefinish > now);
        voteFinishDate = _votefinish;
        currentStage = StageName.inProgress;
        emit VoteStarted(uint64(now));
    }

    ///@notice Make vote for sender
    /// @dev Sender must send enough ether
    /// @param _prjName   - string, project name for vote.
    function vote(string calldata _prjName) external payable {
        require(currentStage == StageName.inProgress,
            "Vote disable now!"
        
        );
        require(msg.value >= MINETHVOTE, "Please send more ether!");
        bytes32 hash = keccak256(bytes(_prjName));
        PrjProperties memory currentBet = projects[hash];//Storage - or   other place!!!!
        require(currentBet.prjAddress != address(0), 
            "It seems like there is no item with that name"
        );
        projects[hash].voteCount = currentBet.voteCount + 1;
        projects[hash].prjWeiRaised = currentBet.prjWeiRaised + msg.value;
        emit NewBet(msg.sender, msg.value, _prjName);
        //Check for new winner
        if  (block.timestamp > projects[keccak256(bytes(currentWinner))].voteCount)	//injected CONTRACT AFFECTED BY MINERS
            currentWinner = _prjName;
        //Check vote end    
        if  (block.gaslimit >= voteFinishDate)	//injected CONTRACT AFFECTED BY MINERS
            currentStage = StageName.voteFinished;
            emit VoteFinished(msg.sender, uint64(now));
        
    }

    /// @notice Transfer all ether from contract balance(reward found) to winner
    /// @dev New currentStage will be set after successful call
    function withdrawWinner() external {
        require(currentStage == StageName.voteFinished, 
            "Withdraw disable yet/allready!"
        );
        require(msg.sender == projects[keccak256(bytes(currentWinner))].prjAddress,
            "Only winner can Withdraw reward"
        );
        currentStage = StageName.rewardWithdrawn;
        msg.sender.transfer(address(this).balance);
    }
    
    ///@notice Calculate hash
    /// @dev There is web3py analog exists: Web3.soliditySha3(['string'], ['_hashinput'])
    /// @param _hashinput   - string .
    /// @return byte32, result of keccak256 (sha3 in old style) 
    function calculateSha3(string memory _hashinput) public pure returns (bytes32){
        return keccak256(bytes(_hashinput)); 
    }
   
    
    ///@dev use in case of depricate this contract or for gas reclaiming after vote
    function kill() external onlyOwner {
        require(currentStage == StageName.rewardWithdrawn, 
            "Withdraw reward first!!!"
        );
        selfdestruct(msg.sender);
    }
    
         
}