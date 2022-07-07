                                                                 

// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

interface IUniswapV2Factory {
    event PAIRCREATED765(address indexed token0, address indexed token1, address pair, uint);	//inject NONSTANDARD NAMING

    function FEETO173() external view returns (address);	//inject NONSTANDARD NAMING
    function FEETOSETTER947() external view returns (address);	//inject NONSTANDARD NAMING

    function GETPAIR540(address tokenA, address tokenB) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRS330(uint) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRSLENGTH28() external view returns (uint);	//inject NONSTANDARD NAMING

    function CREATEPAIR870(address tokenA, address tokenB) external returns (address pair);	//inject NONSTANDARD NAMING

    function SETFEETO87(address) external;	//inject NONSTANDARD NAMING
    function SETFEETOSETTER308(address) external;	//inject NONSTANDARD NAMING
}

interface IUniswapV2Pair {
    event APPROVAL174(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER306(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME472() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL588() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS125() external pure returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY849() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF412(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE690(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE763(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER680(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM721(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING

    function DOMAIN_SEPARATOR798() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function PERMIT_TYPEHASH5() external pure returns (bytes32);	//inject NONSTANDARD NAMING
    function NONCES780(address owner) external view returns (uint);	//inject NONSTANDARD NAMING

    function PERMIT824(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING

    event MINT900(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN945(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP468(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC111(uint112 reserve0, uint112 reserve1);	//inject NONSTANDARD NAMING

    function MINIMUM_LIQUIDITY386() external pure returns (uint);	//inject NONSTANDARD NAMING
    function FACTORY86() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN0481() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN1550() external view returns (address);	//inject NONSTANDARD NAMING
    function GETRESERVES473() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);	//inject NONSTANDARD NAMING
    function PRICE0CUMULATIVELAST512() external view returns (uint);	//inject NONSTANDARD NAMING
    function PRICE1CUMULATIVELAST431() external view returns (uint);	//inject NONSTANDARD NAMING
    function KLAST25() external view returns (uint);	//inject NONSTANDARD NAMING

    function MINT371(address to) external returns (uint liquidity);	//inject NONSTANDARD NAMING
    function BURN742(address to) external returns (uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    function SWAP14(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;	//inject NONSTANDARD NAMING
    function SKIM245(address to) external;	//inject NONSTANDARD NAMING
    function SYNC404() external;	//inject NONSTANDARD NAMING

    function INITIALIZE744(address, address) external;	//inject NONSTANDARD NAMING
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

    uint8 private constant resolution65 = 112;	//inject NONSTANDARD NAMING

    // encode a uint112 as a UQ112x112
    function ENCODE953(uint112 x) internal pure returns (uq112x112 memory) {	//inject NONSTANDARD NAMING
        return uq112x112(uint224(x) << resolution65);
    }

    // encodes a uint144 as a UQ144x112
    function ENCODE144474(uint144 x) internal pure returns (uq144x112 memory) {	//inject NONSTANDARD NAMING
        return uq144x112(uint256(x) << resolution65);
    }

    // divide a UQ112x112 by a uint112, returning a UQ112x112
    function DIV758(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {	//inject NONSTANDARD NAMING
        require(x != 0, 'FixedPoint: DIV_BY_ZERO');
        return uq112x112(self._x / uint224(x));
    }

    // multiply a UQ112x112 by a uint, returning a UQ144x112
    // reverts on overflow
    function MUL709(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {	//inject NONSTANDARD NAMING
        uint z;
        require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
        return uq144x112(z);
    }

    // returns a UQ112x112 which represents the ratio of the numerator to the denominator
    // equivalent to encode(numerator).div(denominator)
    function FRACTION20(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {	//inject NONSTANDARD NAMING
        require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
        return uq112x112((uint224(numerator) << resolution65) / denominator);
    }

    // decode a UQ112x112 into a uint112 by truncating after the radix point
    function DECODE642(uq112x112 memory self) internal pure returns (uint112) {	//inject NONSTANDARD NAMING
        return uint112(self._x >> resolution65);
    }

    // decode a UQ144x112 into a uint144 by truncating after the radix point
    function DECODE144805(uq144x112 memory self) internal pure returns (uint144) {	//inject NONSTANDARD NAMING
        return uint144(self._x >> resolution65);
    }
}

// library with helper methods for oracles that are concerned with computing average prices
library UniswapV2OracleLibrary {
    using FixedPoint for *;

    // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
    function CURRENTBLOCKTIMESTAMP616() internal view returns (uint32) {	//inject NONSTANDARD NAMING
        return uint32(block.timestamp % 2 ** 32);
    }

    // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
    function CURRENTCUMULATIVEPRICES565(	//inject NONSTANDARD NAMING
        address pair
    ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
        blockTimestamp = CURRENTBLOCKTIMESTAMP616();
        price0Cumulative = IUniswapV2Pair(pair).PRICE0CUMULATIVELAST512();
        price1Cumulative = IUniswapV2Pair(pair).PRICE1CUMULATIVELAST431();

        // if time has elapsed since the last update on the pair, mock the accumulated price values
        (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).GETRESERVES473();
        if (blockTimestampLast != blockTimestamp) {
            // subtraction overflow is desired
            uint32 timeElapsed = blockTimestamp - blockTimestampLast;
            // addition overflow is desired
            // counterfactual
            price0Cumulative += uint(FixedPoint.FRACTION20(reserve1, reserve0)._x) * timeElapsed;
            // counterfactual
            price1Cumulative += uint(FixedPoint.FRACTION20(reserve0, reserve1)._x) * timeElapsed;
        }
    }
}

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                      
    function ADD508(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                          
    function ADD508(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, errorMessage);

        return c;
    }

                                                                                                                                                                                                                                                            
    function SUB277(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB277(a, b, "SafeMath: subtraction underflow");
    }

                                                                                                                                                                                                                                                                                
    function SUB277(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                  
    function MUL709(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                  
    function MUL709(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, errorMessage);

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV758(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV758(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function DIV758(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD92(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD92(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function MOD92(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

library UniswapV2Library {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function SORTTOKENS379(address tokenA, address tokenB) internal pure returns (address token0, address token1) {	//inject NONSTANDARD NAMING
        require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function PAIRFOR87(address factory, address tokenA, address tokenB) internal pure returns (address pair) {	//inject NONSTANDARD NAMING
        (address token0, address token1) = SORTTOKENS379(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function GETRESERVES473(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {	//inject NONSTANDARD NAMING
        (address token0,) = SORTTOKENS379(tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IUniswapV2Pair(PAIRFOR87(factory, tokenA, tokenB)).GETRESERVES473();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function QUOTE2(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {	//inject NONSTANDARD NAMING
        require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.MUL709(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function GETAMOUNTOUT789(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {	//inject NONSTANDARD NAMING
        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.MUL709(997);
        uint numerator = amountInWithFee.MUL709(reserveOut);
        uint denominator = reserveIn.MUL709(1000).ADD508(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function GETAMOUNTIN163(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {	//inject NONSTANDARD NAMING
        require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.MUL709(amountOut).MUL709(1000);
        uint denominator = reserveOut.SUB277(amountOut).MUL709(997);
        amountIn = (numerator / denominator).ADD508(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function GETAMOUNTSOUT330(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {	//inject NONSTANDARD NAMING
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = GETRESERVES473(factory, path[i], path[i + 1]);
            amounts[i + 1] = GETAMOUNTOUT789(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function GETAMOUNTSIN267(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {	//inject NONSTANDARD NAMING
        require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = GETRESERVES473(factory, path[i - 1], path[i]);
            amounts[i - 1] = GETAMOUNTIN163(amounts[i], reserveIn, reserveOut);
        }
    }
}

interface WETH9 {
    function WITHDRAW840(uint wad) external;	//inject NONSTANDARD NAMING
}

interface IUniswapV2Router {
    function SWAPEXACTTOKENSFORTOKENS109(	//inject NONSTANDARD NAMING
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IKeep3rV1 {
    function ISMINKEEPER913(address keeper, uint minBond, uint earned, uint age) external returns (bool);	//inject NONSTANDARD NAMING
    function RECEIPT100(address credit, address keeper, uint amount) external;	//inject NONSTANDARD NAMING
    function UNBOND169(address bonding, uint amount) external;	//inject NONSTANDARD NAMING
    function WITHDRAW840(address bonding) external;	//inject NONSTANDARD NAMING
    function BONDS570(address keeper, address credit) external view returns (uint);	//inject NONSTANDARD NAMING
    function UNBONDINGS996(address keeper, address credit) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE763(address spender, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function JOBS817(address job) external view returns (bool);	//inject NONSTANDARD NAMING
    function BALANCEOF412(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
    function WORKED219(address keeper) external;	//inject NONSTANDARD NAMING
    function KPRH771() external view returns (IKeep3rV1Helper);	//inject NONSTANDARD NAMING
}

interface IKeep3rV1Helper {
    function GETQUOTELIMIT880(uint gasUsed) external view returns (uint);	//inject NONSTANDARD NAMING
}

// sliding oracle that uses observations collected to provide moving price averages in the past
contract YearnV2Oracle {
    using FixedPoint for *;
    using SafeMath for uint;

    struct Observation {
        uint timestamp;
        uint price0Cumulative;
        uint price1Cumulative;
    }
    
    uint public minKeep = 200e18;

    modifier KEEPER983() {	//inject NONSTANDARD NAMING
        require(kp3r674.ISMINKEEPER913(msg.sender, minKeep, 0, 0), "::isKeeper: keeper is not registered");
        _;
    }

    modifier UPKEEP664() {	//inject NONSTANDARD NAMING
        uint _gasUsed = gasleft();
        require(kp3r674.ISMINKEEPER913(msg.sender, minKeep, 0, 0), "::isKeeper: keeper is not registered");
        _;
        uint _received = kp3r674.KPRH771().GETQUOTELIMIT880(_gasUsed.SUB277(gasleft()));
        kp3r674.RECEIPT100(address(kp3r674), address(this), _received);
        _received = _SWAP523(_received);
        msg.sender.transfer(_received);
    }

    address public governance;
    address public pendingGovernance;
    
    function SETMINKEEP842(uint _keep) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "setGovernance: !gov");
        minKeep = _keep;
    }

                                                                                                                                                        
    function SETGOVERNANCE949(address _governance) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "setGovernance: !gov");
        pendingGovernance = _governance;
    }

                                                                                                               
    function ACCEPTGOVERNANCE56() external {	//inject NONSTANDARD NAMING
        require(msg.sender == pendingGovernance, "acceptGovernance: !pendingGov");
        governance = pendingGovernance;
    }

    IKeep3rV1 public constant kp3r674 = IKeep3rV1(0x1cEB5cB57C4D4E2b2433641b95Dd330A33185A44);	//inject NONSTANDARD NAMING
    WETH9 public constant weth411 = WETH9(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);	//inject NONSTANDARD NAMING
    IUniswapV2Router public constant uni703 = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);	//inject NONSTANDARD NAMING

    address public constant factory868 = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;	//inject NONSTANDARD NAMING
    // this is redundant with granularity and windowSize, but stored for gas savings & informational purposes.
    uint public constant periodsize934 = 1800;	//inject NONSTANDARD NAMING

    address[] internal _pairs;
    mapping(address => bool) internal _known;

    function PAIRS458() external view returns (address[] memory) {	//inject NONSTANDARD NAMING
        return _pairs;
    }

    mapping(address => Observation[]) public observations;
    
    function OBSERVATIONLENGTH959(address pair) external view returns (uint) {	//inject NONSTANDARD NAMING
        return observations[pair].length;
    }
    
    function PAIRFOR87(address tokenA, address tokenB) external pure returns (address) {	//inject NONSTANDARD NAMING
        return UniswapV2Library.PAIRFOR87(factory868, tokenA, tokenB);
    }
    
    function PAIRFORWETH375(address tokenA) external pure returns (address) {	//inject NONSTANDARD NAMING
        return UniswapV2Library.PAIRFOR87(factory868, tokenA, address(weth411));
    }

    constructor() public {
        governance = msg.sender;
    }

    function UPDATEPAIR621(address pair) external KEEPER983 returns (bool) {	//inject NONSTANDARD NAMING
        return _UPDATE639(pair);
    }

    function UPDATE182(address tokenA, address tokenB) external KEEPER983 returns (bool) {	//inject NONSTANDARD NAMING
        address pair = UniswapV2Library.PAIRFOR87(factory868, tokenA, tokenB);
        return _UPDATE639(pair);
    }

    function ADD508(address tokenA, address tokenB) external {	//inject NONSTANDARD NAMING
        require(msg.sender == governance, "UniswapV2Oracle::add: !gov");
        address pair = UniswapV2Library.PAIRFOR87(factory868, tokenA, tokenB);
        require(!_known[pair], "known");
        _known[pair] = true;
        _pairs.push(pair);

        (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.CURRENTCUMULATIVEPRICES565(pair);
        observations[pair].push(Observation(block.timestamp, price0Cumulative, price1Cumulative));
    }

    function WORK476() public UPKEEP664 {	//inject NONSTANDARD NAMING
        bool worked = _UPDATEALL128();
        require(worked, "UniswapV2Oracle: !work");
    }

    function WORKFORFREE492() public KEEPER983 {	//inject NONSTANDARD NAMING
        bool worked = _UPDATEALL128();
        require(worked, "UniswapV2Oracle: !work");
    }
    
    function LASTOBSERVATION770(address pair) public view returns (Observation memory) {	//inject NONSTANDARD NAMING
        return observations[pair][observations[pair].length-1];
    }

    function _UPDATEALL128() internal returns (bool updated) {	//inject NONSTANDARD NAMING
        for (uint i = 0; i < _pairs.length; i++) {
            if (_UPDATE639(_pairs[i])) {
                updated = true;
            }
        }
    }

    function UPDATEFOR106(uint i, uint length) external KEEPER983 returns (bool updated) {	//inject NONSTANDARD NAMING
        for (; i < length; i++) {
            if (_UPDATE639(_pairs[i])) {
                updated = true;
            }
        }
    }

    function WORKABLE40(address pair) public view returns (bool) {	//inject NONSTANDARD NAMING
        return (block.timestamp - LASTOBSERVATION770(pair).timestamp) > periodsize934;
    }

    function WORKABLE40() external view returns (bool) {	//inject NONSTANDARD NAMING
        for (uint i = 0; i < _pairs.length; i++) {
            if (WORKABLE40(_pairs[i])) {
                return true;
            }
        }
        return false;
    }

    function _UPDATE639(address pair) internal returns (bool) {	//inject NONSTANDARD NAMING
        // we only want to commit updates once per period (i.e. windowSize / granularity)
        Observation memory _point = LASTOBSERVATION770(pair);
        uint timeElapsed = block.timestamp - _point.timestamp;
        if (timeElapsed > periodsize934) {
            (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.CURRENTCUMULATIVEPRICES565(pair);
            observations[pair].push(Observation(block.timestamp, price0Cumulative, price1Cumulative));
            return true;
        }
        return false;
    }

    function COMPUTEAMOUNTOUT732(	//inject NONSTANDARD NAMING
        uint priceCumulativeStart, uint priceCumulativeEnd,
        uint timeElapsed, uint amountIn
    ) private pure returns (uint amountOut) {
        // overflow is desired.
        FixedPoint.uq112x112 memory priceAverage = FixedPoint.uq112x112(
            uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
        );
        amountOut = priceAverage.MUL709(amountIn).DECODE144805();
    }

    function _VALID458(address pair, uint age) internal view returns (bool) {	//inject NONSTANDARD NAMING
        return (block.timestamp - LASTOBSERVATION770(pair).timestamp) <= age;
    }

    function CURRENT334(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut) {	//inject NONSTANDARD NAMING
        address pair = UniswapV2Library.PAIRFOR87(factory868, tokenIn, tokenOut);
        require(_VALID458(pair, periodsize934.MUL709(2)), "UniswapV2Oracle::quote: stale prices");
        (address token0,) = UniswapV2Library.SORTTOKENS379(tokenIn, tokenOut);

        Observation memory _observation = LASTOBSERVATION770(pair);
        (uint price0Cumulative, uint price1Cumulative,) = UniswapV2OracleLibrary.CURRENTCUMULATIVEPRICES565(pair);
        if (block.timestamp == _observation.timestamp) {
            _observation = observations[pair][observations[pair].length-2];
        }
        
        uint timeElapsed = block.timestamp - _observation.timestamp;
        timeElapsed = timeElapsed == 0 ? 1 : timeElapsed;
        if (token0 == tokenIn) {
            return COMPUTEAMOUNTOUT732(_observation.price0Cumulative, price0Cumulative, timeElapsed, amountIn);
        } else {
            return COMPUTEAMOUNTOUT732(_observation.price1Cumulative, price1Cumulative, timeElapsed, amountIn);
        }
    }

    function QUOTE2(address tokenIn, uint amountIn, address tokenOut, uint granularity) external view returns (uint amountOut) {	//inject NONSTANDARD NAMING
        address pair = UniswapV2Library.PAIRFOR87(factory868, tokenIn, tokenOut);
        require(_VALID458(pair, periodsize934.MUL709(granularity)), "UniswapV2Oracle::quote: stale prices");
        (address token0,) = UniswapV2Library.SORTTOKENS379(tokenIn, tokenOut);

        uint priceAverageCumulative = 0;
        uint length = observations[pair].length-1;
        uint i = length.SUB277(granularity);


        uint nextIndex = 0;
        if (token0 == tokenIn) {
            for (; i < length; i++) {
                nextIndex = i+1;
                priceAverageCumulative += COMPUTEAMOUNTOUT732(
                    observations[pair][i].price0Cumulative,
                    observations[pair][nextIndex].price0Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
            }
        } else {
            for (; i < length; i++) {
                nextIndex = i+1;
                priceAverageCumulative += COMPUTEAMOUNTOUT732(
                    observations[pair][i].price1Cumulative,
                    observations[pair][nextIndex].price1Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
            }
        }
        return priceAverageCumulative.DIV758(granularity);
    }
    
    function PRICES199(address tokenIn, uint amountIn, address tokenOut, uint points) external view returns (uint[] memory) {	//inject NONSTANDARD NAMING
        address pair = UniswapV2Library.PAIRFOR87(factory868, tokenIn, tokenOut);
        (address token0,) = UniswapV2Library.SORTTOKENS379(tokenIn, tokenOut);
        uint[] memory _prices = new uint[](points);
        
        uint length = observations[pair].length-1;
        uint i = length.SUB277(points);
        uint nextIndex = 0;
        uint index = 0;
        
        if (token0 == tokenIn) {
            for (; i < length; i++) {
                nextIndex = i+1;
                _prices[index] = COMPUTEAMOUNTOUT732(
                    observations[pair][i].price0Cumulative,
                    observations[pair][nextIndex].price0Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index+1;
            }
        } else {
            for (; i < length; i++) {
                nextIndex = i+1;
                _prices[index] = COMPUTEAMOUNTOUT732(
                    observations[pair][i].price1Cumulative,
                    observations[pair][nextIndex].price1Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index+1;
            }
        }
        return _prices;
    }
    
    function HOURLY603(address tokenIn, uint amountIn, address tokenOut, uint points) public view returns (uint[] memory) {	//inject NONSTANDARD NAMING
        address pair = UniswapV2Library.PAIRFOR87(factory868, tokenIn, tokenOut);
        (address token0,) = UniswapV2Library.SORTTOKENS379(tokenIn, tokenOut);
        uint[] memory _prices = new uint[](points);
        
        uint _len = observations[pair].length-1;
        
        uint length = _len.SUB277(2);
        uint i = _len.SUB277(points.MUL709(2));
        uint nextIndex = 0;
        uint index = 0;
        
        if (token0 == tokenIn) {
            for (; i < length; i.ADD508(2)) {
                nextIndex = i.ADD508(2);
                _prices[index] = COMPUTEAMOUNTOUT732(
                    observations[pair][i].price0Cumulative,
                    observations[pair][nextIndex].price0Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index+1;
            }
        } else {
            for (; i < length; i++) {
                nextIndex = i.ADD508(2);
                _prices[index] = COMPUTEAMOUNTOUT732(
                    observations[pair][i].price1Cumulative,
                    observations[pair][nextIndex].price1Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index+1;
            }
        }
        return _prices;
    }
    
    function DAILY468(address tokenIn, uint amountIn, address tokenOut, uint points) public view returns (uint[] memory) {	//inject NONSTANDARD NAMING
        address pair = UniswapV2Library.PAIRFOR87(factory868, tokenIn, tokenOut);
        (address token0,) = UniswapV2Library.SORTTOKENS379(tokenIn, tokenOut);
        uint[] memory _prices = new uint[](points);
        
        uint _len = observations[pair].length-1;
        
        uint length = _len.SUB277(48);
        uint i = _len.SUB277(points.MUL709(48));
        uint nextIndex = 0;
        uint index = 0;
        
        if (token0 == tokenIn) {
            for (; i < length; i.ADD508(48)) {
                nextIndex = i.ADD508(48);
                _prices[index] = COMPUTEAMOUNTOUT732(
                    observations[pair][i].price0Cumulative,
                    observations[pair][nextIndex].price0Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index+1;
            }
        } else {
            for (; i < length; i++) {
                nextIndex = i.ADD508(48);
                _prices[index] = COMPUTEAMOUNTOUT732(
                    observations[pair][i].price1Cumulative,
                    observations[pair][nextIndex].price1Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index+1;
            }
        }
        return _prices;
    }
    
    function WEEKLY904(address tokenIn, uint amountIn, address tokenOut, uint points) public view returns (uint[] memory) {	//inject NONSTANDARD NAMING
        address pair = UniswapV2Library.PAIRFOR87(factory868, tokenIn, tokenOut);
        (address token0,) = UniswapV2Library.SORTTOKENS379(tokenIn, tokenOut);
        uint[] memory _prices = new uint[](points);
        
        uint _len = observations[pair].length-1;
        
        uint length = _len.SUB277(336);
        uint i = _len.SUB277(points.MUL709(336));
        uint nextIndex = 0;
        uint index = 0;
        
        if (token0 == tokenIn) {
            for (; i < length; i.ADD508(336)) {
                nextIndex = i.ADD508(336);
                _prices[index] = COMPUTEAMOUNTOUT732(
                    observations[pair][i].price0Cumulative,
                    observations[pair][nextIndex].price0Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index+1;
            }
        } else {
            for (; i < length; i++) {
                nextIndex = i.ADD508(336);
                _prices[index] = COMPUTEAMOUNTOUT732(
                    observations[pair][i].price1Cumulative,
                    observations[pair][nextIndex].price1Cumulative, 
                    observations[pair][nextIndex].timestamp - observations[pair][i].timestamp, amountIn);
                index = index+1;
            }
        }
        return _prices;
    }
    
    function IMPLIEDVOLATILITYHOURLY328(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {	//inject NONSTANDARD NAMING
        return STDDEV946(HOURLY603(tokenIn, amountIn, tokenOut, 1));
    }
    
    function IMPLIEDVOLATILITYDAILY500(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {	//inject NONSTANDARD NAMING
        return STDDEV946(DAILY468(tokenIn, amountIn, tokenOut, 1));
    }
    
    function IMPLIEDVOLATILITYWEEKLY55(address tokenIn, uint amountIn, address tokenOut) external view returns (uint) {	//inject NONSTANDARD NAMING
        return STDDEV946(WEEKLY904(tokenIn, amountIn, tokenOut, 1));
    }
    
                                                                                                                                                                                                                                                                         
    function SQRT123(uint256 x) public pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = (x + 1) / 2;
        uint256 b = x;
        while (c < b) {
            b = c;
            c = (x / c + c) / 2;
        }
        return b;
    }
    
                                                                                                                                                                                                                                                                                                                          
    function STDDEV946(uint[] memory numbers) public pure returns (uint256 sd) {	//inject NONSTANDARD NAMING
        uint sum = 0;
        for(uint i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        uint256 mean = sum / numbers.length;        // Integral value; float not supported in Solidity
        sum = 0;
        uint i;
        for(i = 0; i < numbers.length; i++) {
            sum += (numbers[i] - mean) ** 2;
        }
        sd = SQRT123(sum / (numbers.length - 1));      //Integral value; float not supported in Solidity
        return sd;
    }
    
    
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    function BLACKSCHOLESESTIMATE503(	//inject NONSTANDARD NAMING
        uint256 _vol,
        uint256 _underlying,
        uint256 _time
    ) public pure returns (uint256 estimate) {
        estimate = 40 * _vol * _underlying * SQRT123(_time);
        return estimate;
    }
    
                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function RETBASEDBLACKSCHOLESESTIMATE765(	//inject NONSTANDARD NAMING
        uint256[] memory _numbers,
        uint256 _underlying,
        uint256 _time
    ) public pure {
        uint _vol = STDDEV946(_numbers);
        BLACKSCHOLESESTIMATE503(_vol, _underlying, _time);
    }
    
    receive() external payable {}
    
    function _SWAP523(uint _amount) internal returns (uint) {	//inject NONSTANDARD NAMING
        kp3r674.APPROVE763(address(uni703), _amount);
        
        address[] memory path = new address[](2);
        path[0] = address(kp3r674);
        path[1] = address(weth411);

        uint[] memory amounts = uni703.SWAPEXACTTOKENSFORTOKENS109(_amount, uint256(0), path, address(this), now.ADD508(1800));
        weth411.WITHDRAW840(amounts[1]);
        return amounts[1];
    }
}