/**
 *Submitted for verification at Etherscan.io on 2020-08-11
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

//Note that assert() is now used because the try/catch mechanism in the Pamp.sol contract does not revert on failure with require();

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a/*, "SafeMath: addition overflow"*/);

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        assert(b <= a/*, errorMessage*/);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        assert(c / a == b/*, "SafeMath: multiplication overflow"*/);

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        assert(b > 0/*, errorMessage*/);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        assert(b != 0/*, errorMessage*/);
        return a % b;
    }
}

// Contract used to calculate stakes. Unused currently.

abstract contract CalculatorInterface {
    function calculateNumTokens(uint numerator, uint denominator, uint price, uint volume, uint _streak, uint256 balance, uint256 daysStaked, address stakerAddress, uint256 totalSupply) public view virtual returns (uint256);
    function negativeDayCallback(int numerator, uint denominator, uint256 price, uint256 volume) public virtual;
    function iterativelyCalculateOwedRewards(uint stakerLastTimestamp, uint stakerStartTimestamp, uint balance, address stakerAddress, uint totalSupply) public virtual view returns (uint256);
}


// Parent token contract, see Pamp.sol
abstract contract PampToken {
    function balanceOf(address account) public view virtual returns (uint256);
    function _burn(address account, uint256 amount) external virtual;
    function mint(address account, uint256 amount) public virtual;
}

abstract contract PreviousContract {
    function resetStakeTimeMigrateState(address addr) external virtual returns (uint256 startTimestamp, uint256 lastTimestamp);
    function getWhitelist(address addr) external virtual view returns (string memory);
}



/**
 * @dev Implementation of the Pamp Network: https://pamp.network
 * Pamp Network (PAMP) is the world's first price-reactive cryptocurrency.
 * The inflation rate of the token is wholly dependent on its market activity.
 * Minting does not happen when the price is less than the day prior.
 * When the price is greater than the day prior, the inflation for that day is
 * a function of its price, percent increase, volume, any positive price streaks,
 * and the amount of time a given holder has been holding.
 * In the first iteration, the dev team acts as the price oracle, but in the future, we plan to integrate a Chainlink price oracle.
 * This contract is the staking contract for the project and is upgradeable by the owner.
 * This is the staking contract V2, deployed at 0x2ceff2fc3257b9e66d69de3081483563a9d522dd
 */
