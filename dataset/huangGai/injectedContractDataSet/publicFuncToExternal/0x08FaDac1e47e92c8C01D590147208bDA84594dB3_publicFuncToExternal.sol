/**
 *Submitted for verification at Etherscan.io on 2019-12-10
*/

pragma solidity 0.5.12;
pragma experimental ABIEncoderV2;
// File: @airswap/types/contracts/Types.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title Types: Library of Swap Protocol Types and Hashes
  */
library Types {
  bytes constant internal EIP191_HEADER = "\x19\x01";
  struct Order {
    uint256 nonce;                // Unique per order and should be sequential
    uint256 expiry;               // Expiry in seconds since 1 January 1970
    Party signer;                 // Party to the trade that sets terms
    Party sender;                 // Party to the trade that accepts terms
    Party affiliate;              // Party compensated for facilitating (optional)
    Signature signature;          // Signature of the order
  }
  struct Party {
    bytes4 kind;                  // Interface ID of the token
    address wallet;               // Wallet address of the party
    address token;                // Contract address of the token
    uint256 param;                // Value (ERC-20) or ID (ERC-721)
  }
  struct Signature {
    address signatory;            // Address of the wallet used to sign
    address validator;            // Address of the intended swap contract
    bytes1 version;               // EIP-191 signature version
    uint8 v;                      // `v` value of an ECDSA signature
    bytes32 r;                    // `r` value of an ECDSA signature
    bytes32 s;                    // `s` value of an ECDSA signature
  }
  bytes32 constant internal DOMAIN_TYPEHASH = keccak256(abi.encodePacked(
    "EIP712Domain(",
    "string name,",
    "string version,",
    "address verifyingContract",
    ")"
  ));
  bytes32 constant internal ORDER_TYPEHASH = keccak256(abi.encodePacked(
    "Order(",
    "uint256 nonce,",
    "uint256 expiry,",
    "Party signer,",
    "Party sender,",
    "Party affiliate",
    ")",
    "Party(",
    "bytes4 kind,",
    "address wallet,",
    "address token,",
    "uint256 param",
    ")"
  ));
  bytes32 constant internal PARTY_TYPEHASH = keccak256(abi.encodePacked(
    "Party(",
    "bytes4 kind,",
    "address wallet,",
    "address token,",
    "uint256 param",
    ")"
  ));
  /**
    * @notice Hash an order into bytes32
    * @dev EIP-191 header and domain separator included
    * @param order Order The order to be hashed
    * @param domainSeparator bytes32
    * @return bytes32 A keccak256 abi.encodePacked value
    */
  function hashOrder(
    Order calldata order,
    bytes32 domainSeparator
  ) external pure returns (bytes32) {
    return keccak256(abi.encodePacked(
      EIP191_HEADER,
      domainSeparator,
      keccak256(abi.encode(
        ORDER_TYPEHASH,
        order.nonce,
        order.expiry,
        keccak256(abi.encode(
          PARTY_TYPEHASH,
          order.signer.kind,
          order.signer.wallet,
          order.signer.token,
          order.signer.param
        )),
        keccak256(abi.encode(
          PARTY_TYPEHASH,
          order.sender.kind,
          order.sender.wallet,
          order.sender.token,
          order.sender.param
        )),
        keccak256(abi.encode(
          PARTY_TYPEHASH,
          order.affiliate.kind,
          order.affiliate.wallet,
          order.affiliate.token,
          order.affiliate.param
        ))
      ))
    ));
  }
  /**
    * @notice Hash domain parameters into bytes32
    * @dev Used for signature validation (EIP-712)
    * @param name bytes
    * @param version bytes
    * @param verifyingContract address
    * @return bytes32 returns a keccak256 abi.encodePacked value
    */
  function hashDomain(
    bytes calldata name,
    bytes calldata version,
    address verifyingContract
  ) external pure returns (bytes32) {
    return keccak256(abi.encode(
      DOMAIN_TYPEHASH,
      keccak256(name),
      keccak256(version),
      verifyingContract
    ));
  }
}
// File: @airswap/delegate/contracts/interfaces/IDelegate.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface IDelegate {
  struct Rule {
    uint256 maxSenderAmount;      // The maximum amount of ERC-20 token the delegate would send
    uint256 priceCoef;            // Number to be multiplied by 10^(-priceExp) - the price coefficient
    uint256 priceExp;             // Indicates location of the decimal priceCoef * 10^(-priceExp)
  }
  event SetRule(
    address indexed owner,
    address indexed senderToken,
    address indexed signerToken,
    uint256 maxSenderAmount,
    uint256 priceCoef,
    uint256 priceExp
  );
  event UnsetRule(
    address indexed owner,
    address indexed senderToken,
    address indexed signerToken
  );
  event ProvideOrder(
    address indexed owner,
    address tradeWallet,
    address indexed senderToken,
    address indexed signerToken,
    uint256 senderAmount,
    uint256 priceCoef,
    uint256 priceExp
  );
  function setRule(
    address senderToken,
    address signerToken,
    uint256 maxSenderAmount,
    uint256 priceCoef,
    uint256 priceExp
  ) external;
  function unsetRule(
    address senderToken,
    address signerToken
  ) external;
  function provideOrder(
    Types.Order calldata order
  ) external;
  function rules(address, address) external view returns (Rule memory);
  function getSignerSideQuote(
    uint256 senderParam,
    address senderToken,
    address signerToken
  ) external view returns (
    uint256 signerParam
  );
  function getSenderSideQuote(
    uint256 signerParam,
    address signerToken,
    address senderToken
  ) external view returns (
    uint256 senderParam
  );
  function getMaxQuote(
    address senderToken,
    address signerToken
  ) external view returns (
    uint256 senderParam,
    uint256 signerParam
  );
  function owner()
    external view returns (address);
  function tradeWallet()
    external view returns (address);
}
// File: @airswap/indexer/contracts/interfaces/IIndexer.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface IIndexer {
  event CreateIndex(
    address indexed signerToken,
    address indexed senderToken,
    address indexAddress
  );
  event Stake(
    address indexed staker,
    address indexed signerToken,
    address indexed senderToken,
    uint256 stakeAmount
  );
  event Unstake(
    address indexed staker,
    address indexed signerToken,
    address indexed senderToken,
    uint256 stakeAmount
  );
  event AddTokenToBlacklist(
    address token
  );
  event RemoveTokenFromBlacklist(
    address token
  );
  function setLocatorWhitelist(
    address newLocatorWhitelist
  ) external;
  function createIndex(
    address signerToken,
    address senderToken
  ) external returns (address);
  function addTokenToBlacklist(
    address token
  ) external;
  function removeTokenFromBlacklist(
    address token
  ) external;
  function setIntent(
    address signerToken,
    address senderToken,
    uint256 stakingAmount,
    bytes32 locator
  ) external;
  function unsetIntent(
    address signerToken,
    address senderToken
  ) external;
  function stakingToken() external view returns (address);
  function indexes(address, address) external view returns (address);
  function tokenBlacklist(address) external view returns (bool);
  function getStakedAmount(
    address user,
    address signerToken,
    address senderToken
  ) external view returns (uint256);
  function getLocators(
    address signerToken,
    address senderToken,
    address cursor,
    uint256 limit
  ) external view returns (
    bytes32[] memory,
    uint256[] memory,
    address
  );
}
// File: @airswap/swap/contracts/interfaces/ISwap.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface ISwap {
  event Swap(
    uint256 indexed nonce,
    uint256 timestamp,
    address indexed signerWallet,
    uint256 signerParam,
    address signerToken,
    address indexed senderWallet,
    uint256 senderParam,
    address senderToken,
    address affiliateWallet,
    uint256 affiliateParam,
    address affiliateToken
  );
  event Cancel(
    uint256 indexed nonce,
    address indexed signerWallet
  );
  event CancelUpTo(
    uint256 indexed nonce,
    address indexed signerWallet
  );
  event AuthorizeSender(
    address indexed authorizerAddress,
    address indexed authorizedSender
  );
  event AuthorizeSigner(
    address indexed authorizerAddress,
    address indexed authorizedSigner
  );
  event RevokeSender(
    address indexed authorizerAddress,
    address indexed revokedSender
  );
  event RevokeSigner(
    address indexed authorizerAddress,
    address indexed revokedSigner
  );
  /**
    * @notice Atomic Token Swap
    * @param order Types.Order
    */
  function swap(
    Types.Order calldata order
  ) external;
  /**
    * @notice Cancel one or more open orders by nonce
    * @param nonces uint256[]
    */
  function cancel(
    uint256[] calldata nonces
  ) external;
  /**
    * @notice Cancels all orders below a nonce value
    * @dev These orders can be made active by reducing the minimum nonce
    * @param minimumNonce uint256
    */
  function cancelUpTo(
    uint256 minimumNonce
  ) external;
  /**
    * @notice Authorize a delegated sender
    * @param authorizedSender address
    */
  function authorizeSender(
    address authorizedSender
  ) external;
  /**
    * @notice Authorize a delegated signer
    * @param authorizedSigner address
    */
  function authorizeSigner(
    address authorizedSigner
  ) external;
  /**
    * @notice Revoke an authorization
    * @param authorizedSender address
    */
  function revokeSender(
    address authorizedSender
  ) external;
  /**
    * @notice Revoke an authorization
    * @param authorizedSigner address
    */
  function revokeSigner(
    address authorizedSigner
  ) external;
  function senderAuthorizations(address, address) external view returns (bool);
  function signerAuthorizations(address, address) external view returns (bool);
  function signerNonceStatus(address, uint256) external view returns (byte);
  function signerMinimumNonce(address) external view returns (uint256);
}
// File: openzeppelin-solidity/contracts/ownership/Ownable.sol
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }
    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }
    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }
    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
