                                                                 

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12;

                                                                      
 
interface IERC20 {
                                                                      
    function TOTALSUPPLY622() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF753(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER955(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE76(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE213(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM690(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER649(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL691(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER876(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN191(token, abi.encodeWithSelector(token.TRANSFER955.selector, to, value));
    }

    function SAFETRANSFERFROM621(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        _CALLOPTIONALRETURN191(token, abi.encodeWithSelector(token.TRANSFERFROM690.selector, from, to, value));
    }

                                                                                                                                                                                                                                                             
    function SAFEAPPROVE2(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE76(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _CALLOPTIONALRETURN191(token, abi.encodeWithSelector(token.APPROVE213.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE52(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE76(address(this), spender).ADD393(value);
        _CALLOPTIONALRETURN191(token, abi.encodeWithSelector(token.APPROVE213.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE172(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE76(address(this), spender).SUB829(value, "SafeERC20: decreased allowance below zero");
        _CALLOPTIONALRETURN191(token, abi.encodeWithSelector(token.APPROVE213.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function _CALLOPTIONALRETURN191(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).FUNCTIONCALL585(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

interface IWETH {
    function DEPOSIT379() external payable;	//inject NONSTANDARD NAMING
    function TRANSFER955(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function WITHDRAW91(uint) external;	//inject NONSTANDARD NAMING
}

interface IUniswapV2Router01 {
    function FACTORY423() external pure returns (address);	//inject NONSTANDARD NAMING
    function WETH656() external pure returns (address);	//inject NONSTANDARD NAMING

    function ADDLIQUIDITY566(	//inject NONSTANDARD NAMING
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function ADDLIQUIDITYETH439(	//inject NONSTANDARD NAMING
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function REMOVELIQUIDITY294(	//inject NONSTANDARD NAMING
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function REMOVELIQUIDITYETH142(	//inject NONSTANDARD NAMING
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function REMOVELIQUIDITYWITHPERMIT785(	//inject NONSTANDARD NAMING
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function REMOVELIQUIDITYETHWITHPERMIT822(	//inject NONSTANDARD NAMING
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function SWAPEXACTTOKENSFORTOKENS694(	//inject NONSTANDARD NAMING
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function SWAPTOKENSFOREXACTTOKENS112(	//inject NONSTANDARD NAMING
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function SWAPEXACTETHFORTOKENS23(uint amountOutMin, address[] calldata path, address to, uint deadline)	//inject NONSTANDARD NAMING
        external
        payable
        returns (uint[] memory amounts);
    function SWAPTOKENSFOREXACTETH134(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)	//inject NONSTANDARD NAMING
        external
        returns (uint[] memory amounts);
    function SWAPEXACTTOKENSFORETH465(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)	//inject NONSTANDARD NAMING
        external
        returns (uint[] memory amounts);
    function SWAPETHFOREXACTTOKENS477(uint amountOut, address[] calldata path, address to, uint deadline)	//inject NONSTANDARD NAMING
        external
        payable
        returns (uint[] memory amounts);

    function QUOTE151(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);	//inject NONSTANDARD NAMING
    function GETAMOUNTOUT667(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);	//inject NONSTANDARD NAMING
    function GETAMOUNTIN118(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);	//inject NONSTANDARD NAMING
    function GETAMOUNTSOUT962(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);	//inject NONSTANDARD NAMING
    function GETAMOUNTSIN769(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);	//inject NONSTANDARD NAMING
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function REMOVELIQUIDITYETHSUPPORTINGFEEONTRANSFERTOKENS84(	//inject NONSTANDARD NAMING
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function REMOVELIQUIDITYETHWITHPERMITSUPPORTINGFEEONTRANSFERTOKENS171(	//inject NONSTANDARD NAMING
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function SWAPEXACTTOKENSFORTOKENSSUPPORTINGFEEONTRANSFERTOKENS513(	//inject NONSTANDARD NAMING
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function SWAPEXACTETHFORTOKENSSUPPORTINGFEEONTRANSFERTOKENS617(	//inject NONSTANDARD NAMING
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function SWAPEXACTTOKENSFORETHSUPPORTINGFEEONTRANSFERTOKENS347(	//inject NONSTANDARD NAMING
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Pair {
    event APPROVAL691(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER649(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME590() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL603() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS715() external pure returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY622() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF753(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE76(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE213(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER955(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM690(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING

    function DOMAIN_SEPARATOR647() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function PERMIT_TYPEHASH618() external pure returns (bytes32);	//inject NONSTANDARD NAMING
    function NONCES61(address owner) external view returns (uint);	//inject NONSTANDARD NAMING

    function PERMIT398(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING

    event MINT816(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN577(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP591(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC313(uint112 reserve0, uint112 reserve1);	//inject NONSTANDARD NAMING

    function MINIMUM_LIQUIDITY897() external pure returns (uint);	//inject NONSTANDARD NAMING
    function FACTORY423() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN0588() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN1553() external view returns (address);	//inject NONSTANDARD NAMING
    function GETRESERVES947() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);	//inject NONSTANDARD NAMING
    function PRICE0CUMULATIVELAST382() external view returns (uint);	//inject NONSTANDARD NAMING
    function PRICE1CUMULATIVELAST280() external view returns (uint);	//inject NONSTANDARD NAMING
    function KLAST968() external view returns (uint);	//inject NONSTANDARD NAMING

    function MINT750(address to) external returns (uint liquidity);	//inject NONSTANDARD NAMING
    function BURN945(address to) external returns (uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    function SWAP412(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;	//inject NONSTANDARD NAMING
    function SKIM546(address to) external;	//inject NONSTANDARD NAMING
    function SYNC14() external;	//inject NONSTANDARD NAMING

    function INITIALIZE840(address, address) external;	//inject NONSTANDARD NAMING
}

interface IUniswapV2Factory {
    event PAIRCREATED444(address indexed token0, address indexed token1, address pair, uint);	//inject NONSTANDARD NAMING

    function FEETO98() external view returns (address);	//inject NONSTANDARD NAMING
    function FEETOSETTER656() external view returns (address);	//inject NONSTANDARD NAMING
    function MIGRATOR786() external view returns (address);	//inject NONSTANDARD NAMING

    function GETPAIR761(address tokenA, address tokenB) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRS341(uint) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRSLENGTH448() external view returns (uint);	//inject NONSTANDARD NAMING

    function CREATEPAIR119(address tokenA, address tokenB) external returns (address pair);	//inject NONSTANDARD NAMING

    function SETFEETO526(address) external;	//inject NONSTANDARD NAMING
    function SETFEETOSETTER51(address) external;	//inject NONSTANDARD NAMING
    function SETMIGRATOR114(address) external;	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _not_entered266 = 1;	//inject NONSTANDARD NAMING
    uint256 private constant _entered280 = 2;	//inject NONSTANDARD NAMING

    uint256 private _status;

    constructor () internal {
        _status = _not_entered266;
    }

                                                                                                                                                                                                                                                                                                                                                                                
    modifier NONREENTRANT384() {	//inject NONSTANDARD NAMING
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _entered280, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _entered280;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _not_entered266;
    }
}

                                                                         
library Math {
                                                               
    function MAX80(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a >= b ? a : b;
    }

                                                                
    function MIN629(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return a < b ? a : b;
    }

                                                                                                          
    function AVERAGE241(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT204(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE55(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL585(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL585(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL585(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE394(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE130(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE130(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE130(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE394(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE394(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT204(target), "Address: call to non-contract");

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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD393(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB829(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB829(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB829(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL131(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV283(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV283(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV283(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD208(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD208(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD208(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

library MathUtils {
    using SafeMath for uint256;

                                                            
    function SQRT196(uint256 x) internal pure returns (uint256 y) {	//inject NONSTANDARD NAMING
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

                                         
    function ROUNDEDDIV172(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, 'div by 0');

        uint256 halfB = (b.MOD208(2) == 0) ? (b.DIV283(2)) : (b.DIV283(2).ADD393(1));
        return (a.MOD208(b) >= halfB) ? (a.DIV283(b).ADD393(1)) : (a.DIV283(b));
    }
}

interface IUniswapV2ERC20 {
    event APPROVAL691(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER649(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME590() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL603() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS715() external pure returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY622() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF753(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE76(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE213(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER955(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM690(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING

    function DOMAIN_SEPARATOR647() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function PERMIT_TYPEHASH618() external pure returns (bytes32);	//inject NONSTANDARD NAMING
    function NONCES61(address owner) external view returns (uint);	//inject NONSTANDARD NAMING

    function PERMIT398(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING
}

interface IUniswapV2Callee {
    function UNISWAPV2CALL695(address sender, uint amount0, uint amount1, bytes calldata data) external;	//inject NONSTANDARD NAMING
}

interface IERC20Uniswap {
    event APPROVAL691(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER649(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME590() external view returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL603() external view returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS715() external view returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY622() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF753(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE76(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE213(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER955(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM690(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
abstract contract Context {
    function _MSGSENDER27() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA543() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

                                                                                                                                                                                                                                                                                                                           
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

                                                          
    function NAME590() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                          
    function SYMBOL603() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS715() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }

                                                     
    function TOTALSUPPLY622() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF753(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER955(address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER21(_MSGSENDER27(), recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE76(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE213(address spender, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE77(_MSGSENDER27(), spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM690(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER21(sender, recipient, amount);
        _APPROVE77(sender, _MSGSENDER27(), _allowances[sender][_MSGSENDER27()].SUB829(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE203(address spender, uint256 addedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE77(_MSGSENDER27(), spender, _allowances[_MSGSENDER27()][spender].ADD393(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE568(address spender, uint256 subtractedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE77(_MSGSENDER27(), spender, _allowances[_MSGSENDER27()][spender].SUB829(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER21(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _BEFORETOKENTRANSFER156(sender, recipient, amount);

        _balances[sender] = _balances[sender].SUB829(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD393(amount);
        emit TRANSFER649(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                                       
    function _MINT693(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _BEFORETOKENTRANSFER156(address(0), account, amount);

        _totalSupply = _totalSupply.ADD393(amount);
        _balances[account] = _balances[account].ADD393(amount);
        emit TRANSFER649(address(0), account, amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN313(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _BEFORETOKENTRANSFER156(account, address(0), amount);

        _balances[account] = _balances[account].SUB829(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB829(amount);
        emit TRANSFER649(account, address(0), amount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function _APPROVE77(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL691(owner, spender, amount);
    }

                                                                                                                                                                                                                                                                                                                            
    function _SETUPDECIMALS749(uint8 decimals_) internal {	//inject NONSTANDARD NAMING
        _decimals = decimals_;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function _BEFORETOKENTRANSFER156(address from, address to, uint256 amount) internal virtual { }	//inject NONSTANDARD NAMING
}

contract WETH9 {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    uint8  public decimals = 18;

    event  APPROVAL691(address indexed src, address indexed guy, uint wad);	//inject NONSTANDARD NAMING
    event  TRANSFER649(address indexed src, address indexed dst, uint wad);	//inject NONSTANDARD NAMING
    event  DEPOSIT981(address indexed dst, uint wad);	//inject NONSTANDARD NAMING
    event  WITHDRAWAL378(address indexed src, uint wad);	//inject NONSTANDARD NAMING

    mapping(address => uint)                       public  balanceOf;
    mapping(address => mapping(address => uint))  public  allowance;

    receive() external payable {
        DEPOSIT379();
    }

    function DEPOSIT379() public payable {	//inject NONSTANDARD NAMING
        balanceOf[msg.sender] += msg.value;
        DEPOSIT981(msg.sender, msg.value);
    }

    function WITHDRAW91(uint wad) public {	//inject NONSTANDARD NAMING
        require(balanceOf[msg.sender] >= wad);
        balanceOf[msg.sender] -= wad;
        msg.sender.transfer(wad);
        WITHDRAWAL378(msg.sender, wad);
    }

    function TOTALSUPPLY622() public view returns (uint) {	//inject NONSTANDARD NAMING
        return address(this).balance;
    }

    function APPROVE213(address guy, uint wad) public returns (bool) {	//inject NONSTANDARD NAMING
        allowance[msg.sender][guy] = wad;
        APPROVAL691(msg.sender, guy, wad);
        return true;
    }

    function TRANSFER955(address dst, uint wad) public returns (bool) {	//inject NONSTANDARD NAMING
        return TRANSFERFROM690(msg.sender, dst, wad);
    }

    function TRANSFERFROM690(address src, address dst, uint wad)	//inject NONSTANDARD NAMING
    public
    returns (bool)
    {
        require(balanceOf[src] >= wad);

        if (src != msg.sender && allowance[src][msg.sender] != uint(- 1)) {
            require(allowance[src][msg.sender] >= wad);
            allowance[src][msg.sender] -= wad;
        }

        balanceOf[src] -= wad;
        balanceOf[dst] += wad;

        TRANSFER649(src, dst, wad);

        return true;
    }
}

contract twis is ERC20 {

    address minter;

    modifier ONLYMINTER285 {	//inject NONSTANDARD NAMING
        require(msg.sender == minter, 'Only minter can call this function.');
        _;
    }

    constructor(address _minter) public ERC20('Twister', 'TWIS') {
        minter = _minter;
    }

    function MINT750(address account, uint256 amount) external ONLYMINTER285 {	//inject NONSTANDARD NAMING
        _MINT693(account, amount);
    }

    function BURN945(address account, uint256 amount) external ONLYMINTER285 {	//inject NONSTANDARD NAMING
        _BURN313(account, amount);
    }

}


contract Twister is ReentrancyGuard {

    using SafeMath for uint256;
    using Address for address;
    using SafeERC20 for IERC20;

    event STAKED534(address indexed from, uint256 amountETH, uint256 amountLP);	//inject NONSTANDARD NAMING
    event WITHDRAWN851(address indexed to, uint256 amountETH, uint256 amountLP);	//inject NONSTANDARD NAMING
    event CLAIMED515(address indexed to, uint256 amount);	//inject NONSTANDARD NAMING
    event HALVING833(uint256 amount);	//inject NONSTANDARD NAMING
    event RECEIVED501(address indexed from, uint256 amount);	//inject NONSTANDARD NAMING

    twis public token;
    IUniswapV2Factory public factory;
    IUniswapV2Router02 public router;
    address public weth;
    address payable public treasury;
    address public pairAddress;

    struct AccountInfo {
        // Staked LP token balance
        uint256 balance;
        uint256 peakBalance;
        uint256 withdrawTimestamp;
        uint256 reward;
        uint256 rewardPerTokenPaid;
    }
    mapping(address => AccountInfo) public accountInfos;

    // Staked LP token total supply
    uint256 private _totalSupply = 0;

    uint256 public constant halving_duration255 = 7 days;	//inject NONSTANDARD NAMING
    uint256 public rewardAllocation = 1500 * 1e18;
    uint256 public halvingTimestamp = 0;
    uint256 public lastUpdateTimestamp = 0;

    uint256 public rewardRate = 0;
    uint256 public rewardPerTokenStored = 0;

    // Farming will be open on this timestamp
    // Date and time (GMT): Monday, October 26, 2020 3:00:00 PM
    uint256 public farmingStartTimestamp = 1604635200;
    bool public farmingStarted = false;

    // Max 10% / day LP withdraw
    uint256 public constant withdraw_limit638 = 10;	//inject NONSTANDARD NAMING

    // Burn address
    address constant burn_address389 = 0x000000000000000000000000000000000000dEaD;	//inject NONSTANDARD NAMING

    // Dev decided to launch without whitelist but since it has been coded and tested, so dev will leave it here.
    // Whitelisted address
    mapping (address => bool) public whitelists;
    // Whitelist deposited balance
    mapping (address => uint256) public whitelistBalance;
    // End period for whitelist advantage
    uint256 public whitelistEndTimestamp = 0;
    // Max stake for whitelist
    uint256 public constant whitelist_stake_limit67 = 3 ether;	//inject NONSTANDARD NAMING
    // Whitelist advantage duration (reduced to 1 minutes since we dont have whitelist)
    uint256 public constant whitelist_duration869 = 1 minutes;	//inject NONSTANDARD NAMING

    constructor(address _routerAddress, address[] memory _whitelists) public {
        token = new twis(address(this));

        router = IUniswapV2Router02(_routerAddress);
        factory = IUniswapV2Factory(router.FACTORY423());
        weth = router.WETH656();
        treasury = msg.sender;
        pairAddress = factory.CREATEPAIR119(address(token), weth);

        // Calc reward rate
        rewardRate = rewardAllocation.DIV283(halving_duration255);

        // Init whitelist
        _SETUPWHITELISTS161(_whitelists);
        whitelistEndTimestamp = farmingStartTimestamp.ADD393(whitelist_duration869);
    }

    receive() external payable {
        emit RECEIVED501(msg.sender, msg.value);
    }

    function STAKE961() external payable NONREENTRANT384 {	//inject NONSTANDARD NAMING
        _CHECKFARMING62();
        _UPDATEREWARD485(msg.sender);
        _HALVING349();

        require(msg.value > 0, 'Cannot stake 0');
        require(!address(msg.sender).ISCONTRACT204(), 'Please use your individual account');

        // If we are still in whitelist duration
        if (whitelistEndTimestamp >= block.timestamp) {
            require(whitelists[msg.sender], 'Only whitelisted address can stake right now');
            whitelistBalance[msg.sender] = whitelistBalance[msg.sender].ADD393(msg.value);
            require(whitelistBalance[msg.sender] <= whitelist_stake_limit67, 'Cannot stake more than allowed in whitelist period');
        }

        // 10% compensation fee
        // since dev doesn't hold any initial supply
        uint256 fee = msg.value.DIV283(10);
        uint256 amount = msg.value.SUB829(fee);
        treasury.transfer(fee);

        uint256 ethAmount = IERC20(weth).BALANCEOF753(pairAddress);
        uint256 tokenAmount = IERC20(token).BALANCEOF753(pairAddress);

        // If eth amount = 0 then set initial price to 1 eth = 2 twis
        uint256 amountTokenDesired = ethAmount == 0 ? (amount * 2) : amount.MUL131(tokenAmount).DIV283(ethAmount);
        // Mint borrowed twis
        token.MINT750(address(this), amountTokenDesired);

        // Add liquidity in uniswap
        uint256 amountETHDesired = amount;
        IERC20(token).APPROVE213(address(router), amountTokenDesired);
        (,, uint256 liquidity) = router.ADDLIQUIDITYETH439{value : amountETHDesired}(address(token), amountTokenDesired, 1, 1, address(this), block.timestamp + 1 days);

        // Add LP token to total supply
        _totalSupply = _totalSupply.ADD393(liquidity);

        // Add to balance
        accountInfos[msg.sender].balance = accountInfos[msg.sender].balance.ADD393(liquidity);
        // Set peak balance
        if (accountInfos[msg.sender].balance > accountInfos[msg.sender].peakBalance) {
            accountInfos[msg.sender].peakBalance = accountInfos[msg.sender].balance;
        }

        // Set stake timestamp as withdraw timestamp
        // to prevent withdraw immediately after first staking
        if (accountInfos[msg.sender].withdrawTimestamp == 0) {
            accountInfos[msg.sender].withdrawTimestamp = block.timestamp;
        }

        emit STAKED534(msg.sender, msg.value, liquidity);
    }

    function WITHDRAW91() external NONREENTRANT384 {	//inject NONSTANDARD NAMING
        _CHECKFARMING62();
        _UPDATEREWARD485(msg.sender);
        _HALVING349();

        require(accountInfos[msg.sender].withdrawTimestamp + 1 days <= block.timestamp, 'You must wait 1 day since your last withdraw or stake');
        require(accountInfos[msg.sender].balance > 0, 'Cannot withdraw 0');

        // Limit withdraw LP token
        uint256 amount = accountInfos[msg.sender].peakBalance.DIV283(withdraw_limit638);
        if (accountInfos[msg.sender].balance < amount) {
            amount = accountInfos[msg.sender].balance;
        }

        // Reduce total supply
        _totalSupply = _totalSupply.SUB829(amount);
        // Reduce balance
        accountInfos[msg.sender].balance = accountInfos[msg.sender].balance.SUB829(amount);
        // Set timestamp
        accountInfos[msg.sender].withdrawTimestamp = block.timestamp;

        // Remove liquidity in uniswap
        IERC20(pairAddress).APPROVE213(address(router), amount);
        (uint256 tokenAmount, uint256 ethAmount) = router.REMOVELIQUIDITY294(address(token), weth, amount, 0, 0, address(this), block.timestamp + 1 days);

        // Burn borrowed twis
        token.BURN945(address(this), tokenAmount);
        // Withdraw ETH and send to sender
        IWETH(weth).WITHDRAW91(ethAmount);
        msg.sender.transfer(ethAmount);

        emit WITHDRAWN851(msg.sender, ethAmount, amount);
    }

    function CLAIM763() external NONREENTRANT384 {	//inject NONSTANDARD NAMING
        _CHECKFARMING62();
        _UPDATEREWARD485(msg.sender);
        _HALVING349();

        uint256 reward = accountInfos[msg.sender].reward;
        require(reward > 0, 'There is no reward to claim');

        if (reward > 0) {
            // Reduce first
            accountInfos[msg.sender].reward = 0;
            // Apply tax
            uint256 taxDenominator = CLAIMTAXDENOMINATOR467();
            uint256 tax = taxDenominator > 0 ? reward.DIV283(taxDenominator) : 0;
            uint256 net = reward.SUB829(tax);

            // Send reward
            token.MINT750(msg.sender, net);
            if (tax > 0) {
                // Burn taxed token
                token.MINT750(burn_address389, tax);
            }

            emit CLAIMED515(msg.sender, reward);
        }
    }

    function TOTALSUPPLY622() external view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

    function BALANCEOF753(address account) external view returns (uint256) {	//inject NONSTANDARD NAMING
        return accountInfos[account].balance;
    }

    function BURNEDTOKENAMOUNT890() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return token.BALANCEOF753(burn_address389);
    }

    function REWARDPERTOKEN638() public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }

        return rewardPerTokenStored
        .ADD393(
            LASTREWARDTIMESTAMP705()
            .SUB829(lastUpdateTimestamp)
            .MUL131(rewardRate)
            .MUL131(1e18)
            .DIV283(_totalSupply)
        );
    }

    function LASTREWARDTIMESTAMP705() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return Math.MIN629(block.timestamp, halvingTimestamp);
    }

    function REWARDEARNED380(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return accountInfos[account].balance.MUL131(
            REWARDPERTOKEN638().SUB829(accountInfos[account].rewardPerTokenPaid)
        )
        .DIV283(1e18)
        .ADD393(accountInfos[account].reward);
    }

    // Token price in eth
    function TOKENPRICE205() public view returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 ethAmount = IERC20(weth).BALANCEOF753(pairAddress);
        uint256 tokenAmount = IERC20(token).BALANCEOF753(pairAddress);
        return tokenAmount > 0 ?
        // Current price
        ethAmount.MUL131(1e18).DIV283(tokenAmount) :
        // Initial price
        (uint256(1e18).DIV283(2));
    }

    function CLAIMTAXDENOMINATOR467() public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (block.timestamp < farmingStartTimestamp + 1 days) {
            return 4;
        } else if (block.timestamp < farmingStartTimestamp + 2 days) {
            return 5;
        } else if (block.timestamp < farmingStartTimestamp + 3 days) {
            return 10;
        } else if (block.timestamp < farmingStartTimestamp + 4 days) {
            return 20;
        } else {
            return 0;
        }
    }

    function _UPDATEREWARD485(address account) internal {	//inject NONSTANDARD NAMING
        rewardPerTokenStored = REWARDPERTOKEN638();
        lastUpdateTimestamp = LASTREWARDTIMESTAMP705();
        if (account != address(0)) {
            accountInfos[account].reward = REWARDEARNED380(account);
            accountInfos[account].rewardPerTokenPaid = rewardPerTokenStored;
        }
    }

    // Do halving when timestamp reached
    function _HALVING349() internal {	//inject NONSTANDARD NAMING
        if (block.timestamp >= halvingTimestamp) {
            rewardAllocation = rewardAllocation.DIV283(2);

            rewardRate = rewardAllocation.DIV283(halving_duration255);
            halvingTimestamp = halvingTimestamp.ADD393(halving_duration255);

            _UPDATEREWARD485(msg.sender);
            emit HALVING833(rewardAllocation);
        }
    }

    // Check if farming is started
    function _CHECKFARMING62() internal {	//inject NONSTANDARD NAMING
        require(farmingStartTimestamp <= block.timestamp, 'Please wait until farming started');
        if (!farmingStarted) {
            farmingStarted = true;
            halvingTimestamp = block.timestamp.ADD393(halving_duration255);
            lastUpdateTimestamp = block.timestamp;
        }
    }

    function _SETUPWHITELISTS161(address[] memory addresses) internal {	//inject NONSTANDARD NAMING
        for (uint256 i = 0; i < addresses.length; i++) {
            whitelists[addresses[i]] = true;
        }
    }
}