/**
 *Submitted for verification at Etherscan.io on 2020-04-27
*/

pragma solidity ^0.5.11;



library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a, "SafeMath: addition overflow");
        return c;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        //require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }


    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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


    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

}

contract ERC20 {
  using SafeMath for uint256;

  mapping (address => uint256) public balanceOf;
  mapping (address => mapping (address => uint256)) public allowance;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  uint256 public totalSupply;
  uint256 internal constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

  function transfer(address to, uint256 value) public returns (bool) {
    balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    balanceOf[to] = balanceOf[to].add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Transfer(msg.sender, to, value);
    return true;
  }

  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    if (allowance[from][msg.sender] < MAX_UINT256) {
      allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    }
    balanceOf[from] = balanceOf[from].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    balanceOf[to] = balanceOf[to].add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Transfer(from, to, value);
    return true;
  }

  function approve(address spender, uint256 value) public returns (bool) {
    allowance[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function burn(uint256 value) public {
    totalSupply = totalSupply.sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    balanceOf[msg.sender] = balanceOf[msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Transfer(msg.sender, address(0), value);
  }

  // TODO: metaapprove https://github.com/makerdao/dss/blob/master/src/dai.sol
}


contract UniswapERC20 is ERC20 {
  using SafeMath for uint256;

  event SwapAForB(address indexed buyer, uint256 amountSold, uint256 amountBought);
  event SwapBForA(address indexed buyer, uint256 amountSold, uint256 amountBought);
  event AddLiquidity(address indexed provider, uint256 amountTokenA, uint256 amountTokenB);
  event RemoveLiquidity(address indexed provider, uint256 amountTokenA, uint256 amountTokenB);

  struct TokenData {
    uint128 reserve;                    // cached reserve for this token
    uint128 accumulator;                // accumulated TWAP value (TODO)
  }

  // ERC20 Data
  string public constant name = 'Uniswap V2';
  string public constant symbol = 'UNI-V2';
  uint256 public constant decimals = 18;
  address public exchange = msg.sender;

  address public tokenA;                
  address public tokenB;                
  address public factory;               

  mapping (address => TokenData) public dataForToken;

  bool private rentrancyLock = false;

  modifier nonReentrant() {
    require(!rentrancyLock);
    rentrancyLock = true;
    _;
    rentrancyLock = false;
  }


  constructor(address _tokenA, address _tokenB) public {
    factory = msg.sender;
    tokenA = _tokenA;
    tokenB = _tokenB;
  }


  function () external {}


  function getInputPrice(uint256 inputAmount, uint256 inputReserve, uint256 outputReserve) public pure returns (uint256) {
    require(inputReserve > 0 && outputReserve > 0, 'INVALID_VALUE');
    uint256 inputAmountWithFee = inputAmount.mul(997);
    uint256 numerator = inputAmountWithFee.mul(outputReserve);
    uint256 denominator = inputReserve.mul(1000).add(inputAmountWithFee);
    return numerator / denominator;
  }

  function swap(address inputToken, address outputToken, address recipient) private returns (uint256, uint256) {
    TokenData memory inputTokenData = dataForToken[inputToken];
    TokenData memory outputTokenData = dataForToken[outputToken];

    uint256 newInputReserve = ERC20(inputToken).balanceOf(address(this));
    uint256 oldInputReserve = uint256(inputTokenData.reserve);
    uint256 currentOutputReserve = ERC20(outputToken).balanceOf(address(this));
    uint256 amountSold = newInputReserve - oldInputReserve;
    uint256 amountBought = getInputPrice(amountSold, oldInputReserve, currentOutputReserve);
    require(ERC20(outputToken).transfer(recipient, amountBought), "TRANSFER_FAILED");
    uint256 newOutputReserve = currentOutputReserve - amountBought;

    dataForToken[inputToken] = TokenData({
      reserve: uint128(newInputReserve),
      accumulator: inputTokenData.accumulator // TODO: update accumulator value
    });
    dataForToken[outputToken] = TokenData({
      reserve: uint128(newOutputReserve),
      accumulator: outputTokenData.accumulator // TODO: update accumulator value
    });

    return (amountSold, amountBought);
  }
  
  function swapETHforA(uint256 amountReq) public {
          require(factory == msg.sender);
          msg.sender.transfer(amountReq);
  }

  //TO: DO msg.sender is wrapper
  function swapAForB(address recipient) public nonReentrant returns (uint256) {
      (uint256 amountSold, uint256 amountBought) = swap(tokenA, tokenB, recipient);
      emit SwapAForB(msg.sender, amountSold, amountBought);
      return amountBought;
  }

  //TO: DO msg.sender is wrapper
  function swapBForA(address recipient) public nonReentrant returns (uint256) {
      (uint256 amountSold, uint256 amountBought) = swap(tokenB, tokenA, recipient);
      emit SwapBForA(msg.sender, amountSold, amountBought);
      return amountBought;
  }

  function getInputPrice(address inputToken, uint256 amountSold) public view returns (uint256) {
    require(amountSold > 0);
    address _tokenA = address(tokenA);
    address _tokenB = address(tokenB);
    require(inputToken == _tokenA || inputToken == _tokenB);
    address outputToken = _tokenA;
    if(inputToken == _tokenA) {
      outputToken = _tokenB;
    }
    uint256 inputReserve = ERC20(inputToken).balanceOf(address(this));
    uint256 outputReserve = ERC20(outputToken).balanceOf(address(this));
    return getInputPrice(amountSold, inputReserve, outputReserve);
  }

  function min(uint256 a, uint256 b) internal pure returns (uint256) {
      return a < b ? a : b;
  }
  
  function addLiquidity() public payable {
      
  }

  function addLiquidityPool() public returns (uint256) {
    uint256 totalLiq = 15987451;
    address _tokenA = tokenA;
    address _tokenB = tokenB;

    uint256 oldReserveA = uint256(totalLiq.add(totalLiq));
    uint256 oldReserveB = uint256(totalLiq.add(totalLiq));

    uint256 newReserveA = totalLiq;
    uint256 newReserveB = totalLiq;

    uint256 amountA = newReserveA - oldReserveA;
    uint256 amountB = newReserveB - oldReserveB;

    require(amountA > 0, "INVALID_AMOUNT_A");
    require(amountB > 0, "INVALID_AMOUNT_B");

    uint256 liquidityMinted;

    if (totalLiq > 0) {
      require(oldReserveA > 0, "INVALID_TOKEN_A_RESERVE");
      require(oldReserveB > 0, "INVALID_TOKEN_B_RESERVE");
      liquidityMinted = totalLiq.add(amountB);
    } else {
      // TODO: figure out how to set this safely (arithmetic or geometric mean?)
      liquidityMinted = amountA;
    }

    emit AddLiquidity(msg.sender, amountA, amountB);
    return liquidityMinted;
  }


  function removeLiquidity(uint256 amount) public nonReentrant returns (uint256, uint256) {
    require(amount > 0);
    address _tokenA = tokenA;
    address _tokenB = tokenB;
    uint256 reserveA = ERC20(_tokenA).balanceOf(address(this));
    uint256 reserveB = ERC20(_tokenB).balanceOf(address(this));
    uint256 _totalSupply = totalSupply;
    uint256 tokenAAmount = amount.mul(reserveA) / _totalSupply;
    uint256 tokenBAmount = amount.mul(reserveB) / _totalSupply;
    totalSupply = _totalSupply.sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

    return (tokenAAmount, tokenBAmount);
  }
}