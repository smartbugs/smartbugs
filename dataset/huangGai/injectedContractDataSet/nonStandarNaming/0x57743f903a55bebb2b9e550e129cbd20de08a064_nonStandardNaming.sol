                                                                 

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;


interface TradeBotCommanderV2Interface {
    // events
    event ADDEDACCOUNT705(address account);	//inject NONSTANDARD NAMING
    event REMOVEDACCOUNT677(address account);	//inject NONSTANDARD NAMING
    event CALL773(address target, uint256 amount, bytes data, bool ok, bytes returnData);	//inject NONSTANDARD NAMING
    
    // callable by accounts
    function PROCESSLIMITORDER517(	//inject NONSTANDARD NAMING
        DharmaTradeBotV1Interface.LimitOrderArguments calldata args,
        DharmaTradeBotV1Interface.LimitOrderExecutionArguments calldata executionArgs
    ) external returns (bool ok, uint256 amountReceived);

    function DEPLOYANDPROCESSLIMITORDER155(	//inject NONSTANDARD NAMING
        address initialSigningKey, // the initial key on the keyring
        address keyRing,
        DharmaTradeBotV1Interface.LimitOrderArguments calldata args,
        DharmaTradeBotV1Interface.LimitOrderExecutionArguments calldata executionArgs
    ) external returns (bool ok, bytes memory returnData);

    // only callable by owner
    function ADDACCOUNT504(address account) external;	//inject NONSTANDARD NAMING
    function REMOVEACCOUNT427(address account) external;	//inject NONSTANDARD NAMING
    function CALLANY167(	//inject NONSTANDARD NAMING
        address payable target, uint256 amount, bytes calldata data
    ) external returns (bool ok, bytes memory returnData);

    // view functions
    function GETACCOUNTS195() external view returns (address[] memory);	//inject NONSTANDARD NAMING
    function GETTRADEBOT843() external view returns (address tradeBot);	//inject NONSTANDARD NAMING
}


interface DharmaTradeBotV1Interface {
  struct LimitOrderArguments {
    address account;
    address assetToSupply;        // Ether = address(0)
    address assetToReceive;       // Ether = address(0)
    uint256 maximumAmountToSupply;
    uint256 maximumPriceToAccept; // represented as a mantissa (n * 10^18)
    uint256 expiration;
    bytes32 salt;
  }

  struct LimitOrderExecutionArguments {
    uint256 amountToSupply; // will be lower than maximum for partial fills
    bytes signatures;
    address tradeTarget;
    bytes tradeData;
  }

  function PROCESSLIMITORDER517(	//inject NONSTANDARD NAMING
    LimitOrderArguments calldata args,
    LimitOrderExecutionArguments calldata executionArgs
  ) external returns (uint256 amountReceived);
}


interface DharmaSmartWalletFactoryV1Interface {
  function NEWSMARTWALLET679(	//inject NONSTANDARD NAMING
    address userSigningKey
  ) external returns (address wallet);
  
  function GETNEXTSMARTWALLET653(	//inject NONSTANDARD NAMING
    address userSigningKey
  ) external view returns (address wallet);
}

interface DharmaKeyRingFactoryV2Interface {
  function NEWKEYRING243(	//inject NONSTANDARD NAMING
    address userSigningKey, address targetKeyRing
  ) external returns (address keyRing);

  function GETNEXTKEYRING535(	//inject NONSTANDARD NAMING
    address userSigningKey
  ) external view returns (address targetKeyRing);
}


