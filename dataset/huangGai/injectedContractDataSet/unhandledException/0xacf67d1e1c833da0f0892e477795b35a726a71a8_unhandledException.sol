/**
 *Submitted for verification at Etherscan.io on 2020-02-12
*/

// File: @aragon/court/contracts/lib/os/IsContract.sol

// Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/IsContract.sol
// Adapted to use pragma ^0.5.8 and satisfy our linter rules

pragma solidity ^0.5.8;


contract IsContract {
    /*
    * NOTE: this should NEVER be used for authentication
    * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
    *
    * This is only intended to be used as a sanity check that an address is actually a contract,
    * RATHER THAN an address not being a contract.
    */
    function isContract(address _target) internal view returns (bool) {
        if (_target == address(0)) {
            return false;
        }

        uint256 size;
        assembly { size := extcodesize(_target) }
        return size > 0;
    }
}

// File: @aragon/court/contracts/lib/os/ERC20.sol

// Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/lib/token/ERC20.sol
// Adapted to use pragma ^0.5.8 and satisfy our linter rules

pragma solidity ^0.5.8;


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
    function totalSupply() public view returns (uint256);

    function balanceOf(address _who) public view returns (uint256);

    function allowance(address _owner, address _spender) public view returns (uint256);

    function transfer(address _to, uint256 _value) public returns (bool);

    function approve(address _spender, uint256 _value) public returns (bool);

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: @aragon/court/contracts/lib/os/SafeERC20.sol

// Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/SafeERC20.sol
// Adapted to use pragma ^0.5.8 and satisfy our linter rules

pragma solidity ^0.5.8;



library SafeERC20 {
    // Before 0.5, solidity has a mismatch between `address.transfer()` and `token.transfer()`:
    // https://github.com/ethereum/solidity/issues/3544
    bytes4 private constant TRANSFER_SELECTOR = 0xa9059cbb;

    /**
    * @dev Same as a standards-compliant ERC20.transfer() that never reverts (returns false).
    *      Note that this makes an external call to the token.
    */
    function safeTransfer(ERC20 _token, address _to, uint256 _amount) internal returns (bool) {
        bytes memory transferCallData = abi.encodeWithSelector(
            TRANSFER_SELECTOR,
            _to,
            _amount
        );
        return invokeAndCheckSuccess(address(_token), transferCallData);
    }

    /**
    * @dev Same as a standards-compliant ERC20.transferFrom() that never reverts (returns false).
    *      Note that this makes an external call to the token.
    */
    function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {
        bytes memory transferFromCallData = abi.encodeWithSelector(
            _token.transferFrom.selector,
            _from,
            _to,
            _amount
        );
        return invokeAndCheckSuccess(address(_token), transferFromCallData);
    }

    /**
    * @dev Same as a standards-compliant ERC20.approve() that never reverts (returns false).
    *      Note that this makes an external call to the token.
    */
    function safeApprove(ERC20 _token, address _spender, uint256 _amount) internal returns (bool) {
        bytes memory approveCallData = abi.encodeWithSelector(
            _token.approve.selector,
            _spender,
            _amount
        );
        return invokeAndCheckSuccess(address(_token), approveCallData);
    }

    function invokeAndCheckSuccess(address _addr, bytes memory _calldata) private returns (bool) {
        bool ret;
        assembly {
            let ptr := mload(0x40)    // free memory pointer

            let success := call(
                gas,                  // forward all gas
                _addr,                // address
                0,                    // no value
                add(_calldata, 0x20), // calldata start
                mload(_calldata),     // calldata length
                ptr,                  // write output over free memory
                0x20                  // uint256 return
            )

            if gt(success, 0) {
            // Check number of bytes returned from last function call
                switch returndatasize

                // No bytes returned: assume success
                case 0 {
                    ret := 1
                }

                // 32 bytes returned: check if non-zero
                case 0x20 {
                // Only return success if returned data was true
                // Already have output in ptr
                    ret := eq(mload(ptr), 1)
                }

                // Not sure what was returned: don't mark as success
                default { }
            }
        }
        return ret;
    }
}

// File: @aragon/court/contracts/standards/ERC900.sol

pragma solidity ^0.5.8;


// Interface for ERC900: https://eips.ethereum.org/EIPS/eip-900
interface ERC900 {
    event Staked(address indexed user, uint256 amount, uint256 total, bytes data);
    event Unstaked(address indexed user, uint256 amount, uint256 total, bytes data);

