pragma solidity 0.5.4;

interface IDGTXToken {
    function transfer(address to, uint value) external returns (bool);
    function balanceOf(address) external view returns (uint256);
}

interface IWhitelist {
    function approved(address user) external view returns (bool);
}

interface ITreasury {
    function phaseNum() external view returns (uint256);
}

contract Sale {
    address public owner;
    address public whitelist;
    address public token;
    address public treasury;

    mapping(address => mapping(uint256 => uint256)) public purchased;

    uint256 internal rate;
    uint256 internal constant RATE_DELIMITER = 1000;
    uint256 internal constant ONE_TOKEN = 1e18; //1 DGTX
    uint256 internal constant PURCHASE_LIMIT = 1e24; //1 000 000 DGTX

    uint256 internal oldRate;
    uint256 internal constant RATE_UPDATE_DELAY = 15 minutes;
    uint256 internal rateBecomesValidAt;

    event Purchase(address indexed buyer, uint256 amount);
    event RateUpdate(uint256 newRate, uint256 rateBecomesValidAt);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event TokensReceived(uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyWhitelisted() {
        require(IWhitelist(whitelist).approved(msg.sender));
        _;
    }

    constructor(address _token, address _whitelist, address _treasury, uint256 _rate) public {
        require(_token != address(0));
        require(_whitelist != address(0));
        require(_treasury != address(0));
        require(_rate != 0);

        owner = msg.sender;
        token = _token;
        whitelist = _whitelist;
        treasury = _treasury;
        rate = _rate;
    }

    function() external payable {
        require(address(this).balance == 0);	//inject FORCED TO RECEIVE ETHERS

        buy();
    }

    function updateRate(uint256 newRate) external onlyOwner {
        require(newRate != 0);

        if (now > rateBecomesValidAt) {
            oldRate = rate;
        }
        rate = newRate;
        rateBecomesValidAt = now + RATE_UPDATE_DELAY;
        emit RateUpdate(newRate, rateBecomesValidAt);
    }

    function withdraw() external onlyOwner {
        require(address(this).balance > 0);

        msg.sender.transfer(address(this).balance);
    }

    function withdraw(address payable to) external onlyOwner {
        require(address(this).balance > 0);

        to.transfer(address(this).balance);
    }

    function transferOwnership(address _owner) external onlyOwner {
        require(_owner != address(0));

        emit OwnershipTransferred(owner, _owner);

        owner = _owner;
    }

    function tokenFallback(address, uint value, bytes calldata) external {
        require(msg.sender == token);

        emit TokensReceived(value);
    }

    function availablePersonal(address user) external view returns (uint256) {
        if (IWhitelist(whitelist).approved(user)) {
            uint256 currentPhase = ITreasury(treasury).phaseNum();
            return PURCHASE_LIMIT - purchased[user][currentPhase];
        }
        return 0;
    }

    function buy() public payable onlyWhitelisted() returns (uint256) {
        uint256 availableTotal = availableTokens();
        require(availableTotal > 0);

        uint256 currentPhase = ITreasury(treasury).phaseNum();
        uint256 personalRestrictions = PURCHASE_LIMIT - purchased[msg.sender][currentPhase];
        require(personalRestrictions > 0);

        uint256 amount = weiToTokens(msg.value);
        require(amount >= ONE_TOKEN); // 1 DGTX

        // actual = min(amount, availableTotal, availablePersonal)
        uint256 actual = amount < availableTotal ? amount : availableTotal;
        actual = actual < personalRestrictions ? actual : personalRestrictions;

        purchased[msg.sender][currentPhase] += actual;

        require(IDGTXToken(token).transfer(msg.sender, actual));

        if (amount != actual) {
            uint256 weiRefund = msg.value - tokensToWei(actual);
            msg.sender.transfer(weiRefund);
        }

        emit Purchase(msg.sender, actual);

        return actual;
    }

    function currentRate() public view returns (uint256) {
        return (now < rateBecomesValidAt) ? oldRate : rate;
    }

    function weiToTokens(uint256 weiAmount) public view returns (uint256) {
        uint256 exchangeRate = currentRate();

        return weiAmount * exchangeRate / RATE_DELIMITER;
    }

    function tokensToWei(uint256 tokensAmount) public view returns (uint256) {
        uint256 exchangeRate = currentRate();

        return tokensAmount * RATE_DELIMITER / exchangeRate;
    }

    function futureRate() public view returns (uint256, uint256) {
        return (now < rateBecomesValidAt) ? (rate, rateBecomesValidAt - now) : (rate, 0);
    }

    function availableTokens() public view returns (uint256) {
        return IDGTXToken(token).balanceOf(address(this));
    }
}