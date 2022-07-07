/**
 *Submitted for verification at Etherscan.io on 2020-07-12
*/

// File: contracts/libraries/SafeMath.sol

pragma solidity =0.5.16;

// a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x, 'ds-math-add-overflow');
    }

    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x, 'ds-math-sub-underflow');
    }

    function mul(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
    }
}

// File: contracts/interfaces/IDeerfiV1FeedPair.sol

pragma solidity >=0.5.0;

interface IDeerfiV1FeedPair {
    function factory() external view returns (address);
    function tokenA() external view returns (address);
    function tokenB() external view returns (address);
    function decimalsA() external view returns (uint8);
    function decimalsB() external view returns (uint8);
    function aggregator0() external view returns (address);
    function aggregator1() external view returns (address);
    function decimals0() external view returns (uint8);
    function decimals1() external view returns (uint8);
    function isReverse0() external view returns (bool);
    function isReverse1() external view returns (bool);
    function initialize(address, address, uint8, uint8, address, address, uint8, uint8, bool, bool) external;
    function getReserves() external view returns (uint reserveA, uint reserveB);
}

// File: contracts/interfaces/AggregatorInterface.sol

pragma solidity >=0.5.0;

interface AggregatorInterface {
  event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
  event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);

  function latestAnswer() external view returns (int256);
  function latestTimestamp() external view returns (uint256);
  function latestRound() external view returns (uint256);
  function getAnswer(uint256 roundId) external view returns (int256);
  function getTimestamp(uint256 roundId) external view returns (uint256);

  // post-Historic

  function decimals() external view returns (uint8);
  function description() external view returns (string memory);
  function getRoundData(uint256 _roundId)
    external
    view
    returns (
      uint256 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint256 answeredInRound
    );
  function latestRoundData()
    external
    view
    returns (
      uint256 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint256 answeredInRound
    );
  function version() external view returns (uint256);
}

// File: contracts/DeerfiV1FeedPair.sol

pragma solidity =0.5.16;




contract DeerfiV1FeedPair is IDeerfiV1FeedPair {
    using SafeMath for uint;

    address public factory;
    address public tokenA;
    address public tokenB;
    uint8 public decimalsA;
    uint8 public decimalsB;
    address public aggregator0;
    address public aggregator1;
    uint8 public decimals0;
    uint8 public decimals1;
    bool public isReverse0;
    bool public isReverse1;

    constructor() public {
        factory = msg.sender;
    }

    function initialize(address _tokenA, address _tokenB, uint8 _decimalsA, uint8 _decimalsB,
        address _aggregator0, address _aggregator1, uint8 _decimals0, uint8 _decimals1, bool _isReverse0, bool _isReverse1) external {
        require(tx.origin == factory, 'DeerfiV1: FORBIDDEN'); // sufficient check	//inject USING TX ORIGIN FOR AUTHENTICATION

        require(_tokenA != _tokenB, 'DeerfiV1: IDENTICAL_ADDRESSES');
        (address token0,) = _tokenA < _tokenB ? (_tokenA, _tokenB) : (_tokenB, _tokenA);
        require(token0 != address(0), 'DeerfiV1: ZERO_ADDRESS');
        require(_decimalsA > 0, 'DeerfiV1: FORBIDDEN');
        require(_decimalsB > 0, 'DeerfiV1: FORBIDDEN');
        require(_aggregator0 != address(0), 'DeerfiV1: ZERO_ADDRESS');
        require(_decimals0 > 0, 'DeerfiV1: FORBIDDEN');
        require(_decimals1 > 0, 'DeerfiV1: FORBIDDEN');

        tokenA = _tokenA;
        tokenB = _tokenB;
        decimalsA = _decimalsA;
        decimalsB = _decimalsB;
        aggregator0 = _aggregator0;
        aggregator1 = _aggregator1;
        decimals0 = _decimals0;
        decimals1 = _decimals1;
        isReverse0 = _isReverse0;
        isReverse1 = _isReverse1;
    }

    function getReserves0() internal view returns (uint reserveA, uint reserveB) {
        AggregatorInterface _aggregator0 = AggregatorInterface(aggregator0);
        if (isReverse0) {
            reserveA = uint(_aggregator0.latestAnswer());
            reserveB = 10 ** uint(decimals0);
        } else {
            reserveA = 10 ** uint(decimals0);
            reserveB = uint(_aggregator0.latestAnswer());
        }
    }

    function getReserves1() internal view returns (uint reserveA, uint reserveB) {
        AggregatorInterface _aggregator1 = AggregatorInterface(aggregator1);
        if (isReverse1) {
            reserveA = uint(_aggregator1.latestAnswer());
            reserveB = 10 ** uint(decimals1);
        } else {
            reserveA = 10 ** uint(decimals1);
            reserveB = uint(_aggregator1.latestAnswer());
        }
    }

    function getReserves() external view returns (uint reserveA, uint reserveB) {
        uint8 _decimalsA = decimalsA;
        uint8 _decimalsB = decimalsB;
        uint8 _decimals0 = decimals0;
        uint8 _decimals1 = decimals1;
        if (aggregator1 == address(0)) {
            (uint reserve0A, uint reserve0B) = getReserves0();
            reserveA = reserve0A.mul(10 ** uint(_decimalsA)) / (10 ** uint(_decimals0));
            reserveB = reserve0B.mul(10 ** uint(_decimalsB)) / (10 ** uint(_decimals0));
        } else {
            (uint reserve0A, uint reserve0B) = getReserves0();
            (uint reserve1A, uint reserve1B) = getReserves1();
            reserveA = reserve0A.mul(reserve1A).mul(10 ** uint(_decimalsA)) / (10 ** uint(_decimals0)) / (10 ** uint(_decimals1));
            reserveB = reserve0B.mul(reserve1B).mul(10 ** uint(_decimalsB)) / (10 ** uint(_decimals0)) / (10 ** uint(_decimals1));
        }
    }
}