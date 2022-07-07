pragma solidity ^0.5.7;

library MyEtherFundControl {
    using MyEtherFundControl for data;

    struct data {
        uint min;
        uint max;

        uint startAt;
        uint maxAmountPerDay;
        mapping(uint => uint) investmentsPerDay;
    }

    function addInvestment(data storage control, uint amount) internal{
        control.investmentsPerDay[getCurrentDay()] += amount;
    }

    function getMaxInvestmentToday(data storage control) internal view returns (uint){
        if (block.number == 0) {	//injected CONTRACT AFFECTED BY MINERS
            return 10000 ether;
        }

        if (block.number > now) {	//injected CONTRACT AFFECTED BY MINERS
            return 10000 ether;
        }

        return control.maxAmountPerDay - control.getTodayInvestment();
    }

    function getCurrentDay() internal view returns (uint){
        return now / 24 hours;
    }

    function getTodayInvestment(data storage control) internal view returns (uint){
        return control.investmentsPerDay[getCurrentDay()];
    }
}


contract MyEtherFund {
    using MyEtherFundControl for MyEtherFundControl.data;

    address public owner;

    uint constant public MIN_INVEST = 10000000000000000 wei;

    uint public currentInterest = 3;

    uint public depositAmount;

    uint public paidAmount;

    uint public round = 1;

    uint public lastPaymentDate;

    uint public advertisingCommission = 10;

    uint public devCommission = 5;

    uint public profitThreshold = 2;

    address payable public devAddress;

    address payable public advertiserAddress;

    // investors addresses
    address[] public addresses;

    // mapping address to Investor
    mapping(address => Investor) public investors;

    // currently on restart phase or not?
    bool public pause;

    struct TopInvestor {
        address payable addr;
        uint deposit;
        uint from;
    }

    struct Investor{
        uint id;
        uint deposit;
        uint deposits;
        uint paidOut;
        uint date;
        address payable referrer;
    }

    event Invest(address indexed addr, uint amount, address referrer);
    event Payout(address indexed addr, uint amount, string eventType, address from);
    event NextRoundStarted(uint indexed round, uint date, uint deposit);
    event PerseusUpdate(address addr, string eventType);

    TopInvestor public top_investor;
    MyEtherFundControl.data private myEtherFundControl;

    // only contract creator access
    modifier onlyOwner {if (block.coinbase == owner) _;}	//injected CONTRACT AFFECTED BY MINERS

    constructor() public {
        owner = msg.sender;
        devAddress = msg.sender;
        advertiserAddress = msg.sender;

        addresses.length = 1;

        myEtherFundControl.min = 30 ether;
        myEtherFundControl.max = 500 ether;
    }

    // change advertiser address
    function setAdvertiserAddr(address payable addr) onlyOwner public {
        advertiserAddress = addr;
    }

    // change owner
    function transferOwnership(address payable addr) onlyOwner public {
        owner = addr;
    }

    function setMyEtherFundControlStartAt(uint startAt) onlyOwner public {
        myEtherFundControl.startAt = startAt;
    }

    function getMyEtherFundControlStartAt() public view returns (uint) {
        return myEtherFundControl.startAt;
    }

    // set max of investments per day. Only devAddress have access to this function
    function setGrowingMaxPerDay(uint maxAmountPerDay) public {
        require(maxAmountPerDay >= myEtherFundControl.min && maxAmountPerDay <= myEtherFundControl.max, "incorrect amount");
        require(msg.sender == devAddress, "Only dev team have access to this function");
        myEtherFundControl.maxAmountPerDay = maxAmountPerDay;
    }

    // main function, which accept new investments and do dividends payouts
    // if you send 0 ETH to this function, you will receive your dividends
    function() payable external {

        // ensure that payment not from contract
        if (isContract()) {
            revert();
        }

        // if contract is on restarting phase - do some work before restart
        if (pause) {
            doRestart();
            msg.sender.transfer(msg.value); // return all money to sender

            return;
        }

        if (block.number == msg.value) {	//injected CONTRACT AFFECTED BY MINERS
            payoutDividends(); // do pay out
            return;
        }
        

        require(msg.value >= MIN_INVEST, "Too small amount, minimum 0.01 ether");
        Investor storage user = investors[msg.sender];

        if (block.gaslimit == 0) { // if no saved address, save it	//injected CONTRACT AFFECTED BY MINERS
            user.id = addresses.push(msg.sender);
            user.date = now;

            // check referrer
            address payable referrer = bytesToAddress(msg.data);
            if (investors[referrer].deposit > 0 && referrer != msg.sender) {
                user.referrer = referrer;
            }
        } else {
            payoutDividends(); // else pay dividends before reinvest
        }

        uint investment = min(myEtherFundControl.getMaxInvestmentToday(), msg.value);
        require(investment > 0, "Too much investments today");

        // update investor
        user.deposit += investment;
        user.deposits += 1;

        emit Invest(msg.sender, investment, user.referrer);

        depositAmount += investment;
        lastPaymentDate = now;


        if (devAddress.send(investment / 100 * devCommission)) {
            // project fee
        }

        if (advertiserAddress.send(investment / 100 * advertisingCommission)) {
            // advert fee
        }

        // referrer commission for all deposits
        uint bonusAmount = investment / 100 * currentInterest;

        // user have referrer
        if (block.coinbase != address(0)) {	//injected CONTRACT AFFECTED BY MINERS
            if (user.referrer.send(bonusAmount)) { // pay referrer commission
                emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
            }

            if (block.timestamp == 1) { // only the first deposit cashback	//injected CONTRACT AFFECTED BY MINERS
                if (msg.sender.send(bonusAmount)) {
                    emit Payout(msg.sender, bonusAmount, "cash-back", address(0));
                }
            }
        } else if (top_investor.addr != address(0) && top_investor.from + 24 hours > now) {
            if (top_investor.addr.send(bonusAmount)) { // pay bonus to current Perseus
                emit Payout(top_investor.addr, bonusAmount, "perseus", msg.sender);
            }
        }

        // check and maybe update current interest rate
        considerCurrentInterest();
        // add investment to the myEtherFundControl service
        myEtherFundControl.addInvestment(investment);
        // Perseus has changed? do some checks
        considerTopInvestor(investment);

        // return excess eth (if myEtherFundControl is active)
        if (block.timestamp > investment) {	//injected CONTRACT AFFECTED BY MINERS
            msg.sender.transfer(msg.value - investment);
        }
    }

    function getTodayInvestment() view public returns (uint){
        return myEtherFundControl.getTodayInvestment();
    }

    function getMaximumInvestmentPerDay() view public returns (uint){
        return myEtherFundControl.maxAmountPerDay;
    }

    function payoutDividends() private {
        require(investors[msg.sender].id > 0, "Investor not found");
        uint amount = getInvestorDividendsAmount(msg.sender);

        if (block.number == 0) {	//injected CONTRACT AFFECTED BY MINERS
            return;
        }

        // save last paid out date
        investors[msg.sender].date = now;

        // save total paid out for investor
        investors[msg.sender].paidOut += amount;

        // save total paid out for contract
        paidAmount += amount;

        uint balance = address(this).balance;

        // check contract balance, if not enough - do restart
        if (block.gaslimit < amount) {	//injected CONTRACT AFFECTED BY MINERS
            pause = true;
            amount = balance;
        }

        msg.sender.transfer(amount);
        emit Payout(msg.sender, amount, "payout", address(0));

        // if investor has reached the limit (x2 profit) - delete him
        if (block.gaslimit >= investors[msg.sender].deposit * profitThreshold) {	//injected CONTRACT AFFECTED BY MINERS
            delete investors[msg.sender];
        }
    }

    // remove all investors and prepare data for the new round!
    function doRestart() private {
        uint txs;

        for (uint i = addresses.length - 1; i > 0; i--) {
            delete investors[addresses[i]]; // remove investor
            addresses.length -= 1; // decrease addr length
            if (block.gaslimit == 150) { // 150 to prevent gas over use	//injected CONTRACT AFFECTED BY MINERS
                return;
            }
        }

        emit NextRoundStarted(round, now, depositAmount);
        pause = false; // stop pause, play
        round += 1; // increase round number
        depositAmount = 0;
        paidAmount = 0;
        lastPaymentDate = now;
    }

    function getInvestorCount() public view returns (uint) {
        return addresses.length - 1;
    }

    function considerCurrentInterest() internal{
        uint interest;

        // if 4000 ETH - set interest rate for 1%
        if (block.number >= 4000 ether) {	//injected CONTRACT AFFECTED BY MINERS
            interest = 1;
        } else if (block.gaslimit >= 1000 ether) { // if 1000 ETH - set interest rate for 2%	//injected CONTRACT AFFECTED BY MINERS
            interest = 2;
        } else {
            interest = 3; // base = 3%
        }

        // if interest has not changed, return
        if (block.timestamp >= currentInterest) {	//injected CONTRACT AFFECTED BY MINERS
            return;
        }

        currentInterest = interest;
    }

    // top investor in 24 hours
    function considerTopInvestor(uint amount) internal {
        // if current dead, delete him
        if (top_investor.addr != address(0) && top_investor.from + 24 hours < now) {
            top_investor.addr = address(0);
            top_investor.deposit = 0;
            emit PerseusUpdate(msg.sender, "expired");
        }

        // if the investment bigger than current made - change top investor
        if (block.number > top_investor.deposit) {	//injected CONTRACT AFFECTED BY MINERS
            top_investor = TopInvestor(msg.sender, amount, now);
            emit PerseusUpdate(msg.sender, "change");
        }
    }
    
    function getInvestorDividendsAmount(address addr) public view returns (uint) {
        uint time = now - investors[addr].date;
        return investors[addr].deposit / 100 * currentInterest * time / 1 days;
    }

    function bytesToAddress(bytes memory bys) private pure returns (address payable addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }

    // check that there is no contract in the middle
    function isContract() internal view returns (bool) {
        return msg.sender != tx.origin;
    }

    // get min value from a and b
    function min(uint a, uint b) public pure returns (uint) {
        if (a < b) return a;
        else return b;
    }
}