pragma solidity 0.5.4;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
    c = a + b;
    assert(c >= a);
    return c;
  }
}

/**
 * @title MultiOwnable
 *
 * @dev Require majority approval of multiple owners to use and access to features
 *      when restrictions on access to critical functions are required.
 *
 */

contract MultiOwnable {
    using SafeMath for uint8;

    struct CommitteeStatusPack{
      /**
       * Key informations for decisions.
       * To save some gas, choosing the struct.
       */
        uint8 numOfOwners;
        uint8 numOfVotes;
        uint8 numOfMinOwners;
        bytes proposedFuncData;
    }
    CommitteeStatusPack public committeeStatus;

    address[] public ballot; // To make sure if it already was voted
    mapping(address => bool) public owner;

    event Vote(address indexed proposer, bytes indexed proposedFuncData);
    event Propose(address indexed proposer, bytes indexed proposedFuncData);
    event Dismiss(address indexed proposer, bytes indexed proposedFuncData);
    event AddedOwner(address newOwner);
    event RemovedOwner(address removedOwner);
    event TransferOwnership(address from, address to);


    /**
     * Organize initial committee.
     *
     * @notice committee must be 3 at least.
     *         you have to use this contract to be inherited because it is internal.
     *
     * @param _coOwner1 _coOwner2 _coOwner3 _coOwner4 _coOwner5 committee members
     */
    constructor(address _coOwner1, address _coOwner2, address _coOwner3, address _coOwner4, address _coOwner5) internal {
        require(_coOwner1 != address(0x0) &&
                _coOwner2 != address(0x0) &&
                _coOwner3 != address(0x0) &&
                _coOwner4 != address(0x0) &&
                _coOwner5 != address(0x0));
        require(_coOwner1 != _coOwner2 &&
                _coOwner1 != _coOwner3 &&
                _coOwner1 != _coOwner4 &&
                _coOwner1 != _coOwner5 &&
                _coOwner2 != _coOwner3 &&
                _coOwner2 != _coOwner4 &&
                _coOwner2 != _coOwner5 &&
                _coOwner3 != _coOwner4 &&
                _coOwner3 != _coOwner5 &&
                _coOwner4 != _coOwner5); // SmartDec Recommendations
        owner[_coOwner1] = true;
        owner[_coOwner2] = true;
        owner[_coOwner3] = true;
        owner[_coOwner4] = true;
        owner[_coOwner5] = true;
        committeeStatus.numOfOwners = 5;
        committeeStatus.numOfMinOwners = 5;
        emit AddedOwner(_coOwner1);
        emit AddedOwner(_coOwner2);
        emit AddedOwner(_coOwner3);
        emit AddedOwner(_coOwner4);
        emit AddedOwner(_coOwner5);
    }


    modifier onlyOwner() {
        require(owner[msg.sender]);
        _;
    }

    /**
     * Pre-check if it's decided by committee
     *
     * @notice If there is a majority approval,
     *         the function with this modifier will not be executed.
     */
    modifier committeeApproved() {
      /* check if proposed Function Name and real function Name are correct */
      require( keccak256(committeeStatus.proposedFuncData) == keccak256(msg.data) ); // SmartDec Recommendations

      /* To check majority */
      require(committeeStatus.numOfVotes > committeeStatus.numOfOwners.div(2));
      _;
      _dismiss(); //Once a commission-approved proposal is made, the proposal is initialized.
    }


    /**
     * Suggest the functions you want to use.
     *
     * @notice To use some importan functions, propose function must be done first and voted.
     */
    function propose(bytes memory _targetFuncData) onlyOwner public {
      /* Check if there're any ongoing proposals */
      require(committeeStatus.numOfVotes == 0);
      require(committeeStatus.proposedFuncData.length == 0);

      /* regist function informations that proposer want to run */
      committeeStatus.proposedFuncData = _targetFuncData;
      emit Propose(msg.sender, _targetFuncData);
    }

    /**
     * Proposal is withdrawn
     *
     * @notice When the proposed function is no longer used or deprecated,
     *         proposal is discarded
     */
    function dismiss() onlyOwner public {
      _dismiss();
    }

    /**
     * Suggest the functions you want to use.
     *
     * @notice 'dismiss' is executed even after successfully executing the proposed function.
     *          If 'msg.sender' want to pass permission, he can't pass the 'committeeApproved' modifier.
     *          internal functions are required to enable this.
     */

    function _dismiss() internal {
      emit Dismiss(msg.sender, committeeStatus.proposedFuncData);
      committeeStatus.numOfVotes = 0;
      committeeStatus.proposedFuncData = "";
      delete ballot;
    }


    /**
     * Owners vote for proposed item
     *
     * @notice if only there're proposals, 'vote' is processed.
     *         the result must be majority.
     *         one ticket for each owner.
     */

    function vote() onlyOwner public {
      // Check duplicated voting list.
      uint length = ballot.length; // SmartDec Recommendations
      for(uint i=0; i<length; i++) // SmartDec Recommendations
        require(ballot[i] != msg.sender);

      //onlyOnwers can vote, if there's ongoing proposal.
      require( committeeStatus.proposedFuncData.length != 0 );

      //Check, if everyone voted.
      //require(committeeStatus.numOfOwners > committeeStatus.numOfVotes); // SmartDec Recommendations
      committeeStatus.numOfVotes++;
      ballot.push(msg.sender);
      emit Vote(msg.sender, committeeStatus.proposedFuncData);
    }


    /**
     * Existing owner transfers permissions to new owner.
     *
     * @notice It transfers authority to the person who was not the owner.
     *           Approval from the committee is required.
     */
    function transferOwnership(address _newOwner) onlyOwner committeeApproved public {
        require( _newOwner != address(0x0) ); // callisto recommendation
        require( owner[_newOwner] == false );
        owner[msg.sender] = false;
        owner[_newOwner] = true;
        emit TransferOwnership(msg.sender, _newOwner);
    }

    /**
     * Add new Owner to committee
     *
     * @notice Approval from the committee is required.
     *
     */
    function addOwner(address _newOwner) onlyOwner committeeApproved public {
        require( _newOwner != address(0x0) );
        require( owner[_newOwner] != true );
        owner[_newOwner] = true;
        committeeStatus.numOfOwners++;
        emit AddedOwner(_newOwner);
    }

    /**
     * Remove the Owner from committee
     *
     * @notice Approval from the committee is required.
     *
     */
    function removeOwner(address _toRemove) onlyOwner committeeApproved public {
        require( _toRemove != address(0x0) );
        require( owner[_toRemove] == true );
        require( committeeStatus.numOfOwners > committeeStatus.numOfMinOwners ); // must keep Number of Minimum Owners at least.
        owner[_toRemove] = false;
        committeeStatus.numOfOwners--;
        emit RemovedOwner(_toRemove);
    }
}