contract PampStaking {
    using SafeMath for uint256;
    
    address public owner;
    
    // A 'staker' is an individual who holds the minimum staking amount in his address.
    
    struct staker {
        uint startTimestamp;    // When the staking started in unix time (block.timesamp)
        uint lastTimestamp;     // When the last staking reward was claimed in unix time (block.timestamp)
        bool hasMigrated;       // Has the staker migrated from the previous contract?
    }
    
    struct update {             // Price updateState
        uint timestamp;         // Last update timestamp, unix time
        uint numerator;         // Numerator of percent change (1% increase = 1/100)
        uint denominator;       // Denominator of percent change
        uint price;         // In USD. 0001 is $0.001, 1000 is $1.000, 1001 is $1.001, etc
        uint volume;        // In whole USD (100 = $100)
        uint streak;        // We save the current streak to use later
    }
    
    PampToken public token;     // ERC20 token contract that uses this upgradeable contract for staking and burning
    
    modifier onlyToken() {
        assert(msg.sender == address(token)/*, "Caller must be PAMP token contract."*/);
        _;
    }
    
    modifier onlyNextStakingContract() {    // Caller must be the next staking contract
        assert(msg.sender == nextStakingContract);
        _;
    }
    
    modifier onlyOracle() {
        assert(msg.sender == oracle);
        _;
    }
    
    modifier onlyOwner() {
        assert(msg.sender == owner);
        _;
    }

    
    mapping (address => staker) public stakers;        // Mapping of all individuals staking/holding tokens greater than minStake
    
    mapping (address => string) public whitelist;      // Mapping of all addresses that do not burn tokens on receive and send (generally other smart contracts). Mapping of address to reason (string)
    
    mapping (address => uint256) public blacklist;     // Mapping of all addresses that receive a specific token burn when receiving. Mapping of address to percent burn (uint256)
    
    mapping (address => string) public uniwhitelist; // Mapping of all addresses that do not burn tokens when sending to or selling on Uniswap. Mapping of address to reason (string)
    

    bool public enableBurns; // Enable burning on transfer or fee on transfer
    
    bool public priceTarget1Hit;  // Price targets, defined in updateState()
    
    bool public priceTarget2Hit;
    
    address public uniswapV2Pair;      // Uniswap pair address, done for fees on Uniswap sells
    
    uint public uniswapSellerBurnPercent;        // Uniswap sells pay a fee. Should be based on negative streaks
    
    uint public transferBurnPercent;
    
    bool public enableUniswapDirectBurns;         // Enable seller fees on Uniswap
    
    uint256 public minStake;                      // Minimum amount to stake
        
    uint8 public minStakeDurationDays;            // Minimum amount of time to claim staking rewards
    
    uint8 public minPercentIncrease;              // Minimum percent increase to enable rewards for the day. 10 = 1.0%, 100 = 10.0%
    
    uint256 public inflationAdjustmentFactor;     // Factor to adjust the amount of rewards (inflation) to be given out in a single day
    
    uint256 public streak;                        // Number of days in a row that the price has increased
    
    uint public maxStreak;                          // Max number of days in a row we consider streak bonuses
        
    uint public negativeStreak;                     // Number of days in a row that the price has decreased
    
    update public lastUpdate;                      // latest price update

    uint public lastNegativeUpdate;                 // last time the price was negative (unix timestamp)
    
    CalculatorInterface public externalCalculator;    // external calculator to calculate the number of tokens given several variables (defined above). Currently unused
    
    address public nextStakingContract;                // Next staking contract deployed. Used for migrating staker state.
    
    bool public useExternalCalc;                      // self-explanatory
    
    bool public useExternalCalcIterative;
    
    bool public freeze;                               // freeze all transfers in an emergency
    
    bool public enableHoldersDay;                     // once a month, holders receive a nice bump. This is true for 24 hours, once a month only.
    
    mapping (bytes32 => bool) public holdersDayRewarded; // Mapping to test whether an individual received his Holder's Day reward
    
    event StakerRemoved(address StakerAddress);     // Staker was removed due to balance dropping below minStake
    
    event StakerAdded(address StakerAddress);       // Staker was added due to balance increasing abolve minStake
    
    event StakesUpdated(uint Amount);               // Staking rewards were claimed
    
    event HoldersDayEnabled();
    
    event HoldersDayRewarded(uint Amount);
    
    event Migration(address StakerAddress);
    
    event MassiveCelebration();                     // Happens when price targets are hit
    
    event Transfer(address indexed from, address indexed to, uint256 value);        // self-explanatory
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    uint public maxStakingDays;
    
    uint public holdersDayRewardDenominator;
    
    update[] public updates;
    
    address public liquidityStakingContract;
    
    address public oracle;
    
    PreviousContract public previousStakingContract;
    
    uint public numStakers;
    
    bool public increaseTransferFees;

    bool public checkPreviousStakingContractWhitelist;
    
    constructor () public {
        owner = msg.sender;
        token = PampToken(0xF0FAC7104aAC544e4a7CE1A55ADF2B5a25c65bD1);
        minStake = 200E18;
        inflationAdjustmentFactor = 800;
        streak = 0;
        minStakeDurationDays = 1;
        useExternalCalc = false; 
        useExternalCalcIterative = false;
        uniswapSellerBurnPercent = 8;
        enableBurns = true;
        freeze = false;
        minPercentIncrease = 10; // 1.0% min increase
        enableUniswapDirectBurns = true;
        transferBurnPercent = 8;
        priceTarget1Hit = true;
        oracle = msg.sender;
        maxStreak = 7;
        holdersDayRewardDenominator = 600;
        maxStakingDays = 100;
        increaseTransferFees = false;
        checkPreviousStakingContractWhitelist = true;
        previousStakingContract = PreviousContract(0x1d2121Efe25535850d1FDB65F930FeAB093416E0);
        uniswapV2Pair = 0x1C608235E6A946403F2a048a38550BefE41e1B85;
        liquidityStakingContract = 0x5CECDbdfB96463045b07d07aAa4fc2F1316F7e47;
    }
    
    // The owner (or price oracle) will call this function to update the price on days the coin is positive. On negative days, no update is made.
    
    function updateState(uint numerator, uint denominator, uint256 price, uint256 volume) public onlyOracle {  // when Chainlink is integrated a separate contract will call this function (oracle address will be changed as well)	//inject PUBLIC FUNC TO EXTERNAL
    
        require(numerator > 0 && denominator > 0 && price > 0 && volume > 0, "Parameters cannot be negative or zero");
        
        if ((numerator < 2 && denominator == 100) || (numerator < 20 && denominator == 1000)) {
            require(mulDiv(1000, numerator, denominator) >= minPercentIncrease, "Increase must be at least minPercentIncrease to count");
        }
        
        uint secondsSinceLastUpdate = (block.timestamp - lastUpdate.timestamp);       // We calculate time since last price update in days.
        
        if (secondsSinceLastUpdate < 129600) { // We should only update once per day, but block timestamps can vary
            streak++;
        } else {
            streak = 1;
        }
        
        if (streak > maxStreak) {
            streak = maxStreak;
        }
        
        if (price >= 1000 && priceTarget1Hit == false) { // 1000 = $1.00
            priceTarget1Hit = true;
            streak = 50;
            emit MassiveCelebration();
            
        } else if (price >= 10000 && priceTarget2Hit == false) {   // It is written, so it shall be done
            priceTarget2Hit = true;
            streak = maxStreak;
            minStake = 100E18;        // Need $1000 to stake
            emit MassiveCelebration();
        }
        
        if(negativeStreak > 0) {
            uniswapSellerBurnPercent = uniswapSellerBurnPercent - (negativeStreak * 2);
            if(increaseTransferFees) {
                transferBurnPercent = transferBurnPercent - (negativeStreak * 2);
            }
            negativeStreak = 0;
        }
        
        
        lastUpdate = update(block.timestamp, numerator, denominator, price, volume, streak);
        
        updates.push(lastUpdate);

    }
    
    // We now update the smart contract on negative days. Currently this is only used to increase the Uniswap burn percent, but we may perform other functionality in the future.
    function updateStateNegative(int numerator, uint denominator, uint256 price, uint256 volume) public onlyOracle { 	//inject PUBLIC FUNC TO EXTERNAL
        require(numerator < minPercentIncrease);
        
        uint secondsSinceLastUpdate = (block.timestamp - lastNegativeUpdate);       // We calculate time since last negative price update in days.
        
        if (secondsSinceLastUpdate < 129600) { // We should only update once per day, but block timestamps can vary
            negativeStreak++;
        } else {
            negativeStreak = 0;
        }
        
        streak = 1;
        
        uniswapSellerBurnPercent = uniswapSellerBurnPercent + (negativeStreak * 2);     // Negative day streaks increase burn fees
        
        if(increaseTransferFees) {
            transferBurnPercent = transferBurnPercent + (negativeStreak * 2);       // May have to contact exchanges about this
        }
        
        lastNegativeUpdate = block.timestamp;

        if(useExternalCalc) {
            externalCalculator.negativeDayCallback(numerator, denominator, price, volume);
        }
        
    }
    
    // This is used by the next staking contract to migrate staker state
    function resetStakeTimeMigrateState(address addr) public onlyNextStakingContract returns (uint256 startTimestamp, uint256 lastTimestamp) {	//inject PUBLIC FUNC TO EXTERNAL
        startTimestamp = stakers[addr].startTimestamp;
        lastTimestamp = stakers[addr].lastTimestamp;
        stakers[addr].lastTimestamp = block.timestamp;
        stakers[addr].startTimestamp = block.timestamp;
    }
    
    function migratePreviousState() public {      // Migrate state to new contract and reset state from old contract. Also reset current state to block.timestamp if it is zero otherwise	//inject PUBLIC FUNC TO EXTERNAL
        
        require(stakers[msg.sender].lastTimestamp == 0, "Last timestamp must be zero");
        require(stakers[msg.sender].startTimestamp == 0, "Start timestamp must be zero");
        require(!stakers[msg.sender].hasMigrated);
        
        (uint startTimestamp, uint lastTimestamp) = previousStakingContract.resetStakeTimeMigrateState(msg.sender);
        
        if(startTimestamp == 0) {
            stakers[msg.sender].startTimestamp = block.timestamp;
        } else {
            stakers[msg.sender].startTimestamp = startTimestamp;
        }
        if(lastTimestamp == 0) {
            stakers[msg.sender].lastTimestamp = block.timestamp;
        } else {
            stakers[msg.sender].lastTimestamp = lastTimestamp;
        }
        
        if(stakers[msg.sender].startTimestamp > stakers[msg.sender].lastTimestamp) {
            stakers[msg.sender].lastTimestamp = block.timestamp;
        }
        
        stakers[msg.sender].hasMigrated = true;
        
        numStakers++;
        
        emit Migration(msg.sender);
    }
    
    function updateMyStakes(address stakerAddress, uint256 balance, uint256 totalSupply) public onlyToken returns (uint256) {     // This function is called by the token contract. Holders call the function on the token contract to claim rewards.	//inject PUBLIC FUNC TO EXTERNAL
        
        assert(balance > 0);
        
        staker memory thisStaker = stakers[stakerAddress];
        
        assert(thisStaker.lastTimestamp > 0/*,"Error: your last timestamp cannot be zero."*/); // We use asserts now so that we fail on errors due to try/catch in token contract.
        
        assert(thisStaker.startTimestamp > 0/*,"Error: your start timestamp cannot be zero."*/);
        
        assert(thisStaker.hasMigrated);     // If you didn't migrate or reset your state, you can't claim
        
        assert(block.timestamp > thisStaker.lastTimestamp/*, "Error: block timestamp is not greater than your last timestamp!"*/);
        assert(lastUpdate.timestamp > thisStaker.lastTimestamp/*, "Error: you can only update stakes once per day. You also cannot update stakes on the same day that you purchased them."*/);
        
        uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
        
        assert(daysStaked >= minStakeDurationDays/*, "You must stake for at least minStakeDurationDays to claim rewards"*/);
        assert(balance >= minStake/*, "You must have a balance of at least minStake to claim rewards"*/);
        
        assert(thisStaker.lastTimestamp >= thisStaker.startTimestamp); // last timestamp should be greater than or equal to start timestamp
        
        uint numTokens = iterativelyCalculateOwedRewards(thisStaker.lastTimestamp, thisStaker.startTimestamp, balance, stakerAddress, totalSupply);
        
        stakers[stakerAddress].lastTimestamp = block.timestamp;        // Again, this can be gamed to some extent, but *cannot be before the last block*
        emit StakesUpdated(numTokens);
        
        return numTokens;       // Token contract will add these tokens to the balance of stakerAddress
    }
    
    struct iterativeCalculationVariables {
        uint index;
        uint bound;
        uint numTokens;
        uint calculatedTokens;
    }
    
    
    // Calculate owed rewards for several days, iterating back through the updates array. This is public so that the frontend can calculate expected rewards.
    function iterativelyCalculateOwedRewards(uint stakerLastTimestamp, uint stakerStartTimestamp, uint balance, address stakerAddress, uint totalSupply) public view returns (uint256) {
        
        if(useExternalCalcIterative) {
            return externalCalculator.iterativelyCalculateOwedRewards(stakerLastTimestamp, stakerStartTimestamp, balance, stakerAddress, totalSupply);
        }
        
        iterativeCalculationVariables memory vars;    // Necessary to fix stack too deep error
         
        vars.index = updates.length.sub(1); // Start from the latest update and work our way back
        
        if(vars.index > 60) {
            vars.bound = vars.index.sub(60);        // We bound the loop to 60 iterations (60 positive days)
        } else {
            vars.bound = vars.index.add(1);                    // No bound on the loop because the number of elements is less than 60
        }

        vars.numTokens = 0;
        
        for(bool end = false; end == false;) {
            
            update memory nextUpdate = updates[vars.index];      // Grab the last update from the array
            if(stakerLastTimestamp > nextUpdate.timestamp || stakerStartTimestamp > nextUpdate.timestamp || vars.index == vars.bound) { // If the staker's last timestamp or start timestamp is ahead of the next update, the staker is not owed the rewards from that update, and the updates array is in chronological order, so we end here, we also check for the bound
                end = true;
            } else {
                uint estimatedDaysStaked = nextUpdate.timestamp.sub(stakerStartTimestamp) / 86400; // We estimate the staker's holding time from the point of view of this current update
                
                vars.calculatedTokens = calculateNumTokens(nextUpdate.numerator, nextUpdate.denominator, nextUpdate.price, nextUpdate.volume, nextUpdate.streak, balance, estimatedDaysStaked, stakerAddress, totalSupply); // calculate the owed tokens from this update
                
                vars.numTokens = vars.numTokens.add(vars.calculatedTokens);
                
                balance = balance.add(vars.calculatedTokens); // We support compound interest
            }
            
            if (vars.index > 0) {
                vars.index = vars.index.sub(1);     // Only subtract when nonzero, so we don't underflow
            } else {
                end = true;
            }
            
        }
        return vars.numTokens;
    }

    function calculateNumTokens(uint numerator, uint denominator, uint price, uint volume, uint _streak, uint256 balance, uint256 daysStaked, address stakerAddress, uint256 totalSupply) public view returns (uint256) { // This is public so that the Pamp frontend can calculate expected rewards without any js issues
        
        if (useExternalCalc) {
            return externalCalculator.calculateNumTokens(numerator, denominator, price, volume, _streak, balance, daysStaked, stakerAddress, totalSupply); // Use external contract, if one is enabled (disabled by default, currently unused)
        }
        
        uint256 _inflationAdjustmentFactor = inflationAdjustmentFactor;
        
        if (_streak > 1) {
            _inflationAdjustmentFactor = _inflationAdjustmentFactor.sub(mulDiv(_inflationAdjustmentFactor, _streak*10, 100));       // If there is a streak, we decrease the inflationAdjustmentFactor
        }
        
        if (daysStaked > maxStakingDays) {      // If you stake for more than maxStakingDays days, you have hit the upper limit of the multiplier
            daysStaked = maxStakingDays;
        } else if (daysStaked == 0) {   // If the minimum days staked is zero, we change the number to 1 so we don't return zero below
            daysStaked = 1;
        }
        
        uint ratio = mulDiv(totalSupply, price, 1000E18).div(volume);       // Ratio of market cap (including locked team tokens) to volume
        
        if (ratio > 50) {  // Too little volume. Decrease rewards. To be honest, this number was arbitrarily chosen.
            _inflationAdjustmentFactor = _inflationAdjustmentFactor.mul(10);
        } else if (ratio > 25) { // Still not enough. Streak doesn't count.
            _inflationAdjustmentFactor = inflationAdjustmentFactor;
        }
        
        uint numTokens = mulDiv(balance, numerator * daysStaked, denominator * _inflationAdjustmentFactor);      // Function that calculates how many tokens are due. See muldiv below.
        uint tenPercent = mulDiv(balance, 1, 10);
        
        if (numTokens > tenPercent) {       // We don't allow a daily rewards of greater than ten percent of a holder's balance.
            numTokens = tenPercent;
        }
        
        return numTokens;
    }

    function getDaysStaked(address _staker) public view returns(uint) {	//inject PUBLIC FUNC TO EXTERNAL
        return block.timestamp.sub(stakers[_staker].startTimestamp) / 86400;
    }    
        
    // This function can be called once a month, when holder's day is enabled
    function claimHoldersDay() public {	//inject PUBLIC FUNC TO EXTERNAL
        
        require(!getHoldersDayRewarded(msg.sender), "You've already claimed Holder's Day");
        require(enableHoldersDay, "Holder's Day is not enabled");

        staker memory thisStaker = stakers[msg.sender];
        uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
        require(daysStaked >= 30, "You must stake for 30 days to claim holder's day rewards");
        if (enableHoldersDay && daysStaked >= 30) {
            if (daysStaked > maxStakingDays) {      // If you stake for more than maxStakingDays days, you have hit the upper limit of the multiplier
                daysStaked = maxStakingDays;
            }
            setHoldersDayRewarded(msg.sender);
            uint numTokens = mulDiv(token.balanceOf(msg.sender), daysStaked, holdersDayRewardDenominator);   // Once a month, holders get a nice bump
            token.mint(msg.sender, numTokens);
            emit HoldersDayRewarded(numTokens);
        }
        
    }

    uint32 public currentHoldersDayRewardedVersion;

    function getHoldersDayRewarded(address holder) internal view returns(bool) {
        bytes32 key = keccak256(abi.encodePacked(currentHoldersDayRewardedVersion, holder));
        return holdersDayRewarded[key];
    }

    function setHoldersDayRewarded(address holder) internal {
        bytes32 key = keccak256(abi.encodePacked(currentHoldersDayRewardedVersion, holder));
        holdersDayRewarded[key] = true;
    }

    function deleteHoldersDayRewarded() internal {
        currentHoldersDayRewardedVersion++;
    }
        
    function updateHoldersDay(bool _enableHoldersDay) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        enableHoldersDay = _enableHoldersDay;
        if(enableHoldersDay) {
            deleteHoldersDayRewarded();
            emit HoldersDayEnabled();
        }
    }
    
    // Self-explanatory functions to update several configuration variables
    
    function updateTokenAddress(PampToken newToken) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        require(address(newToken) != address(0));
        token = newToken;
    }
    
    function updateCalculator(CalculatorInterface calc) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        if(address(calc) == address(0)) {
            externalCalculator = CalculatorInterface(address(0));
            useExternalCalc = false;
        } else {
            externalCalculator = calc;
            useExternalCalc = true;
        }
    }
    
    function updateUseExternalCalcIterative(bool _useExternalCalcIterative) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        useExternalCalcIterative = _useExternalCalcIterative;
    }
    
    
    function updateInflationAdjustmentFactor(uint256 _inflationAdjustmentFactor) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        inflationAdjustmentFactor = _inflationAdjustmentFactor;
    }
    
    function updateStreak(bool negative, uint _streak) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        if(negative) {
            negativeStreak = _streak;
        } else {
            streak = _streak;
        }
    }
    
    function updateMinStakeDurationDays(uint8 _minStakeDurationDays) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        minStakeDurationDays = _minStakeDurationDays;
    }
    
    function updateMinStakes(uint _minStake) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        minStake = _minStake;
    }
    function updateMinPercentIncrease(uint8 _minIncrease) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        minPercentIncrease = _minIncrease;
    }
    
    function updateEnableBurns(bool _enabledBurns) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        enableBurns = _enabledBurns;
    }
    
    function updateWhitelist(address addr, string calldata reason, bool remove) external onlyOwner {
        if (remove) {
            delete whitelist[addr];
        } else {
            whitelist[addr] = reason;
        }
    }
    
    function updateUniWhitelist(address addr, string calldata reason, bool remove) external onlyOwner {
        if (remove) {
            delete uniwhitelist[addr];
        } else {
            uniwhitelist[addr] = reason;
        }     
    }
    
    function updateBlacklist(address addr, uint256 fee, bool remove) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        if (remove) {
            delete blacklist[addr];
        } else {
            blacklist[addr] = fee;
        }
    }
    
    function updateUniswapPair(address addr) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        require(addr != address(0));
        uniswapV2Pair = addr;
    }
    
    function updateEnableUniswapSellBurns(bool _enableDirectSellBurns) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        enableUniswapDirectBurns = _enableDirectSellBurns;
    }
    
    function updateUniswapSellBurnPercent(uint8 _sellerBurnPercent) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        uniswapSellerBurnPercent = _sellerBurnPercent;
    }
    
    function updateFreeze(bool _enableFreeze) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        freeze = _enableFreeze;
    }
    
    function updateNextStakingContract(address nextContract) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        nextStakingContract = nextContract;
    }
    
    function updateLiquidityStakingContract(address _liquidityStakingContract) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        liquidityStakingContract = _liquidityStakingContract;
    }
    
    function updateOracle(address _oracle) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        oracle = _oracle;
    }
    
    function updatePreviousStakingContract(PreviousContract previousContract) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        previousStakingContract = previousContract;
    }

    function updateTransferBurnFee(uint _transferBurnFee) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        transferBurnPercent = _transferBurnFee;
    }

    function updateMaxStreak(uint _maxStreak) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        maxStreak = _maxStreak;
    }

    function updateMaxStakingDays(uint _maxStakingDays) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        maxStakingDays = _maxStakingDays;
    }

    function updateHoldersDayRewardDenominator(uint _holdersDayRewardDenominator) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        holdersDayRewardDenominator = _holdersDayRewardDenominator;
    }

    function updateIncreaseTransferFees(bool _increaseTransferFees) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        increaseTransferFees = _increaseTransferFees;
    }

    function updateCheckPreviousContractWhitelist(bool _checkPreviousStakingContractWhitelist) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        checkPreviousStakingContractWhitelist = _checkPreviousStakingContractWhitelist;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        assert(newOwner != address(0)/*, "Ownable: new owner is the zero address"*/);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
    
    function getStaker(address _staker) public view returns (uint256, uint256, bool) {	//inject PUBLIC FUNC TO EXTERNAL
        return (stakers[_staker].startTimestamp, stakers[_staker].lastTimestamp, stakers[_staker].hasMigrated);
    }
    
    
    function removeLatestUpdate() public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
        delete updates[updates.length - 1];
    }

    
    // This function was not written by us. It was taken from here: https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
    // We believe it works but do not have the understanding of math required to verify it 100%.
    // Takes in three numbers and calculates x * (y/z)
    // This is very useful for this contract as percentages are used constantly

    function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
          (uint l, uint h) = fullMul (x, y);
          assert (h < z);
          uint mm = mulmod (x, y, z);
          if (mm > l) h -= 1;
          l -= mm;
          uint pow2 = z & -z;
          z /= pow2;
          l /= pow2;
          l += h * ((-pow2) / pow2 + 1);
          uint r = 1;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          return l * r;
    }
    
    function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
          uint mm = mulmod (x, y, uint (-1));
          l = x * y;
          h = mm - l;
          if (mm < l) h -= 1;
    }

    // Hooks the transfer() function on pamptoken. All transfers call this function. Takes in sender, recipient address and balances and amount and returns sender balance, recipient balance, and burned amount
    function transferHook(address sender, address recipient, uint256 amount, uint256 senderBalance, uint256 recipientBalance) public onlyToken returns (uint256, uint256, uint256) {	//inject PUBLIC FUNC TO EXTERNAL
        
        if(sender == liquidityStakingContract) {
            // Liquidity staking rewards are now part of inflation.
            return (senderBalance, recipientBalance.add(amount), 0);
        }

        if(checkPreviousStakingContractWhitelist){      // Check the previous contract whitelists to ensure we are up-to-date
            string memory whitelistSender = previousStakingContract.getWhitelist(sender);
            string memory whitelistRecipient = previousStakingContract.getWhitelist(recipient);
            
            if(bytes(whitelistSender).length > 0) {
                whitelist[sender] = whitelistSender;
            }
            if(bytes(whitelistRecipient).length > 0) {
                whitelist[recipient] = whitelistRecipient;
            }
        }
        
        assert(freeze == false);
        assert(sender != recipient);
        assert(amount > 0);
        assert(senderBalance >= amount);
        
        
        uint totalAmount = amount;
        bool shouldAddStaker = true;    // We assume that the recipient is a potential staker (not a smart contract)
        uint burnedAmount = 0;
        
        if (enableBurns && bytes(whitelist[sender]).length == 0 && bytes(whitelist[recipient]).length == 0) { // Burns are enabled and neither the recipient nor the sender are whitelisted
                
            burnedAmount = mulDiv(amount, burnFee(), 100); // Amount to be burned
            
            
            if (blacklist[recipient] > 0) {   //Transferring to a blacklisted address incurs a specific fee
                burnedAmount = mulDiv(amount, blacklist[recipient], 100);      // Calculate the fee. The fee is burnt
                shouldAddStaker = false;            // Blacklisted addresses will never be stakers. Could be an issue if the blacklisted address already is a staker, but likely not an issue
            }
            
            
            
            if (burnedAmount > 0) {
                if (burnedAmount > amount) {
                    totalAmount = 0;
                } else {
                    totalAmount = amount.sub(burnedAmount);
                }
                senderBalance = senderBalance.sub(burnedAmount, "ERC20: burn amount exceeds balance");  // Remove the burned amount from the sender's balance
            }
        } else if (recipient == uniswapV2Pair) {    // Uniswap was used. This is a special case. Uniswap is burn on receive but whitelist on send, so sellers pay fee and buyers do not.
            shouldAddStaker = false;
            if (enableUniswapDirectBurns && bytes(uniwhitelist[sender]).length == 0) { // We check if burns are enabled and if the sender is whitelisted
                burnedAmount = mulDiv(amount, uniswapSellerBurnPercent, 100);     // Seller fee
                if (burnedAmount > 0) {
                    if (burnedAmount > amount) {
                        totalAmount = 0;
                    } else {
                        totalAmount = amount.sub(burnedAmount);
                    }
                    senderBalance = senderBalance.sub(burnedAmount, "ERC20: burn amount exceeds balance");
                }
            }
        
        }
        
        if (bytes(whitelist[recipient]).length > 0) {
            shouldAddStaker = false;
        } else if (recipientBalance >= minStake && checkPreviousStakingContractWhitelist) { // We use checkPreviousStakingContractWhitelist because we don't want to create a new boolean with a setter
            assert(stakers[recipient].hasMigrated);  // The staker is not whitelisted so must migrate or reset their staking time in order to receive a balance
        }
        
        // Here we calculate the percent of the balance an address is receiving. If the address receives too many tokens, the staking time and last time rewards were claimed is reset to block.timestamp
        // This is necessary because otherwise funds could move from address to address with no penality and thus an individual could claim multiple times with the same funds
        
        if (shouldAddStaker && stakers[recipient].startTimestamp > 0 && recipientBalance > 0) {  // If you are currently staking, these should all be true
        
            assert(stakers[recipient].hasMigrated);    // The staker must migrate their staking time in order to receive a balance
            
            uint percent = mulDiv(1000000, totalAmount, recipientBalance);      // This is not really 'percent' it is just a number that represents the totalAmount as a fraction of the recipientBalance. We divide by 2 to reduce the effects
            if(percent == 0) {
                percent == 2;
            }
            percent = percent.div(2);       // Divide it by 2 so it's not as harsh

            if(percent.add(stakers[recipient].startTimestamp) > block.timestamp) {         // We represent the 'percent' as seconds and add to the recipient's unix time
                stakers[recipient].startTimestamp = block.timestamp;
            } else {
                stakers[recipient].startTimestamp = stakers[recipient].startTimestamp.add(percent);               // Receiving too many tokens resets your holding time
            }
            if(percent.add(stakers[recipient].lastTimestamp) > block.timestamp) {
                stakers[recipient].lastTimestamp = block.timestamp;
            } else {
                stakers[recipient].lastTimestamp = stakers[recipient].lastTimestamp.add(percent);                 // Receiving too many tokens may make you ineligible to claim the next day
            }
        } else if (shouldAddStaker && recipientBalance == 0 && (stakers[recipient].startTimestamp > 0 || stakers[recipient].lastTimestamp > 0)) { // Invalid state, so we reset their data/remove them
            delete stakers[recipient];
            numStakers--;
            emit StakerRemoved(recipient);
        }
        
        senderBalance = senderBalance.sub(totalAmount, "ERC20: transfer amount exceeds balance");       // Normal ERC20 transfer
        recipientBalance = recipientBalance.add(totalAmount);
        
        if (shouldAddStaker && stakers[recipient].startTimestamp == 0 && (totalAmount >= minStake || recipientBalance >= minStake)) {        // If the recipient was not previously a staker and their balance is now greater than minStake, we add them automatically
            numStakers++;
            stakers[recipient] = staker(block.timestamp, block.timestamp, true);
            emit StakerAdded(recipient);
        }
        
        if (senderBalance < minStake) {        // If the sender's balance is below the minimum stake, we remove them automatically
            // Remove staker
            delete stakers[sender];
            numStakers--;
            emit StakerRemoved(sender);
        } else {
            stakers[sender].startTimestamp = block.timestamp;      // Sending tokens automatically resets your 'holding time'
            stakers[sender].lastTimestamp = block.timestamp;       // Can't claim after sending tokens
            stakers[sender].hasMigrated = true;       // Can't claim after sending tokens
        }
    
        return (senderBalance, recipientBalance, burnedAmount);
    }
    
    
    function burnFee() internal view returns (uint256) {        // Determines the transaction burn fee
        return transferBurnPercent;
    }
    
    function burn(address account, uint256 amount) public onlyOwner {     // We allow ourselves to burn tokens in case they were minted due to a bug	//inject PUBLIC FUNC TO EXTERNAL
        token._burn(account, amount);
    }
    
    function liquidityRewards(address recipient, uint amount) public {    // For future liquidity rewards contract (calling mint is better than adding to recipient balance)	//inject PUBLIC FUNC TO EXTERNAL
        require(msg.sender == liquidityStakingContract);
        token.mint(recipient, amount);
    }
    
    function resetStakeTimeDebug(address account, uint startTimestamp, uint lastTimestamp, bool migrated) public onlyOwner {      // We allow ourselves to reset stake times in case they get changed incorrectly due to a bug	//inject PUBLIC FUNC TO EXTERNAL
        stakers[account].lastTimestamp = startTimestamp;
        stakers[account].startTimestamp = lastTimestamp;
        stakers[account].hasMigrated = migrated;
    }



}