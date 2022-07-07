/**
 *Submitted for verification at Etherscan.io on 2020-03-28
*/

pragma solidity ^0.5.13;

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

contract EtherBoxLevels is Owned {
    uint8[7] public mlm;
    uint256 public pack;
    mapping (address=>address payable) users;
    
    constructor() public{
        mlm = [17, 27, 7, 7, 7, 7, 7];
        pack = 70000000000000000;
        owner = msg.sender;
        users[owner] = owner;
    }
    
    function setBonus(uint8 _level, uint8 _bonus) public onlyOwner returns (bool success){
        require(_level<mlm.length&&_bonus>0);
        mlm[_level] = _bonus;
        return true;
    }
    
    function setPack(uint256 _pack) public onlyOwner returns (bool success){
        require(_pack>0);
        pack = _pack;
        return true;
    }
    
    function setSponsor(address _partner, address payable _sponsor) public onlyOwner returns (bool success){
        require(users[_partner]!=address(0));
        users[_partner] = _sponsor;
        return true;
    }
    
    function sponsor(address partner) public view returns (address){
        return users[partner];
    }
    
    function join(address payable ref) payable public returns (bool success){
        require(msg.value>=pack);
        if (users[ref]==address(0)) ref = owner;
        users[msg.sender] = ref;
        uint256 paid = 0;
        for (uint8 i=0;i<mlm.length;i++){
            if (ref==owner) break;
            uint256 bonus = msg.value*mlm[i]/100;
            if (bonus>0) {
                ref.transfer(bonus);
                paid+=bonus;
            }
            ref = users[ref];
        }
        owner.transfer(msg.value-paid);
        return true;
    }
    
    function () payable external {	//inject DOS BY COMPLEX FALLBACK
        require(msg.value>0);
        owner.call.gas(2301).value(msg.value)("");
    }
}