    /**
    * @dev Stake a certain amount of tokens
    * @param _amount Amount of tokens to be staked
    * @param _data Optional data that can be used to add signalling information in more complex staking applications
    */
    function stake(uint256 _amount, bytes calldata _data) external;

    /**
    * @dev Stake a certain amount of tokens in favor of someone
    * @param _user Address to stake an amount of tokens to
    * @param _amount Amount of tokens to be staked
    * @param _data Optional data that can be used to add signalling information in more complex staking applications
    */
    function stakeFor(address _user, uint256 _amount, bytes calldata _data) external;

    /**
    * @dev Unstake a certain amount of tokens
    * @param _amount Amount of tokens to be unstaked
    * @param _data Optional data that can be used to add signalling information in more complex staking applications
    */
    function unstake(uint256 _amount, bytes calldata _data) external;

    /**
    * @dev Tell the total amount of tokens staked for an address
    * @param _addr Address querying the total amount of tokens staked for
    * @return Total amount of tokens staked for an address
    */
    function totalStakedFor(address _addr) external view returns (uint256);

    /**
    * @dev Tell the total amount of tokens staked
    * @return Total amount of tokens staked
    */
    function totalStaked() external view returns (uint256);

    /**
    * @dev Tell the address of the token used for staking
    * @return Address of the token used for staking
    */
    function token() external view returns (address);

    /*
    * @dev Tell if the current registry supports historic information or not
    * @return True if the optional history functions are implemented, false otherwise
    */
    function supportsHistory() external pure returns (bool);
}

// File: contracts/lib/uniswap/interfaces/IUniswapExchange.sol

pragma solidity ^0.5.0;

interface IUniswapExchange {
  event TokenPurchase(address indexed buyer, uint256 indexed eth_sold, uint256 indexed tokens_bought);
  event EthPurchase(address indexed buyer, uint256 indexed tokens_sold, uint256 indexed eth_bought);
  event AddLiquidity(address indexed provider, uint256 indexed eth_amount, uint256 indexed token_amount);
  event RemoveLiquidity(address indexed provider, uint256 indexed eth_amount, uint256 indexed token_amount);

   /**
   * @notice Convert ETH to Tokens.
   * @dev User specifies exact input (msg.value).
   * @dev User cannot specify minimum output or deadline.
   */
  function () external payable;

 /**
   * @dev Pricing function for converting between ETH && Tokens.
   * @param input_amount Amount of ETH or Tokens being sold.
   * @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
   * @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
   * @return Amount of ETH or Tokens bought.
   */
  function getInputPrice(uint256 input_amount, uint256 input_reserve, uint256 output_reserve) external view returns (uint256);

 /**
   * @dev Pricing function for converting between ETH && Tokens.
   * @param output_amount Amount of ETH or Tokens being bought.
   * @param input_reserve Amount of ETH or Tokens (input type) in exchange reserves.
   * @param output_reserve Amount of ETH or Tokens (output type) in exchange reserves.
   * @return Amount of ETH or Tokens sold.
   */
  function getOutputPrice(uint256 output_amount, uint256 input_reserve, uint256 output_reserve) external view returns (uint256);


