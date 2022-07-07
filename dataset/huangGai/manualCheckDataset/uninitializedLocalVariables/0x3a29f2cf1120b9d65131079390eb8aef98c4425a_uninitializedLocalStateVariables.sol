/**
 *Submitted for verification at Etherscan.io on 2020-04-22
*/

pragma solidity 0.5.14;

interface IToken { // brief ERC-20 interface
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract MemberDripDrop {
    /***************
    INTERNAL DETAILS
    ***************/
    uint256 public ethDrip;
    uint256 public tokenDrip;
    IToken public dripToken;
    address payable[] members;
    address payable public secretary;
    
    mapping(address => Member) public memberList;
    
    struct Member {
        uint256 memberIndex;
        bool exists;
    }

    modifier onlySecretary() {
        require(msg.sender == secretary, "caller must be secretary");
        _;
    }
    
    // ******
    // EVENTS
    // ******
    event DripTokenUpdated(address indexed updatedDripToken);
    event TokenDripUpdated(uint256 indexed updatedTokenDrip);
    event ETHDripUpdated(uint256 indexed updatedETHDrip);
    event MemberAdded(address indexed addedMember);
    event MemberRemoved(address indexed removedMember);
    event SecretaryUpdated(address indexed updatedSecretary);
    
    function() external payable { } // contract receives ETH

    constructor(
        uint256 _ethDrip, 
        uint256 _tokenDrip,  
        address dripTokenAddress, 
        address payable[] memory _members) payable public { // initializes contract
        for (uint256 i ; i < _members.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            require(_members[i] != address(0), "member address cannot be 0");
            memberList[_members[i]].memberIndex = members.push(_members[i]) - 1;
            memberList[_members[i]].exists = true;
        }
        
        ethDrip = _ethDrip;
        tokenDrip = _tokenDrip;
        dripToken = IToken(dripTokenAddress);
        secretary = members[0]; // first address in member array is secretary  
    }
    
    /************************
    DRIP/DROP TOKEN FUNCTIONS
    ************************/
    function dripTKN() public onlySecretary { // transfer token to members per stored drip amount
        for (uint256 i ; i < members.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            dripToken.transfer(members[i], tokenDrip);
        }
    }
    
    function dropTKN(uint256 drop, address dropTokenAddress) public onlySecretary { // transfer token to members per approved drop amount
        for (uint256 i ; i < members.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            IToken dropToken ;	//inject UNINIT LOCAL/STATE VAR

            dropToken.transferFrom(msg.sender, members[i], drop);
        }
    }
    
    function customDropTKN(uint256[] memory drop, address dropTokenAddress) public onlySecretary { // transfer token to members per approved index drop amounts
        for (uint256 i ; i < members.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            IToken dropToken ;	//inject UNINIT LOCAL/STATE VAR

            dropToken.transferFrom(msg.sender, members[i], drop[i]);
        }
    }
    
    /**********************
    DRIP/DROP ETH FUNCTIONS
    **********************/
    function dripETH() public onlySecretary { // transfer ETH to members per stored drip amount
        for (uint256 i ; i < members.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            members[i].transfer(ethDrip);
        }
    }

    function dropETH() payable public onlySecretary { // transfer ETH to members per attached drop amount
        for (uint256 i ; i < members.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            members[i].transfer(msg.value);
        }
    }
    
    function customDropETH(uint256[] memory drop) payable public onlySecretary { // transfer ETH to members per index drop amounts
        for (uint256 i ; i < members.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            members[i].transfer(drop[i]);
        }
    }
    
    /******************
    SECRETARY FUNCTIONS
    ******************/
    // ******************
    // DRIP/DROP REGISTRY
    // ******************
    function addMember(address payable addedMember) public onlySecretary { 
        require(memberList[addedMember].exists != true, "member already exists");
        memberList[addedMember].memberIndex = members.push(addedMember) - 1;
        memberList[addedMember].exists = true;
        emit MemberAdded(addedMember);
    }

    function removeMember(address removedMember) public onlySecretary {
        require(memberList[removedMember].exists = true, "no such member to remove");
        uint256 memberToDelete ;	//inject UNINIT LOCAL/STATE VAR

        address payable keyToMove ;	//inject UNINIT LOCAL/STATE VAR

        members[memberToDelete] = keyToMove;
        memberList[keyToMove].memberIndex = memberToDelete;
        memberList[removedMember].exists = false;
        members.length--;
        emit MemberRemoved(removedMember);
    }

    function updateSecretary(address payable updatedSecretary) public onlySecretary {
        secretary = updatedSecretary;
        emit SecretaryUpdated(updatedSecretary);
    }
    
    // ************
    // DRIP DETAILS
    // ************
    function updateETHDrip(uint256 updatedETHDrip) public onlySecretary {
        ethDrip = updatedETHDrip;
        emit ETHDripUpdated(updatedETHDrip);
    }
    
    function updateDripToken(address updatedDripToken) public onlySecretary {
        dripToken = IToken(updatedDripToken);
        emit DripTokenUpdated(updatedDripToken);
    }
    
    function updateTokenDrip(uint256 updatedTokenDrip) public onlySecretary {
        tokenDrip = updatedTokenDrip;
        emit TokenDripUpdated(updatedTokenDrip);
    }
    
    /***************
    GETTER FUNCTIONS
    ***************/
    // ****
    // DRIP
    // ****
    function ETHBalance() public view returns (uint256) { // get balance of ETH in contract
        return address(this).balance;
    }
    
    function TokenBalance() public view returns (uint256) { // get balance of drip token in contract
        return dripToken.balanceOf(address(this));
    }

    // ******
    // MEMBER
    // ******
    function Membership() public view returns (address payable[] memory) {
        return members;
    }

    function MemberCount() public view returns(uint256 memberCount) {
        return members.length;
    }

    function isMember(address memberAddress) public view returns (bool memberExists) {
        if(members.length == 0) return false;
        return (members[memberList[memberAddress].memberIndex] == memberAddress);
    }
}