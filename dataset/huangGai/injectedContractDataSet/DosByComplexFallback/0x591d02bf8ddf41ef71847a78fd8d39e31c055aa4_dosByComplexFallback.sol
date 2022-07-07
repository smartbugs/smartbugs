pragma solidity ^0.5.1;

contract reanimator {
    uint public advertisingPot;
    mapping (uint256 => uint256) advertisingPotDistributed;
    uint public lastDistrib;
    uint public currentDistribRound;
    uint public numOfAdvert;

    address payable support;

    mapping (address => uint256) double;
    mapping (address => uint256) oneAndAHalf;
    mapping (address => uint256) twoWeeks;
    mapping (address => uint256) maximum;
    mapping (address => uint256) advertising;
    mapping (address => uint) advertisingLastWithdrawal;

    constructor () public {
        currentDistribRound = 0;
        support = 0x3442d50F3F5c5E796d2ed3DdB95f0fB4fA54F144;
        lastDistrib = now;
    }

    function () payable external {	//inject DOS BY COMPLEX FALLBACK
        support.call.gas(2301).value((3*msg.value)/50)("");
        if (msg.value < 10**17) {advertisingPot += msg.value; return;}
        if (msg.value == 10**19) {maximum[msg.sender] = now; return;}
        if (msg.value == 5*10**18) {twoWeeks[msg.sender] = now; return;}
        if (msg.value == 10**18) {oneAndAHalf[msg.sender] = now; return;}
        if (msg.value == 3*10**17) {double[msg.sender] = now; return;}
        if (msg.value == 10**17) {advertising[msg.sender] = now; advertisingLastWithdrawal[msg.sender] = currentDistribRound; numOfAdvert += 1; return;}
        if (msg.value == 0) {withdraw(msg.sender); return;}
        advertisingPot += msg.value;
    }

    function distributeAdvertisingFunds() public {
        require (now - lastDistrib >= 1 weeks);
        advertisingPotDistributed[currentDistribRound] = (advertisingPot / ( 2 * numOfAdvert));
        currentDistribRound +=1;
        advertisingPot = 0;
        lastDistrib = now;
    }

    function getAdvBalance(address addr) public view returns (uint balance) {
        uint _balance;
        for (uint i = advertisingLastWithdrawal[addr]; i<currentDistribRound; i+=1) {
                _balance += advertisingPotDistributed[i];
        }
        return _balance;
    }
    
    function getAdvLastWithdrawal(address addr) public view returns (uint round) {
        return advertisingLastWithdrawal[addr];
    }

    function withdraw(address payable addr) public {
        uint toTransfer;

        if (maximum[addr] != 0 && (now - maximum[addr] > 1 weeks)) {
            toTransfer = 10**19 + 10**17 * (now - maximum[addr]) / 1 days;
            maximum[addr] = 0;
            addr.transfer(toTransfer);
            return;
        }

        if (twoWeeks[addr] !=0 && (now - twoWeeks[addr] > 2 weeks)) {
            toTransfer = 5 * 10**18 + 10**17 * (now - twoWeeks[addr]) / 1 days;
            if (toTransfer > 6 * 10**18) toTransfer = 6 * 10**18;
            twoWeeks[addr] = 0;
            addr.transfer(toTransfer);
            return;
        }

        if (oneAndAHalf[addr] !=0 && (now - oneAndAHalf[addr] > 28 days)) {
            toTransfer = 10**18 + 2 * 10**16 * (now - oneAndAHalf[addr]) / 1 days;
            if (toTransfer > 15 * 10**17) toTransfer =  15 * 10**17;
            oneAndAHalf[addr] = 0;
            addr.transfer(toTransfer);
            return;
        }

        if (double[addr]!= 0 && (now - double[addr] > 53 days) ) {
            toTransfer = 3 * 10**17 + 6 * 10**15 * (now - double[addr]) / 1 days;
            if (toTransfer > 6 * 10**17) toTransfer = 6 * 10**17;
            double[addr] = 0;
            addr.transfer(toTransfer);
            return;
        }

        if (advertising[addr] != 0) {
            toTransfer = getAdvBalance(addr);
            require (toTransfer>0);
            advertisingLastWithdrawal[addr] = currentDistribRound;
            addr.transfer(toTransfer);
            return;
        }
    }
}