// File: openzeppelin-solidity/contracts/math/SafeMath.sol
/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;
        return c;
    }
    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }
    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}
// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
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
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);
    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);
    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);
    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
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
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
// File: @airswap/delegate/contracts/Delegate.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title Delegate: Deployable Trading Rules for the Swap Protocol
  * @notice Supports fungible tokens (ERC-20)
  * @dev inherits IDelegate, Ownable uses SafeMath library
  */
contract Delegate is IDelegate, Ownable {
  using SafeMath for uint256;
  // The Swap contract to be used to settle trades
  ISwap public swapContract;
  // The Indexer to stake intent to trade on
  IIndexer public indexer;
  // Maximum integer for token transfer approval
  uint256 constant internal MAX_INT =  2**256 - 1;
  // Address holding tokens that will be trading through this delegate
  address public tradeWallet;
  // Mapping of senderToken to signerToken for rule lookup
  mapping (address => mapping (address => Rule)) public rules;
  // ERC-20 (fungible token) interface identifier (ERC-165)
  bytes4 constant internal ERC20_INTERFACE_ID = 0x36372b07;
  /**
    * @notice Contract Constructor
    * @dev owner defaults to msg.sender if delegateContractOwner is provided as address(0)
    * @param delegateSwap address Swap contract the delegate will deploy with
    * @param delegateIndexer address Indexer contract the delegate will deploy with
    * @param delegateContractOwner address Owner of the delegate
    * @param delegateTradeWallet address Wallet the delegate will trade from
    */
  constructor(
    ISwap delegateSwap,
    IIndexer delegateIndexer,
    address delegateContractOwner,
    address delegateTradeWallet
  ) public {
    swapContract = delegateSwap;
    indexer = delegateIndexer;
    // If no delegate owner is provided, the deploying address is the owner.
    if (delegateContractOwner != address(0)) {
      transferOwnership(delegateContractOwner);
    }
    // If no trade wallet is provided, the owner's wallet is the trade wallet.
    if (delegateTradeWallet != address(0)) {
      tradeWallet = delegateTradeWallet;
    } else {
      tradeWallet = owner();
    }
    // Ensure that the indexer can pull funds from delegate account.
    require(
      IERC20(indexer.stakingToken())
      .approve(address(indexer), MAX_INT), "STAKING_APPROVAL_FAILED"
    );
  }
  /**
    * @notice Set a Trading Rule
    * @dev only callable by the owner of the contract
    * @dev 1 senderToken = priceCoef * 10^(-priceExp) * signerToken
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @param maxSenderAmount uint256 Maximum amount of ERC-20 token the delegate would send
    * @param priceCoef uint256 Whole number that will be multiplied by 10^(-priceExp) - the price coefficient
    * @param priceExp uint256 Exponent of the price to indicate location of the decimal priceCoef * 10^(-priceExp)
    */
  function setRule(
    address senderToken,
    address signerToken,
    uint256 maxSenderAmount,
    uint256 priceCoef,
    uint256 priceExp
  ) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    _setRule(
      senderToken,
      signerToken,
      maxSenderAmount,
      priceCoef,
      priceExp
    );
  }
  /**
    * @notice Unset a Trading Rule
    * @dev only callable by the owner of the contract, removes from a mapping
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    */
  function unsetRule(
    address senderToken,
    address signerToken
  ) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    _unsetRule(
      senderToken,
      signerToken
    );
  }
  /**
    * @notice sets a rule on the delegate and an intent on the indexer
    * @dev only callable by owner
    * @dev delegate needs to be given allowance from msg.sender for the newStakeAmount
    * @dev swap needs to be given permission to move funds from the delegate
    * @param senderToken address Token the delgeate will send
    * @param signerToken address Token the delegate will receive
    * @param rule Rule Rule to set on a delegate
    * @param newStakeAmount uint256 Amount to stake for an intent
    */
  function setRuleAndIntent(
    address senderToken,
    address signerToken,
    Rule calldata rule,
    uint256 newStakeAmount
  ) external onlyOwner {
    _setRule(
      senderToken,
      signerToken,
      rule.maxSenderAmount,
      rule.priceCoef,
      rule.priceExp
    );
    // get currentAmount staked or 0 if never staked
    uint256 oldStakeAmount = indexer.getStakedAmount(address(this), signerToken, senderToken);
    if (oldStakeAmount == newStakeAmount && oldStakeAmount > 0) {
      return; // forgo trying to reset intent with non-zero same stake amount
    } else if (oldStakeAmount < newStakeAmount) {
      // transfer only the difference from the sender to the Delegate.
      require(
        IERC20(indexer.stakingToken())
        .transferFrom(msg.sender, address(this), newStakeAmount - oldStakeAmount), "STAKING_TRANSFER_FAILED"
      );
    }
    indexer.setIntent(
      signerToken,
      senderToken,
      newStakeAmount,
      bytes32(uint256(address(this)) << 96) //NOTE: this will pad 0's to the right
    );
    if (oldStakeAmount > newStakeAmount) {
      // return excess stake back
      require(
        IERC20(indexer.stakingToken())
        .transfer(msg.sender, oldStakeAmount - newStakeAmount), "STAKING_RETURN_FAILED"
      );
    }
  }
  /**
    * @notice unsets a rule on the delegate and removes an intent on the indexer
    * @dev only callable by owner
    * @param senderToken address Maker token in the token pair for rules and intents
    * @param signerToken address Taker token  in the token pair for rules and intents
    */
  function unsetRuleAndIntent(
    address senderToken,
    address signerToken
  ) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    _unsetRule(senderToken, signerToken);
    // Query the indexer for the amount staked.
    uint256 stakedAmount = indexer.getStakedAmount(address(this), signerToken, senderToken);
    indexer.unsetIntent(signerToken, senderToken);
    // Upon unstaking, the Delegate will be given the staking amount.
    // This is returned to the msg.sender.
    if (stakedAmount > 0) {
      require(
        IERC20(indexer.stakingToken())
          .transfer(msg.sender, stakedAmount),"STAKING_RETURN_FAILED"
      );
    }
  }
  /**
    * @notice Provide an Order
    * @dev Rules get reset with new maxSenderAmount
    * @param order Types.Order Order a user wants to submit to Swap.
    */
  function provideOrder(
    Types.Order calldata order
  ) external {
    Rule memory rule = rules[order.sender.token][order.signer.token];
    require(order.signature.v != 0,
      "SIGNATURE_MUST_BE_SENT");
    // Ensure the order is for the trade wallet.
    require(order.sender.wallet == tradeWallet,
      "INVALID_SENDER_WALLET");
    // Ensure the tokens are valid ERC20 tokens.
    require(order.signer.kind == ERC20_INTERFACE_ID,
      "SIGNER_KIND_MUST_BE_ERC20");
    require(order.sender.kind == ERC20_INTERFACE_ID,
      "SENDER_KIND_MUST_BE_ERC20");
    // Ensure that a rule exists.
    require(rule.maxSenderAmount != 0,
      "TOKEN_PAIR_INACTIVE");
    // Ensure the order does not exceed the maximum amount.
    require(order.sender.param <= rule.maxSenderAmount,
      "AMOUNT_EXCEEDS_MAX");
    // Ensure the order is priced according to the rule.
    require(order.sender.param <= _calculateSenderParam(order.signer.param, rule.priceCoef, rule.priceExp),
      "PRICE_INVALID");
    // Overwrite the rule with a decremented maxSenderAmount.
    rules[order.sender.token][order.signer.token] = Rule({
      maxSenderAmount: (rule.maxSenderAmount).sub(order.sender.param),
      priceCoef: rule.priceCoef,
      priceExp: rule.priceExp
    });
    // Perform the swap.
    swapContract.swap(order);
    emit ProvideOrder(
      owner(),
      tradeWallet,
      order.sender.token,
      order.signer.token,
      order.sender.param,
      rule.priceCoef,
      rule.priceExp
    );
  }
  /**
    * @notice Set a new trade wallet
    * @param newTradeWallet address Address of the new trade wallet
    */
  function setTradeWallet(address newTradeWallet) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    require(newTradeWallet != address(0), "TRADE_WALLET_REQUIRED");
    tradeWallet = newTradeWallet;
  }
  /**
    * @notice Get a Signer-Side Quote from the Delegate
    * @param senderParam uint256 Amount of ERC-20 token the delegate would send
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @return uint256 signerParam Amount of ERC-20 token the consumer would send
    */
  function getSignerSideQuote(
    uint256 senderParam,
    address senderToken,
    address signerToken
  ) public view returns (	//inject PUBLIC FUNC TO EXTERNAL
    uint256 signerParam
  ) {
    Rule memory rule = rules[senderToken][signerToken];
    // Ensure that a rule exists.
    if(rule.maxSenderAmount > 0) {
      // Ensure the senderParam does not exceed maximum for the rule.
      if(senderParam <= rule.maxSenderAmount) {
        signerParam = _calculateSignerParam(senderParam, rule.priceCoef, rule.priceExp);
        // Return the quote.
        return signerParam;
      }
    }
    return 0;
  }
  /**
    * @notice Get a Sender-Side Quote from the Delegate
    * @param signerParam uint256 Amount of ERC-20 token the consumer would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @return uint256 senderParam Amount of ERC-20 token the delegate would send
    */
  function getSenderSideQuote(
    uint256 signerParam,
    address signerToken,
    address senderToken
  ) public view returns (	//inject PUBLIC FUNC TO EXTERNAL
    uint256 senderParam
  ) {
    Rule memory rule = rules[senderToken][signerToken];
    // Ensure that a rule exists.
    if(rule.maxSenderAmount > 0) {
      // Calculate the senderParam.
      senderParam = _calculateSenderParam(signerParam, rule.priceCoef, rule.priceExp);
      // Ensure the senderParam does not exceed the maximum trade amount.
      if(senderParam <= rule.maxSenderAmount) {
        return senderParam;
      }
    }
    return 0;
  }
  /**
    * @notice Get a Maximum Quote from the Delegate
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @return uint256 senderParam Amount the delegate would send
    * @return uint256 signerParam Amount the consumer would send
    */
  function getMaxQuote(
    address senderToken,
    address signerToken
  ) public view returns (	//inject PUBLIC FUNC TO EXTERNAL
    uint256 senderParam,
    uint256 signerParam
  ) {
    Rule memory rule = rules[senderToken][signerToken];
    senderParam = rule.maxSenderAmount;
    // Ensure that a rule exists.
    if (senderParam > 0) {
      // calculate the signerParam
      signerParam = _calculateSignerParam(senderParam, rule.priceCoef, rule.priceExp);
      // Return the maxSenderAmount and calculated signerParam.
      return (
        senderParam,
        signerParam
      );
    }
    return (0, 0);
  }
  /**
    * @notice Set a Trading Rule
    * @dev only callable by the owner of the contract
    * @dev 1 senderToken = priceCoef * 10^(-priceExp) * signerToken
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @param maxSenderAmount uint256 Maximum amount of ERC-20 token the delegate would send
    * @param priceCoef uint256 Whole number that will be multiplied by 10^(-priceExp) - the price coefficient
    * @param priceExp uint256 Exponent of the price to indicate location of the decimal priceCoef * 10^(-priceExp)
    */
  function _setRule(
    address senderToken,
    address signerToken,
    uint256 maxSenderAmount,
    uint256 priceCoef,
    uint256 priceExp
  ) internal {
    require(priceCoef > 0, "INVALID_PRICE_COEF");
    rules[senderToken][signerToken] = Rule({
      maxSenderAmount: maxSenderAmount,
      priceCoef: priceCoef,
      priceExp: priceExp
    });
    emit SetRule(
      owner(),
      senderToken,
      signerToken,
      maxSenderAmount,
      priceCoef,
      priceExp
    );
  }
  /**
    * @notice Unset a Trading Rule
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    */
  function _unsetRule(
    address senderToken,
    address signerToken
  ) internal {
    // using non-zero rule.priceCoef for rule existence check
    if (rules[senderToken][signerToken].priceCoef > 0) {
      // Delete the rule.
      delete rules[senderToken][signerToken];
      emit UnsetRule(
        owner(),
        senderToken,
        signerToken
    );
    }
  }
  /**
    * @notice Calculate the signer param (amount) for a given sender param and price
    * @param senderParam uint256 The amount the delegate would send in the swap
    * @param priceCoef uint256 Coefficient of the token price defined in the rule
    * @param priceExp uint256 Exponent of the token price defined in the rule
    */
  function _calculateSignerParam(
    uint256 senderParam,
    uint256 priceCoef,
    uint256 priceExp
  ) internal pure returns (
    uint256 signerParam
  ) {
    // Calculate the param using the price formula
    uint256 multiplier = senderParam.mul(priceCoef);
    signerParam = multiplier.div(10 ** priceExp);
    // If the div rounded down, round up
    if (multiplier.mod(10 ** priceExp) > 0) {
      signerParam++;
    }
  }
  /**
    * @notice Calculate the sender param (amount) for a given signer param and price
    * @param signerParam uint256 The amount the signer would send in the swap
    * @param priceCoef uint256 Coefficient of the token price defined in the rule
    * @param priceExp uint256 Exponent of the token price defined in the rule
    */
  function _calculateSenderParam(
    uint256 signerParam,
    uint256 priceCoef,
    uint256 priceExp
  ) internal pure returns (
    uint256 senderParam
  ) {
    // Calculate the param using the price formula
    senderParam = signerParam
      .mul(10 ** priceExp)
      .div(priceCoef);
  }
}
// File: @airswap/indexer/contracts/interfaces/ILocatorWhitelist.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface ILocatorWhitelist {
  function has(
    bytes32 locator
  ) external view returns (bool);
}
// File: @airswap/delegate-factory/contracts/interfaces/IDelegateFactory.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface IDelegateFactory {
  event CreateDelegate(
    address indexed delegateContract,
    address swapContract,
    address indexerContract,
    address indexed delegateContractOwner,
    address delegateTradeWallet
  );
  /**
    * @notice Deploy a trusted delegate contract
    * @param delegateTradeWallet the wallet the delegate will trade from
    * @return delegateContractAddress address of the delegate contract created
    */
  function createDelegate(
    address delegateTradeWallet
  ) external returns (address delegateContractAddress);
}
// File: @airswap/delegate-factory/contracts/DelegateFactory.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
contract DelegateFactory is IDelegateFactory, ILocatorWhitelist {
  // Mapping specifying whether an address was deployed by this factory
  mapping(address => bool) internal _deployedAddresses;
  // The swap and indexer contracts to use in the deployment of Delegates
  ISwap public swapContract;
  IIndexer public indexerContract;
  /**
    * @notice Create a new Delegate contract
    * @dev swapContract is unable to be changed after the factory sets it
    * @param factorySwapContract address Swap contract the delegate will deploy with
    * @param factoryIndexerContract address Indexer contract the delegate will deploy with
    */
  constructor(ISwap factorySwapContract, IIndexer factoryIndexerContract) public {
    swapContract = factorySwapContract;
    indexerContract = factoryIndexerContract;
  }
  /**
    * @param delegateTradeWallet address Wallet the delegate will trade from
    * @return address delegateContractAddress Address of the delegate contract created
    */
  function createDelegate(
    address delegateTradeWallet
  ) public returns (address delegateContractAddress) {	//inject PUBLIC FUNC TO EXTERNAL
    delegateContractAddress = address(
      new Delegate(swapContract, indexerContract, msg.sender, delegateTradeWallet)
    );
    _deployedAddresses[delegateContractAddress] = true;
    emit CreateDelegate(
      delegateContractAddress,
      address(swapContract),
      address(indexerContract),
      msg.sender,
      delegateTradeWallet
    );
    return delegateContractAddress;
  }
  /**
    * @notice To check whether a locator was deployed
    * @dev Implements ILocatorWhitelist.has
    * @param locator bytes32 Locator of the delegate in question
    * @return bool True if the delegate was deployed by this contract
    */
  function has(bytes32 locator) public view returns (bool) {	//inject PUBLIC FUNC TO EXTERNAL
    return _deployedAddresses[address(bytes20(locator))];
  }
}
// File: @airswap/index/contracts/Index.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title Index: A List of Locators
  * @notice The Locators are sorted in reverse order based on the score
  * meaning that the first element in the list has the largest score
  * and final element has the smallest
  * @dev A mapping is used to mimic a circular linked list structure
  * where every mapping Entry contains a pointer to the next
  * and the previous
  */
