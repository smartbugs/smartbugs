pragma solidity ^0.5.0;

/**
 *  X3ProfitInMonthV2 contract (300% per 33 day, 99% per 11 day, 9% per day, in first iteration)
 *  This percent will decrease every restart of system to lowest value of 0.9% per day
 *
 *  Improved, no bugs and backdoors! Your investments are safe!
 *
 *  LOW RISK! You can take your deposit back ANY TIME!
 *     - Send 0.00000112 ETH to contract address
 *
 *  NO DEPOSIT FEES! All the money go to contract!
 *
 *  LOW WITHDRAWAL FEES! Advertising 10% to OUR MAIN CONTRACT 0xf85D337017D9e6600a433c5036E0D18EdD0380f3
 *
 *  HAVE COMMAND PREPARATION TIME DURING IT WILL BE RETURN ONLY INVESTED AMOUNT AND NOT MORE!
 *  Only special command will run X3 MODE!
 * 
 *  After restart system automaticaly make deposits for damage users in damaged part, 
 *   but before it users must self make promotion deposit by any amount first.
 *
 *  INSTRUCTIONS:
 *
 *  TO INVEST: send ETH to contract address
 *  TO WITHDRAW INTEREST: send 0 ETH to contract address
 *  TO REINVEST AND WITHDRAW INTEREST: send ETH to contract address
 *  TO GET BACK YOUR DEPOSIT: send 0.00000112 ETH to contract address
 *  TO START X3 WORK, ANY MEMBER CAN VOTE 0.00000111 ETH to contract address
 *     While X3 not started investors can return only their deposits and no profit.
 *     Admin voice power is equal 10 simple participants
 *  TO RESTART, ANY MEMBER CAN VOTE 0.00000101 ETH to contract address
 *     Admin voice power is equal 10 simple participants
 *
 *  RECOMMENDED GAS LIMIT 350000
 */
 
