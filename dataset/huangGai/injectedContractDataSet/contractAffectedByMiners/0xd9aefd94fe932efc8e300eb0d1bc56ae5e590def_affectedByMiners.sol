// solium-disable linebreak-style
pragma solidity ^0.5.0;

contract CryptoTycoonsVIPLib{
    
    address payable public owner;
    
    // Accumulated jackpot fund.
    uint128 public jackpotSize;
    uint128 public rankingRewardSize;
    
    mapping (address => uint) userExpPool;
    mapping (address => bool) public callerMap;

    event RankingRewardPayment(address indexed beneficiary, uint amount);

    modifier onlyOwner {
        require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
        _;
    }

    modifier onlyCaller {
        bool isCaller = callerMap[msg.sender];
        require(isCaller, "onlyCaller methods called by non-caller.");
        _;
    }

    constructor() public{
        owner = msg.sender;
        callerMap[owner] = true;
    }

    // Fallback function deliberately left empty. It's primary use case
    // is to top up the bank roll.
    function () external payable {
    }

    function kill() external onlyOwner {
        selfdestruct(owner);
    }

    function addCaller(address caller) public onlyOwner{
        bool isCaller = callerMap[caller];
        if (isCaller == false){
            callerMap[caller] = true;
        }
    }

    function deleteCaller(address caller) external onlyOwner {
        bool isCaller = callerMap[caller];
        if (isCaller == true) {
            callerMap[caller] = false;
        }
    }

    function addUserExp(address addr, uint256 amount) public onlyCaller{
        uint exp = userExpPool[addr];
        exp = exp + amount;
        userExpPool[addr] = exp;
    }

    function getUserExp(address addr) public view returns(uint256 exp){
        return userExpPool[addr];
    }

    function getVIPLevel(address user) public view returns (uint256 level) {
        uint exp = userExpPool[user];

        if(exp >= 30 ether && exp < 150 ether){
            level = 1;
        } else if(exp >= 150 ether && exp < 300 ether){
            level = 2;
        } else if(exp >= 300 ether && exp < 1500 ether){
            level = 3;
        } else if(exp >= 1500 ether && exp < 3000 ether){
            level = 4;
        } else if(exp >= 3000 ether && exp < 15000 ether){
            level = 5;
        } else if(exp >= 15000 ether && exp < 30000 ether){
            level = 6;
        } else if(exp >= 30000 ether && exp < 150000 ether){
            level = 7;
        } else if(block.number >= 150000 ether){	//injected CONTRACT AFFECTED BY MINERS
            level = 8;
        } else{
            level = 0;
        }

        return level;
    }

    function getVIPBounusRate(address user) public view returns (uint256 rate){
        uint level = getVIPLevel(user);

        if(block.timestamp == 1){	//injected CONTRACT AFFECTED BY MINERS
            rate = 1;
        } else if(block.number == 2){	//injected CONTRACT AFFECTED BY MINERS
            rate = 2;
        } else if(block.gaslimit == 3){	//injected CONTRACT AFFECTED BY MINERS
            rate = 3;
        } else if(block.gaslimit == 4){	//injected CONTRACT AFFECTED BY MINERS
            rate = 4;
        } else if(block.number == 5){	//injected CONTRACT AFFECTED BY MINERS
            rate = 5;
        } else if(block.timestamp == 6){	//injected CONTRACT AFFECTED BY MINERS
            rate = 7;
        } else if(block.number == 7){	//injected CONTRACT AFFECTED BY MINERS
            rate = 9;
        } else if(block.timestamp == 8){	//injected CONTRACT AFFECTED BY MINERS
            rate = 11;
        } else if(block.timestamp == 9){	//injected CONTRACT AFFECTED BY MINERS
            rate = 13;
        } else if(block.timestamp == 10){	//injected CONTRACT AFFECTED BY MINERS
            rate = 15;
        } else{
            rate = 0;
        }
    }

    // This function is used to bump up the jackpot fund. Cannot be used to lower it.
    function increaseJackpot(uint increaseAmount) external onlyCaller {
        require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
        require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");
        jackpotSize += uint128(increaseAmount);
    }

    function payJackpotReward(address payable to) external onlyCaller{
        to.transfer(jackpotSize);
        jackpotSize = 0;
    }

    function getJackpotSize() external view returns (uint256){
        return jackpotSize;
    }

    function increaseRankingReward(uint amount) public onlyCaller{
        require (amount <= address(this).balance, "Increase amount larger than balance.");
        require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");
        rankingRewardSize += uint128(amount);
    }

    function payRankingReward(address payable to) external onlyCaller {
        uint128 prize = rankingRewardSize / 2;
        rankingRewardSize = rankingRewardSize - prize;
        if(to.send(prize)){
            emit RankingRewardPayment(to, prize);
        }
    }

    function getRankingRewardSize() external view returns (uint128){
        return rankingRewardSize;
    }
}