/**
 *Submitted for verification at Etherscan.io on 2020-08-29
*/

pragma solidity ^0.5.0;

contract Token {
    string  public name = "GG WP";
    string  public symbol = "GGWP";
    uint256 public totalSupply = 750000000000000000000000; // 750k million tokens
    uint8   public decimals = 18;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) internal balanceOf;
    mapping(address => mapping(address => uint256)) internal allowance;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balanceOf[msg.sender] -= _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balanceOf[_to] += _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(_value <= allowance[_from][msg.sender]);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balanceOf[_from] -= _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balanceOf[_to] += _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        allowance[_from][msg.sender] -= _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(_from, _to, _value);
        return true;
    }
}