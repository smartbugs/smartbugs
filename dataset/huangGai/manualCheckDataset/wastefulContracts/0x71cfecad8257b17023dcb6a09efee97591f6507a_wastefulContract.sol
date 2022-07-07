pragma solidity 0.5.6;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
  external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
  external returns (bool);

  function transferFrom(address from, address to, uint256 value)
  external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
  /**
   * @dev Multiplies two unsigned integers, reverts on overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Adds two unsigned integers, reverts on overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
   * reverts when dividing by zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract ERC20 is IERC20 {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;

  uint256 private _totalSupply;

  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param owner The address to query the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address owner) public view returns (uint256) {
    return _balances[owner];
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param owner address The address which owns the funds.
   * @param spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(
    address owner,
    address spender
  )
  public
  view
  returns (uint256)
  {
    return _allowed[owner][spender];
  }

  /**
  * @dev Transfer token for a specified address
  * @param to The address to transfer to.
  * @param value The amount to be transferred.
  */
  function transfer(address to, uint256 value) public returns (bool) {
    _transfer(msg.sender, to, value);

    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param spender The address which will spend the funds.
   * @param value The amount of tokens to be spent.
   */
  function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = value;

    emit Approval(msg.sender, spender, value);

    return true;
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param from address The address which you want to send tokens from
   * @param to address The address which you want to transfer to
   * @param value uint256 the amount of tokens to be transferred
   */
  function transferFrom(
    address from,
    address to,
    uint256 value
  )
  public
  returns (bool)
  {
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    _transfer(from, to, value);

    return true;
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param spender The address which will spend the funds.
   * @param addedValue The amount of tokens to increase the allowance by.
   */
  function increaseAllowance(
    address spender,
    uint256 addedValue
  )
  public
  returns (bool)
  {
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
    _allowed[msg.sender][spender].add(addedValue));

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param spender The address which will spend the funds.
   * @param subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  )
  public
  returns (bool)
  {
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
    _allowed[msg.sender][spender].sub(subtractedValue));

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);

    return true;
  }

  /**
  * @dev Transfer token for a specified addresses
  * @param from The address to transfer from.
  * @param to The address to transfer to.
  * @param value The amount to be transferred.
  */
  function _transfer(address from, address to, uint256 value) internal {
    require(to != address(0));

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);

    emit Transfer(from, to, value);
  }

  /**
   * @dev Internal function that mints an amount of the token and assigns it to
   * an account. This encapsulates the modification of balances such that the
   * proper events are emitted.
   * @param account The account that will receive the created tokens.
   * @param value The amount that will be created.
   */
  function _mint(address account, uint256 value) internal {
    require(account != address(0));

    _totalSupply = _totalSupply.add(value);
    _balances[account] = _balances[account].add(value);

    emit Transfer(address(0), account, value);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account.
   * @param account The account whose tokens will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burn(address account, uint256 value) internal {
    require(account != address(0));

    _totalSupply = _totalSupply.sub(value);
    _balances[account] = _balances[account].sub(value);

    emit Transfer(account, address(0), value);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account, deducting from the sender's allowance for said account. Uses the
   * internal burn function.
   * @param account The account whose tokens will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burnFrom(address account, uint256 value) internal {
    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
    // this function needs to emit an event with the updated approval.
    _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
      value);
    _burn(account, value);
  }
}

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {

  using SafeMath for uint256;

  function safeTransfer(
    IERC20 token,
    address to,
    uint256 value
  )
  internal
  {
    require(token.transfer(to, value));
  }

  function safeTransferFrom(
    IERC20 token,
    address from,
    address to,
    uint256 value
  )
  internal
  {
    require(token.transferFrom(from, to, value));
  }

  function safeApprove(
    IERC20 token,
    address spender,
    uint256 value
  )
  internal
  {
    // safeApprove should only be called when setting an initial allowance,
    // or when resetting it to zero. To increase and decrease it, use
    // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
    require((value == 0) || (token.allowance(msg.sender, spender) == 0));
    require(token.approve(spender, value));
  }

  function safeIncreaseAllowance(
    IERC20 token,
    address spender,
    uint256 value
  )
  internal
  {
    uint256 newAllowance = token.allowance(address(this), spender).add(value);
    require(token.approve(spender, newAllowance));
  }

  function safeDecreaseAllowance(
    IERC20 token,
    address spender,
    uint256 value
  )
  internal
  {
    uint256 newAllowance = token.allowance(address(this), spender).sub(value);
    require(token.approve(spender, newAllowance));
  }
}

