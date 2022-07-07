/**
 *Submitted for verification at Etherscan.io on 2020-06-03
*/

pragma solidity >=0.6.8;
//vip exchange coin 
// vipex.co
// SPDX-License-Identifier: MIT

contract ownerShip    
{
    
    address payable public owner;

    address payable public newOwner;

    bool public safeGuard ; 

    
    event OwnershipTransferredEv(address payable indexed previousOwner, address payable indexed newOwner);

    constructor() public 
    {
        
        owner = msg.sender;
        
        safeGuard = false;

    }
    
    
    modifier onlyOwner() 
    {
        require(msg.sender == owner);
        _;
    }


    function transferOwnership(address payable _newOwner) public onlyOwner 
    {
        newOwner = _newOwner;
    }


    function acceptOwnership() public 
    {
        require(msg.sender == newOwner);
        emit OwnershipTransferredEv(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

    function changesafeGuardStatus() onlyOwner public
    {
        if (safeGuard == false)
        {
            safeGuard = true;
        }
        else
        {
            safeGuard = false;    
        }
    }

}

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
    
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

   
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
       
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        

        return c;
    }

    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract tokenERC20 is  ownerShip
{
    
    using SafeMath for uint256;
    bytes23 public name;
    bytes8 public symbol;
    uint8 public decimals; 
    uint256 public totalSupply;
    uint256 public totalMintAfterInitial;
    uint256 public maximumSupply;

    uint public burningRate = 500;    // 500=5%

    
    struct userBalance 
    {
        uint256 totalValue;
        uint256 freezeValue;
        uint256 freezeDate;
        uint256 meltValue;    
    }

    
    mapping (address => mapping (address => userBalance)) public tokens;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
   
    mapping (address => bool) public frozenAccount;
        
    
    event FrozenFunds(address target, bool frozen);
    
    
    event Transfer(address indexed from, address indexed to, uint256 value);
  
    
    event Burn(address indexed from, uint256 value);

     
    function calculatePercentage(uint256 PercentOf, uint256 percentTo ) internal pure returns (uint256) 
    {
        uint256 factor = 10000;
        require(percentTo <= factor);
        uint256 c = PercentOf.mul(percentTo).div(factor);
        return c;
    }   

    function setBurningRate(uint _burningRate) onlyOwner public returns(bool success)
    {
        burningRate = _burningRate;
        return true;
    }

   
    struct tokenTypeData
    {
        bytes23 tokenName;
        bytes8 tokenSymbol;
        uint decimalCount;
        uint minFreezingValue;
        uint rateFactor;      
        uint perDayFreezeRate;   
        bool freezingAllowed;   
    }
    
    mapping (address => tokenTypeData) public tokenTypeDatas;

    constructor () public {
    	decimals = 18; 
        totalSupply = 150000000000000000000000000;       
        maximumSupply = 200000000000000000000000000;
        balanceOf[msg.sender]=totalSupply;       
        tokens[address(this)][owner].totalValue = balanceOf[msg.sender];
        name = "Vipex Coin";                           
        symbol = "VPX";                       

       
        tokenTypeData memory temp;

        temp.tokenName=name;
        temp.tokenSymbol=symbol;
        temp.decimalCount=decimals;
        temp.minFreezingValue=100;
        temp.rateFactor=10000;     
        temp.perDayFreezeRate=1;   
        temp.freezingAllowed=true;  
        tokenTypeDatas[address(this)] = temp;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
         
        function _transfer(address _from, address _to, uint _value) internal {
            require(!safeGuard,"safeGuard Active");
			require (_to != address(0),"to is address 0");                               
			require (balanceOf[_from] >= _value, "no balance in from");               
			require (balanceOf[_to].add(_value) >= balanceOf[_to],"overflow balance"); 
			require(!frozenAccount[_from],"from account frozen");                     
			require(!frozenAccount[_to],"to account frozen");                       
			balanceOf[_from] = balanceOf[_from].sub(_value);    
            tokens[address(this)][_from].totalValue = tokens[address(this)][_from].totalValue.sub(_value); 
			balanceOf[_to] = balanceOf[_to].add(_value);        
            tokens[address(this)][_to].totalValue = tokens[address(this)][_to].totalValue.add(_value);            
            uint burnValue;
            if(!(msg.sender == owner || msg.sender == address(this)))   
            {
                burnValue = calculatePercentage(_value,burningRate); 
                require(burnInternal(_to, burnValue),"burning failed");   
            }
			emit Transfer(_from, _to,_value);
            
        } 

        function burnInternal(address _burnFrom, uint _burnValue) internal returns(bool success)
        {   
            require(!safeGuard,"safeGuard Active");
            require(_burnFrom != address(0));
            require(balanceOf[_burnFrom] >= _burnValue);   
			require(!frozenAccount[_burnFrom],"to account frozen");                       
			balanceOf[_burnFrom] = balanceOf[_burnFrom].sub(_burnValue);    
            tokens[address(this)][_burnFrom].totalValue = tokens[address(this)][_burnFrom].totalValue.sub(_burnValue); 
			balanceOf[address(0)] = balanceOf[address(0)].add(_burnValue);        
            tokens[address(this)][address(0)].totalValue = tokens[address(this)][address(0)].totalValue.add(_burnValue);            
            totalSupply = totalSupply.sub(_burnValue);            
			emit Transfer(_burnFrom, address(0),_burnValue);                         
            return true;            
        }

		function mintInternal(uint256 mintedAmount)  internal returns (bool success) {                         
			totalSupply = totalSupply.add(mintedAmount);
            totalMintAfterInitial = totalMintAfterInitial.add(mintedAmount);
            return true;
		}

    function transfer(address _to, uint256 _value) public returns (bool success) {
         _transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(!safeGuard);
        require(_from != address(0),"transfer from adderss(0) is invalid");
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        return true;
    }
    
        
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        require(!safeGuard);
        allowance[msg.sender][_spender] = _value;
        return true;
    }
		
		function mintToken(address target, uint256 mintedAmount)  public onlyOwner returns (bool success) {
			balanceOf[target] = balanceOf[target].add(mintedAmount);	//injected INTEGER OVERFLOW OR UNDERFLOW

            tokens[address(this)][target].totalValue = tokens[address(this)][target].totalValue.add(mintedAmount);	//injected INTEGER OVERFLOW OR UNDERFLOW
 //parallel record for multi token addressing need                         
			totalSupply = totalSupply.add(mintedAmount);	//injected INTEGER OVERFLOW OR UNDERFLOW

            totalMintAfterInitial = totalMintAfterInitial.add(mintedAmount);	//injected INTEGER OVERFLOW OR UNDERFLOW

		 	emit Transfer(address(0), address(this), mintedAmount);
            return true;
		}
		
    function burn(uint256 _value) public onlyOwner returns (bool success) {
        burnInternal(msg.sender, _value);
        return true;
    }
    
        
    function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
        burnInternal(_from, _value);
        return true;
    }
        
}


