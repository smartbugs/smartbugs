                                                                 

pragma solidity >=0.5.1 <0.6.0;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD122(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB352(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB352(a, b, "SafeMath: subtraction overflow");
    }

                                                                                                                                                                                                                                                                                     
    function SUB352(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL357(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV343(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV343(a, b, "SafeMath: division by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    function DIV343(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD732(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD732(a, b, "SafeMath: modulo by zero");
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
    function MOD732(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY248() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF857(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER214(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE396(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function APPROVE354(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM830(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER185(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL37(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                            
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;

    mapping (address => mapping (address => uint256)) internal _allowances;

    uint256 internal _totalSupply;

                                                     
    function TOTALSUPPLY248() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF857(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER214(address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER614(msg.sender, recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE396(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE354(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE823(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function TRANSFERFROM830(address sender, address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER614(sender, recipient, amount);
        _APPROVE823(sender, msg.sender, _allowances[sender][msg.sender].SUB352(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE979(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE823(msg.sender, spender, _allowances[msg.sender][spender].ADD122(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE927(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE823(msg.sender, spender, _allowances[msg.sender][spender].SUB352(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER614(address sender, address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB352(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD122(amount);
        emit TRANSFER185(sender, recipient, amount);
    }

                                                                                                 
    function _APPROVE823(address owner, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit APPROVAL37(owner, spender, value);
    }
}

contract Ownable {
    address public owner;

    event OWNERSHIPTRANSFERRED935(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                 
    modifier ONLYOWNER958() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner, "Ownable: the caller must be owner");
        _;
    }

                                                                                                                                                                     
    function TRANSFEROWNERSHIP243(address _newOwner) public ONLYOWNER958 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP494(_newOwner);
    }

                                                                                                                                          
    function _TRANSFEROWNERSHIP494(address _newOwner) internal {	//inject NONSTANDARD NAMING
        require(_newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED935(owner, _newOwner);
        owner = _newOwner;
    }
}

                                                                                                                                                 
contract Pausable is Ownable {
                                                                                        
    event PAUSED448(address account);	//inject NONSTANDARD NAMING

                                                                                     
    event UNPAUSED824(address account);	//inject NONSTANDARD NAMING

    bool private _paused;

                                                                                                                      
    constructor () internal {
        _paused = false;
    }

                                                                                       
    function PAUSED579() public view returns (bool) {	//inject NONSTANDARD NAMING
        return _paused;
    }

                                                                                                      
    modifier WHENNOTPAUSED693() {	//inject NONSTANDARD NAMING
        require(!_paused, "Pausable: paused");
        _;
    }

                                                                                                  
    modifier WHENPAUSED355() {	//inject NONSTANDARD NAMING
        require(_paused, "Pausable: not paused");
        _;
    }

                                                                                
    function PAUSE603() public ONLYOWNER958 WHENNOTPAUSED693 {	//inject NONSTANDARD NAMING
        _paused = true;
        emit PAUSED448(msg.sender);
    }

                                                                                   
    function UNPAUSE5() public ONLYOWNER958 WHENPAUSED355 {	//inject NONSTANDARD NAMING
        _paused = false;
        emit UNPAUSED824(msg.sender);
    }
}

                                                                                
contract ERC20Pausable is ERC20, Pausable {
    function TRANSFER214(address to, uint256 value) public WHENNOTPAUSED693 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFER214(to, value);
    }

    function TRANSFERFROM830(address from, address to, uint256 value) public WHENNOTPAUSED693 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFERFROM830(from, to, value);
    }

    function APPROVE354(address spender, uint256 value) public WHENNOTPAUSED693 returns (bool) {	//inject NONSTANDARD NAMING
        return super.APPROVE354(spender, value);
    }

    function INCREASEALLOWANCE979(address spender, uint addedValue) public WHENNOTPAUSED693 returns (bool) {	//inject NONSTANDARD NAMING
        return super.INCREASEALLOWANCE979(spender, addedValue);
    }

    function DECREASEALLOWANCE927(address spender, uint subtractedValue) public WHENNOTPAUSED693 returns (bool) {	//inject NONSTANDARD NAMING
        return super.DECREASEALLOWANCE927(spender, subtractedValue);
    }
}

contract ProtossToken is ERC20Pausable {
    
    string public constant name821 = "Protoss";	//inject NONSTANDARD NAMING
    string public constant symbol856 = "PRC";	//inject NONSTANDARD NAMING
    uint8 public constant decimals764 = 18;	//inject NONSTANDARD NAMING
    uint256 internal constant init_totalsupply916 = 1000000000 ether;	//inject NONSTANDARD NAMING

                                        
    constructor () public {
        owner = address(0xc99D13544297d5baD9e0b0Ca0E94A4E614312F33);
        _totalSupply = init_totalsupply916;
        _balances[owner] = _totalSupply;
        emit TRANSFER185(address(0), owner, _totalSupply);
    }
}