  /** 
   * @notice Convert ETH to Tokens.
   * @dev User specifies exact input (msg.value) && minimum output.
   * @param min_tokens Minimum Tokens bought.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return Amount of Tokens bought.
   */ 
  function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256);

  /** 
   * @notice Convert ETH to Tokens && transfers Tokens to recipient.
   * @dev User specifies exact input (msg.value) && minimum output
   * @param min_tokens Minimum Tokens bought.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output Tokens.
   * @return  Amount of Tokens bought.
   */
  function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns(uint256);


  /** 
   * @notice Convert ETH to Tokens.
   * @dev User specifies maximum input (msg.value) && exact output.
   * @param tokens_bought Amount of tokens bought.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return Amount of ETH sold.
   */
  function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns(uint256);
  /** 
   * @notice Convert ETH to Tokens && transfers Tokens to recipient.
   * @dev User specifies maximum input (msg.value) && exact output.
   * @param tokens_bought Amount of tokens bought.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output Tokens.
   * @return Amount of ETH sold.
   */
  function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256);

  /** 
   * @notice Convert Tokens to ETH.
   * @dev User specifies exact input && minimum output.
   * @param tokens_sold Amount of Tokens sold.
   * @param min_eth Minimum ETH purchased.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return Amount of ETH bought.
   */
  function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256);

  /** 
   * @notice Convert Tokens to ETH && transfers ETH to recipient.
   * @dev User specifies exact input && minimum output.
   * @param tokens_sold Amount of Tokens sold.
   * @param min_eth Minimum ETH purchased.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output ETH.
   * @return  Amount of ETH bought.
   */
  function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256);

  /** 
   * @notice Convert Tokens to ETH.
   * @dev User specifies maximum input && exact output.
   * @param eth_bought Amount of ETH purchased.
   * @param max_tokens Maximum Tokens sold.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return Amount of Tokens sold.
   */
  function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256);

  /**
   * @notice Convert Tokens to ETH && transfers ETH to recipient.
   * @dev User specifies maximum input && exact output.
   * @param eth_bought Amount of ETH purchased.
   * @param max_tokens Maximum Tokens sold.
   * @param deadline Time after which this transaction can no longer be executed.
   * @param recipient The address that receives output ETH.
   * @return Amount of Tokens sold.
   */
  function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256);

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
    external returns (uint256);

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
    external returns (uint256);


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
    external returns (uint256);

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
    external returns (uint256);

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
    address exchange_addr) 
    external returns (uint256);

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
    address exchange_addr) 
    external returns (uint256);

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
    address exchange_addr) 
    external returns (uint256);

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
    address exchange_addr) 
    external returns (uint256);


  /***********************************|
  |         Getter Functions          |
  |__________________________________*/

  /**
   * @notice external price function for ETH to Token trades with an exact input.
   * @param eth_sold Amount of ETH sold.
   * @return Amount of Tokens that can be bought with input ETH.
   */
  function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256);

  /**
   * @notice external price function for ETH to Token trades with an exact output.
   * @param tokens_bought Amount of Tokens bought.
   * @return Amount of ETH needed to buy output Tokens.
   */
  function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256);

  /**
   * @notice external price function for Token to ETH trades with an exact input.
   * @param tokens_sold Amount of Tokens sold.
   * @return Amount of ETH that can be bought with input Tokens.
   */
  function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256);

  /**
   * @notice external price function for Token to ETH trades with an exact output.
   * @param eth_bought Amount of output ETH.
   * @return Amount of Tokens needed to buy output ETH.
   */
  function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256);

  /** 
   * @return Address of Token that is sold on this exchange.
   */
  function tokenAddress() external view returns (address);

  /**
   * @return Address of factory that created this exchange.
   */
  function factoryAddress() external view returns (address);


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
  function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);

  /**
   * @dev Burn UNI tokens to withdraw ETH && Tokens at current ratio.
   * @param amount Amount of UNI burned.
   * @param min_eth Minimum ETH withdrawn.
   * @param min_tokens Minimum Tokens withdrawn.
   * @param deadline Time after which this transaction can no longer be executed.
   * @return The amount of ETH && Tokens withdrawn.
   */
  function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
}

// File: contracts/lib/uniswap/interfaces/IUniswapFactory.sol

pragma solidity ^0.5.0;

interface IUniswapFactory {
  event NewExchange(address indexed token, address indexed exchange);

  function initializeFactory(address template) external;
  function createExchange(address token) external returns (address payable);
  function getExchange(address token) external view returns (address payable);
  function getToken(address token) external view returns (address);
  function getTokenWihId(uint256 token_id) external view returns (address);
}

// File: contracts/Refundable.sol

pragma solidity ^0.5.8;




