pragma solidity ^0.5.1;

library SafeMath {

                                                               
  function MUL493(uint256 _a, uint256 _b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

                                                                             
  function DIV994(uint256 _a, uint256 _b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    // assert(_b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

                                                                                                           
  function SUB747(uint256 _a, uint256 _b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    assert(_b <= _a);
    return _a - _b;
  }

                                                         
  function ADD196(uint256 _a, uint256 _b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}

contract Ownable {
  address public owner;


  event OWNERSHIPRENOUNCED804(address indexed previousOwner);	//inject NONSTANDARD NAMING
  event OWNERSHIPTRANSFERRED780(	//inject NONSTANDARD NAMING
    address indexed previousOwner,
    address indexed newOwner
  );


                                                                                                                   
  constructor() public {
    owner = msg.sender;
  }

                                                                           
  modifier ONLYOWNER146() {	//inject NONSTANDARD NAMING
    require(msg.sender == owner);
    _;
  }

                                                                                                                                                                                                                                                                   
  function RENOUNCEOWNERSHIP303() public ONLYOWNER146 {	//inject NONSTANDARD NAMING
    emit OWNERSHIPRENOUNCED804(owner);
    owner = address(0);
  }

                                                                                                                                                             
  function TRANSFEROWNERSHIP59(address _newOwner) public ONLYOWNER146 {	//inject NONSTANDARD NAMING
    _TRANSFEROWNERSHIP932(_newOwner);
  }

                                                                                                                                  
  function _TRANSFEROWNERSHIP932(address _newOwner) internal {	//inject NONSTANDARD NAMING
    require(_newOwner != address(0));
    emit OWNERSHIPTRANSFERRED780(owner, _newOwner);
    owner = _newOwner;
  }
}

contract Pausable is Ownable {
  event PAUSE575();	//inject NONSTANDARD NAMING
  event UNPAUSE64();	//inject NONSTANDARD NAMING

  bool public paused = false;


                                                                                                
  modifier WHENNOTPAUSED282() {	//inject NONSTANDARD NAMING
    require(!paused);
    _;
  }

                                                                                            
  modifier WHENPAUSED855() {	//inject NONSTANDARD NAMING
    require(paused);
    _;
  }

                                                                          
  function PAUSE602() public ONLYOWNER146 WHENNOTPAUSED282 {	//inject NONSTANDARD NAMING
    paused = true;
    emit PAUSE575();
  }

                                                                             
  function UNPAUSE899() public ONLYOWNER146 WHENPAUSED855 {	//inject NONSTANDARD NAMING
    paused = false;
    emit UNPAUSE64();
  }
}

contract ERC20Basic {
    function TOTALSUPPLY769() public view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF878(address _who) public view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFER201(address _to, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING

    event TRANSFER93(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
}

contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) internal balances;

    uint256 internal totalSupply_;

                                                               
    function TOTALSUPPLY769() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return totalSupply_;
    }

                                                                                                                                                                   
    function TRANSFER201(address _to, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        require(_value <= balances[msg.sender]);
        require(_to != address(0));

        balances[msg.sender] = balances[msg.sender].SUB747(_value);
        balances[_to] = balances[_to].ADD196(_value);
        emit TRANSFER93(msg.sender, _to, _value);
        return true;
    }

                                                                                                                                                                                                                   
    function BALANCEOF878(address _owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return balances[_owner];
    }
}

contract ERC20 is ERC20Basic {
    function ALLOWANCE103(address _owner, address _spender) public view returns (uint256);	//inject NONSTANDARD NAMING
    function TRANSFERFROM299(address _from, address _to, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE456(address _spender, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING

    event APPROVAL162(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract StandardToken is ERC20, BasicToken {
    mapping (address => mapping (address => uint256)) internal allowed;


                                                                                                                                                                                                                                                                                          
    function TRANSFERFROM299(address _from, address _to, uint256 _value)	//inject NONSTANDARD NAMING
        public returns (bool) {
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(_to != address(0));

        balances[_from] = balances[_from].SUB747(_value);
        balances[_to] = balances[_to].ADD196(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].SUB747(_value);
        emit TRANSFER93(_from, _to, _value);
        return true;
    }


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function APPROVE456(address _spender, uint256 _value) public returns (bool) {	//inject NONSTANDARD NAMING
        allowed[msg.sender][_spender] = _value;
        emit APPROVAL162(msg.sender, _spender, _value);
        return true;
    }


                                                                                                                                                                                                                                                                                                                                      
    function ALLOWANCE103(address _owner, address _spender)	//inject NONSTANDARD NAMING
        public view returns (uint256) {
        return allowed[_owner][_spender];
    }


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
    function INCREASEAPPROVAL281(address _spender, uint256 _addedValue)	//inject NONSTANDARD NAMING
        public returns (bool) {
        allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].ADD196(_addedValue));
        emit APPROVAL162(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    function DECREASEAPPROVAL320(address _spender, uint256 _subtractedValue)	//inject NONSTANDARD NAMING
        public returns (bool) {
        uint256 oldValue = allowed[msg.sender][_spender];

        if (_subtractedValue >= oldValue) allowed[msg.sender][_spender] = 0;
        else allowed[msg.sender][_spender] = oldValue.SUB747(_subtractedValue);

        emit APPROVAL162(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
}

contract BurnableToken is StandardToken, Ownable {
    event BURN461(address indexed burner, uint256 value);	//inject NONSTANDARD NAMING


                                                                                                                                                                               
    function BURN801(address _who, uint256 _value) ONLYOWNER146 public {	//inject NONSTANDARD NAMING
        require(_value <= balances[_who]);
        // no need to require value <= totalSupply, since that would imply the
        // sender's balance is greater than the totalSupply, which *should* be an assertion failure

        balances[_who] = balances[_who].SUB747(_value);
        totalSupply_ = totalSupply_.SUB747(_value);
        emit BURN461(_who, _value);
        emit TRANSFER93(_who, address(0), _value);
    }
}

contract MintableToken is StandardToken, Ownable {
    event MINT447(address indexed to, uint256 amount);	//inject NONSTANDARD NAMING
    event MINTFINISHED751();	//inject NONSTANDARD NAMING

    bool public mintingFinished = false;


    modifier CANMINT819() {	//inject NONSTANDARD NAMING
        require(!mintingFinished);
        _;
    }


    modifier HASMINTPERMISSION565() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner);
        _;
    }


                                                                                                                                                                                                                                                   
    function MINT802(address _to, uint256 _amount)	//inject NONSTANDARD NAMING
        public HASMINTPERMISSION565 CANMINT819 returns (bool) {
        totalSupply_ = totalSupply_.ADD196(_amount);
        balances[_to] = balances[_to].ADD196(_amount);
        emit MINT447(_to, _amount);
        emit TRANSFER93(address(0), _to, _amount);
        return true;
    }


                                                                                                                     
    function FINISHMINTING937() public ONLYOWNER146 CANMINT819 returns (bool) {	//inject NONSTANDARD NAMING
        mintingFinished = true;
        emit MINTFINISHED751();
        return true;
    }
}

contract CappedToken is MintableToken {
    uint256 public cap;


    constructor(uint256 _cap) public {
        require(_cap > 0);
        cap = _cap;
    }


                                                                                                                                                                                                                                                   
    function MINT802(address _to, uint256 _amount) public returns (bool) {	//inject NONSTANDARD NAMING
        require(totalSupply_.ADD196(_amount) <= cap);
        return super.MINT802(_to, _amount);
    }
}

contract PausableToken is StandardToken, Pausable {
    function TRANSFER201(address _to, uint256 _value)	//inject NONSTANDARD NAMING
        public WHENNOTPAUSED282 returns (bool) {
        return super.TRANSFER201(_to, _value);
    }


    function TRANSFERFROM299(address _from, address _to, uint256 _value)	//inject NONSTANDARD NAMING
        public WHENNOTPAUSED282 returns (bool) {
        return super.TRANSFERFROM299(_from, _to, _value);
    }


    function APPROVE456(address _spender, uint256 _value)	//inject NONSTANDARD NAMING
        public WHENNOTPAUSED282 returns (bool) {
        return super.APPROVE456(_spender, _value);
    }


    function INCREASEAPPROVAL281(address _spender, uint _addedValue)	//inject NONSTANDARD NAMING
        public WHENNOTPAUSED282 returns (bool success) {
        return super.INCREASEAPPROVAL281(_spender, _addedValue);
    }


    function DECREASEAPPROVAL320(address _spender, uint _subtractedValue)	//inject NONSTANDARD NAMING
        public WHENNOTPAUSED282 returns (bool success) {
        return super.DECREASEAPPROVAL320(_spender, _subtractedValue);
    }
}

contract CryptoPolitanToken is BurnableToken, PausableToken, CappedToken {
    address public upgradedAddress;
    bool public deprecated;
    string public contactInformation = "contact@cryptopolitan.com";
    string public name = "CryptoPolitan";
    string public reason;
    string public symbol = "CPOL";
    uint8 public decimals = 8;

    constructor () CappedToken(100000000000000000000) public {}

    // Fix for the ERC20 short address attack.
    modifier ONLYPAYLOADSIZE635(uint size) {	//inject NONSTANDARD NAMING
        require(!(msg.data.length < size + 4), "payload too big");
        _;
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function TRANSFER201(address _to, uint _value) public WHENNOTPAUSED282 returns (bool) {	//inject NONSTANDARD NAMING
        if (deprecated) return UpgradedStandardToken(upgradedAddress).TRANSFERBYLEGACY691(msg.sender, _to, _value);
        else return super.TRANSFER201(_to, _value);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function TRANSFERFROM299(address _from, address _to, uint _value) public WHENNOTPAUSED282 returns (bool) {	//inject NONSTANDARD NAMING
        if (deprecated) return UpgradedStandardToken(upgradedAddress).TRANSFERFROMBYLEGACY906(msg.sender, _from, _to, _value);
        else return super.TRANSFERFROM299(_from, _to, _value);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function BALANCEOF878(address who) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (deprecated) return UpgradedStandardToken(upgradedAddress).BALANCEOF878(who);
        else return super.BALANCEOF878(who);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function APPROVE456(address _spender, uint _value) public ONLYPAYLOADSIZE635(2 * 32) returns (bool) {	//inject NONSTANDARD NAMING
        if (deprecated) return UpgradedStandardToken(upgradedAddress).APPROVEBYLEGACY941(msg.sender, _spender, _value);
        else return super.APPROVE456(_spender, _value);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function ALLOWANCE103(address _owner, address _spender) public view returns (uint remaining) {	//inject NONSTANDARD NAMING
        if (deprecated) return StandardToken(upgradedAddress).ALLOWANCE103(_owner, _spender);
        else return super.ALLOWANCE103(_owner, _spender);
    }

    // deprecate current contract in favour of a new one
    function DEPRECATE994(address _upgradedAddress, string memory _reason) public ONLYOWNER146 {	//inject NONSTANDARD NAMING
        deprecated = true;
        upgradedAddress = _upgradedAddress;
        reason = _reason;
        emit DEPRECATE691(_upgradedAddress, _reason);
    }

    // Called when contract is deprecated
    event DEPRECATE691(address newAddress, string reason);	//inject NONSTANDARD NAMING
}

contract UpgradedStandardToken is PausableToken {
    // those methods are called by the legacy contract
    // and they must ensure msg.sender to be the contract address
    function TRANSFERBYLEGACY691(address from, address to, uint value) public returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROMBYLEGACY906(address sender, address from, address spender, uint value) public returns (bool);	//inject NONSTANDARD NAMING
    function APPROVEBYLEGACY941(address from, address spender, uint value) public returns (bool);	//inject NONSTANDARD NAMING
}