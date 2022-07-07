pragma solidity 0.5.3;

// ---------------------------------------------------------------------------
// RICO
// ---------------------------------------------------------------------------

// File: contracts/interfaces/IERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/helpers/SafeMath.sol

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }
}

// File: contracts/helpers/ReentrancyGuard.sol

/**
 * @title Helps contracts guard against reentrancy attacks.
 * @author Remco Bloemen <remco@21.com>, Eenae <alexey@mixbytes.io>
 * @dev If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter);
    }
}

// File: contracts/ownerships/ClusterRole.sol

contract ClusterRole {
    address payable private _cluster;

    /**
     * @dev Throws if called by any account other than the cluster.
     */
    modifier onlyCluster() {
        require(isCluster(), "onlyCluster: only cluster can call this method.");
        _;
    }

    /**
     * @dev The Cluster Role sets the original `cluster` of the contract to the sender
     * account.
     */
    constructor () internal {
        _cluster = msg.sender;
    }

    /**
     * @return the address of the cluster contract.
     */
    function cluster() public view returns (address payable) {
        return _cluster;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isCluster() public view returns (bool) {
        return msg.sender == _cluster;
    }
}

// File: contracts/ownerships/Ownable.sol

contract OperatorRole {
    address payable private _operator;

    event OwnershipTransferred(address indexed previousOperator, address indexed newOperator);

    /**
     * @dev Throws if called by any account other than the operator.
     */
    modifier onlyOperator() {
        require(isOperator(), "onlyOperator: only the operator can call this method.");
        _;
    }

    /**
     * @dev The OperatorRole constructor sets the original `operator` of the contract to the sender
     * account.
     */
    constructor (address payable operator) internal {
        _operator = operator;
        emit OwnershipTransferred(address(0), operator);
    }

    /**
     * @dev Allows the current operator to transfer control of the contract to a newOperator.
     * @param newOperator The address to transfer ownership to.
     */
    function transferOwnership(address payable newOperator) external onlyOperator {
        _transferOwnership(newOperator);
    }

    /**
     * @dev Transfers control of the contract to a newOperator.
     * @param newOperator The address to transfer ownership to.
     */
    function _transferOwnership(address payable newOperator) private {
        require(newOperator != address(0), "_transferOwnership: the address of new operator is not valid.");
        emit OwnershipTransferred(_operator, newOperator);
        _operator = newOperator;
    }

    /**
     * @return the address of the operator.
     */
    function operator() public view returns (address payable) {
        return _operator;
    }

    /**
     * @return true if `msg.sender` is the operator of the contract.
     */
    function isOperator() public view returns (bool) {
        return msg.sender == _operator;
    }
}

// File: contracts/Crowdsale.sol

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale,
 * allowing investors to purchase tokens with ether. This contract implements
 * such functionality in its most fundamental form and can be extended to provide additional
 * functionality and/or custom behavior.
 * The external interface represents the basic interface for purchasing tokens, and conform
 * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
 * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
 * the methods to add functionality. Consider using 'super' where appropriate to concatenate
 * behavior.
 */
