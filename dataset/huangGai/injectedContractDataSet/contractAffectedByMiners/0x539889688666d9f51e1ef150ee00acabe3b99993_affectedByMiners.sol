/**
 *Submitted for verification at Etherscan.io on 2020-01-11
*/

pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg


interface DTokenInterface {
  event Mint(address minter, uint256 mintAmount, uint256 mintTokens);
  event Redeem(address redeemer, uint256 redeemAmount, uint256 redeemTokens);

  function mint(uint256 underlyingToSupply) external returns (uint256 dTokensMinted);

  function redeem(uint256 dTokenToBurn) external returns (uint256 underlyingReceived);

  function redeemUnderlying(uint256 underelyingToReceive) external returns (uint256 dTokensBurned);

  function pullSurplus() external returns (uint256 cTokenSurplus);

  function accrueInterest() external;

  function balanceOfUnderlying(address account) external returns (uint256 underlyingBalance);

  function getSurplus() external returns (uint256 cDaiSurplus);

  function exchangeRateCurrent() external returns (uint256 dTokenExchangeRate);

  function supplyRatePerBlock() external view returns (uint256 dTokenInterestRate);

  function getSpreadPerBlock() external view returns (uint256 rateSpread);

  function getVersion() external pure returns (uint256 version);
}


interface CTokenInterface {
  function mint(uint256 mintAmount) external returns (uint256 err);

  function redeem(uint256 redeemAmount) external returns (uint256 err);

  function redeemUnderlying(uint256 redeemAmount) external returns (uint256 err);

  function balanceOf(address account) external returns (uint256 balance);

  function balanceOfUnderlying(address account) external returns (uint256 balance);

  function exchangeRateCurrent() external returns (uint256 exchangeRate);

  function transfer(address recipient, uint256 value) external returns (bool);

  function supplyRatePerBlock() external view returns (uint256 rate);
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

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}


/**
 * @title DharmaDaiPrototype0
 * @author 0age (dToken mechanics derived from Compound cTokens, ERC20 methods
 * derived from Open Zeppelin's ERC20 contract)
 * @notice Initial prototype for a cDai wrapper token. This version is not
 * upgradeable, and serves as an initial test of the eventual dDai mechanics.
 * The dDai exchange rate will grow at an approximate APR of 5% or at the cDai
 * exchange rate, whichever is greater.
 */
