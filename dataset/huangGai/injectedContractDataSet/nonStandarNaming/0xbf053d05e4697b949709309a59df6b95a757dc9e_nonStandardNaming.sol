                                                                 

pragma solidity 0.5.17; // optimization runs: 200, evm version: istanbul


interface DharmaTradeReserveV9Interface {
  event ROLEMODIFIED858(Role indexed role, address account);	//inject NONSTANDARD NAMING
  event ROLEPAUSED516(Role indexed role);	//inject NONSTANDARD NAMING
  event ROLEUNPAUSED425(Role indexed role);	//inject NONSTANDARD NAMING
  
  event ETHERRECEIVED855(address sender, uint256 amount);	//inject NONSTANDARD NAMING

  enum Role {           // #
    DEPOSIT_MANAGER,    // 0
    ADJUSTER,           // 1
    WITHDRAWAL_MANAGER, // 2
    RESERVE_TRADER,     // 3
    PAUSER              // 4
  }

  struct RoleStatus {
    address account;
    bool paused;
  }

  function TRADEDAIFORETHER899(	//inject NONSTANDARD NAMING
    uint256 daiAmount, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalDaiSold);

  function TRADEDAIFORETHERV2950(	//inject NONSTANDARD NAMING
    uint256 daiAmount, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalDaiSold);

  function TRADEETHERFORDAI795(	//inject NONSTANDARD NAMING
    uint256 quotedDaiAmount, uint256 deadline
  ) external payable returns (uint256 totalDaiBought);

  function TRADEETHERFORDAIV2625(	//inject NONSTANDARD NAMING
    uint256 quotedDaiAmount, uint256 deadline
  ) external payable returns (uint256 totalDaiBought);

  function TRADEDAIFORTOKEN107(	//inject NONSTANDARD NAMING
    address token, uint256 daiAmount, uint256 quotedTokenAmount, uint256 deadline, bool routeThroughEther
  ) external returns (uint256 totalDaiSold);

  function TRADETOKENFORDAI864(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmount, uint256 quotedDaiAmount, uint256 deadline, bool routeThroughEther
  ) external returns (uint256 totalDaiBought);

  function TRADETOKENFORETHER84(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmount, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalEtherBought);

  function TRADEETHERFORTOKEN818(	//inject NONSTANDARD NAMING
    address token, uint256 quotedTokenAmount, uint256 deadline
  ) external payable returns (uint256 totalEtherSold);

  function TRADEETHERFORTOKENUSINGETHERIZER867(	//inject NONSTANDARD NAMING
    address token, uint256 etherAmount, uint256 quotedTokenAmount, uint256 deadline
  ) external returns (uint256 totalEtherSold);

  function TRADEDAIFORETHERUSINGRESERVES556(	//inject NONSTANDARD NAMING
    uint256 daiAmountFromReserves, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalDaiSold);

  function TRADEDAIFORETHERUSINGRESERVESV2121(	//inject NONSTANDARD NAMING
    uint256 daiAmountFromReserves, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalDaiSold);

  function TRADEETHERFORDAIUSINGRESERVESANDMINTDDAI322(	//inject NONSTANDARD NAMING
    uint256 etherAmountFromReserves, uint256 quotedDaiAmount, uint256 deadline
  ) external returns (uint256 totalDaiBought, uint256 totalDDaiMinted);

  function TRADEETHERFORDAIUSINGRESERVESANDMINTDDAIV298(	//inject NONSTANDARD NAMING
    uint256 etherAmountFromReserves, uint256 quotedDaiAmount, uint256 deadline
  ) external returns (uint256 totalDaiBought, uint256 totalDDaiMinted);

  function TRADEDAIFORTOKENUSINGRESERVES528(	//inject NONSTANDARD NAMING
    address token, uint256 daiAmountFromReserves, uint256 quotedTokenAmount, uint256 deadline, bool routeThroughEther
  ) external returns (uint256 totalDaiSold);

  function TRADETOKENFORDAIUSINGRESERVESANDMINTDDAI549(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmountFromReserves, uint256 quotedDaiAmount, uint256 deadline, bool routeThroughEther
  ) external returns (uint256 totalDaiBought, uint256 totalDDaiMinted);

  function TRADETOKENFORETHERUSINGRESERVES915(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmountFromReserves, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalEtherBought);

  function TRADEETHERFORTOKENUSINGRESERVES405(	//inject NONSTANDARD NAMING
    address token, uint256 etherAmountFromReserves, uint256 quotedTokenAmount, uint256 deadline
  ) external returns (uint256 totalEtherSold);

  function FINALIZEETHERDEPOSIT298(	//inject NONSTANDARD NAMING
    address payable smartWallet,
    address initialUserSigningKey,
    uint256 etherAmount
  ) external;

  function FINALIZEDAIDEPOSIT931(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey, uint256 daiAmount
  ) external;

  function FINALIZEDHARMADAIDEPOSIT237(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey, uint256 dDaiAmount
  ) external;

  function MINT835(uint256 daiAmount) external returns (uint256 dDaiMinted);	//inject NONSTANDARD NAMING

  function REDEEM834(uint256 dDaiAmount) external returns (uint256 daiReceived);	//inject NONSTANDARD NAMING

  function TRADEDDAIFORUSDC353(	//inject NONSTANDARD NAMING
    uint256 daiEquivalentAmount, uint256 quotedUSDCAmount
  ) external returns (uint256 usdcReceived);

  function TRADEUSDCFORDDAI141(	//inject NONSTANDARD NAMING
    uint256 usdcAmount, uint256 quotedDaiEquivalentAmount
  ) external returns (uint256 dDaiMinted);

