/**
 *Submitted for verification at Etherscan.io on 2020-09-25
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable {
    address internal owner;
    address internal newowner;
    address internal admin;
    address internal dev;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    
    modifier onlyNewOwner {
        require(msg.sender == newowner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newowner = _newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function takeOwnership() public onlyNewOwner {
        owner = newowner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }    
    
    function setAdmin(address _admin) public onlyOwner {
        admin = _admin;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setDev(address _dev) public onlyOwner {
        dev = _dev;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    modifier onlyAdmin {
        require(msg.sender == admin || msg.sender == owner);
        _;
    }
    
    modifier onlyDev {
        require(msg.sender == dev || msg.sender == admin || msg.sender == owner);
        _;
    }
}

abstract contract ContractConn{
    function transfer(address _to, uint _value) virtual public;
    function transferFrom(address _from, address _to, uint _value) virtual public;
    function balanceOf(address who) virtual public view returns (uint);
    function burn(uint256 _value) virtual public returns(bool);
}

contract Pledge is Ownable {

    using SafeMath for uint256;
    
    struct PledgeInfo {
        uint256 id;
        address pledgeor;
        string  coinType;
        uint256 amount;
        uint256 pledgeTime;
        uint256 pledgeBlock;
        uint256 ExpireBlock;
        bool    isValid;
    }
    
    ContractConn internal zild;
    
    uint256 internal pledgeBlock = 90000;
    uint256 internal pledgeBlockChange = 0;
    uint256 internal changePledgeTime;
    bool    internal needChangeTime = false; 
	uint256 internal burnCount = 0;
    uint256 internal totalPledge;
    
    mapping(address => PledgeInfo[]) internal zild_pledge;
    mapping(address => uint256) internal user_pledge_amount;

    event SetPledgeBlock(uint256 pblock,address indexed who,uint256 time);
    event EffectPledgeBlock(uint256 pblock,address indexed who,uint256 time);
    event WithdrawZILD(address indexed to,uint256 pamount,uint256 time);
    event NeedBurnPledge(address indexed to,uint256 pleid,uint256 pamount);
    event BurnPledge(address  indexed from,uint256 pleid,uint256 pamount);
    event PledgeZILD(address indexed from,uint256 pleid,uint256 pamount,uint256 bblock,uint256 eblock,uint256 time);
    
    constructor(address _zild) public {
        zild = ContractConn(_zild);
    }

    function setpledgeblock(uint256 _block) public onlyAdmin {
        require(_block > 0,"Pledge: New pledge time must be greater than 0");
        pledgeBlockChange = _block;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        changePledgeTime = block.number;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        needChangeTime = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit SetPledgeBlock(_block,msg.sender,now);
    }

    function effectblockchange() public onlyAdmin {
        require(needChangeTime,"Pledge: No new deposit time are set");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 currentTime = block.number;
        uint256 effectTime = changePledgeTime.add(pledgeBlock);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (currentTime < effectTime) return;
        pledgeBlock = pledgeBlockChange;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        needChangeTime = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit EffectPledgeBlock(pledgeBlockChange,msg.sender,now);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    

    function burn(uint256 _amount) public onlyAdmin returns(bool) {
        require(_amount > 0 || _amount < burnCount, "pledgeBurn1The amount exceeds the amount that should be burned");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        zild.burn(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        burnCount = burnCount.sub(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit BurnPledge(address(msg.sender),_amount,now);
        return true;
    }

    function pledgeZILD(uint256 _amount) public returns(uint256){
        zild.transferFrom(address(msg.sender), address(this), _amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint256 length = zild_pledge[msg.sender].length;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        zild_pledge[msg.sender].push(	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            PledgeInfo({
                id: length,
                pledgeor: msg.sender,
                coinType: "zild",
                amount: _amount,
                pledgeTime: now,
                pledgeBlock: block.number,
                ExpireBlock: block.number.add(pledgeBlock),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                isValid: true
            })
        );
        user_pledge_amount[msg.sender] = user_pledge_amount[msg.sender].add(_amount); 	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalPledge = totalPledge.add(_amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit PledgeZILD(msg.sender,length,_amount,block.number,block.number.add(pledgeBlock),now);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return length;
    }

    function invalidPledge(address _user, uint256 _id) public onlyDev {
        require(zild_pledge[_user].length > _id);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        zild_pledge[_user][_id].isValid = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function validPledge(address _user, uint256 _id) public onlyAdmin{
        require(zild_pledge[_user].length > _id);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        zild_pledge[_user][_id].isValid = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function pledgeCount(address _user)  view public returns(uint256) {
        require(msg.sender == _user || msg.sender == owner, "Pledge: Only check your own pledge records");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return zild_pledge[_user].length;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
 
     function pledgeAmount(address _user)  view public returns(uint256) {
        require(msg.sender == _user || msg.sender == owner, "Pledge: Only check your own pledge records");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return user_pledge_amount[_user];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function clearInvalidOrder(address _user, uint256 _pledgeId) public onlyAdmin{
        PledgeInfo memory pledgeInfo = zild_pledge[address(_user)][_pledgeId];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if(!pledgeInfo.isValid) {
            burnCount = burnCount.add(pledgeInfo.amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            user_pledge_amount[_user] = user_pledge_amount[_user].sub(pledgeInfo.amount); 	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            totalPledge = totalPledge.sub(pledgeInfo.amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            zild_pledge[address(_user)][_pledgeId].amount = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            emit NeedBurnPledge(_user,_pledgeId,pledgeInfo.amount);
        }
    }
 
    function withdrawZILD(uint256 _pledgeId) public returns(bool){
        PledgeInfo memory info = zild_pledge[msg.sender][_pledgeId]; 	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(block.number > info.ExpireBlock, "The withdrawal block has not arrived!");
        require(info.isValid, "The withdrawal pledge has been breached!");
        zild.transfer(msg.sender,info.amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        user_pledge_amount[msg.sender] = user_pledge_amount[msg.sender].sub(info.amount); 	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalPledge = totalPledge.sub(info.amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        zild_pledge[msg.sender][_pledgeId].amount = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit WithdrawZILD(msg.sender,zild_pledge[msg.sender][_pledgeId].amount,now);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }
}