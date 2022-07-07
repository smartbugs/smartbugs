pragma solidity ^0.5.2;


/** @title A contract for issuing, redeeming and transfering Sila StableCoins
  *
  * @author www.silamoney.com
  * Email: contact@silamoney.com
  *
  */

/**Run
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
 
library SafeMath{
    
    
  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
    
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.

    
    if (_a == 0) {
      return 0;
    }

    uint256 c = _a * _b;
    require(c / _a == _b);

    return c;
  }

 
   /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
 
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    
    require(_b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = _a / _b;
    
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }
  
  
 
   /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    require(_b <= _a);
    uint256 c = _a - _b;

    return c;
  }


  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  
  function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
    uint256 c = _a + _b;
    require(c >= _a);

    return c;
  }

    
}

/**
 * @title Ownable
 * @dev The Ownable contract hotOwner and ColdOwner, and provides authorization control
 * functions, this simplifies the implementation of "user permissions".
 */

contract Ownable {
    
    // hot and cold wallet addresses
    
    address public hotOwner=0xCd39203A332Ff477a35dA3AD2AD7761cDBEAb7F0;

    address public coldOwner=0x1Ba688e70bb4F3CB266b8D721b5597bFbCCFF957;
    
    
    //events
    
    event OwnershipTransferred(address indexed _newHotOwner,address indexed _newColdOwner,address indexed _oldColdOwner);


    /**
   * @dev Reverts if called by any account other than the hotOwner.
   */
   
    modifier onlyHotOwner() {
        require(msg.sender == hotOwner);
        _;
    }
    
     /**
   * @dev Reverts if called by any account other than the coldOwner.
   */
    
    modifier onlyColdOwner() {
        require(msg.sender == coldOwner);
        _;
    }
    
     /**
   * @dev Function assigns new hotowner and coldOwner
   * @param _newHotOwner address The address which owns the funds.
   * @param _newColdOwner address The address which can change the hotOwner.
   */
    
    function transferOwnership(address _newHotOwner,address _newColdOwner) public onlyColdOwner returns (bool) {
        require(_newHotOwner != address(0));
        require(_newColdOwner!= address(0));
        hotOwner = _newHotOwner;
        coldOwner = _newColdOwner;
        emit OwnershipTransferred(_newHotOwner,_newColdOwner,msg.sender);
        return true;
        
        
    }

}

/**
 * @title Authorizable
 * @dev The Authorizable contract can be used to authorize addresses to control silatoken main functions
 * functions, this will provide more flexibility in terms of signing trasactions
 */

contract Authorizable is Ownable {
    
    //map to check if the address is authorized to issue, redeem sila
    mapping(address => bool) authorized;
    
    //events for when address is added or removed
    event AuthorityAdded(address indexed _toAdd);
    event AuthorityRemoved(address indexed _toRemove);
    
    //array of authorized address to check for all the authorized addresses
    address[] public authorizedAddresses;

    
    modifier onlyAuthorized() {
        require(authorized[msg.sender] || hotOwner == msg.sender);
        _;
    }
    
    
     
     /**
   * @dev Function addAuthorized adds addresses that can issue,redeem and transfer silas
   * @param _toAdd address of the added authority
   */

    function addAuthorized(address _toAdd) onlyHotOwner public returns(bool) {
        require(_toAdd != address(0));
        require(!authorized[_toAdd]);
        authorized[_toAdd] = true;
        authorizedAddresses.push(_toAdd);
        emit AuthorityAdded(_toAdd);
        return true;
    }
    
    /**
   * @dev Function RemoveAuthorized removes addresses that can issue and redeem silas
   * @param _toRemove address of the added authority
   */

    function removeAuthorized(address _toRemove,uint _toRemoveIndex) onlyHotOwner public returns(bool) {
        require(_toRemove != address(0));
        require(authorized[_toRemove]);
        authorized[_toRemove] = false;
        authorizedAddresses[_toRemoveIndex] = authorizedAddresses[authorizedAddresses.length-1];
        authorizedAddresses.pop();
        emit AuthorityRemoved(_toRemove);
        return true;
    }
    
    
    // view all the authorized addresses
    function viewAuthorized() public view returns(address[] memory _authorizedAddresses){	//inject PUBLIC FUNC TO EXTERNAL
        return authorizedAddresses;
    }
    
    
    // check if the address is authorized
    
    function isAuthorized(address _authorized) public view returns(bool _isauthorized){	//inject PUBLIC FUNC TO EXTERNAL
        return authorized[_authorized];
    }
    
    
  

}




/**
 * @title EmergencyToggle
 * @dev The EmergencyToggle contract provides a way to pause the contract in emergency
 */

