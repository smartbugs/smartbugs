                                                                 

pragma solidity 0.5.17; // optimization runs: 200, evm version: istanbul


interface DharmaTradeReserveV14Interface {
  event TRADE504(	//inject NONSTANDARD NAMING
    address account,
    address suppliedAsset,
    address receivedAsset,
    address retainedAsset,
    uint256 suppliedAmount,
    uint256 recievedAmount,
    uint256 retainedAmount
  );
  event ROLEMODIFIED267(Role indexed role, address account);	//inject NONSTANDARD NAMING
  event ROLEPAUSED190(Role indexed role);	//inject NONSTANDARD NAMING
  event ROLEUNPAUSED454(Role indexed role);	//inject NONSTANDARD NAMING
  event ETHERRECEIVED220(address sender, uint256 amount);	//inject NONSTANDARD NAMING
  event GASRESERVEREFILLED158(uint256 etherAmount);	//inject NONSTANDARD NAMING

  enum Role {            // #
    DEPOSIT_MANAGER,     // 0
    ADJUSTER,            // 1
    WITHDRAWAL_MANAGER,  // 2
    RESERVE_TRADER,      // 3
    PAUSER,              // 4
    GAS_RESERVE_REFILLER // 5
  }
  
  enum TradeType {
    DAI_TO_TOKEN,
    DAI_TO_ETH,
    ETH_TO_DAI,
    TOKEN_TO_DAI,
    ETH_TO_TOKEN,
    TOKEN_TO_ETH,
    TOKEN_TO_TOKEN
  }

  struct RoleStatus {
    address account;
    bool paused;
  }

  function TRADEDAIFORETHERV2941(	//inject NONSTANDARD NAMING
    uint256 daiAmount, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalDaiSold);

  function TRADEETHERFORDAIV2888(	//inject NONSTANDARD NAMING
    uint256 quotedDaiAmount, uint256 deadline
  ) external payable returns (uint256 totalDaiBought);

  function TRADEDAIFORTOKEN895(	//inject NONSTANDARD NAMING
    address token,
    uint256 daiAmount,
    uint256 quotedTokenAmount,
    uint256 deadline,
    bool routeThroughEther
  ) external returns (uint256 totalDaiSold);

  function TRADETOKENFORDAI139(	//inject NONSTANDARD NAMING
    ERC20Interface token,
    uint256 tokenAmount,
    uint256 quotedDaiAmount,
    uint256 deadline,
    bool routeThroughEther
  ) external returns (uint256 totalDaiBought);

  function TRADETOKENFORETHER779(	//inject NONSTANDARD NAMING
    ERC20Interface token,
    uint256 tokenAmount,
    uint256 quotedEtherAmount,
    uint256 deadline
  ) external returns (uint256 totalEtherBought);

  function TRADEETHERFORTOKEN640(	//inject NONSTANDARD NAMING
    address token, uint256 quotedTokenAmount, uint256 deadline
  ) external payable returns (uint256 totalEtherSold);

  function TRADEETHERFORTOKENUSINGETHERIZER777(	//inject NONSTANDARD NAMING
    address token,
    uint256 etherAmount,
    uint256 quotedTokenAmount,
    uint256 deadline
  ) external returns (uint256 totalEtherSold);

  function TRADETOKENFORTOKEN271(	//inject NONSTANDARD NAMING
    ERC20Interface tokenProvided,
    address tokenReceived,
    uint256 tokenProvidedAmount,
    uint256 quotedTokenReceivedAmount,
    uint256 deadline,
    bool routeThroughEther
  ) external returns (uint256 totalTokensSold);

  function TRADETOKENFORTOKENUSINGRESERVES584(	//inject NONSTANDARD NAMING
    ERC20Interface tokenProvidedFromReserves,
    address tokenReceived,
    uint256 tokenProvidedAmountFromReserves,
    uint256 quotedTokenReceivedAmount,
    uint256 deadline,
    bool routeThroughEther
  ) external returns (uint256 totalTokensSold);

  function TRADEDAIFORETHERUSINGRESERVESV2260(	//inject NONSTANDARD NAMING
    uint256 daiAmountFromReserves, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalDaiSold);

  function TRADEETHERFORDAIUSINGRESERVESANDMINTDDAIV2493(	//inject NONSTANDARD NAMING
    uint256 etherAmountFromReserves, uint256 quotedDaiAmount, uint256 deadline
  ) external returns (uint256 totalDaiBought, uint256 totalDDaiMinted);

  function TRADEDAIFORTOKENUSINGRESERVES81(	//inject NONSTANDARD NAMING
    address token,
    uint256 daiAmountFromReserves,
    uint256 quotedTokenAmount,
    uint256 deadline,
    bool routeThroughEther
  ) external returns (uint256 totalDaiSold);

  function TRADETOKENFORDAIUSINGRESERVESANDMINTDDAI350(	//inject NONSTANDARD NAMING
    ERC20Interface token,
    uint256 tokenAmountFromReserves,
    uint256 quotedDaiAmount,
    uint256 deadline,
    bool routeThroughEther
  ) external returns (uint256 totalDaiBought, uint256 totalDDaiMinted);

  function TRADETOKENFORETHERUSINGRESERVES547(	//inject NONSTANDARD NAMING
    ERC20Interface token,
    uint256 tokenAmountFromReserves,
    uint256 quotedEtherAmount,
    uint256 deadline
  ) external returns (uint256 totalEtherBought);

  function TRADEETHERFORTOKENUSINGRESERVES877(	//inject NONSTANDARD NAMING
    address token,
    uint256 etherAmountFromReserves,
    uint256 quotedTokenAmount,
    uint256 deadline
  ) external returns (uint256 totalEtherSold);

  function FINALIZEETHERDEPOSIT986(	//inject NONSTANDARD NAMING
    address payable smartWallet,
    address initialUserSigningKey,
    uint256 etherAmount
  ) external;

  function FINALIZEDAIDEPOSIT934(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey, uint256 daiAmount
  ) external;

  function FINALIZEDHARMADAIDEPOSIT513(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey, uint256 dDaiAmount
  ) external;

  function MINT202(uint256 daiAmount) external returns (uint256 dDaiMinted);	//inject NONSTANDARD NAMING

  function REDEEM16(uint256 dDaiAmount) external returns (uint256 daiReceived);	//inject NONSTANDARD NAMING

  function TRADEDDAIFORUSDC654(	//inject NONSTANDARD NAMING
    uint256 daiEquivalentAmount, uint256 quotedUSDCAmount
  ) external returns (uint256 usdcReceived);

  function TRADEUSDCFORDDAI12(	//inject NONSTANDARD NAMING
    uint256 usdcAmount, uint256 quotedDaiEquivalentAmount
  ) external returns (uint256 dDaiMinted);

