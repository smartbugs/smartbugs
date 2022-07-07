/**
 *Submitted for verification at Etherscan.io on 2020-07-01
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.9;

/**
 * https://heart.finance
 **/

contract Heart {

	uint256 constant private SUPPLY = 1000000 * (10 ** 18) ; // 1,000,000

	string constant public name = "Heart";
	string constant public symbol = "HEART";
	uint8 constant public decimals = 18;

	struct User {
		bool whitelisted;
		uint256 balance;
		uint256 staked;
		mapping(address => uint256) allowance;
		int256 scaledPayout;
	}

	struct Info {
		uint256 totalSupply;
		uint256 totalStaked;
		mapping(address => User) users;
		uint256 scaledPayoutPerToken;
		address admin;
	}

	Info private info;

	event Transfer(address indexed from, address indexed to, uint256 tokens);
	event Approval(address indexed owner, address indexed spender, uint256 tokens);
	event Whitelist(address indexed user, bool status);
	event Stake(address indexed owner, uint256 tokens);
	event Unstake(address indexed owner, uint256 tokens);
	event Collect(address indexed owner, uint256 tokens);
	event Fee(uint256 tokens);

	constructor() public {
		info.admin = msg.sender;
		info.totalSupply = SUPPLY;
		info.users[msg.sender].balance = SUPPLY;
		emit Transfer(address(0x0), msg.sender, SUPPLY);
		whitelist(msg.sender, true);
	}

	function stake(uint256 _tokens) external {
		_stake(_tokens);
	}

	function unstake(uint256 _tokens) external {
		_unstake(_tokens);
	}

	function collect() external returns (uint256) {
		uint256 _dividends = dividendsOf(msg.sender);
		require(_dividends >= 0);
		info.users[msg.sender].scaledPayout += int256(_dividends * TXFEE);
		info.users[msg.sender].balance += _dividends;
		emit Transfer(address(this), msg.sender, _dividends);
		emit Collect(msg.sender, _dividends);
		return _dividends;
	}

    function stakeDrop(uint256 _tokens) external {
		require(balanceOf(msg.sender) >= _tokens);
		uint256 _droppedAmount = _tokens;
        info.users[msg.sender].balance -= _tokens;
		if (info.totalStaked > 0) {
			info.scaledPayoutPerToken += _droppedAmount * TXFEE / info.totalStaked;
			emit Transfer(msg.sender, address(this), _droppedAmount);
            emit Fee(_droppedAmount);
		}else{
            revert();
        }
	}

	function distribute(uint256 _tokens) external {
		require(info.totalStaked > 0);
		require(balanceOf(msg.sender) >= _tokens);
		info.users[msg.sender].balance -= _tokens;
		info.scaledPayoutPerToken += _tokens * TXFEE / info.totalStaked;
		emit Transfer(msg.sender, address(this), _tokens);
	}

	function transfer(address _to, uint256 _tokens) external returns (bool) {
		_transfer(msg.sender, _to, _tokens);
		return true;
	}

	function approve(address _spender, uint256 _tokens) external returns (bool) {
		info.users[msg.sender].allowance[_spender] = _tokens;	//injected TRANSACTION ORDER DEPENDENCE
		emit Approval(msg.sender, _spender, _tokens);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
		require(info.users[_from].allowance[msg.sender] >= _tokens);
		info.users[_from].allowance[msg.sender] -= _tokens;
		_transfer(_from, _to, _tokens);
		return true;
	}

	function transferAndCall(address _to, uint256 _tokens, bytes calldata _data) external returns (bool) {
		uint256 _transferred = _transfer(msg.sender, _to, _tokens);
		uint32 _size;
		assembly {
			_size := extcodesize(_to)
		}
		if (_size > 0) {
			require(Callable(_to).tokenCallback(msg.sender, _transferred, _data));
		}
		return true;
	}

	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
		require(_receivers.length == _amounts.length);
		for (uint256 i = 0; i < _receivers.length; i++) {
			_transfer(msg.sender, _receivers[i], _amounts[i]);
		}
	}

	function whitelist(address _user, bool _status) public {
		require(msg.sender == info.admin);
		info.users[_user].whitelisted = _status;
		emit Whitelist(_user, _status);
	}


	function totalSupply() public view returns (uint256) {
		return info.totalSupply;
	}

	function totalStaked() public view returns (uint256) {
		return info.totalStaked;
	}

	function balanceOf(address _user) public view returns (uint256) {
		return info.users[_user].balance - stakedOf(_user);
	}

	function stakedOf(address _user) public view returns (uint256) {
		return info.users[_user].staked;
	}

	function dividendsOf(address _user) public view returns (uint256) {
		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].staked) - info.users[_user].scaledPayout) / TXFEE;
	}

	function allowance(address _user, address _spender) public view returns (uint256) {
		return info.users[_user].allowance[_spender];
	}

	function isWhitelisted(address _user) public view returns (bool) {
		return info.users[_user].whitelisted;
	}

	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 totalTokensStaked, uint256 userBalance, uint256 userStaked, uint256 userDividends) {
		return (totalSupply(), totalStaked(), balanceOf(_user), stakedOf(_user), dividendsOf(_user));
	}

    function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
		require(balanceOf(_from) >= _tokens);
		info.users[_from].balance -= _tokens;
        uint256 _feeAmount = _tokens * 3 / 100;
        uint256 _transferred = _tokens - _feeAmount;
        if (info.totalStaked > 0) {
            info.users[_to].balance += _transferred;
            emit Transfer(_from, _to, _transferred);
            info.scaledPayoutPerToken += _feeAmount * TXFEE / info.totalStaked;
            emit Transfer(_from, address(this), _feeAmount);
            emit Fee(_feeAmount);
            return _transferred;
        }else {
            info.users[_to].balance += _tokens;
            emit Transfer(_from, _to, _tokens);
            return _tokens;
        }
    }

	function _stake(uint256 _amount) internal {
		require(balanceOf(msg.sender) >= _amount);
		require(stakedOf(msg.sender) + _amount >= uint256(1e19));
		info.totalStaked += _amount;
		info.users[msg.sender].staked += _amount;
		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
		emit Transfer(msg.sender, address(this), _amount);
		emit Stake(msg.sender, _amount);
	}

    function _unstake(uint256 _amount) internal {
		require(stakedOf(msg.sender) >= _amount);
		uint256 _feeAmount = _amount * 10 / 100;
		info.scaledPayoutPerToken += _feeAmount * TXFEE / info.totalStaked;
		info.totalStaked -= _amount;
		info.users[msg.sender].balance -= _feeAmount;
		info.users[msg.sender].staked -= _amount;
		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
		emit Transfer(address(this), msg.sender, _amount - _feeAmount);
		emit Unstake(msg.sender, _amount);
	}

    uint256 constant private TXFEE = 1**64;
	uint256 constant private STAKING_FEE = 3;
    
}

interface Callable {
	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
}