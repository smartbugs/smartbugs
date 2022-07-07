/**
 *Submitted for verification at Etherscan.io on 2020-03-09
*/

pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;


library SafeMath {

  
  string constant OVERFLOW = "008001";
  string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
  string constant DIVISION_BY_ZERO = "008003";

  
  function mul(
    uint256 _factor1,
    uint256 _factor2
  )
    internal
    pure
    returns (uint256 product)
  {
    
    
    
    if (_factor1 == 0)
    {
      return 0;
    }

    product = _factor1 * _factor2;
    require(product / _factor1 == _factor2, OVERFLOW);
  }

  
  function div(
    uint256 _dividend,
    uint256 _divisor
  )
    internal
    pure
    returns (uint256 quotient)
  {
    
    require(_divisor > 0, DIVISION_BY_ZERO);
    quotient = _dividend / _divisor;
    
  }

  
  function sub(
    uint256 _minuend,
    uint256 _subtrahend
  )
    internal
    pure
    returns (uint256 difference)
  {
    //require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
    difference = _minuend - _subtrahend;
  }

  
  function add(
    uint256 _addend1,
    uint256 _addend2
  )
    internal
    pure
    returns (uint256 sum)
  {
    sum = _addend1 + _addend2;
    //require(sum >= _addend1, OVERFLOW);
  }

  
  function mod(
    uint256 _dividend,
    uint256 _divisor
  )
    internal
    pure
    returns (uint256 remainder)
  {
    require(_divisor != 0, DIVISION_BY_ZERO);
    remainder = _dividend % _divisor;
  }

}

interface ERC165 {

  
  function supportsInterface(
    bytes4 _interfaceID
  )
    external
    view
    returns (bool);

}

contract SupportsInterface is
  ERC165
{

  
  mapping(bytes4 => bool) internal supportedInterfaces;

  
  constructor()
    public
  {
    supportedInterfaces[0x01ffc9a7] = true; 
  }

  
  function supportsInterface(
    bytes4 _interfaceID
  )
    external
    override
    view
    returns (bool)
  {
    return supportedInterfaces[_interfaceID];
  }

}

contract Abilitable {
  using SafeMath for uint;

  
  string constant NOT_AUTHORIZED = "017001";
  string constant INVALID_INPUT = "017002";

  
  uint8 constant SUPER_ABILITY = 1;

  
  uint8 constant ALLOW_SUPER_ABILITY = 2;

  
  uint8 constant EMPTY_SLOT_1 = 4;

  
  uint8 constant EMPTY_SLOT_2 = 8;

  
  uint8 constant ALL_DEFAULT_ABILITIES = 15;

  
  mapping(address => uint256) public addressToAbility;

  
  event SetAbilities(
    address indexed _target,
    uint256 indexed _abilities
  );

  
  modifier hasAbilities(
    uint256 _abilities
  )
  {
    require(_abilities > 0, INVALID_INPUT);
    require(
      addressToAbility[msg.sender] & _abilities == _abilities,
      NOT_AUTHORIZED
    );
    _;
  }

  
  constructor()
    public
  {
    addressToAbility[msg.sender] = ALL_DEFAULT_ABILITIES;
  }

  
  function grantAbilities(
    address _target,
    uint256 _abilities
  )
    external
    hasAbilities(SUPER_ABILITY)
  {
    addressToAbility[_target] |= _abilities;
    emit SetAbilities(_target, addressToAbility[_target]);
  }

  
  function revokeAbilities(
    address _target,
    uint256 _abilities
  )
    external
    hasAbilities(SUPER_ABILITY)
  {
    addressToAbility[_target] &= ~_abilities;
    emit SetAbilities(_target, addressToAbility[_target]);
  }

  
  function setAbilities(
    address _target,
    uint256 _abilities
  )
    external
    hasAbilities(SUPER_ABILITY)
  {
    addressToAbility[_target] = _abilities;
    emit SetAbilities(_target, _abilities);
  }

  
  function isAble(
    address _target,
    uint256 _abilities
  )
    external
    view
    returns (bool)
  {
    require(_abilities > 0, INVALID_INPUT);
    return (addressToAbility[_target] & _abilities) == _abilities;
  }

}

