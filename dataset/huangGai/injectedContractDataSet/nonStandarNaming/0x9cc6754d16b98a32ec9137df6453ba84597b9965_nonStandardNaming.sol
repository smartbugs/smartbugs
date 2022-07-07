                                                                 

pragma solidity ^0.5.0;

contract Token {
    string  public name = "waviii";
    string  public symbol = "waviii";
    uint256 public totalSupply = 1000000000000000000000000; // 1 million tokens
    uint8   public decimals = 18;

    event TRANSFER854(	//inject NONSTANDARD NAMING
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event APPROVAL296(	//inject NONSTANDARD NAMING
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function TRANSFER300(address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit TRANSFER854(msg.sender, _to, _value);
        return true;
    }

    function APPROVE674(address _spender, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowance[msg.sender][_spender] = _value;
        emit APPROVAL296(msg.sender, _spender, _value);
        return true;
    }

    function TRANSFERFROM551(address _from, address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit TRANSFER854(_from, _to, _value);
        return true;
    }
}