/**
 *Submitted for verification at Etherscan.io on 2020-10-12
*/

// SPDX-License-Identifier: GPL-3.0-or-later

/**

Author: CoFiX Core, https://cofix.io
Commit hash: v0.9.5-1-g7141c43
Repository: https://github.com/Computable-Finance/CoFiX
Issues: https://github.com/Computable-Finance/CoFiX/issues

*/

pragma experimental ABIEncoderV2;
pragma solidity 0.6.12;


// 
interface ICoFiXERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    // function name() external pure returns (string memory);
    // function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
}

// 
interface ICoFiXPair is ICoFiXERC20 {

    struct OraclePrice {
        uint256 ethAmount;
        uint256 erc20Amount;
        uint256 blockNum;
        uint256 K;
        uint256 theta;
    }

    // All pairs: {ETH <-> ERC20 Token}
    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, address outToken, uint outAmount, address indexed to);
    event Swap(
        address indexed sender,
        uint amountIn,
        uint amountOut,
        address outToken,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1);

    function mint(address to) external payable returns (uint liquidity, uint oracleFeeChange);
    function burn(address outToken, address to) external payable returns (uint amountOut, uint oracleFeeChange);
    function swapWithExact(address outToken, address to) external payable returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo);
    function swapForExact(address outToken, uint amountOutExact, address to) external payable returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo);
    function skim(address to) external;
    function sync() external;

    function initialize(address, address, string memory, string memory) external;

    /// @dev get Net Asset Value Per Share
    /// @param  ethAmount ETH side of Oracle price {ETH <-> ERC20 Token}
    /// @param  erc20Amount Token side of Oracle price {ETH <-> ERC20 Token}
    /// @return navps The Net Asset Value Per Share (liquidity) represents
    function getNAVPerShare(uint256 ethAmount, uint256 erc20Amount) external view returns (uint256 navps);
}

// 
interface ICoFiXFactory {
    // All pairs: {ETH <-> ERC20 Token}
    event PairCreated(address indexed token, address pair, uint256);
    event NewGovernance(address _new);
    event NewController(address _new);
    event NewFeeReceiver(address _new);
    event NewFeeVaultForLP(address token, address feeVault);
    event NewVaultForLP(address _new);
    event NewVaultForTrader(address _new);
    event NewVaultForCNode(address _new);

    /// @dev Create a new token pair for trading
    /// @param  token the address of token to trade
    /// @return pair the address of new token pair
    function createPair(
        address token
        )
        external
        returns (address pair);

    function getPair(address token) external view returns (address pair);
    function allPairs(uint256) external view returns (address pair);
    function allPairsLength() external view returns (uint256);

    function getTradeMiningStatus(address token) external view returns (bool status);
    function setTradeMiningStatus(address token, bool status) external;
    function getFeeVaultForLP(address token) external view returns (address feeVault); // for LPs
    function setFeeVaultForLP(address token, address feeVault) external;

    function setGovernance(address _new) external;
    function setController(address _new) external;
    function setFeeReceiver(address _new) external;
    function setVaultForLP(address _new) external;
    function setVaultForTrader(address _new) external;
    function setVaultForCNode(address _new) external;
    function getController() external view returns (address controller);
    function getFeeReceiver() external view returns (address feeReceiver); // For CoFi Holders
    function getVaultForLP() external view returns (address vaultForLP);
    function getVaultForTrader() external view returns (address vaultForTrader);
    function getVaultForCNode() external view returns (address vaultForCNode);
}

// 
interface ICoFiXController {

    event NewK(address token, int128 K, int128 sigma, uint256 T, uint256 ethAmount, uint256 erc20Amount, uint256 blockNum, uint256 tIdx, uint256 sigmaIdx, int128 K0);
    event NewGovernance(address _new);
    event NewOracle(address _priceOracle);
    event NewKTable(address _kTable);
    event NewTimespan(uint256 _timeSpan);
    event NewKRefreshInterval(uint256 _interval);
    event NewKLimit(int128 maxK0);
    event NewGamma(int128 _gamma);
    event NewTheta(address token, uint32 theta);

    function addCaller(address caller) external;

    function queryOracle(address token, uint8 op, bytes memory data) external payable returns (uint256 k, uint256 ethAmount, uint256 erc20Amount, uint256 blockNum, uint256 theta);
}

// 
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
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

