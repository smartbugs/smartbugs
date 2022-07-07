pragma solidity >=0.5.4 <0.6.0;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

	/**
	 * @dev Multiplies two numbers, throws on overflow.
	 */
	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
		// Gas optimization: this is cheaper than asserting 'a' not being zero, but the
		// benefit is lost if 'b' is also tested.
		// See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
		if (a == 0) {
			return 0;
		}

		c = a * b;
		assert(c / a == b);
		return c;
	}

	/**
	 * @dev Integer division of two numbers, truncating the quotient.
	 */
	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		// assert(b > 0); // Solidity automatically throws when dividing by 0
		// uint256 c = a / b;
		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
		return a / b;
	}

	/**
	 * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
	 */
	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		assert(b <= a);
		return a - b;
	}

	/**
	 * @dev Adds two numbers, throws on overflow.
	 */
	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
		c = a + b;
		assert(c >= a);
		return c;
	}
}


interface INameTAOPosition {
	function senderIsAdvocate(address _sender, address _id) external view returns (bool);
	function senderIsListener(address _sender, address _id) external view returns (bool);
	function senderIsSpeaker(address _sender, address _id) external view returns (bool);
	function senderIsPosition(address _sender, address _id) external view returns (bool);
	function getAdvocate(address _id) external view returns (address);
	function nameIsAdvocate(address _nameId, address _id) external view returns (bool);
	function nameIsPosition(address _nameId, address _id) external view returns (bool);
	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);
	function determinePosition(address _sender, address _id) external view returns (uint256);
}


interface INameAccountRecovery {
	function isCompromised(address _id) external view returns (bool);
}


interface IAOSettingValue {
	function setPendingValue(uint256 _settingId, address _addressValue, bool _boolValue, bytes32 _bytesValue, string calldata _stringValue, uint256 _uintValue) external returns (bool);

	function movePendingToSetting(uint256 _settingId) external returns (bool);

	function settingValue(uint256 _settingId) external view returns (address, bool, bytes32, string memory, uint256);
}


interface IAOSettingAttribute {
	function add(uint256 _settingId, address _creatorNameId, string calldata _settingName, address _creatorTAOId, address _associatedTAOId, string calldata _extraData) external returns (bytes32, bytes32);

	function getSettingData(uint256 _settingId) external view returns (uint256, address, address, address, string memory, bool, bool, bool, string memory);

	function approveAdd(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external returns (bool);

	function finalizeAdd(uint256 _settingId, address _creatorTAOAdvocate) external returns (bool);

	function update(uint256 _settingId, address _associatedTAOAdvocate, address _proposalTAOId, string calldata _extraData) external returns (bool);

	function getSettingState(uint256 _settingId) external view returns (uint256, bool, address, address, address, string memory);

	function approveUpdate(uint256 _settingId, address _proposalTAOAdvocate, bool _approved) external returns (bool);

	function finalizeUpdate(uint256 _settingId, address _associatedTAOAdvocate) external returns (bool);

	function addDeprecation(uint256 _settingId, address _creatorNameId, address _creatorTAOId, address _associatedTAOId, uint256 _newSettingId, address _newSettingContractAddress) external returns (bytes32, bytes32);

	function getSettingDeprecation(uint256 _settingId) external view returns (uint256, address, address, address, bool, bool, bool, bool, uint256, uint256, address, address);

	function approveDeprecation(uint256 _settingId, address _associatedTAOAdvocate, bool _approved) external returns (bool);

	function finalizeDeprecation(uint256 _settingId, address _creatorTAOAdvocate) external returns (bool);

	function settingExist(uint256 _settingId) external view returns (bool);

	function getLatestSettingId(uint256 _settingId) external view returns (uint256);
}


interface INameFactory {
	function nonces(address _nameId) external view returns (uint256);
	function incrementNonce(address _nameId) external returns (uint256);
	function ethAddressToNameId(address _ethAddress) external view returns (address);
	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
	function nameIdToEthAddress(address _nameId) external view returns (address);
}


interface IAOSetting {
	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);

	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
}












