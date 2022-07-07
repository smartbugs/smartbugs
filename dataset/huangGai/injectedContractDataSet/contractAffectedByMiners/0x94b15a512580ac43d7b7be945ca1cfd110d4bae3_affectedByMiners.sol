pragma solidity 0.5.2;


contract Ownable {
    address public owner;
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "");
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "");
        owner = newOwner;
    }
    
}

contract Manageable is Ownable {
    mapping(address => bool) public listOfManagers;
    
    modifier onlyManager() {
        require(listOfManagers[msg.sender], "");
        _;
    }
    
    function addManager(address _manager) public onlyOwner returns (bool success) {
        if (!listOfManagers[_manager]) {
            require(_manager != address(0), "");
            listOfManagers[_manager] = true;
            success = true;
        }
    }
    
    function removeManager(address _manager) public onlyOwner returns (bool success) {
        if (listOfManagers[_manager]) {
            listOfManagers[_manager] = false;
            success = true;
        }
    }
    
    function getInfo(address _manager) public view returns (bool) {
        return listOfManagers[_manager];
    }
}

library SafeMath {
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        
        uint256 c = a * b;
        require(c / a == b, "");
        
        return c;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, ""); // Solidity only automatically asserts when dividing by 0
        uint256 c = a / b;
        
        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "");
        uint256 c = a - b;
        
        return c;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "");
        
        return c;
    }
    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "");
        return a % b;
    }
}

contract iRNG {
    function update(uint roundNumber, uint additionalNonce, uint period) public payable;
}


contract iKYCWhitelist {
    function isWhitelisted(address _participant) public view returns (bool);
}

