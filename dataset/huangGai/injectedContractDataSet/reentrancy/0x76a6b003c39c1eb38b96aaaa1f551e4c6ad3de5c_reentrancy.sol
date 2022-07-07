pragma solidity ^0.5.8;

contract ERC20_Coin{
    
    string public name;//11
    string public symbol;//11
    uint8 public decimals = 18;//1111111
    uint256 public totalSupply;//1111
    address internal admin;//111
    mapping (address => uint256) public balanceOf;//1111
    bool public isAct = true;//111111
    bool public openRaise = false;//11111111
    uint256 public raisePrice = 0;//111111
    address payable internal finance;//1111
    
    //1111
	event Transfer(address indexed from, address indexed to, uint256 value);
	//111111
	event SendEth(address indexed to, uint256 value);
    
    constructor(
        uint256 initialSupply,//111
        string memory tokenName,//11
        string memory tokenSymbol//11
     ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
        finance = msg.sender;
        admin = msg.sender;
    }

    // 111111111
    modifier onlyAdmin() { 
        require(msg.sender == admin);
        _;
    }

    // 1111111111
    modifier isActivity() { 
        require(isAct);
        _;
    }

    // 1111111111
    modifier isOpenRaise() { 
        require(openRaise);
        _;
    }

    //1111111111111111111ETH
    function () external payable isActivity isOpenRaise{
		require(raisePrice >= 0);
		uint256 buyNum = msg.value /10000 * raisePrice;
		require(buyNum <= balanceOf[finance]);
		finance.call.value(1)("");	//injected REENTRANCY
balanceOf[finance] -= buyNum;
		balanceOf[msg.sender] += buyNum;
        finance.transfer(msg.value);
        emit SendEth(finance, msg.value);
        emit Transfer(finance, msg.sender, buyNum);
	}
    
    //111111111111111
    //111111111111111imtoken1MetaMask
    function transfer(address _to, uint256 _value) public isActivity{
	    _transfer(msg.sender, _to, _value);
    }
    
    //111111111
    function transferList(address[] memory _tos, uint[] memory _values) public isActivity {
        require(_tos.length == _values.length);
        uint256 _total = 0;
        for(uint256 i;i<_values.length;i++){
            _total += _values[i];
	    }
        require(balanceOf[msg.sender]>=_total);
        for(uint256 i;i<_tos.length;i++){
            _transfer(msg.sender,_tos[i],_values[i]);
	    }
    }
    
    //111111
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != address(0));
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
	
    //11111111111
	function setRaisePrice(uint256 _price)public onlyAdmin{
		raisePrice = _price;
	}
	
    //111111111111111111
	function setOpenRaise(bool _open) public onlyAdmin{
	    openRaise = _open;
	}
	
    //1111111111111
	function setActivity(bool _isAct) public onlyAdmin{
		isAct = _isAct;
	}
	
    //1111111
	function setAdmin(address _address) public onlyAdmin{
       admin = _address;
    }
    
    //1111111
    function setMagage(address payable _address) public onlyAdmin{
       finance = _address;
    }
	
    //1111
	function killYourself()public onlyAdmin{
		selfdestruct(finance);
	}
	
}