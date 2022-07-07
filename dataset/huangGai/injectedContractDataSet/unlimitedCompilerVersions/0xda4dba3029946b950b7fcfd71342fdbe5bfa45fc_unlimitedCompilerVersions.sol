pragma solidity ^0.5.8;	//inject UNLIMITED COMPILER VERSIONS

contract Owned {
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    address payable owner;
    address payable newOwner;
    function changeOwner(address payable _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        if (msg.sender == newOwner) {
            owner = newOwner;
        }
    }
}

contract Stake is Owned {
    uint8 public fee;
    uint32 public users;
    string domain;
    mapping (address=>uint256) stakes;
    event Staked(address indexed _from, uint256 _value);
    event Transfered(address indexed _from, address indexed _to, uint256 _value);
    event Withdrawn(address indexed _from, uint256 _value);
    function stakeOf(address _user) view public returns (uint256 stake) {return stakes[_user];}
    function transferStake(address _from, address _to, uint256 _amount) public onlyOwner returns (bool ok){
        require(_from!=address(0)&&_to!=address(0)&&_amount>0&&_amount<=stakes[_from]);
        stakes[_from]-=_amount;
        emit Transfered(_from,_to,_amount);
        uint256 fees = _amount*fee/100;
        _amount-=fees;
        stakes[_to]+=_amount;
        owner.transfer(fees);
        return true;
    }
    function withdrawStake(address payable _from, uint256 _amount) public onlyOwner returns (bool ok){
        require(_from!=address(0)&&_amount>0&&_amount<=stakes[_from]);
        stakes[_from]-=_amount;
        emit Withdrawn(_from,_amount);
        if (_from==owner) owner.transfer(_amount);
        else {
            uint256 fees = _amount*fee/100;
            _amount-=fees;
            _from.transfer(_amount);
            owner.transfer(fees);
        }
        return true;
    }
}

contract EtherBox is Stake{
    
    constructor() public{
        fee = 1;
        users = 0;
        domain = 'www.etherbox.io';
        owner = msg.sender;
    }
    
    function () payable external {
        require(msg.value>0);
        if (stakes[msg.sender]==0) users++;
        stakes[msg.sender]+=msg.value;
        emit Staked(msg.sender,msg.value);
    }
}