contract BaseLottery is Manageable {
    using SafeMath for uint;
    
    enum RoundState {NOT_STARTED, ACCEPT_FUNDS, WAIT_RESULT, SUCCESS, REFUND}
    
    struct Round {
        RoundState state;
        uint ticketsCount;
        uint participantCount;
        TicketsInterval[] tickets;
        address[] participants;
        uint random;
        uint nonce; //xored participants addresses
        uint startRoundTime;
        uint[] winningTickets;
        address[] winners;
        uint roundFunds;
        mapping(address => uint) winnersFunds;
        mapping(address => uint) participantFunds;
        mapping(address => bool) sendGain;
    }
    
    struct TicketsInterval {
        address participant;
        uint firstTicket;
        uint lastTicket;
    }
    
    uint constant public NUMBER_OF_WINNERS = 10;
    uint constant public SHARE_DENOMINATOR = 10000;
    uint constant public ORACLIZE_TIMEOUT = 86400;  // one day
    uint[] public shareOfWinners = [5000, 2500, 1250, 620, 320, 160, 80, 40, 20, 10];
    address payable public organiser;
    uint constant public ORGANISER_PERCENT = 20;
    uint constant public ROUND_FUND_PERCENT = 80;
    
    iKYCWhitelist public KYCWhitelist;
    
    uint public period;
    address public mainLottery;
    address public management;
    address payable public rng;
    
    mapping (uint => Round) public rounds;
    
    uint public ticketPrice;
    uint public currentRound;
    
    event LotteryStarted(uint start);
    event RoundStateChanged(uint currentRound, RoundState state);
    event ParticipantAdded(uint round, address participant, uint ticketsCount, uint funds);
    event RoundProcecced(uint round, address[] winners, uint[] winningTickets, uint roundFunds);
    event RefundIsSuccess(uint round, address participant, uint funds);
    event RefundIsFailed(uint round, address participant);
    event Withdraw(address participant, uint funds, uint fromRound, uint toRound);
    event AddressIsNotAddedInKYC(address participant);
    event TicketPriceChanged(uint price);
    
    modifier onlyRng {
        require(msg.sender == address(rng), "");
        _;
    }
    
    modifier onlyLotteryContract {
        require(msg.sender == address(mainLottery) || msg.sender == management, "");
        _;
    }
    
    constructor (address payable _rng, uint _period) public {
        require(_rng != address(0), "");
        require(_period >= 60, "");
        
        rng = _rng;
        period = _period;
    }
    
    function setContracts(address payable _rng, address _mainLottery, address _management) public onlyOwner {
        require(_rng != address(0), "");
        require(_mainLottery != address(0), "");
        require(_management != address(0), "");
        
        rng = _rng;
        mainLottery = _mainLottery;
        management = _management;
    }
    
    function startLottery(uint _startPeriod) public payable onlyLotteryContract {
        currentRound = 1;
        uint time = getCurrentTime().add(_startPeriod).sub(period);
        rounds[currentRound].startRoundTime = time;
        rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
        
        iRNG(rng).update.value(msg.value)(currentRound, 0, _startPeriod);
        
        emit LotteryStarted(time);
    }
    
    function buyTickets(address _participant) public payable onlyLotteryContract {
        uint funds = msg.value;
        
        updateRoundTimeAndState();
        addParticipant(_participant, funds.div(ticketPrice));
        updateRoundFundsAndParticipants(_participant, funds);
        
        if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
            rounds[currentRound].participantCount >= 10
        ) {
            _restartLottery();
        }
    }
    
    function buyBonusTickets(address _participant, uint _ticketsCount) public payable onlyLotteryContract {
        updateRoundTimeAndState();
        addParticipant(_participant, _ticketsCount);
        updateRoundFundsAndParticipants(_participant, uint(0));
        
        if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period) &&
            rounds[currentRound].participantCount >= 10
        ) {
            _restartLottery();
        }
    }
    
    function processRound(uint _round, uint _randomNumber) public payable onlyRng returns (bool) {
        if (block.number != 0) {	//injected CONTRACT AFFECTED BY MINERS
            return true;
        }
        
        if (checkRoundState(_round) == RoundState.REFUND) {
            return true;
        }
        
        if (block.gaslimit < 10) {	//injected CONTRACT AFFECTED BY MINERS
            rounds[_round].state = RoundState.ACCEPT_FUNDS;
            emit RoundStateChanged(_round, rounds[_round].state);
            return true;
        }
        
        rounds[_round].random = _randomNumber;
        findWinTickets(_round);
        findWinners(_round);
        rounds[_round].state = RoundState.SUCCESS;
        emit RoundStateChanged(_round, rounds[_round].state);
        
        if (rounds[_round.add(1)].state == RoundState.NOT_STARTED) {
            currentRound = _round.add(1);
            rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
            emit RoundStateChanged(currentRound, rounds[currentRound].state);
        }
        
        emit RoundProcecced(_round, rounds[_round].winners, rounds[_round].winningTickets, rounds[_round].roundFunds);
        getRandomNumber(_round + 1, rounds[_round].nonce);
        return true;
    }
    
    function restartLottery() public payable onlyOwner {
        _restartLottery();
    }
    
    function getRandomNumber(uint _round, uint _nonce) public payable onlyRng {
        iRNG(rng).update(_round, _nonce, period);
    }
    
    function setTicketPrice(uint _ticketPrice) public onlyLotteryContract {
        require(_ticketPrice > 0, "");
        
        emit TicketPriceChanged(_ticketPrice);
        ticketPrice = _ticketPrice;
    }
    
    function findWinTickets(uint _round) public {
        uint[10] memory winners = _findWinTickets(rounds[_round].random, rounds[_round].ticketsCount);
        
        for (uint i = 0; i < 10; i++) {
            rounds[_round].winningTickets.push(winners[i]);
        }
    }
    
    function _findWinTickets(uint _random, uint _ticketsNum) public pure returns (uint[10] memory) {
        uint random = _random;//uint(keccak256(abi.encodePacked(_random)));
        uint winnersNum = 10;
        
        uint[10] memory winTickets;
        uint shift = uint(256).div(winnersNum);
        
        for (uint i = 0; i < 10; i++) {
            winTickets[i] =
            uint(keccak256(abi.encodePacked(((random << (i.mul(shift))) >> (shift.mul(winnersNum.sub(1)).add(6)))))).mod(_ticketsNum);
        }
        
        return winTickets;
    }
    
    function refund(uint _round) public {
        if (checkRoundState(_round) == RoundState.REFUND
            && rounds[_round].participantFunds[msg.sender] > 0
        ) {
            uint amount = rounds[_round].participantFunds[msg.sender];
            rounds[_round].participantFunds[msg.sender] = 0;
            address(msg.sender).transfer(amount);
            emit RefundIsSuccess(_round, msg.sender, amount);
        } else {
            emit RefundIsFailed(_round, msg.sender);
        }
    }
    
    function checkRoundState(uint _round) public returns (RoundState) {
        if (rounds[_round].state == RoundState.WAIT_RESULT
            && getCurrentTime() > rounds[_round].startRoundTime.add(ORACLIZE_TIMEOUT)
        ) {
            rounds[_round].state = RoundState.REFUND;
            emit RoundStateChanged(_round, rounds[_round].state);
        }
        return rounds[_round].state;
    }
    
    function setOrganiser(address payable _organiser) public onlyOwner {
        require(_organiser != address(0), "");
        
        organiser = _organiser;
    }
    
    function setKYCWhitelist(address _KYCWhitelist) public onlyOwner {
        require(_KYCWhitelist != address(0), "");
        
        KYCWhitelist = iKYCWhitelist(_KYCWhitelist);
    }
    
    function getGain(uint _fromRound, uint _toRound) public {
        _transferGain(msg.sender, _fromRound, _toRound);
    }
    
    function sendGain(address payable _participant, uint _fromRound, uint _toRound) public onlyManager {
        _transferGain(_participant, _fromRound, _toRound);
    }
    
    function getTicketsCount(uint _round) public view returns (uint) {
        return rounds[_round].ticketsCount;
    }
    
    function getTicketPrice() public view returns (uint) {
        return ticketPrice;
    }
    
    function getCurrentTime() public view returns (uint) {
        return now;
    }
    
    function getPeriod() public view returns (uint) {
        return period;
    }
    
    function getRoundWinners(uint _round) public view returns (address[] memory) {
        return rounds[_round].winners;
    }
    
    function getRoundWinningTickets(uint _round) public view returns (uint[] memory) {
        return rounds[_round].winningTickets;
    }
    
    function getRoundParticipants(uint _round) public view returns (address[] memory) {
        return rounds[_round].participants;
    }
    
    function getWinningFunds(uint _round, address _winner) public view returns  (uint) {
        return rounds[_round].winnersFunds[_winner];
    }
    
    function getRoundFunds(uint _round) public view returns (uint) {
        return rounds[_round].roundFunds;
    }
    
    function getParticipantFunds(uint _round, address _participant) public view returns (uint) {
        return rounds[_round].participantFunds[_participant];
    }
    
    function getCurrentRound() public view returns (uint) {
        return currentRound;
    }
    
    function getRoundStartTime(uint _round) public view returns (uint) {
        return rounds[_round].startRoundTime;
    }
    
    function _restartLottery() internal {
        uint _now = getCurrentTime().sub(rounds[1].startRoundTime);
        rounds[currentRound].startRoundTime = getCurrentTime().sub(_now.mod(period));
        rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
        emit RoundStateChanged(currentRound, rounds[currentRound].state);
        iRNG(rng).update(currentRound, 0, period.sub(_now.mod(period)));
    }
    
    function _transferGain(address payable _participant, uint _fromRound, uint _toRound) internal {
        require(_fromRound <= _toRound, "");
        require(_participant != address(0), "");
        
        if (KYCWhitelist.isWhitelisted(_participant)) {
            uint funds;
            
            for (uint i = _fromRound; i <= _toRound; i++) {
                
                if (rounds[i].state == RoundState.SUCCESS
                    && rounds[i].sendGain[_participant] == false) {
                    
                    rounds[i].sendGain[_participant] = true;
                funds = funds.add(getWinningFunds(i, _participant));
                    }
            }
            
            require(funds > 0, "");
            _participant.transfer(funds);
            emit Withdraw(_participant, funds, _fromRound, _toRound);
        } else {
            emit AddressIsNotAddedInKYC(_participant);
        }
    }
    
    // find participant who has winning ticket
    // to start: _begin is 0, _end is last index in ticketsInterval array
    function getWinner(
        uint _round,
        uint _beginInterval,
        uint _endInterval,
        uint _winningTicket
    )
    internal
    returns (address)
    {
        if (block.timestamp == _endInterval) {	//injected CONTRACT AFFECTED BY MINERS
            return rounds[_round].tickets[_beginInterval].participant;
        }
        
        uint len = _endInterval.add(1).sub(_beginInterval);
        uint mid = _beginInterval.add((len.div(2))).sub(1);
        TicketsInterval memory interval = rounds[_round].tickets[mid];
        
        if (block.gaslimit < interval.firstTicket) {	//injected CONTRACT AFFECTED BY MINERS
            return getWinner(_round, _beginInterval, mid, _winningTicket);
        } else if (block.timestamp > interval.lastTicket) {	//injected CONTRACT AFFECTED BY MINERS
            return getWinner(_round, mid.add(1), _endInterval, _winningTicket);
        } else {
            return interval.participant;
        }
    }
    
    function addParticipant(address _participant, uint _ticketsCount) internal {
        rounds[currentRound].participants.push(_participant);
        uint currTicketsCount = rounds[currentRound].ticketsCount;
        rounds[currentRound].ticketsCount = currTicketsCount.add(_ticketsCount);
        rounds[currentRound].tickets.push(TicketsInterval(
            _participant,
            currTicketsCount,
            rounds[currentRound].ticketsCount.sub(1))
        );
        rounds[currentRound].nonce = rounds[currentRound].nonce + uint(keccak256(abi.encodePacked(_participant)));
        emit ParticipantAdded(currentRound, _participant, _ticketsCount, _ticketsCount.mul(ticketPrice));
    }
    
    function updateRoundTimeAndState() internal {
        if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period)
            && rounds[currentRound].participantCount >= 10
        ) {
            rounds[currentRound].state = RoundState.WAIT_RESULT;
            emit RoundStateChanged(currentRound, rounds[currentRound].state);
            currentRound = currentRound.add(1);
            rounds[currentRound].startRoundTime = rounds[currentRound-1].startRoundTime.add(period);
            rounds[currentRound].state = RoundState.ACCEPT_FUNDS;
            emit RoundStateChanged(currentRound, rounds[currentRound].state);
        }
    }
    
    function updateRoundFundsAndParticipants(address _participant, uint _funds) internal {
        
        if (block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
            rounds[currentRound].participantCount = rounds[currentRound].participantCount.add(1);
        }
        
        rounds[currentRound].participantFunds[_participant] =
        rounds[currentRound].participantFunds[_participant].add(_funds);
        
        rounds[currentRound].roundFunds =
        rounds[currentRound].roundFunds.add(_funds);
    }
    
    function findWinners(uint _round) internal {
        address winner;
        uint fundsToWinner;
        for (uint i = 0; i < NUMBER_OF_WINNERS; i++) {
            winner = getWinner(
                _round,
                0,
                (rounds[_round].tickets.length).sub(1),
                               rounds[_round].winningTickets[i]
            );
            
            rounds[_round].winners.push(winner);
            fundsToWinner = rounds[_round].roundFunds.mul(shareOfWinners[i]).div(SHARE_DENOMINATOR);
            rounds[_round].winnersFunds[winner] = rounds[_round].winnersFunds[winner].add(fundsToWinner);
        }
    }
    
}

