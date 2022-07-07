/**
 *Submitted for verification at Etherscan.io on 2020-01-08
*/

pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg
// WARNING - `executeActionWithAtomicBatchCalls` has a `bytes[]` argument that
// requires ABIEncoderV2. Exercise caution when calling that specific function.
pragma experimental ABIEncoderV2;


interface DharmaSmartWalletImplementationV0Interface {
  // Fires when a new user signing key is set on the smart wallet.
  event NewUserSigningKey(address userSigningKey);

  // Fires when an error occurs as part of an attempted action.
  event ExternalError(address indexed source, string revertReason);

  // The smart wallet recognizes DAI, USDC, ETH, and SAI as supported assets.
  enum AssetType {
    DAI,
    USDC,
    ETH,
    SAI
  }

  // Actions, or protected methods (i.e. not deposits) each have an action type.
  enum ActionType {
    Cancel,
    SetUserSigningKey,
    Generic,
    GenericAtomicBatch,
    SAIWithdrawal,
    USDCWithdrawal,
    ETHWithdrawal,
    SetEscapeHatch,
    RemoveEscapeHatch,
    DisableEscapeHatch,
    DAIWithdrawal,
    DAIBorrow,
    USDCBorrow
  }

  function initialize(address userSigningKey) external;

  function repayAndDeposit() external;

  function withdrawDai(
    uint256 amount,
    address recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok);

  function withdrawUSDC(
    uint256 amount,
    address recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok);

  function cancel(
    uint256 minimumActionGas,
    bytes calldata signature
  ) external;

