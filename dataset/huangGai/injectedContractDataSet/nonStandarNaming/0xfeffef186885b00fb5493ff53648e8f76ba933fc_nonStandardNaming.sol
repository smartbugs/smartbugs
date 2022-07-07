                                                                 

// File: contracts/tokens/ERC20.sol

pragma solidity 0.5.14;

                                                                                                                                                                         
contract ERC20 {

                                         
  function TOTALSUPPLY679() public view returns (uint256 supply);	//inject NONSTANDARD NAMING

                                                                        
  function BALANCEOF603(address _owner) public view returns (uint256 balance);	//inject NONSTANDARD NAMING

                                                                                                    
  function TRANSFER978(address _to, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING

                                                                             
  function TRANSFERFROM476(address _from, address _to, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                
  function APPROVE644(address _spender, uint256 _value) public returns (bool success);	//inject NONSTANDARD NAMING

                                                                                         
  function ALLOWANCE384(address _owner, address _spender) public view returns (uint256 remaining);	//inject NONSTANDARD NAMING

                                                                                
  event TRANSFER760(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                    
  event APPROVAL643(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: contracts/tokens/SafeMath.sol

pragma solidity 0.5.14;


                                                                                          
library SafeMath {

                                                                
  function MUL81(uint256 _a, uint256 _b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    uint256 c = _a * _b;
    require(c / _a == _b);

    return c;
  }

                                                                                                         
  function DIV451(uint256 _a, uint256 _b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(_b > 0);
    // Solidity only automatically asserts when dividing by 0
    uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold

    return c;
  }

                                                                                                            
  function SUB832(uint256 _a, uint256 _b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(_b <= _a);
    uint256 c = _a - _b;

    return c;
  }

                                                          
  function ADD114(uint256 _a, uint256 _b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = _a + _b;
    require(c >= _a);

    return c;
  }

                                                                                                                               
  function MOD487(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b != 0);
    return a % b;
  }
}

// File: contracts/tokens/StandardToken.sol

pragma solidity 0.5.14;




                                                                                                                                                                                                                                                                                 
contract StandardToken is ERC20 {
  using SafeMath for uint256;

  mapping(address => uint256) internal balances;

  mapping(address => mapping(address => uint256)) private allowed;

  uint256 internal totalSupply_;

                                                       
  function TOTALSUPPLY679() public view returns (uint256) {	//inject NONSTANDARD NAMING
    return totalSupply_;
  }

                                                                                                                                                                                                     
  function BALANCEOF603(address _owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
    return balances[_owner];
  }

                                                                                                                                                                                                                                                                                                                          
  function ALLOWANCE384(address _owner, address _spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
    return allowed[_owner][_spender];
  }

                                                                                                                                                     
  function TRANSFER978(address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
    require(_value <= balances[msg.sender]);
    require(_to != address(0));

    balances[msg.sender] = balances[msg.sender].SUB832(_value);
    balances[_to] = balances[_to].ADD114(_value);
    emit TRANSFER760(msg.sender, _to, _value);
    return true;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
  function APPROVE644(address _spender, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
    allowed[msg.sender][_spender] = _value;
    emit APPROVAL643(msg.sender, _spender, _value);
    return true;
  }

                                                                                                                                                                                                                                                                              
  function TRANSFERFROM476(address _from, address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);
    require(_to != address(0));

    balances[_from] = balances[_from].SUB832(_value);
    balances[_to] = balances[_to].ADD114(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB832(_value);
    emit TRANSFER760(_from, _to, _value);
    return true;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                               
  function INCREASEAPPROVAL847(address _spender, uint256 _addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
    allowed[msg.sender][_spender] = (
    allowed[msg.sender][_spender].ADD114(_addedValue));
    emit APPROVAL643(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function DECREASEAPPROVAL982(address _spender, uint256 _subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
    uint256 oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue >= oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.SUB832(_subtractedValue);
    }
    emit APPROVAL643(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

                                                                                                                                                                                                                                                                                                                                     
  function _MINT883(address _account, uint256 _amount) internal {	//inject NONSTANDARD NAMING
    require(_account != address(0));
    totalSupply_ = totalSupply_.ADD114(_amount);
    balances[_account] = balances[_account].ADD114(_amount);
    emit TRANSFER760(address(0), _account, _amount);
  }

                                                                                                                                                                                                                  
  function _BURN950(address _account, uint256 _amount) internal {	//inject NONSTANDARD NAMING
    require(_account != address(0));
    require(_amount <= balances[_account]);

    totalSupply_ = totalSupply_.SUB832(_amount);
    balances[_account] = balances[_account].SUB832(_amount);
    emit TRANSFER760(_account, address(0), _amount);
  }

                                                                                                                                                                                                                                                                                                                 
  function _BURNFROM531(address _account, uint256 _amount) internal {	//inject NONSTANDARD NAMING
    require(_amount <= allowed[_account][msg.sender]);

    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
    // this function needs to emit an event with the updated approval.
    allowed[_account][msg.sender] = allowed[_account][msg.sender].SUB832(_amount);
    _BURN950(_account, _amount);
  }
}

// File: contracts/tokens/Ownable.sol

pragma solidity 0.5.14;


                                                                                                                                                                                             
contract Ownable {
  address public owner;

  event OWNERSHIPRENOUNCED53(address indexed previousOwner);	//inject NONSTANDARD NAMING

  event OWNERSHIPTRANSFERRED268(	//inject NONSTANDARD NAMING
    address indexed previousOwner,
    address indexed newOwner
  );

                                                                                                                   
  constructor() public {
    owner = msg.sender;
  }

                                                                           
  modifier ONLYOWNER709() {	//inject NONSTANDARD NAMING
    require(msg.sender == owner);
    _;
  }

                                                                                                                                                                                                                                                                   
  function RENOUNCEOWNERSHIP918() public ONLYOWNER709 {	//inject NONSTANDARD NAMING
    emit OWNERSHIPRENOUNCED53(owner);
    owner = address(0);
  }

                                                                                                                                                             
  function TRANSFEROWNERSHIP47(address _newOwner) public ONLYOWNER709 {	//inject NONSTANDARD NAMING
    _TRANSFEROWNERSHIP390(_newOwner);
  }

                                                                                                                                  
  function _TRANSFEROWNERSHIP390(address _newOwner) internal {	//inject NONSTANDARD NAMING
    require(_newOwner != address(0));
    emit OWNERSHIPTRANSFERRED268(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: contracts/tokens/BurnableToken.sol

pragma solidity 0.5.14;



                                                                                           
contract BurnableToken is StandardToken {

  event BURN276(address indexed burner, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                             
  function BURN42(uint256 _value) public {	//inject NONSTANDARD NAMING
    _BURN950(msg.sender, _value);
  }

                                                                                                                                                                                                                                             
  function BURNFROM69(address _from, uint256 _value) public {	//inject NONSTANDARD NAMING
    _BURNFROM531(_from, _value);
  }

                                                                                                                         
  function _BURN950(address _who, uint256 _value) internal {	//inject NONSTANDARD NAMING
    super._BURN950(_who, _value);
    emit BURN276(_who, _value);
  }
}

// File: contracts/tokens/SportValueCoin.sol

pragma solidity 0.5.14;


                                                                                                                                
contract SportValueCoin is BurnableToken {

  // meta data
  string public constant symbol15 = "SVC";	//inject NONSTANDARD NAMING

  string public version = '1.0';

  string public constant name455 = "Sport Value Coin";	//inject NONSTANDARD NAMING

  uint256 public constant decimals291 = 18;	//inject NONSTANDARD NAMING

  uint256 public constant initial_supply658 = 100 * (10 ** 6) * 10 ** decimals291; // 100 millions	//inject NONSTANDARD NAMING

  constructor() public {
    _MINT883(msg.sender, initial_supply658);
  }

}