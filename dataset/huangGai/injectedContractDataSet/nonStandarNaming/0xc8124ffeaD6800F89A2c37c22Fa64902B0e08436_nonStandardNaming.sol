                                                                 

// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;


// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
abstract contract Context {
    function _MSGSENDER742() internal view virtual returns (address payable) {	//inject NONSTANDARD NAMING
        return msg.sender;
    }

    function _MSGDATA476() internal view virtual returns (bytes memory) {	//inject NONSTANDARD NAMING
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
contract Ownable is Context {
    address private _owner;

    event OWNERSHIPTRANSFERRED603(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        address msgSender = _MSGSENDER742();
        _owner = msgSender;
        emit OWNERSHIPTRANSFERRED603(address(0), msgSender);
    }

                                                                     
    function OWNER943() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER460() {	//inject NONSTANDARD NAMING
        require(_owner == _MSGSENDER742(), "Ownable: caller is not the owner");
        _;
    }

                                                                                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP291() public virtual ONLYOWNER460 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED603(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP407(address newOwner) public virtual ONLYOWNER460 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED603(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract PriceProvider is Ownable {

    address public manager;

    string public providerName;

    uint8 public constant decimals686 = 2; // decimals of ethereum price	//inject NONSTANDARD NAMING
    bool public updateRequred;

                                                                                                                                       

    constructor(string memory _providerName, address _manager, bool _updateRequred) public Ownable() {
        providerName = _providerName;
        manager = _manager;
        updateRequred = _updateRequred;
    }

                                                                                               

    function SETMANAGER980(address _manager) external ONLYOWNER460 {	//inject NONSTANDARD NAMING
        manager = _manager;
    }

                                                   

    function LASTPRICE690() public virtual view returns (uint32);	//inject NONSTANDARD NAMING
}

// 
                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY861() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF276(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER827(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE661(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function APPROVE898(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM273(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER185(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL8(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                           
abstract contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

                                                                                                                                                                                       
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

                                                          
    function NAME190() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                          
    function SYMBOL403() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function DECIMALS571() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

// a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
library FixedPoint {
    // range: [0, 2**112 - 1]
    // resolution: 1 / 2**112
    struct uq112x112 {
        uint224 _x;
    }

    // range: [0, 2**144 - 1]
    // resolution: 1 / 2**112
    struct uq144x112 {
        uint _x;
    }

    uint8 private constant resolution887 = 112;	//inject NONSTANDARD NAMING

    // encode a uint112 as a UQ112x112
    function ENCODE375(uint112 x) internal pure returns (uq112x112 memory) {	//inject NONSTANDARD NAMING
        return uq112x112(uint224(x) << resolution887);
    }

    // encodes a uint144 as a UQ144x112
    function ENCODE144305(uint144 x) internal pure returns (uq144x112 memory) {	//inject NONSTANDARD NAMING
        return uq144x112(uint256(x) << resolution887);
    }

    // divide a UQ112x112 by a uint112, returning a UQ112x112
    function DIV530(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {	//inject NONSTANDARD NAMING
        require(x != 0, 'FixedPoint: DIV_BY_ZERO');
        return uq112x112(self._x / uint224(x));
    }

    // multiply a UQ112x112 by a uint, returning a UQ144x112
    // reverts on overflow
    function MUL252(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {	//inject NONSTANDARD NAMING
        uint z;
        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
        return uq144x112(z);
    }

    // returns a UQ112x112 which represents the ratio of the numerator to the denominator
    // equivalent to encode(numerator).div(denominator)
    function FRACTION125(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {	//inject NONSTANDARD NAMING
        require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
        return uq112x112((uint224(numerator) << resolution887) / denominator);
    }

    // decode a UQ112x112 into a uint112 by truncating after the radix point
    function DECODE122(uq112x112 memory self) internal pure returns (uint112) {	//inject NONSTANDARD NAMING
        return uint112(self._x >> resolution887);
    }

    // decode a UQ144x112 into a uint144 by truncating after the radix point
    function DECODE144956(uq144x112 memory self) internal pure returns (uint144) {	//inject NONSTANDARD NAMING
        return uint144(self._x >> resolution887);
    }
}

interface IUniswapV2Pair {
    event APPROVAL8(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER185(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME190() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL403() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS571() external pure returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY861() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF276(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE661(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE898(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER827(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM273(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING

    function DOMAIN_SEPARATOR374() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function PERMIT_TYPEHASH748() external pure returns (bytes32);	//inject NONSTANDARD NAMING
    function NONCES344(address owner) external view returns (uint);	//inject NONSTANDARD NAMING

    function PERMIT537(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING

    event MINT421(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN632(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP642(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC872(uint112 reserve0, uint112 reserve1);	//inject NONSTANDARD NAMING

    function MINIMUM_LIQUIDITY496() external pure returns (uint);	//inject NONSTANDARD NAMING
    function FACTORY810() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN0628() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN1909() external view returns (address);	//inject NONSTANDARD NAMING
    function GETRESERVES186() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);	//inject NONSTANDARD NAMING
    function PRICE0CUMULATIVELAST525() external view returns (uint);	//inject NONSTANDARD NAMING
    function PRICE1CUMULATIVELAST405() external view returns (uint);	//inject NONSTANDARD NAMING
    function KLAST975() external view returns (uint);	//inject NONSTANDARD NAMING

    function MINT537(address to) external returns (uint liquidity);	//inject NONSTANDARD NAMING
    function BURN439(address to) external returns (uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    function SWAP853(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;	//inject NONSTANDARD NAMING
    function SKIM750(address to) external;	//inject NONSTANDARD NAMING
    function SYNC911() external;	//inject NONSTANDARD NAMING

    function INITIALIZE196(address, address) external;	//inject NONSTANDARD NAMING
}

// library with helper methods for oracles that are concerned with computing average prices
library UniswapV2OracleLibrary {
    using FixedPoint for *;

    // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
    function CURRENTBLOCKTIMESTAMP220() internal view returns (uint32) {	//inject NONSTANDARD NAMING
        return uint32(block.timestamp % 2 ** 32);
    }

    // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
    function CURRENTCUMULATIVEPRICES765(	//inject NONSTANDARD NAMING
        address pair
    ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
        blockTimestamp = CURRENTBLOCKTIMESTAMP220();
        price0Cumulative = IUniswapV2Pair(pair).PRICE0CUMULATIVELAST525();
        price1Cumulative = IUniswapV2Pair(pair).PRICE1CUMULATIVELAST405();

        // if time has elapsed since the last update on the pair, mock the accumulated price values
        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).GETRESERVES186();
        if (blockTimestampLast != blockTimestamp) {
            // subtraction overflow is desired
            uint32 timeElapsed = blockTimestamp - blockTimestampLast;
            // addition overflow is desired
            // counterfactual
            price0Cumulative += uint(FixedPoint.FRACTION125(reserve1, reserve0)._x) * timeElapsed;
            // counterfactual
            price1Cumulative += uint(FixedPoint.FRACTION125(reserve0, reserve1)._x) * timeElapsed;
        }
    }
}

// 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                                    
    function ADD549(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                        
    function SUB879(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB879(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                            
    function SUB879(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                                
    function MUL252(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function DIV530(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV530(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function DIV530(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    function MOD417(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD417(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function MOD417(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

library UniswapV2Library {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function SORTTOKENS809(address tokenA, address tokenB) internal pure returns (address token0, address token1) {	//inject NONSTANDARD NAMING
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function PAIRFOR391(address factory, address tokenA, address tokenB) internal pure returns (address pair) {	//inject NONSTANDARD NAMING
        (address token0, address token1) = SORTTOKENS809(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function GETRESERVES186(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {	//inject NONSTANDARD NAMING
        (address token0,) = SORTTOKENS809(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(PAIRFOR391(factory, tokenA, tokenB)).GETRESERVES186();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function QUOTE986(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {	//inject NONSTANDARD NAMING
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.MUL252(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function GETAMOUNTOUT221(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {	//inject NONSTANDARD NAMING
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.MUL252(997);
        uint numerator = amountInWithFee.MUL252(reserveOut);
        uint denominator = reserveIn.MUL252(1000).ADD549(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function GETAMOUNTIN900(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {	//inject NONSTANDARD NAMING
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.MUL252(amountOut).MUL252(1000);
        uint denominator = reserveOut.SUB879(amountOut).MUL252(997);
        amountIn = (numerator / denominator).ADD549(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function GETAMOUNTSOUT486(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {	//inject NONSTANDARD NAMING
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = GETRESERVES186(factory, path[i], path[i + 1]);
            amounts[i + 1] = GETAMOUNTOUT221(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function GETAMOUNTSIN740(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {	//inject NONSTANDARD NAMING
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = GETRESERVES186(factory, path[i - 1], path[i]);
            amounts[i - 1] = GETAMOUNTIN900(amounts[i], reserveIn, reserveOut);
        }
    }
}

contract PriceProviderUniswap is PriceProvider {

    using FixedPoint for *;
    using SafeMath for uint;

    IUniswapV2Pair public immutable pair;

    address immutable weth;
    address public immutable stableToken;

    uint priceCumulativeLast;
    uint price1CumulativeLast;
    uint32 blockTimestampLast;
    bool wethIsToken0;
    FixedPoint.uq112x112 priceAverage;

                                                                                         

    constructor(address _manager, address _factory, address _weth, address _stableToken) public PriceProvider("Uniswap", _manager, true) {
        IUniswapV2Pair _pair = IUniswapV2Pair(UniswapV2Library.PAIRFOR391(_factory, _weth, _stableToken));
        pair = _pair;
        weth = _weth;
        if (_weth == _pair.TOKEN0628()) {
            wethIsToken0 = true;
        } else {
            wethIsToken0 = false;
        }
        stableToken = _stableToken;

        if (wethIsToken0 == true) {
            priceCumulativeLast = _pair.PRICE0CUMULATIVELAST525();
        } else {
            priceCumulativeLast = _pair.PRICE1CUMULATIVELAST405();
        }

        (,,blockTimestampLast) = _pair.GETRESERVES186();
    }

    function UPDATE754() external {	//inject NONSTANDARD NAMING
        require(msg.sender == manager, "manager!");
        (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) =
            UniswapV2OracleLibrary.CURRENTCUMULATIVEPRICES765(address(pair));
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired

        // overflow is desired, casting never truncates
        // cumulative price is in (uq112x112 price * seconds) units so we simply wrap it after division by time elapsed
        if (wethIsToken0 == true) {
            priceAverage = FixedPoint.uq112x112(uint224((price0Cumulative - priceCumulativeLast) / timeElapsed));
            priceCumulativeLast = price0Cumulative;
        } else {
            priceAverage = FixedPoint.uq112x112(uint224((price1Cumulative - priceCumulativeLast) / timeElapsed));
            priceCumulativeLast = price1Cumulative;
        }

        blockTimestampLast = blockTimestamp;
    }

                                                           

    function LASTPRICE690() public override view returns (uint32 price) {	//inject NONSTANDARD NAMING
        uint amountOut = priceAverage.MUL252(1 ether).DECODE144956();
        uint8 stableTokenDecimals = ERC20Detailed(stableToken).DECIMALS571();
        if (stableTokenDecimals >= decimals686) {
            price = uint32(amountOut.DIV530(10 ** uint(stableTokenDecimals - decimals686)));
        } else {
            price = uint32(amountOut.MUL252(10 ** uint(decimals686 - stableTokenDecimals)));
        }
    }
}