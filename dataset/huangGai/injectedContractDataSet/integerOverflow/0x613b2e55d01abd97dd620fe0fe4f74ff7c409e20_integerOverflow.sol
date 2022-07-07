/**
 *Submitted for verification at Etherscan.io on 2020-04-28
*/

pragma solidity ^0.5.16;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        //assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        //assert(c >= a);
        return c;
    }
}

contract Ownable {
	address public owner;
	address public newOwner;

	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

	function initOwnable() internal {
		owner = msg.sender;
		newOwner = address(0);
	}

	modifier onlyOwner() {
		require(msg.sender == owner, "msg.sender == owner");
		_;
	}

	function transferOwnership(address _newOwner) public onlyOwner {
		require(address(0) != _newOwner, "address(0) != _newOwner");
		newOwner = _newOwner;
	}

	function acceptOwnership() public {
		require(msg.sender == newOwner, "msg.sender == newOwner");
		emit OwnershipTransferred(owner, msg.sender);
		owner = msg.sender;
		newOwner = address(0);
	}
}

contract Adminable is Ownable {
    mapping(address => bool) public admin;

    event AdminSet(address indexed adminAddress, bool indexed status);

    function initAdminable() internal {
        admin[msg.sender] = true;
    }

    modifier onlyAdmin() {
        require(admin[msg.sender], "admin[msg.sender]");
        _;
    }

    function setAdmin(address adminAddress, bool status) public onlyOwner {
        emit AdminSet(adminAddress, status);
        admin[adminAddress] = status;
    }
}

contract Authorizable is Adminable {
    mapping(address => bool) public authorized;

    event AuthorizationSet(address indexed addressAuthorized, bool indexed authorization);

    function initAuthorizable() internal {
        authorized[msg.sender] = true;
    }

    modifier onlyAuthorized() {
        require(authorized[msg.sender], "authorized[msg.sender]");
        _;
    }

    function setAuthorized(address addressAuthorized, bool authorization) public onlyAdmin {
        emit AuthorizationSet(addressAuthorized, authorization);
        authorized[addressAuthorized] = authorization;
    }
}

contract ERC20Basic {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract BasicToken is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    function transferFunction(address _sender, address _to, uint256 _value) internal returns (bool) {
        require(_to != address(0), "_to != address(0)");
        require(_to != address(this), "_to != address(this)");
        require(_value <= balances[_sender], "_value <= balances[_sender]");

        balances[_sender] = balances[_sender].sub(_value);
        balances[_to] = balances[_to].add(_value);

        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
	    transferFunction(msg.sender, _to, _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}

contract ERC223TokenCompatible is BasicToken {
  using SafeMath for uint256;

  event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);

	function transfer(address _to, uint256 _value, bytes memory _data, string memory _custom_fallback) public returns (bool success) {
		transferFunction(msg.sender, _to, _value);

		if( isContract(_to) ) {
		    (bool txOk, ) = _to.call.value(0)( abi.encodePacked(bytes4( keccak256( abi.encodePacked( _custom_fallback ) ) ), msg.sender, _value, _data) );
			require( txOk, "_to.call.value(0)( abi.encodePacked(bytes4( keccak256( abi.encodePacked( _custom_fallback ) ) ), msg.sender, _value, _data) )" );

		}
		emit Transfer(msg.sender, _to, _value, _data);
		return true;
	}

	function transfer(address _to, uint256 _value, bytes memory _data) public returns (bool success) {
		return transfer(_to, _value, _data, "tokenFallback(address,uint256,bytes)");
	}

	//assemble the given address bytecode. If bytecode exists then the _addr is a contract.
	function isContract(address _addr) private view returns (bool is_contract) {
		uint256 length;
		assembly {
            //retrieve the size of the code on target address, this needs assembly
            length := extcodesize(_addr)
		}
		return (length>0);
    }
}

contract StandardToken is ERC20, BasicToken {

    mapping (address => mapping (address => uint256)) internal allowed;

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {

        require(_value <= allowed[_from][msg.sender], "_value <= allowed[_from][msg.sender]");

        transferFunction(_from, _to, _value);

        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
        allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        }
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
    }

}

contract HumanStandardToken is StandardToken {
    /* Approves and then calls the receiving contract */
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
        approve(_spender, _value);
        (bool txOk, ) = _spender.call(abi.encodePacked(bytes4(keccak256("receiveApproval(address,uint256,bytes)")), msg.sender, _value, _extraData));
        require(txOk, 'error on approveAndCall()');
        return true;
    }
    function approveAndCustomCall(address _spender, uint256 _value, bytes memory _extraData, bytes4 _customFunction) public returns (bool success) {
        approve(_spender, _value);
        (bool txOk, ) = _spender.call(abi.encodePacked(_customFunction, msg.sender, _value, _extraData));
        require(txOk, "error on approveAndCustomCall()");
        return true;
    }
}

contract Startable is Adminable, Authorizable {
    event Start();
    event Pause();

    bool public started = false;

    modifier whenStarted() {
	    require(started || authorized[msg.sender], "started || authorized[msg.sender]" );
        _;
    }

    function start() public onlyAdmin {
        started = true;
        emit Start();
    }

    function pause() public onlyAdmin {
        started = false;
        emit Pause();
    }
}

