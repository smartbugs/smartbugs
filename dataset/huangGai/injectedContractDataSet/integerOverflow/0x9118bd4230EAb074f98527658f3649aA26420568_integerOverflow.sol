/**
 *Submitted for verification at Etherscan.io on 2020-02-27
*/

pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;


interface Proxy {

  
  function execute(
    address _target,
    address _a,
    address _b,
    uint256 _c
  )
    external;
    
}

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
    require(_subtrahend <= _minuend, SUBTRAHEND_GREATER_THEN_MINUEND);
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

contract Token is
  ERC20,
  SupportsInterface
{
  using SafeMath for uint256;

  
  string constant NOT_ENOUGH_BALANCE = "001001";
  string constant NOT_ENOUGH_ALLOWANCE = "001002";

  
  string internal tokenName;

  
  string internal tokenSymbol;

  
  uint8 internal tokenDecimals;

  
  uint256 internal tokenTotalSupply;

  
  mapping (address => uint256) internal balances;

  
  mapping (address => mapping (address => uint256)) internal allowed;

  
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

  
  function transfer(
    address _to,
    uint256 _value
  )
    public
    override
    returns (bool _success)
  {
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

  
  function transferFrom(
    address _from,
    address _to,
    uint256 _value
  )
    public
    override
    returns (bool _success)
  {
    require(_value <= balances[_from], NOT_ENOUGH_BALANCE);
    require(_value <= allowed[_from][msg.sender], NOT_ENOUGH_ALLOWANCE);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);
    _success = true;
  }

}

contract TokenCustom is
  Token
{
  constructor(
    string memory _name,
    string memory _symbol,
    uint256 _supply,
    uint8 _decimals,
    address _owner
  )
    public
  {
    tokenName = _name;
    tokenSymbol = _symbol;
    tokenDecimals = _decimals;
    tokenTotalSupply = _supply;
    balances[_owner] = tokenTotalSupply;
    emit Transfer(address(0), _owner, tokenTotalSupply);
  }
}

