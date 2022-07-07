pragma solidity 0.5.2;

contract Ownable {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(tx.origin == owner, "");	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "");
        owner = newOwner;
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


contract iBaseLottery {
    function getPeriod() public view returns (uint);
    function startLottery(uint _startPeriod) public payable;
    function setTicketPrice(uint _ticketPrice) public;
}


contract Management is Ownable {
    using SafeMath for uint;

    uint constant public BET_PRICE = 10000000000000000;                     // 0.01 eth in wei
    uint constant public HOURLY_LOTTERY_SHARE = 30;                         // 30% to hourly lottery
    uint constant public DAILY_LOTTERY_SHARE = 10;                          // 10% to daily lottery
    uint constant public WEEKLY_LOTTERY_SHARE = 5;                          // 5% to weekly lottery
    uint constant public MONTHLY_LOTTERY_SHARE = 5;                         // 5% to monthly lottery
    uint constant public YEARLY_LOTTERY_SHARE = 5;                          // 5% to yearly lottery
    uint constant public JACKPOT_LOTTERY_SHARE = 10;                        // 10% to jackpot lottery
    uint constant public SUPER_JACKPOT_LOTTERY_SHARE = 15;                  // 15% to superJackpot lottery
    uint constant public SHARE_DENOMINATOR = 100;                           // denominator for share
    uint constant public ORACLIZE_TIMEOUT = 86400;

    iBaseLottery public mainLottery;
    iBaseLottery public dailyLottery;
    iBaseLottery public weeklyLottery;
    iBaseLottery public monthlyLottery;
    iBaseLottery public yearlyLottery;
    iBaseLottery public jackPot;
    iBaseLottery public superJackPot;

    uint public start = 1553472000;     // Monday, 25-Mar-19 00:00:00 UTC

    constructor (
        address _mainLottery,
        address _dailyLottery,
        address _weeklyLottery,
        address _monthlyLottery,
        address _yearlyLottery,
        address _jackPot,
        address _superJackPot
    )
        public
    {
        require(_mainLottery != address(0), "");
        require(_dailyLottery != address(0), "");
        require(_weeklyLottery != address(0), "");
        require(_monthlyLottery != address(0), "");
        require(_yearlyLottery != address(0), "");
        require(_jackPot != address(0), "");
        require(_superJackPot != address(0), "");

        mainLottery = iBaseLottery(_mainLottery);
        dailyLottery = iBaseLottery(_dailyLottery);
        weeklyLottery = iBaseLottery(_weeklyLottery);
        monthlyLottery = iBaseLottery(_monthlyLottery);
        yearlyLottery = iBaseLottery(_yearlyLottery);
        jackPot = iBaseLottery(_jackPot);
        superJackPot = iBaseLottery(_superJackPot);
    }

    function startLotteries() public payable onlyOwner {

        mainLottery.setTicketPrice(BET_PRICE.mul(HOURLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        dailyLottery.setTicketPrice(BET_PRICE.mul(DAILY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        weeklyLottery.setTicketPrice(BET_PRICE.mul(WEEKLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        monthlyLottery.setTicketPrice(BET_PRICE.mul(MONTHLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        yearlyLottery.setTicketPrice(BET_PRICE.mul(YEARLY_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        jackPot.setTicketPrice(BET_PRICE.mul(JACKPOT_LOTTERY_SHARE).div(SHARE_DENOMINATOR));
        superJackPot.setTicketPrice(BET_PRICE.mul(SUPER_JACKPOT_LOTTERY_SHARE).div(SHARE_DENOMINATOR));

        mainLottery.startLottery.value(msg.value/7)(start.add(mainLottery.getPeriod()).sub(now));
        dailyLottery.startLottery.value(msg.value/7)(start.add(dailyLottery.getPeriod()).sub(now));
        weeklyLottery.startLottery.value(msg.value/7)(start.add(weeklyLottery.getPeriod()).sub(now));
        monthlyLottery.startLottery.value(msg.value/7)(start.add(monthlyLottery.getPeriod()).sub(now));
        yearlyLottery.startLottery.value(msg.value/7)(start.add(yearlyLottery.getPeriod()).sub(now));
        jackPot.startLottery.value(msg.value/7)(ORACLIZE_TIMEOUT);
        superJackPot.startLottery.value(msg.value/7)(ORACLIZE_TIMEOUT);
    }
}