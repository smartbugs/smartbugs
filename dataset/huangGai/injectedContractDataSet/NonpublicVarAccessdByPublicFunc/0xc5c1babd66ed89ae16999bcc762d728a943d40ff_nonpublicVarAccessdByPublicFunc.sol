/**
 *Submitted for verification at Etherscan.io on 2020-07-18
*/

// File: contracts/loopring/impl/BrokerData.sol

pragma solidity ^0.5.7;

library BrokerData {

  struct BrokerOrder {
    address owner;
    bytes32 orderHash;
    uint fillAmountB;
    uint requestedAmountS;
    uint requestedFeeAmount;
    address tokenRecipient;
    bytes extraData;
  }

  /**
   * The request wraps all broker orders that share the following overall fields. The perspective on these fields is
   * the orders that are passed in. Meaning, `tokenB` is the token being RECEIVED by each owner and `tokenS` is the
   * token being SPENT by each owner. Lastly, `totalRequestedFeeAmount` is the total `feeAmountS` for all brokered
   * orders. If the fees are in `tokenB`, then this amount is always 0.
   */
  struct BrokerApprovalRequest {
    BrokerOrder[] orders;
    // The token output token for the broker at the end of #brokerRequestAllowance.
    address tokenS;
    // The token received by the broker at the start of #brokerRequestAllowance. This token must be internally traded
    // for tokenS.
    address tokenB;
    address feeToken;
    // The amount of tokens that the broker has at the start of the call to #brokerRequestAllowance. This amount needs
    // to be traded within the brokering contract for #totalRequestedAmountS
    uint totalFillAmountB;
    // The amount of tokens that needs be outputted by #brokerRequestAllowance (and therefore traded for INTERNALLY
    // within the contract)
    uint totalRequestedAmountS;
    uint totalRequestedFeeAmount;
  }

  struct BrokerInterceptorReport {
    address owner;
    address broker;
    bytes32 orderHash;
    address tokenB;
    address tokenS;
    address feeToken;
    uint fillAmountB;
    uint spentAmountS;
    uint spentFeeAmount;
    address tokenRecipient;
    bytes extraData;
  }

}

// File: contracts/market-making/sources/uniswap-v2/interfaces/IUniswapV2Router01.sol

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;
pragma experimental ABIEncoderV2;


