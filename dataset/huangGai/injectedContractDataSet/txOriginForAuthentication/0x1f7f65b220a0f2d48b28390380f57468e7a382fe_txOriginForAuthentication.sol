pragma solidity >=0.5.4 <0.6.0;

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


interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }




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


interface INameAccountRecovery {
	function isCompromised(address _id) external view returns (bool);
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


interface INameFactory {
	function nonces(address _nameId) external view returns (uint256);
	function incrementNonce(address _nameId) external returns (uint256);
	function ethAddressToNameId(address _ethAddress) external view returns (address);
	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
	function nameIdToEthAddress(address _nameId) external view returns (address);
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


interface IAOSetting {
	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);

	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
}


interface ITAOAncestry {
	function initialize(address _id, address _parentId, uint256 _childMinLogos) external returns (bool);

	function getAncestryById(address _id) external view returns (address, uint256, uint256);

	function addChild(address _taoId, address _childId) external returns (bool);

	function isChild(address _taoId, address _childId) external view returns (bool);
}


interface ITAOFactory {
	function nonces(address _taoId) external view returns (uint256);
	function incrementNonce(address _taoId) external returns (uint256);
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
 * @title TAOCurrency
 */
contract TAOCurrency is TheAO {
	using SafeMath for uint256;

	// Public variables of the contract
	string public name;
	string public symbol;
	uint8 public decimals;

	// To differentiate denomination of TAO Currency
	uint256 public powerOfTen;

	uint256 public totalSupply;

	// This creates an array with all balances
	// address is the address of nameId, not the eth public address
	mapping (address => uint256) public balanceOf;

	// This generates a public event on the blockchain that will notify clients
	// address is the address of TAO/Name Id, not eth public address
	event Transfer(address indexed from, address indexed to, uint256 value);

	// This notifies clients about the amount burnt
	// address is the address of TAO/Name Id, not eth public address
	event Burn(address indexed from, uint256 value);

	/**
	 * Constructor function
	 *
	 * Initializes contract with initial supply TAOCurrency to the creator of the contract
	 */
	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
		name = _name;		// Set the name for display purposes
		symbol = _symbol;	// Set the symbol for display purposes

		powerOfTen = 0;
		decimals = 0;

		setNameTAOPositionAddress(_nameTAOPositionAddress);
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
	 * @dev Check if `_id` is a Name or a TAO
	 */
	modifier isNameOrTAO(address _id) {
		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
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
	 * @dev The AO set the NameTAOPosition Address
	 * @param _nameTAOPositionAddress The address of NameTAOPosition
	 */
	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
		require (_nameTAOPositionAddress != address(0));
		nameTAOPositionAddress = _nameTAOPositionAddress;
	}

	/***** PUBLIC METHODS *****/
	/**
	 * @dev transfer TAOCurrency from other address
	 *
	 * Send `_value` TAOCurrency to `_to` in behalf of `_from`
	 *
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value the amount to send
	 */
	function transferFrom(address _from, address _to, uint256 _value) public inWhitelist isNameOrTAO(_from) isNameOrTAO(_to) returns (bool) {
		_transfer(_from, _to, _value);
		return true;
	}

	/**
	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
	 * @param target Address to receive TAOCurrency
	 * @param mintedAmount The amount of TAOCurrency it will receive
	 * @return true on success
	 */
	function mint(address target, uint256 mintedAmount) public inWhitelist isNameOrTAO(target) returns (bool) {
		_mint(target, mintedAmount);
		return true;
	}

	/**
	 *
	 * @dev Whitelisted address remove `_value` TAOCurrency from the system irreversibly on behalf of `_from`.
	 *
	 * @param _from the address of the sender
	 * @param _value the amount of money to burn
	 */
	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist isNameOrTAO(_from) returns (bool success) {
		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
		totalSupply = totalSupply.sub(_value);              // Update totalSupply
		emit Burn(_from, _value);
		return true;
	}

	/***** INTERNAL METHODS *****/
	/**
	 * @dev Send `_value` TAOCurrency from `_from` to `_to`
	 * @param _from The address of sender
	 * @param _to The address of the recipient
	 * @param _value The amount to send
	 */
	function _transfer(address _from, address _to, uint256 _value) internal {
		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
		require (balanceOf[_from] >= _value);					// Check if the sender has enough
		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
		emit Transfer(_from, _to, _value);
		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
	}

	/**
	 * @dev Create `mintedAmount` TAOCurrency and send it to `target`
	 * @param target Address to receive TAOCurrency
	 * @param mintedAmount The amount of TAOCurrency it will receive
	 */
	function _mint(address target, uint256 mintedAmount) internal {
		balanceOf[target] = balanceOf[target].add(mintedAmount);
		totalSupply = totalSupply.add(mintedAmount);
		emit Transfer(address(0), address(this), mintedAmount);
		emit Transfer(address(this), target, mintedAmount);
	}
}





contract Logos is TAOCurrency {
	address public nameFactoryAddress;
	address public nameAccountRecoveryAddress;

	INameFactory internal _nameFactory;
	INameTAOPosition internal _nameTAOPosition;
	INameAccountRecovery internal _nameAccountRecovery;

	// Mapping of a Name ID to the amount of Logos positioned by others to itself
	// address is the address of nameId, not the eth public address
	mapping (address => uint256) public positionFromOthers;

	// Mapping of Name ID to other Name ID and the amount of Logos positioned by itself
	mapping (address => mapping(address => uint256)) public positionOnOthers;

	// Mapping of a Name ID to the total amount of Logos positioned by itself on others
	mapping (address => uint256) public totalPositionOnOthers;

	// Mapping of Name ID to it's advocated TAO ID and the amount of Logos earned
	mapping (address => mapping(address => uint256)) public advocatedTAOLogos;

	// Mapping of a Name ID to the total amount of Logos earned from advocated TAO
	mapping (address => uint256) public totalAdvocatedTAOLogos;

	// Event broadcasted to public when `from` address position `value` Logos to `to`
	event PositionFrom(address indexed from, address indexed to, uint256 value);

	// Event broadcasted to public when `from` address unposition `value` Logos from `to`
	event UnpositionFrom(address indexed from, address indexed to, uint256 value);

	// Event broadcasted to public when `nameId` receives `amount` of Logos from advocating `taoId`
	event AddAdvocatedTAOLogos(address indexed nameId, address indexed taoId, uint256 amount);

	// Event broadcasted to public when Logos from advocating `taoId` is transferred from `fromNameId` to `toNameId`
	event TransferAdvocatedTAOLogos(address indexed fromNameId, address indexed toNameId, address indexed taoId, uint256 amount);

	/**
	 * @dev Constructor function
	 */
	constructor(string memory _name, string memory _symbol, address _nameFactoryAddress, address _nameTAOPositionAddress)
		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {
		setNameFactoryAddress(_nameFactoryAddress);
		setNameTAOPositionAddress(_nameTAOPositionAddress);
	}

	/**
	 * @dev Check if `_taoId` is a TAO
	 */
	modifier isTAO(address _taoId) {
		require (AOLibrary.isTAO(_taoId));
		_;
	}

	/**
	 * @dev Check if `_nameId` is a Name
	 */
	modifier isName(address _nameId) {
		require (AOLibrary.isName(_nameId));
		_;
	}

	/**
	 * @dev Check if msg.sender is the current advocate of _id
	 */
	modifier onlyAdvocate(address _id) {
		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _id));
		_;
	}

