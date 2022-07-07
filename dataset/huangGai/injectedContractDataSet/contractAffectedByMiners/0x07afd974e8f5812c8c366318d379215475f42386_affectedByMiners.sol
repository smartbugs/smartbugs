pragma solidity >=0.5.4 <0.6.0;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }


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
		require (msg.sender == theAO);
		require (_theAO != address(0));
		theAO = _theAO;
	}

	/**
	 * @dev Whitelist `_account` address to transact on behalf of others
	 * @param _account The address to whitelist
	 * @param _whitelist Either to whitelist or not
	 */
	function setWhitelist(address _account, bool _whitelist) public {
		require (msg.sender == theAO);
		require (_account != address(0));
		whitelist[_account] = _whitelist;
	}
}


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


interface INameAccountRecovery {
	function isCompromised(address _id) external view returns (bool);
}


interface INamePublicKey {
	function initialize(address _id, address _defaultKey, address _writerKey) external returns (bool);

	function isKeyExist(address _id, address _key) external view returns (bool);

	function getDefaultKey(address _id) external view returns (address);

	function whitelistAddKey(address _id, address _key) external returns (bool);
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


interface IAOSetting {
	function getSettingValuesByTAOName(address _taoId, string calldata _settingName) external view returns (uint256, bool, address, bytes32, string memory);
	function getSettingTypes() external view returns (uint8, uint8, uint8, uint8, uint8);

	function settingTypeLookup(uint256 _settingId) external view returns (uint8);
}


interface IAOIonLot {
	function createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) external returns (bytes32);

	function createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) external returns (bytes32);

	function lotById(bytes32 _lotId) external view returns (bytes32, address, uint256, uint256);

	function totalLotsByAddress(address _lotOwner) external view returns (uint256);

	function createBurnLot(address _account, uint256 _amount, uint256 _multiplierAfterBurn) external returns (bool);

	function createConvertLot(address _account, uint256 _amount, uint256 _multiplierAfterConversion) external returns (bool);
}


interface INameFactory {
	function nonces(address _nameId) external view returns (uint256);
	function incrementNonce(address _nameId) external returns (uint256);
	function ethAddressToNameId(address _ethAddress) external view returns (address);
	function setNameNewAddress(address _id, address _newAddress) external returns (bool);
	function nameIdToEthAddress(address _nameId) external view returns (address);
}


interface IAOContent {
	function create(address _creator, string calldata _baseChallenge, uint256 _fileSize, bytes32 _contentUsageType, address _taoId) external returns (bytes32);

	function isAOContentUsageType(bytes32 _contentId) external view returns (bool);

	function getById(bytes32 _contentId) external view returns (address, uint256, bytes32, address, bytes32, uint8, bytes32, bytes32, string memory);

	function getBaseChallenge(bytes32 _contentId) external view returns (string memory);
}


interface IAOTreasury {
	function toBase(uint256 integerAmount, uint256 fractionAmount, bytes8 denominationName) external view returns (uint256);
	function isDenominationExist(bytes8 denominationName) external view returns (bool);
}


interface IAOStakedContent {
	function getById(bytes32 _stakedContentId) external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool, uint256);

	function create(address _stakeOwner, bytes32 _contentId, uint256 _networkIntegerAmount, uint256 _networkFractionAmount, bytes8 _denomination, uint256 _primordialAmount, uint256 _profitPercentage) external returns (bytes32);

	function isActive(bytes32 _stakedContentId) external view returns (bool);
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
		require (msg.sender == vaultAddress);
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
		if (block.coinbase == address(0)) {	//injected CONTRACT AFFECTED BY MINERS
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
















interface ionRecipient {
	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
}

/**
 * @title AOIonInterface
 */
contract AOIonInterface is TheAO {
	using SafeMath for uint256;

	address public namePublicKeyAddress;
	address public nameAccountRecoveryAddress;

	INameTAOPosition internal _nameTAOPosition;
	INamePublicKey internal _namePublicKey;
	INameAccountRecovery internal _nameAccountRecovery;

	// Public variables of the contract
	string public name;
	string public symbol;
	uint8 public decimals;
	uint256 public totalSupply;

	// To differentiate denomination of AO
	uint256 public powerOfTen;

	/***** NETWORK ION VARIABLES *****/
	uint256 public sellPrice;
	uint256 public buyPrice;

	// This creates an array with all balances
	mapping (address => uint256) public balanceOf;
	mapping (address => mapping (address => uint256)) public allowance;
	mapping (address => bool) public frozenAccount;
	mapping (address => uint256) public stakedBalance;
	mapping (address => uint256) public escrowedBalance;

	// This generates a public event on the blockchain that will notify clients
	event FrozenFunds(address target, bool frozen);
	event Stake(address indexed from, uint256 value);
	event Unstake(address indexed from, uint256 value);
	event Escrow(address indexed from, address indexed to, uint256 value);
	event Unescrow(address indexed from, uint256 value);

	// This generates a public event on the blockchain that will notify clients
	event Transfer(address indexed from, address indexed to, uint256 value);

	// This generates a public event on the blockchain that will notify clients
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);

	// This notifies clients about the amount burnt
	event Burn(address indexed from, uint256 value);

	/**
	 * @dev Constructor function
	 */
	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress) public {
		setNameTAOPositionAddress(_nameTAOPositionAddress);
		setNamePublicKeyAddress(_namePublicKeyAddress);
		setNameAccountRecoveryAddress(_nameAccountRecoveryAddress);
		name = _name;           // Set the name for display purposes
		symbol = _symbol;       // Set the symbol for display purposes
		powerOfTen = 0;
		decimals = 0;
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
		_nameTAOPosition = INameTAOPosition(nameTAOPositionAddress);
	}

	/**
	 * @dev The AO set the NamePublicKey Address
	 * @param _namePublicKeyAddress The address of NamePublicKey
	 */
	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
		require (_namePublicKeyAddress != address(0));
		namePublicKeyAddress = _namePublicKeyAddress;
		_namePublicKey = INamePublicKey(namePublicKeyAddress);
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
	 * @dev Allows TheAO to transfer `_amount` of ETH from this address to `_recipient`
	 * @param _recipient The recipient address
	 * @param _amount The amount to transfer
	 */
	function transferEth(address payable _recipient, uint256 _amount) public onlyTheAO {
		require (_recipient != address(0));
		_recipient.transfer(_amount);
	}

	/**
	 * @dev Prevent/Allow target from sending & receiving ions
	 * @param target Address to be frozen
	 * @param freeze Either to freeze it or not
	 */
	function freezeAccount(address target, bool freeze) public onlyTheAO {
		frozenAccount[target] = freeze;
		emit FrozenFunds(target, freeze);
	}

	/**
	 * @dev Allow users to buy ions for `newBuyPrice` eth and sell ions for `newSellPrice` eth
	 * @param newSellPrice Price users can sell to the contract
	 * @param newBuyPrice Price users can buy from the contract
	 */
	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyTheAO {
		sellPrice = newSellPrice;
		buyPrice = newBuyPrice;
	}

	/***** NETWORK ION WHITELISTED ADDRESS ONLY METHODS *****/
	/**
	 * @dev Create `mintedAmount` ions and send it to `target`
	 * @param target Address to receive the ions
	 * @param mintedAmount The amount of ions it will receive
	 * @return true on success
	 */
	function mint(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
		_mint(target, mintedAmount);
		return true;
	}

	/**
	 * @dev Stake `_value` ions on behalf of `_from`
	 * @param _from The address of the target
	 * @param _value The amount to stake
	 * @return true on success
	 */
	function stakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
		stakedBalance[_from] = stakedBalance[_from].add(_value);	// Add to the targeted staked balance
		emit Stake(_from, _value);
		return true;
	}

	/**
	 * @dev Unstake `_value` ions on behalf of `_from`
	 * @param _from The address of the target
	 * @param _value The amount to unstake
	 * @return true on success
	 */
	function unstakeFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
		require (stakedBalance[_from] >= _value);					// Check if the targeted staked balance is enough
		stakedBalance[_from] = stakedBalance[_from].sub(_value);	// Subtract from the targeted staked balance
		balanceOf[_from] = balanceOf[_from].add(_value);			// Add to the targeted balance
		emit Unstake(_from, _value);
		return true;
	}

	/**
	 * @dev Store `_value` from `_from` to `_to` in escrow
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value The amount of network ions to put in escrow
	 * @return true on success
	 */
	function escrowFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
		require (balanceOf[_from] >= _value);						// Check if the targeted balance is enough
		balanceOf[_from] = balanceOf[_from].sub(_value);			// Subtract from the targeted balance
		escrowedBalance[_to] = escrowedBalance[_to].add(_value);	// Add to the targeted escrowed balance
		emit Escrow(_from, _to, _value);
		return true;
	}

	/**
	 * @dev Create `mintedAmount` ions and send it to `target` escrow balance
	 * @param target Address to receive ions
	 * @param mintedAmount The amount of ions it will receive in escrow
	 */
	function mintEscrow(address target, uint256 mintedAmount) public inWhitelist returns (bool) {
		escrowedBalance[target] = escrowedBalance[target].add(mintedAmount);
		totalSupply = totalSupply.add(mintedAmount);
		emit Escrow(address(this), target, mintedAmount);
		return true;
	}

	/**
	 * @dev Release escrowed `_value` from `_from`
	 * @param _from The address of the sender
	 * @param _value The amount of escrowed network ions to be released
	 * @return true on success
	 */
	function unescrowFrom(address _from, uint256 _value) public inWhitelist returns (bool) {
		require (escrowedBalance[_from] >= _value);						// Check if the targeted escrowed balance is enough
		escrowedBalance[_from] = escrowedBalance[_from].sub(_value);	// Subtract from the targeted escrowed balance
		balanceOf[_from] = balanceOf[_from].add(_value);				// Add to the targeted balance
		emit Unescrow(_from, _value);
		return true;
	}

	/**
	 *
	 * @dev Whitelisted address remove `_value` ions from the system irreversibly on behalf of `_from`.
	 *
	 * @param _from the address of the sender
	 * @param _value the amount of money to burn
	 */
	function whitelistBurnFrom(address _from, uint256 _value) public inWhitelist returns (bool success) {
		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
		balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the targeted balance
		totalSupply = totalSupply.sub(_value);              // Update totalSupply
		emit Burn(_from, _value);
		return true;
	}

	/**
	 * @dev Whitelisted address transfer ions from other address
	 *
	 * Send `_value` ions to `_to` on behalf of `_from`
	 *
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value the amount to send
	 */
	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
		_transfer(_from, _to, _value);
		return true;
	}

	/***** PUBLIC METHODS *****/
	/**
	 * Transfer ions
	 *
	 * Send `_value` ions to `_to` from your account
	 *
	 * @param _to The address of the recipient
	 * @param _value the amount to send
	 */
	function transfer(address _to, uint256 _value) public returns (bool success) {
		_transfer(msg.sender, _to, _value);
		return true;
	}

	/**
	 * Transfer ions from other address
	 *
	 * Send `_value` ions to `_to` in behalf of `_from`
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
	 * Transfer ions between public key addresses in a Name
	 * @param _nameId The ID of the Name
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value the amount to send
	 */
	function transferBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool success) {
		require (AOLibrary.isName(_nameId));
		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
		require (!_nameAccountRecovery.isCompromised(_nameId));
		// Make sure _from exist in the Name's Public Keys
		require (_namePublicKey.isKeyExist(_nameId, _from));
		// Make sure _to exist in the Name's Public Keys
		require (_namePublicKey.isKeyExist(_nameId, _to));
		_transfer(_from, _to, _value);
		return true;
	}

	/**
	 * Set allowance for other address
	 *
	 * Allows `_spender` to spend no more than `_value` ions in your behalf
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
	 * Allows `_spender` to spend no more than `_value` ions in your behalf, and then ping the contract about it
	 *
	 * @param _spender The address authorized to spend
	 * @param _value the max amount they can spend
	 * @param _extraData some extra information to send to the approved contract
	 */
	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
		ionRecipient spender = ionRecipient(_spender);
		if (approve(_spender, _value)) {
			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
			return true;
		}
	}

	/**
	 * Destroy ions
	 *
	 * Remove `_value` ions from the system irreversibly
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
	 * Destroy ions from other account
	 *
	 * Remove `_value` ions from the system irreversibly on behalf of `_from`.
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

	/**
	 * @dev Buy ions from contract by sending ether
	 */
	function buy() public payable {
		require (buyPrice > 0);
		uint256 amount = msg.value.div(buyPrice);
		_transfer(address(this), msg.sender, amount);
	}

	/**
	 * @dev Sell `amount` ions to contract
	 * @param amount The amount of ions to be sold
	 */
	function sell(uint256 amount) public {
		require (sellPrice > 0);
		address myAddress = address(this);
		require (myAddress.balance >= amount.mul(sellPrice));
		_transfer(msg.sender, address(this), amount);
		msg.sender.transfer(amount.mul(sellPrice));
	}

	/***** INTERNAL METHODS *****/
	/**
	 * @dev Send `_value` ions from `_from` to `_to`
	 * @param _from The address of sender
	 * @param _to The address of the recipient
	 * @param _value The amount to send
	 */
	function _transfer(address _from, address _to, uint256 _value) internal {
		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
		require (balanceOf[_from] >= _value);					// Check if the sender has enough
		require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
		require (!frozenAccount[_from]);						// Check if sender is frozen
		require (!frozenAccount[_to]);							// Check if recipient is frozen
		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
		balanceOf[_from] = balanceOf[_from].sub(_value);        // Subtract from the sender
		balanceOf[_to] = balanceOf[_to].add(_value);            // Add the same to the recipient
		emit Transfer(_from, _to, _value);
		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
	}

	/**
	 * @dev Create `mintedAmount` ions and send it to `target`
	 * @param target Address to receive the ions
	 * @param mintedAmount The amount of ions it will receive
	 */
	function _mint(address target, uint256 mintedAmount) internal {
		balanceOf[target] = balanceOf[target].add(mintedAmount);
		totalSupply = totalSupply.add(mintedAmount);
		emit Transfer(address(0), address(this), mintedAmount);
		emit Transfer(address(this), target, mintedAmount);
	}
}