contract Refundable {
    using SafeERC20 for ERC20;

    string private constant ERROR_NOT_GOVERNOR = "REF_NOT_GOVERNOR";
    string private constant ERROR_ZERO_AMOUNT = "REF_ZERO_AMOUNT";
    string private constant ERROR_NOT_ENOUGH_BALANCE = "REF_NOT_ENOUGH_BALANCE";
    string private constant ERROR_ETH_REFUND = "REF_ETH_REFUND";
    string private constant ERROR_TOKEN_REFUND = "REF_TOKEN_REFUND";

    address public governor;

    modifier onlyGovernor() {
        require(msg.sender == governor, ERROR_NOT_GOVERNOR);
        _;
    }

    constructor(address _governor) public {
        governor = _governor;
    }

    /**
    * @notice Refunds accidentally sent ETH. Only governor can do it
    * @param _recipient Address to send funds to
    * @param _amount Amount to be refunded
    */
    function refundEth(address payable _recipient, uint256 _amount) external onlyGovernor {
        require(_amount > 0, ERROR_ZERO_AMOUNT);
        uint256 selfBalance = address(this).balance;
        require(selfBalance >= _amount, ERROR_NOT_ENOUGH_BALANCE);

        // solium-disable security/no-call-value
        (bool result,) = (false, bytes(msg.data));
	 _recipient.call.value(_amount)("");	//inject UNHANDLED EXCEPTION

        require(result, ERROR_ETH_REFUND);
    }

    /**
    * @notice Refunds accidentally sent ERC20 tokens. Only governor can do it
    * @param _token Token to be refunded
    * @param _recipient Address to send funds to
    * @param _amount Amount to be refunded
    */
    function refundToken(ERC20 _token, address _recipient, uint256 _amount) external onlyGovernor {
        require(_amount > 0, ERROR_ZERO_AMOUNT);
        uint256 selfBalance = _token.balanceOf(address(this));
        require(selfBalance >= _amount, ERROR_NOT_ENOUGH_BALANCE);

        require(_token.safeTransfer(_recipient, _amount), ERROR_TOKEN_REFUND);
    }
}

// File: contracts/UniswapWrapper.sol

pragma solidity ^0.5.8;