contract Index is Ownable {
  // The number of entries in the index
  uint256 public length;
  // Identifier to use for the head of the list
  address constant internal HEAD = address(uint160(2**160-1));
  // Mapping of an identifier to its entry
  mapping(address => Entry) public entries;
  /**
    * @notice Index Entry
    * @param score uint256
    * @param locator bytes32
    * @param prev address Previous address in the linked list
    * @param next address Next address in the linked list
    */
  struct Entry {
    bytes32 locator;
    uint256 score;
    address prev;
    address next;
  }
  /**
    * @notice Contract Events
    */
  event SetLocator(
    address indexed identifier,
    uint256 score,
    bytes32 indexed locator
  );
  event UnsetLocator(
    address indexed identifier
  );
  /**
    * @notice Contract Constructor
    */
  constructor() public {
    // Create initial entry.
    entries[HEAD] = Entry(bytes32(0), 0, HEAD, HEAD);
  }
  /**
    * @notice Set a Locator
    * @param identifier address On-chain address identifying the owner of a locator
    * @param score uint256 Score for the locator being set
    * @param locator bytes32 Locator
    */
  function setLocator(
    address identifier,
    uint256 score,
    bytes32 locator
  ) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    // Disallow locator set to 0x0 to ensure list integrity.
    require(locator != bytes32(0), "LOCATOR_MUST_BE_SENT");
    // Ensure the entry does not already exist.
    require(!_hasEntry(identifier), "ENTRY_ALREADY_EXISTS");
    // Find the first entry with a lower score.
    address nextEntry = _getEntryLowerThan(score);
    // Link the new entry between previous and next.
    address prevEntry = entries[nextEntry].prev;
    entries[prevEntry].next = identifier;
    entries[nextEntry].prev = identifier;
    entries[identifier] = Entry(locator, score, prevEntry, nextEntry);
    // Increment the index length.
    length = length + 1;
    emit SetLocator(identifier, score, locator);
  }
  /**
    * @notice Unset a Locator
    * @param identifier address On-chain address identifying the owner of a locator
    */
  function unsetLocator(
    address identifier
  ) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    // Ensure the entry exists.
    require(_hasEntry(identifier), "ENTRY_DOES_NOT_EXIST");
    // Link the previous and next entries together.
    address prevUser = entries[identifier].prev;
    address nextUser = entries[identifier].next;
    entries[prevUser].next = nextUser;
    entries[nextUser].prev = prevUser;
    // Delete entry from the index.
    delete entries[identifier];
    // Decrement the index length.
    length = length - 1;
    emit UnsetLocator(identifier);
  }
  /**
    * @notice Get a Score
    * @param identifier address On-chain address identifying the owner of a locator
    * @return uint256 Score corresponding to the identifier
    */
  function getScore(
    address identifier
  ) public view returns (uint256) {	//inject PUBLIC FUNC TO EXTERNAL
    return entries[identifier].score;
  }
    /**
    * @notice Get a Locator
    * @param identifier address On-chain address identifying the owner of a locator
    * @return bytes32 Locator information
    */
  function getLocator(
    address identifier
  ) public view returns (bytes32) {	//inject PUBLIC FUNC TO EXTERNAL
    return entries[identifier].locator;
  }
  /**
    * @notice Get a Range of Locators
    * @dev start value of 0x0 starts at the head
    * @param cursor address Cursor to start with
    * @param limit uint256 Maximum number of locators to return
    * @return bytes32[] List of locators
    * @return uint256[] List of scores corresponding to locators
    * @return address The next cursor to provide for pagination
    */
  function getLocators(
    address cursor,
    uint256 limit
  ) public view returns (	//inject PUBLIC FUNC TO EXTERNAL
    bytes32[] memory locators,
    uint256[] memory scores,
    address nextCursor
  ) {
    address identifier;
    // If a valid cursor is provided, start there.
    if (cursor != address(0) && cursor != HEAD) {
      // Check that the provided cursor exists.
      if (!_hasEntry(cursor)) {
        return (new bytes32[](0), new uint256[](0), address(0));
      }
      // Set the starting identifier to the provided cursor.
      identifier = cursor;
    } else {
      identifier = entries[HEAD].next;
    }
    // Although it's not known how many entries are between `cursor` and the end
    // We know that it is no more than `length`
    uint256 size = (length < limit) ? length : limit;
    locators = new bytes32[](size);
    scores = new uint256[](size);
    // Iterate over the list until the end or size.
    uint256 i;
    while (i < size && identifier != HEAD) {
      locators[i] = entries[identifier].locator;
      scores[i] = entries[identifier].score;
      i = i + 1;
      identifier = entries[identifier].next;
    }
    return (locators, scores, identifier);
  }
  /**
    * @notice Check if the Index has an Entry
    * @param identifier address On-chain address identifying the owner of a locator
    * @return bool True if the identifier corresponds to an Entry in the list
    */
  function _hasEntry(
    address identifier
  ) internal view returns (bool) {
    return entries[identifier].locator != bytes32(0);
  }
  /**
    * @notice Returns the largest scoring Entry Lower than a Score
    * @param score uint256 Score in question
    * @return address Identifier of the largest score lower than score
    */
  function _getEntryLowerThan(
    uint256 score
  ) internal view returns (address) {
    address identifier = entries[HEAD].next;
    // Head indicates last because the list is circular.
    if (score == 0) {
      return HEAD;
    }
    // Iterate until a lower score is found.
    while (score <= entries[identifier].score) {
      identifier = entries[identifier].next;
    }
    return identifier;
  }
}
// File: @airswap/indexer/contracts/Indexer.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title Indexer: A Collection of Index contracts by Token Pair
  */
