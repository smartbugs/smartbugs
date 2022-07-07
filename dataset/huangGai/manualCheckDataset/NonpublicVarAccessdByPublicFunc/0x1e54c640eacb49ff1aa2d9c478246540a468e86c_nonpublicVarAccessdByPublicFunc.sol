/**
 *Submitted for verification at Etherscan.io on 2020-10-11
*/

// SPDX-License-Identifier: UNLICENSED

pragma solidity =0.6.12;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;}

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");}

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;}

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {return 0;}
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;}

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");}

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;}

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");}

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;}
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function mint(address account, uint256 amount) external;
    function burn(uint256 amount) external;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Uniswap{
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable returns (uint[] memory amounts);
    function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function WETH() external pure returns (address);
}

interface Pool{
    function primary() external view returns (address);
}

contract Poolable{
    
    address payable internal constant _POOLADDRESS = 0x1fcBB2904908EEddbd3f89324f329493C99a8396;

    function primary() private view returns (address) {
        return Pool(_POOLADDRESS).primary();
    }
    
    modifier onlyPrimary() {
        require(msg.sender == primary(), "Caller is not primary");
        _;
    }
}

contract Staker is Poolable{
    
    using SafeMath for uint256;
    
    uint constant internal DECIMAL = 10**18;
    uint constant internal INF = 33136721748;

    uint private _rewardValue = 10**21;
    
    mapping (address => uint256) internal  timePooled;
    mapping (address => uint256) private internalTime;
    mapping (address => uint256) private LPTokenBalance;
    mapping (address => uint256) private rewards;
    mapping (address => uint256) private referralEarned;

    address internal orbAddress;
    
    address constant internal UNIROUTER         = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address constant internal FACTORY           = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address          internal WETHAddress       = Uniswap(UNIROUTER).WETH();
    
    bool private _unchangeable = false;
    bool private _tokenAddressGiven = false;
    bool internal priceCapped = true;
    
    uint internal creationTime = now;
    
    receive() external payable {
        
        if(msg.sender != UNIROUTER){	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            stake();
        }
    }
    
    function sendValue(address payable recipient, uint256 amount) internal {
        (bool success, ) = recipient.call{ value: amount }(""); 
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    
    //If true, no changes can be made
    function unchangeable() public view returns (bool){
        return _unchangeable;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function rewardValue() public view returns (uint){
        return _rewardValue;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    //THE ONLY ADMIN FUNCTIONS vvvv
    //After this is called, no changes can be made
    function makeUnchangeable() public onlyPrimary{
        _unchangeable = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    //Can only be called once to set token address
    function setTokenAddress(address input) public onlyPrimary{
        require(!_tokenAddressGiven, "Function was already called");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _tokenAddressGiven = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        orbAddress = input;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    //Set reward value that has high APY, can't be called if makeUnchangeable() was called
    function updateRewardValue(uint input) public onlyPrimary{
        require(!unchangeable(), "makeUnchangeable() function was already called");
        _rewardValue = input;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    //Cap token price at 1 eth, can't be called if makeUnchangeable() was called
    function capPrice(bool input) public onlyPrimary {
        require(!unchangeable(), "makeUnchangeable() function was already called");
        priceCapped = input;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    //THE ONLY ADMIN FUNCTIONS ^^^^
    
    function sqrt(uint y) public pure returns (uint z) {
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

    function stake() public payable{
        address staker = msg.sender;
        require(creationTime + 2 hours <= now, "It has not been 2 hours since contract creation yet");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint toMint = (address(this).balance.mul(tokenAmount)).div(ethAmount);
        IERC20(orbAddress).mint(address(this), toMint);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        uint poolTokenAmountBefore = IERC20(poolAddress).balanceOf(address(this));
        
        uint amountTokenDesired = IERC20(orbAddress).balanceOf(address(this));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        IERC20(orbAddress).approve(UNIROUTER, amountTokenDesired ); //allow pool to get tokens	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        Uniswap(UNIROUTER).addLiquidityETH{ value: address(this).balance/2 }(orbAddress, amountTokenDesired, 1, 1, address(this), INF);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        //burn tokens equivalunt 10% of value
        if (msg.value >= 0.01 ether){
            address[] memory path = new address[](2);
            path[0] = WETHAddress;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            path[1] = orbAddress;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            uint[] memory amounts = Uniswap(UNIROUTER).swapExactETHForTokens{ value: address(this).balance*2/10 }(1, path, address(this), INF);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            IERC20(orbAddress).burn(amounts[1]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        sendValue(_POOLADDRESS, address(this).balance);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        if(price() >= (1.05 * 10**18) && priceCapped){	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

            uint t = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            uint a = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            uint x = (sqrt(9*t*t + 3988000*a*t) - 1997*t)/1994;
            
            IERC20(orbAddress).mint(address(this), x);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            
            address[] memory path = new address[](2);
            path[0] = orbAddress;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            path[1] = WETHAddress;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            IERC20(orbAddress).approve(UNIROUTER, x);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            Uniswap(UNIROUTER).swapExactTokensForETH(x, 1, path, _POOLADDRESS, INF);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        
        uint poolTokenAmountAfter = IERC20(poolAddress).balanceOf(address(this));
        uint poolTokenGot = poolTokenAmountAfter.sub(poolTokenAmountBefore);
        
        rewards[staker] = rewards[staker].add(viewRecentRewardTokenAmount(staker));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        timePooled[staker] = now;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        internalTime[staker] = now;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    
        LPTokenBalance[staker] = LPTokenBalance[staker].add(poolTokenGot);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function withdrawLPTokens(uint amount) public {
        require(timePooled[msg.sender] + 8 hours <= now, "It has not been 8 hours since you staked yet");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        LPTokenBalance[msg.sender] = LPTokenBalance[msg.sender].sub(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        IERC20(poolAddress).transfer(msg.sender, amount);
        
        internalTime[msg.sender] = now;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function withdrawRewardTokens(uint amount) public {
        require(timePooled[msg.sender] + 8 hours <= now, "It has not been 8 hours since you staked yet");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        rewards[msg.sender] = rewards[msg.sender].add(viewRecentRewardTokenAmount(msg.sender));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        internalTime[msg.sender] = now;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        uint removeAmount = ethtimeCalc(amount);
        rewards[msg.sender] = rewards[msg.sender].sub(removeAmount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        IERC20(orbAddress).mint(msg.sender, amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function viewRecentRewardTokenAmount(address who) internal view returns (uint){
        return (viewLPTokenAmount(who).mul( now.sub(internalTime[who]) ));
    }
    
    function viewRewardTokenAmount(address who) public view returns (uint){
        return earnCalc( rewards[who].add(viewRecentRewardTokenAmount(who)) );	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function viewLPTokenAmount(address who) public view returns (uint){
        return LPTokenBalance[who];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function viewPooledEthAmount(address who) public view returns (uint){
        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        return (ethAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
    }
    
    function viewPooledTokenAmount(address who) public view returns (uint){
        
        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        return (tokenAmount.mul(viewLPTokenAmount(who))).div(IERC20(poolAddress).totalSupply());
    }
    
    function price() public view returns (uint){
        
        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        uint ethAmount = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint tokenAmount = IERC20(orbAddress).balanceOf(poolAddress); //token in uniswap	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        
        return (DECIMAL.mul(ethAmount)).div(tokenAmount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function ethEarnCalc(uint eth, uint time) public view returns(uint){
        
        address poolAddress = Uniswap(FACTORY).getPair(orbAddress, WETHAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint totalEth = IERC20(WETHAddress).balanceOf(poolAddress); //Eth in uniswap	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        uint totalLP = IERC20(poolAddress).totalSupply();
        
        uint LP = ((eth/2)*totalLP)/totalEth;
        
        return earnCalc(LP * time);
    }

    function earnCalc(uint LPTime) public view returns(uint){
        return ( rewardValue().mul(LPTime)  ) / ( 31557600 * DECIMAL );	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function ethtimeCalc(uint orb) internal view returns(uint){
        return ( orb.mul(31557600 * DECIMAL) ).div( rewardValue() );
    }
}