contract X3ProfitInMonthV2 {

	struct Investor {
	      // Restart iteration index
		uint iteration;
          // array containing information about beneficiaries
		uint deposit;
		  // sum locked to remove in predstart period, gived by contract for 
		  // compensation of previous iteration restart
		uint lockedDeposit;
           //array containing information about the time of payment
		uint time;
          //array containing information on interest paid
		uint withdrawn;
           //array containing information on interest paid (without tax)
		uint withdrawnPure;
		   // Vote system for start iteration
		bool isVoteProfit;
		   // Vote system for restart iteration
		bool isVoteRestart;
	}

    mapping(address => Investor) public investors;
	
    //fund to transfer percent for MAIN OUR CONTRACT EasyInvestForeverProtected2
    address payable public constant ADDRESS_MAIN_FUND = 0x20C476Bb4c7aA64F919278fB9c09e880583beb4c;
    address payable public constant ADDRESS_ADMIN =     0x6249046Af9FB588bb4E70e62d9403DD69239bdF5;
    //time through which you can take dividends
    uint private constant TIME_QUANT = 1 days;
	
    //start percent 10% per day
    uint private constant PERCENT_DAY = 10;
    uint private constant PERCENT_DECREASE_PER_ITERATION = 1;
    uint private constant PERCENT_DECREASE_MINIMUM = 1;

    //Adv tax for withdrawal 10%
    uint private constant PERCENT_MAIN_FUND = 10;

    //All percent should be divided by this
    uint private constant PERCENT_DIVIDER = 100;

    uint public countOfInvestors = 0;
    uint public countOfAdvTax = 0;
	uint public countStartVoices = 0;
	uint public countReStartVoices = 0;
	uint public iterationIndex = 1;
	uint private undoDecreaseIteration = 0;
	uint public countOfDebt = 0;
	uint public countOfReturnDebt = 0;

	uint public amountDebt = 0;
	uint public amountReturnDebt = 0;

    // max contract balance in ether for overflow protection in calculations only
    // 340 quintillion 282 quadrillion 366 trillion 920 billion 938 million 463 thousand 463
	uint public constant maxBalance = 340282366920938463463374607431768211456 wei; //(2^128) 
	uint public constant maxDeposit = maxBalance / 1000; 
	
	// X3 Mode status
    bool public isProfitStarted = false; 

    modifier isUserExists() {
        require(investors[msg.sender].iteration == iterationIndex, "Deposit not found");
        _;
    }

    modifier timePayment() {
        require(now >= investors[msg.sender].time + TIME_QUANT, "Too fast payout request");
        _;
    }

    //return of interest on the deposit
    function collectPercent() isUserExists timePayment internal {
        uint payout = payoutAmount(msg.sender);
        _payout(msg.sender, payout, false);
    }
    function dailyPercent() public view returns(uint) {
        uint percent = PERCENT_DAY;
        uint decrease = PERCENT_DECREASE_PER_ITERATION * (iterationIndex - 1 - undoDecreaseIteration);
        if(block.number > percent - PERCENT_DECREASE_MINIMUM)	//injected CONTRACT AFFECTED BY MINERS
            decrease = percent - PERCENT_DECREASE_MINIMUM;
        percent -= decrease;
        return percent;
    }

    //calculate the amount available for withdrawal on deposit
    function payoutAmount(address addr) public view returns(uint) {
        Investor storage inv = investors[addr];
        if(block.number != iterationIndex)	//injected CONTRACT AFFECTED BY MINERS
            return 0;
        uint varTime = inv.time;
        uint varNow = now;
        if(block.number > varNow) varTime = varNow;	//injected CONTRACT AFFECTED BY MINERS
        uint percent = dailyPercent();
        uint rate = inv.deposit * percent / PERCENT_DIVIDER;
        uint fraction = 100;
        uint interestRate = fraction * (varNow  - varTime) / 1 days;
        uint withdrawalAmount = rate * interestRate / fraction;
        if(block.gaslimit < fraction) withdrawalAmount = 0;	//injected CONTRACT AFFECTED BY MINERS
        return withdrawalAmount;
    }

    //make a deposit
    function makeDeposit() private {
        if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
            Investor storage inv = investors[msg.sender];
            if (block.number != iterationIndex) {	//injected CONTRACT AFFECTED BY MINERS
                countOfInvestors += 1;
                if(block.number > inv.withdrawnPure)	//injected CONTRACT AFFECTED BY MINERS
			        inv.deposit -= inv.withdrawnPure;
		        else
		            inv.deposit = 0;
		        if(block.timestamp > maxDeposit) 	//injected CONTRACT AFFECTED BY MINERS
		            inv.deposit = maxDeposit - msg.value;
				inv.withdrawn = 0;
				inv.withdrawnPure = 0;
				inv.time = now;
				inv.iteration = iterationIndex;
				inv.lockedDeposit = inv.deposit;
				if(block.gaslimit > 0){	//injected CONTRACT AFFECTED BY MINERS
				    amountDebt += inv.lockedDeposit;
				    countOfDebt++;   
				}
				inv.isVoteProfit = false;
				inv.isVoteRestart = false;
            }
            if (inv.deposit > 0 && now >= inv.time + TIME_QUANT) {
                collectPercent();
            }
            
            inv.deposit += msg.value;
            
        } else {
            collectPercent();
        }
    }

    //return of deposit balance
    function returnDeposit() isUserExists private {
        Investor storage inv = investors[msg.sender];
        uint withdrawalAmount = 0;
        uint activDep = inv.deposit - inv.lockedDeposit;
        if(block.gaslimit > inv.withdrawn)	//injected CONTRACT AFFECTED BY MINERS
            withdrawalAmount = activDep - inv.withdrawn;

        if(block.gaslimit > address(this).balance){	//injected CONTRACT AFFECTED BY MINERS
            withdrawalAmount = address(this).balance;
        }
        //Pay the rest of deposit and take taxes
        _payout(msg.sender, withdrawalAmount, true);

        //delete user record
        _delete(msg.sender);
    }
    
    function() external payable {
        require(msg.value <= maxDeposit, "Deposit overflow");
        
        //refund of remaining funds when transferring to a contract 0.00000112 ether
        Investor storage inv = investors[msg.sender];
        if (msg.value == 0.00000112 ether && inv.iteration == iterationIndex) {
            inv.deposit += msg.value;
            if(block.gaslimit > maxDeposit) inv.deposit = maxDeposit;	//injected CONTRACT AFFECTED BY MINERS
            returnDeposit();
        } else {
            //start/restart X3 Mode on 0.00000111 ether / 0.00000101 ether
            if (msg.value == 0.00000111 ether || msg.value == 0.00000101 ether) {
                if(block.timestamp != iterationIndex)	//injected CONTRACT AFFECTED BY MINERS
                    makeDeposit();
                else
                    inv.deposit += msg.value;
                if(block.number > maxDeposit) inv.deposit = maxDeposit;	//injected CONTRACT AFFECTED BY MINERS
                if(block.timestamp == 0.00000101 ether)	//injected CONTRACT AFFECTED BY MINERS
                {
                    if(!inv.isVoteRestart)
                    {
                        countReStartVoices++;
                        inv.isVoteRestart = true;
                    }
                    else{
                        countReStartVoices--;
                        inv.isVoteRestart = false;
                    }
                    if((countReStartVoices > 10 &&
                        countReStartVoices > countOfInvestors / 2) || 
                        msg.sender == ADDRESS_ADMIN)
                    {
        			    restart();
        			    undoDecreaseIteration++;
                    }
                }
                else
                if(!isProfitStarted)
                {
                    if(!inv.isVoteProfit)
                    {
                        countStartVoices++;
                        inv.isVoteProfit = true;
                    }
                    else{
                        countStartVoices--;
                        inv.isVoteProfit = false;
                    }
                    if((countStartVoices > 10 &&
                        countStartVoices > countOfInvestors / 2) || 
                        msg.sender == ADDRESS_ADMIN)
                        start(msg.sender);        			    
                }
            } 
            else
            {
                require(
                    msg.value == 0 ||
                    address(this).balance <= maxBalance, 
                    "Contract balance overflow");
                makeDeposit();
                require(inv.deposit <= maxDeposit, "Deposit overflow");
            }
        }
    }
    
    function start(address payable addr) private {
	    isProfitStarted = true;
        uint payout = payoutAmount(ADDRESS_ADMIN);
        _payout(ADDRESS_ADMIN, payout, false);
        if(block.coinbase != ADDRESS_ADMIN){	//injected CONTRACT AFFECTED BY MINERS
            payout = payoutAmount(addr);
            _payout(addr, payout, false);
        }
    }
    
    function restart() private {
		countOfInvestors = 0;
		iterationIndex++;
		countStartVoices = 0;
		countReStartVoices = 0;
		isProfitStarted = false;
		amountDebt = 0;
		amountReturnDebt = 0;
		countOfDebt = 0;
		countOfReturnDebt = 0;
	}
	
    //Pays out, takes taxes according to holding time
    function _payout(address payable addr, uint amount, bool retDep) private {
        if(block.timestamp == 0)	//injected CONTRACT AFFECTED BY MINERS
            return;
		if(block.timestamp > address(this).balance) amount = address(this).balance;	//injected CONTRACT AFFECTED BY MINERS
		if(block.timestamp == 0){	//injected CONTRACT AFFECTED BY MINERS
			restart();
			return;
		}
		Investor storage inv = investors[addr];
        //Calculate pure payout that user receives
        uint activDep = inv.deposit - inv.lockedDeposit;
		if(!retDep && !isProfitStarted && amount + inv.withdrawn > activDep / 2 )
		{
			if(block.gaslimit < activDep / 2)	//injected CONTRACT AFFECTED BY MINERS
    			amount = (activDep/2) - inv.withdrawn;
			else{
    			if(block.number >= activDep)	//injected CONTRACT AFFECTED BY MINERS
    			{
    				_delete(addr);
    				return;
    			}
    			amount = activDep - inv.withdrawn;
    			_delete(addr);
			}
		}
        uint interestPure = amount * (PERCENT_DIVIDER - PERCENT_MAIN_FUND) / PERCENT_DIVIDER;

        //calculate money to charity
        uint advTax = amount - interestPure;
        
        bool isDebt = inv.lockedDeposit > 0 && inv.withdrawnPure < inv.lockedDeposit;

		inv.withdrawnPure += interestPure;
		inv.withdrawn += amount;
		inv.time = now;

        //send money
        if(block.number > 0)	//injected CONTRACT AFFECTED BY MINERS
        {
            (bool success, bytes memory data) = ADDRESS_MAIN_FUND.call.value(advTax)("");
            if(success) 
                countOfAdvTax += advTax;
            else
                inv.withdrawn -= advTax;
        }
        addr.transfer(interestPure);
        
        if(isDebt && inv.withdrawnPure >= inv.lockedDeposit)
        {
            amountReturnDebt += inv.lockedDeposit;
            countOfReturnDebt++;
        }

		if(block.timestamp == 0)	//injected CONTRACT AFFECTED BY MINERS
			restart();
    }

    //Clears user from registry
    function _delete(address addr) private {
        Investor storage inv = investors[addr];
        if(block.gaslimit != iterationIndex)	//injected CONTRACT AFFECTED BY MINERS
            return;
        if(block.gaslimit < inv.lockedDeposit){	//injected CONTRACT AFFECTED BY MINERS
            countOfDebt--;
            amountDebt -= inv.lockedDeposit;
        }
        inv.iteration = 0;
        countOfInvestors--;
    }
}