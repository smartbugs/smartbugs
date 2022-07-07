pragma solidity 0.5.6;

/**
 *
 * @author Alejandro Diaz <Alejandro.Diaz.666@protonmail.com>
 *
 * Overview:
 * This is an implimentation of a multi-dividend-paying token. the token supports income/dividends
 * of Eth and also Dai. A fixed number of tokens are minted in the constructor, and initially owned
 * by the contract owner. Dividends are awarded token holders thusly:
 *
 *   previous_due + [ p(x) * t(x)/N ] + [ p(x+1) * t(x+1)/N ] + ...
 *   where p(x) is the x'th income payment received by the contract
 *         t(x) is the number of tokens held by the token-holder at the time of p(x)
 *         N    is the total number of tokens, which never changes
 *
 * assume that t(x) takes on 3 values, t(a), t(b) and t(c), at times a, b, and c;
 * and that there are multiple payments at times between a and b: x, x+1, x+2...
 * and multiple payments at times between b and c: y, x+y, y+2...
 * and multiple payments at times greater than c: z, z+y, z+2...
 * then factoring:
 *
 *   current_due = { (t(a) * [p(x) + p(x+1)]) ... + (t(a) * [p(x) + p(y-1)]) ... +
 *                   (t(b) * [p(y) + p(y+1)]) ... + (t(b) * [p(y) + p(z-1)]) ... +
 *                   (t(c) * [p(z) + p(z+1)]) ... + (t(c) * [p(z) + p(now)]) } / N
 *
 * or
 *
 *   current_due = { (t(a) * period_a_income) +
 *                   (t(b) * period_b_income) +
 *                   (t(c) * period_c_income) } / N
 *
 * if we designate current_due * N as current-points, then
 *
 *   currentPoints = {  (t(a) * period_a_income) +
 *                      (t(b) * period_b_income) +
 *                      (t(c) * period_c_income) }
 *
 * or more succictly, if we recompute current points before a token-holder's number of
 * tokens, T, is about to change:
 *
 *   currentPoints = previous_points + (T * current-period-income)
 *
 * when we want to do a payout, we'll calculate:
 *  current_due = current-points / N
 *
 * we'll keep track of a token-holder's current-period-points, which is:
 *   T * current-period-income
 * by taking a snapshot of income collected exactly when the current period began; that is, the when the
 * number of tokens last changed. that is, we keep a running count of total income received
 *
 *   totalIncomeReceived = p(x) + p(x+1) + p(x+2)
 *
 * (which happily is the same for all token holders) then, before any token holder changes their number of
 * tokens we compute (for that token holder):
 *
 *  function calcCurPointsForAcct(acct) {
 *    currentPoints[acct] += (totalIncomeReceived - lastSnapshot[acct]) * T[acct]
 *    lastSnapshot[acct] = totalIncomeReceived
 *  }
 *
 * in the withdraw fcn, all we need is:
 *
 *  function withdraw(acct) {
 *    calcCurPointsForAcct(acct);
 *    current_amount_due = currentPoints[acct] / N
 *    currentPoints[acct] = 0;
 *    send(current_amount_due);
 *  }
 *
 */
//import './SafeMath.sol';
/*
    Overflow protected math functions
*/
contract SafeMath {
    /**
        constructor
    */
    constructor() public {
    }

    /**
        @dev returns the sum of _x and _y, asserts if the calculation overflows

        @param _x   value 1
        @param _y   value 2

        @return sum
    */
    function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
        uint256 z ;	//inject UNINIT LOCAL/STATE VAR

        assert(z >= _x);
        return z;
    }

    /**
        @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number

        @param _x   minuend
        @param _y   subtrahend

        @return difference
    */
    function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
        assert(_x >= _y);
        return _x - _y;
    }

    /**
        @dev returns the product of multiplying _x by _y, asserts if the calculation overflows

        @param _x   factor 1
        @param _y   factor 2

        @return product
    */
    function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
        uint256 z ;	//inject UNINIT LOCAL/STATE VAR

        assert(_x == 0 || z / _x == _y);
        return z;
    }
}

//import './iERC20Token.sol';
// Token standard API
// https://github.com/ethereum/EIPs/issues/20
contract iERC20Token {
  function balanceOf( address who ) public view returns (uint value);
  function allowance( address owner, address spender ) public view returns (uint remaining);
  function transfer( address to, uint value) public returns (bool ok);
  function transferFrom( address from, address to, uint value) public returns (bool ok);
  function approve( address spender, uint value ) public returns (bool ok);
  event Transfer( address indexed from, address indexed to, uint value);
  event Approval( address indexed owner, address indexed spender, uint value);
  //these are implimented via automatic getters
  //function name() public view returns (string _name);
  //function symbol() public view returns (string _symbol);
  //function decimals() public view returns (uint8 _decimals);
  //function totalSupply() public view returns (uint256 _totalSupply);
}