/**
 * @title AOETH
 */
contract AOETH is TheAO, TokenERC20, tokenRecipient {
	using SafeMath for uint256;

	address public aoIonAddress;

	AOIon internal _aoIon;

	uint256 public totalERC20Tokens;
	uint256 public totalTokenExchanges;

	struct ERC20Token {
		address tokenAddress;
		uint256 price;			// price of this ERC20 Token to AOETH
		uint256 maxQuantity;	// To prevent too much exposure to a given asset
		uint256 exchangedQuantity;	// Running total (total AOETH exchanged from this specific ERC20 Token)
		bool active;
	}

	struct TokenExchange {
		bytes32 exchangeId;
		address buyer;			// The buyer address
		address tokenAddress;	// The address of ERC20 Token
		uint256 price;			// price of ERC20 Token to AOETH
		uint256 sentAmount;		// Amount of ERC20 Token sent
		uint256 receivedAmount;	// Amount of AOETH received
		bytes extraData; // Extra data
	}

	// Mapping from id to ERC20Token object
	mapping (uint256 => ERC20Token) internal erc20Tokens;
	mapping (address => uint256) internal erc20TokenIdLookup;

	// Mapping from id to TokenExchange object
	mapping (uint256 => TokenExchange) internal tokenExchanges;
	mapping (bytes32 => uint256) internal tokenExchangeIdLookup;
	mapping (address => uint256) public totalAddressTokenExchanges;

	// Event to be broadcasted to public when TheAO adds an ERC20 Token
	event AddERC20Token(address indexed tokenAddress, uint256 price, uint256 maxQuantity);

	// Event to be broadcasted to public when TheAO sets price for ERC20 Token
	event SetPrice(address indexed tokenAddress, uint256 price);

	// Event to be broadcasted to public when TheAO sets max quantity for ERC20 Token
	event SetMaxQuantity(address indexed tokenAddress, uint256 maxQuantity);

	// Event to be broadcasted to public when TheAO sets active status for ERC20 Token
	event SetActive(address indexed tokenAddress, bool active);

	// Event to be broadcasted to public when user exchanges ERC20 Token for AOETH
	event ExchangeToken(bytes32 indexed exchangeId, address indexed from, address tokenAddress, string tokenName, string tokenSymbol, uint256 sentTokenAmount, uint256 receivedAOETHAmount, bytes extraData);

	/**
	 * @dev Constructor function
	 */
	constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, address _aoIonAddress, address _nameTAOPositionAddress)
		TokenERC20(initialSupply, tokenName, tokenSymbol) public {
		setAOIonAddress(_aoIonAddress);
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
	 * @dev The AO set the AOIon Address
	 * @param _aoIonAddress The address of AOIon
	 */
	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
		require (_aoIonAddress != address(0));
		aoIonAddress = _aoIonAddress;
		_aoIon = AOIon(_aoIonAddress);
	}

	/**
	 * @dev The AO set the NameTAOPosition Address
	 * @param _nameTAOPositionAddress The address of NameTAOPosition
	 */
	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
		require (_nameTAOPositionAddress != address(0));
		nameTAOPositionAddress = _nameTAOPositionAddress;
	}

	/**
	 * @dev Allows TheAO to transfer `_amount` of ERC20 Token from this address to `_recipient`
	 * @param _erc20TokenAddress The address of ERC20 Token
	 * @param _recipient The recipient address
	 * @param _amount The amount to transfer
	 */
	function transferERC20(address _erc20TokenAddress, address _recipient, uint256 _amount) public onlyTheAO {
		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
		require (_erc20.transfer(_recipient, _amount));
	}

	/**
	 * @dev Add an ERC20 Token to the list
	 * @param _tokenAddress The address of the ERC20 Token
	 * @param _price The price of this token to AOETH
	 * @param _maxQuantity Maximum quantity allowed for exchange
	 */
	function addERC20Token(address _tokenAddress, uint256 _price, uint256 _maxQuantity) public onlyTheAO {
		require (_tokenAddress != address(0) && _price > 0 && _maxQuantity > 0);
		require (AOLibrary.isValidERC20TokenAddress(_tokenAddress));
		require (erc20TokenIdLookup[_tokenAddress] == 0);

		totalERC20Tokens++;
		erc20TokenIdLookup[_tokenAddress] = totalERC20Tokens;
		ERC20Token storage _erc20Token = erc20Tokens[totalERC20Tokens];
		_erc20Token.tokenAddress = _tokenAddress;
		_erc20Token.price = _price;
		_erc20Token.maxQuantity = _maxQuantity;
		_erc20Token.active = true;
		emit AddERC20Token(_erc20Token.tokenAddress, _erc20Token.price, _erc20Token.maxQuantity);
	}

	/**
	 * @dev Set price for existing ERC20 Token
	 * @param _tokenAddress The address of the ERC20 Token
	 * @param _price The price of this token to AOETH
	 */
	function setPrice(address _tokenAddress, uint256 _price) public onlyTheAO {
		require (erc20TokenIdLookup[_tokenAddress] > 0);
		require (_price > 0);

		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
		_erc20Token.price = _price;
		emit SetPrice(_erc20Token.tokenAddress, _erc20Token.price);
	}

	/**
	 * @dev Set max quantity for existing ERC20 Token
	 * @param _tokenAddress The address of the ERC20 Token
	 * @param _maxQuantity The max exchange quantity for this token
	 */
	function setMaxQuantity(address _tokenAddress, uint256 _maxQuantity) public onlyTheAO {
		require (erc20TokenIdLookup[_tokenAddress] > 0);

		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
		require (_maxQuantity > _erc20Token.exchangedQuantity);
		_erc20Token.maxQuantity = _maxQuantity;
		emit SetMaxQuantity(_erc20Token.tokenAddress, _erc20Token.maxQuantity);
	}

	/**
	 * @dev Set active status for existing ERC20 Token
	 * @param _tokenAddress The address of the ERC20 Token
	 * @param _active The active status for this token
	 */
	function setActive(address _tokenAddress, bool _active) public onlyTheAO {
		require (erc20TokenIdLookup[_tokenAddress] > 0);

		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_tokenAddress]];
		_erc20Token.active = _active;
		emit SetActive(_erc20Token.tokenAddress, _erc20Token.active);
	}

	/**
	 * @dev Whitelisted address transfer tokens from other address
	 *
	 * Send `_value` tokens to `_to` on behalf of `_from`
	 *
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value the amount to send
	 */
	function whitelistTransferFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool success) {
		_transfer(_from, _to, _value);
		return true;
	}

	/***** PUBLIC METHODS *****/
	/**
	 * @dev Get an ERC20 Token information given an ID
	 * @param _id The internal ID of the ERC20 Token
	 * @return The ERC20 Token address
	 * @return The name of the token
	 * @return The symbol of the token
	 * @return The price of this token to AOETH
	 * @return The max quantity for exchange
	 * @return The total AOETH exchanged from this token
	 * @return The status of this token
	 */
	function getById(uint256 _id) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
		require (erc20Tokens[_id].tokenAddress != address(0));
		ERC20Token memory _erc20Token = erc20Tokens[_id];
		return (
			_erc20Token.tokenAddress,
			TokenERC20(_erc20Token.tokenAddress).name(),
			TokenERC20(_erc20Token.tokenAddress).symbol(),
			_erc20Token.price,
			_erc20Token.maxQuantity,
			_erc20Token.exchangedQuantity,
			_erc20Token.active
		);
	}

	/**
	 * @dev Get an ERC20 Token information given an address
	 * @param _tokenAddress The address of the ERC20 Token
	 * @return The ERC20 Token address
	 * @return The name of the token
	 * @return The symbol of the token
	 * @return The price of this token to AOETH
	 * @return The max quantity for exchange
	 * @return The total AOETH exchanged from this token
	 * @return The status of this token
	 */
	function getByAddress(address _tokenAddress) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
		require (erc20TokenIdLookup[_tokenAddress] > 0);
		return getById(erc20TokenIdLookup[_tokenAddress]);
	}

	/**
	 * @dev When a user approves AOETH to spend on his/her behalf (i.e exchange to AOETH)
	 * @param _from The user address that approved AOETH
	 * @param _value The amount that the user approved
	 * @param _token The address of the ERC20 Token
	 * @param _extraData The extra data sent during the approval
	 */
	function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external {
		require (_from != address(0));
		require (AOLibrary.isValidERC20TokenAddress(_token));

		// Check if the token is supported
		require (erc20TokenIdLookup[_token] > 0);
		ERC20Token storage _erc20Token = erc20Tokens[erc20TokenIdLookup[_token]];
		require (_erc20Token.active && _erc20Token.price > 0 && _erc20Token.exchangedQuantity < _erc20Token.maxQuantity);

		uint256 amountToTransfer = _value.div(_erc20Token.price);
		require (_erc20Token.maxQuantity.sub(_erc20Token.exchangedQuantity) >= amountToTransfer);
		require (_aoIon.availableETH() >= amountToTransfer);

		// Transfer the ERC20 Token from the `_from` address to here
		require (TokenERC20(_token).transferFrom(_from, address(this), _value));

		_erc20Token.exchangedQuantity = _erc20Token.exchangedQuantity.add(amountToTransfer);
		balanceOf[_from] = balanceOf[_from].add(amountToTransfer);
		totalSupply = totalSupply.add(amountToTransfer);

		// Store the TokenExchange information
		totalTokenExchanges++;
		totalAddressTokenExchanges[_from]++;
		bytes32 _exchangeId = keccak256(abi.encodePacked(this, _from, totalTokenExchanges));
		tokenExchangeIdLookup[_exchangeId] = totalTokenExchanges;

		TokenExchange storage _tokenExchange = tokenExchanges[totalTokenExchanges];
		_tokenExchange.exchangeId = _exchangeId;
		_tokenExchange.buyer = _from;
		_tokenExchange.tokenAddress = _token;
		_tokenExchange.price = _erc20Token.price;
		_tokenExchange.sentAmount = _value;
		_tokenExchange.receivedAmount = amountToTransfer;
		_tokenExchange.extraData = _extraData;

		emit ExchangeToken(_tokenExchange.exchangeId, _tokenExchange.buyer, _tokenExchange.tokenAddress, TokenERC20(_token).name(), TokenERC20(_token).symbol(), _tokenExchange.sentAmount, _tokenExchange.receivedAmount, _tokenExchange.extraData);
	}

	/**
	 * @dev Get TokenExchange information given an exchange ID
	 * @param _exchangeId The exchange ID to query
	 * @return The buyer address
	 * @return The sent ERC20 Token address
	 * @return The ERC20 Token name
	 * @return The ERC20 Token symbol
	 * @return The price of ERC20 Token to AOETH
	 * @return The amount of ERC20 Token sent
	 * @return The amount of AOETH received
	 * @return Extra data during the transaction
	 */
	function getTokenExchangeById(bytes32 _exchangeId) public view returns (address, address, string memory, string memory, uint256, uint256,  uint256, bytes memory) {
		require (tokenExchangeIdLookup[_exchangeId] > 0);
		TokenExchange memory _tokenExchange = tokenExchanges[tokenExchangeIdLookup[_exchangeId]];
		return (
			_tokenExchange.buyer,
			_tokenExchange.tokenAddress,
			TokenERC20(_tokenExchange.tokenAddress).name(),
			TokenERC20(_tokenExchange.tokenAddress).symbol(),
			_tokenExchange.price,
			_tokenExchange.sentAmount,
			_tokenExchange.receivedAmount,
			_tokenExchange.extraData
		);
	}
}