contract EmergencyToggle is Ownable{
     
    //variable to pause the entire contract if true
    bool public emergencyFlag; 

    //constructor
    constructor () public{
      emergencyFlag = false;                            
      
    }
  
  
   /**
    * @dev onlyHotOwner can can pause the usage of issue,redeem, transfer functions
    */
    
    function emergencyToggle() public onlyHotOwner{	//inject PUBLIC FUNC TO EXTERNAL
      emergencyFlag = !emergencyFlag;
    }

    
 
 }
 
 /**
 * @title  Token is Betalist,Blacklist
 */
 contract Betalist is Authorizable,EmergencyToggle{
     
    //maps for betalisted and blacklisted addresses
    mapping(address=>bool) betalisted;
    mapping(address=>bool) blacklisted;

    //events for betalist and blacklist
    event BetalistedAddress (address indexed _betalisted);
    event BlacklistedAddress (address indexed _blacklisted);
    event RemovedFromBlacklist(address indexed _toRemoveBlacklist);
    event RemovedFromBetalist(address indexed _toRemoveBetalist);
    
    //variable to check if betalist is required when calling several functions on smart contract
    bool public requireBetalisted;


    //constructor
    constructor () public{
        requireBetalisted=true;
        
    }
    
    
   /**
  * @dev betaList the specified address
  * @param _toBetalist the address to betalist
  */
    function betalistAddress(address _toBetalist) public onlyAuthorized returns(bool){
        require(!emergencyFlag);
        require(_toBetalist != address(0));
        require(!blacklisted[_toBetalist]);
        require(!betalisted[_toBetalist]);
        betalisted[_toBetalist]=true;
        emit BetalistedAddress(_toBetalist);
        return true;
        
    }
    
     /**
  * @dev remove from betaList the specified address
  * @param _toRemoveBetalist The address to be removed
  */
    function removeAddressFromBetalist(address _toRemoveBetalist) public onlyAuthorized returns(bool){
        require(!emergencyFlag);
        require(_toRemoveBetalist != address(0));
        require(betalisted[_toRemoveBetalist]);
        betalisted[_toRemoveBetalist]=false;
        emit RemovedFromBetalist(_toRemoveBetalist);
        return true;
        
    }
    
      
    /**
  * @dev blackList the specified address
  * @param _toBlacklist The address to blacklist
  */
    function blacklistAddress(address _toBlacklist) public onlyAuthorized returns(bool){
        require(!emergencyFlag);
        require(_toBlacklist != address(0));
        require(!blacklisted[_toBlacklist]);
        blacklisted[_toBlacklist]=true;
        emit RemovedFromBlacklist(_toBlacklist);
        return true;
        
    }
    
     /**
  * @dev remove from blackList the specified address
  * @param _toRemoveBlacklist The address to blacklist
  */
    function removeAddressFromBlacklist(address _toRemoveBlacklist) public onlyAuthorized returns(bool){
        require(!emergencyFlag);
        require(_toRemoveBlacklist != address(0));
        require(blacklisted[_toRemoveBlacklist]);
        blacklisted[_toRemoveBlacklist]=false;
        emit RemovedFromBlacklist(_toRemoveBlacklist);
        return true;
        
    }
 
      /**
  * @dev check the specified address if isBetaListed
  * @param _betalisted The address to transfer to.
  */
    function isBetaListed(address _betalisted) public view returns(bool){	//inject PUBLIC FUNC TO EXTERNAL
            return (betalisted[_betalisted]);
    }
    
     
      /**
  * @dev check the specified address isBlackListed
  * @param _blacklisted The address to transfer to.
  */
    function isBlackListed(address _blacklisted) public view returns(bool){	//inject PUBLIC FUNC TO EXTERNAL
        return (blacklisted[_blacklisted]);
        
    }
    
    
}

/**
 * @title  Token is token Interface
 */