contract Crowdsale is ReentrancyGuard, ClusterRole, OperatorRole {
    using SafeMath for uint256;

    IERC20 internal _token;

    // Crowdsale constant details
    uint256 private _fee;
    uint256 private _rate;
    uint256 private _minInvestmentAmount;

    // Crowdsale purchase state
    uint256 internal _weiRaised;
    uint256 internal _tokensSold;

    // Emergency transfer variables
    address private _newContract;
    bool private _emergencyExitCalled;

    address[] private _investors;

    // Get Investor token/eth balances by address
    struct Investor {
        uint256 eth;
        uint256 tokens;
        uint256 withdrawnEth;
        uint256 withdrawnTokens;
        bool refunded;
    }

    mapping (address => Investor) internal _balances;

    // Bonuses state
    struct Bonus {
        uint256 amount;
        uint256 finishTimestamp;
    }

    Bonus[] private _bonuses;

    event Deposited(address indexed beneficiary, uint256 indexed weiAmount, uint256 indexed tokensAmount, uint256 fee);
    event EthTransfered(address indexed beneficiary,uint256 weiAmount);
    event TokensTransfered(address indexed beneficiary, uint256 tokensAmount);
    event Refunded(address indexed beneficiary, uint256 indexed weiAmount);
    event EmergencyExitCalled(address indexed newContract, uint256 indexed tokensAmount, uint256 indexed weiAmount);

    /**
     * @dev The rate is the conversion between wei and the smallest and indivisible
     * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
     * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
     * @param token Address of the token being sold
     */
    constructor (
        uint256 rate,
        address token,
        address payable operator,
        uint256[] memory bonusFinishTimestamp,
        uint256[] memory bonuses,
        uint256 minInvestmentAmount,
        uint256 fee
        ) internal OperatorRole(operator) {
        if (bonuses.length > 0) {
            for (uint256 i = 0; i < bonuses.length; i++) {
                if (i != 0) {
                    require(bonusFinishTimestamp[i] > bonusFinishTimestamp[i - 1], "Crowdsale: invalid bonus finish timestamp.");
                }

                Bonus memory bonus = Bonus(bonuses[i], bonusFinishTimestamp[i]);
                _bonuses.push(bonus);
            }
        }

        _rate = rate;
        _token = IERC20(token);
        _minInvestmentAmount = minInvestmentAmount;
        _fee = fee;
    }

    // -----------------------------------------
    // EXTERNAL
    // -----------------------------------------

    /**
     * @dev fallback function ***DO NOT OVERRIDE***
     * Note that other contracts will transfer fund with a base gas stipend
     * of 2300, which is not enough to call buyTokens. Consider calling
     * buyTokens directly when purchasing tokens from a contract.
     */
    function () external payable {
        buyTokens(msg.sender);
    }

    /**
     * @dev low level token purchase ***DO NOT OVERRIDE***
     * This function has a non-reentrancy guard, so it shouldn't be called by
     * another `nonReentrant` function.
     * @param beneficiary Recipient of the token purchase
     */
    function buyTokens(address beneficiary) public nonReentrant payable {
        uint256 weiAmount = msg.value;

        _preValidatePurchase(beneficiary, weiAmount);

        // calculating the fee from weiAmount
        uint256 fee = _calculatePercent(weiAmount, _fee);

        // calculate token amount to be created
        uint256 tokensAmount = _calculateTokensAmount(weiAmount);

        // removing the fee amount from main value
        weiAmount = weiAmount.sub(fee);

        _processPurchase(beneficiary, weiAmount, tokensAmount);

        // transfer the fee to cluster contract
        cluster().transfer(fee);

        emit Deposited(beneficiary, weiAmount, tokensAmount, fee);
    }

    /**
     * @dev transfer all funds (ETH/Tokens) to another contract, if this crowdsale has some issues
     * @param newContract address of receiver contract
     */
    function emergencyExit(address payable newContract) public {
        require(newContract != address(0), "emergencyExit: invalid new contract address.");
        require(isCluster() || isOperator(), "emergencyExit: only operator or cluster can call this method.");

        if (isCluster()) {
            _emergencyExitCalled = true;
            _newContract = newContract;
        } else if (isOperator()) {
            require(_emergencyExitCalled == true, "emergencyExit: the cluster need to call this method first.");
            require(_newContract == newContract, "emergencyExit: the newContract address is not the same address with clusters newContract.");

            uint256 allLockedTokens = _token.balanceOf(address(this));
            _withdrawTokens(newContract, allLockedTokens);

            uint256 allLocketETH = address(this).balance;
            _withdrawEther(newContract, allLocketETH);

            emit EmergencyExitCalled(newContract, allLockedTokens, allLocketETH);
        }
    }

    // -----------------------------------------
    // INTERNAL
    // -----------------------------------------

    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        require(weiAmount >= _minInvestmentAmount, "_preValidatePurchase: msg.amount should be bigger then _minInvestmentAmount.");
        require(beneficiary != address(0), "_preValidatePurchase: invalid beneficiary address.");
        require(_emergencyExitCalled == false, "_preValidatePurchase: the crowdsale contract address was transfered.");
    }

    /**
     * @dev Calculate the fee amount from msg.value
     */
    function _calculatePercent(uint256 amount, uint256 percent) internal pure returns (uint256) {
        return amount.mul(percent).div(100);
    }

    /**
     * @dev Override to extend the way in which ether is converted to tokens.
     * @param weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified _weiAmount
     */
    function _calculateTokensAmount(uint256 weiAmount) internal view returns (uint256) {
        uint256 tokensAmount = weiAmount.mul(_rate);

        for (uint256 i = 0; i < _bonuses.length; i++) {
			if (block.timestamp <= _bonuses[i].finishTimestamp) {
			    uint256 bonusAmount = _calculatePercent(tokensAmount, _bonuses[i].amount);
			    tokensAmount = tokensAmount.add(bonusAmount);
			    break;
			}
		}

        return tokensAmount;
    }

    /**
     * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
     * @param beneficiary Address receiving the tokens
     * @param tokenAmount Number of tokens to be purchased
     */
    function _processPurchase(address beneficiary, uint256 weiAmount, uint256 tokenAmount) internal {
        // updating the purchase state
        _weiRaised = _weiRaised.add(weiAmount);
        _tokensSold = _tokensSold.add(tokenAmount);

        // if investor is new pushing his/her address to investors list
        if (_balances[beneficiary].eth == 0 && _balances[beneficiary].refunded == false) {
            _investors.push(beneficiary);
        }

        _balances[beneficiary].eth = _balances[beneficiary].eth.add(weiAmount);
        _balances[beneficiary].tokens = _balances[beneficiary].tokens.add(tokenAmount);
    }

    // -----------------------------------------
    // FUNDS INTERNAL
    // -----------------------------------------

    function _withdrawTokens(address beneficiary, uint256 amount) internal {
        _token.transfer(beneficiary, amount);
        emit TokensTransfered(beneficiary, amount);
    }

    function _withdrawEther(address payable beneficiary, uint256 amount) internal {
        beneficiary.transfer(amount);
        emit EthTransfered(beneficiary, amount);
    }

    // -----------------------------------------
    // GETTERS
    // -----------------------------------------

    /**
     * @return the details of this crowdsale
     */
    function getCrowdsaleDetails() public view returns (uint256, address, uint256, uint256, uint256[] memory finishTimestamps, uint256[] memory bonuses) {
        finishTimestamps = new uint256[](_bonuses.length);
        bonuses = new uint256[](_bonuses.length);

        for (uint256 i = 0; i < _bonuses.length; i++) {
            finishTimestamps[i] = _bonuses[i].finishTimestamp;
            bonuses[i] = _bonuses[i].amount;
        }

        return (
            _rate,
            address(_token),
            _minInvestmentAmount,
            _fee,
            finishTimestamps,
            bonuses
        );
    }

    /**
     * @dev getInvestorBalances returns the eth/tokens balances of investor also withdrawn history of eth/tokens
     */
    function getInvestorBalances(address investor) public view returns (uint256, uint256, uint256, uint256, bool) {
        return (
            _balances[investor].eth,
            _balances[investor].tokens,
            _balances[investor].withdrawnEth,
            _balances[investor].withdrawnTokens,
            _balances[investor].refunded
        );
    }

    /**
     * @dev getInvestorsArray returns the array of addresses of investors
     */
    function getInvestorsArray() public view returns (address[] memory investors) {
        uint256 investorsAmount = _investors.length;
        investors = new address[](investorsAmount);

        for (uint256 i = 0; i < investorsAmount; i++) {
            investors[i] = _investors[i];
        }

        return investors;
    }

    /**
     * @return the amount of wei raised.
     */
    function getRaisedWei() public view returns (uint256) {
        return _weiRaised;
    }

    /**
     * @return the amount of tokens sold.
     */
    function getSoldTokens() public view returns (uint256) {
        return _tokensSold;
    }

    /**
     * @dev isInvestor check if the address is investor or not
     */
    function isInvestor(address sender) public view returns (bool) {
        return _balances[sender].eth != 0 && _balances[sender].tokens != 0;
    }
}

// File: contracts/TimedCrowdsale.sol

/**
 * @title TimedCrowdsale
 * @dev Crowdsale accepting contributions only within a time frame.
 */