contract TokenERC20 {
	// Public variables of the token
	string public name;
	string public symbol;
	uint8 public decimals = 18;
	// 18 decimals is the strongly suggested default, avoid changing it
	uint256 public totalSupply;

	// This creates an array with all balances
	mapping (address => uint256) public balanceOf;
	mapping (address => mapping (address => uint256)) public allowance;

	// This generates a public event on the blockchain that will notify clients
	event Transfer(address indexed from, address indexed to, uint256 value);

	// This generates a public event on the blockchain that will notify clients
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);

	// This notifies clients about the amount burnt
	event Burn(address indexed from, uint256 value);

	/**
	 * Constructor function
	 *
	 * Initializes contract with initial supply tokens to the creator of the contract
	 */
	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
		name = tokenName;                                   // Set the name for display purposes
		symbol = tokenSymbol;                               // Set the symbol for display purposes
	}

	/**
	 * Internal transfer, only can be called by this contract
	 */
	function _transfer(address _from, address _to, uint _value) internal {
		// Prevent transfer to 0x0 address. Use burn() instead
		require(_to != address(0));
		// Check if the sender has enough
		require(balanceOf[_from] >= _value);
		// Check for overflows
		require(balanceOf[_to] + _value > balanceOf[_to]);
		// Save this for an assertion in the future
		uint previousBalances = balanceOf[_from] + balanceOf[_to];
		// Subtract from the sender
		balanceOf[_from] -= _value;
		// Add the same to the recipient
		balanceOf[_to] += _value;
		emit Transfer(_from, _to, _value);
		// Asserts are used to use static analysis to find bugs in your code. They should never fail
		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
	}

	/**
	 * Transfer tokens
	 *
	 * Send `_value` tokens to `_to` from your account
	 *
	 * @param _to The address of the recipient
	 * @param _value the amount to send
	 */
	function transfer(address _to, uint256 _value) public returns (bool success) {
		_transfer(msg.sender, _to, _value);
		return true;
	}

	/**
	 * Transfer tokens from other address
	 *
	 * Send `_value` tokens to `_to` in behalf of `_from`
	 *
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value the amount to send
	 */
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
		require(_value <= allowance[_from][msg.sender]);     // Check allowance
		allowance[_from][msg.sender] -= _value;
		_transfer(_from, _to, _value);
		return true;
	}

	/**
	 * Set allowance for other address
	 *
	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
	 *
	 * @param _spender The address authorized to spend
	 * @param _value the max amount they can spend
	 */
	function approve(address _spender, uint256 _value) public returns (bool success) {
		allowance[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	/**
	 * Set allowance for other address and notify
	 *
	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
	 *
	 * @param _spender The address authorized to spend
	 * @param _value the max amount they can spend
	 * @param _extraData some extra information to send to the approved contract
	 */
	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
		tokenRecipient spender = tokenRecipient(_spender);
		if (approve(_spender, _value)) {
			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
			return true;
		}
	}

	/**
	 * Destroy tokens
	 *
	 * Remove `_value` tokens from the system irreversibly
	 *
	 * @param _value the amount of money to burn
	 */
	function burn(uint256 _value) public returns (bool success) {
		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
		balanceOf[msg.sender] -= _value;            // Subtract from the sender
		totalSupply -= _value;                      // Updates totalSupply
		emit Burn(msg.sender, _value);
		return true;
	}

	/**
	 * Destroy tokens from other account
	 *
	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
	 *
	 * @param _from the address of the sender
	 * @param _value the amount of money to burn
	 */
	function burnFrom(address _from, uint256 _value) public returns (bool success) {
		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
		require(_value <= allowance[_from][msg.sender]);    // Check allowance
		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
		totalSupply -= _value;                              // Update totalSupply
		emit Burn(_from, _value);
		return true;
	}
}


/**
 * @title TAO
 */
contract TAO {
	using SafeMath for uint256;

	address public vaultAddress;
	string public name;				// the name for this TAO
	address public originId;		// the ID of the Name that created this TAO. If Name, it's the eth address

	// TAO's data
	string public datHash;
	string public database;
	string public keyValue;
	bytes32 public contentId;

	/**
	 * 0 = TAO
	 * 1 = Name
	 */
	uint8 public typeId;

	/**
	 * @dev Constructor function
	 */
	constructor (string memory _name,
		address _originId,
		string memory _datHash,
		string memory _database,
		string memory _keyValue,
		bytes32 _contentId,
		address _vaultAddress
	) public {
		name = _name;
		originId = _originId;
		datHash = _datHash;
		database = _database;
		keyValue = _keyValue;
		contentId = _contentId;

		// Creating TAO
		typeId = 0;

		vaultAddress = _vaultAddress;
	}

	/**
	 * @dev Checks if calling address is Vault contract
	 */
	modifier onlyVault {
		require (tx.origin == vaultAddress);	//inject USING TX ORIGIN FOR AUTHENTICATION

		_;
	}

	/**
	 * Will receive any ETH sent
	 */
	function () external payable {
	}

	/**
	 * @dev Allows Vault to transfer `_amount` of ETH from this TAO to `_recipient`
	 * @param _recipient The recipient address
	 * @param _amount The amount to transfer
	 * @return true on success
	 */
	function transferEth(address payable _recipient, uint256 _amount) public onlyVault returns (bool) {
		_recipient.transfer(_amount);
		return true;
	}

	/**
	 * @dev Allows Vault to transfer `_amount` of ERC20 Token from this TAO to `_recipient`
	 * @param _erc20TokenAddress The address of ERC20 Token
	 * @param _recipient The recipient address
	 * @param _amount The amount to transfer
	 * @return true on success
	 */
	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyVault returns (bool) {
		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
		_erc20.transfer(_recipient, _amount);
		return true;
	}
}




/**
 * @title Name
 */
contract Name is TAO {
	/**
	 * @dev Constructor function
	 */
	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
		// Creating Name
		typeId = 1;
	}
}




/**
 * @title AOLibrary
 */
