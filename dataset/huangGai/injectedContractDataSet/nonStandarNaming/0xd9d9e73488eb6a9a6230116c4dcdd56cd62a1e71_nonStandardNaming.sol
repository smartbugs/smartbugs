                                                                 

pragma solidity ^0.5.1;

interface ERC20 {
    function BALANCEOF566(address _owner) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ALLOWANCE834(address _owner, address _spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER74(address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM526(address _from, address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE430(address _spender, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER299(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL61(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
    function MUL587(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function DIV670(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a / b;
        return c;
    }

    function SUB239(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        assert(b <= a);
        return a - b;
    }

    function ADD495(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract qmpcapital_token is ERC20 {
    using SafeMath for uint256;
    address private deployer;
    string public name = "QMP.capital";
    string public symbol = "QMP";
    uint8 public constant decimals102 = 18;	//inject NONSTANDARD NAMING
    uint256 public constant decimalfactor497 = 10 ** uint256(decimals102);	//inject NONSTANDARD NAMING
    uint256 public constant totalsupply142 = 120000 * decimalfactor497;	//inject NONSTANDARD NAMING
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    event TRANSFER299(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL61(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

    constructor() public {
        balances[msg.sender] = totalsupply142;
        deployer = msg.sender;
        emit TRANSFER299(address(0), msg.sender, totalsupply142);
    }

    function BALANCEOF566(address _owner) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING
        return balances[_owner];
    }

    function ALLOWANCE834(address _owner, address _spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return allowed[_owner][_spender];
    }

    function TRANSFER74(address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[msg.sender] = balances[msg.sender].SUB239(_value);
        balances[_to] = balances[_to].ADD495(_value);
        emit TRANSFER299(msg.sender, _to, _value);
        return true;
    }

    function TRANSFERFROM526(address _from, address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[_from] = balances[_from].SUB239(_value);
        balances[_to] = balances[_to].ADD495(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB239(_value);
        emit TRANSFER299(_from, _to, _value);
        return true;
    }

    function APPROVE430(address _spender, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL61(msg.sender, _spender, _value);
        return true;
    }

    function INCREASEAPPROVAL512(address _spender, uint _addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].ADD495(_addedValue);
        emit APPROVAL61(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function DECREASEAPPROVAL554(address _spender, uint _subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.SUB239(_subtractedValue);
        }
        emit APPROVAL61(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}