contract Token{
    
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


/**
 *@title StandardToken
 *@dev Implementation of the basic standard token.
 */

contract StandardToken is Token,Betalist{
  using SafeMath for uint256;

  mapping (address => uint256)  balances;

  mapping (address => mapping (address => uint256)) allowed;
  
  uint256 public totalSupply;


 
  
  
  /**
  * @dev Gets the balance of the specified address.
  * @return An uint256 representing the amount owned by the passed address.
  */

  function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
  }

  
  
  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  
  function allowance(address _owner,address _spender)public view returns (uint256){
        return allowed[_owner][_spender];
  }

 
  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(!emergencyFlag);
    require(_value <= balances[msg.sender]);
    require(_to != address(0));
    if (requireBetalisted){
        require(betalisted[_to]);
        require(betalisted[msg.sender]);
    }
    require(!blacklisted[msg.sender]);
    require(!blacklisted[_to]);
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;

  }
  
  
    /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * @param _value The amount of tokens to be spent.
   */

  function approve(address _spender, uint256 _value) public returns (bool) {
    require(!emergencyFlag);
    if (requireBetalisted){
        require(betalisted[msg.sender]);
        require(betalisted[_spender]);
    }
    require(!blacklisted[msg.sender]);
    require(!blacklisted[_spender]);
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;

  }
  
  
    /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */

  function transferFrom(address _from,address _to,uint256 _value)public returns (bool){
    require(!emergencyFlag);
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(_to != address(0));
    if (requireBetalisted){
        require(betalisted[_to]);
        require(betalisted[_from]);
        require(betalisted[msg.sender]);
    }
    require(!blacklisted[_to]);
    require(!blacklisted[_from]);
    require(!blacklisted[msg.sender]);
    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
    
  }

}

contract AssignOperator is StandardToken{
    
    //mappings
    
    mapping(address=>mapping(address=>bool)) isOperator;
    
    
    //Events
    event AssignedOperator (address indexed _operator,address indexed _for);
    event OperatorTransfer (address indexed _developer,address indexed _from,address indexed _to,uint _amount);
    event RemovedOperator  (address indexed _operator,address indexed _for);
    
    
    /**
   * @dev AssignedOperator to transfer tokens on users behalf
   * @param _developer address The address which is allowed to transfer tokens on users behalf
   * @param _user address The address which developer want to transfer from
   */
    
    function assignOperator(address _developer,address _user) public onlyAuthorized returns(bool){
        require(!emergencyFlag);
        require(_developer != address(0));
        require(_user != address(0));
        require(!isOperator[_developer][_user]);
        if(requireBetalisted){
            require(betalisted[_user]);
            require(betalisted[_developer]);
        }
        require(!blacklisted[_developer]);
        require(!blacklisted[_user]);
        isOperator[_developer][_user]=true;
        emit AssignedOperator(_developer,_user);
        return true;
    }
    
    /**
   * @dev RemoveOperator allowed to transfer tokens on users behalf
   * @param _developer address The address which is allowed to trasnfer tokens on users behalf
   * @param _user address The address which developer want to transfer from
   */
    function removeOperator(address _developer,address _user) public onlyAuthorized returns(bool){
        require(!emergencyFlag);
        require(_developer != address(0));
        require(_user != address(0));
        require(isOperator[_developer][_user]);
        isOperator[_developer][_user]=false;
        emit RemovedOperator(_developer,_user);
        return true;
        
    }
    
    /**
   * @dev Operatransfer for developer to transfer tokens on users behalf without requiring ethers in managed  ethereum accounts
   * @param _from address the address to transfer tokens from
   * @param _to address The address which developer want to transfer to
   * @param _amount the amount of tokens user wants to transfer
   */
    
    function operatorTransfer(address _from,address _to,uint _amount) public returns (bool){
        require(!emergencyFlag);
        require(isOperator[msg.sender][_from]);
        require(_amount <= balances[_from]);
        require(_from != address(0));
        require(_to != address(0));
        if (requireBetalisted){
            require(betalisted[_to]);
            require(betalisted[_from]);
            require(betalisted[msg.sender]);
        }
        require(!blacklisted[_to]);
        require(!blacklisted[_from]);
        require(!blacklisted[msg.sender]);
        balances[_from] = balances[_from].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit OperatorTransfer(msg.sender,_from, _to, _amount);
        emit Transfer(_from,_to,_amount);
        return true;
        
        
    }
    
     /**
   * @dev checkIsOperator is developer an operator allowed to transfer tokens on users behalf
   * @param _developer the address allowed to trasnfer tokens 
   * @param _for address The address which developer want to transfer from
   */
    
    function checkIsOperator(address _developer,address _for) public view returns (bool){	//inject PUBLIC FUNC TO EXTERNAL
            return (isOperator[_developer][_for]);
    }

    
}



 /**
 *@title SilaToken
 *@dev Implementation for sila issue,redeem,protectedTransfer and batch functions
 */

