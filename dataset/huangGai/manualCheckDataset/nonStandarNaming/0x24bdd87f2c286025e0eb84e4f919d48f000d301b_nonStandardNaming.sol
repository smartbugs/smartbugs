                                                                 

pragma solidity 0.5.13;

//https://www.yineu.me

interface Callable {
	function TOKENCALLBACK394(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);	//inject NONSTANDARD NAMING
}

contract Yineu {

	uint256 constant private initial_supply76 = 1e3;	//inject NONSTANDARD NAMING
	uint256 constant private new_address_supply964 = 1e3;	//inject NONSTANDARD NAMING
	uint256 constant private precision846 = 1e3; 	//inject NONSTANDARD NAMING
	string constant public name678 = "Yineu";	//inject NONSTANDARD NAMING
	string constant public symbol760 = "YIN";	//inject NONSTANDARD NAMING
	uint8 constant public decimals330 = 3;	//inject NONSTANDARD NAMING

    address[] public allAddresses;
    
	struct User {
		uint256 balance;
		mapping(address => uint256) allowance;
	}

	struct Info {
		uint256 totalSupply;
		mapping(address => User) users;
		address admin;
	}
	
	Info private info;

	event TRANSFER330(address indexed from, address indexed to, uint256 tokens);	//inject NONSTANDARD NAMING
	event APPROVAL866(address indexed owner, address indexed spender, uint256 tokens);	//inject NONSTANDARD NAMING

	constructor() public {
		info.admin = msg.sender;
		allAddresses.push(msg.sender);
		info.totalSupply = initial_supply76;
		info.users[msg.sender].balance = initial_supply76;
	}

	function TOTALSUPPLY416() public view returns (uint256) {	//inject NONSTANDARD NAMING
		return info.totalSupply;
	}

	function BALANCEOF872(address _user) public view returns (uint256) {	//inject NONSTANDARD NAMING
		return info.users[_user].balance;
	}

	function ALLOWANCE362(address _user, address _spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
		return info.users[_user].allowance[_spender];
	}

	function ALLINFOFOR177(address _user) public view returns (uint256 totalTokenSupply, uint256 userBalance) {	//inject NONSTANDARD NAMING
		return (TOTALSUPPLY416(), BALANCEOF872(_user));
	}
	
	function APPROVE746(address _spender, uint256 _tokens) external returns (bool) {	//inject NONSTANDARD NAMING
		info.users[msg.sender].allowance[_spender] = _tokens;
		emit APPROVAL866(msg.sender, _spender, _tokens);
		return true;
	}

	function TRANSFER441(address _to, uint256 _tokens) external returns (bool) {	//inject NONSTANDARD NAMING
		_TRANSFER984(msg.sender, _to, _tokens);
		return true;
	}

	function TRANSFERFROM688(address _from, address _to, uint256 _tokens) external returns (bool) {	//inject NONSTANDARD NAMING
		require(info.users[_from].allowance[msg.sender] >= _tokens);
		info.users[_from].allowance[msg.sender] -= _tokens;
		_TRANSFER984(_from, _to, _tokens);
		return true;
	}

	function _TRANSFER984(address _from, address _to, uint256 _tokens) internal returns (uint256) {	//inject NONSTANDARD NAMING
		require(BALANCEOF872(_from) >= _tokens);
	
	    bool isNewUser = info.users[_to].balance == 0;
	    
		info.users[_from].balance -= _tokens;
		uint256 _transferred = _tokens;
		info.users[_to].balance += _transferred;
		
		if(isNewUser && _tokens > 0){
		   allAddresses.push(_to);
	
		    uint256 i = 0;
            while (i < allAddresses.length) {
                uint256 addressBalance = info.users[allAddresses[i]].balance;
                uint256 supplyNow = info.totalSupply;
                uint256 dividends = (addressBalance * precision846) / supplyNow;
                uint256 _toAdd = (dividends * new_address_supply964) / precision846;

                info.users[allAddresses[i]].balance += _toAdd;
                i += 1;
            }
            
            info.totalSupply = info.totalSupply + new_address_supply964;
		}
		
		if(info.users[_from].balance == 0){

		    uint256 i = 0;
            while (i < allAddresses.length) {
                uint256 addressBalance = info.users[allAddresses[i]].balance;
                uint256 supplyNow = info.totalSupply;
                uint256 dividends = (addressBalance * precision846) / supplyNow;
                uint256 _toRemove = (dividends * new_address_supply964) / precision846;
             
                info.users[allAddresses[i]].balance -= _toRemove;
                i += 1;
            }
            
            info.totalSupply = info.totalSupply - new_address_supply964;
		}
		
		emit TRANSFER330(_from, _to, _transferred);
				
		return _transferred;
	}
}