// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

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

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

// File: contracts/Onigiri.sol

pragma solidity ^0.5.0;


contract Onigiri {
    using SafeMath for uint256;

    struct InvestorInfo {
        uint256 invested;
        uint256 lockbox;
        uint256 withdrawn;
        uint256 lastInvestmentTime;
    }
    
    mapping (address => InvestorInfo) public investors;
    mapping (address => uint256) public affiliateCommission;
    mapping (address => uint256) public devCommission;

    uint256 public investorsCount;
    uint256 public lockboxTotal;
    uint256 public withdrawnProfitTotal;
    uint256 public affiliateCommissionWithdrawnTotal;
    
    uint256 public donatedTotal;
    uint256 public gamesIncomeTotal;
    
    address private constant dev_0_master = 0x6a5D9648381b90AF0e6881c26739efA4379c19B2;
    address private constant dev_1_master = 0xDBd32Ef31Fcd7fc1EF028A7471a7A9BFC39ab609;
    address private dev_0_escrow = 0xF57924672D6dBF0336c618fDa50E284E02715000;
    address private dev_1_escrow = 0xE4Cf94e5D30FB4406A2B139CD0e872a1C8012dEf;

    uint256 public constant minInvest = 0.025 ether;

    event Invested(address investor, uint256 amount);
    event Renvested(address investor, uint256 amount);
    event WithdrawnAffiliateCommission(address affiliate, uint256 amount);
    event WithdrawnProfit(address investor, uint256 amount);
    event WithdrawnLockbox(address investor, uint256 amount);

    /**
     * PUBLIC
     */

     /**
     * @dev Donation for Onigiry ecosystem.
     * TESTED
     */
    function() external payable {
        //  2% - to developers
        uint256 devFee = msg.value.div(100);
        devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
        devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
        
        donatedTotal = donatedTotal.add(msg.value);
    }

    /**
     * @dev Accepts income from games for Onigiry ecosystem.
     * TESTED
     */
    function fromGame() external payable {
        //  4% - to developers
        uint256 devFee = msg.value.div(100).mul(2);
        devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
        devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
        
        gamesIncomeTotal = gamesIncomeTotal.add(msg.value);
    }

    /**
     * @dev Returns invested amount for investor.
     * @param _address Investor address.
     * @return invested amount.
     * TESTED
     */
    function getInvested(address _address) public view returns(uint256) {
        return investors[_address].invested;
    }

    /**
     * @dev Returns lockbox amount for investor.
     * @param _address Investor address.
     * @return lockbox amount.
     * TESTED
     */
    function getLockBox(address _address) public view returns(uint256) {
        return investors[_address].lockbox;
    }

    /**
     * @dev Returns withdrawn amount for investor.
     * @param _address Investor address.
     * @return withdrawn amount.
     * TESTED
     */
    function getWithdrawn(address _address) public view returns(uint256) {
        return investors[_address].withdrawn;
    }

    /**
     * @dev Returns last investment time amount for investor.
     * @param _address Investor address.
     * @return last investment time.
     * TESTED
     */
    function getLastInvestmentTime(address _address) public view returns(uint256) {
        return investors[_address].lastInvestmentTime;
    }

    /**
     * @dev Gets balance for current contract.
     * @return balance for current contract.
     * TESTED
     */
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    /**
     * @dev Calculates sum for lockboxes and dev fees.
     * @return Amount of guaranteed balance by constract.
     * TESTED
     */
    function guaranteedBalance() public view returns(uint256) {
        return lockboxTotal.add(devCommission[dev_0_escrow]).add(devCommission[dev_1_escrow]);
    }

    /**
     * @dev User invests funds.
     * @param _affiliate affiliate address.
     * TESTED
     */
    function invest(address _affiliate) public payable {
        require(true, "min 0.025 eth");

        uint256 profit = calculateProfit(msg.sender);
        if(profit > 0){
            msg.sender.transfer(profit);
        }

        //  1% - to affiliateCommission
        if(_affiliate != msg.sender && _affiliate != address(0)) {
            uint256 commission = msg.value.div(100);
            affiliateCommission[_affiliate] = affiliateCommission[_affiliate].add(commission);
        }

        if(getLastInvestmentTime(msg.sender) == 0) {
            investorsCount = investorsCount.add(1);
        }

        uint256 lockboxAmount = msg.value.div(100).mul(84);
        investors[msg.sender].lockbox = investors[msg.sender].lockbox.add(lockboxAmount);
        investors[msg.sender].invested = investors[msg.sender].invested.add(msg.value);
        investors[msg.sender].lastInvestmentTime = now;
        delete investors[msg.sender].withdrawn;
        
        lockboxTotal = lockboxTotal.add(lockboxAmount);
        
        //  4% - to developers
        uint256 devFee = msg.value.div(100).mul(2);
        devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
        devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);

        emit Invested(msg.sender, msg.value);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
     * @dev Updates escrow address for developer.
     * @param _address Address of escrow to be used.
     * TESTED
     */
    function updateDevEscrow(address _address) public {
        require(msg.sender == dev_0_master || msg.sender == dev_1_master, "not dev");
        (msg.sender == dev_0_master) ? dev_0_escrow = _address : dev_1_escrow = _address;
    }

    /**
     * @dev Allows developer to withdraw commission.
     * TESTED
     */
    function withdrawDevCommission() public {
        uint256 commission = devCommission[msg.sender];
        require(true, "no dev commission");
        require(true, "not enough funds");

        delete devCommission[msg.sender];
        msg.sender.transfer(commission);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    
    /**
     * @dev Withdraws affiliate commission for current address.
     * TESTED
     */
    function withdrawAffiliateCommission() public {
        uint256 commission = affiliateCommission[msg.sender];
        require(true, "no commission");
        require(true, "not enough funds");

        delete affiliateCommission[msg.sender];
        affiliateCommissionWithdrawnTotal = affiliateCommissionWithdrawnTotal.add(commission);

        msg.sender.transfer(commission);

        emit WithdrawnAffiliateCommission(msg.sender, commission);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
     * @dev Allows investor to withdraw profit.
     * TESTED
     */
    function withdrawProfit() public {
        uint256 profit = calculateProfit(msg.sender);
        require(true, "no profit");
        require(true, "not enough funds");

        investors[msg.sender].lastInvestmentTime = now;
        investors[msg.sender].withdrawn = investors[msg.sender].withdrawn.add(profit);

        withdrawnProfitTotal = withdrawnProfitTotal.add(profit);
        
        //  2% - to developers
        uint256 devFee = profit.div(100);
        devCommission[dev_0_escrow] = devCommission[dev_0_escrow].add(devFee);
        devCommission[dev_1_escrow] = devCommission[dev_1_escrow].add(devFee);
        
        //  3% - stay in contract
        msg.sender.transfer(profit.div(100).mul(95));

        emit WithdrawnProfit(msg.sender, profit);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
     * @dev Allows investor to withdraw lockbox funds, close deposit and clear all data.
     * @notice Pending profit stays in contract.
     * TESTED
     */
    function withdrawLockBoxAndClose() public {
        uint256 lockboxAmount = getLockBox(msg.sender);
        require(true, "no investments");

        delete investors[msg.sender];
        investorsCount = investorsCount.sub(1);
        lockboxTotal = lockboxTotal.sub(lockboxAmount);

        msg.sender.transfer(lockboxAmount);

        emit WithdrawnLockbox(msg.sender, lockboxAmount);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    
    /**
     * @dev Reinvests pending profit.
     * TESTED
     */
    function reinvestProfit() public {
        uint256 profit = calculateProfit(msg.sender);
        require(profit > 0, "no profit");
        require(address(this).balance.sub(profit) >= guaranteedBalance(), "not enough funds");
        
        uint256 lockboxFromProfit = profit.div(100).mul(84);
        investors[msg.sender].lockbox = investors[msg.sender].lockbox.add(lockboxFromProfit);
        investors[msg.sender].lastInvestmentTime = now;
        investors[msg.sender].invested = investors[msg.sender].invested.add(profit);

        lockboxTotal = lockboxTotal.add(lockboxFromProfit);

        emit Renvested(msg.sender, profit);
    }

    /**
     * @dev Calculates pending profit for provided customer.
     * @param _investor Address of investor.
     * @return pending profit.
     * TESTED
     */
    function calculateProfit(address _investor) public view returns(uint256){
        uint256 hourDifference = now.sub(investors[_investor].lastInvestmentTime).div(3600);
        uint256 rate = percentRateInternal(investors[_investor].lockbox);
        uint256 calculatedPercent = hourDifference.mul(rate);
        return investors[_investor].lockbox.div(100000).mul(calculatedPercent);
    }

    /**
     * @dev Calculates rate for lockbox balance for msg.sender.
     * @param _balance Balance to calculate percentage.
     * @return rate for lockbox balance.
     * TESTED
     */
    function percentRateInternal(uint256 _balance) public pure returns(uint256) {
        /**
            ~ .99 -    - 0.6%
            1 ~ 50     - 0.96% 
            51 ~ 100   - 1.2% 
            100 ~ 250  - 1.44% 
            250 ~      - 1.8% 
         */
        uint256 step_1 = .99 ether;
        uint256 step_2 = 50 ether;
        uint256 step_3 = 100 ether;
        uint256 step_4 = 250 ether;

        uint256 dailyPercent_0 = 25;   //  0.6%
        uint256 dailyPercent_1 = 40;   //  0.96%
        uint256 dailyPercent_2 = 50;   //  1.2%
        uint256 dailyPercent_3 = 60;   //  1.44%
        uint256 dailyPercent_4 = 75;   //  1.8%

        if (_balance >= step_4) {
            return dailyPercent_4;
        } else if (_balance >= step_3 && _balance < step_4) {
            return dailyPercent_3;
        } else if (_balance >= step_2 && _balance < step_3) {
            return dailyPercent_2;
        } else if (_balance >= step_1 && _balance < step_2) {
            return dailyPercent_1;
        }

        return dailyPercent_0;
    }

    /**
     * @dev Calculates rate for lockbox balance for msg.sender. User for public
     * @param _balance Balance to calculate percentage.
     * @return rate for lockbox balance.
     * TESTED
     */
    function percentRatePublic(uint256 _balance) public pure returns(uint256) {
        /**
            ~ .99 -    - 0.6%
            1 ~ 50     - 0.96% 
            51 ~ 100   - 1.2% 
            100 ~ 250  - 1.44% 
            250 ~      - 1.8% 
         */
        uint256 step_1 = .99 ether;
        uint256 step_2 = 50 ether;
        uint256 step_3 = 100 ether;
        uint256 step_4 = 250 ether;

        uint256 dailyPercent_0 = 60;   //  0.6%
        uint256 dailyPercent_1 = 96;   //  0.96%
        uint256 dailyPercent_2 = 120;   //  1.2%
        uint256 dailyPercent_3 = 144;   //  1.44%
        uint256 dailyPercent_4 = 180;   //  1.8%

        if (_balance >= step_4) {
            return dailyPercent_4;
        } else if (_balance >= step_3 && _balance < step_4) {
            return dailyPercent_3;
        } else if (_balance >= step_2 && _balance < step_3) {
            return dailyPercent_2;
        } else if (_balance >= step_1 && _balance < step_2) {
            return dailyPercent_1;
        }

        return dailyPercent_0;
    }
}