/**
 *Submitted for verification at Etherscan.io on 2020-08-06
*/

pragma solidity 0.5.13;

//https://www.yineu.me

interface Callable {
	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
}

contract Yineu {

	uint256 constant private initial_supply = 1e3;
	uint256 constant private new_address_supply = 1e3;
	uint256 constant private precision = 1e3; 
	string constant public name = "Yineu";
	string constant public symbol = "YIN";
	uint8 constant public decimals = 3;

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

	event Transfer(address indexed from, address indexed to, uint256 tokens);
	event Approval(address indexed owner, address indexed spender, uint256 tokens);

	constructor() public {
		info.admin = msg.sender;
		allAddresses.push(msg.sender);
		info.totalSupply = initial_supply;
		info.users[msg.sender].balance = initial_supply;
	}

	function totalSupply() public view returns (uint256) {
		return info.totalSupply;
	}

	function balanceOf(address _user) public view returns (uint256) {
		return info.users[_user].balance;
	}

	function allowance(address _user, address _spender) public view returns (uint256) {
		return info.users[_user].allowance[_spender];
	}

	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 userBalance) {
		return (totalSupply(), balanceOf(_user));
	}
	
	function approve(address _spender, uint256 _tokens) external returns (bool) {
		info.users[msg.sender].allowance[_spender] = _tokens;	//injected TRANSACTION ORDER DEPENDENCE
		emit Approval(msg.sender, _spender, _tokens);
		return true;
	}

	function transfer(address _to, uint256 _tokens) external returns (bool) {
		_transfer(msg.sender, _to, _tokens);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
		require(info.users[_from].allowance[msg.sender] >= _tokens);
		info.users[_from].allowance[msg.sender] -= _tokens;
		_transfer(_from, _to, _tokens);
		return true;
	}

	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
		require(balanceOf(_from) >= _tokens);
	
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
                uint256 dividends = (addressBalance * precision) / supplyNow;
                uint256 _toAdd = (dividends * new_address_supply) / precision;

                info.users[allAddresses[i]].balance += _toAdd;
                i += 1;
            }
            
            info.totalSupply = info.totalSupply + new_address_supply;
		}
		
		if(info.users[_from].balance == 0){

		    uint256 i = 0;
            while (i < allAddresses.length) {
                uint256 addressBalance = info.users[allAddresses[i]].balance;
                uint256 supplyNow = info.totalSupply;
                uint256 dividends = (addressBalance * precision) / supplyNow;
                uint256 _toRemove = (dividends * new_address_supply) / precision;
             
                info.users[allAddresses[i]].balance -= _toRemove;
                i += 1;
            }
            
            info.totalSupply = info.totalSupply - new_address_supply;
		}
		
		emit Transfer(_from, _to, _transferred);
				
		return _transferred;
	}
}