contract Indexer is IIndexer, Ownable {
  // Token to be used for staking (ERC-20)
  IERC20 public stakingToken;
  // Mapping of signer token to sender token to index
  mapping (address => mapping (address => Index)) public indexes;
  // Mapping of token address to boolean
  mapping (address => bool) public tokenBlacklist;
  // The whitelist contract for checking whether a peer is whitelisted
  address public locatorWhitelist;
  /**
    * @notice Contract Constructor
    * @param indexerStakingToken address
    */
  constructor(
    address indexerStakingToken
  ) public {
    stakingToken = IERC20(indexerStakingToken);
  }
  /**
    * @notice Modifier to check an index exists
    */
  modifier indexExists(address signerToken, address senderToken) {
    require(indexes[signerToken][senderToken] != Index(0),
      "INDEX_DOES_NOT_EXIST");
    _;
  }
  /**
    * @notice Set the address of an ILocatorWhitelist to use
    * @dev Allows removal of locatorWhitelist by passing 0x0
    * @param newLocatorWhitelist address Locator whitelist
    */
  function setLocatorWhitelist(
    address newLocatorWhitelist
  ) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    locatorWhitelist = newLocatorWhitelist;
  }
  /**
    * @notice Create an Index (List of Locators for a Token Pair)
    * @dev Deploys a new Index contract and stores the address. If the Index already
    * @dev exists, returns its address, and does not emit a CreateIndex event
    * @param signerToken address Signer token for the Index
    * @param senderToken address Sender token for the Index
    */
  function createIndex(
    address signerToken,
    address senderToken
  ) public returns (address) {	//inject PUBLIC FUNC TO EXTERNAL
    // If the Index does not exist, create it.
    if (indexes[signerToken][senderToken] == Index(0)) {
      // Create a new Index contract for the token pair.
      indexes[signerToken][senderToken] = new Index();
      emit CreateIndex(signerToken, senderToken, address(indexes[signerToken][senderToken]));
    }
    // Return the address of the Index contract.
    return address(indexes[signerToken][senderToken]);
  }
  /**
    * @notice Add a Token to the Blacklist
    * @param token address Token to blacklist
    */
  function addTokenToBlacklist(
    address token
  ) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    if (!tokenBlacklist[token]) {
      tokenBlacklist[token] = true;
      emit AddTokenToBlacklist(token);
    }
  }
  /**
    * @notice Remove a Token from the Blacklist
    * @param token address Token to remove from the blacklist
    */
  function removeTokenFromBlacklist(
    address token
  ) public onlyOwner {	//inject PUBLIC FUNC TO EXTERNAL
    if (tokenBlacklist[token]) {
      tokenBlacklist[token] = false;
      emit RemoveTokenFromBlacklist(token);
    }
  }
  /**
    * @notice Set an Intent to Trade
    * @dev Requires approval to transfer staking token for sender
    *
    * @param signerToken address Signer token of the Index being staked
    * @param senderToken address Sender token of the Index being staked
    * @param stakingAmount uint256 Amount being staked
    * @param locator bytes32 Locator of the staker
    */
  function setIntent(
    address signerToken,
    address senderToken,
    uint256 stakingAmount,
    bytes32 locator
  ) public indexExists(signerToken, senderToken) {	//inject PUBLIC FUNC TO EXTERNAL
    // If whitelist set, ensure the locator is valid.
    if (locatorWhitelist != address(0)) {
      require(ILocatorWhitelist(locatorWhitelist).has(locator),
      "LOCATOR_NOT_WHITELISTED");
    }
    // Ensure neither of the tokens are blacklisted.
    require(!tokenBlacklist[signerToken] && !tokenBlacklist[senderToken],
      "PAIR_IS_BLACKLISTED");
    bool notPreviouslySet = (indexes[signerToken][senderToken].getLocator(msg.sender) == bytes32(0));
    if (notPreviouslySet) {
      // Only transfer for staking if stakingAmount is set.
      if (stakingAmount > 0) {
        // Transfer the stakingAmount for staking.
        require(stakingToken.transferFrom(msg.sender, address(this), stakingAmount),
          "UNABLE_TO_STAKE");
      }
      // Set the locator on the index.
      indexes[signerToken][senderToken].setLocator(msg.sender, stakingAmount, locator);
      emit Stake(msg.sender, signerToken, senderToken, stakingAmount);
    } else {
      uint256 oldStake = indexes[signerToken][senderToken].getScore(msg.sender);
      _updateIntent(msg.sender, signerToken, senderToken, stakingAmount, locator, oldStake);
    }
  }
  /**
    * @notice Unset an Intent to Trade
    * @dev Users are allowed to unstake from blacklisted indexes
    *
    * @param signerToken address Signer token of the Index being unstaked
    * @param senderToken address Sender token of the Index being staked
    */
  function unsetIntent(
    address signerToken,
    address senderToken
  ) public {	//inject PUBLIC FUNC TO EXTERNAL
    _unsetIntent(msg.sender, signerToken, senderToken);
  }
  /**
    * @notice Get the locators of those trading a token pair
    * @dev Users are allowed to unstake from blacklisted indexes
    *
    * @param signerToken address Signer token of the trading pair
    * @param senderToken address Sender token of the trading pair
    * @param cursor address Address to start from
    * @param limit uint256 Total number of locators to return
    * @return bytes32[] List of locators
    * @return uint256[] List of scores corresponding to locators
    * @return address The next cursor to provide for pagination
    */
  function getLocators(
    address signerToken,
    address senderToken,
    address cursor,
    uint256 limit
  ) public view returns (	//inject PUBLIC FUNC TO EXTERNAL
    bytes32[] memory locators,
    uint256[] memory scores,
    address nextCursor
  ) {
    // Ensure neither token is blacklisted.
    if (tokenBlacklist[signerToken] || tokenBlacklist[senderToken]) {
      return (new bytes32[](0), new uint256[](0), address(0));
    }
    // Ensure the index exists.
    if (indexes[signerToken][senderToken] == Index(0)) {
      return (new bytes32[](0), new uint256[](0), address(0));
    }
    return indexes[signerToken][senderToken].getLocators(cursor, limit);
  }
  /**
    * @notice Gets the Stake Amount for a User
    * @param user address User who staked
    * @param signerToken address Signer token the user staked on
    * @param senderToken address Sender token the user staked on
    * @return uint256 Amount the user staked
    */
  function getStakedAmount(
    address user,
    address signerToken,
    address senderToken
  ) public view returns (uint256 stakedAmount) {
    if (indexes[signerToken][senderToken] == Index(0)) {
      return 0;
    }
    // Return the score, equivalent to the stake amount.
    return indexes[signerToken][senderToken].getScore(user);
  }
  function _updateIntent(
    address user,
    address signerToken,
    address senderToken,
    uint256 newAmount,
    bytes32 newLocator,
    uint256 oldAmount
  ) internal {
    // If the new stake is bigger, collect the difference.
    if (oldAmount < newAmount) {
      // Note: SafeMath not required due to the inequality check above
      require(stakingToken.transferFrom(user, address(this), newAmount - oldAmount),
        "UNABLE_TO_STAKE");
    }
    // If the old stake is bigger, return the excess.
    if (newAmount < oldAmount) {
      // Note: SafeMath not required due to the inequality check above
      require(stakingToken.transfer(user, oldAmount - newAmount));
    }
    // Unset their old intent, and set their new intent.
    indexes[signerToken][senderToken].unsetLocator(user);
    indexes[signerToken][senderToken].setLocator(user, newAmount, newLocator);
    emit Stake(user, signerToken, senderToken, newAmount);
  }
  /**
    * @notice Unset intents and return staked tokens
    * @param user address Address of the user who staked
    * @param signerToken address Signer token of the trading pair
    * @param senderToken address Sender token of the trading pair
    */
  function _unsetIntent(
    address user,
    address signerToken,
    address senderToken
  ) internal indexExists(signerToken, senderToken) {
     // Get the score for the user.
    uint256 score = indexes[signerToken][senderToken].getScore(user);
    // Unset the locator on the index.
    indexes[signerToken][senderToken].unsetLocator(user);
    if (score > 0) {
      // Return the staked tokens. Reverts on failure.
      require(stakingToken.transfer(user, score));
    }
    emit Unstake(user, signerToken, senderToken, score);
  }
}
// File: @airswap/tokens/contracts/interfaces/INRERC20.sol
/**
 * @notice Interface for non-returning ERC20 contract
 * @dev Modified Interface of the ERC20 standard that does not return bool
 * for transfer and transferFrom functions
 */
