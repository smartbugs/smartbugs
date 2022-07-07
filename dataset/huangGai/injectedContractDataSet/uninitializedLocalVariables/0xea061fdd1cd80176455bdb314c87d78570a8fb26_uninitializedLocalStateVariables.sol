/**
 *Submitted for verification at Etherscan.io on 2020-07-26
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.16;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function decimals() external view returns (uint);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR


        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR


        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash ;	//inject UNINIT LOCAL/STATE VAR

        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

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
    function vaults(address) external view returns (address);
}

interface Balancer {
    function joinPool(uint,uint[] calldata) external;
    function exitPool(uint,uint[] calldata) external;
}

interface MStable {
    function mint(address, uint) external;
    function redeem(address, uint) external;
}

/*

 A strategy must implement the following calls;
 
 - deposit()
 - withdraw(address) must exclude any tokens used in the yield - Controller role - withdraw should return to Controller
 - withdraw(uint) - Controller | Vault role - withdraw should always return to vault
 - withdrawAll() - Controller | Vault role - withdraw should always return to vault
 - balanceOf()
 
 Where possible, strategies must remain as immutable as possible, instead of updating variables, we update the contract by linking it in the controller
 
*/

/*

 Strategy ~ 50% USDC to mUSD
 mUSD+USDC into balancer
 BAL+MTA

*/