contract TokenDeployProxy {
  
  function deploy(
    string memory _name,
    string memory _symbol,
    uint256 _supply,
    uint8 _decimals,
    address _owner
  )
    public
    returns (address token)
  {
    token = address(
      new TokenCustom(
        _name, _symbol, _supply, _decimals, _owner
      )
    );
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

contract TokenDeployGateway is
  Abilitable
{
  
  uint8 constant ABILITY_TO_SET_PROXY = 16;

  
  string constant INVALID_SIGNATURE_KIND = "011001";
  string constant TAKER_NOT_EQUAL_TO_SENDER = "011002";
  string constant CLAIM_EXPIRED = "011003";
  string constant INVALID_SIGNATURE = "011004";
  string constant DEPLOY_CANCELED = "011005";
  string constant DEPLOY_ALREADY_PERFORMED = "011006";
  string constant MAKER_NOT_EQUAL_TO_SENDER = "011007";

  
  enum SignatureKind
  {
    eth_sign,
    trezor,
    no_prefix
  }

  
  struct TokenData
  {
    string name;
    string symbol;
    uint256 supply;
    uint8 decimals;
    address owner;
  }

  
  struct TransferData
  {
    address token;
    address to;
    uint256 value;
  }

  
  struct SignatureData
  {
    bytes32 r;
    bytes32 s;
    uint8 v;
    SignatureKind kind;
  }

  
  struct DeployData
  {
    address maker;
    address taker;
    TokenData tokenData;
    TransferData transferData;
    uint256 seed;
    uint256 expiration;
  }

  
  TokenDeployProxy public tokenDeployProxy;

  
  Proxy public tokenTransferProxy;

  
  mapping(bytes32 => bool) public deployCancelled;

  
  mapping(bytes32 => bool) public deployPerformed;

  
  event Perform(
    address indexed _maker,
    address indexed _taker,
    address _createdContract,
    bytes32 _claim
  );

  
  event Cancel(
    address indexed _maker,
    address indexed _taker,
    bytes32 _claim
  );

  
  event ProxyChange(
    address _proxy
  );

  
  constructor(
    address _tokenDeployProxy,
    address _tokenTransferProxy
  )
    public
  {
    tokenDeployProxy = TokenDeployProxy(_tokenDeployProxy);
    tokenTransferProxy = Proxy(_tokenTransferProxy);
  }

  
  function setDeployProxy(
    address _tokenDeployProxy
  )
    external
    hasAbilities(ABILITY_TO_SET_PROXY)
  {
    tokenDeployProxy = TokenDeployProxy(_tokenDeployProxy);
    emit ProxyChange(_tokenDeployProxy);
  }

  
  function perform(
    DeployData memory _data,
    SignatureData memory _signature
  )
    public
  {
    require(_data.taker == msg.sender, TAKER_NOT_EQUAL_TO_SENDER);
    require(_data.expiration >= now, CLAIM_EXPIRED);

    bytes32 claim = getDeployDataClaim(_data);
    require(
      isValidSignature(
        _data.maker,
        claim,
        _signature
      ),
      INVALID_SIGNATURE
    );

    require(!deployCancelled[claim], DEPLOY_CANCELED);
    require(!deployPerformed[claim], DEPLOY_ALREADY_PERFORMED);

    deployPerformed[claim] = true;

    address token = _doActions(_data);

    emit Perform(
      _data.maker,
      _data.taker,
      token,
      claim
    );
  }

  
  function performAnyTaker(
    DeployData memory _data,
    SignatureData memory _signature
  )
    public
  {
    require(_data.expiration >= now, CLAIM_EXPIRED);

    bytes32 claim = getDeployDataClaim(_data);
    require(
      isValidSignature(
        _data.maker,
        claim,
        _signature
      ),
      INVALID_SIGNATURE
    );

    require(!deployCancelled[claim], DEPLOY_CANCELED);
    require(!deployPerformed[claim], DEPLOY_ALREADY_PERFORMED);

    deployPerformed[claim] = true;

    address token = _doActionsReplaceZeroAddress(_data);

    emit Perform(
      _data.maker,
      msg.sender,
      token,
      claim
    );
  }

  
  function cancel(
    DeployData memory _data
  )
    public
  {
    require(_data.maker == msg.sender, MAKER_NOT_EQUAL_TO_SENDER);

    bytes32 claim = getDeployDataClaim(_data);
    require(!deployPerformed[claim], DEPLOY_ALREADY_PERFORMED);

    deployCancelled[claim] = true;
    emit Cancel(
      _data.maker,
      _data.taker,
      claim
    );
  }

  
  function getDeployDataClaim(
    DeployData memory _deployData
  )
    public
    view
    returns (bytes32)
  {
    bytes32 tokendata = keccak256(
      abi.encodePacked(
        _deployData.tokenData.name,
        _deployData.tokenData.symbol,
        _deployData.tokenData.supply,
        _deployData.tokenData.decimals,
        _deployData.tokenData.owner
      )
    );

    bytes32 transferData = keccak256(
      abi.encodePacked(
        _deployData.transferData.token,
        _deployData.transferData.to,
        _deployData.transferData.value
      )
    );

    return keccak256(
      abi.encodePacked(
        address(this),
        _deployData.maker,
        _deployData.taker,
        tokendata,
        transferData,
        _deployData.seed,
        _deployData.expiration
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

  
  function _doActions(
    DeployData memory _deploy
  )
    private
    returns (address _token)
  {
    tokenTransferProxy.execute(
      _deploy.transferData.token,
      _deploy.maker,
      _deploy.transferData.to,
      _deploy.transferData.value
    );

    _token = tokenDeployProxy.deploy(
      _deploy.tokenData.name,
      _deploy.tokenData.symbol,
      _deploy.tokenData.supply,
      _deploy.tokenData.decimals,
      _deploy.tokenData.owner
    );
  }

  
  function _doActionsReplaceZeroAddress(
    DeployData memory _deploy
  )
    private
    returns (address _token)
  {
    if (_deploy.transferData.to == address(0))
    {
      _deploy.transferData.to = msg.sender;
    }

    tokenTransferProxy.execute(
      _deploy.transferData.token,
      _deploy.maker,
      _deploy.transferData.to,
      _deploy.transferData.value
    );

    _token = tokenDeployProxy.deploy(
      _deploy.tokenData.name,
      _deploy.tokenData.symbol,
      _deploy.tokenData.supply,
      _deploy.tokenData.decimals,
      _deploy.tokenData.owner
    );
  }
}