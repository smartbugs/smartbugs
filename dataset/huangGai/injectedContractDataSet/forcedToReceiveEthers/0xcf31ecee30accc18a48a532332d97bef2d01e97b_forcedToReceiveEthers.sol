/**
 *Submitted for verification at Etherscan.io on 2020-01-14
*/

pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg


interface DTokenInterface {
  // Events (replicate Compound's events)
  event Mint(address minter, uint256 mintAmount, uint256 mintTokens);
  event Redeem(address redeemer, uint256 redeemAmount, uint256 redeemTokens);

  // external functions (trigger accrual)
  function mint(uint256 underlyingToSupply) external returns (uint256 dTokensMinted);
  function mintViaCToken(uint256 cTokensToSupply) external returns (uint256 dTokensMinted);
  function redeem(uint256 dTokensToBurn) external returns (uint256 underlyingReceived);
  function redeemToCToken(uint256 dTokensToBurn) external returns (uint256 cTokensReceived);
  function redeemUnderlying(uint256 underelyingToReceive) external returns (uint256 dTokensBurned);
  function redeemUnderlyingToCToken(uint256 underlyingToReceive) external returns (uint256 dTokensBurned);
  function transferUnderlying(address recipient, uint256 amount) external returns (bool);
  function transferUnderlyingFrom(address sender, address recipient, uint256 amount) external returns (bool);
  function pullSurplus() external returns (uint256 cTokenSurplus);
  function accrueInterest() external;

  // view functions (do not trigger accrual)
  function totalSupplyUnderlying() external view returns (uint256);
  function balanceOfUnderlying(address account) external view returns (uint256 underlyingBalance);
  function getSurplus() external view returns (uint256 cTokenSurplus);
  function getSurplusUnderlying() external view returns (uint256 underlyingSurplus);
  function exchangeRateCurrent() external view returns (uint256 dTokenExchangeRate);
  function supplyRatePerBlock() external view returns (uint256 dTokenInterestRate);
  function getSpreadPerBlock() external view returns (uint256 rateSpread);
  function getVersion() external pure returns (uint256 version);
}


interface CTokenInterface {
  function mint(uint256 mintAmount) external returns (uint256 err);
  function redeem(uint256 redeemAmount) external returns (uint256 err);
  function redeemUnderlying(uint256 redeemAmount) external returns (uint256 err);
  function balanceOf(address account) external view returns (uint256 balance);
  function balanceOfUnderlying(address account) external returns (uint256 balance);
  function exchangeRateCurrent() external returns (uint256 exchangeRate);
  function transfer(address recipient, uint256 value) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 value) external returns (bool);
  
  function supplyRatePerBlock() external view returns (uint256 rate);
  function exchangeRateStored() external view returns (uint256 rate);
  function accrualBlockNumber() external view returns (uint256 blockNumber);
}


interface ERC20Interface {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}


interface SpreadRegistryInterface {
  function getUSDCSpreadPerBlock() external view returns (uint256 usdcSpreadPerBlock);
}


library SafeMath {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a, "SafeMath: subtraction overflow");
    uint256 c = a - b;

    return c;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0, "SafeMath: division by zero");
    uint256 c = a / b;

    return c;
  }
}


/**
 * @title DharmaUSDCPrototype1
 * @author 0age (dToken mechanics derived from Compound cTokens, ERC20 methods
 * derived from Open Zeppelin's ERC20 contract)
 * @notice Initial prototype for a cUSDC wrapper token. This version is not
 * upgradeable, and serves as an initial test of the eventual dUSDC mechanics.
 * The dUSDC exchange rate will grow at the rate of the cUSDC exchange rate less
 * the USDC spread set on the Dharma Spread Registry.
 */
