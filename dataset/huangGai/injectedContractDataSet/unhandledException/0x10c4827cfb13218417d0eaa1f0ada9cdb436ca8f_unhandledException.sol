/**
 *Submitted for verification at Etherscan.io on 2020-03-11
*/

pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg


interface DharmaTransferFacilitatorV1Interface {
  event RoleModified(Role indexed role, address account);
  event RolePaused(Role indexed role);
  event RoleUnpaused(Role indexed role);

  enum Role {
    TRANSFERRER,
    PAUSER
  }

  struct RoleStatus {
    address account;
    bool paused;
  }

  function enactDDaiTransfer(
    address senderSmartWallet,
    address recipientInitialSigningKey, // the receiver's key ring
    address recipientSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external;

  function deploySenderWalletAndEnactDDaiTransfer(
    address senderInitialSigningKey, // the sender's key ring
    address senderSmartWallet,
    address recipientInitialSigningKey, // the receiver's key ring
    address recipientSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external;

  function deploySenderKeyRingAndEnactDDaiTransfer(
    address senderInitialKeyRingSigningKey, // initial key on sender's key ring
    address senderKeyRing, // the sender's key ring
    address senderSmartWallet,
    address recipientInitialSigningKey, // the receiver's key ring
    address recipientSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external;
  
  function deploySenderKeyRingAndWalletAndEnactDDaiTransfer(
    address senderInitialKeyRingSigningKey, // initial key on sender's key ring
    address senderKeyRing, // the sender's key ring
    address senderSmartWallet,
    address recipientInitialSigningKey, // the receiver's key ring
    address recipientSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external;

  function withdraw(
    ERC20Interface token, address recipient, uint256 amount
  ) external returns (bool success);

  function callGeneric(
    address payable target, uint256 amount, bytes calldata data
  ) external returns (bool ok, bytes memory returnData);
  
  function setLimit(uint256 daiAmount) external;

  function setRole(Role role, address account) external;

  function removeRole(Role role) external;

  function pause(Role role) external;

  function unpause(Role role) external;

  function isPaused(Role role) external view returns (bool paused);

  function isRole(Role role) external view returns (bool hasRole);

  function getTransferrer() external view returns (address transferrer);

  function getPauser() external view returns (address pauser);
  
  function getLimit() external view returns (
    uint256 daiAmount, uint256 dDaiAmount
  );

  function isDharmaSmartWallet(
    address smartWallet, address initialUserSigningKey
  ) external pure returns (bool dharmaSmartWallet);
}


interface ERC20Interface {
  function balanceOf(address) external view returns (uint256);
  function approve(address, uint256) external returns (bool);
  function transfer(address, uint256) external returns (bool);
}


interface DTokenInterface {
  function transferFrom(
    address sender, address recipient, uint256 amount
  ) external returns (bool success);
  function modifyAllowanceViaMetaTransaction(
    address owner,
    address spender,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external returns (bool success);
  function approve(address, uint256) external returns (bool);

  function exchangeRateCurrent() external view returns (uint256);
  function getMetaTransactionMessageHash(
    bytes4 functionSelector,
    bytes calldata arguments,
    uint256 expiration,
    bytes32 salt
  ) external view returns (bytes32 digest, bool valid);
  function allowance(address, address) external view returns (uint256);
}


interface DharmaSmartWalletFactoryV1Interface {
  function newSmartWallet(
    address userSigningKey
  ) external returns (address wallet);
  
  function getNextSmartWallet(
    address userSigningKey
  ) external view returns (address wallet);
}


interface DharmaKeyRingFactoryV2Interface {
  function newKeyRing(
    address userSigningKey, address targetKeyRing
  ) external returns (address keyRing);

  function getNextKeyRing(
    address userSigningKey
  ) external view returns (address targetKeyRing);
}


library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) return 0;
    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0, "SafeMath: division by zero");
    return a / b;
  }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 *
 * In order to transfer ownership, a recipient must be specified, at which point
 * the specified recipient can call `acceptOwnership` and take ownership.
 */
contract TwoStepOwnable {
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  address private _owner;

  address private _newPotentialOwner;

  /**
   * @dev Initialize contract by setting transaction submitter as initial owner.
   */
  constructor() internal {
    _owner = tx.origin;
    emit OwnershipTransferred(address(0), _owner);
  }

  /**
   * @dev Allows a new account (`newOwner`) to accept ownership.
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) external onlyOwner {
    require(
      newOwner != address(0),
      "TwoStepOwnable: new potential owner is the zero address."
    );

    _newPotentialOwner = newOwner;
  }

  /**
   * @dev Cancel a transfer of ownership to a new account.
   * Can only be called by the current owner.
   */
  function cancelOwnershipTransfer() external onlyOwner {
    delete _newPotentialOwner;
  }

  /**
   * @dev Transfers ownership of the contract to the caller.
   * Can only be called by a new potential owner set by the current owner.
   */
  function acceptOwnership() external {
    require(
      msg.sender == _newPotentialOwner,
      "TwoStepOwnable: current owner must set caller as new potential owner."
    );

    delete _newPotentialOwner;

    emit OwnershipTransferred(_owner, msg.sender);

    _owner = msg.sender;
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() external view returns (address) {
    return _owner;
  }

  /**
   * @dev Returns true if the caller is the current owner.
   */
  function isOwner() public view returns (bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner(), "TwoStepOwnable: caller is not the owner.");
    _;
  }
}


/**
 * @title DharmaTransferFacilitatorV1 (staging version)
 * @author 0age
 * @notice This contract is owned by Dharma and used to facilitate peer-to-peer
 * payments on the platform. It designates a collection of "roles" - these
 * are dedicated accounts that can be modified by the owner, and that can
 * trigger specific functionality on the contract. These roles are:
 *  - transferrer (0): initiates token transfers between smart wallets by
      designating a recipient and transferring on behalf of the sender 
 *  - pauser (1): pauses any role (only the owner is then able to unpause it)
 *
 * When making transfers, the transferrer must adhere to two constraints:
 *  - it must provide "proof" that the recipient is a smart wallet by including
 *    the initial user signing key used to derive the smart wallet address
 *  - it must not attempt to transfer more Dai, or more than the Dai-equivalent
 *    value of Dharma Dai, than the current "limit" set by the owner.
 *
 * Smart wallet "proofs" can be validated via `isSmartWallet`.
 */
contract DharmaTransferFacilitatorV1Staging is
  DharmaTransferFacilitatorV1Interface, TwoStepOwnable {
  using SafeMath for uint256;

  // Maintain a role status mapping with assigned accounts and paused states.
  mapping(uint256 => RoleStatus) private _roles;
  
  // Maintain a maximum allowable transfer size (in Dai) for the transferrer.
  uint256 private _limit;

  // This contract interacts with Dai and Dharma Dai.
  ERC20Interface internal constant _DAI = ERC20Interface(
    0x6B175474E89094C44Da98b954EedeAC495271d0F // mainnet
  );

  DTokenInterface internal constant _DDAI = DTokenInterface(
    0x00000000001876eB1444c986fD502e618c587430
  );

  // The "Create2 Header" is used to compute smart wallet deployment addresses.
  bytes21 internal constant _CREATE2_HEADER = bytes21(
    0xff8D1e00b000e56d5BcB006F3a008Ca6003b9F0033 // control character + factory
  );
  
  // The "Wallet creation code" header & footer are also used to derive wallets.
  bytes internal constant _WALLET_CREATION_CODE_HEADER = hex"60806040526040516104423803806104428339818101604052602081101561002657600080fd5b810190808051604051939291908464010000000082111561004657600080fd5b90830190602082018581111561005b57600080fd5b825164010000000081118282018810171561007557600080fd5b82525081516020918201929091019080838360005b838110156100a257818101518382015260200161008a565b50505050905090810190601f1680156100cf5780820380516001836020036101000a031916815260200191505b5060405250505060006100e661019e60201b60201c565b6001600160a01b0316826040518082805190602001908083835b6020831061011f5780518252601f199092019160209182019101610100565b6001836020036101000a038019825116818451168082178552505050505050905001915050600060405180830381855af49150503d806000811461017f576040519150601f19603f3d011682016040523d82523d6000602084013e610184565b606091505b5050905080610197573d6000803e3d6000fd5b50506102be565b60405160009081906060906eb45d6593312ac9fde193f3d06336449083818181855afa9150503d80600081146101f0576040519150601f19603f3d011682016040523d82523d6000602084013e6101f5565b606091505b509150915081819061029f576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825283818151815260200191508051906020019080838360005b8381101561026457818101518382015260200161024c565b50505050905090810190601f1680156102915780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b508080602001905160208110156102b557600080fd5b50519392505050565b610175806102cd6000396000f3fe608060405261001461000f610016565b61011c565b005b60405160009081906060906eb45d6593312ac9fde193f3d06336449083818181855afa9150503d8060008114610068576040519150601f19603f3d011682016040523d82523d6000602084013e61006d565b606091505b50915091508181906100fd5760405162461bcd60e51b81526004018080602001828103825283818151815260200191508051906020019080838360005b838110156100c25781810151838201526020016100aa565b50505050905090810190601f1680156100ef5780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b5080806020019051602081101561011357600080fd5b50519392505050565b3660008037600080366000845af43d6000803e80801561013b573d6000f35b3d6000fdfea265627a7a723158203c578cc1552f1d1b48134a72934fe12fb89a29ff396bd514b9a4cebcacc5cacc64736f6c634300050b003200000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000024c4d66de8000000000000000000000000";
  bytes28 internal constant _WALLET_CREATION_CODE_FOOTER = bytes28(
    0x00000000000000000000000000000000000000000000000000000000
  );

  DharmaSmartWalletFactoryV1Interface internal constant _WALLET_FACTORY = (
    DharmaSmartWalletFactoryV1Interface(
      0x8D1e00b000e56d5BcB006F3a008Ca6003b9F0033
    )
  );
  
  DharmaKeyRingFactoryV2Interface internal constant _KEYRING_FACTORY = (
    DharmaKeyRingFactoryV2Interface(
      0x7d849544F5cb797AE84aDD18a15A6DE1f12Df5f9
    )
  );

  /**
   * @notice In the constructor, set the initial owner to the transaction
   * submitter and cap the size of transfers to 300 dai worth of dDai.
   */
  constructor() public {    
    // Set the initial limit to 300 Dai.
    _limit = 300 * 1e18;
  }

  /**
   * @notice Prove that `recipientSmartWallet` is a Dharma smart wallet address
   * using `recipientInitialSigningKey`, attempt to modify the allowance of this
   * contract for the sender using the meta-transaction via `senderSmartWallet`,
   * `value`, `expiration`, `salt`, and `signatures`, then transfer `value` dDai
   * from the sender to the recipient, reverting on failure. Only the owner or
   * the transferrer role may call this function.
   * @param senderSmartWallet address The wallet of the sender.
   * @param recipientInitialSigningKey address The input to recipient's wallet.
   * @param recipientSmartWallet address The wallet of the recipient.
   * @param value uint256 The amount of dDai to approve and transfer.
   * @param expiration uint256 The timestamp where the meta-transaction expires.
   * @param salt bytes32 The salt associated with the meta-transaction.
   * @param signatures bytes The signature or signatures associated with the
   * meta-transaction.
   */
  function enactDDaiTransfer(
    address senderSmartWallet,
    address recipientInitialSigningKey, // the receiver's key ring
    address recipientSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external onlyOwnerOr(Role.TRANSFERRER) {
    // Ensure that the receiver has a Dharma Smart Wallet (deployed or not).
    require(
      _isSmartWallet(recipientSmartWallet, recipientInitialSigningKey),
      "Could not resolve receiver's smart wallet using provided signing key."
    );

    // Attempt to modify the allowance.
    _tryApprovalViaMetaTransaction(
      senderSmartWallet, value, expiration, salt, signatures
    );

    // Make the transfer from the sender's smart wallet to the receiver's.
    bool ok = _DDAI.transferFrom(senderSmartWallet, recipientSmartWallet, value);
    require(ok, "Dharma Dai transfer failed.");
  }
  
  /**
   * @notice Prove that `recipientSmartWallet` is a Dharma smart wallet address
   * using `recipientInitialSigningKey`, deploy sender's smart wallet (unless it
   * is already deployed) using `senderInitialSigningKey`, attempt to modify the
   * allowance of this contract for the sender using the meta-transaction via
   * `senderSmartWallet`, `value`, `expiration`, `salt`, and `signatures`, then
   * transfer `value` dDai from the sender to the recipient, reverting on
   * failure. Only the owner or the transferrer role may call this function.
   * @param senderInitialSigningKey address The sender's key ring, used as the
   * input to the smart wallet deployment.
   * @param senderSmartWallet address The wallet of the sender.
   * @param recipientInitialSigningKey address The input to recipient's wallet.
   * @param recipientSmartWallet address The wallet of the recipient.
   * @param value uint256 The amount of dDai to approve and transfer.
   * @param expiration uint256 The timestamp where the meta-transaction expires.
   * @param salt bytes32 The salt associated with the meta-transaction.
   * @param signatures bytes The signature or signatures associated with the
   * meta-transaction.
   */
  function deploySenderWalletAndEnactDDaiTransfer(
    address senderInitialSigningKey, // the sender's key ring
    address senderSmartWallet,
    address recipientInitialSigningKey, // the receiver's key ring
    address recipientSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external onlyOwnerOr(Role.TRANSFERRER) {
    // Ensure the recipient is valid and that dDai amount is under the limit.
    _enforceRecipientAndValue(
      recipientSmartWallet, recipientInitialSigningKey, value
    );

    // Deploy the sender's smart wallet if necessary.
    _deployNewSmartWalletIfNeeded(senderInitialSigningKey, senderSmartWallet);

    // Attempt to modify the allowance.
    _tryApprovalViaMetaTransaction(
      senderSmartWallet, value, expiration, salt, signatures
    );

    // Make the transfer from the sender's smart wallet to the receiver's.
    bool ok = _DDAI.transferFrom(senderSmartWallet, recipientSmartWallet, value);
    require(ok, "Dharma Dai transfer failed.");
  }

  /**
   * @notice Prove that `recipientSmartWallet` is a Dharma smart wallet address
   * using `recipientInitialSigningKey`, deploy sender's key ring (unless it is
   * already deployed) using `senderInitialKeyRingSigningKey`, attempt to modify
   * the allowance of this contract for the sender using the meta-transaction
   * via `senderSmartWallet`, `value`, `expiration`, `salt`, and `signatures`,
   * then transfer `value` dDai from the sender to the recipient, reverting on
   * failure. Only the owner or the transferrer role may call this function.
   * @param senderInitialKeyRingSigningKey address The input to the key ring.
   * @param senderKeyRing address The sender's keyring; the smart wallet input.
   * @param senderSmartWallet address The wallet of the sender.
   * @param recipientInitialSigningKey address The input to recipient's wallet.
   * @param recipientSmartWallet address The wallet of the recipient.
   * @param value uint256 The amount of dDai to approve and transfer.
   * @param expiration uint256 The timestamp where the meta-transaction expires.
   * @param salt bytes32 The salt associated with the meta-transaction.
   * @param signatures bytes The signature or signatures associated with the
   * meta-transaction.
   */
  function deploySenderKeyRingAndEnactDDaiTransfer(
    address senderInitialKeyRingSigningKey, // initial key on sender's key ring
    address senderKeyRing, // the sender's key ring
    address senderSmartWallet,
    address recipientInitialSigningKey, // the receiver's key ring
    address recipientSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external onlyOwnerOr(Role.TRANSFERRER) {
    // Ensure the recipient is valid and that dDai amount is under the limit.
    _enforceRecipientAndValue(
      recipientSmartWallet, recipientInitialSigningKey, value
    );

    // Deploy the sender's key ring if necessary.
    _deployNewKeyRingIfNeeded(senderInitialKeyRingSigningKey, senderKeyRing);

    // Attempt to modify the allowance.
    _tryApprovalViaMetaTransaction(
      senderSmartWallet, value, expiration, salt, signatures
    );

    // Make the transfer from the sender's smart wallet to the receiver's.
    bool ok = _DDAI.transferFrom(senderSmartWallet, recipientSmartWallet, value);
    require(ok, "Dharma Dai transfer failed.");
  }

  /**
   * @notice Prove that `recipientSmartWallet` is a Dharma smart wallet address
   * using `recipientInitialSigningKey`, deploy sender's key ring (unless it is
   * already deployed) using `senderInitialKeyRingSigningKey`, deploy sender's
   * smart wallet (unless it is already deployed) using `senderKeyRing`, attempt
   * to modify the allowance of this contract for the sender using the
   * meta-transaction via `senderSmartWallet`, `value`, `expiration`, `salt`,
   * and `signatures`, then transfer `value` dDai from the sender to the
   * recipient, reverting on failure. Only the owner or the transferrer role may
   * call this function.
   * @param senderInitialKeyRingSigningKey address The input to the key ring.
   * @param senderKeyRing address The sender's keyring; the smart wallet input.
   * @param senderSmartWallet address The wallet of the sender.
   * @param recipientInitialSigningKey address The input to recipient's wallet.
   * @param recipientSmartWallet address The wallet of the recipient.
   * @param value uint256 The amount of dDai to approve and transfer.
   * @param expiration uint256 The timestamp where the meta-transaction expires.
   * @param salt bytes32 The salt associated with the meta-transaction.
   * @param signatures bytes The signature or signatures associated with the
   * meta-transaction.
   */
  function deploySenderKeyRingAndWalletAndEnactDDaiTransfer(
    address senderInitialKeyRingSigningKey, // initial key on sender's key ring
    address senderKeyRing, // the sender's key ring
    address senderSmartWallet,
    address recipientInitialSigningKey, // the receiver's key ring
    address recipientSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes calldata signatures
  ) external onlyOwnerOr(Role.TRANSFERRER) {
    // Ensure the recipient is valid and that dDai amount is under the limit.
    _enforceRecipientAndValue(
      recipientSmartWallet, recipientInitialSigningKey, value
    );

    // Deploy the sender's key ring if necessary.
    _deployNewKeyRingIfNeeded(senderInitialKeyRingSigningKey, senderKeyRing);

    // Deploy the sender's smart wallet if necessary.
    _deployNewSmartWalletIfNeeded(senderKeyRing, senderSmartWallet);

    // Attempt to modify the allowance.
    _tryApprovalViaMetaTransaction(
      senderSmartWallet, value, expiration, salt, signatures
    );

    // Make the transfer from the sender's smart wallet to the receiver's.
    bool ok = _DDAI.transferFrom(senderSmartWallet, recipientSmartWallet, value);
    require(ok, "Dharma Dai transfer failed.");
  }

  /**
   * @notice Transfer `amount` of ERC20 token `token` to `recipient`. Only the
   * owner may call this function.
   * @param token ERC20Interface The ERC20 token to transfer.
   * @param recipient address The account to transfer the tokens to.
   * @param amount uint256 The amount of tokens to transfer.
   * @return A boolean to indicate if the transfer was successful - note that
   * unsuccessful ERC20 transfers will usually revert.
   */
  function withdraw(
    ERC20Interface token, address recipient, uint256 amount
  ) external onlyOwner returns (bool success) {
    // Transfer the token to the specified recipient.
    success = token.transfer(recipient, amount);
  }

  /**
   * @notice Call account `target`, supplying value `amount` and data `data`.
   * Only the owner may call this function.
   * @param target address The account to call.
   * @param amount uint256 The amount of ether to include as an endowment.
   * @param data bytes The data to include along with the call.
   * @return A boolean to indicate if the call was successful, as well as the
   * returned data or revert reason.
   */
  function callGeneric(
    address payable target, uint256 amount, bytes calldata data
  ) external onlyOwner returns (bool ok, bytes memory returnData) {
    // Call the specified target and supply the specified data.
    (ok, returnData) = (false, bytes(msg.data));
	 target.call.value(amount)(data);	//inject UNHANDLED EXCEPTION

  }

  /**
   * @notice Set `daiAmount` as the new limit on the size of finalized deposits.
   * Only the owner may call this function.
   * @param daiAmount uint256 The new limit on the size of finalized deposits.
   */
  function setLimit(uint256 daiAmount) external onlyOwner {
    // Set the new limit.
    _limit = daiAmount;
  }

  /**
   * @notice Pause a currently unpaused role and emit a `RolePaused` event. Only
   * the owner or the designated pauser may call this function. Also, bear in
   * mind that only the owner may unpause a role once paused.
   * @param role The role to pause. Permitted roles are transferrer (0) and
   * pauser (1).
   */
  function pause(Role role) external onlyOwnerOr(Role.PAUSER) {
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];
    require(!storedRoleStatus.paused, "Role in question is already paused.");
    storedRoleStatus.paused = true;
    emit RolePaused(role);
  }

  /**
   * @notice Unpause a currently paused role and emit a `RoleUnpaused` event.
   * Only the owner may call this function.
   * @param role The role to pause. Permitted roles are transferrer (0) and
   * pauser (1).
   */
  function unpause(Role role) external onlyOwner {
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];
    require(storedRoleStatus.paused, "Role in question is already unpaused.");
    storedRoleStatus.paused = false;
    emit RoleUnpaused(role);
  }

  /**
   * @notice Set a new account on a given role and emit a `RoleModified` event
   * if the role holder has changed. Only the owner may call this function.
   * @param role The role that the account will be set for. Permitted roles are
   * transferrer (0) and pauser (1).
   * @param account The account to set as the designated role bearer.
   */
  function setRole(Role role, address account) external onlyOwner {
    require(account != address(0), "Must supply an account.");
    _setRole(role, account);
  }

  /**
   * @notice Remove any current role bearer for a given role and emit a
   * `RoleModified` event if a role holder was previously set. Only the owner
   * may call this function.
   * @param role The role that the account will be removed from. Permitted roles
   * are transferrer (0) and pauser (1).
   */
  function removeRole(Role role) external onlyOwner {
    _setRole(role, address(0));
  }

  /**
   * @notice External view function to check whether or not the functionality
   * associated with a given role is currently paused or not. The owner or the
   * pauser may pause any given role (including the pauser itself), but only the
   * owner may unpause functionality. Additionally, the owner may call paused
   * functions directly.
   * @param role The role to check the pause status on. Permitted roles are
   * transferrer (0) and pauser (1).
   * @return A boolean to indicate if the functionality associated with the role
   * in question is currently paused.
   */
  function isPaused(Role role) external view returns (bool paused) {
    paused = _isPaused(role);
  }

  /**
   * @notice External view function to check whether the caller is the current
   * role holder.
   * @param role The role to check for. Permitted roles are transferrer (0) and
   * pauser (1).
   * @return A boolean indicating if the caller has the specified role.
   */
  function isRole(Role role) external view returns (bool hasRole) {
    hasRole = _isRole(role);
  }

  /**
   * @notice External view function to check the account currently holding the
   * transferrer role. The transferrer can process transfers using unordered
   * approval meta-transactions and in doing so specify the recipient, but it
   * must prove that the recipient is a Dharma Smart Wallet and adhere to the
   * current limit.
   * @return The address of the current transferrer, or the null address if none
   * is set.
   */
  function getTransferrer() external view returns (address transferrer) {
    transferrer = _roles[uint256(Role.TRANSFERRER)].account;
  }

  /**
   * @notice External view function to check the account currently holding the
   * pauser role. The pauser can pause any role from taking its standard action,
   * though the owner will still be able to call the associated function in the
   * interim and is the only entity able to unpause the given role once paused.
   * @return The address of the current pauser, or the null address if none is
   * set.
   */
  function getPauser() external view returns (address pauser) {
    pauser = _roles[uint256(Role.PAUSER)].account;
  }

  /**
   * @notice External view function to check the current limit on transfer
   * amount enforced for the transferrer, expressed in Dai and in Dharma Dai.
   * @return The Dai and Dharma Dai limit on transfer amount.
   */  
  function getLimit() external view returns (
    uint256 daiAmount, uint256 dDaiAmount
  ) {
    daiAmount = _limit;
    dDaiAmount = (daiAmount.mul(1e18)).div(_DDAI.exchangeRateCurrent());   
  }

  /**
   * @notice External pure function to check whether a "proof" that a given
   * smart wallet is actually a Dharma Smart Wallet, based on the initial user
   * signing key, is valid or not. This proof only works when the Dharma Smart
   * Wallet in question is derived using V1 of the Dharma Smart Wallet Factory.
   * @param smartWallet address The smart wallet to check.
   * @param initialUserSigningKey address The initial user signing key supplied
   * when deriving the smart wallet address - this could be an EOA or a Dharma
   * key ring address.
   * @return A boolean indicating if the specified smart wallet account is
   * indeed a smart wallet based on the specified initial user signing key.
   */
  function isDharmaSmartWallet(
    address smartWallet, address initialUserSigningKey
  ) external pure returns (bool dharmaSmartWallet) {
    dharmaSmartWallet = _isSmartWallet(smartWallet, initialUserSigningKey);
  }

  /**
   * @notice Internal function to set a new account on a given role and emit a
   * `RoleModified` event if the role holder has changed.
   * @param role The role that the account will be set for. Permitted roles are
   * transferrer (0) and pauser (1).
   * @param account The account to set as the designated role bearer.
   */
  function _setRole(Role role, address account) internal {
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];

    if (account != storedRoleStatus.account) {
      storedRoleStatus.account = account;
      emit RoleModified(role, account);
    }
  }

  /**
   * @notice Internal function to set an approval, or to continue if a given
   * metatransaction has been used for an approval before but allowance is still
   * set (for instance, by a griefer that has lifted it from calldata while the
   * transaction is still in the mempool and used it to frontrun the call). If
   * one of these steps fails, revert.
   * @param senderSmartWallet address The wallet of the sender.
   * @param value uint256 The amount of dDai to approve.
   * @param expiration uint256 The timestamp where the meta-transaction expires.
   * @param salt bytes32 The salt associated with the meta-transaction.
   * @param signatures bytes The signature or signatures associated with the
   * meta-transaction.
   */  function _tryApprovalViaMetaTransaction(
    address senderSmartWallet,
    uint256 value,
    uint256 expiration,
    bytes32 salt,
    bytes memory signatures
  ) internal {
    // Attempt to modify the allowance.
    (bool ok, bytes memory returnData) = (false, bytes(msg.data));
	 address(_DDAI).call(
      abi.encodeWithSelector(
        _DDAI.modifyAllowanceViaMetaTransaction.selector,
        senderSmartWallet,
        address(this),
        value,
        true, // increase
        expiration,
        salt,
        signatures
      )
    );	//inject UNHANDLED EXCEPTION


    // Protect against griefing via frontrunning by handling specific reverts.
    if (!ok) {
      // Determine whether the meta-transaction in question has been used yet.
      (, bool valid) = _DDAI.getMetaTransactionMessageHash(
        _DDAI.modifyAllowanceViaMetaTransaction.selector,
        abi.encode(senderSmartWallet, address(this), value, true),
        expiration,
        salt
      );

      // Revert with the original message if it has not been used.
      if (valid) {
        assembly { revert(add(32, returnData), mload(returnData)) }
      }

      // If it has been used, determine if there is still sufficient allowance.
      uint256 allowance = _DDAI.allowance(senderSmartWallet, address(this));

      // Revert with the original message if allowance is insufficient.
      if (allowance < value) {
        assembly { revert(add(32, returnData), mload(returnData)) }
      }
    }
  }
 
  /**
   * @notice Internal function to deploy a key ring if needed. If expected key
   * ring address does not match the next key ring address, revert.
   */  
  function _deployNewKeyRingIfNeeded(
    address initialSigningKey, address expectedKeyRing
  ) internal returns (address keyRing) {
    // Only deploy if a contract doesn't already exist at expected address.
    bytes32 size;
    assembly { size := extcodesize(expectedKeyRing) }
    if (size == 0) {
      require(
        _KEYRING_FACTORY.getNextKeyRing(initialSigningKey) == expectedKeyRing,
        "Key ring to be deployed does not match expected key ring."
      );
      keyRing = _KEYRING_FACTORY.newKeyRing(initialSigningKey, expectedKeyRing);
    } else {
      // Note: the key ring at the expected address may have been modified so that
      // the supplied user signing key is no longer a valid key - therefore, treat
      // this helper as a way to protect against race conditions, not as a primary
      // mechanism for interacting with key ring contracts.
      keyRing = expectedKeyRing;
    }
  }

  /**
   * @notice Internal function to deploy a smart wallet if needed. If expected
   * smart wallet address does not match the next smart wallet address, revert.
   */  
  function _deployNewSmartWalletIfNeeded(
    address userSigningKey, // the key ring
    address expectedSmartWallet
  ) internal returns (address smartWallet) {
    // Only deploy if a contract doesn't already exist at expected address.
    bytes32 size;
    assembly { size := extcodesize(expectedSmartWallet) }
    if (size == 0) {
      require(
        _WALLET_FACTORY.getNextSmartWallet(userSigningKey) == expectedSmartWallet,
        "Smart wallet to be deployed does not match expected smart wallet."
      );
      smartWallet = _WALLET_FACTORY.newSmartWallet(userSigningKey);
    } else {
      // Note: the smart wallet at the expected address may have been modified
      // so that the supplied user signing key is no longer a valid key.
      // Therefore, treat this helper as a way to protect against race
      // conditions, not as a primary mechanism for interacting with smart
      // wallet contracts.
      smartWallet = expectedSmartWallet;
    }
  }

  /**
   * @notice Internal view function to ensure that a recipient is a valid target
   * for the transferrer to select and that the value being transferred does not
   * exceed the current limit.
   */
  function _enforceRecipientAndValue(
    address recipient, address recipientInitialSigningKey, uint256 dDaiAmount
  ) internal view {
    // Ensure that the recipient is indeed a smart wallet.
    require(
      _isSmartWallet(recipient, recipientInitialSigningKey),
      "Could not resolve smart wallet using provided signing key."
    );
    
    // Get the current dDai exchange rate.
    uint256 exchangeRate = _DDAI.exchangeRateCurrent();

    // Ensure that an exchange rate was actually returned.
    require(exchangeRate != 0, "Could not retrieve dDai exchange rate.");
    
    // Get the equivalent Dai amount of the transfer.
    uint256 daiEquivalent = (dDaiAmount.mul(exchangeRate)) / 1e18;
    
    // Ensure that the amount to transfer is lower than the limit.
    require(daiEquivalent < _limit, "Transfer size exceeds the limit.");
  }

  /**
   * @notice Internal view function to check whether the caller is the current
   * role holder.
   * @param role The role to check for. Permitted roles are transferrer (0) and
   * pauser (1).
   * @return A boolean indicating if the caller has the specified role.
   */
  function _isRole(Role role) internal view returns (bool hasRole) {
    hasRole = msg.sender == _roles[uint256(role)].account;
  }

  /**
   * @notice Internal view function to check whether the given role is paused or
   * not.
   * @param role The role to check for. Permitted roles are transferrer (0) and
   * pauser (1).
   * @return A boolean indicating if the specified role is paused or not.
   */
  function _isPaused(Role role) internal view returns (bool paused) {
    paused = _roles[uint256(role)].paused;
  }

  /**
   * @notice Internal view function to enforce that the given initial user
   * signing key resolves to the given smart wallet when deployed through the
   * Dharma Smart Wallet Factory V1.
   * @param smartWallet address The smart wallet.
   * @param initialUserSigningKey address The initial user signing key.
   */
  function _isSmartWallet(
    address smartWallet, address initialUserSigningKey
  ) internal pure returns (bool) {
    // Derive the keccak256 hash of the smart wallet initialization code.
    bytes32 initCodeHash = keccak256(
      abi.encodePacked(
        _WALLET_CREATION_CODE_HEADER,
        initialUserSigningKey,
        _WALLET_CREATION_CODE_FOOTER
      )
    );

    // Attempt to derive a smart wallet address that matches the one provided.
    address target;
    for (uint256 nonce = 0; nonce < 10; nonce++) {
      target = address(          // derive the target deployment address.
        uint160(                 // downcast to match the address type.
          uint256(               // cast to uint to truncate upper digits.
            keccak256(           // compute CREATE2 hash using all inputs.
              abi.encodePacked(  // pack all inputs to the hash together.
                _CREATE2_HEADER, // pass in control character + factory address.
                nonce,           // pass in current nonce as the salt.
                initCodeHash     // pass in hash of contract creation code.
              )
            )
          )
        )
      );

      // Exit early if the provided smart wallet matches derived target address.
      if (target == smartWallet) {
        return true;
      }

      // Otherwise, increment the nonce and derive a new salt.
      nonce++;
    }

    // Explicity recognize no target was found matching provided smart wallet.
    return false;
  }

  /**
   * @notice Modifier that throws if called by any account other than the owner
   * or the supplied role, or if the caller is not the owner and the role in
   * question is paused.
   * @param role The role to require unless the caller is the owner. Permitted
   * roles are transferrer (0) and pauser (1).
   */
  modifier onlyOwnerOr(Role role) {
    if (!isOwner()) {
      require(_isRole(role), "Caller does not have a required role.");
      require(!_isPaused(role), "Role in question is currently paused.");
    }
    _;
  }
}