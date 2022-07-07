                                                                 

pragma solidity 0.5.11;

                                                                                         
library SafeMath {
    function MUL499(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function DIV181(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function SUB558(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        assert(b <= a);
        return a - b;
    }

    function ADD491(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

                                                                                                                                                                                             
contract Ownable {
    address public owner;


    event OWNERSHIPTRANSFERRED470(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING


                                                                                                                        
    constructor() public {
        owner = msg.sender;
    }

                                                                               
    modifier ONLYOWNER617() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }

                                                                                                                                                                 
    function TRANSFEROWNERSHIP534(address newOwner) public ONLYOWNER617 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0));
        emit OWNERSHIPTRANSFERRED470(owner, newOwner);
        owner = newOwner;
    }
}

                            
contract ERC20Basic {
    uint256 public totalSupply;
    function BALANCEOF515(address who) public view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER781(address to, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER945(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                        
contract ERC20 is ERC20Basic {
    function ALLOWANCE104(address owner, address spender) public view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFERFROM476(address from, address to, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE925(address spender, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING
    event APPROVAL128(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

                                                                                          
contract BasicToken is ERC20Basic, Ownable {

    using SafeMath for uint256;

    mapping(address => uint256) balances;

                                                                                                                                                               
    function TRANSFER781(address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= BALANCEOF515(msg.sender));

        // SafeMath.sub will throw if there is not enough balance.
        balances[msg.sender] = balances[msg.sender].SUB558(_value);
        balances[_to] = balances[_to].ADD491(_value);
        emit TRANSFER945(msg.sender, _to, _value);
        return true;
    }

                                                                                                                                                                                                                
    function BALANCEOF515(address _owner) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING
        return balances[_owner];
    }
    
}


                                                                                                                                                                                                                                                                          
contract StandardToken is ERC20, BasicToken {

    mapping (address => mapping (address => uint256)) allowed;

                                                                                                                                                                                                                                                                                     
    function TRANSFERFROM476(address _from, address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(allowed[_from][msg.sender] >= _value);
        require(BALANCEOF515(_from) >= _value);
        require(balances[_to].ADD491(_value) > balances[_to]); // Check for overflows
        balances[_from] = balances[_from].SUB558(_value);
        balances[_to] = balances[_to].ADD491(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB558(_value);
        emit TRANSFER945(_from, _to, _value);
        return true;
    }

                                                                                                                                                                                                                                         
    function APPROVE925(address _spender, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require((_value == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL128(msg.sender, _spender, _value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                 
    function ALLOWANCE104(address _owner, address _spender) public view returns (uint256 remaining) {	//inject NONSTANDARD NAMING
        return allowed[_owner][_spender];
    }

                                                                                                                                                                                                                                                   
    function INCREASEAPPROVAL746 (address _spender, uint _addedValue) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].ADD491(_addedValue);
        emit APPROVAL128(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function DECREASEAPPROVAL212 (address _spender, uint _subtractedValue) public returns (bool success) {	//inject NONSTANDARD NAMING
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.SUB558(_subtractedValue);
        }
        emit APPROVAL128(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}


                                                                                                                
contract Pausable is StandardToken {
    event PAUSE436();	//inject NONSTANDARD NAMING
    event UNPAUSE446();	//inject NONSTANDARD NAMING

    bool public paused = false;

    address public founder;
    
                                                                                    
    modifier WHENNOTPAUSED442() {	//inject NONSTANDARD NAMING
        require(!paused || msg.sender == founder);
        _;
    }

                                                                                        
    modifier WHENPAUSED201() {	//inject NONSTANDARD NAMING
        require(paused);
        _;
    }

                                                                              
    function PAUSE713() public ONLYOWNER617 WHENNOTPAUSED442 {	//inject NONSTANDARD NAMING
        paused = true;
        emit PAUSE436();
    }

                                                                                 
    function UNPAUSE439() public ONLYOWNER617 WHENPAUSED201 {	//inject NONSTANDARD NAMING
        paused = false;
        emit UNPAUSE446();
    }
}


contract PausableToken is Pausable {

    function TRANSFER781(address _to, uint256 _value) public WHENNOTPAUSED442 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFER781(_to, _value);
    }

    function TRANSFERFROM476(address _from, address _to, uint256 _value) public WHENNOTPAUSED442 returns (bool) {	//inject NONSTANDARD NAMING
        return super.TRANSFERFROM476(_from, _to, _value);
    }

    //The functions below surve no real purpose. Even if one were to approve another to spend
    //tokens on their behalf, those tokens will still only be transferable when the token contract
    //is not paused.

    function APPROVE925(address _spender, uint256 _value) public WHENNOTPAUSED442 returns (bool) {	//inject NONSTANDARD NAMING
        return super.APPROVE925(_spender, _value);
    }

    function INCREASEAPPROVAL746(address _spender, uint _addedValue) public WHENNOTPAUSED442 returns (bool success) {	//inject NONSTANDARD NAMING
        return super.INCREASEAPPROVAL746(_spender, _addedValue);
    }

    function DECREASEAPPROVAL212(address _spender, uint _subtractedValue) public WHENNOTPAUSED442 returns (bool success) {	//inject NONSTANDARD NAMING
        return super.DECREASEAPPROVAL212(_spender, _subtractedValue);
    }
}

contract STT is PausableToken {

    string public name;
    string public symbol;
    uint8 public decimals;

                                                                                        
    constructor() public {
        name = "Secure Transaction Token";
        symbol = "STT";
        decimals = 18;
        totalSupply = 500000000*1000000000000000000;
        
        founder = msg.sender;

        balances[msg.sender] = totalSupply;
        emit TRANSFER945(address(0), msg.sender, totalSupply);
    }
    
                                                                                                                                                                                
    event TOKENFREEZEEVENT773(address indexed _owner, uint256 amount);	//inject NONSTANDARD NAMING

                                                                                                                                                                                      
    event TOKENUNFREEZEEVENT259(address indexed _owner, uint256 amount);	//inject NONSTANDARD NAMING
    event TOKENSBURNED508(address indexed _owner, uint256 _tokens);	//inject NONSTANDARD NAMING

    
    mapping(address => uint256) internal frozenTokenBalances;

    function FREEZETOKENS581(address _owner, uint256 _value) public ONLYOWNER617 {	//inject NONSTANDARD NAMING
        require(_value <= BALANCEOF515(_owner));
        uint256 oldFrozenBalance = GETFROZENBALANCE695(_owner);
        uint256 newFrozenBalance = oldFrozenBalance.ADD491(_value);
        SETFROZENBALANCE498(_owner,newFrozenBalance);
        emit TOKENFREEZEEVENT773(_owner,_value);
    }
    
    function UNFREEZETOKENS565(address _owner, uint256 _value) public ONLYOWNER617 {	//inject NONSTANDARD NAMING
        require(_value <= GETFROZENBALANCE695(_owner));
        uint256 oldFrozenBalance = GETFROZENBALANCE695(_owner);
        uint256 newFrozenBalance = oldFrozenBalance.SUB558(_value);
        SETFROZENBALANCE498(_owner,newFrozenBalance);
        emit TOKENUNFREEZEEVENT259(_owner,_value);
    }
    
    
    function SETFROZENBALANCE498(address _owner, uint256 _newValue) internal {	//inject NONSTANDARD NAMING
        frozenTokenBalances[_owner]=_newValue;
    }

    function BALANCEOF515(address _owner) view public returns(uint256)  {	//inject NONSTANDARD NAMING
        return GETTOTALBALANCE318(_owner).SUB558(GETFROZENBALANCE695(_owner));
    }

    function GETTOTALBALANCE318(address _owner) view public returns(uint256) {	//inject NONSTANDARD NAMING
        return balances[_owner];   
    }
                                                                                                                                                                                                                                                                            

    function GETFROZENBALANCE695(address _owner) view public returns(uint256) {	//inject NONSTANDARD NAMING
        return frozenTokenBalances[_owner];   
    }
    
                                                                                                  
    function BURNTOKENS269(uint256 _tokens) public ONLYOWNER617 {	//inject NONSTANDARD NAMING
        require(BALANCEOF515(msg.sender) >= _tokens);
        balances[msg.sender] = balances[msg.sender].SUB558(_tokens);
        totalSupply = totalSupply.SUB558(_tokens);
        emit TOKENSBURNED508(msg.sender, _tokens);
    }
    function DESTROY903(address payable _benefitiary) external ONLYOWNER617{	//inject NONSTANDARD NAMING
        selfdestruct(_benefitiary);
    }
}