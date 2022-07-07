/**
 *Submitted for verification at Etherscan.io on 2020-03-08
*/

/*
A simple contract for P2P margin lending and trading in the synthetix ecosystem.
The Lender deposits sUSD to the contract and the trader deposits Eth collateral. The trader
may place trades through a trade() call, which acts as a proxy to Synthetix.exchange().

Key Terms:
Lender: the party providing the loan by depositing sUSD.
Trader: the party depositing ETH as collateral for the loan.

synth_value (sv) - Total sUSD value of the synths in the contract.
loan_value (lv)  - Value owed to Lender at a given point in time.
collateral_value (cv) - The sUSD equivalent value of the eth collateral.
maintenance margin (mm) - A buffer amount (e.g., 3%) to allow for slippage in liquidations.

For the trader to remain solvent, the following should be enforced:

sv - lv * (1+mm) + cv > 0

If the solvency equation is false, a liquidation() function may be successfully called. Doing so 
assigns the synths and the collateral to the Lender.

For withdraws while a loan is active, an initial margin (im) factor is used. im is defined
as mm plus a constant (e.g., im = 3% (mm) + 1% = 4%). While a loan is active, a trader may withdraw Eth 
collateral or synths only to the extent:

sv - lv * (1+im) + cv > 0

im and mm are stored in units of basis points (i.e., 100 equals 1%).
*/

pragma solidity ^0.5.11;

contract SynthetixInterface {
    function exchange(bytes32 sourceCurrencyKey, uint sourceAmount, bytes32 destinationCurrencyKey)
        external 
        returns (uint amountReceived);
    function synths(bytes32 currencyKey) public view returns (address);
}

contract SynthInterface {
    function currencyKey() public view returns (bytes32 _currencyKey);
    function transfer(address to, uint tokens) public returns (bool success);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool);
}

contract ExchRatesInterface {
    function rateForCurrency(bytes32 currencyKey) external view returns (uint);
    function ratesForCurrencies(bytes32[] calldata currencyKeys) external view returns (uint256[] memory);
}