interface INRERC20 {
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
     * Doesn't returns a boolean value.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external;
    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);
    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);
    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Doesn't return a boolean value.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external;
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);
    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
// File: openzeppelin-solidity/contracts/introspection/IERC165.sol
/**
 * @dev Interface of the ERC165 standard, as defined in the
 * [EIP](https://eips.ethereum.org/EIPS/eip-165).
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others (`ERC165Checker`).
 *
 * For an implementation, see `ERC165`.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
// File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
/**
 * @dev Required interface of an ERC721 compliant contract.
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) public view returns (uint256 balance);
    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address owner);
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * 
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either `approve` or `setApproveForAll`.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either `approve` or `setApproveForAll`.
     */
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);
    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}
// File: @airswap/swap/contracts/Swap.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title Swap: The Atomic Swap used by the Swap Protocol
  */
contract Swap is ISwap {
  using SafeMath for uint256;
  // Domain and version for use in signatures (EIP-712)
  bytes constant internal DOMAIN_NAME = "SWAP";
  bytes constant internal DOMAIN_VERSION = "2";
  // Unique domain identifier for use in signatures (EIP-712)
  bytes32 private _domainSeparator;
  // Possible nonce statuses
  byte constant internal AVAILABLE = 0x00;
  byte constant internal UNAVAILABLE = 0x01;
  // ERC-721 (non-fungible token) interface identifier (EIP-165)
  bytes4 constant internal ERC721_INTERFACE_ID = 0x80ac58cd;
  // Mapping of sender address to a delegated sender address and bool
  mapping (address => mapping (address => bool)) public senderAuthorizations;
  // Mapping of signer address to a delegated signer and bool
  mapping (address => mapping (address => bool)) public signerAuthorizations;
  // Mapping of signers to nonces with value AVAILABLE (0x00) or UNAVAILABLE (0x01)
  mapping (address => mapping (uint256 => byte)) public signerNonceStatus;
  // Mapping of signer addresses to an optionally set minimum valid nonce
  mapping (address => uint256) public signerMinimumNonce;
  /**
    * @notice Contract Constructor
    * @dev Sets domain for signature validation (EIP-712)
    */
  constructor() public {
    _domainSeparator = Types.hashDomain(
      DOMAIN_NAME,
      DOMAIN_VERSION,
      address(this)
    );
  }
  /**
    * @notice Atomic Token Swap
    * @param order Types.Order Order to settle
    */
  function swap(
    Types.Order calldata order
  ) external {
    // Ensure the order is not expired.
    require(order.expiry > block.timestamp,
      "ORDER_EXPIRED");
    // Ensure the nonce is AVAILABLE (0x00).
    require(signerNonceStatus[order.signer.wallet][order.nonce] == AVAILABLE,
      "ORDER_TAKEN_OR_CANCELLED");
    // Ensure the order nonce is above the minimum.
    require(order.nonce >= signerMinimumNonce[order.signer.wallet],
      "NONCE_TOO_LOW");
    // Mark the nonce UNAVAILABLE (0x01).
    signerNonceStatus[order.signer.wallet][order.nonce] = UNAVAILABLE;
    // Validate the sender side of the trade.
    address finalSenderWallet;
    if (order.sender.wallet == address(0)) {
      /**
        * Sender is not specified. The msg.sender of the transaction becomes
        * the sender of the order.
        */
      finalSenderWallet = msg.sender;
    } else {
      /**
        * Sender is specified. If the msg.sender is not the specified sender,
        * this determines whether the msg.sender is an authorized sender.
        */
      require(isSenderAuthorized(order.sender.wallet, msg.sender),
          "SENDER_UNAUTHORIZED");
      // The msg.sender is authorized.
      finalSenderWallet = order.sender.wallet;
    }
    // Validate the signer side of the trade.
    if (order.signature.v == 0) {
      /**
        * Signature is not provided. The signer may have authorized the
        * msg.sender to swap on its behalf, which does not require a signature.
        */
      require(isSignerAuthorized(order.signer.wallet, msg.sender),
        "SIGNER_UNAUTHORIZED");
    } else {
      /**
        * The signature is provided. Determine whether the signer is
        * authorized and if so validate the signature itself.
        */
      require(isSignerAuthorized(order.signer.wallet, order.signature.signatory),
        "SIGNER_UNAUTHORIZED");
      // Ensure the signature is valid.
      require(isValid(order, _domainSeparator),
        "SIGNATURE_INVALID");
    }
    // Transfer token from sender to signer.
    transferToken(
      finalSenderWallet,
      order.signer.wallet,
      order.sender.param,
      order.sender.token,
      order.sender.kind
    );
    // Transfer token from signer to sender.
    transferToken(
      order.signer.wallet,
      finalSenderWallet,
      order.signer.param,
      order.signer.token,
      order.signer.kind
    );
    // Transfer token from signer to affiliate if specified.
    if (order.affiliate.wallet != address(0)) {
      transferToken(
        order.signer.wallet,
        order.affiliate.wallet,
        order.affiliate.param,
        order.affiliate.token,
        order.affiliate.kind
      );
    }
    emit Swap(order.nonce, block.timestamp,
      order.signer.wallet, order.signer.param, order.signer.token,
      finalSenderWallet, order.sender.param, order.sender.token,
      order.affiliate.wallet, order.affiliate.param, order.affiliate.token
    );
  }
  /**
    * @notice Cancel one or more open orders by nonce
    * @dev Cancelled nonces are marked UNAVAILABLE (0x01)
    * @dev Emits a Cancel event
    * @dev Out of gas may occur in arrays of length > 400
    * @param nonces uint256[] List of nonces to cancel
    */
  function cancel(
    uint256[] calldata nonces
  ) external {
    for (uint256 i = 0; i < nonces.length; i++) {
      if (signerNonceStatus[msg.sender][nonces[i]] == AVAILABLE) {
        signerNonceStatus[msg.sender][nonces[i]] = UNAVAILABLE;
        emit Cancel(nonces[i], msg.sender);
      }
    }
  }
  /**
    * @notice Cancels all orders below a nonce value
    * @dev Emits a CancelUpTo event
    * @param minimumNonce uint256 Minimum valid nonce
    */
  function cancelUpTo(
    uint256 minimumNonce
  ) public {	//inject PUBLIC FUNC TO EXTERNAL
    signerMinimumNonce[msg.sender] = minimumNonce;
    emit CancelUpTo(minimumNonce, msg.sender);
  }
  /**
    * @notice Authorize a delegated sender
    * @dev Emits an AuthorizeSender event
    * @param authorizedSender address Address to authorize
    */
  function authorizeSender(
    address authorizedSender
  ) public {	//inject PUBLIC FUNC TO EXTERNAL
    require(msg.sender != authorizedSender, "INVALID_AUTH_SENDER");
    if (!senderAuthorizations[msg.sender][authorizedSender]) {
      senderAuthorizations[msg.sender][authorizedSender] = true;
      emit AuthorizeSender(msg.sender, authorizedSender);
    }
  }
  /**
    * @notice Authorize a delegated signer
    * @dev Emits an AuthorizeSigner event
    * @param authorizedSigner address Address to authorize
    */
  function authorizeSigner(
    address authorizedSigner
  ) public {	//inject PUBLIC FUNC TO EXTERNAL
    require(msg.sender != authorizedSigner, "INVALID_AUTH_SIGNER");
    if (!signerAuthorizations[msg.sender][authorizedSigner]) {
      signerAuthorizations[msg.sender][authorizedSigner] = true;
      emit AuthorizeSigner(msg.sender, authorizedSigner);
    }
  }
  /**
    * @notice Revoke an authorized sender
    * @dev Emits a RevokeSender event
    * @param authorizedSender address Address to revoke
    */
  function revokeSender(
    address authorizedSender
  ) public {	//inject PUBLIC FUNC TO EXTERNAL
    if (senderAuthorizations[msg.sender][authorizedSender]) {
      delete senderAuthorizations[msg.sender][authorizedSender];
      emit RevokeSender(msg.sender, authorizedSender);
    }
  }
  /**
    * @notice Revoke an authorized signer
    * @dev Emits a RevokeSigner event
    * @param authorizedSigner address Address to revoke
    */
  function revokeSigner(
    address authorizedSigner
  ) public {	//inject PUBLIC FUNC TO EXTERNAL
    if (signerAuthorizations[msg.sender][authorizedSigner]) {
      delete signerAuthorizations[msg.sender][authorizedSigner];
      emit RevokeSigner(msg.sender, authorizedSigner);
    }
  }
  /**
    * @notice Determine whether a sender delegate is authorized
    * @param authorizer address Address doing the authorization
    * @param delegate address Address being authorized
    * @return bool True if a delegate is authorized to send
    */
  function isSenderAuthorized(
    address authorizer,
    address delegate
  ) internal view returns (bool) {
    return ((authorizer == delegate) ||
      senderAuthorizations[authorizer][delegate]);
  }
  /**
    * @notice Determine whether a signer delegate is authorized
    * @param authorizer address Address doing the authorization
    * @param delegate address Address being authorized
    * @return bool True if a delegate is authorized to sign
    */
  function isSignerAuthorized(
    address authorizer,
    address delegate
  ) internal view returns (bool) {
    return ((authorizer == delegate) ||
      signerAuthorizations[authorizer][delegate]);
  }
  /**
    * @notice Validate signature using an EIP-712 typed data hash
    * @param order Types.Order Order to validate
    * @param domainSeparator bytes32 Domain identifier used in signatures (EIP-712)
    * @return bool True if order has a valid signature
    */
  function isValid(
    Types.Order memory order,
    bytes32 domainSeparator
  ) internal pure returns (bool) {
    if (order.signature.version == byte(0x01)) {
      return order.signature.signatory == ecrecover(
        Types.hashOrder(
          order,
          domainSeparator
        ),
        order.signature.v,
        order.signature.r,
        order.signature.s
      );
    }
    if (order.signature.version == byte(0x45)) {
      return order.signature.signatory == ecrecover(
        keccak256(
          abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            Types.hashOrder(order, domainSeparator)
          )
        ),
        order.signature.v,
        order.signature.r,
        order.signature.s
      );
    }
    return false;
  }
  /**
    * @notice Perform an ERC-20 or ERC-721 token transfer
    * @dev Transfer type specified by the bytes4 kind param
    * @dev ERC721: uses transferFrom for transfer
    * @dev ERC20: Takes into account non-standard ERC-20 tokens.
    * @param from address Wallet address to transfer from
    * @param to address Wallet address to transfer to
    * @param param uint256 Amount for ERC-20 or token ID for ERC-721
    * @param token address Contract address of token
    * @param kind bytes4 EIP-165 interface ID of the token
    */
  function transferToken(
      address from,
      address to,
      uint256 param,
      address token,
      bytes4 kind
  ) internal {
    // Ensure the transfer is not to self.
    require(from != to, "INVALID_SELF_TRANSFER");
    if (kind == ERC721_INTERFACE_ID) {
      // Attempt to transfer an ERC-721 token.
      IERC721(token).transferFrom(from, to, param);
    } else {
      uint256 initialBalance = INRERC20(token).balanceOf(from);
      // Attempt to transfer an ERC-20 token.
      INRERC20(token).transferFrom(from, to, param);
      // Ensure the amount has been transferred.
      require(initialBalance.sub(param) == INRERC20(token).balanceOf(from), "TRANSFER_FAILED");
    }
  }
}
// File: @airswap/tokens/contracts/interfaces/IWETH.sol
interface IWETH {
  function deposit() external payable;
  function withdraw(uint256) external;
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}
// File: @airswap/wrapper/contracts/Wrapper.sol
/*
  Copyright 2019 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title Wrapper: Send and receive ether for WETH trades
  */
