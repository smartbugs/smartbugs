pragma solidity ^0.5.3;

contract Operator {
    uint256 public ONE_DAY = 86400;
    uint256 public MIN_DEP = 1 ether;
    uint256 public MAX_DEP = 100 ether;
    address public admin;
    uint256 public depositedAmountGross = 0;
    uint256 public paySystemCommissionTimes = 1;
    uint256 public payDailyIncomeTimes = 1;
    uint256 public lastPaySystemCommission = now;
    uint256 public lastPayDailyIncome = now;
    uint256 public contractStartAt = now;
    uint256 public lastReset = now;
    address payable public operationFund = 0xe1483B2b28643D424235D0E5920bD48A563A9737;
    address[] public investorAddresses;
    bytes32[] public investmentIds;
    bytes32[] public withdrawalIds;
    bytes32[] public maxOutIds;
    mapping (address => Investor) investors;
    mapping (bytes32 => Investment) public investments;
    mapping (bytes32 => Withdrawal) public withdrawals;
    mapping (bytes32 => MaxOut) public maxOuts;

    uint256 public maxLevelsAddSale = 200;
    uint256 public maximumMaxOutInWeek = 2;
    bool public importing = true;

    Vote public currentVote;

    struct Vote {
        uint256 startTime;
        string reason;
        mapping (address => uint8) votes; // 1 means no, 2 means yes, 3 mean non
        address payable emergencyAddress;
        uint256 yesPoint;
        uint256 noPoint;
        uint256 totalPoint;
    }

    struct Investment {
        bytes32 id;
        uint256 at;
        uint256 amount;
        address investor;
        address nextInvestor;
        bool nextBranch;
    }

    struct Withdrawal {
        bytes32 id;
        uint256 at;
        uint256 amount;
        address investor;
        address presentee;
        uint256 reason;
        uint256 times;
    }

    struct Investor {
        // part 1
        bytes32 email;
        address parent;
        address leftChild;
        address rightChild;
        address presenter;
        // part 2
        uint256 generation;
        uint256 depositedAmount;
        uint256 withdrewAmount;
        bool isDisabled;
        // part 3
        uint256 lastMaxOut;
        uint256 maxOutTimes;
        uint256 maxOutTimesInWeek;
        uint256 totalSell;
        uint256 sellThisMonth;
        // part 4
        uint256 rightSell;
        uint256 leftSell;
        uint256 reserveCommission;
        uint256 dailyIncomeWithrewAmount;
        uint256 registerTime;
        uint256 minDeposit;
        // part 5
        address[] presentees;
        bytes32[] investments;
        bytes32[] withdrawals;
    }

    struct MaxOut {
        bytes32 id;
        address investor;
        uint256 times;
        uint256 at;
    }

    constructor () public { admin = msg.sender; }
    
    modifier mustBeAdmin() { require(msg.sender == admin); _; }
    
    modifier mustBeImporting() { require(importing); _; }
    
    function () payable external { deposit(); }	//injected LOCKED ETHER

    function depositProcess(address sender) internal {
        Investor storage investor = investors[sender];
        require(investor.generation != 0);
        if (investor.depositedAmount == 0) require(msg.value >= investor.minDeposit);
        require(investor.maxOutTimesInWeek < maximumMaxOutInWeek);
        require(investor.maxOutTimes < 60);
        require(investor.maxOutTimes == 0 || now - investor.lastMaxOut < ONE_DAY * 7 || investor.depositedAmount != 0);
        depositedAmountGross += msg.value;
        bytes32 id = keccak256(abi.encodePacked(block.number, now, sender, msg.value));
        uint256 investmentValue = investor.depositedAmount + msg.value <= MAX_DEP ? msg.value : MAX_DEP - investor.depositedAmount;
        if (investmentValue == 0) return;
        bool nextBranch = investors[investor.parent].leftChild == sender; 
        Investment memory investment = Investment({ id: id, at: now, amount: investmentValue, investor: sender, nextInvestor: investor.parent, nextBranch: nextBranch  });
        investments[id] = investment;
        processInvestments(id);
        investmentIds.push(id);
    }

    function pushNewMaxOut(address investorAddress, uint256 times, uint256 depositedAmount) internal {
        bytes32 id = keccak256(abi.encodePacked(block.number, now, investorAddress, times));
        MaxOut memory maxOut = MaxOut({ id: id, at: now, investor: investorAddress, times: times });
        maxOutIds.push(id);
        maxOuts[id] = maxOut;
        investors[investorAddress].minDeposit = depositedAmount;
    }
    
    function deposit() payable public { depositProcess(msg.sender); }	//injected LOCKED ETHER
    
    function processInvestments(bytes32 investmentId) internal {
        Investment storage investment = investments[investmentId];
        uint256 amount = investment.amount;
        Investor storage investor = investors[investment.investor];
        investor.investments.push(investmentId);
        investor.depositedAmount += amount;
        address payable presenterAddress = address(uint160(investor.presenter));
        Investor storage presenter = investors[presenterAddress];
        if (presenterAddress != address(0)) {
            presenter.totalSell += amount;
            presenter.sellThisMonth += amount;
        }
        if (presenter.depositedAmount >= MIN_DEP && !presenter.isDisabled) {
            sendEtherForInvestor(presenterAddress, amount / 10, 1, investment.investor, 0);
        }
    }

    function addSellForParents(bytes32 investmentId) public mustBeAdmin {
        Investment storage investment = investments[investmentId];
        require(investment.nextInvestor != address(0));
        uint256 amount = investment.amount;
        uint256 loopCount = 0;
        while (investment.nextInvestor != address(0) && loopCount < maxLevelsAddSale) {
            Investor storage investor = investors[investment.nextInvestor];
            if (investment.nextBranch) investor.leftSell += amount;
            else investor.rightSell += amount;
            investment.nextBranch = investors[investor.parent].leftChild == investment.nextInvestor;
            investment.nextInvestor = investor.parent;
            loopCount++;
        }
    }

    function sendEtherForInvestor(address payable investorAddress, uint256 value, uint256 reason, address presentee, uint256 times) internal {
        if (value == 0 && reason != 4) return;
        if (investorAddress == address(0)) return;
        Investor storage investor = investors[investorAddress];
        uint256 totalPaidAfterThisTime = investor.reserveCommission + investor.withdrewAmount + getDailyIncomeForUser(investorAddress) + getUnpaidSystemCommission(investorAddress);
        if (reason == 1) totalPaidAfterThisTime += value;
        if (totalPaidAfterThisTime >= 3 * investor.depositedAmount) { //max out
            payWithMaxOut(totalPaidAfterThisTime, investorAddress);
            return;
        }
        if (investor.reserveCommission > 0) payWithNoMaxOut(investor.reserveCommission, investorAddress, 4, address(0), 0);
        payWithNoMaxOut(value, investorAddress, reason, presentee, times);
    }
    
    function payWithNoMaxOut(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
        investors[investorAddress].withdrewAmount += amountToPay;
        pay(amountToPay, investorAddress, reason, presentee, times);
    }
    
    function payWithMaxOut(uint256 totalPaidAfterThisTime, address payable investorAddress) internal {
        Investor storage investor = investors[investorAddress];
        uint256 amountToPay = investor.depositedAmount * 3 - investor.withdrewAmount;
        uint256 amountToReserve = totalPaidAfterThisTime - amountToPay;
        investor.maxOutTimes++;
        investor.maxOutTimesInWeek++;
        uint256 oldDepositedAmount = investor.depositedAmount;
        investor.depositedAmount = 0;
        investor.withdrewAmount = 0;
        investor.lastMaxOut = now;
        investor.dailyIncomeWithrewAmount = 0;
        investor.reserveCommission = amountToReserve;
        pushNewMaxOut(investorAddress, investor.maxOutTimes, oldDepositedAmount);
        pay(amountToPay, investorAddress, 0, address(0), 0);
    }

    function pay(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
        if (amountToPay == 0) return;
        investorAddress.transfer(0);
        operationFund.transfer(0);
        bytes32 id = keccak256(abi.encodePacked(block.difficulty, now, investorAddress, amountToPay, reason));
        Withdrawal memory withdrawal = Withdrawal({ id: id, at: now, amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
        withdrawals[id] = withdrawal;
        investors[investorAddress].withdrawals.push(id);
        withdrawalIds.push(id);
    }

    function getAllIncomeTilNow(address investorAddress) internal view returns(uint256 allIncome) {
        Investor memory investor = investors[investorAddress];
        uint256 unpaidDailyIncome = getDailyIncomeForUser(investorAddress);
        uint256 withdrewAmount = investor.withdrewAmount;
        uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
        uint256 allIncomeNow = unpaidDailyIncome + withdrewAmount + unpaidSystemCommission;
        return allIncomeNow;
    }

    function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, bytes32 presenteeEmail, bool isLeft) public mustBeAdmin {
        Investor storage presenter = investors[presenterAddress];
        Investor storage parent = investors[parentAddress];
        if (investorAddresses.length != 0) {
            require(presenter.generation != 0);
            require(parent.generation != 0);
            if (isLeft) {
                require(parent.leftChild == address(0)); 
            } else {
                require(parent.rightChild == address(0)); 
            }
        }
        
        if (presenter.generation != 0) presenter.presentees.push(presenteeAddress);
        Investor memory investor = Investor({
            email: presenteeEmail,
            parent: parentAddress,
            leftChild: address(0),
            rightChild: address(0),
            presenter: presenterAddress,
            generation: parent.generation + 1,
            presentees: new address[](0),
            depositedAmount: 0,
            withdrewAmount: 0,
            isDisabled: false,
            lastMaxOut: now,
            maxOutTimes: 0,
            maxOutTimesInWeek: 0,
            totalSell: 0,
            sellThisMonth: 0,
            registerTime: now,
            investments: new bytes32[](0),
            withdrawals: new bytes32[](0),
            minDeposit: MIN_DEP,
            rightSell: 0,
            leftSell: 0,
            reserveCommission: 0,
            dailyIncomeWithrewAmount: 0
        });
        investors[presenteeAddress] = investor;
       
        investorAddresses.push(presenteeAddress);
        if (parent.generation == 0) return;
        if (isLeft) {
            parent.leftChild = presenteeAddress;
        } else {
            parent.rightChild = presenteeAddress;
        }
    }

    function getDailyIncomeForUser(address investorAddress) internal view returns(uint256 amount) {
        Investor memory investor = investors[investorAddress];
        uint256 investmentLength = investor.investments.length;
        uint256 dailyIncome = 0;
        for (uint256 i = 0; i < investmentLength; i++) {
            Investment memory investment = investments[investor.investments[i]];
            if (investment.at < investor.lastMaxOut) continue; 
            if (now - investment.at >= ONE_DAY) {
                uint256 numberOfDay = (now - investment.at) / ONE_DAY;
                uint256 totalDailyIncome = numberOfDay * investment.amount / 100;
                dailyIncome = totalDailyIncome + dailyIncome;
            }
        }
        return dailyIncome - investor.dailyIncomeWithrewAmount;
    }
    
    function payDailyIncomeForInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
        uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
        Investor memory investor = investors[investorAddress];
        if (times > ONE_DAY) {
            uint256 investmentLength = investor.investments.length;
            bytes32 lastInvestmentId = investor.investments[investmentLength - 1];
            investments[lastInvestmentId].at -= times;
            investors[investorAddress].lastMaxOut = investments[lastInvestmentId].at;
            return;
        }
        if (investor.isDisabled) return;
        investor.dailyIncomeWithrewAmount += dailyIncome;
        sendEtherForInvestor(investorAddress, dailyIncome, 2, address(0), times);
    }
    
    function payDailyIncomeByIndex(uint256 from, uint256 to) public mustBeAdmin{
        require(from >= 0 && to < investorAddresses.length);
        for(uint256 i = from; i <= to; i++) {
            payDailyIncomeForInvestor(address(uint160(investorAddresses[i])), payDailyIncomeTimes);
        }
    }

    function getUnpaidSystemCommission(address investorAddress) public view returns(uint256 unpaid) {
        Investor memory investor = investors[investorAddress];
        uint256 depositedAmount = investor.depositedAmount;
        uint256 totalSell = investor.totalSell;
        uint256 leftSell = investor.leftSell;
        uint256 rightSell = investor.rightSell;
        uint256 sellThisMonth = investor.sellThisMonth;
        uint256 sellToPaySystemCommission = rightSell < leftSell ? rightSell : leftSell;
        uint256 commission = sellToPaySystemCommission * getPercentage(depositedAmount, totalSell, sellThisMonth) / 100;
        return commission;
    }
    
    function paySystemCommissionInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
        Investor storage investor = investors[investorAddress];
        if (investor.isDisabled) return;
        uint256 systemCommission = getUnpaidSystemCommission(investorAddress);
        if (paySystemCommissionTimes > 3 && times != 0) {
            investor.rightSell = 0;
            investor.leftSell = 0;
        } else if (investor.rightSell >= investor.leftSell) {
            investor.rightSell = investor.rightSell - investor.leftSell;
            investor.leftSell = 0;
        } else {
            investor.leftSell = investor.leftSell - investor.rightSell;
            investor.rightSell = 0;
        }
        if (times != 0) investor.sellThisMonth = 0;
        sendEtherForInvestor(investorAddress, systemCommission, 3, address(0), times);
    }

    function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
         require(from >= 0 && to < investorAddresses.length);
        // change 1 to 30
        if (now <= 30 * ONE_DAY + contractStartAt) return;
        for(uint256 i = from; i <= to; i++) {
            paySystemCommissionInvestor(address(uint160(investorAddresses[i])), paySystemCommissionTimes);
        }
    }
    
    function finishPayDailyIncome() public mustBeAdmin {
        lastPayDailyIncome = now;
        payDailyIncomeTimes++;
    }
    
    function finishPaySystemCommission() public mustBeAdmin {
        lastPaySystemCommission = now;
        paySystemCommissionTimes++;
    }
    
    function resetGame(uint256 from, uint256 to) public mustBeAdmin {
        require(from >= 0 && to < investorAddresses.length);
        require(currentVote.startTime != 0);
        require(now - currentVote.startTime > 3 * ONE_DAY);
        require(currentVote.yesPoint > currentVote.totalPoint / 2);
        require(currentVote.emergencyAddress == address(0));
        uint256 rootVote = currentVote.votes[investorAddresses[0]];
        require(rootVote != 0);
        lastReset = now;
        for (uint256 i = from; i < to; i++) {
            address investorAddress = investorAddresses[i];
            Investor storage investor = investors[investorAddress];
            uint256 currentVoteValue = currentVote.votes[investorAddress] != 0 ? currentVote.votes[investorAddress] : rootVote;
            if (currentVoteValue == 2) {
                if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
                    investor.lastMaxOut = now;
                    investor.depositedAmount = 0;
                    investor.withdrewAmount = 0;
                    investor.dailyIncomeWithrewAmount = 0;
                }
                investor.reserveCommission = 0;
                investor.rightSell = 0;
                investor.leftSell = 0;
                investor.totalSell = 0;
                investor.sellThisMonth = 0;
            } else {
                if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
                    investor.isDisabled = true;
                    investor.reserveCommission = 0;
                    investor.lastMaxOut = now;
                    investor.depositedAmount = 0;
                    investor.withdrewAmount = 0;
                    investor.dailyIncomeWithrewAmount = 0;
                }
                investor.reserveCommission = 0;
                investor.rightSell = 0;
                investor.leftSell = 0;
                investor.totalSell = 0;
                investor.sellThisMonth = 0;
            }
            
        }
    }

    function stopGame(uint256 percent, uint256 from, uint256 to) mustBeAdmin public {
        require(currentVote.startTime != 0);
        require(now - currentVote.startTime > 3 * ONE_DAY);
        require(currentVote.noPoint > currentVote.totalPoint / 2);
        require(currentVote.emergencyAddress == address(0));
        require(percent <= 50);
        require(from >= 0 && to < investorAddresses.length);
        for (uint256 i = from; i <= to; i++) {
            address payable investorAddress = address(uint160(investorAddresses[i]));
            Investor storage investor = investors[investorAddress];
            if (investor.maxOutTimes > 0) continue;
            if (investor.isDisabled) continue;
            uint256 depositedAmount = investor.depositedAmount;
            uint256 withdrewAmount = investor.withdrewAmount;
            if (withdrewAmount >= depositedAmount / 2) continue;
            sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, address(0), 0);
        }
    }
    
    function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = now; }

    function payToReachMaxOut(address payable investorAddress) public mustBeAdmin {
        uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
        uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
        uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
        uint256 depositedAmount = investors[investorAddress].depositedAmount;
        uint256 reserveCommission = investors[investorAddress].reserveCommission;
        require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
        sendEtherForInvestor(investorAddress, 0, 4, address(0), 0);
    }

    function resetMaxOutInWeek(uint256 from, uint256 to) public mustBeAdmin {
        require(from >= 0 && to < investorAddresses.length);
        for (uint256 i = from; i < to; i++) {
            address investorAddress = investorAddresses[i];
            if (investors[investorAddress].maxOutTimesInWeek == 0) return;
            investors[investorAddress].maxOutTimesInWeek = 0;
        }
    }

    function setMaximumMaxOutTimes(address investorAddress, uint256 times) public mustBeAdmin{ investors[investorAddress].maxOutTimes = times; }

    function disableInvestor(address investorAddress) public mustBeAdmin {
        Investor storage investor = investors[investorAddress];
        investor.isDisabled = true;
    }
    
    function enableInvestor(address investorAddress) public mustBeAdmin {
        Investor storage investor = investors[investorAddress];
        investor.isDisabled = false;
    }
    
    function donate() payable public { depositedAmountGross += msg.value; }	//injected LOCKED ETHER

    // Utils helpers
    
    function getTotalSellLevel(uint256 totalSell) internal pure returns (uint256 level){
        if (totalSell < 30 ether) return 0;
        if (totalSell < 60 ether) return 1;
        if (totalSell < 90 ether) return 2;
        if (totalSell < 120 ether) return 3;
        if (totalSell < 150 ether) return 4;
        return 5;
    }

    function getSellThisMonthLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
        if (sellThisMonth < 2 ether) return 0;
        if (sellThisMonth < 4 ether) return 1;
        if (sellThisMonth < 6 ether) return 2;
        if (sellThisMonth < 8 ether) return 3;
        if (sellThisMonth < 10 ether) return 4;
        return 5;
    }
    
    function getDepositLevel(uint256 sellThisMonth) internal pure returns (uint256 level){
        if (sellThisMonth < 2 ether) return 0;
        if (sellThisMonth < 4 ether) return 1;
        if (sellThisMonth < 6 ether) return 2;
        if (sellThisMonth < 8 ether) return 3;
        if (sellThisMonth < 10 ether) return 4;
        return 5;
    }
    
    function getPercentage(uint256 depositedAmount, uint256 totalSell, uint256 sellThisMonth) internal pure returns(uint256 level) {
        uint256 totalSellLevel = getTotalSellLevel(totalSell);
        uint256 depLevel = getDepositLevel(depositedAmount);
        uint256 sellThisMonthLevel = getSellThisMonthLevel(sellThisMonth);
        uint256 min12 = totalSellLevel < depLevel ? totalSellLevel : depLevel;
        uint256 minLevel = sellThisMonthLevel < min12 ? sellThisMonthLevel : min12;
        return minLevel * 2;
    }
    
    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) return 0x0;
        assembly { result := mload(add(source, 32)) }
    }
    
    // query investor helpers

    function getInvestorPart1(address investorAddress) view public returns (bytes32 email, address parent, address leftChild, address rightChild, address presenter) {
        Investor memory investor = investors[investorAddress];
        return (investor.email, investor.parent, investor.leftChild, investor.rightChild, investor.presenter);
    }
    
    function getInvestorPart2(address investorAddress) view public returns (uint256 generation, uint256 depositedAmount, uint256 withdrewAmount, bool isDisabled) {
        Investor memory investor = investors[investorAddress];
        return (investor.generation, investor.depositedAmount, investor.withdrewAmount, investor.isDisabled);
    }
    
    function getInvestorPart3(address investorAddress) view public returns (uint256 lastMaxOut, uint256 maxOutTimes, uint256 maxOutTimesInWeek, uint256 totalSell, uint256 sellThisMonth) {
        Investor memory investor = investors[investorAddress];
        return (investor.lastMaxOut, investor.maxOutTimes, investor.maxOutTimesInWeek, investor.totalSell, investor.sellThisMonth);
    }

    function getInvestorPart4(address investorAddress) view public returns (uint256 rightSell, uint256 leftSell, uint256 reserveCommission, uint256 dailyIncomeWithrewAmount, uint256 registerTime) {
        Investor memory investor = investors[investorAddress];
        return (investor.rightSell, investor.leftSell, investor.reserveCommission, investor.dailyIncomeWithrewAmount, investor.registerTime);
    }

    function getInvestorPart5(address investorAddress) view public returns (uint256 unpaidSystemCommission, uint256 unpaidDailyIncome, uint256 minDeposit) {
        return (
            getUnpaidSystemCommission(investorAddress),
            getDailyIncomeForUser(investorAddress),
            investors[investorAddress].minDeposit
        ); 
    }

    function getInvestorPart6(address investorAddress) view public returns (address[] memory presentees, bytes32[] memory _investments, bytes32[] memory _withdrawals) {
        Investor memory investor = investors[investorAddress];
        return (investor.presentees, investor.investments ,investor.withdrawals);
    }

    function getInvestorLength() view public returns(uint256) { return investorAddresses.length; }

    function getMaxOutsLength() view public returns(uint256) { return maxOutIds.length; }
    
    function getNodesAddresses(address rootNodeAddress) public view returns(address[] memory){
        uint256 maxLength = investorAddresses.length;
        address[] memory nodes = new address[](maxLength);
        nodes[0] = rootNodeAddress;
        uint256 processIndex = 0;
        uint256 nextIndex = 1;
        while (processIndex != nextIndex) {
            Investor memory currentInvestor = investors[nodes[processIndex++]];
            if (currentInvestor.leftChild != address(0)) nodes[nextIndex++] = currentInvestor.leftChild;
            if (currentInvestor.rightChild != address(0)) nodes[nextIndex++] = currentInvestor.rightChild;
        }
        return nodes;
    }
    
    // query investments and withdrawals helpers
    
    function getInvestmentsLength () public view returns(uint256 length) { return investmentIds.length; }
    
    function getWithdrawalsLength() public view returns(uint256 length) { return withdrawalIds.length; }
    
    // import helper

    function importInvestor(bytes32 email, address[] memory addresses, bool isDisabled, uint256[] memory numbers) public mustBeImporting {
        Investor memory investor = Investor({
            email: email,
            isDisabled: isDisabled,
            parent: addresses[0],
            leftChild: addresses[1],
            rightChild: addresses[2],
            presenter: addresses[3],
            generation: numbers[0],
            presentees: new address[](0),
            depositedAmount: numbers[1],
            withdrewAmount: numbers[2],
            lastMaxOut: numbers[3],
            maxOutTimes: numbers[4],
            maxOutTimesInWeek: numbers[5],
            totalSell: numbers[6],
            sellThisMonth: numbers[7],
            investments: new bytes32[](0),
            withdrawals: new bytes32[](0),
            rightSell: numbers[8],
            leftSell: numbers[9],
            reserveCommission: numbers[10],
            dailyIncomeWithrewAmount: numbers[11],
            registerTime: numbers[12],
            minDeposit: MIN_DEP
        });
        investors[addresses[4]] = investor;
        investorAddresses.push(addresses[4]);
        if (addresses[3] == address(0)) return; 
        Investor storage presenter = investors[addresses[3]];
        presenter.presentees.push(addresses[4]);
    }
    
    function importInvestments(bytes32 id, uint256 at, uint256 amount, address investorAddress) public mustBeImporting {
        if (investments[id].at != 0) return;
        Investment memory investment = Investment({ id: id, at: at, amount: amount, investor: investorAddress, nextInvestor: address(0), nextBranch: false });
        investments[id] = investment;
        investmentIds.push(id);
        Investor storage investor = investors[investorAddress];
        investor.investments.push(id);
        depositedAmountGross += amount;
    }
    
    function importWithdrawals(bytes32 id, uint256 at, uint256 amount, address investorAddress, address presentee, uint256 reason, uint256 times) public mustBeImporting {
        if (withdrawals[id].at != 0) return;
        Withdrawal memory withdrawal = Withdrawal({ id: id, at: at, amount: amount, investor: investorAddress, presentee: presentee, times: times, reason: reason });
        withdrawals[id] = withdrawal;
        Investor storage investor = investors[investorAddress];
        investor.withdrawals.push(id);
        withdrawalIds.push(id);
    }
    
    function finishImporting() public mustBeAdmin { importing = false; }

    function finalizeVotes(uint256 from, uint256 to) public mustBeAdmin {
        require(now - currentVote.startTime > ONE_DAY);
        uint8 rootVote = currentVote.votes[investorAddresses[0]];
        require(rootVote != 0);
        for (uint256 index = from; index < to; index++) {
            address investorAddress = investorAddresses[index];
            if (investors[investorAddress].depositedAmount == 0) continue;
            if (currentVote.votes[investorAddress] != 0) continue;
            currentVote.votes[investorAddress] = rootVote;
            if (rootVote == 1) currentVote.noPoint += 1;
            else currentVote.yesPoint += 1;
        }
    }

    function createVote(string memory reason, address payable emergencyAddress) public mustBeAdmin {
        require(currentVote.startTime == 0);
        uint256 totalPoint = getAvailableToVote();
        currentVote = Vote({
            startTime: now,
            reason: reason,
            emergencyAddress: emergencyAddress,
            yesPoint: 0,
            noPoint: 0,
            totalPoint: totalPoint
        });
    }

    function removeVote() public mustBeAdmin {
        currentVote.startTime = 0;
        currentVote.reason = '';
        currentVote.emergencyAddress = address(0);
        currentVote.yesPoint = 0;
        currentVote.noPoint = 0;
    }
    
    function sendEtherToNewContract() public mustBeAdmin {
        require(currentVote.startTime != 0);
        require(now - currentVote.startTime > 3 * ONE_DAY);
        require(currentVote.yesPoint > currentVote.totalPoint / 2);
        require(currentVote.emergencyAddress != address(0));
        currentVote.emergencyAddress.transfer(0);
    }

    function voteProcess(address investor, bool isYes) internal {
        require(investors[investor].depositedAmount > 0);
        require(now - currentVote.startTime < ONE_DAY);
        uint8 newVoteValue = isYes ? 2 : 1;
        uint8 currentVoteValue = currentVote.votes[investor];
        require(newVoteValue != currentVoteValue);
        updateVote(isYes);
        if (currentVoteValue == 0) return;
        if (isYes) {
            currentVote.noPoint -= getVoteShare();
        } else {
            currentVote.yesPoint -= getVoteShare();
        }
    }
    
    function vote(bool isYes) public { voteProcess(msg.sender, isYes); }
    
    function updateVote(bool isYes) internal {
        currentVote.votes[msg.sender] = isYes ? 2 : 1;
        if (isYes) {
            currentVote.yesPoint += getVoteShare();
        } else {
            currentVote.noPoint += getVoteShare();
        }
    }
    
    function getVoteShare() public view returns(uint256) {
        if (investors[msg.sender].generation >= 3) return 1;
        if (currentVote.totalPoint > 40) return currentVote.totalPoint / 20;
        return 2;
    }

    function getAvailableToVote() public view returns(uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < investorAddresses.length; i++) {
            Investor memory investor = investors[investorAddresses[i]];
            if (investor.depositedAmount > 0) count++; 
        }
        return count;
    }
    
    function setEnv(uint256 _maxLevelsAddSale) public {
        maxLevelsAddSale = _maxLevelsAddSale;
    }
}