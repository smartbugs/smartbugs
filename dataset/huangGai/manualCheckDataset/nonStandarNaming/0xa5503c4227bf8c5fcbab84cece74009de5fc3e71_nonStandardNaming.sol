pragma solidity ^0.5.2;


                                                                                                   
library SafeMath {
                                                                                  
    function MUL803(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                           
    function DIV739(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                              
    function SUB240(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                            
    function ADD649(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                    
    function MOD521(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}

                                                                                        
interface IERC20 {
    function TRANSFER940(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE773(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM406(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TOTALSUPPLY323() external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF593(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE869(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    event TRANSFER104(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    event APPROVAL145(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                                                                                                                                                                        
 
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

                                                     
    function NAME604() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                       
    function SYMBOL119() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                   
    function DECIMALS999() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

                                                               
    function TOTALSUPPLY323() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                                                                                                                                                                              
    function BALANCEOF593(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[owner];
    }

                                                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE869(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowed[owner][spender];
    }

                                                                                                                                                                 
    function TRANSFER940(address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER651(msg.sender, to, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE773(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE103(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function TRANSFERFROM406(address from, address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER651(from, to, value);
        _APPROVE103(from, msg.sender, _allowed[from][msg.sender].SUB240(value));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function INCREASEALLOWANCE839(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE103(msg.sender, spender, _allowed[msg.sender][spender].ADD649(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function DECREASEALLOWANCE280(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE103(msg.sender, spender, _allowed[msg.sender][spender].SUB240(subtractedValue));
        return true;
    }

                                                                                                                                                                                                                    
    function _TRANSFER651(address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(to != address(0));

        _balances[from] = _balances[from].SUB240(value);
        _balances[to] = _balances[to].ADD649(value);
        emit TRANSFER104(from, to, value);
    }

                                                                                                                                                                                                                                                                                                                                                
    function _MINT410(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.ADD649(value);
        _balances[account] = _balances[account].ADD649(value);
        emit TRANSFER104(address(0), account, value);
    }

                                                                                                                                                                                                                           
    function _BURN498(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.SUB240(value);
        _balances[account] = _balances[account].SUB240(value);
        emit TRANSFER104(account, address(0), value);
    }

                                                                                                                                                                                                                                                                  
    function _APPROVE103(address owner, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit APPROVAL145(owner, spender, value);
    }

                                                                                                                                                                                                                                                                                                                                                                                              
    function _BURNFROM661(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        _BURN498(account, value);
        _APPROVE103(account, msg.sender, _allowed[account][msg.sender].SUB240(value));
    }
}
                                                                                                                                                                                                              
contract EXCHANGE is ERC20, ERC20Detailed {
    uint256 public constant initial_supply735 = 500000000000 * (10 ** 18);	//inject NONSTANDARD NAMING

                                                                                     
    constructor () public ERC20Detailed("Safuracoin", "EXCHANGE", 8) {
        _MINT410(msg.sender, initial_supply735);
    }
}