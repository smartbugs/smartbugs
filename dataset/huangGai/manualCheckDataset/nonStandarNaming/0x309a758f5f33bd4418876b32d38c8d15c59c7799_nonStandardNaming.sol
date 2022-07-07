pragma solidity ^0.5.2;

                                                                                                   
library SafeMath {
                                                                                
    function MUL162(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                         
    function DIV641(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                            
    function SUB622(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

                                                                          
    function ADD574(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

                                                                                                                                                 
    function MOD960(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0);
        return a % b;
    }
}



                                                                                        
interface IERC20 {
    function TRANSFER171(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE729(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM43(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING

    function TOTALSUPPLY1000() external view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF11(address who) external view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE189(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

    event TRANSFER893(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

    event APPROVAL326(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}



                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

                                                             
    function TOTALSUPPLY1000() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                                                                                                                                                                          
    function BALANCEOF11(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[owner];
    }

                                                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE189(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowed[owner][spender];
    }

                                                                                                                                                             
    function TRANSFER171(address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER88(msg.sender, to, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE729(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE787(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function TRANSFERFROM43(address from, address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER88(from, to, value);
        _APPROVE787(from, msg.sender, _allowed[from][msg.sender].SUB622(value));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function INCREASEALLOWANCE340(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE787(msg.sender, spender, _allowed[msg.sender][spender].ADD574(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function DECREASEALLOWANCE920(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE787(msg.sender, spender, _allowed[msg.sender][spender].SUB622(subtractedValue));
        return true;
    }

                                                                                                                                                                                                               
    function _TRANSFER88(address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(to != address(0));

        _balances[from] = _balances[from].SUB622(value);
        _balances[to] = _balances[to].ADD574(value);
        emit TRANSFER893(from, to, value);
    }

                                                                                                                                                                                                                                                                                                                                                
    function _MINT877(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.ADD574(value);
        _balances[account] = _balances[account].ADD574(value);
        emit TRANSFER893(address(0), account, value);
    }

                                                                                                                                                                                                                           
    function _BURN466(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0));

        _totalSupply = _totalSupply.SUB622(value);
        _balances[account] = _balances[account].SUB622(value);
        emit TRANSFER893(account, address(0), value);
    }

                                                                                                                                                                                                                                                                  
    function _APPROVE787(address owner, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(spender != address(0));
        require(owner != address(0));

        _allowed[owner][spender] = value;
        emit APPROVAL326(owner, spender, value);
    }

                                                                                                                                                                                                                                                                                                                                                                                              
    function _BURNFROM510(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        _BURN466(account, value);
        _APPROVE787(account, msg.sender, _allowed[account][msg.sender].SUB622(value));
    }
}



                                                                                                                                                                                                                
contract Controller {
    
    address private _owner;
    bool private _paused;
    
    event OWNERSHIPTRANSFERRED948(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING
    event PAUSED527(address account);	//inject NONSTANDARD NAMING
    event UNPAUSED105(address account);	//inject NONSTANDARD NAMING
    
    mapping(address => bool) private owners;
    
                                                                                                                                                          
    constructor() internal {
        SETOWNER969(msg.sender);
    }

                                                                               
    modifier ONLYOWNER408() {	//inject NONSTANDARD NAMING
        require(owners[msg.sender]);
        _;
    }

    function SETOWNER969(address addr) internal returns(bool) {	//inject NONSTANDARD NAMING
        if (!owners[addr]) {
          owners[addr] = true;
          _owner = addr;
          return true; 
        }
    }

                                                                                                                                                                    
    function CHANGEOWNER929(address newOwner) ONLYOWNER408 public returns(bool) {	//inject NONSTANDARD NAMING
        require (!owners[newOwner]);
          owners[newOwner];
          _owner = newOwner;
          emit OWNERSHIPTRANSFERRED948(_owner, newOwner);
          return true; 
        }

                                                      
    function OWNER670() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }
    
                                                                             
    function PAUSED195() public view returns(bool) {	//inject NONSTANDARD NAMING
    return _paused;
    }
    
                                                                                                    
    modifier WHENNOTPAUSED721() {	//inject NONSTANDARD NAMING
    require(!_paused);
    _;
    }
    
                                                                                                
    modifier WHENPAUSED463() {	//inject NONSTANDARD NAMING
    require(_paused);
    _;
    }
    
                                                                              
    function PAUSE136() public ONLYOWNER408 WHENNOTPAUSED721 {	//inject NONSTANDARD NAMING
    _paused = true;
    emit PAUSED527(msg.sender);
    }
    
                                                                                 
    function UNPAUSE780() public ONLYOWNER408 WHENPAUSED463 {	//inject NONSTANDARD NAMING
    _paused = false;
    emit UNPAUSED105(msg.sender);
    }
    
}



                                                                                                                                                                                                                                      
contract LobefyToken is ERC20, Controller {
    
    using SafeMath for uint256;
    
    string private _name = "Lobefy Token";
    string private _symbol = "CRWD";
    uint256 private _decimals = 18;
    
    address private team = 0xDA19316953D19f5f8C6361d68C6D0078c06285d3;
    uint256 private team1Balance = 50 * (10 ** 6) * (10 ** 18);
    
    
    constructor() public {
        MINT940(team, team1Balance);
    }

                                                     
    function NAME85() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }

                                                       
    function SYMBOL530() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }

                                                                   
    function DECIMALS786() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
    
                                                                                                                    
    function BURN283(uint256 value) public {	//inject NONSTANDARD NAMING
        _BURN466(msg.sender, value);
    }

                                                                                                                                                                                                                                                     
    function BURNFROM445(address from, uint256 value) public {	//inject NONSTANDARD NAMING
        _BURNFROM510(from, value);
    }
    
                                                                                                                                                                                                                                                
    function MINT940(address to, uint256 value) public ONLYOWNER408 returns (bool) {	//inject NONSTANDARD NAMING
        _MINT877(to, value);
        return true;
    }
    
    function TRANSFER171(address to, uint256 value) public WHENNOTPAUSED721 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFER171(to, value);
    }

    function TRANSFERFROM43(address from, address to, uint256 value) public WHENNOTPAUSED721 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFERFROM43(from, to, value);
    }

    function APPROVE729(address spender, uint256 value) public WHENNOTPAUSED721 returns (bool) {	//inject NONSTANDARD NAMING
        return super.APPROVE729(spender, value);
    }

    function INCREASEALLOWANCE340(address spender, uint addedValue) public WHENNOTPAUSED721 returns (bool success) {	//inject NONSTANDARD NAMING
        return super.INCREASEALLOWANCE340(spender, addedValue);
    }

    function DECREASEALLOWANCE920(address spender, uint subtractedValue) public WHENNOTPAUSED721 returns (bool success) {	//inject NONSTANDARD NAMING
        return super.DECREASEALLOWANCE920(spender, subtractedValue);
    }
}