contract DharmaUSDCPrototype1 is ERC20Interface, DTokenInterface {
  using SafeMath for uint256;

  uint256 internal constant _DHARMA_USDC_VERSION = 0;

  string internal constant _NAME = "Dharma USD Coin (Prototype 1)";
  string internal constant _SYMBOL = "dUSDC-p1";
  uint8 internal constant _DECIMALS = 8; // to match cUSDC

  uint256 internal constant _SCALING_FACTOR = 1e18;
  uint256 internal constant _HALF_OF_SCALING_FACTOR = 5e17;
  uint256 internal constant _COMPOUND_SUCCESS = 0;

  CTokenInterface internal constant _CUSDC = CTokenInterface(
    0x39AA39c021dfbaE8faC545936693aC917d5E7563 // mainnet
  );

  ERC20Interface internal constant _USDC = ERC20Interface(
    0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 // mainnet
  );

  SpreadRegistryInterface internal constant _SPREAD = SpreadRegistryInterface(
    0xA143fD004B3c26f8FAeDeb9224eC03585e63d041
  );

  // Note: this is just an EOA for the initial prototype.
  address internal constant _VAULT = 0x7e4A8391C728fEd9069B2962699AB416628B19Fa;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _totalSupply;

  // TODO: pack these more tightly in storage
  uint256 private _blockLastUpdated;
  uint256 private _dUSDCExchangeRate;
  uint256 private _cUSDCExchangeRate;

  constructor() public {
    // Approve cUSDC to transfer USDC on behalf of this contract in order to mint.
    require(_USDC.approve(address(_CUSDC), uint256(-1)));

    _blockLastUpdated = block.number;
    _dUSDCExchangeRate = 1e16; // 1 USDC == 1 dUSDC to start
    _cUSDCExchangeRate = _CUSDC.exchangeRateCurrent();
  }

  /**
   * @notice Transfer `amount` USDC from `msg.sender` to this contract, use them
   * to mint cUSDC, and mint dTokens with `msg.sender` as the beneficiary. Ensure
   * that this contract has been approved to transfer the USDC on behalf of the
   * caller.
   * @param usdcToSupply uint256 The amount of USDC to provide as part of minting.
   * @return The amount of dUSDC received in return for the supplied USDC.
   */
  function mint(
    uint256 usdcToSupply
  ) external accrues returns (uint256 dUSDCMinted) {
    // Pull in USDC - ensure that this contract has sufficient allowance.
    require(
      _USDC.transferFrom(msg.sender, address(this), usdcToSupply),
      "USDC transfer failed."
    );

    // Use the cUSDC to mint USDC and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CUSDC).call(abi.encodeWithSelector(
      _CUSDC.mint.selector, usdcToSupply
    ));

    _checkCompoundInteraction(_CUSDC.mint.selector, ok, data);

    // Determine the dUSDC to mint using the exchange rate.
    dUSDCMinted = (usdcToSupply.mul(_SCALING_FACTOR)).div(_dUSDCExchangeRate);

    // Mint dUSDC to the caller.
    _mint(msg.sender, usdcToSupply, dUSDCMinted);
  }

  /**
   * @notice Transfer `amount` cUSDC from `msg.sender` to this contract and mint
   * dTokens with `msg.sender` as the beneficiary. Ensure that this contract has
   * been approved to transfer the cUSDC on behalf of the caller.
   * @param cUSDCToSupply uint256 The amount of cUSDC to provide as part of
   * minting.
   * @return The amount of dUSDC received in return for the supplied cUSDC.
   */
  function mintViaCToken(
    uint256 cUSDCToSupply
  ) external accrues returns (uint256 dUSDCMinted) {
    // Pull in cUSDC - ensure that this contract has sufficient allowance.
    (bool ok, bytes memory data) = address(_CUSDC).call(abi.encodeWithSelector(
      _CUSDC.transferFrom.selector, msg.sender, address(this), cUSDCToSupply
    ));

    _checkCompoundInteraction(_CUSDC.transferFrom.selector, ok, data);

    // Determine the USDC equivalent of the supplied cUSDC amount.
    uint256 usdcEquivalent = cUSDCToSupply.mul(_cUSDCExchangeRate) / _SCALING_FACTOR;

    // Determine the dUSDC to mint using the exchange rate.
    dUSDCMinted = (usdcEquivalent.mul(_SCALING_FACTOR)).div(_dUSDCExchangeRate);

    // Mint dUSDC to the caller.
    _mint(msg.sender, usdcEquivalent, dUSDCMinted);
  }

  /**
   * @notice Redeem `dUSDCToBurn` dUSDC from `msg.sender`, use the corresponding
   * cUSDC to redeem USDC, and transfer the USDC to `msg.sender`.
   * @param dUSDCToBurn uint256 The amount of dUSDC to provide for USDC.
   * @return The amount of USDC received in return for the provided cUSDC.
   */
  function redeem(
    uint256 dUSDCToBurn
  ) external accrues returns (uint256 usdcReceived) {
    // Determine the underlying USDC value of the dUSDC to be burned.
    usdcReceived = dUSDCToBurn.mul(_dUSDCExchangeRate) / _SCALING_FACTOR;

    // Burn the dUSDC.
    _burn(msg.sender, usdcReceived, dUSDCToBurn);

    // Use the cUSDC to redeem USDC and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CUSDC).call(abi.encodeWithSelector(
      _CUSDC.redeemUnderlying.selector, usdcReceived
    ));

    _checkCompoundInteraction(_CUSDC.redeemUnderlying.selector, ok, data);

    // Send the USDC to the redeemer.
    require(_USDC.transfer(msg.sender, usdcReceived), "USDC transfer failed.");
  }

  /**
   * @notice Redeem `dUSDCToBurn` dUSDC from `msg.sender` and transfer the
   * corresponding amount of cUSDC to `msg.sender`.
   * @param dUSDCToBurn uint256 The amount of dUSDC to provide for USDC.
   * @return The amount of cUSDC received in return for the provided dUSDC.
   */
  function redeemToCToken(
    uint256 dUSDCToBurn
  ) external accrues returns (uint256 cUSDCReceived) {
    // Determine the underlying USDC value of the dUSDC to be burned.
    uint256 usdcEquivalent = dUSDCToBurn.mul(_dUSDCExchangeRate) / _SCALING_FACTOR;

    // Determine the amount of cUSDC corresponding to the redeemed USDC value.
    cUSDCReceived = (usdcEquivalent.mul(_SCALING_FACTOR)).div(_cUSDCExchangeRate);

    // Burn the dUSDC.
    _burn(msg.sender, usdcEquivalent, dUSDCToBurn);

    // Transfer the cUSDC to the caller and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CUSDC).call(abi.encodeWithSelector(
      _CUSDC.transfer.selector, msg.sender, cUSDCReceived
    ));

    _checkCompoundInteraction(_CUSDC.transfer.selector, ok, data);
  }

  /**
   * @notice Redeem the dUSDC equivalent value of USDC amount `usdcToReceive` from
   * `msg.sender`, use the corresponding cUSDC to redeem USDC, and transfer the
   * USDC to `msg.sender`.
   * @param usdcToReceive uint256 The amount, denominated in USDC, of the cUSDC to
   * provide for USDC.
   * @return The amount of dUSDC burned in exchange for the returned USDC.
   */
  function redeemUnderlying(
    uint256 usdcToReceive
  ) external accrues returns (uint256 dUSDCBurned) {
    // Determine the dUSDC to redeem using the exchange rate.
    dUSDCBurned = (usdcToReceive.mul(_SCALING_FACTOR)).div(_dUSDCExchangeRate);

    // Burn the dUSDC.
    _burn(msg.sender, usdcToReceive, dUSDCBurned);

    // Use the cUSDC to redeem USDC and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CUSDC).call(abi.encodeWithSelector(
      _CUSDC.redeemUnderlying.selector, usdcToReceive
    ));

    _checkCompoundInteraction(_CUSDC.redeemUnderlying.selector, ok, data);

    // Send the USDC to the redeemer.
    require(_USDC.transfer(msg.sender, usdcToReceive), "USDC transfer failed.");
  }

  /**
   * @notice Redeem the dUSDC equivalent value of USDC amount `usdcToReceive` from
   * `msg.sender` and transfer the corresponding amount of cUSDC to `msg.sender`.
   * @param usdcToReceive uint256 The amount, denominated in USDC, of the cUSDC to
   * provide for USDC.
   * @return The amount of dUSDC burned in exchange for the returned cUSDC.
   */
  function redeemUnderlyingToCToken(
    uint256 usdcToReceive
  ) external accrues returns (uint256 dUSDCBurned) {
    // Determine the dUSDC to redeem using the exchange rate.
    dUSDCBurned = (usdcToReceive.mul(_SCALING_FACTOR)).div(_dUSDCExchangeRate);

    // Burn the dUSDC.
    _burn(msg.sender, usdcToReceive, dUSDCBurned);

    // Determine the amount of cUSDC corresponding to the redeemed USDC value.
    uint256 cUSDCToReceive = usdcToReceive.mul(_SCALING_FACTOR).div(_cUSDCExchangeRate);

    // Transfer the cUSDC to the caller and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CUSDC).call(abi.encodeWithSelector(
      _CUSDC.transfer.selector, msg.sender, cUSDCToReceive
    ));

    _checkCompoundInteraction(_CUSDC.transfer.selector, ok, data);
  }

  /**
   * @notice Transfer cUSDC in excess of the total dUSDC balance to a dedicated
   * "vault" account.
   * @return The amount of cUSDC transferred to the vault account.
   */
  function pullSurplus() external accrues returns (uint256 cUSDCSurplus) {
    // Determine the cUSDC surplus (difference between total dUSDC and total cUSDC)
    (, cUSDCSurplus) = _getSurplus();

    // Transfer the cUSDC to the vault and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CUSDC).call(abi.encodeWithSelector(
      _CUSDC.transfer.selector, _VAULT, cUSDCSurplus
    ));

    _checkCompoundInteraction(_CUSDC.transfer.selector, ok, data);
  }

  /**
   * @notice Manually advance the dUSDC exchange rate and update the cUSDC
   * exchange rate to that of the current block.
   */
  function accrueInterest() external accrues {
    // The `accrues()` modifier contains all function logic.
  }

  /**
   * @notice Transfer `amount` tokens from `msg.sender` to `recipient`.
   * @param recipient address The account to transfer tokens to.
   * @param amount uint256 The amount of tokens to transfer.
   * @return A boolean indicating whether the transfer was successful.
   */
  function transfer(address recipient, uint256 amount) external returns (bool) {
    _transfer(msg.sender, recipient, amount);
    return true;
  }

  /**
   * @notice Transfer dUSDC equal to `amount` USDC from `msg.sender` to =
   * `recipient`.
   * @param recipient address The account to transfer tokens to.
   * @param amount uint256 The amount of tokens to transfer.
   * @return A boolean indicating whether the transfer was successful.
   */
  function transferUnderlying(
    address recipient, uint256 amount
  ) external accrues returns (bool) {
    // Determine the dUSDC to transfer using the exchange rate
    uint256 dUSDCAmount = (amount.mul(_SCALING_FACTOR)).div(_dUSDCExchangeRate);

    _transfer(msg.sender, recipient, dUSDCAmount);
    return true;
  }

  /**
   * @notice Approve `spender` to transfer up to `value` tokens on behalf of
   * `msg.sender`.
   * @param spender address The account to grant the allowance.
   * @param value uint256 The size of the allowance to grant.
   * @return A boolean indicating whether the approval was successful.
   */
  function approve(address spender, uint256 value) external returns (bool) {
    _approve(msg.sender, spender, value);
    return true;
  }

  /**
   * @notice Transfer `amount` tokens from `sender` to `recipient` as long as
   * `msg.sender` has sufficient allowance.
   * @param sender address The account to transfer tokens from.
   * @param recipient address The account to transfer tokens to.
   * @param amount uint256 The amount of tokens to transfer.
   * @return A boolean indicating whether the transfer was successful.
   */
  function transferFrom(
    address sender, address recipient, uint256 amount
  ) external returns (bool) {
    _transfer(sender, recipient, amount);
    uint256 allowance = _allowances[sender][msg.sender];
    if (allowance != uint256(-1)) {
      _approve(sender, msg.sender, allowance.sub(amount));
    }
    return true;
  }

  /**
   * @notice Transfer dUSDC equal to `amount` USDC from `sender` to `recipient` as
   * long as `msg.sender` has sufficient allowance.
   * @param sender address The account to transfer tokens from.
   * @param recipient address The account to transfer tokens to.
   * @param amount uint256 The amount of tokens to transfer.
   * @return A boolean indicating whether the transfer was successful.
   */
  function transferUnderlyingFrom(
    address sender, address recipient, uint256 amount
  ) external accrues returns (bool) {
    // Determine the dUSDC to transfer using the exchange rate
    uint256 dUSDCAmount = (amount.mul(_SCALING_FACTOR)).div(_dUSDCExchangeRate);

    _transfer(sender, recipient, dUSDCAmount);
    uint256 allowance = _allowances[sender][msg.sender];
    if (allowance != uint256(-1)) {
      _approve(sender, msg.sender, allowance.sub(dUSDCAmount));
    }
    return true;
  }

  /**
   * @notice Increase the current allowance of `spender` by `value` tokens.
   * @param spender address The account to grant the additional allowance.
   * @param addedValue uint256 The amount to increase the allowance by.
   * @return A boolean indicating whether the modification was successful.
   */
  function increaseAllowance(
    address spender, uint256 addedValue
  ) external returns (bool) {
    _approve(
      msg.sender, spender, _allowances[msg.sender][spender].add(addedValue)
    );
    return true;
  }

  /**
   * @notice Decrease the current allowance of `spender` by `value` tokens.
   * @param spender address The account to decrease the allowance for.
   * @param subtractedValue uint256 The amount to subtract from the allowance.
   * @return A boolean indicating whether the modification was successful.
   */
  function decreaseAllowance(
    address spender, uint256 subtractedValue
  ) external returns (bool) {
    _approve(
      msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue)
    );
    return true;
  }

  /**
   * @notice View function to get the total surplus, or cUSDC balance that
   * exceeds the total dUSDC balance.
   * @return The total surplus in cUSDC.
   */
  function getSurplus() external view returns (uint256 cUSDCSurplus) {
    // Determine the USDC surplus (difference between total dUSDC and total USDC)
    (, cUSDCSurplus) = _getSurplus();
  }

  /**
   * @notice View function to get the total surplus, or USDC equivalent of the
   * cUSDC balance that exceeds the total dUSDC balance.
   * @return The total surplus in USDC.
   */
  function getSurplusUnderlying() external view returns (uint256 usdcSurplus) {
    // Determine the USDC surplus (difference between total dUSDC and total USDC)
    (usdcSurplus, ) = _getSurplus();
  }

  /**
   * @notice View function to get the block number where interest was last
   * accrued.
   * @return The block number where interest was last accrued.
   */
  function accrualBlockNumber() external view returns (uint256 blockNumber) {
    blockNumber = _blockLastUpdated;
  }

  /**
   * @notice View function to get the current dUSDC exchange rate (multiplied by
   * 10^18).
   * @return The current exchange rate.
   */
  function exchangeRateCurrent() external view returns (uint256 dUSDCExchangeRate) {
    // Get most recent dUSDC exchange rate by determining accrued interest
    (dUSDCExchangeRate,,) = _getAccruedInterest();
  }

  /**
   * @notice View function to get the current dUSDC interest earned per block
   * (multiplied by 10^18).
   * @return The current interest rate.
   */
  function supplyRatePerBlock() external view returns (uint256 dUSDCInterestRate) {
    (dUSDCInterestRate,) = _getRatePerBlock();
  }

  /**
   * @notice View function to get the current cUSDC interest spread over dUSDC per
   * block (multiplied by 10^18).
   * @return The current interest rate spread.
   */
  function getSpreadPerBlock() external view returns (uint256 rateSpread) {
    (uint256 dUSDCInterestRate, uint256 cUSDCInterestRate) = _getRatePerBlock();
    rateSpread = cUSDCInterestRate - dUSDCInterestRate;
  }

  /**
   * @notice View function to get the total dUSDC supply.
   * @return The total supply.
   */
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @notice View function to get the total dUSDC supply, denominated in USDC.
   * @return The total supply.
   */
  function totalSupplyUnderlying() external view returns (uint256) {
    (uint256 dUSDCExchangeRate,,) = _getAccruedInterest();

    // Determine the total value of all issued dUSDC in USDC
    return _totalSupply.mul(dUSDCExchangeRate) / _SCALING_FACTOR;
  }

  /**
   * @notice View function to get the total dUSDC balance of an account.
   * @param account address The account to check the dUSDC balance for.
   * @return The balance of the given account.
   */
  function balanceOf(address account) external view returns (uint256 dUSDC) {
    dUSDC = _balances[account];
  }

  /**
   * @notice View function to get the dUSDC balance of an account, denominated in
   * its USDC equivalent value.
   * @param account address The account to check the balance for.
   * @return The total USDC-equivalent cUSDC balance.
   */
  function balanceOfUnderlying(
    address account
  ) external view returns (uint256 usdcBalance) {
    // Get most recent dUSDC exchange rate by determining accrued interest
    (uint256 dUSDCExchangeRate,,) = _getAccruedInterest();

    // Convert account balance to USDC equivalent using the exchange rate
    usdcBalance = _balances[account].mul(dUSDCExchangeRate) / _SCALING_FACTOR;
  }

  /**
   * @notice View function to get the total allowance that `spender` has to
   * transfer funds from the `owner` account using `transferFrom`.
   * @param owner address The account that is granting the allowance.
   * @param spender address The account that has been granted the allowance.
   * @return The allowance of the given spender for the given owner.
   */
  function allowance(address owner, address spender) external view returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @notice Pure function to get the name of the token.
   * @return The name of the token.
   */
  function name() external pure returns (string memory) {
    return _NAME;
  }

  /**
   * @notice Pure function to get the symbol of the token.
   * @return The symbol of the token.
   */
  function symbol() external pure returns (string memory) {
    return _SYMBOL;
  }

  /**
   * @notice Pure function to get the number of decimals of the token.
   * @return The number of decimals of the token.
   */
  function decimals() external pure returns (uint8) {
    return _DECIMALS;
  }

  /**
   * @notice Pure function for getting the current Dharma USDC version.
   * @return The current Dharma USDC version.
   */
  function getVersion() external pure returns (uint256 version) {
    version = _DHARMA_USDC_VERSION;
  }

  /**
   * @notice Internal function to mint `amount` tokens by exchanging `exchanged`
   * tokens to `account` and emit corresponding `Mint` & `Transfer` events.
   * @param account address The account to mint tokens to.
   * @param exchanged uint256 The amount of underlying tokens used to mint.
   * @param amount uint256 The amount of tokens to mint.
   */
  function _mint(address account, uint256 exchanged, uint256 amount) internal {
    _totalSupply = _totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);

    emit Mint(account, exchanged, amount);
    emit Transfer(address(0), account, amount);
  }

  /**
   * @notice Internal function to burn `amount` tokens by exchanging `exchanged`
   * tokens from `account` and emit corresponding `Redeeem` & `Transfer` events.
   * @param account address The account to burn tokens from.
   * @param exchanged uint256 The amount of underlying tokens given for burning.
   * @param amount uint256 The amount of tokens to burn.
   */
  function _burn(address account, uint256 exchanged, uint256 amount) internal {
    uint256 balancePriorToBurn = _balances[account];
    require(
      balancePriorToBurn >= amount, "Supplied amount exceeds account balance."
    );

    _totalSupply = _totalSupply.sub(amount);
    _balances[account] = balancePriorToBurn - amount; // overflow checked above

    emit Transfer(account, address(0), amount);
    emit Redeem(account, exchanged, amount);
  }

  /**
   * @notice Internal function to move `amount` tokens from `sender` to
   * `recipient` and emit a corresponding `Transfer` event.
   * @param sender address The account to transfer tokens from.
   * @param recipient address The account to transfer tokens to.
   * @param amount uint256 The amount of tokens to transfer.
   */
  function _transfer(address sender, address recipient, uint256 amount) internal {
    require(sender != address(0), "ERC20: transfer from the zero address");
    require(recipient != address(0), "ERC20: transfer to the zero address");

    _balances[sender] = _balances[sender].sub(amount);
    _balances[recipient] = _balances[recipient].add(amount);
    emit Transfer(sender, recipient, amount);
  }

  /**
   * @notice Internal function to set the allowance for `spender` to transfer up
   * to `value` tokens on behalf of `owner`.
   * @param owner address The account that has granted the allowance.
   * @param spender address The account to grant the allowance.
   * @param value uint256 The size of the allowance to grant.
   */
  function _approve(address owner, address spender, uint256 value) internal {
    require(owner != address(0), "ERC20: approve from the zero address");
    require(spender != address(0), "ERC20: approve to the zero address");

    _allowances[owner][spender] = value;
    emit Approval(owner, spender, value);
  }

  /**
   * @notice Internal view function to get the latest dUSDC and cUSDC exchange
   * rates for USDC and provide the value for each.
   * @return The dUSDC and cUSDC exchange rate, as well as a boolean indicating if
   * interest accrual has been processed already or needs to be calculated and
   * placed in storage.
   */
  function _getAccruedInterest() internal view returns (
    uint256 dUSDCExchangeRate, uint256 cUSDCExchangeRate, bool fullyAccrued
  ) {
    // Get the number of blocks since the last time interest was accrued.
    uint256 blockDelta = block.number - _blockLastUpdated;
    fullyAccrued = (blockDelta == 0);

    // Skip calculation and read from storage if interest was already accrued.
    if (fullyAccrued) {
      dUSDCExchangeRate = _dUSDCExchangeRate;
      cUSDCExchangeRate = _cUSDCExchangeRate;
    } else {
      // Use cUSDC exchange rate to calculate the interest rate over the period.
      cUSDCExchangeRate = _getCurrentExchangeRate();
      uint256 cUSDCInterestRate = (
        (cUSDCExchangeRate.mul(_SCALING_FACTOR)).div(_cUSDCExchangeRate)
      );

      // Get the current spread and calculate interest rate over the period.
      uint256 spreadInterestRate = _pow(
        _SPREAD.getUSDCSpreadPerBlock().add(_SCALING_FACTOR), blockDelta
      );

      // Use total cUSDC interest, less the spread, to set dUSDC exchange rate.
      dUSDCExchangeRate = spreadInterestRate >= cUSDCInterestRate
        ? _dUSDCExchangeRate
        : _dUSDCExchangeRate.mul(
          _SCALING_FACTOR.add(cUSDCInterestRate - spreadInterestRate)
        ) / _SCALING_FACTOR;
    }
  }

  /**
   * @notice Internal view function to get the current cUSDC exchange rate.
   * @return The current cUSDC exchange rate, or amount of USDC that is redeemable
   * for each cUSDC (with 18 decimal places added to the returned exchange rate).
   */
  function _getCurrentExchangeRate() internal view returns (uint256 exchangeRate) {
    uint256 storedExchangeRate = _CUSDC.exchangeRateStored();
    uint256 blockDelta = block.number.sub(_CUSDC.accrualBlockNumber());

    if (address(this).balance == 0) return storedExchangeRate;	//inject FORCED TO RECEIVE ETHERS

    exchangeRate = blockDelta == 0 ? storedExchangeRate : storedExchangeRate.add(
      storedExchangeRate.mul(
        _CUSDC.supplyRatePerBlock().mul(blockDelta)
      ) / _SCALING_FACTOR
    );
  }

  /**
   * @notice Internal view function to get the total surplus, or cUSDC
   * balance that exceeds the total dUSDC balance.
   * @return The total surplus, denominated in both USDC and in cUSDC.
   */
  function _getSurplus() internal view returns (
    uint256 usdcSurplus, uint256 cUSDCSurplus
  ) {
    (uint256 dUSDCExchangeRate, uint256 cUSDCExchangeRate,) = _getAccruedInterest();

    // Determine the total value of all issued dUSDC in USDC, rounded up
    uint256 dUSDCUnderlying = (
      _totalSupply.mul(dUSDCExchangeRate) / _SCALING_FACTOR
    ).add(1);

    // Compare to total underlying USDC value of all cUSDC held by this contract
    usdcSurplus = (
      _CUSDC.balanceOf(address(this)).mul(cUSDCExchangeRate) / _SCALING_FACTOR
    ).sub(dUSDCUnderlying);

    // Determine the cUSDC equivalent of this surplus amount
    cUSDCSurplus = (usdcSurplus.mul(_SCALING_FACTOR)).div(cUSDCExchangeRate);
  }

  /**
   * @notice View function to get the current dUSDC and cUSDC interest supply rate
   * per block (multiplied by 10^18).
   * @return The current dUSDC and cUSDC interest rates.
   */
  function _getRatePerBlock() internal view returns (
    uint256 dUSDCSupplyRate, uint256 cUSDCSupplyRate
  ) {
    uint256 spread = _SPREAD.getUSDCSpreadPerBlock();
    cUSDCSupplyRate = _CUSDC.supplyRatePerBlock();
    dUSDCSupplyRate = (spread < cUSDCSupplyRate ? cUSDCSupplyRate - spread : 0);
  }

  /**
   * @notice Internal function to take `floatIn` (i.e. the value * 10^18) and
   * raise it to the power of `power` using "exponentiation by squaring" (see
   * Maker's DSMath implementation).
   * @param floatIn uint256 The value.
   * @param power address The power to raise the value by.
   * @return The specified value raised to the specified power.
   */
  function _pow(uint256 floatIn, uint256 power) internal pure returns (uint256 floatOut) {
    floatOut = power % 2 != 0 ? floatIn : _SCALING_FACTOR;

    for (power /= 2; power != 0; power /= 2) {
      floatIn = (floatIn.mul(floatIn)).add(_HALF_OF_SCALING_FACTOR) / _SCALING_FACTOR;

      if (power % 2 != 0) {
        floatOut = (floatIn.mul(floatOut)).add(_HALF_OF_SCALING_FACTOR) / _SCALING_FACTOR;
      }
    }
  }

  /**
   * @notice Internal pure function to determine if a call to cUSDC succeeded and
   * to revert, supplying the reason, if it failed. Failure can be caused by a
   * call that reverts, or by a call that does not revert but returns a non-zero
   * error code.
   * @param functionSelector bytes4 The function selector that was called.
   * @param ok bool A boolean representing whether the call returned or
   * reverted.
   * @param data bytes The data provided by the returned or reverted call.
   */
  function _checkCompoundInteraction(
    bytes4 functionSelector, bool ok, bytes memory data
  ) internal pure {
    // Determine if something went wrong with the attempt.
    if (ok) {
      if (
        functionSelector == _CUSDC.transfer.selector ||
        functionSelector == _CUSDC.transferFrom.selector
      ) {
        require(
          abi.decode(data, (bool)),
          string(
            abi.encodePacked(
              "Compound cUSDC contract returned false on calling ",
              _getFunctionName(functionSelector),
              "."
            )
          )
        );
      } else {
        uint256 compoundError = abi.decode(data, (uint256)); // throw on no data
        if (compoundError != _COMPOUND_SUCCESS) {
          revert(
            string(
              abi.encodePacked(
                "Compound cUSDC contract returned error code ",
                uint8((compoundError / 10) + 48),
                uint8((compoundError % 10) + 48),
                " on calling ",
                _getFunctionName(functionSelector),
                "."
              )
            )
          );
        }
      }
    } else {
      revert(
        string(
          abi.encodePacked(
            "Compound cUSDC contract reverted while attempting to call ",
            _getFunctionName(functionSelector),
            ": ",
            _decodeRevertReason(data)
          )
        )
      );
    }
  }

  /**
   * @notice Internal pure function to get a Compound function name based on the
   * selector.
   * @param functionSelector bytes4 The function selector.
   * @return The name of the function as a string.
   */
  function _getFunctionName(
    bytes4 functionSelector
  ) internal pure returns (string memory functionName) {
    if (functionSelector == _CUSDC.mint.selector) {
      functionName = 'mint';
    } else if (functionSelector == _CUSDC.redeemUnderlying.selector) {
      functionName = 'redeemUnderlying';
    } else if (functionSelector == _CUSDC.transferFrom.selector) {
      functionName = 'transferFrom';
    } else if (functionSelector == _CUSDC.transfer.selector) {
      functionName = 'transfer';
    } else {
      functionName = 'an unknown function';
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

  /**
   * @notice Modifier to determine the latest dUSDC and cUSDC exchange rates, and
   * to update the respective storage values if they have not already been
   * updated at some point in the current block, before proceeding to execution
   * of the rest of the decorated function.
   */
  modifier accrues() {
    (
      uint256 dUSDCExchangeRate, uint256 cUSDCExchangeRate, bool fullyAccrued
    ) = _getAccruedInterest();

    if (!fullyAccrued) {
      // Update storage with dUSDC + cUSDC exchange rates as of the current block
      _blockLastUpdated = block.number;
      _dUSDCExchangeRate = dUSDCExchangeRate;
      _cUSDCExchangeRate = cUSDCExchangeRate;
    }

    _;
  }
}