contract Pausable is MultiOwnable {
    event Pause();
    event Unpause();

    bool internal paused;

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    modifier whenPaused() {
        require(paused);
        _;
    }

    modifier noReentrancy() {
        require(!paused);
        paused = true;
        _;
        paused = false;
    }

    /* When you discover your smart contract is under attack, you can buy time to upgrade the contract by
       immediately pausing the contract.
     */
    function pause() public onlyOwner committeeApproved whenNotPaused {
        paused = true;
        emit Pause();
    }

    function unpause() public onlyOwner committeeApproved whenPaused {
        paused = false;
        emit Unpause();
    }
}

/**
 * Contract Managing TokenExchanger's address used by ProxyNemodax
 */
contract RunningContractManager is Pausable {
    address public implementation; //SmartDec Recommendations

    event Upgraded(address indexed newContract);

    function upgrade(address _newAddr) onlyOwner committeeApproved external {
        require(implementation != _newAddr);
        implementation = _newAddr;
        emit Upgraded(_newAddr); // SmartDec Recommendations
    }

    /* SmartDec Recommendations
    function runningAddress() onlyOwner external view returns (address){
        return implementation;
    }
    */
}



/**
 * NemoLab ERC20 Token
 * Written by Shin HyunJae
 * version 12
 */
contract TokenERC20 is RunningContractManager {
    using SafeMath for uint256;

    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;
    //mapping (address => bool) public frozenAccount; // SmartDec Recommendations
    mapping (address => uint256) public frozenExpired;

    //bool private initialized = false;
    bool private initialized; // SmartDec Recommendations

    /**
     * This is area for some variables to add.
     * Please add variables from the end of pre-declared variables
     * if you would have added some variables and re-deployed the contract,
     * tokenPerEth would get garbage value. so please reset tokenPerEth variable
     *
     * uint256 something..;
     */


    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);
    event LastBalance(address indexed account, uint256 value);

    // This notifies clients about the allowance of balance
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    // This notifies clients about the amount burnt
    // event Burn(address indexed from, uint256 value); // callisto recommendation

    // This notifies clients about the freezing address
    //event FrozenFunds(address target, bool frozen); // callisto recommendation
    event FrozenFunds(address target, uint256 expirationDate); // SmartDec Recommendations

    /**
     * Initialize Token Function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */

    function initToken(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint256 _initialSupply,
        address _marketSaleManager,
        address _serviceOperationManager,
        address _dividendManager,
        address _incentiveManager,
        address _reserveFundManager
    ) internal onlyOwner committeeApproved {
        require( initialized == false );
        require(_initialSupply > 0 && _initialSupply <= 2**uint256(184)); // [2019.03.05] Fixed for Mythril Vulerablity SWC ID:101 => _initialSupply <= 2^184 <= (2^256 / 10^18)

        name = _tokenName;                                       // Set the name for display purposes
        symbol = _tokenSymbol;                                   // Set the symbol for display purposes
        //totalSupply = convertToDecimalUnits(_initialSupply);     // Update total supply with the decimal amount

        /*balances[msg.sender] = totalSupply;                     // Give the creator all initial tokens
        emit Transfer(address(this), address(0), totalSupply);
        emit LastBalance(address(this), 0);
        emit LastBalance(msg.sender, totalSupply);*/

        // SmartDec Recommendations
        uint256 tempSupply = convertToDecimalUnits(_initialSupply);

        uint256 dividendBalance = tempSupply.div(10);               // dividendBalance = 10%
        uint256 reserveFundBalance = dividendBalance;               // reserveFundBalance = 10%
        uint256 marketSaleBalance = tempSupply.div(5);              // marketSaleBalance = 20%
        uint256 serviceOperationBalance = marketSaleBalance.mul(2); // serviceOperationBalance = 40%
        uint256 incentiveBalance = marketSaleBalance;               // incentiveBalance = 20%

        balances[_marketSaleManager] = marketSaleBalance;
        balances[_serviceOperationManager] = serviceOperationBalance;
        balances[_dividendManager] = dividendBalance;
        balances[_incentiveManager] = incentiveBalance;
        balances[_reserveFundManager] = reserveFundBalance;

        totalSupply = tempSupply;

        emit Transfer(address(0), _marketSaleManager, marketSaleBalance);
        emit Transfer(address(0), _serviceOperationManager, serviceOperationBalance);
        emit Transfer(address(0), _dividendManager, dividendBalance);
        emit Transfer(address(0), _incentiveManager, incentiveBalance);
        emit Transfer(address(0), _reserveFundManager, reserveFundBalance);

        emit LastBalance(address(this), 0);
        emit LastBalance(_marketSaleManager, marketSaleBalance);
        emit LastBalance(_serviceOperationManager, serviceOperationBalance);
        emit LastBalance(_dividendManager, dividendBalance);
        emit LastBalance(_incentiveManager, incentiveBalance);
        emit LastBalance(_reserveFundManager, reserveFundBalance);

        assert( tempSupply ==
          marketSaleBalance.add(serviceOperationBalance).
                            add(dividendBalance).
                            add(incentiveBalance).
                            add(reserveFundBalance)
        );


        initialized = true;
    }


    /**
     * Convert tokens units to token decimal units
     *
     * @param _value Tokens units without decimal units
     */
    function convertToDecimalUnits(uint256 _value) internal view returns (uint256 value) {
        value = _value.mul(10 ** uint256(decimals));
        return value;
    }

    /**
     * Get tokens balance
     *
     * @notice Query tokens balance of the _account
     *
     * @param _account Account address to query tokens balance
     */
    function balanceOf(address _account) public view returns (uint256 balance) {
        balance = balances[_account];
        return balance;
    }

    /**
     * Get allowed tokens balance
     *
     * @notice Query tokens balance allowed to _spender
     *
     * @param _owner Owner address to query tokens balance
     * @param _spender The address allowed tokens balance
     */
    function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
        remaining = allowed[_owner][_spender];
        return remaining;
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0x0));                                            // Prevent transfer to 0x0 address.
        require(balances[_from] >= _value);                             // Check if the sender has enough
        if(frozenExpired[_from] != 0 ){                                 // Check if sender is frozen
            require(block.timestamp > frozenExpired[_from]);
            _unfreezeAccount(_from);
        }
        if(frozenExpired[_to] != 0 ){                                   // Check if recipient is frozen
            require(block.timestamp > frozenExpired[_to]);
            _unfreezeAccount(_to);
        }

        uint256 previousBalances = balances[_from].add(balances[_to]);  // Save this for an assertion in the future

        balances[_from] = balances[_from].sub(_value);                  // Subtract from the sender
        balances[_to] = balances[_to].add(_value);                      // Add the same to the recipient
        emit Transfer(_from, _to, _value);
        emit LastBalance(_from, balances[_from]);
        emit LastBalance(_to, balances[_to]);

        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balances[_from] + balances[_to] == previousBalances);
    }

    /**
     * Transfer tokens
     *
     * @notice Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public noReentrancy returns (bool success) {
        _transfer(msg.sender, _to, _value);
        success = true;
        return success;
    }


    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint256 _value) public noReentrancy returns (bool success) {
        require(_value <= allowed[_from][msg.sender]);     // Check allowance
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        success = true;
        return success;
    }

    /**
     * Internal approve, only can be called by this contract
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function _approve(address _spender, uint256 _value) internal returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        success = true;
        return success;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public noReentrancy returns (bool success) {
        success = _approve(_spender, _value);
        return success;
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
    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
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
    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
      uint256 oldValue = allowed[msg.sender][_spender];
      if (_subtractedValue >= oldValue) {
        allowed[msg.sender][_spender] = 0;
      } else {
        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
      }
      emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
      return true;
    }




    /// @notice `freeze? Prevent` `target` from sending & receiving tokens
    /// @param target Address to be frozen
    function freezeAccount(address target, uint256 freezeExpiration) onlyOwner committeeApproved public {
        frozenExpired[target] = freezeExpiration;
        //emit FrozenFunds(target, true);
        emit FrozenFunds(target, freezeExpiration); // SmartDec Recommendations
    }

    /// @notice  `freeze? Allow` `target` from sending & receiving tokens
    /// @notice if expiration date was over, when this is called with transfer transaction, auto-unfreeze is occurred without committeeApproved
    ///         the reason why it's separated from wrapper function.
    /// @param target Address to be unfrozen
    function _unfreezeAccount(address target) internal returns (bool success) {
        frozenExpired[target] = 0;
        //emit FrozenFunds(target, false);
        emit FrozenFunds(target, 0); // SmartDec Recommendations
        success = true;
        return success;
    }

    /// @notice _unfreezeAccount wrapper function.
    /// @param target Address to be unfrozen
    function unfreezeAccount(address target) onlyOwner committeeApproved public returns(bool success) {
        success = _unfreezeAccount(target);
        return success;
    }

}


/**
 * @title TokenExchanger
 * @notice This is for exchange between Ether and 'Nemo' token
 *          It won't be needed after being listed on the exchange.
 */