  function setUserSigningKey(
    address userSigningKey,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external;

  function getBalances() external returns (
    uint256 daiBalance,
    uint256 usdcBalance,
    uint256 etherBalance,
    uint256 cDaiUnderlyingDaiBalance,
    uint256 cUSDCUnderlyingUSDCBalance,
    uint256 cEtherUnderlyingEtherBalance
  );

  function getUserSigningKey() external view returns (address userSigningKey);

  function getNonce() external view returns (uint256 nonce);

  function getNextCustomActionID(
    ActionType action,
    uint256 amount,
    address recipient,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function getCustomActionID(
    ActionType action,
    uint256 amount,
    address recipient,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function getVersion() external pure returns (uint256 version);
}


interface DharmaSmartWalletImplementationV1Interface {
  event CallSuccess(
    bytes32 actionID,
    bool rolledBack,
    uint256 nonce,
    address to,
    bytes data,
    bytes returnData
  );

  event CallFailure(
    bytes32 actionID,
    uint256 nonce,
    address to,
    bytes data,
    string revertReason
  );

  // ABIEncoderV2 uses an array of Calls for executing generic batch calls.
  struct Call {
    address to;
    bytes data;
  }

  // ABIEncoderV2 uses an array of CallReturns for handling generic batch calls.
  struct CallReturn {
    bool ok;
    bytes returnData;
  }

  function withdrawEther(
    uint256 amount,
    address payable recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok);

  function executeAction(
    address to,
    bytes calldata data,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok, bytes memory returnData);

  function recover(address newUserSigningKey) external;

  function executeActionWithAtomicBatchCalls(
    Call[] calldata calls,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool[] memory ok, bytes[] memory returnData);

  function getNextGenericActionID(
    address to,
    bytes calldata data,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function getGenericActionID(
    address to,
    bytes calldata data,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function getNextGenericAtomicBatchActionID(
    Call[] calldata calls,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function getGenericAtomicBatchActionID(
    Call[] calldata calls,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);
}


interface DharmaSmartWalletImplementationV3Interface {
  event Cancel(uint256 cancelledNonce);
  event EthWithdrawal(uint256 amount, address recipient);
}


interface DharmaSmartWalletImplementationV4Interface {
  event Escaped();

  function setEscapeHatch(
    address account,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external;

  function removeEscapeHatch(
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external;

  function permanentlyDisableEscapeHatch(
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external;

  function escape() external;
}


interface DharmaSmartWalletImplementationV6Interface {
  function migrateSaiToDai() external;
  function migrateCSaiToCDai() external;
}


interface CTokenInterface {
  function mint(uint256 mintAmount) external returns (uint256 err);
  function redeem(uint256 redeemAmount) external returns (uint256 err);
  function redeemUnderlying(uint256 redeemAmount) external returns (uint256 err);
  function balanceOf(address account) external returns (uint256 balance);
  function balanceOfUnderlying(address account) external returns (uint256 balance);
}


interface USDCV1Interface {
  function isBlacklisted(address _account) external view returns (bool);
  function paused() external view returns (bool);
}


interface DharmaKeyRegistryInterface {
  event NewGlobalKey(address oldGlobalKey, address newGlobalKey);
  event NewSpecificKey(
    address indexed account, address oldSpecificKey, address newSpecificKey
  );

  function setGlobalKey(address globalKey, bytes calldata signature) external;
  function setSpecificKey(address account, address specificKey) external;
  function getKey() external view returns (address key);
  function getKeyForUser(address account) external view returns (address key);
  function getGlobalKey() external view returns (address globalKey);
  function getSpecificKey(address account) external view returns (address specificKey);
}


interface DharmaEscapeHatchRegistryInterface {
  // Fire an event when an escape hatch is set or removed.
  event EscapeHatchModified(
    address indexed smartWallet, address oldEscapeHatch, address newEscapeHatch
  );

  // Fire an event when an escape hatch is permanently disabled.
  event EscapeHatchDisabled(address smartWallet);

  // Store the escape hatch account, as well as a flag indicating if the escape
  // hatch has been disabled, for each smart wallet that elects to set one.
  struct EscapeHatch {
    address escapeHatch;
    bool disabled;
  }

  function setEscapeHatch(address newEscapeHatch) external;

  function removeEscapeHatch() external;

  function permanentlyDisableEscapeHatch() external;

  function getEscapeHatch() external view returns (
    bool exists, address escapeHatch
  );

  function getEscapeHatchForSmartWallet(
    address smartWallet
  ) external view returns (bool exists, address escapeHatch);

  function hasDisabledEscapeHatchForSmartWallet(
    address smartWallet
  ) external view returns (bool disabled);
}


interface IERC20 {
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
}


interface ERC1271 {
  function isValidSignature(
    bytes calldata data, bytes calldata signature
  ) external view returns (bytes4 magicValue);
}


interface SaiToDaiMigratorInterface {
  function swapSaiToDai(uint256 balance) external;
}


library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}


library ECDSA {
  function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
    if (signature.length != 65) {
      return (address(0));
    }

    bytes32 r;
    bytes32 s;
    uint8 v;

    assembly {
      r := mload(add(signature, 0x20))
      s := mload(add(signature, 0x40))
      v := byte(0, mload(add(signature, 0x60)))
    }

    if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
      return address(0);
    }

    if (v != 27 && v != 28) {
      return address(0);
    }

    return ecrecover(hash, v, r, s);
  }

  function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
  }
}


/**
 * @title DharmaSmartWalletImplementationV6 (staging version)
 * @author 0age
 * @notice The V6 implementation for the Dharma smart wallet is a non-custodial,
 * meta-transaction-enabled wallet with helper functions to facilitate lending
 * funds using CompoundV2, and with a security backstop provided by Dharma Labs
 * prior to making withdrawals. It adds support for Multi-collateral Dai, with
 * the addition of functions for migrating Sai to Dai as well as for migrating
 * cSai to cDai while leaving any existing Sai in place to simplify accounting.
 * It contains methods to support account recovery, escape hatch functionality,
 * and generic actions, including in an atomic batch. The smart wallet instances
 * utilizing this implementation are deployed through the Dharma Smart Wallet
 * Factory via `CREATE2`, which allows for their address to be known ahead of
 * time, and any Dai or USDC that has already been sent into that address will
 * automatically be deposited into Compound upon deployment of the new smart
 * wallet instance.
 */
contract DharmaSmartWalletImplementationV6Staging is
  DharmaSmartWalletImplementationV0Interface,
  DharmaSmartWalletImplementationV1Interface,
  DharmaSmartWalletImplementationV3Interface,
  DharmaSmartWalletImplementationV4Interface,
  DharmaSmartWalletImplementationV6Interface {
  using Address for address;
  using ECDSA for bytes32;
  // WARNING: DO NOT REMOVE OR REORDER STORAGE WHEN WRITING NEW IMPLEMENTATIONS!

  // The user signing key associated with this account is in storage slot 0.
  // It is the core differentiator when it comes to the account in question.
  address private _userSigningKey;

  // The nonce associated with this account is in storage slot 1. Every time a
  // signature is submitted, it must have the appropriate nonce, and once it has
  // been accepted the nonce will be incremented.
  uint256 private _nonce;

  // The self-call context flag is in storage slot 2. Some protected functions
  // may only be called externally from calls originating from other methods on
  // this contract, which enables appropriate exception handling on reverts.
  // Any storage should only be set immediately preceding a self-call and should
  // be cleared upon entering the protected function being called.
  bytes4 internal _selfCallContext;

  // END STORAGE DECLARATIONS - DO NOT REMOVE OR REORDER STORAGE ABOVE HERE!

  // The smart wallet version will be used when constructing valid signatures.
  uint256 internal constant _DHARMA_SMART_WALLET_VERSION = 6;

  // DharmaKeyRegistryV2 holds a public key for verifying meta-transactions.
  DharmaKeyRegistryInterface internal constant _DHARMA_KEY_REGISTRY = (
    DharmaKeyRegistryInterface(0x00000000006c7f32F0cD1eA4C1383558eb68802D)
  );

  // Account recovery is facilitated using a hard-coded recovery manager,
  // controlled by Dharma and implementing appropriate timelocks.
  address internal constant _ACCOUNT_RECOVERY_MANAGER = address(
    0x2a7E7718b755F9868E6B64DD18C6886707DD9c10
  );

  // Users can designate an "escape hatch" account with the ability to sweep all
  // funds from their smart wallet by using the Dharma Escape Hatch Registry.
  DharmaEscapeHatchRegistryInterface internal constant _ESCAPE_HATCH_REGISTRY = (
    DharmaEscapeHatchRegistryInterface(0x00000000005280B515004B998a944630B6C663f8)
  );

  // Interface with Sai, Dai, USDC, related CompoundV2 contracts, and migrator.
  CTokenInterface internal constant _CSAI = CTokenInterface(
    0xF5DCe57282A584D2746FaF1593d3121Fcac444dC // mainnet
  );

  CTokenInterface internal constant _CDAI = CTokenInterface(
    0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643 // mainnet
  );

  CTokenInterface internal constant _CUSDC = CTokenInterface(
    0x39AA39c021dfbaE8faC545936693aC917d5E7563 // mainnet
  );

  IERC20 internal constant _SAI = IERC20(
    0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359 // mainnet
  );

  IERC20 internal constant _DAI = IERC20(
    0x6B175474E89094C44Da98b954EedeAC495271d0F // mainnet
  );

  IERC20 internal constant _USDC = IERC20(
    0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // mainnet
  );

  SaiToDaiMigratorInterface internal constant _MIGRATOR = SaiToDaiMigratorInterface(
    0xc73e0383F3Aff3215E6f04B0331D58CeCf0Ab849 // mainnet
  );

  USDCV1Interface internal constant _USDC_NAUGHTY = USDCV1Interface(
    0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // mainnet
  );

  // Compound returns a value of 0 to indicate success, or lack of an error.
  uint256 internal constant _COMPOUND_SUCCESS = 0;

  // ERC-1271 must return this magic value when `isValidSignature` is called.
  bytes4 internal constant _ERC_1271_MAGIC_VALUE = bytes4(0x20c13b0b);

  // Minimum supported deposit & non-maximum withdrawal size is .001 underlying.
  uint256 private constant _JUST_UNDER_ONE_1000th_DAI = 999999999999999;
  uint256 private constant _JUST_UNDER_ONE_1000th_USDC = 999;

  // Specify the amount of gas to supply when making Ether transfers.
  uint256 private constant _ETH_TRANSFER_GAS = 4999;

  /**
   * @notice In the initializer, set up the initial user signing key, set
   * approval on the cDAI and cUSDC contracts, and deposit any Dai or USDC
   * already at this address to Compound. Note that this initializer is only
   * callable while the smart wallet instance is still in the contract creation
   * phase.
   * @param userSigningKey address The initial user signing key for the smart
   * wallet.
   */
  function initialize(address userSigningKey) public {	//inject PUBLIC FUNC TO EXTERNAL
    // Ensure that this function is only callable during contract construction.
    assembly { if extcodesize(address) { revert(0, 0) } }

    // Set up the user's signing key and emit a corresponding event.
    _setUserSigningKey(userSigningKey);

    // Approve the cDAI contract to transfer Dai on behalf of this contract.
    if (_setFullApproval(AssetType.DAI)) {
      // Get the current Dai balance on this contract.
      uint256 daiBalance = _DAI.balanceOf(address(this));

      // Try to deposit the full Dai balance on Compound.
      _depositOnCompound(AssetType.DAI, daiBalance);
    }

    // Approve the cUSDC contract to transfer USDC on behalf of this contract.
    if (_setFullApproval(AssetType.USDC)) {
      // Get the current USDC balance on this contract.
      uint256 usdcBalance = _USDC.balanceOf(address(this));

      // Try to deposit the full USDC balance on Compound.
      _depositOnCompound(AssetType.USDC, usdcBalance);
    }
  }

  /**
   * @notice Deposit all Dai and USDC currently residing at this address to
   * Compound. Note that "repay" is not currently implemented, but the function
   * is still named `repayAndDeposit` so that infrastructure around calling this
   * function will not need to be altered for a future smart wallet version. If
   * some step of this function fails, the function itself will still succeed,
   * but an `ExternalError` with information on what went wrong will be emitted.
   */
  function repayAndDeposit() public {	//inject PUBLIC FUNC TO EXTERNAL
    // Get the current Dai balance on this contract.
    uint256 daiBalance = _DAI.balanceOf(address(this));

    // If there is any Dai balance, check for adequate approval for cDai.
    if (daiBalance > 0) {
      uint256 daiAllowance = _DAI.allowance(address(this), address(_CDAI));
      // If allowance is insufficient, try to set it before depositing.
      if (daiAllowance < daiBalance) {
        if (_setFullApproval(AssetType.DAI)) {
          // Deposit the full available Dai balance on Compound.
          _depositOnCompound(AssetType.DAI, daiBalance);
        }
      // Otherwise, just go ahead and try the Dai deposit.
      } else {
        // Deposit the full available Dai balance on Compound.
        _depositOnCompound(AssetType.DAI, daiBalance);
      }
    }

    // Get the current USDC balance on this contract.
    uint256 usdcBalance = _USDC.balanceOf(address(this));

    // If there is any USDC balance, check for adequate approval for cUSDC.
    if (usdcBalance > 0) {
      uint256 usdcAllowance = _USDC.allowance(address(this), address(_CUSDC));
      // If allowance is insufficient, try to set it before depositing.
      if (usdcAllowance < usdcBalance) {
        if (_setFullApproval(AssetType.USDC)) {
          // Deposit the full available USDC balance on Compound.
          _depositOnCompound(AssetType.USDC, usdcBalance);
        }
      // Otherwise, just go ahead and try the USDC deposit.
      } else {
        // Deposit the full available USDC balance on Compound.
        _depositOnCompound(AssetType.USDC, usdcBalance);
      }
    }
  }

  /**
   * @notice Withdraw Dai to a provided recipient address by redeeming the
   * underlying Dai from the cDAI contract and transferring it to the recipient.
   * All Dai in Compound and in the smart wallet itself can be withdrawn by
   * providing an amount of uint256(-1) or 0xfff...fff. This function can be
   * called directly by the account set as the global key on the Dharma Key
   * Registry, or by any relayer that provides a signed message from the same
   * keyholder. The nonce used for the signature must match the current nonce on
   * the smart wallet, and gas supplied to the call must exceed the specified
   * minimum action gas, plus the gas that will be spent before the gas check is
   * reached - usually somewhere around 25,000 gas. If the withdrawal fails, an
   * `ExternalError` with additional details on what went wrong will be emitted.
   * Note that some dust may still be left over, even in the event of a max
   * withdrawal, due to the fact that Dai has a higher precision than cDAI. Also
   * note that the withdrawal will fail in the event that Compound does not have
   * sufficient Dai available to withdraw.
   * @param amount uint256 The amount of Dai to withdraw.
   * @param recipient address The account to transfer the withdrawn Dai to.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   * @return True if the withdrawal succeeded, otherwise false.
   */
  function withdrawDai(
    uint256 amount,
    address recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok) {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _validateActionAndIncrementNonce(
      ActionType.DAIWithdrawal,
      abi.encode(amount, recipient),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Ensure that an amount of at least 0.001 Dai has been supplied.
    require(amount > _JUST_UNDER_ONE_1000th_DAI, "Insufficient Dai supplied.");

    // Ensure that a non-zero recipient has been supplied.
    require(recipient != address(0), "No recipient supplied.");

    // Set the self-call context in order to call _withdrawDaiAtomic.
    _selfCallContext = this.withdrawDai.selector;

    // Make the atomic self-call - if redeemUnderlying fails on cDAI, it will
    // succeed but nothing will happen except firing an ExternalError event. If
    // the second part of the self-call (the Dai transfer) fails, it will revert
    // and roll back the first part of the call as well as fire an ExternalError
    // event after returning from the failed call.
    bytes memory returnData;
    (ok, returnData) = address(this).call(abi.encodeWithSelector(
      this._withdrawDaiAtomic.selector, amount, recipient
    ));

    // If the atomic call failed, emit an event signifying a transfer failure.
    if (!ok) {
      emit ExternalError(address(_DAI), "Could not transfer Dai.");
    } else {
      // Set ok to false if the call succeeded but the withdrawal failed.
      ok = abi.decode(returnData, (bool));
    }
  }

  /**
   * @notice Protected function that can only be called from `withdrawDai` on
   * this contract. It will attempt to withdraw the supplied amount of Dai, or
   * the maximum amount if specified using `uint256(-1)`, to the supplied
   * recipient address by redeeming the underlying Dai from the cDAI contract
   * and transferring it to the recipient. An ExternalError will be emitted and
   * the transfer will be skipped if the call to `redeem` or `redeemUnderlying`
   * fails, and any revert will be caught by `withdrawDai` and diagnosed in
   * order to emit an appropriate `ExternalError` as well.
   * @param amount uint256 The amount of Dai to withdraw.
   * @param recipient address The account to transfer the withdrawn Dai to.
   * @return True if the withdrawal succeeded, otherwise false.
   */
  function _withdrawDaiAtomic(
    uint256 amount,
    address recipient
  ) public returns (bool success) {	//inject PUBLIC FUNC TO EXTERNAL
    // Ensure caller is this contract and self-call context is correctly set.
    _enforceSelfCallFrom(this.withdrawDai.selector);

    // If amount = 0xfff...fff, withdraw the maximum amount possible.
    bool maxWithdraw = (amount == uint256(-1));
    if (maxWithdraw) {
      // First attempt to redeem all cDai from Compound if there is a balance.
      _withdrawMaxFromCompound(AssetType.DAI);

      // Then transfer all Dai to recipient if there is a balance.
      require(_transferMax(_DAI, recipient, false));
      success = true;
    } else {
      // Attempt to withdraw specified Dai from Compound before proceeding.
      if (_withdrawFromCompound(AssetType.DAI, amount)) {
        // At this point Dai transfer should never fail - wrap it just in case.
        require(_DAI.transfer(recipient, amount));
        success = true;
      }
    }
  }

  /**
   * @notice Withdraw USDC to a provided recipient address by redeeming the
   * underlying USDC from the cUSDC contract and transferring it to recipient.
   * All USDC in Compound and in the smart wallet itself can be withdrawn by
   * providing an amount of uint256(-1) or 0xfff...fff. This function can be
   * called directly by the account set as the global key on the Dharma Key
   * Registry, or by any relayer that provides a signed message from the same
   * keyholder. The nonce used for the signature must match the current nonce on
   * the smart wallet, and gas supplied to the call must exceed the specified
   * minimum action gas, plus the gas that will be spent before the gas check is
   * reached - usually somewhere around 25,000 gas. If the withdrawal fails, an
   * `ExternalError` with additional details on what went wrong will be emitted.
   * Note that the USDC contract can be paused and also allows for blacklisting
   * accounts - either of these possibilities may cause a withdrawal to fail. In
   * addition, Compound may not have sufficient USDC available at the time to
   * withdraw.
   * @param amount uint256 The amount of USDC to withdraw.
   * @param recipient address The account to transfer the withdrawn USDC to.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   * @return True if the withdrawal succeeded, otherwise false.
   */
  function withdrawUSDC(
    uint256 amount,
    address recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok) {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _validateActionAndIncrementNonce(
      ActionType.USDCWithdrawal,
      abi.encode(amount, recipient),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Ensure that an amount of at least 0.001 USDC has been supplied.
    require(amount > _JUST_UNDER_ONE_1000th_USDC, "Insufficient USDC supplied.");

    // Ensure that a non-zero recipient has been supplied.
    require(recipient != address(0), "No recipient supplied.");

    // Set the self-call context in order to call _withdrawUSDCAtomic.
    _selfCallContext = this.withdrawUSDC.selector;

    // Make the atomic self-call - if redeemUnderlying fails on cUSDC, it will
    // succeed but nothing will happen except firing an ExternalError event. If
    // the second part of the self-call (USDC transfer) fails, it will revert
    // and roll back the first part of the call as well as fire an ExternalError
    // event after returning from the failed call.
    bytes memory returnData;
    (ok, returnData) = address(this).call(abi.encodeWithSelector(
      this._withdrawUSDCAtomic.selector, amount, recipient
    ));
    if (!ok) {
      // Find out why USDC transfer reverted (doesn't give revert reasons).
      _diagnoseAndEmitUSDCSpecificError(_USDC.transfer.selector);
    } else {
      // Set ok to false if the call succeeded but the withdrawal failed.
      ok = abi.decode(returnData, (bool));
    }
  }

  /**
   * @notice Protected function that can only be called from `withdrawUSDC` on
   * this contract. It will attempt to withdraw the supplied amount of USDC, or
   * the maximum amount if specified using `uint256(-1)`, to the supplied
   * recipient address by redeeming the underlying USDC from the cUSDC contract
   * and transferring it to the recipient. An ExternalError will be emitted and
   * the transfer will be skipped if the call to `redeemUnderlying` fails, and
   * any revert will be caught by `withdrawUSDC` and diagnosed in order to emit
   * an appropriate ExternalError as well.
   * @param amount uint256 The amount of USDC to withdraw.
   * @param recipient address The account to transfer the withdrawn USDC to.
   * @return True if the withdrawal succeeded, otherwise false.
   */
  function _withdrawUSDCAtomic(
    uint256 amount,
    address recipient
  ) public returns (bool success) {	//inject PUBLIC FUNC TO EXTERNAL
    // Ensure caller is this contract and self-call context is correctly set.
    _enforceSelfCallFrom(this.withdrawUSDC.selector);

    // If amount = 0xfff...fff, withdraw the maximum amount possible.
    bool maxWithdraw = (amount == uint256(-1));
    if (maxWithdraw) {
      // First attempt to redeem all cUSDC from Compound if there is a balance.
      _withdrawMaxFromCompound(AssetType.USDC);

      // Then transfer all USDC to recipient if there is a balance.
      require(_transferMax(_USDC, recipient, false));
      success = true;
    } else {
      // Attempt to withdraw specified USDC from Compound before proceeding.
      if (_withdrawFromCompound(AssetType.USDC, amount)) {
        // Ensure that the USDC transfer does not fail.
        require(_USDC.transfer(recipient, amount));
        success = true;
      }
    }
  }

  /**
   * @notice Withdraw Ether to a provided recipient address by transferring it
   * to a recipient. This is only intended to be utilized on V6 as a mechanism
   * for recovering Ether from this contract.
   * @param amount uint256 The amount of Ether to withdraw.
   * @param recipient address The account to transfer the Ether to.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   * @return True if the transfer succeeded, otherwise false.
   */
  function withdrawEther(
    uint256 amount,
    address payable recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok) {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _validateActionAndIncrementNonce(
      ActionType.ETHWithdrawal,
      abi.encode(amount, recipient),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Ensure that a non-zero amount of Ether has been supplied.
    require(amount > 0, "Must supply a non-zero amount of Ether.");

    // Ensure that a non-zero recipient has been supplied.
    require(recipient != address(0), "No recipient supplied.");

    // Attempt to transfer Ether to the recipient and emit an appropriate event.
    ok = _transferETH(recipient, amount);
  }

  /**
   * @notice Allow a signatory to increment the nonce at any point. The current
   * nonce needs to be provided as an argument to the a signature so as not to
   * enable griefing attacks. All arguments can be omitted if called directly.
   * No value is returned from this function - it will either succeed or revert.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param signature bytes A signature that resolves to either the public key
   * set for this account in storage slot zero, `_userSigningKey`, or the public
   * key returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   */
  function cancel(
    uint256 minimumActionGas,
    bytes calldata signature
  ) external {
    // Get the current nonce.
    uint256 nonceToCancel = _nonce;

    // Ensure the caller or the supplied signature is valid and increment nonce.
    _validateActionAndIncrementNonce(
      ActionType.Cancel,
      abi.encode(),
      minimumActionGas,
      signature,
      signature
    );

    // Emit an event to validate that the nonce is no longer valid.
    emit Cancel(nonceToCancel);
  }

  /**
   * @notice Perform a generic call to another contract. Note that accounts with
   * no code may not be specified, nor may the smart wallet itself. In order to
   * increment the nonce and invalidate the signatures, a call to this function
   * with a valid target, signatutes, and gas will always succeed. To determine
   * whether the call made as part of the action was successful or not, either
   * the return values or the `CallSuccess` or `CallFailure` event can be used.
   * @param to address The contract to call.
   * @param data bytes The calldata to provide when making the call.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   * @return A boolean signifying the status of the call, as well as any data
   * returned from the call.
   */
  function executeAction(
    address to,
    bytes calldata data,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok, bytes memory returnData) {
    // Ensure that the `to` address is a contract and is not this contract.
    _ensureValidGenericCallTarget(to);

    // Ensure caller and/or supplied signatures are valid and increment nonce.
    (bytes32 actionID, uint256 nonce) = _validateActionAndIncrementNonce(
      ActionType.Generic,
      abi.encode(to, data),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Note: from this point on, there are no reverts (apart from out-of-gas or
    // call-depth-exceeded) originating from this action. However, the call
    // itself may revert, in which case the function will return `false`, along
    // with the revert reason encoded as bytes, and fire an CallFailure event.

    // Perform the action via low-level call and set return values using result.
    (ok, returnData) = to.call(data);

    // Emit a CallSuccess or CallFailure event based on the outcome of the call.
    if (ok) {
      // Note: while the call succeeded, the action may still have "failed"
      // (for example, successful calls to Compound can still return an error).
      emit CallSuccess(actionID, false, nonce, to, data, returnData);
    } else {
      // Note: while the call failed, the nonce will still be incremented, which
      // will invalidate all supplied signatures.
      emit CallFailure(actionID, nonce, to, data, string(returnData));
    }
  }

  /**
   * @notice Allow signatory to set a new user signing key. The current nonce
   * needs to be provided as an argument to the a signature so as not to enable
   * griefing attacks. No value is returned from this function - it will either
   * succeed or revert.
   * @param userSigningKey address The new user signing key to set on this smart
   * wallet.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   */
  function setUserSigningKey(
    address userSigningKey,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _validateActionAndIncrementNonce(
      ActionType.SetUserSigningKey,
      abi.encode(userSigningKey),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Set new user signing key on smart wallet and emit a corresponding event.
    _setUserSigningKey(userSigningKey);
  }

  /**
   * @notice Set a dedicated address as the "escape hatch" account. This account
   * will then be able to call `escape()` at any point to "sweep" the entire
   * Dai, USDC, residual cDAI & cUSDC, and Ether balance from the smart wallet.
   * This function call will revert if the smart wallet has previously called
   * `permanentlyDisableEscapeHatch` at any point and disabled the escape hatch.
   * No value is returned from this function - it will either succeed or revert.
   * @param account address The account to set as the escape hatch account.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   */
  function setEscapeHatch(
    address account,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _validateActionAndIncrementNonce(
      ActionType.SetEscapeHatch,
      abi.encode(account),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Ensure that an escape hatch account has been provided.
    require(account != address(0), "Must supply an escape hatch account.");

    // Set a new escape hatch for the smart wallet unless it has been disabled.
    _ESCAPE_HATCH_REGISTRY.setEscapeHatch(account);
  }

  /**
   * @notice Remove the "escape hatch" account if one is currently set. This
   * function call will revert if the smart wallet has previously called
   * `permanentlyDisableEscapeHatch` at any point and disabled the escape hatch.
   * No value is returned from this function - it will either succeed or revert.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   */
  function removeEscapeHatch(
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _validateActionAndIncrementNonce(
      ActionType.RemoveEscapeHatch,
      abi.encode(),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Remove the escape hatch for the smart wallet if one is currently set.
    _ESCAPE_HATCH_REGISTRY.removeEscapeHatch();
  }

  /**
   * @notice Permanently disable the "escape hatch" mechanism for this smart
   * wallet. This function call will revert if the smart wallet has already
   * called `permanentlyDisableEscapeHatch` at any point in the past. No value
   * is returned from this function - it will either succeed or revert.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   */
  function permanentlyDisableEscapeHatch(
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _validateActionAndIncrementNonce(
      ActionType.DisableEscapeHatch,
      abi.encode(),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Permanently disable the escape hatch mechanism for this smart wallet.
    _ESCAPE_HATCH_REGISTRY.permanentlyDisableEscapeHatch();
  }

  /**
   * @notice Allow the designated escape hatch account to  "sweep" the entire
   * Sai, Dai, USDC, residual cSai, cDAI & cUSDC, and Ether balance from the
   * smart wallet. The call will revert for any other caller, or if there is no
   * escape hatch account currently set for this smart wallet. First, an attempt
   * will be made to redeem any cSAI, cDAI, or cUSDC that is currently deposited
   * in Compound. Then, attempts will be made to transfer all Sai, Dai, USDC,
   * residual cSAI, cDAI & cUSDC, and Ether to the escape hatch account. If any
   * portion of this operation does not succeed, it will simply be skipped,
   * allowing the rest of the operation to proceed. Finally, an `Escaped` event
   * will be emitted. No value is returned from this function - it will either
   * succeed or revert.
   */
  function escape() public {	//inject PUBLIC FUNC TO EXTERNAL
    // Get the escape hatch account, if one exists, for this account.
    (bool exists, address escapeHatch) = _ESCAPE_HATCH_REGISTRY.getEscapeHatch();

    // Ensure that an escape hatch is currently set for this smart wallet.
    require(exists, "No escape hatch is currently set for this smart wallet.");

    // Ensure that the escape hatch account is the caller.
    require(
      msg.sender == escapeHatch,
      "Only the escape hatch account may call this function."
    );

    // Attempt to redeem all cSAI for Sai on Compound.
    _withdrawMaxFromCompound(AssetType.SAI);

    // Attempt to redeem all cDAI for Dai on Compound.
    _withdrawMaxFromCompound(AssetType.DAI);

    // Attempt to redeem all cUSDC for USDC on Compound.
    _withdrawMaxFromCompound(AssetType.USDC);

    // Attempt to transfer the total Sai balance to the caller.
    _transferMax(_SAI, msg.sender, true);

    // Attempt to transfer the total Dai balance to the caller.
    _transferMax(_DAI, msg.sender, true);

    // Attempt to transfer the total USDC balance to the caller.
    _transferMax(_USDC, msg.sender, true);

    // Attempt to transfer any residual cSAI to the caller.
    _transferMax(IERC20(address(_CSAI)), msg.sender, true);

    // Attempt to transfer any residual cDAI to the caller.
    _transferMax(IERC20(address(_CDAI)), msg.sender, true);

    // Attempt to transfer any residual cUSDC to the caller.
    _transferMax(IERC20(address(_CUSDC)), msg.sender, true);

    // Determine if there is Ether at this address that should be transferred.
    uint256 balance = address(this).balance;
    if (balance > 0) {
      // Attempt to transfer any Ether to caller and emit an appropriate event.
      _transferETH(msg.sender, balance);
    }

    // Emit an `Escaped` event.
    emit Escaped();
  }

  /**
   * @notice Allow the account recovery manager to set a new user signing key on
   * the smart wallet. The call will revert for any other caller. The account
   * recovery manager implements a set of controls around the process, including
   * a timelock and an option to permanently opt out of account recover. No
   * value is returned from this function - it will either succeed or revert.
   * @param newUserSigningKey address The new user signing key to set on this
   * smart wallet.
   */
  function recover(address newUserSigningKey) public {	//inject PUBLIC FUNC TO EXTERNAL
    require(
      msg.sender == _ACCOUNT_RECOVERY_MANAGER,
      "Only the account recovery manager may call this function."
    );

    // Increment nonce to prevent signature reuse should original key be reset.
    _nonce++;

    // Set up the user's new dharma key and emit a corresponding event.
    _setUserSigningKey(newUserSigningKey);
  }

  /**
   * @notice Convert all available Sai for Dai. If the conversion fails, or if
   * the realized exchange rate is less than 1:1, the call will revert. Note
   * that cSai is not included as part of this operation.
   */
  function migrateSaiToDai() public {	//inject PUBLIC FUNC TO EXTERNAL
    // Swap the current Sai balance on this contract for Dai.
    _swapSaiForDai(_SAI.balanceOf(address(this)));
  }

  /**
   * @notice Redeem all available cSAI for Sai, swap that Sai for Dai, and use
   * that Dai to mint cDai. If any step in the process fails, the call will
   * revert and prior steps will be rolled back. Also note that existing Sai and
   * Dai are not included as part of this operation.
   */
  function migrateCSaiToCDai() public {	//inject PUBLIC FUNC TO EXTERNAL
    // Get the current cSai balance for this account.
    uint256 redeemAmount = _CSAI.balanceOf(address(this));

    // Only perform the call to redeem if there is a non-zero balance.
    if (redeemAmount > 0) {
      // Get the current Sai balance on this contract.
      uint256 currentSaiBalance = _SAI.balanceOf(address(this));

      // Redeem underlying balance from cSai and revert if unsuccessful.
      require(
        _CSAI.redeem(redeemAmount) == _COMPOUND_SUCCESS, "cSai redeem failed."
      );

      // Calculate difference between pre-redeem and post-redeem Sai balances.
      uint256 saiBalance = _SAI.balanceOf(address(this)) - currentSaiBalance;

      // Swap any Sai for Dai and get the newly-swapped Dai balance.
      uint256 daiBalance = _swapSaiForDai(saiBalance);
      
      // If the cDai allowance is insufficient, set it before depositing.
      if (_DAI.allowance(address(this), address(_CDAI)) < daiBalance) {
        require(
          _DAI.approve(address(_CDAI), uint256(-1)), "Dai approval failed."
        );
      }
      
      // Deposit the new Dai balance on Compound.
      require(_CDAI.mint(daiBalance) == _COMPOUND_SUCCESS, "cDai mint failed.");
    }
  }

  /**
   * @notice Retrieve the Dai and USDC balances held by the smart wallet, both
   * directly and held in Compound. This is not a view function since Compound
   * will calculate accrued interest as part of the underlying balance checks,
   * but can still be called from an off-chain source as though it were a view
   * function.
   * @return The Dai balance, the USDC balance, the underlying Dai balance of
   * the cDAI balance, and the underlying USDC balance of the cUSDC balance.
   */
  function getBalances() public returns (	//inject PUBLIC FUNC TO EXTERNAL
    uint256 daiBalance,
    uint256 usdcBalance,
    uint256 etherBalance, // always returns 0
    uint256 cDaiUnderlyingDaiBalance,
    uint256 cUsdcUnderlyingUsdcBalance,
    uint256 cEtherUnderlyingEtherBalance // always returns 0
  ) {
    daiBalance = _DAI.balanceOf(address(this));
    usdcBalance = _USDC.balanceOf(address(this));
    cDaiUnderlyingDaiBalance = _CDAI.balanceOfUnderlying(address(this));
    cUsdcUnderlyingUsdcBalance = _CUSDC.balanceOfUnderlying(address(this));
  }

  /**
   * @notice View function for getting the current user signing key for the
   * smart wallet.
   * @return The current user signing key.
   */
  function getUserSigningKey() public view returns (address userSigningKey) {	//inject PUBLIC FUNC TO EXTERNAL
    userSigningKey = _userSigningKey;
  }

  /**
   * @notice View function for getting the current nonce of the smart wallet.
   * This nonce is incremented whenever an action is taken that requires a
   * signature and/or a specific caller.
   * @return The current nonce.
   */
  function getNonce() public view returns (uint256 nonce) {	//inject PUBLIC FUNC TO EXTERNAL
    nonce = _nonce;
  }

  /**
   * @notice View function that, given an action type and arguments, will return
   * the action ID or message hash that will need to be prefixed (according to
   * EIP-191 0x45), hashed, and signed by both the user signing key and by the
   * key returned for this smart wallet by the Dharma Key Registry in order to
   * construct a valid signature for the corresponding action. Any nonce value
   * may be supplied, which enables constructing valid message hashes for
   * multiple future actions ahead of time.
   * @param action uint8 The type of action, designated by it's index. Valid
   * custom actions in V6 include Cancel (0), SetUserSigningKey (1),
   * DAIWithdrawal (10), USDCWithdrawal (5), ETHWithdrawal (6),
   * SetEscapeHatch (7), RemoveEscapeHatch (8), and DisableEscapeHatch (9).
   * @param amount uint256 The amount to withdraw for Withdrawal actions. This
   * value is ignored for non-withdrawal action types.
   * @param recipient address The account to transfer withdrawn funds to or the
   * new user signing key. This value is ignored for Cancel, RemoveEscapeHatch,
   * and DisableEscapeHatch action types.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @return The action ID, which will need to be prefixed, hashed and signed in
   * order to construct a valid signature.
   */
  function getNextCustomActionID(
    ActionType action,
    uint256 amount,
    address recipient,
    uint256 minimumActionGas
  ) public view returns (bytes32 actionID) {	//inject PUBLIC FUNC TO EXTERNAL
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _getActionID(
      action,
      _validateCustomActionTypeAndGetArguments(action, amount, recipient),
      _nonce,
      minimumActionGas,
      _userSigningKey,
      _getDharmaSigningKey()
    );
  }

  /**
   * @notice View function that, given an action type and arguments, will return
   * the action ID or message hash that will need to be prefixed (according to
   * EIP-191 0x45), hashed, and signed by both the user signing key and by the
   * key returned for this smart wallet by the Dharma Key Registry in order to
   * construct a valid signature for the corresponding action. The current nonce
   * will be used, which means that it will only be valid for the next action
   * taken.
   * @param action uint8 The type of action, designated by it's index. Valid
   * custom actions in V6 include Cancel (0), SetUserSigningKey (1),
   * DAIWithdrawal (10), USDCWithdrawal (5), ETHWithdrawal (6),
   * SetEscapeHatch (7), RemoveEscapeHatch (8), and DisableEscapeHatch (9).
   * @param amount uint256 The amount to withdraw for Withdrawal actions. This
   * value is ignored for non-withdrawal action types.
   * @param recipient address The account to transfer withdrawn funds to or the
   * new user signing key. This value is ignored for Cancel, RemoveEscapeHatch,
   * and DisableEscapeHatch action types.
   * @param nonce uint256 The nonce to use.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @return The action ID, which will need to be prefixed, hashed and signed in
   * order to construct a valid signature.
   */
  function getCustomActionID(
    ActionType action,
    uint256 amount,
    address recipient,
    uint256 nonce,
    uint256 minimumActionGas
  ) public view returns (bytes32 actionID) {	//inject PUBLIC FUNC TO EXTERNAL
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _getActionID(
      action,
      _validateCustomActionTypeAndGetArguments(action, amount, recipient),
      nonce,
      minimumActionGas,
      _userSigningKey,
      _getDharmaSigningKey()
    );
  }

  /**
   * @notice View function that, given an action type and arguments, will return
   * the action ID or message hash that will need to be prefixed (according to
   * EIP-191 0x45), hashed, and signed by both the user signing key and by the
   * key returned for this smart wallet by the Dharma Key Registry in order to
   * construct a valid signature for a given generic action. The current nonce
   * will be used, which means that it will only be valid for the next action
   * taken.
   * @param to address The target to call into as part of the generic action.
   * @param data bytes The data to supply when calling into the target.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @return The action ID, which will need to be prefixed, hashed and signed in
   * order to construct a valid signature.
   */
  function getNextGenericActionID(
    address to,
    bytes calldata data,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _getActionID(
      ActionType.Generic,
      abi.encode(to, data),
      _nonce,
      minimumActionGas,
      _userSigningKey,
      _getDharmaSigningKey()
    );
  }

  /**
   * @notice View function that, given an action type and arguments, will return
   * the action ID or message hash that will need to be prefixed (according to
   * EIP-191 0x45), hashed, and signed by both the user signing key and by the
   * key returned for this smart wallet by the Dharma Key Registry in order to
   * construct a valid signature for a given generic action. Any nonce value may
   * be supplied, which enables constructing valid message hashes for multiple
   * future actions ahead of time.
   * @param to address The target to call into as part of the generic action.
   * @param data bytes The data to supply when calling into the target.
   * @param nonce uint256 The nonce to use.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @return The action ID, which will need to be prefixed, hashed and signed in
   * order to construct a valid signature.
   */
  function getGenericActionID(
    address to,
    bytes calldata data,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _getActionID(
      ActionType.Generic,
      abi.encode(to, data),
      nonce,
      minimumActionGas,
      _userSigningKey,
      _getDharmaSigningKey()
    );
  }

  /**
   * @notice Pure function for getting the current Dharma Smart Wallet version.
   * @return The current Dharma Smart Wallet version.
   */
  function getVersion() public pure returns (uint256 version) {	//inject PUBLIC FUNC TO EXTERNAL
    version = _DHARMA_SMART_WALLET_VERSION;
  }

  /**
   * @notice Perform a series of generic calls to other contracts. If any call
   * fails during execution, the preceding calls will be rolled back, but their
   * original return data will still be accessible. Calls that would otherwise
   * occur after the failed call will not be executed. Note that accounts with
   * no code may not be specified, nor may the smart wallet itself or the escape
   * hatch registry. In order to increment the nonce and invalidate the
   * signatures, a call to this function with valid targets, signatutes, and gas
   * will always succeed. To determine whether each call made as part of the
   * action was successful or not, either the corresponding return value or the
   * corresponding `CallSuccess` or `CallFailure` event can be used - note that
   * even calls that return a success status will have been rolled back unless
   * all of the calls returned a success status. Finally, note that this
   * function must currently be implemented as a public function (instead of as
   * an external one) due to an ABIEncoderV2 `UnimplementedFeatureError`.
   * @param calls Call[] A struct containing the target and calldata to provide
   * when making each call.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   * @return An array of structs signifying the status of each call, as well as
   * any data returned from that call. Calls that are not executed will return
   * empty data.
   */
  function executeActionWithAtomicBatchCalls(
    Call[] memory calls,
    uint256 minimumActionGas,
    bytes memory userSignature,
    bytes memory dharmaSignature
  ) public returns (bool[] memory ok, bytes[] memory returnData) {
    // Ensure that each `to` address is a contract and is not this contract.
    for (uint256 i = 0; i < calls.length; i++) {
      _ensureValidGenericCallTarget(calls[i].to);
    }

    // Ensure caller and/or supplied signatures are valid and increment nonce.
    (bytes32 actionID, uint256 nonce) = _validateActionAndIncrementNonce(
      ActionType.GenericAtomicBatch,
      abi.encode(calls),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Note: from this point on, there are no reverts (apart from out-of-gas or
    // call-depth-exceeded) originating from this contract. However, one of the
    // calls may revert, in which case the function will return `false`, along
    // with the revert reason encoded as bytes, and fire an CallFailure event.

    // Specify length of returned values in order to work with them in memory.
    ok = new bool[](calls.length);
    returnData = new bytes[](calls.length);

    // Set self-call context to call _executeActionWithAtomicBatchCallsAtomic.
    _selfCallContext = this.executeActionWithAtomicBatchCalls.selector;

    // Make the atomic self-call - if any call fails, calls that preceded it
    // will be rolled back and calls that follow it will not be made.
    (bool externalOk, bytes memory rawCallResults) = address(this).call(
      abi.encodeWithSelector(
        this._executeActionWithAtomicBatchCallsAtomic.selector, calls
      )
    );

    // Parse data returned from self-call into each call result and store / log.
    CallReturn[] memory callResults = abi.decode(rawCallResults, (CallReturn[]));
    for (uint256 i = 0; i < callResults.length; i++) {
      Call memory currentCall = calls[i];

      // Set the status and the return data / revert reason from the call.
      ok[i] = callResults[i].ok;
      returnData[i] = callResults[i].returnData;

      // Emit CallSuccess or CallFailure event based on the outcome of the call.
      if (callResults[i].ok) {
        // Note: while the call succeeded, the action may still have "failed"
        // (i.e. a successful calls to Compound can still return an error).
        emit CallSuccess(
          actionID,
          !externalOk, // if another call failed this will have been rolled back
          nonce,
          currentCall.to,
          currentCall.data,
          callResults[i].returnData
        );
      } else {
        // Note: while the call failed, the nonce will still be incremented,
        // which will invalidate all supplied signatures.
        emit CallFailure(
          actionID,
          nonce,
          currentCall.to,
          currentCall.data,
          string(callResults[i].returnData)
        );

        // exit early - any calls after the first failed call will not execute.
        break;
      }
    }
  }

  /**
   * @notice Protected function that can only be called from
   * `executeActionWithAtomicBatchCalls` on this contract. It will attempt to
   * perform each specified call, populating the array of results as it goes,
   * unless a failure occurs, at which point it will revert and "return" the
   * array of results as revert data. Otherwise, it will simply return the array
   * upon successful completion of each call. Finally, note that this function
   * must currently be implemented as a public function (instead of as an
   * external one) due to an ABIEncoderV2 `UnimplementedFeatureError`.
   * @param calls Call[] A struct containing the target and calldata to provide
   * when making each call.
   * @return An array of structs signifying the status of each call, as well as
   * any data returned from that call. Calls that are not executed will return
   * empty data. If any of the calls fail, the array will be returned as revert
   * data.
   */
  function _executeActionWithAtomicBatchCallsAtomic(
    Call[] memory calls
  ) public returns (CallReturn[] memory callResults) {
    // Ensure caller is this contract and self-call context is correctly set.
    _enforceSelfCallFrom(this.executeActionWithAtomicBatchCalls.selector);

    bool rollBack = false;
    callResults = new CallReturn[](calls.length);

    for (uint256 i = 0; i < calls.length; i++) {
      // Perform low-level call and set return values using result.
      (bool ok, bytes memory returnData) = calls[i].to.call(calls[i].data);
      callResults[i] = CallReturn({ok: ok, returnData: returnData});
      if (!ok) {
        // Exit early - any calls after the first failed call will not execute.
        rollBack = true;
        break;
      }
    }

    if (rollBack) {
      // Wrap in length encoding and revert (provide data instead of a string).
      bytes memory callResultsBytes = abi.encode(callResults);
      assembly { revert(add(32, callResultsBytes), mload(callResultsBytes)) }
    }
  }

  /**
   * @notice View function that, given an action type and arguments, will return
   * the action ID or message hash that will need to be prefixed (according to
   * EIP-191 0x45), hashed, and signed by both the user signing key and by the
   * key returned for this smart wallet by the Dharma Key Registry in order to
   * construct a valid signature for a given generic atomic batch action. The
   * current nonce will be used, which means that it will only be valid for the
   * next action taken. Finally, note that this function must currently be
   * implemented as a public function (instead of as an external one) due to an
   * ABIEncoderV2 `UnimplementedFeatureError`.
   * @param calls Call[] A struct containing the target and calldata to provide
   * when making each call.
   * @param calls Call[] A struct containing the target and calldata to provide
   * when making each call.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @return The action ID, which will need to be prefixed, hashed and signed in
   * order to construct a valid signature.
   */
  function getNextGenericAtomicBatchActionID(
    Call[] memory calls,
    uint256 minimumActionGas
  ) public view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _getActionID(
      ActionType.GenericAtomicBatch,
      abi.encode(calls),
      _nonce,
      minimumActionGas,
      _userSigningKey,
      _getDharmaSigningKey()
    );
  }

  /**
   * @notice View function that, given an action type and arguments, will return
   * the action ID or message hash that will need to be prefixed (according to
   * EIP-191 0x45), hashed, and signed by both the user signing key and by the
   * key returned for this smart wallet by the Dharma Key Registry in order to
   * construct a valid signature for a given generic atomic batch action. Any
   * nonce value may be supplied, which enables constructing valid message
   * hashes for multiple future actions ahead of time. Finally, note that this
   * function must currently be implemented as a public function (instead of as
   * an external one) due to an ABIEncoderV2 `UnimplementedFeatureError`.
   * @param calls Call[] A struct containing the target and calldata to provide
   * when making each call.
   * @param calls Call[] A struct containing the target and calldata to provide
   * when making each call.
   * @param nonce uint256 The nonce to use.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @return The action ID, which will need to be prefixed, hashed and signed in
   * order to construct a valid signature.
   */
  function getGenericAtomicBatchActionID(
    Call[] memory calls,
    uint256 nonce,
    uint256 minimumActionGas
  ) public view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _getActionID(
      ActionType.GenericAtomicBatch,
      abi.encode(calls),
      nonce,
      minimumActionGas,
      _userSigningKey,
      _getDharmaSigningKey()
    );
  }

  /**
   * @notice Internal function for setting a new user signing key. Called by the
   * initializer, by the `setUserSigningKey` function, and by the `recover`
   * function. A `NewUserSigningKey` event will also be emitted.
   * @param userSigningKey address The new user signing key to set on this smart
   * wallet.
   */
  function _setUserSigningKey(address userSigningKey) internal {
    // Ensure that a user signing key is set on this smart wallet.
    require(userSigningKey != address(0), "No user signing key provided.");

    _userSigningKey = userSigningKey;
    emit NewUserSigningKey(userSigningKey);
  }

  /**
   * @notice Internal function for converting a Sai balance to Dai. The total
   * amount of received Dai must be greater than or equal to the total amount of
   * swapped Sai.
   * @param saiToSwap uint256 The amount of Sai to swap.
   * @return The amount of Dai received as part of the swap.
   */
  function _swapSaiForDai(uint256 saiToSwap) internal returns (uint256 dai) {
    // If the balance is non-zero, check if migrator has adequate approval.
    if (saiToSwap > 0) {
      uint256 allowance = _SAI.allowance(address(this), address(_MIGRATOR));
      
      // Ensure that allowance is sufficient before calling the migrator.
      if (saiToSwap > allowance) {
        // Approve migrator contract to transfer Sai on behalf of this wallet.
        require(
          _SAI.approve(address(_MIGRATOR), uint256(-1)), "Sai approval failed."
        );
      }

      // Get the current Dai balance on this contract.
      uint256 currentDaiBalance = _DAI.balanceOf(address(this));

      // Call migrator contract to swap the supplied Sai balance for Dai.
      _MIGRATOR.swapSaiToDai(saiToSwap);

      // Return the difference between the pre-swap and post-swap Dai balances.
      dai = _DAI.balanceOf(address(this)) - currentDaiBalance;

      // Ensure that the Sai-to-Dai exchange rate was at least 1-to-1.
      require(dai >= saiToSwap, "Exchange rate cannot be below 1:1.");
    } else {
      // Explicitly specify a change in balance of zero if no swap occurred.
      dai = 0;
    }
  }

  /**
   * @notice Internal function for setting the allowance of a given ERC20 asset
   * to the maximum value. This enables the corresponding cToken for the asset
   * to pull in tokens in order to make deposits.
   * @param asset uint256 The ID of the asset, either Dai (0) or USDC (1).
   * @return True if the approval succeeded, otherwise false.
   */
  function _setFullApproval(AssetType asset) internal returns (bool ok) {
    // Get asset's underlying token address and corresponding cToken address.
    address token;
    address cToken;
    if (asset == AssetType.DAI) {
      token = address(_DAI);
      cToken = address(_CDAI);
    } else {
      token = address(_USDC);
      cToken = address(_CUSDC);
    }

    // Approve cToken contract to transfer underlying on behalf of this wallet.
    (ok, ) = address(token).call(abi.encodeWithSelector(
      // Note: since both cTokens have the same interface, just use cDAI's.
      _DAI.approve.selector, cToken, uint256(-1)
    ));

    // Emit a corresponding event if the approval failed.
    if (!ok) {
      if (asset == AssetType.DAI) {
        emit ExternalError(address(_DAI), "DAI contract reverted on approval.");
      } else {
        // Find out why USDC transfer reverted (it doesn't give revert reasons).
        _diagnoseAndEmitUSDCSpecificError(_USDC.approve.selector);
      }
    }
  }

  /**
   * @notice Internal function for depositing a given ERC20 asset and balance on
   * the corresponding cToken. No value is returned, as no additional steps need
   * to be conditionally performed after the deposit.
   * @param asset uint256 The ID of the asset, either Dai (0) or USDC (1).
   * @param balance uint256 The amount of the asset to deposit. Note that an
   * attempt to deposit "dust" (i.e. very small amounts) may result in 0 cTokens
   * being minted, or in fewer cTokens being minted than is implied by the
   * current exchange rate (due to lack of sufficient precision on the tokens).
   */
  function _depositOnCompound(AssetType asset, uint256 balance) internal {
    // Only perform a deposit if the balance is at least .001 Dai or USDC.
    if (
      asset == AssetType.DAI && balance > _JUST_UNDER_ONE_1000th_DAI ||
      asset == AssetType.USDC && balance > _JUST_UNDER_ONE_1000th_USDC
    ) {
      // Get cToken address for the asset type.
      address cToken = asset == AssetType.DAI ? address(_CDAI) : address(_CUSDC);

      // Attempt to mint the balance on the cToken contract.
      (bool ok, bytes memory data) = cToken.call(abi.encodeWithSelector(
        // Note: since both cTokens have the same interface, just use cDAI's.
        _CDAI.mint.selector, balance
      ));

      // Log an external error if something went wrong with the attempt.
      _checkCompoundInteractionAndLogAnyErrors(
        asset, _CDAI.mint.selector, ok, data
      );
    }
  }

  /**
   * @notice Internal function for withdrawing a given underlying asset balance
   * from the corresponding cToken. Note that the requested balance may not be
   * currently available on Compound, which will cause the withdrawal to fail.
   * @param asset uint256 The asset's ID, either Dai (0) or USDC (1).
   * @param balance uint256 The amount of the asset to withdraw, denominated in
   * the underlying token. Note that an attempt to withdraw "dust" (i.e. very
   * small amounts) may result in 0 underlying tokens being redeemed, or in
   * fewer tokens being redeemed than is implied by the current exchange rate
   * (due to lack of sufficient precision on the tokens).
   * @return True if the withdrawal succeeded, otherwise false.
   */
  function _withdrawFromCompound(
    AssetType asset,
    uint256 balance
  ) internal returns (bool success) {
    // Get cToken address for the asset type. (No custom ETH withdrawal action.)
    address cToken = asset == AssetType.DAI ? address(_CDAI) : address(_CUSDC);

    // Attempt to redeem the underlying balance from the cToken contract.
    (bool ok, bytes memory data) = cToken.call(abi.encodeWithSelector(
      // Note: function selector is the same for each cToken so just use cDAI's.
      _CDAI.redeemUnderlying.selector, balance
    ));

    // Log an external error if something went wrong with the attempt.
    success = _checkCompoundInteractionAndLogAnyErrors(
      asset, _CDAI.redeemUnderlying.selector, ok, data
    );
  }

  /**
   * @notice Internal function for withdrawing the total underlying asset
   * balance from the corresponding cToken. Note that the requested balance may
   * not be currently available on Compound, which will cause the withdrawal to
   * fail.
   * @param asset uint256 The asset's ID, either Dai (0), USDC (1), or Sai (3).
   */
  function _withdrawMaxFromCompound(AssetType asset) internal {
    // Get cToken address for the asset type. (No custom ETH withdrawal action.)
    address cToken = (
      asset == AssetType.DAI ? address(_CDAI) : (
        asset == AssetType.USDC ? address(_CUSDC) : address(_CSAI)
      )
    );

    // Get the current cToken balance for this account.
    uint256 redeemAmount = IERC20(cToken).balanceOf(address(this));

    // Only perform the call to redeem if there is a non-zero balance.
    if (redeemAmount > 0) {
      // Attempt to redeem the underlying balance from the cToken contract.
      (bool ok, bytes memory data) = cToken.call(abi.encodeWithSelector(
        // Function selector is the same for all cTokens, so just use cDAI's.
        _CDAI.redeem.selector, redeemAmount
      ));

      // Log an external error if something went wrong with the attempt.
      _checkCompoundInteractionAndLogAnyErrors(
        asset, _CDAI.redeem.selector, ok, data
      );
    }
  }

  /**
   * @notice Internal function for transferring the total underlying balance of
   * the corresponding token to a designated recipient. It will return true if
   * tokens were successfully transferred (or there is no balance), signified by
   * the boolean returned by the transfer function, or the call status if the
   * `suppressRevert` boolean is set to true.
   * @param token IERC20 The interface of the token in question.
   * @param recipient address The account that will receive the tokens.
   * @param suppressRevert bool A boolean indicating whether reverts should be
   * suppressed or not. Used by the escape hatch so that a problematic transfer
   * will not block the rest of the call from executing.
   * @return True if tokens were successfully transferred or if there is no
   * balance, else false.
   */
  function _transferMax(
    IERC20 token, address recipient, bool suppressRevert
  ) internal returns (bool success) {
    // Get the current balance on the smart wallet for the supplied ERC20 token.
    uint256 transferAmount = token.balanceOf(address(this));

    // Only perform the call to transfer if there is a non-zero balance.
    if (transferAmount > 0) {
      if (!suppressRevert) {
        // Perform the transfer and pass along the returned boolean (or revert).
        success = token.transfer(recipient, transferAmount);
      } else {
        // Attempt transfer with 1/2 gas, allow reverts, and return call status.
        (success, ) = address(token).call.gas(gasleft() / 2)(
          abi.encodeWithSelector(
            token.transfer.selector, recipient, transferAmount
          )
        );
      }
    } else {
      // Skip the transfer and return true.
      success = true;
    }
  }

  /**
   * @notice Internal function for transferring Ether to a designated recipient.
   * It will return true and emit an `EthWithdrawal` event if Ether was
   * successfully transferred - otherwise, it will return false and emit an
   * `ExternalError` event.
   * @param recipient address payable The account that will receive the Ether.
   * @param amount uint256 The amount of Ether to transfer.
   * @return True if Ether was successfully transferred, else false.
   */
  function _transferETH(
    address payable recipient, uint256 amount
  ) internal returns (bool success) {
    // Attempt to transfer any Ether to caller and emit an event if it fails.
    (success, ) = recipient.call.gas(_ETH_TRANSFER_GAS).value(amount)("");
    if (!success) {
      emit ExternalError(recipient, "Recipient rejected ether transfer.");
    } else {
      emit EthWithdrawal(amount, recipient);
    }
  }

  /**
   * @notice Internal function for validating supplied gas (if specified),
   * retrieving the signer's public key from the Dharma Key Registry, deriving
   * the action ID, validating the provided caller and/or signatures using that
   * action ID, and incrementing the nonce. This function serves as the
   * entrypoint for all protected "actions" on the smart wallet, and is the only
   * area where these functions should revert (other than due to out-of-gas
   * errors, which can be guarded against by supplying a minimum action gas
   * requirement).
   * @param action uint8 The type of action, designated by it's index. Valid
   * actions in V6 include Cancel (0), SetUserSigningKey (1), Generic (2),
   * GenericAtomicBatch (3), DAIWithdrawal (10), USDCWithdrawal (5),
   * ETHWithdrawal (6), SetEscapeHatch (7), RemoveEscapeHatch (8), and
   * DisableEscapeHatch (9).
   * @param arguments bytes ABI-encoded arguments for the action.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used. A unique hash returned from `getCustomActionID` is prefixed
   * and hashed to create the message hash for the signature.
   * @param dharmaSignature bytes A signature that resolves to the public key
   * returned for this account from the Dharma Key Registry. A unique hash
   * returned from `getCustomActionID` is prefixed and hashed to create the
   * signed message.
   * @return The nonce of the current action (prior to incrementing it).
   */
  function _validateActionAndIncrementNonce(
    ActionType action,
    bytes memory arguments,
    uint256 minimumActionGas,
    bytes memory userSignature,
    bytes memory dharmaSignature
  ) internal returns (bytes32 actionID, uint256 actionNonce) {
    // Ensure that the current gas exceeds the minimum required action gas.
    // This prevents griefing attacks where an attacker can invalidate a
    // signature without providing enough gas for the action to succeed. Also
    // note that some gas will be spent before this check is reached - supplying
    // ~30,000 additional gas should suffice when submitting transactions. To
    // skip this requirement, supply zero for the minimumActionGas argument.
    if (minimumActionGas != 0) {
      require(
        gasleft() >= minimumActionGas,
        "Invalid action - insufficient gas supplied by transaction submitter."
      );
    }

    // Get the current nonce for the action to be performed.
    actionNonce = _nonce;

    // Get the user signing key that will be used to verify their signature.
    address userSigningKey = _userSigningKey;

    // Get the Dharma signing key that will be used to verify their signature.
    address dharmaSigningKey = _getDharmaSigningKey();

    // Determine the actionID - this serves as the signature hash.
    actionID = _getActionID(
      action,
      arguments,
      actionNonce,
      minimumActionGas,
      userSigningKey,
      dharmaSigningKey
    );

    // Compute the message hash - the hashed, EIP-191-0x45-prefixed action ID.
    bytes32 messageHash = actionID.toEthSignedMessageHash();

    // Actions other than Cancel require both signatures; Cancel only needs one.
    if (action != ActionType.Cancel) {
      // Validate user signing key signature unless it is `msg.sender`.
      if (msg.sender != userSigningKey) {
        require(
          _validateUserSignature(
            messageHash, action, arguments, userSigningKey, userSignature
          ),
          "Invalid action - invalid user signature."
        );
      }

      // Validate Dharma signing key signature unless it is `msg.sender`.
      if (msg.sender != dharmaSigningKey) {
        require(
          dharmaSigningKey == messageHash.recover(dharmaSignature),
          "Invalid action - invalid Dharma signature."
        );
      }
    } else {
      // Validate signing key signature unless user or Dharma is `msg.sender`.
      if (msg.sender != userSigningKey && msg.sender != dharmaSigningKey) {
        require(
          dharmaSigningKey == messageHash.recover(dharmaSignature) ||
          _validateUserSignature(
            messageHash, action, arguments, userSigningKey, userSignature
          ),
          "Invalid action - invalid signature."
        );
      }
    }

    // Increment nonce in order to prevent reuse of signatures after the call.
    _nonce++;
  }

  /**
   * @notice Internal function to determine whether a call to a given cToken
   * succeeded, and to emit a relevant ExternalError event if it failed. The
   * failure can be caused by a call that reverts, or by a call that does not
   * revert but returns a non-zero error code.
   * @param asset uint256 The ID of the asset, either Dai (0) or USDC (1).
   * @param functionSelector bytes4 The function selector that was called on the
   * corresponding cToken of the asset type.
   * @param ok bool A boolean representing whether the call returned or
   * reverted.
   * @param data bytes The data provided by the returned or reverted call.
   * @return True if the interaction was successful, otherwise false. This will
   * be used to determine if subsequent steps in the action should be attempted
   * or not, specifically a transfer following a withdrawal.
   */
  function _checkCompoundInteractionAndLogAnyErrors(
    AssetType asset,
    bytes4 functionSelector,
    bool ok,
    bytes memory data
  ) internal returns (bool success) {
    // Log an external error if something went wrong with the attempt.
    if (ok) {
      uint256 compoundError = abi.decode(data, (uint256));
      if (compoundError != _COMPOUND_SUCCESS) {
        // Get called contract address, name of contract, and function name.
        (address account, string memory name, string memory functionName) = (
          _getCTokenDetails(asset, functionSelector)
        );

        emit ExternalError(
          account,
          string(
            abi.encodePacked(
              "Compound ",
              name,
              " contract returned error code ",
              uint8((compoundError / 10) + 48),
              uint8((compoundError % 10) + 48),
              " while attempting to call ",
              functionName,
              "."
            )
          )
        );
      } else {
        success = true;
      }
    } else {
      // Get called contract address, name of contract, and function name.
      (address account, string memory name, string memory functionName) = (
        _getCTokenDetails(asset, functionSelector)
      );

      // Decode the revert reason in the event one was returned.
      string memory revertReason = _decodeRevertReason(data);

      emit ExternalError(
        account,
        string(
          abi.encodePacked(
            "Compound ",
            name,
            " contract reverted while attempting to call ",
            functionName,
            ": ",
            revertReason
          )
        )
      );
    }
  }

  /**
   * @notice Internal function to diagnose the reason that a call to the USDC
   * contract failed and to emit a corresponding ExternalError event. USDC can
   * blacklist accounts and pause the contract, which can both cause a transfer
   * or approval to fail.
   * @param functionSelector bytes4 The function selector that was called on the
   * USDC contract.
   */
  function _diagnoseAndEmitUSDCSpecificError(bytes4 functionSelector) internal {
    // Determine the name of the function that was called on USDC.
    string memory functionName;
    if (functionSelector == _USDC.transfer.selector) {
      functionName = "transfer";
    } else {
      functionName = "approve";
    }

    // Find out why USDC transfer reverted (it doesn't give revert reasons).
    if (_USDC_NAUGHTY.isBlacklisted(address(this))) {
      emit ExternalError(
        address(_USDC),
        string(
          abi.encodePacked(
            functionName, " failed - USDC has blacklisted this user."
          )
        )
      );
    } else { // Note: `else if` breaks coverage.
      if (_USDC_NAUGHTY.paused()) {
        emit ExternalError(
          address(_USDC),
          string(
            abi.encodePacked(
              functionName, " failed - USDC contract is currently paused."
            )
          )
        );
      } else {
        emit ExternalError(
          address(_USDC),
          string(
            abi.encodePacked(
              "USDC contract reverted on ", functionName, "."
            )
          )
        );
      }
    }
  }

  /**
   * @notice Internal function to ensure that protected functions can only be
   * called from this contract and that they have the appropriate context set.
   * The self-call context is then cleared. It is used as an additional guard
   * against reentrancy, especially once generic actions are supported by the
   * smart wallet in future versions.
   * @param selfCallContext bytes4 The expected self-call context, equal to the
   * function selector of the approved calling function.
   */
  function _enforceSelfCallFrom(bytes4 selfCallContext) internal {
    // Ensure caller is this contract and self-call context is correctly set.
    require(
      msg.sender == address(this) &&
      _selfCallContext == selfCallContext,
      "External accounts or unapproved internal functions cannot call this."
    );

    // Clear the self-call context.
    delete _selfCallContext;
  }

  /**
   * @notice Internal view function for validating a user's signature. If the
   * user's signing key does not have contract code, it will be validated via
   * ecrecover; otherwise, it will be validated using ERC-1271, passing the
   * message hash that was signed, the action type, and the arguments as data.
   * @param messageHash bytes32 The message hash that is signed by the user. It
   * is derived by prefixing (according to EIP-191 0x45) and hashing an actionID
   * returned from `getCustomActionID`.
   * @param action uint8 The type of action, designated by it's index. Valid
   * actions in V6 include Cancel (0), SetUserSigningKey (1), Generic (2),
   * GenericAtomicBatch (3), DAIWithdrawal (10), USDCWithdrawal (5),
   * ETHWithdrawal (6), SetEscapeHatch (7), RemoveEscapeHatch (8), and
   * DisableEscapeHatch (9).
   * @param arguments bytes ABI-encoded arguments for the action.
   * @param userSignature bytes A signature that resolves to the public key
   * set for this account in storage slot zero, `_userSigningKey`. If the user
   * signing key is not a contract, ecrecover will be used; otherwise, ERC1271
   * will be used.
   * @return A boolean representing the validity of the supplied user signature.
   */
  function _validateUserSignature(
    bytes32 messageHash,
    ActionType action,
    bytes memory arguments,
    address userSigningKey,
    bytes memory userSignature
  ) internal view returns (bool valid) {
    if (!userSigningKey.isContract()) {
      valid = userSigningKey == messageHash.recover(userSignature);
    } else {
      bytes memory data = abi.encode(messageHash, action, arguments);
      valid = (
        ERC1271(userSigningKey).isValidSignature(
          data, userSignature
        ) == _ERC_1271_MAGIC_VALUE
      );
    }
  }

  /**
   * @notice Internal view function to get the Dharma signing key for the smart
   * wallet from the Dharma Key Registry. This key can be set for each specific
   * smart wallet - if none has been set, a global fallback key will be used.
   * @return The address of the Dharma signing key, or public key corresponding
   * to the secondary signer.
   */
  function _getDharmaSigningKey() internal view returns (
    address dharmaSigningKey
  ) {
    dharmaSigningKey = _DHARMA_KEY_REGISTRY.getKey();
  }

  /**
   * @notice Internal view function that, given an action type and arguments,
   * will return the action ID or message hash that will need to be prefixed
   * (according to EIP-191 0x45), hashed, and signed by the key designated by
   * the Dharma Key Registry in order to construct a valid signature for the
   * corresponding action. The current nonce will be supplied to this function
   * when reconstructing an action ID during protected function execution based
   * on the supplied parameters.
   * @param action uint8 The type of action, designated by it's index. Valid
   * actions in V6 include Cancel (0), SetUserSigningKey (1), Generic (2),
   * GenericAtomicBatch (3), DAIWithdrawal (10), USDCWithdrawal (5),
   * ETHWithdrawal (6), SetEscapeHatch (7), RemoveEscapeHatch (8), and
   * DisableEscapeHatch (9).
   * @param arguments bytes ABI-encoded arguments for the action.
   * @param nonce uint256 The nonce to use.
   * @param minimumActionGas uint256 The minimum amount of gas that must be
   * provided to this call - be aware that additional gas must still be included
   * to account for the cost of overhead incurred up until the start of this
   * function call.
   * @param dharmaSigningKey address The address of the secondary key, or public
   * key corresponding to the secondary signer.
   * @return The action ID, which will need to be prefixed, hashed and signed in
   * order to construct a valid signature.
   */
  function _getActionID(
    ActionType action,
    bytes memory arguments,
    uint256 nonce,
    uint256 minimumActionGas,
    address userSigningKey,
    address dharmaSigningKey
  ) internal view returns (bytes32 actionID) {
    // actionID is constructed according to EIP-191-0x45 to prevent replays.
    actionID = keccak256(
      abi.encodePacked(
        address(this),
        _DHARMA_SMART_WALLET_VERSION,
        userSigningKey,
        dharmaSigningKey,
        nonce,
        minimumActionGas,
        action,
        arguments
      )
    );
  }

  /**
   * @notice Internal pure function to get the cToken address, it's name, and
   * the name of the called function, based on a supplied asset type and
   * function selector. It is used to help construct ExternalError events.
   * @param asset uint256 The ID of the asset, either Dai (0) or USDC (1).
   * @param functionSelector bytes4 The function selector that was called on the
   * corresponding cToken of the asset type.
   * @return The cToken address, it's name, and the name of the called function.
   */
  function _getCTokenDetails(
    AssetType asset,
    bytes4 functionSelector
  ) internal pure returns (
    address account,
    string memory name,
    string memory functionName
  ) {
    if (asset == AssetType.DAI) {
      account = address(_CDAI);
      name = "cDAI";
    } else {
      account = address(_CUSDC);
      name = "cUSDC";
    }

    // Note: since both cTokens have the same interface, just use cDAI's.
    if (functionSelector == _CDAI.mint.selector) {
      functionName = "mint";
    } else {
      functionName = string(abi.encodePacked(
        "redeem",
        functionSelector == _CDAI.redeemUnderlying.selector ? "Underlying" : ""
      ));
    }
  }

  /**
   * @notice Internal view function to ensure that a given `to` address provided
   * as part of a generic action is valid. Calls cannot be performed to accounts
   * without code or back into the smart wallet itself. Additionally, generic
   * calls cannot supply the address of the Dharma Escape Hatch registry - the
   * specific, designated functions must be used in order to make calls into it.
   * @param to address The address that will be targeted by the generic call.
   */
  function _ensureValidGenericCallTarget(address to) internal view {
    require(
      to.isContract(),
      "Invalid `to` parameter - must supply a contract address containing code."
    );

    require(
      to != address(this),
      "Invalid `to` parameter - cannot supply the address of this contract."
    );

    require(
      to != address(_ESCAPE_HATCH_REGISTRY),
      "Invalid `to` parameter - cannot supply the Dharma Escape Hatch Registry."
    );
  }

  /**
   * @notice Internal pure function to ensure that a given action type is a
   * "custom" action type (i.e. is not a generic action type) and to construct
   * the "arguments" input to an actionID based on that action type.
   * @param action uint8 The type of action, designated by it's index. Valid
   * custom actions in V6 include Cancel (0), SetUserSigningKey (1),
   * DAIWithdrawal (10), USDCWithdrawal (5), ETHWithdrawal (6),
   * SetEscapeHatch (7), RemoveEscapeHatch (8), and DisableEscapeHatch (9).
   * @param amount uint256 The amount to withdraw for Withdrawal actions. This
   * value is ignored for all non-withdrawal action types.
   * @param recipient address The account to transfer withdrawn funds to or the
   * new user signing key. This value is ignored for Cancel, RemoveEscapeHatch,
   * and DisableEscapeHatch action types.
   * @return A bytes array containing the arguments that will be provided as
   * a component of the inputs when constructing a custom action ID.
   */
  function _validateCustomActionTypeAndGetArguments(
    ActionType action, uint256 amount, address recipient
  ) internal pure returns (bytes memory arguments) {
    // Ensure that the action type is a valid custom action type.
    require(
      action == ActionType.Cancel ||
      action == ActionType.SetUserSigningKey ||
      action == ActionType.DAIWithdrawal ||
      action == ActionType.USDCWithdrawal ||
      action == ActionType.ETHWithdrawal ||
      action == ActionType.SetEscapeHatch ||
      action == ActionType.RemoveEscapeHatch ||
      action == ActionType.DisableEscapeHatch,
      "Invalid custom action type."
    );

    // Use action type to determine parameters to include in returned arguments.
    if (
      action == ActionType.Cancel ||
      action == ActionType.RemoveEscapeHatch ||
      action == ActionType.DisableEscapeHatch
    ) {
      // Ignore parameters for Cancel, RemoveEscapeHatch, or DisableEscapeHatch.
      arguments = abi.encode();
    } else if (
      action == ActionType.SetUserSigningKey ||
      action == ActionType.SetEscapeHatch
    ) {
      // Ignore `amount` parameter for other, non-withdrawal actions.
      arguments = abi.encode(recipient);
    } else {
      // Use both `amount` and `recipient` parameters for withdrawals.
      arguments = abi.encode(amount, recipient);
    }
  }

  /**
   * @notice Internal pure function to decode revert reasons. The revert reason
   * prefix is removed and the remaining string argument is decoded.
   * @param revertData bytes The raw data supplied alongside the revert.
   * @return The decoded revert reason string.
   */
  function _decodeRevertReason(
    bytes memory revertData
  ) internal pure returns (string memory revertReason) {
    // Solidity prefixes revert reason with 0x08c379a0 -> Error(string) selector
    if (
      revertData.length > 68 && // prefix (4) + position (32) + length (32)
      revertData[0] == byte(0x08) &&
      revertData[1] == byte(0xc3) &&
      revertData[2] == byte(0x79) &&
      revertData[3] == byte(0xa0)
    ) {
      // Get the revert reason without the prefix from the revert data.
      bytes memory revertReasonBytes = new bytes(revertData.length - 4);
      for (uint256 i = 4; i < revertData.length; i++) {
        revertReasonBytes[i - 4] = revertData[i];
      }

      // Decode the resultant revert reason as a string.
      revertReason = abi.decode(revertReasonBytes, (string));
    } else {
      // Simply return the default, with no revert reason.
      revertReason = "(no revert reason)";
    }
  }
}