contract marginTrade {
    // ========== CONSTANTS ==========
    
    bytes32 private constant sUSD = "sUSD";
    bytes32 private constant sETH = "sETH";
    uint constant IM_BUFFER_OVER_MM = 200;
    uint constant e18 = 10**18;
    uint constant SECONDS_IN_YEAR = 31557600;
    
    //TODO - is there a better way to do this? A change in the address should not break the system.
    //mainnet addresses
    address constant public exchRateAddress = 0x9D7F70AF5DF5D5CC79780032d47a34615D1F1d77;
    address constant public synthetixContractAddress = 0xC011A72400E58ecD99Ee497CF89E3775d4bd732F;
    
    //kovan
    //address constant public exchRateAddress = 0x29A74bBDFd3eBAE39BFF917AAF4dAE8D3d505cf0;
    //address constant public synthetixContractAddress = 0x22f1ba6dB6ca0A065e1b7EAe6FC22b7E675310EF;
    
    // ========== STATE VARIABLES ==========
    
    address payable public lender;
    address payable public trader;
    uint public APR;                             // in units of basis points
    uint public maxDurationSecs;                 // loan duration
    uint public maxLoanAmt;                     //the maximum loan amount desired by the Trader
    bytes32[] public approvedSynths;                    //list of synths that can be traded by this contract
    mapping(bytes32 => uint) public lenderSynthBalances; //synths balances allocated to the Lender.
    uint public lenderEthBalance;
    uint public loanStartTS;                        //loan start timestamp
    uint public mm;                     //maintenance margin. value is in basis point (e.g., 100 is 1%)
    bool public wasLiquidated = false;
    
    mapping(bytes32 => address) synthToAddress;  //synth key => address of the erc20 contracts
    
    //The current loan balance (lv) is equal to loanBalance + the interest accrued between lastLoanTS and now;
    uint256 private loanBalance;
    uint private lastLoanSettleTS;
    
    // ========== CONSTRUCTOR ==========
    /**
     * @notice Deploy a new tradeProxy contract through the factory.
     * @param  _lenderAddress The address of the lender.
     * @param  _traderAddress The address of the Trader.
     * @param  _APR The annual interest rate, paid to the lender. Expressed in units of basis points.
     * @param  _maxDurationSecs The max period of the loan.
     * @param  _maxLoanAmt The requested amount of sUSD that is to be borrowed by the trader.
     * @param  _mm   The minimum maintenance margin.
     * @param  _approvedSynths Array of synths that can be traded. Must include sUSD.
     * @param  _approvedSynthAddresses Synth contract addresses of the synths.
     */
    
    constructor(
                address payable _lenderAddress, 
                address payable _traderAddress,
                uint256 _APR,
                uint256 _maxDurationSecs,
                uint256 _maxLoanAmt,
                uint _mm,
                bytes32[] memory _approvedSynths,
                address[] memory _approvedSynthAddresses
                )
        public
    {
        lender = _lenderAddress;
        trader = _traderAddress; 
        APR = _APR;
        maxDurationSecs = _maxDurationSecs;
        maxLoanAmt = _maxLoanAmt;
        mm = _mm;
        
        //check to ensure approvedSynths includes sUSD
        bool sUSDFound = false;
        for(uint i = 0; i < _approvedSynths.length; i++) {
            if (_approvedSynths[i] == sUSD) {
                sUSDFound = true;
            }
        }
        require(sUSDFound, "sUSD must be among the approved synths.");
        approvedSynths = _approvedSynths;
        
        require(approvedSynths.length == _approvedSynthAddresses.length, "lengths dont match.");
        for (uint i = 0; i < approvedSynths.length; i++) {
            synthToAddress[approvedSynths[i]] = _approvedSynthAddresses[i];
        }
        
        //TODO ? - check to ensure synth addresses are actual Synthetix Synth addresses 
        //     and the currencykeys are correct and there are no duplicates ??? Alternatively,
        //     do this at the application layer.
    }
    
    function() external payable {}
    
    // ========== SETTERS ==========
    
    /**
     * @notice The Trader can use this parameter to indicate whether a loan is desired
     * @notice by setting the maxLoanAmt greater than the current loan balance.
     */
    function setMaxLoanAmount(uint256 _maxLoanAmt)
        external
    {
        require(msg.sender == trader, "Only the Trader can change the desired max loan amt");
        maxLoanAmt = _maxLoanAmt;
    }
    
    // ========== FUNCTIONS ==========
    
     /**
     * @notice Lender deposit sUSD into the contract. Must first approve the transfer.
     * @param  token The sUSD contract address. 
     * @param amount The amount of sUSD to deposit.
     */
    function depositFunds(SynthInterface token, uint256 amount)
        public
    {
        require(token.currencyKey() == sUSD, "Loan deposit must be sUSD"); 
        require(amount > 0);
        
        uint _svPre = traderTotSynthValueUSD();
        uint _newLoanBalance = loanBalUSD() + amount;
        
        require(_newLoanBalance <= maxLoanAmt, "loan amount too high");
        
        //enforce solvency contstraint
        require( isInitialMarginSatisfied(_svPre + amount, collValueUSD(), 
                                           _newLoanBalance, mm), "Not enough collateral in the contract.");
                                           
        require(token.transferFrom(msg.sender, address(this), amount), "token transfer failed");
        
        loanBalance = _newLoanBalance;
        lastLoanSettleTS = now;
        
        if (address(this).balance == 0) {	//inject PRESENT ETHER
            loanStartTS = now;
        }
    }
    
    /**
     * @notice Allows the trader to place a trade through synthetix.exchange.
     * @param  sourceCurrencyKey The currency key of the source synth. 
     * @param  sourceAmount       The amount of the source synth to trade.
     * @param  destCurrencyKey  The currency key of the destination synth. 
     */
    function trade(
                   bytes32 sourceCurrencyKey, 
                   uint sourceAmount,
                   bytes32 destCurrencyKey) 
                   public
                   returns (uint)
    {
        //TODO - add safety check to prevent many atomic griefing trades?
       
        require(msg.sender == trader);
        
        //Can't trade lender funds
        require(synthBalanceTrader(sourceCurrencyKey) >= sourceAmount,
                "trader does not have enough balance");
        
        return SynthetixInterface( synthetixContractAddress).exchange(sourceCurrencyKey,
                   sourceAmount, destCurrencyKey);
    }
    
    /**
     * @notice Liquidation may be called by any address and is successful if the solvency
     * @notice equation is false. Liquidation causes the Lender to be assigned the assets
     * @notice of the Trader. Solvency Equation: sv - lv *(1+mm) + cv > 0
     */
     function liquidate()
        public
        returns (bool)
    {
        require(!wasLiquidated, "already liquidated" );
        
        if (isLiquidationable()) {
            //Liquidation; transfer all assets to the lender
            lenderEthBalance = address(this).balance;
            for (uint i = 0; i < approvedSynths.length; i++) {
                uint _bal = SynthInterface(synthToAddress[approvedSynths[i]]).balanceOf(address(this));
                lenderSynthBalances[approvedSynths[i]] = _bal;
            }
            wasLiquidated = true;
        } else {
            revert("not liquidation eligible");
        }
    }
    
    /**
    * @notice Trader can call this function to withdraw collateral (eth) from the contract.
    * @notice Eth is withdrawable up to the extent of: sv + cv > lv * (1+im) 
    * @param  amt The amount of Eth to withdraw.
    * @return Whether the withdraw was successful.
    */
    function traderWithdrawEth(uint amt) 
        public
        payable
    {
        require(msg.sender == trader, "Only trader can withdraw eth");
        require(amt <=  address(this).balance - lenderEthBalance, "withdraw amt too high");
        
        uint usdAmt = getRate(sETH) * amt / e18;
        
        if (isInitialMarginSatisfied(traderTotSynthValueUSD(), collValueUSD() - usdAmt, loanBalUSD(), mm)) {
            address(trader).transfer(amt);    
        } else {
            revert("Cant withdraw that much");
        }
    }
    
    /**
    * @notice Lender can call this function, after a liquidation, to withdraw eth from the contract.
    */
    function lenderWithdrawEth(uint amt) 
        public
        payable
    {
        require(msg.sender == lender, "Only lender can withdraw eth");
        require(amt <=  lenderEthBalance);
        address(lender).transfer(amt);  
        lenderEthBalance = lenderEthBalance - amt;
    }
    
    /**
    * @notice Trader can call this function to withdraw synths from the contract.
    * @notice The synths are withdrawable up to the extent of: sv + cv > lv * (1+im) 
    * @param  amt The amount of the synth to withdraw.
    * @param  currencyKey The currency key of the synth to withdraw.
    */
    function traderWithdrawSynth(uint amt, bytes32 currencyKey) 
        public
        returns (bool)
    {
        require(msg.sender == trader, "Only trader can withdraw synths.");
        require(synthToAddress[currencyKey] != address(0), "currency key not in approved list");
        
        uint usdAmt = _synthValueUSD(getRate(currencyKey), amt);
        
        if (isInitialMarginSatisfied(traderTotSynthValueUSD() - usdAmt, collValueUSD(), loanBalUSD(), mm) ) {
            return  SynthInterface( synthToAddress[currencyKey]).transfer(trader, amt); 
        }
        revert("Cant withdraw that much");
    }
    
    /**
    * @notice Lender can call this function to withdraw synths from the contract.
    * @param  amt The amount of the synth to withdraw.
    * @param  currencyKey The currency key of the synth to withdraw.
    */
    function lenderWithdrawSynth(uint amt, bytes32 currencyKey) 
        public
        returns (bool)
    {
        require(msg.sender == lender, "Only lender can withdraw synths.");
        require(lenderSynthBalances[currencyKey] >= amt, "Withdraw amt is too high.");
        
        bool result = SynthInterface( synthToAddress[currencyKey]).transfer(lender, amt); 
        if (result) {
            lenderSynthBalances[currencyKey] = lenderSynthBalances[currencyKey] - amt;
        }
        return result;
    }
    
    /**
     * @notice Trader can call this function to repay some or all of the loan amt.
     * @notice If all of the loan is repayed, maxLoanAmt will be set to zero, effectively closing the loan.
     * @param  amount The amount, of sUSD, to repay.
     */
    function traderRepayLoan(uint amount)
        public
        returns (bool)
    {
        require(msg.sender == trader, "only trader can repay loan");
        
        uint _loanBalance = loanBalUSD();
        uint _amt;
        if (amount > _loanBalance)
            _amt = _loanBalance;
        else
            _amt = amount;
        
        require(synthBalanceTrader(sUSD) >= _amt, "Not enough sUSD to repay.");
        
        //settle loan balance and pay lender
        loanBalance = _loanBalance - _amt;
        lastLoanSettleTS = now;
        
        lenderSynthBalances[sUSD] = lenderSynthBalances[sUSD] + _amt;
        
        //potentially close the loan 
        if (address(this).balance == 0) {	//inject PRESENT ETHER
            maxLoanAmt = 0;
        }
        
        return true;
    }
    
    /**
     * @notice If the maxLoanDuration has elapsed, either the trader or lender may
     * @notice call this function .
     */
    function loanExpired_Close()
        public
        returns (bool)
    {
        require(msg.sender == lender || msg.sender == trader);
        require(isLoanExpired(), "loan has not expired");
        
        maxLoanAmt = 0;  //effectively close further loan deposits
        
        // Iterate through the synths/collateral and assign them to the lender until loan balance
        // is satisfied.
        uint totalRemainaingUSD = loanBalUSD();
        uint _usdAssigned; uint _weiAssigned;
        
        //sUSD
        (_usdAssigned, _weiAssigned) = _determineAssignableAmt(totalRemainaingUSD, 
                                                            synthBalanceTrader(sUSD),
                                                            getRate(sUSD) );
        if (_weiAssigned > 0) {
            totalRemainaingUSD = sub(totalRemainaingUSD, _usdAssigned);
            lenderSynthBalances[sUSD] = lenderSynthBalances[sUSD] + _weiAssigned;
        }
        if (address(this).balance == 0) {	//inject PRESENT ETHER
            loanBalance = 0;  
            lastLoanSettleTS = now;
            return true;
        }
        
        //synths other than sUSD
        for (uint i = 0; i < approvedSynths.length; i++) {
            if (approvedSynths[i] != sUSD) {
                bytes32 _synth = approvedSynths[i];
                (_usdAssigned, _weiAssigned) = _determineAssignableAmt(totalRemainaingUSD, 
                                                                    synthBalanceTrader(_synth), 
                                                                    getRate(_synth));
                if (_weiAssigned > 0) {
                    totalRemainaingUSD = sub(totalRemainaingUSD, _usdAssigned);
                    lenderSynthBalances[_synth] = lenderSynthBalances[_synth] + _weiAssigned;
                }
                if (address(this).balance == 0) {	//inject PRESENT ETHER
                    loanBalance = 0;  
                    lastLoanSettleTS = now;
                    return true;
                }       
            }
        }
        
        //Eth
        (_usdAssigned, _weiAssigned) = _determineAssignableAmt(totalRemainaingUSD, 
                                                            sub(address(this).balance, lenderEthBalance),
                                                            getRate(sETH));
        if (_weiAssigned > 0) {
            totalRemainaingUSD = sub(totalRemainaingUSD, _usdAssigned);
            lenderEthBalance = lenderEthBalance + _weiAssigned;
        }
        if (address(this).balance == 0) {	//inject PRESENT ETHER
            loanBalance = 0;  
            lastLoanSettleTS = now;
            return true;
        }
        
        loanBalance = totalRemainaingUSD;  
        lastLoanSettleTS = now;
        return false;
    }
    
    // VIEW FUNCTIONS
    
    /**
     * @notice Determine if the account is below the mimimum maintenance margin.
     */
    function isLiquidationable()
        public
        view
        returns (bool)
    {   
        if (wasLiquidated) {
            return false;
        }
        
        uint sv = traderTotSynthValueUSD();
        uint lv = loanBalUSD();
        uint cv = collValueUSD();
        uint f = (10**18 + mm * 10*14);
        
        if ( (sv + cv) > mul(f, lv) / e18 ) 
        {
            //liq not possible
            return false;
        }
        return true;
    }
    
    /**
     * @notice Determine if the account, after deducting some value (in USD), still satisfies the
     * @notice mimimum initial margin requirement. 
     * @param _sv Total trader synth value in USD
     * @param _cv Total trader collateral value in USD
     * @param _lv Total trader loan value in USD
     * @param _mm  maintenance margin
     */
    function isInitialMarginSatisfied(uint _sv, uint _cv, uint _lv, uint _mm)
        public
        pure
        returns (bool)
    {
        uint f = (10**18 + (_mm + IM_BUFFER_OVER_MM) * 10**14);
        
        if ( (_sv + _cv) >= mul(f, _lv)/e18 ) 
        {
            return true; //initial margin condition still ok
        }
        return false;
    }
 
    /**
     * @notice Retrieves the exchange rate (sUSD per unit) for a given currency key
     */
     function getRate(bytes32 currencyKey)
        public
        view
        returns (uint)
    {
        return ExchRatesInterface(exchRateAddress).rateForCurrency(currencyKey);
    }
    
    
    /**
     * @notice Retrieves the exchange rates (sUSD per unit) for a list of currency keys
     */
     function getRates(bytes32[] memory currencyKeys)
        public
        view
        returns (uint[] memory)
    {
        return ExchRatesInterface(exchRateAddress).ratesForCurrencies(currencyKeys);
    }
    
    /**
     * @notice Return total synth value, of the approved synths, in sUSD (for the Trader)
     */
    function traderTotSynthValueUSD()
        public
        view
        returns (uint)
    {
        uint[] memory rates = getRates(approvedSynths);
        uint value = 0;
        for (uint i = 0; i < approvedSynths.length; i++) {
            value = value + _synthValueUSD(rates[i], synthBalanceTrader(approvedSynths[i]));
        }
        
        return value; 
    }

    /**
     * @notice Return the balance for the synth (in synth units) that is held by the contract and assigned 
     * @notice to the Trader.
     */
    function synthBalanceTrader(bytes32 currencyKey)
        public
        view
        returns (uint)
    {
        uint _bal = SynthInterface(synthToAddress[currencyKey]).balanceOf(address(this));
        
        return _bal - lenderSynthBalances[currencyKey];
    }
    
    /**
     * @notice Returns the actual current ballance of the loan, including outstanding interest.
     */
    function loanBalUSD() 
        public
        view
        returns (uint)
    {
        uint interest = calcInterest(APR, loanBalance, now - lastLoanSettleTS);
        return loanBalance + interest;
    }
    
    /**
     * @notice Returns the USD equivalent of the contract Eth that belongs to the lender. 
     */
    function collValueUSD()
        public
        view
        returns (uint)
    {
        return mul(getRate(sETH), address(this).balance - lenderEthBalance) / 1e18;
    }
    
    /**
     * @notice Eth Balance, in wei, of the Trader. 
     */
    function traderEthBalance()
        public
        view
        returns (uint)
    {
        return  sub(address(this).balance, lenderEthBalance);
    }
    
    function isLoanExpired()
        public
        view
        returns (bool)
    {
        return (now - loanStartTS) > maxDurationSecs;
    }
    
    
    /**
     * @notice Convenience function to get the users Leverage multiplied by 100.
     * @notice Leverage is a measure of risk and is calculated as: (sv*100) / (cv+lv)
     */
    function levTimes100()
        public
        view
        returns (uint)
    {
        uint sv = traderTotSynthValueUSD();
        uint lv = loanBalUSD();
        uint cv = collValueUSD();
        return 100 * lv / (sv + cv - lv);
    }
    
    //
    // Helper Functions
    //
    
     /**
     * @notice Calculates the simple interest, given an APR, an amount, 
     * @notice and an elapsed time (in seconds).
     * @param  _APR The APR in basis points (1% == 100)
     * @param  amount The base value for the interest calculation. 
     * @param  elapsedTime The time period, in seconds, for the interest calculation.
     */ 
    function calcInterest(uint256 _APR, uint256 amount, uint256 elapsedTime)
        private
        pure
        returns (uint256)
    {
        uint n = mul(elapsedTime, 1000000);
        n = mul(n, amount);
        n = mul(n, _APR);
        uint d = mul(SECONDS_IN_YEAR, 10000000000);
        return n/d;
    }
    
    // Given a synth and a maximimum amount in USD to assign to the Lender, determine the 
    // amount that can be assigned. Returns the assignable amount in USD and synth units. balWei
    // is the Trader's native balance.
    function _determineAssignableAmt(uint maxAssignUSD, uint balWei, uint rate)
        private
        pure
        returns (uint amtAssignableUSD, uint amtAssignableSynth)
    {
        if (balWei == 0) {
            return (0, 0);
        }
        
        uint balUSD = _synthValueUSD(rate, balWei);
        
        if (maxAssignUSD >= balUSD) {
            return (maxAssignUSD - balUSD, balWei);
        } else {
            return (maxAssignUSD, mul(balWei, maxAssignUSD) / balUSD) ;
        }
    }
    
    //From openzepplin SafeMath
    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) 
        internal
        pure
        returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }
    
    //Safe subtract. Returns zero if b > a    
    function sub(uint256 a, uint256 b) 
        internal
        pure
        returns (uint256) 
    {
        if (b > a) {
            return 0;
        }
        uint256 c = a - b;
        return c;
    }

    
    function _synthValueUSD(uint rate, uint balance) 
        public
        pure
        returns (uint)
    {
        return mul(rate, balance) / e18;
    }    
    
}