interface IUniswapV2Router01 {

    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);

    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address who) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.0;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        require(token.transfer(to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        require(token.transferFrom(from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require((value == 0) || (token.allowance(address(this), spender) == 0));
        require(token.approve(spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        require(token.approve(spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        require(token.approve(spender, newAllowance));
    }
}

// File: contracts/libs/SafeEther.sol

/*
 * Copyright 2020 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.0;

library SafeEther {

    function toPayable(address _address) internal pure returns (address payable) {
        return address(uint160(_address));
    }

    function safeTransferEther(address recipient, uint amount) internal {
        safeTransferEther(recipient, amount, "CANNOT_TRANSFER_ETHER");
    }

    function safeTransferEther(address recipient, uint amount, string memory errorMessage) internal {
        (bool success,) = address(uint160(recipient)).call.value(amount)("");
        require(success, errorMessage);
    }

}

// File: contracts/market-making/helper/MakerBrokerBase.sol

/*
 * Copyright 2020 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;




/**
 * @dev The base contract for any ownable contract is used for permissioned market making with either open liquidity
 *      pools, like Uniswap, or permissioned ones like Dolomite Options.
 */
contract MakerBrokerBase {

    using SafeEther for address payable;
    using SafeERC20 for IERC20;

    address internal owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0x0), "ZERO_ADDRESS");
        owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function withdrawDust(address token) external {
        _withdrawDust(token, msg.sender);
    }

    function withdrawDust(address token, address recipient) external {
        _withdrawDust(token, recipient);
    }

    function withdrawEthDust() external {
        _withdrawEthDust(msg.sender);
    }

    function withdrawEthDust(address payable recipient) external {
        _withdrawEthDust(recipient);
    }

    function _withdrawDust(address token, address recipient) internal {
        require(msg.sender == owner, "UNAUTHORIZED");
        IERC20(token).safeTransfer(
            recipient,
            IERC20(token).balanceOf(address(this))
        );
    }

    function _withdrawEthDust(address payable recipient) internal {
        require(msg.sender == owner, "UNAUTHORIZED");
        recipient.safeTransferEther(address(this).balance);
    }

}

// File: contracts/misc/interfaces/IWETH.sol

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;

interface IWETH {
  event Deposit(address indexed src, uint wad);
  event Withdraw(address indexed src, uint wad);

  function deposit() external payable;
  function withdraw(uint wad) external;
}

// File: contracts/loopring/iface/IBrokerDelegate.sol

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;


interface IBrokerDelegate {

  /*
   * Loopring requests an allowance be set on a given token for a specified amount. Order details
   * are provided (tokenS, totalAmountS, tokenB, totalAmountB, orderTokenRecipient, extraOrderData)
   * to aid in any calculations or on-chain exchange of assets that may be required. The last 4
   * parameters concern the actual token approval being requested of the broker.
   *
   * @returns Whether or not onOrderFillReport should be called for orders using this broker
   */
  function brokerRequestAllowance(BrokerData.BrokerApprovalRequest calldata request) external returns (bool);

  /*
   * After Loopring performs all of the transfers necessary to complete all the submitted
   * rings it will call this function for every order's brokerInterceptor (if set) passing
   * along the final fill counts for tokenB, tokenS and feeToken. This allows actions to be
   * performed on a per-order basis after all tokenS/feeToken funds have left the order owner's
   * possession and the tokenB funds have been transferred to the order owner's intended recipient
   */
  function onOrderFillReport(BrokerData.BrokerInterceptorReport calldata fillReport) external;

  /*
   * Get the available token balance controlled by the broker on behalf of an address (owner)
   */
  function brokerBalanceOf(address owner, address token) external view returns (uint);
}

// File: contracts/market-making/UniswapRebalancerMakerBroker.sol

/*
 * Copyright 2019 Dolomite
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity ^0.5.7;






/*
 * Inherits Loopring's IBrokerDelegate and sources liquidity from Uniswap
 * when the Loopring protocol requests a token approval. Because the Loopring
 * protocol expects the taker order to precede maker orders, and non-brokered
 * transfers occur before before brokered transfers, it is guaranteed that this
 * broker contract will receive the necessary tokens to trade, right before it
 * sets the approval and the Loopring protocol transfers the tokens out. Thus,
 * liquidity can be sourced on-chain with no money down!
 */
contract UniswapRebalancerMakerBroker is MakerBrokerBase, IBrokerDelegate {

    address internal _wethTokenAddress;
    address internal _loopringDelegate;
    address internal _uniswapV2Router;
    uint8 internal _slippageFactor;

    mapping(address => address) public tokenToExchange;
    mapping(address => bool) internal tokenToIsSetup;

    constructor(address loopringDelegate, address uniswapV2Router, address wethTokenAddress) public {
        _loopringDelegate = loopringDelegate;
        _wethTokenAddress = wethTokenAddress;
        _uniswapV2Router = uniswapV2Router;
        _slippageFactor = 4;
    }

    function setupToken(address token) public {
        IERC20(token).safeApprove(_loopringDelegate, uint(- 1));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        IERC20(token).safeApprove(_uniswapV2Router, uint(- 1));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        tokenToIsSetup[token] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setupTokens(address[] calldata tokens) external {
        for (uint i = 0; i < tokens.length; i++) {
            setupToken(tokens[i]);
        }
    }

    function setSlippageFactor(uint8 slippageFactor) external onlyOwner {
        _slippageFactor = slippageFactor;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getSlippageFactor() external view returns (uint8) {
        return _slippageFactor;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function() external payable {
        revert("UniswapRebalancerMakerBroker: NO_DEFAULT");
    }

    // --------------------------------
    // Loopring Broker Delegate

    function brokerRequestAllowance(BrokerData.BrokerApprovalRequest memory request) public returns (bool) {
        require(msg.sender == _loopringDelegate, "UniswapRebalancerMakerBroker: UNAUTHORIZED");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        require(tokenToIsSetup[request.tokenS], "UniswapRebalancerMakerBroker: TOKEN_S_NOT_SETUP");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC

        for (uint i = 0; i < request.orders.length; i++) {
            require(request.orders[i].tokenRecipient == address(this), "UniswapRebalancerMakerBroker: INVALID_TOKEN_RECIPIENT");
            require(request.orders[i].owner == owner, "UniswapRebalancerMakerBroker: INVALID_ORDER_OWNER");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        }

        address[] memory intermediatePaths;
        if (request.orders[0].extraData.length == 0) {
            intermediatePaths = new address[](0);
        } else {
            intermediatePaths = abi.decode(request.orders[0].extraData, (address[]));
        }

        if (intermediatePaths.length == 0 || intermediatePaths[0] != address(0x0000000000000000000000000000000000000001)) {
            address[] memory path = new address[](intermediatePaths.length + 2);
            path[0] = request.tokenB;
            for (uint i = 0; i < intermediatePaths.length; i++) {
                path[i + 1] = intermediatePaths[i];
            }
            path[path.length - 1] = request.tokenS;

            // We don't need to do a "try-catch" here because UniswapV2 has sufficient error handling.
            IUniswapV2Router01(_uniswapV2Router).swapExactTokensForTokens(	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                request.totalFillAmountB,
                request.totalRequestedAmountS / uint(_slippageFactor),	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
                path,
                address(this),
                block.timestamp
            );
        }

        // We don't need a fill report.
        return false;
    }

    function onOrderFillReport(BrokerData.BrokerInterceptorReport memory fillReport) public {
        // No op
    }

    /*
     * This broker isn't concerned with accurate balance reporting. It simplifies balance-tracking logic to just report
     * a maximum.
     */
    function brokerBalanceOf(address owner, address token) public view returns (uint) {
        return uint(- 1);
    }

    function balanceOf(address token) public view returns (uint) {
        return IERC20(token).balanceOf(address(this));
    }

}