contract TwoStepOwnable {
  address private _owner;

  address private _newPotentialOwner;

  event OWNERSHIPTRANSFERRED599(	//inject NONSTANDARD NAMING
    address indexed previousOwner,
    address indexed newOwner
  );

                                                                                            
  constructor() internal {
    _owner = tx.origin;
    emit OWNERSHIPTRANSFERRED599(address(0), _owner);
  }

                                                               
  function OWNER209() public view returns (address) {	//inject NONSTANDARD NAMING
    return _owner;
  }

                                                                           
  modifier ONLYOWNER726() {	//inject NONSTANDARD NAMING
    require(ISOWNER585(), "TwoStepOwnable: caller is not the owner.");
    _;
  }

                                                                      
  function ISOWNER585() public view returns (bool) {	//inject NONSTANDARD NAMING
    return msg.sender == _owner;
  }

                                                                                                                          
  function TRANSFEROWNERSHIP473(address newOwner) public ONLYOWNER726 {	//inject NONSTANDARD NAMING
    require(
      newOwner != address(0),
      "TwoStepOwnable: new potential owner is the zero address."
    );

    _newPotentialOwner = newOwner;
  }

                                                                                                                    
  function CANCELOWNERSHIPTRANSFER552() public ONLYOWNER726 {	//inject NONSTANDARD NAMING
    delete _newPotentialOwner;
  }

                                                                                                                                                   
  function ACCEPTOWNERSHIP824() public {	//inject NONSTANDARD NAMING
    require(
      msg.sender == _newPotentialOwner,
      "TwoStepOwnable: current owner must set caller as new potential owner."
    );

    delete _newPotentialOwner;

    emit OWNERSHIPTRANSFERRED599(_owner, msg.sender);

    _owner = msg.sender;
  }
}


