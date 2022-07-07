                                                                 

// File: @aragon/court/contracts/lib/os/IsContract.sol

// Brought from https://github.com/aragon/aragonOS/blob/v4.3.0/contracts/common/IsContract.sol
// Adapted to use pragma ^0.5.8 and satisfy our linter rules

pragma solidity ^0.5.8;


contract IsContract {
                                                                                                                                                                                                                                                                                                                                        
    function ISCONTRACT505(address _target) internal view returns (bool) {	//inject NONSTANDARD NAMING
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


                                                                                        
contract ERC20 {
    function TOTALSUPPLY734() public view returns (uint256);	//inject NONSTANDARD NAMING

    function BALANCEOF87(address _who) public view returns (uint256);	//inject NONSTANDARD NAMING

    function ALLOWANCE217(address _owner, address _spender) public view returns (uint256);	//inject NONSTANDARD NAMING

    function TRANSFER438(address _to, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING

    function APPROVE791(address _spender, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING

    function TRANSFERFROM747(address _from, address _to, uint256 _value) public returns (bool);	//inject NONSTANDARD NAMING

    event TRANSFER133(	//inject NONSTANDARD NAMING
        address indexed from,
        address indexed to,
        uint256 value
    );

    event APPROVAL808(	//inject NONSTANDARD NAMING
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
    bytes4 private constant transfer_selector206 = 0xa9059cbb;	//inject NONSTANDARD NAMING

                                                                                                                                                                           
    function SAFETRANSFER7(ERC20 _token, address _to, uint256 _amount) internal returns (bool) {	//inject NONSTANDARD NAMING
        bytes memory transferCallData = abi.encodeWithSelector(
            transfer_selector206,
            _to,
            _amount
        );
        return INVOKEANDCHECKSUCCESS678(address(_token), transferCallData);
    }

                                                                                                                                                                               
    function SAFETRANSFERFROM771(ERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {	//inject NONSTANDARD NAMING
        bytes memory transferFromCallData = abi.encodeWithSelector(
            _token.TRANSFERFROM747.selector,
            _from,
            _to,
            _amount
        );
        return INVOKEANDCHECKSUCCESS678(address(_token), transferFromCallData);
    }

                                                                                                                                                                          
    function SAFEAPPROVE557(ERC20 _token, address _spender, uint256 _amount) internal returns (bool) {	//inject NONSTANDARD NAMING
        bytes memory approveCallData = abi.encodeWithSelector(
            _token.APPROVE791.selector,
            _spender,
            _amount
        );
        return INVOKEANDCHECKSUCCESS678(address(_token), approveCallData);
    }

    function INVOKEANDCHECKSUCCESS678(address _addr, bytes memory _calldata) private returns (bool) {	//inject NONSTANDARD NAMING
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
    event STAKED64(address indexed user, uint256 amount, uint256 total, bytes data);	//inject NONSTANDARD NAMING
    event UNSTAKED870(address indexed user, uint256 amount, uint256 total, bytes data);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                  
    function STAKE84(uint256 _amount, bytes calldata _data) external;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                 
    function STAKEFOR84(address _user, uint256 _amount, bytes calldata _data) external;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                      
    function UNSTAKE238(uint256 _amount, bytes calldata _data) external;	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                    
    function TOTALSTAKEDFOR777(address _addr) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                            
    function TOTALSTAKED236() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                            
    function TOKEN451() external view returns (address);	//inject NONSTANDARD NAMING

                                                                                                                                                                                
    function SUPPORTSHISTORY821() external pure returns (bool);	//inject NONSTANDARD NAMING
}

// File: contracts/lib/uniswap/interfaces/IUniswapExchange.sol

pragma solidity ^0.5.0;

interface IUniswapExchange {
  event TOKENPURCHASE996(address indexed buyer, uint256 indexed eth_sold, uint256 indexed tokens_bought);	//inject NONSTANDARD NAMING
  event ETHPURCHASE686(address indexed buyer, uint256 indexed tokens_sold, uint256 indexed eth_bought);	//inject NONSTANDARD NAMING
  event ADDLIQUIDITY195(address indexed provider, uint256 indexed eth_amount, uint256 indexed token_amount);	//inject NONSTANDARD NAMING
  event REMOVELIQUIDITY507(address indexed provider, uint256 indexed eth_amount, uint256 indexed token_amount);	//inject NONSTANDARD NAMING

                                                                                                                                                            
  function () external payable;

                                                                                                                                                                                                                                                                                                                                                                 
  function GETINPUTPRICE733(uint256 input_amount, uint256 input_reserve, uint256 output_reserve) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                  
  function GETOUTPUTPRICE452(uint256 output_amount, uint256 input_reserve, uint256 output_reserve) external view returns (uint256);	//inject NONSTANDARD NAMING


                                                                                                                                                                                                                                                                                           
  function ETHTOTOKENSWAPINPUT342(uint256 min_tokens, uint256 deadline) external payable returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                          
  function ETHTOTOKENTRANSFERINPUT323(uint256 min_tokens, uint256 deadline, address recipient) external payable returns(uint256);	//inject NONSTANDARD NAMING


                                                                                                                                                                                                                                                                                          
  function ETHTOTOKENSWAPOUTPUT701(uint256 tokens_bought, uint256 deadline) external payable returns(uint256);	//inject NONSTANDARD NAMING
                                                                                                                                                                                                                                                                                                                                                                                          
  function ETHTOTOKENTRANSFEROUTPUT693(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                       
  function TOKENTOETHSWAPINPUT977(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                  
  function TOKENTOETHTRANSFERINPUT18(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                          
  function TOKENTOETHSWAPOUTPUT664(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                   
  function TOKENTOETHTRANSFEROUTPUT247(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
  function TOKENTOTOKENSWAPINPUT27(	//inject NONSTANDARD NAMING
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address token_addr) 
    external returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  function TOKENTOTOKENTRANSFERINPUT278(	//inject NONSTANDARD NAMING
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address recipient, 
    address token_addr) 
    external returns (uint256);


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function TOKENTOTOKENSWAPOUTPUT751(	//inject NONSTANDARD NAMING
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address token_addr) 
    external returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  function TOKENTOTOKENTRANSFEROUTPUT428(	//inject NONSTANDARD NAMING
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address recipient, 
    address token_addr) 
    external returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function TOKENTOEXCHANGESWAPINPUT174(	//inject NONSTANDARD NAMING
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address exchange_addr) 
    external returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
  function TOKENTOEXCHANGETRANSFERINPUT767(	//inject NONSTANDARD NAMING
    uint256 tokens_sold, 
    uint256 min_tokens_bought, 
    uint256 min_eth_bought, 
    uint256 deadline, 
    address recipient, 
    address exchange_addr) 
    external returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function TOKENTOEXCHANGESWAPOUTPUT918(	//inject NONSTANDARD NAMING
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address exchange_addr) 
    external returns (uint256);

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
  function TOKENTOEXCHANGETRANSFEROUTPUT147(	//inject NONSTANDARD NAMING
    uint256 tokens_bought, 
    uint256 max_tokens_sold, 
    uint256 max_eth_sold, 
    uint256 deadline, 
    address recipient, 
    address exchange_addr) 
    external returns (uint256);


                                                                                                                       

                                                                                                                                                                                                       
  function GETETHTOTOKENINPUTPRICE69(uint256 eth_sold) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                         
  function GETETHTOTOKENOUTPUTPRICE555(uint256 tokens_bought) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                             
  function GETTOKENTOETHINPUTPRICE162(uint256 tokens_sold) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                   
  function GETTOKENTOETHOUTPUTPRICE369(uint256 eth_bought) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                         
  function TOKENADDRESS963() external view returns (address);	//inject NONSTANDARD NAMING

                                                                       
  function FACTORYADDRESS389() external view returns (address);	//inject NONSTANDARD NAMING


                                                                                                                       

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
  function ADDLIQUIDITY566(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                            
  function REMOVELIQUIDITY718(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);	//inject NONSTANDARD NAMING
}

// File: contracts/lib/uniswap/interfaces/IUniswapFactory.sol

pragma solidity ^0.5.0;

interface IUniswapFactory {
  event NEWEXCHANGE290(address indexed token, address indexed exchange);	//inject NONSTANDARD NAMING

  function INITIALIZEFACTORY19(address template) external;	//inject NONSTANDARD NAMING
  function CREATEEXCHANGE596(address token) external returns (address payable);	//inject NONSTANDARD NAMING
  function GETEXCHANGE730(address token) external view returns (address payable);	//inject NONSTANDARD NAMING
  function GETTOKEN772(address token) external view returns (address);	//inject NONSTANDARD NAMING
  function GETTOKENWIHID451(uint256 token_id) external view returns (address);	//inject NONSTANDARD NAMING
}

// File: contracts/Refundable.sol

pragma solidity ^0.5.8;




contract Refundable {
    using SafeERC20 for ERC20;

    string private constant error_not_governor455 = "REF_NOT_GOVERNOR";	//inject NONSTANDARD NAMING
    string private constant error_zero_amount252 = "REF_ZERO_AMOUNT";	//inject NONSTANDARD NAMING
    string private constant error_not_enough_balance862 = "REF_NOT_ENOUGH_BALANCE";	//inject NONSTANDARD NAMING
    string private constant error_eth_refund150 = "REF_ETH_REFUND";	//inject NONSTANDARD NAMING
    string private constant error_token_refund409 = "REF_TOKEN_REFUND";	//inject NONSTANDARD NAMING

    address public governor;

    modifier ONLYGOVERNOR318() {	//inject NONSTANDARD NAMING
        require(msg.sender == governor, error_not_governor455);
        _;
    }

    constructor(address _governor) public {
        governor = _governor;
    }

                                                                                                                                                                               
    function REFUNDETH646(address payable _recipient, uint256 _amount) external ONLYGOVERNOR318 {	//inject NONSTANDARD NAMING
        require(_amount > 0, error_zero_amount252);
        uint256 selfBalance = address(this).balance;
        require(selfBalance >= _amount, error_not_enough_balance862);

        // solium-disable security/no-call-value
        (bool result,) = _recipient.call.value(_amount)("");
        require(result, error_eth_refund150);
    }

                                                                                                                                                                                                                                 
    function REFUNDTOKEN5(ERC20 _token, address _recipient, uint256 _amount) external ONLYGOVERNOR318 {	//inject NONSTANDARD NAMING
        require(_amount > 0, error_zero_amount252);
        uint256 selfBalance = _token.BALANCEOF87(address(this));
        require(selfBalance >= _amount, error_not_enough_balance862);

        require(_token.SAFETRANSFER7(_recipient, _amount), error_token_refund409);
    }
}

// File: contracts/UniswapWrapper.sol

pragma solidity ^0.5.8;









contract UniswapWrapper is Refundable, IsContract {
    using SafeERC20 for ERC20;

    string private constant error_token_not_contract383 = "UW_TOKEN_NOT_CONTRACT";	//inject NONSTANDARD NAMING
    string private constant error_registry_not_contract179 = "UW_REGISTRY_NOT_CONTRACT";	//inject NONSTANDARD NAMING
    string private constant error_uniswap_factory_not_contract907 = "UW_UNISWAP_FACTORY_NOT_CONTRACT";	//inject NONSTANDARD NAMING
    string private constant error_received_wrong_token364 = "UW_RECEIVED_WRONG_TOKEN";	//inject NONSTANDARD NAMING
    string private constant error_wrong_data_length344 = "UW_WRONG_DATA_LENGTH";	//inject NONSTANDARD NAMING
    string private constant error_zero_amount252 = "UW_ZERO_AMOUNT";	//inject NONSTANDARD NAMING
    string private constant error_token_transfer_failed211 = "UW_TOKEN_TRANSFER_FAILED";	//inject NONSTANDARD NAMING
    string private constant error_token_approval_failed944 = "UW_TOKEN_APPROVAL_FAILED";	//inject NONSTANDARD NAMING
    string private constant error_uniswap_unavailable264 = "UW_UNISWAP_UNAVAILABLE";	//inject NONSTANDARD NAMING

    bytes32 internal constant activate_data805 = keccak256("activate(uint256)");	//inject NONSTANDARD NAMING

    ERC20 public bondedToken;
    ERC900 public registry;
    IUniswapFactory public uniswapFactory;

    constructor(address _governor, ERC20 _bondedToken, ERC900 _registry, IUniswapFactory _uniswapFactory) Refundable(_governor) public {
        require(ISCONTRACT505(address(_bondedToken)), error_token_not_contract383);
        require(ISCONTRACT505(address(_registry)), error_registry_not_contract179);
        require(ISCONTRACT505(address(_uniswapFactory)), error_uniswap_factory_not_contract907);

        bondedToken = _bondedToken;
        registry = _registry;
        uniswapFactory = _uniswapFactory;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    function RECEIVEAPPROVAL744(address _from, uint256 _amount, address _token, bytes calldata _data) external {	//inject NONSTANDARD NAMING
        require(_token == msg.sender, error_received_wrong_token364);
        // data must have 4 words
        require(_data.length == 128, error_wrong_data_length344);

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

        _CONTRIBUTEEXTERNALTOKEN25(_from, _amount, _token, minTokens, minEth, deadline, activate);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function CONTRIBUTEEXTERNALTOKEN307(	//inject NONSTANDARD NAMING
        uint256 _amount,
        address _token,
        uint256 _minTokens,
        uint256 _minEth,
        uint256 _deadline,
        bool _activate
    )
        external
    {
        _CONTRIBUTEEXTERNALTOKEN25(msg.sender, _amount, _token, _minTokens, _minEth, _deadline, _activate);
    }

                                                                                                                                                                                                                                                                                                                                                                                                 
    function CONTRIBUTEETH468(uint256 _minTokens, uint256 _deadline, bool _activate) external payable {	//inject NONSTANDARD NAMING
        require(msg.value > 0, error_zero_amount252);

        // get the Uniswap exchange for the bonded token
        address payable uniswapExchangeAddress = uniswapFactory.GETEXCHANGE730(address(bondedToken));
        require(uniswapExchangeAddress != address(0), error_uniswap_unavailable264);
        IUniswapExchange uniswapExchange = IUniswapExchange(uniswapExchangeAddress);

        // swap tokens
        uint256 bondedTokenAmount = uniswapExchange.ETHTOTOKENSWAPINPUT342.value(msg.value)(_minTokens, _deadline);

        // stake and activate in the registry
        _STAKEANDACTIVATE532(msg.sender, bondedTokenAmount, _activate);
    }

    function _CONTRIBUTEEXTERNALTOKEN25(	//inject NONSTANDARD NAMING
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
        require(_amount > 0, error_zero_amount252);

        // move tokens to this contract
        ERC20 token = ERC20(_token);
        require(token.SAFETRANSFERFROM771(_from, address(this), _amount), error_token_transfer_failed211);

        // get the Uniswap exchange for the external token
        address payable uniswapExchangeAddress = uniswapFactory.GETEXCHANGE730(_token);
        require(uniswapExchangeAddress != address(0), error_uniswap_unavailable264);
        IUniswapExchange uniswapExchange = IUniswapExchange(uniswapExchangeAddress);

        require(token.SAFEAPPROVE557(address(uniswapExchange), _amount), error_token_approval_failed944);

        // swap tokens
        uint256 bondedTokenAmount = uniswapExchange.TOKENTOTOKENSWAPINPUT27(_amount, _minTokens, _minEth, _deadline, address(bondedToken));

        // stake and activate in the registry
        _STAKEANDACTIVATE532(_from, bondedTokenAmount, _activate);
    }

    function _STAKEANDACTIVATE532(address _from, uint256 _amount, bool _activate) internal {	//inject NONSTANDARD NAMING
        // activate in registry
        bondedToken.APPROVE791(address(registry), _amount);
        bytes memory data;
        if (_activate) {
            data = abi.encodePacked(activate_data805);
        }
        registry.STAKEFOR84(_from, _amount, data);
    }
}