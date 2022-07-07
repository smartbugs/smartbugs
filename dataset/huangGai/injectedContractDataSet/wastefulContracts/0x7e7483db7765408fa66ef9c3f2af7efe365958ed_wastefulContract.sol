pragma solidity ^0.5.1;

contract Owned {
    modifier onlyOwner() {
        require(msg.sender==owner);
        _;
    }
    address payable owner;
    address payable newOwner;
    function changeOwner(address payable _newOwner) public onlyOwner {
        newOwner=_newOwner;
    }
    function acceptOwnership() public {
        if (msg.sender==newOwner) {
            owner=newOwner;
        }
    }
}

contract ERC20 {
    function balanceOf(address _owner) view public returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
}

contract UnlockVideo is Owned{
    uint256 add;
    uint8 fee;
    uint8 bonus;
    address token;
    mapping (address=>uint256) donates;
    mapping (bytes32=>address) videos;
    mapping (address=>uint256) balances;
    event Donate(address indexed _owner, uint256 _amount);
        
    constructor() public{
        add = 5000000000000000;
        fee = 2;
        bonus = 10;
        token = 0xCD8aAC9972dc4Ddc48d700bc0710C0f5223fBCfa;
        owner = msg.sender;
    }
    
    function addVideo(bytes32 _id) public returns (bool success){
        require (videos[_id]==address(0x0) && balances[msg.sender]>=add);
        videos[_id] = msg.sender;
        balances[msg.sender] -= add;
        if (ERC20(token).balanceOf(address(this))>=bonus) ERC20(token).transfer(msg.sender, bonus);
        owner.transfer(add);
        return true;
    }
    
    function changeDonate(uint256 _donate) public returns (bool success){
        require(_donate>0);
        donates[msg.sender] = _donate;
        return true;
    }
    
    function donateVideo(bytes32 _id) public returns (bool success){
        require(videos[_id]!=address(0x0) && balances[msg.sender]>=donates[videos[_id]]);
        balances[videos[_id]] += donates[videos[_id]];
        balances[msg.sender] -= donates[videos[_id]];
        if (ERC20(token).balanceOf(address(this))>=bonus) ERC20(token).transfer(msg.sender, bonus);
        emit Donate(msg.sender, donates[videos[_id]]);
        return true;
    }
    
    function changeAdd (uint256 _add) onlyOwner public returns (bool success){
        require (_add>0);
        add=_add;
        return true;
    }
    
    function changeFee (uint8 _fee) onlyOwner public returns (bool success){
        require (_fee>0);
        fee=_fee;
        return true;
    }
    
    function changeBonus (uint8 _bonus) onlyOwner public returns (bool success){
        require (_bonus>0);
        bonus=_bonus;
        return true;
    }
    
    function getBalance(address _owner) view public returns (uint256 balance){
        return balances[_owner];
    }
    
    function withdrawEth(uint256 _amount) public returns (bool success){
        require(_amount>0 && balances[msg.sender]>=_amount);
        uint256 deduct = _amount*fee/100;
        owner.transfer(deduct);
        msg.sender.transfer(_amount-deduct);
        return true;
    }
    
    function () payable external {
        require(true);
        uint256 deduct = msg.value*fee/100;
        owner.transfer(deduct);
        balances[msg.sender]+=msg.value-deduct;
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
}