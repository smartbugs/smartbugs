pragma solidity 0.5.15;

contract IAugur {
    function CREATECHILDUNIVERSE712(bytes32 _parentPayoutDistributionHash, uint256[] memory _parentPayoutNumerators) public returns (IUniverse);	//inject NONSTANDARD NAMING
    function ISKNOWNUNIVERSE698(IUniverse _universe) public view returns (bool);	//inject NONSTANDARD NAMING
    function TRUSTEDCASHTRANSFER967(address _from, address _to, uint256 _amount) public returns (bool);	//inject NONSTANDARD NAMING
    function ISTRUSTEDSENDER635(address _address) public returns (bool);	//inject NONSTANDARD NAMING
    function ONCATEGORICALMARKETCREATED679(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash, bytes32[] memory _outcomes) public returns (bool);	//inject NONSTANDARD NAMING
    function ONYESNOMARKETCREATED215(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash) public returns (bool);	//inject NONSTANDARD NAMING
    function ONSCALARMARKETCREATED844(uint256 _endTime, string memory _extraInfo, IMarket _market, address _marketCreator, address _designatedReporter, uint256 _feePerCashInAttoCash, int256[] memory _prices, uint256 _numTicks)  public returns (bool);	//inject NONSTANDARD NAMING
    function LOGINITIALREPORTSUBMITTED874(IUniverse _universe, address _reporter, address _market, address _initialReporter, uint256 _amountStaked, bool _isDesignatedReporter, uint256[] memory _payoutNumerators, string memory _description, uint256 _nextWindowStartTime, uint256 _nextWindowEndTime) public returns (bool);	//inject NONSTANDARD NAMING
    function DISPUTECROWDSOURCERCREATED646(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] memory _payoutNumerators, uint256 _size, uint256 _disputeRound) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGDISPUTECROWDSOURCERCONTRIBUTION255(IUniverse _universe, address _reporter, address _market, address _disputeCrowdsourcer, uint256 _amountStaked, string memory description, uint256[] memory _payoutNumerators, uint256 _currentStake, uint256 _stakeRemaining, uint256 _disputeRound) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGDISPUTECROWDSOURCERCOMPLETED546(IUniverse _universe, address _market, address _disputeCrowdsourcer, uint256[] memory _payoutNumerators, uint256 _nextWindowStartTime, uint256 _nextWindowEndTime, bool _pacingOn, uint256 _totalRepStakedInPayout, uint256 _totalRepStakedInMarket, uint256 _disputeRound) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGINITIALREPORTERREDEEMED338(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256[] memory _payoutNumerators) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGDISPUTECROWDSOURCERREDEEMED9(IUniverse _universe, address _reporter, address _market, uint256 _amountRedeemed, uint256 _repReceived, uint256[] memory _payoutNumerators) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGMARKETFINALIZED368(IUniverse _universe, uint256[] memory _winningPayoutNumerators) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGMARKETMIGRATED444(IMarket _market, IUniverse _originalUniverse) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGREPORTINGPARTICIPANTDISAVOWED43(IUniverse _universe, IMarket _market) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGMARKETPARTICIPANTSDISAVOWED537(IUniverse _universe) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGCOMPLETESETSPURCHASED486(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGCOMPLETESETSSOLD144(IUniverse _universe, IMarket _market, address _account, uint256 _numCompleteSets, uint256 _fees) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGMARKETOICHANGED928(IUniverse _universe, IMarket _market) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGTRADINGPROCEEDSCLAIMED757(IUniverse _universe, address _sender, address _market, uint256 _outcome, uint256 _numShares, uint256 _numPayoutTokens, uint256 _fees) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGUNIVERSEFORKED116(IMarket _forkingMarket) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGREPUTATIONTOKENSTRANSFERRED904(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGREPUTATIONTOKENSBURNED995(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGREPUTATIONTOKENSMINTED985(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGSHARETOKENSBALANCECHANGED123(address _account, IMarket _market, uint256 _outcome, uint256 _balance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGDISPUTECROWDSOURCERTOKENSTRANSFERRED932(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGDISPUTECROWDSOURCERTOKENSBURNED518(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGDISPUTECROWDSOURCERTOKENSMINTED48(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGDISPUTEWINDOWCREATED79(IDisputeWindow _disputeWindow, uint256 _id, bool _initial) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGPARTICIPATIONTOKENSREDEEMED534(IUniverse universe, address _sender, uint256 _attoParticipationTokens, uint256 _feePayoutShare) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGTIMESTAMPSET762(uint256 _newTimestamp) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGINITIALREPORTERTRANSFERRED573(IUniverse _universe, IMarket _market, address _from, address _to) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGMARKETTRANSFERRED247(IUniverse _universe, address _from, address _to) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGPARTICIPATIONTOKENSTRANSFERRED386(IUniverse _universe, address _from, address _to, uint256 _value, uint256 _fromBalance, uint256 _toBalance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGPARTICIPATIONTOKENSBURNED957(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGPARTICIPATIONTOKENSMINTED248(IUniverse _universe, address _target, uint256 _amount, uint256 _totalSupply, uint256 _balance) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGMARKETREPBONDTRANSFERRED31(address _universe, address _from, address _to) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGWARPSYNCDATAUPDATED845(address _universe, uint256 _warpSyncHash, uint256 _marketEndTime) public returns (bool);	//inject NONSTANDARD NAMING
    function ISKNOWNFEESENDER211(address _feeSender) public view returns (bool);	//inject NONSTANDARD NAMING
    function LOOKUP594(bytes32 _key) public view returns (address);	//inject NONSTANDARD NAMING
    function GETTIMESTAMP626() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETMAXIMUMMARKETENDDATE626() public returns (uint256);	//inject NONSTANDARD NAMING
    function ISKNOWNMARKET166(IMarket _market) public view returns (bool);	//inject NONSTANDARD NAMING
    function DERIVEPAYOUTDISTRIBUTIONHASH812(uint256[] memory _payoutNumerators, uint256 _numTicks, uint256 numOutcomes) public view returns (bytes32);	//inject NONSTANDARD NAMING
    function LOGVALIDITYBONDCHANGED992(uint256 _validityBond) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGDESIGNATEDREPORTSTAKECHANGED748(uint256 _designatedReportStake) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGNOSHOWBONDCHANGED254(uint256 _noShowBond) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGREPORTINGFEECHANGED596(uint256 _reportingFee) public returns (bool);	//inject NONSTANDARD NAMING
    function GETUNIVERSEFORKINDEX548(IUniverse _universe) public view returns (uint256);	//inject NONSTANDARD NAMING
}

contract IOwnable {
    function GETOWNER826() public view returns (address);	//inject NONSTANDARD NAMING
    function TRANSFEROWNERSHIP284(address _newOwner) public returns (bool);	//inject NONSTANDARD NAMING
}

contract ITyped {
    function GETTYPENAME153() public view returns (bytes32);	//inject NONSTANDARD NAMING
}

library SafeMathUint256 {
    function MUL760(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

    function DIV647(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function SUB692(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        return a - b;
    }

    function ADD571(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function MIN885(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a <= b) {
            return a;
        } else {
            return b;
        }
    }

    function MAX990(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a >= b) {
            return a;
        } else {
            return b;
        }
    }

    function SQRT858(uint256 y) internal pure returns (uint256 z) {	//inject NONSTANDARD NAMING
        if (y > 3) {
            uint256 x = (y + 1) / 2;
            z = y;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function GETUINT256MIN331() internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return 0;
    }

    function GETUINT256MAX467() internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // 2 ** 256 - 1
        return 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    }

    function ISMULTIPLEOF540(uint256 a, uint256 b) internal pure returns (bool) {	//inject NONSTANDARD NAMING
        return a % b == 0;
    }

    // Float [fixed point] Operations
    function FXPMUL102(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV647(MUL760(a, b), base);
    }

    function FXPDIV922(uint256 a, uint256 b, uint256 base) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV647(MUL760(a, base), b);
    }
}

interface IERC1155 {

                                                                                          
                                                                          
                                           
                                                                      
                                                                           
                                                                                                 
                                                                                                      
                                                                                                       
                                                                   
    event TRANSFERSINGLE49(	//inject NONSTANDARD NAMING
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

                                                                                          
                                                                          
                                          
                                                                      
                                                                           
                                                                                                 
                                                                                                      
                                                                                                      
                                                                   
    event TRANSFERBATCH882(	//inject NONSTANDARD NAMING
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

                                                   
    event APPROVALFORALL731(	//inject NONSTANDARD NAMING
        address indexed owner,
        address indexed operator,
        bool approved
    );

                                                              
                                     
                                                                                            
    event URI998(	//inject NONSTANDARD NAMING
        string value,
        uint256 indexed id
    );

                                                                                                     
                                                       
                                                                                            
                                                
                                                                                        
                                      
                                                                                                         
                                                                                       
                                                                                               
                                     
                                     
                                           
                                      
                                                                                      
    function SAFETRANSFERFROM689(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    )
        external;

                                                                                                  
                                                      
                                                                                            
                                                
                                                                              
                                                                                                                 
                                      
                                                                                                         
                                                                                            
                                                                                                        
                                       
                                       
                                             
                                                      
                                                                                      
    function SAFEBATCHTRANSFERFROM779(	//inject NONSTANDARD NAMING
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    )
        external;

                                                                                                               
                                                           
                                                                          
                                                                                   
    function SETAPPROVALFORALL494(address operator, bool approved) external;	//inject NONSTANDARD NAMING

                                                                             
                                                
                                                       
                                                                        
    function ISAPPROVEDFORALL901(address owner, address operator) external view returns (bool);	//inject NONSTANDARD NAMING

                                                       
                                                     
                                     
                                                                       
    function BALANCEOF492(address owner, uint256 id) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                
                                     
                                                                   
    function TOTALSUPPLY304(uint256 id) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                               
                                                        
                                      
                                                                        
    function BALANCEOFBATCH918(	//inject NONSTANDARD NAMING
        address[] calldata owners,
        uint256[] calldata ids
    )
        external
        view
        returns (uint256[] memory balances_);
}

contract IERC20 {
    function TOTALSUPPLY304() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF492(address owner) public view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER644(address to, uint256 amount) public returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM669(address from, address to, uint256 amount) public returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE293(address spender, uint256 amount) public returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE377(address owner, address spender) public view returns (uint256);	//inject NONSTANDARD NAMING

    // solhint-disable-next-line no-simple-event-func-name
    event TRANSFER723(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL665(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract ICash is IERC20 {
}

contract ERC20 is IERC20 {
    using SafeMathUint256 for uint256;

    uint8 constant public decimals866 = 18;	//inject NONSTANDARD NAMING

    uint256 public totalSupply;

    mapping (address => uint256) public balances;

    mapping (address => mapping (address => uint256)) public allowances;

                                                   
    function BALANCEOF492(address _account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return balances[_account];
    }

                                                                                                                                                                                                    
    function TRANSFER644(address _recipient, uint256 _amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER433(msg.sender, _recipient, _amount);
        return true;
    }

                                                   
    function ALLOWANCE377(address _owner, address _spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return allowances[_owner][_spender];
    }

                                                                                                                                   
    function APPROVE293(address _spender, uint256 _amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE571(msg.sender, _spender, _amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function TRANSFERFROM669(address _sender, address _recipient, uint256 _amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER433(_sender, _recipient, _amount);
        _APPROVE571(_sender, msg.sender, allowances[_sender][msg.sender].SUB692(_amount));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE307(address _spender, uint256 _addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE571(msg.sender, _spender, allowances[msg.sender][_spender].ADD571(_addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE757(address _spender, uint256 _subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE571(msg.sender, _spender, allowances[msg.sender][_spender].SUB692(_subtractedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER433(address _sender, address _recipient, uint256 _amount) internal {	//inject NONSTANDARD NAMING
        require(_sender != address(0), "ERC20: transfer from the zero address");
        require(_recipient != address(0), "ERC20: transfer to the zero address");

        balances[_sender] = balances[_sender].SUB692(_amount);
        balances[_recipient] = balances[_recipient].ADD571(_amount);
        emit TRANSFER723(_sender, _recipient, _amount);
        ONTOKENTRANSFER292(_sender, _recipient, _amount);
    }

                                                                                                                                                                                                                                                                       
    function _MINT880(address _account, uint256 _amount) internal {	//inject NONSTANDARD NAMING
        require(_account != address(0), "ERC20: mint to the zero address");

        totalSupply = totalSupply.ADD571(_amount);
        balances[_account] = balances[_account].ADD571(_amount);
        emit TRANSFER723(address(0), _account, _amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN356(address _account, uint256 _amount) internal {	//inject NONSTANDARD NAMING
        require(_account != address(0), "ERC20: burn from the zero address");

        balances[_account] = balances[_account].SUB692(_amount);
        totalSupply = totalSupply.SUB692(_amount);
        emit TRANSFER723(_account, address(0), _amount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _APPROVE571(address _owner, address _spender, uint256 _amount) internal {	//inject NONSTANDARD NAMING
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(_spender != address(0), "ERC20: approve to the zero address");

        allowances[_owner][_spender] = _amount;
        emit APPROVAL665(_owner, _spender, _amount);
    }

                                                                                                                                                                           
    function _BURNFROM317(address _account, uint256 _amount) internal {	//inject NONSTANDARD NAMING
        _BURN356(_account, _amount);
        _APPROVE571(_account, msg.sender, allowances[_account][msg.sender].SUB692(_amount));
    }

    // Subclasses of this token generally want to send additional logs through the centralized Augur log emitter contract
    function ONTOKENTRANSFER292(address _from, address _to, uint256 _value) internal;	//inject NONSTANDARD NAMING
}

contract VariableSupplyToken is ERC20 {
    using SafeMathUint256 for uint256;

    function MINT146(address _target, uint256 _amount) internal returns (bool) {	//inject NONSTANDARD NAMING
        _MINT880(_target, _amount);
        ONMINT315(_target, _amount);
        return true;
    }

    function BURN234(address _target, uint256 _amount) internal returns (bool) {	//inject NONSTANDARD NAMING
        _BURN356(_target, _amount);
        ONBURN653(_target, _amount);
        return true;
    }

    // Subclasses of this token may want to send additional logs through the centralized Augur log emitter contract
    function ONMINT315(address, uint256) internal {	//inject NONSTANDARD NAMING
    }

    // Subclasses of this token may want to send additional logs through the centralized Augur log emitter contract
    function ONBURN653(address, uint256) internal {	//inject NONSTANDARD NAMING
    }
}

contract IAffiliateValidator {
    function VALIDATEREFERENCE609(address _account, address _referrer) external view returns (bool);	//inject NONSTANDARD NAMING
}

contract IDisputeWindow is ITyped, IERC20 {
    function INVALIDMARKETSTOTAL511() external view returns (uint256);	//inject NONSTANDARD NAMING
    function VALIDITYBONDTOTAL28() external view returns (uint256);	//inject NONSTANDARD NAMING

    function INCORRECTDESIGNATEDREPORTTOTAL522() external view returns (uint256);	//inject NONSTANDARD NAMING
    function INITIALREPORTBONDTOTAL695() external view returns (uint256);	//inject NONSTANDARD NAMING

    function DESIGNATEDREPORTNOSHOWSTOTAL443() external view returns (uint256);	//inject NONSTANDARD NAMING
    function DESIGNATEDREPORTERNOSHOWBONDTOTAL703() external view returns (uint256);	//inject NONSTANDARD NAMING

    function INITIALIZE90(IAugur _augur, IUniverse _universe, uint256 _disputeWindowId, bool _participationTokensEnabled, uint256 _duration, uint256 _startTime) public;	//inject NONSTANDARD NAMING
    function TRUSTEDBUY954(address _buyer, uint256 _attotokens) public returns (bool);	//inject NONSTANDARD NAMING
    function GETUNIVERSE719() public view returns (IUniverse);	//inject NONSTANDARD NAMING
    function GETREPUTATIONTOKEN35() public view returns (IReputationToken);	//inject NONSTANDARD NAMING
    function GETSTARTTIME383() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETENDTIME626() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETWINDOWID901() public view returns (uint256);	//inject NONSTANDARD NAMING
    function ISACTIVE720() public view returns (bool);	//inject NONSTANDARD NAMING
    function ISOVER108() public view returns (bool);	//inject NONSTANDARD NAMING
    function ONMARKETFINALIZED596() public;	//inject NONSTANDARD NAMING
    function REDEEM559(address _account) public returns (bool);	//inject NONSTANDARD NAMING
}

contract IMarket is IOwnable {
    enum MarketType {
        YES_NO,
        CATEGORICAL,
        SCALAR
    }

    function INITIALIZE90(IAugur _augur, IUniverse _universe, uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, address _creator, uint256 _numOutcomes, uint256 _numTicks) public;	//inject NONSTANDARD NAMING
    function DERIVEPAYOUTDISTRIBUTIONHASH812(uint256[] memory _payoutNumerators) public view returns (bytes32);	//inject NONSTANDARD NAMING
    function DOINITIALREPORT448(uint256[] memory _payoutNumerators, string memory _description, uint256 _additionalStake) public returns (bool);	//inject NONSTANDARD NAMING
    function GETUNIVERSE719() public view returns (IUniverse);	//inject NONSTANDARD NAMING
    function GETDISPUTEWINDOW804() public view returns (IDisputeWindow);	//inject NONSTANDARD NAMING
    function GETNUMBEROFOUTCOMES636() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETNUMTICKS752() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETMARKETCREATORSETTLEMENTFEEDIVISOR51() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETFORKINGMARKET637() public view returns (IMarket _market);	//inject NONSTANDARD NAMING
    function GETENDTIME626() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETWINNINGPAYOUTDISTRIBUTIONHASH916() public view returns (bytes32);	//inject NONSTANDARD NAMING
    function GETWINNINGPAYOUTNUMERATOR375(uint256 _outcome) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETWINNINGREPORTINGPARTICIPANT424() public view returns (IReportingParticipant);	//inject NONSTANDARD NAMING
    function GETREPUTATIONTOKEN35() public view returns (IV2ReputationToken);	//inject NONSTANDARD NAMING
    function GETFINALIZATIONTIME347() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETINITIALREPORTER212() public view returns (IInitialReporter);	//inject NONSTANDARD NAMING
    function GETDESIGNATEDREPORTINGENDTIME834() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETVALIDITYBONDATTOCASH123() public view returns (uint256);	//inject NONSTANDARD NAMING
    function AFFILIATEFEEDIVISOR322() external view returns (uint256);	//inject NONSTANDARD NAMING
    function GETNUMPARTICIPANTS137() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETDISPUTEPACINGON415() public view returns (bool);	//inject NONSTANDARD NAMING
    function DERIVEMARKETCREATORFEEAMOUNT558(uint256 _amount) public view returns (uint256);	//inject NONSTANDARD NAMING
    function RECORDMARKETCREATORFEES738(uint256 _marketCreatorFees, address _sourceAccount, bytes32 _fingerprint) public returns (bool);	//inject NONSTANDARD NAMING
    function ISCONTAINERFORREPORTINGPARTICIPANT696(IReportingParticipant _reportingParticipant) public view returns (bool);	//inject NONSTANDARD NAMING
    function ISFINALIZEDASINVALID362() public view returns (bool);	//inject NONSTANDARD NAMING
    function FINALIZE310() public returns (bool);	//inject NONSTANDARD NAMING
    function ISFINALIZED623() public view returns (bool);	//inject NONSTANDARD NAMING
    function GETOPENINTEREST251() public view returns (uint256);	//inject NONSTANDARD NAMING
}

contract IReportingParticipant {
    function GETSTAKE932() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETPAYOUTDISTRIBUTIONHASH1000() public view returns (bytes32);	//inject NONSTANDARD NAMING
    function LIQUIDATELOSING232() public;	//inject NONSTANDARD NAMING
    function REDEEM559(address _redeemer) public returns (bool);	//inject NONSTANDARD NAMING
    function ISDISAVOWED173() public view returns (bool);	//inject NONSTANDARD NAMING
    function GETPAYOUTNUMERATOR512(uint256 _outcome) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETPAYOUTNUMERATORS444() public view returns (uint256[] memory);	//inject NONSTANDARD NAMING
    function GETMARKET927() public view returns (IMarket);	//inject NONSTANDARD NAMING
    function GETSIZE85() public view returns (uint256);	//inject NONSTANDARD NAMING
}

contract IDisputeCrowdsourcer is IReportingParticipant, IERC20 {
    function INITIALIZE90(IAugur _augur, IMarket market, uint256 _size, bytes32 _payoutDistributionHash, uint256[] memory _payoutNumerators, uint256 _crowdsourcerGeneration) public;	//inject NONSTANDARD NAMING
    function CONTRIBUTE720(address _participant, uint256 _amount, bool _overload) public returns (uint256);	//inject NONSTANDARD NAMING
    function SETSIZE177(uint256 _size) public;	//inject NONSTANDARD NAMING
    function GETREMAININGTOFILL115() public view returns (uint256);	//inject NONSTANDARD NAMING
    function CORRECTSIZE807() public returns (bool);	//inject NONSTANDARD NAMING
    function GETCROWDSOURCERGENERATION652() public view returns (uint256);	//inject NONSTANDARD NAMING
}

contract IInitialReporter is IReportingParticipant, IOwnable {
    function INITIALIZE90(IAugur _augur, IMarket _market, address _designatedReporter) public;	//inject NONSTANDARD NAMING
    function REPORT291(address _reporter, bytes32 _payoutDistributionHash, uint256[] memory _payoutNumerators, uint256 _initialReportStake) public;	//inject NONSTANDARD NAMING
    function DESIGNATEDREPORTERSHOWED809() public view returns (bool);	//inject NONSTANDARD NAMING
    function INITIALREPORTERWASCORRECT338() public view returns (bool);	//inject NONSTANDARD NAMING
    function GETDESIGNATEDREPORTER404() public view returns (address);	//inject NONSTANDARD NAMING
    function GETREPORTTIMESTAMP304() public view returns (uint256);	//inject NONSTANDARD NAMING
    function MIGRATETONEWUNIVERSE701(address _designatedReporter) public;	//inject NONSTANDARD NAMING
    function RETURNREPFROMDISAVOW512() public;	//inject NONSTANDARD NAMING
}

contract IReputationToken is IERC20 {
    function MIGRATEOUTBYPAYOUT436(uint256[] memory _payoutNumerators, uint256 _attotokens) public returns (bool);	//inject NONSTANDARD NAMING
    function MIGRATEIN692(address _reporter, uint256 _attotokens) public returns (bool);	//inject NONSTANDARD NAMING
    function TRUSTEDREPORTINGPARTICIPANTTRANSFER10(address _source, address _destination, uint256 _attotokens) public returns (bool);	//inject NONSTANDARD NAMING
    function TRUSTEDMARKETTRANSFER61(address _source, address _destination, uint256 _attotokens) public returns (bool);	//inject NONSTANDARD NAMING
    function TRUSTEDUNIVERSETRANSFER148(address _source, address _destination, uint256 _attotokens) public returns (bool);	//inject NONSTANDARD NAMING
    function TRUSTEDDISPUTEWINDOWTRANSFER53(address _source, address _destination, uint256 _attotokens) public returns (bool);	//inject NONSTANDARD NAMING
    function GETUNIVERSE719() public view returns (IUniverse);	//inject NONSTANDARD NAMING
    function GETTOTALMIGRATED220() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETTOTALTHEORETICALSUPPLY552() public view returns (uint256);	//inject NONSTANDARD NAMING
    function MINTFORREPORTINGPARTICIPANT798(uint256 _amountMigrated) public returns (bool);	//inject NONSTANDARD NAMING
}

contract IShareToken is ITyped, IERC1155 {
    function INITIALIZE90(IAugur _augur) external;	//inject NONSTANDARD NAMING
    function INITIALIZEMARKET720(IMarket _market, uint256 _numOutcomes, uint256 _numTicks) public;	//inject NONSTANDARD NAMING
    function UNSAFETRANSFERFROM654(address _from, address _to, uint256 _id, uint256 _value) public;	//inject NONSTANDARD NAMING
    function UNSAFEBATCHTRANSFERFROM211(address _from, address _to, uint256[] memory _ids, uint256[] memory _values) public;	//inject NONSTANDARD NAMING
    function CLAIMTRADINGPROCEEDS854(IMarket _market, address _shareHolder, bytes32 _fingerprint) external returns (uint256[] memory _outcomeFees);	//inject NONSTANDARD NAMING
    function GETMARKET927(uint256 _tokenId) external view returns (IMarket);	//inject NONSTANDARD NAMING
    function GETOUTCOME167(uint256 _tokenId) external view returns (uint256);	//inject NONSTANDARD NAMING
    function GETTOKENID371(IMarket _market, uint256 _outcome) public pure returns (uint256 _tokenId);	//inject NONSTANDARD NAMING
    function GETTOKENIDS530(IMarket _market, uint256[] memory _outcomes) public pure returns (uint256[] memory _tokenIds);	//inject NONSTANDARD NAMING
    function BUYCOMPLETESETS983(IMarket _market, address _account, uint256 _amount) external returns (bool);	//inject NONSTANDARD NAMING
    function BUYCOMPLETESETSFORTRADE277(IMarket _market, uint256 _amount, uint256 _longOutcome, address _longRecipient, address _shortRecipient) external returns (bool);	//inject NONSTANDARD NAMING
    function SELLCOMPLETESETS485(IMarket _market, address _holder, address _recipient, uint256 _amount, bytes32 _fingerprint) external returns (uint256 _creatorFee, uint256 _reportingFee);	//inject NONSTANDARD NAMING
    function SELLCOMPLETESETSFORTRADE561(IMarket _market, uint256 _outcome, uint256 _amount, address _shortParticipant, address _longParticipant, address _shortRecipient, address _longRecipient, uint256 _price, address _sourceAccount, bytes32 _fingerprint) external returns (uint256 _creatorFee, uint256 _reportingFee);	//inject NONSTANDARD NAMING
    function TOTALSUPPLYFORMARKETOUTCOME526(IMarket _market, uint256 _outcome) public view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOFMARKETOUTCOME21(IMarket _market, uint256 _outcome, address _account) public view returns (uint256);	//inject NONSTANDARD NAMING
    function LOWESTBALANCEOFMARKETOUTCOMES298(IMarket _market, uint256[] memory _outcomes, address _account) public view returns (uint256);	//inject NONSTANDARD NAMING
}

contract IUniverse {
    function CREATIONTIME597() external view returns (uint256);	//inject NONSTANDARD NAMING
    function MARKETBALANCE692(address) external view returns (uint256);	//inject NONSTANDARD NAMING

    function FORK341() public returns (bool);	//inject NONSTANDARD NAMING
    function UPDATEFORKVALUES73() public returns (bool);	//inject NONSTANDARD NAMING
    function GETPARENTUNIVERSE169() public view returns (IUniverse);	//inject NONSTANDARD NAMING
    function CREATECHILDUNIVERSE712(uint256[] memory _parentPayoutNumerators) public returns (IUniverse);	//inject NONSTANDARD NAMING
    function GETCHILDUNIVERSE576(bytes32 _parentPayoutDistributionHash) public view returns (IUniverse);	//inject NONSTANDARD NAMING
    function GETREPUTATIONTOKEN35() public view returns (IV2ReputationToken);	//inject NONSTANDARD NAMING
    function GETFORKINGMARKET637() public view returns (IMarket);	//inject NONSTANDARD NAMING
    function GETFORKENDTIME510() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETFORKREPUTATIONGOAL776() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETPARENTPAYOUTDISTRIBUTIONHASH230() public view returns (bytes32);	//inject NONSTANDARD NAMING
    function GETDISPUTEROUNDDURATIONINSECONDS412(bool _initial) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETORCREATEDISPUTEWINDOWBYTIMESTAMP65(uint256 _timestamp, bool _initial) public returns (IDisputeWindow);	//inject NONSTANDARD NAMING
    function GETORCREATECURRENTDISPUTEWINDOW813(bool _initial) public returns (IDisputeWindow);	//inject NONSTANDARD NAMING
    function GETORCREATENEXTDISPUTEWINDOW682(bool _initial) public returns (IDisputeWindow);	//inject NONSTANDARD NAMING
    function GETORCREATEPREVIOUSDISPUTEWINDOW575(bool _initial) public returns (IDisputeWindow);	//inject NONSTANDARD NAMING
    function GETOPENINTERESTINATTOCASH866() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETTARGETREPMARKETCAPINATTOCASH438() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETORCACHEVALIDITYBOND873() public returns (uint256);	//inject NONSTANDARD NAMING
    function GETORCACHEDESIGNATEDREPORTSTAKE630() public returns (uint256);	//inject NONSTANDARD NAMING
    function GETORCACHEDESIGNATEDREPORTNOSHOWBOND936() public returns (uint256);	//inject NONSTANDARD NAMING
    function GETORCACHEMARKETREPBOND533() public returns (uint256);	//inject NONSTANDARD NAMING
    function GETORCACHEREPORTINGFEEDIVISOR44() public returns (uint256);	//inject NONSTANDARD NAMING
    function GETDISPUTETHRESHOLDFORFORK42() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETDISPUTETHRESHOLDFORDISPUTEPACING311() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETINITIALREPORTMINVALUE947() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETPAYOUTNUMERATORS444() public view returns (uint256[] memory);	//inject NONSTANDARD NAMING
    function GETREPORTINGFEEDIVISOR13() public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETPAYOUTNUMERATOR512(uint256 _outcome) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETWINNINGCHILDPAYOUTNUMERATOR599(uint256 _outcome) public view returns (uint256);	//inject NONSTANDARD NAMING
    function ISOPENINTERESTCASH47(address) public view returns (bool);	//inject NONSTANDARD NAMING
    function ISFORKINGMARKET534() public view returns (bool);	//inject NONSTANDARD NAMING
    function GETCURRENTDISPUTEWINDOW862(bool _initial) public view returns (IDisputeWindow);	//inject NONSTANDARD NAMING
    function GETDISPUTEWINDOWSTARTTIMEANDDURATION802(uint256 _timestamp, bool _initial) public view returns (uint256, uint256);	//inject NONSTANDARD NAMING
    function ISPARENTOF319(IUniverse _shadyChild) public view returns (bool);	//inject NONSTANDARD NAMING
    function UPDATETENTATIVEWINNINGCHILDUNIVERSE89(bytes32 _parentPayoutDistributionHash) public returns (bool);	//inject NONSTANDARD NAMING
    function ISCONTAINERFORDISPUTEWINDOW320(IDisputeWindow _shadyTarget) public view returns (bool);	//inject NONSTANDARD NAMING
    function ISCONTAINERFORMARKET856(IMarket _shadyTarget) public view returns (bool);	//inject NONSTANDARD NAMING
    function ISCONTAINERFORREPORTINGPARTICIPANT696(IReportingParticipant _reportingParticipant) public view returns (bool);	//inject NONSTANDARD NAMING
    function MIGRATEMARKETOUT672(IUniverse _destinationUniverse) public returns (bool);	//inject NONSTANDARD NAMING
    function MIGRATEMARKETIN285(IMarket _market, uint256 _cashBalance, uint256 _marketOI) public returns (bool);	//inject NONSTANDARD NAMING
    function DECREMENTOPENINTEREST834(uint256 _amount) public returns (bool);	//inject NONSTANDARD NAMING
    function DECREMENTOPENINTERESTFROMMARKET346(IMarket _market) public returns (bool);	//inject NONSTANDARD NAMING
    function INCREMENTOPENINTEREST645(uint256 _amount) public returns (bool);	//inject NONSTANDARD NAMING
    function GETWINNINGCHILDUNIVERSE709() public view returns (IUniverse);	//inject NONSTANDARD NAMING
    function ISFORKING853() public view returns (bool);	//inject NONSTANDARD NAMING
    function DEPOSIT693(address _sender, uint256 _amount, address _market) public returns (bool);	//inject NONSTANDARD NAMING
    function WITHDRAW474(address _recipient, uint256 _amount, address _market) public returns (bool);	//inject NONSTANDARD NAMING
    function CREATESCALARMARKET875(uint256 _endTime, uint256 _feePerCashInAttoCash, IAffiliateValidator _affiliateValidator, uint256 _affiliateFeeDivisor, address _designatedReporterAddress, int256[] memory _prices, uint256 _numTicks, string memory _extraInfo) public returns (IMarket _newMarket);	//inject NONSTANDARD NAMING
}

contract IV2ReputationToken is IReputationToken {
    function PARENTUNIVERSE976() external returns (IUniverse);	//inject NONSTANDARD NAMING
    function BURNFORMARKET683(uint256 _amountToBurn) public returns (bool);	//inject NONSTANDARD NAMING
    function MINTFORWARPSYNC909(uint256 _amountToMint, address _target) public returns (bool);	//inject NONSTANDARD NAMING
}

library Reporting {
    uint256 private constant designated_reporting_duration_seconds939 = 1 days;	//inject NONSTANDARD NAMING
    uint256 private constant dispute_round_duration_seconds351 = 7 days;	//inject NONSTANDARD NAMING
    uint256 private constant initial_dispute_round_duration_seconds185 = 1 days;	//inject NONSTANDARD NAMING
    uint256 private constant dispute_window_buffer_seconds655 = 1 hours;	//inject NONSTANDARD NAMING
    uint256 private constant fork_duration_seconds463 = 60 days;	//inject NONSTANDARD NAMING

    uint256 private constant base_market_duration_maximum20 = 30 days; // A market of 30 day length can always be created	//inject NONSTANDARD NAMING
    uint256 private constant upgrade_cadence254 = 365 days;	//inject NONSTANDARD NAMING
    uint256 private constant initial_upgrade_timestamp605 = 1627776000; // Aug 1st 2021	//inject NONSTANDARD NAMING

    uint256 private constant initial_rep_supply507 = 11 * 10 ** 6 * 10 ** 18; // 11 Million REP	//inject NONSTANDARD NAMING

    uint256 private constant affiliate_source_cut_divisor194 = 5; // The trader gets 20% of the affiliate fee when an affiliate fee is taken	//inject NONSTANDARD NAMING

    uint256 private constant default_validity_bond803 = 10 ether; // 10 Cash (Dai)	//inject NONSTANDARD NAMING
    uint256 private constant validity_bond_floor708 = 10 ether; // 10 Cash (Dai)	//inject NONSTANDARD NAMING
    uint256 private constant default_reporting_fee_divisor809 = 10000; // .01% fees	//inject NONSTANDARD NAMING
    uint256 private constant maximum_reporting_fee_divisor548 = 10000; // Minimum .01% fees	//inject NONSTANDARD NAMING
    uint256 private constant minimum_reporting_fee_divisor749 = 3; // Maximum 33.3~% fees. Note than anything less than a value of 2 here will likely result in bugs such as divide by 0 cases.	//inject NONSTANDARD NAMING

    uint256 private constant target_invalid_markets_divisor747 = 100; // 1% of markets are expected to be invalid	//inject NONSTANDARD NAMING
    uint256 private constant target_incorrect_designated_report_markets_divisor83 = 100; // 1% of markets are expected to have an incorrect designate report	//inject NONSTANDARD NAMING
    uint256 private constant target_designated_report_no_shows_divisor678 = 20; // 5% of markets are expected to have a no show	//inject NONSTANDARD NAMING
    uint256 private constant target_rep_market_cap_multiplier475 = 5; // We multiply and divide by constants since we may want to multiply by a fractional amount	//inject NONSTANDARD NAMING

    uint256 private constant fork_threshold_divisor49 = 40; // 2.5% of the total REP supply being filled in a single dispute bond will trigger a fork	//inject NONSTANDARD NAMING
    uint256 private constant maximum_dispute_rounds529 = 20; // We ensure that after 20 rounds of disputes a fork will occur	//inject NONSTANDARD NAMING
    uint256 private constant minimum_slow_rounds438 = 8; // We ensure that at least 8 dispute rounds take DISPUTE_ROUND_DURATION_SECONDS+ seconds to complete until the next round begins	//inject NONSTANDARD NAMING

    function GETDESIGNATEDREPORTINGDURATIONSECONDS10() internal pure returns (uint256) { return designated_reporting_duration_seconds939; }	//inject NONSTANDARD NAMING
    function GETINITIALDISPUTEROUNDDURATIONSECONDS286() internal pure returns (uint256) { return initial_dispute_round_duration_seconds185; }	//inject NONSTANDARD NAMING
    function GETDISPUTEWINDOWBUFFERSECONDS683() internal pure returns (uint256) { return dispute_window_buffer_seconds655; }	//inject NONSTANDARD NAMING
    function GETDISPUTEROUNDDURATIONSECONDS187() internal pure returns (uint256) { return dispute_round_duration_seconds351; }	//inject NONSTANDARD NAMING
    function GETFORKDURATIONSECONDS842() internal pure returns (uint256) { return fork_duration_seconds463; }	//inject NONSTANDARD NAMING
    function GETBASEMARKETDURATIONMAXIMUM759() internal pure returns (uint256) { return base_market_duration_maximum20; }	//inject NONSTANDARD NAMING
    function GETUPGRADECADENCE338() internal pure returns (uint256) { return upgrade_cadence254; }	//inject NONSTANDARD NAMING
    function GETINITIALUPGRADETIMESTAMP486() internal pure returns (uint256) { return initial_upgrade_timestamp605; }	//inject NONSTANDARD NAMING
    function GETDEFAULTVALIDITYBOND656() internal pure returns (uint256) { return default_validity_bond803; }	//inject NONSTANDARD NAMING
    function GETVALIDITYBONDFLOOR634() internal pure returns (uint256) { return validity_bond_floor708; }	//inject NONSTANDARD NAMING
    function GETTARGETINVALIDMARKETSDIVISOR906() internal pure returns (uint256) { return target_invalid_markets_divisor747; }	//inject NONSTANDARD NAMING
    function GETTARGETINCORRECTDESIGNATEDREPORTMARKETSDIVISOR444() internal pure returns (uint256) { return target_incorrect_designated_report_markets_divisor83; }	//inject NONSTANDARD NAMING
    function GETTARGETDESIGNATEDREPORTNOSHOWSDIVISOR524() internal pure returns (uint256) { return target_designated_report_no_shows_divisor678; }	//inject NONSTANDARD NAMING
    function GETTARGETREPMARKETCAPMULTIPLIER935() internal pure returns (uint256) { return target_rep_market_cap_multiplier475; }	//inject NONSTANDARD NAMING
    function GETMAXIMUMREPORTINGFEEDIVISOR201() internal pure returns (uint256) { return maximum_reporting_fee_divisor548; }	//inject NONSTANDARD NAMING
    function GETMINIMUMREPORTINGFEEDIVISOR230() internal pure returns (uint256) { return minimum_reporting_fee_divisor749; }	//inject NONSTANDARD NAMING
    function GETDEFAULTREPORTINGFEEDIVISOR804() internal pure returns (uint256) { return default_reporting_fee_divisor809; }	//inject NONSTANDARD NAMING
    function GETINITIALREPSUPPLY859() internal pure returns (uint256) { return initial_rep_supply507; }	//inject NONSTANDARD NAMING
    function GETAFFILIATESOURCECUTDIVISOR779() internal pure returns (uint256) { return affiliate_source_cut_divisor194; }	//inject NONSTANDARD NAMING
    function GETFORKTHRESHOLDDIVISOR823() internal pure returns (uint256) { return fork_threshold_divisor49; }	//inject NONSTANDARD NAMING
    function GETMAXIMUMDISPUTEROUNDS774() internal pure returns (uint256) { return maximum_dispute_rounds529; }	//inject NONSTANDARD NAMING
    function GETMINIMUMSLOWROUNDS218() internal pure returns (uint256) { return minimum_slow_rounds438; }	//inject NONSTANDARD NAMING
}

contract IAugurTrading {
    function LOOKUP594(bytes32 _key) public view returns (address);	//inject NONSTANDARD NAMING
    function LOGPROFITLOSSCHANGED911(IMarket _market, address _account, uint256 _outcome, int256 _netPosition, uint256 _avgPrice, int256 _realizedProfit, int256 _frozenFunds, int256 _realizedCost) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGORDERCREATED154(IUniverse _universe, bytes32 _orderId, bytes32 _tradeGroupId) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGORDERCANCELED389(IUniverse _universe, IMarket _market, address _creator, uint256 _tokenRefund, uint256 _sharesRefund, bytes32 _orderId) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGORDERFILLED166(IUniverse _universe, address _creator, address _filler, uint256 _price, uint256 _fees, uint256 _amountFilled, bytes32 _orderId, bytes32 _tradeGroupId) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGMARKETVOLUMECHANGED635(IUniverse _universe, address _market, uint256 _volume, uint256[] memory _outcomeVolumes, uint256 _totalTrades) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGZEROXORDERFILLED898(IUniverse _universe, IMarket _market, bytes32 _orderHash, bytes32 _tradeGroupId, uint8 _orderType, address[] memory _addressData, uint256[] memory _uint256Data) public returns (bool);	//inject NONSTANDARD NAMING
    function LOGZEROXORDERCANCELED137(address _universe, address _market, address _account, uint256 _outcome, uint256 _price, uint256 _amount, uint8 _type, bytes32 _orderHash) public;	//inject NONSTANDARD NAMING
}

contract IOrders {
    function SAVEORDER165(uint256[] calldata _uints, bytes32[] calldata _bytes32s, Order.Types _type, IMarket _market, address _sender) external returns (bytes32 _orderId);	//inject NONSTANDARD NAMING
    function REMOVEORDER407(bytes32 _orderId) external returns (bool);	//inject NONSTANDARD NAMING
    function GETMARKET927(bytes32 _orderId) public view returns (IMarket);	//inject NONSTANDARD NAMING
    function GETORDERTYPE39(bytes32 _orderId) public view returns (Order.Types);	//inject NONSTANDARD NAMING
    function GETOUTCOME167(bytes32 _orderId) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETAMOUNT930(bytes32 _orderId) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETPRICE598(bytes32 _orderId) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETORDERCREATOR755(bytes32 _orderId) public view returns (address);	//inject NONSTANDARD NAMING
    function GETORDERSHARESESCROWED20(bytes32 _orderId) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETORDERMONEYESCROWED161(bytes32 _orderId) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETORDERDATAFORCANCEL357(bytes32 _orderId) public view returns (uint256, uint256, Order.Types, IMarket, uint256, address);	//inject NONSTANDARD NAMING
    function GETORDERDATAFORLOGS935(bytes32 _orderId) public view returns (Order.Types, address[] memory _addressData, uint256[] memory _uint256Data);	//inject NONSTANDARD NAMING
    function GETBETTERORDERID822(bytes32 _orderId) public view returns (bytes32);	//inject NONSTANDARD NAMING
    function GETWORSEORDERID439(bytes32 _orderId) public view returns (bytes32);	//inject NONSTANDARD NAMING
    function GETBESTORDERID727(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);	//inject NONSTANDARD NAMING
    function GETWORSTORDERID835(Order.Types _type, IMarket _market, uint256 _outcome) public view returns (bytes32);	//inject NONSTANDARD NAMING
    function GETLASTOUTCOMEPRICE593(IMarket _market, uint256 _outcome) public view returns (uint256);	//inject NONSTANDARD NAMING
    function GETORDERID157(Order.Types _type, IMarket _market, uint256 _amount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) public pure returns (bytes32);	//inject NONSTANDARD NAMING
    function GETTOTALESCROWED463(IMarket _market) public view returns (uint256);	//inject NONSTANDARD NAMING
    function ISBETTERPRICE274(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);	//inject NONSTANDARD NAMING
    function ISWORSEPRICE692(Order.Types _type, uint256 _price, bytes32 _orderId) public view returns (bool);	//inject NONSTANDARD NAMING
    function ASSERTISNOTBETTERPRICE18(Order.Types _type, uint256 _price, bytes32 _betterOrderId) public view returns (bool);	//inject NONSTANDARD NAMING
    function ASSERTISNOTWORSEPRICE875(Order.Types _type, uint256 _price, bytes32 _worseOrderId) public returns (bool);	//inject NONSTANDARD NAMING
    function RECORDFILLORDER693(bytes32 _orderId, uint256 _sharesFilled, uint256 _tokensFilled, uint256 _fill) external returns (bool);	//inject NONSTANDARD NAMING
    function SETPRICE687(IMarket _market, uint256 _outcome, uint256 _price) external returns (bool);	//inject NONSTANDARD NAMING
}

library Order {
    using SafeMathUint256 for uint256;

    enum Types {
        Bid, Ask
    }

    enum TradeDirections {
        Long, Short
    }

    struct Data {
        // Contracts
        IMarket market;
        IAugur augur;
        IAugurTrading augurTrading;
        IShareToken shareToken;
        ICash cash;

        // Order
        bytes32 id;
        address creator;
        uint256 outcome;
        Order.Types orderType;
        uint256 amount;
        uint256 price;
        uint256 sharesEscrowed;
        uint256 moneyEscrowed;
        bytes32 betterOrderId;
        bytes32 worseOrderId;
    }

    function CREATE815(IAugur _augur, IAugurTrading _augurTrading, address _creator, uint256 _outcome, Order.Types _type, uint256 _attoshares, uint256 _price, IMarket _market, bytes32 _betterOrderId, bytes32 _worseOrderId) internal view returns (Data memory) {	//inject NONSTANDARD NAMING
        require(_outcome < _market.GETNUMBEROFOUTCOMES636(), "Order.create: Outcome is not within market range");
        require(_price != 0, "Order.create: Price may not be 0");
        require(_price < _market.GETNUMTICKS752(), "Order.create: Price is outside of market range");
        require(_attoshares > 0, "Order.create: Cannot use amount of 0");
        require(_creator != address(0), "Order.create: Creator is 0x0");

        IShareToken _shareToken = IShareToken(_augur.LOOKUP594("ShareToken"));

        return Data({
            market: _market,
            augur: _augur,
            augurTrading: _augurTrading,
            shareToken: _shareToken,
            cash: ICash(_augur.LOOKUP594("Cash")),
            id: 0,
            creator: _creator,
            outcome: _outcome,
            orderType: _type,
            amount: _attoshares,
            price: _price,
            sharesEscrowed: 0,
            moneyEscrowed: 0,
            betterOrderId: _betterOrderId,
            worseOrderId: _worseOrderId
        });
    }

    //
    // "public" functions
    //

    function GETORDERID157(Order.Data memory _orderData, IOrders _orders) internal view returns (bytes32) {	//inject NONSTANDARD NAMING
        if (_orderData.id == bytes32(0)) {
            bytes32 _orderId = CALCULATEORDERID856(_orderData.orderType, _orderData.market, _orderData.amount, _orderData.price, _orderData.creator, block.number, _orderData.outcome, _orderData.moneyEscrowed, _orderData.sharesEscrowed);
            require(_orders.GETAMOUNT930(_orderId) == 0, "Order.getOrderId: New order had amount. This should not be possible");
            _orderData.id = _orderId;
        }
        return _orderData.id;
    }

    function CALCULATEORDERID856(Order.Types _type, IMarket _market, uint256 _amount, uint256 _price, address _sender, uint256 _blockNumber, uint256 _outcome, uint256 _moneyEscrowed, uint256 _sharesEscrowed) internal pure returns (bytes32) {	//inject NONSTANDARD NAMING
        return sha256(abi.encodePacked(_type, _market, _amount, _price, _sender, _blockNumber, _outcome, _moneyEscrowed, _sharesEscrowed));
    }

    function GETORDERTRADINGTYPEFROMMAKERDIRECTION100(Order.TradeDirections _creatorDirection) internal pure returns (Order.Types) {	//inject NONSTANDARD NAMING
        return (_creatorDirection == Order.TradeDirections.Long) ? Order.Types.Bid : Order.Types.Ask;
    }

    function GETORDERTRADINGTYPEFROMFILLERDIRECTION800(Order.TradeDirections _fillerDirection) internal pure returns (Order.Types) {	//inject NONSTANDARD NAMING
        return (_fillerDirection == Order.TradeDirections.Long) ? Order.Types.Ask : Order.Types.Bid;
    }

    function SAVEORDER165(Order.Data memory _orderData, bytes32 _tradeGroupId, IOrders _orders) internal returns (bytes32) {	//inject NONSTANDARD NAMING
        GETORDERID157(_orderData, _orders);
        uint256[] memory _uints = new uint256[](5);
        _uints[0] = _orderData.amount;
        _uints[1] = _orderData.price;
        _uints[2] = _orderData.outcome;
        _uints[3] = _orderData.moneyEscrowed;
        _uints[4] = _orderData.sharesEscrowed;
        bytes32[] memory _bytes32s = new bytes32[](4);
        _bytes32s[0] = _orderData.betterOrderId;
        _bytes32s[1] = _orderData.worseOrderId;
        _bytes32s[2] = _tradeGroupId;
        _bytes32s[3] = _orderData.id;
        return _orders.SAVEORDER165(_uints, _bytes32s, _orderData.orderType, _orderData.market, _orderData.creator);
    }
}

interface IUniswapV2Pair {
    event APPROVAL665(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER723(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME524() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL582() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS958() external pure returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY304() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF492(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE377(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE293(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER644(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM669(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING

    function DOMAIN_SEPARATOR256() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function PERMIT_TYPEHASH256() external pure returns (bytes32);	//inject NONSTANDARD NAMING
    function NONCES605(address owner) external view returns (uint);	//inject NONSTANDARD NAMING

    function PERMIT866(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING

    event MINT159(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN674(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP992(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC856(uint112 reserve0, uint112 reserve1);	//inject NONSTANDARD NAMING

    function MINIMUM_LIQUIDITY585() external pure returns (uint);	//inject NONSTANDARD NAMING
    function FACTORY704() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN0151() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN132() external view returns (address);	//inject NONSTANDARD NAMING
    function GETRESERVES901() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);	//inject NONSTANDARD NAMING
    function PRICE0CUMULATIVELAST708() external view returns (uint);	//inject NONSTANDARD NAMING
    function PRICE1CUMULATIVELAST245() external view returns (uint);	//inject NONSTANDARD NAMING
    function KLAST943() external view returns (uint);	//inject NONSTANDARD NAMING

    function MINT146(address to) external returns (uint liquidity);	//inject NONSTANDARD NAMING
    function BURN234(address to) external returns (uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    function SWAP505(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;	//inject NONSTANDARD NAMING
    function SKIM81(address to) external;	//inject NONSTANDARD NAMING
    function SYNC86() external;	//inject NONSTANDARD NAMING

    function INITIALIZE90(address, address) external;	//inject NONSTANDARD NAMING
}

contract IRepSymbol {
    function GETREPSYMBOL498(address _augur, address _universe) external view returns (string memory);	//inject NONSTANDARD NAMING
}

contract ReputationToken is VariableSupplyToken, IV2ReputationToken {
    using SafeMathUint256 for uint256;

    string constant public name600 = "Reputation";	//inject NONSTANDARD NAMING
    IUniverse internal universe;
    IUniverse public parentUniverse;
    uint256 internal totalMigrated;
    IERC20 public legacyRepToken;
    IAugur public augur;
    address public warpSync;

    constructor(IAugur _augur, IUniverse _universe, IUniverse _parentUniverse) public {
        augur = _augur;
        universe = _universe;
        parentUniverse = _parentUniverse;
        warpSync = _augur.LOOKUP594("WarpSync");
        legacyRepToken = IERC20(_augur.LOOKUP594("LegacyReputationToken"));
        require(warpSync != address(0));
        require(legacyRepToken != IERC20(0));
    }

    function SYMBOL582() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return IRepSymbol(augur.LOOKUP594("RepSymbol")).GETREPSYMBOL498(address(augur), address(universe));
    }

                                                                                                                                                                                                                                                                                                         
    function MIGRATEOUTBYPAYOUT436(uint256[] memory _payoutNumerators, uint256 _attotokens) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_attotokens > 0);
        IUniverse _destinationUniverse = universe.CREATECHILDUNIVERSE712(_payoutNumerators);
        IReputationToken _destination = _destinationUniverse.GETREPUTATIONTOKEN35();
        BURN234(msg.sender, _attotokens);
        _destination.MIGRATEIN692(msg.sender, _attotokens);
        return true;
    }

    function MIGRATEIN692(address _reporter, uint256 _attotokens) public returns (bool) {	//inject NONSTANDARD NAMING
        IUniverse _parentUniverse = parentUniverse;
        require(ReputationToken(msg.sender) == _parentUniverse.GETREPUTATIONTOKEN35());
        require(augur.GETTIMESTAMP626() < _parentUniverse.GETFORKENDTIME510());
        MINT146(_reporter, _attotokens);
        totalMigrated += _attotokens;
        // Update the fork tentative winner and finalize if we can
        if (!_parentUniverse.GETFORKINGMARKET637().ISFINALIZED623()) {
            _parentUniverse.UPDATETENTATIVEWINNINGCHILDUNIVERSE89(universe.GETPARENTPAYOUTDISTRIBUTIONHASH230());
        }
        return true;
    }

    function MINTFORREPORTINGPARTICIPANT798(uint256 _amountMigrated) public returns (bool) {	//inject NONSTANDARD NAMING
        IReportingParticipant _reportingParticipant = IReportingParticipant(msg.sender);
        require(parentUniverse.ISCONTAINERFORREPORTINGPARTICIPANT696(_reportingParticipant));
        // simulate a 40% ROI which would have occured during a normal dispute had this participant's outcome won the dispute
        uint256 _bonus = _amountMigrated.MUL760(2) / 5;
        MINT146(address(_reportingParticipant), _bonus);
        return true;
    }

    function MINTFORWARPSYNC909(uint256 _amountToMint, address _target) public returns (bool) {	//inject NONSTANDARD NAMING
        require(warpSync == msg.sender);
        MINT146(_target, _amountToMint);
        universe.UPDATEFORKVALUES73();
        return true;
    }

    function BURNFORMARKET683(uint256 _amountToBurn) public returns (bool) {	//inject NONSTANDARD NAMING
        require(universe.ISCONTAINERFORMARKET856(IMarket(msg.sender)));
        BURN234(msg.sender, _amountToBurn);
        return true;
    }

    function TRUSTEDUNIVERSETRANSFER148(address _source, address _destination, uint256 _attotokens) public returns (bool) {	//inject NONSTANDARD NAMING
        require(IUniverse(msg.sender) == universe);
        _TRANSFER433(_source, _destination, _attotokens);
        return true;
    }

    function TRUSTEDMARKETTRANSFER61(address _source, address _destination, uint256 _attotokens) public returns (bool) {	//inject NONSTANDARD NAMING
        require(universe.ISCONTAINERFORMARKET856(IMarket(msg.sender)));
        _TRANSFER433(_source, _destination, _attotokens);
        return true;
    }

    function TRUSTEDREPORTINGPARTICIPANTTRANSFER10(address _source, address _destination, uint256 _attotokens) public returns (bool) {	//inject NONSTANDARD NAMING
        require(universe.ISCONTAINERFORREPORTINGPARTICIPANT696(IReportingParticipant(msg.sender)));
        _TRANSFER433(_source, _destination, _attotokens);
        return true;
    }

    function TRUSTEDDISPUTEWINDOWTRANSFER53(address _source, address _destination, uint256 _attotokens) public returns (bool) {	//inject NONSTANDARD NAMING
        require(universe.ISCONTAINERFORDISPUTEWINDOW320(IDisputeWindow(msg.sender)));
        _TRANSFER433(_source, _destination, _attotokens);
        return true;
    }

    function ASSERTREPUTATIONTOKENISLEGITCHILD164(IReputationToken _shadyReputationToken) private view {	//inject NONSTANDARD NAMING
        IUniverse _universe = _shadyReputationToken.GETUNIVERSE719();
        require(universe.ISPARENTOF319(_universe));
        require(_universe.GETREPUTATIONTOKEN35() == _shadyReputationToken);
    }

                                                                                 
    function GETUNIVERSE719() public view returns (IUniverse) {	//inject NONSTANDARD NAMING
        return universe;
    }

                                                                                               
    function GETTOTALMIGRATED220() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return totalMigrated;
    }

                                               
    function GETLEGACYREPTOKEN110() public view returns (IERC20) {	//inject NONSTANDARD NAMING
        return legacyRepToken;
    }

                                                                                         
    function GETTOTALTHEORETICALSUPPLY552() public view returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 _totalSupply = totalSupply;
        if (parentUniverse == IUniverse(0)) {
            return _totalSupply.ADD571(legacyRepToken.TOTALSUPPLY304()).SUB692(legacyRepToken.BALANCEOF492(address(1))).SUB692(legacyRepToken.BALANCEOF492(address(0)));
        } else if (augur.GETTIMESTAMP626() >= parentUniverse.GETFORKENDTIME510()) {
            return _totalSupply;
        } else {
            return _totalSupply + parentUniverse.GETREPUTATIONTOKEN35().GETTOTALTHEORETICALSUPPLY552();
        }
    }

    function ONTOKENTRANSFER292(address _from, address _to, uint256 _value) internal {	//inject NONSTANDARD NAMING
        augur.LOGREPUTATIONTOKENSTRANSFERRED904(universe, _from, _to, _value, balances[_from], balances[_to]);
    }

    function ONMINT315(address _target, uint256 _amount) internal {	//inject NONSTANDARD NAMING
        augur.LOGREPUTATIONTOKENSMINTED985(universe, _target, _amount, totalSupply, balances[_target]);
    }

    function ONBURN653(address _target, uint256 _amount) internal {	//inject NONSTANDARD NAMING
        augur.LOGREPUTATIONTOKENSBURNED995(universe, _target, _amount, totalSupply, balances[_target]);
    }

                                                                                                                                                                                                                 
    function MIGRATEFROMLEGACYREPUTATIONTOKEN918() public returns (bool) {	//inject NONSTANDARD NAMING
        require(parentUniverse == IUniverse(0));
        uint256 _legacyBalance = legacyRepToken.BALANCEOF492(msg.sender);
        require(legacyRepToken.TRANSFERFROM669(msg.sender, address(1), _legacyBalance));
        MINT146(msg.sender, _legacyBalance);
        return true;
    }
}