/**
 *Submitted for verification at Etherscan.io on 2020-08-05
*/

pragma solidity ^0.5.17;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function decimals() external view returns (uint);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        //require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

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
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
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
    function rewards() external view returns (address);
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


contract Balancer {
    function getBalance(address token) external view returns (uint);

    function joinPool(uint poolAmountOut, uint[] calldata maxAmountsIn) external;
    function exitPool(uint poolAmountIn, uint[] calldata minAmountsOut) external;
    function swapExactAmountIn(
        address tokenIn,
        uint tokenAmountIn,
        address tokenOut,
        uint minAmountOut,
        uint maxPrice
    ) external returns (uint tokenAmountOut, uint spotPriceAfter);
    function swapExactAmountOut(
        address tokenIn,
        uint maxAmountIn,
        address tokenOut,
        uint tokenAmountOut,
        uint maxPrice
    ) external returns (uint tokenAmountIn, uint spotPriceAfter);
    function joinswapExternAmountIn(address tokenIn, uint tokenAmountIn, uint minPoolAmountOut) external returns (uint poolAmountOut);
    function exitswapPoolAmountIn(address tokenOut, uint poolAmountIn, uint minAmountOut) external returns (uint tokenAmountOut);
}


contract BConst {
    uint public constant BONE              = 10**18;

    uint public constant MIN_BOUND_TOKENS  = 2;
    uint public constant MAX_BOUND_TOKENS  = 8;

    uint public constant MIN_FEE           = BONE / 10**6;
    uint public constant MAX_FEE           = BONE / 10;
    uint public constant EXIT_FEE          = 0;

    uint public constant MIN_WEIGHT        = BONE;
    uint public constant MAX_WEIGHT        = BONE * 50;
    uint public constant MAX_TOTAL_WEIGHT  = BONE * 50;
    uint public constant MIN_BALANCE       = BONE / 10**12;

    uint public constant INIT_POOL_SUPPLY  = BONE * 100;

    uint public constant MIN_BPOW_BASE     = 1 wei;
    uint public constant MAX_BPOW_BASE     = (2 * BONE) - 1 wei;
    uint public constant BPOW_PRECISION    = BONE / 10**10;

    uint public constant MAX_IN_RATIO      = BONE / 2;
    uint public constant MAX_OUT_RATIO     = (BONE / 3) + 1 wei;
}

contract BNum is BConst {

    function bmul(uint a, uint b)
        internal pure
        returns (uint)
    {
        uint c0 = a * b;
        require(a == 0 || c0 / a == b, "ERR_MUL_OVERFLOW");
        uint c1 = c0 + (BONE / 2);
        require(c1 >= c0, "ERR_MUL_OVERFLOW");
        uint c2 = c1 / BONE;
        return c2;
    }

}


interface StrategyYfii {
    function harvest() external;
}

contract AntiStrategyYfii is BNum  {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;
    
    address constant public yfii = address(0xa1d0E215a23d7030842FC67cE582a6aFa3CCaB83);
    address constant public strategyYfiiAddr = address(0x2De055fec2b826ed4A7478CeDDBefF82C1EdFA70);
    address constant public balancerPool = address(0x16cAC1403377978644e78769Daa49d8f6B6CF565);
    address constant public dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);

    
    address public governance;
    
    constructor() public {
        governance = msg.sender;
    }
    
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }
    
    function deposit(uint256 amount) public {
        _totalSupply = _totalSupply.add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _balances[msg.sender] = _balances[msg.sender].add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        IERC20(yfii).safeTransferFrom(msg.sender, address(this), amount);
    }

    function withdraw(uint256 amount) public {
        _totalSupply = _totalSupply.sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _balances[msg.sender] = _balances[msg.sender].sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        IERC20(yfii).safeTransfer(msg.sender, amount);
    }
    
    
    // Governance can withdraw dust
    function withdrawDust() external returns (uint dust) {
        require(msg.sender == governance, "!governance");
        dust = IERC20(yfii).balanceOf(address(this)).sub(_totalSupply);
        if(dust > 0){
            IERC20(yfii).safeTransfer(governance, dust);
        }
        uint dai_balance = IERC20(dai).balanceOf(address(this));
        if(dai_balance > 0){
            IERC20(dai).safeTransfer(governance, IERC20(dai).balanceOf(address(this)));
        }
    }
    
    function earn() public {
        uint _beforeYFII = IERC20(yfii).balanceOf(address(this));
        
        uint tokenAmountIn = bmul(Balancer(balancerPool).getBalance(yfii), MAX_IN_RATIO);
        
        if(tokenAmountIn > _beforeYFII){
            tokenAmountIn = _beforeYFII;
        }
        
        IERC20(yfii).safeApprove(balancerPool, 0);
        IERC20(yfii).safeApprove(balancerPool, tokenAmountIn);
        Balancer(balancerPool).swapExactAmountIn(yfii, tokenAmountIn, dai, 0, uint(-1));
        StrategyYfii(strategyYfiiAddr).harvest();
        IERC20(dai).safeApprove(balancerPool, 0);
        IERC20(dai).safeApprove(balancerPool, IERC20(dai).balanceOf(address(this)));
        Balancer(balancerPool).swapExactAmountIn(dai, IERC20(dai).balanceOf(address(this)), yfii, _beforeYFII, uint(-1));
        uint _afterYFII = IERC20(yfii).balanceOf(address(this));
        require(_afterYFII >= _beforeYFII , "Need more yfii");
        
        // reset approve to zero
        IERC20(yfii).safeApprove(balancerPool, 0);
        IERC20(dai).safeApprove(balancerPool, 0);
    }

}