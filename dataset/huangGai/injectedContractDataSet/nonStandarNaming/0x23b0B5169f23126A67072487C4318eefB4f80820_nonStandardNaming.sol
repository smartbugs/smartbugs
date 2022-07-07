                                                                 

pragma solidity ^0.6.2;


// SPDX-License-Identifier: MIT
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
abstract contract Context {
    function _MSGSENDER583() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA879() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// SPDX-License-Identifier: MIT
                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY430() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF616(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER244(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE387(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE425(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM381(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER617(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL460(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// SPDX-License-Identifier: MIT
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD135(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB321(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB321(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB321(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL733(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV136(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV136(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV136(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD593(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD593(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD593(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

// SPDX-License-Identifier: MIT
                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT469(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function SENDVALUE193(address payable recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function FUNCTIONCALL340(address target, bytes memory data) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
      return FUNCTIONCALL340(target, data, "Address: low-level call failed");
    }

                                                                                                                                                                                                                       
    function FUNCTIONCALL340(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return _FUNCTIONCALLWITHVALUE922(target, data, 0, errorMessage);
    }

                                                                                                                                                                                                                                                                                                                                                                   
    function FUNCTIONCALLWITHVALUE944(address target, bytes memory data, uint256 value) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        return FUNCTIONCALLWITHVALUE944(target, data, value, "Address: low-level call with value failed");
    }

                                                                                                                                                                                                                                                 
    function FUNCTIONCALLWITHVALUE944(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _FUNCTIONCALLWITHVALUE922(target, data, value, errorMessage);
    }

    function _FUNCTIONCALLWITHVALUE922(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {	//inject NONSTANDARD NAMING
        require(ISCONTRACT469(target), "Address: call to non-contract");

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

// SPDX-License-Identifier: MIT
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
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

                                                          
    function NAME100() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                          
    function SYMBOL131() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function DECIMALS904() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }

                                                     
    function TOTALSUPPLY430() public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF616(address account) public view override returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER244(address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER73(_MSGSENDER583(), recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE387(address owner, address spender) public view virtual override returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE425(address spender, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE319(_MSGSENDER583(), spender, amount);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM381(address sender, address recipient, uint256 amount) public virtual override returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER73(sender, recipient, amount);
        _APPROVE319(sender, _MSGSENDER583(), _allowances[sender][_MSGSENDER583()].SUB321(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE808(address spender, uint256 addedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE319(_MSGSENDER583(), spender, _allowances[_MSGSENDER583()][spender].ADD135(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE515(address spender, uint256 subtractedValue) public virtual returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE319(_MSGSENDER583(), spender, _allowances[_MSGSENDER583()][spender].SUB321(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER73(address sender, address recipient, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _BEFORETOKENTRANSFER129(sender, recipient, amount);

        _balances[sender] = _balances[sender].SUB321(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD135(amount);
        emit TRANSFER617(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                                       
    function _MINT517(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _BEFORETOKENTRANSFER129(address(0), account, amount);

        _totalSupply = _totalSupply.ADD135(amount);
        _balances[account] = _balances[account].ADD135(amount);
        emit TRANSFER617(address(0), account, amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN171(address account, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _BEFORETOKENTRANSFER129(account, address(0), amount);

        _balances[account] = _balances[account].SUB321(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB321(amount);
        emit TRANSFER617(account, address(0), amount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                
    function _APPROVE319(address owner, address spender, uint256 amount) internal virtual {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL460(owner, spender, amount);
    }

                                                                                                                                                                                                                                                                                                                            
    function _SETUPDECIMALS874(uint8 decimals_) internal {	//inject NONSTANDARD NAMING
        _decimals = decimals_;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function _BEFORETOKENTRANSFER129(address from, address to, uint256 amount) internal virtual { }	//inject NONSTANDARD NAMING
}

// SPDX-License-Identifier: MIT
                                                                             
abstract contract ERC20Capped is ERC20 {
    uint256 private _cap;

                                                                                                                                     
    constructor (uint256 cap) public {
        require(cap > 0, "ERC20Capped: cap is 0");
        _cap = cap;
    }

                                                                        
    function CAP360() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _cap;
    }

                                                                                                                                                                           
    function _BEFORETOKENTRANSFER129(address from, address to, uint256 amount) internal virtual override {	//inject NONSTANDARD NAMING
        super._BEFORETOKENTRANSFER129(from, to, amount);

        if (from == address(0)) { // When minting tokens
            require(TOTALSUPPLY430().ADD135(amount) <= _cap, "ERC20Capped: cap exceeded");
        }
    }
}

// SPDX-License-Identifier: MIT
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED797(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER583();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED797(address(0), msgSender);
    }

                                                                     
    function OWNER971() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER607() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER583(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP525() public virtual ONLYOWNER607 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED797(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP777(address newOwner) public virtual ONLYOWNER607 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED797(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Router01 {
    function FACTORY439() external pure returns (address);	//inject NONSTANDARD NAMING
    function WETH181() external pure returns (address);	//inject NONSTANDARD NAMING

    function ADDLIQUIDITY85(	//inject NONSTANDARD NAMING
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function ADDLIQUIDITYETH216(	//inject NONSTANDARD NAMING
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function REMOVELIQUIDITY344(	//inject NONSTANDARD NAMING
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function REMOVELIQUIDITYETH742(	//inject NONSTANDARD NAMING
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function REMOVELIQUIDITYWITHPERMIT491(	//inject NONSTANDARD NAMING
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function REMOVELIQUIDITYETHWITHPERMIT317(	//inject NONSTANDARD NAMING
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function SWAPEXACTTOKENSFORTOKENS917(	//inject NONSTANDARD NAMING
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function SWAPTOKENSFOREXACTTOKENS879(	//inject NONSTANDARD NAMING
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function SWAPEXACTETHFORTOKENS817(uint amountOutMin, address[] calldata path, address to, uint deadline)	//inject NONSTANDARD NAMING
        external
        payable
        returns (uint[] memory amounts);
    function SWAPTOKENSFOREXACTETH856(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)	//inject NONSTANDARD NAMING
        external
        returns (uint[] memory amounts);
    function SWAPEXACTTOKENSFORETH218(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)	//inject NONSTANDARD NAMING
        external
        returns (uint[] memory amounts);
    function SWAPETHFOREXACTTOKENS998(uint amountOut, address[] calldata path, address to, uint deadline)	//inject NONSTANDARD NAMING
        external
        payable
        returns (uint[] memory amounts);

    function QUOTE315(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);	//inject NONSTANDARD NAMING
    function GETAMOUNTOUT816(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);	//inject NONSTANDARD NAMING
    function GETAMOUNTIN684(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);	//inject NONSTANDARD NAMING
    function GETAMOUNTSOUT241(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);	//inject NONSTANDARD NAMING
    function GETAMOUNTSIN775(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);	//inject NONSTANDARD NAMING
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function REMOVELIQUIDITYETHSUPPORTINGFEEONTRANSFERTOKENS846(	//inject NONSTANDARD NAMING
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function REMOVELIQUIDITYETHWITHPERMITSUPPORTINGFEEONTRANSFERTOKENS1(	//inject NONSTANDARD NAMING
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function SWAPEXACTTOKENSFORTOKENSSUPPORTINGFEEONTRANSFERTOKENS219(	//inject NONSTANDARD NAMING
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function SWAPEXACTETHFORTOKENSSUPPORTINGFEEONTRANSFERTOKENS501(	//inject NONSTANDARD NAMING
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function SWAPEXACTTOKENSFORETHSUPPORTINGFEEONTRANSFERTOKENS54(	//inject NONSTANDARD NAMING
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Pair {
    event APPROVAL460(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER617(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME100() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL131() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS904() external pure returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY430() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF616(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE387(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE425(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER244(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM381(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING

    function DOMAIN_SEPARATOR749() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function PERMIT_TYPEHASH945() external pure returns (bytes32);	//inject NONSTANDARD NAMING
    function NONCES546(address owner) external view returns (uint);	//inject NONSTANDARD NAMING

    function PERMIT654(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING

    event MINT786(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN405(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP722(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC303(uint112 reserve0, uint112 reserve1);	//inject NONSTANDARD NAMING

    function MINIMUM_LIQUIDITY735() external pure returns (uint);	//inject NONSTANDARD NAMING
    function FACTORY439() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN0934() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN1318() external view returns (address);	//inject NONSTANDARD NAMING
    function GETRESERVES691() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);	//inject NONSTANDARD NAMING
    function PRICE0CUMULATIVELAST150() external view returns (uint);	//inject NONSTANDARD NAMING
    function PRICE1CUMULATIVELAST277() external view returns (uint);	//inject NONSTANDARD NAMING
    function KLAST634() external view returns (uint);	//inject NONSTANDARD NAMING

    function MINT615(address to) external returns (uint liquidity);	//inject NONSTANDARD NAMING
    function BURN664(address to) external returns (uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    function SWAP816(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;	//inject NONSTANDARD NAMING
    function SKIM21(address to) external;	//inject NONSTANDARD NAMING
    function SYNC269() external;	//inject NONSTANDARD NAMING

    function INITIALIZE267(address, address) external;	//inject NONSTANDARD NAMING
}

interface IUniswapV2Factory {
    event PAIRCREATED762(address indexed token0, address indexed token1, address pair, uint);	//inject NONSTANDARD NAMING

    function FEETO789() external view returns (address);	//inject NONSTANDARD NAMING
    function FEETOSETTER578() external view returns (address);	//inject NONSTANDARD NAMING

    function GETPAIR592(address tokenA, address tokenB) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRS410(uint) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRSLENGTH90() external view returns (uint);	//inject NONSTANDARD NAMING

    function CREATEPAIR614(address tokenA, address tokenB) external returns (address pair);	//inject NONSTANDARD NAMING

    function SETFEETO894(address) external;	//inject NONSTANDARD NAMING
    function SETFEETOSETTER1(address) external;	//inject NONSTANDARD NAMING
}

interface IWETH {
    function DEPOSIT145() external payable;	//inject NONSTANDARD NAMING
    function TRANSFER244(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function WITHDRAW78(uint) external;	//inject NONSTANDARD NAMING
}

contract CGLB is ERC20Capped, Ownable {

    using SafeMath for uint;

    address public UNIPAIR;
    address public DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    IUniswapV2Router02 public UNIROUTER = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    IUniswapV2Factory public UNIFACTORY = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);

    bool public isRunning = false;
    bool private liquidityFlag;
    uint public constant supplycap690 = (10**4)*(10**18);	//inject NONSTANDARD NAMING
    uint public constant tokensforinitialliquidity143 = 3*(10**3)*(10**18);	//inject NONSTANDARD NAMING

    bytes32 public airdropRoot;
    mapping (address => bool) public claimedAirdrop;

    string public website = "www.cglb.fi";

    constructor() public ERC20Capped(supplycap690) ERC20("Cant go lower boys", "CGLB") {
        airdropRoot = 0x185065ab3d54b516ee3ed54dc30e04758300a4b41e207cf3ba91715f378d7728;
    }

                                                                      
    function TRANSFER244(address recipient, uint256 amount)	//inject NONSTANDARD NAMING
    public override
    returns (bool) {
        require(msg.sender == UNIPAIR || msg.sender == address(UNIROUTER));
        super.TRANSFER244(recipient, amount);
        return true;
    }

    function TRANSFERFROM381(address sender, address recipient, uint256 amount)	//inject NONSTANDARD NAMING
    public override
    returns (bool) {
        require(liquidityFlag);
        _TRANSFER73(sender, recipient, amount);
        return true;
    }

    function ADDLIQUIDITYTOUNISWAPPAIR951(	//inject NONSTANDARD NAMING
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountDAIDesired,
        uint256 amountDAImin
        ) public payable {
        require(isRunning);
        require(IERC20(DAI).TRANSFERFROM381(msg.sender, address(this), amountDAIDesired));
        require(IERC20(DAI).APPROVE425(address(UNIROUTER), amountDAIDesired));
        _TRANSFER73(msg.sender, address(this), amountTokenDesired);
        liquidityFlag = true;
        (uint amountToken, uint amountDAI, uint liquidity) = UNIROUTER.ADDLIQUIDITY85(
            address(this),
            DAI,
            amountTokenDesired,
            amountDAIDesired,
            amountTokenMin,
            amountDAImin,
            msg.sender,
            now + 10 minutes
        );
        liquidityFlag = false;
        //sends dust back
        if (amountTokenDesired - amountToken > 0 ) _TRANSFER73(address(this), msg.sender, amountTokenDesired-amountToken);
        if (amountDAIDesired - amountDAI > 0) require(IERC20(DAI).TRANSFER244(msg.sender, amountDAIDesired - amountDAI));
     }

     function ADDINITIALLIQUIDITYWITHPAIR729() public ONLYOWNER607 {	//inject NONSTANDARD NAMING
         CREATEUNISWAPPAIR64();
         uint256 amountDAI = IERC20(DAI).BALANCEOF616(address(this));
         require(IERC20(DAI).TRANSFER244(UNIPAIR, amountDAI));
         _MINT517(UNIPAIR, tokensforinitialliquidity143);
         IUniswapV2Pair(UNIPAIR).MINT615(msg.sender);
         isRunning = true;
     }

     function ADDINITIALLIQUIDITY209() public ONLYOWNER607 {	//inject NONSTANDARD NAMING
         uint256 amountDAI = IERC20(DAI).BALANCEOF616(address(this));
         require(IERC20(DAI).TRANSFER244(UNIPAIR, amountDAI));
         _MINT517(UNIPAIR, tokensforinitialliquidity143);
         IUniswapV2Pair(UNIPAIR).MINT615(msg.sender);
         isRunning = true;
     }

    function SETAIRDROPROOT894(bytes32 _root) public ONLYOWNER607 {	//inject NONSTANDARD NAMING
        airdropRoot = _root;
    }

    function SETPAIR246(address _pair) public ONLYOWNER607 {	//inject NONSTANDARD NAMING
        UNIPAIR = _pair;
    }

     function CREATEUNISWAPPAIR64() internal {	//inject NONSTANDARD NAMING
         require(UNIPAIR == address(0), "Token: pool already created");
         UNIPAIR = UNIFACTORY.CREATEPAIR614(
             DAI,
             address(this)
         );
     }

     function CHECKPROOF499(bytes memory proof, bytes32 root, bytes32 hash) internal view returns (bool) {	//inject NONSTANDARD NAMING
       bytes32 el;
       bytes32 h = hash;

       for (uint256 i = 32; i <= proof.length; i += 32) {
           assembly {
               el := mload(add(proof, i))
           }

           if (h < el) {
               h = keccak256(abi.encodePacked(h, el));
           } else {
               h = keccak256(abi.encodePacked(el, h));
           }
       }

       return h == root;
     }

     function CLAIMAIRDROP701(bytes memory proof, uint amount) public {	//inject NONSTANDARD NAMING
         require(!claimedAirdrop[msg.sender]);
         bytes32 hash = keccak256(abi.encodePacked(msg.sender, amount));
         require(CHECKPROOF499(proof, airdropRoot, hash), "Invalid proof");
         claimedAirdrop[msg.sender] = true;
         _MINT517(msg.sender, amount);
     }

     function WITHDRAWERC20742(address token) ONLYOWNER607 public {	//inject NONSTANDARD NAMING
         uint balance = IERC20(token).BALANCEOF616(address(this));
         require(IERC20(token).TRANSFER244(msg.sender, balance));
     }
}