contract TokenExchanger is TokenERC20{
  using SafeMath for uint256;

    uint256 internal tokenPerEth;
    bool public opened;

    event ExchangeEtherToToken(address indexed from, uint256 etherValue, uint256 tokenPerEth);
    event ExchangeTokenToEther(address indexed from, uint256 etherValue, uint256 tokenPerEth);
    event WithdrawToken(address indexed to, uint256 value);
    event WithdrawEther(address indexed to, uint256 value);
    event SetExchangeRate(address indexed from, uint256 tokenPerEth);


    constructor(address _coOwner1,
                address _coOwner2,
                address _coOwner3,
                address _coOwner4,
                address _coOwner5)
        MultiOwnable( _coOwner1, _coOwner2, _coOwner3, _coOwner4, _coOwner5) public { opened = true; }

    /**
     * Initialize Exchanger Function
     *
     * Initialize Exchanger contract with tokenPerEth
     * and Initialize NemoCoin by calling initToken
     * It would call initToken in TokenERC20 with _tokenName, _tokenSymbol, _initalSupply
     * Last five arguments are manager account to supply currency (_marketSaleManager, _serviceOperationManager, _dividendManager, _incentiveManager, _reserveFundManager)
     *
     */
    function initExchanger(
        string calldata _tokenName,
        string calldata _tokenSymbol,
        uint256 _initialSupply,
        uint256 _tokenPerEth,
        address _marketSaleManager,
        address _serviceOperationManager,
        address _dividendManager,
        address _incentiveManager,
        address _reserveFundManager
    ) external onlyOwner committeeApproved {
        require(opened);
        //require(_tokenPerEth > 0 && _initialSupply > 0);  // [2019.03.05] Fixed for Mythril Vulerablity SWC ID:101
        require(_tokenPerEth > 0); // SmartDec Recommendations
        require(_marketSaleManager != address(0) &&
                _serviceOperationManager != address(0) &&
                _dividendManager != address(0) &&
                _incentiveManager != address(0) &&
                _reserveFundManager != address(0));
        require(_marketSaleManager != _serviceOperationManager &&
                _marketSaleManager != _dividendManager &&
                _marketSaleManager != _incentiveManager &&
                _marketSaleManager != _reserveFundManager &&
                _serviceOperationManager != _dividendManager &&
                _serviceOperationManager != _incentiveManager &&
                _serviceOperationManager != _reserveFundManager &&
                _dividendManager != _incentiveManager &&
                _dividendManager != _reserveFundManager &&
                _incentiveManager != _reserveFundManager); // SmartDec Recommendations

        super.initToken(_tokenName, _tokenSymbol, _initialSupply,
          // SmartDec Recommendations
          _marketSaleManager,
          _serviceOperationManager,
          _dividendManager,
          _incentiveManager,
          _reserveFundManager
        );
        tokenPerEth = _tokenPerEth;
        emit SetExchangeRate(msg.sender, tokenPerEth);
    }


    /**
     * Change tokenPerEth variable only by owner
     *
     * Because "TokenExchaner" is only used until be listed on the exchange,
     * tokenPerEth is needed by then and it would be managed by manager.
     */
    function setExchangeRate(uint256 _tokenPerEth) onlyOwner committeeApproved external returns (bool success){
        require(opened);
        require( _tokenPerEth > 0);
        tokenPerEth = _tokenPerEth;
        emit SetExchangeRate(msg.sender, tokenPerEth);

        success = true;
        return success;
    }

    function getExchangerRate() external view returns(uint256){
        return tokenPerEth;
    }

    /**
     * Exchange Ether To Token
     *
     * @notice Send `Nemo` tokens to msg sender as much as amount of ether received considering exchangeRate.
     */
    function exchangeEtherToToken() payable external noReentrancy returns (bool success){
        require(opened);
        uint256 tokenPayment;
        uint256 ethAmount = msg.value;

        require(ethAmount > 0);
        require(tokenPerEth != 0);
        tokenPayment = ethAmount.mul(tokenPerEth);

        super._transfer(address(this), msg.sender, tokenPayment);

        emit ExchangeEtherToToken(msg.sender, msg.value, tokenPerEth);

        success = true;
        return success;
    }

    /**
     * Exchange Token To Ether
     *
     * @notice Send Ether to msg sender as much as amount of 'Nemo' Token received considering exchangeRate.
     *
     * @param _value Amount of 'Nemo' token
     */
    function exchangeTokenToEther(uint256 _value) external noReentrancy returns (bool success){
      require(opened);
      require(tokenPerEth != 0);

      uint256 remainingEthBalance = address(this).balance;
      uint256 etherPayment = _value.div(tokenPerEth);
      uint256 remainder = _value % tokenPerEth; // [2019.03.06 Fixing Securify vulnerabilities-Division influences Transfer Amount]
      require(remainingEthBalance >= etherPayment);

      uint256 tokenAmount = _value.sub(remainder); // [2019.03.06 Fixing Securify vulnerabilities-Division influences Transfer Amount]
      super._transfer(msg.sender, address(this), tokenAmount); // [2019.03.06 Fixing Securify vulnerabilities-Division influences Transfer Amount]
      //require(address(msg.sender).send(etherPayment));
      address(msg.sender).transfer(etherPayment); // SmartDec Recommendations

      emit ExchangeTokenToEther(address(this), etherPayment, tokenPerEth);
      success = true;
      return success;
    }

    /**
     * Withdraw token from TokenExchanger contract
     *
     * @notice Withdraw charged Token to _recipient.
     *
     * @param _recipient The address to which the token was issued.
     * @param _value Amount of token to withdraw.
     */
    function withdrawToken(address _recipient, uint256 _value) onlyOwner committeeApproved noReentrancy public {
      //require(opened);
      super._transfer(address(this) ,_recipient, _value);
      emit WithdrawToken(_recipient, _value);
    }


    /**
     * Withdraw Ether from TokenExchanger contract
     *
     * @notice Withdraw charged Ether to _recipient.
     *
     * @param _recipient The address to which the Ether was issued.
     * @param _value Amount of Ether to withdraw.
     */
    function withdrawEther(address payable _recipient, uint256 _value) onlyOwner committeeApproved noReentrancy public {
        //require(opened);
        //require(_recipient.send(_value));
        _recipient.transfer(_value);	//injected SHORT ADDRESS ATTACK
 // SmartDec Recommendations
        emit WithdrawEther(_recipient, _value);
    }

    /**
     * close the TokenExchanger functions permanently
     *
     * @notice This contract would be closed when the coin is actively traded and judged that its TokenExchanger function is not needed.
     */
    function closeExchanger() onlyOwner committeeApproved external {
        opened = false;
    }
}


