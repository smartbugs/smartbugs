                                                                 

pragma solidity 0.5.17;

   
                                                                                         
library SafeMath {
  function MUL922(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function DIV682(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function SUB426(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    assert(b <= a);
    return a - b;
  }

  function ADD438(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}


                                                                                                                                                                                             
contract Ownable {
  address public owner;


  event OWNERSHIPTRANSFERRED626(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING


                                                                                                                   
  constructor() public {
    owner = msg.sender;
  }


                                                                           
  modifier ONLYOWNER539() {	//inject NONSTANDARD NAMING
    require(msg.sender == owner);
    _;
  }


                                                                                                                                                            
  function TRANSFEROWNERSHIP867(address newOwner) ONLYOWNER539 public {	//inject NONSTANDARD NAMING
    require(newOwner != address(0));
    emit OWNERSHIPTRANSFERRED626(owner, newOwner);
    owner = newOwner;
  }
}

                                                                                                                               
contract ERC20Basic {
  uint256 public totalSupply;
  function BALANCEOF550(address who) public view returns (uint256);	//inject NONSTANDARD NAMING
  function TRANSFER247(address to, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING
  event TRANSFER814(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
}


                                                                                         
contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) internal balances;

                                                                                                                                                     
  function TRANSFER247(address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
    require(_to != address(0) && _to != address(this));

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].SUB426(_value);
    balances[_to] = balances[_to].ADD438(_value);
    emit TRANSFER814(msg.sender, _to, _value);
    return true;
  }

                                                                                                                                                                                                     
  function BALANCEOF550(address _owner) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING
    return balances[_owner];
  }
}

                                                                                        
contract ERC20 is ERC20Basic {
  function ALLOWANCE624(address owner, address spender) public view returns (uint256);	//inject NONSTANDARD NAMING
  function TRANSFERFROM452(address from, address to, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING
  function APPROVE694(address spender, uint256 value) public returns (bool);	//inject NONSTANDARD NAMING
  event APPROVAL612(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}


                                                                                                                                                                                                                                                                          
contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) internal allowed;


                                                                                                                                                                                                                                                                              
  function TRANSFERFROM452(address _from, address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
    require(_to != address(0) && _to != address(this));

    uint256 _allowance = allowed[_from][msg.sender];

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    // require (_value <= _allowance);

    balances[_from] = balances[_from].SUB426(_value);
    balances[_to] = balances[_to].ADD438(_value);
    allowed[_from][msg.sender] = _allowance.SUB426(_value);
    emit TRANSFER814(_from, _to, _value);
    return true;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
  function APPROVE694(address _spender, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
    allowed[msg.sender][_spender] = _value;
    emit APPROVAL612(msg.sender, _spender, _value);
    return true;
  }

                                                                                                                                                                                                                                                                                                                          
  function ALLOWANCE624(address _owner, address _spender) public view returns (uint256 remaining) {	//inject NONSTANDARD NAMING
    return allowed[_owner][_spender];
  }

                                                                                                                                                                                                                                           
  function INCREASEAPPROVAL555 (address _spender, uint _addedValue) public	//inject NONSTANDARD NAMING
    returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].ADD438(_addedValue);
    emit APPROVAL612(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function DECREASEAPPROVAL969 (address _spender, uint _subtractedValue) public	//inject NONSTANDARD NAMING
    returns (bool success) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.SUB426(_subtractedValue);
    }
    emit APPROVAL612(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }
}


interface tokenRecipient { 
    function RECEIVEAPPROVAL835(address _from, uint256 _value, bytes calldata _extraData) external;	//inject NONSTANDARD NAMING
}

                                                                                           
contract BurnableToken is StandardToken {

    event BURN972(address indexed burner, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                     
    function BURN583(address burner, uint256 _value) internal {	//inject NONSTANDARD NAMING
        require(_value > 0);
        require(_value <= balances[burner]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        balances[burner] = balances[burner].SUB426(_value);
        totalSupply = totalSupply.SUB426(_value);
        emit TRANSFER814(burner, address(0), _value);
        emit BURN972(burner, _value);
    }
}

contract DKING is BurnableToken, Ownable {
    
    address public stakingAddress;

    string public constant name593 = "Deflationary King";	//inject NONSTANDARD NAMING
    string public constant symbol894 = "DKING";	//inject NONSTANDARD NAMING
    uint public constant decimals497 = 18;	//inject NONSTANDARD NAMING
    // there is no problem in using * here instead of .mul()
    uint256 public constant initialsupply444 = 1000000 * (10 ** uint256(decimals497));	//inject NONSTANDARD NAMING
    
    function SETSTAKINGADDRESS222(address _addr) public ONLYOWNER539 {	//inject NONSTANDARD NAMING
        stakingAddress = _addr;
    }
    
    function TRANSFER247(address to, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        uint _amountToBurn = amount.MUL922(400).DIV682(10000);
        uint _amountToDisburse = amount.MUL922(400).DIV682(10000);
        uint _amountAfterFee = amount.SUB426(_amountToBurn).SUB426(_amountToDisburse);
        
        BURN583(msg.sender, _amountToBurn);
        require(super.TRANSFER247(stakingAddress, _amountToDisburse), "Cannot disburse rewards.");
        if (stakingAddress != address(0)) {
            tokenRecipient(stakingAddress).RECEIVEAPPROVAL835(msg.sender, _amountToDisburse, "");
        }
        require(super.TRANSFER247(to, _amountAfterFee), "Cannot transfer tokens.");
        return true;
    }
    
    function TRANSFERFROM452(address from, address to, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        require(to != address(0) && to != address(this));
        uint _amountToBurn = amount.MUL922(400).DIV682(10000);
        uint _amountToDisburse = amount.MUL922(400).DIV682(10000);
        uint _amountAfterFee = amount.SUB426(_amountToBurn).SUB426(_amountToDisburse);
        
        uint256 _allowance = allowed[from][msg.sender];
    
        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
        // require (_value <= _allowance);

        balances[from] = balances[from].SUB426(_amountAfterFee);
        balances[to] = balances[to].ADD438(_amountAfterFee);
        balances[from] = balances[from].SUB426(_amountToDisburse);
        balances[stakingAddress] = balances[stakingAddress].ADD438(_amountToDisburse);
        allowed[from][msg.sender] = _allowance.SUB426(amount);
        
        BURN583(from, _amountToBurn);

        emit TRANSFER814(from, stakingAddress, _amountToDisburse);
        emit TRANSFER814(from, to, _amountAfterFee);
        
        if (stakingAddress != address(0)) {
            tokenRecipient(stakingAddress).RECEIVEAPPROVAL835(msg.sender, _amountToDisburse, "");
        }
        return true;
    }

    // Constructors
    constructor () public {
        totalSupply = initialsupply444;
        balances[msg.sender] = initialsupply444; // Send all tokens to owner
        emit TRANSFER814(address(0), msg.sender, initialsupply444);
    }
    
    
    function TRANSFERANYERC20TOKEN616(address _tokenAddress, address _to, uint _amount) public ONLYOWNER539 {	//inject NONSTANDARD NAMING
        ERC20(_tokenAddress).TRANSFER247(_to, _amount);
    }
    
}