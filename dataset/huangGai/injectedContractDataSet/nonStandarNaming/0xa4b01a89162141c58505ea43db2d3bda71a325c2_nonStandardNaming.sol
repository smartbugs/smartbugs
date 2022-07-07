                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   

pragma solidity 0.5.1;

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

                                                                                        
interface IERC20 {
  function TOTALSUPPLY936() external view returns (uint256);	//inject NONSTANDARD NAMING

  function BALANCEOF371(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

  function ALLOWANCE214(address owner, address spender)	//inject NONSTANDARD NAMING
    external view returns (uint256);

  function TRANSFER168(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

  function APPROVE80(address spender, uint256 value)	//inject NONSTANDARD NAMING
    external returns (bool);

  function TRANSFERFROM234(address from, address to, uint256 value)	//inject NONSTANDARD NAMING
    external returns (bool);

  event TRANSFER30(	//inject NONSTANDARD NAMING
    address indexed from,
    address indexed to,
    uint256 value
  );

  event APPROVAL61(	//inject NONSTANDARD NAMING
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

                                                                                          
library SafeMath {

                                                                
  function MUL733(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                         
  function DIV828(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                            
  function SUB889(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

                                                          
  function ADD39(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

                                                                                                                               
  function MOD393(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b != 0);
    return a % b;
  }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

                                                                                                                                                                                                                                                                                            
contract ERC20 is IERC20 {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;

  uint256 private _totalSupply;

                                                       
  function TOTALSUPPLY936() public view returns (uint256) {	//inject NONSTANDARD NAMING
    return _totalSupply;
  }

                                                                                                                                                                                                
  function BALANCEOF371(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
    return _balances[owner];
  }

                                                                                                                                                                                                                                                                                                                        
  function ALLOWANCE214(	//inject NONSTANDARD NAMING
    address owner,
    address spender
   )
    public
    view
    returns (uint256)
  {
    return _allowed[owner][spender];
  }

                                                                                                                                                   
  function TRANSFER168(address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
    _TRANSFER798(msg.sender, to, value);
    return true;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  function APPROVE80(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
    require(spender != address(0));

    _allowed[msg.sender][spender] = value;
    emit APPROVAL61(msg.sender, spender, value);
    return true;
  }

                                                                                                                                                                                                                                                                           
  function TRANSFERFROM234(	//inject NONSTANDARD NAMING
    address from,
    address to,
    uint256 value
  )
    public
    returns (bool)
  {
    require(value <= _allowed[from][msg.sender]);

    _allowed[from][msg.sender] = _allowed[from][msg.sender].SUB889(value);
    _TRANSFER798(from, to, value);
    return true;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  function INCREASEALLOWANCE418(	//inject NONSTANDARD NAMING
    address spender,
    uint256 addedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].ADD39(addedValue));
    emit APPROVAL61(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  function DECREASEALLOWANCE265(	//inject NONSTANDARD NAMING
    address spender,
    uint256 subtractedValue
  )
    public
    returns (bool)
  {
    require(spender != address(0));

    _allowed[msg.sender][spender] = (
      _allowed[msg.sender][spender].SUB889(subtractedValue));
    emit APPROVAL61(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

                                                                                                                                                                                                   
  function _TRANSFER798(address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
    require(value <= _balances[from]);
    require(to != address(0));

    _balances[from] = _balances[from].SUB889(value);
    _balances[to] = _balances[to].ADD39(value);
    emit TRANSFER30(from, to, value);
  }

                                                                                                                                                                                                                                                                                                                                  
  function _MINT17(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
    require(account != address(0));
    _totalSupply = _totalSupply.ADD39(value);
    _balances[account] = _balances[account].ADD39(value);
    emit TRANSFER30(address(0), account, value);
  }

                                                                                                                                                                                                               
  function _BURN632(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
    require(account != address(0));
    require(value <= _balances[account]);

    _totalSupply = _totalSupply.SUB889(value);
    _balances[account] = _balances[account].SUB889(value);
    emit TRANSFER30(account, address(0), value);
  }

                                                                                                                                                                                                                                                                                                             
  function _BURNFROM339(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
    require(value <= _allowed[account][msg.sender]);

    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
    // this function needs to emit an event with the updated approval.
    _allowed[account][msg.sender] = _allowed[account][msg.sender].SUB889(
      value);
    _BURN632(account, value);
  }
}

// File: openzeppelin-solidity/contracts/access/Roles.sol

                                                                                  
library Roles {
  struct Role {
    mapping (address => bool) bearer;
  }

                                                         
  function ADD39(Role storage role, address account) internal {	//inject NONSTANDARD NAMING
    require(account != address(0));
    require(!HAS536(role, account));

    role.bearer[account] = true;
  }

                                                             
  function REMOVE855(Role storage role, address account) internal {	//inject NONSTANDARD NAMING
    require(account != address(0));
    require(HAS536(role, account));

    role.bearer[account] = false;
  }

                                                                         
  function HAS536(Role storage role, address account)	//inject NONSTANDARD NAMING
    internal
    view
    returns (bool)
  {
    require(account != address(0));
    return role.bearer[account];
  }
}

// File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol

contract MinterRole {
  using Roles for Roles.Role;

  event MINTERADDED705(address indexed account);	//inject NONSTANDARD NAMING
  event MINTERREMOVED101(address indexed account);	//inject NONSTANDARD NAMING

  Roles.Role private minters;

  constructor() internal {
    _ADDMINTER752(msg.sender);
  }

  modifier ONLYMINTER554() {	//inject NONSTANDARD NAMING
    require(ISMINTER485(msg.sender));
    _;
  }

  function ISMINTER485(address account) public view returns (bool) {	//inject NONSTANDARD NAMING
    return minters.HAS536(account);
  }

  function ADDMINTER992(address account) public ONLYMINTER554 {	//inject NONSTANDARD NAMING
    _ADDMINTER752(account);
  }

  function RENOUNCEMINTER120() public {	//inject NONSTANDARD NAMING
    _REMOVEMINTER694(msg.sender);
  }

  function _ADDMINTER752(address account) internal {	//inject NONSTANDARD NAMING
    minters.ADD39(account);
    emit MINTERADDED705(account);
  }

  function _REMOVEMINTER694(address account) internal {	//inject NONSTANDARD NAMING
    minters.REMOVE855(account);
    emit MINTERREMOVED101(account);
  }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol

                                                           
contract ERC20Mintable is ERC20, MinterRole {
                                                                                                                                                                                                                                    
  function MINT763(	//inject NONSTANDARD NAMING
    address to,
    uint256 value
  )
    public
    ONLYMINTER554
    returns (bool)
  {
    _MINT17(to, value);
    return true;
  }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol

                                                                                                                                                                                                                                        
contract ERC20Detailed is IERC20 {
  string private _name;
  string private _symbol;
  uint8 private _decimals;

  constructor(string memory name, string memory symbol, uint8 decimals) public {
    _name = name;
    _symbol = symbol;
    _decimals = decimals;
  }

                                               
  function NAME131() public view returns(string memory) {	//inject NONSTANDARD NAMING
    return _name;
  }

                                                 
  function SYMBOL158() public view returns(string memory) {	//inject NONSTANDARD NAMING
    return _symbol;
  }

                                                             
  function DECIMALS779() public view returns(uint8) {	//inject NONSTANDARD NAMING
    return _decimals;
  }
}

// File: contracts/TXCast.sol

contract TXCast is ERC20Mintable, ERC20Detailed {
  constructor () public ERC20Detailed("TXCast", "TXC", 0) {}
}

// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol

                                                                                                                                                                                                                                                                            
library SafeERC20 {

  using SafeMath for uint256;

  function SAFETRANSFER87(	//inject NONSTANDARD NAMING
    IERC20 token,
    address to,
    uint256 value
  )
    internal
  {
    require(token.TRANSFER168(to, value));
  }

  function SAFETRANSFERFROM776(	//inject NONSTANDARD NAMING
    IERC20 token,
    address from,
    address to,
    uint256 value
  )
    internal
  {
    require(token.TRANSFERFROM234(from, to, value));
  }

  function SAFEAPPROVE794(	//inject NONSTANDARD NAMING
    IERC20 token,
    address spender,
    uint256 value
  )
    internal
  {
    // safeApprove should only be called when setting an initial allowance, 
    // or when resetting it to zero. To increase and decrease it, use 
    // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
    require((value == 0) || (token.ALLOWANCE214(msg.sender, spender) == 0));
    require(token.APPROVE80(spender, value));
  }

  function SAFEINCREASEALLOWANCE532(	//inject NONSTANDARD NAMING
    IERC20 token,
    address spender,
    uint256 value
  )
    internal
  {
    uint256 newAllowance = token.ALLOWANCE214(address(this), spender).ADD39(value);
    require(token.APPROVE80(spender, newAllowance));
  }

  function SAFEDECREASEALLOWANCE74(	//inject NONSTANDARD NAMING
    IERC20 token,
    address spender,
    uint256 value
  )
    internal
  {
    uint256 newAllowance = token.ALLOWANCE214(address(this), spender).SUB889(value);
    require(token.APPROVE80(spender, newAllowance));
  }
}

// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol

                                                                                                                                                                                                                             
contract ReentrancyGuard {

                                                                     
  uint256 private _guardCounter;

  constructor() internal {
    // The counter starts at one to prevent changing it from zero to a non-zero
    // value, which is a more expensive operation.
    _guardCounter = 1;
  }

                                                                                                                                                                                                                                                                                                                                                                  
  modifier NONREENTRANT633() {	//inject NONSTANDARD NAMING
    _guardCounter += 1;
    uint256 localCounter = _guardCounter;
    _;
    require(localCounter == _guardCounter);
  }

}

// File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
contract Crowdsale is ReentrancyGuard {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  // The token being sold
  IERC20 private _token;

  // Address where funds are collected
  address payable private _wallet;

  // How many token units a buyer gets per wei.
  // The rate is the conversion between wei and the smallest and indivisible token unit.
  // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
  // 1 wei will give you 1 unit, or 0.001 TOK.
  uint256 private _rate;

  // Amount of wei raised
  uint256 private _weiRaised;

                                                                                                                                                                                                                                 
  event TOKENSPURCHASED409(	//inject NONSTANDARD NAMING
    address indexed purchaser,
    address indexed beneficiary,
    uint256 value,
    uint256 amount
  );

                                                                                                                                                                                                                                                                                                                                                                                       
  constructor(uint256 rate, address payable wallet                  ) internal {
    require(rate > 0);
    require(wallet != address(0));
    //require(address(token) != address(0));

    _rate = rate;
    _wallet = wallet;
    _token = new TXCast();
  }

  // -----------------------------------------
  // Crowdsale external interface
  // -----------------------------------------

                                                                                                                                                                                                                                                                             
  function () external payable {
    BUYTOKENS23(msg.sender);
  }

                                              
  function TOKEN725() public view returns(IERC20) {	//inject NONSTANDARD NAMING
    return _token;
  }

                                                               
  function WALLET658() public view returns(address) {	//inject NONSTANDARD NAMING
    return _wallet;
  }

                                                                        
  function RATE552() public view returns(uint256) {	//inject NONSTANDARD NAMING
    return _rate;
  }

                                                  
  function WEIRAISED883() public view returns (uint256) {	//inject NONSTANDARD NAMING
    return _weiRaised;
  }

                                                                                                                                                                                                                                              
  function BUYTOKENS23(address beneficiary) public NONREENTRANT633 payable {	//inject NONSTANDARD NAMING

    uint256 weiAmount = msg.value;
    _PREVALIDATEPURCHASE107(beneficiary, weiAmount);

    // calculate token amount to be created
    uint256 tokens = _GETTOKENAMOUNT819(weiAmount);

    // update state
    _weiRaised = _weiRaised.ADD39(weiAmount);

    _PROCESSPURCHASE612(beneficiary, tokens);
    emit TOKENSPURCHASED409(
      msg.sender,
      beneficiary,
      weiAmount,
      tokens
    );

    _UPDATEPURCHASINGSTATE169(beneficiary, weiAmount);

    _FORWARDFUNDS314();
    _POSTVALIDATEPURCHASE48(beneficiary, weiAmount);
  }

  // -----------------------------------------
  // Internal interface (extensible)
  // -----------------------------------------

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function _PREVALIDATEPURCHASE107(	//inject NONSTANDARD NAMING
    address beneficiary,
    uint256 weiAmount
  )
    internal
    view
  {
    require(beneficiary != address(0));
    require(weiAmount != 0);
    require(uint(weiAmount >> 18) << 18 == weiAmount);
  }

                                                                                                                                                                                                                                                                               
  function _POSTVALIDATEPURCHASE48(	//inject NONSTANDARD NAMING
    address beneficiary,
    uint256 weiAmount
  )
    internal
    view
  {
    // optional override
  }

                                                                                                                                                                                                                                                                
  function _DELIVERTOKENS659(	//inject NONSTANDARD NAMING
    address beneficiary,
    uint256 tokenAmount
  )
    internal
  {
    _token.SAFETRANSFER87(beneficiary, tokenAmount);
  }

                                                                                                                                                                                                                                                  
  function _PROCESSPURCHASE612(	//inject NONSTANDARD NAMING
    address beneficiary,
    uint256 tokenAmount
  )
    internal
  {
    _DELIVERTOKENS659(beneficiary, tokenAmount);
  }

                                                                                                                                                                                                                                                      
  function _UPDATEPURCHASINGSTATE169(	//inject NONSTANDARD NAMING
    address beneficiary,
    uint256 weiAmount
  )
    internal
  {
    // optional override
  }

                                                                                                                                                                                                                                        
  function _GETTOKENAMOUNT819(uint256 weiAmount)	//inject NONSTANDARD NAMING
    internal view returns (uint256)
  {
    return weiAmount.DIV828(1 ether);
  }

                                                                          
  function _FORWARDFUNDS314() internal {	//inject NONSTANDARD NAMING
    _wallet.transfer(msg.value);
  }
}

// File: openzeppelin-solidity/contracts/crowdsale/emission/MintedCrowdsale.sol

                                                                                                                                                                                            
contract MintedCrowdsale is Crowdsale {
  constructor() internal {}

                                                                                                                                                                       
  function _DELIVERTOKENS659(	//inject NONSTANDARD NAMING
    address beneficiary,
    uint256 tokenAmount
  )
    internal
  {
    // Potentially dangerous assumption about the type of the token.
    require(
      ERC20Mintable(address(TOKEN725())).MINT763(beneficiary, tokenAmount));
  }
}

// File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol

                                                                                         
contract CappedCrowdsale is Crowdsale {
  using SafeMath for uint256;

  uint256 private _cap;

                                                                                                                                             
  constructor(uint256 cap) internal {
    require(cap > 0);
    _cap = cap;
  }

                                                  
  function CAP835() public view returns(uint256) {	//inject NONSTANDARD NAMING
    return _cap;
  }

                                                                                                       
  function CAPREACHED150() public view returns (bool) {	//inject NONSTANDARD NAMING
    return WEIRAISED883() >= _cap;
  }

                                                                                                                                                                                   
  function _PREVALIDATEPURCHASE107(	//inject NONSTANDARD NAMING
    address beneficiary,
    uint256 weiAmount
  )
    internal
    view
  {
    super._PREVALIDATEPURCHASE107(beneficiary, weiAmount);
    require(WEIRAISED883().ADD39(weiAmount) <= _cap);
  }

}

// File: contracts/TXCSale.sol

contract TXCSale is CappedCrowdsale, MintedCrowdsale {
  constructor
  (
    uint256 _cap,
    address payable _wallet
  )
  public
  Crowdsale(1 ether, _wallet)
  CappedCrowdsale(_cap * 1 ether) {
      
  }
}