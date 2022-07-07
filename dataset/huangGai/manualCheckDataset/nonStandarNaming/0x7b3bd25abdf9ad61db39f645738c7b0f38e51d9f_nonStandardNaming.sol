pragma solidity ^0.5.1;

interface tokenRecipient { 
    function RECEIVEAPPROVAL508(address _from, uint256 _value, address _token, bytes calldata _extraData) external; 	//inject NONSTANDARD NAMING
}

                                                                                         
library SafeMath {

                                                               
  function MUL771(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    c = a * b;
    assert(c / a == b);
    return c;
  }

                                                                             
  function DIV887(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return a / b;
  }

                                                                                                           
  function SUB554(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    assert(b <= a);
    return a - b;
  }

                                                         
  function ADD386(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
    c = a + b;
    assert(c >= a);
    return c;
  }
}

contract SOContract {
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowed;

    // This generates a public event on the blockchain that will notify clients
    event TRANSFER728(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL102(address indexed _owner, address indexed _spender, uint256 _value);	//inject NONSTANDARD NAMING

                                                                                                                                        
    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
    }

                                                                             
    function _TRANSFER248(address _from, address _to, uint256 _value) internal {	//inject NONSTANDARD NAMING
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != address(0x0));
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        emit TRANSFER728(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

                                                                                                                                                                                                  
    function TRANSFER116(address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        _TRANSFER248(msg.sender, _to, _value);
        return true;
    }

                                                                                                                                                                                                                                                                      
    function TRANSFERFROM758(address _from, address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        require(_value <= allowed[_from][msg.sender]);     // Check allowance
        allowed[_from][msg.sender] -= _value;
        _TRANSFER248(_from, _to, _value);
        return true;
    }

                                                                                                                                                                                                                                                            
    function APPROVE102(address _spender, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL102(msg.sender, _spender, _value); 
        return true;
    }

                                                                                                                                                
    function INCREASEAPPROVAL679(address _spender, uint _addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = SafeMath.ADD386(allowed[msg.sender][_spender],_addedValue);
        emit APPROVAL102(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

                                                                                                                                                          
    function DECREASEAPPROVAL481(address _spender, uint _subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = SafeMath.SUB554(oldValue, _subtractedValue);
        }
        emit APPROVAL102(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

                                            
    function ALLOWANCE225(address _owner, address _spender) public view returns (uint256 remaining) {	//inject NONSTANDARD NAMING
        return allowed[_owner][_spender];
    }

                                                                                                                                                                                                                                                                                                                                                                                             
    function APPROVEANDCALL291(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {	//inject NONSTANDARD NAMING
        tokenRecipient spender = tokenRecipient(_spender);
        if (APPROVE102(_spender, _value)) {
            spender.RECEIVEAPPROVAL508(msg.sender, _value, address(this), _extraData);
            return true;
        }
    }
}