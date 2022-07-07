                                                                 

pragma solidity 0.5.16;


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
contract Initializable {

                                                                       
  bool private initialized;

                                                                                         
  bool private initializing;

                                                                                
  modifier INITIALIZER17() {	//inject NONSTANDARD NAMING
    require(initializing || ISCONSTRUCTOR66() || !initialized, "Contract instance has already been initialized");

    bool isTopLevelCall = !initializing;
    if (isTopLevelCall) {
      initializing = true;
      initialized = true;
    }

    _;

    if (isTopLevelCall) {
      initializing = false;
    }
  }

                                                                                 
  function ISCONSTRUCTOR66() private view returns (bool) {	//inject NONSTANDARD NAMING
    // extcodesize checks the size of the code stored in an address, and
    // address returns the current address. Since the code is still not
    // deployed when running a constructor, any checks on its code size will
    // yield zero, making it an effective way to detect if a contract is
    // under construction or not.
    address self = address(this);
    uint256 cs;
    assembly { cs := extcodesize(self) }
    return cs == 0;
  }

  // Reserved storage space to allow for layout changes in the future.
  uint256[50] private ______gap;
}


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD372(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB412(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB412(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                                                             
    function SUB412(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL649(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV679(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV679(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function DIV679(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD551(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD551(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function MOD551(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}


interface ILidCertifiableToken {
    function ACTIVATETRANSFERS731() external;	//inject NONSTANDARD NAMING
    function ACTIVATETAX668() external;	//inject NONSTANDARD NAMING
    function MINT344(address account, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ADDMINTER649(address account) external;	//inject NONSTANDARD NAMING
    function RENOUNCEMINTER144() external;	//inject NONSTANDARD NAMING
    function TRANSFER323(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE152(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM1(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE547(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ISMINTER659(address account) external view returns (bool);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY983() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF603(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    event TRANSFER149(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL587(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

}


library BasisPoints {
    using SafeMath for uint;

    uint constant private basis_points714 = 10000;	//inject NONSTANDARD NAMING

    function MULBP472(uint amt, uint bp) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (amt == 0) return 0;
        return amt.MUL649(bp).DIV679(basis_points714);
    }

    function DIVBP824(uint amt, uint bp) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(bp > 0, "Cannot divide by zero.");
        if (amt == 0) return 0;
        return amt.MUL649(basis_points714).DIV679(bp);
    }

    function ADDBP191(uint amt, uint bp) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (amt == 0) return 0;
        if (bp == 0) return amt;
        return amt.ADD372(MULBP472(amt, bp));
    }

    function SUBBP23(uint amt, uint bp) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (amt == 0) return 0;
        if (bp == 0) return amt;
        return amt.SUB412(MULBP472(amt, bp));
    }
}


contract LidTeamLock is Initializable {
    using BasisPoints for uint;
    using SafeMath for uint;

    uint public releaseInterval;
    uint public releaseStart;
    uint public releaseBP;

    uint public startingLid;
    uint public startingEth;

    address payable[] public teamMemberAddresses;
    uint[] public teamMemberBPs;
    mapping(address => uint) public teamMemberClaimedEth;
    mapping(address => uint) public teamMemberClaimedLid;

    ILidCertifiableToken private lidToken;

    modifier ONLYAFTERSTART772 {	//inject NONSTANDARD NAMING
        require(releaseStart != 0 && now > releaseStart, "Has not yet started.");
        _;
    }

    function() external payable { }

    function INITIALIZE794(	//inject NONSTANDARD NAMING
        uint _releaseInterval,
        uint _releaseBP,
        address payable[] calldata _teamMemberAddresses,
        uint[] calldata _teamMemberBPs,
        ILidCertifiableToken _lidToken
    ) external INITIALIZER17 {
        require(_teamMemberAddresses.length == _teamMemberBPs.length, "Must have one BP for every address.");

        releaseInterval = _releaseInterval;
        releaseBP = _releaseBP;
        lidToken = _lidToken;

        for (uint i = 0; i < _teamMemberAddresses.length; i++) {
            teamMemberAddresses.push(_teamMemberAddresses[i]);
        }

        uint totalTeamBP = 0;
        for (uint i = 0; i < _teamMemberBPs.length; i++) {
            teamMemberBPs.push(_teamMemberBPs[i]);
            totalTeamBP = totalTeamBP.ADD372(_teamMemberBPs[i]);
        }
        require(totalTeamBP == 10000, "Must allocate exactly 100% (10000 BP) to team.");
    }

    function CLAIMLID158(uint id) external ONLYAFTERSTART772 {	//inject NONSTANDARD NAMING
        require(CHECKIFTEAMMEMBER746(msg.sender), "Can only be called by team members.");
        require(msg.sender == teamMemberAddresses[id], "Sender must be team member ID");
        uint bp = teamMemberBPs[id];
        uint cycle = GETCURRENTCYCLECOUNT204();
        uint totalClaimAmount = cycle.MUL649(startingLid.MULBP472(bp).MULBP472(releaseBP));
        uint toClaim = totalClaimAmount.SUB412(teamMemberClaimedLid[msg.sender]);
        if (lidToken.BALANCEOF603(address(this)) < toClaim) toClaim = lidToken.BALANCEOF603(address(this));
        teamMemberClaimedLid[msg.sender] = teamMemberClaimedLid[msg.sender].ADD372(toClaim);
        lidToken.TRANSFER323(msg.sender, toClaim);
    }

    function CLAIMETH812(uint id) external {	//inject NONSTANDARD NAMING
        require(CHECKIFTEAMMEMBER746(msg.sender), "Can only be called by team members.");
        require(msg.sender == teamMemberAddresses[id], "Sender must be team member ID");
        uint bp = teamMemberBPs[id];
        uint totalClaimAmount = startingEth.MULBP472(bp);
        uint toClaim = totalClaimAmount.SUB412(teamMemberClaimedEth[msg.sender]);
        if (address(this).balance < toClaim) toClaim = address(this).balance;
        teamMemberClaimedEth[msg.sender] = teamMemberClaimedEth[msg.sender].ADD372(toClaim);
        msg.sender.transfer(toClaim);
    }

    function STARTRELEASE140() external {	//inject NONSTANDARD NAMING
        require(releaseStart == 0, "Has already started.");
        require(address(this).balance != 0, "Must have some ether deposited.");
        require(lidToken.BALANCEOF603(address(this)) != 0, "Must have some lid deposited.");
        startingLid = lidToken.BALANCEOF603(address(this));
        startingEth = address(this).balance;
        releaseStart = now.ADD372(24 hours);
    }

    function MIGRATEMEMBER350(uint i, address payable newAddress) external {	//inject NONSTANDARD NAMING
        require(msg.sender == teamMemberAddresses[0], "Must be project lead.");
        address oldAddress = teamMemberAddresses[i];
        teamMemberClaimedLid[newAddress] = teamMemberClaimedLid[oldAddress];
        delete teamMemberClaimedLid[oldAddress];
        teamMemberAddresses[i] = newAddress;
    }

    function RESETTEAM129(	//inject NONSTANDARD NAMING
        address payable[] calldata _teamMemberAddresses,
        uint[] calldata _teamMemberBPs
    ) external {
        require(msg.sender == teamMemberAddresses[0], "Must be project lead.");
        delete teamMemberAddresses;
        delete teamMemberBPs;
        for (uint i = 0; i < _teamMemberAddresses.length; i++) {
            teamMemberAddresses.push(_teamMemberAddresses[i]);
        }

        uint totalTeamBP = 0;
        for (uint i = 0; i < _teamMemberBPs.length; i++) {
            teamMemberBPs.push(_teamMemberBPs[i]);
            totalTeamBP = totalTeamBP.ADD372(_teamMemberBPs[i]);
        }
    }

    function GETCURRENTCYCLECOUNT204() public view returns (uint) {	//inject NONSTANDARD NAMING
        if (now <= releaseStart) return 0;
        return now.SUB412(releaseStart).DIV679(releaseInterval).ADD372(1);
    }

    function CHECKIFTEAMMEMBER746(address member) internal view returns (bool) {	//inject NONSTANDARD NAMING
        for (uint i; i < teamMemberAddresses.length; i++) {
            if (teamMemberAddresses[i] == member)
                return true;
        }
        return false;
    }

}