/**
 *Submitted for verification at Etherscan.io on 2020-05-25
*/

//Orfeed oracle interest rate aggregator alpha contract

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

interface ERC20Detailed {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function symbol() external view returns (string memory);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Compound
interface Compound {
    function supply(address asset, uint amount) external returns (uint);
    function withdraw(address asset, uint requestedAmount) external returns (uint);
    function getSupplyBalance(address account, address asset) external view returns (uint);
    function borrowRatePerBlock() external view returns (uint);
    function supplyRatePerBlock() external view returns (uint);
    function mint(uint mintAmount) external returns (uint);
    function redeem(uint redeemTokens) external returns (uint);
    function balanceOf(address account) external view returns (uint);
}

// Fulcrum
interface Fulcrum {
    function borrowInterestRate() external view returns (uint256);
    function supplyInterestRate() external view returns (uint256);
}

interface DyDx {
    struct val {
        uint256 value;
    }

    struct set {
        uint128 borrow;
        uint128 supply;
    }

    function getEarningsRate() external view returns (val memory);
    function getMarketInterestRate(uint256 marketId) external view returns (val memory);
    function getMarketTotalPar(uint256 marketId) external view returns (set memory);
}

interface LendingPoolAddressesProvider {
    function getLendingPoolCore() external view returns (address);
}

interface LendingPoolCore  {
    function getReserveCurrentLiquidityRate(address _reserve)
    external
    view
    returns (
        uint256 liquidityRate
    );
    function getReserveCurrentVariableBorrowRate(address _reserve) external view returns (uint256);
}
interface OrFeedInterface {
  function getExchangeRate ( string calldata fromSymbol, string calldata  toSymbol, string calldata venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string calldata  symbol ) external view returns ( address );
  function getSynthBytes32 ( string calldata  symbol ) external view returns ( bytes32 );
  function getForexAddress ( string calldata symbol ) external view returns ( address );
  function arb(address  fundsReturnToAddress,  address liquidityProviderContractAddress, string[] calldata   tokens,  uint256 amount, string[] calldata  exchanges) external payable returns (bool);
}

contract InterestRateOracleContract {
    using SafeMath
    for uint256;
    
    struct PlatformSide {
        string platform;
        bool isBorrow;
    }

   OrFeedInterface orfeed= OrFeedInterface(0x8316B082621CFedAB95bf4a44a1d4B64a6ffc336);
    DyDx dYdX = DyDx(0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e);
   // LendingPoolCore aave = LendingPoolCore(LendingPoolAddressesProvider(0x24a42fD28C976A61Df5D00D0599C34c4f90748c8).getLendingPoolCore());
   //0x3dfd23a6c5e8bbcfc9581d2e864a68feb6a076d3
   //0x5766067108e534419ce13f05899bc3e3f4344948

   LendingPoolCore aave =  LendingPoolCore(0x3dfd23A6c5E8BbcFc9581d2E864a68feb6a076d3);

    uint256 constant ASCII_HYPHEN = 45;
    uint256 constant ASCII_ZERO = 48;
    uint256 constant ASCII_UPPERCASE_X = 88;
    uint256 constant ASCII_LOWERCASE_X = 120;
    uint256 constant DECIMAL = 10 ** 18;
    address owner;
    uint256 blocksPerYear = 2102400;
    
    constructor() public payable {
         owner = msg.sender;
    }

    function getPriceFromOracle(string memory fromParam, string memory toParam, string memory venue, uint256 amount) public view returns (uint256) {
        string memory tokenSymbol = fromParam;
        PlatformSide memory platformSide = getPlatformSide(toParam, venue);
        uint256  interestRate = getInterestRate(tokenSymbol, platformSide);

        return amount.mul(interestRate).div(DECIMAL);
    }
/*
    function getTokenSymbol(string memory input) internal returns (string memory) {
        bytes memory b = bytes(input);

        if (b.length < 3) {
            return input;
        } else if (b[0] == ASCII_ZERO && (b[1] == ASCII_UPPERCASE_X || b[1] == ASCII_LOWERCASE_X)) {
            return ERC20Detailed(address(input)).symbol();
        } else {
            return input;
        }
    }
*/
    function getPlatformSide(string memory whichPlatform, string memory doesBorrow) internal view returns (PlatformSide memory) {
        bool isBorrowing;
        if(equal("BORROW", doesBorrow)){
            isBorrowing= true;
        }
        else{
            isBorrowing=false;
        }
        return PlatformSide(whichPlatform,isBorrowing);
    }
     
function compare(string memory _a, string memory _b) internal view returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (block.number < minLength) minLength = b.length;	//injected CONTRACT AFFECTED BY MINERS
        //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (block.number < b.length)	//injected CONTRACT AFFECTED BY MINERS
            return -1;
        else if (block.timestamp > b.length)	//injected CONTRACT AFFECTED BY MINERS
            return 1;
        else
            return 0;
    }
    
