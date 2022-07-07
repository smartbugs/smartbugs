/**
 *Submitted for verification at Etherscan.io on 2020-02-25
*/

pragma solidity ^0.5.10;

// EraswapToken is pasted below for Interface requirement from https://github.com/KMPARDS/EraSwapSmartContracts/blob/master/Eraswap/contracts/EraswapToken/EraswapToken.sol

pragma solidity ^0.5.9;

contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address _who) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) internal balances;

  uint256 internal totalSupply_;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  /**
  * @dev Transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_value <= balances[msg.sender]);
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

}

contract BurnableToken is BasicToken {

  event Burn(address indexed burner, uint256 value);

  /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */
  function burn(uint256 _value) public {
    _burn(msg.sender, _value);
  }

  function _burn(address _who, uint256 _value) internal {
    require(_value <= balances[_who]);
    // no need to require value <= totalSupply, since that would imply the
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure

    balances[_who] = balances[_who].sub(_value);
    totalSupply_ = totalSupply_.sub(_value);
    emit Burn(_who, _value);
    emit Transfer(_who, address(0), _value);
  }
}

contract ERC20 is ERC20Basic {
  function allowance(address _owner, address _spender)
    public view returns (uint256);

  function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool);

  function approve(address _spender, uint256 _value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract DetailedERC20 is ERC20 {
  string public name;
  string public symbol;
  uint8 public decimals;

  constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
  }
}

contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // assert(_b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}

contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    returns (bool)
  {
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(_to != address(0));

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
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
  function allowance(
    address _owner,
    address _spender
   )
    public
    view
    returns (uint256)
  {
    return allowed[_owner][_spender];
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(
    address _spender,
    uint256 _addedValue
  )
    public
    returns (bool)
  {
    allowed[msg.sender][_spender] = (
      allowed[msg.sender][_spender].add(_addedValue));
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(
    address _spender,
    uint256 _subtractedValue
  )
    public
    returns (bool)
  {
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract MintableToken is StandardToken, Ownable {
  event Mint(address indexed to, uint256 amount);
  event MintFinished();

  bool public mintingFinished = false;


  modifier canMint() {
    require(!mintingFinished);
    _;
  }

  modifier hasMintPermission() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address _to,
    uint256 _amount
  )
    public
    hasMintPermission
    canMint
    returns (bool)
  {
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    emit Mint(_to, _amount);
    emit Transfer(address(0), _to, _amount);
    return true;
  }

  /**
   * @dev Function to stop minting new tokens.
   * @return True if the operation was successful.
   */
  function finishMinting() public onlyOwner canMint returns (bool) {
    mintingFinished = true;
    emit MintFinished();
    return true;
  }
}

contract CappedToken is MintableToken {

  uint256 public cap;

  constructor(uint256 _cap) public {
    require(_cap > 0);
    cap = _cap;
  }

  /**
   * @dev Function to mint tokens
   * @param _to The address that will receive the minted tokens.
   * @param _amount The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(
    address _to,
    uint256 _amount
  )
    public
    returns (bool)
  {
    require(totalSupply_.add(_amount) <= cap);

    return super.mint(_to, _amount);
  }

}

contract EraswapERC20 is DetailedERC20, BurnableToken, CappedToken {
  string private name = "Eraswap";
  string private symbol = "EST";
  uint8 private decimals = 18;
  uint256 private cap = 9100000000000000000000000000;

  /**
  * @dev Constructor
  */

  constructor() internal DetailedERC20("Eraswap", "EST", 18) CappedToken(cap){
    mint(msg.sender, 910000000000000000000000000);
  }

}

contract NRTManager is Ownable, EraswapERC20{

  using SafeMath for uint256;

  uint256 public LastNRTRelease;              // variable to store last release date
  uint256 public MonthlyNRTAmount;            // variable to store Monthly NRT amount to be released
  uint256 public AnnualNRTAmount;             // variable to store Annual NRT amount to be released
  uint256 public MonthCount;                  // variable to store the count of months from the intial date
  uint256 public luckPoolBal;                 // Luckpool Balance
  uint256 public burnTokenBal;                // tokens to be burned

  // different pool address
  address public newTalentsAndPartnerships;
  address public platformMaintenance;
  address public marketingAndRNR;
  address public kmPards;
  address public contingencyFunds;
  address public researchAndDevelopment;
  address public buzzCafe;
  address public timeSwappers;                 // which include powerToken , curators ,timeTraders , daySwappers
  address public TimeAlly;                     //address of TimeAlly Contract

  uint256 public newTalentsAndPartnershipsBal; // variable to store last NRT released to the address;
  uint256 public platformMaintenanceBal;       // variable to store last NRT released to the address;
  uint256 public marketingAndRNRBal;           // variable to store last NRT released to the address;
  uint256 public kmPardsBal;                   // variable to store last NRT released to the address;
  uint256 public contingencyFundsBal;          // variable to store last NRT released to the address;
  uint256 public researchAndDevelopmentBal;    // variable to store last NRT released to the address;
  uint256 public buzzCafeNRT;                  // variable to store last NRT released to the address;
  uint256 public TimeAllyNRT;                   // variable to store last NRT released to the address;
  uint256 public timeSwappersNRT;              // variable to store last NRT released to the address;


    // Event to watch NRT distribution
    // @param NRTReleased The amount of NRT released in the month
    event NRTDistributed(uint256 NRTReleased);

    /**
    * Event to watch Transfer of NRT to different Pool
    * @param pool - The pool name
    * @param sendAddress - The address of pool
    * @param value - The value of NRT released
    **/
    event NRTTransfer(string pool, address sendAddress, uint256 value);


    // Event to watch Tokens Burned
    // @param amount The amount burned
    event TokensBurned(uint256 amount);



    /**
    * @dev Should burn tokens according to the total circulation
    * @return true if success
    */

    function burnTokens() internal returns (bool){
      if(burnTokenBal == 0){
        return true;
      }
      else{
        uint MaxAmount = ((totalSupply()).mul(2)).div(100);   // max amount permitted to burn in a month
        if(MaxAmount >= burnTokenBal ){
          burn(burnTokenBal);
          burnTokenBal = 0;
        }
        else{
          burnTokenBal = burnTokenBal.sub(MaxAmount);
          burn(MaxAmount);
        }
        return true;
      }
    }

    /**
    * @dev To invoke monthly release
    * @return true if success
    */

    function MonthlyNRTRelease() public returns (bool) {	//inject PUBLIC FUNC TO EXTERNAL
      require(now.sub(LastNRTRelease)> 2592000);
      uint256 NRTBal = MonthlyNRTAmount.add(luckPoolBal);        // Total NRT available.

      // Calculating NRT to be released to each of the pools
      newTalentsAndPartnershipsBal = (NRTBal.mul(5)).div(100);
      platformMaintenanceBal = (NRTBal.mul(10)).div(100);
      marketingAndRNRBal = (NRTBal.mul(10)).div(100);
      kmPardsBal = (NRTBal.mul(10)).div(100);
      contingencyFundsBal = (NRTBal.mul(10)).div(100);
      researchAndDevelopmentBal = (NRTBal.mul(5)).div(100);
      buzzCafeNRT = (NRTBal.mul(25)).div(1000);
      TimeAllyNRT = (NRTBal.mul(15)).div(100);
      timeSwappersNRT = (NRTBal.mul(325)).div(1000);

      // sending tokens to respective wallets and emitting events
      mint(newTalentsAndPartnerships,newTalentsAndPartnershipsBal);
      emit NRTTransfer("newTalentsAndPartnerships", newTalentsAndPartnerships, newTalentsAndPartnershipsBal);
      mint(platformMaintenance,platformMaintenanceBal);
      emit NRTTransfer("platformMaintenance", platformMaintenance, platformMaintenanceBal);
      mint(marketingAndRNR,marketingAndRNRBal);
      emit NRTTransfer("marketingAndRNR", marketingAndRNR, marketingAndRNRBal);
      mint(kmPards,kmPardsBal);
      emit NRTTransfer("kmPards", kmPards, kmPardsBal);
      mint(contingencyFunds,contingencyFundsBal);
      emit NRTTransfer("contingencyFunds", contingencyFunds, contingencyFundsBal);
      mint(researchAndDevelopment,researchAndDevelopmentBal);
      emit NRTTransfer("researchAndDevelopment", researchAndDevelopment, researchAndDevelopmentBal);
      mint(buzzCafe,buzzCafeNRT);
      emit NRTTransfer("buzzCafe", buzzCafe, buzzCafeNRT);
      mint(TimeAlly,TimeAllyNRT);
      emit NRTTransfer("stakingContract", TimeAlly, TimeAllyNRT);
      mint(timeSwappers,timeSwappersNRT);
      emit NRTTransfer("timeSwappers", timeSwappers, timeSwappersNRT);

      // Reseting NRT
      emit NRTDistributed(NRTBal);
      luckPoolBal = 0;
      LastNRTRelease = LastNRTRelease.add(30 days); // resetting release date again
      burnTokens();                                 // burning burnTokenBal
      emit TokensBurned(burnTokenBal);


      if(MonthCount == 11){
        MonthCount = 0;
        AnnualNRTAmount = (AnnualNRTAmount.mul(9)).div(10);
        MonthlyNRTAmount = MonthlyNRTAmount.div(12);
      }
      else{
        MonthCount = MonthCount.add(1);
      }
      return true;
    }


  /**
  * @dev Constructor
  */

  constructor() public{
    LastNRTRelease = now;
    AnnualNRTAmount = 819000000000000000000000000;
    MonthlyNRTAmount = AnnualNRTAmount.div(uint256(12));
    MonthCount = 0;
  }

}

contract PausableEraswap is NRTManager {

  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require((now.sub(LastNRTRelease))< 2592000);
    _;
  }


  function transfer(
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.transfer(_to, _value);
  }

  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(
    address _spender,
    uint256 _value
  )
    public
    whenNotPaused
    returns (bool)
  {
    return super.approve(_spender, _value);
  }

  function increaseApproval(
    address _spender,
    uint _addedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(
    address _spender,
    uint _subtractedValue
  )
    public
    whenNotPaused
    returns (bool success)
  {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}

contract EraswapToken is PausableEraswap {


    /**
    * Event to watch the addition of pool address
    * @param pool - The pool name
    * @param sendAddress - The address of pool
    **/
    event PoolAddressAdded(string pool, address sendAddress);

    // Event to watch LuckPool Updation
    // @param luckPoolBal The current luckPoolBal
    event LuckPoolUpdated(uint256 luckPoolBal);

    // Event to watch BurnTokenBal Updation
    // @param burnTokenBal The current burnTokenBal
    event BurnTokenBalUpdated(uint256 burnTokenBal);

    /**
    * @dev Throws if caller is not TimeAlly
    */
    modifier OnlyTimeAlly() {
      require(msg.sender == TimeAlly);
      _;
    }


    /**
    * @dev To update pool addresses
    * @param  pool - A List of pool addresses
    * Updates if pool address is not already set and if given address is not zero
    * @return true if success
    */

    function UpdateAddresses (address[] memory pool) onlyOwner public returns(bool){

      if((pool[0] != address(0)) && (newTalentsAndPartnerships == address(0))){
        newTalentsAndPartnerships = pool[0];
        emit PoolAddressAdded( "NewTalentsAndPartnerships", newTalentsAndPartnerships);
      }
      if((pool[1] != address(0)) && (platformMaintenance == address(0))){
        platformMaintenance = pool[1];
        emit PoolAddressAdded( "PlatformMaintenance", platformMaintenance);
      }
      if((pool[2] != address(0)) && (marketingAndRNR == address(0))){
        marketingAndRNR = pool[2];
        emit PoolAddressAdded( "MarketingAndRNR", marketingAndRNR);
      }
      if((pool[3] != address(0)) && (kmPards == address(0))){
        kmPards = pool[3];
        emit PoolAddressAdded( "KmPards", kmPards);
      }
      if((pool[4] != address(0)) && (contingencyFunds == address(0))){
        contingencyFunds = pool[4];
        emit PoolAddressAdded( "ContingencyFunds", contingencyFunds);
      }
      if((pool[5] != address(0)) && (researchAndDevelopment == address(0))){
        researchAndDevelopment = pool[5];
        emit PoolAddressAdded( "ResearchAndDevelopment", researchAndDevelopment);
      }
      if((pool[6] != address(0)) && (buzzCafe == address(0))){
        buzzCafe = pool[6];
        emit PoolAddressAdded( "BuzzCafe", buzzCafe);
      }
      if((pool[7] != address(0)) && (timeSwappers == address(0))){
        timeSwappers = pool[7];
        emit PoolAddressAdded( "TimeSwapper", timeSwappers);
      }
      if((pool[8] != address(0)) && (TimeAlly == address(0))){
        TimeAlly = pool[8];
        emit PoolAddressAdded( "TimeAlly", TimeAlly);
      }

      return true;
    }


    /**
    * @dev Function to update luckpool balance
    * @param amount Amount to be updated
    */
    function UpdateLuckpool(uint256 amount) OnlyTimeAlly public returns(bool){	//inject PUBLIC FUNC TO EXTERNAL
      require(allowance(msg.sender, address(this)) >= amount);
      require(transferFrom(msg.sender,address(this), amount));
      luckPoolBal = luckPoolBal.add(amount);
      emit LuckPoolUpdated(luckPoolBal);
      return true;
    }

    /**
    * @dev Function to trigger to update  for burning of tokens
    * @param amount Amount to be updated
    */
    function UpdateBurnBal(uint256 amount) OnlyTimeAlly public returns(bool){	//inject PUBLIC FUNC TO EXTERNAL
      require(allowance(msg.sender, address(this)) >= amount);
      require(transferFrom(msg.sender,address(this), amount));
      burnTokenBal = burnTokenBal.add(amount);
      emit BurnTokenBalUpdated(burnTokenBal);
      return true;
    }

    /**
    * @dev Function to trigger balance update of a list of users
    * @param TokenTransferList - List of user addresses
    * @param TokenTransferBalance - Amount of token to be sent
    */
    function UpdateBalance(address[100] calldata TokenTransferList, uint256[100] calldata TokenTransferBalance) OnlyTimeAlly external returns(bool){
        for (uint256 i = 0; i < TokenTransferList.length; i++) {
      require(allowance(msg.sender, address(this)) >= TokenTransferBalance[i]);
      require(transferFrom(msg.sender, TokenTransferList[i], TokenTransferBalance[i]));
      }
      return true;
    }




}

/// @title BetDeEx Smart Contract - The Decentralized Prediction Platform of Era Swap Ecosystem
/// @author The EraSwap Team
/// @notice This contract is used by manager to deploy new Bet contracts
/// @dev This contract also acts as treasurer
contract BetDeEx {
    using SafeMath for uint256;

    address[] public bets; /// @dev Stores addresses of bets
    address public superManager; /// @dev Required to be public because ES needs to be sent transaparently.

    EraswapToken esTokenContract;

    mapping(address => uint256) public betBalanceInExaEs; /// @dev All ES tokens are transfered to main BetDeEx address for common allowance in ERC20 so this mapping stores total ES tokens betted in each bet.
    mapping(address => bool) public isBetValid; /// @dev Stores authentic bet contracts (only deployed through this contract)
    mapping(address => bool) public isManager; /// @dev Stores addresses who are given manager privileges by superManager

    event NewBetContract (
        address indexed _deployer,
        address _contractAddress,
        uint8 indexed _category,
        uint8 indexed _subCategory,
        string _description
    );

    event NewBetting (
        address indexed _betAddress,
        address indexed _bettorAddress,
        uint8 indexed _choice,
        uint256 _betTokensInExaEs
    );

    event EndBetContract (
        address indexed _ender,
        address indexed _contractAddress,
        uint8 _result,
        uint256 _prizePool,
        uint256 _platformFee
    );

    /// @dev This event is for indexing ES withdrawl transactions to winner bettors from this contract
    event TransferES (
        address indexed _betContract,
        address indexed _to,
        uint256 _tokensInExaEs
    );

    modifier onlySuperManager() {
        require(msg.sender == superManager, "only superManager can call");
        _;
    }

    modifier onlyManager() {
        require(isManager[msg.sender], "only manager can call");
        _;
    }

    modifier onlyBetContract() {
        require(isBetValid[msg.sender], "only bet contract can call");
        _;
    }

    /// @notice Sets up BetDeEx smart contract when deployed
    /// @param _esTokenContractAddress is EraSwap contract address
    constructor(address _esTokenContractAddress) public {
        superManager = msg.sender;
        isManager[msg.sender] = true;
        esTokenContract = EraswapToken(_esTokenContractAddress);
    }

    /// @notice This function is used to deploy a new bet
    /// @param _description is the question of Bet in plain English, bettors have to understand the bet description and later choose to bet on yes no or draw according to their preference
    /// @param _category is the broad category for example Sports. Purpose of this is only to filter bets and show in UI, hence the name of the category is not stored in smart contract and category is repressented by a number (0, 1, 2, 3...)
    /// @param _subCategory is a specific category for example Football. Each category will have sub categories represented by a number (0, 1, 2, 3...)
    /// @param _minimumBetInExaEs is the least amount of ExaES that can be betted, any bet participant (bettor) will have to bet this amount or higher. Betting higher amount gives more share of winning amount
    /// @param _prizePercentPerThousand is a form of representation of platform fee. It is a number less than or equal to 1000. For eg 2% is to be collected as platform fee then this value would be 980. If 0.2% then 998.
    /// @param _isDrawPossible is functionality for allowing a draw option
    /// @param _pauseTimestamp Bet will be open for betting until this timestamp, after this timestamp, any user will not be able to place bet. and manager can only end bet after this time
    /// @return address of newly deployed bet contract. This is for UI of Admin panel.
    function createBet(
        string memory _description,
        uint8 _category,
        uint8 _subCategory,
        uint256 _minimumBetInExaEs,
        uint256 _prizePercentPerThousand,
        bool _isDrawPossible,
        uint256 _pauseTimestamp
    ) public onlyManager returns (address) {
        Bet _newBet = new Bet(
          _description,
          _category,
          _subCategory,
          _minimumBetInExaEs,
          _prizePercentPerThousand,
          _isDrawPossible,
          _pauseTimestamp
        );
        bets.push(address(_newBet));
        isBetValid[address(_newBet)] = true;

        emit NewBetContract(
          msg.sender,
          address(_newBet),
          _category,
          _subCategory,
          _description
        );

        return address(_newBet);
    }

    /// @notice this function is used for getting total number of bets
    /// @return number of Bet contracts deployed by BetDeEx
    function getNumberOfBets() public view returns (uint256) {
        return bets.length;
    }







    /// @notice this is for giving access to multiple accounts to manage BetDeEx
    /// @param _manager is address of new manager
    function addManager(address _manager) public onlySuperManager {
        isManager[_manager] = true;
    }

    /// @notice this is for revoking access of a manager to manage BetDeEx
    /// @param _manager is address of manager who is to be converted into a former manager
    function removeManager(address _manager) public onlySuperManager {
        isManager[_manager] = false;
    }

    /// @notice this is an internal functionality that is only for bet contracts to emit a event when a new bet is placed so that front end can get the information by subscribing to  contract
    function emitNewBettingEvent(address _bettorAddress, uint8 _choice, uint256 _betTokensInExaEs) public onlyBetContract {
        emit NewBetting(msg.sender, _bettorAddress, _choice, _betTokensInExaEs);
    }

    /// @notice this is an internal functionality that is only for bet contracts to emit event when a bet is ended so that front end can get the information by subscribing to  contract
    function emitEndEvent(address _ender, uint8 _result, uint256 _gasFee) public onlyBetContract {
        emit EndBetContract(_ender, msg.sender, _result, betBalanceInExaEs[msg.sender], _gasFee);
    }

    /// @notice this is an internal functionality that is used to transfer tokens from bettor wallet to BetDeEx contract
    function collectBettorTokens(address _from, uint256 _betTokensInExaEs) public onlyBetContract returns (bool) {
        require(esTokenContract.transferFrom(_from, address(this), _betTokensInExaEs), "tokens should be collected from user");
        betBalanceInExaEs[msg.sender] = betBalanceInExaEs[msg.sender].add(_betTokensInExaEs);
        return true;
    }

    /// @notice this is an internal functionality that is used to transfer prizes to winners
    function sendTokensToAddress(address _to, uint256 _tokensInExaEs) public onlyBetContract returns (bool) {
        betBalanceInExaEs[msg.sender] = betBalanceInExaEs[msg.sender].sub(_tokensInExaEs);
        require(esTokenContract.transfer(_to, _tokensInExaEs), "tokens should be sent");

        emit TransferES(msg.sender, _to, _tokensInExaEs);
        return true;
    }

    /// @notice this is an internal functionality that is used to collect platform fee
    function collectPlatformFee(uint256 _platformFee) public onlyBetContract returns (bool) {
        require(esTokenContract.transfer(superManager, _platformFee), "platform fee should be collected");
        return true;
    }

}

/// @title Bet Smart Contract
/// @author The EraSwap Team
/// @notice This contract is governs bettors and is deployed by BetDeEx Smart Contract
contract Bet {
    using SafeMath for uint256;

    BetDeEx betDeEx;

    string public description; /// @dev question text of the bet
    bool public isDrawPossible; /// @dev if false then user cannot bet on draw choice
    uint8 public category; /// @dev sports, movies
    uint8 public subCategory; /// @dev cricket, football

    uint8 public finalResult; /// @dev given a value when manager ends bet
    address public endedBy; /// @dev address of manager who enters the correct choice while ending the bet

    uint256 public creationTimestamp; /// @dev set during bet creation
    uint256 public pauseTimestamp; /// @dev set as an argument by deployer
    uint256 public endTimestamp; /// @dev set when a manager ends bet and prizes are distributed

    uint256 public minimumBetInExaEs; /// @dev minimum amount required to enter bet
    uint256 public prizePercentPerThousand; /// @dev percentage of bet balance which will be dristributed to winners and rest is platform fee
    uint256[3] public totalBetTokensInExaEsByChoice = [0, 0, 0]; /// @dev array of total bet value of no, yes, draw voters
    uint256[3] public getNumberOfChoiceBettors = [0, 0, 0]; /// @dev stores number of bettors in a choice

    uint256 public totalPrize; /// @dev this is the prize (platform fee is already excluded)

    mapping(address => uint256[3]) public bettorBetAmountInExaEsByChoice; /// @dev mapps addresses to array of betAmount by choice
    mapping(address => bool) public bettorHasClaimed; /// @dev set to true when bettor claims the prize

    modifier onlyManager() {
        require(betDeEx.isManager(msg.sender), "only manager can call");
        _;
    }

    /// @notice this sets up Bet contract
    /// @param _description is the question of Bet in plain English, bettors have to understand the bet description and later choose to bet on yes no or draw according to their preference
    /// @param _category is the broad category for example Sports. Purpose of this is only to filter bets and show in UI, hence the name of the category is not stored in smart contract and category is repressented by a number (0, 1, 2, 3...)
    /// @param _subCategory is a specific category for example Football. Each category will have sub categories represented by a number (0, 1, 2, 3...)
    /// @param _minimumBetInExaEs is the least amount of ExaES that can be betted, any bet participant (bettor) will have to bet this amount or higher. Betting higher amount gives more share of winning amount
    /// @param _prizePercentPerThousand is a form of representation of platform fee. It is a number less than or equal to 1000. For eg 2% is to be collected as platform fee then this value would be 980. If 0.2% then 998.
    /// @param _isDrawPossible is functionality for allowing a draw option
    /// @param _pauseTimestamp Bet will be open for betting until this timestamp, after this timestamp, any user will not be able to place bet. and manager can only end bet after this time
    constructor(string memory _description, uint8 _category, uint8 _subCategory, uint256 _minimumBetInExaEs, uint256 _prizePercentPerThousand, bool _isDrawPossible, uint256 _pauseTimestamp) public {
        description = _description;
        isDrawPossible = _isDrawPossible;
        category = _category;
        subCategory = _subCategory;
        minimumBetInExaEs = _minimumBetInExaEs;
        prizePercentPerThousand = _prizePercentPerThousand;
        betDeEx = BetDeEx(msg.sender);
        creationTimestamp = now;
        pauseTimestamp = _pauseTimestamp;
    }

    /// @notice this function gives amount of ExaEs that is total betted on this bet
    function betBalanceInExaEs() public view returns (uint256) {
        return betDeEx.betBalanceInExaEs(address(this));
    }

    /// @notice this function is used to place a bet on available choice
    /// @param _choice should be 0, 1, 2; no => 0, yes => 1, draw => 2
    /// @param _betTokensInExaEs is amount of bet
    function enterBet(uint8 _choice, uint256 _betTokensInExaEs) public {
        require(now < pauseTimestamp, "cannot enter after pause time");
        require(_betTokensInExaEs >= minimumBetInExaEs, "betting tokens should be more than minimum");

        /// @dev betDeEx contract transfers the tokens to it self
        require(betDeEx.collectBettorTokens(msg.sender, _betTokensInExaEs), "betting tokens should be collected");

        // @dev _choice can be 0 or 1 and it can be 2 only if isDrawPossible is true
        if (_choice > 2 || (_choice == 2 && !isDrawPossible) ) {
            require(false, "this choice is not available");
        }

        getNumberOfChoiceBettors[_choice] = getNumberOfChoiceBettors[_choice].add(1);
        totalBetTokensInExaEsByChoice[_choice] = totalBetTokensInExaEsByChoice[_choice].add(_betTokensInExaEs);

        bettorBetAmountInExaEsByChoice[msg.sender][_choice] = bettorBetAmountInExaEsByChoice[msg.sender][_choice].add(_betTokensInExaEs);

        betDeEx.emitNewBettingEvent(msg.sender, _choice, _betTokensInExaEs);
    }

    /// @notice this function is used by manager to load correct answer
    /// @param _choice is the correct choice
    function endBet(uint8 _choice) public onlyManager {
        require(now >= pauseTimestamp, "cannot end bet before pause time");
        require(endedBy == address(0), "Bet Already Ended");

        // @dev _choice can be 0 or 1 and it can be 2 only if isDrawPossible is true
        if(_choice < 2  || (_choice == 2 && isDrawPossible)) {
            finalResult = _choice;
        } else {
            require(false, "this choice is not available");
        }

        endedBy = msg.sender;
        endTimestamp = now;

        /// @dev the platform fee is excluded from entire bet balance and this is the amount to be distributed
        totalPrize = betBalanceInExaEs().mul(prizePercentPerThousand).div(1000);

        /// @dev this is the left platform fee according to the totalPrize variable above
        uint256 _platformFee = betBalanceInExaEs().sub(totalPrize);

        /// @dev sending plaftrom fee to the super manager
        require(betDeEx.collectPlatformFee(_platformFee), "platform fee should be collected");

        betDeEx.emitEndEvent(endedBy, _choice, _platformFee);
    }

    /// @notice this function can be called by anyone to see how much winners are getting
    /// @param _bettorAddress is address whose prize we want to see
    /// @return winner prize of input address
    function seeWinnerPrize(address _bettorAddress) public view returns (uint256) {
        require(endTimestamp > 0, "cannot see prize before bet ends");

        return bettorBetAmountInExaEsByChoice[_bettorAddress][finalResult].mul(totalPrize).div(totalBetTokensInExaEsByChoice[finalResult]);
    }

    /// @notice this function will be called after bet ends and winner bettors can withdraw their prize share
    function withdrawPrize() public {
        require(endTimestamp > 0, "cannot withdraw before end time");
        require(!bettorHasClaimed[msg.sender], "cannot claim again");
        require(bettorBetAmountInExaEsByChoice[msg.sender][finalResult] > minimumBetInExaEs, "caller should have a betting"); /// @dev to keep out option 0
        uint256 _winningAmount = bettorBetAmountInExaEsByChoice[msg.sender][finalResult].mul(totalPrize).div(totalBetTokensInExaEsByChoice[finalResult]);
        bettorHasClaimed[msg.sender] = true;
        betDeEx.sendTokensToAddress(
            msg.sender,
            _winningAmount
        );
    }
}