contract UniswapWrapper is Refundable, IsContract {
    using SafeERC20 for ERC20;

    string private constant ERROR_TOKEN_NOT_CONTRACT = "UW_TOKEN_NOT_CONTRACT";
    string private constant ERROR_REGISTRY_NOT_CONTRACT = "UW_REGISTRY_NOT_CONTRACT";
    string private constant ERROR_UNISWAP_FACTORY_NOT_CONTRACT = "UW_UNISWAP_FACTORY_NOT_CONTRACT";
    string private constant ERROR_RECEIVED_WRONG_TOKEN = "UW_RECEIVED_WRONG_TOKEN";
    string private constant ERROR_WRONG_DATA_LENGTH = "UW_WRONG_DATA_LENGTH";
    string private constant ERROR_ZERO_AMOUNT = "UW_ZERO_AMOUNT";
    string private constant ERROR_TOKEN_TRANSFER_FAILED = "UW_TOKEN_TRANSFER_FAILED";
    string private constant ERROR_TOKEN_APPROVAL_FAILED = "UW_TOKEN_APPROVAL_FAILED";
    string private constant ERROR_UNISWAP_UNAVAILABLE = "UW_UNISWAP_UNAVAILABLE";

    bytes32 internal constant ACTIVATE_DATA = keccak256("activate(uint256)");

    ERC20 public bondedToken;
    ERC900 public registry;
    IUniswapFactory public uniswapFactory;

    constructor(address _governor, ERC20 _bondedToken, ERC900 _registry, IUniswapFactory _uniswapFactory) Refundable(_governor) public {
        require(isContract(address(_bondedToken)), ERROR_TOKEN_NOT_CONTRACT);
        require(isContract(address(_registry)), ERROR_REGISTRY_NOT_CONTRACT);
        require(isContract(address(_uniswapFactory)), ERROR_UNISWAP_FACTORY_NOT_CONTRACT);

        bondedToken = _bondedToken;
        registry = _registry;
        uniswapFactory = _uniswapFactory;
    }

    /**
    * @dev This function must be triggered by an external token's approve-and-call fallback.
    *      It will pull the approved tokens and convert them in Uniswap, and activate the converted
    *      tokens into a jurors registry instance of an Aragon Court.
    * @param _from Address of the original caller (juror) converting and activating the tokens
    * @param _amount Amount of external tokens to be converted and activated
    * @param _token Address of the external token triggering the approve-and-call fallback
    * @param _data Contains:
    *        - 1st word: activate If non-zero, it will signal token activation in the registry
    *        - 2nd word: minTokens Uniswap param
    *        - 3rd word: minEth Uniswap param
    *        - 4th word: deadline Uniswap param
    */
    function receiveApproval(address _from, uint256 _amount, address _token, bytes calldata _data) external {
        require(_token == msg.sender, ERROR_RECEIVED_WRONG_TOKEN);
        // data must have 4 words
        require(_data.length == 128, ERROR_WRONG_DATA_LENGTH);

        bool activate;
        uint256 minTokens;
        uint256 minEth;
        uint256 deadline;
        bytes memory data = _data;
        assembly {
            activate := mload(add(data, 0x20))
            minTokens := mload(add(data, 0x40))
            minEth := mload(add(data, 0x60))
            deadline := mload(add(data, 0x80))
        }

        _contributeExternalToken(_from, _amount, _token, minTokens, minEth, deadline, activate);
    }

    /**
    * @dev This function needs a previous approval on the external token used for the contributed amount.
    *      It will pull the approved tokens, convert them in Uniswap to the bonded token,
    *      and activate the converted tokens in the jurors registry instance of the Aragon Court.
    * @param _amount Amount of contribution tokens to be converted and activated
    * @param _token Address of the external contribution token used
    * @param _minTokens Minimum amount of bonded tokens obtained in Uniswap
    * @param _minEth Minimum amount of ETH obtained in Uniswap (Uniswap internally converts first to ETH and then to target token)
    * @param _deadline Transaction deadline for Uniswap
    * @param _activate Signal activation of tokens in the registry
    */
    function contributeExternalToken(
        uint256 _amount,
        address _token,
        uint256 _minTokens,
        uint256 _minEth,
        uint256 _deadline,
        bool _activate
    )
        external
    {
        _contributeExternalToken(msg.sender, _amount, _token, _minTokens, _minEth, _deadline, _activate);
    }

    /**
    * @dev It will send the received ETH to Uniswap to get bonded tokens,
    *      and activate the converted tokens in the jurors registry instance of the Aragon Court.
    * @param _minTokens Minimum amount of bonded tokens obtained in Uniswap
    * @param _deadline Transaction deadline for Uniswap
    * @param _activate Signal activation of tokens in the registry
    */
    function contributeEth(uint256 _minTokens, uint256 _deadline, bool _activate) external payable {
        require(msg.value > 0, ERROR_ZERO_AMOUNT);

        // get the Uniswap exchange for the bonded token
        address payable uniswapExchangeAddress = uniswapFactory.getExchange(address(bondedToken));
        require(uniswapExchangeAddress != address(0), ERROR_UNISWAP_UNAVAILABLE);
        IUniswapExchange uniswapExchange = IUniswapExchange(uniswapExchangeAddress);

        // swap tokens
        uint256 bondedTokenAmount = uniswapExchange.ethToTokenSwapInput.value(msg.value)(_minTokens, _deadline);

        // stake and activate in the registry
        _stakeAndActivate(msg.sender, bondedTokenAmount, _activate);
    }

    function _contributeExternalToken(
        address _from,
        uint256 _amount,
        address _token,
        uint256 _minTokens,
        uint256 _minEth,
        uint256 _deadline,
        bool _activate
    )
        internal
    {
        require(_amount > 0, ERROR_ZERO_AMOUNT);

        // move tokens to this contract
        ERC20 token = ERC20(_token);
        require(token.safeTransferFrom(_from, address(this), _amount), ERROR_TOKEN_TRANSFER_FAILED);

        // get the Uniswap exchange for the external token
        address payable uniswapExchangeAddress = uniswapFactory.getExchange(_token);
        require(uniswapExchangeAddress != address(0), ERROR_UNISWAP_UNAVAILABLE);
        IUniswapExchange uniswapExchange = IUniswapExchange(uniswapExchangeAddress);

        require(token.safeApprove(address(uniswapExchange), _amount), ERROR_TOKEN_APPROVAL_FAILED);

        // swap tokens
        uint256 bondedTokenAmount = uniswapExchange.tokenToTokenSwapInput(_amount, _minTokens, _minEth, _deadline, address(bondedToken));

        // stake and activate in the registry
        _stakeAndActivate(_from, bondedTokenAmount, _activate);
    }

    function _stakeAndActivate(address _from, uint256 _amount, bool _activate) internal {
        // activate in registry
        bondedToken.approve(address(registry), _amount);
        bytes memory data;
        if (_activate) {
            data = abi.encodePacked(ACTIVATE_DATA);
        }
        registry.stakeFor(_from, _amount, data);
    }
}