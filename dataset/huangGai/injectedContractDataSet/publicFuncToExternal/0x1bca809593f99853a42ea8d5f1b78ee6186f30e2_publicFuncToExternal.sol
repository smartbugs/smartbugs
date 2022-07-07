/**
 *Submitted for verification at Etherscan.io on 2020-06-03
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

// File: contracts/dolomite-direct/interfaces/IDepositContract.sol

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


interface IDepositContract {

    function perform(
        address addr,
        string calldata signature,
        bytes calldata encodedParams,
        uint value
    ) external returns (bytes memory);

}

// File: contracts/dolomite-direct/lib/Types.sol

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

library Types {

    struct RequestFee {
        address feeRecipient;
        address feeToken;
        uint feeAmount;
    }

    struct RequestSignature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    enum RequestType {Update, Transfer, Approve, Perform}

    struct Request {
        address owner;
        address target;
        RequestType requestType;
        bytes payload;
        uint nonce;
        RequestFee fee;
        RequestSignature signature;
    }

    struct TransferRequest {
        address token;
        address recipient;
        uint amount;
        bool unwrap;
    }

    struct UpdateRequest {
        address version;
        bytes additionalData;
    }

    struct ApproveRequest {
        address operator;
        bool canOperate;
    }

    struct PerformRequest {
        address to;
        string functionSignature;
        bytes encodedParams;
        uint value;
    }

}

// File: contracts/dolomite-direct/lib/RequestImpl.sol

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



library RequestImpl {

    bytes constant personalPrefix = "\x19Ethereum Signed Message:\n32";

    function getSigner(Types.Request memory self) internal pure returns (address) {
        bytes32 messageHash = keccak256(abi.encode(
                self.owner,
                self.target,
                self.requestType,
                self.payload,
                self.nonce,
                abi.encode(self.fee.feeRecipient, self.fee.feeToken, self.fee.feeAmount)
            ));

        bytes32 prefixedHash = keccak256(abi.encodePacked(personalPrefix, messageHash));
        return ecrecover(prefixedHash, self.signature.v, self.signature.r, self.signature.s);
    }

    function decodeTransferRequest(Types.Request memory self)
    internal
    pure
    returns (Types.TransferRequest memory){
        require(self.requestType == Types.RequestType.Transfer, "INVALID_REQUEST_TYPE");

        (
        address token,
        address recipient,
        uint amount,
        bool unwrap
        ) = abi.decode(self.payload, (address, address, uint, bool));

        return Types.TransferRequest({
            token : token,
            recipient : recipient,
            amount : amount,
            unwrap : unwrap
            });
    }

    function decodeUpdateRequest(Types.Request memory self)
    internal
    pure
    returns (Types.UpdateRequest memory updateRequest)
    {
        require(self.requestType == Types.RequestType.Update, "INVALID_REQUEST_TYPE");

        (
        updateRequest.version,
        updateRequest.additionalData
        ) = abi.decode(self.payload, (address, bytes));
    }

    function decodeApproveRequest(Types.Request memory self)
    internal
    pure
    returns (Types.ApproveRequest memory approveRequest)
    {
        require(self.requestType == Types.RequestType.Approve, "INVALID_REQUEST_TYPE");

        (
        approveRequest.operator,
        approveRequest.canOperate
        ) = abi.decode(self.payload, (address, bool));
    }

    function decodePerformRequest(Types.Request memory self)
    internal
    pure
    returns (Types.PerformRequest memory performRequest)
    {
        require(self.requestType == Types.RequestType.Perform, "INVALID_REQUEST_TYPE");

        (
        performRequest.to,
        performRequest.functionSignature,
        performRequest.encodedParams,
        performRequest.value
    ) = abi.decode(self.payload, (address, string, bytes, uint));
    }

}

// File: contracts/dolomite-direct/interfaces/IVersionable.sol

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


interface IVersionable {

  /*
   * Is called by IDepositContractRegistry when this version
   * is being upgraded to. Will call `versionEndUsage` on the
   * old contract before calling this one
   */
  function versionBeginUsage(
    address owner,
    address payable depositAddress,
    address oldVersion,
    bytes calldata additionalData
  ) external;

  /*
   * Is called by IDepositContractRegistry when this version is
   * being upgraded from. IDepositContractRegistry will then call
   * `versionBeginUsage` on the new contract
   */
  function versionEndUsage(
    address owner,
    address payable depositAddress,
    address newVersion,
    bytes calldata additionalData
  ) external;

}

// File: contracts/dolomite-direct/interfaces/IDolomiteMarginTradingBroker.sol

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


interface IDolomiteMarginTradingBroker {
    function brokerMarginRequestApproval(address owner, address token, uint amount) external;