// 
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
     *
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
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
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
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// 
// ERC20 token implementation, inherited by CoFiXPair contract, no owner or governance
contract CoFiXERC20 is ICoFiXERC20 {
    using SafeMath for uint;

    string public constant nameForDomain = 'CoFiX Pool Token';
    uint8 public override constant decimals = 18;
    uint  public override totalSupply;
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance;

    bytes32 public override DOMAIN_SEPARATOR;
    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
    bytes32 public override constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint) public override nonces;

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    constructor() public {
        uint chainId;
        assembly {
            chainId := chainid()
        }
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
                keccak256(bytes(nameForDomain)),
                keccak256(bytes('1')),
                chainId,
                address(this)
            )
        );
    }

    function _mint(address to, uint value) internal {
        totalSupply = totalSupply.add(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint value) internal {
        balanceOf[from] = balanceOf[from].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Transfer(from, address(0), value);
    }

    function _approve(address owner, address spender, uint value) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(address from, address to, uint value) private {
        balanceOf[from] = balanceOf[from].sub(value);
        balanceOf[to] = balanceOf[to].add(value);
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint value) external override returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint value) external override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) external override returns (bool) {
        if (allowance[from][msg.sender] != uint(-1)) {
            allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
        }
        _transfer(from, to, value);
        return true;
    }

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override {
        require(deadline >= block.timestamp, 'CERC20: EXPIRED');
        bytes32 digest = keccak256(
            abi.encodePacked(
                '\x19\x01',
                DOMAIN_SEPARATOR,
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );
        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, 'CERC20: INVALID_SIGNATURE');
        _approve(owner, spender, value);
    }
}

// 
// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = (false, bytes(msg.data));
	 token.call(abi.encodeWithSelector(0x095ea7b3, to, value));	//inject UNHANDLED EXCEPTION

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = (false, bytes(msg.data));
	 token.call(abi.encodeWithSelector(0xa9059cbb, to, value));	//inject UNHANDLED EXCEPTION

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = (false, bytes(msg.data));
	 token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));	//inject UNHANDLED EXCEPTION

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = (false, bytes(msg.data));
	 to.call{value:value}(new bytes(0));	//inject UNHANDLED EXCEPTION

        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}

