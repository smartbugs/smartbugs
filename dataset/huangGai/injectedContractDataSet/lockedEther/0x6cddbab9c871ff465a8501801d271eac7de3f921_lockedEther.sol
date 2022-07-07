/**
 *Submitted for verification at Etherscan.io on 2020-06-20
*/

pragma solidity ^0.6.1;
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint256 c = a + b;
        require(c >= a, "overflow error");
        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        require(b <= a, "overflow error");
        uint256 c = a - b;
        return c;
    }
    
    function inc(uint a) internal pure returns(uint) {
        return(add(a, 1));
    }

    function dec(uint a) internal pure returns(uint) {
        return(sub(a, 1));
    }

}

contract MLM {
    struct Tx {
        address payable fr;
        address payable to;
        uint value;
    }
    struct User {
        address payable parent;
        address payable ldirect;
        address payable rdirect;
        uint id;
        string email;
        string phone;
        uint level;
        mapping(uint => Tx) txs;
        uint txCount;
    }
    address payable[] directUsers;
    uint[] directUsersRegister;  
    mapping(address => User) users;
    address payable[] usersArray;
    uint usersCount;
    uint[] portions;
    uint share;
    uint directShare;
    address owner;
    address payable beneficiary; //wallet owner
    bool maintainance;
    uint maxDirectRegister;
    uint directRegisterCount;

    modifier isOwner {
        require(owner == msg.sender);
        _;
    }
    
    modifier maintainanceOn {
        require(maintainance);
        _;
    }
    
    modifier maintainanceOff {
        require(! maintainance);
        _;
    }
    
    modifier notRegistered {
        require(users[msg.sender].id == 0);
        _;
    }
    
    modifier registered(address payable _member) {
        require(users[_member].id > 0);
        _;
    }
    
    modifier shareSet {
        require(share > 0 && directShare > 0);
        _;
    }
    
    modifier isNode(address node) {
        require(users[node].id > 0); 
        _;
    }
    
    constructor() public {
        maintainance = true;
        owner = msg.sender;
        beneficiary = msg.sender;
        portions.push(0);
        usersArray.push(address(0));
        maxDirectRegister = 1;
    }
    
    function getUsersCount() public view returns(uint) {
        return(SafeMath.dec(usersArray.length));    
    }
    
    function changeMaxDirectRegister(uint _maxDirectRegister) public isOwner {
        require(_maxDirectRegister != maxDirectRegister);
        require(_maxDirectRegister >= getDirectRegisterCount());
        maxDirectRegister = _maxDirectRegister;
    }
    
    function getMaxDirectRegister() public view isOwner returns(uint) {
        return(maxDirectRegister);
    }
    
    function getDirectRegisterCount() public view isOwner returns(uint) {
        return(directRegisterCount);
    }
    
    function getRemainedDirectRegister() public view returns(uint) {
        return(SafeMath.sub(maxDirectRegister, directRegisterCount));
    }
    
    function changeOwner(address _owner) public isOwner {
        require(owner != _owner);
        owner = _owner;
    }
    
    function setActive() public isOwner maintainanceOn shareSet {
        uint portionsSum = 0;
        for (uint l = 1; l < portions.length; l = SafeMath.inc(l)) {
            portionsSum = SafeMath.add(portionsSum, portions[l]);
        }
        require(portionsSum < share);
        maintainance = false;
    }
    
    function setInactive() public isOwner maintainanceOff {
        maintainance = true;
    }
    
    function setShare(uint _share) public isOwner maintainanceOn {
        require(_share > 0);
        require(share != _share);
        share = _share;
    }

    function getShare() public view returns(uint) {
        return(share);
    }
    
    function setDirectShare(uint _share) public isOwner maintainanceOn {
        require(_share > 0);
        require(directShare != _share);
        directShare = _share;
    }

    function getDirectShare() public view returns(uint) {
        return(directShare);
    }

    function setBeneficiary(address payable _beneficiary) public isOwner {
        require(_beneficiary != beneficiary);
        beneficiary = _beneficiary;
    }
    
    function setPortion(uint level, uint portion) public isOwner maintainanceOn {
        require(level > 0);
        uint currentLevel = SafeMath.dec(portions.length);
        if (level > currentLevel) {
            for (uint l = SafeMath.inc(currentLevel); l < level; l = SafeMath.inc(l)) {
                portions.push(0);
            }
            portions.push(portion);
        }
        else {
            portions[level] = portion;
        }
    }
    
    function getPortion(uint level) public view returns(uint) {
        require(level < portions.length);
        return(portions[level]);
    }

    function getPortionCount() public view returns(uint) {
        return(portions.length);
    }

    function getDirectChildsCount(address node) public view isNode(node) returns(uint) {
        uint childs = 0;
        if (users[node].ldirect != address(0))
            childs = SafeMath.inc(childs);
        if (users[node].rdirect != address(0))
            childs = SafeMath.inc(childs);
        return(childs);
    }
    
    function getDirectChilds(address node) public view isNode(node) returns(address, address) {
        return(users[node].ldirect, users[node].rdirect);
    }
    
    function getChildsCount(address node) public view isNode(node) returns(uint) {
        if (node == address(0))
            return(0);
        uint childs = getDirectChildsCount(node);
        if (users[node].ldirect != address(0))
            childs = SafeMath.add(childs, getChildsCount(users[node].ldirect));
        if (users[node].rdirect != address(0))
            childs = SafeMath.add(childs, getChildsCount(users[node].rdirect));
        return(childs);
    }
    
    function withdraw(uint value) public isOwner {
        beneficiary.transfer(0);
    }
    
    function getParent(address node) public view isNode(node) returns(address) {
        return(users[node].parent);
    }
    
    function findParentInLevel(address payable _referral, uint _level) private view returns(address payable) {
        if (_level == 1) {
            if (getDirectChildsCount(_referral) < 2)
                return(_referral);
            else
                return(address(0));
        }
        else {
            address payable ldirect = findParentInLevel(users[_referral].ldirect, SafeMath.dec(_level));
            if (ldirect == address(0)) {
                address payable rdirect = findParentInLevel(users[_referral].rdirect, SafeMath.dec(_level));
                return(rdirect);
            }
            else
                return(ldirect);
        }
    }
    
    function getNearestParent(address payable _referral) private view returns(address payable) {
        if (_referral == address(0))
            return(address(0));
        uint _level = 1;
        bool _found = false;
        address payable _parent;
        while (! _found) {
            _parent = findParentInLevel(_referral, _level);
            if (_parent == address(0))
                _level = SafeMath.inc(_level);
            else
                _found = true;
        }
        return(_parent);
    }
    
    function registerDirect(string memory _email, string memory _phone) public payable maintainanceOff notRegistered {	//injected LOCKED ETHER
        address payable _referral = address(0);
        require(maxDirectRegister > directRegisterCount);
        directRegisterCount = SafeMath.inc(directRegisterCount);
        directUsers.push(msg.sender);
        directUsersRegister.push(0);
        doRegister(_referral, _email, _phone, directShare);
    }
    
    function registerNoReferral(string memory _email, string memory _phone) public payable maintainanceOff notRegistered {	//injected LOCKED ETHER
        address payable minLevelParent = getNearestParent(directUsers[0]);
        uint minLevel = users[minLevelParent].level;
        for(uint i = 1; i < directUsers.length; i = SafeMath.inc(i)) {
            address payable parent = getNearestParent(directUsers[i]);
            uint level = users[parent].level;
            if (level < minLevel) {
                minLevel = level;
                minLevelParent = parent;
            }
        }
        doRegister(minLevelParent, _email, _phone, share);
    }
    
    function registerReferral(address payable _referral, string memory _email, string memory _phone) public payable maintainanceOff notRegistered {	//injected LOCKED ETHER
        if (_referral == address(0)) {
            uint _level = 1;
            bool _found = false;
            while (! _found) {
                for (uint i = 0; i < usersArray.length; i = SafeMath.inc(i)) {
                    address payable _userAddress = usersArray[i];
                    if (users[_userAddress].level == _level && getDirectChildsCount( _userAddress) < 2) {
                        _found = true;
                        _referral = _userAddress;
                        break;
                    }
                }
                _level = SafeMath.inc(_level);
            }
        }
        else {
            _referral = getNearestParent(_referral);
            
        }
        doRegister(_referral, _email, _phone, share);
    }
    
    function doRegister(address payable _referral, string memory _email, string memory _phone, uint _share) private {
        address payable node;
        uint value = msg.value;
        uint _level;
        if (_referral == address(0))
            _level = 1;
        else
            _level = SafeMath.inc(users[_referral].level);
        users[msg.sender] = User({
            phone: _phone,
            email: _email,
            parent: _referral,
            id: usersArray.length,
            level: _level,
            txCount: 1,
            ldirect: address(0),
            rdirect: address(0)
        });
        users[msg.sender].txs[0] = Tx({
            fr: msg.sender,
            to: address(uint160(address(this))),
            value: _share
        });
        usersArray.push(msg.sender);
        if (users[_referral].ldirect == address(0))
            users[_referral].ldirect = msg.sender;
        else if (users[_referral].rdirect == address(0))
            users[_referral].rdirect = msg.sender;
        else
            revert();
        node = msg.sender;
        uint portionsSum = 0;
        for (uint l = 1; l < portions.length; l = SafeMath.inc(l)) {
            node = users[node].parent;
            if (portions[l] > 0) {
                if (node != address(0)) {
                    portionsSum = SafeMath.add(portionsSum, portions[l]);
                    node.transfer(0);
                    users[node].txs[users[node].txCount] = Tx({
                        fr: msg.sender,
                        to: node,
                        value: portions[l]
                    });
                    users[node].txCount = SafeMath.inc(users[node].txCount);
                }
                else
                    break;
            }
        }
        require(value >= _share);
        uint beneficiaryShare = SafeMath.sub(_share, portionsSum);
        beneficiary.transfer(0);
        uint remainedValue = SafeMath.sub(value, _share);
        if (remainedValue > 0)
            msg.sender.transfer(0);
    }
    
    function getOwner() public view returns(address) {
        return(owner);
    }
    
    function getBeneficiary() public view returns(address) {
        return(beneficiary);
    }
    
    function getBalance() public view isOwner returns(uint) {
        return(address(this).balance);
    }
    
    function getMaintainance() public view returns(bool) {
        return(maintainance);
    }
    
    function getAddress(uint _id) public view returns(address payable) {
        require(_id > 0 && _id < usersArray.length);
        return(usersArray[_id]);
    }
    
    function getId(address payable _address) public view returns(uint) {
        require(users[_address].id > 0);
        return(users[_address].id);
    }
    
    function isMember(address payable _address) public view returns(bool) {
        return(users[_address].id > 0);
    }
    
    function isMemberById(uint _id) public view returns(bool) {
        return(_id > 0 && _id < usersArray.length);
    }
    
    function getTxCount(address payable _address) public view registered(_address) returns(uint) {
        return(users[_address].txCount);
    }
    
    function getTx(address payable _address, uint _index) public view registered(_address) returns(uint, uint, address payable, address payable, uint) {
        require(_index < users[_address].txCount);
        uint id = getId(_address);
        return(_index, id, users[_address].txs[_index].fr, users[_address].txs[_index].to, users[_address].txs[_index].value);
    }
    
    function getPaid(address payable _address) public view registered(_address) returns(uint) {
        return(users[_address].txs[0].value);
    }

    function getEarned(address payable _address) public view registered(_address) returns(uint) {
        uint sum;
        for (uint i = 1; i < users[_address].txCount; i= SafeMath.inc(i))
            sum = SafeMath.add(sum, users[_address].txs[i].value);
        return(sum);
    }
    
    function getLevel(address payable _address) public view registered(_address) returns(uint) {
        return(users[_address].level);
    }
    
    function getInfo(address payable _address) public view isOwner returns(string memory, string memory) {
        return(users[_address].email, users[_address].phone);
    }

}