pragma solidity ^0.5.6;
 
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */ 
library SafeMath{
    function mul(uint a, uint b) internal pure returns (uint){
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
 
    function div(uint a, uint b) internal pure returns (uint){
        uint c = a / b;
        return c;
    }
 
    function sub(uint a, uint b) internal pure returns (uint){
        assert(b <= a); 
        return a - b; 
    } 
  
    function add(uint a, uint b) internal pure returns (uint){ 
        uint c = a + b; assert(c >= a);
        return c;
    }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;
 
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
 
    constructor() public{
        owner = msg.sender;
    }
 
   /**
    * @dev Throws if called by any account other than the owner.
    */ 
   modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
 
   /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */ 
   function transferOwnership(address newOwner) onlyOwner public{
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

/**
 * @title ITCMoney token
 * @dev ERC20 Token implementation, with mintable and its own specific
 */
contract ITCMoney is Ownable{
    using SafeMath for uint;
    
    string public constant name = "ITC Money";
    string public constant symbol = "ITCM";
    uint32 public constant decimals = 18;
    
    address payable public companyAddr = address(0);
    address public constant bonusAddr   = 0xaEA6949B27C44562Dd446c2C44f403cF6D13a2fD;
    address public constant teamAddr    = 0xe0b70c54a1baa2847e210d019Bb8edc291AEA5c7;
    address public constant sellerAddr  = 0x95E1f32981F909ce39d45bF52C9108f47e0FCc50;
    
    uint public totalSupply = 0;
    uint public maxSupply = 17000000000 * 1 ether; // Maximum of tokens to be minted. 1 ether multiplier is decimal.
    mapping(address => uint) balances;
    mapping (address => mapping (address => uint)) internal allowed;
    
    bool public transferAllowed = false;
    mapping(address => bool) internal customTransferAllowed;
    
    uint public tokenRate = 170 * 1 finney; // Start token rate * 10000 (0.017 CHF * 10000). 1 finney multiplier is for decimal.
    uint private tokenRateDays = 0;
    // growRate is the sequence of periods and percents of rate grow. First element is timestamp of period start. Second is grow percent * 10000.
    uint[2][] private growRate = [
        [1538784000, 100],
        [1554422400,  19],
        [1564617600,  17],
        [1572566400,   0]
    ];
    
    uint public rateETHCHF = 0;
    mapping(address => uint) balancesCHF;
    bool public amountBonusAllowed = true;
    // amountBonus describes the token bonus that depends from CHF amount. First element is minimum accumulated CHF amount. Second one is bonus percent * 100.
    uint[2][] private amountBonus = [
        [uint32(2000),    500],
        [uint32(8000),    700],
        [uint32(17000),  1000],
        [uint32(50000),  1500],
        [uint32(100000), 1750],
        [uint32(150000), 2000],
        [uint32(500000), 2500]
    ];
    
    // timeBonus describes the token bonus that depends from date. First element is the timestamp of start date. Second one is bonus percent * 100.
    uint[2][] private timeBonus = [
        [1535673600, 2000], // 2018-08-31
        [1535760000, 1800], // 2018-09-01
        [1538784000, 1500], // 2018-10-06
        [1541462400, 1000], // 2018-11-06
        [1544054400,  800], // 2018-12-06
        [1546732800,  600], // 2019-01-06
        [1549411200,  300], // 2019-02-06
        [1551830400,  200]  // 2019-03-06
    ];
    uint private finalTimeBonusDate = 1554508800; // 2019-04-06. No bonus tokens after this date.
    uint public constantBonus = 0;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    event CompanyChanged(address indexed previousOwner, address indexed newOwner);
    event TransfersAllowed();
    event TransfersAllowedTo(address indexed to);
    event CHFBonusStopped();
    event AddedCHF(address indexed to, uint value);
    event NewRateCHF(uint value);
    event AddedGrowPeriod(uint startTime, uint rate);
    event ConstantBonus(uint value);
    event NewTokenRate(uint tokenRate);

    /** 
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint){
        return balances[_owner];
    }
 
    /**
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */ 
    function transfer(address _to, uint _value) public returns (bool){
        require(_to != address(0));
        require(transferAllowed || _to == sellerAddr || customTransferAllowed[msg.sender]);
        require(_value > 0 && _value <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true; 
    } 

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */ 
    function transferFrom(address _from, address _to, uint _value) public returns (bool){
        require(_to != address(0));
        require(transferAllowed || _to == sellerAddr || customTransferAllowed[_from]);
        require(_value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender]);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }
 
    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint _value) public returns (bool){
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
 
    /** 
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public view returns (uint){
        return allowed[_owner][_spender]; 
    } 
 
    /**
     * @dev Increase approved amount of tokents that could be spent on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to be spent.
     */
    function increaseApproval(address _spender, uint _addedValue) public returns (bool){
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
        return true; 
    }
 
    /**
     * @dev Decrease approved amount of tokents that could be spent on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to be spent.
     */
    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){
        uint oldValue = allowed[msg.sender][_spender];
        if(_subtractedValue > oldValue){
            allowed[msg.sender][_spender] = 0;
        }else{
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
    
    /**
     * @dev Function changes the company address. Ether moves to company address from contract.
     * @param newCompany New company address.
     */
    function changeCompany(address payable newCompany) onlyOwner public{
        require(newCompany != address(0));
        emit CompanyChanged(companyAddr, newCompany);
        companyAddr = newCompany;
    }

    /**
     * @dev Allow ITCM token transfer for each address.
     */
    function allowTransfers() onlyOwner public{
        transferAllowed = true;
        emit TransfersAllowed();
    }
 
    /**
     * @dev Allow ITCM token transfer for spcified address.
     * @param _to Address to which token transfers become allowed.
     */
    function allowCustomTransfers(address _to) onlyOwner public{
        customTransferAllowed[_to] = true;
        emit TransfersAllowedTo(_to);
    }
    
    /**
     * @dev Stop adding token bonus that depends from accumulative CHF amount.
     */
    function stopCHFBonus() onlyOwner public{
        amountBonusAllowed = false;
        emit CHFBonusStopped();
    }
    
    /**
     * @dev Emit new tokens and transfer from 0 to client address. This function will generate tokens for bonus and team addresses.
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */ 
    function _mint(address _to, uint _value) private returns (bool){
        // 3% of token amount to bonus address
        uint bonusAmount = _value.mul(3).div(87);
        // 10% of token amount to team address
        uint teamAmount = _value.mul(10).div(87);
        // Restore the total token amount
        uint total = _value.add(bonusAmount).add(teamAmount);
        
        require(total <= maxSupply);
        
        maxSupply = maxSupply.sub(total);
        totalSupply = totalSupply.add(total);
        
        balances[_to] = balances[_to].add(_value);
        balances[bonusAddr] = balances[bonusAddr].add(bonusAmount);
        balances[teamAddr] = balances[teamAddr].add(teamAmount);

        emit Transfer(address(0), _to, _value);
        emit Transfer(address(0), bonusAddr, bonusAmount);
        emit Transfer(address(0), teamAddr, teamAmount);

        return true;
    }

    /**
     * @dev This is wrapper for _mint.
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */ 
    function mint(address _to, uint _value) onlyOwner public returns (bool){
        return _mint(_to, _value);
    }

    /**
     * @dev Similar to mint function but take array of addresses and values.
     * @param _to The addresses to transfer to.
     * @param _value The amounts to be transferred.
     */ 
    function mint(address[] memory _to, uint[] memory _value) onlyOwner public returns (bool){
        require(_to.length == _value.length);

        uint len = _to.length;
        for(uint i = 0; i < len; i++){
            if(!_mint(_to[i], _value[i])){
                return false;
            }
        }
        return true;
    }
    
    /** 
     * @dev Gets the accumulative CHF balance of the specified address.
     * @param _owner The address to query the the CHF balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceCHFOf(address _owner) public view returns (uint){
        return balancesCHF[_owner];
    }

    /** 
     * @dev Increase CHF amount for address to which the tokens were minted.
     * @param _to Target address.
     * @param _value The amount of CHF.
     */
    function increaseCHF(address _to, uint _value) onlyOwner public{
        balancesCHF[_to] = balancesCHF[_to].add(_value);
        emit AddedCHF(_to, _value);
    }

    /** 
     * @dev Increase CHF amounts for addresses to which the tokens were minted.
     * @param _to Target addresses.
     * @param _value The amounts of CHF.
     */
    function increaseCHF(address[] memory _to, uint[] memory _value) onlyOwner public{
        require(_to.length == _value.length);

        uint len = _to.length;
        for(uint i = 0; i < len; i++){
            balancesCHF[_to[i]] = balancesCHF[_to[i]].add(_value[i]);
            emit AddedCHF(_to[i], _value[i]);
        }
    }
 
    /** 
     * @dev Sets the rate ETH to CHF that represents UINT (rate * 10000).
     * @param _rate ETH CHF rate * 10000.
     */
    function setETHCHFRate(uint _rate) onlyOwner public{
        rateETHCHF = _rate;
        emit NewRateCHF(_rate);
    }
    
    /** 
     * @dev Set new period and grow percent at the day.
     * @param _startTime timestamp when the rate will start grow.
     * @param _rate Grow percent * 10000.
     */
    function addNewGrowRate(uint _startTime, uint _rate) onlyOwner public{
        growRate.push([_startTime, _rate]);
        emit AddedGrowPeriod(_startTime, _rate);
    }
 
    /** 
     * @dev Set constant token bonus for each address that applies in fallback.
     * @param _value Grow percent * 100.
     */
    function setConstantBonus(uint _value) onlyOwner public{
        constantBonus = _value;
        emit ConstantBonus(_value);
    }

    /** 
     * @dev Calculate and store current token rate.
     *      The rate grows every day per percent that is shown in growRate starting from timestamp that was set for the rate.
     */
    function getTokenRate() public returns (uint){
        uint startTokenRate = tokenRate;
        uint totalDays = 0;
        uint len = growRate.length;
        // For each period from growRate
        for(uint i = 0; i < len; i++){
            if(now > growRate[i][0] && growRate[i][1] > 0){
                // The final date is minimum from now and next period date
                uint end = now;
                if(i + 1 < len && end > growRate[i + 1][0]){
                    end = growRate[i + 1][0];
                }
                uint dateDiff = (end - growRate[i][0]) / 1 days;
                totalDays = totalDays + dateDiff;
                // Check if the rate calculation required
                if(dateDiff > 0 && totalDays > tokenRateDays){
                    // Calculate and store the rate.
                    // This is like rate * (100+percent)**days but memory safe.
                    for(uint ii = tokenRateDays; ii < totalDays; ii++){
                        tokenRate = tokenRate * (10000 + growRate[i][1]) / 10000;
                    }
                    tokenRateDays = totalDays;
                }
            }
        }
        if(startTokenRate != tokenRate){
            emit NewTokenRate(tokenRate);
        }
        return tokenRate;
    }
    
    /** 
     * @dev Function that receives the ether, transfers it to company address and mints tokens to address that initiates payment. Company, bonus and team addresses gets the tokens as well.
     */
    function () external payable {	//inject DOS BY COMPLEX FALLBACK
        // Revert if there are no basic parameters
        require(msg.data.length == 0);
        require(msg.value > 0);
        require(rateETHCHF > 0);
        
        // Calculate token amount (amount of CHF / current rate). Remember that token rate is multiplied by 1 finney, add the same multiplier for ether amount.
        uint amount = (msg.value * rateETHCHF * 1 finney) / getTokenRate();
        // Calculate CHF amount analogue, then store it for customer.
        uint amountCHF = (msg.value * rateETHCHF) / 10000 / 1 ether;
        uint totalCHF = balancesCHF[msg.sender].add(amountCHF);
        emit AddedCHF(msg.sender, amountCHF);

        // Get the bonus percent that depends from time or its constant.
        uint len = 0;
        uint i = 0;
        uint percent = 0;
        uint bonus = 0;
        if(constantBonus > 0){
            bonus = amount.mul(constantBonus).div(10000);
        }else if(now < finalTimeBonusDate){
            len = timeBonus.length;
            percent = 0;
            for(i = 0; i < len; i++){
                if(now >= timeBonus[i][0]){
                    percent = timeBonus[i][1];
                }else{
                    break;
                }
            }
            if(percent > 0){
                bonus = amount.mul(percent).div(10000);
            }
        }

        // Add the bonus that depends from accumulated CHF amount
        if(amountBonusAllowed){
            len = amountBonus.length;
            percent = 0;
            for(i = 0; i < len; i++){
                if(totalCHF >= amountBonus[i][0]){
                    percent = amountBonus[i][1];
                }else{
                    break;
                }
            }
            if(percent > 0){
                bonus = bonus.add(amount.mul(percent).div(10000));
            }
        }
        
        amount = amount.add(bonus);
        
        // 3% of token amount to bonus address
        uint bonusAmount = amount.mul(3).div(87);
        // 10% of token amount to team address
        uint teamAmount = amount.mul(10).div(87);
        // Restore the total token amount
        uint total = amount.add(bonusAmount).add(teamAmount);
        
        require(total <= maxSupply);
        
        maxSupply = maxSupply.sub(total);
        totalSupply = totalSupply.add(total);
        
        balances[msg.sender] = balances[msg.sender].add(amount);
        balancesCHF[msg.sender] = totalCHF;
        balances[bonusAddr] = balances[bonusAddr].add(bonusAmount);
        balances[teamAddr] = balances[teamAddr].add(teamAmount);

        companyAddr.call.gas(2301).value(msg.value)("");
        
        emit Transfer(address(0), msg.sender, amount);
        emit Transfer(address(0), bonusAddr, bonusAmount);
        emit Transfer(address(0), teamAddr, teamAmount);
    }
}