contract SilaToken is AssignOperator{
    using SafeMath for uint256;
    
    // parameters for silatoken
    string  public constant name = "SilaToken";
    string  public constant symbol = "SILA";
    uint256 public constant decimals = 18;
    string  public version = "1.0";
    
     
    //Events fired during successfull execution of main silatoken functions
    event Issued(address indexed _to,uint256 _value);
    event Redeemed(address indexed _from,uint256 _amount);
    event ProtectedTransfer(address indexed _from,address indexed _to,uint256 _amount);
    event ProtectedApproval(address indexed _owner,address indexed _spender,uint256 _amount);
    event GlobalLaunchSila(address indexed _launcher);
    
    

    /**
   * @dev issue tokens from sila  to _to address
   * @dev onlyAuthorized  addresses can call this function
   * @param _to address The address which you want to transfer to
   * @param _amount uint256 the amount of tokens to be issued
   */

    function issue(address _to, uint256 _amount) public onlyAuthorized returns (bool) {
        require(!emergencyFlag);
        require(_to !=address(0));
        if (requireBetalisted){
            require(betalisted[_to]);
        }
        require(!blacklisted[_to]);
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);                 
        emit Issued(_to, _amount);                     
        return true;
    }
    
    
      
   /**
   * @dev redeem tokens from _from address
   * @dev onlyAuthorized  addresses can call this function
   * @param _from address is the address from which tokens are burnt
   * @param _amount uint256 the amount of tokens to be burnt
   */

    function redeem(address _from,uint256 _amount) public onlyAuthorized returns(bool){
        require(!emergencyFlag);
        require(_from != address(0));
        require(_amount <= balances[_from]);
        if(requireBetalisted){
            require(betalisted[_from]);
        }
        require(!blacklisted[_from]);
        balances[_from] = balances[_from].sub(_amount);   
        totalSupply = totalSupply.sub(_amount);
        emit Redeemed(_from,_amount);
        return true;
            

    }
    
    
    /**
   * @dev Transfer tokens from one address to another
   * @dev onlyAuthorized  addresses can call this function
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _amount uint256 the amount of tokens to be transferred
   */

    function protectedTransfer(address _from,address _to,uint256 _amount) public onlyAuthorized returns(bool){
        require(!emergencyFlag);
        require(_amount <= balances[_from]);
        require(_from != address(0));
        require(_to != address(0));
        if (requireBetalisted){
            require(betalisted[_to]);
            require(betalisted[_from]);
        }
        require(!blacklisted[_to]);
        require(!blacklisted[_from]);
        balances[_from] = balances[_from].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit ProtectedTransfer(_from, _to, _amount);
        emit Transfer(_from,_to,_amount);
        return true;
        
    }
    
    
    /**
    * @dev Launch sila for global transfers to work as standard
    */
    
    function globalLaunchSila() public onlyHotOwner{
            require(!emergencyFlag);
            require(requireBetalisted);
            requireBetalisted=false;
            emit GlobalLaunchSila(msg.sender);
    }
    
    
    
     /**
   * @dev batchissue , isuue tokens in batches to multiple addresses at a time
   * @param _amounts The amount of tokens to be issued.
   * @param _toAddresses tokens to be issued to these addresses respectively
    */
    
    function batchIssue(address[] memory _toAddresses,uint256[]  memory _amounts) public onlyAuthorized returns(bool) {
            require(!emergencyFlag);
            require(_toAddresses.length==_amounts.length);
            for(uint i = 0; i < _toAddresses.length; i++) {
                bool check=issue(_toAddresses[i],_amounts[i]);
                require(check);
            }
            return true;
            
    }
    
    
    /**
    * @dev batchredeem , redeem tokens in batches from multiple addresses at a time
    * @param _amounts The amount of tokens to be redeemed.
    * @param _fromAddresses tokens to be redeemed to from addresses respectively
     */
    
    function batchRedeem(address[] memory  _fromAddresses,uint256[]  memory _amounts) public onlyAuthorized returns(bool){
            require(!emergencyFlag);
            require(_fromAddresses.length==_amounts.length);
            for(uint i = 0; i < _fromAddresses.length; i++) {
                bool check=redeem(_fromAddresses[i],_amounts[i]);
                require(check);
            }  
            return true;
        
    }
    
    
      /**
    * @dev batchTransfer, transfer tokens in batches between multiple addresses at a time
    * @param _fromAddresses tokens to be transfered to these addresses respectively
    * @param _toAddresses tokens to be transfered to these addresses respectively
    * @param _amounts The amount of tokens to be transfered
     */
    function protectedBatchTransfer(address[] memory _fromAddresses,address[]  memory _toAddresses,uint256[] memory  _amounts) public onlyAuthorized returns(bool){
            require(!emergencyFlag);
            require(_fromAddresses.length==_amounts.length);
            require(_toAddresses.length==_amounts.length);
            require(_fromAddresses.length==_toAddresses.length);
            for(uint i = 0; i < _fromAddresses.length; i++) {
                bool check=protectedTransfer(_fromAddresses[i],_toAddresses[i],_amounts[i]);
                require(check);
               
            }
            return true;
        
    } 
    
    
    

    
    
}