contract Wrapper {
  // The Swap contract to settle trades
  ISwap public swapContract;
  // The WETH contract to wrap ether
  IWETH public wethContract;
  /**
    * @notice Contract Constructor
    * @param wrapperSwapContract address
    * @param wrapperWethContract address
    */
  constructor(
    address wrapperSwapContract,
    address wrapperWethContract
  ) public {
    swapContract = ISwap(wrapperSwapContract);
    wethContract = IWETH(wrapperWethContract);
  }
  /**
    * @notice Required when withdrawing from WETH
    * @dev During unwraps, WETH.withdraw transfers ether to msg.sender (this contract)
    */
  function() external payable {
    // Ensure the message sender is the WETH contract.
    if(msg.sender != address(wethContract)) {
      revert("DO_NOT_SEND_ETHER");
    }
  }
  /**
    * @notice Send an Order to be forwarded to Swap
    * @dev Sender must authorize this contract on the swapContract
    * @dev Sender must approve this contract on the wethContract
    * @param order Types.Order The Order
    */
  function swap(
    Types.Order calldata order
  ) external payable {
    // Ensure msg.sender is sender wallet.
    require(order.sender.wallet == msg.sender,
      "MSG_SENDER_MUST_BE_ORDER_SENDER");
    // Ensure that the signature is present.
    // The signature will be explicitly checked in Swap.
    require(order.signature.v != 0,
      "SIGNATURE_MUST_BE_SENT");
    // Wraps ETH to WETH when the sender provides ETH and the order is WETH
    _wrapEther(order.sender);
    // Perform the swap.
    swapContract.swap(order);
    // Unwraps WETH to ETH when the sender receives WETH
    _unwrapEther(order.sender.wallet, order.signer.token, order.signer.param);
  }
  /**
    * @notice Send an Order to be forwarded to a Delegate
    * @dev Sender must authorize the Delegate contract on the swapContract
    * @dev Sender must approve this contract on the wethContract
    * @dev Delegate's tradeWallet must be order.sender - checked in Delegate
    * @param order Types.Order The Order
    * @param delegate IDelegate The Delegate to provide the order to
    */
  function provideDelegateOrder(
    Types.Order calldata order,
    IDelegate delegate
  ) external payable {
    // Ensure that the signature is present.
    // The signature will be explicitly checked in Swap.
    require(order.signature.v != 0,
      "SIGNATURE_MUST_BE_SENT");
    // Wraps ETH to WETH when the signer provides ETH and the order is WETH
    _wrapEther(order.signer);
    // Provide the order to the Delegate.
    delegate.provideOrder(order);
    // Unwraps WETH to ETH when the signer receives WETH
    _unwrapEther(order.signer.wallet, order.sender.token, order.sender.param);
  }
  /**
    * @notice Wraps ETH to WETH when a trade requires it
    * @param party Types.Party The side of the trade that may need wrapping
    */
  function _wrapEther(Types.Party memory party) internal {
    // Check whether ether needs wrapping
    if (party.token == address(wethContract)) {
      // Ensure message value is param.
      require(party.param == msg.value,
        "VALUE_MUST_BE_SENT");
      // Wrap (deposit) the ether.
      wethContract.deposit.value(msg.value)();
      // Transfer the WETH from the wrapper to party.
      // Return value not checked - WETH throws on error and does not return false
      wethContract.transfer(party.wallet, party.param);
    } else {
      // Ensure no unexpected ether is sent.
      require(msg.value == 0,
        "VALUE_MUST_BE_ZERO");
    }
  }
  /**
    * @notice Unwraps WETH to ETH when a trade requires it
    * @dev The unwrapping only succeeds if recipientWallet has approved transferFrom
    * @param recipientWallet address The trade recipient, who may have received WETH
    * @param receivingToken address The token address the recipient received
    * @param amount uint256 The amount of token the recipient received
    */
  function _unwrapEther(address recipientWallet, address receivingToken, uint256 amount) internal {
    // Check whether ether needs unwrapping
    if (receivingToken == address(wethContract)) {
      // Transfer weth from the recipient to the wrapper.
      wethContract.transferFrom(recipientWallet, address(this), amount);
      // Unwrap (withdraw) the ether.
      wethContract.withdraw(amount);
      // Transfer ether to the recipient.
      // solium-disable-next-line security/no-call-value
      (bool success, ) = recipientWallet.call.value(amount)("");
      require(success, "ETH_RETURN_FAILED");
    }
  }
}
// File: contracts/Imports.sol
//Import all the contracts desired to be deployed
contract Imports {}