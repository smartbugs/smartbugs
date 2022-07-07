                                                                 

pragma solidity ^0.5.1;

interface ERC20 {
    function BALANCEOF609(address _owner) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ALLOWANCE290(address _owner, address _spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER961(address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM912(address _from, address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE95(address _spender, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER903(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL958(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
    function MUL226(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function DIV693(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a / b;
        return c;
    }

    function SUB333(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        assert(b <= a);
        return a - b;
    }

    function ADD836(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract horizex is ERC20 {
    using SafeMath for uint256;
    address private deployer;
    string public name = "horizex.ltd";
    string public symbol = "HRX";
    uint8 public constant decimals428 = 18;	//inject NONSTANDARD NAMING
    uint256 public constant decimalfactor43 = 10 ** uint256(decimals428);	//inject NONSTANDARD NAMING
    uint256 public constant totalsupply53 = 8000 * decimalfactor43;	//inject NONSTANDARD NAMING
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    event TRANSFER903(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL958(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

    constructor() public {
        balances[msg.sender] = totalsupply53;
        deployer = msg.sender;
        emit TRANSFER903(address(0), msg.sender, totalsupply53);
    }

    function BALANCEOF609(address _owner) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING
        return balances[_owner];
    }

    function ALLOWANCE290(address _owner, address _spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return allowed[_owner][_spender];
    }

    function TRANSFER961(address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[msg.sender] = balances[msg.sender].SUB333(_value);
        balances[_to] = balances[_to].ADD836(_value);
        emit TRANSFER903(msg.sender, _to, _value);
        return true;
    }

    function TRANSFERFROM912(address _from, address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[_from] = balances[_from].SUB333(_value);
        balances[_to] = balances[_to].ADD836(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB333(_value);
        emit TRANSFER903(_from, _to, _value);
        return true;
    }

    function APPROVE95(address _spender, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL958(msg.sender, _spender, _value);
        return true;
    }

    function INCREASEAPPROVAL279(address _spender, uint _addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].ADD836(_addedValue);
        emit APPROVAL958(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function DECREASEAPPROVAL731(address _spender, uint _subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.SUB333(_subtractedValue);
        }
        emit APPROVAL958(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}