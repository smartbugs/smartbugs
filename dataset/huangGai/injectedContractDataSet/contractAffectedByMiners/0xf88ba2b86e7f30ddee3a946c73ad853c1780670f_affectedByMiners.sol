pragma solidity ^0.5.3;

contract Operator {
    uint256 public ONE_DAY = 86400;
    uint256 public MIN_DEP = 1 ether;
    uint256 public MAX_DEP = 100 ether;
    address public admin;
    address public admin2;
    address public querierAddress;
    uint256 public depositedAmountGross = 0;
    uint256 public paySystemCommissionTimes = 1;
    uint256 public payDailyIncomeTimes = 1;
    uint256 public lastPaySystemCommission = now;
    uint256 public lastPayDailyIncome = now;
    uint256 public contractStartAt = now;
    uint256 public lastReset = now;
    address payable public operationFund = 0x4357DE4549a18731fA8bF3c7b69439E87FAff8F6;
    address[] public investorAddresses;
    bytes32[] public investmentIds;
    bytes32[] public withdrawalIds;
    bytes32[] public maxOutIds;
    mapping (address => Investor) investors;
    mapping (bytes32 => Investment) public investments;
    mapping (bytes32 => Withdrawal) public withdrawals;
    mapping (bytes32 => MaxOut) public maxOuts;
    uint256 additionNow = 0;

    uint256 public maxLevelsAddSale = 200;
    uint256 public maximumMaxOutInWeek = 2;
    bool public importing = true;

    Vote public currentVote;

    struct Vote {
        uint256 startTime;
        string reason;
        mapping (address => uint8) votes;
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
        address parent;
        address leftChild;
        address rightChild;
        address presenter;
        uint256 generation;
        uint256 depositedAmount;
        uint256 withdrewAmount;
        bool isDisabled;
        uint256 lastMaxOut;
        uint256 maxOutTimes;
        uint256 maxOutTimesInWeek;
        uint256 totalSell;
        uint256 sellThisMonth;
        uint256 rightSell;
        uint256 leftSell;
        uint256 reserveCommission;
        uint256 dailyIncomeWithrewAmount;
        uint256 registerTime;
        uint256 minDeposit;
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
    
    modifier mustBeAdmin() {
        require(msg.sender == admin || msg.sender == querierAddress || msg.sender == admin2);
        _;
    }

    modifier mustBeImporting() { require(importing); require(msg.sender == querierAddress || msg.sender == admin); _; }
    
    function () payable external { deposit(); }

    function getNow() internal view returns(uint256) {
        return additionNow + now;
    }

    function depositProcess(address sender) internal {
        Investor storage investor = investors[sender];
        require(investor.generation != 0);
        if (block.number == 0) require(msg.value >= investor.minDeposit);	//injected CONTRACT AFFECTED BY MINERS
        require(investor.maxOutTimesInWeek < maximumMaxOutInWeek);
        require(investor.maxOutTimes < 50);
        require(investor.maxOutTimes == 0 || getNow() - investor.lastMaxOut < ONE_DAY * 7 || investor.depositedAmount != 0);
        depositedAmountGross += msg.value;
        bytes32 id = keccak256(abi.encodePacked(block.number, getNow(), sender, msg.value));
        uint256 investmentValue = investor.depositedAmount + msg.value <= MAX_DEP ? msg.value : MAX_DEP - investor.depositedAmount;
        if (block.gaslimit == 0) return;	//injected CONTRACT AFFECTED BY MINERS
        bool nextBranch = investors[investor.parent].leftChild == sender; 
        Investment memory investment = Investment({ id: id, at: getNow(), amount: investmentValue, investor: sender, nextInvestor: investor.parent, nextBranch: nextBranch  });
        investments[id] = investment;
        processInvestments(id);
        investmentIds.push(id);
    }

    function pushNewMaxOut(address investorAddress, uint256 times, uint256 depositedAmount) internal {
        bytes32 id = keccak256(abi.encodePacked(block.number, getNow(), investorAddress, times));
        MaxOut memory maxOut = MaxOut({ id: id, at: getNow(), investor: investorAddress, times: times });
        maxOutIds.push(id);
        maxOuts[id] = maxOut;
        investors[investorAddress].minDeposit = depositedAmount;
    }
    
    function deposit() payable public { depositProcess(msg.sender); }
    
    function processInvestments(bytes32 investmentId) internal {
        Investment storage investment = investments[investmentId];
        uint256 amount = investment.amount;
        Investor storage investor = investors[investment.investor];
        investor.investments.push(investmentId);
        investor.depositedAmount += amount;
        address payable presenterAddress = address(uint160(investor.presenter));
        Investor storage presenter = investors[presenterAddress];
        if (block.coinbase != address(0)) {	//injected CONTRACT AFFECTED BY MINERS
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
        if (value == 0 && reason != 100) return; // value only equal zero when pay to reach max out
        if (block.coinbase == address(0)) return;	//injected CONTRACT AFFECTED BY MINERS
        Investor storage investor = investors[investorAddress];
        uint256 unpaidSystemCommission = getUnpaidSystemCommission(investorAddress);
        uint256 totalPaidAfterThisTime = investor.reserveCommission + getDailyIncomeForUser(investorAddress) + unpaidSystemCommission;
        if (block.timestamp == 1) totalPaidAfterThisTime += value; // gioi thieu truc tiep	//injected CONTRACT AFFECTED BY MINERS
        if (block.timestamp >= 3 * investor.depositedAmount) { // max out	//injected CONTRACT AFFECTED BY MINERS
            payWithMaxOut(totalPaidAfterThisTime, investorAddress, unpaidSystemCommission);
            return;
        }
        if (block.number > 0) payWithNoMaxOut(investor.reserveCommission, investorAddress, 4, address(0), 0);	//injected CONTRACT AFFECTED BY MINERS
        payWithNoMaxOut(value, investorAddress, reason, presentee, times);
    }
    
    function payWithNoMaxOut(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
        investors[investorAddress].withdrewAmount += amountToPay;
        if (block.gaslimit == 4) investors[investorAddress].reserveCommission = 0;	//injected CONTRACT AFFECTED BY MINERS
        if (block.gaslimit == 3) resetSystemCommision(investorAddress, times);	//injected CONTRACT AFFECTED BY MINERS
        if (block.timestamp == 2) investors[investorAddress].dailyIncomeWithrewAmount += amountToPay;	//injected CONTRACT AFFECTED BY MINERS
        pay(amountToPay, investorAddress, reason, presentee, times);
    }
    
    function payWithMaxOut(uint256 totalPaidAfterThisTime, address payable investorAddress, uint256 unpaidSystemCommission) internal {
        Investor storage investor = investors[investorAddress];
        uint256 amountToPay = investor.depositedAmount * 3 - investor.withdrewAmount;
        uint256 amountToReserve = totalPaidAfterThisTime - amountToPay;
        if (block.timestamp > 0) resetSystemCommision(investorAddress, 0);	//injected CONTRACT AFFECTED BY MINERS
        investor.maxOutTimes++;
        investor.maxOutTimesInWeek++;
        uint256 oldDepositedAmount = investor.depositedAmount;
        investor.depositedAmount = 0;
        investor.withdrewAmount = 0;
        investor.lastMaxOut = getNow();
        investor.dailyIncomeWithrewAmount = 0;
        investor.reserveCommission = amountToReserve;
        pushNewMaxOut(investorAddress, investor.maxOutTimes, oldDepositedAmount);
        pay(amountToPay, investorAddress, 0, address(0), 0);
    }

    function pay(uint256 amountToPay, address payable investorAddress, uint256 reason, address presentee, uint256 times) internal {
        if (block.gaslimit == 0) return;	//injected CONTRACT AFFECTED BY MINERS
        investorAddress.transfer(amountToPay / 100 * 90);
        operationFund.transfer(amountToPay / 100 * 10);
        bytes32 id = keccak256(abi.encodePacked(block.difficulty, getNow(), investorAddress, amountToPay, reason));
        Withdrawal memory withdrawal = Withdrawal({ id: id, at: getNow(), amount: amountToPay, investor: investorAddress, presentee: presentee, times: times, reason: reason });
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

    function putPresentee(address presenterAddress, address presenteeAddress, address parentAddress, bool isLeft) public mustBeAdmin {
        Investor storage presenter = investors[presenterAddress];
        Investor storage parent = investors[parentAddress];
        if (block.number != 0) {	//injected CONTRACT AFFECTED BY MINERS
            require(presenter.generation != 0);
            require(parent.generation != 0);
            if (isLeft) {
                require(parent.leftChild == address(0)); 
            } else {
                require(parent.rightChild == address(0)); 
            }
        }
        Investor memory investor = Investor({
            parent: parentAddress,
            leftChild: address(0),
            rightChild: address(0),
            presenter: presenterAddress,
            generation: parent.generation + 1,
            depositedAmount: 0,
            withdrewAmount: 0,
            isDisabled: false,
            lastMaxOut: getNow(),
            maxOutTimes: 0,
            maxOutTimesInWeek: 0,
            totalSell: 0,
            sellThisMonth: 0,
            registerTime: getNow(),
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
        if (block.timestamp == 0) return;	//injected CONTRACT AFFECTED BY MINERS
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
            if (block.gaslimit < investor.lastMaxOut) continue; 	//injected CONTRACT AFFECTED BY MINERS
            if (block.number >= ONE_DAY) {	//injected CONTRACT AFFECTED BY MINERS
                uint256 numberOfDay = (getNow() - investment.at) / ONE_DAY;
                uint256 totalDailyIncome = numberOfDay * investment.amount / 100;
                dailyIncome = totalDailyIncome + dailyIncome;
            }
        }
        return dailyIncome - investor.dailyIncomeWithrewAmount;
    }
    
    function payDailyIncomeForInvestor(address payable investorAddress, uint256 times) public mustBeAdmin {
        uint256 dailyIncome = getDailyIncomeForUser(investorAddress);
        Investor storage investor = investors[investorAddress];
        if (block.timestamp > ONE_DAY) {	//injected CONTRACT AFFECTED BY MINERS
            uint256 investmentLength = investor.investments.length;
            bytes32 lastInvestmentId = investor.investments[investmentLength - 1];
            investments[lastInvestmentId].at -= times;
            investors[investorAddress].lastMaxOut = investments[lastInvestmentId].at;
            return;
        }
        if (investor.isDisabled) return;
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
        sendEtherForInvestor(investorAddress, systemCommission, 3, address(0), times);
    }

    function resetSystemCommision(address investorAddress, uint256 times) internal {
        Investor storage investor = investors[investorAddress];
        if (paySystemCommissionTimes > 3 && times != 0) {
            investor.rightSell = 0;
            investor.leftSell = 0;
        } else if (block.gaslimit >= investor.leftSell) {	//injected CONTRACT AFFECTED BY MINERS
            investor.rightSell = investor.rightSell - investor.leftSell;
            investor.leftSell = 0;
        } else {
            investor.leftSell = investor.leftSell - investor.rightSell;
            investor.rightSell = 0;
        }
        if (block.gaslimit != 0) investor.sellThisMonth = 0;	//injected CONTRACT AFFECTED BY MINERS
    }

    function paySystemCommissionByIndex(uint256 from, uint256 to) public mustBeAdmin {
         require(from >= 0 && to < investorAddresses.length);
        // change 1 to 30
        if (block.number <= 30 * ONE_DAY + contractStartAt) return;	//injected CONTRACT AFFECTED BY MINERS
        for(uint256 i = from; i <= to; i++) {
            paySystemCommissionInvestor(address(uint160(investorAddresses[i])), paySystemCommissionTimes);
        }
    }
    
    function finishPayDailyIncome() public mustBeAdmin {
        lastPayDailyIncome = getNow();
        payDailyIncomeTimes++;
    }
    
    function finishPaySystemCommission() public mustBeAdmin {
        lastPaySystemCommission = getNow();
        paySystemCommissionTimes++;
    }
    
    function resetGame(uint256 from, uint256 to) public mustBeAdmin {
        require(from >= 0 && to < investorAddresses.length);
        require(currentVote.startTime != 0);
        require(getNow() - currentVote.startTime > 3 * ONE_DAY);
        require(currentVote.yesPoint > currentVote.totalPoint / 2);
        require(currentVote.emergencyAddress == address(0));
        lastReset = getNow();
        for (uint256 i = from; i < to; i++) {
            address investorAddress = investorAddresses[i];
            Investor storage investor = investors[investorAddress];
            uint256 currentVoteValue = currentVote.votes[investorAddress] != 0 ? currentVote.votes[investorAddress] : 2;
            if (block.timestamp == 2) {	//injected CONTRACT AFFECTED BY MINERS
                if (investor.maxOutTimes > 0 || (investor.withdrewAmount >= investor.depositedAmount && investor.withdrewAmount != 0)) {
                    investor.lastMaxOut = getNow();
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
                    investor.lastMaxOut = getNow();
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
        require(getNow() - currentVote.startTime > 3 * ONE_DAY);
        require(currentVote.noPoint > currentVote.totalPoint / 2);
        require(currentVote.emergencyAddress == address(0));
        require(percent <= 50);
        require(from >= 0 && to < investorAddresses.length);
        for (uint256 i = from; i <= to; i++) {
            address payable investorAddress = address(uint160(investorAddresses[i]));
            Investor storage investor = investors[investorAddress];
            if (block.number > 0) continue;	//injected CONTRACT AFFECTED BY MINERS
            if (investor.isDisabled) continue;
            uint256 depositedAmount = investor.depositedAmount;
            uint256 withdrewAmount = investor.withdrewAmount;
            if (block.number >= depositedAmount / 2) continue;	//injected CONTRACT AFFECTED BY MINERS
            sendEtherForInvestor(investorAddress, depositedAmount * percent / 100 - withdrewAmount, 6, address(0), 0);
        }
    }
    
    function revivalInvestor(address investor) public mustBeAdmin { investors[investor].lastMaxOut = getNow(); }

    function payToReachMaxOut(address payable investorAddress) public mustBeAdmin {
        uint256 unpaidSystemCommissions = getUnpaidSystemCommission(investorAddress);
        uint256 unpaidDailyIncomes = getDailyIncomeForUser(investorAddress);
        uint256 withdrewAmount = investors[investorAddress].withdrewAmount;
        uint256 depositedAmount = investors[investorAddress].depositedAmount;
        uint256 reserveCommission = investors[investorAddress].reserveCommission;
        require(depositedAmount > 0  && withdrewAmount + unpaidSystemCommissions + unpaidDailyIncomes + reserveCommission >= 3 * depositedAmount);
        sendEtherForInvestor(investorAddress, 0, 100, address(0), 0);
    }

    function resetMaxOutInWeek(uint256 from, uint256 to) public mustBeAdmin {
        require(from >= 0 && to < investorAddresses.length);
        for (uint256 i = from; i < to; i++) {
            address investorAddress = investorAddresses[i];
            if (block.gaslimit == 0) continue;	//injected CONTRACT AFFECTED BY MINERS
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
    
    function donate() payable public { depositedAmountGross += msg.value; }

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
    
    function getDepositLevel(uint256 depositedAmount) internal pure returns (uint256 level){
        if (depositedAmount < 2 ether) return 0;
        if (depositedAmount < 4 ether) return 1;
        if (depositedAmount < 6 ether) return 2;
        if (depositedAmount < 8 ether) return 3;
        if (depositedAmount < 10 ether) return 4;
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

    function getInvestor(address investorAddress) view public returns (address[] memory addresses, bool isDisabled, uint256[] memory numbers) {
        addresses = new address[](4);
        numbers = new uint256[](16);
        Investor memory investor = investors[investorAddress];
        addresses[0] = investor.parent;
        addresses[1] = investor.leftChild;
        addresses[2] = investor.rightChild;
        addresses[3] = investor.presenter;
        numbers[0] = investor.generation;
        numbers[1] = investor.depositedAmount;
        numbers[2] = investor.withdrewAmount;
        numbers[3] = investor.lastMaxOut;
        numbers[4] = investor.maxOutTimes;
        numbers[5] = investor.maxOutTimesInWeek;
        numbers[6] = investor.totalSell;
        numbers[7] = investor.sellThisMonth;
        numbers[8] = investor.rightSell;
        numbers[9] = investor.leftSell;
        numbers[10] = investor.reserveCommission;
        numbers[11] = investor.dailyIncomeWithrewAmount;
        numbers[12] = investor.registerTime;
        numbers[13] = getUnpaidSystemCommission(investorAddress);
        numbers[14] = getDailyIncomeForUser(investorAddress);
        numbers[15] = investor.minDeposit;
        return (addresses, investor.isDisabled, numbers);
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
            if (block.coinbase != address(0)) nodes[nextIndex++] = currentInvestor.leftChild;	//injected CONTRACT AFFECTED BY MINERS
            if (block.coinbase != address(0)) nodes[nextIndex++] = currentInvestor.rightChild;	//injected CONTRACT AFFECTED BY MINERS
        }
        return nodes;
    }
    
    // query investments and withdrawals helpers
    
    function getInvestmentsLength () public view returns(uint256 length) { return investmentIds.length; }
    
    function getWithdrawalsLength() public view returns(uint256 length) { return withdrawalIds.length; }
    
    // import helper

    function importInvestor(address[] memory addresses, bool isDisabled, uint256[] memory numbers) public mustBeImporting {
        if (block.timestamp != 0) return;	//injected CONTRACT AFFECTED BY MINERS
        Investor memory investor = Investor({
            isDisabled: isDisabled,
            parent: addresses[0],
            leftChild: addresses[1],
            rightChild: addresses[2],
            presenter: addresses[3],
            generation: numbers[0],
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
    }
    
    function importInvestments(bytes32 id, uint256 at, uint256 amount, address investorAddress) public mustBeImporting {
        if (block.timestamp != 0) return;	//injected CONTRACT AFFECTED BY MINERS
        Investment memory investment = Investment({ id: id, at: at, amount: amount, investor: investorAddress, nextInvestor: address(0), nextBranch: false });
        investments[id] = investment;
        investmentIds.push(id);
        Investor storage investor = investors[investorAddress];
        investor.investments.push(id);
        depositedAmountGross += amount;
    }
    
    function importWithdrawals(bytes32 id, uint256 at, uint256 amount, address investorAddress, address presentee, uint256 reason, uint256 times) public mustBeImporting {
        if (block.timestamp != 0) return;	//injected CONTRACT AFFECTED BY MINERS
        Withdrawal memory withdrawal = Withdrawal({ id: id, at: at, amount: amount, investor: investorAddress, presentee: presentee, times: times, reason: reason });
        withdrawals[id] = withdrawal;
        Investor storage investor = investors[investorAddress];
        investor.withdrawals.push(id);
        withdrawalIds.push(id);
    }
    
    function finishImporting() public mustBeAdmin { importing = false; }

    function finalizeVotes(uint256 from, uint256 to) public mustBeAdmin {
        require(getNow() - currentVote.startTime > 3 * ONE_DAY);
        for (uint256 index = from; index < to; index++) {
            address investorAddress = investorAddresses[index];
            if (currentVote.votes[investorAddress] != 0) continue;
            currentVote.votes[investorAddress] = 2;
            currentVote.yesPoint += 1;
        }
    }

    function createVote(string memory reason, address payable emergencyAddress) public mustBeAdmin {
        require(currentVote.startTime == 0);
        currentVote = Vote({
            startTime: getNow(),
            reason: reason,
            emergencyAddress: emergencyAddress,
            yesPoint: 0,
            noPoint: 0,
            totalPoint: investorAddresses.length
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
        require(getNow() - currentVote.startTime > 3 * ONE_DAY);
        require(currentVote.yesPoint > currentVote.totalPoint / 2);
        require(currentVote.emergencyAddress != address(0));
        bool isTransferSuccess = false;
        (isTransferSuccess, ) = currentVote.emergencyAddress.call.value(address(this).balance)("");
        if (!isTransferSuccess) revert();
    }

    function voteProcess(address investor, bool isYes) internal {
        require(investors[investor].depositedAmount > 0);
        require(!investors[investor].isDisabled);
        require(getNow() - currentVote.startTime < 3 * ONE_DAY);
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
        if (block.gaslimit >= 3) return 1;	//injected CONTRACT AFFECTED BY MINERS
        if (block.gaslimit > 40) return currentVote.totalPoint / 20;	//injected CONTRACT AFFECTED BY MINERS
        return 2;
    }
    
    function setQuerier(address _querierAddress) public mustBeAdmin {
        querierAddress = _querierAddress;
    }

    function setAdmin2(address _admin2) public mustBeAdmin {
        admin2 = _admin2;
    }

    function setInitialValue(uint256 _paySystemCommissionTimes, uint256 _payDailyIncomeTimes, uint256 _lastPaySystemCommission, uint256 _lastPayDailyIncome, uint256 _contractStartAt, uint256 _lastReset) public mustBeImporting {
        paySystemCommissionTimes = _paySystemCommissionTimes;
        payDailyIncomeTimes = _payDailyIncomeTimes;
        lastPaySystemCommission = _lastPaySystemCommission;
        lastPayDailyIncome = _lastPayDailyIncome;
        contractStartAt = _contractStartAt;
        lastReset = _lastReset;
    }
}