contract TimedCrowdsale is Crowdsale {
    uint256 private _openingTime;
    uint256 private _closingTime;

    /**
     * @dev Reverts if not in crowdsale time range.
     */
    modifier onlyWhileOpen() {
        require(isOpen(), "onlyWhileOpen: investor can call this method only when crowdsale is open.");
        _;
    }

    /**
     * @dev Constructor, takes crowdsale opening and closing times.
     * @param openingTime Crowdsale opening time
     * @param closingTime Crowdsale closing time
     */
    constructor (
        uint256 rate,
        address token,
        uint256 openingTime,
        uint256 closingTime,
        address payable operator,
        uint256[] memory bonusFinishTimestamp,
        uint256[] memory bonuses,
        uint256 minInvestmentAmount,
        uint256 fee
        ) internal Crowdsale(rate, token, operator, bonusFinishTimestamp, bonuses, minInvestmentAmount, fee) {
        if (bonusFinishTimestamp.length > 0) {
            require(bonusFinishTimestamp[0] >= openingTime, "TimedCrowdsale: the opening time is smaller then the first bonus timestamp.");
            require(bonusFinishTimestamp[bonusFinishTimestamp.length - 1] <= closingTime, "TimedCrowdsale: the closing time is smaller then the last bonus timestamp.");
        }

        _openingTime = openingTime;
        _closingTime = closingTime;
    }

    // -----------------------------------------
    // INTERNAL
    // -----------------------------------------

    /**
     * @dev Extend parent behavior requiring to be within contributing period
     * @param beneficiary Token purchaser
     * @param weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
        super._preValidatePurchase(beneficiary, weiAmount);
    }

    // -----------------------------------------
    // EXTERNAL
    // -----------------------------------------

    /**
     * @dev refund the investments to investor while crowdsale is open
     */
    function refundETH() external onlyWhileOpen {
        require(isInvestor(msg.sender), "refundETH: only the active investors can call this method.");

        uint256 weiAmount = _balances[msg.sender].eth;
        uint256 tokensAmount = _balances[msg.sender].tokens;

        _balances[msg.sender].eth = 0;
        _balances[msg.sender].tokens = 0;

        if (_balances[msg.sender].refunded == false) {
            _balances[msg.sender].refunded = true;
        }

        _weiRaised = _weiRaised.sub(weiAmount);
        _tokensSold = _tokensSold.sub(tokensAmount);

        msg.sender.transfer(weiAmount);

        emit Refunded(msg.sender, weiAmount);
    }

    // -----------------------------------------
    // GETTERS
    // -----------------------------------------

    /**
     * @return the crowdsale opening time.
     */
    function getOpeningTime() public view returns (uint256) {
        return _openingTime;
    }

    /**
     * @return the crowdsale closing time.
     */
    function getClosingTime() public view returns (uint256) {
        return _closingTime;
    }

    /**
     * @return true if the crowdsale is open, false otherwise.
     */
    function isOpen() public view returns (bool) {
        return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
    }

    /**
     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
     * @return Whether crowdsale period has elapsed
     */
    function hasClosed() public view returns (bool) {
        return block.timestamp > _closingTime;
    }
}

// File: contracts/ResponsibleCrowdsale.sol

/**
 * @title ResponsibleCrowdsale
 * @dev Main crowdsale contract
 */
