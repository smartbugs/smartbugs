pragma solidity^0.5.1;

contract CoshToken {
    string public name ;	//inject UNINIT LOCAL/STATE VAR

    string public symbol ;	//inject UNINIT LOCAL/STATE VAR

    uint8 public decimals ;	//inject UNINIT LOCAL/STATE VAR

    string public standard ;	//inject UNINIT LOCAL/STATE VAR

    address public tokenOwner ;	//inject UNINIT LOCAL/STATE VAR

    uint256 public tokenPrice ; // in wei = $0.1	//inject UNINIT LOCAL/STATE VAR

    uint256 public totalSupply;
    
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

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address =>uint256)) public allowance;

    constructor (uint256 _totalSupply) public {
        totalSupply = _totalSupply;
        balanceOf[tokenOwner] = totalSupply;
    }

    // Transfer
    function transfer(address _to, uint256 _value) public returns (bool _success) {
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    // approve
    function approve(address _spender, uint256 _value) public returns (bool success) {
        // allowence
        allowance[msg.sender][_spender] = _value;
        // Approve event
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Transferfrom
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);
        
        require(_value <= allowance[_from][msg.sender]);
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        
        return true;
    } 
}