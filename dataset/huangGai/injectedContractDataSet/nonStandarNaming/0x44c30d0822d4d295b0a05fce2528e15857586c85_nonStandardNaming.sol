                                                                 

pragma solidity ^0.5.7;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  

contract ERC20Token
{
    mapping (address => uint256) public balanceOf;
    function TRANSFER650(address _to, uint256 _value) public;	//inject NONSTANDARD NAMING
}

library SafeMath {
                                                                                                                                                                                                                             
    function ADD696(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB727(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL579(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV93(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD838(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract PZMT_20_Plus
{
    using SafeMath for uint256;
    
    address payable public owner = 0x76E40e08e10c8D7D088b20D26349ec52932F8BC3;
    
    uint256 minBalance = 100;
    ERC20Token PZM_Token = ERC20Token(0x71ee6E4fD5F2E70eD5e6fBAf853AE3B223564BCa);
    
    struct InvestorData {
        uint256 funds;
        uint256 lastDatetime;
        uint256 totalProfit;
    }
    mapping (address => InvestorData) investors;
    
    modifier ONLYOWNER245()	//inject NONSTANDARD NAMING
    {
        assert(msg.sender == owner);
        _;
    }
    
    function WITHDRAW99(uint256 amount)  public ONLYOWNER245 {	//inject NONSTANDARD NAMING
        owner.transfer(amount);
    }
    
    function CHANGEOWNER707(address payable newOwner) public ONLYOWNER245 {	//inject NONSTANDARD NAMING
        owner = newOwner;
    }
    
    function CHANGEMINBALANCE924(uint256 newMinBalance) public ONLYOWNER245 {	//inject NONSTANDARD NAMING
        minBalance = newMinBalance;
    }
    
    function BYTESTOADDRESS738(bytes memory bys) private pure returns (address payable addr) {	//inject NONSTANDARD NAMING
        assembly {
          addr := mload(add(bys,20))
        } 
    }
    // function for transfer any token from contract
    function TRANSFERTOKENS239 (address token, address target, uint256 amount) ONLYOWNER245 public	//inject NONSTANDARD NAMING
    {
        ERC20Token(token).TRANSFER650(target, amount);
    }
    
    function GETINFO234(address investor) view public returns (uint256 totalFunds, uint256 pendingReward, uint256 totalProfit, uint256 contractBalance)	//inject NONSTANDARD NAMING
    {
        InvestorData memory data = investors[investor];
        totalFunds = data.funds;
        if (data.funds > 0) pendingReward = data.funds.MUL579(20).DIV93(100).MUL579(block.timestamp - data.lastDatetime).DIV93(30 days);
        totalProfit = data.totalProfit;
        contractBalance = address(this).balance;
    }
    
    function() payable external
    {
        assert(msg.sender == tx.origin); // prevent bots to interact with contract
        
        if (msg.sender == owner) return;
        
        assert(PZM_Token.balanceOf(msg.sender) >= minBalance * 10**18);
        
        
        InvestorData storage data = investors[msg.sender];
        
        if (msg.value > 0)
        {
            // first investment at least 2 ether, all next at least 0.01 ether
            assert(msg.value >= 0.2 ether || (data.funds != 0 && msg.value >= 0.01 ether));
            if (msg.data.length == 20) {
                address payable ref = BYTESTOADDRESS738(msg.data);
                assert(ref != msg.sender);
                ref.transfer(msg.value.MUL579(10).DIV93(100));   // 10%
                owner.transfer(msg.value.MUL579(5).DIV93(100));  // 5%
            } else if (msg.data.length == 0) {
                owner.transfer(msg.value.MUL579(15).DIV93(100));
            } else {
                assert(false); // invalid memo
            }
        }
        
        
        if (data.funds != 0) {
            // 20% per 30 days
            uint256 reward = data.funds.MUL579(20).DIV93(100).MUL579(block.timestamp - data.lastDatetime).DIV93(30 days);
            data.totalProfit = data.totalProfit.ADD696(reward);
            
            address(msg.sender).transfer(reward);
        }

        data.lastDatetime = block.timestamp;
        data.funds = data.funds.ADD696(msg.value.MUL579(85).DIV93(100));
        
    }
}