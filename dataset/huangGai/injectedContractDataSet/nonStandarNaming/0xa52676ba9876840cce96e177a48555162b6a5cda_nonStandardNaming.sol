                                                                 

pragma solidity ^0.5.1;

interface ERC20 {
    function BALANCEOF826(address _owner) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ALLOWANCE267(address _owner, address _spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER297(address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM696(address _from, address _to, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE799(address _spender, uint256 _value) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER889(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL734(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

library SafeMath {
    function MUL624(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function DIV846(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a / b;
        return c;
    }

    function SUB910(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        assert(b <= a);
        return a - b;
    }

    function ADD174(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract afalos is ERC20 {
    using SafeMath for uint256;
    address private deployer;
    string public name = "Afalos.network";
    string public symbol = "AFAK";
    uint8 public constant decimals879 = 18;	//inject NONSTANDARD NAMING
    uint256 public constant decimalfactor655 = 10 ** uint256(decimals879);	//inject NONSTANDARD NAMING
    uint256 public constant totalsupply495 = 500 * decimalfactor655;	//inject NONSTANDARD NAMING
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    event TRANSFER889(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL734(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

    constructor() public {
        balances[msg.sender] = totalsupply495;
        deployer = msg.sender;
        emit TRANSFER889(address(0), msg.sender, totalsupply495);
    }

    function BALANCEOF826(address _owner) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING
        return balances[_owner];
    }

    function ALLOWANCE267(address _owner, address _spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return allowed[_owner][_spender];
    }

    function TRANSFER297(address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[msg.sender] = balances[msg.sender].SUB910(_value);
        balances[_to] = balances[_to].ADD174(_value);
        emit TRANSFER889(msg.sender, _to, _value);
        return true;
    }

    function TRANSFERFROM696(address _from, address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(block.timestamp >= 1545102693);

        balances[_from] = balances[_from].SUB910(_value);
        balances[_to] = balances[_to].ADD174(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB910(_value);
        emit TRANSFER889(_from, _to, _value);
        return true;
    }

    function APPROVE799(address _spender, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL734(msg.sender, _spender, _value);
        return true;
    }

    function INCREASEAPPROVAL719(address _spender, uint _addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].ADD174(_addedValue);
        emit APPROVAL734(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function DECREASEAPPROVAL265(address _spender, uint _subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = oldValue.SUB910(_subtractedValue);
        }
        emit APPROVAL734(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}