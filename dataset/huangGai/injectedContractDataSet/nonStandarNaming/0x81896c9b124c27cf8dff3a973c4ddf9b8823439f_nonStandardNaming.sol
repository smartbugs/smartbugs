                                                                 

                                                                                 

pragma solidity ^0.5.7;

                                                                                          
library SafeMath {
    
    int256 constant private int256_min606 = -2**255;	//inject NONSTANDARD NAMING

                                                                                
    function MUL578(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                              
    function MUL578(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        require(!(a == -1 && b == int256_min606)); // This is the only case of overflow not detected by the check below

        int256 c = a * b;
        require(c / a == b);

        return c;
    }

                                                                                                                         
    function DIV266(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                       
    function DIV266(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
        require(b != 0); // Solidity only automatically asserts when dividing by 0
        require(!(b == -1 && a == int256_min606)); // This is the only case of overflow

        int256 c = a / b;

        return c;
    }

                                                                                                                            
    function SUB55(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                             
    function SUB55(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
        int256 c = a - b;
        require((b >= 0 && c <= a) || (b < 0 && c > a));

        return c;
    }

                                                                          
    function ADD666(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                        
    function ADD666(int256 a, int256 b) internal pure returns (int256) {	//inject NONSTANDARD NAMING
        int256 c = a + b;
        require((b >= 0 && c >= a) || (b < 0 && c < a));

        return c;
    }

                                                                                                                                                 
    function MOD120(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}


                                                                                        
interface IERC20 {
    function TOTALSUPPLY304() external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF735(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE123(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    function TRANSFER854(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE531(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM522(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    event TRANSFER418(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    event APPROVAL780(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract ERC20Pistachio is IERC20 {

    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

                                                               

    // Token symbol (short)
    string public symbol;

    // Token name (Long)
    string public  name;

    // Decimals (18 maximum)
    uint8 public decimals;

                                                                         
    constructor (address initialAccount, string memory _tokenSymbol, string memory _tokenName, uint256 initialBalance) public {

        // Initialize Contract Parameters
        symbol = _tokenSymbol;
        name = _tokenName;
        decimals = 18;  // default decimals is going to be 18 always

        _MINT600(initialAccount, initialBalance);

    }

                                                             
    function TOTALSUPPLY304() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                                                                                                                                                                          
    function BALANCEOF735(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[owner];
    }

                                                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE123(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowed[owner][spender];
    }

                                                                                                                                                             
    function TRANSFER854(address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER481(msg.sender, to, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE531(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit APPROVAL780(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function TRANSFERFROM522(address from, address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _allowed[from][msg.sender] = _allowed[from][msg.sender].SUB55(value);
        _TRANSFER481(from, to, value);
        emit APPROVAL780(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function INCREASEALLOWANCE330(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].ADD666(addedValue);
        emit APPROVAL780(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function DECREASEALLOWANCE446(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].SUB55(subtractedValue);
        emit APPROVAL780(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

                                                                                                                                                                                                               
    function _TRANSFER481(address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(to != address(0));

        _balances[from] = _balances[from].SUB55(value);
        _balances[to] = _balances[to].ADD666(value);
        emit TRANSFER418(from, to, value);
    }

                                                                                                                                                                                                                                                                                                                                                
    function _MINT600(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.ADD666(value);
        _balances[account] = _balances[account].ADD666(value);
        emit TRANSFER418(address(0), account, value);
    }

                                                                                                                                                                                                                           
    function _BURN785(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.SUB55(value);
        _balances[account] = _balances[account].SUB55(value);
        emit TRANSFER418(account, address(0), value);
    }

                                                                                                                                                                                                                                                                                                                                                                                              
    function _BURNFROM615(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        _allowed[account][msg.sender] = _allowed[account][msg.sender].SUB55(value);
        _BURN785(account, value);
        emit APPROVAL780(account, msg.sender, _allowed[account][msg.sender]);
    }

}

                                                                                           
contract ERC20Burnable is ERC20Pistachio {

    bool private _burnableActive;

                                                                                                                    
    function BURN665(uint256 value) public WHENBURNABLEACTIVE644 {	//inject NONSTANDARD NAMING
        _BURN785(msg.sender, value);
    }

                                                                                                                                                                                                                                                     
    function BURNFROM948(address from, uint256 value) public WHENBURNABLEACTIVE644 {	//inject NONSTANDARD NAMING
        _BURNFROM615(from, value);
    }

                                                                          

    function _SETBURNABLEACTIVE519(bool _active) internal {	//inject NONSTANDARD NAMING
        _burnableActive = _active;
    }

    modifier WHENBURNABLEACTIVE644() {	//inject NONSTANDARD NAMING
        require(_burnableActive);
        _;
    }

}

                                                                                  
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

                                                               
    function ADD666(Role storage role, address account) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));
        require(!HAS322(role, account));

        role.bearer[account] = true;
    }

                                                                   
    function REMOVE231(Role storage role, address account) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));
        require(HAS322(role, account));

        role.bearer[account] = false;
    }

                                                                                 
    function HAS322(Role storage role, address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        require(account != address(0));
        return role.bearer[account];
    }
}

contract MinterRole {
    using Roles for Roles.Role;

    event MINTERADDED605(address indexed account);	//inject NONSTANDARD NAMING
    event MINTERREMOVED905(address indexed account);	//inject NONSTANDARD NAMING

    Roles.Role private _minters;

    constructor () internal {
        _ADDMINTER929(msg.sender);
    }

    modifier ONLYMINTER785() {	//inject NONSTANDARD NAMING
        require(ISMINTER455(msg.sender));
        _;
    }

    function ISMINTER455(address account) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _minters.HAS322(account);
    }

    function ADDMINTER562(address account) public ONLYMINTER785 {	//inject NONSTANDARD NAMING
        _ADDMINTER929(account);
    }

    function RENOUNCEMINTER297() public {	//inject NONSTANDARD NAMING
        _REMOVEMINTER917(msg.sender);
    }

    function _ADDMINTER929(address account) internal {	//inject NONSTANDARD NAMING
        _minters.ADD666(account);
        emit MINTERADDED605(account);
    }

    function _REMOVEMINTER917(address account) internal {	//inject NONSTANDARD NAMING
        _minters.REMOVE231(account);
        emit MINTERREMOVED905(account);
    }
}

                                                           
contract ERC20Mintable is ERC20Pistachio, MinterRole {

    bool private _mintableActive;
                                                                                                                                                                                                                                                
    function MINT525(address to, uint256 value) public ONLYMINTER785 WHENMINTABLEACTIVE702 returns (bool) {	//inject NONSTANDARD NAMING
        _MINT600(to, value);
        return true;
    }

                                                                          

    function _SETMINTABLEACTIVE686(bool _active) internal {	//inject NONSTANDARD NAMING
        _mintableActive = _active;
    }

    modifier WHENMINTABLEACTIVE702() {	//inject NONSTANDARD NAMING
        require(_mintableActive);
        _;
    }

}

contract PauserRole {
    using Roles for Roles.Role;

    event PAUSERADDED252(address indexed account);	//inject NONSTANDARD NAMING
    event PAUSERREMOVED538(address indexed account);	//inject NONSTANDARD NAMING

    Roles.Role private _pausers;

    constructor () internal {
        _ADDPAUSER941(msg.sender);
    }

    modifier ONLYPAUSER672() {	//inject NONSTANDARD NAMING
        require(ISPAUSER604(msg.sender));
        _;
    }

    function ISPAUSER604(address account) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _pausers.HAS322(account);
    }

    function ADDPAUSER65(address account) public ONLYPAUSER672 {	//inject NONSTANDARD NAMING
        _ADDPAUSER941(account);
    }

    function RENOUNCEPAUSER647() public {	//inject NONSTANDARD NAMING
        _REMOVEPAUSER706(msg.sender);
    }

    function _ADDPAUSER941(address account) internal {	//inject NONSTANDARD NAMING
        _pausers.ADD666(account);
        emit PAUSERADDED252(account);
    }

    function _REMOVEPAUSER706(address account) internal {	//inject NONSTANDARD NAMING
        _pausers.REMOVE231(account);
        emit PAUSERREMOVED538(account);
    }
}

                                                                                                                
contract Pausable is PauserRole {
    event PAUSED114(address account);	//inject NONSTANDARD NAMING
    event UNPAUSED110(address account);	//inject NONSTANDARD NAMING

    bool private _pausableActive;
    bool private _paused;

    constructor () internal {
        _paused = false;
    }

                                                                               
    function PAUSED723() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _paused;
    }

                                                                                                      
    modifier WHENNOTPAUSED424() {	//inject NONSTANDARD NAMING
        require(!_paused);
        _;
    }

                                                                                                  
    modifier WHENPAUSED745() {	//inject NONSTANDARD NAMING
        require(_paused);
        _;
    }

                                                                                
    function PAUSE827() public ONLYPAUSER672 WHENNOTPAUSED424 WHENPAUSABLEACTIVE658 {	//inject NONSTANDARD NAMING
        _paused = true;
        emit PAUSED114(msg.sender);
    }

                                                                                   
    function UNPAUSE942() public ONLYPAUSER672 WHENPAUSED745 WHENPAUSABLEACTIVE658 {	//inject NONSTANDARD NAMING
        _paused = false;
        emit UNPAUSED110(msg.sender);
    }

                                                                              

    function _SETPAUSABLEACTIVE337(bool _active) internal {	//inject NONSTANDARD NAMING
        _pausableActive = _active;
    }

    modifier WHENPAUSABLEACTIVE658() {	//inject NONSTANDARD NAMING
        require(_pausableActive);
        _;
    }

}

                                                                                                                                                                                                                                                                                         
contract ERC20Chocolate is ERC20Pistachio, ERC20Burnable, ERC20Mintable, Pausable {

    // maximum capital, if defined > 0
    uint256 private _cap;

    constructor (
        address initialAccount, string memory _tokenSymbol, string memory _tokenName, uint256 initialBalance, uint256 cap,
        bool _burnableOption, bool _mintableOption, bool _pausableOption
    ) public
        ERC20Pistachio(initialAccount, _tokenSymbol, _tokenName, initialBalance) {

        // we must add customer account as the first minter
        ADDMINTER562(initialAccount);

        // add customer as pauser
        ADDPAUSER65(initialAccount);

        if (cap > 0) {
            _cap = cap; // maximum capitalization limited
        } else {
            _cap = 0; // unlimited capitalization
        }

        // activate or deactivate options
        _SETBURNABLEACTIVE519(_burnableOption);
        _SETMINTABLEACTIVE686(_mintableOption);
        _SETPAUSABLEACTIVE337(_pausableOption);

    }

                                                             
    function CAP794() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _cap;
    }

                                                                             
    function _MINT600(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        if (_cap > 0) {
            require(TOTALSUPPLY304().ADD666(value) <= _cap);
        }
        super._MINT600(account, value);
    }

                                       
    function TRANSFER854(address to, uint256 value) public WHENNOTPAUSED424 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFER854(to, value);
    }

    function TRANSFERFROM522(address from,address to, uint256 value) public WHENNOTPAUSED424 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFERFROM522(from, to, value);
    }

    function APPROVE531(address spender, uint256 value) public WHENNOTPAUSED424 returns (bool) {	//inject NONSTANDARD NAMING
        return super.APPROVE531(spender, value);
    }

    function INCREASEALLOWANCE330(address spender, uint addedValue) public WHENNOTPAUSED424 returns (bool success) {	//inject NONSTANDARD NAMING
        return super.INCREASEALLOWANCE330(spender, addedValue);
    }

    function DECREASEALLOWANCE446(address spender, uint subtractedValue) public WHENNOTPAUSED424 returns (bool success) {	//inject NONSTANDARD NAMING
        return super.DECREASEALLOWANCE446(spender, subtractedValue);
    }

}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
contract ReentrancyGuard {
    // counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

                                                                                                                                                                                                                                                                                                                                                                                
    modifier NONREENTRANT377() {	//inject NONSTANDARD NAMING
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function SAFETRANSFER714(IERC20 token, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN667(token, abi.encodeWithSelector(token.TRANSFER854.selector, to, value));
    }

    function SAFETRANSFERFROM672(IERC20 token, address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        CALLOPTIONALRETURN667(token, abi.encodeWithSelector(token.TRANSFERFROM522.selector, from, to, value));
    }

    function SAFEAPPROVE372(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.ALLOWANCE123(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        CALLOPTIONALRETURN667(token, abi.encodeWithSelector(token.APPROVE531.selector, spender, value));
    }

    function SAFEINCREASEALLOWANCE265(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE123(address(this), spender).ADD666(value);
        CALLOPTIONALRETURN667(token, abi.encodeWithSelector(token.APPROVE531.selector, spender, newAllowance));
    }

    function SAFEDECREASEALLOWANCE998(IERC20 token, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        uint256 newAllowance = token.ALLOWANCE123(address(this), spender).SUB55(value);
        CALLOPTIONALRETURN667(token, abi.encodeWithSelector(token.APPROVE531.selector, spender, newAllowance));
    }

                                                                                                                                                                                                                                                                                                                                                                                        
    function CALLOPTIONALRETURN667(IERC20 token, bytes memory data) private {	//inject NONSTANDARD NAMING
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).ISCONTRACT761(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

                                                                   
library Address {
                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function ISCONTRACT761(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.
        
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

                                                                                                                                                                  
    function TOPAYABLE851(address account) internal pure returns (address payable) {	//inject NONSTANDARD NAMING
        return address(uint160(account));
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
contract Crowdsale is ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for ERC20Chocolate;

    // The token being sold
    ERC20Chocolate private _token;

    // Address where funds are collected
    address payable private _wallet;

    // How many token units a buyer gets per wei.
    // The rate is the conversion between wei and the smallest and indivisible token unit.
    // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
    // 1 wei will give you 1 unit, or 0.001 TOK.
    uint256 private _rate;

    // Amount of wei raised
    uint256 private _weiRaised;

                                                                                                                                                                                                                                               
    event TOKENSPURCHASED287(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    constructor (uint256 rate, address payable wallet, ERC20Chocolate token) public {
        require(rate > 0, "Crowdsale: rate is 0");
        require(wallet != address(0), "Crowdsale: wallet is the zero address");
        require(address(token) != address(0), "Crowdsale: token is the zero address");

        _rate = rate;
        _wallet = wallet;
        _token = token;
    }

                                                                                                                                                                                                                                                                                          
    function () external payable {
        BUYTOKENS434(msg.sender);
    }

                                                    
    function TOKEN293() public view returns (IERC20) {	//inject NONSTANDARD NAMING
        return _token;
    }

                                                                     
    function WALLET108() public view returns (address payable) {	//inject NONSTANDARD NAMING
        return _wallet;
    }

                                                                              
    function RATE426() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _rate;
    }

                                                        
    function WEIRAISED13() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _weiRaised;
    }

                                                                                                                                                                                                                                                          
    function BUYTOKENS434(address beneficiary) public NONREENTRANT377 payable {	//inject NONSTANDARD NAMING
        uint256 weiAmount = msg.value;
        _PREVALIDATEPURCHASE289(beneficiary, weiAmount);

        // calculate token amount to be created
        uint256 tokens = _GETTOKENAMOUNT276(weiAmount);

        // update state
        _weiRaised = _weiRaised.ADD666(weiAmount);

        _PROCESSPURCHASE887(beneficiary, tokens);
        emit TOKENSPURCHASED287(msg.sender, beneficiary, weiAmount, tokens);

        _UPDATEPURCHASINGSTATE322(beneficiary, weiAmount);

        _FORWARDFUNDS963();
        _POSTVALIDATEPURCHASE368(beneficiary, weiAmount);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function _PREVALIDATEPURCHASE289(address beneficiary, uint256 weiAmount) internal view {	//inject NONSTANDARD NAMING
        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
        require(weiAmount != 0, "Crowdsale: weiAmount is 0");
    }

                                                                                                                                                                                                                                                                                                
    function _POSTVALIDATEPURCHASE368(address beneficiary, uint256 weiAmount) internal view {	//inject NONSTANDARD NAMING
        // solhint-disable-previous-line no-empty-blocks
    }

                                                                                                                                                                                                                                                                                 
    function _DELIVERTOKENS47(address beneficiary, uint256 tokenAmount) internal {	//inject NONSTANDARD NAMING
        _token.SAFETRANSFER714(beneficiary, tokenAmount);
    }

                                                                                                                                                                                                                                                                   
    function _PROCESSPURCHASE887(address beneficiary, uint256 tokenAmount) internal {	//inject NONSTANDARD NAMING
        _DELIVERTOKENS47(beneficiary, tokenAmount);
    }

                                                                                                                                                                                                                                                                       
    function _UPDATEPURCHASINGSTATE322(address beneficiary, uint256 weiAmount) internal {	//inject NONSTANDARD NAMING
        // solhint-disable-previous-line no-empty-blocks
    }

                                                                                                                                                                                                                                                  
    function _GETTOKENAMOUNT276(uint256 weiAmount) internal view returns (uint256) {	//inject NONSTANDARD NAMING
        return weiAmount.MUL578(_rate);
    }

                                                                                
    function _FORWARDFUNDS963() internal {	//inject NONSTANDARD NAMING
        _wallet.transfer(msg.value);
    }
}

                                                                                                                                                                                            
contract MintedCrowdsale is Crowdsale {
                                                                                                                                                                                 
    function _DELIVERTOKENS47(address beneficiary, uint256 tokenAmount) internal {	//inject NONSTANDARD NAMING
        // Potentially dangerous assumption about the type of the token.
        require(
            ERC20Mintable(address(TOKEN293())).MINT525(beneficiary, tokenAmount),
                "MintedCrowdsale: minting failed"
        );
    }
}

                                                                                                                                          
contract PausableCrowdsale is Crowdsale, Pausable {
                                                                                                                                                                                                                                                                                                                                                                                  
    function _PREVALIDATEPURCHASE289(address _beneficiary, uint256 _weiAmount) internal view WHENNOTPAUSED424 {	//inject NONSTANDARD NAMING
        return super._PREVALIDATEPURCHASE289(_beneficiary, _weiAmount);
    }
}

                                                       
contract CrowdsaleRaspberry is MintedCrowdsale, PausableCrowdsale {
    constructor (uint256 rate, address payable wallet, ERC20Chocolate token, bool _isPausable) public
    Crowdsale(rate, wallet, token) {
        // solhint-disable-previous-line no-empty-blocks
        _SETPAUSABLEACTIVE337(_isPausable);
    }
}