contract StrategyBalancerMTA {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    
    address constant public want = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    address constant public mUSD = address(0xe2f2a5C287993345a840Db3B0845fbC70f5935a5);
    address constant public balancer = address(0x72Cd8f4504941Bf8c5a21d1Fd83A96499FD71d2C);
    
    
    address public governance;
    address public controller;
    bool public breaker ;	//inject UNINIT LOCAL/STATE VAR

    
    constructor(address _controller) public {
        governance = msg.sender;
        controller = _controller;
    }
    
    function setBreaker(bool _breaker) public {
        require(msg.sender == governance, "!governance");
        breaker = _breaker;
    }
    
    function deposit() external {
        require(breaker == false, "!breaker");
        uint _balance ;	//inject UNINIT LOCAL/STATE VAR

        uint _usdc ;	//inject UNINIT LOCAL/STATE VAR

        IERC20(want).safeApprove(mUSD, 0);
        IERC20(want).safeApprove(mUSD, _usdc);
        MStable(mUSD).mint(want,_usdc);
        
        uint _musd ;	//inject UNINIT LOCAL/STATE VAR

        
        uint _total ;	//inject UNINIT LOCAL/STATE VAR

        uint _balancerMUSD ;	//inject UNINIT LOCAL/STATE VAR

        uint _poolAmountMUSD ;	//inject UNINIT LOCAL/STATE VAR

        
        uint _balancerUSDC ;	//inject UNINIT LOCAL/STATE VAR

        uint _poolAmountUSDC ;	//inject UNINIT LOCAL/STATE VAR

        
        uint _poolAmountOut ;	//inject UNINIT LOCAL/STATE VAR

        if (_poolAmountUSDC < _poolAmountOut) {
            _poolAmountOut = _poolAmountUSDC;
        }
        
        IERC20(want).safeApprove(balancer, 0);
        IERC20(want).safeApprove(balancer, _usdc);
        IERC20(mUSD).safeApprove(balancer, 0);
        IERC20(mUSD).safeApprove(balancer, _musd);
        
        uint[] memory _maxAmountIn = new uint[](2);
        _maxAmountIn[0] = _musd;
        _maxAmountIn[1] = _musd;
        Balancer(balancer).joinPool(_poolAmountOut, _maxAmountIn);
    }
    
    // Controller only function for creating additional rewards from dust
    function withdraw(IERC20 _asset) external returns (uint balance) {
        require(msg.sender == controller, "!controller");
        require(address(_asset) != want, "!c");
        require(address(_asset) != mUSD, "!c");
        require(address(_asset) != balancer, "!c");
        balance = _asset.balanceOf(address(this));
        _asset.safeTransfer(controller, balance);
    }
    
    // Withdraw partial funds, normally used with a vault withdrawal
    function withdraw(uint _amount) external {
        require(msg.sender == controller, "!controller");
        uint _balance ;	//inject UNINIT LOCAL/STATE VAR

        if (_balance < _amount) {
            uint _withdrew ;	//inject UNINIT LOCAL/STATE VAR

            _amount = _withdrew.add(_balance);
        }
        
        address _vault ;	//inject UNINIT LOCAL/STATE VAR

        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20(want).safeTransfer(_vault, _amount);
        
    }
    
    function redeem() external {
        MStable(mUSD).redeem(want, normalize(IERC20(mUSD).balanceOf(address(this))));
    }
    
    // Withdraw all funds, normally used when migrating strategies
    function withdrawAll() external returns (uint balance) {
        require(msg.sender == controller, "!controller");
        _withdrawAll();
        balance = IERC20(want).balanceOf(address(this));
        
        address _vault ;	//inject UNINIT LOCAL/STATE VAR

        require(_vault != address(0), "!vault"); // additional protection so we don't burn the funds
        IERC20(want).safeTransfer(_vault, balance);
        
    }
    
    function _withdrawAll() internal {
        uint _bpt ;	//inject UNINIT LOCAL/STATE VAR

        uint[] memory _minAmountOut = new uint[](2);
        _minAmountOut[0] = 0;
        _minAmountOut[1] = 0;
        Balancer(balancer).exitPool(_bpt, _minAmountOut);
        uint _musd ;	//inject UNINIT LOCAL/STATE VAR

        MStable(mUSD).redeem(want, normalize(_musd));
    }
    
    function _withdrawSome(uint256 _amount) internal returns (uint) {
        uint _usdc ;	//inject UNINIT LOCAL/STATE VAR

        uint _bpt ;	//inject UNINIT LOCAL/STATE VAR

        uint _totalSupply ;	//inject UNINIT LOCAL/STATE VAR

        uint _redeem ;	//inject UNINIT LOCAL/STATE VAR

        if (_redeem > _bpt) {
            _redeem = _bpt;
        }
        uint[] memory _minAmountOut = new uint[](2);
        _minAmountOut[0] = 0;
        _minAmountOut[1] = 0;
        uint _before ;	//inject UNINIT LOCAL/STATE VAR

        uint _mBefore ;	//inject UNINIT LOCAL/STATE VAR

        Balancer(balancer).exitPool(_redeem, _minAmountOut);
        uint _mAfter ;	//inject UNINIT LOCAL/STATE VAR

        uint _musd ;	//inject UNINIT LOCAL/STATE VAR

        uint _after ;	//inject UNINIT LOCAL/STATE VAR

        uint _withdrew ;	//inject UNINIT LOCAL/STATE VAR

        _before = IERC20(want).balanceOf(address(this));
        MStable(mUSD).redeem(want, normalize(_musd));
        _after = IERC20(want).balanceOf(address(this));
        return _withdrew.add(_after.sub(_before));
    }
    
    function normalize(uint _amount) public view returns (uint) {
        return _amount.mul(10**IERC20(want).decimals()).div(10**IERC20(mUSD).decimals());
    }
    
    function balanceOf() public view returns (uint) {
        uint _bpt ;	//inject UNINIT LOCAL/STATE VAR

        uint _totalSupply ;	//inject UNINIT LOCAL/STATE VAR

        uint _musd ;	//inject UNINIT LOCAL/STATE VAR

        uint _usdc ;	//inject UNINIT LOCAL/STATE VAR

        _usdc = _usdc.mul(_bpt).div(_totalSupply);
        _musd = _musd.mul(_bpt).div(_totalSupply);
        return _usdc.add(normalize(_musd))
                    .add(IERC20(want).balanceOf(address(this)))
                    .add(normalize(IERC20(mUSD).balanceOf(address(this))));
    }
    
    
    function setGovernance(address _governance) external {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }
    
    function setController(address _controller) external {
        require(msg.sender == governance, "!governance");
        controller = _controller;
    }
}