                                                                 

pragma solidity ^0.5.1;

interface ERC20 {
    function BALANCEOF862(address _owner) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ALLOWANCE87(address _owner, address _spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER774(address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM695(address _from, address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE957(address _spender, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER917(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL215(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
    function MUL251(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function DIV241(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a / b;
        return c;
    }

    function SUB234(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        assert(b <= a);
        return a - b;
    }

    function ADD300(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract mixi is ERC20 {
    using SafeMath for uint256;
    address private deployer;
    string public name = "mixi.network";
    string public symbol = "MIXI";
    uint8 public constant decimals537 = 18;	//inject NONSTANDARD NAMING
    uint256 public constant decimalfactor998 = 10 ** uint256(decimals537);	//inject NONSTANDARD NAMING
    uint256 public constant totalsupply82 = 1000 * decimalfactor998;	//inject NONSTANDARD NAMING
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    event TRANSFER917(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL215(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

    constructor() public {
        balances[msg.sender] = totalsupply82;
        deployer = msg.sender;
        emit TRANSFER917(address(0), msg.sender, totalsupply82);
    }

    function BALANCEOF862(address _owner) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING
        return balances[_owner];
    }

    function ALLOWANCE87(address _owner, address _spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return allowed[_owner][_spender];
    }

    function TRANSFER774(address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[msg.sender] = balances[msg.sender].SUB234(_value);
        balances[_to] = balances[_to].ADD300(_value);
        emit TRANSFER917(msg.sender, _to, _value);
        return true;
    }

    function TRANSFERFROM695(address _from, address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[_from] = balances[_from].SUB234(_value);
        balances[_to] = balances[_to].ADD300(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB234(_value);
        emit TRANSFER917(_from, _to, _value);
        return true;
    }

    function APPROVE957(address _spender, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL215(msg.sender, _spender, _value);
        return true;
    }

    function INCREASEAPPROVAL802(address _spender, uint _addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].ADD300(_addedValue);
        emit APPROVAL215(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function DECREASEAPPROVAL663(address _spender, uint _subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.SUB234(_subtractedValue);
        }
        emit APPROVAL215(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}