/**
 * @title ERC20Detailed token
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 */
contract ERC20Detailed is IERC20 {
  string private _name;
  string private _symbol;
  uint8 private _decimals;

  constructor(string memory name, string memory symbol, uint8 decimals) public {
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
  }

  /**
   * @return the name of the token.
   */
  function name() public view returns(string memory) {
    return _name;
  }

  /**
   * @return the symbol of the token.
   */
  function symbol() public view returns(string memory) {
    return _symbol;
  }

  /**
   * @return the number of decimals of the token.
   */
  function decimals() public view returns(uint8) {
    return _decimals;
  }
}

contract Ownable {
  address payable public owner;
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
  function transferOwnership(address payable newOwner) public onlyOwner {
    require(newOwner != address(0));
    owner = newOwner;
  }
}



contract GameWave is ERC20, ERC20Detailed, Ownable {

  uint paymentsTime = block.timestamp;
  uint totalPaymentAmount;
  uint lastTotalPaymentAmount;
  uint minted = 20000000;

  mapping (address => uint256) lastWithdrawTime;

  /**
   * @dev The GW constructor sets the original variables
   * specified in the contract ERC20Detailed.
   */
  constructor() public ERC20Detailed("Game wave token", "GWT", 18) {
    _mint(msg.sender, minted * (10 ** uint256(decimals())));
  }

  /**
    * Fallback function
    *
    * The function without name is the default function that is called whenever anyone sends funds to a contract.
    */
  function () payable external {
    if (msg.value == 0){
      withdrawDividends(msg.sender);
    }
  }

  /**
    * @notice This function allows the investor to see the amount of dividends available for withdrawal.
    * @param _holder this is the address of the investor, where you can see the number of diverders available for withdrawal.
    * @return An uint the value available for the removal of dividends.
    */
  function getDividends(address _holder) view public returns(uint) {
    if (paymentsTime >= lastWithdrawTime[_holder]){
      return totalPaymentAmount.mul(balanceOf(_holder)).div(minted * (10 ** uint256(decimals())));
    } else {
      return 0;
    }
  }

  /**
    * @notice This function allows the investor to withdraw dividends available for withdrawal.
    * @param _holder this is the address of the investor, by which there is a withdrawal available to dividend.
    * @return An uint value of removed dividends.
    */
  function withdrawDividends(address payable _holder) public returns(uint) {
    uint dividends = getDividends(_holder);
    lastWithdrawTime[_holder] = block.timestamp;
    lastTotalPaymentAmount = lastTotalPaymentAmount.add(dividends);
    _holder.transfer(dividends);
  }

  /**
  * @notice This function initializes payments with a period of 30 days.
  *
  */

  function startPayments() public {
    require(true);
    owner.transfer(totalPaymentAmount.sub(lastTotalPaymentAmount));
    totalPaymentAmount = address(this).balance;
    paymentsTime = block.timestamp;
    lastTotalPaymentAmount = 0;
  	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
}

/*
* @title Bank
* @dev Bank contract which contained all ETH from Bears and Bulls teams.
* When time in blockchain will be grater then current deadline or last deadline need call getWinner function
* then participants able get prizes.
*
* Last participant(last hero) win 10% from all bank
*
* - To get prize send 0 ETH to this contract
*/
contract Bank is Ownable {

    using SafeMath for uint256;

    mapping (uint256 => mapping (address => uint256)) public depositBears;
    mapping (uint256 => mapping (address => uint256)) public depositBulls;

    uint256 public currentDeadline;
    uint256 public currentRound = 1;
    uint256 public lastDeadline;
    uint256 public defaultCurrentDeadlineInHours = 24;
    uint256 public defaultLastDeadlineInHours = 48;
    uint256 public countOfBears;
    uint256 public countOfBulls;
    uint256 public totalSupplyOfBulls;
    uint256 public totalSupplyOfBears;
    uint256 public totalGWSupplyOfBulls;
    uint256 public totalGWSupplyOfBears;
    uint256 public probabilityOfBulls;
    uint256 public probabilityOfBears;
    address public lastHero;
    address public lastHeroHistory;
    uint256 public jackPot;
    uint256 public winner;
    uint256 public withdrawn;
    uint256 public withdrawnGW;
    uint256 public remainder;
    uint256 public remainderGW;
    uint256 public rate = 1;
    uint256 public rateModifier = 0;
    uint256 public tokenReturn;
    address crowdSale;

    uint256 public lastTotalSupplyOfBulls;
    uint256 public lastTotalSupplyOfBears;
    uint256 public lastTotalGWSupplyOfBulls;
    uint256 public lastTotalGWSupplyOfBears;
    uint256 public lastProbabilityOfBulls;
    uint256 public lastProbabilityOfBears;
    address public lastRoundHero;
    uint256 public lastJackPot;
    uint256 public lastWinner;
    uint256 public lastBalance;
    uint256 public lastBalanceGW;
    uint256 public lastCountOfBears;
    uint256 public lastCountOfBulls;
    uint256 public lastWithdrawn;
    uint256 public lastWithdrawnGW;


    bool public finished = false;

    Bears public BearsContract;
    Bulls public BullsContract;
    GameWave public GameWaveContract;

    /*
    * @dev Constructor create first deadline
    */
    constructor(address _crowdSale) public {
        _setRoundTime(6, 8);
        crowdSale = _crowdSale;
    }

    /**
    * @dev Setter token rate.
    * @param _rate this value for change percent relation rate to count of tokens.
    * @param _rateModifier this value for change math operation under tokens.
    */
    function setRateToken(uint256 _rate, uint256 _rateModifier) public onlyOwner returns(uint256){
        rate = _rate;
        rateModifier = _rateModifier;
    }

    /**
    * @dev Setter crowd sale address.
    * @param _crowdSale Address of the crowd sale contract.
    */
    function setCrowdSale(address _crowdSale) public onlyOwner{
        crowdSale = _crowdSale;
    }

    /**
    * @dev Setter round time.
    * @param _currentDeadlineInHours this value current deadline in hours.
    * @param _lastDeadlineInHours this value last deadline in hours.
    */
    function _setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) internal {
        defaultCurrentDeadlineInHours = _currentDeadlineInHours;
        defaultLastDeadlineInHours = _lastDeadlineInHours;
        currentDeadline = block.timestamp + 60 * 60 * _currentDeadlineInHours;
        lastDeadline = block.timestamp + 60 * 60 * _lastDeadlineInHours;
    }

    /**
    * @dev Setter round time.
    * @param _currentDeadlineInHours this value current deadline in hours.
    * @param _lastDeadlineInHours this value last deadline in hours.
    */
    function setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) public onlyOwner {
        _setRoundTime(_currentDeadlineInHours, _lastDeadlineInHours);
    }


    /**
    * @dev Setter the GameWave contract address. Address can be set at once.
    * @param _GameWaveAddress Address of the GameWave contract
    */
    function setGameWaveAddress(address payable _GameWaveAddress) public {
        require(address(GameWaveContract) == address(0x0));
        GameWaveContract = GameWave(_GameWaveAddress);
    }

    /**
    * @dev Setter the Bears contract address. Address can be set at once.
    * @param _bearsAddress Address of the Bears contract
    */
    function setBearsAddress(address payable _bearsAddress) external {
        require(address(BearsContract) == address(0x0));
        BearsContract = Bears(_bearsAddress);
    }

    /**
    * @dev Setter the Bulls contract address. Address can be set at once.
    * @param _bullsAddress Address of the Bulls contract
    */
    function setBullsAddress(address payable _bullsAddress) external {
        require(address(BullsContract) == address(0x0));
        BullsContract = Bulls(_bullsAddress);
    }

    /**
    * @dev Getting time from blockchain for timer
    */
    function getNow() view public returns(uint){
        return block.timestamp;
    }

    /**
    * @dev Getting state of game. True - game continue, False - game stopped
    */
    function getState() view public returns(bool) {
        if (block.timestamp > currentDeadline) {
            return false;
        }
        return true;
    }

    /**
    * @dev Setting info about participant from Bears or Bulls contract
    * @param _lastHero Address of participant
    * @param _deposit Amount of deposit
    */
    function setInfo(address _lastHero, uint256 _deposit) public {
        require(address(BearsContract) == msg.sender || address(BullsContract) == msg.sender);

        if (address(BearsContract) == msg.sender) {
            require(depositBulls[currentRound][_lastHero] == 0, "You are already in bulls team");
            if (depositBears[currentRound][_lastHero] == 0)
                countOfBears++;
            totalSupplyOfBears = totalSupplyOfBears.add(_deposit.mul(90).div(100));
            depositBears[currentRound][_lastHero] = depositBears[currentRound][_lastHero].add(_deposit.mul(90).div(100));
        }

        if (address(BullsContract) == msg.sender) {
            require(depositBears[currentRound][_lastHero] == 0, "You are already in bears team");
            if (depositBulls[currentRound][_lastHero] == 0)
                countOfBulls++;
            totalSupplyOfBulls = totalSupplyOfBulls.add(_deposit.mul(90).div(100));
            depositBulls[currentRound][_lastHero] = depositBulls[currentRound][_lastHero].add(_deposit.mul(90).div(100));
        }

        lastHero = _lastHero;

        if (currentDeadline.add(120) <= lastDeadline) {
            currentDeadline = currentDeadline.add(120);
        } else {
            currentDeadline = lastDeadline;
        }

        jackPot += _deposit.mul(10).div(100);

        calculateProbability();
    }

    function estimateTokenPercent(uint256 _difference) public view returns(uint256){
        if (rateModifier == 0) {
            return _difference.mul(rate);
        } else {
            return _difference.div(rate);
        }
    }

    /**
    * @dev Calculation probability for team's win
    */
    function calculateProbability() public {
        require(winner == 0 && getState());

        totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract));
        totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract));
        uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100);

        if (totalGWSupplyOfBulls < 1 ether) {
            totalGWSupplyOfBulls = 0;
        }

        if (totalGWSupplyOfBears < 1 ether) {
            totalGWSupplyOfBears = 0;
        }

        if (totalGWSupplyOfBulls <= totalGWSupplyOfBears) {
            uint256 difference = totalGWSupplyOfBears.sub(totalGWSupplyOfBulls).div(0.01 ether);

            probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(estimateTokenPercent(difference));

            if (probabilityOfBears > 8000) {
                probabilityOfBears = 8000;
            }
            if (probabilityOfBears < 2000) {
                probabilityOfBears = 2000;
            }
            probabilityOfBulls = 10000 - probabilityOfBears;
        } else {
            uint256 difference = totalGWSupplyOfBulls.sub(totalGWSupplyOfBears).div(0.01 ether);
            probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(estimateTokenPercent(difference));

            if (probabilityOfBulls > 8000) {
                probabilityOfBulls = 8000;
            }
            if (probabilityOfBulls < 2000) {
                probabilityOfBulls = 2000;
            }
            probabilityOfBears = 10000 - probabilityOfBulls;
        }

        totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract));
        totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract));
    }

    /**
    * @dev Getting winner team
    */
    function getWinners() public {
        require(true);
        uint256 seed1 = address(this).balance;
        uint256 seed2 = totalSupplyOfBulls;
        uint256 seed3 = totalSupplyOfBears;
        uint256 seed4 = totalGWSupplyOfBulls;
        uint256 seed5 = totalGWSupplyOfBulls;
        uint256 seed6 = block.difficulty;
        uint256 seed7 = block.timestamp;

        bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
        uint randomNumber = uint(randomHash);

        if (randomNumber == 0){
            randomNumber = 1;
        }

        uint winningNumber = randomNumber % 10000;

        if (1 <= winningNumber && winningNumber <= probabilityOfBears){
            winner = 1;
        }

        if (probabilityOfBears < winningNumber && winningNumber <= 10000){
            winner = 2;
        }

        if (GameWaveContract.balanceOf(address(BullsContract)) > 0)
            GameWaveContract.transferFrom(
                address(BullsContract),
                address(this),
                GameWaveContract.balanceOf(address(BullsContract))
            );

        if (GameWaveContract.balanceOf(address(BearsContract)) > 0)
            GameWaveContract.transferFrom(
                address(BearsContract),
                address(this),
                GameWaveContract.balanceOf(address(BearsContract))
            );

        lastTotalSupplyOfBulls = totalSupplyOfBulls;
        lastTotalSupplyOfBears = totalSupplyOfBears;
        lastTotalGWSupplyOfBears = totalGWSupplyOfBears;
        lastTotalGWSupplyOfBulls = totalGWSupplyOfBulls;
        lastRoundHero = lastHero;
        lastJackPot = jackPot;
        lastWinner = winner;
        lastCountOfBears = countOfBears;
        lastCountOfBulls = countOfBulls;
        lastWithdrawn = withdrawn;
        lastWithdrawnGW = withdrawnGW;

        if (lastBalance > lastWithdrawn){
            remainder = lastBalance.sub(lastWithdrawn);
            address(GameWaveContract).transfer(remainder);
        }

        lastBalance = lastTotalSupplyOfBears.add(lastTotalSupplyOfBulls).add(lastJackPot);

        if (lastBalanceGW > lastWithdrawnGW){
            remainderGW = lastBalanceGW.sub(lastWithdrawnGW);
            tokenReturn = (totalGWSupplyOfBears.add(totalGWSupplyOfBulls)).mul(20).div(100).add(remainderGW);
            GameWaveContract.transfer(crowdSale, tokenReturn);
        }

        lastBalanceGW = GameWaveContract.balanceOf(address(this));

        totalSupplyOfBulls = 0;
        totalSupplyOfBears = 0;
        totalGWSupplyOfBulls = 0;
        totalGWSupplyOfBears = 0;
        remainder = 0;
        remainderGW = 0;
        jackPot = 0;

        withdrawn = 0;
        winner = 0;
        withdrawnGW = 0;
        countOfBears = 0;
        countOfBulls = 0;
        probabilityOfBulls = 0;
        probabilityOfBears = 0;

        _setRoundTime(defaultCurrentDeadlineInHours, defaultLastDeadlineInHours);
        currentRound++;
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
    * @dev Payable function for take prize
    */
    function () external payable {
        if (msg.value == 0){
            require(true);

            uint payout = 0;
            uint payoutGW = 0;

            if (lastWinner == 1 && depositBears[currentRound - 1][msg.sender] > 0) {
                payout = calculateLastETHPrize(msg.sender);
            }
            if (lastWinner == 2 && depositBulls[currentRound - 1][msg.sender] > 0) {
                payout = calculateLastETHPrize(msg.sender);
            }

            if (payout > 0) {
                depositBears[currentRound - 1][msg.sender] = 0;
                depositBulls[currentRound - 1][msg.sender] = 0;
                withdrawn = withdrawn.add(payout);
                msg.sender.transfer(payout);
            }

            if ((lastWinner == 1 && depositBears[currentRound - 1][msg.sender] == 0) || (lastWinner == 2 && depositBulls[currentRound - 1][msg.sender] == 0)) {
                payoutGW = calculateLastGWPrize(msg.sender);
                withdrawnGW = withdrawnGW.add(payoutGW);
                GameWaveContract.transfer(msg.sender, payoutGW);
            }

            if (msg.sender == lastRoundHero) {
                lastHeroHistory = lastRoundHero;
                lastRoundHero = address(0x0);
                withdrawn = withdrawn.add(lastJackPot);
                msg.sender.transfer(lastJackPot);
            }
        }
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    /**
    * @dev Getting ETH prize of participant
    * @param participant Address of participant
    */
    function calculateETHPrize(address participant) public view returns(uint) {

        uint payout = 0;
        uint256 totalSupply = (totalSupplyOfBears.add(totalSupplyOfBulls));

        if (depositBears[currentRound][participant] > 0) {
            payout = totalSupply.mul(depositBears[currentRound][participant]).div(totalSupplyOfBears);
        }

        if (depositBulls[currentRound][participant] > 0) {
            payout = totalSupply.mul(depositBulls[currentRound][participant]).div(totalSupplyOfBulls);
        }

        return payout;
    }

    /**
    * @dev Getting GW Token prize of participant
    * @param participant Address of participant
    */
    function calculateGWPrize(address participant) public view returns(uint) {

        uint payout = 0;
        uint totalSupply = (totalGWSupplyOfBears.add(totalGWSupplyOfBulls)).mul(80).div(100);

        if (depositBears[currentRound][participant] > 0) {
            payout = totalSupply.mul(depositBears[currentRound][participant]).div(totalSupplyOfBears);
        }

        if (depositBulls[currentRound][participant] > 0) {
            payout = totalSupply.mul(depositBulls[currentRound][participant]).div(totalSupplyOfBulls);
        }

        return payout;
    }

    /**
    * @dev Getting ETH prize of _lastParticipant
    * @param _lastParticipant Address of _lastParticipant
    */
    function calculateLastETHPrize(address _lastParticipant) public view returns(uint) {

        uint payout = 0;
        uint256 totalSupply = (lastTotalSupplyOfBears.add(lastTotalSupplyOfBulls));

        if (depositBears[currentRound - 1][_lastParticipant] > 0) {
            payout = totalSupply.mul(depositBears[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBears);
        }

        if (depositBulls[currentRound - 1][_lastParticipant] > 0) {
            payout = totalSupply.mul(depositBulls[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBulls);
        }

        return payout;
    }

    /**
    * @dev Getting GW Token prize of _lastParticipant
    * @param _lastParticipant Address of _lastParticipant
    */
    function calculateLastGWPrize(address _lastParticipant) public view returns(uint) {

        uint payout = 0;
        uint totalSupply = (lastTotalGWSupplyOfBears.add(lastTotalGWSupplyOfBulls)).mul(80).div(100);

        if (depositBears[currentRound - 1][_lastParticipant] > 0) {
            payout = totalSupply.mul(depositBears[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBears);
        }

        if (depositBulls[currentRound - 1][_lastParticipant] > 0) {
            payout = totalSupply.mul(depositBulls[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBulls);
        }

        return payout;
    }
}

/**
* @dev Base contract for teams
*/
contract CryptoTeam {
    using SafeMath for uint256;

    Bank public BankContract;
    GameWave public GameWaveContract;
    
    /**
    * @dev Payable function. 10% will send to Developers fund and 90% will send to JackPot contract.
    * Also setting info about player.
    */
    function () external payable {
        require(true);

        BankContract.setInfo(msg.sender, msg.value.mul(90).div(100));

        address(GameWaveContract).transfer(msg.value.mul(10).div(100));
        
        address(BankContract).transfer(msg.value.mul(90).div(100));
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
}

/*
* @dev Bears contract. To play game with Bears send ETH to this contract
*/
contract Bears is CryptoTeam {
    constructor(address payable _bankAddress, address payable _GameWaveAddress) public {
        BankContract = Bank(_bankAddress);
        BankContract.setBearsAddress(address(this));
        GameWaveContract = GameWave(_GameWaveAddress);
        GameWaveContract.approve(_bankAddress, 9999999999999999999000000000000000000);
    }
}

/*
* @dev Bulls contract. To play game with Bulls send ETH to this contract
*/
contract Bulls is CryptoTeam {
    constructor(address payable _bankAddress, address payable _GameWaveAddress) public {
        BankContract = Bank(_bankAddress);
        BankContract.setBullsAddress(address(this));
        GameWaveContract = GameWave(_GameWaveAddress);
        GameWaveContract.approve(_bankAddress, 9999999999999999999000000000000000000);
    }
}

/*
* @dev Crowdsal contract
*/
contract Sale {

    GameWave public GWContract;
    uint256 public buyPrice;
    address public owner;
    uint balance;

    bool crowdSaleClosed = false;

    constructor(
        address payable _GWContract
    ) payable public {
        owner = msg.sender;
        GWContract = GameWave(_GWContract);
        GWContract.approve(owner, 9999999999999999999000000000000000000);
    }

    /**
     * @notice Allow users to buy tokens for `newBuyPrice`
     * @param newBuyPrice Price users can buy from the contract.
     */

    function setPrice(uint256 newBuyPrice) public {
        buyPrice = newBuyPrice;
    }

    /**
     * Fallback function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract and
     * sends tokens to the buyer.
     */

    function () payable external {
        uint amount = msg.value;
        balance = (amount / buyPrice) * 10 ** 18;
        GWContract.transfer(msg.sender, balance);
        address(GWContract).transfer(amount);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
}