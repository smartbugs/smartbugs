/**
 *Submitted for verification at Etherscan.io on 2020-03-03
*/

pragma solidity 0.5.16;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @dev Locks ERC20 tokens for a specific period
 */
contract BlockbirdLock {

  /**
   * ERC20 contract for which we can lock tokens.
   */
  IERC20 lockContract;

  /**
   * @dev Structure that holds information about locked tokens.
   */
  struct Lock {
    uint256 amount;
    uint256 duration;
  }

  /**
   * @dev Mapping of locked tokens.
   */
  mapping(address => Lock) internal lockedTokens;

  /**
   * @dev Sets contract for which we can lock tokens.
   * @param lockContractAddress Address of ERC20 token.
   */
  constructor(address lockContractAddress) public {
    lockContract = IERC20(lockContractAddress);
  }

  /**
   * @dev Locks token for a specified period.
   * @param recipient Address that will be able to withdraw tokens after specified time.
   * @param amount Amount of tokens we are locking up.
   * @param duration Duration for which the tokens will be locked.
   */
  function lock(
    address recipient,
    uint256 amount,
    uint256 duration
  )
    external
  {
    require(lockedTokens[recipient].amount == 0, 'BlockbirdLock: Tokens for this recipent already locked.');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    lockedTokens[recipient] = Lock({ amount: amount, duration: duration });	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    lockContract.transferFrom(msg.sender, address(this), amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  /**
   * @dev Withdraw locked tokens.s
   */
  function withdraw()
    external
  {
    require(lockedTokens[msg.sender].duration < now, 'BlockbirdLock: Lock time has not yet passed.');	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    uint256 amount = lockedTokens[msg.sender].amount;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    delete lockedTokens[msg.sender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    lockContract.transfer(msg.sender, amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

}