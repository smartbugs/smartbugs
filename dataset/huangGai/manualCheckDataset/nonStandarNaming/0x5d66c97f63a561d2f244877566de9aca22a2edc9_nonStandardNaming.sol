pragma solidity ^0.5.8;

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

                                                                                                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY24() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF234(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER72(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE257(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function APPROVE45(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM346(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER728(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL558(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol

                                                           
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

                                                                                                                                                                                       
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

                                                          
    function NAME136() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                                                                          
    function SYMBOL217() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function DECIMALS964() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD825(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB689(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL868(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV452(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD717(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

                                                     
    function TOTALSUPPLY24() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF234(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER72(address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER437(msg.sender, recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE257(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE45(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE89(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function TRANSFERFROM346(address sender, address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER437(sender, recipient, amount);
        _APPROVE89(sender, msg.sender, _allowances[sender][msg.sender].SUB689(amount));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE86(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE89(msg.sender, spender, _allowances[msg.sender][spender].ADD825(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE981(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE89(msg.sender, spender, _allowances[msg.sender][spender].SUB689(subtractedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER437(address sender, address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB689(amount);
        _balances[recipient] = _balances[recipient].ADD825(amount);
        emit TRANSFER728(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                                       
    function _MINT126(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD825(amount);
        _balances[account] = _balances[account].ADD825(amount);
        emit TRANSFER728(address(0), account, amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN761(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.SUB689(value);
        _balances[account] = _balances[account].SUB689(value);
        emit TRANSFER728(account, address(0), value);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _APPROVE89(address owner, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit APPROVAL558(owner, spender, value);
    }

                                                                                                                                                                          
    function _BURNFROM912(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        _BURN761(account, amount);
        _APPROVE89(account, msg.sender, _allowances[account][msg.sender].SUB689(amount));
    }
}

// File: openzeppelin-solidity/contracts/access/Roles.sol

                                                                                  
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

                                                                
    function ADD825(Role storage role, address account) internal {	//inject NONSTANDARD NAMING
        require(!HAS200(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

                                                                    
    function REMOVE879(Role storage role, address account) internal {	//inject NONSTANDARD NAMING
        require(HAS200(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

                                                                                  
    function HAS200(Role storage role, address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol

contract MinterRole {
    using Roles for Roles.Role;

    event MINTERADDED281(address indexed account);	//inject NONSTANDARD NAMING
    event MINTERREMOVED788(address indexed account);	//inject NONSTANDARD NAMING

    Roles.Role private _minters;

    constructor () internal {
        _ADDMINTER695(msg.sender);
    }

    modifier ONLYMINTER448() {	//inject NONSTANDARD NAMING
        require(ISMINTER103(msg.sender), "MinterRole: caller does not have the Minter role");
        _;
    }

    function ISMINTER103(address account) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _minters.HAS200(account);
    }

    function ADDMINTER340(address account) public ONLYMINTER448 {	//inject NONSTANDARD NAMING
        _ADDMINTER695(account);
    }

    function RENOUNCEMINTER82() public {	//inject NONSTANDARD NAMING
        _REMOVEMINTER969(msg.sender);
    }

    function _ADDMINTER695(address account) internal {	//inject NONSTANDARD NAMING
        _minters.ADD825(account);
        emit MINTERADDED281(account);
    }

    function _REMOVEMINTER969(address account) internal {	//inject NONSTANDARD NAMING
        _minters.REMOVE879(account);
        emit MINTERREMOVED788(account);
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol

                                                                                                                                                                                                                                     
contract ERC20Mintable is ERC20, MinterRole {
                                                                                                                                 
    function MINT699(address account, uint256 amount) public ONLYMINTER448 returns (bool) {	//inject NONSTANDARD NAMING
        _MINT126(account, amount);
        return true;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol

                                                                                     
contract ERC20Capped is ERC20Mintable {
    uint256 private _cap;

                                                                                                                                     
    constructor (uint256 cap) public {
        require(cap > 0, "ERC20Capped: cap is 0");
        _cap = cap;
    }

                                                                        
    function CAP280() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _cap;
    }

                                                                                                                                                             
    function _MINT126(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(TOTALSUPPLY24().ADD825(value) <= _cap, "ERC20Capped: cap exceeded");
        super._MINT126(account, value);
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol

                                                                                                                                                                                                                
contract ERC20Burnable is ERC20 {
                                                                                                     
    function BURN558(uint256 amount) public {	//inject NONSTANDARD NAMING
        _BURN761(msg.sender, amount);
    }

                                                  
    function BURNFROM709(address account, uint256 amount) public {	//inject NONSTANDARD NAMING
        _BURNFROM912(account, amount);
    }
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

                                                                                                                                                                                                                                                                                                                                                                       
contract Ownable {
    address private _owner;

    event OWNERSHIPTRANSFERRED785(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                               
    constructor () internal {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED785(address(0), _owner);
    }

                                                                     
    function OWNER790() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER785() {	//inject NONSTANDARD NAMING
        require(ISOWNER48(), "Ownable: caller is not the owner");
        _;
    }

                                                                            
    function ISOWNER48() public view returns (bool) {	//inject NONSTANDARD NAMING
        return msg.sender == _owner;
    }

                                                                                                                                                                                                                                                                                                                                                 
    function RENOUNCEOWNERSHIP92() public ONLYOWNER785 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED785(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                              
    function TRANSFEROWNERSHIP413(address newOwner) public ONLYOWNER785 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP978(newOwner);
    }

                                                                                              
    function _TRANSFEROWNERSHIP978(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED785(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: eth-token-recover/contracts/TokenRecover.sol

                                                                                                                                                                  
contract TokenRecover is Ownable {

                                                                                                                                                                                                                                             
    function RECOVERERC20723(address tokenAddress, uint256 tokenAmount) public ONLYOWNER785 {	//inject NONSTANDARD NAMING
        IERC20(tokenAddress).TRANSFER72(OWNER790(), tokenAmount);
    }
}

// File: ico-maker/contracts/access/roles/OperatorRole.sol

contract OperatorRole {
    using Roles for Roles.Role;

    event OPERATORADDED875(address indexed account);	//inject NONSTANDARD NAMING
    event OPERATORREMOVED255(address indexed account);	//inject NONSTANDARD NAMING

    Roles.Role private _operators;

    constructor() internal {
        _ADDOPERATOR101(msg.sender);
    }

    modifier ONLYOPERATOR594() {	//inject NONSTANDARD NAMING
        require(ISOPERATOR640(msg.sender));
        _;
    }

    function ISOPERATOR640(address account) public view returns (bool) {	//inject NONSTANDARD NAMING
        return _operators.HAS200(account);
    }

    function ADDOPERATOR763(address account) public ONLYOPERATOR594 {	//inject NONSTANDARD NAMING
        _ADDOPERATOR101(account);
    }

    function RENOUNCEOPERATOR674() public {	//inject NONSTANDARD NAMING
        _REMOVEOPERATOR451(msg.sender);
    }

    function _ADDOPERATOR101(address account) internal {	//inject NONSTANDARD NAMING
        _operators.ADD825(account);
        emit OPERATORADDED875(account);
    }

    function _REMOVEOPERATOR451(address account) internal {	//inject NONSTANDARD NAMING
        _operators.REMOVE879(account);
        emit OPERATORREMOVED255(account);
    }
}

// File: ico-maker/contracts/token/ERC20/BaseERC20Token.sol

                                                                                                                                             
contract BaseERC20Token is ERC20Detailed, ERC20Capped, ERC20Burnable, OperatorRole, TokenRecover {

    event MINTFINISHED767();	//inject NONSTANDARD NAMING
    event TRANSFERENABLED385();	//inject NONSTANDARD NAMING

    // indicates if minting is finished
    bool private _mintingFinished = false;

    // indicates if transfer is enabled
    bool private _transferEnabled = false;

                                                                              
    modifier CANMINT798() {	//inject NONSTANDARD NAMING
        require(!_mintingFinished);
        _;
    }

                                                                                                                  
    modifier CANTRANSFER140(address from) {	//inject NONSTANDARD NAMING
        require(_transferEnabled || ISOPERATOR640(from));
        _;
    }

                                                                                                                                                                                                                                                                                                                                 
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 cap,
        uint256 initialSupply
    )
        public
        ERC20Detailed(name, symbol, decimals)
        ERC20Capped(cap)
    {
        if (initialSupply > 0) {
            _MINT126(OWNER790(), initialSupply);
        }
    }

                                                             
    function MINTINGFINISHED780() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _mintingFinished;
    }

                                                             
    function TRANSFERENABLED7() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _transferEnabled;
    }

                                                                                                                                                                                                                                                
    function MINT699(address to, uint256 value) public CANMINT798 returns (bool) {	//inject NONSTANDARD NAMING
        return super.MINT699(to, value);
    }

                                                                                                                                                                                                                                         
    function TRANSFER72(address to, uint256 value) public CANTRANSFER140(msg.sender) returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFER72(to, value);
    }

                                                                                                                                                                                                                                                                                                                                                                 
    function TRANSFERFROM346(address from, address to, uint256 value) public CANTRANSFER140(from) returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFERFROM346(from, to, value);
    }

                                                                                    
    function FINISHMINTING211() public ONLYOWNER785 CANMINT798 {	//inject NONSTANDARD NAMING
        _mintingFinished = true;

        emit MINTFINISHED767();
    }

                                                     
    function ENABLETRANSFER141() public ONLYOWNER785 {	//inject NONSTANDARD NAMING
        _transferEnabled = true;

        emit TRANSFERENABLED385();
    }

                                                                                                                         
    function REMOVEOPERATOR532(address account) public ONLYOWNER785 {	//inject NONSTANDARD NAMING
        _REMOVEOPERATOR451(account);
    }

                                                                                                                       
    function REMOVEMINTER389(address account) public ONLYOWNER785 {	//inject NONSTANDARD NAMING
        _REMOVEMINTER969(account);
    }
}

// File: contracts/ERC20Token.sol

                                                                                                                                       
contract ERC20Token is BaseERC20Token {

    string public builtOn = "https://vittominacori.github.io/erc20-generator";

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 cap,
        uint256 initialSupply
    )
        public
        BaseERC20Token(name, symbol, decimals, cap, initialSupply)
    {} // solhint-disable-line no-empty-blocks
}