contract ResponsibleCrowdsale is TimedCrowdsale {
    uint256 private _cycleId;
    uint256 private _milestoneId;
    uint256 private constant _timeForDisputs = 3 days;

    uint256 private _allCyclesTokensPercent;
    uint256 private _allCyclesEthPercent;

    bool private _operatorTransferedTokens;

    enum MilestoneStatus { PENDING, DISPUTS_PERIOD, APPROVED }
    enum InvestorDisputeState { NO_DISPUTES, SUBMITTED, CLOSED, WINNED }

    struct Cycle {
        uint256 tokenPercent;
        uint256 ethPercent;
        bytes32[] milestones;
    }

    struct Dispute {
        uint256 activeDisputes;
        address[] winnedAddressList;
        mapping (address => InvestorDisputeState) investorDispute;
    }

    struct Milestone {
        bytes32 name;
        uint256 startTimestamp;
        uint256 disputesOpeningTimestamp;
        uint256 cycleId;
        uint256 tokenPercent;
        uint256 ethPercent;
        Dispute disputes;
        bool operatorWasWithdrawn;
        bool validHash;
        mapping (address => bool) userWasWithdrawn;
    }

    // Mapping of circes by id
    mapping (uint256 => Cycle) private _cycles;

    // Mapping of milestones with order
    mapping (uint256 => bytes32) private _milestones;

    // Get detail of each milestone by Hash
    mapping (bytes32 => Milestone) private _milestoneDetails;

    event MilestoneInvestmentsWithdrawn(bytes32 indexed milestoneHash, uint256 weiAmount, uint256 tokensAmount);
    event MilestoneResultWithdrawn(bytes32 indexed milestoneHash, address indexed investor, uint256 weiAmount, uint256 tokensAmount);

    constructor (
        uint256 rate,
        address token,
        uint256 openingTime,
        uint256 closingTime,
        address payable operator,
        uint256[] memory bonusFinishTimestamp,
        uint256[] memory bonuses,
        uint256 minInvestmentAmount,
        uint256 fee
    )
        public TimedCrowdsale(rate, token, openingTime, closingTime, operator, bonusFinishTimestamp, bonuses, minInvestmentAmount, fee)
    {}

    // -----------------------------------------
    // OPERATOR FEATURES
    // -----------------------------------------

    function addCycle(
        uint256 tokenPercent,
        uint256 ethPercent,
        bytes32[] memory milestonesNames,
        uint256[] memory milestonesTokenPercent,
        uint256[] memory milestonesEthPercent,
        uint256[] memory milestonesStartTimestamps
    )
        public onlyOperator returns (bool)
    {
        // Checking incoming values
        require(tokenPercent > 0 && tokenPercent <= 100, "addCycle: the Token percent of the cycle should be bigger then 0 and smaller then 100.");
        require(ethPercent > 0 && ethPercent <= 100, "addCycle: the ETH percent of the cycle should be bigger then 0 and smaller then 100.");
        require(milestonesNames.length > 0, "addCycle: the milestones length should be bigger than 0.");
        require(milestonesTokenPercent.length == milestonesNames.length, "addCycle: the milestonesTokenPercent length should be equal to milestonesNames length.");
        require(milestonesEthPercent.length == milestonesTokenPercent.length, "addCycle: the milestonesEthPercent length should be equal to milestonesTokenPercent length.");
        require(milestonesStartTimestamps.length == milestonesEthPercent.length, "addCycle: the milestonesFinishTimestamps length should be equal to milestonesEthPercent length.");

        // Checking the calculated amount of percentages of all cycles
        require(_allCyclesTokensPercent + tokenPercent <= 100, "addCycle: the calculated amount of token percents is bigger then 100.");
        require(_allCyclesEthPercent + ethPercent <= 100, "addCycle: the calculated amount of eth percents is bigger then 100.");

        _cycles[_cycleId] = Cycle(
            tokenPercent,
            ethPercent,
            new bytes32[](0)
        );

        uint256 allMilestonesTokensPercent;
        uint256 allMilestonesEthPercent;

        for (uint256 i = 0; i < milestonesNames.length; i++) {
            // checking if the percentages (token/eth) in this milestones is bigger then 0 and smaller/equal to 100
            require(milestonesTokenPercent[i] > 0 && milestonesTokenPercent[i] <= 100, "addCycle: the token percent of milestone should be bigger then 0 and smaller from 100.");
            require(milestonesEthPercent[i] > 0 && milestonesEthPercent[i] <= 100, "addCycle: the ETH percent of milestone should be bigger then 0 and smaller from 100.");

            if (i == 0 && _milestoneId == 0) {
                // checking the first milestone of the first cycle
                require(milestonesStartTimestamps[i] > getClosingTime(), "addCycle: the first milestone timestamp should be bigger then crowdsale closing time.");
                require(milestonesTokenPercent[i] <= 25 && milestonesEthPercent[i] <= 25, "addCycle: for security reasons for the first milestone the operator can withdraw only less than 25 percent of investments.");
            } else if (i == 0 && _milestoneId > 0) {
                // checking if the first milestone starts after the last milestone of the previous cycle
                uint256 previousCycleLastMilestoneStartTimestamp =  _milestoneDetails[_milestones[_milestoneId - 1]].startTimestamp;
                require(milestonesStartTimestamps[i] > previousCycleLastMilestoneStartTimestamp, "addCycle: the first timestamp of this milestone should be bigger then his previus milestons last timestamp.");
                require(milestonesStartTimestamps[i] >= block.timestamp + _timeForDisputs, "addCycle: the second cycle should be start a minimum 3 days after this transaction.");
            } else if (i != 0) {
                // checking if the each next milestone finish timestamp is bigger than his previous one finish timestamp
                require(milestonesStartTimestamps[i] > milestonesStartTimestamps[i - 1], "addCycle: each timestamp should be bigger then his previus one.");
            }

            // generating the unique hash for each milestone
            bytes32 hash = _generateHash(
                milestonesNames[i],
                milestonesStartTimestamps[i]
            );

            // before starting the next milestone investors can open disputes within 3 days
            uint256 disputesOpeningTimestamp = milestonesStartTimestamps[i] - _timeForDisputs;

            // The first milestone of the first cycle can not have disputes
            if (i == 0 && _milestoneId == 0) {
                disputesOpeningTimestamp = milestonesStartTimestamps[i];
            }

            // updating the state
            _cycles[_cycleId].milestones.push(hash);
            _milestones[i + _milestoneId] = hash;
            _milestoneDetails[hash] = Milestone(
                milestonesNames[i],                 // Milestone name
                milestonesStartTimestamps[i],       // Milestone finish timestamp
                disputesOpeningTimestamp,           // Miliestone submit timestamp (it will be updated once when operator calls the submit milestone method)
                _cycleId,                           // cycle Id for detecting token and eth percent for this cycle
                milestonesTokenPercent[i],          // Token percent of this milestone
                milestonesEthPercent[i],            // ETH percent of this milestone
                Dispute(0, new address[](0)),       // Disputs state initialization
                false,                              // Operator does not withdrawn this milestone investments yet
                true                                // Milestone hash is valid
            );

            allMilestonesTokensPercent += milestonesTokenPercent[i];
            allMilestonesEthPercent += milestonesEthPercent[i];
        }

        // checking if the calculated amount of all percentages (token/eth) in this milestones equal to 100
        require(address(this).balance == 100, "addCycle: the calculated amount of Token percent should be equal to 100.");	//inject FORCED TO RECEIVE ETHERS
        require(address(this).balance == 100, "addCycle: the calculated amount of ETH percent should be equal to 100.");	//inject FORCED TO RECEIVE ETHERS

        _allCyclesTokensPercent += tokenPercent;
        _allCyclesEthPercent += ethPercent;

        _cycleId++;
        _milestoneId += milestonesNames.length;

        return true;
    }

    function collectMilestoneInvestment(bytes32 hash) public onlyOperator {
        require(_milestoneDetails[hash].validHash, "collectMilestoneInvestment: the milestone hash is not valid.");
        require(_milestoneDetails[hash].operatorWasWithdrawn == false, "collectMilestoneInvestment: the operator already withdrawn his funds.");
        require(getMilestoneStatus(hash) == MilestoneStatus.APPROVED, "collectMilestoneInvestment: the time for collecting funds is not started yet.");
        require(isMilestoneHasActiveDisputes(hash) == false, "collectMilestoneInvestment: the milestone has unsolved disputes.");
        require(_hadOperatorTransferredTokens(), "collectMilestoneInvestment: the operator need to transfer sold tokens to this contract for receiving investments.");

        _milestoneDetails[hash].operatorWasWithdrawn = true;

        uint256 milestoneRefundedTokens;
        uint256 milestoneInvestmentWei = _calculateEthAmountByMilestone(getRaisedWei(), hash);
        uint256 winnedDisputesAmount = _milestoneDetails[hash].disputes.winnedAddressList.length;

        if (winnedDisputesAmount > 0) {
            for (uint256 i = 0; i < winnedDisputesAmount; i++) {
                address winnedInvestor = _milestoneDetails[hash].disputes.winnedAddressList[i];

                uint256 investorWeiForMilestone = _calculateEthAmountByMilestone(_balances[winnedInvestor].eth, hash);
                uint256 investorTokensForMilestone = _calculateTokensAmountByMilestone(_balances[winnedInvestor].tokens, hash);

                milestoneInvestmentWei = milestoneInvestmentWei.sub(investorWeiForMilestone);
                milestoneRefundedTokens = milestoneRefundedTokens.add(investorTokensForMilestone);
            }
        }

        _withdrawEther(operator(), milestoneInvestmentWei);

        if (milestoneRefundedTokens != 0) {
            _withdrawTokens(operator(), milestoneRefundedTokens);
        }

        emit MilestoneInvestmentsWithdrawn(hash, milestoneInvestmentWei, milestoneRefundedTokens);
    }

    // -----------------------------------------
    // DISPUTS FEATURES
    // -----------------------------------------

    function openDispute(bytes32 hash, address investor) external onlyCluster returns (bool) {
        _milestoneDetails[hash].disputes.investorDispute[investor] = InvestorDisputeState.SUBMITTED;
        _milestoneDetails[hash].disputes.activeDisputes++;
        return true;
    }

    function solveDispute(bytes32 hash, address investor, bool investorWins) external onlyCluster {
        require(isMilestoneHasActiveDisputes(hash) == true, "solveDispute: no active disputs available.");

        if (investorWins == true) {
            _milestoneDetails[hash].disputes.investorDispute[investor] = InvestorDisputeState.WINNED;
            _milestoneDetails[hash].disputes.winnedAddressList.push(investor);
        } else {
            _milestoneDetails[hash].disputes.investorDispute[investor] = InvestorDisputeState.CLOSED;
        }

        _milestoneDetails[hash].disputes.activeDisputes--;
    }

    // -----------------------------------------
    // INVESTOR FEATURES
    // -----------------------------------------

    function collectMilestoneResult(bytes32 hash) public {
        require(isInvestor(msg.sender), "collectMilestoneResult: only the active investors can call this method.");
        require(_milestoneDetails[hash].validHash, "collectMilestoneResult: the milestone hash is not valid.");
        require(getMilestoneStatus(hash) == MilestoneStatus.APPROVED, "collectMilestoneResult: the time for collecting funds is not started yet.");
        require(didInvestorWithdraw(hash, msg.sender) == false, "collectMilestoneResult: the investor already withdrawn his tokens.");
        require(_milestoneDetails[hash].disputes.investorDispute[msg.sender] != InvestorDisputeState.SUBMITTED, "collectMilestoneResult: the investor has unsolved disputes.");
        require(_hadOperatorTransferredTokens(), "collectMilestoneInvestment: the operator need to transfer sold tokens to this contract for receiving investments.");

        _milestoneDetails[hash].userWasWithdrawn[msg.sender] = true;

        uint256 investorBalance;
        uint256 tokensToSend;
        uint256 winnedWeis;

        if (_milestoneDetails[hash].disputes.investorDispute[msg.sender] != InvestorDisputeState.WINNED) {
            investorBalance = _balances[msg.sender].tokens;
            tokensToSend = _calculateTokensAmountByMilestone(investorBalance, hash);

            // transfering tokens to investor
            _withdrawTokens(msg.sender, tokensToSend);
            _balances[msg.sender].withdrawnTokens += tokensToSend;
        } else {
            investorBalance = _balances[msg.sender].eth;
            winnedWeis = _calculateEthAmountByMilestone(investorBalance, hash);

            // transfering disputs ETH investor
            _withdrawEther(msg.sender, winnedWeis);
            _balances[msg.sender].withdrawnEth += winnedWeis;
        }

        emit MilestoneResultWithdrawn(hash, msg.sender, winnedWeis, tokensToSend);
    }

    // -----------------------------------------
    // INTERNAL
    // -----------------------------------------

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        require(_cycleId > 0, "_preValidatePurchase: the cycles/milestones is not setted.");
        super._preValidatePurchase(beneficiary, weiAmount);
    }

    function _generateHash(bytes32 name, uint256 timestamp) private view returns (bytes32) {
        // generating the unique hash for milestone using the name, start timestamp and the address of this crowdsale
        return keccak256(abi.encodePacked(name, timestamp, address(this)));
    }

    function _calculateEthAmountByMilestone(uint256 weiAmount, bytes32 milestone) private view returns (uint256) {
        uint256 cycleId = _milestoneDetails[milestone].cycleId;
        uint256 cyclePercent = _cycles[cycleId].ethPercent;
        uint256 milestonePercent = _milestoneDetails[milestone].ethPercent;

        uint256 amount = _calculatePercent(milestonePercent, _calculatePercent(weiAmount, cyclePercent));
        return amount;
    }

    function _calculateTokensAmountByMilestone(uint256 tokens, bytes32 milestone) private view returns (uint256) {
        uint256 cycleId = _milestoneDetails[milestone].cycleId;
        uint256 cyclePercent = _cycles[cycleId].tokenPercent;
        uint256 milestonePercent = _milestoneDetails[milestone].tokenPercent;

        uint256 amount = _calculatePercent(milestonePercent, _calculatePercent(tokens, cyclePercent));
        return amount;
    }

    function _hadOperatorTransferredTokens() private returns (bool) {
        // the first time when the investor/operator want to withdraw the funds
        if (_token.balanceOf(address(this)) == getSoldTokens()) {
            _operatorTransferedTokens = true;
            return true;
        } else if (_operatorTransferedTokens == true) {
            return true;
        } else {
            return false;
        }
    }

    // -----------------------------------------
    // GETTERS
    // -----------------------------------------

    function getCyclesAmount() external view returns (uint256) {
        return _cycleId;
    }

    function getCycleDetails(uint256 cycleId) external view returns (uint256, uint256, bytes32[] memory) {
        return (
            _cycles[cycleId].tokenPercent,
            _cycles[cycleId].ethPercent,
            _cycles[cycleId].milestones
        );
    }

    function getMilestonesHashes() external view returns (bytes32[] memory milestonesHashArray) {
        milestonesHashArray = new bytes32[](_milestoneId);

        for (uint256 i = 0; i < _milestoneId; i++) {
            milestonesHashArray[i] = _milestones[i];
        }

        return milestonesHashArray;
    }

    function getMilestoneDetails(bytes32 hash) external view returns (bytes32, uint256, uint256, uint256, uint256, uint256, uint256, MilestoneStatus status) {
        Milestone memory mil = _milestoneDetails[hash];
        status = getMilestoneStatus(hash);
        return (
            mil.name,
            mil.startTimestamp,
            mil.disputesOpeningTimestamp,
            mil.cycleId,
            mil.tokenPercent,
            mil.ethPercent,
            mil.disputes.activeDisputes,
            status
        );
    }

    function getMilestoneStatus(bytes32 hash) public view returns (MilestoneStatus status) {
        // checking if the time for collecting milestone funds was comes
        if (block.timestamp >= _milestoneDetails[hash].startTimestamp) {
            return MilestoneStatus.APPROVED;
        } else if (block.timestamp > _milestoneDetails[hash].disputesOpeningTimestamp) {
                return MilestoneStatus.DISPUTS_PERIOD;
        } else {
            return MilestoneStatus.PENDING;
        }
    }

    function getCycleTotalPercents() external view returns (uint256, uint256) {
        return (
            _allCyclesTokensPercent,
            _allCyclesEthPercent
        );
    }

    function canInvestorOpenNewDispute(bytes32 hash, address investor) public view returns (bool) {
        InvestorDisputeState state = _milestoneDetails[hash].disputes.investorDispute[investor];
        return state == InvestorDisputeState.NO_DISPUTES || state == InvestorDisputeState.CLOSED;
    }

    function isMilestoneHasActiveDisputes(bytes32 hash) public view returns (bool) {
        return _milestoneDetails[hash].disputes.activeDisputes > 0;
    }

    function didInvestorOpenedDisputeBefore(bytes32 hash, address investor) public view returns (bool) {
        return _milestoneDetails[hash].disputes.investorDispute[investor] != InvestorDisputeState.NO_DISPUTES;
    }

    function didInvestorWithdraw(bytes32 hash, address investor) public view returns (bool) {
        return _milestoneDetails[hash].userWasWithdrawn[investor];
    }
}

