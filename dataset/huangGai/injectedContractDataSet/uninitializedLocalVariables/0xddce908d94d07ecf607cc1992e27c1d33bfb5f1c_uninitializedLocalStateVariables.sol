/**
 *Submitted for verification at Etherscan.io on 2020-01-13
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
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a, "SafeMath: subtraction overflow");
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR


    return c;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0, "SafeMath: division by zero");
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR


    return c;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0, "SafeMath: modulo by zero");
    return a % b;
  }
}


/**
 * @title DharmaUSDCPrototype0
 * @author 0age (dToken mechanics derived from Compound cTokens, ERC20 methods
 * derived from OpenZeppelin's ERC20 contract)
 * @notice Initial prototype for a cUSDC wrapper token. This version is not
 * upgradeable, and serves as an initial test of the eventual dUSDC mechanics.
 * The dUSDC exchange rate will grow at an approximate APR of 4% or at the cUSDC
 * exchange rate, whichever is greater.
 */
contract DharmaUSDCPrototype0 is ERC20Interface, DTokenInterface {
  using SafeMath for uint256;

  uint256 internal constant _DHARMA_USDC_VERSION = 0;

  // Note: this is a constant for the proof-of-concept but will be configurable.
  // 4% APR interest assuming 15 second block time & 2,102,400 blocks per year
  uint256 internal constant _RATE_PER_BLOCK = 1000000019025875275;

  string internal constant _NAME = "Dharma USD Coin (Prototype 0)";
  string internal constant _SYMBOL = "dUSDC-p0";
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
   * @param usdcToSupply uint256 The amount of usdc to provide as part of minting.
   * @return The amount of dUSDC received in return for the supplied USDC.
   */
  function mint(
    uint256 usdcToSupply
  ) external accrues returns (uint256 dUSDCMinted) {
    // Determine the dUSDC to mint using the exchange rate
    dUSDCMinted = usdcToSupply.mul(_SCALING_FACTOR).div(_dUSDCExchangeRate);

    // Pull in USDC (requires that this contract has sufficient allowance)
    require(
      _USDC.transferFrom(msg.sender, address(this), usdcToSupply),
      "USDC transfer failed."
    );

    // Use the USDC to mint cUSDC (TODO: include error code in revert reason)
    require(_CUSDC.mint(usdcToSupply) == _COMPOUND_SUCCESS, "cUSDC mint failed.");

    // Mint dUSDC to the caller
    _mint(msg.sender, usdcToSupply, dUSDCMinted);
  }

  /**
   * @notice Redeem `dUSDCToBurn` dUSDC from `msg.sender`, use the corresponding
   * cUSDC to redeem USDC, and transfer the USDC to `msg.sender`.
   * @param dUSDCToBurn uint256 The amount of dUSDC to provide for USDC.
   * @return The amount of usdc received in return for the provided cUSDC.
   */
  function redeem(
    uint256 dUSDCToBurn
  ) external accrues returns (uint256 usdcReceived) {
    // Determine the underlying USDC value of the dUSDC to be burned
    usdcReceived = dUSDCToBurn.mul(_dUSDCExchangeRate) / _SCALING_FACTOR;

    // Burn the dUSDC
    _burn(msg.sender, usdcReceived, dUSDCToBurn);

    // Use the cUSDC to redeem USDC  (TODO: include error code in revert reason)
    require(
      _CUSDC.redeemUnderlying(usdcReceived) == _COMPOUND_SUCCESS,
      "cUSDC redeem failed."
    );

    // Send the USDC to the redeemer
    require(_USDC.transfer(msg.sender, usdcReceived), "USDC transfer failed.");
  }

  /**
   * @notice Redeem the dUSDC equivalent value of USDC amount `usdcToReceive` from
   * `msg.sender`, use the corresponding cUSDC to redeem USDC, and transfer the
   * USDC to `msg.sender`.
   * @param usdcToReceive uint256 The amount, denominated in USDC, of the cUSDC to
   * provide for USDC.
   * @return The amount of USDC received in return for the provided cUSDC.
   */
  function redeemUnderlying(
    uint256 usdcToReceive
  ) external accrues returns (uint256 dUSDCBurned) {
    // Determine the dUSDC to redeem using the exchange rate
    dUSDCBurned = usdcToReceive.mul(_SCALING_FACTOR).div(_dUSDCExchangeRate);

    // Burn the dUSDC
    _burn(msg.sender, usdcToReceive, dUSDCBurned);

    // Use the cUSDC to redeem USDC  (TODO: include error code in revert reason)
    require(
      _CUSDC.redeemUnderlying(usdcToReceive) == _COMPOUND_SUCCESS,
      "cUSDC redeem failed."
    );

    // Send the USDC to the redeemer
    require(_USDC.transfer(msg.sender, usdcToReceive), "USDC transfer failed.");
  }

  /**
   * @notice Transfer cUSDC in excess of the total dUSDC balance to a dedicated
   * "vault" account.
   * @return The amount of cUSDC transferred to the vault account.
   */
  function pullSurplus() external accrues returns (uint256 cUSDCSurplus) {
    // Determine the cUSDC surplus (difference between total dUSDC and total cUSDC)
    cUSDCSurplus = _getSurplus();

    // Send the cUSDC surplus to the vault
    require(_CUSDC.transfer(_VAULT, cUSDCSurplus), "cUSDC transfer failed.");
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
    uint256 allowance ;	//inject UNINIT LOCAL/STATE VAR

    if (allowance != uint256(-1)) {
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
   * @notice View function to get the dUSDC balance of an account, denominated in
   * its USDC equivalent value.
   * @param account address The account to check the balance for.
   * @return The total USDC-equivalent cUSDC balance.
   */
  function balanceOfUnderlying(
    address account
  ) external returns (uint256 usdcBalance) {
    // Get most recent dUSDC exchange rate by determining accrued interest
    (uint256 dUSDCExchangeRate,,) = _getAccruedInterest();

    // Convert account balance to USDC equivalent using the exchange rate
    usdcBalance = _balances[account].mul(dUSDCExchangeRate) / _SCALING_FACTOR;
  }

  /**
   * @notice View function to get the total surplus, or cUSDC balance that
   * exceeds the total dUSDC balance.
   * @return The total surplus.
   */
  function getSurplus() external accrues returns (uint256 cUSDCSurplus) {
    // Determine the cUSDC surplus (difference between total dUSDC and total cUSDC)
    cUSDCSurplus = _getSurplus();
  }

  /**
   * @notice View function to get the current dUSDC exchange rate (multiplied by
   * 10^18).
   * @return The current exchange rate.
   */
  function exchangeRateCurrent() external returns (uint256 dUSDCExchangeRate) {
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
   * @notice View function to get the total dUSDC balance of an account.
   * @param account address The account to check the dUSDC balance for.
   * @return The balance of the given account.
   */
  function balanceOf(address account) external view returns (uint256 dUSDC) {
    dUSDC = _balances[account];
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
    uint256 balancePriorToBurn ;	//inject UNINIT LOCAL/STATE VAR

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
   * @notice Internal, view-esque function to get the latest dUSDC and cUSDC
   * exchange rates for USDC and update the record of each in the event that they
   * have not already been updated in the given block.
   * @return The dUSDC and cUSDC exchange rate, as well as a boolean indicating if
   * interest accrual has been processed already or needs to be calculated and
   * placed in storage.
   */
  function _getAccruedInterest() internal /* view */ returns (
    uint256 dUSDCExchangeRate, uint256 cUSDCExchangeRate, bool fullyAccrued
  ) {
    // Get the number of blocks since the last time interest was accrued
    uint256 blocksToAccrueInterest ;	//inject UNINIT LOCAL/STATE VAR

    fullyAccrued = (blocksToAccrueInterest == 0);

    // Skip calculation and read from storage if interest was accrued this block
    if (fullyAccrued) {
      dUSDCExchangeRate = _dUSDCExchangeRate;
      cUSDCExchangeRate = _cUSDCExchangeRate;
    } else {
      // Calculate the accrued interest over the period
      uint256 defaultInterest ;	//inject UNINIT LOCAL/STATE VAR


      // Retrieve the latest exchange rate for cUSDC
      cUSDCExchangeRate = _CUSDC.exchangeRateCurrent();

      // Calculate the accrued interest for Compound over the period
      uint256 cUSDCInterest ;	//inject UNINIT LOCAL/STATE VAR


      // Take the lesser of the two and use it to adjust the dUSDC exchange rate
      dUSDCExchangeRate = _dUSDCExchangeRate.mul(
        defaultInterest > cUSDCInterest ? cUSDCInterest : defaultInterest
      ) / _SCALING_FACTOR;
    }
  }

  /**
   * @notice Internal, view-esque function to get the total surplus, or cUSDC
   * balance that exceeds the total dUSDC balance.
   * @return The total surplus.
   */
  function _getSurplus() internal /* view */ returns (uint256 cUSDCSurplus) {
    // Determine the total value of all issued dUSDC in USDC, rounded up
    uint256 dUSDCUnderlying ;	//inject UNINIT LOCAL/STATE VAR


    // Compare to total underlying USDC value of all cUSDC held by this contract
    uint256 usdcSurplus ;	//inject UNINIT LOCAL/STATE VAR


    // Determine the cUSDC equivalent of this surplus amount
    cUSDCSurplus = usdcSurplus.mul(_SCALING_FACTOR).div(_cUSDCExchangeRate);
  }

  /**
   * @notice View function to get the current dUSDC and cUSDC interest supply rate
   * per block (multiplied by 10^18).
   * @return The current dUSDC and cUSDC interest rates.
   */
  function _getRatePerBlock() internal view returns (
    uint256 dUSDCSupplyRate, uint256 cUSDCSupplyRate
  ) {
    uint256 defaultSupplyRate ;	//inject UNINIT LOCAL/STATE VAR

    cUSDCSupplyRate = _CUSDC.supplyRatePerBlock(); // NOTE: accrue on Compound first?
    dUSDCSupplyRate = (
      defaultSupplyRate < cUSDCSupplyRate ? defaultSupplyRate : cUSDCSupplyRate
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