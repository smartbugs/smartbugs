/**
 *Submitted for verification at Etherscan.io on 2020-02-11
*/

pragma solidity ^0.5.16;


library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev give an account access to this role
     */
    function add(Role storage role, address account) internal {
        require(account != address(0));
        require(!has(role, account));

        role.bearer[account] = true;
    }

    /**
     * @dev remove an account's access to this role
     */
    function remove(Role storage role, address account) internal {
        require(account != address(0));
        require(has(role, account));

        role.bearer[account] = false;
    }

    /**
     * @dev check if an account has this role
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }
}


contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
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
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the Nordic Energy smart contract.
     * @notice Renouncing to ownership will leave the smart contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the smart contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the smart contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
        return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        //assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //assert(c >= a);
        return c;
    }
}

interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    /**
    * @dev Total number of Nordic Energy tokens in existence
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
     * @dev Function to check the amount of Nordic Energy tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of Nordic Energy tokens still available for the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
    * @dev Transfer Nordic Energy token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of Nordic Energy tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of Nordic Energy tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer Nordic Energy tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of Nordic Energy tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _transfer(from, to, value);
        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

    /**
     * @dev Increase the amount of Nordic Energy tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of Nordic Energy tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of Nordic Energy tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of Nordic Energy tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Transfer Nordic Energy token for a specified addresses
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
     * @dev Internal function that mints an amount of the Nordic Energy token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created Nordic Energy tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the Nordic Energy token of a given
     * account.
     * @param account The account whose Nordic Energy tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Internal function that burns an amount of the Nordic Energy token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose Nordic Energy tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
        _burn(account, value);
        emit Approval(account, msg.sender, _allowed[account][msg.sender]);
    }
}

contract ERC20Burnable is ERC20 {
    /**
     * @dev Burns a specific amount of Nordic Energy tokens.
     * @param value The amount of Nordic Energy token to be burned.
     */
    function burn(uint256 value) public {
        _burn(msg.sender, value);
    }

    /**
     * @dev Burns a specific amount of Nordic Energy tokens from the target address and decrements allowance
     * @param from address The address which you want to send tokens from
     * @param value uint256 The amount of Nordic Energy token to be burned
     */
    function burnFrom(address from, uint256 value) public {
        _burnFrom(from, value);
    }
}


contract PauserRole {
    using Roles for Roles.Role;

    event PauserAdded(address indexed account);
    event PauserRemoved(address indexed account);

    Roles.Role private _pausers;

    constructor () internal {
        _addPauser(msg.sender);
    }

    modifier onlyPauser() {
        require(isPauser(msg.sender));
        _;
    }

    function isPauser(address account) public view returns (bool) {
        return _pausers.has(account);
    }

    function addPauser(address account) public onlyPauser {
        _addPauser(account);
    }

    function renouncePauser() public {
        _removePauser(msg.sender);
    }

    function _addPauser(address account) internal {
        _pausers.add(account);
        emit PauserAdded(account);
    }

    function _removePauser(address account) internal {
        _pausers.remove(account);
        emit PauserRemoved(account);
    }
}

contract Pausable is PauserRole {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor () internal {
        _paused = false;
    }

    /**
     * @return true if the contract is paused, false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the smart contract is paused.
     */
    modifier whenPaused() {
        require(_paused);
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() public onlyPauser whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() public onlyPauser whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}


contract ERC20Pausable is ERC20, Pausable {
    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
        return super.approve(spender, value);
    }

    function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool success) {
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool success) {
        return super.decreaseAllowance(spender, subtractedValue);
    }
}


contract MintableAndPausableToken is ERC20Pausable, Ownable {
    uint8 public constant decimals = 18;
    uint256 public maxTokenSupply = 185000000 * 10 ** uint256(decimals);

    bool public mintingFinished = false;

    event Mint(address indexed to, uint256 amount);
    event MintFinished();
    event MintStarted();

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    modifier checkMaxSupply(uint256 _amount) {
        require(maxTokenSupply >= totalSupply().add(_amount));
        _;
    }

    modifier cannotMint() {
        require(mintingFinished);
        _;
    }

    function mint(address _to, uint256 _amount)
        external
        onlyOwner
        canMint
        checkMaxSupply (_amount)
        whenNotPaused
        returns (bool)
    {
        super._mint(_to, _amount);
        return true;
    }

    function _mint(address _to, uint256 _amount)
        internal
        canMint
        checkMaxSupply (_amount)
    {
        super._mint(_to, _amount);
    }

    function finishMinting() external onlyOwner canMint returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }

    function startMinting() external onlyOwner cannotMint returns (bool) {
        mintingFinished = false;
        emit MintStarted();
        return true;
    }
}