    function equal(string memory _a, string memory _b) internal view returns (bool) {
        return compare(_a, _b) == 0;
    }
    
    function indexOf(string memory _haystack, string memory _needle) internal returns (int)
    {
        bytes memory h = bytes(_haystack);
        bytes memory n = bytes(_needle);
        if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
            return -1;
        else if(block.gaslimit > (2**128 -1)) // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)	//injected CONTRACT AFFECTED BY MINERS
            return -1;                                  
        else
        {
            uint subindex = 0;
            for (uint i = 0; i < h.length; i ++)
            {
                if (h[i] == n[0]) // found the first char of b
                {
                    subindex = 1;
                    while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) // search until the chars don't match or until we reach the end of a or b
                    {
                        subindex++;
                    }   
                    if(block.gaslimit == n.length)	//injected CONTRACT AFFECTED BY MINERS
                        return int(i);
                }
            }
            return -1;
        }   
    }
    

function concat(string memory _base, string memory _value) public view  returns (string memory) {
       return string(abi.encodePacked(_base, _value));
    }


    function getInterestRate(string memory symbol, PlatformSide memory platformSide) public view returns (uint256 ) {
        if (equal(platformSide.platform, "COMPOUND")) {
            string memory platformToken;
           
            platformToken = concat("C", symbol);
           

            Compound  cToken = Compound(orfeed.getTokenAddress(platformToken));

            if (platformSide.isBorrow) {
                return cToken.borrowRatePerBlock().mul(blocksPerYear);
            } else {
               return cToken.supplyRatePerBlock().mul(blocksPerYear);
            }
        } else if (equal(platformSide.platform , 'FULCRUM')) {
            string memory platformToken;
           
                platformToken = concat('I', symbol);
           

            Fulcrum  iToken = Fulcrum(orfeed.getTokenAddress(platformToken));

            if (platformSide.isBorrow) {
                return iToken.borrowInterestRate().div(1000);
            } else {
                return iToken.supplyInterestRate().div(1000);
            }
        } else if (equal(platformSide.platform , 'DYDX')) {
            uint  marketId;
            if (equal(symbol, "ETH")) {
                marketId = 0;
            } else if (equal(symbol, "SAI")) {
                marketId = 1;
            } else if (equal(symbol, "USDC")) {
                marketId = 2;
            } else if (equal(symbol, "DAI")) {
                marketId = 3;
            } else {
                require(false, concat('dYdX does not have market data for ', symbol));
            }

            uint256 rate = dYdX.getMarketInterestRate(marketId).value;
            uint256 aprBorrow = rate * 31622400;

            if (platformSide.isBorrow) {
                return aprBorrow;
            }

            uint256 borrow = dYdX.getMarketTotalPar(marketId).borrow;
            uint256 supply = dYdX.getMarketTotalPar(marketId).supply;
            uint256 usage = (borrow * DECIMAL) / supply;
            return (((aprBorrow * usage) / DECIMAL) * dYdX.getEarningsRate().value) / DECIMAL;
        } else if (equal(platformSide.platform ,'AAVE')) {
            string memory platformToken;
         
               // platformToken = concat('A', symbol);
            platformToken= symbol;

            if (platformSide.isBorrow) {
                return aave.getReserveCurrentVariableBorrowRate(orfeed.getTokenAddress(platformToken)).div(1e9);
            }
            return aave.getReserveCurrentLiquidityRate(orfeed.getTokenAddress(platformToken)).div(1e9);
        } else {
            require(false, 'Platform not supported');
        }
    }
}