	/**
	 * @dev Only allowed if Name is not compromised
	 */
	modifier nameNotCompromised(address _id) {
		require (!_nameAccountRecovery.isCompromised(_id));
		_;
	}

	/**
	 * @dev Only allowed if sender's Name is not compromised
	 */
	modifier senderNameNotCompromised() {
		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
		_;
	}

	/***** THE AO ONLY METHODS *****/
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
	 * @dev The AO set the NameTAOPosition Address
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

	/***** PUBLIC METHODS *****/
	/**
	 * @dev Get the total sum of Logos for an address
	 * @param _target The address to check
	 * @return The total sum of Logos (own + positioned + advocated TAOs)
	 */
	function sumBalanceOf(address _target) public isName(_target) view returns (uint256) {
		return balanceOf[_target].add(positionFromOthers[_target]).add(totalAdvocatedTAOLogos[_target]);
	}

	/**
	 * @dev Return the amount of Logos that are available to be positioned on other
	 * @param _sender The sender address to check
	 * @return The amount of Logos that are available to be positioned on other
	 */
	function availableToPositionAmount(address _sender) public isName(_sender) view returns (uint256) {
		return balanceOf[_sender].sub(totalPositionOnOthers[_sender]);
	}

	/**
	 * @dev `_from` Name position `_value` Logos onto `_to` Name
	 *
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value the amount to position
	 * @return true on success
	 */
	function positionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
		require (_from != _to);	// Can't position Logos to itself
		require (availableToPositionAmount(_from) >= _value); // should have enough balance to position
		require (positionFromOthers[_to].add(_value) >= positionFromOthers[_to]); // check for overflows

		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].add(_value);
		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].add(_value);
		positionFromOthers[_to] = positionFromOthers[_to].add(_value);

		emit PositionFrom(_from, _to, _value);
		return true;
	}

	/**
	 * @dev `_from` Name unposition `_value` Logos from `_to` Name
	 *
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value the amount to unposition
	 * @return true on success
	 */
	function unpositionFrom(address _from, address _to, uint256 _value) public isName(_from) isName(_to) nameNotCompromised(_from) nameNotCompromised(_to) onlyAdvocate(_from) senderNameNotCompromised returns (bool) {
		require (_from != _to);	// Can't unposition Logos to itself
		require (positionOnOthers[_from][_to] >= _value);

		positionOnOthers[_from][_to] = positionOnOthers[_from][_to].sub(_value);
		totalPositionOnOthers[_from] = totalPositionOnOthers[_from].sub(_value);
		positionFromOthers[_to] = positionFromOthers[_to].sub(_value);

		emit UnpositionFrom(_from, _to, _value);
		return true;
	}

	/**
	 * @dev Add `_amount` logos earned from advocating a TAO `_taoId` to its Advocate
	 * @param _taoId The ID of the advocated TAO
	 * @param _amount the amount to reward
	 * @return true on success
	 */
	function addAdvocatedTAOLogos(address _taoId, uint256 _amount) public inWhitelist isTAO(_taoId) returns (bool) {
		require (_amount > 0);
		address _nameId = _nameTAOPosition.getAdvocate(_taoId);

		advocatedTAOLogos[_nameId][_taoId] = advocatedTAOLogos[_nameId][_taoId].add(_amount);
		totalAdvocatedTAOLogos[_nameId] = totalAdvocatedTAOLogos[_nameId].add(_amount);

		emit AddAdvocatedTAOLogos(_nameId, _taoId, _amount);
		return true;
	}

	/**
	 * @dev Transfer logos earned from advocating a TAO `_taoId` from `_fromNameId` to the Advocate of `_taoId`
	 * @param _fromNameId The ID of the Name that sends the Logos
	 * @param _taoId The ID of the advocated TAO
	 * @return true on success
	 */
	function transferAdvocatedTAOLogos(address _fromNameId, address _taoId) public inWhitelist isName(_fromNameId) isTAO(_taoId) returns (bool) {
		address _toNameId = _nameTAOPosition.getAdvocate(_taoId);
		require (_fromNameId != _toNameId);
		require (totalAdvocatedTAOLogos[_fromNameId] >= advocatedTAOLogos[_fromNameId][_taoId]);

		uint256 _amount = advocatedTAOLogos[_fromNameId][_taoId];
		advocatedTAOLogos[_fromNameId][_taoId] = 0;
		totalAdvocatedTAOLogos[_fromNameId] = totalAdvocatedTAOLogos[_fromNameId].sub(_amount);
		advocatedTAOLogos[_toNameId][_taoId] = advocatedTAOLogos[_toNameId][_taoId].add(_amount);
		totalAdvocatedTAOLogos[_toNameId] = totalAdvocatedTAOLogos[_toNameId].add(_amount);

		emit TransferAdvocatedTAOLogos(_fromNameId, _toNameId, _taoId, _amount);
		return true;
	}
}