/**
 * Token upgrader interface inspired by Lunyr.
 *
 * Token upgrader transfers previous version Nordic Energy tokens to a newer version.
 * Token upgrader itself can be the Nordic Energy token smart contract, or just a middle man contract doing the heavy lifting.
 */
contract TokenUpgrader {
    uint public originalSupply;

    /** Interface marker */
    function isTokenUpgrader() external pure returns (bool) {
        return true;
    }

    function upgradeFrom(address _from, uint256 _value) public;
}



contract UpgradeableToken is MintableAndPausableToken {
    // Contract or person who can set the upgrade path.
    address public upgradeMaster;
    
    // Bollean value needs to be true to start upgrades
    bool private upgradesAllowed;

    // The next smart contract where the Nordic Energy tokens will be migrated.
    TokenUpgrader public tokenUpgrader;

    // How many Nordic Energy tokens we have upgraded by now.
    uint public totalUpgraded;

    /**
    * Upgrade states.
    * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
    * - Waiting: Nordic Energy allows upgrade, but we don't have a new Nordic Energy token version
    * - ReadyToUpgrade: The Nordic Energy token version is set, but not a single Nordic Energy token has been upgraded yet
    * - Upgrading: Nordic Energy token upgrader is set and the balance holders can upgrade Nordic Energy tokens
    */
    enum UpgradeState { NotAllowed, Waiting, ReadyToUpgrade, Upgrading }

    // Somebody has upgraded some of his Nordic Energy tokens.
    event Upgrade(address indexed _from, address indexed _to, uint256 _value);

    // New token version available.
    event TokenUpgraderIsSet(address _newToken);

    modifier onlyUpgradeMaster {
        // Only a master can designate the next token
        require(msg.sender == upgradeMaster);
        _;
    }

    modifier notInUpgradingState {
        // Upgrade has already begun for Nordic Energy token
        require(getUpgradeState() != UpgradeState.Upgrading);
        _;
    }

    // Do not allow construction without upgrade master set.
    constructor(address _upgradeMaster) public {
        upgradeMaster = _upgradeMaster;
    }

    // set a Nordic Energy token upgrader
    function setTokenUpgrader(address _newToken)
        external
        onlyUpgradeMaster
        notInUpgradingState
    {
        require(canUpgrade());
        require(_newToken != address(0));

        tokenUpgrader = TokenUpgrader(_newToken);

        // Handle bad interface
        require(tokenUpgrader.isTokenUpgrader());

        // Make sure that Nordic Energy token supplies match in source and target
        require(tokenUpgrader.originalSupply() == totalSupply());

        emit TokenUpgraderIsSet(address(tokenUpgrader));
    }

    // Allow the Nordic Energy token holder to upgrade some of our tokens to a new smart contract.
    function upgrade(uint _value) external {
        UpgradeState state = getUpgradeState();
        
        // Check upgrate state 
        require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
        // Validate input value
        require(_value != 0);

        //balances[msg.sender] = balances[msg.sender].sub(_value);
        // Take Nordic Energy tokens out from circulation
        //totalSupply_ = totalSupply_.sub(_value);
        //the _burn method emits the Transfer event
        _burn(msg.sender, _value);

        totalUpgraded = totalUpgraded.add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW


        // Token Upgrader reissues the Nordic Energy tokens
        tokenUpgrader.upgradeFrom(msg.sender, _value);
        emit Upgrade(msg.sender, address(tokenUpgrader), _value);
    }

    /**
    * Change the upgrade master.
    * This allows us to set a new owner for the upgrade mechanism.
    */
    function setUpgradeMaster(address _newMaster) external onlyUpgradeMaster {
        require(_newMaster != address(0));
        upgradeMaster = _newMaster;
    }

    // To be overriden to add functionality
    function allowUpgrades() external onlyUpgradeMaster () {
        upgradesAllowed = true;
    }

    // To be overriden to add functionality
    function rejectUpgrades() external onlyUpgradeMaster () {
        require(!(totalUpgraded > 0));
        upgradesAllowed = false;
    }

    // Get the state of the Nordic Energy token upgrade.
    function getUpgradeState() public view returns(UpgradeState) {
        if (!canUpgrade()) return UpgradeState.NotAllowed;
        else if (address(tokenUpgrader) == address(0)) return UpgradeState.Waiting;
        else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
        else return UpgradeState.Upgrading;
    }

    // To be overriden to add functionality
    function canUpgrade() public view returns(bool) {
        return upgradesAllowed;
    }
}