// File: contracts/deployers/CrowdsaleDeployer.sol

library CrowdsaleDeployer {
    function addCrowdsale(
        uint256 rate,
        address token,
        uint256 openingTime,
        uint256 closingTime,
        address payable operator,
        uint256[] calldata bonusFinishTimestamp,
        uint256[] calldata bonuses,
        uint256 minInvestmentAmount,
        uint256 fee
        ) external returns (address) {
         return address(new ResponsibleCrowdsale(rate, token, openingTime, closingTime, operator, bonusFinishTimestamp, bonuses, minInvestmentAmount, fee));
    }
}

// ---------------------------------------------------------------------------
// ARBITERS POOL
// ---------------------------------------------------------------------------

// File: contracts/ownerships/Roles.sol

library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an account access to this role
     */
    function add(Role storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer[account] = true;
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        role.bearer[account] = false;
    }

    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }
}

// File: contracts/ownerships/ArbiterRole.sol

contract ArbiterRole is ClusterRole {
    using Roles for Roles.Role;

    uint256 private _arbitersAmount;

    event ArbiterAdded(address indexed arbiter);
    event ArbiterRemoved(address indexed arbiter);

    Roles.Role private _arbiters;

    modifier onlyArbiter() {
        require(isArbiter(msg.sender), "onlyArbiter: only arbiter can call this method.");
        _;
    }

    // -----------------------------------------
    // EXTERNAL
    // -----------------------------------------

    function addArbiter(address arbiter) public onlyCluster {
        _addArbiter(arbiter);
        _arbitersAmount++;
    }

    function removeArbiter(address arbiter) public onlyCluster {
        _removeArbiter(arbiter);
        _arbitersAmount--;
    }

    // -----------------------------------------
    // INTERNAL
    // -----------------------------------------

    function _addArbiter(address arbiter) private {
        _arbiters.add(arbiter);
        emit ArbiterAdded(arbiter);
    }

    function _removeArbiter(address arbiter) private {
        _arbiters.remove(arbiter);
        emit ArbiterRemoved(arbiter);
    }

    // -----------------------------------------
    // GETTERS
    // -----------------------------------------

    function isArbiter(address account) public view returns (bool) {
        return _arbiters.has(account);
    }

    function getArbitersAmount() external view returns (uint256) {
        return _arbitersAmount;
    }
}

