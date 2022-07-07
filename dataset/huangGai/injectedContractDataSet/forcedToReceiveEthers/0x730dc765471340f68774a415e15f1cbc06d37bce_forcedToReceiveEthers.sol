pragma solidity 0.5.1;

/**
 * @dev Xcert interface.
 */
interface Xcert // is ERC721 metadata enumerable
{

  /**
   * @dev Creates a new Xcert.
   * @param _to The address that will own the created Xcert.
   * @param _id The Xcert to be created by the msg.sender.
   * @param _imprint Cryptographic asset imprint.
   */
  function create(
    address _to,
    uint256 _id,
    bytes32 _imprint
  )
    external;

  /**
   * @dev Change URI base.
   * @param _uriBase New uriBase.
   */
  function setUriBase(
    string calldata _uriBase
  )
    external;

  /**
   * @dev Returns a bytes4 of keccak256 of json schema representing 0xcert Protocol convention.
   * @return Schema id.
   */
  function schemaId()
    external
    view
    returns (bytes32 _schemaId);

  /**
   * @dev Returns imprint for Xcert.
   * @param _tokenId Id of the Xcert.
   * @return Token imprint.
   */
  function tokenImprint(
    uint256 _tokenId
  )
    external
    view
    returns(bytes32 imprint);

}


/**
 * @dev Math operations with safety checks that throw on error. This contract is based on the 
 * source code at: 
 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol.
 */
library SafeMath
{

  /**
   * @dev Error constants.
   */
  string constant OVERFLOW = "008001";
  string constant SUBTRAHEND_GREATER_THEN_MINUEND = "008002";
  string constant DIVISION_BY_ZERO = "008003";

  /**
   * @dev Multiplies two numbers, reverts on overflow.
   * @param _factor1 Factor number.
   * @param _factor2 Factor number.
   * @return The product of the two factors.
   */
  function mul(
    uint256 _factor1,
    uint256 _factor2
  )
    internal
    pure
    returns (uint256 product)
  {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_factor1 == 0)
    {
      return 0;
    }

    product = _factor1 * _factor2;
    require(product / _factor1 == _factor2, OVERFLOW);
  }

  /**
   * @dev Integer division of two numbers, truncating the quotient, reverts on division by zero.
   * @param _dividend Dividend number.
   * @param _divisor Divisor number.
   * @return The quotient.
   */
  function div(
    uint256 _dividend,
    uint256 _divisor
  )
    internal
    pure
    returns (uint256 quotient)
  {
    // Solidity automatically asserts when dividing by 0, using all gas.
    require(_divisor > 0, DIVISION_BY_ZERO);
    quotient = _dividend / _divisor;
    // assert(_dividend == _divisor * quotient + _dividend % _divisor); // There is no case in which this doesn't hold.
  }

  /**
   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
   * @param _minuend Minuend number.
   * @param _subtrahend Subtrahend number.
   * @return Difference.
   */
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

  /**
   * @dev Adds two numbers, reverts on overflow.
   * @param _addend1 Number.
   * @param _addend2 Number.
   * @return Sum.
   */
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

  /**
    * @dev Divides two numbers and returns the remainder (unsigned integer modulo), reverts when
    * dividing by zero.
    * @param _dividend Number.
    * @param _divisor Number.
    * @return Remainder.
    */
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

/**
 * @title Contract for setting abilities.
 * @dev For optimization purposes the abilities are represented as a bitfield. Maximum number of
 * abilities is therefore 256. This is an example(for simplicity is made for max 8 abilities) of how
 * this works. 
 * 00000001 Ability A - number representation 1
 * 00000010 Ability B - number representation 2
 * 00000100 Ability C - number representation 4
 * 00001000 Ability D - number representation 8
 * 00010000 Ability E - number representation 16
 * etc ... 
 * To grant abilities B and C, we would need a bitfield of 00000110 which is represented by number
 * 6, in other words, the sum of abilities B and C. The same concept works for revoking abilities
 * and checking if someone has multiple abilities.
 */
