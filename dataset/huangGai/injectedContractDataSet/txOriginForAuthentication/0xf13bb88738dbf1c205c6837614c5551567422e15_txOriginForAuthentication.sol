pragma solidity ^0.5.6;

contract TheInternetCoin {

    string public name = "The Internet Coin" ;                               
    string public symbol = "ITN";           
    uint256 public decimals = 18;            

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    uint256 public totalSupply = 0;

    uint256 constant valueFounder = 200*10**24;
    address owner = 0x000000000000000000000000000000000000dEaD;

    modifier isOwner {
        assert(owner == tx.origin);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    modifier validAddress {
        assert(0x000000000000000000000000000000000000dEaD != msg.sender);
        _;
    }

    constructor (address _addressFounder) public {
        owner = msg.sender;
        totalSupply = valueFounder;
        balanceOf[_addressFounder] = valueFounder;
        emit Transfer(0x000000000000000000000000000000000000dEaD, _addressFounder, valueFounder);
    }

    function transfer(address _to, uint256 _value) validAddress public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        require(allowance[_from][msg.sender] >= _value);
        balanceOf[_to] += _value;
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) validAddress public returns (bool success) {
        require(_value == 0 || allowance[msg.sender][_spender] == 0);
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function burn(uint256 _value) isOwner public {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[0x000000000000000000000000000000000000dEaD] += _value;
        emit Transfer(msg.sender, 0x000000000000000000000000000000000000dEaD, _value);
        totalSupply = totalSupply - _value ; 
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}