contract TradeBotCommanderV2 is TradeBotCommanderV2Interface, TwoStepOwnable {
    // Track all authorized accounts.
    address[] private _accounts;

    // Indexes start at 1, as 0 signifies non-inclusion
    mapping (address => uint256) private _accountIndexes;
    
    DharmaTradeBotV1Interface private immutable _TRADE_BOT;

    DharmaSmartWalletFactoryV1Interface private immutable _WALLET_FACTORY;
  
    DharmaKeyRingFactoryV2Interface private immutable _KEYRING_FACTORY;

    constructor(address walletFactory, address keyRingFactory, address tradeBot, address[] memory initialAccounts) public {
        require(
            walletFactory != address(0) &&
            keyRingFactory != address(0) &&
            tradeBot != address(0),
            "Missing required constructor arguments."
        );
        _WALLET_FACTORY = DharmaSmartWalletFactoryV1Interface(walletFactory);
        _KEYRING_FACTORY = DharmaKeyRingFactoryV2Interface(keyRingFactory);
        _TRADE_BOT = DharmaTradeBotV1Interface(tradeBot);
        for (uint256 i; i < initialAccounts.length; i++) {
            address account = initialAccounts[i];
            _ADDACCOUNT722(account);
        }
    }
    
    function PROCESSLIMITORDER517(	//inject NONSTANDARD NAMING
        DharmaTradeBotV1Interface.LimitOrderArguments calldata args,
        DharmaTradeBotV1Interface.LimitOrderExecutionArguments calldata executionArgs
    ) external override returns (bool ok, uint256 amountReceived) {
        require(
            _accountIndexes[msg.sender] != 0,
            "Only authorized accounts may trigger limit orders."
        );
        
        amountReceived = _TRADE_BOT.PROCESSLIMITORDER517(
            args, executionArgs
        );

        ok = true;
    }

    // Deploy a key ring and a smart wallet, then process the limit order.
    function DEPLOYANDPROCESSLIMITORDER155(	//inject NONSTANDARD NAMING
        address initialSigningKey, // the initial key on the keyring
        address keyRing,
        DharmaTradeBotV1Interface.LimitOrderArguments calldata args,
        DharmaTradeBotV1Interface.LimitOrderExecutionArguments calldata executionArgs
    ) external override returns (bool ok, bytes memory returnData) {
        require(
            _accountIndexes[msg.sender] != 0,
            "Only authorized accounts may trigger limit orders."
        );
        
        _DEPLOYNEWKEYRINGIFNEEDED997(initialSigningKey, keyRing);
        _DEPLOYNEWSMARTWALLETIFNEEDED48(keyRing, args.account);
        
        try _TRADE_BOT.PROCESSLIMITORDER517(args, executionArgs) returns (uint256 amountReceived) {
            return (true, abi.encode(amountReceived));
        } catch (bytes memory revertData) {
            return (false, revertData);
        }
  }

    function ADDACCOUNT504(address account) external override ONLYOWNER726 {	//inject NONSTANDARD NAMING
        _ADDACCOUNT722(account);
    }

    function REMOVEACCOUNT427(address account) external override ONLYOWNER726 {	//inject NONSTANDARD NAMING
        _REMOVEACCOUNT899(account);
    }

    function CALLANY167(	//inject NONSTANDARD NAMING
        address payable target, uint256 amount, bytes calldata data
    ) external override ONLYOWNER726 returns (bool ok, bytes memory returnData) {
        // Call the specified target and supply the specified amount and data.
        (ok, returnData) = target.call{value: amount}(data);

        emit CALL773(target, amount, data, ok, returnData);
    }

    function GETACCOUNTS195() external view override returns (address[] memory) {	//inject NONSTANDARD NAMING
        return _accounts;
    }

    function GETTRADEBOT843() external view override returns (address tradeBot) {	//inject NONSTANDARD NAMING
        return address(_TRADE_BOT);
    }

  function _DEPLOYNEWKEYRINGIFNEEDED997(	//inject NONSTANDARD NAMING
    address initialSigningKey, address expectedKeyRing
  ) internal returns (address keyRing) {
    // Only deploy if a contract doesn't already exist at expected address.
    bytes32 size;
    assembly { size := extcodesize(expectedKeyRing) }
    if (size == 0) {
      require(
        _KEYRING_FACTORY.GETNEXTKEYRING535(initialSigningKey) == expectedKeyRing,
        "Key ring to be deployed does not match expected key ring."
      );
      keyRing = _KEYRING_FACTORY.NEWKEYRING243(initialSigningKey, expectedKeyRing);
    } else {
      // Note: the key ring at the expected address may have been modified so that
      // the supplied user signing key is no longer a valid key - therefore, treat
      // this helper as a way to protect against race conditions, not as a primary
      // mechanism for interacting with key ring contracts.
      keyRing = expectedKeyRing;
    }
  }
  
  function _DEPLOYNEWSMARTWALLETIFNEEDED48(	//inject NONSTANDARD NAMING
    address userSigningKey, // the key ring
    address expectedSmartWallet
  ) internal returns (address smartWallet) {
    // Only deploy if a contract doesn't already exist at expected address.
    bytes32 size;
    assembly { size := extcodesize(expectedSmartWallet) }
    if (size == 0) {
      require(
        _WALLET_FACTORY.GETNEXTSMARTWALLET653(userSigningKey) == expectedSmartWallet,
        "Smart wallet to be deployed does not match expected smart wallet."
      );
      smartWallet = _WALLET_FACTORY.NEWSMARTWALLET679(userSigningKey);
    } else {
      // Note: the smart wallet at the expected address may have been modified
      // so that the supplied user signing key is no longer a valid key.
      // Therefore, treat this helper as a way to protect against race
      // conditions, not as a primary mechanism for interacting with smart
      // wallet contracts.
      smartWallet = expectedSmartWallet;
    }
  }

    function _ADDACCOUNT722(address account) internal {	//inject NONSTANDARD NAMING
        require(
            _accountIndexes[account] == 0,
            "Account matching the provided account already exists."
        );
        _accounts.push(account);
        _accountIndexes[account] = _accounts.length;

        emit ADDEDACCOUNT705(account);
    }
    
    function _REMOVEACCOUNT899(address account) internal {	//inject NONSTANDARD NAMING
        uint256 removedAccountIndex = _accountIndexes[account];
        require(
            removedAccountIndex != 0,
            "No account found matching the provided account."
        );

        // swap account to remove with the last one then pop from the array.
        address lastAccount = _accounts[_accounts.length - 1];
        _accounts[removedAccountIndex - 1] = lastAccount;
        _accountIndexes[lastAccount] = removedAccountIndex;
        _accounts.pop();
        delete _accountIndexes[account];

        emit REMOVEDACCOUNT677(account); 
    }
}