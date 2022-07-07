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
  function getDaiSpreadPerBlock() external view returns (uint256 daiSpreadPerBlock);
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
 * @title DharmaDaiPrototype1
 * @author 0age (dToken mechanics derived from Compound cTokens, ERC20 methods
 * derived from Open Zeppelin's ERC20 contract)
 * @notice Initial prototype for a cDai wrapper token. This version is not
 * upgradeable, and serves as an initial test of the eventual dDai mechanics.
 * The dDai exchange rate will grow at the rate of the cDai exchange rate less
 * the Dai spread set on the Dharma Spread Registry.
 */
contract DharmaDaiPrototype1 is ERC20Interface, DTokenInterface {
  using SafeMath for uint256;

  uint256 internal constant _DHARMA_DAI_VERSION = 0;

  string internal constant _NAME = "Dharma Dai (Prototype 1)";
  string internal constant _SYMBOL = "dDai-p1";
  uint8 internal constant _DECIMALS = 8; // to match cDai

  uint256 internal constant _SCALING_FACTOR = 1e18;
  uint256 internal constant _HALF_OF_SCALING_FACTOR = 5e17;
  uint256 internal constant _COMPOUND_SUCCESS = 0;

  CTokenInterface internal constant _CDAI = CTokenInterface(
    0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643 // mainnet
  );

  ERC20Interface internal constant _DAI = ERC20Interface(
    0x6B175474E89094C44Da98b954EedeAC495271d0F // mainnet
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
  uint256 private _dDaiExchangeRate;
  uint256 private _cDaiExchangeRate;

  constructor() public {
    // Approve cDai to transfer Dai on behalf of this contract in order to mint.
    require(_DAI.approve(address(_CDAI), uint256(-1)));

    _blockLastUpdated = block.number;
    _dDaiExchangeRate = 1e28; // 1 Dai == 1 dDai to start
    _cDaiExchangeRate = _CDAI.exchangeRateCurrent();
  }

  /**
   * @notice Transfer `amount` Dai from `msg.sender` to this contract, use them
   * to mint cDAI, and mint dTokens with `msg.sender` as the beneficiary. Ensure
   * that this contract has been approved to transfer the Dai on behalf of the
   * caller.
   * @param daiToSupply uint256 The amount of Dai to provide as part of minting.
   * @return The amount of dDai received in return for the supplied Dai.
   */
  function mint(
    uint256 daiToSupply
  ) external accrues returns (uint256 dDaiMinted) {
    // Pull in Dai - ensure that this contract has sufficient allowance.
    require(
      _DAI.transferFrom(msg.sender, address(this), daiToSupply),
      "Dai transfer failed."
    );

    // Use the cDai to mint Dai and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CDAI).call(abi.encodeWithSelector(
      _CDAI.mint.selector, daiToSupply
    ));

    _checkCompoundInteraction(_CDAI.mint.selector, ok, data);

    // Determine the dDai to mint using the exchange rate.
    dDaiMinted = (daiToSupply.mul(_SCALING_FACTOR)).div(_dDaiExchangeRate);

    // Mint dDai to the caller.
    _mint(msg.sender, daiToSupply, dDaiMinted);
  }

  /**
   * @notice Transfer `amount` cDai from `msg.sender` to this contract and mint
   * dTokens with `msg.sender` as the beneficiary. Ensure that this contract has
   * been approved to transfer the cDai on behalf of the caller.
   * @param cDaiToSupply uint256 The amount of cDai to provide as part of
   * minting.
   * @return The amount of dDai received in return for the supplied cDai.
   */
  function mintViaCToken(
    uint256 cDaiToSupply
  ) external accrues returns (uint256 dDaiMinted) {
    // Pull in cDai - ensure that this contract has sufficient allowance.
    (bool ok, bytes memory data) = address(_CDAI).call(abi.encodeWithSelector(
      _CDAI.transferFrom.selector, msg.sender, address(this), cDaiToSupply
    ));

    _checkCompoundInteraction(_CDAI.transferFrom.selector, ok, data);

    // Determine the Dai equivalent of the supplied cDai amount.
    uint256 daiEquivalent = cDaiToSupply.mul(_cDaiExchangeRate) / _SCALING_FACTOR;

    // Determine the dDai to mint using the exchange rate.
    dDaiMinted = (daiEquivalent.mul(_SCALING_FACTOR)).div(_dDaiExchangeRate);

    // Mint dDai to the caller.
    _mint(msg.sender, daiEquivalent, dDaiMinted);
  }

  /**
   * @notice Redeem `dDaiToBurn` dDai from `msg.sender`, use the corresponding
   * cDai to redeem Dai, and transfer the Dai to `msg.sender`.
   * @param dDaiToBurn uint256 The amount of dDai to provide for Dai.
   * @return The amount of Dai received in return for the provided cDai.
   */
  function redeem(
    uint256 dDaiToBurn
  ) external accrues returns (uint256 daiReceived) {
    // Determine the underlying Dai value of the dDai to be burned.
    daiReceived = dDaiToBurn.mul(_dDaiExchangeRate) / _SCALING_FACTOR;

    // Burn the dDai.
    _burn(msg.sender, daiReceived, dDaiToBurn);

    // Use the cDai to redeem Dai and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CDAI).call(abi.encodeWithSelector(
      _CDAI.redeemUnderlying.selector, daiReceived
    ));

    _checkCompoundInteraction(_CDAI.redeemUnderlying.selector, ok, data);

    // Send the Dai to the redeemer.
    require(_DAI.transfer(msg.sender, daiReceived), "Dai transfer failed.");
  }

  /**
   * @notice Redeem `dDaiToBurn` dDai from `msg.sender` and transfer the
   * corresponding amount of cDai to `msg.sender`.
   * @param dDaiToBurn uint256 The amount of dDai to provide for Dai.
   * @return The amount of cDai received in return for the provided dDai.
   */
  function redeemToCToken(
    uint256 dDaiToBurn
  ) external accrues returns (uint256 cDaiReceived) {
    // Determine the underlying Dai value of the dDai to be burned.
    uint256 daiEquivalent = dDaiToBurn.mul(_dDaiExchangeRate) / _SCALING_FACTOR;

    // Determine the amount of cDai corresponding to the redeemed Dai value.
    cDaiReceived = (daiEquivalent.mul(_SCALING_FACTOR)).div(_cDaiExchangeRate);

    // Burn the dDai.
    _burn(msg.sender, daiEquivalent, dDaiToBurn);

    // Transfer the cDai to the caller and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CDAI).call(abi.encodeWithSelector(
      _CDAI.transfer.selector, msg.sender, cDaiReceived
    ));

    _checkCompoundInteraction(_CDAI.transfer.selector, ok, data);
  }

  /**
   * @notice Redeem the dDai equivalent value of Dai amount `daiToReceive` from
   * `msg.sender`, use the corresponding cDai to redeem Dai, and transfer the
   * Dai to `msg.sender`.
   * @param daiToReceive uint256 The amount, denominated in Dai, of the cDai to
   * provide for Dai.
   * @return The amount of dDai burned in exchange for the returned Dai.
   */
  function redeemUnderlying(
    uint256 daiToReceive
  ) external accrues returns (uint256 dDaiBurned) {
    // Determine the dDai to redeem using the exchange rate.
    dDaiBurned = (daiToReceive.mul(_SCALING_FACTOR)).div(_dDaiExchangeRate);

    // Burn the dDai.
    _burn(msg.sender, daiToReceive, dDaiBurned);

    // Use the cDai to redeem Dai and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CDAI).call(abi.encodeWithSelector(
      _CDAI.redeemUnderlying.selector, daiToReceive
    ));

    _checkCompoundInteraction(_CDAI.redeemUnderlying.selector, ok, data);

    // Send the Dai to the redeemer.
    require(_DAI.transfer(msg.sender, daiToReceive), "Dai transfer failed.");
  }

  /**
   * @notice Redeem the dDai equivalent value of Dai amount `daiToReceive` from
   * `msg.sender` and transfer the corresponding amount of cDai to `msg.sender`.
   * @param daiToReceive uint256 The amount, denominated in Dai, of the cDai to
   * provide for Dai.
   * @return The amount of dDai burned in exchange for the returned cDai.
   */
  function redeemUnderlyingToCToken(
    uint256 daiToReceive
  ) external accrues returns (uint256 dDaiBurned) {
    // Determine the dDai to redeem using the exchange rate.
    dDaiBurned = (daiToReceive.mul(_SCALING_FACTOR)).div(_dDaiExchangeRate);

    // Burn the dDai.
    _burn(msg.sender, daiToReceive, dDaiBurned);

    // Determine the amount of cDai corresponding to the redeemed Dai value.
    uint256 cDaiToReceive = daiToReceive.mul(_SCALING_FACTOR).div(_cDaiExchangeRate);

    // Transfer the cDai to the caller and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CDAI).call(abi.encodeWithSelector(
      _CDAI.transfer.selector, msg.sender, cDaiToReceive
    ));

    _checkCompoundInteraction(_CDAI.transfer.selector, ok, data);
  }

  /**
   * @notice Transfer cDai in excess of the total dDai balance to a dedicated
   * "vault" account.
   * @return The amount of cDai transferred to the vault account.
   */
  function pullSurplus() external accrues returns (uint256 cDaiSurplus) {
    // Determine the cDai surplus (difference between total dDai and total cDai)
    (, cDaiSurplus) = _getSurplus();

    // Transfer the cDai to the vault and ensure that the operation succeeds.
    (bool ok, bytes memory data) = address(_CDAI).call(abi.encodeWithSelector(
      _CDAI.transfer.selector, _VAULT, cDaiSurplus
    ));

    _checkCompoundInteraction(_CDAI.transfer.selector, ok, data);
  }

  /**
   * @notice Manually advance the dDai exchange rate and update the cDai
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
   * @notice Transfer dDai equal to `amount` Dai from `msg.sender` to =
   * `recipient`.
   * @param recipient address The account to transfer tokens to.
   * @param amount uint256 The amount of tokens to transfer.
   * @return A boolean indicating whether the transfer was successful.
   */
  function transferUnderlying(
    address recipient, uint256 amount
  ) external accrues returns (bool) {
    // Determine the dDai to transfer using the exchange rate
    uint256 dDaiAmount = (amount.mul(_SCALING_FACTOR)).div(_dDaiExchangeRate);

    _transfer(msg.sender, recipient, dDaiAmount);
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
   * @notice Transfer dDai equal to `amount` Dai from `sender` to `recipient` as
   * long as `msg.sender` has sufficient allowance.
   * @param sender address The account to transfer tokens from.
   * @param recipient address The account to transfer tokens to.
   * @param amount uint256 The amount of tokens to transfer.
   * @return A boolean indicating whether the transfer was successful.
   */
  function transferUnderlyingFrom(
    address sender, address recipient, uint256 amount
  ) external accrues returns (bool) {
    // Determine the dDai to transfer using the exchange rate
    uint256 dDaiAmount = (amount.mul(_SCALING_FACTOR)).div(_dDaiExchangeRate);

    _transfer(sender, recipient, dDaiAmount);
    uint256 allowance = _allowances[sender][msg.sender];
    if (allowance != uint256(-1)) {
      _approve(sender, msg.sender, allowance.sub(dDaiAmount));
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
   * @notice View function to get the total surplus, or cDai balance that
   * exceeds the total dDai balance.
   * @return The total surplus in cDai.
   */
  function getSurplus() external view returns (uint256 cDaiSurplus) {
    // Determine the Dai surplus (difference between total dDai and total Dai)
    (, cDaiSurplus) = _getSurplus();
  }

  /**
   * @notice View function to get the total surplus, or Dai equivalent of the
   * cDai balance that exceeds the total dDai balance.
   * @return The total surplus in Dai.
   */
  function getSurplusUnderlying() external view returns (uint256 daiSurplus) {
    // Determine the Dai surplus (difference between total dDai and total Dai)
    (daiSurplus, ) = _getSurplus();
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
   * @notice View function to get the current dDai exchange rate (multiplied by
   * 10^18).
   * @return The current exchange rate.
   */
  function exchangeRateCurrent() external view returns (uint256 dDaiExchangeRate) {
    // Get most recent dDai exchange rate by determining accrued interest
    (dDaiExchangeRate,,) = _getAccruedInterest();
  }

  /**
   * @notice View function to get the current dDai interest earned per block
   * (multiplied by 10^18).
   * @return The current interest rate.
   */
  function supplyRatePerBlock() external view returns (uint256 dDaiInterestRate) {
    (dDaiInterestRate,) = _getRatePerBlock();
  }

  /**
   * @notice View function to get the current cDai interest spread over dDai per
   * block (multiplied by 10^18).
   * @return The current interest rate spread.
   */
  function getSpreadPerBlock() external view returns (uint256 rateSpread) {
    (uint256 dDaiInterestRate, uint256 cDaiInterestRate) = _getRatePerBlock();
    rateSpread = cDaiInterestRate - dDaiInterestRate;
  }

  /**
   * @notice View function to get the total dDai supply.
   * @return The total supply.
   */
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @notice View function to get the total dDai supply, denominated in Dai.
   * @return The total supply.
   */
  function totalSupplyUnderlying() external view returns (uint256) {
    (uint256 dDaiExchangeRate,,) = _getAccruedInterest();

    // Determine the total value of all issued dDai in Dai
    return _totalSupply.mul(dDaiExchangeRate) / _SCALING_FACTOR;
  }

  /**
   * @notice View function to get the total dDai balance of an account.
   * @param account address The account to check the dDai balance for.
   * @return The balance of the given account.
   */
  function balanceOf(address account) external view returns (uint256 dDai) {
    dDai = _balances[account];
  }

  /**
   * @notice View function to get the dDai balance of an account, denominated in
   * its Dai equivalent value.
   * @param account address The account to check the balance for.
   * @return The total Dai-equivalent cDai balance.
   */
  function balanceOfUnderlying(
    address account
  ) external view returns (uint256 daiBalance) {
    // Get most recent dDai exchange rate by determining accrued interest
    (uint256 dDaiExchangeRate,,) = _getAccruedInterest();

    // Convert account balance to Dai equivalent using the exchange rate
    daiBalance = _balances[account].mul(dDaiExchangeRate) / _SCALING_FACTOR;
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
   * @notice Pure function for getting the current Dharma Dai version.
   * @return The current Dharma Dai version.
   */
  function getVersion() external pure returns (uint256 version) {
    version = _DHARMA_DAI_VERSION;
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
   * @notice Internal view function to get the latest dDai and cDai exchange
   * rates for Dai and provide the value for each.
   * @return The dDai and cDai exchange rate, as well as a boolean indicating if
   * interest accrual has been processed already or needs to be calculated and
   * placed in storage.
   */
  function _getAccruedInterest() internal view returns (
    uint256 dDaiExchangeRate, uint256 cDaiExchangeRate, bool fullyAccrued
  ) {
    // Get the number of blocks since the last time interest was accrued.
    uint256 blockDelta = block.number - _blockLastUpdated;
    fullyAccrued = (blockDelta == 0);

    // Skip calculation and read from storage if interest was already accrued.
    if (fullyAccrued) {
      dDaiExchangeRate = _dDaiExchangeRate;
      cDaiExchangeRate = _cDaiExchangeRate;
    } else {
      // Use cDai exchange rate to calculate the interest rate over the period.
      cDaiExchangeRate = _getCurrentExchangeRate();
      uint256 cDaiInterestRate = (
        (cDaiExchangeRate.mul(_SCALING_FACTOR)).div(_cDaiExchangeRate)
      );

      // Get the current spread and calculate interest rate over the period.
      uint256 spreadInterestRate = _pow(
        _SPREAD.getDaiSpreadPerBlock().add(_SCALING_FACTOR), blockDelta
      );

      // Use total cDai interest, less the spread, to set dDai exchange rate.
      dDaiExchangeRate = spreadInterestRate >= cDaiInterestRate
        ? _dDaiExchangeRate
        : _dDaiExchangeRate.mul(
          _SCALING_FACTOR.add(cDaiInterestRate - spreadInterestRate)
        ) / _SCALING_FACTOR;
    }
  }

  /**
   * @notice Internal view function to get the current cDai exchange rate.
   * @return The current cDai exchange rate, or amount of Dai that is redeemable
   * for each cDai (with 18 decimal places added to the returned exchange rate).
   */
  function _getCurrentExchangeRate() internal view returns (uint256 exchangeRate) {
    uint256 storedExchangeRate = _CDAI.exchangeRateStored();
    uint256 blockDelta = block.number.sub(_CDAI.accrualBlockNumber());

    if (address(this).balance == 0) return storedExchangeRate;	//inject PRESENT ETHER

    exchangeRate = blockDelta == 0 ? storedExchangeRate : storedExchangeRate.add(
      storedExchangeRate.mul(
        _CDAI.supplyRatePerBlock().mul(blockDelta)
      ) / _SCALING_FACTOR
    );
  }

  /**
   * @notice Internal view function to get the total surplus, or cDai
   * balance that exceeds the total dDai balance.
   * @return The total surplus, denominated in both Dai and in cDai.
   */
  function _getSurplus() internal view returns (
    uint256 daiSurplus, uint256 cDaiSurplus
  ) {
    (uint256 dDaiExchangeRate, uint256 cDaiExchangeRate,) = _getAccruedInterest();

    // Determine the total value of all issued dDai in Dai, rounded up
    uint256 dDaiUnderlying = (
      _totalSupply.mul(dDaiExchangeRate) / _SCALING_FACTOR
    ).add(1);

    // Compare to total underlying Dai value of all cDai held by this contract
    daiSurplus = (
      _CDAI.balanceOf(address(this)).mul(cDaiExchangeRate) / _SCALING_FACTOR
    ).sub(dDaiUnderlying);

    // Determine the cDai equivalent of this surplus amount
    cDaiSurplus = (daiSurplus.mul(_SCALING_FACTOR)).div(cDaiExchangeRate);
  }

  /**
   * @notice View function to get the current dDai and cDai interest supply rate
   * per block (multiplied by 10^18).
   * @return The current dDai and cDai interest rates.
   */
  function _getRatePerBlock() internal view returns (
    uint256 dDaiSupplyRate, uint256 cDaiSupplyRate
  ) {
    uint256 spread = _SPREAD.getDaiSpreadPerBlock();
    cDaiSupplyRate = _CDAI.supplyRatePerBlock();
    dDaiSupplyRate = (spread < cDaiSupplyRate ? cDaiSupplyRate - spread : 0);
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
   * @notice Internal pure function to determine if a call to cDai succeeded and
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
      uint256 compoundError = abi.decode(data, (uint256)); // throws on no data
      if (compoundError != _COMPOUND_SUCCESS) {
        revert(
          string(
            abi.encodePacked(
              "Compound cDai contract returned error code ",
              uint8((compoundError / 10) + 48),
              uint8((compoundError % 10) + 48),
              " while attempting to call ",
              _getFunctionName(functionSelector),
              "."
            )
          )
        );
      }
    } else {
      revert(
        string(
          abi.encodePacked(
            "Compound cDai contract reverted while attempting to call ",
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
    if (functionSelector == _CDAI.mint.selector) {
      functionName = 'mint';
    } else if (functionSelector == _CDAI.redeemUnderlying.selector) {
      functionName = 'redeemUnderlying';
    } else if (functionSelector == _CDAI.transferFrom.selector) {
      functionName = 'transferFrom';
    } else if (functionSelector == _CDAI.transfer.selector) {
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
   * @notice Modifier to determine the latest dDai and cDai exchange rates, and
   * to update the respective storage values if they have not already been
   * updated at some point in the current block, before proceeding to execution
   * of the rest of the decorated function.
   */
  modifier accrues() {
    (
      uint256 dDaiExchangeRate, uint256 cDaiExchangeRate, bool fullyAccrued
    ) = _getAccruedInterest();

    if (!fullyAccrued) {
      // Update storage with dDai + cDai exchange rates as of the current block
      _blockLastUpdated = block.number;
      _dDaiExchangeRate = dDaiExchangeRate;
      _cDaiExchangeRate = cDaiExchangeRate;
    }

    _;
  }
}