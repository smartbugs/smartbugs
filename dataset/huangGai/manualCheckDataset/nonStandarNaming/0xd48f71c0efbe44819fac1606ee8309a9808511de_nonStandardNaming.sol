                                                                 

pragma solidity ^0.5.8;

contract ERC20_Contract{
    
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address internal admin;
    mapping (address => uint256) public balanceOf;
    bool public isActivity = true;
    bool public openRaise = true;
    uint256 public raiseOption = 0;
    address payable internal management;
    
	event TRANSFER619(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
	event SENDETH835(address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    
    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
     ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
        management = msg.sender;
        admin = msg.sender;
    }

    modifier ONLYADMIN861() { 	//inject NONSTANDARD NAMING
        require(msg.sender == admin);
        _;
    }

    modifier ISACT922() { 	//inject NONSTANDARD NAMING
        require(isActivity);
        _;
    }

    modifier ISOPENRAISE916() { 	//inject NONSTANDARD NAMING
        require(openRaise);
        _;
    }

    function () external payable ISACT922 ISOPENRAISE916{
		require(raiseOption >= 0);
		uint256 buyNum = msg.value /10000 * raiseOption;
		require(buyNum <= balanceOf[management]);
		balanceOf[management] -= buyNum;
		balanceOf[msg.sender] += buyNum;
        management.transfer(msg.value);
        emit SENDETH835(management, msg.value);
        emit TRANSFER619(management, msg.sender, buyNum);
	}
    
    function TRANSFER915(address _to, uint256 _value) public ISACT922{	//inject NONSTANDARD NAMING
	    _TRANSFER532(msg.sender, _to, _value);
    }
    
    function BATCHTRANSFER282(address[] memory _tos, uint[] memory _values) public ISACT922 {	//inject NONSTANDARD NAMING
        require(_tos.length == _values.length);
        uint256 _total = 0;
        for(uint256 i;i<_values.length;i++){
            _total += _values[i];
	    }
        require(balanceOf[msg.sender]>=_total);
        for(uint256 i;i<_tos.length;i++){
            _TRANSFER532(msg.sender,_tos[i],_values[i]);
	    }
    }
    
    function _TRANSFER532(address _from, address _to, uint _value) internal {	//inject NONSTANDARD NAMING
        require(_to != address(0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit TRANSFER619(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
	
	function SETRAISEOPTION937(uint256 _price)public ONLYADMIN861{	//inject NONSTANDARD NAMING
		raiseOption = _price;
	}
	
	function SETRAISEOPEN489(bool _open) public ONLYADMIN861{	//inject NONSTANDARD NAMING
	    openRaise = _open;
	}
	
	function SETACT148(bool _isAct) public ONLYADMIN861{	//inject NONSTANDARD NAMING
		isActivity = _isAct;
	}
	
	function CHANGEADMIN920(address _address) public ONLYADMIN861{	//inject NONSTANDARD NAMING
       admin = _address;
    }
    
    function CHANGEFINANCE282(address payable _address) public ONLYADMIN861{	//inject NONSTANDARD NAMING
       management = _address;
    }
	
	function DESTRUCTCONTRACT32()public ONLYADMIN861{	//inject NONSTANDARD NAMING
		selfdestruct(management);
	}
	
}