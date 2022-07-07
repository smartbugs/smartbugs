/**
 *Submitted for verification at Etherscan.io on 2020-06-11
*/

// File: contracts/interfaces/ICryptoETF.sol

pragma solidity 0.6.9;

interface ICryptoETF {
    event Purchase(address customer, uint256 usdc, uint256 cetf);
    event Sell(address customer, uint256 usdc, uint256 cetf);

    function purchase(uint256 _amount, uint256 _deadline) external returns(uint256 amount);

    function sell(uint256 _amount, uint256 _deadline) external returns(uint256 amount);

    function rebalance(uint256[] calldata _ratio) external returns(bool success);

    function expectedCETF(uint256 _baseAmount) external view returns(uint256 cETF);

    function base() external view returns(address baseToken);

    function tokens() external view returns(address[] memory token);

    function ratio(address _token) external view returns(uint256 amount);
}

// File: contracts/interfaces/IUniswapV2Router01.sol

/*
 * Contract copy and pasted from uniswap github
 * https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router01.sol
 */

pragma solidity 0.6.9;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// File: contracts/interfaces/IERC20.sol

pragma solidity 0.6.9;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

// File: contracts/library/SafeMath.sol

pragma solidity 0.6.9;

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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
     */
    function sub(uint256 a, uint256 b, string memory errorMessage)
        internal
        pure
        returns (uint256)
    {
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage)
        internal
        pure
        returns (uint256)
    {
        // Solidity only automatically asserts when dividing by 0
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage)
        internal
        pure
        returns (uint256)
    {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/library/Ownable.sol

pragma solidity 0.6.9;

contract Ownable {
    address internal _owner;

    event OwnershipTransferred(
        address indexed currentOwner,
        address indexed newOwner
    );

    constructor() internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    modifier onlyOwner() {
        require(
            msg.sender == _owner,
            "Ownable : Function called by unauthorized user."
        );
        _;
    }

    function owner() external view returns (address ownerAddress) {
        ownerAddress = _owner;
    }

    function transferOwnership(address newOwner)
    public
    onlyOwner
    returns (bool success)
    {
        require(newOwner != address(0), "Ownable/transferOwnership : cannot transfer ownership to zero address");
        success = _transferOwnership(newOwner);
    }

    function renounceOwnership() external onlyOwner returns (bool success) {
        success = _transferOwnership(address(0));
    }

    function _transferOwnership(address newOwner) internal returns (bool success) {
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
        success = true;
    }
}

// File: contracts/erc20/ERC20.sol

pragma solidity 0.6.9;


abstract contract ERC20 {
    using SafeMath for uint256;

    uint256 internal _totalSupply;
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /*
   * Internal Functions for ERC20 standard logics
   */

    function _transfer(address from, address to, uint256 amount)
        internal
        returns (bool success)
    {
        _balances[from] = _balances[from].sub(
            amount,
            "ERC20/transfer : cannot transfer more than token owner balance"
        );
        _balances[to] = _balances[to].add(amount);
        emit Transfer(from, to, amount);
        success = true;
    }

    function _approve(address owner, address spender, uint256 amount)
        internal
        returns (bool success)
    {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
        success = true;
    }

    function _mint(address recipient, uint256 amount)
        internal
        returns (bool success)
    {
        _totalSupply = _totalSupply.add(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(address(0), recipient, amount);
        success = true;
    }

    function _burn(address burned, uint256 amount)
        internal
        returns (bool success)
    {
        _balances[burned] = _balances[burned].sub(
            amount,
            "ERC20Burnable/burn : Cannot burn more than user's balance"
        );
        _totalSupply = _totalSupply.sub(
            amount,
            "ERC20Burnable/burn : Cannot burn more than totalSupply"
        );
        emit Transfer(burned, address(0), amount);
        success = true;
    }

    /*
   * public view functions to view common data
   */

    function totalSupply() external view returns (uint256 total) {
        total = _totalSupply;
    }
    function balanceOf(address owner) external view returns (uint256 balance) {
        balance = _balances[owner];
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256 remaining)
    {
        remaining = _allowances[owner][spender];
    }

    /*
   * External view Function Interface to implement on final contract
   */
    function name() virtual external view returns (string memory tokenName);
    function symbol() virtual external view returns (string memory tokenSymbol);
    function decimals() virtual external view returns (uint8 tokenDecimals);

    /*
   * External Function Interface to implement on final contract
   */
    function transfer(address to, uint256 amount)
        virtual
        external
        returns (bool success);
    function transferFrom(address from, address to, uint256 amount)
        virtual
        external
        returns (bool success);
    function approve(address spender, uint256 amount)
        virtual
        external
        returns (bool success);
}

// File: contracts/CryptoETF.sol

pragma solidity 0.6.9;







contract CryptoETF is ICryptoETF, ERC20, Ownable {

    using SafeMath for uint256;

    IERC20 internal _baseToken;

    IUniswapV2Router01 internal _router;

    address[] internal _assets;
    mapping(address => uint256) internal _ratio;

    constructor(address _base, address _uniswapRouter, address[] memory _tokens, uint256[] memory _percentage) public {
        _baseToken = IERC20(_base);
        _router = IUniswapV2Router01(_uniswapRouter);
        _assets = _tokens;
        _setRatio(_percentage);
    }

    function name() external view override returns(string memory tokenName) {
        tokenName = "CryptoETF";
    }

    function symbol() external view override returns(string memory tokenSymbol) {
        tokenSymbol = "cETF";
    }

    function decimals() external view override returns(uint8 tokenDecimals) {
        tokenDecimals = 18;
    }

    function base() external view override returns(address token) {
        token = address(_baseToken);
    }

    function tokens() external view override returns(address[] memory token) {
        token = _assets;
    }

    function ratio(address _token) external view override returns(uint256 percentage) {
        percentage = _ratio[_token];
    }


    function transfer(address _to, uint256 _amount) external override returns(bool success) {
        success =  _transfer(msg.sender, _to, _amount);
    }

    function transferFrom(address _from, address _to, uint256 _amount) external override returns(bool success) {
        _transfer(_from, _to, _amount);
        _approve(_from, msg.sender, _allowances[_from][msg.sender].sub(_amount));
        success = true;
    }

    function approve(address _spender, uint256 _amount) external override returns(bool success) {
        success = _approve(msg.sender, _spender, _amount);
    }

    function purchase(uint256 _amount, uint256 _deadline) external override returns(uint256 amount){
        _baseToken.transferFrom(msg.sender, address(this), _amount);
        _baseToken.approve(address(_router), _amount);
        amount = _expectedCETF(_amount);
        for(uint256 i = 0; i < _assets.length ; i++) {
            uint256 baseIn = _getAssetExchangeInput(i, _amount);
            // TODO change expected token output
            // DO NOT use uniswap as price table
            address[] memory path = _toDynamicArray([address(_baseToken), _assets[i]]);
            _router.swapExactTokensForTokens(baseIn, 1, path, address(this), _deadline)[0];
        }

        _mint(msg.sender, amount);
        emit Purchase(msg.sender, _amount, amount);
    }

    function expectedCETF(uint256 _baseAmount) external view override returns(uint256 cETF) {
        cETF = _expectedCETF(_baseAmount);
    }

    function sell(uint256 _amount, uint256 _deadline) external override returns(uint256 amount) {
        uint256 assetValue = _getValueAsBase();
        for(uint256 i = 0; i < _assets.length; i++){
            uint256 received = _sell(i, assetValue, _amount, _deadline);
            amount = amount.add(received);
        }
        _burn(msg.sender, _amount);
        emit Sell(msg.sender, amount, _amount);
    }

    function rebalance(uint256[] calldata _percentage) external onlyOwner override returns(bool success) {
        _sellAll();
        _setRatio(_percentage);
        _buyAll();
        success = true;
    }

    function _toDynamicArray(address[2] memory array) internal pure returns(address[] memory dynamic) {
        dynamic = new address[](2);
        dynamic[0] = array[0];
        dynamic[1] = array[1];
    }

    function _sellAll() internal returns(bool success) {
        for(uint256 i = 0; i < _assets.length; i++){
            address[] memory path = _toDynamicArray([_assets[i], address(_baseToken)]);
            _router.swapExactTokensForTokens(IERC20(_assets[i]).balanceOf(address(this)), 1, path, address(this), now);
        }
        return true;
    }

    function _buyAll() internal returns(bool success) {
        for(uint256 i = 0; i < _assets.length; i++) {
            address[] memory path = _toDynamicArray([address(_baseToken), _assets[i]]);
            _router.swapExactTokensForTokens(_getAssetExchangeInput(i,_baseToken.balanceOf(address(this))), 1, path, address(this), now)[0];
        }
    }

    function _setRatio(uint256[] memory _percentage) internal returns(bool success) {
        require(_percentage.length == _assets.length, "SetRatio : Input lenght is different to asset length");
        uint256 sum;
        for(uint256 i = 0; i < _percentage.length; i++) {
            sum = sum.add(_percentage[i]);
            _ratio[_assets[i]] = _percentage[i];
        }
        require(sum == _hundred(), "SetRatio : Input does not sum to hundred");
        return true;
    }

    function _getAssetExchangeInput(uint256 _assetIndex, uint256 _amount) internal view returns(uint256 amount){
        return _amount.mul(_ratio[_assets[_assetIndex]]).div(_hundred());
    }

    function _sell(uint256 _assetIndex, uint256 _totalValue, uint256 _sellAmount, uint256 _deadline) internal returns(uint256 amount) {
        uint256 tokenIn = IERC20(_assets[_assetIndex]).balanceOf(address(this)).mul(_sellAmount).div(_totalValue);

        IERC20(_assets[_assetIndex]).approve(address(_router), tokenIn);
        // TODO change expected token output
        // DO NOT use uniswap as price table
        address[] memory path = _toDynamicArray([_assets[_assetIndex], address(_baseToken)]);
        amount = _router.swapExactTokensForTokens(tokenIn, 1, path, msg.sender, _deadline)[0];
    }

    function _getBaseToAsset(uint256 _assetIndex, uint256 _amount) internal view returns(uint256 amount) {
        return _amount.mul(_ratio[_assets[_assetIndex]]).div(_hundred());
    }

    function _hundred() internal pure returns(uint256 amount) {
        return 100*(10**18);
    }

    function _getValueAsBase() internal view returns(uint256 value) {
        // TODO change to use Chain link as price table
        for(uint256 i = 0; i < _assets.length; i++) {
            uint256 assetBalance = IERC20(_assets[i]).balanceOf(address(this));
            if(address(this).balance == 0 ){	//inject PRESENT ETHER
                continue;
            }else{
                address[] memory path = _toDynamicArray([_assets[i], address(_baseToken)]);
                uint256 baseOut = _router.getAmountsOut(assetBalance, path)[0];
                value = value.add(baseOut);
            }
        }
    }

    function _expectedCETF(uint256 _baseAmount) internal view returns(uint256 cETF) {
        if(address(this).balance == 0) {	//inject PRESENT ETHER
            cETF = _baseAmount;
        } else {
            cETF = _totalSupply.mul(_baseAmount).div(_getValueAsBase());
        }
    }
}