//import './iDividendToken.sol';
// simple interface for withdrawing dividends
contract iDividendToken {
  function checkDividends(address _addr) view public returns(uint _ethAmount, uint _daiAmount);
  function withdrawEthDividends() public returns (uint _amount);
  function withdrawDaiDividends() public returns (uint _amount);
}

contract ETT is iERC20Token, iDividendToken, SafeMath {

  event Transfer(address indexed from, address indexed to, uint amount);
  event Approval(address indexed from, address indexed to, uint amount);

  struct tokenHolder {
    uint tokens;           // num tokens currently held in this acct, aka balance
    uint currentEthPoints; // updated before token balance changes, or before a withdrawal. credit for owning tokens
    uint lastEthSnapshot;  // snapshot of global TotalPoints (Eth), last time we updated this acct's currentEthPoints
    uint currentDaiPoints; // updated before token balance changes, or before a withdrawal. credit for owning tokens
    uint lastDaiSnapshot;  // snapshot of global TotalPoints (Dai), last time we updated this acct's currentDaiPoints
  }

  bool    public isLocked;
  uint8   public decimals;
  address public daiToken;
  string  public symbol;
  string  public name;
  uint public    totalSupply;                                       // total token supply. never changes
  uint public    holdoverEthBalance;                                // funds received, but not yet distributed
  uint public    totalEthReceived;
  uint public    holdoverDaiBalance;                                // funds received, but not yet distributed
  uint public    totalDaiReceived;

  mapping (address => mapping (address => uint)) private approvals; //transfer approvals, from -> to -> amount
  mapping (address => tokenHolder) public tokenHolders;


  //
  //constructor
  //
  constructor(address _daiToken, uint256 _tokenSupply, uint8 _decimals, string memory _name, string memory _symbol) public {
    daiToken = _daiToken;
    totalSupply = _tokenSupply;
    decimals = _decimals;
    name = _name;
    symbol = _symbol;
    tokenHolders[msg.sender].tokens = totalSupply;
    emit Transfer(address(0), msg.sender, totalSupply);
  }


  //
  // ERC-20
  //


  //
  // transfer tokens to a specified address
  // @param to the address to transfer to.
  // @param value the amount to be transferred.
  // checks for overflow, sufficient tokens to xfer are in internal _transfer fcn
  //
  function transfer(address _to, uint _value) public returns (bool success) {
    _transfer(msg.sender, _to, _value);
    return true;
  }


  //
  // transfer tokens from one address to another.
  // note that while this function emits an Approval event, this is not required as per the specification,
  // and other compliant implementations may not emit the event.
  // @param from address the address which you want to send tokens from
  // @param to address the address which you want to transfer to
  // @param value uint256 the amount of tokens to be transferred
  // checks for overflow, sufficient tokens to xfer are in internal _transfer fcn
  // check for sufficient approval in in the safeSub
  //
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    _transfer(_from, _to, _value);
    _approve(_from, msg.sender, safeSub(approvals[_from][msg.sender], _value));
    return true;
  }


  //
  // internal fcn to execute a transfer. no check/modification of approval here
  // wrap of token balances is prevented in safe{Add,Sub}
  //
  function _transfer(address _from, address _to, uint _value) internal {
    require(_to != address(0));
    //first credit source acct with points accrued so far.. must do this before number of held tokens changes
    calcCurPointsForAcct(_from);
    tokenHolders[_from].tokens = safeSub(tokenHolders[_from].tokens, _value);
    //if destination is a new tokenholder then we are setting his "last" snapshot to the current totalPoints
    if (tokenHolders[_to].lastEthSnapshot == 0)
      tokenHolders[_to].lastEthSnapshot = totalEthReceived;
    if (tokenHolders[_to].lastDaiSnapshot == 0)
      tokenHolders[_to].lastDaiSnapshot = totalDaiReceived;
    //credit destination acct with points accrued so far.. must do this before number of held tokens changes
    calcCurPointsForAcct(_to);
    tokenHolders[_to].tokens = safeAdd(tokenHolders[_to].tokens, _value);
    emit Transfer(_from, _to, _value);
  }


  function balanceOf(address _owner) public view returns (uint balance) {
    balance = tokenHolders[_owner].tokens;
  }


  //
  // approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
  // beware that changing an allowance with this method brings the risk that someone may use both the old
  // and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
  // race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
  // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
  // @param _spender the address which will spend the funds.
  // @param _value the amount of tokens to be spent.
  //
  function approve(address _spender, uint256 _value) public returns (bool) {
    _approve(msg.sender, _spender, _value);
    return true;
  }


  //
  // increase the amount of tokens that an owner allows to a spender.
  // approve should be called when allowed[msg.sender][spender] == 0. to increment
  // allowed value it is better to use this function to avoid 2 calls (and wait until
  // the first transaction is mined)
  // Emits an Approval event.
  // @param _spender the address which will spend the funds.
  // @param _addedValue the amount of tokens to increase the allowance by.
  //
  function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
    _approve(msg.sender, _spender, safeAdd(approvals[msg.sender][_spender], _addedValue));
    return true;
  }

  /**
   * decrease the amount of tokens that an owner allows to a spender.
   * approve should be called when allowed[msg.sender][spender] == 0. to decrement
   * allowed value it is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * from MonolithDAO Token.sol
   * emits an Approval event.
   * @param _spender the address which will spend the funds.
   * @param _subtractedValue the amount of tokens to decrease the allowance by.
   */
  function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
    _approve(msg.sender, _spender, safeSub(approvals[msg.sender][_spender], _subtractedValue));
    return true;
  }


  /*
   * @dev internal fcn to approve an address to spend another addresses' tokens.
   * @param _owner the address that owns the tokens.
   * @param _spender the address that will spend the tokens.
   * @param _value the number of tokens that can be spent.
   */
  function _approve(address _owner, address _spender, uint _value) internal {
    require(_owner != address(0));
    require(_spender != address(0));
    approvals[_owner][_spender] = _value;
    emit Approval(_owner, _spender, _value);
  }


  function allowance(address _owner, address _spender) public view returns (uint remaining) {
    return approvals[_owner][_spender];
  }

  //
  // END ERC20
  //

  //
  // calc current points for a token holder; that is, points that are due to this token holder for all dividends
  // received by the contract during the current "period". the period began the last time this fcn was called, at which
  // time we updated the account's snapshot of the running point count, totalEthReceived. during the period the account's
  // number of tokens must not have changed. so always call this fcn before changing the number of tokens.
  //
  function calcCurPointsForAcct(address _acct) internal {
    uint256 _newEthPoints ;	//inject UNINIT LOCAL/STATE VAR

    tokenHolders[_acct].currentEthPoints = safeAdd(tokenHolders[_acct].currentEthPoints, _newEthPoints);
    tokenHolders[_acct].lastEthSnapshot = totalEthReceived;
    uint256 _newDaiPoints ;	//inject UNINIT LOCAL/STATE VAR

    tokenHolders[_acct].currentDaiPoints = safeAdd(tokenHolders[_acct].currentDaiPoints, _newDaiPoints);
    tokenHolders[_acct].lastDaiSnapshot = totalDaiReceived;
  }


  //
  // default payable function. funds receieved here become dividends.
  //
  function () external payable {
    holdoverEthBalance = safeAdd(holdoverEthBalance, msg.value);
    totalEthReceived = safeAdd(totalEthReceived, msg.value);
  }


  //
  // this payable function is for payment in Dai
  // caller must have already approved the Dai transfer
  //
  function payDai(uint256 _daiAmount) external {
    require(iERC20Token(daiToken).transferFrom(msg.sender, address(this), _daiAmount), "failed to transfer dai");
    holdoverDaiBalance = safeAdd(holdoverDaiBalance, _daiAmount);
    totalDaiReceived = safeAdd(totalDaiReceived, _daiAmount);
  }


  //
  // updateDaiBalance
  // update the dia holdover balance, in case someone transfers dai directly
  // to the contract. anyone can call this.
  //
  function updateDaiBalance() public {
    uint256 _actBalance ;	//inject UNINIT LOCAL/STATE VAR

    uint256 _daiAmount ;	//inject UNINIT LOCAL/STATE VAR

    holdoverDaiBalance = safeAdd(holdoverDaiBalance, _daiAmount);
    totalDaiReceived = safeAdd(totalDaiReceived, _daiAmount);
  }


  //
  // check my dividends
  //
  function checkDividends(address _addr) view public returns(uint _ethAmount, uint _daiAmount) {
    //don't call calcCurPointsForAcct here, cuz this is a constant fcn
    uint _currentEthPoints ;	//inject UNINIT LOCAL/STATE VAR

    _ethAmount = _currentEthPoints / totalSupply;
    uint _currentDaiPoints ;	//inject UNINIT LOCAL/STATE VAR

    _daiAmount = _currentDaiPoints / totalSupply;
  }


  //
  // withdraw my dividends
  //
  function withdrawEthDividends() public returns (uint _amount) {
    calcCurPointsForAcct(msg.sender);
    _amount = tokenHolders[msg.sender].currentEthPoints / totalSupply;
    uint _pointsUsed ;	//inject UNINIT LOCAL/STATE VAR

    tokenHolders[msg.sender].currentEthPoints = safeSub(tokenHolders[msg.sender].currentEthPoints, _pointsUsed);
    holdoverEthBalance = safeSub(holdoverEthBalance, _amount);
    msg.sender.transfer(_amount);
  }

  function withdrawDaiDividends() public returns (uint _amount) {
    calcCurPointsForAcct(msg.sender);
    _amount = tokenHolders[msg.sender].currentDaiPoints / totalSupply;
    uint _pointsUsed ;	//inject UNINIT LOCAL/STATE VAR

    tokenHolders[msg.sender].currentDaiPoints = safeSub(tokenHolders[msg.sender].currentDaiPoints, _pointsUsed);
    holdoverDaiBalance = safeSub(holdoverDaiBalance, _amount);
    require(iERC20Token(daiToken).transfer(msg.sender, _amount), "failed to transfer dai");
  }


}