    function brokerMarginGetTrader(address owner, bytes calldata orderData) external view returns (address);
}

// File: contracts/dolomite-direct/interfaces/IDepositContractRegistry.sol

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


interface IDepositContractRegistry {

    function depositAddressOf(address owner) external view returns (address payable);

    function operatorOf(address owner, address operator) external returns (bool);

}

// File: contracts/dolomite-direct/lib/DepositContractImpl.sol

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



library DepositContractImpl {

    function wrapAndTransferToken(
        IDepositContract self,
        address token,
        address recipient,
        uint amount,
        address wethAddress
    ) internal {
        if (token == wethAddress) {
            uint etherBalance = address(self).balance;
            if (etherBalance > 0) {
                wrapEth(self, token, etherBalance);
            }
        }
        transferToken(self, token, recipient, amount);
    }

    function transferToken(IDepositContract self, address token, address recipient, uint amount) internal {
        self.perform(token, "transfer(address,uint256)", abi.encode(recipient, amount), 0);
    }

    function transferEth(IDepositContract self, address recipient, uint amount) internal {
        self.perform(recipient, "", abi.encode(), amount);
    }

    function approveToken(IDepositContract self, address token, address broker, uint amount) internal {
        self.perform(token, "approve(address,uint256)", abi.encode(broker, amount), 0);
    }

    function wrapEth(IDepositContract self, address wethToken, uint amount) internal {
        self.perform(wethToken, "deposit()", abi.encode(), amount);
    }

    function unwrapWeth(IDepositContract self, address wethToken, uint amount) internal {
        self.perform(wethToken, "withdraw(uint256)", abi.encode(amount), 0);
    }

    function setDydxOperator(IDepositContract self, address dydxContract, address operator) internal {
        bytes memory encodedParams = abi.encode(
            bytes32(0x0000000000000000000000000000000000000000000000000000000000000020),
            bytes32(0x0000000000000000000000000000000000000000000000000000000000000001),
            operator,
            bytes32(0x0000000000000000000000000000000000000000000000000000000000000001)
        );
        self.perform(dydxContract, "setOperators((address,bool)[])", encodedParams, 0);
    }
}

// File: contracts/dolomite-direct/Requestable.sol

contract Requestable {

    using RequestImpl for Types.Request;

    mapping(address => uint) nonces;

    function validateRequest(Types.Request memory request) internal {
        require(request.target == address(this), "INVALID_TARGET");
        require(request.getSigner() == request.owner, "INVALID_SIGNATURE");
        require(nonces[request.owner] + 1 == request.nonce, "INVALID_NONCE");

        if (request.fee.feeAmount > 0) {
            require(balanceOf(request.owner, request.fee.feeToken) >= request.fee.feeAmount, "INSUFFICIENT_FEE_BALANCE");
        }

        nonces[request.owner] += 1;
    }

    function completeRequest(Types.Request memory request) internal {
        if (request.fee.feeAmount > 0) {
            _payRequestFee(request.owner, request.fee.feeToken, request.fee.feeRecipient, request.fee.feeAmount);
        }
    }

    function nonceOf(address owner) public view returns (uint) {
        return nonces[owner];
    }

    // Abtract functions
    function balanceOf(address owner, address token) public view returns (uint);
    function _payRequestFee(address owner, address feeToken, address feeRecipient, uint feeAmount) internal;
}

// File: contracts/dolomite-direct/DolomiteDirectV1.sol

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













/**
 * @title DolomiteDirectV1
 * @author Zack Rubenstein from Dolomite
 *
 * Interfaces with the IDepositContractRegistry and individual 
 * IDepositContracts to enable smart-wallet functionality as well
 * as spot and margin trading on Dolomite (through Loopring & dYdX)
 */
