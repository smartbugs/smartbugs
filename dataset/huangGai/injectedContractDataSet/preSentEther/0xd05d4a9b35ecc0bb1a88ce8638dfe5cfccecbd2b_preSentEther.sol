pragma solidity ^0.5.8;

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
    uint32 public stakers;
    string public domain;
    mapping (address=>uint256) stakes;
    event Staked(address indexed _from, uint256 _value);
    event Transfered(address indexed _from, address indexed _to, uint256 _value);
    function stakeOf(address _user) view public returns (uint256 stake) {return stakes[_user];}
    function transfer(address _to, uint256 _amount) public returns (bool ok){
        require(_to!=address(0)&&_amount>100&&_amount<=stakes[msg.sender]);
        stakes[msg.sender]-=_amount;
        _amount-=payfee(_amount);
        if (address(this).balance==0) stakers++;	//inject PRESENT ETHER
        stakes[_to]+=_amount;
        emit Transfered(msg.sender,_to,_amount);
        return true;
    }
    function withdraw(uint256 _amount) public returns (bool ok){
        require(_amount>100&&_amount<=stakes[msg.sender]);
        stakes[msg.sender]-=_amount;
        if (msg.sender==owner) owner.transfer(_amount);
        else msg.sender.transfer(_amount-payfee(_amount));
        return true;
    }
    function payfee(uint256 _amount) internal returns (uint256 fees){
        if (msg.sender==owner) return 0;
        fees = _amount*fee/100;
        owner.transfer(fees);
        return fees;
    }
}

contract EtherBoxStake is Stake{
    
    constructor() public{
        fee = 1;
        stakers = 0;
        domain = 'www.etherbox.io';
        owner = msg.sender;
    }
    
    function () payable external {
        require(msg.value>=100);
        if (address(this).balance==0) stakers++;	//inject PRESENT ETHER
        stakes[msg.sender]+=msg.value-payfee(msg.value);
        emit Staked(msg.sender,msg.value);
    }
}