/**
 *Submitted for verification at Etherscan.io on 2020-05-05
*/

pragma solidity 0.6.2;

/**
 * @title The Owned contract
 * @notice A contract with helpers for basic contract ownership.
 */
contract Owned {

  address payable public owner;
  address private pendingOwner;

  event OwnershipTransferRequested(
    address indexed from,
    address indexed to
  );
  event OwnershipTransfered(
    address indexed from,
    address indexed to
  );

  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Allows an owner to begin transferring ownership to a new address,
   * pending.
   */
  function transferOwnership(address _to)
    external
    onlyOwner()
  {
    pendingOwner = _to;

    emit OwnershipTransferRequested(owner, _to);
  }

  /**
   * @dev Allows an ownership transfer to be completed by the recipient.
   */
  function acceptOwnership()
    external
  {
    require(msg.sender == pendingOwner, "Must be proposed owner");

    address oldOwner ;	//inject UNINIT LOCAL/STATE VAR

    owner = msg.sender;
    pendingOwner = address(0);

    emit OwnershipTransfered(oldOwner, msg.sender);
  }

  /**
   * @dev Reverts if called by anyone other than the contract owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner, "Only callable by owner");
    _;
  }

}


interface AggregatorInterface {
  function latestAnswer() external view returns (int256);
  function latestTimestamp() external view returns (uint256);
  function latestRound() external view returns (uint256);
  function getAnswer(uint256 roundId) external view returns (int256);
  function getTimestamp(uint256 roundId) external view returns (uint256);
  function decimals() external view returns (uint8);

  event AnswerUpdated(int256 indexed current, uint256 indexed roundId, uint256 timestamp);
  event NewRound(uint256 indexed roundId, address indexed startedBy, uint256 startedAt);
}







/**
 * @title A trusted proxy for updating where current answers are read from
 * @notice This contract provides a consistent address for the
 * CurrentAnwerInterface but delegates where it reads from to the owner, who is
 * trusted to update it.
 */
contract AggregatorProxy is AggregatorInterface, Owned {

  AggregatorInterface public aggregator;

  constructor(address _aggregator) public Owned() {
    setAggregator(_aggregator);
  }

  /**
   * @notice Reads the current answer from aggregator delegated to.
   */
  function latestAnswer()
    external
    view
    virtual
    override
    returns (int256)
  {
    return _latestAnswer();
  }

  /**
   * @notice Reads the last updated height from aggregator delegated to.
   */
  function latestTimestamp()
    external
    view
    virtual
    override
    returns (uint256)
  {
    return _latestTimestamp();
  }

  /**
   * @notice get past rounds answers
   * @param _roundId the answer number to retrieve the answer for
   */
  function getAnswer(uint256 _roundId)
    external
    view
    virtual
    override
    returns (int256)
  {
    return _getAnswer(_roundId);
  }

  /**
   * @notice get block timestamp when an answer was last updated
   * @param _roundId the answer number to retrieve the updated timestamp for
   */
  function getTimestamp(uint256 _roundId)
    external
    view
    virtual
    override
    returns (uint256)
  {
    return _getTimestamp(_roundId);
  }

  /**
   * @notice get the latest completed round where the answer was updated
   */
  function latestRound()
    external
    view
    virtual
    override
    returns (uint256)
  {
    return _latestRound();
  }

  /**
   * @notice represents the number of decimals the aggregator responses represent.
   */
  function decimals()
    external
    view
    override
    returns (uint8)
  {
    return aggregator.decimals();
  }

  /**
   * @notice Allows the owner to update the aggregator address.
   * @param _aggregator The new address for the aggregator contract
   */
  function setAggregator(address _aggregator)
    public
    onlyOwner()
  {
    aggregator = AggregatorInterface(_aggregator);
  }

  /*
   * Internal
   */

  function _latestAnswer()
    internal
    view
    returns (int256)
  {
    return aggregator.latestAnswer();
  }

  function _latestTimestamp()
    internal
    view
    returns (uint256)
  {
    return aggregator.latestTimestamp();
  }

  function _getAnswer(uint256 _roundId)
    internal
    view
    returns (int256)
  {
    return aggregator.getAnswer(_roundId);
  }

  function _getTimestamp(uint256 _roundId)
    internal
    view
    returns (uint256)
  {
    return aggregator.getTimestamp(_roundId);
  }

  function _latestRound()
    internal
    view
    returns (uint256)
  {
    return aggregator.latestRound();
  }
}





/**
 * @title Whitelisted
 * @notice Allows the owner to add and remove addresses from a whitelist
 */
contract Whitelisted is Owned {

  bool public whitelistEnabled;
  mapping(address => bool) public whitelisted;

  event AddedToWhitelist(address user);
  event RemovedFromWhitelist(address user);
  event WhitelistEnabled();
  event WhitelistDisabled();

  constructor()
    public
  {
    whitelistEnabled = true;
  }

  /**
   * @notice Adds an address to the whitelist
   * @param _user The address to whitelist
   */
  function addToWhitelist(address _user) external onlyOwner() {
    whitelisted[_user] = true;
    emit AddedToWhitelist(_user);
  }

  /**
   * @notice Removes an address from the whitelist
   * @param _user The address to remove
   */
  function removeFromWhitelist(address _user) external onlyOwner() {
    delete whitelisted[_user];
    emit RemovedFromWhitelist(_user);
  }

  /**
   * @notice makes the whitelist check enforced
   */
  function enableWhitelist()
    external
    onlyOwner()
  {
    whitelistEnabled = true;

    emit WhitelistEnabled();
  }

  /**
   * @notice makes the whitelist check unenforced
   */
  function disableWhitelist()
    external
    onlyOwner()
  {
    whitelistEnabled = false;

    emit WhitelistDisabled();
  }

  /**
   * @dev reverts if the caller is not whitelisted
   */
  modifier isWhitelisted() {
    require(whitelisted[msg.sender] || !whitelistEnabled, "Not whitelisted");
    _;
  }
}


/**
 * @title A trusted proxy for updating where current answers are read from
 * @notice This contract provides a consistent address for the
 * AggregatorInterface but delegates where it reads from to the owner, who is
 * trusted to update it.
 * @notice Only whitelisted addresses are allowed to access getters for
 * aggregated answers and round information.
 */
contract WhitelistedAggregatorProxy is AggregatorProxy, Whitelisted {

  constructor(address _aggregator) public AggregatorProxy(_aggregator) {
  }

  /**
   * @notice Reads the current answer from aggregator delegated to.
   * @dev overridden function to add the isWhitelisted() modifier
   */
  function latestAnswer()
    external
    view
    override
    isWhitelisted()
    returns (int256)
  {
    return _latestAnswer();
  }

  /**
   * @notice Reads the last updated height from aggregator delegated to.
   * @dev overridden function to add the isWhitelisted() modifier
   */
  function latestTimestamp()
    external
    view
    override
    isWhitelisted()
    returns (uint256)
  {
    return _latestTimestamp();
  }

  /**
   * @notice get past rounds answers
   * @param _roundId the answer number to retrieve the answer for
   * @dev overridden function to add the isWhitelisted() modifier
   */
  function getAnswer(uint256 _roundId)
    external
    view
    override
    isWhitelisted()
    returns (int256)
  {
    return _getAnswer(_roundId);
  }

  /**
   * @notice get block timestamp when an answer was last updated
   * @param _roundId the answer number to retrieve the updated timestamp for
   * @dev overridden function to add the isWhitelisted() modifier
   */
  function getTimestamp(uint256 _roundId)
    external
    view
    override
    isWhitelisted()
    returns (uint256)
  {
    return _getTimestamp(_roundId);
  }

  /**
   * @notice get the latest completed round where the answer was updated
   * @dev overridden function to add the isWhitelisted() modifier
   */
  function latestRound()
    external
    view
    override
    isWhitelisted()
    returns (uint256)
  {
    return _latestRound();
  }
}