                                                                 

pragma solidity =0.5.16;

interface IUniSlurmFactory {
    event PAIRCREATED643(address indexed token0, address indexed token1, address pair, uint);	//inject NONSTANDARD NAMING

    function FEETO571() external view returns (address);	//inject NONSTANDARD NAMING
    function FEETOSETTER612() external view returns (address);	//inject NONSTANDARD NAMING

    function GETPAIR63(address tokenA, address tokenB) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRS572(uint) external view returns (address pair);	//inject NONSTANDARD NAMING
    function ALLPAIRSLENGTH196() external view returns (uint);	//inject NONSTANDARD NAMING

    function CREATEPAIR935(address tokenA, address tokenB) external returns (address pair);	//inject NONSTANDARD NAMING

    function SETFEETO183(address) external;	//inject NONSTANDARD NAMING
    function SETFEETOSETTER227(address) external;	//inject NONSTANDARD NAMING
}

interface IUniSlurmPair {
    event APPROVAL888(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER551(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME160() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL664() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS561() external pure returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY585() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF875(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE779(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE58(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER588(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM28(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING

    function DOMAIN_SEPARATOR387() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function PERMIT_TYPEHASH650() external pure returns (bytes32);	//inject NONSTANDARD NAMING
    function NONCES43(address owner) external view returns (uint);	//inject NONSTANDARD NAMING

    function PERMIT561(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING

    event MINT2(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN970(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP447(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC662(uint112 reserve0, uint112 reserve1);	//inject NONSTANDARD NAMING

    function MINIMUM_LIQUIDITY787() external pure returns (uint);	//inject NONSTANDARD NAMING
    function FACTORY371() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN07() external view returns (address);	//inject NONSTANDARD NAMING
    function TOKEN1249() external view returns (address);	//inject NONSTANDARD NAMING
    function GETRESERVES1() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);	//inject NONSTANDARD NAMING
    function PRICE0CUMULATIVELAST488() external view returns (uint);	//inject NONSTANDARD NAMING
    function PRICE1CUMULATIVELAST101() external view returns (uint);	//inject NONSTANDARD NAMING
    function KLAST399() external view returns (uint);	//inject NONSTANDARD NAMING

    function MINT920(address to) external returns (uint liquidity);	//inject NONSTANDARD NAMING
    function BURN311(address to) external returns (uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    function SWAP495(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;	//inject NONSTANDARD NAMING
    function SKIM266(address to) external;	//inject NONSTANDARD NAMING
    function SYNC778() external;	//inject NONSTANDARD NAMING

    function INITIALIZE278(address, address) external;	//inject NONSTANDARD NAMING
}

interface IUniSlurmERC20 {
    event APPROVAL888(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER551(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME160() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL664() external pure returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS561() external pure returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY585() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF875(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE779(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE58(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER588(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM28(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING

    function DOMAIN_SEPARATOR387() external view returns (bytes32);	//inject NONSTANDARD NAMING
    function PERMIT_TYPEHASH650() external pure returns (bytes32);	//inject NONSTANDARD NAMING
    function NONCES43(address owner) external view returns (uint);	//inject NONSTANDARD NAMING

    function PERMIT561(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;	//inject NONSTANDARD NAMING
}

library SafeMath {
    function ADD459(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function SUB229(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function MUL16(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

contract UniSlurmERC20 is IUniSlurmERC20 {
    using SafeMath for uint;

    string public constant name17 = 'UniSlurm';	//inject NONSTANDARD NAMING
    string public constant symbol660 = 'UNIS';	//inject NONSTANDARD NAMING
    uint8 public constant decimals825 = 18;	//inject NONSTANDARD NAMING
    uint  public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    bytes32 public DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public constant permit_typehash767 = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;	//inject NONSTANDARD NAMING
    mapping(address => uint) public nonces;

    event APPROVAL888(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER551(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    constructor() public {
        uint chainId;
        assembly {
            chainId := chainid
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(name17)),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    function _MINT935(address to, uint value) internal {	//inject NONSTANDARD NAMING
        totalSupply = totalSupply.ADD459(value);
        balanceOf[to] = balanceOf[to].ADD459(value);
        emit TRANSFER551(address(0), to, value);
    }

    function _BURN53(address from, uint value) internal {	//inject NONSTANDARD NAMING
        balanceOf[from] = balanceOf[from].SUB229(value);
        totalSupply = totalSupply.SUB229(value);
        emit TRANSFER551(from, address(0), value);
    }

    function _APPROVE174(address owner, address spender, uint value) private {	//inject NONSTANDARD NAMING
        allowance[owner][spender] = value;
        emit APPROVAL888(owner, spender, value);
    }

    function _TRANSFER788(address from, address to, uint value) private {	//inject NONSTANDARD NAMING
        balanceOf[from] = balanceOf[from].SUB229(value);
        balanceOf[to] = balanceOf[to].ADD459(value);
        emit TRANSFER551(from, to, value);
    }

    function APPROVE58(address spender, uint value) external returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE174(msg.sender, spender, value);
        return true;
    }

    function TRANSFER588(address to, uint value) external returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER788(msg.sender, to, value);
        return true;
    }

    function TRANSFERFROM28(address from, address to, uint value) external returns (bool) {	//inject NONSTANDARD NAMING
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].SUB229(value);
        }
        _TRANSFER788(from, to, value);
        return true;
    }

    function PERMIT561(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {	//inject NONSTANDARD NAMING
        require(deadline >= block.timestamp, 'UniSlurm: EXPIRED');
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(permit_typehash767, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniSlurm: INVALID_SIGNATURE');
        _APPROVE174(owner, spender, value);
    }
}

library Math {
    function MIN298(uint x, uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function SQRT202(uint y) internal pure returns (uint z) {	//inject NONSTANDARD NAMING
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

library UQ112x112 {
    uint224 constant q112888 = 2**112;	//inject NONSTANDARD NAMING

    // encode a uint112 as a UQ112x112
    function ENCODE159(uint112 y) internal pure returns (uint224 z) {	//inject NONSTANDARD NAMING
        z = uint224(y) * q112888; // never overflows
    }

    // divide a UQ112x112 by a uint112, returning a UQ112x112
    function UQDIV280(uint224 x, uint112 y) internal pure returns (uint224 z) {	//inject NONSTANDARD NAMING
        z = x / uint224(y);
    }
}

interface IERC20 {
    event APPROVAL888(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
    event TRANSFER551(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING

    function NAME160() external view returns (string memory);	//inject NONSTANDARD NAMING
    function SYMBOL664() external view returns (string memory);	//inject NONSTANDARD NAMING
    function DECIMALS561() external view returns (uint8);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY585() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF875(address owner) external view returns (uint);	//inject NONSTANDARD NAMING
    function ALLOWANCE779(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING

    function APPROVE58(address spender, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFER588(address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM28(address from, address to, uint value) external returns (bool);	//inject NONSTANDARD NAMING
}

interface IUniSlurmCallee {
    function UNISLURMCALL850(address sender, uint amount0, uint amount1, bytes calldata data) external;	//inject NONSTANDARD NAMING
}

contract UniSlurmPair is IUniSlurmPair, UniSlurmERC20 {
    using SafeMath  for uint;
    using UQ112x112 for uint224;

    uint public constant minimum_liquidity396 = 10**3;	//inject NONSTANDARD NAMING
    bytes4 private constant selector560 = bytes4(keccak256(bytes('transfer(address,uint256)')));	//inject NONSTANDARD NAMING

    address public factory;
    address public token0;
    address public token1;

    uint112 private reserve0;           // uses single storage slot, accessible via getReserves
    uint112 private reserve1;           // uses single storage slot, accessible via getReserves
    uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves

    uint public price0CumulativeLast;
    uint public price1CumulativeLast;
    uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event

    uint private unlocked = 1;
    modifier LOCK137() {	//inject NONSTANDARD NAMING
        require(unlocked == 1, 'UniSlurm: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }

    function GETRESERVES1() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {	//inject NONSTANDARD NAMING
        _reserve0 = reserve0;
        _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
    }

    function _SAFETRANSFER205(address token, address to, uint value) private {	//inject NONSTANDARD NAMING
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(selector560, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniSlurm: TRANSFER_FAILED');
    }

    event MINT2(address indexed sender, uint amount0, uint amount1);	//inject NONSTANDARD NAMING
    event BURN970(address indexed sender, uint amount0, uint amount1, address indexed to);	//inject NONSTANDARD NAMING
    event SWAP447(	//inject NONSTANDARD NAMING
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event SYNC662(uint112 reserve0, uint112 reserve1);	//inject NONSTANDARD NAMING

    constructor() public {
        factory = msg.sender;
    }

    // called once by the factory at time of deployment
    function INITIALIZE278(address _token0, address _token1) external {	//inject NONSTANDARD NAMING
        require(msg.sender == factory, 'UniSlurm: FORBIDDEN'); // sufficient check
        token0 = _token0;
        token1 = _token1;
    }

    // update reserves and, on the first call per block, price accumulators
    function _UPDATE859(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {	//inject NONSTANDARD NAMING
        require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniSlurm: OVERFLOW');
        uint32 blockTimestamp = uint32(block.timestamp % 2**32);
        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
        if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
            // * never overflows, and + overflow is desired
            price0CumulativeLast += uint(UQ112x112.ENCODE159(_reserve1).UQDIV280(_reserve0)) * timeElapsed;
            price1CumulativeLast += uint(UQ112x112.ENCODE159(_reserve0).UQDIV280(_reserve1)) * timeElapsed;
        }
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        blockTimestampLast = blockTimestamp;
        emit SYNC662(reserve0, reserve1);
    }

    // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
    function _MINTFEE708(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {	//inject NONSTANDARD NAMING
        address feeTo = IUniSlurmFactory(factory).FEETO571();
        feeOn = feeTo != address(0);
        uint _kLast = kLast; // gas savings
        if (feeOn) {
            if (_kLast != 0) {
                uint rootK = Math.SQRT202(uint(_reserve0).MUL16(_reserve1));
                uint rootKLast = Math.SQRT202(_kLast);
                if (rootK > rootKLast) {
                    uint numerator = totalSupply.MUL16(rootK.SUB229(rootKLast));
                    uint denominator = rootK.MUL16(5).ADD459(rootKLast);
                    uint liquidity = numerator / denominator;
                    if (liquidity > 0) _MINT935(feeTo, liquidity);
                }
            }
        } else if (_kLast != 0) {
            kLast = 0;
        }
    }

    // this low-level function should be called from a contract which performs important safety checks
    function MINT920(address to) external LOCK137 returns (uint liquidity) {	//inject NONSTANDARD NAMING
        (uint112 _reserve0, uint112 _reserve1,) = GETRESERVES1(); // gas savings
        uint balance0 = IERC20(token0).BALANCEOF875(address(this));
        uint balance1 = IERC20(token1).BALANCEOF875(address(this));
        uint amount0 = balance0.SUB229(_reserve0);
        uint amount1 = balance1.SUB229(_reserve1);

        bool feeOn = _MINTFEE708(_reserve0, _reserve1);
        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        if (_totalSupply == 0) {
            liquidity = Math.SQRT202(amount0.MUL16(amount1)).SUB229(minimum_liquidity396);
           _MINT935(address(0), minimum_liquidity396); // permanently lock the first MINIMUM_LIQUIDITY tokens
        } else {
            liquidity = Math.MIN298(amount0.MUL16(_totalSupply) / _reserve0, amount1.MUL16(_totalSupply) / _reserve1);
        }
        require(liquidity > 0, 'UniSlurm: INSUFFICIENT_LIQUIDITY_MINTED');
        _MINT935(to, liquidity);

        _UPDATE859(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = uint(reserve0).MUL16(reserve1); // reserve0 and reserve1 are up-to-date
        emit MINT2(msg.sender, amount0, amount1);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function BURN311(address to) external LOCK137 returns (uint amount0, uint amount1) {	//inject NONSTANDARD NAMING
        (uint112 _reserve0, uint112 _reserve1,) = GETRESERVES1(); // gas savings
        address _token0 = token0;                                // gas savings
        address _token1 = token1;                                // gas savings
        uint balance0 = IERC20(_token0).BALANCEOF875(address(this));
        uint balance1 = IERC20(_token1).BALANCEOF875(address(this));
        uint liquidity = balanceOf[address(this)];

        bool feeOn = _MINTFEE708(_reserve0, _reserve1);
        uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
        amount0 = liquidity.MUL16(balance0) / _totalSupply; // using balances ensures pro-rata distribution
        amount1 = liquidity.MUL16(balance1) / _totalSupply; // using balances ensures pro-rata distribution
        require(amount0 > 0 && amount1 > 0, 'UniSlurm: INSUFFICIENT_LIQUIDITY_BURNED');
        _BURN53(address(this), liquidity);
        _SAFETRANSFER205(_token0, to, amount0);
        _SAFETRANSFER205(_token1, to, amount1);
        balance0 = IERC20(_token0).BALANCEOF875(address(this));
        balance1 = IERC20(_token1).BALANCEOF875(address(this));

        _UPDATE859(balance0, balance1, _reserve0, _reserve1);
        if (feeOn) kLast = uint(reserve0).MUL16(reserve1); // reserve0 and reserve1 are up-to-date
        emit BURN970(msg.sender, amount0, amount1, to);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function SWAP495(uint amount0Out, uint amount1Out, address to, bytes calldata data) external LOCK137 {	//inject NONSTANDARD NAMING
        require(amount0Out > 0 || amount1Out > 0, 'UniSlurm: INSUFFICIENT_OUTPUT_AMOUNT');
        (uint112 _reserve0, uint112 _reserve1,) = GETRESERVES1(); // gas savings
        require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniSlurm: INSUFFICIENT_LIQUIDITY');

        uint balance0;
        uint balance1;
        { // scope for _token{0,1}, avoids stack too deep errors
        address _token0 = token0;
        address _token1 = token1;
        require(to != _token0 && to != _token1, 'UniSlurm: INVALID_TO');
        if (amount0Out > 0) _SAFETRANSFER205(_token0, to, amount0Out); // optimistically transfer tokens
        if (amount1Out > 0) _SAFETRANSFER205(_token1, to, amount1Out); // optimistically transfer tokens
        if (data.length > 0) IUniSlurmCallee(to).UNISLURMCALL850(msg.sender, amount0Out, amount1Out, data);
        balance0 = IERC20(_token0).BALANCEOF875(address(this));
        balance1 = IERC20(_token1).BALANCEOF875(address(this));
        }
        uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
        require(amount0In > 0 || amount1In > 0, 'UniSlurm: INSUFFICIENT_INPUT_AMOUNT');
        { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
        uint balance0Adjusted = balance0.MUL16(1000).SUB229(amount0In.MUL16(3));
        uint balance1Adjusted = balance1.MUL16(1000).SUB229(amount1In.MUL16(3));
        require(balance0Adjusted.MUL16(balance1Adjusted) >= uint(_reserve0).MUL16(_reserve1).MUL16(1000**2), 'UniSlurm: K');
        }

        _UPDATE859(balance0, balance1, _reserve0, _reserve1);
        emit SWAP447(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
    }

    // force balances to match reserves
    function SKIM266(address to) external LOCK137 {	//inject NONSTANDARD NAMING
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        _SAFETRANSFER205(_token0, to, IERC20(_token0).BALANCEOF875(address(this)).SUB229(reserve0));
        _SAFETRANSFER205(_token1, to, IERC20(_token1).BALANCEOF875(address(this)).SUB229(reserve1));
    }

    // force reserves to match balances
    function SYNC778() external LOCK137 {	//inject NONSTANDARD NAMING
        _UPDATE859(IERC20(token0).BALANCEOF875(address(this)), IERC20(token1).BALANCEOF875(address(this)), reserve0, reserve1);
    }
}


contract UniSlurmFactory is IUniSlurmFactory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PAIRCREATED643(address indexed token0, address indexed token1, address pair, uint);	//inject NONSTANDARD NAMING

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function ALLPAIRSLENGTH196() external view returns (uint) {	//inject NONSTANDARD NAMING
        return allPairs.length;
    }

    function CREATEPAIR935(address tokenA, address tokenB) external returns (address pair) {	//inject NONSTANDARD NAMING
        require(tokenA != tokenB, 'UniSlurm: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'UniSlurm: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'UniSlurm: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(UniSlurmPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IUniSlurmPair(pair).INITIALIZE278(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PAIRCREATED643(token0, token1, pair, allPairs.length);
    }

    function SETFEETO183(address _feeTo) external {	//inject NONSTANDARD NAMING
        require(msg.sender == feeToSetter, 'UniSlurm: FORBIDDEN');
        feeTo = _feeTo;
    }

    function SETFEETOSETTER227(address _feeToSetter) external {	//inject NONSTANDARD NAMING
        require(msg.sender == feeToSetter, 'UniSlurm: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }
}