interface MigrationReceiver {

  
  function onMigrationReceived(
    address _migrator,
    uint256 _amount
  )
    external
    returns(bytes4 magicValue);
}

interface ERC20 {

  
  function name()
    external
    view
    returns (string memory _name);

  
  function symbol()
    external
    view
    returns (string memory _symbol);

  
  function decimals()
    external
    view
    returns (uint8 _decimals);

  
  function totalSupply()
    external
    view
    returns (uint256 _totalSupply);

  
  function balanceOf(
    address _owner
  )
    external
    view
    returns (uint256 _balance);

  
  function transfer(
    address _to,
    uint256 _value
  )
    external
    returns (bool _success);

  
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    external
    returns (bool _success);

  
  function approve(
    address _spender,
    uint256 _value
  )
    external
    returns (bool _success);

  
  function allowance(
    address _owner,
    address _spender
  )
    external
    view
    returns (uint256 _remaining);

  
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
  );

  
  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );

}

contract DappToken is
  ERC20,
  SupportsInterface,
  Abilitable,
  MigrationReceiver
{
  using SafeMath for uint256;

  
  uint8 constant ABILITY_SET_WHITELISTED = 16;
  uint8 constant ABILITY_SET_MIGRATE_ADDRESS = 32;
  uint8 constant ABILITY_SET_MIGRATOR_ADDRESS = 64;

  
  string constant NOT_ENOUGH_BALANCE = "010001";
  string constant NOT_ENOUGH_ALLOWANCE = "010002";
  string constant NOT_WHITELISTED_ADDRESS = "010003";
  string constant MIGRATION_NOT_STARTED = "010004";
  string constant MIGRATION_STARTED = "010005";
  string constant NOT_ABLE_TO_MIGRATE = "010006";
  string constant INVALID_SIGNATURE = "010007";
  string constant CLAIM_PERFORMED = "010008";
  string constant CLAIM_EXPIRED = "010009";
  string constant INVALID_SIGNATURE_KIND = "010010";
  string constant CLAIM_CANCELED = "010011";

  
  string internal tokenName;

  
  string internal tokenSymbol;

  
  uint8 internal tokenDecimals;

  
  uint256 internal tokenTotalSupply;

  
  mapping (address => uint256) internal balances;

  
  mapping (address => mapping (address => uint256)) internal allowed;

  
  address public tokenTransferProxy;

  
  mapping (address => bool) public whitelistedRecipients;

  
  ERC20 public barteredToken;

  
  address public migrationAddress;

  
  mapping (address => bool) public approvedMigrators;

  
  bytes4 constant MAGIC_ON_MIGRATION_RECEIVED = 0xc5b97e06;

  
  enum SignatureKind
  {
    eth_sign,
    trezor,
    no_prefix
  }

  
  struct SignatureData
  {
    bytes32 r;
    bytes32 s;
    uint8 v;
    SignatureKind kind;
  }

  
  mapping(bytes32 => bool) public claimPerformed;

  
  mapping(bytes32 => bool) public claimCancelled;

  
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 _value
  );

  
  event Approval(
    address indexed _owner,
    address indexed _spender,
    uint256 _value
  );

  
  event WhitelistedRecipient(
    address indexed _target,
    bool state
  );

  
  event ApprovedMigrator(
    address indexed _target,
    bool state
  );

  
  constructor()
    public
  {
    supportedInterfaces[0x36372b07] = true; 
    supportedInterfaces[0x06fdde03] = true; 
    supportedInterfaces[0x95d89b41] = true; 
    supportedInterfaces[0x313ce567] = true; 
  }

  
  function name()
    external
    override
    view
    returns (string memory _name)
  {
    _name = tokenName;
  }

  
  function symbol()
    external
    override
    view
    returns (string memory _symbol)
  {
    _symbol = tokenSymbol;
  }

  
  function decimals()
    external
    override
    view
    returns (uint8 _decimals)
  {
    _decimals = tokenDecimals;
  }

  
  function totalSupply()
    external
    override
    view
    returns (uint256 _totalSupply)
  {
    _totalSupply = tokenTotalSupply;
  }

  
  function balanceOf(
    address _owner
  )
    external
    override
    view
    returns (uint256 _balance)
  {
    _balance = balances[_owner];
  }

  
  function allowance(
    address _owner,
    address _spender
  )
    external
    override
    view
    returns (uint256 _remaining)
  {
    _remaining = allowed[_owner][_spender];
  }

  
  function setWhitelistedRecipient(
    address _target,
    bool _state
  )
    external
    hasAbilities(ABILITY_SET_WHITELISTED)
  {
    whitelistedRecipients[_target] = _state;
    emit WhitelistedRecipient(_target, _state);
  }

  
  function setApprovedMigrator(
    address _target,
    bool _state
  )
    external
    hasAbilities(ABILITY_SET_MIGRATOR_ADDRESS)
  {
    approvedMigrators[_target] = _state;
    emit ApprovedMigrator(_target, _state);
  }

  
  function startMigration(
    address _target
  )
    external
    hasAbilities(ABILITY_SET_MIGRATE_ADDRESS)
  {
    require(_target != address(0), MIGRATION_NOT_STARTED);
    migrationAddress = _target;
  }

  
  function migrate()
    external
  {
    require(migrationAddress != address(0), MIGRATION_NOT_STARTED);
    uint256 balance = balances[msg.sender];
    balances[msg.sender] = 0;
    tokenTotalSupply = tokenTotalSupply.sub(balance);
    barteredToken.transfer(migrationAddress, balance);
    require(
      MigrationReceiver(migrationAddress)
        .onMigrationReceived(msg.sender, balance) == MAGIC_ON_MIGRATION_RECEIVED,
      NOT_ABLE_TO_MIGRATE
    );
    emit Transfer(msg.sender, address(0), balance);
  }

  
  function onMigrationReceived(
    address _migrator,
    uint256 _amount
  )
    external
    override
    returns(bytes4)
  {
    require(approvedMigrators[msg.sender], NOT_ABLE_TO_MIGRATE);
    tokenTotalSupply = tokenTotalSupply.add(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

    balances[_migrator] = balances[_migrator].add(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

    allowed[_migrator][tokenTransferProxy] = allowed[_migrator][tokenTransferProxy].add(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Approval(_migrator, tokenTransferProxy, allowed[_migrator][tokenTransferProxy]);
    emit Transfer(address(0), _migrator, _amount);
    return MAGIC_ON_MIGRATION_RECEIVED;
  }

  
  function transfer(
    address _to,
    uint256 _value
  )
    public
    override
    returns (bool _success)
  {
    require(migrationAddress == address(0), MIGRATION_STARTED);
    require(whitelistedRecipients[_to], NOT_WHITELISTED_ADDRESS);
    require(_value <= balances[msg.sender], NOT_ENOUGH_BALANCE);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW


    emit Transfer(msg.sender, _to, _value);
    _success = true;
  }

  
  function approve(
    address _spender,
    uint256 _value
  )
    public
    override
    returns (bool _success)
  {
    allowed[msg.sender][_spender] = _value;

    emit Approval(msg.sender, _spender, _value);
    _success = true;
  }

   
  function approveWithSignature(
    address _approver,
    address _spender,
    uint256 _value,
    address _feeRecipient,
    uint256 _feeValue,
    uint256 _seed,
    uint256 _expiration,
    SignatureData memory _signature
  )
    public
  {
    bytes32 claim = generateClaim(
      _approver,
      _spender,
      _value,
      _feeRecipient,
      _feeValue,
      _seed,
      _expiration
    );
    require(!claimCancelled[claim], CLAIM_CANCELED);
    require(!claimPerformed[claim], CLAIM_PERFORMED);
    require(
      isValidSignature(
        _approver,
        claim,
        _signature
      ),
      INVALID_SIGNATURE
    );
    require(_expiration > now, CLAIM_EXPIRED);
    claimPerformed[claim] = true;

    allowed[_approver][_spender] = _value;
    emit Approval(_approver, _spender, _value);

    require(_feeValue <= balances[_approver], NOT_ENOUGH_BALANCE);
    balances[_approver] = balances[_approver].sub(_feeValue);
    if (_feeRecipient == address(0)) {
      _feeRecipient = msg.sender;
    }
    balances[_feeRecipient] = balances[_feeRecipient].add(_feeValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Transfer(_approver, _feeRecipient, _feeValue);
  }

  
  function cancelApproveWithSignature(
    address _spender,
    uint256 _value,
    address _feeRecipient,
    uint256 _feeValue,
    uint256 _seed,
    uint256 _expiration
  )
    external
  {
    bytes32 claim = generateClaim(
      msg.sender,
      _spender,
      _value,
      _feeRecipient,
      _feeValue,
      _seed,
      _expiration
    );
    require(!claimPerformed[claim], CLAIM_PERFORMED);
    claimCancelled[claim] = true;
  }

  
  function generateClaim(
    address _approver,
    address _spender,
    uint256 _value,
    address _feeRecipient,
    uint256 _feeValue,
    uint256 _seed,
    uint256 _expiration
  )
    public
    view
    returns (bytes32 _claim)
  {
    _claim = keccak256(
      abi.encodePacked(
        address(this),
        _approver,
        _spender,
        _value,
        _feeRecipient,
        _feeValue,
        _seed,
        _expiration
      )
    );
  }

  
  function isValidSignature(
    address _signer,
    bytes32 _claim,
    SignatureData memory _signature
  )
    public
    pure
    returns (bool)
  {
    if (_signature.kind == SignatureKind.eth_sign)
    {
      return _signer == ecrecover(
        keccak256(
          abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _claim
          )
        ),
        _signature.v,
        _signature.r,
        _signature.s
      );
    } else if (_signature.kind == SignatureKind.trezor)
    {
      return _signer == ecrecover(
        keccak256(
          abi.encodePacked(
            "\x19Ethereum Signed Message:\n\x20",
            _claim
          )
        ),
        _signature.v,
        _signature.r,
        _signature.s
      );
    } else if (_signature.kind == SignatureKind.no_prefix)
    {
      return _signer == ecrecover(
        _claim,
        _signature.v,
        _signature.r,
        _signature.s
      );
    }

    revert(INVALID_SIGNATURE_KIND);
  }

  
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    override
    returns (bool _success)
  {
    require(migrationAddress == address(0), MIGRATION_STARTED);
    require(whitelistedRecipients[_to], NOT_WHITELISTED_ADDRESS);
    require(_value <= balances[_from], NOT_ENOUGH_BALANCE);
    require(_value <= allowed[_from][msg.sender], NOT_ENOUGH_ALLOWANCE);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);
    _success = true;
  }

  
  function deposit(
    uint256 _value,
    address _receiver
  )
    public
  {
    require(migrationAddress == address(0), MIGRATION_STARTED);
    tokenTotalSupply = tokenTotalSupply.add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    balances[_receiver] = balances[_receiver].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    barteredToken.transferFrom(msg.sender, address(this), _value);
    allowed[_receiver][tokenTransferProxy] = allowed[_receiver][tokenTransferProxy].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Transfer(address(0), _receiver, _value);
    emit Approval(_receiver, tokenTransferProxy, allowed[_receiver][tokenTransferProxy]);
  }

  
  function withdraw(
    uint256 _value
  )
    public
  {
    require(_value <= balances[msg.sender], NOT_ENOUGH_BALANCE);
    tokenTotalSupply = tokenTotalSupply.sub(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    balances[msg.sender] = balances[msg.sender].sub(_value);
    barteredToken.transfer(msg.sender, _value);
    emit Transfer(msg.sender, address(0), _value);
  }
}

contract DappTokenMock is
  DappToken
{
  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals,
    address _barteredToken,
    address _tokenTransferProxy
  )
    public
  {
    tokenName = _name;
    tokenSymbol = _symbol;
    tokenDecimals = _decimals;
    barteredToken = ERC20(_barteredToken);
    tokenTransferProxy = _tokenTransferProxy;
  }
}