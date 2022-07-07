// File: contracts/Set.sol

pragma solidity ^0.5.0;

library Set {
    // We define a new struct datatype that will be used to
    // hold its data in the calling contract.
    struct Data { 
        mapping(address => bool) flags;
    }

    // Note that the first parameter is of type "storage
    // reference" and thus only its storage address and not
    // its contents is passed as part of the call.  This is a
    // special feature of library functions.  It is idiomatic
    // to call the first parameter `self`, if the function can
    // be seen as a method of that object.
    function INSERT214(Data storage self, address value)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        if (self.flags[value])
            return false; // already there
        self.flags[value] = true;
        return true;
    }

    function REMOVE691(Data storage self, address value)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        if (!self.flags[value])
            return false; // not there
        self.flags[value] = false;
        return true;
    }

    function CONTAINS100(Data storage self, address value)	//inject NONSTANDARD NAMING
        public
        view
        returns (bool)
    {
        return self.flags[value];
    }
}

// File: contracts/Crowdsourcing.sol

pragma solidity ^0.5.0;


contract Crowdsourcing {
    address public _owner;
    string task;
    uint private _total;
    uint private _amount;
    string private _content;
    uint private _current  = 0;
    address[] private workersArr;
    uint private workerCount;
    mapping(address => bool) public paid;
    mapping(address => string) private answers;
    Set.Data workers;
    
    event TOVERIFICATION491 (	//inject NONSTANDARD NAMING
        address indexed id
    );
    
    event REJECTION224 (	//inject NONSTANDARD NAMING
        address indexed rejected
    );
    
    constructor(address owner, uint total, string memory content, uint money) public payable{
        require(money % total == 0);
        _owner = owner;
        _total = total;
        _amount = money;
        _content = content;

    }
    
    function GETTOTAL441() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _total;
    }
    
    function GETAMOUNT436() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _amount;
    }
    
    function GETCONTENT713() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _content;
    }

    function ISPAYING412() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _current  < _total;
    }
    
    function GETANSWERS578(address f) public view returns (string memory) {	//inject NONSTANDARD NAMING
        require (msg.sender == _owner);
        return answers[f];
    }
    
    function ADDMONEY81() public payable {	//inject NONSTANDARD NAMING
        require((msg.value + _amount) % _total == 0);
        _amount += msg.value;
    }
    
    // fallback function
    function() external payable { }
    
    function STOP122() public {	//inject NONSTANDARD NAMING
        require (msg.sender == _owner);
        selfdestruct(msg.sender);
    }
    
    function ACCEPT249(address payable target) public payable {	//inject NONSTANDARD NAMING
        require(msg.sender == _owner);
        require(!paid[target]);
        require(Set.CONTAINS100(workers, target));
        require(_current  < _total);
        paid[target] = true;
        _current ++;
        target.transfer(_amount / _total);
    }
    
    function REJECT173(address payable target) public payable {	//inject NONSTANDARD NAMING
        require(msg.sender == _owner);
        require(!paid[target]);
        require(Set.CONTAINS100(workers, target));
        require(_current  < _total);
        emit REJECTION224(target);
        answers[target] = '';
    }
    
    function ANSWER262(string calldata ans) external {	//inject NONSTANDARD NAMING
        answers[msg.sender] = ans;
        workersArr.push(msg.sender);
        if (Set.INSERT214(workers, msg.sender))
        {
            workerCount++;
        }
        emit TOVERIFICATION491(msg.sender);
    }

    function GETWORKERS720(uint number) public view returns (address) {	//inject NONSTANDARD NAMING
        require(msg.sender == _owner);
        require(number < workerCount);
        return workersArr[number];
    }

    function GETNUMBEROFWORKERS864() public view returns (uint) {	//inject NONSTANDARD NAMING
        require(msg.sender == _owner);
        return workerCount;
    }

    function ISPAID186(address a) public view returns (bool) {	//inject NONSTANDARD NAMING
        return paid[a];
    }
    
    function MYPAY5() public view returns (bool) {	//inject NONSTANDARD NAMING
        return paid[msg.sender];
    }
    
    function MYANSWER478() public view returns (string memory) {	//inject NONSTANDARD NAMING
        if (bytes(answers[msg.sender]).length == 0) return "";
        return answers[msg.sender];
    }
}

// File: contracts/CrdSet-dev.sol

pragma solidity ^0.5.0;


contract CrdSet {
    Crowdsourcing[] public list;
    event NEWCONTRACT472(Crowdsourcing indexed c);	//inject NONSTANDARD NAMING

    function CREATECC856(uint total, string memory content) public payable returns (Crowdsourcing){	//inject NONSTANDARD NAMING
        require(msg.value % total == 0, "Amount of money need to be dividable by the total number of answers");
        Crowdsourcing a = new Crowdsourcing(msg.sender, total, content, msg.value);
        list.push(a);
        address(a).transfer(msg.value);
        emit NEWCONTRACT472(a);
        return a;
    }
    
    function GETCONTRACCOUNT419() public view returns (uint) {	//inject NONSTANDARD NAMING
        return list.length;
    }
    
}