/**
 *Submitted for verification at Etherscan.io on 2020-04-08
*/

// File: contracts/UniswapAdaptor.sol

pragma solidity ^0.5.16;

contract IMarketplace {
    enum ProductState {
        NotDeployed,                // non-existent or deleted
        Deployed                    // created or redeployed
    }

    enum Currency {
        DATA,                       // "token wei" (10^-18 DATA)
        USD                         // attodollars (10^-18 USD)
    }

    function getProduct(bytes32 id) public view returns (string memory name, address owner, address beneficiary, uint pricePerSecond, Currency currency, uint minimumSubscriptionSeconds, ProductState state) {}
    function getSubscription(bytes32 productId, address subscriber) public view returns (bool isValid, uint endTimestamp) {}
    function getPriceInData(uint subscriptionSeconds, uint price, Currency unit) public view returns (uint datacoinAmount) {}
    function buyFor(bytes32 productId, uint subscriptionSeconds, address recipient) public {}
}

interface IERC20Token {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
    function approve(address _spender, uint256 _value) external returns (bool success);
}



//from https://docs.uniswap.io/smart-contract-integration/interface:
contract IUniswapFactory {
    // Public Variables
    address public exchangeTemplate;
    uint256 public tokenCount;
    // Create Exchange
    function createExchange(address token) external returns (address exchange);
    // Get Exchange and Token Info
    function getExchange(address token) external view returns (address exchange);
    function getToken(address exchange) external view returns (address token);
    function getTokenWithId(uint256 tokenId) external view returns (address token);
    // Never use
    function initializeFactory(address template) external;
}
contract IUniswapExchange{
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Address of Uniswap Factory
    function factoryAddress() external view returns (address factory);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
    // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_tokens, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
    // Trade ERC20 to ERC20
    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
    // Trade ERC20 to Custom Pool
    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
    // ERC20 comaptibility for liquidity tokens
    bytes32 public name;
    bytes32 public symbol;
    uint256 public decimals;
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    // Never use
    function setup(address token_addr) external;
}

