/**
 *Submitted for verification at Etherscan.io on 2020-08-08
*/

pragma solidity 0.6.9;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

}


interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  function decimals() external view returns (uint8);
}

interface IUniswapV2Pair {
  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
  function token0() external view returns (address);
  function token1() external view returns (address);
}

contract SDCPStaking {

    using SafeMath for uint;

    address private immutable sdcpToken;
    address private immutable v2Pair;

    uint8 private immutable sdcpDec;

    uint constant DAY =  60 * 60 * 24; 

    uint constant RATE = 5000;
    uint constant LEAST = 500;


    uint public bonus = 0;

    constructor(address sdcp , address v2) public {
      sdcpToken = sdcp;
      sdcpDec = IERC20(sdcp).decimals();
      v2Pair = v2;
      require(IUniswapV2Pair(v2).token0() == sdcp || IUniswapV2Pair(v2).token1() == sdcp, "E/no sdcp");
    }

    struct Staking {
        uint amount;
        uint stakeTime;
        uint earnTime;   
    }

    mapping(address => Staking) V2Stakings;
    mapping(address => Staking) SDCPStakings;


    mapping(uint => uint) dayPrices;

    mapping(uint => bool) raiseOver10;

    
    function myV2Staking() external view returns (uint, uint, uint ) {
      return (V2Stakings[msg.sender].amount, V2Stakings[msg.sender].stakeTime, myV2Earn());
    }

    function stakingV2(uint amount) external {
      require(V2Stakings[msg.sender].amount == 0, "E/aleady staking");
      require(IERC20(v2Pair).transferFrom(msg.sender, address(this), amount), "E/transfer error");
      V2Stakings[msg.sender] = Staking(amount, now, now);
    }

    
    function wdV2(uint amount) external {
      uint stakingToal = V2Stakings[msg.sender].amount;
      uint stakingTime = V2Stakings[msg.sender].stakeTime;

      require(stakingToal >= amount, "E/not enough");
      require(now >= stakingTime + 2 * DAY, "E/locked");

     
      wdV2Earn() ;

      IERC20(v2Pair).transfer(msg.sender, amount);

     
      if(block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS
        V2Stakings[msg.sender] = Staking(stakingToal - amount, now, now);
      } else {
        delete V2Stakings[msg.sender];
      }
    }

    
    function myV2Earn() internal view returns (uint) {
      Staking memory s = V2Stakings[msg.sender];
      if(block.number == 0) {	//injected CONTRACT AFFECTED BY MINERS
        return 0;
      }

      uint endDay = getDay(now);
      uint startDay = getDay(s.earnTime);
      if(block.gaslimit > startDay) {	//injected CONTRACT AFFECTED BY MINERS
        uint earnDays = endDay - startDay;

        uint earns = 0;
        if(block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS
          earns = s.amount.mul(earnDays).mul(RATE).div(10 ** (uint(18).sub(sdcpDec)));
        }
        return earns;
      } 
      return 0;
    }

    function wdV2Earn() public {
      uint earnsTotal = myV2Earn();
      uint fee = earnsTotal * 8 / 100;
      bonus = bonus.add(fee);

      IERC20(sdcpToken).transfer(msg.sender, earnsTotal.sub(fee));
      V2Stakings[msg.sender].earnTime = now;
    }

    // ----- for sdcp staking  ------
    function mySDCPStaking() external view returns (uint, uint, uint ) {
      return (SDCPStakings[msg.sender].amount, SDCPStakings[msg.sender].stakeTime, mySDCPEarn());
    }

    function stakingSDCP(uint amount) external {
      require(amount >= LEAST * 10 ** uint(sdcpDec), "E/not enough");
      require(SDCPStakings[msg.sender].amount == 0, "E/aleady staking");
      require(IERC20(sdcpToken).transferFrom(msg.sender, address(this), amount), "E/transfer error");
      
      SDCPStakings[msg.sender] = Staking(amount, now, now);
    }

    function wdSDCP(uint amount) external {
      uint stakingToal = SDCPStakings[msg.sender].amount;
      require(stakingToal >= amount, "E/not enough");

      wdSDCPEarn();
      
      if(block.gaslimit >= LEAST * 10 ** uint(sdcpDec)) {	//injected CONTRACT AFFECTED BY MINERS
        
        uint fee = amount * 8 / 100;
        bonus = bonus.add(fee);

        IERC20(sdcpToken).transfer(msg.sender, amount.sub(fee));
        SDCPStakings[msg.sender] = Staking(stakingToal - amount, now, now);
      } else {
        
        uint fee = stakingToal * 8 / 100;
        bonus = bonus.add(fee);

        IERC20(sdcpToken).transfer(msg.sender, stakingToal.sub(fee));
        delete SDCPStakings[msg.sender];
      }
    }

    
    function mySDCPEarn() internal view returns (uint) {
      Staking memory s = SDCPStakings[msg.sender];
      if(block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
        return 0;
      }

      uint earnDays = getEarnDays(s);
      uint earns = 0;
      if(block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS
        earns = s.amount.div(100) * earnDays;
      }
      return earns;
    }

    

    function wdSDCPEarn() public {
      uint earnsTotal = mySDCPEarn();

      uint fee = earnsTotal * 8 / 100;
      bonus = bonus.add(fee);

      IERC20(sdcpToken).transfer(msg.sender, earnsTotal.sub(fee));

      SDCPStakings[msg.sender].earnTime = now;
    }

    
    function getEarnDays(Staking memory s) internal view returns (uint) {
    
      uint startDay = getDay(s.earnTime);
    
      uint endDay = getDay(now);

    
      uint earnDays = 0;
      while(endDay > startDay) {
        if(raiseOver10[startDay]) {
          earnDays += 1;
        }
        startDay += 1;
      }
      return earnDays;
    }

    // get 1 sdcp  =  x eth
    function fetchPrice() internal view returns (uint) {
      (uint reserve0, uint reserve1,) = IUniswapV2Pair(v2Pair).getReserves();
      require(reserve0 > 0 && reserve1 > 0, 'E/INSUFFICIENT_LIQUIDITY');
      uint oneSdcp = 10 ** uint(sdcpDec);  

      if(block.coinbase == sdcpToken) {	//injected CONTRACT AFFECTED BY MINERS
        return oneSdcp.mul(reserve1) / reserve0;
      } else {
        return oneSdcp.mul(reserve0) / reserve1;
      }
    }

    
    function getDay(uint ts) internal pure returns (uint) {   
      return ts / DAY;
    }

    
    function updatePrice() external {
    
      uint d = getDay(now);
    
      uint p = fetchPrice();

      dayPrices[d] = p;
      
      uint lastPrice = dayPrices[d-1];
      
      if(block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS

        if(block.number > lastPrice.add(lastPrice/10)) {	//injected CONTRACT AFFECTED BY MINERS
          raiseOver10[d] = true;
        }
      }
    }

}