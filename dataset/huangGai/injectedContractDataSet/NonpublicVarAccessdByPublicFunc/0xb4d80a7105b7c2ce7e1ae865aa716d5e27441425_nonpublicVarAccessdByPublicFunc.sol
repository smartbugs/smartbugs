/**
 *Submitted for verification at Etherscan.io on 2020-08-09
*/

pragma solidity ^0.5.1;

interface ERC20 {
    function balanceOf(address _owner) external view returns (uint256);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract etherdefi is ERC20 {
    using SafeMath for uint256;
    address private deployer;
    string public name = "etherdefi.world";
    string public symbol = "ETHFI";
    uint8 public constant decimals = 18;
    uint256 public constant decimalFactor = 10 ** uint256(decimals);
    uint256 public constant totalSupply = 800 * decimalFactor;
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() public {
        balances[msg.sender] = totalSupply;
        deployer = msg.sender;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(block.timestamp >= 1545102693);

        balances[msg.sender] = balances[msg.sender].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[_to] = balances[_to].add(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= balances[_from]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(_value <= allowed[_from][msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(block.timestamp >= 1545102693);

        balances[_from] = balances[_from].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[_to] = balances[_to].add(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        } else {
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        return true;
    }
}