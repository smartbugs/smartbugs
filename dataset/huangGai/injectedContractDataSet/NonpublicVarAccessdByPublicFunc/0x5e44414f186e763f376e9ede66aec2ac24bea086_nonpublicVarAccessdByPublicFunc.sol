pragma solidity ^0.5.2;

// File: zeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address internal owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


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
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

}

// File: zeppelin-solidity/contracts/lifecycle/Pausable.sol

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool internal paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Unpause();
  }
}

// File: zeppelin-solidity/contracts/math/SafeMath.sol

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

// File: zeppelin-solidity/contracts/token/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  uint256 internal totalSupply;
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: zeppelin-solidity/contracts/token/BasicToken.sol

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[_to] = balances[_to].add(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

}

// File: zeppelin-solidity/contracts/token/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: zeppelin-solidity/contracts/token/StandardToken.sol

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    require(_value <= allowed[_from][msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    balances[_from] = balances[_from].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    balances[_to] = balances[_to].add(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _addedValue The amount of tokens to increase the allowance by.
   */
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   *
   * approve should be called when allowed[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param _spender The address which will spend the funds.
   * @param _subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
    uint oldValue = allowed[msg.sender][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    return true;
  }

}

// File: zeppelin-solidity/contracts/token/PausableToken.sol

/**
 * @title Pausable token
 *
 * @dev StandardToken modified with pausable transfers.
 **/

contract PausableToken is StandardToken, Pausable {

  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
    return super.approve(_spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}

// File: contracts/URACToken.sol

/// @title URACToken Contract
/// For more information about this token sale, please visit http://www.uranus.io
/// @author reedhong
contract URACToken is PausableToken {
    using SafeMath for uint;

    /// Constant token specific fields
    string public constant name = "URACToken";
    string public constant symbol = "URAC";
    uint public constant decimals = 18;

    /// URAC total tokens supply
    uint internal currentSupply;

    /// Fields that are only changed in constructor
    /// URAC sale  contract
    address public minter;

    /// Fields that can be changed by functions
    mapping (address => uint) internal lockedBalances;

    /// claim flag
    bool internal claimedFlag;

    /*
     * MODIFIERS
     */
    modifier onlyMinter {
        require(msg.sender == minter);
        _;
    }

    modifier canClaimed {
        require(claimedFlag == true);
        _;
    }

    modifier maxTokenAmountNotReached (uint amount){
        require(currentSupply.add(amount) <= totalSupply);
        _;
    }

    modifier validAddress( address addr ) {
        require(addr != address(0x0));
        require(addr != address(this));
        _;
    }

    /**
     * CONSTRUCTOR
     *
     * @dev Initialize the URAC Token
     * @param _minter The URACCrowdSale Contract
     * @param _maxTotalSupply total supply token
     */
    constructor(address _minter, address _admin, uint _maxTotalSupply)
        public
        validAddress(_admin)
        validAddress(_minter)
        {
        minter = _minter;
        totalSupply = _maxTotalSupply;
        claimedFlag = false;
        transferOwnership(_admin);
    }

    function mintex(uint amount) public onlyOwner {
        balances[msg.sender] = balances[msg.sender].add(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        totalSupply = totalSupply.add(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * EXTERNAL FUNCTION
     *
     * @dev URACCrowdSale contract instance mint token
     * @param receipent The destination account owned mint tokens
     * @param amount The amount of mint token
     * @param isLock Lock token flag
     * be sent to this address.
     */

    function mint(address receipent, uint amount, bool isLock)
        external
        onlyMinter
        maxTokenAmountNotReached(amount)
        returns (bool)
    {
        if (isLock ) {
            lockedBalances[receipent] = lockedBalances[receipent].add(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        } else {
            balances[receipent] = balances[receipent].add(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        currentSupply = currentSupply.add(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }


    function setClaimedFlag(bool flag)
        public
        onlyOwner
    {
        claimedFlag = flag;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

     /*
     * PUBLIC FUNCTIONS
     */

    /// @dev Locking period has passed - Locked tokens have turned into tradeable
    function claimTokens(address[] calldata receipents)
        external
        canClaimed
    {
        for (uint i = 0; i < receipents.length; i++) {
            address receipent = receipents[i];
            //balances[receipent] = balances[receipent].add(lockedBalances[receipent]);
            balances[msg.sender] = balances[msg.sender].add(lockedBalances[receipent]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            transfer(receipent, lockedBalances[receipent]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
            lockedBalances[receipent] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
    }
}

// File: contracts/URACCrowdSale.sol

/// @title URACCrowdSale Contract
/// For more information about this token sale, please visit http://www.uranus.io
/// @author reedhong
contract URACCrowdSale is Pausable {
    using SafeMath for uint;

    /// Constant fields
    /// URAC total tokens supply
    uint public constant URAC_TOTAL_SUPPLY = 3500000000 ether;
    uint internal constant MAX_SALE_DURATION = 10 days;
    uint public constant STAGE_1_TIME =  3 days;
    uint public constant STAGE_2_TIME = 7 days;
    uint public constant MIN_LIMIT = 0.1 ether;
    uint public constant MAX_STAGE_1_LIMIT = 10 ether;

    //uint public constant STAGE_1 = 1;
    //uint public constant STAGE_2 = 2;
    enum STAGE {STAGE_1, STAGE_2}

    /// Exchange rates
    uint internal  exchangeRate = 6200;


    uint public constant MINER_STAKE = 4000;    // for minter
    uint public constant OPEN_SALE_STAKE = 158; // for public
    uint public constant OTHER_STAKE = 5842;    // for others


    uint public constant DIVISOR_STAKE = 10000;

    // max open sale tokens
    uint public constant MAX_OPEN_SOLD = URAC_TOTAL_SUPPLY * OPEN_SALE_STAKE / DIVISOR_STAKE;
    uint public constant STAKE_MULTIPLIER = URAC_TOTAL_SUPPLY / DIVISOR_STAKE;

    /// All deposited ETH will be instantly forwarded to this address.
    address payable internal wallet;
    address payable public minerAddress;
    address payable public otherAddress;

    /// Contribution start time
    uint internal startTime;
    /// Contribution end time
    uint internal endTime;

    /// Fields that can be changed by functions
    /// Accumulator for open sold tokens
    uint public openSoldTokens;
    /// ERC20 compilant URAC token contact instance
    URACToken public uracToken;

    /// tags show address can join in open sale
    mapping (address => bool) internal fullWhiteList;

    mapping (address => uint) public firstStageFund;
 
    /*
     * EVENTS
     */
    event NewSale(address indexed destAddress, uint ethCost, uint gotTokens);
    event NewWallet(address onwer, address oldWallet, address newWallet);

    modifier notEarlierThan(uint x) {
        require(now >= x);
        _;
    }

    modifier earlierThan(uint x) {
        require(now < x);
        _;
    }

    modifier ceilingNotReached() {
        require(openSoldTokens < MAX_OPEN_SOLD);
        _;
    }

    modifier isSaleEnded() {
        require(now > endTime || openSoldTokens >= MAX_OPEN_SOLD);
        _;
    }

    modifier validAddress( address addr ) {
        require(addr != address(0x0));
        require(addr != address(this));
        _;
    }

    constructor (
        address payable _wallet,
        address payable _minerAddress,
        address payable _otherAddress
        ) public
        validAddress(_wallet)
        validAddress(_minerAddress)
        validAddress(_otherAddress)
        {
        paused = true;
        wallet = _wallet;
        minerAddress = _minerAddress;
        otherAddress = _otherAddress;

        openSoldTokens = 0;
        /// Create urac token contract instance
        uracToken = new URACToken(address(this), msg.sender, URAC_TOTAL_SUPPLY);

        uracToken.mint(minerAddress, MINER_STAKE * STAKE_MULTIPLIER, false);
        uracToken.mint(otherAddress, OTHER_STAKE * STAKE_MULTIPLIER, false);
    }

    function setExchangeRate(uint256 rate)
        public
        onlyOwner
        earlierThan(endTime)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    {
        exchangeRate = rate;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setStartTime(uint _startTime )
        public
        onlyOwner
    {
        startTime = _startTime;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        endTime = startTime + MAX_SALE_DURATION;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /// @dev batch set quota for user admin
    /// if openTag <=0, removed
    function setWhiteList(address[] calldata users, bool openTag)
        external
        onlyOwner
        earlierThan(endTime)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    {
        require(saleNotEnd());
        for (uint i = 0; i < users.length; i++) {
            fullWhiteList[users[i]] = openTag;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
    }


    /// @dev batch set quota for early user quota
    /// if openTag <=0, removed
    function addWhiteList(address user, bool openTag)
        external
        onlyOwner
        earlierThan(endTime)	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    {
        require(saleNotEnd());
        fullWhiteList[user] = openTag;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    }

    /// @dev Emergency situation
    function setWallet(address payable newAddress)  external onlyOwner {
        emit NewWallet(owner, wallet, newAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        wallet = newAddress;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /// @return true if sale not ended, false otherwise.
    function saleNotEnd() view internal returns (bool) {
        return now < endTime && openSoldTokens < MAX_OPEN_SOLD;
    }

    /**
     * Fallback function
     *
     * @dev If anybody sends Ether directly to this  contract, consider he is getting URAC token
     */
    function ()external payable {
        buyURAC(msg.sender);
    }

    /*
     * PUBLIC FUNCTIONS
     */
    /// @dev Exchange msg.value ether to URAC for account recepient
    /// @param receipient URAC tokens receiver
    function buyURAC(address receipient)
        internal
        whenNotPaused
        ceilingNotReached
        notEarlierThan(startTime)
        earlierThan(endTime)
        validAddress(receipient)
        returns (bool)
    {
        // Do not allow contracts to game the system
        require(!isContract(msg.sender));
        require(tx.gasprice <= 100000000000 wei);
        require(msg.value >= MIN_LIMIT);

        bool inWhiteListTag = fullWhiteList[receipient];
        require(inWhiteListTag == true);

        STAGE stage = STAGE.STAGE_2;
        if ( startTime <= now && now < startTime + STAGE_1_TIME ) {
            stage = STAGE.STAGE_1;
            require(msg.value <= MAX_STAGE_1_LIMIT);
            uint fund1 = firstStageFund[receipient];
            require (fund1 < MAX_STAGE_1_LIMIT );
        }

        doBuy(receipient, stage);

        return true;
    }


    /// @dev Buy URAC token normally
    function doBuy(address receipient, STAGE stage) internal {
        // protect partner quota in stage one
        uint value = msg.value;

        if ( stage == STAGE.STAGE_1 ) {
            uint fund1 = firstStageFund[receipient];
            fund1 = fund1.add(value);
            if (fund1 > MAX_STAGE_1_LIMIT ) {
                uint refund1 = fund1.sub(MAX_STAGE_1_LIMIT);
                value = value.sub(refund1);
                msg.sender.transfer(refund1);
            }
        }

        uint tokenAvailable = MAX_OPEN_SOLD.sub(openSoldTokens);
        require(tokenAvailable > 0);
        uint toFund;
        uint toCollect;
        (toFund, toCollect) = costAndBuyTokens(tokenAvailable, value);
        if (toFund > 0) {
            require(uracToken.mint(receipient, toCollect, true));
            wallet.transfer(toFund);
            openSoldTokens = openSoldTokens.add(toCollect);
            emit NewSale(receipient, toFund, toCollect);
        }

        // not enough token sale, just return eth
        uint toReturn = value.sub(toFund);
        if (toReturn > 0) {
            msg.sender.transfer(toReturn);
        }

        if ( stage == STAGE.STAGE_1 ) {
            firstStageFund[receipient] = firstStageFund[receipient].add(toFund);
        }
    }

    /// @dev Utility function for calculate available tokens and cost ethers
    function costAndBuyTokens(uint availableToken, uint value) view internal returns (uint costValue, uint getTokens) {
        // all conditions has checked in the caller functions
        getTokens = exchangeRate * value;

        if (availableToken >= getTokens) {
            costValue = value;
        } else {
            costValue = availableToken / exchangeRate;
            getTokens = availableToken;
        }
    }

    /// @dev Internal function to determine if an address is a contract
    /// @param _addr The address being queried
    /// @return True if `_addr` is a contract
    function isContract(address payable _addr) view internal returns(bool) {
        uint size;
        if (_addr == 0x0000000000000000000000000000000000000000) {
            return false;
        }

        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }
}