/**
 * @title NameTAOPosition
 */
contract NameTAOPosition is TheAO, INameTAOPosition {
	using SafeMath for uint256;

	address public settingTAOId;
	address public nameFactoryAddress;
	address public nameAccountRecoveryAddress;
	address public taoFactoryAddress;
	address public aoSettingAddress;
	address public taoAncestryAddress;
	address public logosAddress;

	uint256 public totalTAOAdvocateChallenges;

	INameFactory internal _nameFactory;
	INameAccountRecovery internal _nameAccountRecovery;
	ITAOFactory internal _taoFactory;
	IAOSetting internal _aoSetting;
	ITAOAncestry internal _taoAncestry;
	Logos internal _logos;

	struct PositionDetail {
		address advocateId;
		address listenerId;
		address speakerId;
		bool created;
	}

	struct TAOAdvocateChallenge {
		bytes32 challengeId;
		address newAdvocateId;		// The Name ID that wants to be the new Advocate
		address taoId;				// The TAO ID being challenged
		bool completed;				// Status of the challenge
		uint256 createdTimestamp;	// Timestamp when this challenge is created
		uint256 lockedUntilTimestamp;	// The deadline for current Advocate to respond
		uint256 completeBeforeTimestamp; // The deadline for the challenger to respond and complete the challenge
	}

	// Mapping from Name/TAO ID to its PositionDetail info
	mapping (address => PositionDetail) internal positionDetails;

	// Mapping from challengeId to TAOAdvocateChallenge info
	mapping (bytes32 => TAOAdvocateChallenge) internal taoAdvocateChallenges;

	// Event to be broadcasted to public when current Advocate of TAO sets New Advocate
	event SetAdvocate(address indexed taoId, address oldAdvocateId, address newAdvocateId, uint256 nonce);

	// Event to be broadcasted to public when current Advocate of Name/TAO sets New Listener
	event SetListener(address indexed taoId, address oldListenerId, address newListenerId, uint256 nonce);

	// Event to be broadcasted to public when current Advocate of Name/TAO sets New Speaker
	event SetSpeaker(address indexed taoId, address oldSpeakerId, address newSpeakerId, uint256 nonce);

	// Event to be broadcasted to public when a Name challenges to become TAO's new Advocate
	event ChallengeTAOAdvocate(address indexed taoId, bytes32 indexed challengeId, address currentAdvocateId, address challengerAdvocateId, uint256 createdTimestamp, uint256 lockedUntilTimestamp, uint256 completeBeforeTimestamp);

	// Event to be broadcasted to public when Challenger completes the TAO Advocate challenge
	event CompleteTAOAdvocateChallenge(address indexed taoId, bytes32 indexed challengeId);

	/**
	 * @dev Constructor function
	 */
	constructor(address _nameFactoryAddress, address _taoFactoryAddress) public {
		setNameFactoryAddress(_nameFactoryAddress);
		setTAOFactoryAddress(_taoFactoryAddress);

		nameTAOPositionAddress = address(this);
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
	 * @dev Check if calling address is Factory
	 */
	modifier onlyFactory {
		require (msg.sender == nameFactoryAddress || msg.sender == taoFactoryAddress);
		_;
	}

	/**
	 * @dev Check if `_taoId` is a TAO
	 */
	modifier isTAO(address _taoId) {
		require (AOLibrary.isTAO(_taoId));
		_;
	}

	/**
	 * @dev Check if `_nameId` is a Name
	 */
	modifier isName(address _nameId) {
		require (AOLibrary.isName(_nameId));
		_;
	}

	/**
	 * @dev Check if `_id` is a Name or a TAO
	 */
	modifier isNameOrTAO(address _id) {
		require (AOLibrary.isName(_id) || AOLibrary.isTAO(_id));
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
	 * @dev Check if msg.sender is the current advocate of a Name/TAO ID
	 */
	modifier onlyAdvocate(address _id) {
		require (this.senderIsAdvocate(msg.sender, _id));
		_;
	}

	/**
	 * @dev Only allowed if sender's Name is not compromised
	 */
	modifier senderNameNotCompromised() {
		require (!_nameAccountRecovery.isCompromised(_nameFactory.ethAddressToNameId(msg.sender)));
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
	 * @dev The AO set the NameFactory Address
	 * @param _nameFactoryAddress The address of NameFactory
	 */
	function setNameFactoryAddress(address _nameFactoryAddress) public onlyTheAO {
		require (_nameFactoryAddress != address(0));
		nameFactoryAddress = _nameFactoryAddress;
		_nameFactory = INameFactory(_nameFactoryAddress);
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
	 * @dev The AO set the TAOFactory Address
	 * @param _taoFactoryAddress The address of TAOFactory
	 */
	function setTAOFactoryAddress(address _taoFactoryAddress) public onlyTheAO {
		require (_taoFactoryAddress != address(0));
		taoFactoryAddress = _taoFactoryAddress;
		_taoFactory = ITAOFactory(_taoFactoryAddress);
	}

	/**
	 * @dev The AO sets setting TAO ID
	 * @param _settingTAOId The new setting TAO ID to set
	 */
	function setSettingTAOId(address _settingTAOId) public onlyTheAO {
		require (AOLibrary.isTAO(_settingTAOId));
		settingTAOId = _settingTAOId;
	}

	/**
	 * @dev The AO sets AO Setting address
	 * @param _aoSettingAddress The address of AOSetting
	 */
	function setAOSettingAddress(address _aoSettingAddress) public onlyTheAO {
		require (_aoSettingAddress != address(0));
		aoSettingAddress = _aoSettingAddress;
		_aoSetting = IAOSetting(_aoSettingAddress);
	}

	/**
	 * @dev The AO set the TAOAncestry Address
	 * @param _taoAncestryAddress The address of TAOAncestry
	 */
	function setTAOAncestryAddress(address _taoAncestryAddress) public onlyTheAO {
		require (_taoAncestryAddress != address(0));
		taoAncestryAddress = _taoAncestryAddress;
		_taoAncestry = ITAOAncestry(taoAncestryAddress);
	}

	/**
	 * @dev The AO set the logosAddress Address
	 * @param _logosAddress The address of Logos
	 */
	function setLogosAddress(address _logosAddress) public onlyTheAO {
		require (_logosAddress != address(0));
		logosAddress = _logosAddress;
		_logos = Logos(_logosAddress);
	}

	/***** PUBLIC METHODS *****/
	/**
	 * @dev Check whether or not a Name/TAO ID exist in the list
	 * @param _id The ID to be checked
	 * @return true if yes, false otherwise
	 */
	function isExist(address _id) public view returns (bool) {
		return positionDetails[_id].created;
	}

	/**
	 * @dev Check whether or not `_sender` eth address is Advocate of _id
	 * @param _sender The eth address to check
	 * @param _id The ID to be checked
	 * @return true if yes, false otherwise
	 */
	function senderIsAdvocate(address _sender, address _id) external view returns (bool) {
		return (positionDetails[_id].created && positionDetails[_id].advocateId == _nameFactory.ethAddressToNameId(_sender));
	}

	/**
	 * @dev Check whether or not `_sender` eth address is Listener of _id
	 * @param _sender The eth address to check
	 * @param _id The ID to be checked
	 * @return true if yes, false otherwise
	 */
	function senderIsListener(address _sender, address _id) external view returns (bool) {
		return (positionDetails[_id].created && positionDetails[_id].listenerId == _nameFactory.ethAddressToNameId(_sender));
	}

	/**
	 * @dev Check whether or not `_sender` eth address is Speaker of _id
	 * @param _sender The eth address to check
	 * @param _id The ID to be checked
	 * @return true if yes, false otherwise
	 */
	function senderIsSpeaker(address _sender, address _id) external view returns (bool) {
		return (positionDetails[_id].created && positionDetails[_id].speakerId == _nameFactory.ethAddressToNameId(_sender));
	}

	/**
	 * @dev Check whether or not `_sender` eth address is Advocate of Parent of _id
	 * @param _sender The eth address to check
	 * @param _id The ID to be checked
	 * @return true if yes, false otherwise
	 */
	function senderIsAdvocateOfParent(address _sender, address _id) public view returns (bool) {
		(address _parentId,,) = _taoAncestry.getAncestryById(_id);
		 return ((AOLibrary.isName(_parentId) || (AOLibrary.isTAO(_parentId) && _taoAncestry.isChild(_parentId, _id))) && this.senderIsAdvocate(_sender, _parentId));
	}

	/**
	 * @dev Check whether or not eth address is either Advocate/Listener/Speaker of _id
	 * @param _sender The eth address to check
	 * @param _id The ID to be checked
	 * @return true if yes, false otherwise
	 */
	function senderIsPosition(address _sender, address _id) external view returns (bool) {
		address _nameId = _nameFactory.ethAddressToNameId(_sender);
		if (_nameId == address(0)) {
			return false;
		} else {
			return this.nameIsPosition(_nameId, _id);
		}
	}

	/**
	 * @dev Check whether or not _nameId is advocate of _id
	 * @param _nameId The name ID to be checked
	 * @param _id The ID to be checked
	 * @return true if yes, false otherwise
	 */
	function nameIsAdvocate(address _nameId, address _id) external view returns (bool) {
		return (positionDetails[_id].created && positionDetails[_id].advocateId == _nameId);
	}

	/**
	 * @dev Check whether or not _nameId is either Advocate/Listener/Speaker of _id
	 * @param _nameId The name ID to be checked
	 * @param _id The ID to be checked
	 * @return true if yes, false otherwise
	 */
	function nameIsPosition(address _nameId, address _id) external view returns (bool) {
		return (positionDetails[_id].created &&
			(positionDetails[_id].advocateId == _nameId ||
			 positionDetails[_id].listenerId == _nameId ||
			 positionDetails[_id].speakerId == _nameId
			)
	   );
	}

	/**
	 * @dev Determine whether or not `_sender` is Advocate/Listener/Speaker of the Name/TAO
	 * @param _sender The ETH address that to check
	 * @param _id The ID of the Name/TAO
	 * @return 1 if Advocate. 2 if Listener. 3 if Speaker
	 */
	function determinePosition(address _sender, address _id) external view returns (uint256) {
		require (this.senderIsPosition(_sender, _id));
		PositionDetail memory _positionDetail = positionDetails[_id];
		address _nameId = _nameFactory.ethAddressToNameId(_sender);
		if (_nameId == _positionDetail.advocateId) {
			return 1;
		} else if (_nameId == _positionDetail.listenerId) {
			return 2;
		} else {
			return 3;
		}
	}

	/**
	 * @dev Initialize Position for a Name/TAO
	 * @param _id The ID of the Name/TAO
	 * @param _advocateId The Advocate ID of the Name/TAO
	 * @param _listenerId The Listener ID of the Name/TAO
	 * @param _speakerId The Speaker ID of the Name/TAO
	 * @return true on success
	 */
	function initialize(address _id, address _advocateId, address _listenerId, address _speakerId)
		external
		isNameOrTAO(_id)
		isName(_advocateId)
		isNameOrTAO(_listenerId)
		isNameOrTAO(_speakerId)
		onlyFactory returns (bool) {
		require (!isExist(_id));

		PositionDetail storage _positionDetail = positionDetails[_id];
		_positionDetail.advocateId = _advocateId;
		_positionDetail.listenerId = _listenerId;
		_positionDetail.speakerId = _speakerId;
		_positionDetail.created = true;
		return true;
	}

	/**
	 * @dev Get Name/TAO's Position info
	 * @param _id The ID of the Name/TAO
	 * @return the Advocate name
	 * @return the Advocate ID of Name/TAO
	 * @return the Listener name
	 * @return the Listener ID of Name/TAO
	 * @return the Speaker name
	 * @return the Speaker ID of Name/TAO
	 */
	function getPositionById(address _id) public view returns (string memory, address, string memory, address, string memory, address) {
		require (isExist(_id));
		PositionDetail memory _positionDetail = positionDetails[_id];
		return (
			TAO(address(uint160(_positionDetail.advocateId))).name(),
			_positionDetail.advocateId,
			TAO(address(uint160(_positionDetail.listenerId))).name(),
			_positionDetail.listenerId,
			TAO(address(uint160(_positionDetail.speakerId))).name(),
			_positionDetail.speakerId
		);
	}

	/**
	 * @dev Get Name/TAO's Advocate
	 * @param _id The ID of the Name/TAO
	 * @return the Advocate ID of Name/TAO
	 */
	function getAdvocate(address _id) external view returns (address) {
		require (isExist(_id));
		PositionDetail memory _positionDetail = positionDetails[_id];
		return _positionDetail.advocateId;
	}

	/**
	 * @dev Get Name/TAO's Listener
	 * @param _id The ID of the Name/TAO
	 * @return the Listener ID of Name/TAO
	 */
	function getListener(address _id) public view returns (address) {
		require (isExist(_id));
		PositionDetail memory _positionDetail = positionDetails[_id];
		return _positionDetail.listenerId;
	}

	/**
	 * @dev Get Name/TAO's Speaker
	 * @param _id The ID of the Name/TAO
	 * @return the Speaker ID of Name/TAO
	 */
	function getSpeaker(address _id) public view returns (address) {
		require (isExist(_id));
		PositionDetail memory _positionDetail = positionDetails[_id];
		return _positionDetail.speakerId;
	}

	/**
	 * @dev Set Advocate for a TAO
	 * @param _taoId The ID of the TAO
	 * @param _newAdvocateId The new advocate ID to be set
	 */
	function setAdvocate(address _taoId, address _newAdvocateId)
		public
		isTAO(_taoId)
		isName(_newAdvocateId)
		onlyAdvocate(_taoId)
		senderIsName
		senderNameNotCompromised {
		require (isExist(_taoId));
		// Make sure the newAdvocate is not compromised
		require (!_nameAccountRecovery.isCompromised(_newAdvocateId));
		_setAdvocate(_taoId, _newAdvocateId);
	}

	/**
	 * Only Advocate of Parent of `_taoId` can replace child `_taoId` 's Advocate with himself
	 * @param _taoId The ID of the TAO
	 */
	function parentReplaceChildAdvocate(address _taoId)
		public
		isTAO(_taoId)
		senderIsName
		senderNameNotCompromised {
		require (isExist(_taoId));
		require (senderIsAdvocateOfParent(msg.sender, _taoId));
		address _parentNameId = _nameFactory.ethAddressToNameId(msg.sender);
		address _currentAdvocateId = this.getAdvocate(_taoId);

		// Make sure it's not replacing itself
		require (_parentNameId != _currentAdvocateId);

		// Parent has to have more Logos than current Advocate
		require (_logos.sumBalanceOf(_parentNameId) > _logos.sumBalanceOf(this.getAdvocate(_taoId)));

		_setAdvocate(_taoId, _parentNameId);
	}

	/**
	 * A Name challenges current TAO's Advocate to be its new Advocate
	 * @param _taoId The ID of the TAO
	 */
	function challengeTAOAdvocate(address _taoId)
		public
		isTAO(_taoId)
		senderIsName
		senderNameNotCompromised {
		require (isExist(_taoId));
		address _newAdvocateId = _nameFactory.ethAddressToNameId(msg.sender);
		address _currentAdvocateId = this.getAdvocate(_taoId);

		// Make sure it's not challenging itself
		require (_newAdvocateId != _currentAdvocateId);

		// New Advocate has to have more Logos than current Advocate
		require (_logos.sumBalanceOf(_newAdvocateId) > _logos.sumBalanceOf(_currentAdvocateId));

		(uint256 _lockDuration, uint256 _completeDuration) = _getSettingVariables();

		totalTAOAdvocateChallenges++;
		bytes32 _challengeId = keccak256(abi.encodePacked(this, _taoId, _newAdvocateId, totalTAOAdvocateChallenges));
		TAOAdvocateChallenge storage _taoAdvocateChallenge = taoAdvocateChallenges[_challengeId];
		_taoAdvocateChallenge.challengeId = _challengeId;
		_taoAdvocateChallenge.newAdvocateId = _newAdvocateId;
		_taoAdvocateChallenge.taoId = _taoId;
		_taoAdvocateChallenge.createdTimestamp = now;
		_taoAdvocateChallenge.lockedUntilTimestamp = _taoAdvocateChallenge.createdTimestamp.add(_lockDuration);
		_taoAdvocateChallenge.completeBeforeTimestamp = _taoAdvocateChallenge.lockedUntilTimestamp.add(_completeDuration);

		emit ChallengeTAOAdvocate(_taoId, _challengeId, _currentAdvocateId, _newAdvocateId, _taoAdvocateChallenge.createdTimestamp, _taoAdvocateChallenge.lockedUntilTimestamp, _taoAdvocateChallenge.completeBeforeTimestamp);
	}

	/**
	 * Get status of a TAOAdvocateChallenge given a `_challengeId` and a `_sender` eth address
	 * @param _challengeId The ID of TAOAdvocateChallenge
	 * @param _sender The sender address
	 * @return status of the challenge
	 *		1 = Can complete challenge
	 *		2 = Challenge not exist
	 *		3 = Sender is not the creator of the challenge
	 *		4 = Transaction is not in the allowed period of time (locking period of time)
	 *		5 = Transaction has expired
	 *		6 = Challenge has been completed
	 *		7 = Challenger has less Logos than current Advocate of TAO
	 */
	function getChallengeStatus(bytes32 _challengeId, address _sender) public view returns (uint8) {
		address _challengerNameId = _nameFactory.ethAddressToNameId(_sender);
		TAOAdvocateChallenge storage _taoAdvocateChallenge = taoAdvocateChallenges[_challengeId];

		// If the challenge does not exist
		if (_taoAdvocateChallenge.taoId == address(0)) {
			return 2;
		} else if (_challengerNameId != _taoAdvocateChallenge.newAdvocateId) {
			// If the calling address is not the creator of the challenge
			return 3;
		} else if (now < _taoAdvocateChallenge.lockedUntilTimestamp) {
			// If this transaction is not in the allowed period of time
			return 4;
		} else if (now > _taoAdvocateChallenge.completeBeforeTimestamp) {
			// Transaction has expired
			return 5;
		} else if (_taoAdvocateChallenge.completed) {
			// If the challenge has been completed
			return 6;
		} else if (_logos.sumBalanceOf(_challengerNameId) <= _logos.sumBalanceOf(this.getAdvocate(_taoAdvocateChallenge.taoId))) {
			// If challenger has less Logos than current Advocate of TAO
			return 7;
		} else {
			// Can complete!
			return 1;
		}
	}

	/**
	 * Only owner of challenge can respond and complete of the challenge
	 * @param _challengeId The ID of the TAOAdvocateChallenge
	 */
	function completeTAOAdvocateChallenge(bytes32 _challengeId)
		public
		senderIsName
		senderNameNotCompromised {
		TAOAdvocateChallenge storage _taoAdvocateChallenge = taoAdvocateChallenges[_challengeId];

		// Make sure the challenger can complete this challenge
		require (getChallengeStatus(_challengeId, msg.sender) == 1);

		_taoAdvocateChallenge.completed = true;

		_setAdvocate(_taoAdvocateChallenge.taoId, _taoAdvocateChallenge.newAdvocateId);

		emit CompleteTAOAdvocateChallenge(_taoAdvocateChallenge.taoId, _challengeId);
	}

	/**
	 * @dev Get TAOAdvocateChallenge info given an ID
	 * @param _challengeId The ID of TAOAdvocateChallenge
	 * @return the new Advocate ID in the challenge
	 * @return the ID of Name/TAO
	 * @return the completion status of the challenge
	 * @return the created timestamp
	 * @return the lockedUntil timestamp (The deadline for current Advocate to respond)
	 * @return the completeBefore timestamp (The deadline for the challenger to respond and complete the challenge)
	 */
	function getTAOAdvocateChallengeById(bytes32 _challengeId) public view returns (address, address, bool, uint256, uint256, uint256) {
		TAOAdvocateChallenge memory _taoAdvocateChallenge = taoAdvocateChallenges[_challengeId];
		require (_taoAdvocateChallenge.taoId != address(0));
		return (
			_taoAdvocateChallenge.newAdvocateId,
			_taoAdvocateChallenge.taoId,
			_taoAdvocateChallenge.completed,
			_taoAdvocateChallenge.createdTimestamp,
			_taoAdvocateChallenge.lockedUntilTimestamp,
			_taoAdvocateChallenge.completeBeforeTimestamp
		);
	}

	/**
	 * @dev Set Listener for a Name/TAO
	 * @param _id The ID of the Name/TAO
	 * @param _newListenerId The new listener ID to be set
	 */
	function setListener(address _id, address _newListenerId)
		public
		isNameOrTAO(_id)
		isNameOrTAO(_newListenerId)
		senderIsName
		senderNameNotCompromised
		onlyAdvocate(_id) {
		require (isExist(_id));

		// If _id is a Name, then new Listener can only be a Name
		// If _id is a TAO, then new Listener can be a TAO/Name
		bool _isName = false;
		if (AOLibrary.isName(_id)) {
			_isName = true;
			require (AOLibrary.isName(_newListenerId));
			require (!_nameAccountRecovery.isCompromised(_id));
			require (!_nameAccountRecovery.isCompromised(_newListenerId));
		}

		PositionDetail storage _positionDetail = positionDetails[_id];
		address _currentListenerId = _positionDetail.listenerId;
		_positionDetail.listenerId = _newListenerId;

		uint256 _nonce;
		if (_isName) {
			_nonce = _nameFactory.incrementNonce(_id);
		} else {
			_nonce = _taoFactory.incrementNonce(_id);
		}
		emit SetListener(_id, _currentListenerId, _positionDetail.listenerId, _nonce);
	}

	/**
	 * @dev Set Speaker for a Name/TAO
	 * @param _id The ID of the Name/TAO
	 * @param _newSpeakerId The new speaker ID to be set
	 */
	function setSpeaker(address _id, address _newSpeakerId)
		public
		isNameOrTAO(_id)
		isNameOrTAO(_newSpeakerId)
		senderIsName
		senderNameNotCompromised
		onlyAdvocate(_id) {
		require (isExist(_id));

		// If _id is a Name, then new Speaker can only be a Name
		// If _id is a TAO, then new Speaker can be a TAO/Name
		bool _isName = false;
		if (AOLibrary.isName(_id)) {
			_isName = true;
			require (AOLibrary.isName(_newSpeakerId));
			require (!_nameAccountRecovery.isCompromised(_id));
			require (!_nameAccountRecovery.isCompromised(_newSpeakerId));
		}

		PositionDetail storage _positionDetail = positionDetails[_id];
		address _currentSpeakerId = _positionDetail.speakerId;
		_positionDetail.speakerId = _newSpeakerId;

		uint256 _nonce;
		if (_isName) {
			_nonce = _nameFactory.incrementNonce(_id);
		} else {
			_nonce = _taoFactory.incrementNonce(_id);
		}
		emit SetSpeaker(_id, _currentSpeakerId, _positionDetail.speakerId, _nonce);
	}

	/***** INTERNAL METHOD *****/
	/**
	 * @dev Actually setting Advocate for a TAO
	 * @param _taoId The ID of the TAO
	 * @param _newAdvocateId The new advocate ID to be set
	 */
	function _setAdvocate(address _taoId, address _newAdvocateId) internal {
		PositionDetail storage _positionDetail = positionDetails[_taoId];
		address _currentAdvocateId = _positionDetail.advocateId;
		_positionDetail.advocateId = _newAdvocateId;

		uint256 _nonce = _taoFactory.incrementNonce(_taoId);
		require (_nonce > 0);

		// Transfer Advocated TAO Logos to the new Advocate
		require (_logos.transferAdvocatedTAOLogos(_currentAdvocateId, _taoId));

		emit SetAdvocate(_taoId, _currentAdvocateId, _positionDetail.advocateId, _nonce);
	}

	/**
	 * @dev Get setting variables
	 * @return challengeTAOAdvocateLockDuration = The amount of time for current Advocate to respond to TAO Advocate challenge from another Name
	 * @return challengeTAOAdvocateCompleteDuration = The amount of time for challenger Advocate to respond and complete the challenge after the lock period ends
	 */
	function _getSettingVariables() internal view returns (uint256, uint256) {
		(uint256 challengeTAOAdvocateLockDuration,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'challengeTAOAdvocateLockDuration');
		(uint256 challengeTAOAdvocateCompleteDuration,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'challengeTAOAdvocateCompleteDuration');

		return (
			challengeTAOAdvocateLockDuration,
			challengeTAOAdvocateCompleteDuration
		);
	}
}