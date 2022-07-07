pragma solidity ^0.5.4;

interface IERC20 {
    function TRANSFER49(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE389(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM997(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TOTALSUPPLY768() external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF449(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE666(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    event TRANSFER931(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    event APPROVAL14(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
                                                                                
    function MUL769(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                         
    function DIV819(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                            
    function SUB766(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                          
    function ADD744(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                 
    function MOD580(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}

contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

                                                             
    function TOTALSUPPLY768() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                                                                                                                                                                          
    function BALANCEOF449(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[owner];
    }

                                                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE666(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowed[owner][spender];
    }

                                                                                                                                                             
    function TRANSFER49(address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER421(msg.sender, to, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE389(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit APPROVAL14(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function TRANSFERFROM997(address from, address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _allowed[from][msg.sender] = _allowed[from][msg.sender].SUB766(value);
        _TRANSFER421(from, to, value);
        emit APPROVAL14(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function INCREASEALLOWANCE401(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].ADD744(addedValue);
        emit APPROVAL14(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function DECREASEALLOWANCE107(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].SUB766(subtractedValue);
        emit APPROVAL14(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

                                                                                                                                                                                                               
    function _TRANSFER421(address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(to != address(0));

        _balances[from] = _balances[from].SUB766(value);
        _balances[to] = _balances[to].ADD744(value);
        emit TRANSFER931(from, to, value);
    }

                                                                                                                                                                                                                                                                                                                                                
    function _MINT831(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.ADD744(value);
        _balances[account] = _balances[account].ADD744(value);
        emit TRANSFER931(address(0), account, value);
    }

                                                                                                                                                                                                                           
    function _BURN902(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.SUB766(value);
        _balances[account] = _balances[account].SUB766(value);
        emit TRANSFER931(account, address(0), value);
    }

                                                                                                                                                                                                                                                                                                                                                                                              
    function _BURNFROM377(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        _allowed[account][msg.sender] = _allowed[account][msg.sender].SUB766(value);
        _BURN902(account, value);
        emit APPROVAL14(account, msg.sender, _allowed[account][msg.sender]);
    }
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

                                                     
    function NAME89() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                       
    function SYMBOL199() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                   
    function DECIMALS428() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

contract Ownable {
    address private _owner;

    event OWNERSHIPTRANSFERRED633(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                                                           
    constructor () internal {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED633(address(0), _owner);
    }

                                                        
    function OWNER390() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER452() {	//inject NONSTANDARD NAMING
        require(ISOWNER539());
        _;
    }

                                                                                 
    function ISOWNER539() public view returns (bool) {	//inject NONSTANDARD NAMING
        return msg.sender == _owner;
    }

                                                                                                                                                                                                                                                                               
    function RENOUNCEOWNERSHIP357() public ONLYOWNER452 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED633(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                                                    
    function TRANSFEROWNERSHIP550(address newOwner) public ONLYOWNER452 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP911(newOwner);
    }

                                                                                                                                         
    function _TRANSFEROWNERSHIP911(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        emit OWNERSHIPTRANSFERRED633(_owner, newOwner);
        _owner = newOwner;
    }
}

contract ICEbergT is ERC20Detailed, ERC20, Ownable {

    using SafeMath for uint256;

    constructor(address _tokenHolder)
        public
        ERC20Detailed("ICEbergT", "ICEBT", 18)
    {
        _MINT831(_tokenHolder, 500000000000000000000000);
    }
    
                                                                                                                                                                                                                                                                      
    function MINT143( uint256 value ) public ONLYOWNER452  {	//inject NONSTANDARD NAMING
        _MINT831( OWNER390() , value );
    }
}