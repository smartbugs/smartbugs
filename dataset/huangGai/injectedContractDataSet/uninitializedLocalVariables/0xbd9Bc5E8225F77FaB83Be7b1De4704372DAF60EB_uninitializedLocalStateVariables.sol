/**
 *Submitted for verification at Etherscan.io on 2019-12-02
*/

/*
    @MyJobBot
*/

pragma solidity ^ 0.5.12;
pragma experimental ABIEncoderV2;


contract Owned {
    address public owner;
    address public newOwner;
    address public oracul;
    uint idleTime ; // 90 days	//inject UNINIT LOCAL/STATE VAR

    uint lastTxTime;
    


    event OwnershipTransferred(address indexed _from, address indexed _to);
    event OraculChanged(address indexed _oracul);

    constructor() public {
        owner = 0x95B719Df33A6b4c2a897CAa156BFCFf4d8564161;
        oracul = msg.sender;
        lastTxTime = now;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier onlyOracul {
        require(msg.sender == oracul);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

    function setOracul(address _newOracul) public onlyOwner {
        oracul = _newOracul;
        emit OraculChanged(_newOracul);
    }

    function canSuicide() public view returns(bool) {
        if (now - lastTxTime <  idleTime) {
            return false;
        } else {
            return true;
        }
    }

    function suicideContract() public onlyOwner {
        if (now - lastTxTime < idleTime) {
            revert();
        } else {
            selfdestruct(msg.sender);
        }
    }
}



contract Verifier is Owned {
    bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked("EIP712Domain(string name,string version)"));
    bytes32 private constant CHECK_TYPEHASH = keccak256(abi.encodePacked("Check(address user,uint256 amount,uint256 time)"));

    bytes32 private constant DOMAIN_SEPARATOR = keccak256(abi.encode(
        EIP712_DOMAIN_TYPEHASH,
        keccak256("AddTrade"),
        keccak256("1")
    ));
    
    struct Check {
        address user;
        uint256 amount;
        uint256 time;
    }

    function hashCheck(Check memory _check) private pure returns (bytes32){
        return keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(
                CHECK_TYPEHASH,
                _check.user,
                _check.amount,
                _check.time
            ))
        ));
    }
    
    function verify(Check memory check, uint8 sigV, bytes32 sigR, bytes32 sigS) public view returns (bool) {
        return oracul == ecrecover(hashCheck(check), sigV, sigR, sigS);
    }

    function verifyCheck(address user, uint256 amount, uint256 time, uint8 sigV, bytes32 sigR, bytes32 sigS)  public view returns (bool) {
        Check memory check = Check({user: user, amount: amount, time: time});

        return oracul == ecrecover(hashCheck(check), sigV, sigR, sigS);
    }
}

contract Verifier2 is Owned {
    bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked("EIP712Domain(string name,string version)"));
    bytes32 private constant CHECK_TYPEHASH = keccak256(abi.encodePacked("Access(address user)"));

    bytes32 private constant DOMAIN_SEPARATOR = keccak256(abi.encode(
        EIP712_DOMAIN_TYPEHASH,
        keccak256("AddTrade"),
        keccak256("1")
    ));
    
    struct Access {
        address user;
    }

    function hashCheck(Access memory _check) private pure returns (bytes32){
        return keccak256(abi.encodePacked(
            "\x19\x01",
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(
                CHECK_TYPEHASH,
                _check.user
            ))
        ));
    }

    function verifyAccess(address user, uint8 sigV, bytes32 sigR, bytes32 sigS)  public view returns (bool) {
        Access memory access = Access({user: user});

        return oracul == ecrecover(hashCheck(access), sigV, sigR, sigS);
    }
}


contract MyJobBot is Verifier, Verifier2 {
    // Init
    uint public adminBalance;
    uint public proposalPrice;
    address[] public allProposals;
    address[] public allCashOut;
    struct ProposalObject {
        uint amount;
        uint time;
    }
    mapping(address => uint) cashOutRecords;
    mapping(address => ProposalObject) proposalRecords;
    mapping(address => uint) penaltyRecords;
    constructor() public {
        proposalPrice = 78000000000000000;
    }

    // Events
    event NewProposal(address indexed user, uint indexed amount);
    event CashOut(address indexed user, uint indexed amount);
    event Penalty(address indexed user, uint indexed amount);


    // Getters
    function getCashOut(address _user) public view returns(uint) {
        return cashOutRecords[_user];
    }

    function getProposal(address _user) public view returns(ProposalObject memory) {
        return proposalRecords[_user];
    }

    function getPenalty(address _user) public view returns(uint) {
        return penaltyRecords[_user];
    }
    
    // Functions
    function newProposal(address user, uint8 sigV, bytes32 sigR, bytes32 sigS) public payable {
        require(verifyAccess(user, sigV, sigR, sigS) == true);
        require(msg.sender == user);
        require(msg.value >= proposalPrice);
        require (proposalRecords[msg.sender].time == 0);

        adminBalance += msg.value / 100 * 45;
        
        proposalRecords[msg.sender] = ProposalObject({amount: msg.value - (msg.value / 100 * 45), time: now});
        allProposals.push(msg.sender);
        lastTxTime = now;
        emit NewProposal(msg.sender, msg.value);
    }

    function cashOut(address user, uint256 amount, uint256 time, uint8 sigV, bytes32 sigR, bytes32 sigS) public {
        require(verifyCheck(user, amount, time, sigV, sigR, sigS) == true);
        require(msg.sender == user);
        require(time > cashOutRecords[msg.sender]);
        require (amount + adminBalance <= address(this).balance);

        msg.sender.transfer(amount);
        cashOutRecords[msg.sender] = time;
        allCashOut.push(msg.sender);
        lastTxTime = now;
        emit CashOut(msg.sender, amount);
    }

    function penalty() public payable {
        require(msg.value >= proposalPrice);
        adminBalance += msg.value;
        penaltyRecords[msg.sender] = now;
        emit Penalty(msg.sender, msg.value);
    }

    function cashoutAdmin() public onlyOwner {
        msg.sender.transfer(adminBalance);
        adminBalance = 0;
    }

    function setProposalPrice(uint _newProposalPrice) public onlyOracul {
        proposalPrice = _newProposalPrice;
    }

    // ==================== Fallback!
    function() external payable {
        if (msg.value == 1000000000) {
            cashoutAdmin();
            return;
        }
        adminBalance += msg.value;
    }
}