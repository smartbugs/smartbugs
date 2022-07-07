/**
 *Submitted for verification at Etherscan.io on 2020-07-01
*/

pragma solidity 0.6.6;

/**
 * @title The Owned contract
 * @notice A contract with helpers for basic contract ownership.
 */
contract Owned {

  address payable internal owner;
  address private pendingOwner;

  event OwnershipTransferRequested(
    address indexed from,
    address indexed to
  );
  event OwnershipTransferred(
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
    pendingOwner = _to;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    emit OwnershipTransferRequested(owner, _to);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  /**
   * @dev Allows an ownership transfer to be completed by the recipient.
   */
  function acceptOwnership()
    external
  {
    require(msg.sender == pendingOwner, "Must be proposed owner");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    address oldOwner = owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    owner = msg.sender;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    pendingOwner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    emit OwnershipTransferred(oldOwner, msg.sender);
  }

  /**
   * @dev Reverts if called by anyone other than the contract owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner, "Only callable by owner");
    _;
  }

}


interface AccessControllerInterface {
  function hasAccess(address user, bytes calldata data) external view returns (bool);
}










/**
 * @title SimpleWriteAccessController
 * @notice Gives access to accounts explicitly added to an access list by the
 * controller's owner.
 * @dev does not make any special permissions for externally, see
 * SimpleReadAccessController for that.
 */
contract SimpleWriteAccessController is AccessControllerInterface, Owned {

  bool internal checkEnabled;
  mapping(address => bool) internal accessList;

  event AddedAccess(address user);
  event RemovedAccess(address user);
  event CheckAccessEnabled();
  event CheckAccessDisabled();

  constructor()
    public
  {
    checkEnabled = true;
  }

  /**
   * @notice Returns the access of an address
   * @param _user The address to query
   */
  function hasAccess(
    address _user,
    bytes memory
  )
    public
    view
    virtual
    override
    returns (bool)
  {
    return accessList[_user] || !checkEnabled;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  /**
   * @notice Adds an address to the access list
   * @param _user The address to add
   */
  function addAccess(address _user)
    external
    onlyOwner()
  {
    if (!accessList[_user]) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      accessList[_user] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

      emit AddedAccess(_user);
    }
  }

  /**
   * @notice Removes an address from the access list
   * @param _user The address to remove
   */
  function removeAccess(address _user)
    external
    onlyOwner()
  {
    if (accessList[_user]) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      accessList[_user] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

      emit RemovedAccess(_user);
    }
  }

  /**
   * @notice makes the access check enforced
   */
  function enableAccessCheck()
    external
    onlyOwner()
  {
    if (!checkEnabled) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      checkEnabled = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

      emit CheckAccessEnabled();
    }
  }

  /**
   * @notice makes the access check unenforced
   */
  function disableAccessCheck()
    external
    onlyOwner()
  {
    if (checkEnabled) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      checkEnabled = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

      emit CheckAccessDisabled();
    }
  }

  /**
   * @dev reverts if the caller does not have access
   */
  modifier checkAccess() {
    require(hasAccess(msg.sender, msg.data), "No access");
    _;
  }
}


/**
 * @title SimpleReadAccessController
 * @notice Gives access to:
 * - any externally owned account (note that offchain actors can always read
 * any contract storage regardless of onchain access control measures, so this
 * does not weaken the access control while improving usability)
 * - accounts explicitly added to an access list
 * @dev SimpleReadAccessController is not suitable for access controlling writes
 * since it grants any externally owned account access! See
 * SimpleWriteAccessController for that.
 */
contract SimpleReadAccessController is SimpleWriteAccessController {

  /**
   * @notice Returns the access of an address
   * @param _user The address to query
   */
  function hasAccess(
    address _user,
    bytes memory _calldata
  )
    public
    view
    virtual
    override
    returns (bool)
  {
    return super.hasAccess(_user, _calldata) || _user == tx.origin;
  }

}




/**
 * @title The Flags contract
 * @notice Allows flags to signal to any reader on the access control list.
 * The owner can set flags, or designate other addresses to set flags. The
 * owner must turn the flags off, other setters cannot.
 */
contract Flags is SimpleReadAccessController {

  AccessControllerInterface internal raisingAccessController;

  mapping(address => bool) private flags;

  event FlagOn(
    address indexed subject
  );
  event FlagOff(
    address indexed subject
  );
  event RaisingAccessControllerChanged(
    address indexed previous,
    address indexed current
  );

  /**
   * @param racAddress address for the raising access controller.
   */
  constructor(
    address racAddress
  )
    public
  {
    setRaisingAccessController(racAddress);
  }

  /**
   * @notice read the warning flag status of a contract address.
   * @param subject The contract address being checked for a flag.
   * @return A true value indicates that a flag was raised and a
   * false value indicates that no flag was raised.
   */
  function getFlag(address subject)
    external
    view
    checkAccess()
    returns (bool)
  {
    return flags[subject];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  /**
   * @notice read the warning flag status of a contract address.
   * @param subjects An array of addresses being checked for a flag.
   * @return An array of bools where a true value for any flag indicates that
   * a flag was raised and a false value indicates that no flag was raised.
   */
  function getFlags(address[] calldata subjects)
    external
    view
    checkAccess()
    returns (bool[] memory)
  {
    bool[] memory responses = new bool[](subjects.length);
    for (uint256 i = 0; i < subjects.length; i++) {
      responses[i] = flags[subjects[i]];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    return responses;
  }

  /**
   * @notice enable the warning flags for mulitple addresses.
   * Access is controlled by raisingAccessController, except for owner
   * who always has access.
   * @param subjects List of the contract addresses whose flag is being raised
   */
  function raiseFlags(address[] calldata subjects)
    external
  {
    require(allowedToRaiseFlags(), "Not allowed to raise flags");

    for (uint256 i = 0; i < subjects.length; i++) {
      address subject = subjects[i];

      if (!flags[subject]) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        flags[subject] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit FlagOn(subject);
      }
    }
  }

  /**
   * @notice allows owner to disable the warning flags for mulitple addresses.
   * @param subjects List of the contract addresses whose flag is being lowered
   */
  function lowerFlags(address[] calldata subjects)
    external
    onlyOwner()
  {
    for (uint256 i = 0; i < subjects.length; i++) {
      address subject = subjects[i];

      if (flags[subject]) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        flags[subject] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit FlagOff(subject);
      }
    }
  }

  /**
   * @notice allows owner to change the access controller for raising flags.
   * @param racAddress new address for the raising access controller.
   */
  function setRaisingAccessController(
    address racAddress
  )
    public
    onlyOwner()
  {
    address previous = address(raisingAccessController);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    raisingAccessController = AccessControllerInterface(racAddress);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

    emit RaisingAccessControllerChanged(previous, racAddress);
  }


  // PRIVATE

  function allowedToRaiseFlags()
    private
    returns (bool)
  {
    return msg.sender == owner ||
      raisingAccessController.hasAccess(msg.sender, msg.data);
  }

}