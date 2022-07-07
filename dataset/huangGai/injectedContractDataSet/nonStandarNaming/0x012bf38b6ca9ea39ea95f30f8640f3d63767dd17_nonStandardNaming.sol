                                                                 

pragma solidity ^0.5.16;

interface IERC20 {
    function TOTALSUPPLY344() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF995(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER795(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE796(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function APPROVE408(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM856(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
    function DECIMALS615() external view returns (uint);	//inject NONSTANDARD NAMING
    event TRANSFER370(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL858(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
    function ADD697(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB109(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB109(a, b, "SafeMath: subtraction overflow");
    }
    function SUB109(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function MUL960(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV581(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV581(a, b, "SafeMath: division by zero");
    }
    function DIV581(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    function MOD970(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD970(a, b, "SafeMath: modulo by zero");
    }
    function MOD970(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function ISCONTRACT908(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function TOPAYABLE655(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }
    function SENDVALUE370(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER212(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN170(token, abi.encodeWithSelector(token.TRANSFER795.selector, to, value));
    }

    function SAFETRANSFERFROM22(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN170(token, abi.encodeWithSelector(token.TRANSFERFROM856.selector, from, to, value));
    }

    function SAFEAPPROVE493(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require((value == 0) || (token.ALLOWANCE796(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN170(token, abi.encodeWithSelector(token.APPROVE408.selector, spender, value));
    }
    function CALLOPTIONALRETURN170(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        require(address(token).ISCONTRACT908(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


interface Controller {
    function VAULTS291(address) external view returns (address);	//inject NONSTANDARD NAMING
}

interface Balancer {
    function JOINPOOL849(uint,uint[] calldata) external;	//inject NONSTANDARD NAMING
    function EXITPOOL804(uint,uint[] calldata) external;	//inject NONSTANDARD NAMING
}

interface MStable {
    function MINT666(address, uint) external;	//inject NONSTANDARD NAMING
    function REDEEM500(address, uint) external;	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 

                                                                      

contract StrategyBalancerMTA {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    
    address constant public want295 = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);	//inject NONSTANDARD NAMING
    address constant public musd674 = address(0xe2f2a5C287993345a840Db3B0845fbC70f5935a5);	//inject NONSTANDARD NAMING
    address constant public balancer837 = address(0x72Cd8f4504941Bf8c5a21d1Fd83A96499FD71d2C);	//inject NONSTANDARD NAMING
    
    
    address public governance;
    address public controller;
    bool public breaker = false;
    // Supply tracks the number of `want` that we have lent out of other distro's
    uint public supply = 0;
    
    constructor(address _controller) public {
        governance = msg.sender;
        controller = _controller;
    }
    
    function SETBREAKER384(bool _breaker) public {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        breaker = _breaker;
    }
    
    function DEPOSIT98() external {	//inject NONSTANDARD NAMING
        require(breaker == false, "!breaker");
        uint _balance = IERC20(want295).BALANCEOF995(address(this));
        uint _want = _balance.DIV581(2);
        IERC20(want295).SAFEAPPROVE493(musd674, 0);
        IERC20(want295).SAFEAPPROVE493(musd674, _want);
        
        uint _before = _balance;
        MStable(musd674).MINT666(want295, _want);
        uint _after = IERC20(want295).BALANCEOF995(address(this));
        supply = supply.ADD697(_before.SUB109(_after));
        
        uint _musd = IERC20(musd674).BALANCEOF995(address(this));
        
        uint _total = IERC20(balancer837).TOTALSUPPLY344();
        uint _balancerMUSD = IERC20(musd674).BALANCEOF995(balancer837);
        uint _poolAmountMUSD = _musd.MUL960(_total).DIV581(_balancerMUSD);
        
        uint _balancerUSDC = IERC20(want295).BALANCEOF995(balancer837);
        uint _poolAmountUSDC = _want.MUL960(_total).DIV581(_balancerUSDC);
        
        uint _poolAmountOut = _poolAmountMUSD;
        if (_poolAmountUSDC < _poolAmountOut) {
            _poolAmountOut = _poolAmountUSDC;
        }
        
        IERC20(want295).SAFEAPPROVE493(balancer837, 0);
        IERC20(want295).SAFEAPPROVE493(balancer837, _want);
        IERC20(musd674).SAFEAPPROVE493(balancer837, 0);
        IERC20(musd674).SAFEAPPROVE493(balancer837, _musd);
        
        uint[] memory _maxAmountIn = new uint[](2);
        _maxAmountIn[0] = _musd;
        _maxAmountIn[1] = _want;
        _before = IERC20(want295).BALANCEOF995(address(this));
        Balancer(balancer837).JOINPOOL849(_poolAmountOut, _maxAmountIn);
        _after = IERC20(want295).BALANCEOF995(address(this));
        supply = supply.ADD697(_before.SUB109(_after));
    }
    
    // Controller only function for creating additional rewards from dust
    function WITHDRAW505(IERC20 _asset) external returns (uint balance) {	//inject NONSTANDARD NAMING
        require(msg.sender == controller, "!controller");
        require(address(_asset) != want295, "!c");
        require(address(_asset) != musd674, "!c");
        require(address(_asset) != balancer837, "!c");
        balance = _asset.BALANCEOF995(address(this));
        _asset.SAFETRANSFER212(controller, balance);
    }
    
    function WITHDRAWM660(uint _amount) internal returns (uint) {	//inject NONSTANDARD NAMING
        if (_amount > supply) {
            // Pool made too much profit, so we reset to 0 to avoid revert
            supply = 0;
        } else {
            supply = supply.SUB109(_amount);
        }
        
        uint _before = IERC20(want295).BALANCEOF995(address(this));
        MStable(musd674).REDEEM500(want295, _amount);
        uint _after  = IERC20(want295).BALANCEOF995(address(this));
        return _after.SUB109(_before);
    }
    
    function WITHDRAWBPT914(uint _amount) internal returns (uint) {	//inject NONSTANDARD NAMING
        uint _calc = CALCULATERATIO430(_amount);
        _amount = _amount.SUB109(_amount.MUL960(10).DIV581(10000));
        return _WITHDRAWSOME884(_calc, _amount);
    }
    
    // Withdraw partial funds, normally used with a vault withdrawal
    function WITHDRAW505(uint _amount) external {	//inject NONSTANDARD NAMING
        require(msg.sender == controller, "!controller");
        uint _balance = IERC20(want295).BALANCEOF995(address(this));
        if (_balance < _amount) {
            uint _musd = NORMALIZE117(IERC20(musd674).BALANCEOF995(address(this)));
            uint _remainder = _amount.SUB109(_balance);
            if (_musd > 0) {
                if (_musd > _remainder) {
                    _amount = WITHDRAWM660(_remainder);
                    _amount = _amount.ADD697(_balance);
                } else {
                    _remainder = _remainder.SUB109(_musd);
                    uint _withdrew = WITHDRAWM660(_musd);
                    _amount = _withdrew.ADD697(_balance);
                    _withdrew = WITHDRAWBPT914(_remainder);
                    _amount = _amount.ADD697(_withdrew);
                }
            } else {
                _amount = WITHDRAWBPT914(_remainder);
                _amount = _amount.ADD697(_balance);
            }
            
        }
        
                                                                                                                                                                                                                                            
        
        IERC20(want295).SAFETRANSFER212(controller, _amount);
        
    }
    
    function REDEEM500() external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        uint _balance = NORMALIZE117(IERC20(musd674).BALANCEOF995(address(this)));
        if (_balance > supply) {
            // Pool made too much profit, so we reset to 0 to avoid revert
            supply = 0;
        } else {
            supply = supply.SUB109(_balance);
        }
        
        MStable(musd674).REDEEM500(want295, _balance);
    }
    
    // Withdraw all funds, normally used when migrating strategies
    function WITHDRAWALL744() external returns (uint balance) {	//inject NONSTANDARD NAMING
        require(msg.sender == controller, "!controller");
        _WITHDRAWALL952();
        balance = IERC20(want295).BALANCEOF995(address(this));
        
                                                                                                                                                                                                                                            
        
        IERC20(want295).SAFETRANSFER212(controller, balance);
        
    }
    
    function _WITHDRAWALL952() internal {	//inject NONSTANDARD NAMING
        uint _bpt = IERC20(balancer837).BALANCEOF995(address(this));
        uint[] memory _minAmountOut = new uint[](2);
        _minAmountOut[0] = 0;
        _minAmountOut[1] = 0;
        uint _before = IERC20(want295).BALANCEOF995(address(this));
        Balancer(balancer837).EXITPOOL804(_bpt, _minAmountOut);
        uint _after = IERC20(want295).BALANCEOF995(address(this));
        uint _diff = _after.SUB109(_before);
        if (_diff > supply) {
            // Pool made too much profit, so we reset to 0 to avoid revert
            supply = 0;
        } else {
            supply = supply.SUB109(_after.SUB109(_before));
        }
        uint _musd = IERC20(musd674).BALANCEOF995(address(this));
        
        // This one is the exception because it assumes we can redeem 1 USDC
        _diff = NORMALIZE117(_musd);
        if (_diff > supply) {
            // Pool made too much profit, so we reset to 0 to avoid revert
            supply = 0;
        } else {
            supply = supply.SUB109(_diff);
        }
        MStable(musd674).REDEEM500(want295, _diff);
    }
    
    function CALCULATERATIO430(uint _amount) public view returns (uint) {	//inject NONSTANDARD NAMING
        uint _musd = NORMALIZE117(IERC20(musd674).BALANCEOF995(balancer837));
        uint _want = IERC20(want295).BALANCEOF995(balancer837);
        uint _total = _musd.ADD697(_want);
        uint _ratio = _amount.MUL960(_want).DIV581(_total);
        return _ratio;
    }
    
    function _WITHDRAWSOME884(uint256 _amount, uint _max) internal returns (uint) {	//inject NONSTANDARD NAMING
        uint _redeem = IERC20(balancer837).TOTALSUPPLY344().MUL960(_amount).DIV581(IERC20(want295).BALANCEOF995(balancer837));
        if (_redeem > IERC20(balancer837).BALANCEOF995(address(this))) {
            _redeem = IERC20(balancer837).BALANCEOF995(address(this));
        }
        uint[] memory _minAmountOut = new uint[](2);
        _minAmountOut[0] = 0;
        _minAmountOut[1] = 0;
        
        uint _before = IERC20(want295).BALANCEOF995(address(this));
        uint _mBefore = IERC20(musd674).BALANCEOF995(address(this));
        Balancer(balancer837).EXITPOOL804(_redeem, _minAmountOut);
        uint _mAfter = IERC20(musd674).BALANCEOF995(address(this));
        uint _after = IERC20(want295).BALANCEOF995(address(this));
        
        uint _musd = _mAfter.SUB109(_mBefore);
        uint _withdrew = _after.SUB109(_before);
        
        if (_withdrew > supply) {
            // Pool made too much profit, so we reset to 0 to avoid revert
            supply = 0;
        } else {
            supply = supply.SUB109(_withdrew);
        }
        _musd = NORMALIZE117(_musd);
        if (_musd > supply) {
            // Pool made too much profit, so we reset to 0 to avoid revert
            supply = 0;
        } else {
            supply = supply.SUB109(_musd);
        }
        _before = IERC20(want295).BALANCEOF995(address(this));
        MStable(musd674).REDEEM500(want295, _musd);
        _after = IERC20(want295).BALANCEOF995(address(this));
        _withdrew = _withdrew.ADD697(_after.SUB109(_before));
        // Apply the fee as a difference
        _withdrew = _withdrew.SUB109(_musd.SUB109(_after.SUB109(_before)));
        if (_withdrew > _max) {
            _withdrew = _max;
        }
        return _withdrew;
    }
    
    function NORMALIZE117(uint _amount) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _amount.MUL960(10**IERC20(want295).DECIMALS615()).DIV581(10**IERC20(musd674).DECIMALS615());
    }
    
    function BALANCEOF995() public view returns (uint) {	//inject NONSTANDARD NAMING
        return IERC20(want295).BALANCEOF995(address(this))
                .ADD697(supply);
    }
    
    
    function SETGOVERNANCE741(address _governance) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }
    
    function SETCONTROLLER847(address _controller) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "!governance");
        controller = _controller;
    }
}