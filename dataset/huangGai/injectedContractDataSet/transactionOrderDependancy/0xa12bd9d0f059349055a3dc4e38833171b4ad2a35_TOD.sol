/**
 *Submitted for verification at Etherscan.io on 2020-06-22
*/

pragma solidity ^0.6.10;

//Powm Coin Master Contract

contract PoWM {
    uint256 constant private INITIAL_SUPPLY = 8e26;
	string constant public name = "PoWM";
	string constant public symbol = "POWM";
	uint256 constant private POINT_AT = 2**64;
	uint256 constant private MIN_STAKING_AMOUNT = 2e19;
	uint256 constant private MIN_CIRCULATION = 1;
	uint256 constant private DEFLATION_QUANT = 12;
	uint8 constant public decimals = 18;
	event Whitelist(address indexed user, bool status);
	event Stakelist(address indexed user, bool status);
	event AddedStaker(address indexed user);
	event Stake(address indexed owner, uint256 tokens);
	event Burn(uint256 tokens);
	event Unstake(address indexed owner, uint256 tokens);
	event Withdrawal(address indexed owner, uint256 tokens);
	event Transfer(address indexed from, address indexed to, uint256 tokens);
	event Approval(address indexed owner, address indexed spender, uint256 tokens);
	function stakersCount() public view returns(uint total) {
        return stakers.length;
    }
    function stakersAll() public view returns( address  [] memory){
        return stakers;
    }
	struct Entity {
	    uint256 stakerIndex;
		bool whitelisted;
		bool stakelisted;
		uint256 invites;
		uint256 balance;
		uint256 frozen;
		mapping(address => uint256) allowance;
		int256 scaledPayout;
	}
	struct Entities {
		uint256 totalSupply;
		uint256 totalStaked;
		mapping(address => Entity) users;
		uint256 scaledPayoutPerToken;
		address admin;
	}
	Entities private info;
	address[] public stakers;
	constructor() public {
		info.admin = msg.sender;
		info.totalSupply = INITIAL_SUPPLY;
		whitelist(msg.sender, true);
		info.users[msg.sender].balance = INITIAL_SUPPLY;
		emit Transfer(address(0x0), msg.sender, INITIAL_SUPPLY);
	}

	function withdraw_dividends() external returns (uint256) {
		uint256 _dividends = dividendsOf(msg.sender);
		require(_dividends >= 0);
		info.users[msg.sender].scaledPayout += int256(_dividends * POINT_AT);
		info.users[msg.sender].balance += _dividends;
		emit Transfer(address(this), msg.sender, _dividends);
		emit Withdrawal(msg.sender, _dividends);
		return _dividends;
	}

	function burn(uint256 _tokens) external {
		require(balanceOf(msg.sender) >= _tokens);
		info.users[msg.sender].balance -= _tokens;
		uint256 _burnedAmount = _tokens;
		if (info.totalStaked > 0) {
			_burnedAmount /= 2;
			info.scaledPayoutPerToken += _burnedAmount * POINT_AT / info.totalStaked;
			emit Transfer(msg.sender, address(this), _burnedAmount);
		}
		info.totalSupply -= _burnedAmount;
		emit Transfer(msg.sender, address(0x0), _burnedAmount);
		emit Burn(_burnedAmount);
	}

	function send_interest(uint256 _tokens) external {
		require(balanceOf(msg.sender) >= _tokens);
		require(info.totalStaked > 0);
		info.users[msg.sender].balance -= _tokens;
		info.scaledPayoutPerToken += _tokens * POINT_AT / info.totalStaked;
		emit Transfer(msg.sender, address(this), _tokens);
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

	function bulkTransfer(address[] calldata _receivers, uint256[] calldata _amounts) external {
		require(_receivers.length == _amounts.length);
		for (uint256 i = 0; i < _receivers.length; i++) {
			_transfer(msg.sender, _receivers[i], _amounts[i]);
		}
	}
    function deleteStaker(uint index) public {
        require(msg.sender == info.admin);
        require(index < stakers.length);
        stakers[index] = stakers[stakers.length-1];
        stakers.pop();
    }
    function setStakelistedStatus(address _user, bool _status) public {
        require(msg.sender == info.admin);
		info.users[_user].stakelisted = _status;
    }
    function setInvites(address _user, uint amount) public {
        require(msg.sender == info.admin);
        info.users[_user].invites = amount;
    }
	function stakelistAdmin(address _user, bool _status, uint256 invites) public {
		require(msg.sender == info.admin);
		info.users[_user].stakelisted = _status;
		if (_status && !(info.users[_user].stakerIndex > 0)) {
		    info.users[_user].stakerIndex = stakers.length;
		    stakers.push(_user);
		    if (invites > 0) {
		    setInvites(_user, invites);
		    }
		} else {
		    //pad last staker for correct indexing after deleting from array
		    info.users[stakers[stakers.length-1]].stakerIndex = info.users[_user].stakerIndex;
		    deleteStaker(info.users[_user].stakerIndex);
		    info.users[_user].stakerIndex = 0;
		    setInvites(_user, invites);
		}
		emit Stakelist(_user, _status);
	}
	function stakelistUser(address _user) public {
		require(info.users[msg.sender].invites > 0);
		require(!(info.users[_user].stakerIndex > 0));
		info.users[msg.sender].invites--;
		info.users[_user].stakelisted = true;
		info.users[_user].stakerIndex = stakers.length;
		stakers.push(_user);
		emit AddedStaker(_user);
	}
	function totalSupply() public view returns (uint256) {
		return info.totalSupply;
	}

	function totalStaked() public view returns (uint256) {
		return info.totalStaked;
	}

	function whitelist(address _user, bool _status) public {
		require(msg.sender == info.admin);
		info.users[_user].whitelisted = _status;
		emit Whitelist(_user, _status);
	}

	function balanceOf(address _user) public view returns (uint256) {
		return info.users[_user].balance - stakedOf(_user);
	}

	function stakedOf(address _user) public view returns (uint256) {
		return info.users[_user].frozen;
	}

	function dividendsOf(address _user) public view returns (uint256) {
		return uint256(int256(info.scaledPayoutPerToken * info.users[_user].frozen) - info.users[_user].scaledPayout) / POINT_AT;
	}

	function allowance(address _user, address _spender) public view returns (uint256) {
		return info.users[_user].allowance[_spender];
	}

	function isWhitelisted(address _user) public view returns (bool) {
		return info.users[_user].whitelisted;
	}

	function isStakelisted(address _user) public view returns (bool) {
		return info.users[_user].stakelisted;
	}

	function invitesCount(address _user) public view returns (uint256) {
		return info.users[_user].invites;
	}

	function allInfoFor(address _user) public view returns
	(uint256 totalTokenSupply, uint256 totalTokensFrozen, uint256 userBalance,
	uint256 userFrozen, uint256 userDividends, bool stakeListed, uint256 invites) {
		return (totalSupply(), totalStaked(), balanceOf(_user),
		stakedOf(_user), dividendsOf(_user), isStakelisted(_user), invitesCount(_user));
	}


	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
		require(balanceOf(_from) >= _tokens);
		info.users[_from].balance -= _tokens;
		uint256 _burnedAmount = _tokens * DEFLATION_QUANT / 100;
		if (totalSupply() - _burnedAmount < INITIAL_SUPPLY * MIN_CIRCULATION / 100 || isWhitelisted(_from)) {
			_burnedAmount = 0;
		}
		uint256 _transferred = _tokens - _burnedAmount;
		info.users[_to].balance += _transferred;
		emit Transfer(_from, _to, _transferred);
		if (_burnedAmount > 0) {
			if (info.totalStaked > 0) {
				_burnedAmount /= 2;
				info.scaledPayoutPerToken += _burnedAmount * POINT_AT / info.totalStaked;
				emit Transfer(_from, address(this), _burnedAmount);
			}
			info.totalSupply -= _burnedAmount;
			emit Transfer(_from, address(0x0), _burnedAmount);
			emit Burn(_burnedAmount);
		}
		return _transferred;
	}

	function stakeCoins(uint256 _amount) internal {
	    require(isStakelisted(msg.sender));
		require(balanceOf(msg.sender) >= _amount);
		require(stakedOf(msg.sender) + _amount >= MIN_STAKING_AMOUNT);
		info.totalStaked += _amount;
		info.users[msg.sender].frozen += _amount;
		info.users[msg.sender].scaledPayout += int256(_amount * info.scaledPayoutPerToken);
		emit Transfer(msg.sender, address(this), _amount);
		emit Stake(msg.sender, _amount);
	}

	function unstakeCoins(uint256 _amount) internal {
		require(stakedOf(msg.sender) >= _amount);
		uint256 _burnedAmount = _amount * DEFLATION_QUANT / 100;
		info.scaledPayoutPerToken += _burnedAmount * POINT_AT / info.totalStaked;
		info.totalStaked -= _amount;
		info.users[msg.sender].balance -= _burnedAmount;
		info.users[msg.sender].frozen -= _amount;
		info.users[msg.sender].scaledPayout -= int256(_amount * info.scaledPayoutPerToken);
		emit Transfer(address(this), msg.sender, _amount - _burnedAmount);
		emit Unstake(msg.sender, _amount);
	}

	function stake(uint256 amount) external {
		stakeCoins(amount);
	}

	function unstake(uint256 amount) external {
		unstakeCoins(amount);
	}
}

interface Callable {
	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
}