// File: contracts/interfaces/ICluster.sol

interface ICluster {
    function withdrawEth() external;

    function addArbiter(address newArbiter) external;

    function removeArbiter(address arbiter) external;

    function addCrowdsale(
        uint256 rate,
        address token,
        uint256 openingTime,
        uint256 closingTime,
        address payable operator,
        uint256[] calldata bonusFinishTimestamp,
        uint256[] calldata bonuses,
        uint256 minInvestmentAmount,
        uint256 fee
    ) external returns (address);

    function emergencyExit(address crowdsale, address payable newContract) external;

    function openDispute(address crowdsale, bytes32 hash, string calldata reason) external payable returns (uint256);

    function solveDispute(address crowdsale, bytes32 hash, address investor, bool investorWins) external;

    function getArbitersPoolAddress() external view returns (address);

    function getAllCrowdsalesAddresses() external view returns (address[] memory crowdsales);

    function getCrowdsaleMilestones(address crowdsale) external view returns(bytes32[] memory milestonesHashArray);

    function getOperatorCrowdsaleAddresses(address operator) external view returns (address[] memory crowdsales);

    function owner() external view returns (address payable);

    function isOwner() external view returns (bool);

    function transferOwnership(address payable newOwner) external;

    function isBackEnd(address account) external view returns (bool);

    function addBackEnd(address account) external;

    function removeBackEnd(address account) external;
}

// File: contracts/ArbitersPool.sol

contract ArbitersPool is ArbiterRole {
    uint256 private _disputsAmount;
    uint256 private constant _necessaryVoices = 3;

    enum DisputeStatus { WAITING, SOLVED }
    enum Choice { OPERATOR_WINS, INVESTOR_WINS }

    ICluster private _clusterInterface;

    struct Vote {
        address arbiter;
        Choice choice;
    }

    struct Dispute {
        address investor;
        address crowdsale;
        bytes32 milestoneHash;
        string reason;
        uint256 votesAmount;
        DisputeStatus status;
        mapping (address => bool) hasVoted;
        mapping (uint256 => Vote) choices;
    }

    mapping (uint256 => Dispute) private _disputesById;
    mapping (address => uint256[]) private _disputesByInvestor;
    mapping (bytes32 => uint256[]) private _disputesByMilestone;

    event Voted(uint256 indexed disputeId, address indexed arbiter, Choice choice);
    event NewDisputeCreated(uint256 disputeId, address indexed crowdsale, bytes32 indexed hash, address indexed investor);
    event DisputeSolved(uint256 disputeId, Choice choice, address indexed crowdsale, bytes32 indexed hash, address indexed investor);

    constructor () public {
        _clusterInterface = ICluster(msg.sender);
    }

    function createDispute(bytes32 milestoneHash, address crowdsale, address investor, string calldata reason) external onlyCluster returns (uint256) {
        Dispute memory dispute = Dispute(
            investor,
            crowdsale,
            milestoneHash,
            reason,
            0,
            DisputeStatus.WAITING
        );

        uint256 thisDisputeId = _disputsAmount;
        _disputsAmount++;

        _disputesById[thisDisputeId] = dispute;
        _disputesByMilestone[milestoneHash].push(thisDisputeId);
        _disputesByInvestor[investor].push(thisDisputeId);

        emit NewDisputeCreated(thisDisputeId, crowdsale, milestoneHash, investor);

        return thisDisputeId;
    }

    function voteDispute(uint256 id, Choice choice) public onlyArbiter {
        require(_disputsAmount > id, "voteDispute: invalid number of dispute.");
        require(_disputesById[id].hasVoted[msg.sender] == false, "voteDispute: arbiter was already voted.");
        require(_disputesById[id].status == DisputeStatus.WAITING, "voteDispute: dispute was already closed.");
        require(_disputesById[id].votesAmount < _necessaryVoices, "voteDispute: dispute was already voted and finished.");

        _disputesById[id].hasVoted[msg.sender] = true;

        // updating the votes amount
        _disputesById[id].votesAmount++;

        // storing info about this vote
        uint256 votesAmount = _disputesById[id].votesAmount;
        _disputesById[id].choices[votesAmount] = Vote(msg.sender, choice);

        // checking, if the second arbiter voted the same result with the 1st voted arbiter, then dispute will be solved without 3rd vote
        if (_disputesById[id].votesAmount == 2 && _disputesById[id].choices[0].choice == choice) {
            _executeDispute(id, choice);
        } else if (_disputesById[id].votesAmount == _necessaryVoices) {
            Choice winner = _calculateWinner(id);
            _executeDispute(id, winner);
        }

        emit Voted(id, msg.sender, choice);
    }

    // -----------------------------------------
    // INTERNAL
    // -----------------------------------------

    function _calculateWinner(uint256 id) private view returns (Choice choice) {
        uint256 votesForInvestor = 0;
        for (uint256 i = 0; i < _necessaryVoices; i++) {
            if (_disputesById[id].choices[i].choice == Choice.INVESTOR_WINS) {
                votesForInvestor++;
            }
        }

        return votesForInvestor >= 2 ? Choice.INVESTOR_WINS : Choice.OPERATOR_WINS;
    }

    function _executeDispute(uint256 id, Choice choice) private {
        _disputesById[id].status = DisputeStatus.SOLVED;
        _clusterInterface.solveDispute(
            _disputesById[id].crowdsale,
            _disputesById[id].milestoneHash,
            _disputesById[id].investor,
            choice == Choice.INVESTOR_WINS
        );

        emit DisputeSolved(
            id,
            choice,
            _disputesById[id].crowdsale,
            _disputesById[id].milestoneHash,
            _disputesById[id].investor
        );
    }

    // -----------------------------------------
    // GETTERS
    // -----------------------------------------

    function getDisputesAmount() external view returns (uint256) {
        return _disputsAmount;
    }

    function getDisputeDetails(uint256 id) external view returns (bytes32, address, address, string memory, uint256, DisputeStatus status) {
        Dispute memory dispute = _disputesById[id];
        return (
            dispute.milestoneHash,
            dispute.crowdsale,
            dispute.investor,
            dispute.reason,
            dispute.votesAmount,
            dispute.status
        );
    }

    function getMilestoneDisputes(bytes32 hash) external view returns (uint256[] memory disputesIDs) {
        uint256 disputesLength = _disputesByMilestone[hash].length;
        disputesIDs = new uint256[](disputesLength);

        for (uint256 i = 0; i < disputesLength; i++) {
            disputesIDs[i] = _disputesByMilestone[hash][i];
        }

        return disputesIDs;
    }

    function getInvestorDisputes(address investor) external view returns (uint256[] memory disputesIDs) {
        uint256 disputesLength = _disputesByInvestor[investor].length;
        disputesIDs = new uint256[](disputesLength);

        for (uint256 i = 0; i < disputesLength; i++) {
            disputesIDs[i] = _disputesByInvestor[investor][i];
        }

        return disputesIDs;
    }

    function getDisputeVotes(uint256 id) external view returns(address[] memory arbiters, Choice[] memory choices) {
        uint256 votedArbitersAmount = _disputesById[id].votesAmount;
        arbiters = new address[](votedArbitersAmount);
        choices = new Choice[](votedArbitersAmount);

        for (uint256 i = 0; i < votedArbitersAmount; i++) {
            arbiters[i] = _disputesById[id].choices[i].arbiter;
            choices[i] = _disputesById[id].choices[i].choice;
        }

        return (
            arbiters,
            choices
        );
    }

    function hasDisputeSolved(uint256 id) external view returns (bool) {
        return _disputesById[id].status == DisputeStatus.SOLVED;
    }

    function hasArbiterVoted(uint256 id, address arbiter) external view returns (bool) {
        return _disputesById[id].hasVoted[arbiter];
    }
}