contract StartToken is Startable, ERC223TokenCompatible, StandardToken, HumanStandardToken {

    function transfer(address _to, uint256 _value) public whenStarted returns (bool) {
        return super.transfer(_to, _value);
    }
    function transfer(address _to, uint256 _value, bytes memory _data) public whenStarted returns (bool) {
        return super.transfer(_to, _value, _data);
    }
    function transfer(address _to, uint256 _value, bytes memory _data, string memory _custom_fallback) public whenStarted returns (bool) {
        return super.transfer(_to, _value, _data, _custom_fallback);
    }

    function transferFrom(address _from, address _to, uint256 _value) public whenStarted returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public whenStarted returns (bool) {
        return super.approve(_spender, _value);
    }

    function increaseApproval(address _spender, uint _addedValue) public whenStarted returns (bool success) {
        return super.increaseApproval(_spender, _addedValue);
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public whenStarted returns (bool success) {
        return super.decreaseApproval(_spender, _subtractedValue);
    }

    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public whenStarted returns (bool success) {
        return super.approveAndCall(_spender, _value, _extraData);
    }

    function approveAndCustomCall(
        address _spender,
        uint256 _value,
        bytes memory _extraData,
        bytes4 _customFunction
        )
        public whenStarted returns (bool success)
        {
        return super.approveAndCustomCall(_spender, _value, _extraData, _customFunction);
    }
}

contract Whitelistable is StartToken {
    mapping(address => bool) public whitelist;

    modifier whitelisted(address _to) {
	    require(whitelist[_to], "The user should be whitelisted.");
        _;
    }

    function transfer(address _to, uint256 _value) public whitelisted(_to) returns (bool) {
        return super.transfer(_to, _value);
    }
    function transfer(address _to, uint256 _value, bytes memory _data) public whitelisted(_to) returns (bool) {
        return super.transfer(_to, _value, _data);
    }
    function transfer(address _to, uint256 _value, bytes memory _data, string memory _custom_fallback) public whitelisted(_to) returns (bool) {
        return super.transfer(_to, _value, _data, _custom_fallback);
    }

    function transferFrom(address _from, address _to, uint256 _value) public whitelisted(_to) returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public whitelisted(_spender) returns (bool) {
        return super.approve(_spender, _value);
    }

    function increaseApproval(address _spender, uint _addedValue) public whitelisted(_spender) returns (bool success) {
        return super.increaseApproval(_spender, _addedValue);
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public whitelisted(_spender) returns (bool success) {
        return super.decreaseApproval(_spender, _subtractedValue);
    }

    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public whitelisted(_spender) returns (bool success) {
        return super.approveAndCall(_spender, _value, _extraData);
    }

    function approveAndCustomCall(
        address _spender,
        uint256 _value,
        bytes memory _extraData,
        bytes4 _customFunction
        )
        public whitelisted(_spender)
        returns (bool success)
        {
        return super.approveAndCustomCall(_spender, _value, _extraData, _customFunction);
    }

    function addToWhitelist(address[] memory _addresses) public onlyAdmin {
        for( uint256 i = 0; i < _addresses.length; i += 1 ) {
            whitelist[_addresses[i]] = true;
        }
    }

    function removeFromWhitelist(address[] memory _addresses) public onlyAdmin {
        for( uint256 i = 0; i < _addresses.length; i += 1 ) {
            whitelist[_addresses[i]] = false;
        }
    }
}

contract BurnToken is StandardToken {
    uint256 public initialSupply;

    event Burn(address indexed burner, uint256 value);

    function initBurnToken(uint256 _totalSupply) internal {
        initialSupply = _totalSupply;
    }

    function burnFunction(address _burner, uint256 _value) internal returns (bool) {
        require(_value > 0, "_value > 0");
		require(_value <= balances[_burner], "_value <= balances[_burner]");

        balances[_burner] = balances[_burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        emit Burn(_burner, _value);
		emit Transfer(_burner, address(0), _value);
		return true;
    }

	function burn(uint256 _value) public returns(bool) {
        return burnFunction(msg.sender, _value);
    }

	function burnFrom(address _from, uint256 _value) public returns (bool) {
		require(_value <= allowed[_from][msg.sender], "_value <= allowed[_from][msg.sender]"); // check if it has the budget allowed
		burnFunction(_from, _value);
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
		return true;
	}
}

contract Changable is Adminable, ERC20Basic {
    function changeName(string memory _newName) public onlyAdmin {
        name = _newName;
    }
    function changeSymbol(string memory _newSymbol) public onlyAdmin {
        symbol = _newSymbol;
    }
}

contract TokenImplementation is
    ERC20Basic,
    ERC223TokenCompatible,
     StandardToken,
    HumanStandardToken,
    StartToken,
    Whitelistable,
    BurnToken,
    Changable
    {
    bool internal initialized = true;
    function init(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public {
        require(!initialized, "!initialized");
        initOwnable();
        initAdminable();
        initAuthorizable();
        initBurnToken(_totalSupply);
        initialized = true;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        balances[msg.sender] = totalSupply;
		emit Transfer(address(0), msg.sender, totalSupply);
    }
}