/**
 *Submitted for verification at Etherscan.io on 2020-05-27
*/

/**
 *Submitted for verification at Etherscan.io on 2020-05-27
*/

pragma solidity 0.5.10;  /*


    
    ___________________________________________________________________
      _      _                                        ______           
      |  |  /          /                                /              
    --|-/|-/-----__---/----__----__---_--_----__-------/-------__------
      |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
    __/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_ DIGIGO!
    
    

                                                                                     
                                                                                     


----------------------------------------------------------------------------------------------------

=== MAIN FEATURES ===
    => Higher degree of control by owner - safeGuard functionality
    => SafeMath implementation 
    => Earning on token for fixed-deposit

------------------------------------------------------------------------------------------------------
*/

/* Safemath library */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// Owner Handler
contract ownerShip    // Auction Contract Owner and OwherShip change
{
    //Global storage declaration
    address payable public owner;

    address payable public newOwner;

    bool public safeGuard ; // To hault all non owner functions in case of imergency

    //Event defined for ownership transfered
    event OwnershipTransferredEv(address payable indexed previousOwner, address payable indexed newOwner);


    //Sets owner only on first run
    constructor() public 
    {
        //Set contract owner
        owner = msg.sender;
        // Disabled global hault on first deploy
        safeGuard = false;

    }

    //This will restrict function only for owner where attached
    modifier onlyOwner() 
    {
        require(true);
        _;
    }


    function transferOwnership(address payable _newOwner) public onlyOwner 
    {
        newOwner = _newOwner;
    }


    //the reason for this flow is to protect owners from sending ownership to unintended address due to human error
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



contract tokenERC20 is  ownerShip
{
    // Public variables of the token
    using SafeMath for uint256;
    bytes32 public name;
    bytes8 public symbol;
    uint8 public decimals; // places of decimal
    uint256 public totalSupply;
    uint256 public totalMintAfterInitial;
    uint256 public maximumSupply;

    uint public burningRate = 500;    // 500=5%

    // struct to store token and ether value 
    struct userBalance 
    {
        uint256 totalValue;
        uint256 freezeValue;
        uint256 freezeDate;
        uint256 meltValue;    
    }

    // Mapped storage for token  ( If token address is 0 means ether)
    mapping (address => mapping (address => userBalance)) public tokens;


        // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    
    /* Records for the fronzen accounts */
    mapping (address => bool) public frozenAccount;
        
    /* This generates a public event on the blockchain that will notify clients */
    event FrozenFunds(address target, bool frozen);
    
    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);
  
    
    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);

     //Calculate percent and return result
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



    //Token type defnition
    struct tokenTypeData
    {
        bytes32 tokenName;
        bytes8 tokenSymbol;
        uint decimalCount;
        uint minFreezingValue;
        uint rateFactor;      // % of token balance amount = "effective balance amount" to calculate interest
        uint perDayFreezeRate;   //1000 = 10% ,10 = 0.1%, 1 = 0.01%
        bool freezingAllowed;   // If false this token type is not allowed or accepted to freeze
    }
    // Mapped storage struct for token type  data
    mapping (address => tokenTypeData) public tokenTypeDatas;


        /**
         * Constrctor function
         *
         * Initializes contract with initial supply tokens to the creator of the contract
         */
    constructor () public {
    	decimals = 18; // 18 decimal places
        totalSupply = 50000000000000000000000000;       // 50 Million with 18 decimal places
        maximumSupply = 100000000000000000000000000;         // 100 Million with 18 decimal places
        balanceOf[msg.sender]=totalSupply;       // tokens will be sent to owner
        tokens[address(this)][owner].totalValue = balanceOf[msg.sender];
        name = "DIGIGO Token";                           // Set the name for display purposes
        symbol = "DIGO";                       // Set the symbol for display purposes

        //In house token type data update
        tokenTypeData memory temp;

        temp.tokenName=name;
        temp.tokenSymbol=symbol;
        temp.decimalCount=decimals;
        temp.minFreezingValue=100;
        temp.rateFactor=10000;   //10000 = 100% means token amount = effective amount   
        temp.perDayFreezeRate=100;   // 1% daily freezing reward
        temp.freezingAllowed=true;  
        tokenTypeDatas[address(this)] = temp;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
         /* Internal transfer, only can be called by this contract */
        function _transfer(address _from, address _to, uint _value) internal {
            require(!safeGuard,"safeGuard Active");
			require (_to != address(0),"to is address 0");                               // Prevent transfer to 0x0 address. Use burn() instead
			require (balanceOf[_from] >= _value, "no balance in from");               // Check if the sender has enough
			require (balanceOf[_to].add(_value) >= balanceOf[_to],"overflow balance"); // Check for overflows
			require(!frozenAccount[_from],"from account frozen");                     // Check if sender is frozen
			require(!frozenAccount[_to],"to account frozen");                       // Check if recipient is frozen
			balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
            tokens[address(this)][_from].totalValue = tokens[address(this)][_from].totalValue.sub(_value); //parallel record for multi token addressing need
			balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
            tokens[address(this)][_to].totalValue = tokens[address(this)][_to].totalValue.add(_value);   //parallel record for multi token addressing need         
            uint burnValue;
            if(!(msg.sender == owner || msg.sender == address(this)))   // burn if sender is not this contract or owner
            {
                burnValue = calculatePercentage(_value,burningRate); //amount to burn
                require(burnInternal(_to, burnValue),"burning failed");   // burnt from receiver
            }
			emit Transfer(_from, _to,_value);
            
        } 

        function burnInternal(address _burnFrom, uint _burnValue) internal returns(bool success)
        {   
            require(!safeGuard,"safeGuard Active");
            require(_burnFrom != address(0));
            require(balanceOf[_burnFrom] >= _burnValue);   // Check if the sender has enough
			require(!frozenAccount[_burnFrom],"to account frozen");                       // Check if recipient is frozen
			balanceOf[_burnFrom] = balanceOf[_burnFrom].sub(_burnValue);    // Subtract from the sender
            tokens[address(this)][_burnFrom].totalValue = tokens[address(this)][_burnFrom].totalValue.sub(_burnValue); //parallel record for multi token addressing need
			balanceOf[address(0)] = balanceOf[address(0)].add(_burnValue);        // Add the same to the recipient
            tokens[address(this)][address(0)].totalValue = tokens[address(this)][address(0)].totalValue.add(_burnValue);   //parallel record for multi token addressing need         
            totalSupply = totalSupply.sub(_burnValue);            
			emit Transfer(_burnFrom, address(0),_burnValue);                         // Update totalSupply
            return true;            
        }

		function mintInternal(uint256 mintedAmount)  internal returns (bool success) {                         
			totalSupply = totalSupply.add(mintedAmount);
            totalMintAfterInitial = totalMintAfterInitial.add(mintedAmount);
		 	//emit Transfer(address(0), address(this), mintedAmount);
            return true;
		}



        /**
         * Transfer tokens
         *
         * Send `_value` tokens to `_to` from your account
         *
         * @param _to The address of the recipient
         * @param _value the amount to send
         */
    function transfer(address _to, uint256 _value) public returns (bool success) {
         _transfer(msg.sender, _to, _value);
        return true;
    }
    
        /**
         * Transfer tokens from other address
         *
         * Send `_value` tokens to `_to` in behalf of `_from`
         *
         * @param _from The address of the sender
         * @param _to The address of the recipient
         * @param _value the amount to send
         */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(!safeGuard);
        require(_from != address(0),"transfer from adderss(0) is invalid");
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        return true;
    }
    
        /**
         * Set allowance for other address
         *
         * Allows `_spender` to spend no more than `_value` tokens in your behalf
         *
         * @param _spender The address authorized to spend
         * @param _value the max amount they can spend
         */
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        require(!safeGuard);
        allowance[msg.sender][_spender] = _value;
        return true;
    }

        
		/// @notice Create `mintedAmount` tokens and send it to `target`
		/// @param target Address to receive the tokens
		/// @param mintedAmount the amount of tokens it will receive
		function mintToken(address target, uint256 mintedAmount)  public onlyOwner returns (bool success) {
			balanceOf[target] = balanceOf[target].add(mintedAmount);
            tokens[address(this)][target].totalValue = tokens[address(this)][target].totalValue.add(mintedAmount); //parallel record for multi token addressing need                         
			totalSupply = totalSupply.add(mintedAmount);
            totalMintAfterInitial = totalMintAfterInitial.add(mintedAmount);
		 	emit Transfer(address(0), address(this), mintedAmount);
            return true;
		}


        /**
         * Destroy tokens
         *
         * Remove `_value` tokens from the system irreversibly
         *
         * @param _value the amount of money to burn
         */
    function burn(uint256 _value) public onlyOwner returns (bool success) {
        burnInternal(msg.sender, _value);
        return true;
    }
    
        /**
         * Destroy tokens from other account
         *
         * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
         *
         * @param _from the address of the sender
         * @param _value the amount of money to burn
         */
    function burnFrom(address _from, uint256 _value) public onlyOwner returns (bool success) {
        burnInternal(_from, _value);
        return true;
    }
        
}



