/**
 *Submitted for verification at Etherscan.io on 2020-05-13
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
    address tokenS;
    address tokenB;
    address feeToken;
    uint totalFillAmountB;
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
        //require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a);

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

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.5.0;



/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
 * Originally based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 *
 * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
 * all accounts just by listening to said events. Note that this isn't required by the specification, and other
 * compliant implementations may not do it.
 */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param owner address The address which owns the funds.
     * @param spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _transfer(from, to, value);
        emit Approval(from, msg.sender, _allowed[from][msg.sender]);
        return true;
    }

    /**
     * @dev Increase the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To increment
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param addedValue The amount of tokens to increase the allowance by.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner allowed to a spender.
     * approve should be called when allowed_[_spender] == 0. To decrement
     * allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * Emits an Approval event.
     * @param spender The address which will spend the funds.
     * @param subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Transfer token for a specified addresses
    * @param from The address to transfer from.
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
        _burn(account, value);
        emit Approval(account, msg.sender, _allowed[account][msg.sender]);
    }
}

// File: contracts/market-making/sources/uniswap/UniswapExchange.sol

pragma solidity ^0.5.0;


interface IUniswapFactory {
  event NewExchange(address indexed token, address indexed exchange);

  function initializeFactory(address template) external;
  function createExchange(address token) external returns (address payable);
  function getExchange(address token) external view returns (address payable);
  function getToken(address token) external view returns (address);
  function getTokenWihId(uint256 token_id) external view returns (address);
}

interface IUniswapExchange {
  event TokenPurchase(address indexed buyer, uint256 indexed eth_sold, uint256 indexed tokens_bought);
  event EthPurchase(address indexed buyer, uint256 indexed tokens_sold, uint256 indexed eth_bought);
  event AddLiquidity(address indexed provider, uint256 indexed eth_amount, uint256 indexed token_amount);
  event RemoveLiquidity(address indexed provider, uint256 indexed eth_amount, uint256 indexed token_amount);

  function () external payable;

  function getInputPrice(uint256 input_amount, uint256 input_reserve, uint256 output_reserve) external view returns (uint256);

  function getOutputPrice(uint256 output_amount, uint256 input_reserve, uint256 output_reserve) external view returns (uint256);

  function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256);

  function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns(uint256);

  function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns(uint256);

  function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256);

  function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256);

  function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256);

  function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256);

  function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256);

  function tokenToTokenSwapInput(
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address token_addr) 
    external returns (uint256);

  function tokenToTokenTransferInput(
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address recipient, 
    address token_addr) 
    external returns (uint256);

  function tokenToTokenSwapOutput(
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address token_addr) 
    external returns (uint256);

  function tokenToTokenTransferOutput(
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address recipient, 
    address token_addr) 
    external returns (uint256);

  function tokenToExchangeSwapInput(
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address exchange_addr) 
    external returns (uint256);

  function tokenToExchangeTransferInput(
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address recipient, 
    address exchange_addr) 
    external returns (uint256);

  function tokenToExchangeSwapOutput(
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address exchange_addr) 
    external returns (uint256);

  function tokenToExchangeTransferOutput(
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address recipient, 
    address exchange_addr) 
    external returns (uint256);

  function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256);
  function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256);
  function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256);
  function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256);

  function tokenAddress() external view returns (address);
  function factoryAddress() external view returns (address);

  function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
  function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
}

contract UniswapExchange is IERC20 {

  using SafeMath for uint;

  /***********************************|
  |        Variables && Events        |
  |__________________________________*/

  // Variables
  bytes32 public name;         // Uniswap V1
  bytes32 public symbol;       // UNI-V1
  uint256 public decimals;     // 18
  IERC20 token;                // address of the IERC20 token traded on this contract
  IUniswapFactory factory;     // interface for the factory that created this contract

  uint private _totalSupply;
  mapping(address => uint) private _balances;
  mapping (address => mapping (address => uint256)) private _allowed;
  
  // Events
  event TokenPurchase(address indexed buyer, uint256 indexed eth_sold, uint256 indexed tokens_bought);
  event EthPurchase(address indexed buyer, uint256 indexed tokens_sold, uint256 indexed eth_bought);
  event AddLiquidity(address indexed provider, uint256 indexed eth_amount, uint256 indexed token_amount);
  event RemoveLiquidity(address indexed provider, uint256 indexed eth_amount, uint256 indexed token_amount);


  /***********************************|
  |            Constsructor           |
  |__________________________________*/

  /**  
   * @dev This function acts as a contract constructor which is not currently supported in contracts deployed
   *      using create_with_code_of(). It is called once by the factory during contract creation.
   */
  function setup(address token_addr) public {
    require( 
      address(factory) == address(0) && address(token) == address(0) && token_addr != address(0), 
      "INVALID_ADDRESS"
    );
    factory = IUniswapFactory(msg.sender);
    token = IERC20(token_addr);
    name = 0x556e697377617020563100000000000000000000000000000000000000000000;
    symbol = 0x554e492d56310000000000000000000000000000000000000000000000000000;
    decimals = 18;
  }


  /***********************************|
  |        Exchange Functions         |
  |__________________________________*/


  /**
   * @notice Convert ETH to Tokens.
   * @dev User specifies exact input (msg.value).
   * @dev User cannot specify minimum output or deadline.
   */
  function () external payable {
    ethToTokenInput(msg.value, 1, block.timestamp, msg.sender, msg.sender);
  }

 /**
   * @dev Pricing function for converting between ETH && Tokens.
   * @param input_amount Amount of ETH or Tokens being sold.
   * @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
   * @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
   * @return Amount of ETH or Tokens bought.
   */
  function getInputPrice(uint256 input_amount, uint256 input_reserve, uint256 output_reserve) public view returns (uint256) {
    require(input_reserve > 0 && output_reserve > 0, "INVALID_VALUE");
    uint256 input_amount_with_fee = input_amount.mul(997);
    uint256 numerator = input_amount_with_fee.mul(output_reserve);
    uint256 denominator = input_reserve.mul(1000).add(input_amount_with_fee);
    return numerator / denominator;
  }

 /**
   * @dev Pricing function for converting between ETH && Tokens.
   * @param output_amount Amount of ETH or Tokens being bought.
   * @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
   * @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
   * @return Amount of ETH or Tokens sold.
   */
  function getOutputPrice(uint256 output_amount, uint256 input_reserve, uint256 output_reserve) public view returns (uint256) {
    require(input_reserve > 0 && output_reserve > 0);
    uint256 numerator = input_reserve.mul(output_amount).mul(1000);
    uint256 denominator = (output_reserve.sub(output_amount)).mul(997);
    return (numerator / denominator).add(1);
  }

  function ethToTokenInput(uint256 eth_sold, uint256 min_tokens, uint256 deadline, address buyer, address recipient) private returns (uint256) {
    require(deadline >= block.timestamp && eth_sold > 0 && min_tokens > 0);
    uint256 token_reserve = token.balanceOf(address(this));
    uint256 tokens_bought = getInputPrice(eth_sold, address(this).balance.sub(eth_sold), token_reserve);
    require(tokens_bought >= min_tokens);
    require(token.transfer(recipient, tokens_bought));
    emit TokenPurchase(buyer, eth_sold, tokens_bought);
    return tokens_bought;
  }

  /** 
   * @notice Convert ETH to Tokens.
   * @dev User specifies exact input (msg.value) && minimum output.
   * @param min_tokens Minimum Tokens bought.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return Amount of Tokens bought.
   */ 
  function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) public payable returns (uint256) {
    return ethToTokenInput(msg.value, min_tokens, deadline, msg.sender, msg.sender);
  }

  /** 
   * @notice Convert ETH to Tokens && transfers Tokens to recipient.
   * @dev User specifies exact input (msg.value) && minimum output
   * @param min_tokens Minimum Tokens bought.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output Tokens.
   * @return  Amount of Tokens bought.
   */
  function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) public payable returns(uint256) {
    require(recipient != address(this) && recipient != address(0));
    return ethToTokenInput(msg.value, min_tokens, deadline, msg.sender, recipient);
  }

  function ethToTokenOutput(uint256 tokens_bought, uint256 max_eth, uint256 deadline, address payable buyer, address recipient) private returns (uint256) {
    require(deadline >= block.timestamp && tokens_bought > 0 && max_eth > 0);
    uint256 token_reserve = token.balanceOf(address(this));
    uint256 eth_sold = getOutputPrice(tokens_bought, address(this).balance.sub(max_eth), token_reserve);
    // Throws if eth_sold > max_eth
    uint256 eth_refund = max_eth.sub(eth_sold);
    if (eth_refund > 0) {
      buyer.transfer(eth_refund);
    }
    require(token.transfer(recipient, tokens_bought));
    emit TokenPurchase(buyer, eth_sold, tokens_bought);
    return eth_sold;
  }

  /** 
   * @notice Convert ETH to Tokens.
   * @dev User specifies maximum input (msg.value) && exact output.
   * @param tokens_bought Amount of tokens bought.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return Amount of ETH sold.
   */
  function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) public payable returns(uint256) {
    return ethToTokenOutput(tokens_bought, msg.value, deadline, msg.sender, msg.sender);
  }

  /** 
   * @notice Convert ETH to Tokens && transfers Tokens to recipient.
   * @dev User specifies maximum input (msg.value) && exact output.
   * @param tokens_bought Amount of tokens bought.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output Tokens.
   * @return Amount of ETH sold.
   */
  function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) public payable returns (uint256) {
    require(recipient != address(this) && recipient != address(0));
    return ethToTokenOutput(tokens_bought, msg.value, deadline, msg.sender, recipient);
  }

  function tokenToEthInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address buyer, address payable recipient) private returns (uint256) {
    require(deadline >= block.timestamp && tokens_sold > 0 && min_eth > 0);
    uint256 token_reserve = token.balanceOf(address(this));
    uint256 eth_bought = getInputPrice(tokens_sold, token_reserve, address(this).balance);
    uint256 wei_bought = eth_bought;
    require(wei_bought >= min_eth);
    recipient.transfer(wei_bought);
    require(token.transferFrom(buyer, address(this), tokens_sold));
    emit EthPurchase(buyer, tokens_sold, wei_bought);
    return wei_bought;
  }

  /** 
   * @notice Convert Tokens to ETH.
   * @dev User specifies exact input && minimum output.
   * @param tokens_sold Amount of Tokens sold.
   * @param min_eth Minimum ETH purchased.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return Amount of ETH bought.
   */
  function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) public returns (uint256) {
    return tokenToEthInput(tokens_sold, min_eth, deadline, msg.sender, msg.sender);
  }

  /** 
   * @notice Convert Tokens to ETH && transfers ETH to recipient.
   * @dev User specifies exact input && minimum output.
   * @param tokens_sold Amount of Tokens sold.
   * @param min_eth Minimum ETH purchased.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output ETH.
   * @return  Amount of ETH bought.
   */
  function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address payable recipient) public returns (uint256) {
    require(recipient != address(this) && recipient != address(0));
    return tokenToEthInput(tokens_sold, min_eth, deadline, msg.sender, recipient);
  }

  
  function tokenToEthOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address buyer, address payable recipient) private returns (uint256) {
    require(deadline >= block.timestamp && eth_bought > 0);
    uint256 token_reserve = token.balanceOf(address(this));
    uint256 tokens_sold = getOutputPrice(eth_bought, token_reserve, address(this).balance);
    // tokens sold is always > 0
    require(max_tokens >= tokens_sold);
    recipient.transfer(eth_bought);
    require(token.transferFrom(buyer, address(this), tokens_sold));
    emit EthPurchase(buyer, tokens_sold, eth_bought);
    return tokens_sold;
  }

  /** 
   * @notice Convert Tokens to ETH.
   * @dev User specifies maximum input && exact output.
   * @param eth_bought Amount of ETH purchased.
   * @param max_tokens Maximum Tokens sold.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return Amount of Tokens sold.
   */
  function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) public returns (uint256) {
    return tokenToEthOutput(eth_bought, max_tokens, deadline, msg.sender, msg.sender);
  }

  /**
   * @notice Convert Tokens to ETH && transfers ETH to recipient.
   * @dev User specifies maximum input && exact output.
   * @param eth_bought Amount of ETH purchased.
   * @param max_tokens Maximum Tokens sold.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output ETH.
   * @return Amount of Tokens sold.
   */
  function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address payable recipient) public returns (uint256) {
    require(recipient != address(this) && recipient != address(0));
    return tokenToEthOutput(eth_bought, max_tokens, deadline, msg.sender, recipient);
  }

  function tokenToTokenInput(
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline,
    address buyer, 
    address recipient, 
    address payable exchange_addr) 
    private returns (uint256) 
  {
    require(deadline >= block.timestamp && tokens_sold > 0 && min_tokens_bought > 0 && min_eth_bought > 0);
    require(exchange_addr != address(this) && exchange_addr != address(0));
    uint256 token_reserve = token.balanceOf(address(this));
    uint256 eth_bought = getInputPrice(tokens_sold, token_reserve, address(this).balance);
    uint256 wei_bought = eth_bought;
    require(wei_bought >= min_eth_bought);
    require(token.transferFrom(buyer, address(this), tokens_sold));
    uint256 tokens_bought = IUniswapExchange(exchange_addr).ethToTokenTransferInput.value(wei_bought)(min_tokens_bought, deadline, recipient);
    emit EthPurchase(buyer, tokens_sold, wei_bought);
    return tokens_bought;
  }

  /**
   * @notice Convert Tokens (token) to Tokens (token_addr).
   * @dev User specifies exact input && minimum output.
   * @param tokens_sold Amount of Tokens sold.
   * @param min_tokens_bought Minimum Tokens (token_addr) purchased.
   * @param min_eth_bought Minimum ETH purchased as intermediary.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param token_addr The address of the token being purchased.
   * @return Amount of Tokens (token_addr) bought.
   */
  function tokenToTokenSwapInput(
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address token_addr) 
    public returns (uint256) 
  {
    address payable exchange_addr = factory.getExchange(token_addr);
    return tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, msg.sender, exchange_addr);
  }

  /**
   * @notice Convert Tokens (token) to Tokens (token_addr) && transfers
   *         Tokens (token_addr) to recipient.
   * @dev User specifies exact input && minimum output.
   * @param tokens_sold Amount of Tokens sold.
   * @param min_tokens_bought Minimum Tokens (token_addr) purchased.
   * @param min_eth_bought Minimum ETH purchased as intermediary.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output ETH.
   * @param token_addr The address of the token being purchased.
   * @return Amount of Tokens (token_addr) bought.
   */
  function tokenToTokenTransferInput(
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address recipient, 
    address token_addr) 
    public returns (uint256) 
  {
    address payable exchange_addr = factory.getExchange(token_addr);
    return tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, recipient, exchange_addr);
  }

  function tokenToTokenOutput(
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address buyer, 
    address recipient, 
    address payable exchange_addr) 
    private returns (uint256) 
  {
    require(deadline >= block.timestamp && (tokens_bought > 0 && max_eth_sold > 0));
    require(exchange_addr != address(this) && exchange_addr != address(0));
    uint256 eth_bought = IUniswapExchange(exchange_addr).getEthToTokenOutputPrice(tokens_bought);
    uint256 token_reserve = token.balanceOf(address(this));
    uint256 tokens_sold = getOutputPrice(eth_bought, token_reserve, address(this).balance);
    // tokens sold is always > 0
    require(max_tokens_sold >= tokens_sold && max_eth_sold >= eth_bought);
    require(token.transferFrom(buyer, address(this), tokens_sold));
    uint256 eth_sold = IUniswapExchange(exchange_addr).ethToTokenTransferOutput.value(eth_bought)(tokens_bought, deadline, recipient);
    emit EthPurchase(buyer, tokens_sold, eth_bought);
    return tokens_sold;
  }

  /**
   * @notice Convert Tokens (token) to Tokens (token_addr).
   * @dev User specifies maximum input && exact output.
   * @param tokens_bought Amount of Tokens (token_addr) bought.
   * @param max_tokens_sold Maximum Tokens (token) sold.
   * @param max_eth_sold Maximum ETH purchased as intermediary.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param token_addr The address of the token being purchased.
   * @return Amount of Tokens (token) sold.
   */
  function tokenToTokenSwapOutput(
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address token_addr) 
    public returns (uint256) 
  {
    address payable exchange_addr = factory.getExchange(token_addr);
    return tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, msg.sender, exchange_addr);
  }

  /**
   * @notice Convert Tokens (token) to Tokens (token_addr) && transfers
   *         Tokens (token_addr) to recipient.
   * @dev User specifies maximum input && exact output.
   * @param tokens_bought Amount of Tokens (token_addr) bought.
   * @param max_tokens_sold Maximum Tokens (token) sold.
   * @param max_eth_sold Maximum ETH purchased as intermediary.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output ETH.
   * @param token_addr The address of the token being purchased.
   * @return Amount of Tokens (token) sold.
   */
  function tokenToTokenTransferOutput(
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address recipient, 
    address token_addr) 
    public returns (uint256) 
  {
    address payable exchange_addr = factory.getExchange(token_addr);
    return tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, recipient, exchange_addr);
  }

  /**
   * @notice Convert Tokens (token) to Tokens (exchange_addr.token).
   * @dev Allows trades through contracts that were not deployed from the same factory.
   * @dev User specifies exact input && minimum output.
   * @param tokens_sold Amount of Tokens sold.
   * @param min_tokens_bought Minimum Tokens (token_addr) purchased.
   * @param min_eth_bought Minimum ETH purchased as intermediary.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param exchange_addr The address of the exchange for the token being purchased.
   * @return Amount of Tokens (exchange_addr.token) bought.
   */
  function tokenToExchangeSwapInput(
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address payable exchange_addr) 
    public returns (uint256) 
  {
    return tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, msg.sender, exchange_addr);
  }

  /**
   * @notice Convert Tokens (token) to Tokens (exchange_addr.token) && transfers
   *         Tokens (exchange_addr.token) to recipient.
   * @dev Allows trades through contracts that were not deployed from the same factory.
   * @dev User specifies exact input && minimum output.
   * @param tokens_sold Amount of Tokens sold.
   * @param min_tokens_bought Minimum Tokens (token_addr) purchased.
   * @param min_eth_bought Minimum ETH purchased as intermediary.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output ETH.
   * @param exchange_addr The address of the exchange for the token being purchased.
   * @return Amount of Tokens (exchange_addr.token) bought.
   */
  function tokenToExchangeTransferInput(
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address recipient, 
    address payable exchange_addr) 
    public returns (uint256) 
  {
    require(recipient != address(this));
    return tokenToTokenInput(tokens_sold, min_tokens_bought, min_eth_bought, deadline, msg.sender, recipient, exchange_addr);
  }

  /**
   * @notice Convert Tokens (token) to Tokens (exchange_addr.token).
   * @dev Allows trades through contracts that were not deployed from the same factory.
   * @dev User specifies maximum input && exact output.
   * @param tokens_bought Amount of Tokens (token_addr) bought.
   * @param max_tokens_sold Maximum Tokens (token) sold.
   * @param max_eth_sold Maximum ETH purchased as intermediary.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param exchange_addr The address of the exchange for the token being purchased.
   * @return Amount of Tokens (token) sold.
   */
  function tokenToExchangeSwapOutput(
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address payable exchange_addr) 
    public returns (uint256) 
  {
    return tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, msg.sender, exchange_addr);
  }

  /**
   * @notice Convert Tokens (token) to Tokens (exchange_addr.token) && transfers
   *         Tokens (exchange_addr.token) to recipient.
   * @dev Allows trades through contracts that were not deployed from the same factory.
   * @dev User specifies maximum input && exact output.
   * @param tokens_bought Amount of Tokens (token_addr) bought.
   * @param max_tokens_sold Maximum Tokens (token) sold.
   * @param max_eth_sold Maximum ETH purchased as intermediary.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output ETH.
   * @param exchange_addr The address of the exchange for the token being purchased.
   * @return Amount of Tokens (token) sold.
   */
  function tokenToExchangeTransferOutput(
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address recipient, 
    address payable exchange_addr) 
    public returns (uint256) 
  {
    require(recipient != address(this));
    return tokenToTokenOutput(tokens_bought, max_tokens_sold, max_eth_sold, deadline, msg.sender, recipient, exchange_addr);
  }


  /***********************************|
  |         Getter Functions          |
  |__________________________________*/

  /**
   * @notice Public price function for ETH to Token trades with an exact input.
   * @param eth_sold Amount of ETH sold.
   * @return Amount of Tokens that can be bought with input ETH.
   */
  function getEthToTokenInputPrice(uint256 eth_sold) public view returns (uint256) {
    require(eth_sold > 0);
    uint256 token_reserve = token.balanceOf(address(this));
    return getInputPrice(eth_sold, address(this).balance, token_reserve);
  }

  /**
   * @notice Public price function for ETH to Token trades with an exact output.
   * @param tokens_bought Amount of Tokens bought.
   * @return Amount of ETH needed to buy output Tokens.
   */
  function getEthToTokenOutputPrice(uint256 tokens_bought) public view returns (uint256) {
    require(tokens_bought > 0);
    uint256 token_reserve = token.balanceOf(address(this));
    uint256 eth_sold = getOutputPrice(tokens_bought, address(this).balance, token_reserve);
    return eth_sold;
  }

  /**
   * @notice Public price function for Token to ETH trades with an exact input.
   * @param tokens_sold Amount of Tokens sold.
   * @return Amount of ETH that can be bought with input Tokens.
   */
  function getTokenToEthInputPrice(uint256 tokens_sold) public view returns (uint256) {
    require(tokens_sold > 0);
    uint256 token_reserve = token.balanceOf(address(this));
    uint256 eth_bought = getInputPrice(tokens_sold, token_reserve, address(this).balance);
    return eth_bought;
  }

  /**
   * @notice Public price function for Token to ETH trades with an exact output.
   * @param eth_bought Amount of output ETH.
   * @return Amount of Tokens needed to buy output ETH.
   */
  function getTokenToEthOutputPrice(uint256 eth_bought) public view returns (uint256) {
    require(eth_bought > 0);
    uint256 token_reserve = token.balanceOf(address(this));
    return getOutputPrice(eth_bought, token_reserve, address(this).balance);
  }

  /** 
   * @return Address of Token that is sold on this exchange.
   */
  function tokenAddress() public view returns (address) {
    return address(token);
  }

  /**
   * @return Address of factory that created this exchange.
   */
  function factoryAddress() public view returns (address) {
    return address(factory);
  }


  /***********************************|
  |        Liquidity Functions        |
  |__________________________________*/

  /** 
   * @notice Deposit ETH && Tokens (token) at current ratio to mint UNI tokens.
   * @dev min_liquidity does nothing when total UNI supply is 0.
   * @param min_liquidity Minimum number of UNI sender will mint if total UNI supply is greater than 0.
   * @param max_tokens Maximum number of tokens deposited. Deposits max amount if total UNI supply is 0.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return The amount of UNI minted.
   */
  function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) public payable returns (uint256) {
    require(deadline > block.timestamp && max_tokens > 0 && msg.value > 0, 'UniswapExchange#addLiquidity: INVALID_ARGUMENT');
    uint256 total_liquidity = _totalSupply;

    if (total_liquidity > 0) {
      require(min_liquidity > 0, "INVALID_MIN_LIQUIDITY");
      uint256 eth_reserve = address(this).balance.sub(msg.value);
      uint256 token_reserve = token.balanceOf(address(this));
      uint256 token_amount = (msg.value.mul(token_reserve) / eth_reserve).add(1);
      uint256 liquidity_minted = msg.value.mul(total_liquidity) / eth_reserve;
      require(max_tokens >= token_amount && liquidity_minted >= min_liquidity);
      _balances[msg.sender] = _balances[msg.sender].add(liquidity_minted);
      _totalSupply = total_liquidity.add(liquidity_minted);
      require(token.transferFrom(msg.sender, address(this), token_amount));
      emit AddLiquidity(msg.sender, msg.value, token_amount);
      emit Transfer(address(0), msg.sender, liquidity_minted);
      return liquidity_minted;

    } else {
      require(address(factory) != address(0) && address(token) != address(0) && msg.value >= 1000000000, "INVALID_VALUE");
      require(factory.getExchange(address(token)) == address(this), "INVALID_EXCHANGE");
      uint256 token_amount = max_tokens;
      uint256 initial_liquidity = address(this).balance;
      _totalSupply = initial_liquidity;
      _balances[msg.sender] = initial_liquidity;
      require(token.transferFrom(msg.sender, address(this), token_amount));
      emit AddLiquidity(msg.sender, msg.value, token_amount);
      emit Transfer(address(0), msg.sender, initial_liquidity);
      return initial_liquidity;
    }
  }

  /**
   * @dev Burn UNI tokens to withdraw ETH && Tokens at current ratio.
   * @param amount Amount of UNI burned.
   * @param min_eth Minimum ETH withdrawn.
   * @param min_tokens Minimum Tokens withdrawn.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return The amount of ETH && Tokens withdrawn.
   */
  function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) public returns (uint256, uint256) {
    require(amount > 0 && deadline > block.timestamp && min_eth > 0 && min_tokens > 0);
    uint256 total_liquidity = _totalSupply;
    require(total_liquidity > 0);
    uint256 token_reserve = token.balanceOf(address(this));
    uint256 eth_amount = amount.mul(address(this).balance) / total_liquidity;
    uint256 token_amount = amount.mul(token_reserve) / total_liquidity;
    require(eth_amount >= min_eth && token_amount >= min_tokens);

    _balances[msg.sender] = _balances[msg.sender].sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

    _totalSupply = total_liquidity.sub(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

    msg.sender.transfer(eth_amount);
    require(token.transfer(msg.sender, token_amount));
    emit RemoveLiquidity(msg.sender, eth_amount, token_amount);
    emit Transfer(msg.sender, address(0), amount);
    return (eth_amount, token_amount);
  }

  function balanceOf(address owner) public view returns (uint) {
    return _balances[owner];
  }

  function totalSupply() public view returns (uint) {
    return _totalSupply;
  }

  function allowance(address owner, address spender) public view returns (uint) {
    return _allowed[owner][spender];
  }

  function transfer(address to, uint256 value) public returns (bool) {
    _transfer(msg.sender, to, value);
    return true;
  }

  function approve(address spender, uint256 value) public returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function transferFrom(address from, address to, uint256 value) public returns (bool) {
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

    _transfer(from, to, value);
    emit Approval(from, msg.sender, _allowed[from][msg.sender]);
    return true;
  }

  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  function _transfer(address from, address to, uint256 value) internal {
    require(to != address(0));

    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);
    emit Transfer(from, to, value);
  }

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
pragma experimental ABIEncoderV2;


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
}