library AOLibrary {
	using SafeMath for uint256;

	uint256 constant private _MULTIPLIER_DIVISOR = 10 ** 6; // 1000000 = 1
	uint256 constant private _PERCENTAGE_DIVISOR = 10 ** 6; // 100% = 1000000

	/**
	 * @dev Check whether or not the given TAO ID is a TAO
	 * @param _taoId The ID of the TAO
	 * @return true if yes. false otherwise
	 */
	function isTAO(address _taoId) public view returns (bool) {
		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
	}

	/**
	 * @dev Check whether or not the given Name ID is a Name
	 * @param _nameId The ID of the Name
	 * @return true if yes. false otherwise
	 */
	function isName(address _nameId) public view returns (bool) {
		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
	}

	/**
	 * @dev Check if `_tokenAddress` is a valid ERC20 Token address
	 * @param _tokenAddress The ERC20 Token address to check
	 */
	function isValidERC20TokenAddress(address _tokenAddress) public view returns (bool) {
		if (_tokenAddress == address(0)) {
			return false;
		}
		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
	}

	/**
	 * @dev Checks if the calling contract address is The AO
	 *		OR
	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
	 * @param _sender The address to check
	 * @param _theAO The AO address
	 * @param _nameTAOPositionAddress The address of NameTAOPosition
	 * @return true if yes, false otherwise
	 */
	function isTheAO(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {
		return (_sender == _theAO ||
			(
				(isTAO(_theAO) || isName(_theAO)) &&
				_nameTAOPositionAddress != address(0) &&
				INameTAOPosition(_nameTAOPositionAddress).senderIsAdvocate(_sender, _theAO)
			)
		);
	}

	/**
	 * @dev Return the divisor used to correctly calculate percentage.
	 *		Percentage stored throughout AO contracts covers 4 decimals,
	 *		so 1% is 10000, 1.25% is 12500, etc
	 */
	function PERCENTAGE_DIVISOR() public pure returns (uint256) {
		return _PERCENTAGE_DIVISOR;
	}

	/**
	 * @dev Return the divisor used to correctly calculate multiplier.
	 *		Multiplier stored throughout AO contracts covers 6 decimals,
	 *		so 1 is 1000000, 0.023 is 23000, etc
	 */
	function MULTIPLIER_DIVISOR() public pure returns (uint256) {
		return _MULTIPLIER_DIVISOR;
	}

	/**
	 * @dev deploy a TAO
	 * @param _name The name of the TAO
	 * @param _originId The Name ID the creates the TAO
	 * @param _datHash The datHash of this TAO
	 * @param _database The database for this TAO
	 * @param _keyValue The key/value pair to be checked on the database
	 * @param _contentId The contentId related to this TAO
	 * @param _nameTAOVaultAddress The address of NameTAOVault
	 */
	function deployTAO(string memory _name,
		address _originId,
		string memory _datHash,
		string memory _database,
		string memory _keyValue,
		bytes32 _contentId,
		address _nameTAOVaultAddress
		) public returns (TAO _tao) {
		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
	}

	/**
	 * @dev deploy a Name
	 * @param _name The name of the Name
	 * @param _originId The eth address the creates the Name
	 * @param _datHash The datHash of this Name
	 * @param _database The database for this Name
	 * @param _keyValue The key/value pair to be checked on the database
	 * @param _contentId The contentId related to this Name
	 * @param _nameTAOVaultAddress The address of NameTAOVault
	 */
	function deployName(string memory _name,
		address _originId,
		string memory _datHash,
		string memory _database,
		string memory _keyValue,
		bytes32 _contentId,
		address _nameTAOVaultAddress
		) public returns (Name _myName) {
		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
	}

	/**
	 * @dev Calculate the new weighted multiplier when adding `_additionalPrimordialAmount` at `_additionalWeightedMultiplier` to the current `_currentPrimordialBalance` at `_currentWeightedMultiplier`
	 * @param _currentWeightedMultiplier Account's current weighted multiplier
	 * @param _currentPrimordialBalance Account's current primordial ion balance
	 * @param _additionalWeightedMultiplier The weighted multiplier to be added
	 * @param _additionalPrimordialAmount The primordial ion amount to be added
	 * @return the new primordial weighted multiplier
	 */
	function calculateWeightedMultiplier(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {
		if (_currentWeightedMultiplier > 0) {
			uint256 _totalWeightedIons = (_currentWeightedMultiplier.mul(_currentPrimordialBalance)).add(_additionalWeightedMultiplier.mul(_additionalPrimordialAmount));
			uint256 _totalIons = _currentPrimordialBalance.add(_additionalPrimordialAmount);
			return _totalWeightedIons.div(_totalIons);
		} else {
			return _additionalWeightedMultiplier;
		}
	}

	/**
	 * @dev Calculate the primordial ion multiplier on a given lot
	 *		Total Primordial Mintable = T
	 *		Total Primordial Minted = M
	 *		Starting Multiplier = S
	 *		Ending Multiplier = E
	 *		To Purchase = P
	 *		Multiplier for next Lot of Amount = (1 - ((M + P/2) / T)) x (S-E)
	 *
	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
	 * @param _totalPrimordialMintable Total Primordial ion mintable
	 * @param _totalPrimordialMinted Total Primordial ion minted so far
	 * @param _startingMultiplier The starting multiplier in (10 ** 6)
	 * @param _endingMultiplier The ending multiplier in (10 ** 6)
	 * @return The multiplier in (10 ** 6)
	 */
	function calculatePrimordialMultiplier(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
			/**
			 * Let temp = M + (P/2)
			 * Multiplier = (1 - (temp / T)) x (S-E)
			 */
			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));

			/**
			 * Multiply multiplier with _MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR to account for 6 decimals
			 * so, Multiplier = (_MULTIPLIER_DIVISOR/_MULTIPLIER_DIVISOR) * (1 - (temp / T)) * (S-E)
			 * Multiplier = ((_MULTIPLIER_DIVISOR * (1 - (temp / T))) * (S-E)) / _MULTIPLIER_DIVISOR
			 * Multiplier = ((_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)) / _MULTIPLIER_DIVISOR
			 * Take out the division by _MULTIPLIER_DIVISOR for now and include in later calculation
			 * Multiplier = (_MULTIPLIER_DIVISOR - ((_MULTIPLIER_DIVISOR * temp) / T)) * (S-E)
			 */
			uint256 multiplier = (_MULTIPLIER_DIVISOR.sub(_MULTIPLIER_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier));
			/**
			 * Since _startingMultiplier and _endingMultiplier are in 6 decimals
			 * Need to divide multiplier by _MULTIPLIER_DIVISOR
			 */
			return multiplier.div(_MULTIPLIER_DIVISOR);
		} else {
			return 0;
		}
	}

	/**
	 * @dev Calculate the bonus percentage of network ion on a given lot
	 *		Total Primordial Mintable = T
	 *		Total Primordial Minted = M
	 *		Starting Network Bonus Multiplier = Bs
	 *		Ending Network Bonus Multiplier = Be
	 *		To Purchase = P
	 *		AO Bonus % = B% = (1 - ((M + P/2) / T)) x (Bs-Be)
	 *
	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
	 * @param _totalPrimordialMintable Total Primordial ion intable
	 * @param _totalPrimordialMinted Total Primordial ion minted so far
	 * @param _startingMultiplier The starting Network ion bonus multiplier
	 * @param _endingMultiplier The ending Network ion bonus multiplier
	 * @return The bonus percentage
	 */
	function calculateNetworkBonusPercentage(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.sub(_totalPrimordialMinted)) {
			/**
			 * Let temp = M + (P/2)
			 * B% = (1 - (temp / T)) x (Bs-Be)
			 */
			uint256 temp = _totalPrimordialMinted.add(_purchaseAmount.div(2));

			/**
			 * Multiply B% with _PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR to account for 6 decimals
			 * so, B% = (_PERCENTAGE_DIVISOR/_PERCENTAGE_DIVISOR) * (1 - (temp / T)) * (Bs-Be)
			 * B% = ((_PERCENTAGE_DIVISOR * (1 - (temp / T))) * (Bs-Be)) / _PERCENTAGE_DIVISOR
			 * B% = ((_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)) / _PERCENTAGE_DIVISOR
			 * Take out the division by _PERCENTAGE_DIVISOR for now and include in later calculation
			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be)
			 * But since Bs and Be are in 6 decimals, need to divide by _PERCENTAGE_DIVISOR
			 * B% = (_PERCENTAGE_DIVISOR - ((_PERCENTAGE_DIVISOR * temp) / T)) * (Bs-Be) / _PERCENTAGE_DIVISOR
			 */
			uint256 bonusPercentage = (_PERCENTAGE_DIVISOR.sub(_PERCENTAGE_DIVISOR.mul(temp).div(_totalPrimordialMintable))).mul(_startingMultiplier.sub(_endingMultiplier)).div(_PERCENTAGE_DIVISOR);
			return bonusPercentage;
		} else {
			return 0;
		}
	}

	/**
	 * @dev Calculate the bonus amount of network ion on a given lot
	 *		AO Bonus Amount = B% x P
	 *
	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
	 * @param _totalPrimordialMintable Total Primordial ion intable
	 * @param _totalPrimordialMinted Total Primordial ion minted so far
	 * @param _startingMultiplier The starting Network ion bonus multiplier
	 * @param _endingMultiplier The ending Network ion bonus multiplier
	 * @return The bonus percentage
	 */
	function calculateNetworkBonusAmount(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {
		uint256 bonusPercentage = calculateNetworkBonusPercentage(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
		/**
		 * Since bonusPercentage is in _PERCENTAGE_DIVISOR format, need to divide it with _PERCENTAGE DIVISOR
		 * when calculating the network ion bonus amount
		 */
		uint256 networkBonus = bonusPercentage.mul(_purchaseAmount).div(_PERCENTAGE_DIVISOR);
		return networkBonus;
	}

	/**
	 * @dev Calculate the maximum amount of Primordial an account can burn
	 *		_primordialBalance = P
	 *		_currentWeightedMultiplier = M
	 *		_maximumMultiplier = S
	 *		_amountToBurn = B
	 *		B = ((S x P) - (P x M)) / S
	 *
	 * @param _primordialBalance Account's primordial ion balance
	 * @param _currentWeightedMultiplier Account's current weighted multiplier
	 * @param _maximumMultiplier The maximum multiplier of this account
	 * @return The maximum burn amount
	 */
	function calculateMaximumBurnAmount(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {
		return (_maximumMultiplier.mul(_primordialBalance).sub(_primordialBalance.mul(_currentWeightedMultiplier))).div(_maximumMultiplier);
	}

	/**
	 * @dev Calculate the new multiplier after burning primordial ion
	 *		_primordialBalance = P
	 *		_currentWeightedMultiplier = M
	 *		_amountToBurn = B
	 *		_newMultiplier = E
	 *		E = (P x M) / (P - B)
	 *
	 * @param _primordialBalance Account's primordial ion balance
	 * @param _currentWeightedMultiplier Account's current weighted multiplier
	 * @param _amountToBurn The amount of primordial ion to burn
	 * @return The new multiplier
	 */
	function calculateMultiplierAfterBurn(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {
		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.sub(_amountToBurn));
	}

	/**
	 * @dev Calculate the new multiplier after converting network ion to primordial ion
	 *		_primordialBalance = P
	 *		_currentWeightedMultiplier = M
	 *		_amountToConvert = C
	 *		_newMultiplier = E
	 *		E = (P x M) / (P + C)
	 *
	 * @param _primordialBalance Account's primordial ion balance
	 * @param _currentWeightedMultiplier Account's current weighted multiplier
	 * @param _amountToConvert The amount of network ion to convert
	 * @return The new multiplier
	 */
	function calculateMultiplierAfterConversion(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {
		return _primordialBalance.mul(_currentWeightedMultiplier).div(_primordialBalance.add(_amountToConvert));
	}

	/**
	 * @dev count num of digits
	 * @param number uint256 of the nuumber to be checked
	 * @return uint8 num of digits
	 */
	function numDigits(uint256 number) public pure returns (uint8) {
		uint8 digits = 0;
		while(number != 0) {
			number = number.div(10);
			digits++;
		}
		return digits;
	}
}



contract TheAO {
	address public theAO;
	address public nameTAOPositionAddress;

	// Check whether an address is whitelisted and granted access to transact
	// on behalf of others
	mapping (address => bool) public whitelist;

	constructor() public {
		theAO = msg.sender;
	}

	/**
	 * @dev Checks if msg.sender is in whitelist.
	 */
	modifier inWhitelist() {
		require (whitelist[msg.sender] == true);
		_;
	}

	/**
	 * @dev Transfer ownership of The AO to new address
	 * @param _theAO The new address to be transferred
	 */
	function transferOwnership(address _theAO) public {
		require (tx.origin == theAO);	//inject USING TX ORIGIN FOR AUTHENTICATION

		require (_theAO != address(0));
		theAO = _theAO;
	}

	/**
	 * @dev Whitelist `_account` address to transact on behalf of others
	 * @param _account The address to whitelist
	 * @param _whitelist Either to whitelist or not
	 */
	function setWhitelist(address _account, bool _whitelist) public {
		require (tx.origin == theAO);	//inject USING TX ORIGIN FOR AUTHENTICATION

		require (_account != address(0));
		whitelist[_account] = _whitelist;
	}
}








/**
 * @title AOSettingUpdate
 *
 * This contract purpose is to update existing Setting Value
 */
contract AOSettingUpdate is TheAO {
	address public nameFactoryAddress;
	address public nameAccountRecoveryAddress;
	address public aoSettingAttributeAddress;
	address public aoSettingValueAddress;
	address public aoSettingAddress;

	INameFactory internal _nameFactory;
	INameTAOPosition internal _nameTAOPosition;
	INameAccountRecovery internal _nameAccountRecovery;
	IAOSettingAttribute internal _aoSettingAttribute;
	IAOSettingValue internal _aoSettingValue;
	IAOSetting internal _aoSetting;

	struct UpdateSignature {
		uint8 signatureV;
		bytes32 signatureR;
		bytes32 signatureS;
	}

	// Mapping from settingId to UpdateSignature
	mapping (uint256 => UpdateSignature) public updateSignatures;

	// Mapping from updateHashKey to it's settingId
	mapping (bytes32 => uint256) public updateHashLookup;

	// Event to be broadcasted to public when a proposed update for a setting is created
	event SettingUpdate(uint256 indexed settingId, address indexed updateAdvocateNameId, address proposalTAOId);

	// Event to be broadcasted to public when setting update is approved/rejected by the advocate of proposalTAOId
	event ApproveSettingUpdate(uint256 indexed settingId, address proposalTAOId, address proposalTAOAdvocate, bool approved);

	// Event to be broadcasted to public when setting update is finalized by the advocate of associatedTAOId
	event FinalizeSettingUpdate(uint256 indexed settingId, address associatedTAOId, address associatedTAOAdvocate);

	/**
	 * @dev Constructor function
	 */
	constructor(address _nameFactoryAddress,
		address _nameTAOPositionAddress,
		address _nameAccountRecoveryAddress,
		address _aoSettingAttributeAddress,
		address _aoSettingValueAddress,
		address _aoSettingAddress
		) public {
		setNameFactoryAddress(_nameFactoryAddress);
		setNameTAOPositionAddress(_nameTAOPositionAddress);
		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
		setAOSettingAttributeAddress(_aoSettingAttributeAddress);
		setAOSettingValueAddress(_aoSettingValueAddress);
		setAOSettingAddress(_aoSettingAddress);
	}

	/**
	 * @dev Checks if the calling contract address is The AO
	 *		OR
	 *		If The AO is set to a Name/TAO, then check if calling address is the Advocate
	 */
	modifier onlyTheAO {
		require (AOLibrary.isTheAO(msg.sender, theAO, nameTAOPositionAddress));
		_;
	}

	/**
	 * @dev Check is msg.sender address is a Name
	 */
	 modifier senderIsName() {
		require (_nameFactory.ethAddressToNameId(msg.sender) != address(0));
		_;
	 }

	/**
	 * @dev Only allowed if sender's Name is not compromised
	 */
	modifier senderNameNotCompromised() {
		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
		_;
	}

	/**
	 * @dev Check if sender can update setting
	 */
	modifier canUpdate(address _proposalTAOId) {
		require (
			AOLibrary.isTAO(_proposalTAOId) &&
			_nameFactory.ethAddressToNameId(msg.sender) != address(0) &&
			!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender))
		);
		_;
	}

	/**
	 * @dev Check whether or not setting is of type address
	 */
	modifier isAddressSetting(uint256 _settingId) {
		(uint8 ADDRESS_SETTING_TYPE,,,,) = _aoSetting.getSettingTypes();
		// Make sure the setting type is address
		require (_aoSetting.settingTypeLookup(_settingId) == ADDRESS_SETTING_TYPE);
		_;
	}

	/**
	 * @dev Check whether or not setting is of type bool
	 */
	modifier isBoolSetting(uint256 _settingId) {
		(, uint8 BOOL_SETTING_TYPE,,,) = _aoSetting.getSettingTypes();
		// Make sure the setting type is bool
		require (_aoSetting.settingTypeLookup(_settingId) == BOOL_SETTING_TYPE);
		_;
	}

	/**
	 * @dev Check whether or not setting is of type bytes32
	 */
	modifier isBytesSetting(uint256 _settingId) {
		(,, uint8 BYTES_SETTING_TYPE,,) = _aoSetting.getSettingTypes();
		// Make sure the setting type is bytes32
		require (_aoSetting.settingTypeLookup(_settingId) == BYTES_SETTING_TYPE);
		_;
	}

	/**
	 * @dev Check whether or not setting is of type string
	 */
	modifier isStringSetting(uint256 _settingId) {
		(,,, uint8 STRING_SETTING_TYPE,) = _aoSetting.getSettingTypes();
		// Make sure the setting type is string
		require (_aoSetting.settingTypeLookup(_settingId) == STRING_SETTING_TYPE);
		_;
	}

	/**
	 * @dev Check whether or not setting is of type uint256
	 */
	modifier isUintSetting(uint256 _settingId) {
		(,,,, uint8 UINT_SETTING_TYPE) = _aoSetting.getSettingTypes();
		// Make sure the setting type is uint256
		require (_aoSetting.settingTypeLookup(_settingId) == UINT_SETTING_TYPE);
		_;
	}

	/***** The AO ONLY METHODS *****/
	/**
	 * @dev Transfer ownership of The AO to new address
	 * @param _theAO The new address to be transferred
	 */
	function transferOwnership(address _theAO) public onlyTheAO {
		require (_theAO != address(0));
		theAO = _theAO;
	}

	/**
	 * @dev Whitelist `_account` address to transact on behalf of others
	 * @param _account The address to whitelist
	 * @param _whitelist Either to whitelist or not
	 */
	function setWhitelist(address _account, bool _whitelist) public onlyTheAO {
		require (_account != address(0));
		whitelist[_account] = _whitelist;
	}

	/**
	 * @dev The AO sets NameFactory address
	 * @param _nameFactoryAddress The address of NameFactory
	 */
	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
		require (_nameFactoryAddress != address(0));
		nameFactoryAddress = _nameFactoryAddress;
		_nameFactory = INameFactory(_nameFactoryAddress);
	}

	/**
	 * @dev The AO sets NameTAOPosition address
	 * @param _nameTAOPositionAddress The address of NameTAOPosition
	 */
	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
		require (_nameTAOPositionAddress != address(0));
		nameTAOPositionAddress = _nameTAOPositionAddress;
		_nameTAOPosition = INameTAOPosition(_nameTAOPositionAddress);
	}

	/**
	 * @dev The AO set the NameAccountRecovery Address
	 * @param _nameAccountRecoveryAddress The address of NameAccountRecovery
	 */
	function setNameAccountRecoveryAddress(address _nameAccountRecoveryAddress) public onlyTheAO {
		require (_nameAccountRecoveryAddress != address(0));
		nameAccountRecoveryAddress = _nameAccountRecoveryAddress;
		_nameAccountRecovery = INameAccountRecovery(nameAccountRecoveryAddress);
	}

	/**
	 * @dev The AO sets AOSettingAttribute address
	 * @param _aoSettingAttributeAddress The address of AOSettingAttribute
	 */
	function setAOSettingAttributeAddress(address _aoSettingAttributeAddress) public onlyTheAO {
		require (_aoSettingAttributeAddress != address(0));
		aoSettingAttributeAddress = _aoSettingAttributeAddress;
		_aoSettingAttribute = IAOSettingAttribute(_aoSettingAttributeAddress);
	}

	/**
	 * @dev The AO sets AOSettingValue address
	 * @param _aoSettingValueAddress The address of AOSettingValue
	 */
	function setAOSettingValueAddress(address _aoSettingValueAddress) public onlyTheAO {
		require (_aoSettingValueAddress != address(0));
		aoSettingValueAddress = _aoSettingValueAddress;
		_aoSettingValue = IAOSettingValue(_aoSettingValueAddress);
	}

	/**
	 * @dev The AO sets AOSetting address
	 * @param _aoSettingAddress The address of AOSetting
	 */
	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
		require (_aoSettingAddress != address(0));
		aoSettingAddress = _aoSettingAddress;
		_aoSetting = IAOSetting(_aoSettingAddress);
	}

	/***** PUBLIC METHODS *****/
	/**
	 * @dev Advocate of Setting's _associatedTAOId submits an address setting update after an update has been proposed
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new address value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function updateAddressSetting(
		uint256 _settingId,
		address _newValue,
		address _proposalTAOId,
		uint8 _signatureV,
		bytes32 _signatureR,
		bytes32 _signatureS,
		string memory _extraData)
		public
		canUpdate(_proposalTAOId)
		isAddressSetting(_settingId) {

		// Verify and store update address signature
		require (_verifyAndStoreUpdateAddressSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));

		// Store the setting state data
		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));

		// Store the value as pending value
		_aoSettingValue.setPendingValue(_settingId, _newValue, false, '', '', 0);

		// Store the update hash key lookup
		_storeUpdateAddressHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);

		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
	}

	/**
	 * @dev Advocate of Setting's _associatedTAOId submits a bool setting update after an update has been proposed
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new bool value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function updateBoolSetting(
		uint256 _settingId,
		bool _newValue,
		address _proposalTAOId,
		uint8 _signatureV,
		bytes32 _signatureR,
		bytes32 _signatureS,
		string memory _extraData)
		public
		canUpdate(_proposalTAOId)
		isBoolSetting(_settingId) {

		// Verify and store update bool signature
		require (_verifyAndStoreUpdateBoolSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));

		// Store the setting state data
		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));

		// Store the value as pending value
		_aoSettingValue.setPendingValue(_settingId, address(0), _newValue, '', '', 0);

		// Store the update hash key lookup
		_storeUpdateBoolHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);

		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
	}

	/**
	 * @dev Advocate of Setting's _associatedTAOId submits a bytes32 setting update after an update has been proposed
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new bytes32 value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function updateBytesSetting(
		uint256 _settingId,
		bytes32 _newValue,
		address _proposalTAOId,
		uint8 _signatureV,
		bytes32 _signatureR,
		bytes32 _signatureS,
		string memory _extraData)
		public
		canUpdate(_proposalTAOId)
		isBytesSetting(_settingId) {

		// Verify and store update bytes32 signature
		require (_verifyAndStoreUpdateBytesSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));

		// Store the setting state data
		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));

		// Store the value as pending value
		_aoSettingValue.setPendingValue(_settingId, address(0), false, _newValue, '', 0);

		// Store the update hash key lookup
		_storeUpdateBytesHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);

		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
	}

	/**
	 * @dev Advocate of Setting's _associatedTAOId submits a string setting update after an update has been proposed
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new string value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function updateStringSetting(
		uint256 _settingId,
		string memory _newValue,
		address _proposalTAOId,
		uint8 _signatureV,
		bytes32 _signatureR,
		bytes32 _signatureS,
		string memory _extraData)
		public
		canUpdate(_proposalTAOId)
		isStringSetting(_settingId) {

		// Verify and store update string signature
		require (_verifyAndStoreUpdateStringSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));

		// Store the setting state data
		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));

		// Store the value as pending value
		_aoSettingValue.setPendingValue(_settingId, address(0), false, '', _newValue, 0);

		// Store the update hash key lookup
		_storeUpdateStringHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);

		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
	}

	/**
	 * @dev Advocate of Setting's _associatedTAOId submits a uint256 setting update after an update has been proposed
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new uint256 value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _signatureV The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureR The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _signatureS The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function updateUintSetting(
		uint256 _settingId,
		uint256 _newValue,
		address _proposalTAOId,
		uint8 _signatureV,
		bytes32 _signatureR,
		bytes32 _signatureS,
		string memory _extraData)
		public
		canUpdate(_proposalTAOId)
		isUintSetting(_settingId) {

		// Verify and store update uint256 signature
		require (_verifyAndStoreUpdateUintSignature(_settingId, _newValue, _proposalTAOId, _signatureV, _signatureR, _signatureS));

		// Store the setting state data
		require (_aoSettingAttribute.update(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId, _extraData));

		// Store the value as pending value
		_aoSettingValue.setPendingValue(_settingId, address(0), false, '', '', _newValue);

		// Store the update hash key lookup
		_storeUpdateUintHashLookup(_settingId, _newValue, _proposalTAOId, _extraData);

		emit SettingUpdate(_settingId, _nameFactory.ethAddressToNameId(msg.sender), _proposalTAOId);
	}

	/**
	 * @dev Advocate of Setting's proposalTAOId approves the setting update
	 * @param _settingId The ID of the setting to be approved
	 * @param _approved Whether to approve or reject
	 */
	function approveSettingUpdate(uint256 _settingId, bool _approved) public senderIsName senderNameNotCompromised {
		// Make sure setting exist
		require (_aoSetting.settingTypeLookup(_settingId) > 0);

		address _proposalTAOAdvocate = _nameFactory.ethAddressToNameId(msg.sender);
		(,,, address _proposalTAOId,,) = _aoSettingAttribute.getSettingState(_settingId);

		require (_aoSettingAttribute.approveUpdate(_settingId, _proposalTAOAdvocate, _approved));

		emit ApproveSettingUpdate(_settingId, _proposalTAOId, _proposalTAOAdvocate, _approved);
	}

	/**
	 * @dev Advocate of Setting's _associatedTAOId finalizes the setting update once the setting is approved
	 * @param _settingId The ID of the setting to be finalized
	 */
	function finalizeSettingUpdate(uint256 _settingId) public senderIsName senderNameNotCompromised {
		// Make sure setting exist
		require (_aoSetting.settingTypeLookup(_settingId) > 0);

		address _associatedTAOAdvocate = _nameFactory.ethAddressToNameId(msg.sender);
		require (_aoSettingAttribute.finalizeUpdate(_settingId, _associatedTAOAdvocate));

		(,,, address _associatedTAOId,,,,,) = _aoSettingAttribute.getSettingData(_settingId);

		require (_aoSettingValue.movePendingToSetting(_settingId));

		emit FinalizeSettingUpdate(_settingId, _associatedTAOId, _associatedTAOAdvocate);
	}

	/***** Internal Method *****/
	/**
	 * @dev Verify the signature for the address update and store the signature info
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new address value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @return true if valid, false otherwise
	 */
	function _verifyAndStoreUpdateAddressSignature(
		uint256 _settingId,
		address _newValue,
		address _proposalTAOId,
		uint8 _v,
		bytes32 _r,
		bytes32 _s
		) internal returns (bool) {
		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
			return false;
		}
		_storeUpdateSignature(_settingId, _v, _r, _s);
		return true;
	}

	/**
	 * @dev Verify the signature for the bool update and store the signature info
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new bool value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @return true if valid, false otherwise
	 */
	function _verifyAndStoreUpdateBoolSignature(
		uint256 _settingId,
		bool _newValue,
		address _proposalTAOId,
		uint8 _v,
		bytes32 _r,
		bytes32 _s
		) internal returns (bool) {
		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
			return false;
		}
		_storeUpdateSignature(_settingId, _v, _r, _s);
		return true;
	}

	/**
	 * @dev Verify the signature for the bytes32 update and store the signature info
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new bytes32 value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @return true if valid, false otherwise
	 */
	function _verifyAndStoreUpdateBytesSignature(
		uint256 _settingId,
		bytes32 _newValue,
		address _proposalTAOId,
		uint8 _v,
		bytes32 _r,
		bytes32 _s
		) internal returns (bool) {
		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
			return false;
		}
		_storeUpdateSignature(_settingId, _v, _r, _s);
		return true;
	}

	/**
	 * @dev Verify the signature for the string update and store the signature info
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new string value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @return true if valid, false otherwise
	 */
	function _verifyAndStoreUpdateStringSignature(
		uint256 _settingId,
		string memory _newValue,
		address _proposalTAOId,
		uint8 _v,
		bytes32 _r,
		bytes32 _s
		) internal returns (bool) {
		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
			return false;
		}
		_storeUpdateSignature(_settingId, _v, _r, _s);
		return true;
	}

	/**
	 * @dev Verify the signature for the uint256 update and store the signature info
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new uint256 value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @return true if valid, false otherwise
	 */
	function _verifyAndStoreUpdateUintSignature(
		uint256 _settingId,
		uint256 _newValue,
		address _proposalTAOId,
		uint8 _v,
		bytes32 _r,
		bytes32 _s
		) public returns (bool) {
		bytes32 _hash = keccak256(abi.encodePacked(address(this), _settingId, _proposalTAOId, _newValue, _nameFactory.ethAddressToNameId(msg.sender)));
		if (ecrecover(_hash, _v, _r, _s) != msg.sender) {
			return false;
		}
		_storeUpdateSignature(_settingId, _v, _r, _s);
		return true;
	}

	/**
	 * @dev Store the update hash lookup for this address setting
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new address value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function _storeUpdateAddressHashLookup(
		uint256 _settingId,
		address _newValue,
		address _proposalTAOId,
		string memory _extraData)
		internal {
		// Store the update hash key lookup
		(address _addressValue,,,,) = _aoSettingValue.settingValue(_settingId);
		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _addressValue, _newValue, _extraData, _settingId))] = _settingId;
	}

	/**
	 * @dev Store the update hash lookup for this bool setting
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new bool value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function _storeUpdateBoolHashLookup(
		uint256 _settingId,
		bool _newValue,
		address _proposalTAOId,
		string memory _extraData)
		internal {
		// Store the update hash key lookup
		(, bool _boolValue,,,) = _aoSettingValue.settingValue(_settingId);
		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _boolValue, _newValue, _extraData, _settingId))] = _settingId;
	}

	/**
	 * @dev Store the update hash lookup for this bytes32 setting
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new bytes32 value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function _storeUpdateBytesHashLookup(
		uint256 _settingId,
		bytes32 _newValue,
		address _proposalTAOId,
		string memory _extraData)
		internal {
		// Store the update hash key lookup
		(,, bytes32 _bytesValue,,) = _aoSettingValue.settingValue(_settingId);
		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _bytesValue, _newValue, _extraData, _settingId))] = _settingId;
	}

	/**
	 * @dev Store the update hash lookup for this string setting
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new string value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function _storeUpdateStringHashLookup(
		uint256 _settingId,
		string memory _newValue,
		address _proposalTAOId,
		string memory _extraData)
		internal {
		// Store the update hash key lookup
		(,,, string memory _stringValue,) = _aoSettingValue.settingValue(_settingId);
		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _stringValue, _newValue, _extraData, _settingId))] = _settingId;
	}

	/**
	 * @dev Store the update hash lookup for this uint256 setting
	 * @param _settingId The ID of the setting to be updated
	 * @param _newValue The new address value for this setting
	 * @param _proposalTAOId The child of the associatedTAOId with the update Logos
	 * @param _extraData Catch-all string value to be stored if exist
	 */
	function _storeUpdateUintHashLookup(
		uint256 _settingId,
		uint256 _newValue,
		address _proposalTAOId,
		string memory _extraData)
		internal {
		// Store the update hash key lookup
		(,,,, uint256 _uintValue) = _aoSettingValue.settingValue(_settingId);
		updateHashLookup[keccak256(abi.encodePacked(address(this), _proposalTAOId, _uintValue, _newValue, _extraData, _settingId))] = _settingId;
	}

	/**
	 * @dev Actual storing the UpdateSignature info
	 * @param _settingId The ID of the setting to be updated
	 * @param _v The V part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _r The R part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 * @param _s The S part of the signature of proposalTAOId, newValue and associatedTAOId's Advocate
	 */
	function _storeUpdateSignature(uint256 _settingId, uint8 _v, bytes32 _r, bytes32 _s) internal {
		UpdateSignature storage _updateSignature = updateSignatures[_settingId];
		_updateSignature.signatureV = _v;
		_updateSignature.signatureR = _r;
		_updateSignature.signatureS = _s;
	}
}