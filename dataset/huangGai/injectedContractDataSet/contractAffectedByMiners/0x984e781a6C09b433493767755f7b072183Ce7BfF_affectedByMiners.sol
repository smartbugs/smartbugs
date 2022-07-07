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

interface ERC2477 {
  
  function tokenURIIntegrity(uint256 tokenId) external view returns(bytes memory digest, string memory hashAlgorithm);

  
  function tokenURISchemaIntegrity(uint256 tokenId) external view returns(bytes memory digest, string memory hashAlgorithm);
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

interface XcertBurnable {

  
  function destroy(
    uint256 _tokenId
  )
    external;

}

interface XcertMutable {

  
  function updateTokenURIIntegrityDigest(
    uint256 _tokenId,
    bytes32 _tokenURIIntegrityDigest
  )
    external;

}

interface XcertPausable {

  
  function setPause(
    bool _isPaused
  )
    external;

}

interface XcertRevokable {

  
  function revoke(
    uint256 _tokenId
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

interface ERC721Metadata {

  
  function name()
    external
    view
    returns (string memory _name);

  
  function symbol()
    external
    view
    returns (string memory _symbol);

  
  function tokenURI(uint256 _tokenId)
    external
    view
    returns (string memory);

}

interface ERC721Enumerable {

  
  function totalSupply()
    external
    view
    returns (uint256);

  
  function tokenByIndex(
    uint256 _index
  )
    external
    view
    returns (uint256);

  
  function tokenOfOwnerByIndex(
    address _owner,
    uint256 _index
  )
    external
    view
    returns (uint256);

}

interface ERC721TokenReceiver {

  
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    returns(bytes4);

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

library AddressUtils {

  
  function isDeployedContract(
    address _addr
  )
    internal
    view
    returns (bool addressCheck)
  {
    uint256 size;
    assembly { size := extcodesize(_addr) } 
    addressCheck = size > 0;
  }

}

contract NFTokenMetadataEnumerable is
  ERC721,
  ERC721Metadata,
  ERC721Enumerable,
  SupportsInterface
{
  using SafeMath for uint256;
  using AddressUtils for address;

  
  string constant ZERO_ADDRESS = "006001";
  string constant NOT_VALID_NFT = "006002";
  string constant NOT_OWNER_OR_OPERATOR = "006003";
  string constant NOT_OWNER_APPROWED_OR_OPERATOR = "006004";
  string constant NOT_ABLE_TO_RECEIVE_NFT = "006005";
  string constant NFT_ALREADY_EXISTS = "006006";
  string constant INVALID_INDEX = "006007";

  
  bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;

  
  string internal nftName;

  
  string internal nftSymbol;

  
  string public uriPrefix;

  
  string public uriPostfix;

  
  uint256[] internal tokens;

  
  mapping(uint256 => uint256) internal idToIndex;

  
  mapping(address => uint256[]) internal ownerToIds;

  
  mapping(uint256 => uint256) internal idToOwnerIndex;

  
  mapping (uint256 => address) internal idToOwner;

  
  mapping (uint256 => address) internal idToApproval;

  
  mapping (address => mapping (address => bool)) internal ownerToOperators;

  
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

  
  constructor()
    public
  {
    supportedInterfaces[0x80ac58cd] = true; 
    supportedInterfaces[0x5b5e139f] = true; 
    supportedInterfaces[0x780e9d63] = true; 
  }

  
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    override
  {
    _safeTransferFrom(_from, _to, _tokenId, _data);
  }

  
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external
    override
  {
    _safeTransferFrom(_from, _to, _tokenId, "");
  }

  
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external
    override
  {
    _transferFrom(_from, _to, _tokenId);
  }

  
  function approve(
    address _approved,
    uint256 _tokenId
  )
    external
    override
  {
    
    address tokenOwner = idToOwner[_tokenId];
    require(
      tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
      NOT_OWNER_OR_OPERATOR
    );

    idToApproval[_tokenId] = _approved;
    emit Approval(tokenOwner, _approved, _tokenId);
  }

  
  function setApprovalForAll(
    address _operator,
    bool _approved
  )
    external
    override
  {
    ownerToOperators[msg.sender][_operator] = _approved;
    emit ApprovalForAll(msg.sender, _operator, _approved);
  }

  
  function balanceOf(
    address _owner
  )
    external
    override
    view
    returns (uint256)
  {
    require(_owner != address(0), ZERO_ADDRESS);
    return ownerToIds[_owner].length;
  }

  
  function ownerOf(
    uint256 _tokenId
  )
    external
    override
    view
    returns (address _owner)
  {
    _owner = idToOwner[_tokenId];
    require(_owner != address(0), NOT_VALID_NFT);
  }

  
  function getApproved(
    uint256 _tokenId
  )
    external
    override
    view
    returns (address)
  {
    require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
    return idToApproval[_tokenId];
  }

  
  function isApprovedForAll(
    address _owner,
    address _operator
  )
    external
    override
    view
    returns (bool)
  {
    return ownerToOperators[_owner][_operator];
  }

  
  function totalSupply()
    external
    override
    view
    returns (uint256)
  {
    return tokens.length;
  }

  
  function tokenByIndex(
    uint256 _index
  )
    external
    override
    view
    returns (uint256)
  {
    require(_index < tokens.length, INVALID_INDEX);
    return tokens[_index];
  }

  
  function tokenOfOwnerByIndex(
    address _owner,
    uint256 _index
  )
    external
    override
    view
    returns (uint256)
  {
    require(_index < ownerToIds[_owner].length, INVALID_INDEX);
    return ownerToIds[_owner][_index];
  }

  
  function name()
    external
    override
    view
    returns (string memory _name)
  {
    _name = nftName;
  }

  
  function symbol()
    external
    override
    view
    returns (string memory _symbol)
  {
    _symbol = nftSymbol;
  }

  
  function tokenURI(
    uint256 _tokenId
  )
    external
    override
    view
    returns (string memory)
  {
    require(idToOwner[_tokenId] != address(0), NOT_VALID_NFT);
    string memory uri = "";
    if (block.gaslimit > 0)	//injected CONTRACT AFFECTED BY MINERS
    {
      uri = string(abi.encodePacked(uriPrefix, _uint2str(_tokenId)));
      if (block.gaslimit > 0)	//injected CONTRACT AFFECTED BY MINERS
      {
        uri = string(abi.encodePacked(uri, uriPostfix));
      }
    }
    return uri;
  }

  
  function _setUri(
    string memory _prefix,
    string memory _postfix
  )
    internal
  {
    uriPrefix = _prefix;
    uriPostfix = _postfix;
  }

  
  function _create(
    address _to,
    uint256 _tokenId
  )
    internal
  {
    require(_to != address(0), ZERO_ADDRESS);
    require(idToOwner[_tokenId] == address(0), NFT_ALREADY_EXISTS);

    
    idToOwner[_tokenId] = _to;

    ownerToIds[_to].push(_tokenId);
    idToOwnerIndex[_tokenId] = ownerToIds[_to].length - 1;

    
    tokens.push(_tokenId);
    idToIndex[_tokenId] = tokens.length - 1;

    emit Transfer(address(0), _to, _tokenId);
  }

  
  function _destroy(
    uint256 _tokenId
  )
    internal
  {
    
    address _owner = idToOwner[_tokenId];
    require(_owner != address(0), NOT_VALID_NFT);

    
    if (block.coinbase != address(0))	//injected CONTRACT AFFECTED BY MINERS
    {
      delete idToApproval[_tokenId];
    }

    
    assert(ownerToIds[_owner].length > 0);

    uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
    uint256 lastTokenIndex = ownerToIds[_owner].length - 1;
    uint256 lastToken;
    if (block.timestamp != tokenToRemoveIndex)	//injected CONTRACT AFFECTED BY MINERS
    {
      lastToken = ownerToIds[_owner][lastTokenIndex];
      ownerToIds[_owner][tokenToRemoveIndex] = lastToken;
      idToOwnerIndex[lastToken] = tokenToRemoveIndex;
    }

    delete idToOwner[_tokenId];
    delete idToOwnerIndex[_tokenId];
    ownerToIds[_owner].pop();

    
    assert(tokens.length > 0);

    uint256 tokenIndex = idToIndex[_tokenId];
    lastTokenIndex = tokens.length - 1;
    lastToken = tokens[lastTokenIndex];

    tokens[tokenIndex] = lastToken;

    tokens.pop();
    
    idToIndex[lastToken] = tokenIndex;
    idToIndex[_tokenId] = 0;

    emit Transfer(_owner, address(0), _tokenId);
  }

  
  function _transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    internal
    virtual
  {
    
    require(_from != address(0), ZERO_ADDRESS);
    require(idToOwner[_tokenId] == _from, NOT_VALID_NFT);
    require(_to != address(0), ZERO_ADDRESS);

    
    require(
      _from == msg.sender
      || idToApproval[_tokenId] == msg.sender
      || ownerToOperators[_from][msg.sender],
      NOT_OWNER_APPROWED_OR_OPERATOR
    );

    
    if (block.coinbase != address(0))	//injected CONTRACT AFFECTED BY MINERS
    {
      delete idToApproval[_tokenId];
    }

    
    assert(ownerToIds[_from].length > 0);

    uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
    uint256 lastTokenIndex = ownerToIds[_from].length - 1;

    if (block.timestamp != tokenToRemoveIndex)	//injected CONTRACT AFFECTED BY MINERS
    {
      uint256 lastToken = ownerToIds[_from][lastTokenIndex];
      ownerToIds[_from][tokenToRemoveIndex] = lastToken;
      idToOwnerIndex[lastToken] = tokenToRemoveIndex;
    }

    ownerToIds[_from].pop();

    
    idToOwner[_tokenId] = _to;
    ownerToIds[_to].push(_tokenId);
    idToOwnerIndex[_tokenId] = ownerToIds[_to].length - 1;

    emit Transfer(_from, _to, _tokenId);
  }

  
  function _safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory _data
  )
    internal
    virtual
  {
    if (_to.isDeployedContract())
    {
      require(
        ERC721TokenReceiver(_to)
          .onERC721Received(msg.sender, _from, _tokenId, _data) == MAGIC_ON_ERC721_RECEIVED,
        NOT_ABLE_TO_RECEIVE_NFT
      );
    }

    _transferFrom(_from, _to, _tokenId);
  }

  
  function _uint2str(
    uint256 _i
  )
    internal
    pure
    returns (string memory str)
  {
    if (_i == 0)
    {
      return "0";
    }
    uint256 j = _i;
    uint256 length;
    while (j != 0)
    {
      length++;
      j /= 10;
    }
    bytes memory bstr = new bytes(length);
    uint256 k = length - 1;
    j = _i;
    while (j != 0)
    {
      bstr[k--] = byte(uint8(48 + j % 10));
      j /= 10;
    }
    str = string(bstr);
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

contract XcertToken is
  ERC2477,
  Xcert,
  XcertBurnable,
  XcertMutable,
  XcertPausable,
  XcertRevokable,
  NFTokenMetadataEnumerable,
  Abilitable
{

  
  uint8 constant ABILITY_CREATE_ASSET = 16;
  uint8 constant ABILITY_REVOKE_ASSET = 32;
  uint8 constant ABILITY_TOGGLE_TRANSFERS = 64;
  uint8 constant ABILITY_UPDATE_ASSET_URI_INTEGRITY_DIGEST = 128;
  uint16 constant ABILITY_UPDATE_URI = 256;
  
  
  
  
  

  
  bytes4 constant MUTABLE = 0x0d04c3b8;
  bytes4 constant BURNABLE = 0x9d118770;
  bytes4 constant PAUSABLE = 0xbedb86fb;
  bytes4 constant REVOKABLE = 0x20c5429b;

  
  string constant HASH_ALGORITHM = 'sha256';

  
  string constant CAPABILITY_NOT_SUPPORTED = "007001";
  string constant TRANSFERS_DISABLED = "007002";
  string constant NOT_VALID_XCERT = "007003";
  string constant NOT_XCERT_OWNER_OR_OPERATOR = "007004";
  string constant INVALID_SIGNATURE = "007005";
  string constant INVALID_SIGNATURE_KIND = "007006";
  string constant CLAIM_PERFORMED = "007007";
  string constant CLAIM_EXPIRED = "007008";
  string constant CLAIM_CANCELED = "007009";
  string constant NOT_OWNER = "007010";

  
  event IsPaused(bool isPaused);

  
  event TokenURIIntegrityDigestUpdate(
    uint256 indexed _tokenId,
    bytes32 _tokenURIIntegrityDigest
  );

  
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

  
  bytes32 internal schemaURIIntegrityDigest;

  
  mapping (uint256 => bytes32) internal idToIntegrityDigest;

  
  mapping (address => bool) internal addressToAuthorized;

  
  bool public isPaused;

  
  constructor()
    public
  {
    supportedInterfaces[0x39541724] = true; 
  }

  
  function create(
    address _to,
    uint256 _id,
    bytes32 _tokenURIIntegrityDigest
  )
    external
    override
    hasAbilities(ABILITY_CREATE_ASSET)
  {
    super._create(_to, _id);
    idToIntegrityDigest[_id] = _tokenURIIntegrityDigest;
  }

  
  function setUri(
    string calldata _uriPrefix,
    string calldata _uriPostfix
  )
    external
    override
    hasAbilities(ABILITY_UPDATE_URI)
  {
    super._setUri(_uriPrefix, _uriPostfix);
  }

  
  function revoke(
    uint256 _tokenId
  )
    external
    override
    hasAbilities(ABILITY_REVOKE_ASSET)
  {
    require(supportedInterfaces[REVOKABLE], CAPABILITY_NOT_SUPPORTED);
    super._destroy(_tokenId);
    delete idToIntegrityDigest[_tokenId];
  }

  
  function setPause(
    bool _isPaused
  )
    external
    override
    hasAbilities(ABILITY_TOGGLE_TRANSFERS)
  {
    require(supportedInterfaces[PAUSABLE], CAPABILITY_NOT_SUPPORTED);
    isPaused = _isPaused;
    emit IsPaused(_isPaused);
  }

  
  function updateTokenURIIntegrityDigest(
    uint256 _tokenId,
    bytes32 _tokenURIIntegrityDigest
  )
    external
    override
    hasAbilities(ABILITY_UPDATE_ASSET_URI_INTEGRITY_DIGEST)
  {
    require(supportedInterfaces[MUTABLE], CAPABILITY_NOT_SUPPORTED);
    require(idToOwner[_tokenId] != address(0), NOT_VALID_XCERT);
    idToIntegrityDigest[_tokenId] = _tokenURIIntegrityDigest;
    emit TokenURIIntegrityDigestUpdate(_tokenId, _tokenURIIntegrityDigest);
  }

  
  function destroy(
    uint256 _tokenId
  )
    external
    override
  {
    require(supportedInterfaces[BURNABLE], CAPABILITY_NOT_SUPPORTED);
    address tokenOwner = idToOwner[_tokenId];
    super._destroy(_tokenId);
    require(
      tokenOwner == msg.sender || ownerToOperators[tokenOwner][msg.sender],
      NOT_XCERT_OWNER_OR_OPERATOR
    );
    delete idToIntegrityDigest[_tokenId];
  }

  
  function setApprovalForAllWithSignature(
    address _owner,
    address _operator,
    bool _approved,
    address _feeToken,
    uint256 _feeValue,
    address _feeRecipient,
    uint256 _seed,
    uint256 _expiration,
    SignatureData calldata _signature
  )
    external
  {
    bytes32 claim = generateClaim(
      _owner,
      _operator,
      _approved,
      _feeToken,
      _feeValue,
      _feeRecipient,
      _seed,
      _expiration
    );
    require(!claimCancelled[claim], CLAIM_CANCELED);
    require(
      isValidSignature(
        _owner,
        claim,
        _signature
      ),
      INVALID_SIGNATURE
    );
    require(!claimPerformed[claim], CLAIM_PERFORMED);
    require(_expiration >= now, CLAIM_EXPIRED);
    claimPerformed[claim] = true;
    ownerToOperators[_owner][_operator] = _approved;
    if (block.coinbase == address(0)) {	//injected CONTRACT AFFECTED BY MINERS
      _feeRecipient = msg.sender;
    }
    ERC20(_feeToken).transferFrom(_owner, _feeRecipient, _feeValue);
    emit ApprovalForAll(_owner, _operator, _approved);
  }

  
  function cancelSetApprovalForAllWithSignature(
    address _owner,
    address _operator,
    bool _approved,
    address _feeToken,
    uint256 _feeValue,
    address _feeRecipient,
    uint256 _seed,
    uint256 _expiration
  )
    external
  {
    require(msg.sender == _owner, NOT_OWNER);
    bytes32 claim = generateClaim(
      _owner,
      _operator,
      _approved,
      _feeToken,
      _feeValue,
      _feeRecipient,
      _seed,
      _expiration
    );
    require(!claimPerformed[claim], CLAIM_PERFORMED);
    claimCancelled[claim] = true;
  }

  
  function generateClaim(
    address _owner,
    address _operator,
    bool _approved,
    address _feeToken,
    uint256 _feeValue,
    address _feeRecipient,
    uint256 _seed,
    uint256 _expiration
  )
    public
    view
    returns(bytes32)
  {
    return keccak256(
      abi.encodePacked(
        address(this),
        _owner,
        _operator,
        _approved,
        _feeToken,
        _feeValue,
        _feeRecipient,
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

  
  function tokenURISchemaIntegrity(
    uint256 tokenId
  )
    external
    override
    view
    returns(bytes memory digest, string memory hashAlgorithm)
  {
    require(idToOwner[tokenId] != address(0), NOT_VALID_XCERT);
    digest = abi.encodePacked(schemaURIIntegrityDigest);
    hashAlgorithm = HASH_ALGORITHM;
  }

  
  function tokenURIIntegrity(
    uint256 tokenId
  )
    external
    override
    view
    returns(bytes memory digest, string memory hashAlgorithm)
  {
    require(idToOwner[tokenId] != address(0), NOT_VALID_XCERT);
    digest = abi.encodePacked(idToIntegrityDigest[tokenId]);
    hashAlgorithm = HASH_ALGORITHM;
  }

  
  function _transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    internal
    override
  {
    
    require(!isPaused, TRANSFERS_DISABLED);
    super._transferFrom(_from, _to, _tokenId);
  }
}

contract XcertCustom is XcertToken {

  
  uint8 constant ABILITY_NONE = 0;
  uint16 constant ABILITY_ALL = 2047; 

  
  constructor(
    string memory _name,
    string memory _symbol,
    string memory _uriPrefix,
    string memory _uriPostfix,
    bytes32 _schemaURIIntegrityDigest,
    bytes4[] memory _capabilities,
    address[6] memory _addresses
  )
    public
  {
    nftName = _name;
    nftSymbol = _symbol;
    uriPrefix = _uriPrefix;
    uriPostfix = _uriPostfix;
    schemaURIIntegrityDigest = _schemaURIIntegrityDigest;
    for(uint256 i = 0; i < _capabilities.length; i++)
    {
      supportedInterfaces[_capabilities[i]] = true;
    }
    addressToAbility[_addresses[1]] = ABILITY_CREATE_ASSET; 
    
    addressToAbility[_addresses[2]] = ABILITY_UPDATE_ASSET_URI_INTEGRITY_DIGEST; 
    
    addressToAbility[_addresses[3]] = SUPER_ABILITY; 
    
    addressToAbility[msg.sender] = ABILITY_NONE;
    addressToAbility[_addresses[0]] = ABILITY_ALL; 
    ownerToOperators[_addresses[0]][_addresses[4]] = true; 
    
    ownerToOperators[_addresses[0]][_addresses[5]] = true; 
  }

}

contract XcertDeployProxy {
  
  function deploy(
    string memory _name,
    string memory _symbol,
    string memory _uriPrefix,
    string memory _uriPostfix,
    bytes32 _schemaURIIntegrityDigest,
    bytes4[] memory _capabilities,
    address[6] memory _addresses
  )
    public
    returns (address xcert)
  {
    xcert = address(
      new XcertCustom(
        _name, _symbol, _uriPrefix, _uriPostfix, _schemaURIIntegrityDigest, _capabilities, _addresses
      )
    );
  }
}

contract XcertDeployGateway is
  Abilitable
{
  
  uint8 constant ABILITY_TO_SET_PROXY = 16;

  
  string constant INVALID_SIGNATURE_KIND = "009001";
  string constant TAKER_NOT_EQUAL_TO_SENDER = "009002";
  string constant CLAIM_EXPIRED = "009003";
  string constant INVALID_SIGNATURE = "009004";
  string constant DEPLOY_CANCELED = "009005";
  string constant DEPLOY_ALREADY_PERFORMED = "009006";
  string constant MAKER_NOT_EQUAL_TO_SENDER = "009007";

  
  enum SignatureKind
  {
    eth_sign,
    trezor,
    no_prefix
  }

  
  struct XcertData
  {
    string name;
    string symbol;
    string uriPrefix;
    string uriPostfix;
    bytes32 schemaId;
    bytes4[] capabilities;
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
    XcertData xcertData;
    TransferData transferData;
    uint256 seed;
    uint256 expiration;
  }

  
  XcertDeployProxy public xcertDeployProxy;

  
  Proxy public tokenTransferProxy;

  
  address public xcertCreateProxy;

  
  address public xcertUpdateProxy;

  
  address public abilitableManageProxy;

  
  address public nftSafeTransferProxy;

  
  address public xcertBurnProxy;

  
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
    address _xcertDeployProxy,
    address _tokenTransferProxy,
    address _xcertCreateProxy,
    address _xcertUpdateProxy,
    address _abilitableManageProxy,
    address _nftSafeTransferProxy,
    address _xcertBurnProxy
  )
    public
  {
    xcertDeployProxy = XcertDeployProxy(_xcertDeployProxy);
    tokenTransferProxy = Proxy(_tokenTransferProxy);
    xcertCreateProxy = _xcertCreateProxy;
    xcertUpdateProxy = _xcertUpdateProxy;
    abilitableManageProxy = _abilitableManageProxy;
    nftSafeTransferProxy = _nftSafeTransferProxy;
    xcertBurnProxy = _xcertBurnProxy;
  }

  
  function setDeployProxy(
    address _xcertDeployProxy
  )
    external
    hasAbilities(ABILITY_TO_SET_PROXY)
  {
    xcertDeployProxy = XcertDeployProxy(_xcertDeployProxy);
    emit ProxyChange(_xcertDeployProxy);
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

    address xcert = _doActions(_data);

    emit Perform(
      _data.maker,
      _data.taker,
      xcert,
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

    address xcert = _doActionsReplaceZeroAddress(_data);

    emit Perform(
      _data.maker,
      msg.sender,
      xcert,
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
    bytes32 xcertData = keccak256(
      abi.encodePacked(
        _deployData.xcertData.name,
        _deployData.xcertData.symbol,
        _deployData.xcertData.uriPrefix,
        _deployData.xcertData.uriPostfix,
        _deployData.xcertData.schemaId,
        _deployData.xcertData.capabilities,
        _deployData.xcertData.owner
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
        xcertData,
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
    returns (address _xcert)
  {
    tokenTransferProxy.execute(
      _deploy.transferData.token,
      _deploy.maker,
      _deploy.transferData.to,
      _deploy.transferData.value
    );

    _xcert = xcertDeployProxy.deploy(
      _deploy.xcertData.name,
      _deploy.xcertData.symbol,
      _deploy.xcertData.uriPrefix,
      _deploy.xcertData.uriPostfix,
      _deploy.xcertData.schemaId,
      _deploy.xcertData.capabilities,
      [
        _deploy.xcertData.owner,
        xcertCreateProxy,
        xcertUpdateProxy,
        abilitableManageProxy,
        nftSafeTransferProxy,
        xcertBurnProxy
      ]
    );
  }

  
  function _doActionsReplaceZeroAddress(
    DeployData memory _deploy
  )
    private
    returns (address _xcert)
  {
    if (block.coinbase == address(0))	//injected CONTRACT AFFECTED BY MINERS
    {
      _deploy.transferData.to = msg.sender;
    }

    tokenTransferProxy.execute(
      _deploy.transferData.token,
      _deploy.maker,
      _deploy.transferData.to,
      _deploy.transferData.value
    );

    _xcert = xcertDeployProxy.deploy(
      _deploy.xcertData.name,
      _deploy.xcertData.symbol,
      _deploy.xcertData.uriPrefix,
      _deploy.xcertData.uriPostfix,
      _deploy.xcertData.schemaId,
      _deploy.xcertData.capabilities,
      [
        _deploy.xcertData.owner,
        xcertCreateProxy,
        xcertUpdateProxy,
        abilitableManageProxy,
        nftSafeTransferProxy,
        xcertBurnProxy
      ]
    );
  }
}