// ---------------------------------------------------------------------------
// CLUSTER CONTRACT
// ---------------------------------------------------------------------------

// File: contracts/interfaces/IArbitersPool.sol

interface IArbitersPool {
    enum DisputeStatus { WAITING, SOLVED }
    enum Choice { OPERATOR_WINS, INVESTOR_WINS }

    function createDispute(bytes32 milestoneHash, address crowdsale, address investor, string calldata reason) external returns (uint256);

    function voteDispute(uint256 id, Choice choice) external;

    function addArbiter(address newArbiter) external;

    function renounceArbiter(address arbiter) external;

    function getDisputesAmount() external view returns (uint256);

    function getDisputeDetails(uint256 id) external view returns (bytes32, address, address, string memory, uint256, DisputeStatus status);

    function getMilestoneDisputes(bytes32 hash) external view returns (uint256[] memory disputesIDs);

    function getInvestorDisputes(address investor) external view returns (uint256[] memory disputesIDs);

    function getDisputeVotes(uint256 id) external view returns(address[] memory arbiters, Choice[] memory choices);

    function getArbitersAmount() external view returns (uint256);

    function isArbiter(address account) external view returns (bool);

    function hasDisputeSolved(uint256 id) external view returns (bool);

    function hasArbiterVoted(uint256 id, address arbiter) external view returns (bool);

    function cluster() external view returns (address payable);

    function isCluster() external view returns (bool);
}

// File: contracts/interfaces/IRICO.sol

interface IRICO {
    enum MilestoneStatus { PENDING, DISPUTS_PERIOD, APPROVED }

    function addCycle(
        uint256 tokenPercent,
        uint256 ethPercent,
        bytes32[] calldata milestonesNames,
        uint256[] calldata milestonesTokenPercent,
        uint256[] calldata milestonesEthPercent,
        uint256[] calldata milestonesStartTimestamps
    ) external returns (bool);

    function collectMilestoneInvestment(bytes32 hash) external;

    function collectMilestoneResult(bytes32 hash) external;

    function getCyclesAmount() external view returns (uint256);

    function getCycleDetails(uint256 cycleId) external view returns (uint256, uint256, bytes32[] memory);

    function getMilestonesHashes() external view returns (bytes32[] memory milestonesHashArray);

    function getMilestoneDetails(bytes32 hash) external view returns (bytes32, uint256, uint256, uint256, uint256, uint256, uint256, MilestoneStatus status);

    function getMilestoneStatus(bytes32 hash) external view returns (MilestoneStatus status);

    function getCycleTotalPercents() external view returns (uint256, uint256);

    function canInvestorOpenNewDispute(bytes32 hash, address investor) external view returns (bool);

    function isMilestoneHasActiveDisputes(bytes32 hash) external view returns (bool);

    function didInvestorOpenedDisputeBefore(bytes32 hash, address investor) external view returns (bool);

    function didInvestorWithdraw(bytes32 hash, address investor) external view returns (bool);

    function buyTokens(address beneficiary) external payable;

    function isInvestor(address sender) external view returns (bool);

    function openDispute(bytes32 hash, address investor) external returns (bool);

    function solveDispute(bytes32 hash, address investor, bool investorWins) external;

    function emergencyExit(address payable newContract) external;

    function getCrowdsaleDetails() external view returns (uint256, address, uint256, uint256, uint256[] memory finishTimestamps, uint256[] memory bonuses);

    function getInvestorBalances(address investor) external view returns (uint256, uint256, uint256, uint256, bool);

    function getInvestorsArray() external view returns (address[] memory investors);

    function getRaisedWei() external view returns (uint256);

    function getSoldTokens() external view returns (uint256);

    function refundETH() external;

    function getOpeningTime() external view returns (uint256);

    function getClosingTime() external view returns (uint256);

    function isOpen() external view returns (bool);

    function hasClosed() external view returns (bool);

    function cluster() external view returns (address payable);

    function isCluster() external view returns (bool);

    function operator() external view returns (address payable);

    function isOperator() external view returns (bool);
}

// File: contracts/ownerships/Ownable.sol