interface IDolomiteMarginTradingBroker {
    function brokerMarginRequestApproval(address owner, address token, uint amount) external;

    function brokerMarginGetTrader(address owner, bytes calldata orderData) external view returns (address);
}

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

interface IDepositContract {
    function perform(
        address addr,
        string calldata signature,
        bytes calldata encodedParams,
        uint value
    ) external returns (bytes memory);
}

interface IDepositContractRegistry {
    function depositAddressOf(address owner) external view returns (address payable);

    function operatorOf(address owner, address operator) external returns (bool);
}

library DepositContractHelper {

    function wrapAndTransferToken(IDepositContract self, address token, address recipient, uint amount, address wethAddress) internal {
        if (token == wethAddress) {
            uint etherBalance = address(self).balance;
            if (etherBalance > 0) wrapEth(self, token, etherBalance);
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

library RequestHelper {

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
    returns (Types.TransferRequest memory transferRequest)
    {
        require(self.requestType == Types.RequestType.Transfer, "INVALID_REQUEST_TYPE");

        (
        transferRequest.token,
        transferRequest.recipient,
        transferRequest.amount,
        transferRequest.unwrap
    ) = abi.decode(self.payload, (address, address, uint, bool));
    }
}

contract Requestable {
    using RequestHelper for Types.Request;

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

/**
 * @title DolomiteDirectV1
 * @author Zack Rubenstein from Dolomite
 *
 * Interfaces with the IDepositContractRegistry and individual 
 * IDepositContracts to enable smart-wallet functionality as well
 * as spot and margin trading on Dolomite (through Loopring & dYdX)
 */
contract DolomiteDirectV1 is Requestable, IVersionable, IDolomiteMarginTradingBroker {
    using DepositContractHelper for IDepositContract;
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
            msg.sender,
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

// File: contracts/market-making/UniswapMakerBroker.sol

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






library UniswapFactoryHelper {
    function exchangeOf(IUniswapFactory self, address token) internal returns (IUniswapExchange) {
        return IUniswapExchange(self.getExchange(token));
    }
}

/*
 * Inherits Loopring's IBrokerDelegate and sources liquidity from Uniswap
 * when the Loopring protocol requests a token approval. Because the Loopring
 * protocol expects the taker order to precede maker orders, and non-brokered
 * transfers occur before before brokered transfers, it is guaranteed that this
 * broker contract will receive the necessary tokens to trade, right before it
 * sets the approval and the Loopring protocol transfers the tokens out. Thus,
 * liquidity can be sourced on-chain with no money down!
 */
contract UniswapMakerBroker is MakerBrokerBase {
    using UniswapFactoryHelper for IUniswapFactory;

    address public wethTokenAddress;
    address public loopringDelegate;
    IUniswapFactory public uniswapFactory;

    mapping(address => address) public tokenToExchange;
    mapping(address => bool) public tokenToIsSetup;

    constructor(address _loopringDelegate, address _uniswapFactory, address _wethTokenAddress) public {
        loopringDelegate = _loopringDelegate;
        wethTokenAddress = _wethTokenAddress;
        uniswapFactory = IUniswapFactory(_uniswapFactory);
    }

    function setupToken(address token, bool setupExchange) public {
        if (setupExchange) {
            IUniswapExchange exchange = uniswapFactory.exchangeOf(token);
            ERC20(token).approve(address(exchange), uint(-1));
            tokenToExchange[token] = address(exchange);
        }
        ERC20(token).approve(loopringDelegate, uint(-1));
        tokenToIsSetup[token] = true;
    }

    function setupTokens(address[] calldata tokens, bool[] calldata setupExchanges) external {
        require(tokens.length == setupExchanges.length, "lengths do not match");

        for (uint i = 0; i < tokens.length; i++) {
            setupToken(tokens[i], setupExchanges[i]);
        }
    }

    function() external payable {
        // No op, but accepts ETH being sent to this contract.
    }

    // --------------------------------
    // Loopring Broker Delegate

    function brokerRequestAllowance(BrokerData.BrokerApprovalRequest memory request) public returns (bool) {
        require(msg.sender == loopringDelegate, "Uniswap MakerBroker: Unauthorized caller");
        require(tokenToIsSetup[request.tokenS], "Uniswap MakerBroker: tokenS is not setup yet");

        for (uint i = 0; i < request.orders.length; i++) {
            require(request.orders[i].tokenRecipient == address(this), "Uniswap MakerBroker: Order tokenRecipient must be this broker");
            require(request.orders[i].owner == owner, "Uniswap MakerBroker: Order owner must be the owner of this contract");
        }

        if (request.tokenB == wethTokenAddress) {
            // We need to convert WETH to ETH to 1) avoid double fee payment on Uniswap and 2) get the best price on Uniswap
            IWETH(wethTokenAddress).withdraw(request.totalFillAmountB);
        }

        // perform exchange
        bool isTokenBExchangeWrapper = abi.decode(request.orders[0].extraData, (bool));
        IUniswapExchange exchange;
        if (isTokenBExchangeWrapper) {
            exchange = IUniswapExchange(address(uint160(tokenToExchange[request.tokenB])));
        } else {
            exchange = IUniswapExchange(address(uint160(tokenToExchange[request.tokenS])));
        }

        (bool success, bytes memory result) = address(this).call(
            abi.encodePacked(
//                keccak256("performSwap(address,((address,bytes32,uint,uint,uint,address,bytes)[],address,address,address,uint,uint,uint),bool"),
                this.performSwap.selector,
                abi.encode(exchange, request, isTokenBExchangeWrapper)
            )
        );
        require(success, "Uniswap MakerBroker: Uniswap matching failed");
        uint exchangeAmount = abi.decode(result, (uint));

        if (request.tokenS == wethTokenAddress) {
            // Orders on Dolomite require we use WETH instead of ETH, so we must convert it back
            IWETH(wethTokenAddress).deposit.value(exchangeAmount)();
        }

        return false;
    }

    function performSwap(
        IUniswapExchange exchange,
        BrokerData.BrokerApprovalRequest memory request,
        bool isTokenBExchangeWrapper
    ) public returns (uint exchangeAmount) {
        // This fn is public so we can get access to the #selector with type-safety.
        require(msg.sender == address(this) || msg.sender == loopringDelegate, "INVALID_SENDER");

        uint deadline = block.timestamp + 1;
        if (request.tokenS == wethTokenAddress) {
            exchangeAmount = exchange.tokenToEthSwapInput(
                request.totalFillAmountB,
                request.totalRequestedAmountS,
                deadline
            );
        } else if (request.tokenB == wethTokenAddress) {
            exchangeAmount = exchange.ethToTokenSwapInput.value(request.totalFillAmountB)(
                request.totalRequestedAmountS,
                deadline
            );
        } else {
            // Pure token to token
            address tokenToBuy;
            if (isTokenBExchangeWrapper) {
                request.tokenS;
            } else {
                request.tokenB;
            }
            exchangeAmount = exchange.tokenToTokenSwapInput(
                request.totalFillAmountB,
                request.totalRequestedAmountS,
            /* minEthBoughtInWei */ 1, // We don't care about the token <-> ETH exchange rate as long as we get enough tokenB
                deadline,
                tokenToBuy
            );
        }

        return exchangeAmount;
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
        return uint(-1);
    }

}