// 
// Pair contract for each trading pair, storing assets and handling settlement
// No owner or governance
contract CoFiXPair is ICoFiXPair, CoFiXERC20 {
    using SafeMath for uint;

    enum CoFiX_OP { QUERY, MINT, BURN, SWAP_WITH_EXACT, SWAP_FOR_EXACT } // operations in CoFiX

    uint public override constant MINIMUM_LIQUIDITY = 10**9; // it's negligible because we calc liquidity in ETH
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));

    uint256 constant public K_BASE = 1E8; // K
    uint256 constant public NAVPS_BASE = 1E18; // NAVPS (Net Asset Value Per Share), need accuracy
    uint256 constant public THETA_BASE = 1E8; // theta

    string public name;
    string public symbol;

    address public override immutable factory;
    address public override token0; // WETH token
    address public override token1; // any ERC20 token

    uint112 private reserve0;           // uses single storage slot, accessible via getReserves
    uint112 private reserve1;           // uses single storage slot, accessible via getReserves

    uint private unlocked = 1;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, address outToken, uint outAmount, address indexed to);
    event Swap(
        address indexed sender,
        uint amountIn,
        uint amountOut,
        address outToken,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    modifier lock() {
        require(unlocked == 1, "CPair: LOCKED");
        unlocked = 0;
        _;
        unlocked = 1;
    }

    constructor() public {
        factory = msg.sender;
    }

    receive() external payable {}

    // called once by the factory at time of deployment
    function initialize(address _token0, address _token1, string memory _name, string memory _symbol) external override {
        require(msg.sender == factory, "CPair: FORBIDDEN"); // sufficient check
        token0 = _token0;
        token1 = _token1;
        name = _name;
        symbol = _symbol;
    }

    function getReserves() public override view returns (uint112 _reserve0, uint112 _reserve1) {
        _reserve0 = reserve0;
        _reserve1 = reserve1;
    }

    function _safeTransfer(address token, address to, uint value) private {
        (bool success, bytes memory data) = (false, bytes(msg.data));
	 token.call(abi.encodeWithSelector(SELECTOR, to, value));	//inject UNHANDLED EXCEPTION

        require(success && (data.length == 0 || abi.decode(data, (bool))), "CPair: TRANSFER_FAILED");
    }

    // update reserves
    function _update(uint balance0, uint balance1) private {
        require(balance0 <= uint112(-1) && balance1 <= uint112(-1), "CPair: OVERFLOW");
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
        emit Sync(reserve0, reserve1);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function mint(address to) external payable override lock returns (uint liquidity, uint oracleFeeChange) {
        address _token0 = token0;                                // gas savings
        address _token1 = token1;                                // gas savings
        (uint112 _reserve0, uint112 _reserve1) = getReserves(); // gas savings
        uint balance0 = IERC20(_token0).balanceOf(address(this));
        uint balance1 = IERC20(_token1).balanceOf(address(this));
        uint amount0 = balance0.sub(_reserve0);
        uint amount1 = balance1.sub(_reserve1);

        uint256 _ethBalanceBefore = address(this).balance;
        { // scope for ethAmount/erc20Amount/blockNum to avoid stack too deep error
            bytes memory data = abi.encode(msg.sender, to, amount0, amount1);
            // query price
            OraclePrice memory _op;
            (_op.K, _op.ethAmount, _op.erc20Amount, _op.blockNum, _op.theta) = _queryOracle(_token1, CoFiX_OP.MINT, data);
            uint256 navps = calcNAVPerShareForMint(_reserve0, _reserve1, _op);
            if (totalSupply == 0) {
                liquidity = calcLiquidity(amount0, amount1, navps, _op).sub(MINIMUM_LIQUIDITY);
                _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
            } else {
                liquidity = calcLiquidity(amount0, amount1, navps, _op);
            }
        }
        oracleFeeChange = msg.value.sub(_ethBalanceBefore.sub(address(this).balance));

        require(liquidity > 0, "CPair: SHORT_LIQUIDITY_MINTED");
        _mint(to, liquidity);

        _update(balance0, balance1);
        if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);

        emit Mint(msg.sender, amount0, amount1);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function burn(address outToken, address to) external payable override lock returns (uint amountOut, uint oracleFeeChange) {
        address _token0 = token0;                                // gas savings
        address _token1 = token1;                                // gas savings
        uint balance0 = IERC20(_token0).balanceOf(address(this));
        uint balance1 = IERC20(_token1).balanceOf(address(this));
        uint liquidity = balanceOf[address(this)];

        uint256 _ethBalanceBefore = address(this).balance;
        uint256 fee;
        {
            bytes memory data = abi.encode(msg.sender, outToken, to, liquidity);
            // query price
            OraclePrice memory _op;
            (_op.K, _op.ethAmount, _op.erc20Amount, _op.blockNum, _op.theta) = _queryOracle(_token1, CoFiX_OP.BURN, data);
            if (outToken == _token0) {
                (amountOut, fee) = calcOutToken0ForBurn(liquidity, _op); // navps calculated
            } else if (outToken == _token1) {
                (amountOut, fee) = calcOutToken1ForBurn(liquidity, _op); // navps calculated
            }  else {
                revert("CPair: wrong outToken");
            }
        }
        oracleFeeChange = msg.value.sub(_ethBalanceBefore.sub(address(this).balance));

        require(amountOut > 0, "CPair: SHORT_LIQUIDITY_BURNED");
        _burn(address(this), liquidity);
        _safeTransfer(outToken, to, amountOut);
        if (fee > 0) {
            if (ICoFiXFactory(factory).getTradeMiningStatus(_token1)) {
                // only transfer fee to protocol feeReceiver when trade mining is enabled for this trading pair
                _safeSendFeeForCoFiHolder(_token0, fee);
            } else {
                _safeSendFeeForLP(_token0, _token1, fee);
            }
        }
        balance0 = IERC20(_token0).balanceOf(address(this));
        balance1 = IERC20(_token1).balanceOf(address(this));

        _update(balance0, balance1);
        if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);

        emit Burn(msg.sender, outToken, amountOut, to);
    }


    // this low-level function should be called from a contract which performs important safety checks
    function swapWithExact(address outToken, address to)
        external
        payable override lock
        returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo)
    {
        // tradeInfo[0]: thetaFee, tradeInfo[1]: x, tradeInfo[2]: y, tradeInfo[3]: navps
        address _token0 = token0;
        address _token1 = token1;
        uint256 balance0 = IERC20(_token0).balanceOf(address(this));
        uint256 balance1 = IERC20(_token1).balanceOf(address(this));

        // uint256 fee;
        { // scope for ethAmount/erc20Amount/blockNum to avoid stack too deep error
            uint256 _ethBalanceBefore = address(this).balance;
            (uint112 _reserve0, uint112 _reserve1) = getReserves(); // gas savings
            // calc amountIn
            if (outToken == _token1) {
                amountIn = balance0.sub(_reserve0);
            } else if (outToken == _token0) {
                amountIn = balance1.sub(_reserve1);
            } else {
                revert("CPair: wrong outToken");
            }
            require(amountIn > 0, "CPair: wrong amountIn");
            bytes memory data = abi.encode(msg.sender, outToken, to, amountIn);
            // query price
            OraclePrice memory _op;
            (_op.K, _op.ethAmount, _op.erc20Amount, _op.blockNum, _op.theta) = _queryOracle(_token1, CoFiX_OP.SWAP_WITH_EXACT, data);
            if (outToken == _token1) {
                (amountOut, tradeInfo[0]) = calcOutToken1(amountIn, _op);
                tradeInfo[1] = _reserve0; // swap token0 for token1 out
                tradeInfo[2] = uint256(_reserve1).mul(_op.ethAmount).div(_op.erc20Amount); // _reserve1 value as _reserve0
            } else if (outToken == _token0) {
                (amountOut, tradeInfo[0]) = calcOutToken0(amountIn, _op);
                tradeInfo[1] = uint256(_reserve1).mul(_op.ethAmount).div(_op.erc20Amount); // _reserve1 value as _reserve0
                tradeInfo[2] = _reserve0; // swap token1 for token0 out
            }
            oracleFeeChange = msg.value.sub(_ethBalanceBefore.sub(address(this).balance));
            tradeInfo[3] = calcNAVPerShare(_reserve0, _reserve1, _op.ethAmount, _op.erc20Amount);
        }
        
        require(to != _token0 && to != _token1, "CPair: INVALID_TO");

        _safeTransfer(outToken, to, amountOut); // optimistically transfer tokens
        if (tradeInfo[0] > 0) {
            if (ICoFiXFactory(factory).getTradeMiningStatus(_token1)) {
                // only transfer fee to protocol feeReceiver when trade mining is enabled for this trading pair
                _safeSendFeeForCoFiHolder(_token0, tradeInfo[0]);
            } else {
                _safeSendFeeForLP(_token0, _token1, tradeInfo[0]);
                tradeInfo[0] = 0; // so router won't go into the trade mining logic (reduce one more call gas cost)
            }
        }
        balance0 = IERC20(_token0).balanceOf(address(this));
        balance1 = IERC20(_token1).balanceOf(address(this));

        _update(balance0, balance1);
        if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);

        emit Swap(msg.sender, amountIn, amountOut, outToken, to);
    }

    // this low-level function should be called from a contract which performs important safety checks
    function swapForExact(address outToken, uint amountOutExact, address to)
        external
        payable override lock
        returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo)
    {
        // tradeInfo[0]: thetaFee, tradeInfo[1]: x, tradeInfo[2]: y, tradeInfo[3]: navps
        address _token0 = token0;
        address _token1 = token1;
        OraclePrice memory _op;

        // uint256 fee;

        { // scope for ethAmount/erc20Amount/blockNum to avoid stack too deep error
            uint256 _ethBalanceBefore = address(this).balance;
            bytes memory data = abi.encode(msg.sender, outToken, amountOutExact, to);
            // query price
            (_op.K, _op.ethAmount, _op.erc20Amount, _op.blockNum, _op.theta) = _queryOracle(_token1, CoFiX_OP.SWAP_FOR_EXACT, data);
            oracleFeeChange = msg.value.sub(_ethBalanceBefore.sub(address(this).balance));
        }

        { // calc and check amountIn, also outToken
            uint256 balance0 = IERC20(_token0).balanceOf(address(this));
            uint256 balance1 = IERC20(_token1).balanceOf(address(this));
            (uint112 _reserve0, uint112 _reserve1) = getReserves(); // gas savings
     
            if (outToken == _token1) {
                amountIn = balance0.sub(_reserve0);
                tradeInfo[1] = _reserve0; // swap token0 for token1 out
                tradeInfo[2] = uint256(_reserve1).mul(_op.ethAmount).div(_op.erc20Amount); // _reserve1 value as _reserve0
            } else if (outToken == _token0) {
                amountIn = balance1.sub(_reserve1);
                tradeInfo[1] = uint256(_reserve1).mul(_op.ethAmount).div(_op.erc20Amount); // _reserve1 value as _reserve0
                tradeInfo[2] = _reserve0; // swap token1 for token0 out
            } else {
                revert("CPair: wrong outToken");
            }
            require(amountIn > 0, "CPair: wrong amountIn");
            tradeInfo[3] = calcNAVPerShare(_reserve0, _reserve1, _op.ethAmount, _op.erc20Amount);
        }

        { // split with branch upbove to make code more clear
            uint _amountInNeeded;
            uint _amountInLeft;
            if (outToken == _token1) {
                (_amountInNeeded, tradeInfo[0]) = calcInNeededToken0(amountOutExact, _op);
                _amountInLeft = amountIn.sub(_amountInNeeded);
                if (_amountInLeft > 0) {
                    _safeTransfer(_token0, to, _amountInLeft); // send back the amount0 token change
                }
            } else if (outToken == _token0) {
                (_amountInNeeded, tradeInfo[0]) = calcInNeededToken1(amountOutExact, _op);
                _amountInLeft = amountIn.sub(_amountInNeeded);
                if (_amountInLeft > 0) {
                    _safeTransfer(_token1, to, _amountInLeft); // send back the amount1 token change
                }
            }
            require(_amountInNeeded <= amountIn, "CPair: insufficient amountIn");
            require(_amountInNeeded > 0, "CPair: wrong amountIn needed");
        }
        
        {
            require(to != _token0 && to != _token1, "CPair: INVALID_TO");

            amountOut = amountOutExact;
            _safeTransfer(outToken, to, amountOut); // optimistically transfer tokens
            if (tradeInfo[0] > 0) {
                if (ICoFiXFactory(factory).getTradeMiningStatus(_token1)) {
                    // only transfer fee to protocol feeReceiver when trade mining is enabled for this trading pair
                    _safeSendFeeForCoFiHolder(_token0, tradeInfo[0]);
                } else {
                    _safeSendFeeForLP(_token0, _token1, tradeInfo[0]);
                    tradeInfo[0] = 0; // so router won't go into the trade mining logic (reduce one more call gas cost)
                }
            }
            uint256 balance0 = IERC20(_token0).balanceOf(address(this));
            uint256 balance1 = IERC20(_token1).balanceOf(address(this));

            _update(balance0, balance1);
            if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
        }

        emit Swap(msg.sender, amountIn, amountOut, outToken, to);
    }

    // force balances to match reserves
    function skim(address to) external override lock {
        address _token0 = token0; // gas savings
        address _token1 = token1; // gas savings
        _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
        _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
    }

    // force reserves to match balances
    function sync() external override lock {
        _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)));
    }

    // calc Net Asset Value Per Share for mint
    // use it in this contract, for optimized gas usage
    function calcNAVPerShareForMint(uint256 balance0, uint256 balance1, OraclePrice memory _op) public view returns (uint256 navps) {
        uint _totalSupply = totalSupply;
        if (_totalSupply == 0) {
            navps = NAVPS_BASE;
        } else {
            /*
            N_{p} &= (A_{u}/P_{s}^{'} + A_{e})/S \\\\
                  &= (A_{u}/(P * (1 - K)) + A_{e})/S \\\\
                  &= (\frac{A_{u}}{\frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} - k)}{(k_{BASE})}} + A_{e})/S \\\\
                  &= (\frac{A_{u}*ethAmount*k_{BASE}}{erc20Amount*(k_{BASE} - k)}+ A_{e}) / S \\\\
                  &= (A_{u}*ethAmount*k_{BASE}+ A_{e}*erc20Amount*(k_{BASE} - k)) / S / (erc20Amount*(k_{BASE} - k)) \\\\
            N_{p} &= NAVPS_{BASE}*(A_{u}*ethAmount*k_{BASE}+ A_{e}*erc20Amount*(k_{BASE} - k)) / S / (erc20Amount*(k_{BASE} - k)) \\\\
            // navps = NAVPS_BASE * ( (balance1*_op.ethAmount*K_BASE) + (balance0*_op.erc20Amount*(K_BASE-_op.K)) ) / _totalSupply / _op.erc20Amount / (K_BASE-_op.K);
            */
            uint256 kbaseSubK = K_BASE.sub(_op.K);
            uint256 balance1MulEthKbase = balance1.mul(_op.ethAmount).mul(K_BASE);
            uint256 balance0MulErcKbsk = balance0.mul(_op.erc20Amount).mul(kbaseSubK);
            navps = NAVPS_BASE.mul( (balance1MulEthKbase).add(balance0MulErcKbsk) ).div(_totalSupply).div(_op.erc20Amount).div(kbaseSubK);
        }
    }

    // calc Net Asset Value Per Share for burn
    // use it in this contract, for optimized gas usage
    function calcNAVPerShareForBurn(uint256 balance0, uint256 balance1, OraclePrice memory _op) public view returns (uint256 navps) {
        uint _totalSupply = totalSupply;
        if (_totalSupply == 0) {
            navps = NAVPS_BASE;
        } else {
            /*
            N_{p}^{'} &= (A_{u}/P_{b}^{'} + A_{e})/S \\\\
                      &= (A_{u}/(P * (1 + K)) + A_{e})/S \\\\
                      &= (\frac{A_{u}}{\frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} + k)}{(k_{BASE})}} + A_{e})/S \\\\
                      &= (\frac{A_{u}*ethAmount*k_{BASE}}{erc20Amount*(k_{BASE} + k)}+ A_{e}) / S \\\\
                      &= (A_{u}*ethAmount*k_{BASE}+ A_{e}*erc20Amount*(k_{BASE} + k)) / S / (erc20Amount*(k_{BASE} + k)) \\\\
            N_{p}^{'} &= NAVPS_{BASE}*(A_{u}*ethAmount*k_{BASE}+ A_{e}*erc20Amount*(k_{BASE} + k)) / S / (erc20Amount*(k_{BASE} + k)) \\\\
            // navps = NAVPS_BASE * ( (balance1*_op.ethAmount*K_BASE) + (balance0*_op.erc20Amount*(K_BASE+_op.K)) ) / _totalSupply / _op.erc20Amount / (K_BASE+_op.K);
            */
            uint256 kbaseAddK = K_BASE.add(_op.K);
            uint256 balance1MulEthKbase = balance1.mul(_op.ethAmount).mul(K_BASE);
            uint256 balance0MulErcKbsk = balance0.mul(_op.erc20Amount).mul(kbaseAddK);
            navps = NAVPS_BASE.mul( (balance1MulEthKbase).add(balance0MulErcKbsk) ).div(_totalSupply).div(_op.erc20Amount).div(kbaseAddK);
        }
    }

    // calc Net Asset Value Per Share (no K)
    // use it in this contract, for optimized gas usage
    function calcNAVPerShare(uint256 balance0, uint256 balance1, uint256 ethAmount, uint256 erc20Amount) public view returns (uint256 navps) {
        uint _totalSupply = totalSupply;
        if (_totalSupply == 0) {
            navps = NAVPS_BASE;
        } else {
            /*
            N_{p}^{'} &= (A_{u}/P + A_{e})/S \\\\
                      &= (\frac{A_{u}}{\frac{erc20Amount}{ethAmount}} + A_{e})/S \\\\
                      &= (\frac{A_{u}*ethAmount}{erc20Amount}+ A_{e}) / S \\\\
                      &= (A_{u}*ethAmount+ A_{e}*erc20Amount) / S / (erc20Amount) \\\\
            N_{p}^{'} &= NAVPS_{BASE}*(A_{u}*ethAmount+ A_{e}*erc20Amount) / S / (erc20Amount) \\\\
            // navps = NAVPS_BASE * ( (balance1*_op.ethAmount) + (balance0*_op.erc20Amount) ) / _totalSupply / _op.erc20Amount;
            */
            uint256 balance1MulEth = balance1.mul(ethAmount);
            uint256 balance0MulErc = balance0.mul(erc20Amount);
            navps = NAVPS_BASE.mul( (balance1MulEth).add(balance0MulErc) ).div(_totalSupply).div(erc20Amount);
        }
    }

    // use it in this contract, for optimized gas usage
    function calcLiquidity(uint256 amount0, uint256 amount1, uint256 navps, OraclePrice memory _op) public pure returns (uint256 liquidity) {
        /*
        s_{1} &= a / (N_{p} / NAVPS_{BASE}) \\\\
              &= a * NAVPS_{BASE} / N_{p} \\\\
        s_{2} &= b / P_{b}^{'} / (N_{p} / NAVPS_{BASE}) \\\\
              &= b / (N_{p} / NAVPS_{BASE}) / P_{b}^{'} \\\\
              &= b * NAVPS_{BASE} / N_{p} / P_{b}^{'} \\\\
              &= b * NAVPS_{BASE} / N_{p} / (\frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} + k)}{(k_{BASE})}) \\\\
              &= b * NAVPS_{BASE} * ethAmount * k_{BASE} / N_{p} / (erc20Amount * (k_{BASE} + k))
        s &= s_1 + s_2 \\\\
          &= a * NAVPS_{BASE} / N_{p} + b * NAVPS_{BASE} / N_{p} / P_{b}^{'} \\\\
          &= a * NAVPS_{BASE} / N_{p} + b * NAVPS_{BASE} * ethAmount * k_{BASE} / N_{p} / (erc20Amount * (k_{BASE} + k)) \\\\
        // liquidity = (amount0 * NAVPS_BASE / navps) + (amount1 * NAVPS_BASE * _op.ethAmount * K_BASE / navps / _op.erc20Amount / (K_BASE + _op.K));
        */
        uint256 amnt0MulNbaseDivN = amount0.mul(NAVPS_BASE).div(navps);
        uint256 amnt1MulNbaseEthKbase = amount1.mul(NAVPS_BASE).mul(_op.ethAmount).mul(K_BASE);
        liquidity = ( amnt0MulNbaseDivN ).add( amnt1MulNbaseEthKbase.div(navps).div(_op.erc20Amount).div(K_BASE.add(_op.K)) );
    }

    // get Net Asset Value Per Share for mint
    // only for read, could cost more gas if use it directly in contract
    function getNAVPerShareForMint(OraclePrice memory _op) public view returns (uint256 navps) {
        return calcNAVPerShareForMint(reserve0, reserve1, _op);
    }

    // get Net Asset Value Per Share for burn
    // only for read, could cost more gas if use it directly in contract
    function getNAVPerShareForBurn(OraclePrice memory _op) external view returns (uint256 navps) {
        return calcNAVPerShareForBurn(reserve0, reserve1, _op);
    }

    // get Net Asset Value Per Share
    // only for read, could cost more gas if use it directly in contract
    function getNAVPerShare(uint256 ethAmount, uint256 erc20Amount) external override view returns (uint256 navps) {
        return calcNAVPerShare(reserve0, reserve1, ethAmount, erc20Amount);
    }

    // get estimated liquidity amount (it represents the amount of pool tokens will be minted if someone provide liquidity to the pool)
    // only for read, could cost more gas if use it directly in contract
    function getLiquidity(uint256 amount0, uint256 amount1, OraclePrice memory _op) external view returns (uint256 liquidity) {
        uint256 navps = getNAVPerShareForMint(_op);
        return calcLiquidity(amount0, amount1, navps, _op);
    }

    // calc amountOut for token0 (WETH) when send liquidity token to pool for burning
    function calcOutToken0ForBurn(uint256 liquidity, OraclePrice memory _op) public view returns (uint256 amountOut, uint256 fee) {
        /*
        e &= c * (N_{p}^{'} / NAVPS_{BASE}) * (THETA_{BASE} - \theta)/THETA_{BASE} \\\\
          &= c * \frac{N_{p}^{'}}{NAVPS_{BASE}} * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
          &= c * N_{p}^{'} * (THETA_{BASE} - \theta) / NAVPS_{BASE} / THETA_{BASE} \\\\
        // amountOut = liquidity * navps * (THETA_BASE - _op.theta) / NAVPS_BASE / THETA_BASE;
        */
        uint256 navps = calcNAVPerShareForBurn(reserve0, reserve1, _op);
        amountOut = liquidity.mul(navps).mul(THETA_BASE.sub(_op.theta)).div(NAVPS_BASE).div(THETA_BASE);
        if (_op.theta != 0) {
            // fee = liquidity * navps * (_op.theta) / NAVPS_BASE / THETA_BASE;
            fee = liquidity.mul(navps).mul(_op.theta).div(NAVPS_BASE).div(THETA_BASE);
        }
        return (amountOut, fee);
    }


    // calc amountOut for token1 (ERC20 token) when send liquidity token to pool for burning
    function calcOutToken1ForBurn(uint256 liquidity, OraclePrice memory _op) public view returns (uint256 amountOut, uint256 fee) {
        /*
        u &= c * (N_{p}^{'} / NAVPS_{BASE}) * P_{s}^{'} * (THETA_{BASE} - \theta)/THETA_{BASE} \\\\
          &= c * \frac{N_{p}^{'}}{NAVPS_{BASE}} * \frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} - k)}{(k_{BASE})} * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
          &= \frac{c * N_{p}^{'} * erc20Amount * (k_{BASE} - k) * (THETA_{BASE} - \theta)}{NAVPS_{BASE}*ethAmount*k_{BASE}*THETA_{BASE}}
        // amountOut = liquidity * navps * _op.erc20Amount * (K_BASE - _op.K) * (THETA_BASE - _op.theta) / NAVPS_BASE / _op.ethAmount / K_BASE / THETA_BASE;
        */
        uint256 navps = calcNAVPerShareForBurn(reserve0, reserve1, _op);
        uint256 liqMulMany = liquidity.mul(navps).mul(_op.erc20Amount).mul(K_BASE.sub(_op.K)).mul(THETA_BASE.sub(_op.theta));
        amountOut = liqMulMany.div(NAVPS_BASE).div(_op.ethAmount).div(K_BASE).div(THETA_BASE);
        if (_op.theta != 0) {
            // fee = liquidity * navps * (_op.theta) / NAVPS_BASE / THETA_BASE;
            fee = liquidity.mul(navps).mul(_op.theta).div(NAVPS_BASE).div(THETA_BASE);
        }
        return (amountOut, fee);
    }

    // get estimated amountOut for token0 (WETH) when swapWithExact
    function calcOutToken0(uint256 amountIn, OraclePrice memory _op) public pure returns (uint256 amountOut, uint256 fee) {
        /*
        x &= (a/P_{b}^{'})*\frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
          &= a / (\frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} + k)}{(k_{BASE})}) * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
          &= \frac{a*ethAmount*k_{BASE}}{erc20Amount*(k_{BASE} + k)} * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
          &= \frac{a*ethAmount*k_{BASE}*(THETA_{BASE} - \theta)}{erc20Amount*(k_{BASE} + k)*THETA_{BASE}} \\\\
        // amountOut = amountIn * _op.ethAmount * K_BASE * (THETA_BASE - _op.theta) / _op.erc20Amount / (K_BASE + _op.K) / THETA_BASE;
        */
        amountOut = amountIn.mul(_op.ethAmount).mul(K_BASE).mul(THETA_BASE.sub(_op.theta)).div(_op.erc20Amount).div(K_BASE.add(_op.K)).div(THETA_BASE);
        if (_op.theta != 0) {
            // fee = amountIn * _op.ethAmount * K_BASE * (_op.theta) / _op.erc20Amount / (K_BASE + _op.K) / THETA_BASE;
            fee = amountIn.mul(_op.ethAmount).mul(K_BASE).mul(_op.theta).div(_op.erc20Amount).div(K_BASE.add(_op.K)).div(THETA_BASE);
        }
        return (amountOut, fee);
    }

    // get estimated amountOut for token1 (ERC20 token) when swapWithExact
    function calcOutToken1(uint256 amountIn, OraclePrice memory _op) public pure returns (uint256 amountOut, uint256 fee) {
        /*
        y &= b*P_{s}^{'}*\frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
          &= b * \frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} - k)}{(k_{BASE})} * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
          &= \frac{b*erc20Amount*(k_{BASE} - k)*(THETA_{BASE} - \theta)}{ethAmount*k_{BASE}*THETA_{BASE}} \\\\
        // amountOut = amountIn * _op.erc20Amount * (K_BASE - _op.K) * (THETA_BASE - _op.theta) / _op.ethAmount / K_BASE / THETA_BASE;
        */
        amountOut = amountIn.mul(_op.erc20Amount).mul(K_BASE.sub(_op.K)).mul(THETA_BASE.sub(_op.theta)).div(_op.ethAmount).div(K_BASE).div(THETA_BASE);
        if (_op.theta != 0) {
            // fee = amountIn * _op.theta / THETA_BASE;
            fee = amountIn.mul(_op.theta).div(THETA_BASE);
        }
        return (amountOut, fee);
    }

    // get estimate amountInNeeded for token0 (WETH) when swapForExact
    function calcInNeededToken0(uint256 amountOut, OraclePrice memory _op) public pure returns (uint256 amountInNeeded, uint256 fee) {
        // inverse of calcOutToken1
        // amountOut = amountIn.mul(_op.erc20Amount).mul(K_BASE.sub(_op.K)).mul(THETA_BASE.sub(_op.theta)).div(_op.ethAmount).div(K_BASE).div(THETA_BASE);
        amountInNeeded = amountOut.mul(_op.ethAmount).mul(K_BASE).mul(THETA_BASE).div(_op.erc20Amount).div(K_BASE.sub(_op.K)).div(THETA_BASE.sub(_op.theta));
        if (_op.theta != 0) {
            // fee = amountIn * _op.theta / THETA_BASE;
            fee = amountInNeeded.mul(_op.theta).div(THETA_BASE);
        }
        return (amountInNeeded, fee);
    }

    // get estimate amountInNeeded for token1 (ERC20 token) when swapForExact
    function calcInNeededToken1(uint256 amountOut, OraclePrice memory _op) public pure returns (uint256 amountInNeeded, uint256 fee) {
        // inverse of calcOutToken0
        // amountOut = amountIn.mul(_op.ethAmount).mul(K_BASE).mul(THETA_BASE.sub(_op.theta)).div(_op.erc20Amount).div(K_BASE.add(_op.K)).div(THETA_BASE);
        amountInNeeded = amountOut.mul(_op.erc20Amount).mul(K_BASE.add(_op.K)).mul(THETA_BASE).div(_op.ethAmount).div(K_BASE).div(THETA_BASE.sub(_op.theta));
        if (_op.theta != 0) {
            // fee = amountIn * _op.ethAmount * K_BASE * (_op.theta) / _op.erc20Amount / (K_BASE + _op.K) / THETA_BASE;
            fee = amountInNeeded.mul(_op.ethAmount).mul(K_BASE).mul(_op.theta).div(_op.erc20Amount).div(K_BASE.add(_op.K)).div(THETA_BASE);
        }
        return (amountInNeeded, fee);
    }

    function _queryOracle(address token, CoFiX_OP op, bytes memory data) internal returns (uint256, uint256, uint256, uint256, uint256) {
        return ICoFiXController(ICoFiXFactory(factory).getController()).queryOracle{value: msg.value}(token, uint8(op), data);
    }

    // Safe WETH transfer function, just in case not having enough WETH. CoFi holder will earn these fees.
    function _safeSendFeeForCoFiHolder(address _token0, uint256 _fee) internal {
        address feeReceiver = ICoFiXFactory(factory).getFeeReceiver();
        if (feeReceiver == address(0)) {
            return; // if feeReceiver not set, theta fee keeps in pair pool
        }
        _safeSendFee(_token0, feeReceiver, _fee); // transfer fee to protocol fee reward pool for CoFi holders
    }

    // Safe WETH transfer function, just in case not having enough WETH. LP will earn these fees.
    function _safeSendFeeForLP(address _token0, address _token1, uint256 _fee) internal {
        address feeVault = ICoFiXFactory(factory).getFeeVaultForLP(_token1);
        if (feeVault == address(0)) {
            return; // if fee vault not set, theta fee keeps in pair pool
        }
        _safeSendFee(_token0, feeVault, _fee); // transfer fee to protocol fee reward pool for LP
    }

    function _safeSendFee(address _token0, address _receiver, uint256 _fee) internal {
        uint256 wethBal = IERC20(_token0).balanceOf(address(this));
        if (_fee > wethBal) {
            _fee = wethBal;
        }
        if (_fee > 0) _safeTransfer(_token0, _receiver, _fee); 
    }
}

// UNI & CoFi Rocks