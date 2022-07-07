/**
 *Submitted for verification at Etherscan.io on 2020-03-18
*/

pragma solidity ^ 0.6.0;

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------
interface ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a);
        
        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;
        
        return c;
    }
}

contract SpamToken is ERC20Interface {
    using SafeMath for uint256;
    
    string public name;
    string public symbol;
    uint8 public decimals;
    
    uint256 private _totalSupply;
    
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowed;
    
    constructor() public {
        name = "SpamToken";
        symbol = "SPM";
        decimals = 18;
        _totalSupply = 10000000000000000000000000000;
        
        _balances[0xe9dee5f92DBa7A59D0eD384E28e97e41e57Ddc94] = _totalSupply;
        emit Transfer(address(0), 0xe9dee5f92DBa7A59D0eD384E28e97e41e57Ddc94, _totalSupply);
    }
    
    function totalSupply() override external view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address _owner) override external view returns (uint256 balance) {
        return _balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) override external returns (bool success) {
        require(_value <= _balances[msg.sender]);
        require(_to != address(0));
        
        _balances[msg.sender] = _balances[msg.sender].sub(_value);
        _balances[_to] = _balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) override external returns (bool success) {
        require(_value <= _balances[_from]);
        require(_value <= _allowed[_from][msg.sender]);
        require(_to != address(0));
        
        _balances[_from] = _balances[_from].sub(_value);
        _balances[_to] = _balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
        
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) override external returns (bool success) {
        require(_spender != address(0));
        
        _allowed[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) override external view returns (uint256 remaining) {
        return _allowed[_owner][_spender];
    }
}