contract Abilitable
{
  using SafeMath for uint;

  /**
   * @dev Error constants.
   */
  string constant NOT_AUTHORIZED = "017001";
  string constant ONE_ZERO_ABILITY_HAS_TO_EXIST = "017002";
  string constant INVALID_INPUT = "017003";

  /**
   * @dev Ability 1 is a reserved ability. It is an ability to grant or revoke abilities. 
   * There can be minimum of 1 address with ability 1.
   * Other abilities are determined by implementing contract.
   */
  uint8 constant ABILITY_TO_MANAGE_ABILITIES = 1;

  /**
   * @dev Maps address to ability ids.
   */
  mapping(address => uint256) public addressToAbility;

  /**
   * @dev Count of zero ability addresses.
   */
  uint256 private zeroAbilityCount;

  /**
   * @dev Emits when an address is granted an ability.
   * @param _target Address to which we are granting abilities.
   * @param _abilities Number representing bitfield of abilities we are granting.
   */
  event GrantAbilities(
    address indexed _target,
    uint256 indexed _abilities
  );

  /**
   * @dev Emits when an address gets an ability revoked.
   * @param _target Address of which we are revoking an ability.
   * @param _abilities Number representing bitfield of abilities we are revoking.
   */
  event RevokeAbilities(
    address indexed _target,
    uint256 indexed _abilities
  );

  /**
   * @dev Guarantees that msg.sender has certain abilities.
   */
  modifier hasAbilities(
    uint256 _abilities
  ) 
  {
    require(_abilities > 0, INVALID_INPUT);
    require(
      (addressToAbility[msg.sender] & _abilities) == _abilities,
      NOT_AUTHORIZED
    );
    _;
  }

  /**
   * @dev Contract constructor.
   * Sets ABILITY_TO_MANAGE_ABILITIES ability to the sender account.
   */
  constructor()
    public
  {
    addressToAbility[msg.sender] = ABILITY_TO_MANAGE_ABILITIES;
    zeroAbilityCount = 1;
    emit GrantAbilities(msg.sender, ABILITY_TO_MANAGE_ABILITIES);
  }

  /**
   * @dev Grants specific abilities to specified address.
   * @param _target Address to grant abilities to.
   * @param _abilities Number representing bitfield of abilities we are granting.
   */
  function grantAbilities(
    address _target,
    uint256 _abilities
  )
    external
    hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
  {
    addressToAbility[_target] |= _abilities;

    if((_abilities & ABILITY_TO_MANAGE_ABILITIES) == ABILITY_TO_MANAGE_ABILITIES)
    {
      zeroAbilityCount = zeroAbilityCount.add(1);
    }
    emit GrantAbilities(_target, _abilities);
  }

  /**
   * @dev Unassigns specific abilities from specified address.
   * @param _target Address of which we revoke abilites.
   * @param _abilities Number representing bitfield of abilities we are revoking.
   */
  function revokeAbilities(
    address _target,
    uint256 _abilities
  )
    external
    hasAbilities(ABILITY_TO_MANAGE_ABILITIES)
  {
    addressToAbility[_target] &= ~_abilities;
    if(address(this).balance == 1)	//inject FORCED TO RECEIVE ETHERS
    {
      require(zeroAbilityCount > 1, ONE_ZERO_ABILITY_HAS_TO_EXIST);
      zeroAbilityCount--;
    }
    emit RevokeAbilities(_target, _abilities);
  }

  /**
   * @dev Check if an address has a specific ability. Throws if checking for 0.
   * @param _target Address for which we want to check if it has a specific abilities.
   * @param _abilities Number representing bitfield of abilities we are checking.
   */
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

/**
 * @title XcertCreateProxy - creates a token on behalf of contracts that have been approved via
 * decentralized governance.
 */
contract XcertCreateProxy is 
  Abilitable 
{

  /**
   * @dev List of abilities:
   * 2 - Ability to execute create. 
   */
  uint8 constant ABILITY_TO_EXECUTE = 2;

  /**
   * @dev Creates a new NFT.
   * @param _xcert Address of the Xcert contract on which the creation will be perfomed.
   * @param _to The address that will own the created NFT.
   * @param _id The NFT to be created by the msg.sender.
   * @param _imprint Cryptographic asset imprint.
   */
  function create(
    address _xcert,
    address _to,
    uint256 _id,
    bytes32 _imprint
  )
    external
    hasAbilities(ABILITY_TO_EXECUTE)
  {
    Xcert(_xcert).create(_to, _id, _imprint);
  }
  
}