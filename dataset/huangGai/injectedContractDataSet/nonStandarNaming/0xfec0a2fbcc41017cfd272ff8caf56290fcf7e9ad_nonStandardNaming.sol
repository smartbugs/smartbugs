                                                                 

pragma solidity ^0.5.1;

interface ERC20 {
    function BALANCEOF565(address _owner) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ALLOWANCE851(address _owner, address _spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER334(address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM87(address _from, address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE782(address _spender, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER933(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL210(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
    function MUL1000(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function DIV822(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a / b;
        return c;
    }

    function SUB660(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        assert(b <= a);
        return a - b;
    }

    function ADD287(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract RIX is ERC20 {
    using SafeMath for uint256;
    address private deployer;
    string public name = "rix.finance";
    string public symbol = "RIXF";
    uint8 public constant decimals308 = 2;	//inject NONSTANDARD NAMING
    uint256 public constant decimalfactor692 = 10 ** uint256(decimals308);	//inject NONSTANDARD NAMING
    uint256 public constant totalsupply945 = 1500 * decimalfactor692;	//inject NONSTANDARD NAMING
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    event TRANSFER933(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL210(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

    constructor() public {
        balances[msg.sender] = totalsupply945;
        deployer = msg.sender;
        emit TRANSFER933(address(0), msg.sender, totalsupply945);
    }

    function BALANCEOF565(address _owner) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING
        return balances[_owner];
    }

    function ALLOWANCE851(address _owner, address _spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return allowed[_owner][_spender];
    }

    function TRANSFER334(address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[msg.sender] = balances[msg.sender].SUB660(_value);
        balances[_to] = balances[_to].ADD287(_value);
        emit TRANSFER933(msg.sender, _to, _value);
        return true;
    }

    function TRANSFERFROM87(address _from, address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[_from] = balances[_from].SUB660(_value);
        balances[_to] = balances[_to].ADD287(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB660(_value);
        emit TRANSFER933(_from, _to, _value);
        return true;
    }

    function APPROVE782(address _spender, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL210(msg.sender, _spender, _value);
        return true;
    }

    function INCREASEAPPROVAL326(address _spender, uint _addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].ADD287(_addedValue);
        emit APPROVAL210(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function DECREASEAPPROVAL424(address _spender, uint _subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.SUB660(_subtractedValue);
        }
        emit APPROVAL210(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}