/**
 * @title NemodaxStorage
 *
 * @dev This is contract for proxyNemodax data order list.
 *      Contract shouldn't be changed as possible.
 *      If it should be edited, please add from the end of the contract .
 */

contract NemodaxStorage is RunningContractManager {

    // Never ever change the order of variables below!!!!
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    /* This creates an array with all balances */
    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;
    mapping (address => uint256) public frozenExpired; // SmartDec Recommendations

    bool private initialized;

    uint256 internal tokenPerEth;
    bool public opened = true;
}

/**
 * @title ProxyNemodax
 *
 * @dev The only fallback function will forward transaction to TokenExchanger Contract.
 *      and the result of calculation would be stored in ProxyNemodax
 *
 */

contract ProxyNemodax is NemodaxStorage {

    /* Initialize new committee. this will be real committee accounts, not from TokenExchanger contract */
    constructor(address _coOwner1,
                address _coOwner2,
                address _coOwner3,
                address _coOwner4,
                address _coOwner5)
        MultiOwnable( _coOwner1, _coOwner2, _coOwner3, _coOwner4, _coOwner5) public {}

    function () payable external {
        address localImpl = implementation;
        require(localImpl != address(0x0));

        assembly {
            let ptr := mload(0x40)

            switch calldatasize
            case 0 {  } // just to receive ethereum

            default{
                calldatacopy(ptr, 0, calldatasize)

                let result := delegatecall(gas, localImpl, ptr, calldatasize, 0, 0)
                let size := returndatasize
                returndatacopy(ptr, 0, size)
                switch result

                case 0 { revert(ptr, size) }
                default { return(ptr, size) }
            }
        }
    }
}