  function REFILLGASRESERVE448(uint256 etherAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWUSDC439(address recipient, uint256 usdcAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWDAI337(address recipient, uint256 daiAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWDHARMADAI28(address recipient, uint256 dDaiAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWUSDCTOPRIMARYRECIPIENT2(uint256 usdcAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWDAITOPRIMARYRECIPIENT618(uint256 usdcAmount) external;	//inject NONSTANDARD NAMING

  function WITHDRAWETHER691(	//inject NONSTANDARD NAMING
    address payable recipient, uint256 etherAmount
  ) external;

  function WITHDRAW743(	//inject NONSTANDARD NAMING
    ERC20Interface token, address recipient, uint256 amount
  ) external returns (bool success);

  function CALLANY310(	//inject NONSTANDARD NAMING
    address payable target, uint256 amount, bytes calldata data
  ) external returns (bool ok, bytes memory returnData);

  function SETDAILIMIT40(uint256 daiAmount) external;	//inject NONSTANDARD NAMING

  function SETETHERLIMIT732(uint256 daiAmount) external;	//inject NONSTANDARD NAMING

  function SETPRIMARYUSDCRECIPIENT254(address recipient) external;	//inject NONSTANDARD NAMING

  function SETPRIMARYDAIRECIPIENT844(address recipient) external;	//inject NONSTANDARD NAMING

  function SETROLE668(Role role, address account) external;	//inject NONSTANDARD NAMING

  function REMOVEROLE431(Role role) external;	//inject NONSTANDARD NAMING

  function PAUSE546(Role role) external;	//inject NONSTANDARD NAMING

  function UNPAUSE892(Role role) external;	//inject NONSTANDARD NAMING

  function ISPAUSED688(Role role) external view returns (bool paused);	//inject NONSTANDARD NAMING

  function ISROLE537(Role role) external view returns (bool hasRole);	//inject NONSTANDARD NAMING

  function ISDHARMASMARTWALLET489(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey
  ) external view returns (bool dharmaSmartWallet);

  function GETDEPOSITMANAGER179() external view returns (address depositManager);	//inject NONSTANDARD NAMING

  function GETADJUSTER264() external view returns (address adjuster);	//inject NONSTANDARD NAMING

  function GETRESERVETRADER364() external view returns (address reserveTrader);	//inject NONSTANDARD NAMING

  function GETWITHDRAWALMANAGER637() external view returns (address withdrawalManager);	//inject NONSTANDARD NAMING

  function GETPAUSER909() external view returns (address pauser);	//inject NONSTANDARD NAMING

  function GETGASRESERVEREFILLER909() external view returns (address gasReserveRefiller);	//inject NONSTANDARD NAMING

  function GETRESERVES500() external view returns (	//inject NONSTANDARD NAMING
    uint256 dai, uint256 dDai, uint256 dDaiUnderlying
  );

  function GETDAILIMIT177() external view returns (	//inject NONSTANDARD NAMING
    uint256 daiAmount, uint256 dDaiAmount
  );

  function GETETHERLIMIT782() external view returns (uint256 etherAmount);	//inject NONSTANDARD NAMING

  function GETPRIMARYUSDCRECIPIENT773() external view returns (	//inject NONSTANDARD NAMING
    address recipient
  );

  function GETPRIMARYDAIRECIPIENT581() external view returns (	//inject NONSTANDARD NAMING
    address recipient
  );

  function GETIMPLEMENTATION743() external view returns (address implementation);	//inject NONSTANDARD NAMING
  
  function GETINSTANCE306() external pure returns (address instance);	//inject NONSTANDARD NAMING

  function GETVERSION428() external view returns (uint256 version);	//inject NONSTANDARD NAMING
}


interface ERC20Interface {
  function BALANCEOF7(address) external view returns (uint256);	//inject NONSTANDARD NAMING
  function APPROVE806(address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
  function ALLOWANCE503(address, address) external view returns (uint256);	//inject NONSTANDARD NAMING
  function TRANSFER250(address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
  function TRANSFERFROM572(address, address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
}


interface DTokenInterface {
  function MINT202(uint256 underlyingToSupply) external returns (uint256 dTokensMinted);	//inject NONSTANDARD NAMING
  function REDEEM16(uint256 dTokensToBurn) external returns (uint256 underlyingReceived);	//inject NONSTANDARD NAMING
  function REDEEMUNDERLYING444(uint256 underlyingToReceive) external returns (uint256 dTokensBurned);	//inject NONSTANDARD NAMING
  function BALANCEOF7(address) external view returns (uint256);	//inject NONSTANDARD NAMING
  function BALANCEOFUNDERLYING522(address) external view returns (uint256);	//inject NONSTANDARD NAMING
  function TRANSFER250(address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
  function APPROVE806(address, uint256) external returns (bool);	//inject NONSTANDARD NAMING
  function EXCHANGERATECURRENT321() external view returns (uint256);	//inject NONSTANDARD NAMING
}


interface TradeHelperInterface {
  function TRADEUSDCFORDDAI12(	//inject NONSTANDARD NAMING
    uint256 amountUSDC,
    uint256 quotedDaiEquivalentAmount
  ) external returns (uint256 dDaiMinted);
  function TRADEDDAIFORUSDC654(	//inject NONSTANDARD NAMING
    uint256 amountDai,
    uint256 quotedUSDCAmount
  ) external returns (uint256 usdcReceived);
  function GETEXPECTEDDAI546(uint256 usdc) external view returns (uint256 dai);	//inject NONSTANDARD NAMING
  function GETEXPECTEDUSDC60(uint256 dai) external view returns (uint256 usdc);	//inject NONSTANDARD NAMING
}


interface UniswapV2Interface {
  function SWAPTOKENSFOREXACTTOKENS381(	//inject NONSTANDARD NAMING
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function SWAPEXACTTOKENSFORTOKENS55(	//inject NONSTANDARD NAMING
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);
  
  function SWAPEXACTTOKENSFORETH928(	//inject NONSTANDARD NAMING
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);
  
  function SWAPTOKENSFOREXACTETH806(	//inject NONSTANDARD NAMING
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);
  
  function SWAPETHFOREXACTTOKENS164(	//inject NONSTANDARD NAMING
    uint256 amountOut,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);
  
  function SWAPEXACTETHFORTOKENS988(	//inject NONSTANDARD NAMING
    uint256 amountOutMin, 
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);
}


interface EtherReceiverInterface {
  function SETTLEETHER224() external;	//inject NONSTANDARD NAMING
}


library SafeMath {
  function ADD577(uint256 a, uint256 b) internal pure returns (uint256 c) {	//inject NONSTANDARD NAMING
    c = a + b;
    require(c >= a, "SafeMath: addition overflow");
    return c;
  }

  function SUB328(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b <= a, "SafeMath: subtraction overflow");
    return a - b;
  }

  function MUL983(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    if (a == 0) return 0;
    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");
    return c;
  }

  function DIV568(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
    require(b > 0, "SafeMath: division by zero");
    return a / b;
  }
}


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
contract TwoStepOwnable {
  event OWNERSHIPTRANSFERRED746(	//inject NONSTANDARD NAMING
    address indexed previousOwner,
    address indexed newOwner
  );

  address private _owner;

  address private _newPotentialOwner;

                                                                                                                          
  function TRANSFEROWNERSHIP314(address newOwner) external ONLYOWNER349 {	//inject NONSTANDARD NAMING
    require(
      newOwner != address(0),
      "TwoStepOwnable: new potential owner is the zero address."
    );

    _newPotentialOwner = newOwner;
  }

                                                                                                                    
  function CANCELOWNERSHIPTRANSFER449() external ONLYOWNER349 {	//inject NONSTANDARD NAMING
    delete _newPotentialOwner;
  }

                                                                                                                                                   
  function ACCEPTOWNERSHIP100() external {	//inject NONSTANDARD NAMING
    require(
      msg.sender == _newPotentialOwner,
      "TwoStepOwnable: current owner must set caller as new potential owner."
    );

    delete _newPotentialOwner;

    emit OWNERSHIPTRANSFERRED746(_owner, msg.sender);

    _owner = msg.sender;
  }

                                                               
  function OWNER217() external view returns (address) {	//inject NONSTANDARD NAMING
    return _owner;
  }

                                                                      
  function ISOWNER119() public view returns (bool) {	//inject NONSTANDARD NAMING
    return msg.sender == _owner;
  }

                                                                           
  modifier ONLYOWNER349() {	//inject NONSTANDARD NAMING
    require(ISOWNER119(), "TwoStepOwnable: caller is not the owner.");
    _;
  }
}


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
contract DharmaTradeReserveV14ImplementationStaging is DharmaTradeReserveV14Interface, TwoStepOwnable {
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

  uint256 private constant _version68 = 1014;	//inject NONSTANDARD NAMING

  // This contract interacts with USDC, Dai, and Dharma Dai.
  ERC20Interface internal constant _usdc291 = ERC20Interface(	//inject NONSTANDARD NAMING
    0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // mainnet
  );

  ERC20Interface internal constant _dai607 = ERC20Interface(	//inject NONSTANDARD NAMING
    0x6B175474E89094C44Da98b954EedeAC495271d0F // mainnet
  );

  ERC20Interface internal constant _etherizer675 = ERC20Interface(	//inject NONSTANDARD NAMING
    0x723B51b72Ae89A3d0c2a2760f0458307a1Baa191
  );

  DTokenInterface internal constant _ddai635 = DTokenInterface(	//inject NONSTANDARD NAMING
    0x00000000001876eB1444c986fD502e618c587430
  );

  TradeHelperInterface internal constant _trade_helper419 = TradeHelperInterface(	//inject NONSTANDARD NAMING
    0x9328F2Fb3e85A4d24Adc2f68F82737183e85691d
  );
  
  UniswapV2Interface internal constant _uniswap_router857 = UniswapV2Interface(	//inject NONSTANDARD NAMING
    0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
  );
  
  EtherReceiverInterface internal constant _eth_receiver286 = EtherReceiverInterface(	//inject NONSTANDARD NAMING
    0xaf84687D21736F5E06f738c6F065e88890465E7c
  );
  
  address internal constant _weth890 = address(	//inject NONSTANDARD NAMING
    0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
  );
  
  address internal constant _gas_reserve614 = address(	//inject NONSTANDARD NAMING
    0x09cd826D4ABA4088E1381A1957962C946520952d // staging version
  );

  // The "Create2 Header" is used to compute smart wallet deployment addresses.
  bytes21 internal constant _create2_header144 = bytes21(	//inject NONSTANDARD NAMING
    0xff8D1e00b000e56d5BcB006F3a008Ca6003b9F0033 // control character + factory
  );
  
  // The "Wallet creation code" header & footer are also used to derive wallets.
  bytes internal constant _wallet_creation_code_header349 = hex"60806040526040516104423803806104428339818101604052602081101561002657600080fd5b810190808051604051939291908464010000000082111561004657600080fd5b90830190602082018581111561005b57600080fd5b825164010000000081118282018810171561007557600080fd5b82525081516020918201929091019080838360005b838110156100a257818101518382015260200161008a565b50505050905090810190601f1680156100cf5780820380516001836020036101000a031916815260200191505b5060405250505060006100e661019e60201b60201c565b6001600160a01b0316826040518082805190602001908083835b6020831061011f5780518252601f199092019160209182019101610100565b6001836020036101000a038019825116818451168082178552505050505050905001915050600060405180830381855af49150503d806000811461017f576040519150601f19603f3d011682016040523d82523d6000602084013e610184565b606091505b5050905080610197573d6000803e3d6000fd5b50506102be565b60405160009081906060906eb45d6593312ac9fde193f3d06336449083818181855afa9150503d80600081146101f0576040519150601f19603f3d011682016040523d82523d6000602084013e6101f5565b606091505b509150915081819061029f576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825283818151815260200191508051906020019080838360005b8381101561026457818101518382015260200161024c565b50505050905090810190601f1680156102915780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b508080602001905160208110156102b557600080fd5b50519392505050565b610175806102cd6000396000f3fe608060405261001461000f610016565b61011c565b005b60405160009081906060906eb45d6593312ac9fde193f3d06336449083818181855afa9150503d8060008114610068576040519150601f19603f3d011682016040523d82523d6000602084013e61006d565b606091505b50915091508181906100fd5760405162461bcd60e51b81526004018080602001828103825283818151815260200191508051906020019080838360005b838110156100c25781810151838201526020016100aa565b50505050905090810190601f1680156100ef5780820380516001836020036101000a031916815260200191505b509250505060405180910390fd5b5080806020019051602081101561011357600080fd5b50519392505050565b3660008037600080366000845af43d6000803e80801561013b573d6000f35b3d6000fdfea265627a7a723158203c578cc1552f1d1b48134a72934fe12fb89a29ff396bd514b9a4cebcacc5cacc64736f6c634300050b003200000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000024c4d66de8000000000000000000000000";	//inject NONSTANDARD NAMING
  bytes28 internal constant _wallet_creation_code_footer225 = bytes28(	//inject NONSTANDARD NAMING
    0x00000000000000000000000000000000000000000000000000000000
  );

  // Include a payable fallback so that the contract can receive Ether payments.
  function () external payable {
    emit ETHERRECEIVED220(msg.sender, msg.value);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function TRADEDAIFORETHERV2941(	//inject NONSTANDARD NAMING
    uint256 daiAmount,
    uint256 quotedEtherAmount,
    uint256 deadline
  ) external returns (uint256 totalDaiSold) {
    // Transfer the Dai from the caller and revert on failure.
    _TRANSFERINTOKEN55(_dai607, msg.sender, daiAmount);
    
    // Trade Dai for Ether.
    totalDaiSold = _TRADEDAIFORETHER930(
      daiAmount, quotedEtherAmount, deadline, false
    );
  }

  function TRADETOKENFORETHER779(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmount, uint256 quotedEtherAmount, uint256 deadline
  ) external returns (uint256 totalEtherBought) {
    // Transfer the tokens from the caller and revert on failure.
    _TRANSFERINTOKEN55(token, msg.sender, tokenAmount);
    
    // Trade tokens for Ether.
    totalEtherBought = _TRADETOKENFORETHER585(
      token, tokenAmount, quotedEtherAmount, deadline, false
    );

    // Transfer the quoted Ether amount to the caller.
    _TRANSFERETHER189(msg.sender, quotedEtherAmount);
  }

  function TRADEDAIFORTOKEN895(	//inject NONSTANDARD NAMING
    address token, uint256 daiAmount, uint256 quotedTokenAmount, uint256 deadline, bool routeThroughEther
  ) external returns (uint256 totalDaiSold) {
    // Transfer the Dai from the caller and revert on failure.
    _TRANSFERINTOKEN55(_dai607, msg.sender, daiAmount);

    // Trade Dai for specified token.
    totalDaiSold = _TRADEDAIFORTOKEN293(
      token, daiAmount, quotedTokenAmount, deadline, routeThroughEther, false
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function TRADEDAIFORETHERUSINGRESERVESV2260(	//inject NONSTANDARD NAMING
    uint256 daiAmountFromReserves, uint256 quotedEtherAmount, uint256 deadline
  ) external ONLYOWNEROR375(Role.RESERVE_TRADER) returns (uint256 totalDaiSold) {
    // Redeem dDai if the current Dai balance is less than is required.
    _REDEEMDDAIIFNECESSARY474(daiAmountFromReserves);

    // Trade Dai for Ether using reserves.
    totalDaiSold = _TRADEDAIFORETHER930(
      daiAmountFromReserves, quotedEtherAmount, deadline, true
    );
  }

  function TRADETOKENFORETHERUSINGRESERVES547(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmountFromReserves, uint256 quotedEtherAmount, uint256 deadline
  ) external ONLYOWNEROR375(Role.RESERVE_TRADER) returns (uint256 totalEtherBought) {
    // Trade tokens for Ether using reserves.
    totalEtherBought = _TRADETOKENFORETHER585(
      token, tokenAmountFromReserves, quotedEtherAmount, deadline, true
    );
  }

                                                                                                                                                                                                                                                                                                                                                                         
  function TRADEETHERFORDAIV2888(	//inject NONSTANDARD NAMING
    uint256 quotedDaiAmount,
    uint256 deadline
  ) external payable returns (uint256 totalDaiBought) {
    // Trade Ether for Dai.
    totalDaiBought = _TRADEETHERFORDAI152(
      msg.value, quotedDaiAmount, deadline, false
    );

    // Transfer the Dai to the caller and revert on failure.
    _TRANSFERTOKEN426(_dai607, msg.sender, quotedDaiAmount);
  }

  function TRADEETHERFORTOKEN640(	//inject NONSTANDARD NAMING
    address token, uint256 quotedTokenAmount, uint256 deadline
  ) external payable returns (uint256 totalEtherSold) {
    // Trade Ether for the specified token.
    totalEtherSold = _TRADEETHERFORTOKEN294(
      token, msg.value, quotedTokenAmount, deadline, false
    );
  }

  function TRADEETHERFORTOKENUSINGETHERIZER777(	//inject NONSTANDARD NAMING
    address token, uint256 etherAmount, uint256 quotedTokenAmount, uint256 deadline
  ) external returns (uint256 totalEtherSold) {
    // Transfer the Ether from the caller and revert on failure.
    _TRANSFERINTOKEN55(_etherizer675, msg.sender, etherAmount);

    // Trade Ether for the specified token.
    totalEtherSold = _TRADEETHERFORTOKEN294(
      token, etherAmount, quotedTokenAmount, deadline, false
    );
  }
  
  function TRADETOKENFORDAI139(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmount, uint256 quotedDaiAmount, uint256 deadline, bool routeThroughEther
  ) external returns (uint256 totalDaiBought) {
    // Transfer the token from the caller and revert on failure.
    _TRANSFERINTOKEN55(token, msg.sender, tokenAmount);
    
    // Trade the token for Dai.
    totalDaiBought = _TRADETOKENFORDAI325(
      token, tokenAmount, quotedDaiAmount, deadline, routeThroughEther, false
    );
    
    // Transfer the quoted Dai amount to the caller and revert on failure.
    _TRANSFERTOKEN426(_dai607, msg.sender, quotedDaiAmount);
  }

  function TRADETOKENFORTOKEN271(	//inject NONSTANDARD NAMING
    ERC20Interface tokenProvided,
    address tokenReceived,
    uint256 tokenProvidedAmount,
    uint256 quotedTokenReceivedAmount,
    uint256 deadline,
    bool routeThroughEther
  ) external returns (uint256 totalTokensSold) {
    // Transfer the token from the caller and revert on failure.
    _TRANSFERINTOKEN55(tokenProvided, msg.sender, tokenProvidedAmount);
    
    totalTokensSold = _TRADETOKENFORTOKEN365(
      msg.sender,
      tokenProvided,
      tokenReceived,
      tokenProvidedAmount,
      quotedTokenReceivedAmount,
      deadline,
      routeThroughEther
    );
  }

  function TRADETOKENFORTOKENUSINGRESERVES584(	//inject NONSTANDARD NAMING
    ERC20Interface tokenProvidedFromReserves,
    address tokenReceived,
    uint256 tokenProvidedAmountFromReserves,
    uint256 quotedTokenReceivedAmount,
    uint256 deadline,
    bool routeThroughEther
  ) external ONLYOWNEROR375(Role.RESERVE_TRADER)  returns (uint256 totalTokensSold) {
    totalTokensSold = _TRADETOKENFORTOKEN365(
      address(this),
      tokenProvidedFromReserves,
      tokenReceived,
      tokenProvidedAmountFromReserves,
      quotedTokenReceivedAmount,
      deadline,
      routeThroughEther
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
  function TRADEETHERFORDAIUSINGRESERVESANDMINTDDAIV2493(	//inject NONSTANDARD NAMING
    uint256 etherAmountFromReserves, uint256 quotedDaiAmount, uint256 deadline
  ) external ONLYOWNEROR375(Role.RESERVE_TRADER) returns (
    uint256 totalDaiBought, uint256 totalDDaiMinted
  ) {
    // Trade Ether for Dai using reserves.
    totalDaiBought = _TRADEETHERFORDAI152(
      etherAmountFromReserves, quotedDaiAmount, deadline, true
    );

    // Mint dDai using the received Dai.
    totalDDaiMinted = _ddai635.MINT202(totalDaiBought);
  }

  function TRADEETHERFORTOKENUSINGRESERVES877(	//inject NONSTANDARD NAMING
    address token, uint256 etherAmountFromReserves, uint256 quotedTokenAmount, uint256 deadline
  ) external ONLYOWNEROR375(Role.RESERVE_TRADER) returns (uint256 totalEtherSold) {
    // Trade Ether for token using reserves.
    totalEtherSold = _TRADEETHERFORTOKEN294(
      token, etherAmountFromReserves, quotedTokenAmount, deadline, true
    );
  }

  function TRADEDAIFORTOKENUSINGRESERVES81(	//inject NONSTANDARD NAMING
    address token, uint256 daiAmountFromReserves, uint256 quotedTokenAmount, uint256 deadline, bool routeThroughEther
  ) external ONLYOWNEROR375(Role.RESERVE_TRADER) returns (uint256 totalDaiSold) {
    // Redeem dDai if the current Dai balance is less than is required.
    _REDEEMDDAIIFNECESSARY474(daiAmountFromReserves);
    
    // Trade Dai for token using reserves.
    totalDaiSold = _TRADEDAIFORTOKEN293(
      token, daiAmountFromReserves, quotedTokenAmount, deadline, routeThroughEther, true
    );
  }

  function TRADETOKENFORDAIUSINGRESERVESANDMINTDDAI350(	//inject NONSTANDARD NAMING
    ERC20Interface token, uint256 tokenAmountFromReserves, uint256 quotedDaiAmount, uint256 deadline, bool routeThroughEther
  ) external ONLYOWNEROR375(Role.RESERVE_TRADER) returns (
    uint256 totalDaiBought, uint256 totalDDaiMinted
  ) {
    // Trade the token for Dai using reserves.
    totalDaiBought = _TRADETOKENFORDAI325(
      token, tokenAmountFromReserves, quotedDaiAmount, deadline, routeThroughEther, true
    );
    
    // Mint dDai using the received Dai.
    totalDDaiMinted = _ddai635.MINT202(totalDaiBought);
  }
  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  function FINALIZEDAIDEPOSIT934(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey, uint256 daiAmount
  ) external ONLYOWNEROR375(Role.DEPOSIT_MANAGER) {
    // Ensure that the recipient is indeed a smart wallet.
    _ENSURESMARTWALLET467(smartWallet, initialUserSigningKey);

    // Ensure that the amount to transfer is lower than the limit.
    require(daiAmount < _daiLimit, "Transfer size exceeds the limit.");

    // Transfer the Dai to the specified smart wallet.
    _TRANSFERTOKEN426(_dai607, smartWallet, daiAmount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
  function FINALIZEDHARMADAIDEPOSIT513(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey, uint256 dDaiAmount
  ) external ONLYOWNEROR375(Role.DEPOSIT_MANAGER) {
    // Ensure that the recipient is indeed a smart wallet.
    _ENSURESMARTWALLET467(smartWallet, initialUserSigningKey);

    // Get the current dDai exchange rate.
    uint256 exchangeRate = _ddai635.EXCHANGERATECURRENT321();

    // Ensure that an exchange rate was actually returned.
    require(exchangeRate != 0, "Could not retrieve dDai exchange rate.");

    // Get the equivalent Dai amount of the transfer.
    uint256 daiEquivalent = (dDaiAmount.MUL983(exchangeRate)) / 1e18;

    // Ensure that the amount to transfer is lower than the limit.
    require(daiEquivalent < _daiLimit, "Transfer size exceeds the limit.");

    // Transfer the dDai to the specified smart wallet.
    _TRANSFERTOKEN426(ERC20Interface(address(_ddai635)), smartWallet, dDaiAmount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
  function FINALIZEETHERDEPOSIT986(	//inject NONSTANDARD NAMING
    address payable smartWallet,
    address initialUserSigningKey,
    uint256 etherAmount
  ) external ONLYOWNEROR375(Role.DEPOSIT_MANAGER) {
    // Ensure that the recipient is indeed a smart wallet.
    _ENSURESMARTWALLET467(smartWallet, initialUserSigningKey);

    // Ensure that the amount to transfer is lower than the limit.
    require(etherAmount < _etherLimit, "Transfer size exceeds the limit.");

    // Transfer the Ether to the specified smart wallet.
    _TRANSFERETHER189(smartWallet, etherAmount);
  }

                                                                                                                                                                                                                                                                               
  function MINT202(	//inject NONSTANDARD NAMING
    uint256 daiAmount
  ) external ONLYOWNEROR375(Role.ADJUSTER) returns (uint256 dDaiMinted) {
    // Use the specified amount of Dai to mint dDai.
    dDaiMinted = _ddai635.MINT202(daiAmount);
  }

                                                                                                                                                                                                                                                                                    
  function REDEEM16(	//inject NONSTANDARD NAMING
    uint256 dDaiAmount
  ) external ONLYOWNEROR375(Role.ADJUSTER) returns (uint256 daiReceived) {
    // Redeem the specified amount of dDai for Dai.
    daiReceived = _ddai635.REDEEM16(dDaiAmount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function TRADEUSDCFORDDAI12(	//inject NONSTANDARD NAMING
    uint256 usdcAmount,
    uint256 quotedDaiEquivalentAmount
  ) external ONLYOWNEROR375(Role.ADJUSTER) returns (uint256 dDaiMinted) {
    dDaiMinted = _trade_helper419.TRADEUSDCFORDDAI12(
       usdcAmount, quotedDaiEquivalentAmount
    );
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  function TRADEDDAIFORUSDC654(	//inject NONSTANDARD NAMING
    uint256 daiEquivalentAmount,
    uint256 quotedUSDCAmount
  ) external ONLYOWNEROR375(Role.ADJUSTER) returns (uint256 usdcReceived) {
    usdcReceived = _trade_helper419.TRADEDDAIFORUSDC654(
      daiEquivalentAmount, quotedUSDCAmount
    );
  }
  
  function REFILLGASRESERVE448(uint256 etherAmount) external ONLYOWNEROR375(Role.GAS_RESERVE_REFILLER) {	//inject NONSTANDARD NAMING
    // Transfer the Ether to the gas reserve.
    _TRANSFERETHER189(_gas_reserve614, etherAmount);
    
    emit GASRESERVEREFILLED158(etherAmount);
  }

                                                                                                                                                                                                                                                                                        
  function WITHDRAWUSDCTOPRIMARYRECIPIENT2(	//inject NONSTANDARD NAMING
    uint256 usdcAmount
  ) external ONLYOWNEROR375(Role.WITHDRAWAL_MANAGER) {
    // Get the current primary recipient.
    address primaryRecipient = _primaryUSDCRecipient;
    require(
      primaryRecipient != address(0), "No USDC primary recipient currently set."
    );

    // Transfer the supplied USDC amount to the primary recipient.
    _TRANSFERTOKEN426(_usdc291, primaryRecipient, usdcAmount);
  }

                                                                                                                                                                                                                                                                                    
  function WITHDRAWDAITOPRIMARYRECIPIENT618(	//inject NONSTANDARD NAMING
    uint256 daiAmount
  ) external ONLYOWNEROR375(Role.WITHDRAWAL_MANAGER) {
    // Get the current primary recipient.
    address primaryRecipient = _primaryDaiRecipient;
    require(
      primaryRecipient != address(0), "No Dai primary recipient currently set."
    );

    // Transfer the supplied Dai amount to the primary recipient.
    _TRANSFERTOKEN426(_dai607, primaryRecipient, daiAmount);
  }

                                                                                                                                                                                                                                             
  function WITHDRAWUSDC439(	//inject NONSTANDARD NAMING
    address recipient, uint256 usdcAmount
  ) external ONLYOWNER349 {
    // Transfer the USDC to the specified recipient.
    _TRANSFERTOKEN426(_usdc291, recipient, usdcAmount);
  }

                                                                                                                                                                                                                                        
  function WITHDRAWDAI337(	//inject NONSTANDARD NAMING
    address recipient, uint256 daiAmount
  ) external ONLYOWNER349 {
    // Transfer the Dai to the specified recipient.
    _TRANSFERTOKEN426(_dai607, recipient, daiAmount);
  }

                                                                                                                                                                                                                                                               
  function WITHDRAWDHARMADAI28(	//inject NONSTANDARD NAMING
    address recipient, uint256 dDaiAmount
  ) external ONLYOWNER349 {
    // Transfer the dDai to the specified recipient.
    _TRANSFERTOKEN426(ERC20Interface(address(_ddai635)), recipient, dDaiAmount);
  }

                                                                                                                                                                                                                                                  
  function WITHDRAWETHER691(	//inject NONSTANDARD NAMING
    address payable recipient, uint256 etherAmount
  ) external ONLYOWNER349 {
    // Transfer the Ether to the specified recipient.
    _TRANSFERETHER189(recipient, etherAmount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function WITHDRAW743(	//inject NONSTANDARD NAMING
    ERC20Interface token, address recipient, uint256 amount
  ) external ONLYOWNER349 returns (bool success) {
    // Transfer the token to the specified recipient.
    success = token.TRANSFER250(recipient, amount);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                   
  function CALLANY310(	//inject NONSTANDARD NAMING
    address payable target, uint256 amount, bytes calldata data
  ) external ONLYOWNER349 returns (bool ok, bytes memory returnData) {
    // Call the specified target and supply the specified data.
    (ok, returnData) = target.call.value(amount)(data);
  }

                                                                                                                                                                                                                       
  function SETDAILIMIT40(uint256 daiAmount) external ONLYOWNER349 {	//inject NONSTANDARD NAMING
    // Set the new limit.
    _daiLimit = daiAmount;
  }

                                                                                                                                                                                                                           
  function SETETHERLIMIT732(uint256 etherAmount) external ONLYOWNER349 {	//inject NONSTANDARD NAMING
    // Set the new limit.
    _etherLimit = etherAmount;
  }

                                                                                                                                                                                                
  function SETPRIMARYUSDCRECIPIENT254(address recipient) external ONLYOWNER349 {	//inject NONSTANDARD NAMING
    // Set the new primary recipient.
    _primaryUSDCRecipient = recipient;
  }

                                                                                                                                                                                               
  function SETPRIMARYDAIRECIPIENT844(address recipient) external ONLYOWNER349 {	//inject NONSTANDARD NAMING
    // Set the new primary recipient.
    _primaryDaiRecipient = recipient;
  }

                                                                                                                                                                                                                                                                            
  function PAUSE546(Role role) external ONLYOWNEROR375(Role.PAUSER) {	//inject NONSTANDARD NAMING
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];
    require(!storedRoleStatus.paused, "Role in question is already paused.");
    storedRoleStatus.paused = true;
    emit ROLEPAUSED190(role);
  }

                                                                                                                                                                         
  function UNPAUSE892(Role role) external ONLYOWNER349 {	//inject NONSTANDARD NAMING
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];
    require(storedRoleStatus.paused, "Role in question is already unpaused.");
    storedRoleStatus.paused = false;
    emit ROLEUNPAUSED454(role);
  }

                                                                                                                                                                                                                                                                                                        
  function SETROLE668(Role role, address account) external ONLYOWNER349 {	//inject NONSTANDARD NAMING
    require(account != address(0), "Must supply an account.");
    _SETROLE96(role, account);
  }

                                                                                                                                                                                                                                                               
  function REMOVEROLE431(Role role) external ONLYOWNER349 {	//inject NONSTANDARD NAMING
    _SETROLE96(role, address(0));
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
  function ISPAUSED688(Role role) external view returns (bool paused) {	//inject NONSTANDARD NAMING
    paused = _ISPAUSED235(role);
  }

                                                                                                                                                                                                                            
  function ISROLE537(Role role) external view returns (bool hasRole) {	//inject NONSTANDARD NAMING
    hasRole = _ISROLE773(role);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
  function ISDHARMASMARTWALLET489(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey
  ) external view returns (bool dharmaSmartWallet) {
    dharmaSmartWallet = _ISSMARTWALLET673(smartWallet, initialUserSigningKey);
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
  function GETDEPOSITMANAGER179() external view returns (address depositManager) {	//inject NONSTANDARD NAMING
    depositManager = _roles[uint256(Role.DEPOSIT_MANAGER)].account;
  }

                                                                                                                                                                                                                                                                                                                
  function GETADJUSTER264() external view returns (address adjuster) {	//inject NONSTANDARD NAMING
    adjuster = _roles[uint256(Role.ADJUSTER)].account;
  }

                                                                                                                                                                                                                                                                                                                             
  function GETRESERVETRADER364() external view returns (address reserveTrader) {	//inject NONSTANDARD NAMING
    reserveTrader = _roles[uint256(Role.RESERVE_TRADER)].account;
  }

                                                                                                                                                                                                                                                                                                                                
  function GETWITHDRAWALMANAGER637() external view returns (address withdrawalManager) {	//inject NONSTANDARD NAMING
    withdrawalManager = _roles[uint256(Role.WITHDRAWAL_MANAGER)].account;
  }

                                                                                                                                                                                                                                                                                                                                                                                                                                    
  function GETPAUSER909() external view returns (address pauser) {	//inject NONSTANDARD NAMING
    pauser = _roles[uint256(Role.PAUSER)].account;
  }
  
  function GETGASRESERVEREFILLER909() external view returns (address gasReserveRefiller) {	//inject NONSTANDARD NAMING
    gasReserveRefiller = _roles[uint256(Role.GAS_RESERVE_REFILLER)].account;
  }

                                                                                                                                                                                                                                                  
  function GETRESERVES500() external view returns (	//inject NONSTANDARD NAMING
    uint256 dai, uint256 dDai, uint256 dDaiUnderlying
  ) {
    dai = _dai607.BALANCEOF7(address(this));
    dDai = _ddai635.BALANCEOF7(address(this));
    dDaiUnderlying = _ddai635.BALANCEOFUNDERLYING522(address(this));
  }

                                                                                                                                                                                                                                                                               
  function GETDAILIMIT177() external view returns (	//inject NONSTANDARD NAMING
    uint256 daiAmount, uint256 dDaiAmount
  ) {
    daiAmount = _daiLimit;
    dDaiAmount = (daiAmount.MUL983(1e18)).DIV568(_ddai635.EXCHANGERATECURRENT321());
  }

                                                                                                                                                                                                                               
  function GETETHERLIMIT782() external view returns (uint256 etherAmount) {	//inject NONSTANDARD NAMING
    etherAmount = _etherLimit;
  }

                                                                                                                                                                 
  function GETPRIMARYUSDCRECIPIENT773() external view returns (	//inject NONSTANDARD NAMING
    address recipient
  ) {
    recipient = _primaryUSDCRecipient;
  }

                                                                                                                                                               
  function GETPRIMARYDAIRECIPIENT581() external view returns (	//inject NONSTANDARD NAMING
    address recipient
  ) {
    recipient = _primaryDaiRecipient;
  }

                                                                                                                                                                                                         
  function GETIMPLEMENTATION743() external view returns (	//inject NONSTANDARD NAMING
    address implementation
  ) {
    (bool ok, bytes memory returnData) = address(
      0x481B1a16E6675D33f8BBb3a6A58F5a9678649718
    ).staticcall("");
    require(ok && returnData.length == 32, "Invalid implementation.");
    implementation = abi.decode(returnData, (address));
  }

                                                                                                                                                                                                      
  function GETINSTANCE306() external pure returns (address instance) {	//inject NONSTANDARD NAMING
    instance = address(0x09cd826D4ABA4088E1381A1957962C946520952d);
  }

  function GETVERSION428() external view returns (uint256 version) {	//inject NONSTANDARD NAMING
    version = _version68;
  }
  
  function _GRANTUNISWAPROUTERAPPROVALIFNECESSARY414(ERC20Interface token, uint256 amount) internal {	//inject NONSTANDARD NAMING
    if (token.ALLOWANCE503(address(this), address(_uniswap_router857)) < amount) {
      // Try removing approval for Uniswap router first as a workaround for unusual tokens.
      (bool success, bytes memory data) = address(token).call(
        abi.encodeWithSelector(
          token.APPROVE806.selector, address(_uniswap_router857), uint256(0)
        )
      );

      // Grant approval for Uniswap router to transfer tokens on behalf of this contract.
      (success, data) = address(token).call(
        abi.encodeWithSelector(
          token.APPROVE806.selector, address(_uniswap_router857), uint256(-1)
        )
      );

      if (!success) {
        // Some really janky tokens only allow setting approval up to current balance.
        (success, data) = address(token).call(
          abi.encodeWithSelector(
            token.APPROVE806.selector, address(_uniswap_router857), amount
          )
        );
      }

      require(
        success && (data.length == 0 || abi.decode(data, (bool))),
        "Token approval for Uniswap router failed."
      );
    }
  }
  
  function _TRADEETHERFORDAI152(	//inject NONSTANDARD NAMING
    uint256 etherAmount, uint256 quotedDaiAmount, uint256 deadline, bool fromReserves
  ) internal returns (uint256 totalDaiBought) {
    // Establish path from Ether to Dai.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS240(
      _weth890, address(_dai607), false
    );
   
    // Trade Ether for Dai on Uniswap (send to this contract).
    amounts = _uniswap_router857.SWAPEXACTETHFORTOKENS988.value(etherAmount)(
      quotedDaiAmount, path, address(this), deadline
    );
    totalDaiBought = amounts[1];

    _FIRETRADEEVENT684(
      fromReserves,
      TradeType.ETH_TO_DAI,
      address(0),
      etherAmount,
      quotedDaiAmount,
      totalDaiBought.SUB328(quotedDaiAmount)
    );
  }

  function _TRADEDAIFORETHER930(	//inject NONSTANDARD NAMING
    uint256 daiAmount, uint256 quotedEtherAmount, uint256 deadline, bool fromReserves
  ) internal returns (uint256 totalDaiSold) {
    // Establish path from Dai to Ether.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS240(
      address(_dai607), _weth890, false
    );

    // Trade Dai for quoted Ether amount on Uniswap (send to appropriate recipient).
    amounts = _uniswap_router857.SWAPTOKENSFOREXACTETH806(
      quotedEtherAmount, daiAmount, path, fromReserves ? address(this) : msg.sender, deadline
    );
    totalDaiSold = amounts[0];

    _FIRETRADEEVENT684(
      fromReserves,
      TradeType.DAI_TO_ETH,
      address(0),
      daiAmount,
      quotedEtherAmount,
      daiAmount.SUB328(totalDaiSold)
    );
  }

  function _TRADEETHERFORTOKEN294(	//inject NONSTANDARD NAMING
    address token, uint256 etherAmount, uint256 quotedTokenAmount, uint256 deadline, bool fromReserves
  ) internal returns (uint256 totalEtherSold) {
    // Establish path from Ether to target token.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS240(
      _weth890, address(token), false
    );
      
    // Trade Ether for quoted token amount on Uniswap and send to appropriate recipient.
    amounts = _uniswap_router857.SWAPETHFOREXACTTOKENS164.value(etherAmount)(
      quotedTokenAmount, path, fromReserves ? address(this) : msg.sender, deadline
    );
    totalEtherSold = amounts[0];

    _FIRETRADEEVENT684(
      fromReserves,
      TradeType.ETH_TO_TOKEN,
      address(token),
      etherAmount,
      quotedTokenAmount,
      etherAmount.SUB328(totalEtherSold)
    );
  }

  function _TRADETOKENFORETHER585(	//inject NONSTANDARD NAMING
    ERC20Interface token,
    uint256 tokenAmount,
    uint256 quotedEtherAmount,
    uint256 deadline,
    bool fromReserves
  ) internal returns (uint256 totalEtherBought) {
    // Approve Uniswap router to transfer tokens on behalf of this contract.
    _GRANTUNISWAPROUTERAPPROVALIFNECESSARY414(token, tokenAmount);

    // Establish path from target token to Ether.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS240(
      address(token), _weth890, false
    );

    // Trade tokens for quoted Ether amount on Uniswap (send to this contract).
    amounts = _uniswap_router857.SWAPEXACTTOKENSFORETH928(
      tokenAmount, quotedEtherAmount, path, address(this), deadline
    );
    totalEtherBought = amounts[1];

    _FIRETRADEEVENT684(
      fromReserves,
      TradeType.TOKEN_TO_ETH,
      address(token),
      tokenAmount,
      quotedEtherAmount,
      totalEtherBought.SUB328(quotedEtherAmount)
    );
  }

  function _TRADEDAIFORTOKEN293(	//inject NONSTANDARD NAMING
    address token,
    uint256 daiAmount,
    uint256 quotedTokenAmount,
    uint256 deadline,
    bool routeThroughEther,
    bool fromReserves
  ) internal returns (uint256 totalDaiSold) {
    // Establish path (direct or routed through Ether) from Dai to target token.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS240(
      address(_dai607), address(token), routeThroughEther
    );
    
    // Trade the Dai for the quoted token amount on Uniswap and send to appropriate recipient.
    amounts = _uniswap_router857.SWAPTOKENSFOREXACTTOKENS381(
      quotedTokenAmount, daiAmount, path, fromReserves ? address(this) : msg.sender, deadline
    );
    
    totalDaiSold = amounts[0];
    
    _FIRETRADEEVENT684(
      fromReserves,
      TradeType.DAI_TO_TOKEN,
      address(token),
      daiAmount,
      quotedTokenAmount,
      daiAmount.SUB328(totalDaiSold)
    );
  }

  function _TRADETOKENFORDAI325(	//inject NONSTANDARD NAMING
    ERC20Interface token,
    uint256 tokenAmount,
    uint256 quotedDaiAmount,
    uint256 deadline,
    bool routeThroughEther,
    bool fromReserves
  ) internal returns (uint256 totalDaiBought) {
    // Approve Uniswap router to transfer tokens on behalf of this contract.
    _GRANTUNISWAPROUTERAPPROVALIFNECESSARY414(token, tokenAmount);
    
    // Establish path (direct or routed through Ether) from target token to Dai.
    (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS240(
      address(token), address(_dai607), routeThroughEther
    );
    
    // Trade the Dai for the quoted token amount on Uniswap (send to this contract).
    amounts = _uniswap_router857.SWAPEXACTTOKENSFORTOKENS55(
      tokenAmount, quotedDaiAmount, path, address(this), deadline
    );
    
    totalDaiBought = amounts[path.length - 1];

    _FIRETRADEEVENT684(
      fromReserves,
      TradeType.TOKEN_TO_DAI,
      address(token),
      tokenAmount,
      quotedDaiAmount,
      totalDaiBought.SUB328(quotedDaiAmount)
    );
  }

  function _TRADETOKENFORTOKEN365(	//inject NONSTANDARD NAMING
    address recipient,
    ERC20Interface tokenProvided,
    address tokenReceived,
    uint256 tokenProvidedAmount,
    uint256 quotedTokenReceivedAmount,
    uint256 deadline,
    bool routeThroughEther
  ) internal returns (uint256 totalTokensSold) {
    uint256 retainedAmount;

    // Approve Uniswap router to transfer tokens on behalf of this contract.
    _GRANTUNISWAPROUTERAPPROVALIFNECESSARY414(tokenProvided, tokenProvidedAmount);
    
    if (routeThroughEther == false) {
      // Establish direct path between tokens.
      (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS240(
        address(tokenProvided), tokenReceived, false
      );

      // Trade for the quoted token amount on Uniswap and send to recipient.
      amounts = _uniswap_router857.SWAPTOKENSFOREXACTTOKENS381(
        quotedTokenReceivedAmount, tokenProvidedAmount, path, recipient, deadline
      );
    
     totalTokensSold = amounts[0];
     retainedAmount = tokenProvidedAmount.SUB328(totalTokensSold);
    } else {
      // Establish path between provided token and WETH.
      (address[] memory path, uint256[] memory amounts) = _CREATEPATHANDAMOUNTS240(
        address(tokenProvided), _weth890, false
      );

      // Trade all provided tokens for WETH on Uniswap and send to this contract.
      amounts = _uniswap_router857.SWAPEXACTTOKENSFORTOKENS55(
        tokenProvidedAmount, 0, path, address(this), deadline
      );
      retainedAmount = amounts[1];

      // Establish path between WETH and received token.
      (path, amounts) = _CREATEPATHANDAMOUNTS240(
        _weth890, tokenReceived, false
      );

      // Trade bought WETH for received token on Uniswap and send to recipient.
      amounts = _uniswap_router857.SWAPTOKENSFOREXACTTOKENS381(
        quotedTokenReceivedAmount, retainedAmount, path, recipient, deadline
      );
    
     totalTokensSold = amounts[0];
     retainedAmount = retainedAmount.SUB328(totalTokensSold);
    }

    emit TRADE504(
      recipient,
      address(tokenProvided),
      tokenReceived,
      routeThroughEther ? _weth890 : address(tokenProvided),
      tokenProvidedAmount,
      quotedTokenReceivedAmount,
      retainedAmount
    );
  }

                                                                                                                                                                                                                                                                                                                                                                  
  function _SETROLE96(Role role, address account) internal {	//inject NONSTANDARD NAMING
    RoleStatus storage storedRoleStatus = _roles[uint256(role)];

    if (account != storedRoleStatus.account) {
      storedRoleStatus.account = account;
      emit ROLEMODIFIED267(role, account);
    }
  }
  
  function _FIRETRADEEVENT684(	//inject NONSTANDARD NAMING
    bool fromReserves,
    TradeType tradeType,
    address token,
    uint256 suppliedAmount,
    uint256 receivedAmount,
    uint256 retainedAmount
  ) internal {
    uint256 t = uint256(tradeType);
    
    emit TRADE504(
      fromReserves ? address(this) : msg.sender,
      t < 2 ? address(_dai607) : (t % 2 == 0 ? address(0) : token),
      (t > 1 && t < 4) ? address(_dai607) : (t % 2 == 0 ? token : address(0)),
      t < 4 ? address(_dai607) : address(0),
      suppliedAmount,
      receivedAmount,
      retainedAmount
    );  
  }

                                                                                                                                                                                                                            
  function _ISROLE773(Role role) internal view returns (bool hasRole) {	//inject NONSTANDARD NAMING
    hasRole = msg.sender == _roles[uint256(role)].account;
  }

                                                                                                                                                                                                                        
  function _ISPAUSED235(Role role) internal view returns (bool paused) {	//inject NONSTANDARD NAMING
    paused = _roles[uint256(role)].paused;
  }

                                                                                                                                                                                                                                                                                                                                                     
  function _ISSMARTWALLET673(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey
  ) internal pure returns (bool) {
    // Derive the keccak256 hash of the smart wallet initialization code.
    bytes32 initCodeHash = keccak256(
      abi.encodePacked(
        _wallet_creation_code_header349,
        initialUserSigningKey,
        _wallet_creation_code_footer225
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
                _create2_header144, // pass in control character + factory address.
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
  
  function _REDEEMDDAIIFNECESSARY474(uint256 daiAmountFromReserves) internal {	//inject NONSTANDARD NAMING
    uint256 daiBalance = _dai607.BALANCEOF7(address(this));
    if (daiBalance < daiAmountFromReserves) {
      uint256 additionalDaiRequired = daiAmountFromReserves - daiBalance;
      _ddai635.REDEEMUNDERLYING444(additionalDaiRequired);
    }
  }
  
  function _TRANSFERTOKEN426(ERC20Interface token, address to, uint256 amount) internal {	//inject NONSTANDARD NAMING
    (bool success, bytes memory data) = address(token).call(
      abi.encodeWithSelector(token.TRANSFER250.selector, to, amount)
    );
    require(
      success && (data.length == 0 || abi.decode(data, (bool))),
      'Transfer out failed.'
    );
  }
  
  function _TRANSFERETHER189(address recipient, uint256 etherAmount) internal {	//inject NONSTANDARD NAMING
    // Send quoted Ether amount to recipient and revert with reason on failure.
    (bool ok, ) = recipient.call.value(etherAmount)("");
    if (!ok) {
      assembly {
        returndatacopy(0, 0, returndatasize)
        revert(0, returndatasize)
      }
    }
  }

  function _TRANSFERINTOKEN55(ERC20Interface token, address from, uint256 amount) internal {	//inject NONSTANDARD NAMING
    (bool success, bytes memory data) = address(token).call(
      abi.encodeWithSelector(token.TRANSFERFROM572.selector, from, address(this), amount)
    );

    require(
      success && (data.length == 0 || abi.decode(data, (bool))),
      'Transfer in failed.'
    );
  }
  
  function _ENSURESMARTWALLET467(	//inject NONSTANDARD NAMING
    address smartWallet, address initialUserSigningKey
  ) internal pure {
    require(
      _ISSMARTWALLET673(smartWallet, initialUserSigningKey),
      "Could not resolve smart wallet using provided signing key."
    );
  }
  
  function _CREATEPATHANDAMOUNTS240(	//inject NONSTANDARD NAMING
    address start, address end, bool routeThroughEther
  ) internal pure returns (address[] memory, uint256[] memory) {
    uint256 pathLength = routeThroughEther ? 3 : 2;
    address[] memory path = new address[](pathLength);
    path[0] = start;
    
    if (routeThroughEther) {
      path[1] = _weth890;
    }

    path[pathLength - 1] = end;

    return (path, new uint256[](pathLength));
  }

                                                                                                                                                                                                                                                                      
  modifier ONLYOWNEROR375(Role role) {	//inject NONSTANDARD NAMING
    if (!ISOWNER119()) {
      require(_ISROLE773(role), "Caller does not have a required role.");
      require(!_ISPAUSED235(role), "Role in question is currently paused.");
    }
    _;
  }
}