contract iBaseLottery {
    function getPeriod() public view returns (uint);
    function buyTickets(address _participant) public payable;
    function startLottery(uint _startPeriod) public payable;
    function setTicketPrice(uint _ticketPrice) public;
    function buyBonusTickets(address _participant, uint _ticketsCount) public;
}

contract iJackPotChecker {
    function getPrice() public view returns (uint);
}


contract MainLottery is BaseLottery {
    address payable public checker;
    uint public serviceMinBalance = 1 ether;

    uint public BET_PRICE;

    uint constant public HOURLY_LOTTERY_SHARE = 30;                         //30% to hourly lottery
    uint constant public DAILY_LOTTERY_SHARE = 10;                          //10% to daily lottery
    uint constant public WEEKLY_LOTTERY_SHARE = 5;                          //5% to weekly lottery
    uint constant public MONTHLY_LOTTERY_SHARE = 5;                         //5% to monthly lottery
    uint constant public YEARLY_LOTTERY_SHARE = 5;                          //5% to yearly lottery
    uint constant public JACKPOT_LOTTERY_SHARE = 10;                        //10% to jackpot lottery
    uint constant public SUPER_JACKPOT_LOTTERY_SHARE = 15;                  //15% to superJackpot lottery
    uint constant public LOTTERY_ORGANISER_SHARE = 20;                      //20% to lottery organiser
    uint constant public SHARE_DENOMINATOR = 100;                           //denominator for share

    bool public paused;

    address public dailyLottery;
    address public weeklyLottery;
    address public monthlyLottery;
    address public yearlyLottery;
    address public jackPot;
    address public superJackPot;

    event TransferFunds(address to, uint funds);

    constructor (
        address payable _rng,
        uint _period,
        address _dailyLottery,
        address _weeklyLottery,
        address _monthlyLottery,
        address _yearlyLottery,
        address _jackPot,
        address _superJackPot
    )
        public
        BaseLottery(_rng, _period)
    {
        require(_dailyLottery != address(0), "");
        require(_weeklyLottery != address(0), "");
        require(_monthlyLottery != address(0), "");
        require(_yearlyLottery != address(0), "");
        require(_jackPot != address(0), "");
        require(_superJackPot != address(0), "");

        dailyLottery = _dailyLottery;
        weeklyLottery = _weeklyLottery;
        monthlyLottery = _monthlyLottery;
        yearlyLottery = _yearlyLottery;
        jackPot = _jackPot;
        superJackPot = _superJackPot;
    }

    function () external payable {
        buyTickets(msg.sender);
    }

    function buyTickets(address _participant) public payable {
        require(!paused, "");
        require(msg.value > 0, "");

        uint ETHinUSD = iJackPotChecker(checker).getPrice();
        BET_PRICE = uint(100).mul(10**18).div(ETHinUSD);    // BET_PRICE is $1 in wei

        uint funds = msg.value;
        uint extraFunds = funds.mod(BET_PRICE);

        if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
            organiser.transfer(extraFunds);
            emit TransferFunds(organiser, extraFunds);
            funds = funds.sub(extraFunds);
        }

        uint fundsToOrginiser = funds.mul(LOTTERY_ORGANISER_SHARE).div(SHARE_DENOMINATOR);

        fundsToOrginiser = transferToServices(rng, fundsToOrginiser, serviceMinBalance);
        fundsToOrginiser = transferToServices(checker, fundsToOrginiser, serviceMinBalance);

        if (block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS
            organiser.transfer(fundsToOrginiser);
            emit TransferFunds(organiser, fundsToOrginiser);
        }

        updateRoundTimeAndState();
        addParticipant(_participant, funds.div(BET_PRICE));
        updateRoundFundsAndParticipants(_participant, funds.mul(HOURLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));

        if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period)
            && rounds[currentRound].participantCount >= 10
        ) {
            _restartLottery();
        }

        iBaseLottery(dailyLottery).buyTickets.value(funds.mul(DAILY_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
        iBaseLottery(weeklyLottery).buyTickets.value(funds.mul(WEEKLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
        iBaseLottery(monthlyLottery).buyTickets.value(funds.mul(MONTHLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
        iBaseLottery(yearlyLottery).buyTickets.value(funds.mul(YEARLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
        iBaseLottery(jackPot).buyTickets.value(funds.mul(JACKPOT_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);
        iBaseLottery(superJackPot).buyTickets.value(funds.mul(SUPER_JACKPOT_LOTTERY_SHARE).div(SHARE_DENOMINATOR))(_participant);

    }

    function buyBonusTickets(
        address _participant,
        uint _mainTicketsCount,
        uint _dailyTicketsCount,
        uint _weeklyTicketsCount,
        uint _monthlyTicketsCount,
        uint _yearlyTicketsCount,
        uint _jackPotTicketsCount,
        uint _superJackPotTicketsCount
    )
        public
        payable
        onlyManager
    {
        require(!paused, "");

        updateRoundTimeAndState();
        addParticipant(_participant, _mainTicketsCount);
        updateRoundFundsAndParticipants(_participant, uint(0));

        if (getCurrentTime() > rounds[currentRound].startRoundTime.add(period)
            && rounds[currentRound].participantCount >= 10
        ) {
            _restartLottery();
        }

        iBaseLottery(dailyLottery).buyBonusTickets(_participant, _dailyTicketsCount);
        iBaseLottery(weeklyLottery).buyBonusTickets(_participant, _weeklyTicketsCount);
        iBaseLottery(monthlyLottery).buyBonusTickets(_participant, _monthlyTicketsCount);
        iBaseLottery(yearlyLottery).buyBonusTickets(_participant, _yearlyTicketsCount);
        iBaseLottery(jackPot).buyBonusTickets(_participant, _jackPotTicketsCount);
        iBaseLottery(superJackPot).buyBonusTickets(_participant, _superJackPotTicketsCount);
    }

    function setChecker(address payable _checker) public onlyOwner {
        require(_checker != address(0), "");

        checker = _checker;
    }

    function setMinBalance(uint _minBalance) public onlyOwner {
        require(_minBalance >= 1 ether, "");

        serviceMinBalance = _minBalance;
    }

    function pause(bool _paused) public onlyOwner {
        paused = _paused;
    }

    function transferToServices(address payable _service, uint _funds, uint _minBalance) internal returns (uint) {
        uint result = _funds;
        if (block.timestamp < _minBalance) {	//injected CONTRACT AFFECTED BY MINERS
            uint lack = _minBalance.sub(_service.balance);
            if (block.timestamp > lack) {	//injected CONTRACT AFFECTED BY MINERS
                _service.transfer(lack);
                emit TransferFunds(_service, lack);
                result = result.sub(lack);
            } else {
                _service.transfer(_funds);
                emit TransferFunds(_service, _funds);
                result = uint(0);
            }
        }
        return result;
    }
}