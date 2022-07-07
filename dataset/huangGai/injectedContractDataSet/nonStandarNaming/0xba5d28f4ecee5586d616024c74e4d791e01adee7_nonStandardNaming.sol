                                                                 

// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY267() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF771(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER36(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE520(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE275(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM54(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER513(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL255(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD260(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB684(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB684(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB684(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL872(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV551(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV551(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV551(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD699(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD699(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD699(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT292(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE986(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL437(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL437(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL437(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE654(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE142(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE142(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE142(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE654(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE654(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT292(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER627(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN808(token, abi.encodeWithSelector(token.TRANSFER36.selector, to, value));
    }

    function SAFETRANSFERFROM565(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN808(token, abi.encodeWithSelector(token.TRANSFERFROM54.selector, from, to, value));
    }

                                                                                                                                                                                                                                                             
    function SAFEAPPROVE47(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE520(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _CALLOPTIONALRETURN808(token, abi.encodeWithSelector(token.APPROVE275.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE824(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE520(address(this), spender).ADD260(value);
        _CALLOPTIONALRETURN808(token, abi.encodeWithSelector(token.APPROVE275.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE914(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE520(address(this), spender).SUB684(value, "SafeERC20: decreased allowance below zero");
        _CALLOPTIONALRETURN808(token, abi.encodeWithSelector(token.APPROVE275.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function _CALLOPTIONALRETURN808(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).FUNCTIONCALL437(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface IMultiVaultStrategy {
    function WANT777() external view returns (address);	//inject NONSTANDARD NAMING
    function DEPOSIT294() external;	//inject NONSTANDARD NAMING
    function WITHDRAW808(address _asset) external;	//inject NONSTANDARD NAMING
    function WITHDRAW808(uint _amount) external returns (uint);	//inject NONSTANDARD NAMING
    function WITHDRAWTOCONTROLLER653(uint _amount) external;	//inject NONSTANDARD NAMING
    function SKIM294() external;	//inject NONSTANDARD NAMING
    function HARVEST506(address _mergedStrategy) external;	//inject NONSTANDARD NAMING
    function WITHDRAWALL927() external returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF771() external view returns (uint);	//inject NONSTANDARD NAMING
    function WITHDRAWFEE692(uint) external view returns (uint); // pJar: 0.5% (50/10000)	//inject NONSTANDARD NAMING
}

interface IValueMultiVault {
    function CAP418() external view returns (uint);	//inject NONSTANDARD NAMING
    function GETCONVERTER215(address _want) external view returns (address);	//inject NONSTANDARD NAMING
    function GETVAULTMASTER236() external view returns (address);	//inject NONSTANDARD NAMING
    function BALANCE180() external view returns (uint);	//inject NONSTANDARD NAMING
    function TOKEN385() external view returns (address);	//inject NONSTANDARD NAMING
    function AVAILABLE930(address _want) external view returns (uint);	//inject NONSTANDARD NAMING
    function ACCEPT281(address _input) external view returns (bool);	//inject NONSTANDARD NAMING

    function CLAIMINSURANCE45() external;	//inject NONSTANDARD NAMING
    function EARN427(address _want) external;	//inject NONSTANDARD NAMING
    function HARVEST506(address reserve, uint amount) external;	//inject NONSTANDARD NAMING

    function WITHDRAW_FEE118(uint _shares) external view returns (uint);	//inject NONSTANDARD NAMING
    function CALC_TOKEN_AMOUNT_DEPOSIT453(uint[] calldata _amounts) external view returns (uint);	//inject NONSTANDARD NAMING
    function CALC_TOKEN_AMOUNT_WITHDRAW2(uint _shares, address _output) external view returns (uint);	//inject NONSTANDARD NAMING
    function CONVERT_RATE825(address _input, uint _amount) external view returns (uint);	//inject NONSTANDARD NAMING
    function GETPRICEPERFULLSHARE124() external view returns (uint);	//inject NONSTANDARD NAMING
    function GET_VIRTUAL_PRICE769() external view returns (uint); // average dollar value of vault share token	//inject NONSTANDARD NAMING

    function DEPOSIT294(address _input, uint _amount, uint _min_mint_amount) external returns (uint _mint_amount);	//inject NONSTANDARD NAMING
    function DEPOSITFOR247(address _account, address _to, address _input, uint _amount, uint _min_mint_amount) external returns (uint _mint_amount);	//inject NONSTANDARD NAMING
    function DEPOSITALL52(uint[] calldata _amounts, uint _min_mint_amount) external returns (uint _mint_amount);	//inject NONSTANDARD NAMING
    function DEPOSITALLFOR442(address _account, address _to, uint[] calldata _amounts, uint _min_mint_amount) external returns (uint _mint_amount);	//inject NONSTANDARD NAMING
    function WITHDRAW808(uint _shares, address _output, uint _min_output_amount) external returns (uint);	//inject NONSTANDARD NAMING
    function WITHDRAWFOR513(address _account, uint _shares, address _output, uint _min_output_amount) external returns (uint _output_amount);	//inject NONSTANDARD NAMING

    function HARVESTSTRATEGY825(address _strategy) external;	//inject NONSTANDARD NAMING
    function HARVESTWANT168(address _want) external;	//inject NONSTANDARD NAMING
    function HARVESTALLSTRATEGIES334() external;	//inject NONSTANDARD NAMING
}

interface IShareConverter {
    function CONVERT_SHARES_RATE463(address _input, address _output, uint _inputAmount) external view returns (uint _outputAmount);	//inject NONSTANDARD NAMING

    function CONVERT_SHARES33(address _input, address _output, uint _inputAmount) external returns (uint _outputAmount);	//inject NONSTANDARD NAMING
}

interface Converter {
    function CONVERT349(address) external returns (uint);	//inject NONSTANDARD NAMING
}

contract MultiStablesVaultController {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint;

    address public governance;
    address public strategist;

    struct StrategyInfo {
        address strategy;
        uint quota; // set = 0 to disable
        uint percent;
    }

    IValueMultiVault public vault;

    address public basedWant;
    address[] public wantTokens; // sorted by preference

    // want => quota, length
    mapping(address => uint) public wantQuota;
    mapping(address => uint) public wantStrategyLength;

    // want => stratId => StrategyInfo
    mapping(address => mapping(uint => StrategyInfo)) public strategies;

    mapping(address => mapping(address => bool)) public approvedStrategies;

    mapping(address => bool) public investDisabled;
    IShareConverter public shareConverter; // converter for shares (3CRV <-> BCrv, etc ...)
    address public lazySelectedBestStrategy; // we pre-set the best strategy to avoid gas cost of iterating the array

    constructor(IValueMultiVault _vault) public {
        require(address(_vault) != address(0), "!_vault");
        vault = _vault;
        basedWant = vault.TOKEN385();
        governance = msg.sender;
        strategist = msg.sender;
    }

    function SETGOVERNANCE701(address _governance) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function SETSTRATEGIST330(address _strategist) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        strategist = _strategist;
    }

    function APPROVESTRATEGY673(address _want, address _strategy) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        approvedStrategies[_want][_strategy] = true;
    }

    function REVOKESTRATEGY92(address _want, address _strategy) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        approvedStrategies[_want][_strategy] = false;
    }

    function SETWANTQUOTA716(address _want, uint _quota) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        wantQuota[_want] = _quota;
    }

    function SETWANTSTRATEGYLENGTH858(address _want, uint _length) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        wantStrategyLength[_want] = _length;
    }

    // want => stratId => StrategyInfo
    function SETSTRATEGYINFO462(address _want, uint _sid, address _strategy, uint _quota, uint _percent) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        require(approvedStrategies[_want][_strategy], "!approved");
        strategies[_want][_sid].strategy = _strategy;
        strategies[_want][_sid].quota = _quota;
        strategies[_want][_sid].percent = _percent;
    }

    function SETSHARECONVERTER560(IShareConverter _shareConverter) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        shareConverter = _shareConverter;
    }

    function SETINVESTDISABLED819(address _want, bool _investDisabled) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        investDisabled[_want] = _investDisabled;
    }

    function SETWANTTOKENS997(address[] memory _wantTokens) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        delete wantTokens;
        uint _wlength = _wantTokens.length;
        for (uint i = 0; i < _wlength; ++i) {
            wantTokens.push(_wantTokens[i]);
        }
    }

    function GETSTRATEGYCOUNT337() external view returns(uint _strategyCount) {	//inject NONSTANDARD NAMING
        _strategyCount = 0;
        uint _wlength = wantTokens.length;
        for (uint i = 0; i < _wlength; i++) {
            _strategyCount = _strategyCount.ADD260(wantStrategyLength[wantTokens[i]]);
        }
    }

    function WANTLENGTH873() external view returns (uint) {	//inject NONSTANDARD NAMING
        return wantTokens.length;
    }

    function WANTSTRATEGYBALANCE73(address _want) public view returns (uint) {	//inject NONSTANDARD NAMING
        uint _bal = 0;
        for (uint _sid = 0; _sid < wantStrategyLength[_want]; _sid++) {
            _bal = _bal.ADD260(IMultiVaultStrategy(strategies[_want][_sid].strategy).BALANCEOF771());
        }
        return _bal;
    }

    function WANT777() external view returns (address) {	//inject NONSTANDARD NAMING
        if (lazySelectedBestStrategy != address(0)) {
            return IMultiVaultStrategy(lazySelectedBestStrategy).WANT777();
        }
        uint _wlength = wantTokens.length;
        if (_wlength > 0) {
            if (_wlength == 1) {
                return wantTokens[0];
            }
            for (uint i = 0; i < _wlength; i++) {
                address _want = wantTokens[i];
                uint _bal = WANTSTRATEGYBALANCE73(_want);
                if (_bal < wantQuota[_want]) {
                    return _want;
                }
            }
        }
        return basedWant;
    }

    function SETLAZYSELECTEDBESTSTRATEGY629(address _strategy) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        lazySelectedBestStrategy = _strategy;
    }

    function GETBESTSTRATEGY227(address _want) public view returns (address _strategy) {	//inject NONSTANDARD NAMING
        if (lazySelectedBestStrategy != address(0) && IMultiVaultStrategy(lazySelectedBestStrategy).WANT777() == _want) {
            return lazySelectedBestStrategy;
        }
        uint _wantStrategyLength = wantStrategyLength[_want];
        _strategy = address(0);
        if (_wantStrategyLength == 0) return _strategy;
        uint _totalBal = WANTSTRATEGYBALANCE73(_want);
        if (_totalBal == 0) {
            // first depositor, simply return the first strategy
            return strategies[_want][0].strategy;
        }
        uint _bestDiff = 201;
        for (uint _sid = 0; _sid < _wantStrategyLength; _sid++) {
            StrategyInfo storage sinfo = strategies[_want][_sid];
            uint _stratBal = IMultiVaultStrategy(sinfo.strategy).BALANCEOF771();
            if (_stratBal < sinfo.quota) {
                uint _diff = _stratBal.ADD260(_totalBal).MUL872(100).DIV551(_totalBal).SUB684(sinfo.percent); // [100, 200] - [percent]
                if (_diff < _bestDiff) {
                    _bestDiff = _diff;
                    _strategy = sinfo.strategy;
                }
            }
        }
        if (_strategy == address(0)) {
            _strategy = strategies[_want][0].strategy;
        }
    }

    function EARN427(address _token, uint _amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == address(vault) || msg.sender == strategist || msg.sender == governance, "!strategist");
        address _strategy = GETBESTSTRATEGY227(_token);
        if (_strategy == address(0) || IMultiVaultStrategy(_strategy).WANT777() != _token) {
            // forward to vault and then call earnExtra() by its governance
            IERC20(_token).SAFETRANSFER627(address(vault), _amount);
        } else {
            IERC20(_token).SAFETRANSFER627(_strategy, _amount);
            IMultiVaultStrategy(_strategy).DEPOSIT294();
        }
    }

    function WITHDRAW_FEE118(address _want, uint _amount) external view returns (uint) {	//inject NONSTANDARD NAMING
        address _strategy = GETBESTSTRATEGY227(_want);
        return (_strategy == address(0)) ? 0 : IMultiVaultStrategy(_strategy).WITHDRAWFEE692(_amount);
    }

    function BALANCEOF771(address _want, bool _sell) external view returns (uint _totalBal) {	//inject NONSTANDARD NAMING
        uint _wlength = wantTokens.length;
        if (_wlength == 0) {
            return 0;
        }
        _totalBal = 0;
        for (uint i = 0; i < _wlength; i++) {
            address wt = wantTokens[i];
            uint _bal = WANTSTRATEGYBALANCE73(wt);
            if (wt != _want) {
                _bal = shareConverter.CONVERT_SHARES_RATE463(wt, _want, _bal);
                if (_sell) {
                    _bal = _bal.MUL872(9998).DIV551(10000); // minus 0.02% for selling
                }
            }
            _totalBal = _totalBal.ADD260(_bal);
        }
    }

    function WITHDRAWALL927(address _strategy) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        // WithdrawAll sends 'want' to 'vault'
        IMultiVaultStrategy(_strategy).WITHDRAWALL927();
    }

    function INCASETOKENSGETSTUCK116(address _token, uint _amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        IERC20(_token).SAFETRANSFER627(address(vault), _amount);
    }

    function INCASESTRATEGYGETSTUCK927(address _strategy, address _token) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        IMultiVaultStrategy(_strategy).WITHDRAW808(_token);
        IERC20(_token).SAFETRANSFER627(address(vault), IERC20(_token).BALANCEOF771(address(this)));
    }

    function CLAIMINSURANCE45() external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        vault.CLAIMINSURANCE45();
    }

    // note that some strategies do not allow controller to harvest
    function HARVESTSTRATEGY825(address _strategy) external {	//inject NONSTANDARD NAMING
        require(msg.sender == address(vault) || msg.sender == strategist || msg.sender == governance, "!strategist && !vault");
        IMultiVaultStrategy(_strategy).HARVEST506(address(0));
    }

    function HARVESTWANT168(address _want) external {	//inject NONSTANDARD NAMING
        require(msg.sender == address(vault) || msg.sender == strategist || msg.sender == governance, "!strategist && !vault");
        uint _wantStrategyLength = wantStrategyLength[_want];
        address _firstStrategy = address(0); // to send all harvested WETH and proceed the profit sharing all-in-one here
        for (uint _sid = 0; _sid < _wantStrategyLength; _sid++) {
            StrategyInfo storage sinfo = strategies[_want][_sid];
            if (_firstStrategy == address(0)) {
                _firstStrategy = sinfo.strategy;
            } else {
                IMultiVaultStrategy(sinfo.strategy).HARVEST506(_firstStrategy);
            }
        }
        if (_firstStrategy != address(0)) {
            IMultiVaultStrategy(_firstStrategy).HARVEST506(address(0));
        }
    }

    function HARVESTALLSTRATEGIES334() external {	//inject NONSTANDARD NAMING
        require(msg.sender == address(vault) || msg.sender == strategist || msg.sender == governance, "!strategist && !vault");
        uint _wlength = wantTokens.length;
        address _firstStrategy = address(0); // to send all harvested WETH and proceed the profit sharing all-in-one here
        for (uint i = 0; i < _wlength; i++) {
            address _want = wantTokens[i];
            uint _wantStrategyLength = wantStrategyLength[_want];
            for (uint _sid = 0; _sid < _wantStrategyLength; _sid++) {
                StrategyInfo storage sinfo = strategies[_want][_sid];
                if (_firstStrategy == address(0)) {
                    _firstStrategy = sinfo.strategy;
                } else {
                    IMultiVaultStrategy(sinfo.strategy).HARVEST506(_firstStrategy);
                }
            }
        }
        if (_firstStrategy != address(0)) {
            IMultiVaultStrategy(_firstStrategy).HARVEST506(address(0));
        }
    }

    function SWITCHFUND172(IMultiVaultStrategy _srcStrat, IMultiVaultStrategy _destStrat, uint _amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == strategist || msg.sender == governance, "!strategist");
        _srcStrat.WITHDRAWTOCONTROLLER653(_amount);
        address _srcWant = _srcStrat.WANT777();
        address _destWant = _destStrat.WANT777();
        if (_srcWant != _destWant) {
            _amount = IERC20(_srcWant).BALANCEOF771(address(this));
            require(shareConverter.CONVERT_SHARES_RATE463(_srcWant, _destWant, _amount) > 0, "rate=0");
            IERC20(_srcWant).SAFETRANSFER627(address(shareConverter), _amount);
            shareConverter.CONVERT_SHARES33(_srcWant, _destWant, _amount);
        }
        IERC20(_destWant).SAFETRANSFER627(address(_destStrat), IERC20(_destWant).BALANCEOF771(address(this)));
        _destStrat.DEPOSIT294();
    }

    function WITHDRAW808(address _want, uint _amount) external returns (uint _withdrawFee) {	//inject NONSTANDARD NAMING
        require(msg.sender == address(vault), "!vault");
        _withdrawFee = 0;
        uint _toWithdraw = _amount;
        uint _wantStrategyLength = wantStrategyLength[_want];
        uint _received;
        for (uint _sid = _wantStrategyLength; _sid > 0; _sid--) {
            StrategyInfo storage sinfo = strategies[_want][_sid - 1];
            IMultiVaultStrategy _strategy = IMultiVaultStrategy(sinfo.strategy);
            uint _stratBal = _strategy.BALANCEOF771();
            if (_toWithdraw < _stratBal) {
                _received = _strategy.WITHDRAW808(_toWithdraw);
                _withdrawFee = _withdrawFee.ADD260(_strategy.WITHDRAWFEE692(_received));
                return _withdrawFee;
            }
            _received = _strategy.WITHDRAWALL927();
            _withdrawFee = _withdrawFee.ADD260(_strategy.WITHDRAWFEE692(_received));
            if (_received >= _toWithdraw) {
                return _withdrawFee;
            }
            _toWithdraw = _toWithdraw.SUB684(_received);
        }
        if (_toWithdraw > 0) {
            // still not enough, try to withdraw from other wants strategies
            uint _wlength = wantTokens.length;
            for (uint i = _wlength; i > 0; i--) {
                address wt = wantTokens[i - 1];
                if (wt != _want) {
                    (uint _wamt, uint _wdfee) = _WITHDRAWOTHERWANT971(_want, wt, _toWithdraw);
                    _withdrawFee = _withdrawFee.ADD260(_wdfee);
                    if (_wamt >= _toWithdraw) {
                        return _withdrawFee;
                    }
                    _toWithdraw = _toWithdraw.SUB684(_wamt);
                }
            }
        }
        return _withdrawFee;
    }

    function _WITHDRAWOTHERWANT971(address _want, address _other, uint _amount) internal returns (uint _wantAmount, uint _withdrawFee) {	//inject NONSTANDARD NAMING
        // Check balance
        uint b = IERC20(_want).BALANCEOF771(address(this));
        _withdrawFee = 0;
        if (b >= _amount) {
            _wantAmount = b;
        } else {
            uint _toWithdraw = _amount.SUB684(b);
            uint _toWithdrawOther = _toWithdraw.MUL872(101).DIV551(100); // add 1% extra
            uint _otherBal = IERC20(_other).BALANCEOF771(address(this));
            if (_otherBal < _toWithdrawOther) {
                uint _otherStrategyLength = wantStrategyLength[_other];
                for (uint _sid = _otherStrategyLength; _sid > 0; _sid--) {
                    StrategyInfo storage sinfo = strategies[_other][_sid - 1];
                    IMultiVaultStrategy _strategy = IMultiVaultStrategy(sinfo.strategy);
                    uint _stratBal = _strategy.BALANCEOF771();
                    uint _needed = _toWithdrawOther.SUB684(_otherBal);
                    uint _wdamt = (_needed < _stratBal) ? _needed : _stratBal;
                    _strategy.WITHDRAWTOCONTROLLER653(_wdamt);
                    _withdrawFee = _withdrawFee.ADD260(_strategy.WITHDRAWFEE692(_wdamt));
                    _otherBal = IERC20(_other).BALANCEOF771(address(this));
                    if (_otherBal >= _toWithdrawOther) {
                        break;
                    }
                }
            }
            IERC20(_other).SAFETRANSFER627(address(shareConverter), _otherBal);
            shareConverter.CONVERT_SHARES33(_other, _want, _otherBal);
            _wantAmount = IERC20(_want).BALANCEOF771(address(this));
        }
        IERC20(_want).SAFETRANSFER627(address(vault), _wantAmount);
    }
}