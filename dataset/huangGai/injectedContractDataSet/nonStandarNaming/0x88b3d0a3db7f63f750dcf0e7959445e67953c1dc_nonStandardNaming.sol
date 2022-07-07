pragma solidity >=0.5.4 <0.6.0;

interface tokenRecipient { function RECEIVEAPPROVAL172(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }	//inject NONSTANDARD NAMING


                                                                                         
library SafeMath {

	                                                             
	function MUL710(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
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

	                                                                           
	function DIV595(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
		// assert(b > 0); // Solidity automatically throws when dividing by 0
		// uint256 c = a / b;
		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
		return a / b;
	}

	                                                                                                         
	function SUB853(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
		assert(b <= a);
		return a - b;
	}

	                                                       
	function ADD540(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
		c = a + b;
		assert(c >= a);
		return c;
	}
}


interface INameTAOPosition {
	function SENDERISADVOCATE978(address _sender, address _id) external view returns (bool);	//inject NONSTANDARD NAMING
	function SENDERISLISTENER841(address _sender, address _id) external view returns (bool);	//inject NONSTANDARD NAMING
	function SENDERISSPEAKER648(address _sender, address _id) external view returns (bool);	//inject NONSTANDARD NAMING
	function SENDERISPOSITION99(address _sender, address _id) external view returns (bool);	//inject NONSTANDARD NAMING
	function GETADVOCATE521(address _id) external view returns (address);	//inject NONSTANDARD NAMING
	function NAMEISADVOCATE881(address _nameId, address _id) external view returns (bool);	//inject NONSTANDARD NAMING
	function NAMEISPOSITION327(address _nameId, address _id) external view returns (bool);	//inject NONSTANDARD NAMING
	function INITIALIZE405(address _id, address _advocateId, address _listenerId, address _speakerId) external returns (bool);	//inject NONSTANDARD NAMING
	function DETERMINEPOSITION456(address _sender, address _id) external view returns (uint256);	//inject NONSTANDARD NAMING
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
	event TRANSFER193(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

	// This generates a public event on the blockchain that will notify clients
	event APPROVAL454(address indexed _owner, address indexed _spender, uint256 _value);	//inject NONSTANDARD NAMING

	// This notifies clients about the amount burnt
	event BURN994(address indexed from, uint256 value);	//inject NONSTANDARD NAMING

	                                                                                                                        
	constructor (uint256 initialSupply, string memory tokenName, string memory tokenSymbol) public {
		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
		name = tokenName;                                   // Set the name for display purposes
		symbol = tokenSymbol;                               // Set the symbol for display purposes
	}

	                                                                   
	function _TRANSFER285(address _from, address _to, uint _value) internal {	//inject NONSTANDARD NAMING
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
		emit TRANSFER193(_from, _to, _value);
		// Asserts are used to use static analysis to find bugs in your code. They should never fail
		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
	}

	                                                                                                                                                                         
	function TRANSFER874(address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
		_TRANSFER285(msg.sender, _to, _value);
		return true;
	}

	                                                                                                                                                                                                                                          
	function TRANSFERFROM282(address _from, address _to, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
		require(_value <= allowance[_from][msg.sender]);     // Check allowance
		allowance[_from][msg.sender] -= _value;
		_TRANSFER285(_from, _to, _value);
		return true;
	}

	                                                                                                                                                                                                                                   
	function APPROVE265(address _spender, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
		allowance[msg.sender][_spender] = _value;
		emit APPROVAL454(msg.sender, _spender, _value);
		return true;
	}

	                                                                                                                                                                                                                                                                                                                                                                 
	function APPROVEANDCALL88(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {	//inject NONSTANDARD NAMING
		tokenRecipient spender = tokenRecipient(_spender);
		if (APPROVE265(_spender, _value)) {
			spender.RECEIVEAPPROVAL172(msg.sender, _value, address(this), _extraData);
			return true;
		}
	}

	                                                                                                                                         
	function BURN239(uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
		balanceOf[msg.sender] -= _value;            // Subtract from the sender
		totalSupply -= _value;                      // Updates totalSupply
		emit BURN994(msg.sender, _value);
		return true;
	}

	                                                                                                                                                                                                                             
	function BURNFROM882(address _from, uint256 _value) public returns (bool success) {	//inject NONSTANDARD NAMING
		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
		require(_value <= allowance[_from][msg.sender]);    // Check allowance
		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
		totalSupply -= _value;                              // Update totalSupply
		emit BURN994(_from, _value);
		return true;
	}
}


                     
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

	                                 
	uint8 public typeId;

	                                      
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

	                                                             
	modifier ONLYVAULT404 {	//inject NONSTANDARD NAMING
		require (msg.sender == vaultAddress);
		_;
	}

	                                      
	function () external payable {
	}

	                                                                                                                                                                                                           
	function TRANSFERETH144(address payable _recipient, uint256 _amount) public ONLYVAULT404 returns (bool) {	//inject NONSTANDARD NAMING
		_recipient.transfer(_amount);
		return true;
	}

	                                                                                                                                                                                                                                                                            
	function TRANSFERERC20563(address _erc20TokenAddress, address _recipient, uint256 _amount) public ONLYVAULT404 returns (bool) {	//inject NONSTANDARD NAMING
		TokenERC20 _erc20 = TokenERC20(_erc20TokenAddress);
		_erc20.TRANSFER874(_recipient, _amount);
		return true;
	}
}




                      
contract Name is TAO {
	                                      
	constructor (string memory _name, address _originId, string memory _datHash, string memory _database, string memory _keyValue, bytes32 _contentId, address _vaultAddress)
		TAO (_name, _originId, _datHash, _database, _keyValue, _contentId, _vaultAddress) public {
		// Creating Name
		typeId = 1;
	}
}




                           
library AOLibrary {
	using SafeMath for uint256;

	uint256 constant private _multiplier_divisor322 = 10 ** 6; // 1000000 = 1	//inject NONSTANDARD NAMING
	uint256 constant private _percentage_divisor262 = 10 ** 6; // 100% = 1000000	//inject NONSTANDARD NAMING

	                                                                                                                                             
	function ISTAO231(address _taoId) public view returns (bool) {	//inject NONSTANDARD NAMING
		return (_taoId != address(0) && bytes(TAO(address(uint160(_taoId))).name()).length > 0 && TAO(address(uint160(_taoId))).originId() != address(0) && TAO(address(uint160(_taoId))).typeId() == 0);
	}

	                                                                                                                                                 
	function ISNAME781(address _nameId) public view returns (bool) {	//inject NONSTANDARD NAMING
		return (_nameId != address(0) && bytes(TAO(address(uint160(_nameId))).name()).length > 0 && Name(address(uint160(_nameId))).originId() != address(0) && Name(address(uint160(_nameId))).typeId() == 1);
	}

	                                                                                                                                   
	function ISVALIDERC20TOKENADDRESS312(address _tokenAddress) public view returns (bool) {	//inject NONSTANDARD NAMING
		if (_tokenAddress == address(0)) {
			return false;
		}
		TokenERC20 _erc20 = TokenERC20(_tokenAddress);
		return (_erc20.totalSupply() >= 0 && bytes(_erc20.name()).length > 0 && bytes(_erc20.symbol()).length > 0);
	}

	                                                                                                                                                                                                                                                                                                                                                 
	function ISTHEAO403(address _sender, address _theAO, address _nameTAOPositionAddress) public view returns (bool) {	//inject NONSTANDARD NAMING
		return (_sender == _theAO ||
			(
				(ISTAO231(_theAO) || ISNAME781(_theAO)) &&
				_nameTAOPositionAddress != address(0) &&
				INameTAOPosition(_nameTAOPositionAddress).SENDERISADVOCATE978(_sender, _theAO)
			)
		);
	}

	                                                                                                                                                                                       
	function PERCENTAGE_DIVISOR218() public pure returns (uint256) {	//inject NONSTANDARD NAMING
		return _percentage_divisor262;
	}

	                                                                                                                                                                                        
	function MULTIPLIER_DIVISOR371() public pure returns (uint256) {	//inject NONSTANDARD NAMING
		return _multiplier_divisor322;
	}

	                                                                                                                                                                                                                                                                                                                                                                                                             
	function DEPLOYTAO162(string memory _name,	//inject NONSTANDARD NAMING
		address _originId,
		string memory _datHash,
		string memory _database,
		string memory _keyValue,
		bytes32 _contentId,
		address _nameTAOVaultAddress
		) public returns (TAO _tao) {
		_tao = new TAO(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
	}

	                                                                                                                                                                                                                                                                                                                                                                                                                       
	function DEPLOYNAME486(string memory _name,	//inject NONSTANDARD NAMING
		address _originId,
		string memory _datHash,
		string memory _database,
		string memory _keyValue,
		bytes32 _contentId,
		address _nameTAOVaultAddress
		) public returns (Name _myName) {
		_myName = new Name(_name, _originId, _datHash, _database, _keyValue, _contentId, _nameTAOVaultAddress);
	}

	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	function CALCULATEWEIGHTEDMULTIPLIER712(uint256 _currentWeightedMultiplier, uint256 _currentPrimordialBalance, uint256 _additionalWeightedMultiplier, uint256 _additionalPrimordialAmount) public pure returns (uint256) {	//inject NONSTANDARD NAMING
		if (_currentWeightedMultiplier > 0) {
			uint256 _totalWeightedIons = (_currentWeightedMultiplier.MUL710(_currentPrimordialBalance)).ADD540(_additionalWeightedMultiplier.MUL710(_additionalPrimordialAmount));
			uint256 _totalIons = _currentPrimordialBalance.ADD540(_additionalPrimordialAmount);
			return _totalWeightedIons.DIV595(_totalIons);
		} else {
			return _additionalWeightedMultiplier;
		}
	}

	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
	function CALCULATEPRIMORDIALMULTIPLIER760(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {	//inject NONSTANDARD NAMING
		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.SUB853(_totalPrimordialMinted)) {
			                                                                                 
			uint256 temp = _totalPrimordialMinted.ADD540(_purchaseAmount.DIV595(2));

			                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
			uint256 multiplier = (_multiplier_divisor322.SUB853(_multiplier_divisor322.MUL710(temp).DIV595(_totalPrimordialMintable))).MUL710(_startingMultiplier.SUB853(_endingMultiplier));
			                                                                                                                                         
			return multiplier.DIV595(_multiplier_divisor322);
		} else {
			return 0;
		}
	}

	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
	function CALCULATENETWORKBONUSPERCENTAGE146(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {	//inject NONSTANDARD NAMING
		if (_purchaseAmount > 0 && _purchaseAmount <= _totalPrimordialMintable.SUB853(_totalPrimordialMinted)) {
			                                                                           
			uint256 temp = _totalPrimordialMinted.ADD540(_purchaseAmount.DIV595(2));

			                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
			uint256 bonusPercentage = (_percentage_divisor262.SUB853(_percentage_divisor262.MUL710(temp).DIV595(_totalPrimordialMintable))).MUL710(_startingMultiplier.SUB853(_endingMultiplier)).DIV595(_percentage_divisor262);
			return bonusPercentage;
		} else {
			return 0;
		}
	}

	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
	function CALCULATENETWORKBONUSAMOUNT621(uint256 _purchaseAmount, uint256 _totalPrimordialMintable, uint256 _totalPrimordialMinted, uint256 _startingMultiplier, uint256 _endingMultiplier) public pure returns (uint256) {	//inject NONSTANDARD NAMING
		uint256 bonusPercentage = CALCULATENETWORKBONUSPERCENTAGE146(_purchaseAmount, _totalPrimordialMintable, _totalPrimordialMinted, _startingMultiplier, _endingMultiplier);
		                                                                                                                                                                    
		uint256 networkBonus = bonusPercentage.MUL710(_purchaseAmount).DIV595(_percentage_divisor262);
		return networkBonus;
	}

	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
	function CALCULATEMAXIMUMBURNAMOUNT319(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _maximumMultiplier) public pure returns (uint256) {	//inject NONSTANDARD NAMING
		return (_maximumMultiplier.MUL710(_primordialBalance).SUB853(_primordialBalance.MUL710(_currentWeightedMultiplier))).DIV595(_maximumMultiplier);
	}

	                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
	function CALCULATEMULTIPLIERAFTERBURN888(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToBurn) public pure returns (uint256) {	//inject NONSTANDARD NAMING
		return _primordialBalance.MUL710(_currentWeightedMultiplier).DIV595(_primordialBalance.SUB853(_amountToBurn));
	}

	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
	function CALCULATEMULTIPLIERAFTERCONVERSION91(uint256 _primordialBalance, uint256 _currentWeightedMultiplier, uint256 _amountToConvert) public pure returns (uint256) {	//inject NONSTANDARD NAMING
		return _primordialBalance.MUL710(_currentWeightedMultiplier).DIV595(_primordialBalance.ADD540(_amountToConvert));
	}

	                                                                                                                            
	function NUMDIGITS612(uint256 number) public pure returns (uint8) {	//inject NONSTANDARD NAMING
		uint8 digits = 0;
		while(number != 0) {
			number = number.DIV595(10);
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

	                                                       
	modifier INWHITELIST24() {	//inject NONSTANDARD NAMING
		require (whitelist[msg.sender] == true);
		_;
	}

	                                                                                                                 
	function TRANSFEROWNERSHIP920(address _theAO) public {	//inject NONSTANDARD NAMING
		require (msg.sender == theAO);
		require (_theAO != address(0));
		theAO = _theAO;
	}

	                                                                                                                                                                            
	function SETWHITELIST120(address _account, bool _whitelist) public {	//inject NONSTANDARD NAMING
		require (msg.sender == theAO);
		require (_account != address(0));
		whitelist[_account] = _whitelist;
	}
}


                             
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
	event TRANSFER193(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

	// This notifies clients about the amount burnt
	// address is the address of TAO/Name Id, not eth public address
	event BURN994(address indexed from, uint256 value);	//inject NONSTANDARD NAMING

	                                                                                                                             
	constructor (string memory _name, string memory _symbol, address _nameTAOPositionAddress) public {
		name = _name;		// Set the name for display purposes
		symbol = _symbol;	// Set the symbol for display purposes

		powerOfTen = 0;
		decimals = 0;

		SETNAMETAOPOSITIONADDRESS170(_nameTAOPositionAddress);
	}

	                                                                                                                                                             
	modifier ONLYTHEAO376 {	//inject NONSTANDARD NAMING
		require (AOLibrary.ISTHEAO403(msg.sender, theAO, nameTAOPositionAddress));
		_;
	}

	                                                   
	modifier ISNAMEORTAO154(address _id) {	//inject NONSTANDARD NAMING
		require (AOLibrary.ISNAME781(_id) || AOLibrary.ISTAO231(_id));
		_;
	}

	                                 
	                                                                                                                 
	function TRANSFEROWNERSHIP920(address _theAO) public ONLYTHEAO376 {	//inject NONSTANDARD NAMING
		require (_theAO != address(0));
		theAO = _theAO;
	}

	                                                                                                                                                                            
	function SETWHITELIST120(address _account, bool _whitelist) public ONLYTHEAO376 {	//inject NONSTANDARD NAMING
		require (_account != address(0));
		whitelist[_account] = _whitelist;
	}

	                                                                                                                          
	function SETNAMETAOPOSITIONADDRESS170(address _nameTAOPositionAddress) public ONLYTHEAO376 {	//inject NONSTANDARD NAMING
		require (_nameTAOPositionAddress != address(0));
		nameTAOPositionAddress = _nameTAOPositionAddress;
	}

	                            
	                                                                                                                                                                                                                                                         
	function TRANSFERFROM282(address _from, address _to, uint256 _value) public INWHITELIST24 ISNAMEORTAO154(_from) ISNAMEORTAO154(_to) returns (bool) {	//inject NONSTANDARD NAMING
		_TRANSFER285(_from, _to, _value);
		return true;
	}

	                                                                                                                                                                                                                          
	function MINT678(address target, uint256 mintedAmount) public INWHITELIST24 ISNAMEORTAO154(target) returns (bool) {	//inject NONSTANDARD NAMING
		_MINT887(target, mintedAmount);
		return true;
	}

	                                                                                                                                                                                                                     
	function WHITELISTBURNFROM289(address _from, uint256 _value) public INWHITELIST24 ISNAMEORTAO154(_from) returns (bool success) {	//inject NONSTANDARD NAMING
		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
		balanceOf[_from] = balanceOf[_from].SUB853(_value);    // Subtract from the targeted balance
		totalSupply = totalSupply.SUB853(_value);              // Update totalSupply
		emit BURN994(_from, _value);
		return true;
	}

	                              
	                                                                                                                                                                                         
	function _TRANSFER285(address _from, address _to, uint256 _value) internal {	//inject NONSTANDARD NAMING
		require (_to != address(0));							// Prevent transfer to 0x0 address. Use burn() instead
		require (balanceOf[_from] >= _value);					// Check if the sender has enough
		require (balanceOf[_to].ADD540(_value) >= balanceOf[_to]); // Check for overflows
		uint256 previousBalances = balanceOf[_from].ADD540(balanceOf[_to]);
		balanceOf[_from] = balanceOf[_from].SUB853(_value);        // Subtract from the sender
		balanceOf[_to] = balanceOf[_to].ADD540(_value);            // Add the same to the recipient
		emit TRANSFER193(_from, _to, _value);
		assert(balanceOf[_from].ADD540(balanceOf[_to]) == previousBalances);
	}

	                                                                                                                                                                                              
	function _MINT887(address target, uint256 mintedAmount) internal {	//inject NONSTANDARD NAMING
		balanceOf[target] = balanceOf[target].ADD540(mintedAmount);
		totalSupply = totalSupply.ADD540(mintedAmount);
		emit TRANSFER193(address(0), address(this), mintedAmount);
		emit TRANSFER193(address(this), target, mintedAmount);
	}
}


contract PathosGiga is TAOCurrency {
	                                      
	constructor(string memory _name, string memory _symbol, address _nameTAOPositionAddress)
		TAOCurrency(_name, _symbol, _nameTAOPositionAddress) public {
		powerOfTen = 9;
		decimals = 9;
	}
}