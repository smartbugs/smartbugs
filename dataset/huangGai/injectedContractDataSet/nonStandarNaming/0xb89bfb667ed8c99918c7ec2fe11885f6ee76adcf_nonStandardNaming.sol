                                                                 

pragma solidity ^0.5.2;

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

                                                                                   
interface IERC20 {
    function TRANSFER40(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE301(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM794(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TOTALSUPPLY553() external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF929(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE927(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    event TRANSFER76(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    event APPROVAL126(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.2;

                                                                                                   
library SafeMath {
                                                                                  
    function MUL714(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                           
    function DIV136(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                              
    function SUB719(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                            
    function ADD820(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                    
    function MOD689(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.5.2;

                                                                                                                                                                                                                                                                                                                                                                                                                            
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

                                                               
    function TOTALSUPPLY553() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                                                                                                                                                                             
    function BALANCEOF929(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[owner];
    }

                                                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE927(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowed[owner][spender];
    }

                                                                                                                                                                
    function TRANSFER40(address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER980(msg.sender, to, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE301(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE717(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function TRANSFERFROM794(address from, address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER980(from, to, value);
        _APPROVE717(from, msg.sender, _allowed[from][msg.sender].SUB719(value));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
    function INCREASEALLOWANCE41(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE717(msg.sender, spender, _allowed[msg.sender][spender].ADD820(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE194(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE717(msg.sender, spender, _allowed[msg.sender][spender].SUB719(subtractedValue));
        return true;
    }

                                                                                                                                                                                                                    
    function _TRANSFER980(address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(to != address(0));

        _balances[from] = _balances[from].SUB719(value);
        _balances[to] = _balances[to].ADD820(value);
        emit TRANSFER76(from, to, value);
    }

                                                                                                                                                                                                                                                                                                                                                
    function _MINT201(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.ADD820(value);
        _balances[account] = _balances[account].ADD820(value);
        emit TRANSFER76(address(0), account, value);
    }

                                                                                                                                                                                                                           
    function _BURN23(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.SUB719(value);
        _balances[account] = _balances[account].SUB719(value);
        emit TRANSFER76(account, address(0), value);
    }

                                                                                                                                                                                                                                                                  
    function _APPROVE717(address owner, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit APPROVAL126(owner, spender, value);
    }

                                                                                                                                                                                                                                                                                                                                                                                              
    function _BURNFROM444(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        _BURN23(account, value);
        _APPROVE717(account, msg.sender, _allowed[account][msg.sender].SUB719(value));
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.5.2;


                                                                                                                                                                                                                                        
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

                                                     
    function NAME174() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                       
    function SYMBOL647() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                   
    function DECIMALS617() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol

pragma solidity ^0.5.2;


                                                                                           
contract ERC20Burnable is ERC20 {
                                                                                                                    
    function BURN273(uint256 value) public {	//inject NONSTANDARD NAMING
        _BURN23(msg.sender, value);
    }

                                                                                                                                                                                                                                                
    function BURNFROM876(address from, uint256 value) public {	//inject NONSTANDARD NAMING
        _BURNFROM444(from, value);
    }
}

// File: contracts/BNS.sol

pragma solidity ^0.5.0;

contract BNS is ERC20, ERC20Detailed, ERC20Burnable {
    constructor() ERC20Detailed('BNS Token', 'BNS', 8) public {
        _MINT201(msg.sender, 2_500_000_000 * 10 ** 8);
    }
}