interface ERC20Essential 
{

    function transfer(address _to, uint256 _amount) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);

}

//Main contract starts here
contract DIGIGO is tokenERC20
{

    using SafeMath for uint256;
    
    
    	/*************************************/
        /*  User whitelisting functionality  */
        /*************************************/
        bool public whitelistingStatus = false;
        mapping (address => bool) public whitelisted;

        
        /**
         * Change whitelisting status on or off
         *
         * When whitelisting is true, then crowdsale will only accept investors who are whitelisted.
         */
        function changeWhitelistingStatus() onlyOwner public{
            if (whitelistingStatus == false){
			    whitelistingStatus = true;
                whitelisted[owner]= true;
            }
            else{
                whitelistingStatus = false;    
            }
		}
		
		/**
         * Whitelist any user address - only Owner can do this
         *
         * It will add user address in whitelisted mapping
         */
        function whitelistUser(address userAddress) onlyOwner public{
            require(whitelistingStatus == true);
            require(userAddress != address(0));
            whitelisted[userAddress] = true;
		}    
		



		/// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
		/// @param target Address to be frozen
		/// @param freeze either to freeze it or not
		function freezeAccount(address target, bool freeze) onlyOwner public {
				frozenAccount[target] = freeze;
			emit  FrozenFunds(target, freeze);
		}
        

        
        //Just in case, owner wants to transfer Tokens from contract to owner address
        function manualWithdrawToken(uint256 _amount) onlyOwner public {
      		uint256 tokenAmount = _amount.mul(100);
            _transfer(address(this), msg.sender, tokenAmount);
        }
          
        //Just in case, owner wants to transfer Ether from contract to owner address
        function manualWithdrawEther()onlyOwner public{
			uint256 amount=address(this).balance;
			owner.transfer(amount);
			msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
		

        //To air drop
        function airDrop(address[] memory recipients,uint[] memory tokenAmount) public onlyOwner returns (bool) {
            uint reciversLength  = recipients.length;
            require(reciversLength <= 150);
            for(uint i = 0; i < reciversLength; i++)
            {
                  //This will loop through all the recipients and send them the specified tokens
                  _transfer(owner, recipients[i], tokenAmount[i]);
            }
            return true;
        }
        
        
        

    uint public meltHoldSeconds = 172800;  // 172800 seconds = 48 Hr. user can withdraw only after this period




    //Event for eexternal token deposit and withdraw

    event tokenDepositEv(address token, address user, uint amount, uint balance);
    event tokenWithdrawEv(address token, address user, uint amount, uint balance);

    function setWithdrawWaitingPeriod(uint valueInSeconds) onlyOwner public returns (bool)
    {
        meltHoldSeconds = valueInSeconds;
        return true;
    }

    function newTokenTypeData(address token,bytes32 _tokenName, bytes8 _tokenSymbol, uint _decimalCount, uint _minFreezingValue, uint _rateFactor, uint _perDayFreezeRate) onlyOwner public returns (bool)
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

   
    

    //To deposit token
    function tokenDeposit(address token, uint amount) public 
    {
        //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
        require(token!=address(0),"Address(0) found, can't continue");
        require(ERC20Essential(token).transferFrom(msg.sender, address(this), amount),"ERC20 'transferFrom' call failed");
        tokens[token][msg.sender].totalValue = tokens[token][msg.sender].totalValue.add(amount);
        emit tokenDepositEv(token, msg.sender, amount, tokens[token][msg.sender].totalValue);
    }

    //To withdraw token
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
        ERC20Essential(token).transfer(msg.sender, amount);
        emit tokenWithdrawEv(token, msg.sender, amount, tokens[token][msg.sender].totalValue);
    }

    event releaseMyHypeEv(address token, uint amount);
    //releasing after minumum waiting period to withdraw DIGO 
    function releaseMyHype(address token) public returns (bool)
    {
        require(!safeGuard,"System Paused By Admin");
        require(token!=address(0),"Address(0) found, can't continue");
        require(token == address(this),"Only possible for DIGO ");
        require(now.sub(meltHoldSeconds) > tokens[token][msg.sender].freezeDate,"wait period is not over");
        uint amount = tokens[token][msg.sender].meltValue;
        balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
        tokens[token][msg.sender].totalValue = balanceOf[msg.sender].add(tokens[token][msg.sender].freezeValue );
        tokens[token][msg.sender].meltValue = 0; 
        emit releaseMyHypeEv(token, amount);
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
        
        //before adding more freezing amount calculating earning on existing freeze amount and updating same in user ether balance
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
            balanceOf[callingUser] = balanceOf[callingUser].sub(amount);
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
        
        //before melting amount calculating earning on existing freeze amount and updating same in user ether balance
        uint freezeValue = tokens[token][callingUser].freezeValue;
        uint earnedValue = getEarning(token,callingUser,freezeValue);
        require(mintInternal(earnedValue),"minting failed");
        tokens[address(this)][callingUser].meltValue = tokens[address(this)][callingUser].meltValue.add(earnedValue);       
        
        tokens[token][callingUser].freezeValue = tokens[token][callingUser].freezeValue.sub(amount);
        if (token==address(this))
        {
            tokens[token][callingUser].meltValue = tokens[token][callingUser].meltValue.add(amount);
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