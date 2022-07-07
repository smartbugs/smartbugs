                                                                 

pragma solidity 0.5.17; // optimization runs: 200, evm version: istanbul
// WARNING - `executeActionWithAtomicBatchCalls` has a `bytes[]` argument that
// requires ABIEncoderV2. Exercise caution when calling that specific function.
pragma experimental ABIEncoderV2;


interface DharmaSmartWalletImplementationV1Interface {
  event CALLSUCCESS383(	//inject NONSTANDARD NAMING
    bytes32 actionID,
    bool rolledBack,
    uint256 nonce,
    address to,
    bytes data,
    bytes returnData
  );

  event CALLFAILURE442(	//inject NONSTANDARD NAMING
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

  function WITHDRAWETHER963(	//inject NONSTANDARD NAMING
    uint256 amount,
    address payable recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok);

  function EXECUTEACTION770(	//inject NONSTANDARD NAMING
    address to,
    bytes calldata data,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok, bytes memory returnData);

  function RECOVER845(address newUserSigningKey) external;	//inject NONSTANDARD NAMING

  function EXECUTEACTIONWITHATOMICBATCHCALLS418(	//inject NONSTANDARD NAMING
    Call[] calldata calls,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool[] memory ok, bytes[] memory returnData);

  function GETNEXTGENERICACTIONID981(	//inject NONSTANDARD NAMING
    address to,
    bytes calldata data,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function GETGENERICACTIONID781(	//inject NONSTANDARD NAMING
    address to,
    bytes calldata data,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function GETNEXTGENERICATOMICBATCHACTIONID957(	//inject NONSTANDARD NAMING
    Call[] calldata calls,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function GETGENERICATOMICBATCHACTIONID98(	//inject NONSTANDARD NAMING
    Call[] calldata calls,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);
}


interface DharmaSmartWalletImplementationV3Interface {
  event CANCEL692(uint256 cancelledNonce);	//inject NONSTANDARD NAMING
  event ETHWITHDRAWAL175(uint256 amount, address recipient);	//inject NONSTANDARD NAMING
}


interface DharmaSmartWalletImplementationV4Interface {
  event ESCAPED27();	//inject NONSTANDARD NAMING

  function SETESCAPEHATCH554(	//inject NONSTANDARD NAMING
    address account,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external;

  function REMOVEESCAPEHATCH653(	//inject NONSTANDARD NAMING
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external;

  function PERMANENTLYDISABLEESCAPEHATCH796(	//inject NONSTANDARD NAMING
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external;

  function ESCAPE232() external;	//inject NONSTANDARD NAMING
}


interface DharmaSmartWalletImplementationV7Interface {
  // Fires when a new user signing key is set on the smart wallet.
  event NEWUSERSIGNINGKEY833(address userSigningKey);	//inject NONSTANDARD NAMING

  // Fires when an error occurs as part of an attempted action.
  event EXTERNALERROR24(address indexed source, string revertReason);	//inject NONSTANDARD NAMING

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
    SignatureVerification,
    TradeEthForDai,
    DAIBorrow,
    USDCBorrow
  }

  function INITIALIZE336(address userSigningKey) external;	//inject NONSTANDARD NAMING

  function REPAYANDDEPOSIT967() external;	//inject NONSTANDARD NAMING

  function WITHDRAWDAI449(	//inject NONSTANDARD NAMING
    uint256 amount,
    address recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok);

  function WITHDRAWUSDC811(	//inject NONSTANDARD NAMING
    uint256 amount,
    address recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok);

  function CANCEL991(	//inject NONSTANDARD NAMING
    uint256 minimumActionGas,
    bytes calldata signature
  ) external;

  function SETUSERSIGNINGKEY240(	//inject NONSTANDARD NAMING
    address userSigningKey,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external;

  function MIGRATESAITODAI522() external;	//inject NONSTANDARD NAMING

  function MIGRATECSAITODDAI208() external;	//inject NONSTANDARD NAMING

  function MIGRATECDAITODDAI660() external;	//inject NONSTANDARD NAMING

  function MIGRATECUSDCTODUSDC400() external;	//inject NONSTANDARD NAMING

  function GETBALANCES53() external view returns (	//inject NONSTANDARD NAMING
    uint256 daiBalance,
    uint256 usdcBalance,
    uint256 etherBalance,
    uint256 dDaiUnderlyingDaiBalance,
    uint256 dUsdcUnderlyingUsdcBalance,
    uint256 dEtherUnderlyingEtherBalance // always returns zero
  );

  function GETUSERSIGNINGKEY63() external view returns (address userSigningKey);	//inject NONSTANDARD NAMING

  function GETNONCE95() external view returns (uint256 nonce);	//inject NONSTANDARD NAMING

  function GETNEXTCUSTOMACTIONID792(	//inject NONSTANDARD NAMING
    ActionType action,
    uint256 amount,
    address recipient,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function GETCUSTOMACTIONID90(	//inject NONSTANDARD NAMING
    ActionType action,
    uint256 amount,
    address recipient,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function GETVERSION901() external pure returns (uint256 version);	//inject NONSTANDARD NAMING
}


interface DharmaSmartWalletImplementationV8Interface {
  function TRADEETHFORDAIANDMINTDDAI339(	//inject NONSTANDARD NAMING
    uint256 ethToSupply,
    uint256 minimumDaiReceived,
    address target,
    bytes calldata data,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok, bytes memory returnData);

  function GETNEXTETHFORDAIACTIONID361(	//inject NONSTANDARD NAMING
    uint256 ethToSupply,
    uint256 minimumDaiReceived,
    address target,
    bytes calldata data,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);

  function GETETHFORDAIACTIONID368(	//inject NONSTANDARD NAMING
    uint256 ethToSupply,
    uint256 minimumDaiReceived,
    address target,
    bytes calldata data,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID);
}


interface ERC20Interface {
  function TRANSFER153(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING
  function APPROVE270(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

  function BALANCEOF992(address account) external view returns (uint256);	//inject NONSTANDARD NAMING
  function ALLOWANCE583(	//inject NONSTANDARD NAMING
    address owner, address spender
  ) external view returns (uint256);
}


interface ERC1271Interface {
  function ISVALIDSIGNATURE229(	//inject NONSTANDARD NAMING
    bytes calldata data, bytes calldata signature
  ) external view returns (bytes4 magicValue);
}


interface CTokenInterface {
  function REDEEM466(uint256 redeemAmount) external returns (uint256 err);	//inject NONSTANDARD NAMING
  function TRANSFER153(address recipient, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
  function APPROVE270(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

  function BALANCEOF992(address account) external view returns (uint256 balance);	//inject NONSTANDARD NAMING
  function ALLOWANCE583(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
}


interface DTokenInterface {
  // These external functions trigger accrual on the dToken and backing cToken.
  function MINT76(uint256 underlyingToSupply) external returns (uint256 dTokensMinted);	//inject NONSTANDARD NAMING
  function REDEEM466(uint256 dTokensToBurn) external returns (uint256 underlyingReceived);	//inject NONSTANDARD NAMING
  function REDEEMUNDERLYING215(uint256 underlyingToReceive) external returns (uint256 dTokensBurned);	//inject NONSTANDARD NAMING

  // These external functions only trigger accrual on the dToken.
  function MINTVIACTOKEN796(uint256 cTokensToSupply) external returns (uint256 dTokensMinted);	//inject NONSTANDARD NAMING

  // View and pure functions do not trigger accrual on the dToken or the cToken.
  function BALANCEOFUNDERLYING317(address account) external view returns (uint256 underlyingBalance);	//inject NONSTANDARD NAMING
}


interface USDCV1Interface {
  function ISBLACKLISTED453(address _account) external view returns (bool);	//inject NONSTANDARD NAMING
  function PAUSED117() external view returns (bool);	//inject NONSTANDARD NAMING
}


interface DharmaKeyRegistryInterface {
  function GETKEY781() external view returns (address key);	//inject NONSTANDARD NAMING
}


interface DharmaEscapeHatchRegistryInterface {
  function SETESCAPEHATCH554(address newEscapeHatch) external;	//inject NONSTANDARD NAMING

  function REMOVEESCAPEHATCH653() external;	//inject NONSTANDARD NAMING

  function PERMANENTLYDISABLEESCAPEHATCH796() external;	//inject NONSTANDARD NAMING

  function GETESCAPEHATCH697() external view returns (	//inject NONSTANDARD NAMING
    bool exists, address escapeHatch
  );
}


interface TradeHelperInterface {
  function TRADEETHFORDAI848(	//inject NONSTANDARD NAMING
    uint256 daiExpected, address target, bytes calldata data
  ) external payable returns (uint256 daiReceived);
}


interface RevertReasonHelperInterface {
  function REASON113(uint256 code) external pure returns (string memory);	//inject NONSTANDARD NAMING
}


interface EtherizedInterface {
  function TRIGGERETHERTRANSFER345(	//inject NONSTANDARD NAMING
    address payable target, uint256 value
  ) external returns (bool success);
}


interface ConfigurationRegistryInterface {
  function GET761(bytes32 key) external view returns (bytes32 value);	//inject NONSTANDARD NAMING
}


library Address {
  function ISCONTRACT235(address account) internal view returns (bool) {	//inject NONSTANDARD NAMING
    uint256 size;
    assembly { size := extcodesize(account) }
    return size > 0;
  }
}


library ECDSA {
  function RECOVER845(	//inject NONSTANDARD NAMING
    bytes32 hash, bytes memory signature
  ) internal pure returns (address) {
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

  function TOETHSIGNEDMESSAGEHASH603(bytes32 hash) internal pure returns (bytes32) {	//inject NONSTANDARD NAMING
    return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
  }
}


contract Etherized is EtherizedInterface {
  address private constant _etherizer294 = address(	//inject NONSTANDARD NAMING
    0x723B51b72Ae89A3d0c2a2760f0458307a1Baa191 
  );
  
  function TRIGGERETHERTRANSFER345(	//inject NONSTANDARD NAMING
    address payable target, uint256 amount
  ) external returns (bool success) {
    require(msg.sender == _etherizer294, "Etherized: only callable by Etherizer");
    (success, ) = target.call.value(amount)("");
    if (!success) {
      assembly {
        returndatacopy(0, 0, returndatasize())
        revert(0, returndatasize())
      }
    }
  }
}


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
contract DharmaSmartWalletImplementationV11Staging is
  DharmaSmartWalletImplementationV1Interface,
  DharmaSmartWalletImplementationV3Interface,
  DharmaSmartWalletImplementationV4Interface,
  DharmaSmartWalletImplementationV7Interface,
  DharmaSmartWalletImplementationV8Interface,
  ERC1271Interface,
  Etherized {
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
  uint256 internal constant _dharma_smart_wallet_version295 = 1011;	//inject NONSTANDARD NAMING

  // DharmaKeyRegistryV2Staging holds a public key to verify meta-transactions.
  DharmaKeyRegistryInterface internal constant _dharma_key_registry438 = (	//inject NONSTANDARD NAMING
    DharmaKeyRegistryInterface(0x00000000006c7f32F0cD1eA4C1383558eb68802D)
  );
  // Account recovery uses a hard-coded staging version of the recovery manager.
  address internal constant _account_recovery_manager816 = address(	//inject NONSTANDARD NAMING
    0x2a7E7718b755F9868E6B64DD18C6886707DD9c10
  );

  // Users can designate an "escape hatch" account with the ability to sweep all
  // funds from their smart wallet by using the Dharma Escape Hatch Registry.
  DharmaEscapeHatchRegistryInterface internal constant _escape_hatch_registry980 = (	//inject NONSTANDARD NAMING
    DharmaEscapeHatchRegistryInterface(0x00000000005280B515004B998a944630B6C663f8)
  );

  // Interface with dDai, dUSDC, Dai, USDC, Sai, cSai, cDai, cUSDC, & migrator.
  DTokenInterface internal constant _ddai406 = DTokenInterface(	//inject NONSTANDARD NAMING
    0x00000000001876eB1444c986fD502e618c587430 // mainnet
  );

  DTokenInterface internal constant _dusdc174 = DTokenInterface(	//inject NONSTANDARD NAMING
    0x00000000008943c65cAf789FFFCF953bE156f6f8 // mainnet
  );

  ERC20Interface internal constant _dai860 = ERC20Interface(	//inject NONSTANDARD NAMING
    0x6B175474E89094C44Da98b954EedeAC495271d0F // mainnet
  );

  ERC20Interface internal constant _usdc146 = ERC20Interface(	//inject NONSTANDARD NAMING
    0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // mainnet
  );

  CTokenInterface internal constant _cdai443 = CTokenInterface(	//inject NONSTANDARD NAMING
    0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643 // mainnet
  );

  CTokenInterface internal constant _cusdc481 = CTokenInterface(	//inject NONSTANDARD NAMING
    0x39AA39c021dfbaE8faC545936693aC917d5E7563 // mainnet
  );
  
  // The "trade helper" facilitates Eth-to-Dai trades in an isolated context.
  TradeHelperInterface internal constant _trade_helper427 = TradeHelperInterface(	//inject NONSTANDARD NAMING
    0x421816CDFe2073945173c0c35799ec21261fB399
  );

  // The "revert reason helper" contains a collection of revert reason strings.
  RevertReasonHelperInterface internal constant _revert_reason_helper415 = (	//inject NONSTANDARD NAMING
    RevertReasonHelperInterface(0x9C0ccB765D3f5035f8b5Dd30fE375d5F4997D8E4)
  );
  
  ConfigurationRegistryInterface internal constant _config_registry519 = (	//inject NONSTANDARD NAMING
    ConfigurationRegistryInterface(0xC5C0ead7Df3CeFC45c8F4592E3a0f1500949E75D)
  );
  
  bytes32 internal constant _enable_usdc_minting_key536 = bytes32(	//inject NONSTANDARD NAMING
    0x596746115f08448433597980d42b4541c0197187d07ffad9c7f66a471c49dbba
  ); // keccak256("allowAvailableUSDCToBeUsedToMintCUSDC")

  // Compound returns a value of 0 to indicate success, or lack of an error.
  uint256 internal constant _compound_success452 = 0;	//inject NONSTANDARD NAMING

  // ERC-1271 must return this magic value when `isValidSignature` is called.
  bytes4 internal constant _erc_1271_magic_value586 = bytes4(0x20c13b0b);	//inject NONSTANDARD NAMING

  // Minimum supported deposit & non-maximum withdrawal size is .001 underlying.
  uint256 private constant _just_under_one_1000th_dai594 = 999999999999999;	//inject NONSTANDARD NAMING
  uint256 private constant _just_under_one_1000th_usdc382 = 999;	//inject NONSTANDARD NAMING

  // Specify the amount of gas to supply when making Ether transfers.
  uint256 private constant _eth_transfer_gas33 = 4999;	//inject NONSTANDARD NAMING
  
  constructor() public {
    assert(
      _enable_usdc_minting_key536 == keccak256(
        bytes("allowAvailableUSDCToBeUsedToMintCUSDC")
      )
    );
  }

                                                      
  function () external payable {}

                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
  function INITIALIZE336(address userSigningKey) external {	//inject NONSTANDARD NAMING
    // Ensure that this function is only callable during contract construction.
    assembly { if extcodesize(address) { revert(0, 0) } }

    // Set up the user's signing key and emit a corresponding event.
    _SETUSERSIGNINGKEY543(userSigningKey);

    // Approve the dDai contract to transfer Dai on behalf of this contract.
    if (_SETFULLAPPROVAL629(AssetType.DAI)) {
      // Get the current Dai balance on this contract.
      uint256 daiBalance = _dai860.BALANCEOF992(address(this));

      // Try to deposit the full Dai balance to Dharma Dai.
      _DEPOSITDHARMATOKEN821(AssetType.DAI, daiBalance);
    }

    // Approve the dUSDC contract to transfer USDC on behalf of this contract.
    if (_SETFULLAPPROVAL629(AssetType.USDC)) {
      // Get the current USDC balance on this contract.
      uint256 usdcBalance = _usdc146.BALANCEOF992(address(this));

      // Try to deposit the full Dai balance to Dharma USDC.
      _DEPOSITDHARMATOKEN821(AssetType.USDC, usdcBalance);
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                   
  function REPAYANDDEPOSIT967() external {	//inject NONSTANDARD NAMING
    // Get the current Dai balance on this contract.
    uint256 daiBalance = _dai860.BALANCEOF992(address(this));

    // If there is any Dai balance, check for adequate approval for dDai.
    if (daiBalance > 0) {
      uint256 daiAllowance = _dai860.ALLOWANCE583(address(this), address(_ddai406));
      // If allowance is insufficient, try to set it before depositing.
      if (daiAllowance < daiBalance) {
        if (_SETFULLAPPROVAL629(AssetType.DAI)) {
          // Deposit the full available Dai balance to Dharma Dai.
          _DEPOSITDHARMATOKEN821(AssetType.DAI, daiBalance);
        }
      // Otherwise, just go ahead and try the Dai deposit.
      } else {
        // Deposit the full available Dai balance to Dharma Dai.
        _DEPOSITDHARMATOKEN821(AssetType.DAI, daiBalance);
      }
    }

    // Get the current USDC balance on this contract.
    uint256 usdcBalance = _usdc146.BALANCEOF992(address(this));

    // If there is any USDC balance, check for adequate approval for dUSDC.
    if (usdcBalance > 0) {
      uint256 usdcAllowance = _usdc146.ALLOWANCE583(address(this), address(_dusdc174));
      // If allowance is insufficient, try to set it before depositing.
      if (usdcAllowance < usdcBalance) {
        if (_SETFULLAPPROVAL629(AssetType.USDC)) {
          // Deposit the full available USDC balance to Dharma USDC.
          _DEPOSITDHARMATOKEN821(AssetType.USDC, usdcBalance);
        }
      // Otherwise, just go ahead and try the USDC deposit.
      } else {
        // Deposit the full available USDC balance to Dharma USDC.
        _DEPOSITDHARMATOKEN821(AssetType.USDC, usdcBalance);
      }
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
  function WITHDRAWDAI449(	//inject NONSTANDARD NAMING
    uint256 amount,
    address recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok) {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _VALIDATEACTIONANDINCREMENTNONCE883(
      ActionType.DAIWithdrawal,
      abi.encode(amount, recipient),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Ensure that an amount of at least 0.001 Dai has been supplied.
    if (amount <= _just_under_one_1000th_dai594) {
      revert(_REVERTREASON31(0));
    }

    // Ensure that a non-zero recipient has been supplied.
    if (recipient == address(0)) {
      revert(_REVERTREASON31(1));
    }

    // Set the self-call context in order to call _withdrawDaiAtomic.
    _selfCallContext = this.WITHDRAWDAI449.selector;

    // Make the atomic self-call - if redeemUnderlying fails on dDai, it will
    // succeed but nothing will happen except firing an ExternalError event. If
    // the second part of the self-call (the Dai transfer) fails, it will revert
    // and roll back the first part of the call as well as fire an ExternalError
    // event after returning from the failed call.
    bytes memory returnData;
    (ok, returnData) = address(this).call(abi.encodeWithSelector(
      this._WITHDRAWDAIATOMIC5.selector, amount, recipient
    ));

    // If the atomic call failed, emit an event signifying a transfer failure.
    if (!ok) {
      emit EXTERNALERROR24(address(_dai860), _REVERTREASON31(2));
    } else {
      // Set ok to false if the call succeeded but the withdrawal failed.
      ok = abi.decode(returnData, (bool));
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  function _WITHDRAWDAIATOMIC5(	//inject NONSTANDARD NAMING
    uint256 amount,
    address recipient
  ) external returns (bool success) {
    // Ensure caller is this contract and self-call context is correctly set.
    _ENFORCESELFCALLFROM836(this.WITHDRAWDAI449.selector);

    // If amount = 0xfff...fff, withdraw the maximum amount possible.
    bool maxWithdraw = (amount == uint256(-1));
    if (maxWithdraw) {
      // First attempt to redeem all dDai if there is a balance.
      _WITHDRAWMAXFROMDHARMATOKEN348(AssetType.DAI);

      // Then transfer all Dai to recipient if there is a balance.
      require(_TRANSFERMAX629(_dai860, recipient, false));
      success = true;
    } else {
      // Attempt to withdraw specified Dai from Dharma Dai before proceeding.
      if (_WITHDRAWFROMDHARMATOKEN513(AssetType.DAI, amount)) {
        // At this point Dai transfer should never fail - wrap it just in case.
        require(_dai860.TRANSFER153(recipient, amount));
        success = true;
      }
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function WITHDRAWUSDC811(	//inject NONSTANDARD NAMING
    uint256 amount,
    address recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok) {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _VALIDATEACTIONANDINCREMENTNONCE883(
      ActionType.USDCWithdrawal,
      abi.encode(amount, recipient),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Ensure that an amount of at least 0.001 USDC has been supplied.
    if (amount <= _just_under_one_1000th_usdc382) {
      revert(_REVERTREASON31(3));
    }

    // Ensure that a non-zero recipient has been supplied.
    if (recipient == address(0)) {
      revert(_REVERTREASON31(1));
    }

    // Set the self-call context in order to call _withdrawUSDCAtomic.
    _selfCallContext = this.WITHDRAWUSDC811.selector;

    // Make the atomic self-call - if redeemUnderlying fails on dUSDC, it will
    // succeed but nothing will happen except firing an ExternalError event. If
    // the second part of the self-call (USDC transfer) fails, it will revert
    // and roll back the first part of the call as well as fire an ExternalError
    // event after returning from the failed call.
    bytes memory returnData;
    (ok, returnData) = address(this).call(abi.encodeWithSelector(
      this._WITHDRAWUSDCATOMIC942.selector, amount, recipient
    ));
    if (!ok) {
      // Find out why USDC transfer reverted (doesn't give revert reasons).
      _DIAGNOSEANDEMITUSDCSPECIFICERROR976(_usdc146.TRANSFER153.selector);
    } else {
      // Set ok to false if the call succeeded but the withdrawal failed.
      ok = abi.decode(returnData, (bool));
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function _WITHDRAWUSDCATOMIC942(	//inject NONSTANDARD NAMING
    uint256 amount,
    address recipient
  ) external returns (bool success) {
    // Ensure caller is this contract and self-call context is correctly set.
    _ENFORCESELFCALLFROM836(this.WITHDRAWUSDC811.selector);

    // If amount = 0xfff...fff, withdraw the maximum amount possible.
    bool maxWithdraw = (amount == uint256(-1));
    if (maxWithdraw) {
      // Attempt to redeem all dUSDC from Dharma USDC if there is a balance.
      _WITHDRAWMAXFROMDHARMATOKEN348(AssetType.USDC);

      // Then transfer all USDC to recipient if there is a balance.
      require(_TRANSFERMAX629(_usdc146, recipient, false));
      success = true;
    } else {
      // Attempt to withdraw specified USDC from Dharma USDC before proceeding.
      if (_WITHDRAWFROMDHARMATOKEN513(AssetType.USDC, amount)) {
        // Ensure that the USDC transfer does not fail.
        require(_usdc146.TRANSFER153(recipient, amount));
        success = true;
      }
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function WITHDRAWETHER963(	//inject NONSTANDARD NAMING
    uint256 amount,
    address payable recipient,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok) {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _VALIDATEACTIONANDINCREMENTNONCE883(
      ActionType.ETHWithdrawal,
      abi.encode(amount, recipient),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Ensure that a non-zero amount of Ether has been supplied.
    if (amount == 0) {
      revert(_REVERTREASON31(4));
    }

    // Ensure that a non-zero recipient has been supplied.
    if (recipient == address(0)) {
      revert(_REVERTREASON31(1));
    }

    // Attempt to transfer Ether to the recipient and emit an appropriate event.
    ok = _TRANSFERETH212(recipient, amount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function CANCEL991(	//inject NONSTANDARD NAMING
    uint256 minimumActionGas,
    bytes calldata signature
  ) external {
    // Get the current nonce.
    uint256 nonceToCancel = _nonce;

    // Ensure the caller or the supplied signature is valid and increment nonce.
    _VALIDATEACTIONANDINCREMENTNONCE883(
      ActionType.Cancel,
      abi.encode(),
      minimumActionGas,
      signature,
      signature
    );

    // Emit an event to validate that the nonce is no longer valid.
    emit CANCEL692(nonceToCancel);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function EXECUTEACTION770(	//inject NONSTANDARD NAMING
    address to,
    bytes calldata data,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok, bytes memory returnData) {
    // Ensure that the `to` address is a contract and is not this contract.
    _ENSUREVALIDGENERICCALLTARGET978(to);

    // Ensure caller and/or supplied signatures are valid and increment nonce.
    (bytes32 actionID, uint256 nonce) = _VALIDATEACTIONANDINCREMENTNONCE883(
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
      emit CALLSUCCESS383(actionID, false, nonce, to, data, returnData);
    } else {
      // Note: while the call failed, the nonce will still be incremented, which
      // will invalidate all supplied signatures.
      emit CALLFAILURE442(actionID, nonce, to, data, _DECODEREVERTREASON288(returnData));
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function SETUSERSIGNINGKEY240(	//inject NONSTANDARD NAMING
    address userSigningKey,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _VALIDATEACTIONANDINCREMENTNONCE883(
      ActionType.SetUserSigningKey,
      abi.encode(userSigningKey),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Set new user signing key on smart wallet and emit a corresponding event.
    _SETUSERSIGNINGKEY543(userSigningKey);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function SETESCAPEHATCH554(	//inject NONSTANDARD NAMING
    address account,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _VALIDATEACTIONANDINCREMENTNONCE883(
      ActionType.SetEscapeHatch,
      abi.encode(account),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Ensure that an escape hatch account has been provided.
    if (account == address(0)) {
      revert(_REVERTREASON31(5));
    }

    // Set a new escape hatch for the smart wallet unless it has been disabled.
    _escape_hatch_registry980.SETESCAPEHATCH554(account);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function REMOVEESCAPEHATCH653(	//inject NONSTANDARD NAMING
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _VALIDATEACTIONANDINCREMENTNONCE883(
      ActionType.RemoveEscapeHatch,
      abi.encode(),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Remove the escape hatch for the smart wallet if one is currently set.
    _escape_hatch_registry980.REMOVEESCAPEHATCH653();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
  function PERMANENTLYDISABLEESCAPEHATCH796(	//inject NONSTANDARD NAMING
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _VALIDATEACTIONANDINCREMENTNONCE883(
      ActionType.DisableEscapeHatch,
      abi.encode(),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Permanently disable the escape hatch mechanism for this smart wallet.
    _escape_hatch_registry980.PERMANENTLYDISABLEESCAPEHATCH796();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function TRADEETHFORDAIANDMINTDDAI339(	//inject NONSTANDARD NAMING
    uint256 ethToSupply,
    uint256 minimumDaiReceived,
    address target,
    bytes calldata data,
    uint256 minimumActionGas,
    bytes calldata userSignature,
    bytes calldata dharmaSignature
  ) external returns (bool ok, bytes memory returnData) {
    // Ensure caller and/or supplied signatures are valid and increment nonce.
    _VALIDATEACTIONANDINCREMENTNONCE883(
      ActionType.TradeEthForDai,
      abi.encode(ethToSupply, minimumDaiReceived, target, data),
      minimumActionGas,
      userSignature,
      dharmaSignature
    );

    // Ensure that an amount of at least 0.001 Dai will be received.
    if (minimumDaiReceived <= _just_under_one_1000th_dai594) {
      revert(_REVERTREASON31(31));
    }

    // Set the self-call context in order to call _tradeEthForDaiAndMintDDaiAtomic.
    _selfCallContext = this.TRADEETHFORDAIANDMINTDDAI339.selector;

    // Make the atomic self-call - if the swap fails or the received dai is not
    // greater than or equal to the requirement, it will revert and roll back the
    // atomic call as well as fire an ExternalError. If dDai is not successfully
    // minted, the swap will succeed but an ExternalError for dDai will be fired.
    bytes memory returnData;
    (ok, returnData) = address(this).call(abi.encodeWithSelector(
      this._TRADEETHFORDAIANDMINTDDAIATOMIC657.selector,
      ethToSupply, minimumDaiReceived, target, data
    ));

    // If the atomic call failed, emit an event signifying a trade failure.
    if (!ok) {
      emit EXTERNALERROR24(
        address(_trade_helper427), _DECODEREVERTREASON288(returnData)
      );
    }
  }
  
  function _TRADEETHFORDAIANDMINTDDAIATOMIC657(	//inject NONSTANDARD NAMING
    uint256 ethToSupply,
    uint256 minimumDaiReceived,
    address target,
    bytes calldata data
  ) external returns (bool ok, bytes memory returnData) {
    // Ensure caller is this contract and self-call context is correctly set.
    _ENFORCESELFCALLFROM836(this.TRADEETHFORDAIANDMINTDDAI339.selector);
    
    // Do swap using supplied Ether amount, minimum Dai, target, and data.
    uint256 daiReceived = _trade_helper427.TRADEETHFORDAI848.value(ethToSupply)(
      minimumDaiReceived, target, data
    );
    
    // Ensure that sufficient Dai was returned as a result of the swap. 
    if (daiReceived < minimumDaiReceived) {
      revert(_REVERTREASON31(32));
    }
    
    // Attempt to deposit the dai received and mint Dharma Dai.
    _DEPOSITDHARMATOKEN821(AssetType.DAI, daiReceived);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function ESCAPE232() external {	//inject NONSTANDARD NAMING
    // Get the escape hatch account, if one exists, for this account.
    (bool exists, address escapeHatch) = _escape_hatch_registry980.GETESCAPEHATCH697();

    // Ensure that an escape hatch is currently set for this smart wallet.
    if (!exists) {
      revert(_REVERTREASON31(6));
    }

    // Ensure that the escape hatch account is the caller.
    if (msg.sender != escapeHatch) {
      revert(_REVERTREASON31(7));
    }

    // Attempt to redeem all dDai for Dai on Dharma Dai.
    _WITHDRAWMAXFROMDHARMATOKEN348(AssetType.DAI);

    // Attempt to redeem all dUSDC for USDC on Dharma USDC.
    _WITHDRAWMAXFROMDHARMATOKEN348(AssetType.USDC);

    // Attempt to transfer the total Dai balance to the caller.
    _TRANSFERMAX629(_dai860, msg.sender, true);

    // Attempt to transfer the total USDC balance to the caller.
    _TRANSFERMAX629(_usdc146, msg.sender, true);

    // Attempt to transfer any residual cDai to the caller.
    _TRANSFERMAX629(ERC20Interface(address(_cdai443)), msg.sender, true);

    // Attempt to transfer any residual cUSDC to the caller.
    _TRANSFERMAX629(ERC20Interface(address(_cusdc481)), msg.sender, true);

    // Attempt to transfer any residual dDai to the caller.
    _TRANSFERMAX629(ERC20Interface(address(_ddai406)), msg.sender, true);

    // Attempt to transfer any residual dUSDC to the caller.
    _TRANSFERMAX629(ERC20Interface(address(_dusdc174)), msg.sender, true);

    // Determine if there is Ether at this address that should be transferred.
    uint256 balance = address(this).balance;
    if (balance > 0) {
      // Attempt to transfer any Ether to caller and emit an appropriate event.
      _TRANSFERETH212(msg.sender, balance);
    }

    // Emit an `Escaped` event.
    emit ESCAPED27();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function RECOVER845(address newUserSigningKey) external {	//inject NONSTANDARD NAMING
    // Only the Account Recovery Manager contract may call this function.
    if (msg.sender != _account_recovery_manager816) {
      revert(_REVERTREASON31(8));
    }

    // Increment nonce to prevent signature reuse should original key be reset.
    _nonce++;

    // Set up the user's new dharma key and emit a corresponding event.
    _SETUSERSIGNINGKEY543(newUserSigningKey);
  }

                                                          
  function MIGRATESAITODAI522() external {	//inject NONSTANDARD NAMING
    revert();
  }

                                                          
  function MIGRATECSAITODDAI208() external {	//inject NONSTANDARD NAMING
    revert();
  }

                                                                                                                                                                                                                                                                                    
  function MIGRATECDAITODDAI660() external {	//inject NONSTANDARD NAMING
     _MIGRATECTOKENTODTOKEN6(AssetType.DAI);
  }

                                                                                                                                                                                                                                                                                
  function MIGRATECUSDCTODUSDC400() external {	//inject NONSTANDARD NAMING
     _MIGRATECTOKENTODTOKEN6(AssetType.USDC);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
  function GETBALANCES53() external view returns (	//inject NONSTANDARD NAMING
    uint256 daiBalance,
    uint256 usdcBalance,
    uint256 etherBalance,
    uint256 dDaiUnderlyingDaiBalance,
    uint256 dUsdcUnderlyingUsdcBalance,
    uint256 dEtherUnderlyingEtherBalance // always returns 0
  ) {
    daiBalance = _dai860.BALANCEOF992(address(this));
    usdcBalance = _usdc146.BALANCEOF992(address(this));
    etherBalance = address(this).balance;
    dDaiUnderlyingDaiBalance = _ddai406.BALANCEOFUNDERLYING317(address(this));
    dUsdcUnderlyingUsdcBalance = _dusdc174.BALANCEOFUNDERLYING317(address(this));
  }

                                                                                                                                                     
  function GETUSERSIGNINGKEY63() external view returns (address userSigningKey) {	//inject NONSTANDARD NAMING
    userSigningKey = _userSigningKey;
  }

                                                                                                                                                                                                                                             
  function GETNONCE95() external view returns (uint256 nonce) {	//inject NONSTANDARD NAMING
    nonce = _nonce;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function GETNEXTCUSTOMACTIONID792(	//inject NONSTANDARD NAMING
    ActionType action,
    uint256 amount,
    address recipient,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _GETACTIONID195(
      action,
      _VALIDATECUSTOMACTIONTYPEANDGETARGUMENTS503(action, amount, recipient),
      _nonce,
      minimumActionGas,
      _userSigningKey,
      _GETDHARMASIGNINGKEY429()
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  function GETCUSTOMACTIONID90(	//inject NONSTANDARD NAMING
    ActionType action,
    uint256 amount,
    address recipient,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _GETACTIONID195(
      action,
      _VALIDATECUSTOMACTIONTYPEANDGETARGUMENTS503(action, amount, recipient),
      nonce,
      minimumActionGas,
      _userSigningKey,
      _GETDHARMASIGNINGKEY429()
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  function GETNEXTGENERICACTIONID981(	//inject NONSTANDARD NAMING
    address to,
    bytes calldata data,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _GETACTIONID195(
      ActionType.Generic,
      abi.encode(to, data),
      _nonce,
      minimumActionGas,
      _userSigningKey,
      _GETDHARMASIGNINGKEY429()
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  function GETGENERICACTIONID781(	//inject NONSTANDARD NAMING
    address to,
    bytes calldata data,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _GETACTIONID195(
      ActionType.Generic,
      abi.encode(to, data),
      nonce,
      minimumActionGas,
      _userSigningKey,
      _GETDHARMASIGNINGKEY429()
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function GETNEXTETHFORDAIACTIONID361(	//inject NONSTANDARD NAMING
    uint256 ethToSupply,
    uint256 minimumDaiReceived,
    address target,
    bytes calldata data,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _GETACTIONID195(
      ActionType.TradeEthForDai,
      abi.encode(ethToSupply, minimumDaiReceived, target, data),
      _nonce,
      minimumActionGas,
      _userSigningKey,
      _GETDHARMASIGNINGKEY429()
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function GETETHFORDAIACTIONID368(	//inject NONSTANDARD NAMING
    uint256 ethToSupply,
    uint256 minimumDaiReceived,
    address target,
    bytes calldata data,
    uint256 nonce,
    uint256 minimumActionGas
  ) external view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _GETACTIONID195(
      ActionType.TradeEthForDai,
      abi.encode(ethToSupply, minimumDaiReceived, target, data),
      nonce,
      minimumActionGas,
      _userSigningKey,
      _GETDHARMASIGNINGKEY429()
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
  function ISVALIDSIGNATURE229(	//inject NONSTANDARD NAMING
    bytes calldata data, bytes calldata signatures
  ) external view returns (bytes4 magicValue) {
    // Get message hash digest and any additional context from data argument.
    bytes32 digest;
    bytes memory context;

    if (data.length == 32) {
      digest = abi.decode(data, (bytes32));
    } else {
      if (data.length < 64) {
        revert(_REVERTREASON31(30));
      }
      (digest, context) = abi.decode(data, (bytes32, bytes));
    }

    // Get Dharma signature & user signature from combined signatures argument.
    if (signatures.length != 130) {
      revert(_REVERTREASON31(11));
    }
    bytes memory signaturesInMemory = signatures;
    bytes32 r;
    bytes32 s;
    uint8 v;
    assembly {
      r := mload(add(signaturesInMemory, 0x20))
      s := mload(add(signaturesInMemory, 0x40))
      v := byte(0, mload(add(signaturesInMemory, 0x60)))
    }
    bytes memory dharmaSignature = abi.encodePacked(r, s, v);

    assembly {
      r := mload(add(signaturesInMemory, 0x61))
      s := mload(add(signaturesInMemory, 0x81))
      v := byte(0, mload(add(signaturesInMemory, 0xa1)))
    }
    bytes memory userSignature = abi.encodePacked(r, s, v);

    // Validate user signature with `SignatureVerification` as the action type.
    if (
      !_VALIDATEUSERSIGNATURE499(
        digest,
        ActionType.SignatureVerification,
        context,
        _userSigningKey,
        userSignature
      )
    ) {
      revert(_REVERTREASON31(12));
    }

    // Recover Dharma signature against key returned from Dharma Key Registry.
    if (_GETDHARMASIGNINGKEY429() != digest.RECOVER845(dharmaSignature)) {
      revert(_REVERTREASON31(13));
    }

    // Return the ERC-1271 magic value to indicate success.
    magicValue = _erc_1271_magic_value586;
  }

                                                                                                                                                                                                                         
  function GETIMPLEMENTATION136() external view returns (address implementation) {	//inject NONSTANDARD NAMING
    (bool ok, bytes memory returnData) = address(
      0x0000000000b45D6593312ac9fdE193F3D0633644
    ).staticcall("");
    require(ok && returnData.length == 32, "Invalid implementation.");
    implementation = abi.decode(returnData, (address));
  }

                                                                                                                                                 
  function GETVERSION901() external pure returns (uint256 version) {	//inject NONSTANDARD NAMING
    version = _dharma_smart_wallet_version295;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function EXECUTEACTIONWITHATOMICBATCHCALLS418(	//inject NONSTANDARD NAMING
    Call[] memory calls,
    uint256 minimumActionGas,
    bytes memory userSignature,
    bytes memory dharmaSignature
  ) public returns (bool[] memory ok, bytes[] memory returnData) {
    // Ensure that each `to` address is a contract and is not this contract.
    for (uint256 i = 0; i < calls.length; i++) {
      _ENSUREVALIDGENERICCALLTARGET978(calls[i].to);
    }

    // Ensure caller and/or supplied signatures are valid and increment nonce.
    (bytes32 actionID, uint256 nonce) = _VALIDATEACTIONANDINCREMENTNONCE883(
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
    _selfCallContext = this.EXECUTEACTIONWITHATOMICBATCHCALLS418.selector;

    // Make the atomic self-call - if any call fails, calls that preceded it
    // will be rolled back and calls that follow it will not be made.
    (bool externalOk, bytes memory rawCallResults) = address(this).call(
      abi.encodeWithSelector(
        this._EXECUTEACTIONWITHATOMICBATCHCALLSATOMIC905.selector, calls
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
        // Note: while the call succeeded, the action may still have "failed".
        emit CALLSUCCESS383(
          actionID,
          !externalOk, // If another call failed this will have been rolled back
          nonce,
          currentCall.to,
          currentCall.data,
          callResults[i].returnData
        );
      } else {
        // Note: while the call failed, the nonce will still be incremented,
        // which will invalidate all supplied signatures.
        emit CALLFAILURE442(
          actionID,
          nonce,
          currentCall.to,
          currentCall.data,
          _DECODEREVERTREASON288(callResults[i].returnData)
        );

        // exit early - any calls after the first failed call will not execute.
        break;
      }
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  function _EXECUTEACTIONWITHATOMICBATCHCALLSATOMIC905(	//inject NONSTANDARD NAMING
    Call[] memory calls
  ) public returns (CallReturn[] memory callResults) {
    // Ensure caller is this contract and self-call context is correctly set.
    _ENFORCESELFCALLFROM836(this.EXECUTEACTIONWITHATOMICBATCHCALLS418.selector);

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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  function GETNEXTGENERICATOMICBATCHACTIONID957(	//inject NONSTANDARD NAMING
    Call[] memory calls,
    uint256 minimumActionGas
  ) public view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _GETACTIONID195(
      ActionType.GenericAtomicBatch,
      abi.encode(calls),
      _nonce,
      minimumActionGas,
      _userSigningKey,
      _GETDHARMASIGNINGKEY429()
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function GETGENERICATOMICBATCHACTIONID98(	//inject NONSTANDARD NAMING
    Call[] memory calls,
    uint256 nonce,
    uint256 minimumActionGas
  ) public view returns (bytes32 actionID) {
    // Determine the actionID - this serves as a signature hash for an action.
    actionID = _GETACTIONID195(
      ActionType.GenericAtomicBatch,
      abi.encode(calls),
      nonce,
      minimumActionGas,
      _userSigningKey,
      _GETDHARMASIGNINGKEY429()
    );
  }

                                                                                                                                                                                                                                                                                                                                       
  function _SETUSERSIGNINGKEY543(address userSigningKey) internal {	//inject NONSTANDARD NAMING
    // Ensure that a user signing key is set on this smart wallet.
    if (userSigningKey == address(0)) {
      revert(_REVERTREASON31(14));
    }

    _userSigningKey = userSigningKey;
    emit NEWUSERSIGNINGKEY833(userSigningKey);
  }

                                                                                                                                                                                                                                                                                                                                                                     
  function _SETFULLAPPROVAL629(AssetType asset) internal returns (bool ok) {	//inject NONSTANDARD NAMING
    // Get asset's underlying token address and corresponding dToken address.
    address token;
    address dToken;
    if (asset == AssetType.DAI) {
      token = address(_dai860);
      dToken = address(_ddai406);
    } else {
      token = address(_usdc146);
      dToken = address(_dusdc174);
    }

    // Approve dToken contract to transfer underlying on behalf of this wallet.
    (ok, ) = address(token).call(abi.encodeWithSelector(
      // Note: since both Tokens have the same interface, just use DAI's.
      _dai860.APPROVE270.selector, dToken, uint256(-1)
    ));

    // Emit a corresponding event if the approval failed.
    if (!ok) {
      if (asset == AssetType.DAI) {
        emit EXTERNALERROR24(address(_dai860), _REVERTREASON31(17));
      } else {
        // Find out why USDC transfer reverted (it doesn't give revert reasons).
        _DIAGNOSEANDEMITUSDCSPECIFICERROR976(_usdc146.APPROVE270.selector);
      }
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function _DEPOSITDHARMATOKEN821(AssetType asset, uint256 balance) internal {	//inject NONSTANDARD NAMING
    // Only perform a deposit if the balance is at least .001 Dai or USDC.
    if (
      asset == AssetType.DAI && balance > _just_under_one_1000th_dai594 ||
      asset == AssetType.USDC && (
        balance > _just_under_one_1000th_usdc382 &&
        uint256(_config_registry519.GET761(_enable_usdc_minting_key536)) != 0
      )
    ) {
      // Get dToken address for the asset type.
      address dToken = asset == AssetType.DAI ? address(_ddai406) : address(_dusdc174);

      // Attempt to mint the balance on the dToken contract.
      (bool ok, bytes memory data) = dToken.call(abi.encodeWithSelector(
        // Note: since both dTokens have the same interface, just use dDai's.
        _ddai406.MINT76.selector, balance
      ));

      // Log an external error if something went wrong with the attempt.
      _CHECKDHARMATOKENINTERACTIONANDLOGANYERRORS622(
        asset, _ddai406.MINT76.selector, ok, data
      );
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
  function _WITHDRAWFROMDHARMATOKEN513(	//inject NONSTANDARD NAMING
    AssetType asset, uint256 balance
  ) internal returns (bool success) {
    // Get dToken address for the asset type. (No custom ETH withdrawal action.)
    address dToken = asset == AssetType.DAI ? address(_ddai406) : address(_dusdc174);

    // Attempt to redeem the underlying balance from the dToken contract.
    (bool ok, bytes memory data) = dToken.call(abi.encodeWithSelector(
      // Note: function selector is the same for each dToken so just use dDai's.
      _ddai406.REDEEMUNDERLYING215.selector, balance
    ));

    // Log an external error if something went wrong with the attempt.
    success = _CHECKDHARMATOKENINTERACTIONANDLOGANYERRORS622(
      asset, _ddai406.REDEEMUNDERLYING215.selector, ok, data
    );
  }

                                                                                                                                                                                                                                                                                                                                      
  function _WITHDRAWMAXFROMDHARMATOKEN348(AssetType asset) internal {	//inject NONSTANDARD NAMING
    // Get dToken address for the asset type. (No custom ETH withdrawal action.)
    address dToken = asset == AssetType.DAI ? address(_ddai406) : address(_dusdc174);

    // Try to retrieve the current dToken balance for this account.
    ERC20Interface dTokenBalance;
    (bool ok, bytes memory data) = dToken.call(abi.encodeWithSelector(
      dTokenBalance.BALANCEOF992.selector, address(this)
    ));

    uint256 redeemAmount = 0;
    if (ok && data.length == 32) {
      redeemAmount = abi.decode(data, (uint256));
    } else {
      // Something went wrong with the balance check - log an ExternalError.
      _CHECKDHARMATOKENINTERACTIONANDLOGANYERRORS622(
        asset, dTokenBalance.BALANCEOF992.selector, ok, data
      );
    }

    // Only perform the call to redeem if there is a non-zero balance.
    if (redeemAmount > 0) {
      // Attempt to redeem the underlying balance from the dToken contract.
      (ok, data) = dToken.call(abi.encodeWithSelector(
        // Function selector is the same for all dTokens, so just use dDai's.
        _ddai406.REDEEM466.selector, redeemAmount
      ));

      // Log an external error if something went wrong with the attempt.
      _CHECKDHARMATOKENINTERACTIONANDLOGANYERRORS622(
        asset, _ddai406.REDEEM466.selector, ok, data
      );
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  function _TRANSFERMAX629(	//inject NONSTANDARD NAMING
    ERC20Interface token, address recipient, bool suppressRevert
  ) internal returns (bool success) {
    // Get the current balance on the smart wallet for the supplied ERC20 token.
    uint256 balance = 0;
    bool balanceCheckWorked = true;
    if (!suppressRevert) {
      balance = token.BALANCEOF992(address(this));
    } else {
      // Try to retrieve current token balance for this account with 1/2 gas.
      (bool ok, bytes memory data) = address(token).call.gas(gasleft() / 2)(
        abi.encodeWithSelector(token.BALANCEOF992.selector, address(this))
      );

      if (ok && data.length == 32) {
        balance = abi.decode(data, (uint256));
      } else {
        // Something went wrong with the balance check.
        balanceCheckWorked = false;
      }
    }

    // Only perform the call to transfer if there is a non-zero balance.
    if (balance > 0) {
      if (!suppressRevert) {
        // Perform the transfer and pass along the returned boolean (or revert).
        success = token.TRANSFER153(recipient, balance);
      } else {
        // Attempt transfer with 1/2 gas, allow reverts, and return call status.
        (success, ) = address(token).call.gas(gasleft() / 2)(
          abi.encodeWithSelector(token.TRANSFER153.selector, recipient, balance)
        );
      }
    } else {
      // Skip the transfer and return true as long as the balance check worked.
      success = balanceCheckWorked;
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function _TRANSFERETH212(	//inject NONSTANDARD NAMING
    address payable recipient, uint256 amount
  ) internal returns (bool success) {
    // Attempt to transfer any Ether to caller and emit an event if it fails.
    (success, ) = recipient.call.gas(_eth_transfer_gas33).value(amount)("");
    if (!success) {
      emit EXTERNALERROR24(recipient, _REVERTREASON31(18));
    } else {
      emit ETHWITHDRAWAL175(amount, recipient);
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function _VALIDATEACTIONANDINCREMENTNONCE883(	//inject NONSTANDARD NAMING
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
      if (gasleft() < minimumActionGas) {
        revert(_REVERTREASON31(19));
      }
    }

    // Get the current nonce for the action to be performed.
    actionNonce = _nonce;

    // Get the user signing key that will be used to verify their signature.
    address userSigningKey = _userSigningKey;

    // Get the Dharma signing key that will be used to verify their signature.
    address dharmaSigningKey = _GETDHARMASIGNINGKEY429();

    // Determine the actionID - this serves as the signature hash.
    actionID = _GETACTIONID195(
      action,
      arguments,
      actionNonce,
      minimumActionGas,
      userSigningKey,
      dharmaSigningKey
    );

    // Compute the message hash - the hashed, EIP-191-0x45-prefixed action ID.
    bytes32 messageHash = actionID.TOETHSIGNEDMESSAGEHASH603();

    // Actions other than Cancel require both signatures; Cancel only needs one.
    if (action != ActionType.Cancel) {
      // Validate user signing key signature unless it is `msg.sender`.
      if (msg.sender != userSigningKey) {
        if (
          !_VALIDATEUSERSIGNATURE499(
            messageHash, action, arguments, userSigningKey, userSignature
          )
        ) {
          revert(_REVERTREASON31(20));
        }
      }

      // Validate Dharma signing key signature unless it is `msg.sender`.
      if (msg.sender != dharmaSigningKey) {
        if (dharmaSigningKey != messageHash.RECOVER845(dharmaSignature)) {
          revert(_REVERTREASON31(21));
        }
      }
    } else {
      // Validate signing key signature unless user or Dharma is `msg.sender`.
      if (msg.sender != userSigningKey && msg.sender != dharmaSigningKey) {
        if (
          dharmaSigningKey != messageHash.RECOVER845(dharmaSignature) &&
          !_VALIDATEUSERSIGNATURE499(
            messageHash, action, arguments, userSigningKey, userSignature
          )
        ) {
          revert(_REVERTREASON31(22));
        }
      }
    }

    // Increment nonce in order to prevent reuse of signatures after the call.
    _nonce++;
  }

                                                                                                                                                                                                                                                                                   
  function _MIGRATECTOKENTODTOKEN6(AssetType token) internal {	//inject NONSTANDARD NAMING
    CTokenInterface cToken;
    DTokenInterface dToken;

    if (token == AssetType.DAI) {
      cToken = _cdai443;
      dToken = _ddai406;
    } else {
      cToken = _cusdc481;
      dToken = _dusdc174;
    }

    // Get the current cToken balance for this account.
    uint256 balance = cToken.BALANCEOF992(address(this));

    // Only perform the conversion if there is a non-zero balance.
    if (balance > 0) {    
      // If the allowance is insufficient, set it before depositing.
      if (cToken.ALLOWANCE583(address(this), address(dToken)) < balance) {
        if (!cToken.APPROVE270(address(dToken), uint256(-1))) {
          revert(_REVERTREASON31(23));
        }
      }
      
      // Deposit the new balance on the Dharma Token.
      if (dToken.MINTVIACTOKEN796(balance) == 0) {
        revert(_REVERTREASON31(24));
      }
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function _CHECKDHARMATOKENINTERACTIONANDLOGANYERRORS622(	//inject NONSTANDARD NAMING
    AssetType asset,
    bytes4 functionSelector,
    bool ok,
    bytes memory data
  ) internal returns (bool success) {
    // Log an external error if something went wrong with the attempt.
    if (ok) {
      if (data.length == 32) {
        uint256 amount = abi.decode(data, (uint256));
        if (amount > 0) {
          success = true;
        } else {
          // Get called contract address, name of contract, and function name.
          (address account, string memory name, string memory functionName) = (
            _GETDHARMATOKENDETAILS978(asset, functionSelector)
          );

          emit EXTERNALERROR24(
            account,
            string(
              abi.encodePacked(
                name,
                " gave no tokens calling ",
                functionName,
                "."
              )
            )
          );         
        }
      } else {
        // Get called contract address, name of contract, and function name.
        (address account, string memory name, string memory functionName) = (
          _GETDHARMATOKENDETAILS978(asset, functionSelector)
        );

        emit EXTERNALERROR24(
          account,
          string(
            abi.encodePacked(
              name,
              " gave bad data calling ",
              functionName,
              "."
            )
          )
        );        
      }
      
    } else {
      // Get called contract address, name of contract, and function name.
      (address account, string memory name, string memory functionName) = (
        _GETDHARMATOKENDETAILS978(asset, functionSelector)
      );

      // Decode the revert reason in the event one was returned.
      string memory revertReason = _DECODEREVERTREASON288(data);

      emit EXTERNALERROR24(
        account,
        string(
          abi.encodePacked(
            name,
            " reverted calling ",
            functionName,
            ": ",
            revertReason
          )
        )
      );
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                       
  function _DIAGNOSEANDEMITUSDCSPECIFICERROR976(bytes4 functionSelector) internal {	//inject NONSTANDARD NAMING
    // Determine the name of the function that was called on USDC.
    string memory functionName;
    if (functionSelector == _usdc146.TRANSFER153.selector) {
      functionName = "transfer";
    } else {
      functionName = "approve";
    }
    
    USDCV1Interface usdcNaughty = USDCV1Interface(address(_usdc146));

    // Find out why USDC transfer reverted (it doesn't give revert reasons).
    if (usdcNaughty.ISBLACKLISTED453(address(this))) {
      emit EXTERNALERROR24(
        address(_usdc146),
        string(
          abi.encodePacked(
            functionName, " failed - USDC has blacklisted this user."
          )
        )
      );
    } else { // Note: `else if` breaks coverage.
      if (usdcNaughty.PAUSED117()) {
        emit EXTERNALERROR24(
          address(_usdc146),
          string(
            abi.encodePacked(
              functionName, " failed - USDC contract is currently paused."
            )
          )
        );
      } else {
        emit EXTERNALERROR24(
          address(_usdc146),
          string(
            abi.encodePacked(
              "USDC contract reverted on ", functionName, "."
            )
          )
        );
      }
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  function _ENFORCESELFCALLFROM836(bytes4 selfCallContext) internal {	//inject NONSTANDARD NAMING
    // Ensure caller is this contract and self-call context is correctly set.
    if (msg.sender != address(this) || _selfCallContext != selfCallContext) {
      revert(_REVERTREASON31(25));
    }

    // Clear the self-call context.
    delete _selfCallContext;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function _VALIDATEUSERSIGNATURE499(	//inject NONSTANDARD NAMING
    bytes32 messageHash,
    ActionType action,
    bytes memory arguments,
    address userSigningKey,
    bytes memory userSignature
  ) internal view returns (bool valid) {
    if (!userSigningKey.ISCONTRACT235()) {
      valid = userSigningKey == messageHash.RECOVER845(userSignature);
    } else {
      bytes memory data = abi.encode(messageHash, action, arguments);
      valid = (
        ERC1271Interface(userSigningKey).ISVALIDSIGNATURE229(
          data, userSignature
        ) == _erc_1271_magic_value586
      );
    }
  }

                                                                                                                                                                                                                                                                                                                                                                       
  function _GETDHARMASIGNINGKEY429() internal view returns (	//inject NONSTANDARD NAMING
    address dharmaSigningKey
  ) {
    dharmaSigningKey = _dharma_key_registry438.GETKEY781();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
  function _GETACTIONID195(	//inject NONSTANDARD NAMING
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
        _dharma_smart_wallet_version295,
        userSigningKey,
        dharmaSigningKey,
        nonce,
        minimumActionGas,
        action,
        arguments
      )
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function _GETDHARMATOKENDETAILS978(	//inject NONSTANDARD NAMING
    AssetType asset,
    bytes4 functionSelector
  ) internal pure returns (
    address account,
    string memory name,
    string memory functionName
  ) {
    if (asset == AssetType.DAI) {
      account = address(_ddai406);
      name = "Dharma Dai";
    } else {
      account = address(_dusdc174);
      name = "Dharma USD Coin";
    }

    // Note: since both dTokens have the same interface, just use dDai's.
    if (functionSelector == _ddai406.MINT76.selector) {
      functionName = "mint";
    } else {
      if (functionSelector == ERC20Interface(account).BALANCEOF992.selector) {
        functionName = "balanceOf";
      } else {
        functionName = string(abi.encodePacked(
          "redeem",
          functionSelector == _ddai406.REDEEM466.selector ? "" : "Underlying"
        ));
      }
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function _ENSUREVALIDGENERICCALLTARGET978(address to) internal view {	//inject NONSTANDARD NAMING
    if (!to.ISCONTRACT235()) {
      revert(_REVERTREASON31(26));
    }
    
    if (to == address(this)) {
      revert(_REVERTREASON31(27));
    }

    if (to == address(_escape_hatch_registry980)) {
      revert(_REVERTREASON31(28));
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
  function _VALIDATECUSTOMACTIONTYPEANDGETARGUMENTS503(	//inject NONSTANDARD NAMING
    ActionType action, uint256 amount, address recipient
  ) internal pure returns (bytes memory arguments) {
    // Ensure that the action type is a valid custom action type.
    bool validActionType = (
      action == ActionType.Cancel ||
      action == ActionType.SetUserSigningKey ||
      action == ActionType.DAIWithdrawal ||
      action == ActionType.USDCWithdrawal ||
      action == ActionType.ETHWithdrawal ||
      action == ActionType.SetEscapeHatch ||
      action == ActionType.RemoveEscapeHatch ||
      action == ActionType.DisableEscapeHatch
    );
    if (!validActionType) {
      revert(_REVERTREASON31(29));
    }

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

                                                                                                                                                                                                                                                                                        
  function _DECODEREVERTREASON288(	//inject NONSTANDARD NAMING
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
      revertReason = _REVERTREASON31(uint256(-1));
    }
  }

                                                                                                                                                                                                                                                                 
  function _REVERTREASON31(	//inject NONSTANDARD NAMING
    uint256 code
  ) internal pure returns (string memory reason) {
    reason = _revert_reason_helper415.REASON113(code);
  }
}