contract DolomiteDirectV1 is Requestable, IVersionable, IDolomiteMarginTradingBroker {
    using DepositContractImpl for IDepositContract;
    using SafeMath for uint;

    IDepositContractRegistry public registry;
    address public loopringDelegate;
    address public dolomiteMarginProtocolAddress;
    address public dydxProtocolAddress;
    address public wethTokenAddress;

    constructor(
        address _depositContractRegistry,
        address _loopringDelegate,
        address _dolomiteMarginProtocol,
        address _dydxProtocolAddress,
        address _wethTokenAddress
    ) public {
        registry = IDepositContractRegistry(_depositContractRegistry);
        loopringDelegate = _loopringDelegate;
        dolomiteMarginProtocolAddress = _dolomiteMarginProtocol;
        dydxProtocolAddress = _dydxProtocolAddress;
        wethTokenAddress = _wethTokenAddress;
    }

    /*
     * Returns the available balance for an owner that this contract manages.
     * If the token is WETH, it returns the sum of the ETH and WETH balance,
     * as ETH is automatically wrapped upon transfers (unless the unwrap option is
     * set to true in the transfer request)
     */
    function balanceOf(address owner, address token) public view returns (uint) {
        address depositAddress = registry.depositAddressOf(owner);
        uint tokenBalance = IERC20(token).balanceOf(depositAddress);
        if (token == wethTokenAddress) tokenBalance = tokenBalance.add(depositAddress.balance);
        return tokenBalance;
    }

    /*
     * Send up a signed transfer request and the given amount tokens
     * is transferred to the specified recipient.
     */
    function transfer(Types.Request memory request) public {
        validateRequest(request);

        Types.TransferRequest memory transferRequest = request.decodeTransferRequest();
        address payable depositAddress = registry.depositAddressOf(request.owner);

        _transfer(
            transferRequest.token,
            depositAddress,
            transferRequest.recipient,
            transferRequest.amount,
            transferRequest.unwrap
        );

        completeRequest(request);
    }

    // =============================

    function _transfer(address token, address payable depositAddress, address recipient, uint amount, bool unwrap) internal {
        IDepositContract depositContract = IDepositContract(depositAddress);

        if (token == wethTokenAddress && unwrap) {
            if (depositAddress.balance < amount) {
                depositContract.unwrapWeth(wethTokenAddress, amount.sub(depositAddress.balance));
            }

            depositContract.transferEth(recipient, amount);
            return;
        }

        depositContract.wrapAndTransferToken(token, recipient, amount, wethTokenAddress);
    }

    // -----------------------------
    // Loopring Broker Delegate

    function brokerRequestAllowance(BrokerData.BrokerApprovalRequest memory request) public returns (bool) {
        require(msg.sender == loopringDelegate);

        BrokerData.BrokerOrder[] memory mergedOrders = new BrokerData.BrokerOrder[](request.orders.length);
        uint numMergedOrders = 1;

        mergedOrders[0] = request.orders[0];

        if (request.orders.length > 1) {
            for (uint i = 1; i < request.orders.length; i++) {
                bool isDuplicate = false;

                for (uint b = 0; b < numMergedOrders; b++) {
                    if (request.orders[i].owner == mergedOrders[b].owner) {
                        mergedOrders[b].requestedAmountS += request.orders[i].requestedAmountS;
                        mergedOrders[b].requestedFeeAmount += request.orders[i].requestedFeeAmount;
                        isDuplicate = true;
                        break;
                    }
                }

                if (!isDuplicate) {
                    mergedOrders[numMergedOrders] = request.orders[i];
                    numMergedOrders += 1;
                }
            }
        }

        for (uint j = 0; j < numMergedOrders; j++) {
            BrokerData.BrokerOrder memory order = mergedOrders[j];
            address payable depositAddress = registry.depositAddressOf(order.owner);

            _transfer(request.tokenS, depositAddress, address(this), order.requestedAmountS, false);
            if (order.requestedFeeAmount > 0) _transfer(request.feeToken, depositAddress, address(this), order.requestedFeeAmount, false);
        }

        return false;
        // Does not use onOrderFillReport
    }

    function onOrderFillReport(BrokerData.BrokerInterceptorReport memory fillReport) public {
        // Do nothing
    }

    function brokerBalanceOf(address owner, address tokenAddress) public view returns (uint) {
        return balanceOf(owner, tokenAddress);
    }

    // ----------------------------
    // Dolomite Margin Trading Broker

    function brokerMarginRequestApproval(address owner, address token, uint amount) public {
        require(msg.sender == dolomiteMarginProtocolAddress || msg.sender == loopringDelegate, "brokerMarginRequestApproval: INVALID_SENDER");

        address payable depositAddress = registry.depositAddressOf(owner);
        _transfer(token, depositAddress, address(this), amount, false);
    }

    function brokerMarginGetTrader(address owner, bytes memory orderData) public view returns (address) {
        return registry.depositAddressOf(owner);
    }

    // -----------------------------
    // Requestable

    function _payRequestFee(address owner, address feeToken, address feeRecipient, uint feeAmount) internal {
        _transfer(feeToken, registry.depositAddressOf(owner), feeRecipient, feeAmount, false);
    }

    // -----------------------------
    // Versionable

    function versionBeginUsage(
        address owner,
        address payable depositAddress,
        address oldVersion,
        bytes calldata additionalData
    ) external {
        // Approve the DolomiteMarginProtocol as an operator for the deposit contract's dYdX account
        IDepositContract(depositAddress).setDydxOperator(dydxProtocolAddress, dolomiteMarginProtocolAddress);
    }

    function versionEndUsage(
        address owner,
        address payable depositAddress,
        address newVersion,
        bytes calldata additionalData
    ) external {/* do nothing */}


    // =============================
    // Administrative

    /*
     * Tokens are held in individual deposit contracts, the only time a trader's
     * funds are held by this contract is when Loopring or dYdX requests a trader's
     * tokens, and immediately upon this contract moving funds into itself, Loopring
     * or dYdX will move the funds out and into themselves. Thus, we can open this
     * function up for anyone to call to set or reset the approval for Loopring and
     * dYdX for a given token. The reason these approvals are set globally and not
     * on an as-needed (per fill) basis is to reduce gas costs.
     */
    function enableTrading(address token) public {
        IERC20(token).approve(loopringDelegate, 10 ** 70);
        IERC20(token).approve(dolomiteMarginProtocolAddress, 10 ** 70);
    }

    function enableTrading(address[] calldata tokens) external {
        for (uint i = 0; i < tokens.length; i++) {
            enableTrading(tokens[i]);
        }
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

    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0x0), "ZERO_ADDRESS");
        owner = newOwner;
    }

    function withdrawDust(address token) public {	//inject PUBLIC FUNC TO EXTERNAL
        _withdrawDust(token, msg.sender);
    }

    function withdrawDust(address token, address recipient) public {	//inject PUBLIC FUNC TO EXTERNAL
        _withdrawDust(token, recipient);
    }

    function withdrawEthDust() public {	//inject PUBLIC FUNC TO EXTERNAL
        _withdrawEthDust(msg.sender);
    }

    function withdrawEthDust(address payable recipient) public {	//inject PUBLIC FUNC TO EXTERNAL
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

// File: contracts/market-making/UniswapV2MakerBroker.sol

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
contract UniswapV2MakerBroker is MakerBrokerBase, IBrokerDelegate {

    address public wethTokenAddress;
    address public loopringDelegate;
    IUniswapV2Router01 public uniswapV2Router;

    mapping(address => address) public tokenToExchange;
    mapping(address => bool) public tokenToIsSetup;

    constructor(address _loopringDelegate, address _uniswapV2Router, address _wethTokenAddress) public {
        loopringDelegate = _loopringDelegate;
        wethTokenAddress = _wethTokenAddress;
        uniswapV2Router = IUniswapV2Router01(_uniswapV2Router);
    }

    function setupToken(address token) public {
        IERC20(token).safeApprove(loopringDelegate, uint(- 1));
        IERC20(token).safeApprove(address(uniswapV2Router), uint(- 1));
        tokenToIsSetup[token] = true;
    }

    function setupTokens(address[] calldata tokens) external {
        for (uint i = 0; i < tokens.length; i++) {
            setupToken(tokens[i]);
        }
    }

    function() external payable {
        revert("UniswapV2MakerBroker: NO_DEFAULT");
    }

    // --------------------------------
    // Loopring Broker Delegate

    function brokerRequestAllowance(BrokerData.BrokerApprovalRequest memory request) public returns (bool) {
        require(msg.sender == loopringDelegate, "UniswapV2MakerBroker: UNAUTHORIZED");
        require(tokenToIsSetup[request.tokenS], "UniswapV2MakerBroker: TOKEN_S_NOT_SETUP");

        for (uint i = 0; i < request.orders.length; i++) {
            require(request.orders[i].tokenRecipient == address(this), "UniswapV2MakerBroker: INVALID_TOKEN_RECIPIENT");
            require(request.orders[i].owner == owner, "UniswapV2MakerBroker: INVALID_ORDER_OWNER");
        }

        address[] memory intermediatePaths;
        if (request.orders[0].extraData.length == 0) {
            intermediatePaths = new address[](0);
        } else {
            intermediatePaths = abi.decode(request.orders[0].extraData, (address[]));
        }

        address[] memory path = new address[](intermediatePaths.length + 2);
        path[0] = request.tokenB;
        for (uint i = 0; i < intermediatePaths.length; i++) {
            path[i + 1] = intermediatePaths[i];
        }
        path[path.length - 1] = request.tokenS;

        // We don't need to do a "try-catch" here because UniswapV2 has sufficient error handling.
        uniswapV2Router.swapExactTokensForTokens(
            request.totalFillAmountB,
            request.totalRequestedAmountS,
            path,
            address(this),
            block.timestamp
        );

        // We don't need a fill report.
        return false;
    }

    function onOrderFillReport(BrokerData.BrokerInterceptorReport memory fillReport) public {
        // No op
    }

    /*
     * Balance is unknown as it is entirely dependent on the offer in Uniswap being filled.
     * Thus we send down a very large number to ensure the relay/matching engine believes
     * orders from this broker have enough of a balance for trades to be filled.
     */
    function brokerBalanceOf(address owner, address tokenAddress) public view returns (uint) {
        return uint(- 1);
    }

}