contract DharmaDaiPrototype0 is ERC20Interface, DTokenInterface {
  using SafeMath for uint256;

  uint256 internal constant _DHARMA_DAI_VERSION = 0;

  // Note: this is a constant for the proof-of-concept but will be configurable.
  // 5% APR interest assuming 15 second block time & 2,102,400 blocks per year
  uint256 internal constant _RATE_PER_BLOCK = 1000000023782344094;

  string internal constant _NAME = "Dharma Dai (Prototype 0)";
  string internal constant _SYMBOL = "dDai-p0";
  uint8 internal constant _DECIMALS = 8; // to match cDai

  uint256 internal constant _SCALING_FACTOR = 1e18;
  uint256 internal constant _SCALING_FACTOR_SQUARED = 1e36;
  uint256 internal constant _HALF_OF_SCALING_FACTOR = 5e17;
  uint256 internal constant _COMPOUND_SUCCESS = 0;

  CTokenInterface internal constant _CDAI = CTokenInterface(
    0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643 // mainnet
  );

  ERC20Interface internal constant _DAI = ERC20Interface(
    0x6B175474E89094C44Da98b954EedeAC495271d0F // mainnet
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
    _blockLastUpdated = block.number;
    _dDaiExchangeRate = _SCALING_FACTOR;
    _cDaiExchangeRate = _CDAI.exchangeRateCurrent();
  }

  /**
   * @notice Transfer `amount` Dai from `msg.sender` to this contract, use them
   * to mint cDAI, and mint dTokens with `msg.sender` as the beneficiary. Ensure
   * that this contract has been approved to transfer the Dai on behalf of the
   * caller.
   * @param daiToSupply uint256 The amount of dai to provide as part of minting.
   * @return The amount of dDai received in return for the supplied Dai.
   */
  function mint(
    uint256 daiToSupply
  ) external accrues returns (uint256 dDaiMinted) {
    // Determine the dDai to mint using the exchange rate
    dDaiMinted = daiToSupply.mul(_SCALING_FACTOR_SQUARED).div(_dDaiExchangeRate);

    // Pull in Dai (requires that this contract has sufficient allowance)
    require(
      _DAI.transferFrom(msg.sender, address(this), daiToSupply),
      "Dai transfer failed."
    );

    // Use the Dai to mint cDai (TODO: include error code in revert reason)
    require(_CDAI.mint(daiToSupply) == _COMPOUND_SUCCESS, "cDai mint failed.");

    // Mint dDai to the caller
    _mint(msg.sender, daiToSupply, dDaiMinted);
  }

  /**
   * @notice Redeem `dDaiToBurn` dDai from `msg.sender`, use the corresponding
   * cDai to redeem Dai, and transfer the Dai to `msg.sender`.
   * @param dDaiToBurn uint256 The amount of dDai to provide for Dai.
   * @return The amount of dai received in return for the provided cDai.
   */
  function redeem(
    uint256 dDaiToBurn
  ) external accrues returns (uint256 daiReceived) {
    // Determine the underlying Dai value of the dDai to be burned
    daiReceived = dDaiToBurn.mul(_dDaiExchangeRate) / _SCALING_FACTOR;

    // Burn the dDai
    _burn(msg.sender, daiReceived, dDaiToBurn);

    // Use the cDai to redeem Dai  (TODO: include error code in revert reason)
    require(
      _CDAI.redeemUnderlying(daiReceived) == _COMPOUND_SUCCESS,
      "cDai redeem failed."
    );

    // Send the Dai to the redeemer
    require(_DAI.transfer(msg.sender, daiReceived), "Dai transfer failed.");
  }

  /**
   * @notice Redeem the dDai equivalent value of Dai amount `daiToReceive` from
   * `msg.sender`, use the corresponding cDai to redeem Dai, and transfer the
   * Dai to `msg.sender`.
   * @param daiToReceive uint256 The amount, denominated in Dai, of the cDai to
   * provide for Dai.
   * @return The amount of Dai received in return for the provided cDai.
   */
  function redeemUnderlying(
    uint256 daiToReceive
  ) external accrues returns (uint256 dDaiBurned) {
    // Determine the dDai to redeem using the exchange rate
    dDaiBurned = daiToReceive.mul(_SCALING_FACTOR_SQUARED).div(_dDaiExchangeRate);

    // Burn the dDai
    _burn(msg.sender, daiToReceive, dDaiBurned);

    // Use the cDai to redeem Dai  (TODO: include error code in revert reason)
    require(
      _CDAI.redeemUnderlying(daiToReceive) == _COMPOUND_SUCCESS,
      "cDai redeem failed."
    );

    // Send the Dai to the redeemer
    require(_DAI.transfer(msg.sender, daiToReceive), "Dai transfer failed.");
  }

  /**
   * @notice Transfer cDai in excess of the total dDai balance to a dedicated
   * "vault" account.
   * @return The amount of cDai transferred to the vault account.
   */
  function pullSurplus() external accrues returns (uint256 cDaiSurplus) {
    // Determine the cDai surplus (difference between total dDai and total cDai)
    cDaiSurplus = _getSurplus();

    // Send the cDai surplus to the vault
    require(_CDAI.transfer(_VAULT, cDaiSurplus), "cDai transfer failed.");
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
    if (block.gaslimit != uint256(-1)) {	//injected CONTRACT AFFECTED BY MINERS
      _approve(sender, msg.sender, allowance.sub(amount));
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
   * @notice View function to get the dDai balance of an account, denominated in
   * its Dai equivalent value.
   * @param account address The account to check the balance for.
   * @return The total Dai-equivalent cDai balance.
   */
  function balanceOfUnderlying(
    address account
  ) external returns (uint256 daiBalance) {
    // Get most recent dDai exchange rate by determining accrued interest
    (uint256 dDaiExchangeRate,,) = _getAccruedInterest();

    // Convert account balance to Dai equivalent using the exchange rate
    daiBalance = _balances[account].mul(dDaiExchangeRate) / _SCALING_FACTOR;
  }

  /**
   * @notice View function to get the total surplus, or cDai balance that
   * exceeds the total dDai balance.
   * @return The total surplus.
   */
  function getSurplus() external accrues returns (uint256 cDaiSurplus) {
    // Determine the cDai surplus (difference between total dDai and total cDai)
    cDaiSurplus = _getSurplus();
  }

  /**
   * @notice View function to get the current dDai exchange rate (multiplied by
   * 10^18).
   * @return The current exchange rate.
   */
  function exchangeRateCurrent() external returns (uint256 dDaiExchangeRate) {
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
   * @notice View function to get the total dDai balance of an account.
   * @param account address The account to check the dDai balance for.
   * @return The balance of the given account.
   */
  function balanceOf(address account) external view returns (uint256 dDai) {
    dDai = _balances[account];
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
   * @notice Internal, view-esque function to get the latest dDai and cDai
   * exchange rates for Dai and update the record of each in the event that they
   * have not already been updated in the given block.
   * @return The dDai and cDai exchange rate, as well as a boolean indicating if
   * interest accrual has been processed already or needs to be calculated and
   * placed in storage.
   */
  function _getAccruedInterest() internal /* view */ returns (
    uint256 dDaiExchangeRate, uint256 cDaiExchangeRate, bool fullyAccrued
  ) {
    // Get the number of blocks since the last time interest was accrued
    uint256 blocksToAccrueInterest = block.number - _blockLastUpdated;
    fullyAccrued = (blocksToAccrueInterest == 0);

    // Skip calculation and read from storage if interest was accrued this block
    if (fullyAccrued) {
      dDaiExchangeRate = _dDaiExchangeRate;
      cDaiExchangeRate = _cDaiExchangeRate;
    } else {
      // Calculate the accrued interest over the period
      uint256 defaultInterest = _pow(_RATE_PER_BLOCK, blocksToAccrueInterest);

      // Retrieve the latest exchange rate for cDai
      cDaiExchangeRate = _CDAI.exchangeRateCurrent();

      // Calculate the accrued interest for Compound over the period
      uint256 cDaiInterest = (
        cDaiExchangeRate.mul(_SCALING_FACTOR).div(_cDaiExchangeRate)
      );

      // Take the lesser of the two and use it to adjust the dDai exchange rate
      dDaiExchangeRate = _dDaiExchangeRate.mul(
        defaultInterest > cDaiInterest ? cDaiInterest : defaultInterest
      ) / _SCALING_FACTOR;
    }
  }

  /**
   * @notice Internal, view-esque function to get the total surplus, or cDai
   * balance that exceeds the total dDai balance.
   * @return The total surplus.
   */
  function _getSurplus() internal /* view */ returns (uint256 cDaiSurplus) {
    // Determine the total value of all issued dDai in Dai, rounded up
    uint256 dDaiUnderlying = (
      _totalSupply.mul(_dDaiExchangeRate) / _SCALING_FACTOR
    ).add(1);

    // Compare to total underlying Dai value of all cDai held by this contract
    uint256 daiSurplus = (
      _CDAI.balanceOfUnderlying(address(this)).sub(dDaiUnderlying)
    );

    // Determine the cDai equivalent of this surplus amount
    cDaiSurplus = daiSurplus.mul(_SCALING_FACTOR_SQUARED).div(_cDaiExchangeRate);
  }

  /**
   * @notice View function to get the current dDai and cDai interest supply rate
   * per block (multiplied by 10^18).
   * @return The current dDai and cDai interest rates.
   */
  function _getRatePerBlock() internal view returns (
    uint256 dDaiSupplyRate, uint256 cDaiSupplyRate
  ) {
    cDaiSupplyRate = _CDAI.supplyRatePerBlock(); // NOTE: accrue on Compound first?
    dDaiSupplyRate = (
      _RATE_PER_BLOCK < cDaiSupplyRate ? _RATE_PER_BLOCK : cDaiSupplyRate
    );
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