interface ERC20Necessary {
  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value) external returns (bool);

  function transferFrom(address from, address to, uint256 value) external returns (bool);

  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract VIPEX_COIN is tokenERC20
{

    using SafeMath for uint256;
    
    	
        bool public whitelistingStatus = false;
        mapping (address => bool) public whitelisted;

        
        function changeWhitelistingStatus() onlyOwner public{
            if (whitelistingStatus == false){
			    whitelistingStatus = true;
                whitelisted[owner]= true;
            }
            else{
                whitelistingStatus = false;    
            }
		}
		
		
        function whitelistUser(address userAddress) onlyOwner public{
            require(whitelistingStatus == true);
            require(userAddress != address(0));
            whitelisted[userAddress] = true;
		}    
		


		function freezeAccount(address target, bool freeze) onlyOwner public {
				frozenAccount[target] = freeze;
			emit  FrozenFunds(target, freeze);
		}
        

        function manualWithdrawToken(uint256 _amount) onlyOwner public {
      		uint256 tokenAmount = _amount.mul(100);
            _transfer(address(this), msg.sender, tokenAmount);
        }
          
        
        function manualWithdrawEther()onlyOwner public{
			uint256 amount=address(this).balance;
			owner.transfer(amount);
		}
	    //Airdrop
        function Airdrop(address[] memory recipients,uint[] memory tokenAmount) public onlyOwner returns (bool) {
            uint reciversLength  = recipients.length;
            require(reciversLength <= 150);
            for(uint i = 0; i < reciversLength; i++)
            {
                  //This will loop through all the recipients and send them the specified tokens
                  _transfer(owner, recipients[i], tokenAmount[i]);
            }
            return true;
        }
    

    uint public meltHoldSeconds = 172800;  // 48 Hr. user can withdraw only after this period


    event tokenDepositEv(address token, address user, uint amount, uint balance);
    event tokenWithdrawEv(address token, address user, uint amount, uint balance);

    function setWithdrawWaitingPeriod(uint valueInSeconds) onlyOwner public returns (bool)
    {
        meltHoldSeconds = valueInSeconds;
        return true;
    }

    function newTokenTypeData(address token,bytes23 _tokenName, bytes8 _tokenSymbol, uint _decimalCount, uint _minFreezingValue, uint _rateFactor, uint _perDayFreezeRate) onlyOwner public returns (bool)
    {
        tokenTypeData memory temp;

        temp.tokenName=_tokenName;
        temp.tokenSymbol=_tokenSymbol;
        temp.decimalCount=_decimalCount;
        temp.minFreezingValue=_minFreezingValue;
        temp.rateFactor=_rateFactor;      
        temp.perDayFreezeRate=_perDayFreezeRate;   
        temp.freezingAllowed=true;  
        tokenTypeDatas[token] = temp;
        return true;
    }

    function freezingOnOffForTokenType(address token) onlyOwner public returns (bool)
    {
        if (tokenTypeDatas[token].freezingAllowed == false)
        {
            tokenTypeDatas[token].freezingAllowed = true;
        }
        else
        {
            tokenTypeDatas[token].freezingAllowed = false;    
        } 
        return true;     
    }

    function setMinFreezingValue(address token, uint _minFreezingValue) onlyOwner public returns (bool)
    {
        tokenTypeDatas[token].minFreezingValue = _minFreezingValue;
        return true;
    }

    function setRateFactor(address token, uint _rateFactor) onlyOwner public returns (bool)
    {
        tokenTypeDatas[token].rateFactor = _rateFactor;
        return true;
    }

    function setPerDayFreezeRate(address token, uint _perDayFreezeRate) onlyOwner public returns (bool)
    {
        tokenTypeDatas[token].perDayFreezeRate = _perDayFreezeRate;
        return true;
    }

   
    function tokenDeposit(address token, uint amount) public 
    {
        
        require(token!=address(0),"Address(0) found, can't continue");
        require(ERC20Necessary(token).transferFrom(msg.sender, address(this), amount),"ERC20 'transferFrom' call failed");
        tokens[token][msg.sender].totalValue = tokens[token][msg.sender].totalValue.add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit tokenDepositEv(token, msg.sender, amount, tokens[token][msg.sender].totalValue);
    }

    
    function tokenWithdraw(address token, uint amount) public
    {
        require(!safeGuard,"System Paused By Admin");
        require(token != address(this));
        require(token!=address(0),"Address(0) found, can't continue");
        if(now.sub(meltHoldSeconds) > tokens[token][msg.sender].freezeDate)
        {
           tokens[token][msg.sender].meltValue = 0; 
        }
        require(tokens[token][msg.sender].totalValue.sub(tokens[token][msg.sender].freezeValue.add(tokens[token][msg.sender].meltValue)) >= amount,"Required amount is not free to withdraw");       
        tokens[token][msg.sender].totalValue = tokens[token][msg.sender].totalValue.sub(amount);
        ERC20Necessary(token).transfer(msg.sender, amount);
        emit tokenWithdrawEv(token, msg.sender, amount, tokens[token][msg.sender].totalValue);
    }

    event releaseMyVPXEv(address token, uint amount);
    //releasing after minumum waiting period to withdraw Vipex 
    function releaseMyVPX(address token) public returns (bool)
    {
        require(!safeGuard,"System Paused By Admin");
        require(token!=address(0),"Address(0) found, can't continue");
        require(token == address(this),"Only pissible for VIPEX ");
        require(now.sub(meltHoldSeconds) > tokens[token][msg.sender].freezeDate,"wait period is not over");
        uint amount = tokens[token][msg.sender].meltValue;
        balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
        tokens[token][msg.sender].totalValue = balanceOf[msg.sender].add(tokens[token][msg.sender].freezeValue );
        tokens[token][msg.sender].meltValue = 0; 
        emit releaseMyVPXEv(token, amount);
        return true;
    }

    event tokenBalanceFreezeEv(address token, uint amount, uint earning);


    function tokenBalanceFreeze(address token, uint amount)   public returns (bool)
    {
        require(!safeGuard,"System Paused By Admin");
        require(tokenTypeDatas[token].freezingAllowed,"token type not allowed to freeze");
        require(token!=address(0),"Address(0) found, can't continue");
        address callingUser = msg.sender;
        require(msg.sender != address(0),"Address(0) found, can't continue");

        require(amount <=  tokens[token][callingUser].totalValue.sub(tokens[token][callingUser].freezeValue.add(tokens[token][callingUser].meltValue)) && amount >= tokenTypeDatas[token].minFreezingValue, "less than required or less balance");
        
        uint freezeValue = tokens[token][callingUser].freezeValue;
        uint earnedValue;
        if (freezeValue > 0)
        {
            earnedValue = getEarning(token,callingUser,freezeValue);
            require(mintInternal(earnedValue),"minting failed");
            tokens[address(this)][callingUser].meltValue = tokens[address(this)][callingUser].meltValue.add(earnedValue);
        }

        tokens[token][callingUser].freezeValue = tokens[token][callingUser].freezeValue.add(amount);
        if (token==address(this))
        {
            balanceOf[callingUser] = balanceOf[callingUser].sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        }
        tokens[token][callingUser].freezeDate = now;

        emit tokenBalanceFreezeEv(token,amount,earnedValue);
        return true;
    }

    function getEarning(address token,address user,uint amount) internal view returns(uint256)
    {
        uint effectiveAmount = calculatePercentage(amount,tokenTypeDatas[token].rateFactor);
        uint interestAmount = calculatePercentage(effectiveAmount,tokenTypeDatas[token].perDayFreezeRate);
        uint secondsPassed = (now - tokens[token][user].freezeDate);
        uint daysPassed=0;
        if (secondsPassed >= 86400)  // if less than one day earning will be zero
        {
           daysPassed = secondsPassed.div(86400); 
        }
        return daysPassed.mul(interestAmount);
    }


    event tokenBalanceMeltEv(address token, uint amount, uint earning);


    function tokenBalanceMelt(address token, uint amount)   public returns (bool)
    {
        require(!safeGuard,"System Paused By Admin");
        require(token!=address(0),"Address(0) found, can't continue");
        address callingUser = msg.sender;
        require(msg.sender != address(0),"Address(0) found, can't continue");
        require(amount <=  tokens[token][callingUser].freezeValue && amount > 0, "less than required or less balance");
        
        uint freezeValue = tokens[token][callingUser].freezeValue;
        uint earnedValue = getEarning(token,callingUser,freezeValue);
        require(mintInternal(earnedValue),"minting failed");
        tokens[address(this)][callingUser].meltValue = tokens[address(this)][callingUser].meltValue.add(earnedValue);       
        
        tokens[token][callingUser].freezeValue = tokens[token][callingUser].freezeValue.sub(amount);
        if (token==address(this))
        {
            tokens[token][callingUser].meltValue = tokens[token][callingUser].meltValue.add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        }

        tokens[token][callingUser].freezeDate = now;
        emit tokenBalanceMeltEv(token,amount,earnedValue);
        return true;
    }

    function viewMyReward(address token) public view returns(uint freezedValue, uint rewardValue)
    {
        address callingUser = msg.sender;
        uint freezeValue = tokens[token][callingUser].freezeValue;
        uint earnedValue = getEarning(token,callingUser,freezeValue);
        return (freezeValue,earnedValue);
    }

}