contract UniswapAdaptor {
//    using SafeMath for uint256;

    IMarketplace marketplace;
    IUniswapFactory uniswap_factory;
    IERC20Token datacoin;
    constructor(address _marketplace_address, address _uniswap_factory_address, address _datacoin_address) public {
        marketplace = IMarketplace(_marketplace_address);
        uniswap_factory = IUniswapFactory(_uniswap_factory_address);
        datacoin = IERC20Token(_datacoin_address);
    }
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
    /*
        token address 0x0 means ETH
    */
    
    //returns the amount to_tokens that would be received from an input_amount of from_tokens
    function getConversionRateInput(address from_token, address to_token, uint input_amount) public view returns (uint){
        require(from_token != to_token, "must specify different tokens ");
        uint eth_amount;
        if(from_token == address(0)){
            eth_amount = input_amount;
        }
        else{
            address from_token_exchange = uniswap_factory.getExchange(from_token);
            require(from_token_exchange != address(0), "couldnt find exchange for from_token");
            IUniswapExchange exfrom = IUniswapExchange(from_token_exchange);
            eth_amount = exfrom.getTokenToEthInputPrice(input_amount);
        }
        if(to_token == address(0)){
            return eth_amount;
        }
        else{
            address to_token_exchange = uniswap_factory.getExchange(to_token);
            require(to_token_exchange != address(0), "couldnt find exchange for to_token");
            IUniswapExchange exto = IUniswapExchange(to_token_exchange);
            return exto.getEthToTokenInputPrice(eth_amount);
        }
    }

    // returns the amount from_tokens needed to buy output_amount of to_tokens
    function getConversionRateOutput(address from_token, address to_token, uint output_amount) public view returns (uint){
        require(from_token != to_token, "must specify different tokens ");
        uint eth_amount;
        if(to_token == address(0)){
            eth_amount = output_amount;
        }
        else{
            address to_token_exchange = uniswap_factory.getExchange(to_token);
            require(to_token_exchange != address(0), "couldnt find exchange for to_token");
            IUniswapExchange exto = IUniswapExchange(to_token_exchange);
            eth_amount = exto.getEthToTokenOutputPrice(output_amount);
        }
        if(from_token == address(0)){
            return eth_amount;
        }
        else{
            address from_token_exchange = uniswap_factory.getExchange(from_token);
            require(from_token_exchange != address(0), "couldnt find exchange for from_token");
            IUniswapExchange exfrom = IUniswapExchange(from_token_exchange);
            return exfrom.getTokenToEthOutputPrice(eth_amount);
        }
    }
    

    function _getPricePerSecondData(bytes32 productId) internal view returns (uint) {
        (, address owner,, uint pricePerSecond, IMarketplace.Currency priceCurrency,,) = marketplace.getProduct(productId);
        require(owner != address(0), "not found");
        return marketplace.getPriceInData(1, pricePerSecond, priceCurrency);
    }
    function buyWithERC20(bytes32 productId, uint minSubscriptionSeconds,uint timeWindow, address erc20_address, uint amount) public {
        require(erc20_address != address(0), "use buyWithETH instead");
        uint pricePerSecondData = _getPricePerSecondData(productId);
        if(pricePerSecondData == 0x0){
            //subscription is free. return payment and subscribe
            marketplace.buyFor(productId,minSubscriptionSeconds,msg.sender);
            return;
        }
        IERC20Token fromToken = IERC20Token(erc20_address);
        require(fromToken.transferFrom(msg.sender,address(this),amount), "must pre approve token transfer");
        // use the exchange of the received token. this exchange will query its factory to find
        // the DATAcoin exchange in tokenToTokenTransferInput() in _buyWithUniswap()
        address exadd = uniswap_factory.getExchange(erc20_address);
        require(exadd != address(0), "couldnt find exchange for exchanged token");
        require(fromToken.approve(exadd, 0), "approval failed");
        require(fromToken.approve(exadd, amount), "approval failed");
        _buyWithUniswap(exadd, productId, minSubscriptionSeconds, timeWindow, pricePerSecondData, amount, erc20_address);
    }

    function buyWithETH(bytes32 productId, uint minSubscriptionSeconds,uint timeWindow) public payable{
        uint pricePerSecondData = _getPricePerSecondData(productId);
        if(pricePerSecondData == 0x0){
            //subscription is free. return payment and subscribe
            if(msg.value > 0x0){
                msg.sender.transfer(msg.value);
            }
            marketplace.buyFor(productId,minSubscriptionSeconds,msg.sender);
            return;
        }
        address exadd = uniswap_factory.getExchange(address(datacoin));
        require(true, "couldnt find exchange for DATA coin");
        _buyWithUniswap(exadd, productId, minSubscriptionSeconds, timeWindow, pricePerSecondData, msg.value, address(0));
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT
    /**
        from_token = 0x0 means ETH
     */
    function _buyWithUniswap(address exadd, bytes32 productId, uint minSubscriptionSeconds, uint timeWindow, uint pricePerSecondData, uint amount, address from_token) internal{
        uint price = mul(pricePerSecondData,minSubscriptionSeconds);
        IUniswapExchange ex = IUniswapExchange(exadd);
        uint256 datacoin_before_transfer = datacoin.balanceOf(address(this));
        // TransferInput should revert if it cant get at least 'price' amount of DATAcoin 
        uint256 received_datacoin;
        if(from_token == address(0)){
            received_datacoin = ex.ethToTokenTransferInput.value(amount)(price,now + timeWindow, address(this));
        }
        else{
            received_datacoin = ex.tokenToTokenTransferInput(amount, price, 1, now + timeWindow, address(this), address(datacoin));
        }
        require(datacoin.balanceOf(address(this)) - datacoin_before_transfer >= received_datacoin && received_datacoin >= price, "not enough datacoin received");
        require(datacoin.approve(address(marketplace),0),"approval failed");
        require(datacoin.approve(address(marketplace),received_datacoin),"approval failed");
        marketplace.buyFor(productId,received_datacoin / pricePerSecondData,msg.sender);
    }
}