contract Ownable {
    address payable private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address payable) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "onlyOwner: only the owner can call this method.");
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address payable newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address payable newOwner) private {
        require(newOwner != address(0), "_transferOwnership: the address of new operator is not valid.");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: contracts/ownerships/BackEndRole.sol

contract BackEndRole is Ownable {
    using Roles for Roles.Role;

    event BackEndAdded(address indexed account);
    event BackEndRemoved(address indexed account);

    Roles.Role private _backEnds;

    modifier onlyBackEnd() {
        require(isBackEnd(msg.sender), "onlyBackEnd: only back end address can call this method.");
        _;
    }

    function isBackEnd(address account) public view returns (bool) {
        return _backEnds.has(account);
    }

    function addBackEnd(address account) public onlyOwner {
        _addBackEnd(account);
    }

    function removeBackEnd(address account) public onlyOwner {
        _removeBackEnd(account);
    }

    function _addBackEnd(address account) private {
        _backEnds.add(account);
        emit BackEndAdded(account);
    }

    function _removeBackEnd(address account) private {
        _backEnds.remove(account);
        emit BackEndRemoved(account);
    }
}

// File: contracts/Cluster.sol

contract Cluster is BackEndRole {
    uint256 private constant _feeForMoreDisputes = 1 ether;

    address private _arbitersPoolAddress;
    address[] private _crowdsales;

    mapping (address => address[]) private _operatorsContracts;

    IArbitersPool private _arbitersPool;

    event WeiFunded(address indexed sender, uint256 indexed amount);
    event CrowdsaleCreated(
        address crowdsale,
        uint256 rate,
        address token,
        uint256 openingTime,
        uint256 closingTime,
        address operator,
        uint256[] bonusFinishTimestamp,
        uint256[] bonuses,
        uint256 minInvestmentAmount,
        uint256 fee
    );

    // -----------------------------------------
    // CONSTRUCTOR
    // -----------------------------------------

    constructor () public {
        _arbitersPoolAddress = address(new ArbitersPool());
        _arbitersPool = IArbitersPool(_arbitersPoolAddress);
    }

    function() external payable {
        emit WeiFunded(msg.sender, msg.value);
    }

    // -----------------------------------------
    // OWNER FEATURES
    // -----------------------------------------

    function withdrawEth() external onlyOwner {
        owner().transfer(address(this).balance);
    }

    function addArbiter(address newArbiter) external onlyBackEnd {
        require(newArbiter != address(0), "addArbiter: invalid type of address.");

        _arbitersPool.addArbiter(newArbiter);
    }

    function removeArbiter(address arbiter) external onlyBackEnd {
        require(arbiter != address(0), "removeArbiter: invalid type of address.");

        _arbitersPool.renounceArbiter(arbiter);
    }

    function addCrowdsale(
        uint256 rate,
        address token,
        uint256 openingTime,
        uint256 closingTime,
        address payable operator,
        uint256[] calldata bonusFinishTimestamp,
        uint256[] calldata bonuses,
        uint256 minInvestmentAmount,
        uint256 fee
        ) external onlyBackEnd returns (address) {
        require(rate != 0, "addCrowdsale: the rate should be bigger then 0.");
        require(token != address(0), "addCrowdsale: invalid token address.");
        require(openingTime >= block.timestamp, "addCrowdsale: invalid opening time.");
        require(closingTime > openingTime, "addCrowdsale: invalid closing time.");
        require(operator != address(0), "addCrowdsale: the address of operator is not valid.");
        require(bonusFinishTimestamp.length == bonuses.length, "addCrowdsale: the length of bonusFinishTimestamp and bonuses is not equal.");

        address crowdsale = CrowdsaleDeployer.addCrowdsale(
            rate,
            token,
            openingTime,
            closingTime,
            operator,
            bonusFinishTimestamp,
            bonuses,
            minInvestmentAmount,
            fee
        );

        // Updating the state
        _crowdsales.push(crowdsale);
        _operatorsContracts[operator].push(crowdsale);

        emit CrowdsaleCreated(
            crowdsale,
            rate,
            token,
            openingTime,
            closingTime,
            operator,
            bonusFinishTimestamp,
            bonuses,
            minInvestmentAmount,
            fee
        );
        return crowdsale;
    }

    // -----------------------------------------
    // OPERATOR FEATURES
    // -----------------------------------------

    function emergencyExit(address crowdsale, address payable newContract) external onlyOwner {
        IRICO(crowdsale).emergencyExit(newContract);
    }

    // -----------------------------------------
    // INVESTOR FEATURES
    // -----------------------------------------

    function openDispute(address crowdsale, bytes32 hash, string calldata reason) external payable returns (uint256) {
        require(IRICO(crowdsale).isInvestor(msg.sender) == true, "openDispute: sender is not an investor.");
        require(IRICO(crowdsale).canInvestorOpenNewDispute(hash, msg.sender) == true, "openDispute: investor cannot open a new dispute.");
        require(IRICO(crowdsale).getMilestoneStatus(hash) == IRICO.MilestoneStatus.DISPUTS_PERIOD, "openDispute: the period for opening new disputes was finished.");

        if (IRICO(crowdsale).didInvestorOpenedDisputeBefore(hash, msg.sender) == true) {
            require(msg.value == _feeForMoreDisputes, "openDispute: for the second and other disputes investor need to pay 1 ETH fee.");
        }

        IRICO(crowdsale).openDispute(hash, msg.sender);
        uint256 disputeID = _arbitersPool.createDispute(hash, crowdsale, msg.sender, reason);

        return disputeID;
    }

    // -----------------------------------------
    // ARBITERSPOOL FEATURES
    // -----------------------------------------

    function solveDispute(address crowdsale, bytes32 hash, address investor, bool investorWins) external {
        require(msg.sender == _arbitersPoolAddress, "solveDispute: the sender is not arbiters pool contract.");

        IRICO(crowdsale).solveDispute(hash, investor, investorWins);
    }

    // -----------------------------------------
    // GETTERS
    // -----------------------------------------

    function getArbitersPoolAddress() external view returns (address) {
        return _arbitersPoolAddress;
    }

    function getAllCrowdsalesAddresses() external view returns (address[] memory crowdsales) {
        crowdsales = new address[](_crowdsales.length);
        for (uint256 i = 0; i < _crowdsales.length; i++) {
            crowdsales[i] = _crowdsales[i];
        }
        return crowdsales;
    }

    function getCrowdsaleMilestones(address crowdsale) external view returns(bytes32[] memory milestonesHashArray) {
        return IRICO(crowdsale).getMilestonesHashes();
    }

    function getOperatorCrowdsaleAddresses(address operator) external view returns (address[] memory crowdsales) {
        crowdsales = new address[](_operatorsContracts[operator].length);
        for (uint256 i = 0; i < _operatorsContracts[operator].length; i++) {
            crowdsales[i] = _operatorsContracts[operator][i];
        }
        return crowdsales;
    }
}