  function WITHDRAWUSDC678(address recipient, uint256 usdcAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWDAI49(address recipient, uint256 daiAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWDHARMADAI777(address recipient, uint256 dDaiAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWUSDCTOPRIMARYRECIPIENT422(uint256 usdcAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWDAITOPRIMARYRECIPIENT762(uint256 usdcAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWETHER204(	//inject NONSTANDARD NAMING
    address payable recipient, uint256 etherAmount
  ) external;

  function WITHDRAW439(	//inject NONSTANDARD NAMING
    ERC20Interface token, address recipient, uint256 amount
  ) external returns (bool success);

  function CALLANY778(	//inject NONSTANDARD NAMING
    address payable target, uint256 amount, bytes calldata data
  ) external returns (bool ok, bytes memory returnData);

  function SETDAILIMIT345(uint256 daiAmount) external;	//inject NONSTANDARD NAMING

  function SETETHERLIMIT550(uint256 daiAmount) external;	//inject NONSTANDARD NAMING

  function SETPRIMARYUSDCRECIPIENT259(address recipient) external;	//inject NONSTANDARD NAMING

  function SETPRIMARYDAIRECIPIENT972(address recipient) external;	//inject NONSTANDARD NAMING

  function SETROLE712(Role role, address account) external;	//inject NONSTANDARD NAMING

  function REMOVEROLE29(Role role) external;	//inject NONSTANDARD NAMING

  function PAUSE504(Role role) external;	//inject NONSTANDARD NAMING

  function UNPAUSE768(Role role) external;	//inject NONSTANDARD NAMING

  function ISPAUSED423(Role role) external view returns (bool paused);	//inject NONSTANDARD NAMING

  function ISROLE511(Role role) external view returns (bool hasRole);	//inject NONSTANDARD NAMING

  function ISDHARMASMARTWALLET695(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey
  ) external view returns (bool dharmaSmartWallet);

  function GETDEPOSITMANAGER250() external view returns (address depositManager);	//inject NONSTANDARD NAMING

  function GETADJUSTER715() external view returns (address adjuster);	//inject NONSTANDARD NAMING

  function GETRESERVETRADER735() external view returns (address reserveTrader);	//inject NONSTANDARD NAMING

  function GETWITHDRAWALMANAGER7() external view returns (address withdrawalManager);	//inject NONSTANDARD NAMING

  function GETPAUSER73() external view returns (address pauser);	//inject NONSTANDARD NAMING

  function GETRESERVES254() external view returns (	//inject NONSTANDARD NAMING
    uint256 dai, uint256 dDai, uint256 dDaiUnderlying
  );

  function GETDAILIMIT529() external view returns (	//inject NONSTANDARD NAMING
    uint256 daiAmount, uint256 dDaiAmount
  );

  function GETETHERLIMIT792() external view returns (uint256 etherAmount);	//inject NONSTANDARD NAMING

  function GETPRIMARYUSDCRECIPIENT771() external view returns (	//inject NONSTANDARD NAMING
    address recipient
  );

  function GETPRIMARYDAIRECIPIENT209() external view returns (	//inject NONSTANDARD NAMING
    address recipient
  );

  function GETIMPLEMENTATION393() external view returns (address implementation);	//inject NONSTANDARD NAMING

  function GETVERSION945() external view returns (uint256 version);	//inject NONSTANDARD NAMING
}


interface ERC20Interface {
  function BALANCEOF395(address) external view returns (uint256);	//inject NONSTANDARD NAMING
  function APPROVE301(address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
  function ALLOWANCE335(address, address) external view returns (uint256);	//inject NONSTANDARD NAMING
  function TRANSFER424(address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
  function TRANSFERFROM59(address, address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
}


interface DTokenInterface {
  function MINT835(uint256 underlyingToSupply) external returns (uint256 dTokensMinted);	//inject NONSTANDARD NAMING
  function REDEEM834(uint256 dTokensToBurn) external returns (uint256 underlyingReceived);	//inject NONSTANDARD NAMING
  function REDEEMUNDERLYING110(uint256 underlyingToReceive) external returns (uint256 dTokensBurned);	//inject NONSTANDARD NAMING
  function BALANCEOF395(address) external view returns (uint256);	//inject NONSTANDARD NAMING
  function BALANCEOFUNDERLYING111(address) external view returns (uint256);	//inject NONSTANDARD NAMING
  function TRANSFER424(address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
  function APPROVE301(address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
  function EXCHANGERATECURRENT826() external view returns (uint256);	//inject NONSTANDARD NAMING
}


interface TradeHelperInterface {
  function TRADEUSDCFORDDAI141(uint256 amountUSDC, uint256 quotedDaiEquivalentAmount) external returns (uint256 dDaiMinted);	//inject NONSTANDARD NAMING
  function TRADEDDAIFORUSDC353(uint256 amountDai, uint256 quotedUSDCAmount) external returns (uint256 usdcReceived);	//inject NONSTANDARD NAMING
  function GETEXPECTEDDAI468(uint256 usdc) external view returns (uint256 dai);	//inject NONSTANDARD NAMING
  function GETEXPECTEDUSDC440(uint256 dai) external view returns (uint256 usdc);	//inject NONSTANDARD NAMING
}


interface UniswapV1Interface {
  function ETHTOTOKENSWAPINPUT251(	//inject NONSTANDARD NAMING
    uint256 minTokens, uint256 deadline
  ) external payable returns (uint256 tokensBought);

  function TOKENTOETHTRANSFEROUTPUT929(	//inject NONSTANDARD NAMING
    uint256 ethBought, uint256 maxTokens, uint256 deadline, address recipient
  ) external returns (uint256 tokensSold);
}


interface UniswapV2Interface {
  function SWAPTOKENSFOREXACTTOKENS91(	//inject NONSTANDARD NAMING
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function SWAPEXACTTOKENSFORTOKENS457(	//inject NONSTANDARD NAMING
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);
  
  function SWAPEXACTTOKENSFORETH769(	//inject NONSTANDARD NAMING
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);
  
  function SWAPTOKENSFOREXACTETH731(	//inject NONSTANDARD NAMING
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);
  
  function SWAPETHFOREXACTTOKENS5(	//inject NONSTANDARD NAMING
    uint256 amountOut,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);
  
  function SWAPEXACTETHFORTOKENS903(	//inject NONSTANDARD NAMING
    uint256 amountOutMin, 
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);
}


interface EtherReceiverInterface {
  function SETTLEETHER955() external;	//inject NONSTANDARD NAMING
}


library SafeMath {
  function ADD510(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
    c = a + b;
    require(c >= a, "SafeMath: addition overflow");
    return c;
  }

  function MUL1(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    if (a == 0) return 0;
    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");
    return c;
  }

  function DIV802(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b > 0, "SafeMath: division by zero");
    return a / b;
  }
}


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
contract TwoStepOwnable {
  event OWNERSHIPTRANSFERRED461(	//inject NONSTANDARD NAMING
    address indexed previousOwner,
    address indexed newOwner
  );

  address private _owner;

  address private _newPotentialOwner;

                                                                                                                          
  function TRANSFEROWNERSHIP1000(address newOwner) external ONLYOWNER389 {	//inject NONSTANDARD NAMING
    require(
      newOwner != address(0),
      "TwoStepOwnable: new potential owner is the zero address."
    );

    _newPotentialOwner = newOwner;
  }

                                                                                                                    
  function CANCELOWNERSHIPTRANSFER705() external ONLYOWNER389 {	//inject NONSTANDARD NAMING
    delete _newPotentialOwner;
  }

                                                                                                                                                   
  function ACCEPTOWNERSHIP63() external {	//inject NONSTANDARD NAMING
    require(
      msg.sender == _newPotentialOwner,
      "TwoStepOwnable: current owner must set caller as new potential owner."
    );

    delete _newPotentialOwner;

    emit OWNERSHIPTRANSFERRED461(_owner, msg.sender);

    _owner = msg.sender;
  }

                                                               
  function OWNER109() external view returns (address) {	//inject NONSTANDARD NAMING
    return _owner;
  }

                                                                      
  function ISOWNER823() public view returns (bool) {	//inject NONSTANDARD NAMING
    return msg.sender == _owner;
  }

                                                                           
  modifier ONLYOWNER389() {	//inject NONSTANDARD NAMING
    require(ISOWNER823(), "TwoStepOwnable: caller is not the owner.");
    _;
  }
}


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
contract DharmaTradeReserveV9ImplementationStaging is DharmaTradeReserveV9Interface, TwoStepOwnable {
  using SafeMath for uint256;

  // Maintain a role status mapping with assigned accounts and paused states.
  mapping(uint256 => RoleStatus) private _roles;

  // Maintain a "primary recipient" the withdrawal manager can transfer Dai to.
  address private _primaryDaiRecipient;

  // Maintain a "primary recipient" the withdrawal manager can transfer USDC to.
  address private _primaryUSDCRecipient;

  // Maintain a maximum allowable transfer size (in Dai) for the deposit manager.
  uint256 private _daiLimit;

  // Maintain a maximum allowable transfer size (in Ether) for the deposit manager.
  uint256 private _etherLimit;

  bool private _originatesFromReserveTrader; // unused, don't change storage layout

  uint256 private constant _version934 = 8;	//inject NONSTANDARD NAMING

  // This contract interacts with USDC, Dai, and Dharma Dai.
  ERC20Interface internal constant _usdc172 = ERC20Interface(	//inject NONSTANDARD NAMING
    0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // mainnet
  );

  ERC20Interface internal constant _dai939 = ERC20Interface(	//inject NONSTANDARD NAMING
    0x6B175474E89094C44Da98b954EedeAC495271d0F // mainnet
  );

  ERC20Interface internal constant _etherizer566 = ERC20Interface(	//inject NONSTANDARD NAMING
    0x723B51b72Ae89A3d0c2a2760f0458307a1Baa191
  );

  DTokenInterface internal constant _ddai325 = DTokenInterface(	//inject NONSTANDARD NAMING
    0x00000000001876eB1444c986fD502e618c587430
  );

  TradeHelperInterface internal constant _trade_helper648 = TradeHelperInterface(	//inject NONSTANDARD NAMING
    0x9328F2Fb3e85A4d24Adc2f68F82737183e85691d
  );

  UniswapV1Interface internal constant _uniswap_dai496 = UniswapV1Interface(	//inject NONSTANDARD NAMING
    0x2a1530C4C41db0B0b2bB646CB5Eb1A67b7158667
  );
  
  UniswapV2Interface internal constant _uniswap_router877 = UniswapV2Interface(	//inject NONSTANDARD NAMING
    0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
  );
  
  EtherReceiverInterface internal constant _eth_receiver459 = EtherReceiverInterface(	//inject NONSTANDARD NAMING
    0xaf84687D21736F5E06f738c6F065e88890465E7c
  );
  
  address internal constant _weth740 = address(	//inject NONSTANDARD NAMING
    0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
  );

  // The "Create2 Header" is used to compute smart wallet deployment addresses.
  bytes21 internal constant _create2_header376 = bytes21(	//inject NONSTANDARD NAMING
    0xff8D1e00b000e56d5BcB006F3a008Ca6003b9F0033 // control character + factory
  );
  
  // The "Wallet creation code" header & footer are also used to derive wallets.
  bytes internal constant _wallet_creation_code_header138 = hex"60806040526040516104423803806104428339818101604052602081101561002657600080fd5b810190808051604051939291908464010000000082111561004657600080fd5b90830190602082018581111561005b57600080fd5b825164010000000081118282018810171561007557600080fd5b82525081516020918201929091019080838360005b838110156100a257818101518382015260200161008a565b50505050905090810190601f1680156100cf5780820380516001836020036101000a031916815260200191505b5060405250505060006100e661019e60201b60201c565b6001600160a01b0316826040518082805190602001908083835b6020831061011f5780518252601f199092019160209182019101610100565b6001836020036101000a038019825116818451168082178552505050505050905001915050600060405180830381855af49150503d806000811461017f576040519150601f19603f3d011682016040523d82523d6000602084013e610184565b606091505b5050905080610197573d6000803e3d6000fd5b50506102be565b60405160009081906060906eb45d6593312ac9fde193f3d06336449083818181855afa9150503d80600081146101f0576040519150601f19603f3d011682016040523d82523d6000602084013e6101f5565b606091505b509150915081819061029f576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825283818151815260200191508051906020019080838360005b8381101561026457818101518382015260200161024c565b50505050905090810190601f1680156102915780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b508080602001905160208110156102b557600080fd5b50519392505050565b610175806102cd6000396000f3fe608060405261001461000f610016565b61011c565b005b60405160009081906060906eb45d6593312ac9fde193f3d06336449083818181855afa9150503d8060008114610068576040519150601f19603f3d011682016040523d82523d6000602084013e61006d565b606091505b50915091508181906100fd5760405162461bcd60e51b81526004018080602001828103825283818151815260200191508051906020019080838360005b838110156100c25781810151838201526020016100aa565b50505050905090810190601f1680156100ef5780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b5080806020019051602081101561011357600080fd5b50519392505050565b3660008037600080366000845af43d6000803e80801561013b573d6000f35b3d6000fdfea265627a7a723158203c578cc1552f1d1b48134a72934fe12fb89a29ff396bd514b9a4cebcacc5cacc64736f6c634300050b003200000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000024c4d66de8000000000000000000000000";	//inject NONSTANDARD NAMING
  bytes28 internal constant _wallet_creation_code_footer303 = bytes28(	//inject NONSTANDARD NAMING
    0x00000000000000000000000000000000000000000000000000000000
  );

  // Include a payable fallback so that the contract can receive Ether payments.
  function () external payable {
    emit ETHERRECEIVED855(msg.sender, msg.value);
  }

  function INITIALIZE669() external {	//inject NONSTANDARD NAMING
    // Approve Uniswap router to transfer Dai on behalf of this contract.
    if (_dai939.ALLOWANCE335(address(this), address(_uniswap_router877)) != uint256(-1)) {
      bool ok = _dai939.APPROVE301(address(_uniswap_router877), uint256(-1));
      require(ok, "Dai approval for Uniswap router failed.");
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  function TRADEDAIFORETHER899(	//inject NONSTANDARD NAMING
    uint256 daiAmount,
    uint256 quotedEtherAmount,
    uint256 deadline
  ) external returns (uint256 totalDaiSold) {
    // Transfer the Dai from the caller and revert on failure.
    _TRANSFERINTOKEN213(_dai939, msg.sender, daiAmount);

    // Trade the Dai for the quoted Ether amount on Uniswap and send to caller.
    totalDaiSold = _uniswap_dai496.TOKENTOETHTRANSFEROUTPUT929(
      quotedEtherAmount, daiAmount, deadline, msg.sender
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function TRADEDAIFORETHERV2950(	//inject NONSTANDARD NAMING
    uint256 daiAmount,
    uint256 quotedEtherAmount,
    uint256 deadline
  ) external returns (uint256 totalDaiSold) {
    // Transfer the Dai from the caller and revert on failure.
    _TRANSFERINTOKEN213(_dai939, msg.sender, daiAmount);

    // Establish path from Dai to Ether.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      address(_dai939), _weth740, false
    );

    // Trade Dai for quoted Ether amount on Uniswap (send to the caller).
    amounts = _uniswap_router877.SWAPTOKENSFOREXACTETH731(
      quotedEtherAmount, daiAmount, path, msg.sender, deadline
    );
    totalDaiSold = amounts[0];
  }

  function TRADETOKENFORETHER84(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmount, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalEtherBought) {
    // Transfer the tokens from the caller and revert on failure.
    _TRANSFERINTOKEN213(token, msg.sender, tokenAmount);
    
    // Approve Uniswap router to transfer tokens on behalf of this contract.
    _GRANTUNISWAPROUTERAPPROVALIFNECESSARY324(token);

    // Establish path from target token to Ether.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      address(token), _weth740, false
    );

    // Trade tokens for quoted Ether amount on Uniswap (send to this contract).
    amounts = _uniswap_router877.SWAPEXACTTOKENSFORETH769(
      tokenAmount, quotedEtherAmount, path, address(this), deadline
    );
    totalEtherBought = amounts[1];
    
    // Send quoted Ether amount to caller and revert with reason on failure.
    (bool ok, ) = msg.sender.call.value(quotedEtherAmount)("");
    if (!ok) {
      assembly {
        returndatacopy(0, 0, returndatasize)
        revert(0, returndatasize)
      }
    }
  }

  function TRADEDAIFORTOKEN107(	//inject NONSTANDARD NAMING
    address token, uint256 daiAmount, uint256 quotedTokenAmount, uint256 deadline, bool routeThroughEther
  ) external returns (uint256 totalDaiSold) {
    // Transfer the Dai from the caller and revert on failure.
    _TRANSFERINTOKEN213(_dai939, msg.sender, daiAmount);
    
    // Establish path (direct or routed through Ether) from Dai to target token.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      address(_dai939), token, routeThroughEther
    );
    
    // Trade the Dai for the quoted token amount on Uniswap and send to caller.
    amounts = _uniswap_router877.SWAPTOKENSFOREXACTTOKENS91(
      quotedTokenAmount, daiAmount, path, msg.sender, deadline
    );
    
    totalDaiSold = amounts[0];
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function TRADEDAIFORETHERUSINGRESERVES556(	//inject NONSTANDARD NAMING
    uint256 daiAmountFromReserves, uint256 quotedEtherAmount, uint256 deadline
  ) external ONLYOWNEROR665(Role.RESERVE_TRADER) returns (uint256 totalDaiSold) {
    // Redeem dDai if the current Dai balance is less than is required.
    uint256 daiBalance = _dai939.BALANCEOF395(address(this));
    if (daiBalance < daiAmountFromReserves) {
      uint256 additionalDaiRequired = daiAmountFromReserves - daiBalance;
      _ddai325.REDEEMUNDERLYING110(additionalDaiRequired);
    }

    // Trade the Dai for the quoted Ether amount on Uniswap.
    totalDaiSold = _uniswap_dai496.TOKENTOETHTRANSFEROUTPUT929(
      quotedEtherAmount,
      daiAmountFromReserves,
      deadline,
      address(_eth_receiver459)
    );
    
    // Move the Ether from the receiver to this contract (gas workaround).
    _eth_receiver459.SETTLEETHER955();
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function TRADEDAIFORETHERUSINGRESERVESV2121(	//inject NONSTANDARD NAMING
    uint256 daiAmountFromReserves, uint256 quotedEtherAmount, uint256 deadline
  ) external ONLYOWNEROR665(Role.RESERVE_TRADER) returns (uint256 totalDaiSold) {
    // Redeem dDai if the current Dai balance is less than is required.
    uint256 daiBalance = _dai939.BALANCEOF395(address(this));
    if (daiBalance < daiAmountFromReserves) {
      uint256 additionalDaiRequired = daiAmountFromReserves - daiBalance;
      _ddai325.REDEEMUNDERLYING110(additionalDaiRequired);
    }

    // Establish path from Dai to Ether.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      address(_dai939), _weth740, false
    );

    // Trade Dai for quoted Ether amount on Uniswap (send to this contract).
    amounts = _uniswap_router877.SWAPTOKENSFOREXACTETH731(
      quotedEtherAmount, daiAmountFromReserves, path, address(this), deadline
    );
    totalDaiSold = amounts[0];
  }

  function TRADETOKENFORETHERUSINGRESERVES915(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmountFromReserves, uint256 quotedEtherAmount, uint256 deadline
  ) external ONLYOWNEROR665(Role.RESERVE_TRADER) returns (uint256 totalEtherBought) {
    // Approve Uniswap router to transfer tokens on behalf of this contract.
    _GRANTUNISWAPROUTERAPPROVALIFNECESSARY324(token);

    // Establish path from target token to Ether.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      address(token), _weth740, false
    );

    // Trade tokens for quoted Ether amount on Uniswap (send to this contract).
    amounts = _uniswap_router877.SWAPEXACTTOKENSFORETH769(
      tokenAmountFromReserves, quotedEtherAmount, path, address(this), deadline
    );
    totalEtherBought = amounts[1];
  }

                                                                                                                                                                                                                                                                                                                                                                       
  function TRADEETHERFORDAI795(	//inject NONSTANDARD NAMING
    uint256 quotedDaiAmount,
    uint256 deadline
  ) external payable returns (uint256 totalDaiBought) {
    // Trade the Ether for the quoted Dai amount on Uniswap.
    totalDaiBought = _uniswap_dai496.ETHTOTOKENSWAPINPUT251.value(msg.value)(
      quotedDaiAmount, deadline
    );

    // Transfer the Dai to the caller and revert on failure.
    _TRANSFERTOKEN930(_dai939, msg.sender, quotedDaiAmount);
  }

                                                                                                                                                                                                                                                                                                                                                                         
  function TRADEETHERFORDAIV2625(	//inject NONSTANDARD NAMING
    uint256 quotedDaiAmount,
    uint256 deadline
  ) external payable returns (uint256 totalDaiBought) {
    // Establish path from Ether to Dai.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      _weth740, address(_dai939), false
    );
   
    // Trade Ether for Dai on Uniswap (send to this contract).
    amounts = _uniswap_router877.SWAPEXACTETHFORTOKENS903.value(msg.value)(
      quotedDaiAmount, path, address(this), deadline
    );
    totalDaiBought = amounts[1];

    // Transfer the Dai to the caller and revert on failure.
    _TRANSFERTOKEN930(_dai939, msg.sender, quotedDaiAmount);
  }

  function TRADEETHERFORTOKEN818(	//inject NONSTANDARD NAMING
    address token, uint256 quotedTokenAmount, uint256 deadline
  ) external payable returns (uint256 totalEtherSold) {
    // Establish path from Ether to target token.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      _weth740, address(token), false
    );
      
    // Trade Ether for quoted token amount on Uniswap and send to caller.
    amounts = _uniswap_router877.SWAPETHFOREXACTTOKENS5.value(msg.value)(
      quotedTokenAmount, path, msg.sender, deadline
    );
    totalEtherSold = amounts[0];
  }

  function TRADEETHERFORTOKENUSINGETHERIZER867(	//inject NONSTANDARD NAMING
    address token, uint256 etherAmount, uint256 quotedTokenAmount, uint256 deadline
  ) external returns (uint256 totalEtherSold) {
    // Transfer the Ether from the caller and revert on failure.
    _TRANSFERINTOKEN213(_etherizer566, msg.sender, etherAmount);
      
    // Establish path from Ether to target token.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      _weth740, address(token), false
    );
      
    // Trade Ether for quoted token amount on Uniswap and send to caller.
    amounts = _uniswap_router877.SWAPETHFOREXACTTOKENS5.value(etherAmount)(
      quotedTokenAmount, path, msg.sender, deadline
    );
    totalEtherSold = amounts[0];
  }
  
  function TRADETOKENFORDAI864(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmount, uint256 quotedDaiAmount, uint256 deadline, bool routeThroughEther
  ) external returns (uint256 totalDaiBought) {
    // Transfer the token from the caller and revert on failure.
    _TRANSFERINTOKEN213(token, msg.sender, tokenAmount);
    
    // Approve Uniswap router to transfer tokens on behalf of this contract.
    _GRANTUNISWAPROUTERAPPROVALIFNECESSARY324(token);
    
    // Establish path (direct or routed through Ether) from target token to Dai.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      address(token), address(_dai939), routeThroughEther
    );
    
    // Trade the Dai for the quoted token amount on Uniswap and send to caller.
    amounts = _uniswap_router877.SWAPEXACTTOKENSFORTOKENS457(
      tokenAmount, quotedDaiAmount, path, msg.sender, deadline
    );
    
    totalDaiBought = amounts[path.length - 1];
    
    // Transfer the Dai to the caller and revert on failure.
    _TRANSFERTOKEN930(_dai939, msg.sender, quotedDaiAmount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function TRADEETHERFORDAIUSINGRESERVESANDMINTDDAI322(	//inject NONSTANDARD NAMING
    uint256 etherAmountFromReserves, uint256 quotedDaiAmount, uint256 deadline
  ) external ONLYOWNEROR665(Role.RESERVE_TRADER) returns (
    uint256 totalDaiBought, uint256 totalDDaiMinted
  ) {
    // Trade the Ether for the quoted Dai amount on Uniswap.
    totalDaiBought = _uniswap_dai496.ETHTOTOKENSWAPINPUT251.value(
      etherAmountFromReserves
    )(
      quotedDaiAmount, deadline
    );

    // Mint dDai using the received Dai.
    totalDDaiMinted = _ddai325.MINT835(totalDaiBought);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
  function TRADEETHERFORDAIUSINGRESERVESANDMINTDDAIV298(	//inject NONSTANDARD NAMING
    uint256 etherAmountFromReserves, uint256 quotedDaiAmount, uint256 deadline
  ) external ONLYOWNEROR665(Role.RESERVE_TRADER) returns (
    uint256 totalDaiBought, uint256 totalDDaiMinted
  ) {
    // Establish path from Ether to Dai.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      _weth740, address(_dai939), false
    );
   
    // Trade Ether for Dai on Uniswap (send to this contract).
    amounts = _uniswap_router877.SWAPEXACTETHFORTOKENS903.value(
      etherAmountFromReserves
    )(
      quotedDaiAmount, path, address(this), deadline
    );
    totalDaiBought = amounts[1];

    // Mint dDai using the received Dai.
    totalDDaiMinted = _ddai325.MINT835(totalDaiBought);
  }

  function TRADEETHERFORTOKENUSINGRESERVES405(	//inject NONSTANDARD NAMING
    address token, uint256 etherAmountFromReserves, uint256 quotedTokenAmount, uint256 deadline
  ) external ONLYOWNEROR665(Role.RESERVE_TRADER) returns (uint256 totalEtherSold) {
    // Establish path from Ether to target token.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      _weth740, address(token), false
    );
      
    // Trade Ether for quoted token amount on Uniswap and send to this contract.
    amounts = _uniswap_router877.SWAPETHFOREXACTTOKENS5.value(etherAmountFromReserves)(
      quotedTokenAmount, path, address(this), deadline
    );
    totalEtherSold = amounts[0];
  }

  function TRADEDAIFORTOKENUSINGRESERVES528(	//inject NONSTANDARD NAMING
    address token, uint256 daiAmountFromReserves, uint256 quotedTokenAmount, uint256 deadline, bool routeThroughEther
  ) external ONLYOWNEROR665(Role.RESERVE_TRADER) returns (uint256 totalDaiSold) {
    // Redeem dDai if the current Dai balance is less than is required.
    uint256 daiBalance = _dai939.BALANCEOF395(address(this));
    if (daiBalance < daiAmountFromReserves) {
      uint256 additionalDaiRequired = daiAmountFromReserves - daiBalance;
      _ddai325.REDEEMUNDERLYING110(additionalDaiRequired);
    }
    
    // Establish path (direct or routed through Ether) from Dai to target token.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      address(_dai939), address(token), routeThroughEther
    );
    
    // Trade the Dai for the quoted token amount on Uniswap.
    amounts = _uniswap_router877.SWAPTOKENSFOREXACTTOKENS91(
      quotedTokenAmount, daiAmountFromReserves, path, address(this), deadline
    );
    
    totalDaiSold = amounts[0];
  }

  function TRADETOKENFORDAIUSINGRESERVESANDMINTDDAI549(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmountFromReserves, uint256 quotedDaiAmount, uint256 deadline, bool routeThroughEther
  ) external ONLYOWNEROR665(Role.RESERVE_TRADER) returns (
    uint256 totalDaiBought, uint256 totalDDaiMinted
  ) {
    // Approve Uniswap router to transfer tokens on behalf of this contract.
    _GRANTUNISWAPROUTERAPPROVALIFNECESSARY324(token);
    
    // Establish path (direct or routed through Ether) from target token to Dai.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS796(
      address(token), address(_dai939), routeThroughEther
    );
    
    // Trade the Dai for the quoted token amount on Uniswap.
    amounts = _uniswap_router877.SWAPEXACTTOKENSFORTOKENS457(
      tokenAmountFromReserves, quotedDaiAmount, path, address(this), deadline
    );
    
    totalDaiBought = amounts[path.length - 1];
    
    // Mint dDai using the received Dai.
    totalDDaiMinted = _ddai325.MINT835(totalDaiBought);
  }
  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  function FINALIZEDAIDEPOSIT931(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey, uint256 daiAmount
  ) external ONLYOWNEROR665(Role.DEPOSIT_MANAGER) {
    // Ensure that the recipient is indeed a smart wallet.
    _ENSURESMARTWALLET516(smartWallet, initialUserSigningKey);

    // Ensure that the amount to transfer is lower than the limit.
    require(daiAmount < _daiLimit, "Transfer size exceeds the limit.");

    // Transfer the Dai to the specified smart wallet.
    _TRANSFERTOKEN930(_dai939, smartWallet, daiAmount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  function FINALIZEDHARMADAIDEPOSIT237(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey, uint256 dDaiAmount
  ) external ONLYOWNEROR665(Role.DEPOSIT_MANAGER) {
    // Ensure that the recipient is indeed a smart wallet.
    _ENSURESMARTWALLET516(smartWallet, initialUserSigningKey);

    // Get the current dDai exchange rate.
    uint256 exchangeRate = _ddai325.EXCHANGERATECURRENT826();

    // Ensure that an exchange rate was actually returned.
    require(exchangeRate != 0, "Could not retrieve dDai exchange rate.");

    // Get the equivalent Dai amount of the transfer.
    uint256 daiEquivalent = (dDaiAmount.MUL1(exchangeRate)) / 1e18;

    // Ensure that the amount to transfer is lower than the limit.
    require(daiEquivalent < _daiLimit, "Transfer size exceeds the limit.");

    // Transfer the dDai to the specified smart wallet.
    _TRANSFERTOKEN930(ERC20Interface(address(_ddai325)), smartWallet, dDaiAmount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
  function FINALIZEETHERDEPOSIT298(	//inject NONSTANDARD NAMING
    address payable smartWallet,
    address initialUserSigningKey,
    uint256 etherAmount
  ) external ONLYOWNEROR665(Role.DEPOSIT_MANAGER) {
    // Ensure that the recipient is indeed a smart wallet.
    _ENSURESMARTWALLET516(smartWallet, initialUserSigningKey);

    // Ensure that the amount to transfer is lower than the limit.
    require(etherAmount < _etherLimit, "Transfer size exceeds the limit.");

    // Transfer the Ether to the specified smart wallet.
    bool ok;
    (ok, ) = smartWallet.call.value(etherAmount)("");
    if (!ok) {
      assembly {
        returndatacopy(0, 0, returndatasize)
        revert(0, returndatasize)
      }
    }
  }

                                                                                                                                                                                                                                                                               
  function MINT835(	//inject NONSTANDARD NAMING
    uint256 daiAmount
  ) external ONLYOWNEROR665(Role.ADJUSTER) returns (uint256 dDaiMinted) {
    // Use the specified amount of Dai to mint dDai.
    dDaiMinted = _ddai325.MINT835(daiAmount);
  }

                                                                                                                                                                                                                                                                                    
  function REDEEM834(	//inject NONSTANDARD NAMING
    uint256 dDaiAmount
  ) external ONLYOWNEROR665(Role.ADJUSTER) returns (uint256 daiReceived) {
    // Redeem the specified amount of dDai for Dai.
    daiReceived = _ddai325.REDEEM834(dDaiAmount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function TRADEUSDCFORDDAI141(	//inject NONSTANDARD NAMING
    uint256 usdcAmount,
    uint256 quotedDaiEquivalentAmount
  ) external ONLYOWNEROR665(Role.ADJUSTER) returns (uint256 dDaiMinted) {
    dDaiMinted = _trade_helper648.TRADEUSDCFORDDAI141(
       usdcAmount, quotedDaiEquivalentAmount
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  function TRADEDDAIFORUSDC353(	//inject NONSTANDARD NAMING
    uint256 daiEquivalentAmount,
    uint256 quotedUSDCAmount
  ) external ONLYOWNEROR665(Role.ADJUSTER) returns (uint256 usdcReceived) {
    usdcReceived = _trade_helper648.TRADEDDAIFORUSDC353(
      daiEquivalentAmount, quotedUSDCAmount
    );
  }

                                                                                                                                                                                                                                                                                        
  function WITHDRAWUSDCTOPRIMARYRECIPIENT422(	//inject NONSTANDARD NAMING
    uint256 usdcAmount
  ) external ONLYOWNEROR665(Role.WITHDRAWAL_MANAGER) {
    // Get the current primary recipient.
    address primaryRecipient = _primaryUSDCRecipient;
    require(
      primaryRecipient != address(0), "No USDC primary recipient currently set."
    );

    // Transfer the supplied USDC amount to the primary recipient.
    _TRANSFERTOKEN930(_usdc172, primaryRecipient, usdcAmount);
  }

                                                                                                                                                                                                                                                                                    
  function WITHDRAWDAITOPRIMARYRECIPIENT762(	//inject NONSTANDARD NAMING
    uint256 daiAmount
  ) external ONLYOWNEROR665(Role.WITHDRAWAL_MANAGER) {
    // Get the current primary recipient.
    address primaryRecipient = _primaryDaiRecipient;
    require(
      primaryRecipient != address(0), "No Dai primary recipient currently set."
    );

    // Transfer the supplied Dai amount to the primary recipient.
    _TRANSFERTOKEN930(_dai939, primaryRecipient, daiAmount);
  }

                                                                                                                                                                                                                                             
  function WITHDRAWUSDC678(	//inject NONSTANDARD NAMING
    address recipient, uint256 usdcAmount
  ) external ONLYOWNER389 {
    // Transfer the USDC to the specified recipient.
    _TRANSFERTOKEN930(_usdc172, recipient, usdcAmount);
  }

                                                                                                                                                                                                                                        
  function WITHDRAWDAI49(	//inject NONSTANDARD NAMING
    address recipient, uint256 daiAmount
  ) external ONLYOWNER389 {
    // Transfer the Dai to the specified recipient.
    _TRANSFERTOKEN930(_dai939, recipient, daiAmount);
  }

                                                                                                                                                                                                                                                               
  function WITHDRAWDHARMADAI777(	//inject NONSTANDARD NAMING
    address recipient, uint256 dDaiAmount
  ) external ONLYOWNER389 {
    // Transfer the dDai to the specified recipient.
    _TRANSFERTOKEN930(ERC20Interface(address(_ddai325)), recipient, dDaiAmount);
  }

                                                                                                                                                                                                                                                  
  function WITHDRAWETHER204(	//inject NONSTANDARD NAMING
    address payable recipient, uint256 etherAmount
  ) external ONLYOWNER389 {
    bool ok;

    // Transfer the Ether to the specified recipient.
    (ok, ) = recipient.call.value(etherAmount)("");
    if (!ok) {
      assembly {
        returndatacopy(0, 0, returndatasize)
        revert(0, returndatasize)
      }
    }
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function WITHDRAW439(	//inject NONSTANDARD NAMING
    ERC20Interface token, address recipient, uint256 amount
  ) external ONLYOWNER389 returns (bool success) {
    // Transfer the token to the specified recipient.
    success = token.TRANSFER424(recipient, amount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  function CALLANY778(	//inject NONSTANDARD NAMING
    address payable target, uint256 amount, bytes calldata data
  ) external ONLYOWNER389 returns (bool ok, bytes memory returnData) {
    // Call the specified target and supply the specified data.
    (ok, returnData) = target.call.value(amount)(data);
  }

                                                                                                                                                                                                                       
  function SETDAILIMIT345(uint256 daiAmount) external ONLYOWNER389 {	//inject NONSTANDARD NAMING
    // Set the new limit.
    _daiLimit = daiAmount;
  }

                                                                                                                                                                                                                           
  function SETETHERLIMIT550(uint256 etherAmount) external ONLYOWNER389 {	//inject NONSTANDARD NAMING
    // Set the new limit.
    _etherLimit = etherAmount;
  }

                                                                                                                                                                                                
  function SETPRIMARYUSDCRECIPIENT259(address recipient) external ONLYOWNER389 {	//inject NONSTANDARD NAMING
    // Set the new primary recipient.
    _primaryUSDCRecipient = recipient;
  }

                                                                                                                                                                                               
  function SETPRIMARYDAIRECIPIENT972(address recipient) external ONLYOWNER389 {	//inject NONSTANDARD NAMING
    // Set the new primary recipient.
    _primaryDaiRecipient = recipient;
  }

                                                                                                                                                                                                                                                                            
  function PAUSE504(Role role) external ONLYOWNEROR665(Role.PAUSER) {	//inject NONSTANDARD NAMING
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];
    require(!storedRoleStatus.paused, "Role in question is already paused.");
    storedRoleStatus.paused = true;
    emit ROLEPAUSED516(role);
  }

                                                                                                                                                                         
  function UNPAUSE768(Role role) external ONLYOWNER389 {	//inject NONSTANDARD NAMING
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];
    require(storedRoleStatus.paused, "Role in question is already unpaused.");
    storedRoleStatus.paused = false;
    emit ROLEUNPAUSED425(role);
  }

                                                                                                                                                                                                                                                                                                        
  function SETROLE712(Role role, address account) external ONLYOWNER389 {	//inject NONSTANDARD NAMING
    require(account != address(0), "Must supply an account.");
    _SETROLE905(role, account);
  }

                                                                                                                                                                                                                                                               
  function REMOVEROLE29(Role role) external ONLYOWNER389 {	//inject NONSTANDARD NAMING
    _SETROLE905(role, address(0));
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
  function ISPAUSED423(Role role) external view returns (bool paused) {	//inject NONSTANDARD NAMING
    paused = _ISPAUSED128(role);
  }

                                                                                                                                                                                                                            
  function ISROLE511(Role role) external view returns (bool hasRole) {	//inject NONSTANDARD NAMING
    hasRole = _ISROLE24(role);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  function ISDHARMASMARTWALLET695(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey
  ) external view returns (bool dharmaSmartWallet) {
    dharmaSmartWallet = _ISSMARTWALLET926(smartWallet, initialUserSigningKey);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function GETDEPOSITMANAGER250() external view returns (address depositManager) {	//inject NONSTANDARD NAMING
    depositManager = _roles[uint256(Role.DEPOSIT_MANAGER)].account;
  }

                                                                                                                                                                                                                                                                                                                
  function GETADJUSTER715() external view returns (address adjuster) {	//inject NONSTANDARD NAMING
    adjuster = _roles[uint256(Role.ADJUSTER)].account;
  }

                                                                                                                                                                                                                                                                                                                             
  function GETRESERVETRADER735() external view returns (address reserveTrader) {	//inject NONSTANDARD NAMING
    reserveTrader = _roles[uint256(Role.RESERVE_TRADER)].account;
  }

                                                                                                                                                                                                                                                                                                                                
  function GETWITHDRAWALMANAGER7() external view returns (address withdrawalManager) {	//inject NONSTANDARD NAMING
    withdrawalManager = _roles[uint256(Role.WITHDRAWAL_MANAGER)].account;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function GETPAUSER73() external view returns (address pauser) {	//inject NONSTANDARD NAMING
    pauser = _roles[uint256(Role.PAUSER)].account;
  }

                                                                                                                                                                                                                                                  
  function GETRESERVES254() external view returns (	//inject NONSTANDARD NAMING
    uint256 dai, uint256 dDai, uint256 dDaiUnderlying
  ) {
    dai = _dai939.BALANCEOF395(address(this));
    dDai = _ddai325.BALANCEOF395(address(this));
    dDaiUnderlying = _ddai325.BALANCEOFUNDERLYING111(address(this));
  }

                                                                                                                                                                                                                                                                               
  function GETDAILIMIT529() external view returns (	//inject NONSTANDARD NAMING
    uint256 daiAmount, uint256 dDaiAmount
  ) {
    daiAmount = _daiLimit;
    dDaiAmount = (daiAmount.MUL1(1e18)).DIV802(_ddai325.EXCHANGERATECURRENT826());
  }

                                                                                                                                                                                                                               
  function GETETHERLIMIT792() external view returns (uint256 etherAmount) {	//inject NONSTANDARD NAMING
    etherAmount = _etherLimit;
  }

                                                                                                                                                                 
  function GETPRIMARYUSDCRECIPIENT771() external view returns (	//inject NONSTANDARD NAMING
    address recipient
  ) {
    recipient = _primaryUSDCRecipient;
  }

                                                                                                                                                               
  function GETPRIMARYDAIRECIPIENT209() external view returns (	//inject NONSTANDARD NAMING
    address recipient
  ) {
    recipient = _primaryDaiRecipient;
  }

  function GETIMPLEMENTATION393() external view returns (	//inject NONSTANDARD NAMING
    address implementation
  ) {
    (bool ok, bytes memory returnData) = address(
      0x481B1a16E6675D33f8BBb3a6A58F5a9678649718
    ).staticcall("");
    require(ok && returnData.length == 32, "Invalid implementation.");
    implementation = abi.decode(returnData, (address));
  }

  function GETVERSION945() external view returns (uint256 version) {	//inject NONSTANDARD NAMING
    version = _version934;
  }
  
  function _GRANTUNISWAPROUTERAPPROVALIFNECESSARY324(ERC20Interface token) internal {	//inject NONSTANDARD NAMING
    // Approve Uniswap router to transfer tokens on behalf of this contract.
    if (token.ALLOWANCE335(address(this), address(_uniswap_router877)) != uint256(-1)) {
      (bool success, bytes memory data) = address(token).call(
        abi.encodeWithSelector(
          token.APPROVE301.selector, address(_uniswap_router877), uint256(-1)
        )
      );
      require(
        success && (data.length == 0 || abi.decode(data, (bool))),
        "Token approval for Uniswap router failed."
      );
    }
  }

                                                                                                                                                                                                                                                                                                                                                                  
  function _SETROLE905(Role role, address account) internal {	//inject NONSTANDARD NAMING
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];

    if (account != storedRoleStatus.account) {
      storedRoleStatus.account = account;
      emit ROLEMODIFIED858(role, account);
    }
  }

                                                                                                                                                                                                                            
  function _ISROLE24(Role role) internal view returns (bool hasRole) {	//inject NONSTANDARD NAMING
    hasRole = msg.sender == _roles[uint256(role)].account;
  }

                                                                                                                                                                                                                        
  function _ISPAUSED128(Role role) internal view returns (bool paused) {	//inject NONSTANDARD NAMING
    paused = _roles[uint256(role)].paused;
  }

                                                                                                                                                                                                                                                                                                                                                     
  function _ISSMARTWALLET926(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey
  ) internal pure returns (bool) {
    // Derive the keccak256 hash of the smart wallet initialization code.
    bytes32 initCodeHash = keccak256(
      abi.encodePacked(
        _wallet_creation_code_header138,
        initialUserSigningKey,
        _wallet_creation_code_footer303
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
                _create2_header376, // pass in control character + factory address.
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
  
  function _TRANSFERTOKEN930(ERC20Interface token, address to, uint256 amount) internal {	//inject NONSTANDARD NAMING
    (bool success, bytes memory data) = address(token).call(
      abi.encodeWithSelector(token.TRANSFER424.selector, to, amount)
    );
    require(
      success && (data.length == 0 || abi.decode(data, (bool))),
      'Transfer out failed.'
    );
  }

  function _TRANSFERINTOKEN213(ERC20Interface token, address from, uint256 amount) internal {	//inject NONSTANDARD NAMING
    (bool success, bytes memory data) = address(token).call(
      abi.encodeWithSelector(token.TRANSFERFROM59.selector, from, address(this), amount)
    );

    require(
      success && (data.length == 0 || abi.decode(data, (bool))),
      'Transfer in failed.'
    );
  }
  
  function _ENSURESMARTWALLET516(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey
  ) internal view {
    require(
      _ISSMARTWALLET926(smartWallet, initialUserSigningKey),
      "Could not resolve smart wallet using provided signing key."
    );
  }
  
  function _CREATEPATHANDAMOUNTS796(	//inject NONSTANDARD NAMING
    address start, address end, bool routeThroughEther
  ) internal pure returns (address[] memory, uint256[] memory) {
    uint256 pathLength = routeThroughEther ? 3 : 2;
    address[] memory path = new address[](pathLength);
    path[0] = start;
    
    if (routeThroughEther) {
      path[1] = _weth740;
    }

    path[pathLength - 1] = end;

    return (path, new uint256[](pathLength));
  }

                                                                                                                                                                                                                                                                      
  modifier ONLYOWNEROR665(Role role) {	//inject NONSTANDARD NAMING
    if (!ISOWNER823()) {
      require(_ISROLE24(role), "Caller does not have a required role.");
      require(!_ISPAUSED128(role), "Role in question is currently paused.");
    }
    _;
  }
}