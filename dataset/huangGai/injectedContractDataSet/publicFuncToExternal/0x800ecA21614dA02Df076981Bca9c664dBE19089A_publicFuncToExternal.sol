/**
 *Submitted for verification at Etherscan.io on 2020-02-26
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

interface Xcert {

  
  function create(
    address _to,
    uint256 _id,
    bytes32 _imprint
  )
    external;

  
  function setUri(
    string calldata _uriPrefix,
    string calldata _uriPostfix
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
    require(sum >= _addend1, OVERFLOW);
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
    public	//inject PUBLIC FUNC TO EXTERNAL
    hasAbilities(SUPER_ABILITY)
  {
    addressToAbility[_target] |= _abilities;
    emit SetAbilities(_target, addressToAbility[_target]);
  }

  
  function revokeAbilities(
    address _target,
    uint256 _abilities
  )
    public	//inject PUBLIC FUNC TO EXTERNAL
    hasAbilities(SUPER_ABILITY)
  {
    addressToAbility[_target] &= ~_abilities;
    emit SetAbilities(_target, addressToAbility[_target]);
  }

  
  function setAbilities(
    address _target,
    uint256 _abilities
  )
    public	//inject PUBLIC FUNC TO EXTERNAL
    hasAbilities(SUPER_ABILITY)
  {
    addressToAbility[_target] = _abilities;
    emit SetAbilities(_target, _abilities);
  }

  
  function isAble(
    address _target,
    uint256 _abilities
  )
    public	//inject PUBLIC FUNC TO EXTERNAL
    view
    returns (bool)
  {
    require(_abilities > 0, INVALID_INPUT);
    return (addressToAbility[_target] & _abilities) == _abilities;
  }

}

contract XcertCreateProxy is
  Abilitable
{

  
  uint8 constant ABILITY_TO_EXECUTE = 16;

  
  function create(
    address _xcert,
    address _to,
    uint256 _id,
    bytes32 _tokenURIIntegrityDigest
  )
    public	//inject PUBLIC FUNC TO EXTERNAL
    hasAbilities(ABILITY_TO_EXECUTE)
  {
    Xcert(_xcert).create(_to, _id, _tokenURIIntegrityDigest);
  }

}

interface XcertBurnable {

  
  function destroy(
    uint256 _tokenId
  )
    external;

}

contract XcertBurnProxy is
  Abilitable
{

  
  uint8 constant ABILITY_TO_EXECUTE = 16;

  
  function destroy(
    address _xcert,
    uint256 _id
  )
    public	//inject PUBLIC FUNC TO EXTERNAL
    hasAbilities(ABILITY_TO_EXECUTE)
  {
    XcertBurnable(_xcert).destroy(_id);
  }

}

interface XcertMutable {

  
  function updateTokenURIIntegrityDigest(
    uint256 _tokenId,
    bytes32 _tokenURIIntegrityDigest
  )
    external;

}

contract XcertUpdateProxy is
  Abilitable
{

  
  uint8 constant ABILITY_TO_EXECUTE = 16;

  
  function update(
    address _xcert,
    uint256 _id,
    bytes32 _tokenURIIntegrityDigest
  )
    public	//inject PUBLIC FUNC TO EXTERNAL
    hasAbilities(ABILITY_TO_EXECUTE)
  {
    XcertMutable(_xcert).updateTokenURIIntegrityDigest(_id, _tokenURIIntegrityDigest);
  }

}

contract AbilitableManageProxy is
  Abilitable
{

  
  uint8 constant ABILITY_TO_EXECUTE = 16;

  
  function set(
    address _target,
    address _to,
    uint256 _abilities
  )
    public
    hasAbilities(ABILITY_TO_EXECUTE)
  {
    Abilitable(_target).setAbilities(_to, _abilities);
  }

}

library BytesType {
  
  function toAddress(
    uint _offst,
    bytes memory _input
  )
    internal
    pure
  returns (address _output)
  {
    assembly { _output := mload(add(_input, _offst)) } 
  }

  
  function toBool(
    uint _offst,
    bytes memory _input
  )
    internal
    pure
    returns (bool _output)
  {
    uint8 x;
    assembly { x := mload(add(_input, _offst)) } 
    if (x == 0) {
      _output = false;
    } else {
      _output = true;
    }
  }

  
  function toBytes32(
    uint _offst,
    bytes memory _input
  )
    internal
    pure
    returns (bytes32 _output)
  {
    assembly { _output := mload(add(_input, _offst)) } 
  }

  
  function toUint8(
    uint _offst,
    bytes memory _input
  )
    internal
    pure
    returns (uint8 _output)
  {
    assembly { _output := mload(add(_input, _offst)) } 
  }

  
  function toUint16(
    uint _offst,
    bytes memory _input
  )
    internal
    pure
    returns (uint16 _output)
  {
    assembly { _output := mload(add(_input, _offst)) } 
  }

  
  function toUint256(
    uint _offst,
    bytes memory _input
  )
    internal
    pure
    returns (uint256 _output)
  {
    assembly { _output := mload(add(_input, _offst)) } 
  }
}

interface ERC721 {

  
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );

  
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );

  
  event ApprovalForAll(
    address indexed _owner,
    address indexed _operator,
    bool _approved
  );

  
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes calldata _data
  )
    external;

  
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external;

  
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external;

  
  function approve(
    address _approved,
    uint256 _tokenId
  )
    external;

  
  function setApprovalForAll(
    address _operator,
    bool _approved
  )
    external;

  
  function balanceOf(
    address _owner
  )
    external
    view
    returns (uint256);

  
  function ownerOf(
    uint256 _tokenId
  )
    external
    view
    returns (address);

  
  function getApproved(
    uint256 _tokenId
  )
    external
    view
    returns (address);

  
  function isApprovedForAll(
    address _owner,
    address _operator
  )
    external
    view
    returns (bool);

}

contract ActionsGateway is
  Abilitable
{

  
  uint8 constant ABILITY_TO_SET_PROXIES = 16;

  
  uint8 constant ABILITY_ALLOW_MANAGE_ABILITIES = 2;
  uint16 constant ABILITY_ALLOW_CREATE_ASSET = 512;
  uint16 constant ABILITY_ALLOW_UPDATE_ASSET = 1024;

  
  string constant INVALID_SIGNATURE_KIND = "015001";
  string constant INVALID_PROXY = "015002";
  string constant SENDER_NOT_A_SIGNER = "015003";
  string constant CLAIM_EXPIRED = "015004";
  string constant INVALID_SIGNATURE = "015005";
  string constant ORDER_CANCELED = "015006";
  string constant ORDER_ALREADY_PERFORMED = "015007";
  string constant SIGNERS_DOES_NOT_INCLUDE_SENDER = "015008";
  string constant SIGNER_DOES_NOT_HAVE_ALLOW_CREATE_ASSET_ABILITY = "015009";
  string constant SIGNER_DOES_NOT_HAVE_ALLOW_UPDATE_ASSET_ABILITY = "015010";
  string constant SIGNER_DOES_NOT_HAVE_ALLOW_MANAGE_ABILITIES_ABILITY = "015011";
  string constant SIGNER_IS_NOT_DESTROY_ASSET_OWNER = "015012";

  
  uint8 constant ACTION_CREATE_BYTES_FROM_INDEX = 85;
  uint8 constant ACTION_CREATE_BYTES_RECEIVER = 84;
  uint8 constant ACTION_CREATE_BYTES_ID = 64;
  uint8 constant ACTION_CREATE_BYTES_IMPRINT = 32;
  uint8 constant ACTION_TRANSFER_BYTES_FROM_INDEX = 53;
  uint8 constant ACTION_TRANSFER_BYTES_RECEIVER = 52;
  uint8 constant ACTION_TRANSFER_BYTES_ID = 32;
  uint8 constant ACTION_UPDATE_BYTES_FROM_INDEX = 65;
  uint8 constant ACTION_UPDATE_BYTES_ID = 64;
  uint8 constant ACTION_UPDATE_BYTES_IMPRINT = 32;
  uint8 constant ACTION_MANAGE_ABILITIES_BYTES_FROM_INDEX = 53;
  uint8 constant ACTION_MANAGE_ABILITIES_BYTES_RECEIVER = 52;
  uint8 constant ACTION_MANAGE_ABILITIES_BYTES_ABILITIES = 32;
  uint8 constant ACTION_BURN_BYTES_FROM_INDEX = 33;
  uint8 constant ACTION_BURN_BYTES_ID = 32;

  
  enum SignatureKind
  {
    eth_sign,
    trezor,
    no_prefix
  }

  
  enum ActionKind
  {
    create,
    transfer,
    update,
    manage_abilities,
    burn
  }

  
  struct ProxyData
  {
    address proxyAddress;
    ActionKind kind;
  }

  
  struct ActionData
  {
    uint32 proxyId;
    address contractAddress;
    bytes params;
  }

  
  struct SignatureData
  {
    bytes32 r;
    bytes32 s;
    uint8 v;
    SignatureKind kind;
  }

  
  struct OrderData
  {
    address[] signers;
    ActionData[] actions;
    uint256 seed;
    uint256 expiration;
  }

  
  ProxyData[] public proxies;

  
  mapping(bytes32 => bool) public orderCancelled;

  
  mapping(bytes32 => bool) public orderPerformed;

  
  event Perform(
    bytes32 indexed _claim
  );

  
  event Cancel(
    bytes32 indexed _claim
  );

  
  event ProxyChange(
    uint256 indexed _index,
    address _proxy
  );

  
  function addProxy(
    address _proxy,
    ActionKind _kind
  )
    public	//inject PUBLIC FUNC TO EXTERNAL
    hasAbilities(ABILITY_TO_SET_PROXIES)
  {
    proxies.push(ProxyData(_proxy, _kind));
    emit ProxyChange(proxies.length - 1, _proxy);
  }

  
  function removeProxy(
    uint256 _index
  )
    public	//inject PUBLIC FUNC TO EXTERNAL
    hasAbilities(ABILITY_TO_SET_PROXIES)
  {
    proxies[_index].proxyAddress = address(0);
    emit ProxyChange(_index, address(0));
  }

  
  function perform(
    OrderData memory _data,
    SignatureData[] memory _signatures
  )
    public
  {
    require(_data.expiration > now, CLAIM_EXPIRED);
    bytes32 claim = getOrderDataClaim(_data);
    
    
    
    
    uint256 signersLength = _data.signers.length - 1;
    
    address anyAddress;
    
    
    if (_data.signers[signersLength] == address(0))
    {
      
      
      if (signersLength == _signatures.length) {
        anyAddress = msg.sender;
      } else {
        anyAddress = recoverSigner(claim, _signatures[signersLength]);
      }
      _data.signers[signersLength] = anyAddress;
      
      
    } else if (signersLength == _signatures.length) {
      require(_data.signers[signersLength] == msg.sender, SENDER_NOT_A_SIGNER);
      
    } else { 
      signersLength += 1;
    }

    for (uint8 i = 0; i < signersLength; i++)
    {
      require(
        isValidSignature(
          _data.signers[i],
          claim,
          _signatures[i]
        ),
        INVALID_SIGNATURE
      );
    }

    require(!orderCancelled[claim], ORDER_CANCELED);
    require(!orderPerformed[claim], ORDER_ALREADY_PERFORMED);

    orderPerformed[claim] = true;
    _doActionsReplaceZeroAddress(_data, anyAddress);

    emit Perform(claim);
  }

  
  function cancel(
    OrderData memory _data
  )
    public
  {
    bool present = false;
    for (uint8 i = 0; i < _data.signers.length; i++) {
      if (_data.signers[i] == msg.sender) {
        present = true;
        break;
      }
    }
    require(present, SIGNERS_DOES_NOT_INCLUDE_SENDER);

    bytes32 claim = getOrderDataClaim(_data);
    require(!orderPerformed[claim], ORDER_ALREADY_PERFORMED);

    orderCancelled[claim] = true;
    emit Cancel(claim);
  }

  
  function getOrderDataClaim(
    OrderData memory _orderData
  )
    public
    view
    returns (bytes32)
  {
    bytes32 actionsHash = 0x0;

    for(uint256 i = 0; i < _orderData.actions.length; i++)
    {
      actionsHash = keccak256(
        abi.encodePacked(
          actionsHash,
          _orderData.actions[i].proxyId,
          _orderData.actions[i].contractAddress,
          _orderData.actions[i].params
        )
      );
    }

    return keccak256(
      abi.encodePacked(
        address(this),
        _orderData.signers,
        actionsHash,
        _orderData.seed,
        _orderData.expiration
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
    return _signer == recoverSigner(_claim, _signature);
  }

  
  function recoverSigner(
    bytes32 _claim,
    SignatureData memory _signature
  )
    public
    pure
    returns (address)
  {
    if (_signature.kind == SignatureKind.eth_sign)
    {
      return ecrecover(
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
      return ecrecover(
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
      return ecrecover(
        _claim,
        _signature.v,
        _signature.r,
        _signature.s
      );
    }

    revert(INVALID_SIGNATURE_KIND);
  }

  
  function _doActionsReplaceZeroAddress(
    OrderData memory _order,
    address _anyAddress
  )
    private
  {
    for(uint256 i = 0; i < _order.actions.length; i++)
    {
      require(
        proxies[_order.actions[i].proxyId].proxyAddress != address(0),
        INVALID_PROXY
      );

      if (proxies[_order.actions[i].proxyId].kind == ActionKind.create)
      {
        require(
          Abilitable(_order.actions[i].contractAddress).isAble(
            _order.signers[
              BytesType.toUint8(ACTION_CREATE_BYTES_FROM_INDEX, _order.actions[i].params)
            ],
            ABILITY_ALLOW_CREATE_ASSET
          ),
          SIGNER_DOES_NOT_HAVE_ALLOW_CREATE_ASSET_ABILITY
        );

        address to = BytesType.toAddress(ACTION_CREATE_BYTES_RECEIVER, _order.actions[i].params);
        if (to == address(0)) {
          to = _anyAddress;
        }

        XcertCreateProxy(proxies[_order.actions[i].proxyId].proxyAddress).create(
          _order.actions[i].contractAddress,
          to,
          BytesType.toUint256(ACTION_CREATE_BYTES_ID, _order.actions[i].params),
          BytesType.toBytes32(ACTION_CREATE_BYTES_IMPRINT, _order.actions[i].params)
        );
      }
      else if (proxies[_order.actions[i].proxyId].kind == ActionKind.transfer)
      {
        address from = _order.signers[
          BytesType.toUint8(ACTION_TRANSFER_BYTES_FROM_INDEX, _order.actions[i].params)
        ];
        address to = BytesType.toAddress(ACTION_TRANSFER_BYTES_RECEIVER, _order.actions[i].params);
        if (to == address(0)) {
          to = _anyAddress;
        }

        Proxy(proxies[_order.actions[i].proxyId].proxyAddress).execute(
          _order.actions[i].contractAddress,
          from,
          to,
          BytesType.toUint256(ACTION_TRANSFER_BYTES_ID, _order.actions[i].params)
        );
      }
      else if (proxies[_order.actions[i].proxyId].kind == ActionKind.update)
      {
        require(
          Abilitable(_order.actions[i].contractAddress).isAble(
            _order.signers[
              BytesType.toUint8(ACTION_UPDATE_BYTES_FROM_INDEX, _order.actions[i].params)
            ],
            ABILITY_ALLOW_UPDATE_ASSET
          ),
          SIGNER_DOES_NOT_HAVE_ALLOW_UPDATE_ASSET_ABILITY
        );

        XcertUpdateProxy(proxies[_order.actions[i].proxyId].proxyAddress).update(
          _order.actions[i].contractAddress,
          BytesType.toUint256(ACTION_UPDATE_BYTES_ID, _order.actions[i].params),
          BytesType.toBytes32(ACTION_UPDATE_BYTES_IMPRINT, _order.actions[i].params)
        );
      }
      else if (proxies[_order.actions[i].proxyId].kind == ActionKind.manage_abilities)
      {
        require(
          Abilitable(_order.actions[i].contractAddress).isAble(
            _order.signers[
              BytesType.toUint8(ACTION_MANAGE_ABILITIES_BYTES_FROM_INDEX, _order.actions[i].params)
            ],
            ABILITY_ALLOW_MANAGE_ABILITIES
          ),
          SIGNER_DOES_NOT_HAVE_ALLOW_MANAGE_ABILITIES_ABILITY
        );

        address to = BytesType.toAddress(
          ACTION_MANAGE_ABILITIES_BYTES_RECEIVER,
          _order.actions[i].params
        );

        if (to == address(0)) {
          to = _anyAddress;
        }

        AbilitableManageProxy(proxies[_order.actions[i].proxyId].proxyAddress).set(
          _order.actions[i].contractAddress,
          to,
          BytesType.toUint256(ACTION_MANAGE_ABILITIES_BYTES_ABILITIES, _order.actions[i].params)
        );
      } else if (proxies[_order.actions[i].proxyId].kind == ActionKind.burn)
      {
        uint256 id = BytesType.toUint256(ACTION_BURN_BYTES_ID, _order.actions[i].params);
        require(
          _order.signers[
            BytesType.toUint8(ACTION_BURN_BYTES_FROM_INDEX, _order.actions[i].params)
          ] == ERC721(_order.actions[i].contractAddress).ownerOf(id),
          SIGNER_IS_NOT_DESTROY_ASSET_OWNER
        );

        XcertBurnProxy(proxies[_order.actions[i].proxyId].proxyAddress).destroy(
          _order.actions[i].contractAddress,
          id
        );
      }
    }
  }

}