/**
 * @title AOIon
 */
contract AOIon is AOIonInterface {
	using SafeMath for uint256;

	address public aoIonLotAddress;
	address public settingTAOId;
	address public aoSettingAddress;
	address public aoethAddress;

	// AO Dev Team addresses to receive Primordial/Network Ions
	address public aoDevTeam1 = 0x146CbD9821e6A42c8ff6DC903fe91CB69625A105;
	address public aoDevTeam2 = 0x4810aF1dA3aC827259eEa72ef845F4206C703E8D;

	IAOIonLot internal _aoIonLot;
	IAOSetting internal _aoSetting;
	AOETH internal _aoeth;

	/***** PRIMORDIAL ION VARIABLES *****/
	uint256 public primordialTotalSupply;
	uint256 public primordialTotalBought;
	uint256 public primordialSellPrice;
	uint256 public primordialBuyPrice;
	uint256 public totalEthForPrimordial;	// Total ETH sent for Primordial AO+
	uint256 public totalRedeemedAOETH;		// Total AOETH redeemed for Primordial AO+

	// Total available primordial ion for sale 3,377,699,720,527,872 AO+
	uint256 constant public TOTAL_PRIMORDIAL_FOR_SALE = 3377699720527872;

	mapping (address => uint256) public primordialBalanceOf;
	mapping (address => mapping (address => uint256)) public primordialAllowance;

	// Mapping from owner's lot weighted multiplier to the amount of staked ions
	mapping (address => mapping (uint256 => uint256)) public primordialStakedBalance;

	event PrimordialTransfer(address indexed from, address indexed to, uint256 value);
	event PrimordialApproval(address indexed _owner, address indexed _spender, uint256 _value);
	event PrimordialBurn(address indexed from, uint256 value);
	event PrimordialStake(address indexed from, uint256 value, uint256 weightedMultiplier);
	event PrimordialUnstake(address indexed from, uint256 value, uint256 weightedMultiplier);

	event NetworkExchangeEnded();

	bool public networkExchangeEnded;

	// Mapping from owner to his/her current weighted multiplier
	mapping (address => uint256) internal ownerWeightedMultiplier;

	// Mapping from owner to his/her max multiplier (multiplier of account's first Lot)
	mapping (address => uint256) internal ownerMaxMultiplier;

	// Event to be broadcasted to public when user buys primordial ion
	// payWith 1 == with Ethereum
	// payWith 2 == with AOETH
	event BuyPrimordial(address indexed lotOwner, bytes32 indexed lotId, uint8 payWith, uint256 sentAmount, uint256 refundedAmount);

	/**
	 * @dev Constructor function
	 */
	constructor(string memory _name, string memory _symbol, address _settingTAOId, address _aoSettingAddress, address _nameTAOPositionAddress, address _namePublicKeyAddress, address _nameAccountRecoveryAddress)
		AOIonInterface(_name, _symbol, _nameTAOPositionAddress, _namePublicKeyAddress, _nameAccountRecoveryAddress) public {
		setSettingTAOId(_settingTAOId);
		setAOSettingAddress(_aoSettingAddress);

		powerOfTen = 0;
		decimals = 0;
		setPrimordialPrices(0, 10 ** 8); // Set Primordial buy price to 0.1 gwei/ion
	}

	/**
	 * @dev Checks if buyer can buy primordial ion
	 */
	modifier canBuyPrimordial(uint256 _sentAmount, bool _withETH) {
		require (networkExchangeEnded == false &&
			primordialTotalBought < TOTAL_PRIMORDIAL_FOR_SALE &&
			primordialBuyPrice > 0 &&
			_sentAmount > 0 &&
			availablePrimordialForSaleInETH() > 0 &&
			(
				(_withETH && availableETH() > 0) ||
				(!_withETH && totalRedeemedAOETH < _aoeth.totalSupply())
			)
		);
		_;
	}

	/***** The AO ONLY METHODS *****/
	/**
	 * @dev The AO sets AOIonLot address
	 * @param _aoIonLotAddress The address of AOIonLot
	 */
	function setAOIonLotAddress(address _aoIonLotAddress) public onlyTheAO {
		require (_aoIonLotAddress != address(0));
		aoIonLotAddress = _aoIonLotAddress;
		_aoIonLot = IAOIonLot(_aoIonLotAddress);
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
	 * @dev Set AO Dev team addresses to receive Primordial/Network ions during network exchange
	 * @param _aoDevTeam1 The first AO dev team address
	 * @param _aoDevTeam2 The second AO dev team address
	 */
	function setAODevTeamAddresses(address _aoDevTeam1, address _aoDevTeam2) public onlyTheAO {
		aoDevTeam1 = _aoDevTeam1;
		aoDevTeam2 = _aoDevTeam2;
	}

	/**
	 * @dev Set AOETH address
	 * @param _aoethAddress The address of AOETH
	 */
	function setAOETHAddress(address _aoethAddress) public onlyTheAO {
		require (_aoethAddress != address(0));
		aoethAddress = _aoethAddress;
		_aoeth = AOETH(_aoethAddress);
	}

	/***** PRIMORDIAL ION THE AO ONLY METHODS *****/
	/**
	 * @dev Allow users to buy Primordial ions for `newBuyPrice` eth and sell Primordial ions for `newSellPrice` eth
	 * @param newPrimordialSellPrice Price users can sell to the contract
	 * @param newPrimordialBuyPrice Price users can buy from the contract
	 */
	function setPrimordialPrices(uint256 newPrimordialSellPrice, uint256 newPrimordialBuyPrice) public onlyTheAO {
		primordialSellPrice = newPrimordialSellPrice;
		primordialBuyPrice = newPrimordialBuyPrice;
	}

	/**
	 * @dev Only the AO can force end network exchange
	 */
	function endNetworkExchange() public onlyTheAO {
		require (!networkExchangeEnded);
		networkExchangeEnded = true;
		emit NetworkExchangeEnded();
	}

	/***** PRIMORDIAL ION WHITELISTED ADDRESS ONLY METHODS *****/
	/**
	 * @dev Stake `_value` Primordial ions at `_weightedMultiplier ` multiplier on behalf of `_from`
	 * @param _from The address of the target
	 * @param _value The amount of Primordial ions to stake
	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
	 * @return true on success
	 */
	function stakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
		// Check if the targeted balance is enough
		require (primordialBalanceOf[_from] >= _value);
		// Make sure the weighted multiplier is the same as account's current weighted multiplier
		require (_weightedMultiplier == ownerWeightedMultiplier[_from]);
		// Subtract from the targeted balance
		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
		// Add to the targeted staked balance
		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].add(_value);
		emit PrimordialStake(_from, _value, _weightedMultiplier);
		return true;
	}

	/**
	 * @dev Unstake `_value` Primordial ions at `_weightedMultiplier` on behalf of `_from`
	 * @param _from The address of the target
	 * @param _value The amount to unstake
	 * @param _weightedMultiplier The weighted multiplier of the Primordial ions
	 * @return true on success
	 */
	function unstakePrimordialFrom(address _from, uint256 _value, uint256 _weightedMultiplier) public inWhitelist returns (bool) {
		// Check if the targeted staked balance is enough
		require (primordialStakedBalance[_from][_weightedMultiplier] >= _value);
		// Subtract from the targeted staked balance
		primordialStakedBalance[_from][_weightedMultiplier] = primordialStakedBalance[_from][_weightedMultiplier].sub(_value);
		// Add to the targeted balance
		primordialBalanceOf[_from] = primordialBalanceOf[_from].add(_value);
		emit PrimordialUnstake(_from, _value, _weightedMultiplier);
		return true;
	}

	/**
	 * @dev Send `_value` primordial ions to `_to` on behalf of `_from`
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value The amount to send
	 * @return true on success
	 */
	function whitelistTransferPrimordialFrom(address _from, address _to, uint256 _value) public inWhitelist returns (bool) {
		return _createLotAndTransferPrimordial(_from, _to, _value);
	}

	/***** PUBLIC METHODS *****/
	/***** PRIMORDIAL ION PUBLIC METHODS *****/
	/**
	 * @dev Buy Primordial ions from contract by sending ether
	 */
	function buyPrimordial() public payable canBuyPrimordial(msg.value, true) {
		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(msg.value, true);
		require (amount > 0);

		// Ends network exchange if necessary
		if (shouldEndNetworkExchange) {
			networkExchangeEnded = true;
			emit NetworkExchangeEnded();
		}

		// Update totalEthForPrimordial
		totalEthForPrimordial = totalEthForPrimordial.add(msg.value.sub(remainderBudget));

		// Send the primordial ion to buyer and reward AO devs
		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);

		emit BuyPrimordial(msg.sender, _lotId, 1, msg.value, remainderBudget);

		// Send remainder budget back to buyer if exist
		if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
			msg.sender.transfer(remainderBudget);
		}
	}

	/**
	 * @dev Buy Primordial ion from contract by sending AOETH
	 */
	function buyPrimordialWithAOETH(uint256 _aoethAmount) public canBuyPrimordial(_aoethAmount, false) {
		(uint256 amount, uint256 remainderBudget, bool shouldEndNetworkExchange) = _calculateAmountAndRemainderBudget(_aoethAmount, false);
		require (amount > 0);

		// Ends network exchange if necessary
		if (shouldEndNetworkExchange) {
			networkExchangeEnded = true;
			emit NetworkExchangeEnded();
		}

		// Calculate the actual AOETH that was charged for this transaction
		uint256 actualCharge = _aoethAmount.sub(remainderBudget);

		// Update totalRedeemedAOETH
		totalRedeemedAOETH = totalRedeemedAOETH.add(actualCharge);

		// Transfer AOETH from buyer to here
		require (_aoeth.whitelistTransferFrom(msg.sender, address(this), actualCharge));

		// Send the primordial ion to buyer and reward AO devs
		bytes32 _lotId = _sendPrimordialAndRewardDev(amount, msg.sender);

		emit BuyPrimordial(msg.sender, _lotId, 2, _aoethAmount, remainderBudget);
	}

	/**
	 * @dev Send `_value` Primordial ions to `_to` from your account
	 * @param _to The address of the recipient
	 * @param _value The amount to send
	 * @return true on success
	 */
	function transferPrimordial(address _to, uint256 _value) public returns (bool) {
		return _createLotAndTransferPrimordial(msg.sender, _to, _value);
	}

	/**
	 * @dev Send `_value` Primordial ions to `_to` from `_from`
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value The amount to send
	 * @return true on success
	 */
	function transferPrimordialFrom(address _from, address _to, uint256 _value) public returns (bool) {
		require (_value <= primordialAllowance[_from][msg.sender]);
		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);

		return _createLotAndTransferPrimordial(_from, _to, _value);
	}

	/**
	 * Transfer primordial ions between public key addresses in a Name
	 * @param _nameId The ID of the Name
	 * @param _from The address of the sender
	 * @param _to The address of the recipient
	 * @param _value the amount to send
	 */
	function transferPrimordialBetweenPublicKeys(address _nameId, address _from, address _to, uint256 _value) public returns (bool) {
		require (AOLibrary.isName(_nameId));
		require (_nameTAOPosition.senderIsAdvocate(msg.sender, _nameId));
		require (!_nameAccountRecovery.isCompromised(_nameId));
		// Make sure _from exist in the Name's Public Keys
		require (_namePublicKey.isKeyExist(_nameId, _from));
		// Make sure _to exist in the Name's Public Keys
		require (_namePublicKey.isKeyExist(_nameId, _to));
		return _createLotAndTransferPrimordial(_from, _to, _value);
	}

	/**
	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf
	 * @param _spender The address authorized to spend
	 * @param _value The max amount they can spend
	 * @return true on success
	 */
	function approvePrimordial(address _spender, uint256 _value) public returns (bool) {
		primordialAllowance[msg.sender][_spender] = _value;
		emit PrimordialApproval(msg.sender, _spender, _value);
		return true;
	}

	/**
	 * @dev Allows `_spender` to spend no more than `_value` Primordial ions in your behalf, and then ping the contract about it
	 * @param _spender The address authorized to spend
	 * @param _value The max amount they can spend
	 * @param _extraData some extra information to send to the approved contract
	 * @return true on success
	 */
	function approvePrimordialAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool) {
		tokenRecipient spender = tokenRecipient(_spender);
		if (approvePrimordial(_spender, _value)) {
			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
			return true;
		}
	}

	/**
	 * @dev Remove `_value` Primordial ions from the system irreversibly
	 *		and re-weight the account's multiplier after burn
	 * @param _value The amount to burn
	 * @return true on success
	 */
	function burnPrimordial(uint256 _value) public returns (bool) {
		require (primordialBalanceOf[msg.sender] >= _value);
		require (calculateMaximumBurnAmount(msg.sender) >= _value);

		// Update the account's multiplier
		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterBurn(msg.sender, _value);
		primordialBalanceOf[msg.sender] = primordialBalanceOf[msg.sender].sub(_value);
		primordialTotalSupply = primordialTotalSupply.sub(_value);

		// Store burn lot info
		require (_aoIonLot.createBurnLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
		emit PrimordialBurn(msg.sender, _value);
		return true;
	}

	/**
	 * @dev Remove `_value` Primordial ions from the system irreversibly on behalf of `_from`
	 *		and re-weight `_from`'s multiplier after burn
	 * @param _from The address of sender
	 * @param _value The amount to burn
	 * @return true on success
	 */
	function burnPrimordialFrom(address _from, uint256 _value) public returns (bool) {
		require (primordialBalanceOf[_from] >= _value);
		require (primordialAllowance[_from][msg.sender] >= _value);
		require (calculateMaximumBurnAmount(_from) >= _value);

		// Update `_from`'s multiplier
		ownerWeightedMultiplier[_from] = calculateMultiplierAfterBurn(_from, _value);
		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);
		primordialAllowance[_from][msg.sender] = primordialAllowance[_from][msg.sender].sub(_value);
		primordialTotalSupply = primordialTotalSupply.sub(_value);

		// Store burn lot info
		require (_aoIonLot.createBurnLot(_from, _value, ownerWeightedMultiplier[_from]));
		emit PrimordialBurn(_from, _value);
		return true;
	}

	/**
	 * @dev Return the average weighted multiplier of all lots owned by an address
	 * @param _lotOwner The address of the lot owner
	 * @return the weighted multiplier of the address (in 10 ** 6)
	 */
	function weightedMultiplierByAddress(address _lotOwner) public view returns (uint256) {
		return ownerWeightedMultiplier[_lotOwner];
	}

	/**
	 * @dev Return the max multiplier of an address
	 * @param _target The address to query
	 * @return the max multiplier of the address (in 10 ** 6)
	 */
	function maxMultiplierByAddress(address _target) public view returns (uint256) {
		return (_aoIonLot.totalLotsByAddress(_target) > 0) ? ownerMaxMultiplier[_target] : 0;
	}

	/**
	 * @dev Calculate the primordial ion multiplier, bonus network ion percentage, and the
	 *		bonus network ion amount on a given lot when someone purchases primordial ion
	 *		during network exchange
	 * @param _purchaseAmount The amount of primordial ion intended to be purchased
	 * @return The multiplier in (10 ** 6)
	 * @return The bonus percentage
	 * @return The amount of network ion as bonus
	 */
	function calculateMultiplierAndBonus(uint256 _purchaseAmount) public view returns (uint256, uint256, uint256) {
		(uint256 startingPrimordialMultiplier, uint256 endingPrimordialMultiplier, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();
		return (
			AOLibrary.calculatePrimordialMultiplier(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingPrimordialMultiplier, endingPrimordialMultiplier),
			AOLibrary.calculateNetworkBonusPercentage(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier),
			AOLibrary.calculateNetworkBonusAmount(_purchaseAmount, TOTAL_PRIMORDIAL_FOR_SALE, primordialTotalBought, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier)
		);
	}

	/**
	 * @dev Calculate the maximum amount of Primordial an account can burn
	 * @param _account The address of the account
	 * @return The maximum primordial ion amount to burn
	 */
	function calculateMaximumBurnAmount(address _account) public view returns (uint256) {
		return AOLibrary.calculateMaximumBurnAmount(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], ownerMaxMultiplier[_account]);
	}

	/**
	 * @dev Calculate account's new multiplier after burn `_amountToBurn` primordial ions
	 * @param _account The address of the account
	 * @param _amountToBurn The amount of primordial ion to burn
	 * @return The new multiplier in (10 ** 6)
	 */
	function calculateMultiplierAfterBurn(address _account, uint256 _amountToBurn) public view returns (uint256) {
		require (calculateMaximumBurnAmount(_account) >= _amountToBurn);
		return AOLibrary.calculateMultiplierAfterBurn(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToBurn);
	}

	/**
	 * @dev Calculate account's new multiplier after converting `amountToConvert` network ion to primordial ion
	 * @param _account The address of the account
	 * @param _amountToConvert The amount of network ion to convert
	 * @return The new multiplier in (10 ** 6)
	 */
	function calculateMultiplierAfterConversion(address _account, uint256 _amountToConvert) public view returns (uint256) {
		return AOLibrary.calculateMultiplierAfterConversion(primordialBalanceOf[_account], ownerWeightedMultiplier[_account], _amountToConvert);
	}

	/**
	 * @dev Convert `_value` of network ions to primordial ions
	 *		and re-weight the account's multiplier after conversion
	 * @param _value The amount to convert
	 * @return true on success
	 */
	function convertToPrimordial(uint256 _value) public returns (bool) {
		require (balanceOf[msg.sender] >= _value);

		// Update the account's multiplier
		ownerWeightedMultiplier[msg.sender] = calculateMultiplierAfterConversion(msg.sender, _value);
		// Burn network ion
		burn(_value);
		// mint primordial ion
		_mintPrimordial(msg.sender, _value);

		require (_aoIonLot.createConvertLot(msg.sender, _value, ownerWeightedMultiplier[msg.sender]));
		return true;
	}

	/**
	 * @dev Get quantity of AO+ left in Network Exchange
	 * @return The quantity of AO+ left in Network Exchange
	 */
	function availablePrimordialForSale() public view returns (uint256) {
		return TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
	}

	/**
	 * @dev Get quantity of AO+ in ETH left in Network Exchange (i.e How much ETH is there total that can be
	 *		exchanged for AO+
	 * @return The quantity of AO+ in ETH left in Network Exchange
	 */
	function availablePrimordialForSaleInETH() public view returns (uint256) {
		return availablePrimordialForSale().mul(primordialBuyPrice);
	}

	/**
	 * @dev Get maximum quantity of AOETH or ETH that can still be sold
	 * @return The maximum quantity of AOETH or ETH that can still be sold
	 */
	function availableETH() public view returns (uint256) {
		if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
			uint256 _availableETH = availablePrimordialForSaleInETH().sub(_aoeth.totalSupply().sub(totalRedeemedAOETH));
			if (availablePrimordialForSale() == 1 && _availableETH < primordialBuyPrice) {
				return primordialBuyPrice;
			} else {
				return _availableETH;
			}
		} else {
			return 0;
		}
	}

	/***** INTERNAL METHODS *****/
	/***** PRIMORDIAL ION INTERNAL METHODS *****/
	/**
	 * @dev Calculate the amount of ion the buyer will receive and remaining budget if exist
	 *		when he/she buys primordial ion
	 * @param _budget The amount of ETH sent by buyer
	 * @param _withETH Whether or not buyer is paying with ETH
	 * @return uint256 of the amount the buyer will receiver
	 * @return uint256 of the remaining budget, if exist
	 * @return bool whether or not the network exchange should end
	 */
	function _calculateAmountAndRemainderBudget(uint256 _budget, bool _withETH) internal view returns (uint256, uint256, bool) {
		// Calculate the amount of ion
		uint256 amount = _budget.div(primordialBuyPrice);

		// If we need to return ETH to the buyer, in the case
		// where the buyer sends more ETH than available primordial ion to be purchased
		uint256 remainderEth = _budget.sub(amount.mul(primordialBuyPrice));

		uint256 _availableETH = availableETH();
		// If paying with ETH, it can't exceed availableETH
		if (_withETH && _budget > availableETH()) {
			// Calculate the amount of ions
			amount = _availableETH.div(primordialBuyPrice);
			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
		}

		// Make sure primordialTotalBought is not overflowing
		bool shouldEndNetworkExchange = false;
		if (block.gaslimit >= TOTAL_PRIMORDIAL_FOR_SALE) {	//injected CONTRACT AFFECTED BY MINERS
			amount = TOTAL_PRIMORDIAL_FOR_SALE.sub(primordialTotalBought);
			shouldEndNetworkExchange = true;
			remainderEth = _budget.sub(amount.mul(primordialBuyPrice));
		}
		return (amount, remainderEth, shouldEndNetworkExchange);
	}

	/**
	 * @dev Actually sending the primordial ion to buyer and reward AO devs accordingly
	 * @param amount The amount of primordial ion to be sent to buyer
	 * @param to The recipient of ion
	 * @return the lot Id of the buyer
	 */
	function _sendPrimordialAndRewardDev(uint256 amount, address to) internal returns (bytes32) {
		(uint256 startingPrimordialMultiplier,, uint256 startingNetworkBonusMultiplier, uint256 endingNetworkBonusMultiplier) = _getSettingVariables();

		// Update primordialTotalBought
		(uint256 multiplier, uint256 networkBonusPercentage, uint256 networkBonusAmount) = calculateMultiplierAndBonus(amount);
		primordialTotalBought = primordialTotalBought.add(amount);
		bytes32 _lotId = _createPrimordialLot(to, amount, multiplier, networkBonusAmount);

		// Calculate The AO and AO Dev Team's portion of Primordial and Network ion Bonus
		uint256 inverseMultiplier = startingPrimordialMultiplier.sub(multiplier); // Inverse of the buyer's multiplier
		uint256 theAONetworkBonusAmount = (startingNetworkBonusMultiplier.sub(networkBonusPercentage).add(endingNetworkBonusMultiplier)).mul(amount).div(AOLibrary.PERCENTAGE_DIVISOR());
		if (block.coinbase != address(0)) {	//injected CONTRACT AFFECTED BY MINERS
			_createPrimordialLot(aoDevTeam1, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
		}
		if (block.coinbase != address(0)) {	//injected CONTRACT AFFECTED BY MINERS
			_createPrimordialLot(aoDevTeam2, amount.div(2), inverseMultiplier, theAONetworkBonusAmount.div(2));
		}
		_mint(theAO, theAONetworkBonusAmount);
		return _lotId;
	}

	/**
	 * @dev Create a lot with `primordialAmount` of primordial ions with `_multiplier` for an `account`
	 *		during network exchange, and reward `_networkBonusAmount` if exist
	 * @param _account Address of the lot owner
	 * @param _primordialAmount The amount of primordial ions to be stored in the lot
	 * @param _multiplier The multiplier for this lot in (10 ** 6)
	 * @param _networkBonusAmount The network ion bonus amount
	 * @return Created lot Id
	 */
	function _createPrimordialLot(address _account, uint256 _primordialAmount, uint256 _multiplier, uint256 _networkBonusAmount) internal returns (bytes32) {
		bytes32 lotId = _aoIonLot.createPrimordialLot(_account, _primordialAmount, _multiplier, _networkBonusAmount);

		ownerWeightedMultiplier[_account] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_account], primordialBalanceOf[_account], _multiplier, _primordialAmount);

		// If this is the first lot, set this as the max multiplier of the account
		if (block.number == 1) {	//injected CONTRACT AFFECTED BY MINERS
			ownerMaxMultiplier[_account] = _multiplier;
		}
		_mintPrimordial(_account, _primordialAmount);
		_mint(_account, _networkBonusAmount);

		return lotId;
	}

	/**
	 * @dev Create `mintedAmount` Primordial ions and send it to `target`
	 * @param target Address to receive the Primordial ions
	 * @param mintedAmount The amount of Primordial ions it will receive
	 */
	function _mintPrimordial(address target, uint256 mintedAmount) internal {
		primordialBalanceOf[target] = primordialBalanceOf[target].add(mintedAmount);
		primordialTotalSupply = primordialTotalSupply.add(mintedAmount);
		emit PrimordialTransfer(address(0), address(this), mintedAmount);
		emit PrimordialTransfer(address(this), target, mintedAmount);
	}

	/**
	 * @dev Create a lot with `amount` of ions at `weightedMultiplier` for an `account`
	 * @param _account Address of lot owner
	 * @param _amount The amount of ions
	 * @param _weightedMultiplier The multiplier of the lot (in 10^6)
	 * @return bytes32 of new created lot ID
	 */
	function _createWeightedMultiplierLot(address _account, uint256 _amount, uint256 _weightedMultiplier) internal returns (bytes32) {
		require (_account != address(0));
		require (_amount > 0);

		bytes32 lotId = _aoIonLot.createWeightedMultiplierLot(_account, _amount, _weightedMultiplier);
		// If this is the first lot, set this as the max multiplier of the account
		if (block.timestamp == 1) {	//injected CONTRACT AFFECTED BY MINERS
			ownerMaxMultiplier[_account] = _weightedMultiplier;
		}
		return lotId;
	}

	/**
	 * @dev Create Lot and send `_value` Primordial ions from `_from` to `_to`
	 * @param _from The address of sender
	 * @param _to The address of the recipient
	 * @param _value The amount to send
	 * @return true on success
	 */
	function _createLotAndTransferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
		bytes32 _createdLotId = _createWeightedMultiplierLot(_to, _value, ownerWeightedMultiplier[_from]);
		(, address _lotOwner,,) = _aoIonLot.lotById(_createdLotId);

		// Make sure the new lot is created successfully
		require (_lotOwner == _to);

		// Update the weighted multiplier of the recipient
		ownerWeightedMultiplier[_to] = AOLibrary.calculateWeightedMultiplier(ownerWeightedMultiplier[_to], primordialBalanceOf[_to], ownerWeightedMultiplier[_from], _value);

		// Transfer the Primordial ions
		require (_transferPrimordial(_from, _to, _value));
		return true;
	}

	/**
	 * @dev Send `_value` Primordial ions from `_from` to `_to`
	 * @param _from The address of sender
	 * @param _to The address of the recipient
	 * @param _value The amount to send
	 */
	function _transferPrimordial(address _from, address _to, uint256 _value) internal returns (bool) {
		require (_to != address(0));									// Prevent transfer to 0x0 address. Use burn() instead
		require (primordialBalanceOf[_from] >= _value);						// Check if the sender has enough
		require (primordialBalanceOf[_to].add(_value) >= primordialBalanceOf[_to]);	// Check for overflows
		require (!frozenAccount[_from]);								// Check if sender is frozen
		require (!frozenAccount[_to]);									// Check if recipient is frozen
		uint256 previousBalances = primordialBalanceOf[_from].add(primordialBalanceOf[_to]);
		primordialBalanceOf[_from] = primordialBalanceOf[_from].sub(_value);			// Subtract from the sender
		primordialBalanceOf[_to] = primordialBalanceOf[_to].add(_value);				// Add the same to the recipient
		emit PrimordialTransfer(_from, _to, _value);
		assert(primordialBalanceOf[_from].add(primordialBalanceOf[_to]) == previousBalances);
		return true;
	}

	/**
	 * @dev Get setting variables
	 * @return startingPrimordialMultiplier The starting multiplier used to calculate primordial ion
	 * @return endingPrimordialMultiplier The ending multiplier used to calculate primordial ion
	 * @return startingNetworkBonusMultiplier The starting multiplier used to calculate network ion bonus
	 * @return endingNetworkBonusMultiplier The ending multiplier used to calculate network ion bonus
	 */
	function _getSettingVariables() internal view returns (uint256, uint256, uint256, uint256) {
		(uint256 startingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingPrimordialMultiplier');
		(uint256 endingPrimordialMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingPrimordialMultiplier');

		(uint256 startingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'startingNetworkBonusMultiplier');
		(uint256 endingNetworkBonusMultiplier,,,,) = _aoSetting.getSettingValuesByTAOName(settingTAOId, 'endingNetworkBonusMultiplier');

		return (startingPrimordialMultiplier, endingPrimordialMultiplier, startingNetworkBonusMultiplier, endingNetworkBonusMultiplier);
	}
}






/**
 * @title AOStakedContent
 */
contract AOStakedContent is TheAO, IAOStakedContent {
	using SafeMath for uint256;

	uint256 public totalStakedContents;
	address public aoIonAddress;
	address public aoTreasuryAddress;
	address public aoContentAddress;
	address public nameFactoryAddress;
	address public namePublicKeyAddress;

	AOIon internal _aoIon;
	IAOTreasury internal _aoTreasury;
	IAOContent internal _aoContent;
	INameFactory internal _nameFactory;
	INamePublicKey internal _namePublicKey;

	struct StakedContent {
		bytes32 stakedContentId;
		bytes32 contentId;
		address stakeOwner;
		uint256 networkAmount;		// total network ion staked in base denomination
		uint256 primordialAmount;	// the amount of primordial AOIon to stake (always in base denomination)
		uint256 primordialWeightedMultiplier;
		uint256 profitPercentage;	// support up to 4 decimals, 100% = 1000000
		bool active;	// true if currently staked, false when unstaked
		uint256 createdOnTimestamp;
	}

	// Mapping from StakedContent index to the StakedContent object
	mapping (uint256 => StakedContent) internal stakedContents;

	// Mapping from StakedContent ID to index of the stakedContents list
	mapping (bytes32 => uint256) internal stakedContentIndex;

	// Event to be broadcasted to public when `stakeOwner` stakes a new content
	event StakeContent(
		address indexed stakeOwner,
		bytes32 indexed stakedContentId,
		bytes32 indexed contentId,
		uint256 baseNetworkAmount,
		uint256 primordialAmount,
		uint256 primordialWeightedMultiplier,
		uint256 profitPercentage,
		uint256 createdOnTimestamp
	);

	// Event to be broadcasted to public when `stakeOwner` updates the staked content's profit percentage
	event SetProfitPercentage(address indexed stakeOwner, bytes32 indexed stakedContentId, uint256 newProfitPercentage);

	// Event to be broadcasted to public when `stakeOwner` unstakes some network/primordial ion from an existing content
	event UnstakePartialContent(
		address indexed stakeOwner,
		bytes32 indexed stakedContentId,
		bytes32 indexed contentId,
		uint256 remainingNetworkAmount,
		uint256 remainingPrimordialAmount,
		uint256 primordialWeightedMultiplier
	);

	// Event to be broadcasted to public when `stakeOwner` unstakes all ion amount on an existing content
	event UnstakeContent(address indexed stakeOwner, bytes32 indexed stakedContentId);

	// Event to be broadcasted to public when `stakeOwner` re-stakes an existing content
	event StakeExistingContent(
		address indexed stakeOwner,
		bytes32 indexed stakedContentId,
		bytes32 indexed contentId,
		uint256 currentNetworkAmount,
		uint256 currentPrimordialAmount,
		uint256 currentPrimordialWeightedMultiplier
	);

	/**
	 * @dev Constructor function
	 * @param _aoIonAddress The address of AOIon
	 * @param _aoTreasuryAddress The address of AOTreasury
	 * @param _aoContentAddress The address of AOContent
	 * @param _nameFactoryAddress The address of NameFactory
	 * @param _namePublicKeyAddress The address of NamePublicKey
	 * @param _nameTAOPositionAddress The address of NameTAOPosition
	 */
	constructor(address _aoIonAddress, address _aoTreasuryAddress, address _aoContentAddress, address _nameFactoryAddress, address _namePublicKeyAddress, address _nameTAOPositionAddress) public {
		setAOIonAddress(_aoIonAddress);
		setAOTreasuryAddress(_aoTreasuryAddress);
		setAOContentAddress(_aoContentAddress);
		setNameFactoryAddress(_nameFactoryAddress);
		setNamePublicKeyAddress(_namePublicKeyAddress);
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
	 * @dev The AO sets AOIon address
	 * @param _aoIonAddress The address of AOIon
	 */
	function setAOIonAddress(address _aoIonAddress) public onlyTheAO {
		require (_aoIonAddress != address(0));
		aoIonAddress = _aoIonAddress;
		_aoIon = AOIon(_aoIonAddress);
	}

	/**
	 * @dev The AO sets AOTreasury address
	 * @param _aoTreasuryAddress The address of AOTreasury
	 */
	function setAOTreasuryAddress(address _aoTreasuryAddress) public onlyTheAO {
		require (_aoTreasuryAddress != address(0));
		aoTreasuryAddress = _aoTreasuryAddress;
		_aoTreasury = IAOTreasury(_aoTreasuryAddress);
	}

	/**
	 * @dev The AO sets AO Content address
	 * @param _aoContentAddress The address of AOContent
	 */
	function setAOContentAddress(address _aoContentAddress) public onlyTheAO {
		require (_aoContentAddress != address(0));
		aoContentAddress = _aoContentAddress;
		_aoContent = IAOContent(_aoContentAddress);
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
	 * @dev The AO sets NamePublicKey address
	 * @param _namePublicKeyAddress The address of NamePublicKey
	 */
	function setNamePublicKeyAddress(address _namePublicKeyAddress) public onlyTheAO {
		require (_namePublicKeyAddress != address(0));
		namePublicKeyAddress = _namePublicKeyAddress;
		_namePublicKey = INamePublicKey(_namePublicKeyAddress);
	}

	/**
	 * @dev The AO sets NameTAOPosition address
	 * @param _nameTAOPositionAddress The address of NameTAOPosition
	 */
	function setNameTAOPositionAddress(address _nameTAOPositionAddress) public onlyTheAO {
		require (_nameTAOPositionAddress != address(0));
		nameTAOPositionAddress = _nameTAOPositionAddress;
	}

	/***** PUBLIC METHODS *****/
	/**
	 * @dev Stake the content
	 * @param _stakeOwner the address that stake the content
	 * @param _contentId The ID of the content
	 * @param _networkIntegerAmount The integer amount of network ion to stake
	 * @param _networkFractionAmount The fraction amount of network ion to stake
	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
	 * @param _primordialAmount The amount of primordial ion to stake
	 * @param _profitPercentage The percentage of profit the stake owner's media will charge
	 * @return the newly created staked content ID
	 */
	function create(address _stakeOwner,
		bytes32 _contentId,
		uint256 _networkIntegerAmount,
		uint256 _networkFractionAmount,
		bytes8 _denomination,
		uint256 _primordialAmount,
		uint256 _profitPercentage
		) external inWhitelist returns (bytes32) {
		require (_canCreate(_stakeOwner, _contentId, _networkIntegerAmount, _networkFractionAmount, _denomination, _primordialAmount, _profitPercentage));
		// Increment totalStakedContents
		totalStakedContents++;

		// Generate stakedContentId
		bytes32 _stakedContentId = keccak256(abi.encodePacked(this, _stakeOwner, _contentId));
		StakedContent storage _stakedContent = stakedContents[totalStakedContents];

		// Make sure the node doesn't stake the same content twice
		require (_stakedContent.stakeOwner == address(0));

		_stakedContent.stakedContentId = _stakedContentId;
		_stakedContent.contentId = _contentId;
		_stakedContent.stakeOwner = _stakeOwner;
		_stakedContent.profitPercentage = _profitPercentage;
		_stakedContent.active = true;
		_stakedContent.createdOnTimestamp = now;

		if (_aoTreasury.isDenominationExist(_denomination) && (_networkIntegerAmount > 0 || _networkFractionAmount > 0)) {
			_stakedContent.networkAmount = _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination);
			require (_aoIon.stakeFrom(_namePublicKey.getDefaultKey(_stakeOwner), _stakedContent.networkAmount));
		}
		if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
			_stakedContent.primordialAmount = _primordialAmount;

			// Primordial ion is the base AO ion
			_stakedContent.primordialWeightedMultiplier = _aoIon.weightedMultiplierByAddress(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner));
			require (_aoIon.stakePrimordialFrom(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner), _primordialAmount, _stakedContent.primordialWeightedMultiplier));
		}

		stakedContentIndex[_stakedContentId] = totalStakedContents;

		emit StakeContent(_stakedContent.stakeOwner, _stakedContent.stakedContentId, _stakedContent.contentId, _stakedContent.networkAmount, _stakedContent.primordialAmount, _stakedContent.primordialWeightedMultiplier, _stakedContent.profitPercentage, _stakedContent.createdOnTimestamp);
		return _stakedContent.stakedContentId;
	}

	/**
	 * @dev Set profit percentage on existing staked content
	 *		Will throw error if this is a Creative Commons/T(AO) Content
	 * @param _stakedContentId The ID of the staked content
	 * @param _profitPercentage The new value to be set
	 */
	function setProfitPercentage(bytes32 _stakedContentId, uint256 _profitPercentage) public {
		require (_profitPercentage <= AOLibrary.PERCENTAGE_DIVISOR());

		// Make sure the staked content exist
		require (stakedContentIndex[_stakedContentId] > 0);

		address _stakeOwnerNameId = _nameFactory.ethAddressToNameId(msg.sender);
		require (_stakeOwnerNameId != address(0));

		StakedContent storage _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
		// Make sure the staked content owner is the same as the sender
		require (_stakedContent.stakeOwner == _stakeOwnerNameId);

		// Make sure we are updating profit percentage for AO Content only
		// Creative Commons/T(AO) Content has 0 profit percentage
		require (_aoContent.isAOContentUsageType(_stakedContent.contentId));

		_stakedContent.profitPercentage = _profitPercentage;

		emit SetProfitPercentage(_stakeOwnerNameId, _stakedContentId, _profitPercentage);
	}

	/**
	 * @dev Return staked content information at a given ID
	 * @param _stakedContentId The ID of the staked content
	 * @return The ID of the content being staked
	 * @return address of the staked content's owner
	 * @return the network base ion amount staked for this content
	 * @return the primordial ion amount staked for this content
	 * @return the primordial weighted multiplier of the staked content
	 * @return the profit percentage of the content
	 * @return status of the staked content
	 * @return the timestamp when the staked content was created
	 */
	function getById(bytes32 _stakedContentId) external view returns (bytes32, address, uint256, uint256, uint256, uint256, bool, uint256) {
		// Make sure the staked content exist
		require (stakedContentIndex[_stakedContentId] > 0);

		StakedContent memory _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
		return (
			_stakedContent.contentId,
			_stakedContent.stakeOwner,
			_stakedContent.networkAmount,
			_stakedContent.primordialAmount,
			_stakedContent.primordialWeightedMultiplier,
			_stakedContent.profitPercentage,
			_stakedContent.active,
			_stakedContent.createdOnTimestamp
		);
	}

	/**
	 * @dev Unstake existing staked content and refund partial staked amount to the stake owner
	 *		Use unstakeContent() to unstake all staked ion amount. unstakePartialContent() can unstake only up to
	 *		the mininum required to pay the fileSize
	 * @param _stakedContentId The ID of the staked content
	 * @param _networkIntegerAmount The integer amount of network ion to unstake
	 * @param _networkFractionAmount The fraction amount of network ion to unstake
	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
	 * @param _primordialAmount The amount of primordial ion to unstake
	 */
	function unstakePartialContent(bytes32 _stakedContentId,
		uint256 _networkIntegerAmount,
		uint256 _networkFractionAmount,
		bytes8 _denomination,
		uint256 _primordialAmount
		) public {
		// Make sure the staked content exist
		require (stakedContentIndex[_stakedContentId] > 0);
		require (_networkIntegerAmount > 0 || _networkFractionAmount > 0 || _primordialAmount > 0);

		StakedContent storage _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
		(, uint256 _fileSize,,,,,,,) = _aoContent.getById(_stakedContent.contentId);

		address _stakeOwnerNameId = _nameFactory.ethAddressToNameId(msg.sender);
		require (_stakeOwnerNameId != address(0));

		// Make sure the staked content owner is the same as the sender
		require (_stakedContent.stakeOwner == _stakeOwnerNameId);
		// Make sure the staked content is currently active (staked) with some amounts
		require (this.isActive(_stakedContentId));
		// Make sure the staked content has enough balance to unstake
		require (_canUnstakePartial(_networkIntegerAmount, _networkFractionAmount, _denomination, _primordialAmount, _stakedContent.networkAmount, _stakedContent.primordialAmount, _fileSize));

		if (_aoTreasury.isDenominationExist(_denomination) && (_networkIntegerAmount > 0 || _networkFractionAmount > 0)) {
			uint256 _unstakeNetworkAmount = _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination);
			_stakedContent.networkAmount = _stakedContent.networkAmount.sub(_unstakeNetworkAmount);
			require (_aoIon.unstakeFrom(_namePublicKey.getDefaultKey(_stakeOwnerNameId), _unstakeNetworkAmount));
		}
		if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
			_stakedContent.primordialAmount = _stakedContent.primordialAmount.sub(_primordialAmount);
			require (_aoIon.unstakePrimordialFrom(_namePublicKey.getDefaultKey(_stakeOwnerNameId), _primordialAmount, _stakedContent.primordialWeightedMultiplier));
		}
		emit UnstakePartialContent(_stakedContent.stakeOwner, _stakedContent.stakedContentId, _stakedContent.contentId, _stakedContent.networkAmount, _stakedContent.primordialAmount, _stakedContent.primordialWeightedMultiplier);
	}

	/**
	 * @dev Unstake existing staked content and refund the total staked amount to the stake owner
	 * @param _stakedContentId The ID of the staked content
	 */
	function unstakeContent(bytes32 _stakedContentId) public {
		// Make sure the staked content exist
		require (stakedContentIndex[_stakedContentId] > 0);

		StakedContent storage _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];

		address _stakeOwnerNameId = _nameFactory.ethAddressToNameId(msg.sender);
		require (_stakeOwnerNameId != address(0));

		// Make sure the staked content owner is the same as the sender
		require (_stakedContent.stakeOwner == _stakeOwnerNameId);
		// Make sure the staked content is currently active (staked) with some amounts
		require (this.isActive(_stakedContentId));
		_stakedContent.active = false;

		if (block.number > 0) {	//injected CONTRACT AFFECTED BY MINERS
			uint256 _unstakeNetworkAmount = _stakedContent.networkAmount;
			_stakedContent.networkAmount = 0;
			require (_aoIon.unstakeFrom(_namePublicKey.getDefaultKey(_stakeOwnerNameId), _unstakeNetworkAmount));
		}
		if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
			uint256 _primordialAmount = _stakedContent.primordialAmount;
			uint256 _primordialWeightedMultiplier = _stakedContent.primordialWeightedMultiplier;
			_stakedContent.primordialAmount = 0;
			_stakedContent.primordialWeightedMultiplier = 0;
			require (_aoIon.unstakePrimordialFrom(_namePublicKey.getDefaultKey(_stakeOwnerNameId), _primordialAmount, _primordialWeightedMultiplier));
		}
		emit UnstakeContent(_stakedContent.stakeOwner, _stakedContentId);
	}

	/**
	 * @dev Stake existing content with more ions (this is to increase the price)
	 *
	 * @param _stakedContentId The ID of the staked content
	 * @param _networkIntegerAmount The integer amount of network ion to stake
	 * @param _networkFractionAmount The fraction amount of network ion to stake
	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
	 * @param _primordialAmount The amount of primordial ion to stake. (The primordial weighted multiplier has to match the current staked weighted multiplier)
	 */
	function stakeExistingContent(bytes32 _stakedContentId,
		uint256 _networkIntegerAmount,
		uint256 _networkFractionAmount,
		bytes8 _denomination,
		uint256 _primordialAmount
		) public {
		// Make sure the staked content exist
		require (stakedContentIndex[_stakedContentId] > 0);

		StakedContent storage _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
		(, uint256 _fileSize,,,,,,,) = _aoContent.getById(_stakedContent.contentId);

		address _stakeOwnerNameId = _nameFactory.ethAddressToNameId(msg.sender);
		require (_stakeOwnerNameId != address(0));

		// Make sure the staked content owner is the same as the sender
		require (_stakedContent.stakeOwner == _stakeOwnerNameId);
		require (_networkIntegerAmount > 0 || _networkFractionAmount > 0 || _primordialAmount > 0);
		require (_canStakeExisting(_aoContent.isAOContentUsageType(_stakedContent.contentId), _fileSize, _stakedContent.networkAmount.add(_stakedContent.primordialAmount), _networkIntegerAmount, _networkFractionAmount, _denomination, _primordialAmount));

		// Make sure we can stake primordial ion
		// If we are currently staking an active staked content, then the stake owner's weighted multiplier has to match `stakedContent.primordialWeightedMultiplier`
		// i.e, can't use a combination of different weighted multiplier. Stake owner has to call unstakeContent() to unstake all ions first
		if (_primordialAmount > 0 && _stakedContent.active && _stakedContent.primordialAmount > 0 && _stakedContent.primordialWeightedMultiplier > 0) {
			require (_aoIon.weightedMultiplierByAddress(_namePublicKey.getDefaultKey(_stakeOwnerNameId)) == _stakedContent.primordialWeightedMultiplier);
		}

		_stakedContent.active = true;
		if (_aoTreasury.isDenominationExist(_denomination) && (_networkIntegerAmount > 0 || _networkFractionAmount > 0)) {
			uint256 _stakeNetworkAmount = _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination);
			_stakedContent.networkAmount = _stakedContent.networkAmount.add(_stakeNetworkAmount);
			require (_aoIon.stakeFrom(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner), _stakeNetworkAmount));
		}
		if (block.gaslimit > 0) {	//injected CONTRACT AFFECTED BY MINERS
			_stakedContent.primordialAmount = _stakedContent.primordialAmount.add(_primordialAmount);

			// Primordial ion is the base AO ion
			_stakedContent.primordialWeightedMultiplier = _aoIon.weightedMultiplierByAddress(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner));
			require (_aoIon.stakePrimordialFrom(_namePublicKey.getDefaultKey(_stakedContent.stakeOwner), _primordialAmount, _stakedContent.primordialWeightedMultiplier));
		}

		emit StakeExistingContent(_stakeOwnerNameId, _stakedContent.stakedContentId, _stakedContent.contentId, _stakedContent.networkAmount, _stakedContent.primordialAmount, _stakedContent.primordialWeightedMultiplier);
	}

	/**
	 * @dev Check whether or not a staked content is active
	 * @param _stakedContentId The ID of the staked content
	 * @return true if yes, false otherwise.
	 */
	function isActive(bytes32 _stakedContentId) external view returns (bool) {
		// Make sure the staked content exist
		require (stakedContentIndex[_stakedContentId] > 0);

		StakedContent memory _stakedContent = stakedContents[stakedContentIndex[_stakedContentId]];
		return (_stakedContent.active == true && (_stakedContent.networkAmount > 0 || (_stakedContent.primordialAmount > 0 && _stakedContent.primordialWeightedMultiplier > 0)));
	}

	/***** INTERNAL METHODS *****/
	/**
	 * @dev Checks if create params are valid
	 * @param _stakeOwner the address that stake the content
	 * @param _contentId The ID of the content
	 * @param _networkIntegerAmount The integer amount of network ion to stake
	 * @param _networkFractionAmount The fraction amount of network ion to stake
	 * @param _denomination The denomination of the network ion, i.e ao, kilo, mega, etc.
	 * @param _primordialAmount The amount of primordial ion to stake
	 * @param _profitPercentage The percentage of profit the stake owner's media will charge
	 * @return true if yes. false otherwise
	 */
	function _canCreate(address _stakeOwner,
		bytes32 _contentId,
		uint256 _networkIntegerAmount,
		uint256 _networkFractionAmount,
		bytes8 _denomination,
		uint256 _primordialAmount,
		uint256 _profitPercentage) internal view returns (bool) {
		(address _contentCreator, uint256 _fileSize,,,,,,,) = _aoContent.getById(_contentId);
		return (_stakeOwner != address(0) &&
			AOLibrary.isName(_stakeOwner) &&
			_stakeOwner == _contentCreator &&
			(_networkIntegerAmount > 0 || _networkFractionAmount > 0 || _primordialAmount > 0) &&
			(_aoContent.isAOContentUsageType(_contentId) ?
				_aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination).add(_primordialAmount) >= _fileSize :
				_aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination).add(_primordialAmount) == _fileSize
			) &&
			_profitPercentage <= AOLibrary.PERCENTAGE_DIVISOR()
		);
	}

	/**
	 * @dev Check whether or the requested unstake amount is valid
	 * @param _networkIntegerAmount The integer amount of the network ion
	 * @param _networkFractionAmount The fraction amount of the network ion
	 * @param _denomination The denomination of the the network ion
	 * @param _primordialAmount The amount of primordial ion
	 * @param _stakedNetworkAmount The current staked network ion amount
	 * @param _stakedPrimordialAmount The current staked primordial ion amount
	 * @param _stakedFileSize The file size of the staked content
	 * @return true if can unstake, false otherwise
	 */
	function _canUnstakePartial(
		uint256 _networkIntegerAmount,
		uint256 _networkFractionAmount,
		bytes8 _denomination,
		uint256 _primordialAmount,
		uint256 _stakedNetworkAmount,
		uint256 _stakedPrimordialAmount,
		uint256 _stakedFileSize
		) internal view returns (bool) {
		if (
			(_denomination.length > 0 && _denomination[0] != 0 &&
				(_networkIntegerAmount > 0 || _networkFractionAmount > 0) &&
				_stakedNetworkAmount < _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination)
			) ||
			_stakedPrimordialAmount < _primordialAmount ||
			(
				_denomination.length > 0 && _denomination[0] != 0
					&& (_networkIntegerAmount > 0 || _networkFractionAmount > 0)
					&& (_stakedNetworkAmount.sub(_aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination)).add(_stakedPrimordialAmount.sub(_primordialAmount)) < _stakedFileSize)
			) ||
			( _denomination.length == 0 && _denomination[0] == 0 && _networkIntegerAmount == 0 && _networkFractionAmount == 0 && _primordialAmount > 0 && _stakedPrimordialAmount.sub(_primordialAmount) < _stakedFileSize)
		) {
			return false;
		} else {
			return true;
		}
	}

	/**
	 * @dev Check whether the network ion and/or primordial ion is adequate to pay for existing staked content
	 * @param _isAOContentUsageType whether or not the content is of AO Content usage type
	 * @param _fileSize The size of the file
	 * @param _stakedAmount The total staked amount
	 * @param _networkIntegerAmount The integer amount of the network ion
	 * @param _networkFractionAmount The fraction amount of the network ion
	 * @param _denomination The denomination of the the network ion
	 * @param _primordialAmount The amount of primordial ion
	 * @return true when the amount is sufficient, false otherwise
	 */
	function _canStakeExisting(
		bool _isAOContentUsageType,
		uint256 _fileSize,
		uint256 _stakedAmount,
		uint256 _networkIntegerAmount,
		uint256 _networkFractionAmount,
		bytes8 _denomination,
		uint256 _primordialAmount
	) internal view returns (bool) {
		if (_isAOContentUsageType) {
			return _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination).add(_primordialAmount).add(_stakedAmount) >= _fileSize;
		} else {
			return _aoTreasury.toBase(_networkIntegerAmount, _networkFractionAmount, _denomination).add(_primordialAmount).add(_stakedAmount) == _fileSize;
		}
	}
}