/**
 *Submitted for verification at Etherscan.io on 2020-02-20
*/

pragma solidity ^0.5.2;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
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
        //require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a);

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
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
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

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title Helps contracts guard against reentrancy attacks.
 * @author Remco Bloemen <remco@21.com>, Eenae <alexey@mixbytes.io>
 * @dev If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter);
    }
}

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor () internal {
        _paused = false;
    }

    /**
     * @return True if the contract is paused, false otherwise.
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
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(_paused);
        _;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function pause() public onlyOwner whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev Called by a pauser to unpause, returns to normal state.
     */
    function unpause() public onlyOwner whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}

/**
 * @title GLDS
 * @dev ERC20 Token
 */

contract GLDS is IERC20, Ownable, ReentrancyGuard, Pausable  {
   using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    mapping (address => bool) private status;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _initSupply;
    // Address Admin
     address private _walletAdmin;
    // Address where ETH  can be collected
     address payable _walletFund;
    // Address where tokens for 25% bonus can be collected
     address private _walletB25;
    // Address where tokens for 20% bonus can be collected
     address private _walletB20;
     // Address where tokens for 10% bonus can be collected
     address private _walletB10;
     // Amount of wei raised
     uint256 private _weiRaised;
     // Min wei qty required to buy
     uint256 private _minWeiQty;
     // Max wei qty required to buy
     uint256 private _maxWeiQty;
     // Payment info
     struct Payment{
         uint256 index; // index start 1 to keyList.length
         uint256 valueETH;
     }
     // Awaiting list for GLDS tokens after payment. Iterable mapping
     mapping(address => Payment) internal awaitGLDS;
     address[] internal keyList;
     // Bonus 25% info
     struct B25{
         uint256 index; // index start 1 to keyList.length
         uint256 valueGLDS;
     }
     // Awaiting list for Bonus 25%. Iterable mapping
     mapping(address => B25) internal awaitB25;
     address[] internal keyListB25;
     // Bonus 20% info
     struct B20{
         uint256 index; // index start 1 to keyList.length
         uint256 valueGLDS;
     }
     // Awaiting list for Bonus 20%. Iterable mapping
     mapping(address => B20) internal awaitB20;
     address[] internal keyListB20;
     // Bonus 10% info
     struct B10{
         uint256 index; // index start 1 to keyList.length
         uint256 valueGLDS;
     }
     // Awaiting list for Bonus 20%. Iterable mapping
     mapping(address => B10) internal awaitB10;
     address[] internal keyListB10;

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
       * @dev Function to mint tokens.onlyOwner
       * @param to The address that will receive the minted tokens.
       * @param value The amount of tokens to mint.
       * @return A boolean that indicates if the operation was successful.
       */
      function mint(address to, uint256 value) public onlyOwner returns (bool) {
          _mint(to, value);
          return true;
      }

     constructor (string memory name, string memory symbol, uint8 decimals, uint256 initSupply) public {
         _name = name;
         _symbol = symbol;
         _decimals = decimals;
         _initSupply = initSupply.mul(10 **uint256(decimals));
         _mint(msg.sender, _initSupply);
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
     /**
      * @return the initial Supply of the token.
      */
     function initSupply() public view returns (uint256) {
         return _initSupply;
     }

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
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));
        require(value <= _balances[account]);
        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
      * @dev Function to burn tokens.onlyOwner
      * @param from The address to burn tokens.
      * @param value The amount of tokens to burn.
      * @return A boolean that indicates if the operation was successful.
      */
     function burn(address from, uint256 value) public onlyOwner returns (bool) {
         _burn(from, value);
         return true;
     }

    /**
    * @dev Transfer token for a specified addresses
    * @param from The address to transfer from.
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function _transfer(address from, address to, uint256 value) internal {
        require(from != address(0));
        require(to != address(0));
        require(value <= _balances[from]);
        if (from == _walletB25){addB25(to, value);}
        if (from == _walletB20){addB20(to, value);}
        if (from == _walletB10){addB10(to, value);}
        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
    * @dev Transfer token for a specified address.onlyOwner
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transferOwner(address to, uint256 value) public onlyOwner returns (bool) {
        require(value > 0);
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
    function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
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
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
        require(spender != address(0));
        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
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
    function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
        require(from != address(0));
        require(value <= _allowed[from][msg.sender]);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        _transfer(from, to, value);
        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.onlyAdmin
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferAdminFrom(address from, address to, uint256 value) public onlyAdmin returns (bool) {
        require(from != address(0));
        require(value <= _allowed[from][msg.sender]);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        _transfer(from, to, value);
        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

   /**
     * @dev check an account's status
     * @return bool
     */
    function checkStatus(address account) public view returns (bool) {
        require(account != address(0));
        bool currentStatus = status[account];
        return currentStatus;
    }

    /**
     * @dev change an account's status. OnlyOwner
     * @return bool
     */
    function changeStatus(address account) public  onlyOwner {
        require(account != address(0));
        bool currentStatus1 = status[account];
       status[account] = (currentStatus1 == true) ? false : true;
    }

   /**
     * @dev fallback function ***DO NOT OVERRIDE***
     * Note that other contracts will transfer fund with a base gas stipend
     * of 2300, which is not enough to call buyTokens. Consider calling
     * buyTokens directly when purchasing tokens from a contract.
     */
    function () external payable {
        payTokens(msg.sender, msg.value);
    }

    function payTokens(address beneficiary, uint256 weiAmount) public nonReentrant payable {
        // check beneficiary
        require(beneficiary != address(0));
        require(checkStatus(beneficiary) != true);
        // check weiAmount
        require(weiAmount > 0);
        require(weiAmount >= _minWeiQty);
        require(weiAmount <= _maxWeiQty);
        // check _walletFund
        require(_walletFund != address(0));
        // transfer 100% weiAmount to _walletFund
        _walletFund.transfer(weiAmount);
        // update state
        _weiRaised = _weiRaised.add(weiAmount);	//injected INTEGER OVERFLOW OR UNDERFLOW

        // add beneficiary to awaiting list for GLDS tokens
        addPay(beneficiary, weiAmount);

    }

    function transferTokens(uint256 rateX, uint256 rateY) public onlyAdmin returns (bool) {
      uint len = keyList.length;
      for (uint i = 0; i < len; i++) {
      address beneficiary = keyList[i];
      uint256 qtyWei = awaitGLDS[keyList[i]].valueETH;
      uint256 qtyGLDS = qtyWei.div(rateY).mul(rateX);
      uint256 FromWalletB25 = (balanceOf(_walletB25) <= qtyGLDS)? balanceOf(_walletB25) : qtyGLDS;
      qtyGLDS -= FromWalletB25;
      uint256 FromWalletB20 = (balanceOf(_walletB20) <= qtyGLDS)? balanceOf(_walletB20) : qtyGLDS;
      qtyGLDS -= FromWalletB20;
      uint256 FromWalletB10 = (balanceOf(_walletB10) <= qtyGLDS)? balanceOf(_walletB10) : qtyGLDS;
      qtyGLDS -= FromWalletB10;
      if (FromWalletB25 > 0){transferFrom(_walletB25, beneficiary, FromWalletB25);}
      if (FromWalletB20 > 0){transferFrom(_walletB20, beneficiary, FromWalletB20);}
      if (FromWalletB10 > 0){transferFrom(_walletB10, beneficiary, FromWalletB10);}
      qtyWei = qtyGLDS.div(rateX).mul(rateY);
      awaitGLDS[keyList[i]].valueETH = qtyWei;
      }
      return true;
    }

    /**
     * Set _walletFund for ETH collected. onlyOwner
     */
    function setWalletFund(address payable WalletFund) public onlyOwner returns (bool){
       require(WalletFund != address(0));
        _walletFund = WalletFund;
        return true;
    }

    /**
     * @return the _walletFund.
     */
    function walletFund() public view returns (address) {
        return _walletFund;
    }

    /**
     * Set the _walletAdmin. onlyOwner
     */
    function setWalletAdmin(address WalletAdmin) public onlyOwner returns (bool){
        require(WalletAdmin != address(0));
        _walletAdmin = WalletAdmin;
        return true;
    }

     /**
     * @return the _walletAdmin.
     */
    function walletAdmin() public view returns (address) {
        return _walletAdmin;
    }

    /**
     * @dev Throws if called by any account other than the admin.
     */
    modifier onlyAdmin() {
        require(isAdmin());
        _;
    }

    /**
     * @return true if `msg.sender` is the admin of the contract.
     */
    function isAdmin() public view returns (bool) {
        return msg.sender == _walletAdmin;
    }

    /**
     * Set _walletB25, _walletB20, _walletB10 for GLDS collected. onlyOwner
     */
    function setWalletsTokenSale(address WalletB25, address WalletB20, address WalletB10) public onlyOwner returns (bool){
        require(WalletB25 != address(0));
        require(WalletB20 != address(0));
        require(WalletB10 != address(0));
        _walletB25 = WalletB25;
        _walletB20 = WalletB20;
        _walletB10 = WalletB10;
        return true;
    }

    /**
     * @return the _walletB25, _walletB20, _walletB10.
     */
    function walletsTokenSale() public view returns (address, address, address) {
        return (_walletB25, _walletB20, _walletB10);
    }

    /**
     * Charge _walletB25, _walletB20, _walletB10 for GLDS collected. onlyOwner
     */
    function chargeWalletsTokenSale(uint256 AmountB25, uint256 AmountB20, uint256 AmountB10) public onlyOwner returns (bool){
        uint256 total = AmountB25.add(AmountB20).add(AmountB10);
        require(total <= balanceOf(owner()));
        if (AmountB25 > 0) {transfer(_walletB25, AmountB25);}
        if (AmountB20 > 0) {transfer(_walletB20, AmountB20);}
        if (AmountB10 > 0) {transfer(_walletB10, AmountB10);}
        return true;
    }

    /**
     * Set the _MinTokenQty. onlyOwner
     */
    function setMinWeiQty(uint256 MinWeiQty) public onlyOwner returns (bool){
        _minWeiQty = MinWeiQty;
        return true;
    }

    /**
     * Set the _MaxTokenQty. onlyOwner
     */
    function setMaxWeiQty(uint256 MaxWeiQty) public onlyOwner returns (bool){
        _maxWeiQty = MaxWeiQty;
        return true;
    }

    /**
     * @return the number of wei income Total.
     */
    function weiRaised() public view returns (uint256) {
        return _weiRaised;
    }

    /**
     * @return _MinTokenQty.
     */
    function minWeiQty() public view returns (uint256) {
        return _minWeiQty;
    }

    /**
     * @return _MaxTokenQty.
     */
    function maxWeiQty() public view returns (uint256) {
        return _maxWeiQty;
    }

    function addPay(address _key, uint256 _valueETH) internal {
        Payment storage pay = awaitGLDS[_key];
        pay.valueETH += _valueETH;
        if(pay.index > 0){ // payer exists
            // do nothing
            return;
        }else { // new payer
            keyList.push(_key);
            uint keyListIndex = keyList.length - 1;
            pay.index = keyListIndex + 1;
        }
    }

    function removePay(address _key) public onlyOwner returns (bool){
        Payment storage pay = awaitGLDS[_key];
        require(pay.index != 0); // payer not exist
        require(pay.index <= keyList.length); // invalid index value
        // Move an last element of array into the vacated key slot.
        uint keyListIndex = pay.index - 1;
        uint keyListLastIndex = keyList.length - 1;
        awaitGLDS[keyList[keyListLastIndex]].index = keyListIndex + 1;
        keyList[keyListIndex] = keyList[keyListLastIndex];
        keyList.length--;
        delete awaitGLDS[_key];
        return true;
    }

    function sizeAwaitingList() public view returns (uint) {
        return uint(keyList.length);
    }

    function sumAwaitingList() public view returns (uint256) {
        uint len = keyList.length;
        uint256 sum = 0;
        for (uint i = 0; i < len; i++) {
        sum += awaitGLDS[keyList[i]].valueETH;
        }
        return uint256(sum);
    }

    function keysAwaitingList() public view returns (address[] memory) {
        return keyList;
    }

    function containsAwaitingList(address _key) public view returns (bool) {
        return awaitGLDS[_key].index > 0;
    }

    function getIndex(address _key) public view returns (uint256) {
        return awaitGLDS[_key].index;
    }

   function getValueETH(address _key) public view returns (uint256) {
        return awaitGLDS[_key].valueETH;
    }

    function getByIndex(uint256 _index) public view returns (uint256, address, uint256) {
        require(_index >= 0);
        require(_index < keyList.length);
        return (awaitGLDS[keyList[_index]].index, keyList[_index], awaitGLDS[keyList[_index]].valueETH);
    }

    function addB25(address _key, uint256 _valueGLDS) internal {
        B25 storage bonus25 = awaitB25[_key];
        bonus25.valueGLDS += _valueGLDS;
        if(bonus25.index > 0){ // payer exists
            // do nothing
            return;
        }else { // new payer
            keyListB25.push(_key);
            uint keyListIndex = keyListB25.length - 1;
            bonus25.index = keyListIndex + 1;
        }
    }

    function removeB25(address _key) public onlyOwner returns (bool) {
        B25 storage bonus25 = awaitB25[_key];
        require(bonus25.index != 0); // payer not exist
        require(bonus25.index <= keyListB25.length); // invalid index value
        // Move an last element of array into the vacated key slot.
        uint keyListIndex = bonus25.index - 1;
        uint keyListLastIndex = keyListB25.length - 1;
        awaitB25[keyListB25[keyListLastIndex]].index = keyListIndex + 1;
        keyListB25[keyListIndex] = keyListB25[keyListLastIndex];
        keyListB25.length--;
        delete awaitB25[_key];
        return true;
    }

    function sizeB25List() public view returns (uint) {
        return uint(keyListB25.length);
    }

    function sumB25List() public view returns (uint256) {
        uint len = keyListB25.length;
        uint256 sum = 0;
        for (uint i = 0; i < len; i++) {
        sum += awaitB25[keyListB25[i]].valueGLDS;
        }
        return uint256(sum);
    }

    function keysB25List() public view returns (address[] memory) {
        return keyListB25;
    }

    function containsB25List(address _key) public view returns (bool) {
        return awaitB25[_key].index > 0;
    }

    function getB25Index(address _key) public view returns (uint256) {
        return awaitB25[_key].index;
    }

   function getB25ValueGLDS(address _key) public view returns (uint256) {
        return awaitB25[_key].valueGLDS;
    }

    function getB25ByIndex(uint256 _index) public view returns (uint256, address, uint256) {
        require(_index >= 0);
        require(_index < keyListB25.length);
        return (awaitB25[keyListB25[_index]].index, keyListB25[_index], awaitB25[keyListB25[_index]].valueGLDS);
    }

    function addB20(address _key, uint256 _valueGLDS) internal {
        B20 storage bonus20 = awaitB20[_key];
        bonus20.valueGLDS += _valueGLDS;
        if(bonus20.index > 0){ // payer exists
            // do nothing
            return;
        }else { // new payer
            keyListB20.push(_key);
            uint keyListIndex = keyListB20.length - 1;
            bonus20.index = keyListIndex + 1;
        }
    }

    function removeB20(address _key) public onlyOwner returns (bool) {
        B20 storage bonus20 = awaitB20[_key];
        require(bonus20.index != 0); // payer not exist
        require(bonus20.index <= keyListB20.length); // invalid index value
        // Move an last element of array into the vacated key slot.
        uint keyListIndex = bonus20.index - 1;
        uint keyListLastIndex = keyListB20.length - 1;
        awaitB20[keyListB20[keyListLastIndex]].index = keyListIndex + 1;
        keyListB20[keyListIndex] = keyListB20[keyListLastIndex];
        keyListB20.length--;
        delete awaitB20[_key];
        return true;
    }

    function sizeB20List() public view returns (uint) {
        return uint(keyListB20.length);
    }

    function sumB20List() public view returns (uint256) {
        uint len = keyListB20.length;
        uint256 sum = 0;
        for (uint i = 0; i < len; i++) {
        sum += awaitB20[keyListB20[i]].valueGLDS;
        }
        return uint256(sum);
    }

    function keysB20List() public view returns (address[] memory) {
        return keyListB20;
    }

    function containsB20List(address _key) public view returns (bool) {
        return awaitB20[_key].index > 0;
    }

    function getB20Index(address _key) public view returns (uint256) {
        return awaitB20[_key].index;
    }

    function getB20ValueGLDS(address _key) public view returns (uint256) {
        return awaitB20[_key].valueGLDS;
    }

    function getB20ByIndex(uint256 _index) public view returns (uint256, address, uint256) {
        require(_index >= 0);
        require(_index < keyListB20.length);
        return (awaitB20[keyListB20[_index]].index, keyListB20[_index], awaitB20[keyListB20[_index]].valueGLDS);
    }

    function addB10(address _key, uint256 _valueGLDS) internal {
        B10 storage bonus10 = awaitB10[_key];
        bonus10.valueGLDS += _valueGLDS;
        if(bonus10.index > 0){ // payer exists
            // do nothing
            return;
        }else { // new payer
            keyListB10.push(_key);
            uint keyListIndex = keyListB10.length - 1;
            bonus10.index = keyListIndex + 1;
        }
    }

    function removeB10(address _key) public onlyOwner returns (bool) {
        B10 storage bonus10 = awaitB10[_key];
        require(bonus10.index != 0); // payer not exist
        require(bonus10.index <= keyListB10.length); // invalid index value
        // Move an last element of array into the vacated key slot.
        uint keyListIndex = bonus10.index - 1;
        uint keyListLastIndex = keyListB10.length - 1;
        awaitB10[keyListB10[keyListLastIndex]].index = keyListIndex + 1;
        keyListB10[keyListIndex] = keyListB10[keyListLastIndex];
        keyListB10.length--;
        delete awaitB10[_key];
        return true;
    }

    function sizeB10List() public view returns (uint) {
        return uint(keyListB10.length);
    }

    function sumB10List() public view returns (uint256) {
        uint len = keyListB10.length;
        uint256 sum = 0;
        for (uint i = 0; i < len; i++) {
        sum += awaitB10[keyListB10[i]].valueGLDS;
        }
        return uint256(sum);
    }

    function keysB10List() public view returns (address[] memory) {
        return keyListB10;
    }

    function containsB10List(address _key) public view returns (bool) {
        return awaitB10[_key].index > 0;
    }

    function getB10Index(address _key) public view returns (uint256) {
        return awaitB10[_key].index;
    }

    function getB10ValueGLDS(address _key) public view returns (uint256) {
        return awaitB10[_key].valueGLDS;
    }

    function getB10ByIndex(uint256 _index) public view returns (uint256, address, uint256) {
        require(_index >= 0);
        require(_index < keyListB10.length);
        return (awaitB10[keyListB10[_index]].index, keyListB10[_index], awaitB10[keyListB10[_index]].valueGLDS);
    }
    
}