contract Token is UpgradeableToken, ERC20Burnable {
    string public name;
    string public symbol;

    // For patient incentive programs
    uint256 public INITIAL_SUPPLY;
    uint256 public holdPremiumCap;
    uint256 public holdPremiumMinted;

    // After 180 days you get a constant maximum bonus of 25% of Nordic Energy tokens transferred
    // Before that it is spread out linearly(from 0% to 25%) starting from the
    // contribution time till 180 days after that
    uint256 constant maxBonusDuration = 180 days;

    struct Bonus {
        uint256 holdTokens;
        uint256 contributionTime;
        uint256 buybackTokens;
    }

    mapping( address => Bonus ) public holdPremium;

    IERC20 stablecoin;
    address stablecoinPayer;

    uint256 public signupWindowStart;
    uint256 public signupWindowEnd;

    uint256 public refundWindowStart;
    uint256 public refundWindowEnd;

    event UpdatedTokenInformation(string newName, string newSymbol);
    event holdPremiumSet(address beneficiary, uint256 tokens, uint256 contributionTime);
    event holdPremiumCapSet(uint256 newholdPremiumCap);
    event RegisteredForRefund( address holder, uint256 tokens );

    constructor (address _litWallet, address _upgradeMaster, uint256 _INITIAL_SUPPLY, uint256 _holdPremiumCap)
        public
        UpgradeableToken(_upgradeMaster)
        Ownable()
    {
        require(maxTokenSupply >= _INITIAL_SUPPLY.mul(10 ** uint256(decimals)));
        INITIAL_SUPPLY = _INITIAL_SUPPLY.mul(10 ** uint256(decimals));
        setholdPremiumCap(_holdPremiumCap)  ;
        _mint(_litWallet, INITIAL_SUPPLY);
    }

    /**
    * Owner can update Nordic Energy token/stablecoin information here
    */
    function setTokenInformation(string calldata _name, string calldata _symbol) external onlyOwner {
        name = _name;
        symbol = _symbol;

        emit UpdatedTokenInformation(name, symbol);
    }

    function setRefundSignupDetails( uint256 _startTime,  uint256 _endTime, ERC20 _stablecoin, address _payer ) public onlyOwner {
        require( _startTime < _endTime );
        stablecoin = _stablecoin;
        stablecoinPayer = _payer;
        signupWindowStart = _startTime;
        signupWindowEnd = _endTime;
        refundWindowStart = signupWindowStart + 182 days;
        refundWindowEnd = signupWindowEnd + 182 days;
        require( refundWindowStart > signupWindowEnd);
    }

    function signUpForRefund( uint256 _value ) public {
        require( holdPremium[msg.sender].holdTokens != 0 || holdPremium[msg.sender].buybackTokens != 0, "You must be ICO/STOs user to sign up" ); //the user was registered in ICO/STOs
        require( block.timestamp >= signupWindowStart&& block.timestamp <= signupWindowEnd, "Cannot sign up at this time" );
        uint256 value = _value;
        value = value.add(holdPremium[msg.sender].buybackTokens);

        if( value > balanceOf(msg.sender)) //cannot register more than he or she has; since refund has to happen while Nordic Energy token is paused, we don't need to check anything else
            value = balanceOf(msg.sender);

        holdPremium[ msg.sender].buybackTokens = value;
        //buyback cancels hold highway
        if( holdPremium[msg.sender].holdTokens > 0 ){
            holdPremium[msg.sender].holdTokens = 0;
            emit holdPremiumSet( msg.sender, 0, holdPremium[msg.sender].contributionTime );
        }

        emit RegisteredForRefund(msg.sender, value);
    }

    function refund( uint256 _value ) public {
        require( block.timestamp >= refundWindowStart && block.timestamp <= refundWindowEnd, "cannot refund now" );
        require( holdPremium[msg.sender].buybackTokens >= _value, "not enough tokens in refund program" );
        require( balanceOf(msg.sender) >= _value, "not enough tokens" ); //this check is probably redundant to those in _burn, but better check twice
        holdPremium[msg.sender].buybackTokens = holdPremium[msg.sender].buybackTokens.sub(_value);
        _burn( msg.sender, _value );
        require( stablecoin.transferFrom( stablecoinPayer, msg.sender, _value.div(20) ), "transfer failed" ); //we pay 1/20 = 0.05 DAI for 1 LIT
    }

    function setholdPremiumCap(uint256 newholdPremiumCap) public onlyOwner {
        require(newholdPremiumCap > 0);
        holdPremiumCap = newholdPremiumCap;
        emit holdPremiumCapSet(holdPremiumCap);
    }

    /**
    * Owner can burn Nordic Energy tokens here
    */
    function burn(uint256 _value) public onlyOwner {
        super.burn(_value);
    }

    function setholdPremium(
        address beneficiary,
        uint256 value,
        uint256 contributionTime
    )
        public
        onlyOwner
        returns (bool)
    {
        require(beneficiary != address(0) && value > 0 && contributionTime > 0, "Not eligible for hold Premium");

        if (holdPremium[beneficiary].holdTokens != 0) {
            holdPremium[beneficiary].holdTokens = holdPremium[beneficiary].holdTokens.add(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

            emit holdPremiumSet(beneficiary, holdPremium[beneficiary].holdTokens, holdPremium[beneficiary].contributionTime);
        } else {
            holdPremium[beneficiary] = Bonus(value, contributionTime, 0);
            emit holdPremiumSet(beneficiary, value, contributionTime);
        }

        return true;
    }

    function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
        require(_to != address(0));
        require(_value <= balanceOf(msg.sender));

        if (holdPremiumMinted < holdPremiumCap && holdPremium[msg.sender].holdTokens > 0) {
            uint256 amountForBonusCalculation = calculateAmountForBonus(msg.sender, _value);
            uint256 bonus = calculateBonus(msg.sender, amountForBonusCalculation);

            //subtract the tokens token into account here to avoid the above calculations in the future, e.g. in case I withdraw everything in 0 days (bonus 0), and then refund, I shall not be eligible for any bonuses
            holdPremium[msg.sender].holdTokens = holdPremium[msg.sender].holdTokens.sub(amountForBonusCalculation);
            if ( bonus > 0) {
                //balances[msg.sender] = balances[msg.sender].add(bonus);
                _mint( msg.sender, bonus );
                //emit Transfer(address(0), msg.sender, bonus);
            }
        }

        ERC20Pausable.transfer( _to, _value );
//        balances[msg.sender] = balances[msg.sender].sub(_value);
//        balances[_to] = balances[_to].add(_value);
//        emit Transfer(msg.sender, _to, _value);

        //TODO: optimize to avoid setting values outside of buyback window
        if( balanceOf(msg.sender) < holdPremium[msg.sender].buybackTokens )
            holdPremium[msg.sender].buybackTokens = balanceOf(msg.sender);
        return true;
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
        require(_to != address(0));

        if (holdPremiumMinted < holdPremiumCap && holdPremium[_from].holdTokens > 0) {
            uint256 amountForBonusCalculation = calculateAmountForBonus(_from, _value);
            uint256 bonus = calculateBonus(_from, amountForBonusCalculation);

            //subtract the tokens token into account here to avoid the above calculations in the future, e.g. in case I withdraw everything in 0 days (bonus 0), and then refund, I shall not be eligible for any bonuses
            holdPremium[_from].holdTokens = holdPremium[_from].holdTokens.sub(amountForBonusCalculation);
            if ( bonus > 0) {
                //balances[_from] = balances[_from].add(bonus);
                _mint( _from, bonus );
                //emit Transfer(address(0), _from, bonus);
            }
        }

        ERC20Pausable.transferFrom( _from, _to, _value);
        if( balanceOf(_from) < holdPremium[_from].buybackTokens )
            holdPremium[_from].buybackTokens = balanceOf(_from);
        return true;
    }

    function calculateBonus(address beneficiary, uint256 amount) internal returns (uint256) {
        uint256 bonusAmount;

        uint256 contributionTime = holdPremium[beneficiary].contributionTime;
        uint256 bonusPeriod;
        if (now <= contributionTime) {
            bonusPeriod = 0;
        } else if (now.sub(contributionTime) >= maxBonusDuration) {
            bonusPeriod = maxBonusDuration;
        } else {
            bonusPeriod = now.sub(contributionTime);
        }

        if (bonusPeriod != 0) {
            bonusAmount = (((bonusPeriod.mul(amount)).div(maxBonusDuration)).mul(25)).div(100);
            if (holdPremiumMinted.add(bonusAmount) > holdPremiumCap) {
                bonusAmount = holdPremiumCap.sub(holdPremiumMinted);
                holdPremiumMinted = holdPremiumCap;
            } else {
                holdPremiumMinted = holdPremiumMinted.add(bonusAmount);
            }

            if( totalSupply().add(bonusAmount) > maxTokenSupply )
                bonusAmount = maxTokenSupply.sub(totalSupply());
        }

        return bonusAmount;
    }

    function calculateAmountForBonus(address beneficiary, uint256 _value) internal view returns (uint256) {
        uint256 amountForBonusCalculation;

        if(_value >= holdPremium[beneficiary].holdTokens) {
            amountForBonusCalculation = holdPremium[beneficiary].holdTokens;
        } else {
            amountForBonusCalculation = _value;
        }

        return amountForBonusCalculation;
    }

}


contract TestToken is ERC20{
    constructor ( uint256 _balance)public {
        _mint(msg.sender, _balance);
    }
}