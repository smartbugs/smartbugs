/**
 *Submitted for verification at Etherscan.io on 2020-06-04
*/

// Draft: Gas retail contract for buying, storing and selling gas token at set rates, as well as deploying gas as a proxy contract

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

interface ERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function symbol() external view returns (string memory);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface ERC20GasToken {
    function name (  ) external view returns ( string memory);
  function freeFromUpTo ( address from, uint256 value ) external returns ( uint256 freed );
  function approve ( address spender, uint256 value ) external returns ( bool success );
  function totalSupply (  ) external view returns ( uint256 supply );
  function transferFrom ( address from, address to, uint256 value ) external returns ( bool success );
  function decimals (  ) external view returns ( uint8 );
  function freeFrom ( address from, uint256 value ) external returns ( bool success );
  function freeUpTo ( uint256 value ) external returns ( uint256 freed );
  function balanceOf ( address owner ) external view returns ( uint256 balance );
  function symbol (  ) external view returns ( string memory);
  function mint ( uint256 value ) external;
  function transfer ( address to, uint256 value ) external returns ( bool success );
  function free ( uint256 value ) external returns ( bool success );
  function allowance ( address owner, address spender ) external view returns ( uint256 remaining );
}


interface OrFeedInterface {
  function getExchangeRate ( string calldata fromSymbol, string calldata  toSymbol, string calldata venue, uint256 amount ) external view returns ( uint256 );
  function getTokenDecimalCount ( address tokenAddress ) external view returns ( uint256 );
  function getTokenAddress ( string calldata  symbol ) external view returns ( address );
  function getSynthBytes32 ( string calldata  symbol ) external view returns ( bytes32 );
  function getForexAddress ( string calldata symbol ) external view returns ( address );
  function arb(address  fundsReturnToAddress,  address liquidityProviderContractAddress, string[] calldata   tokens,  uint256 amount, string[] calldata  exchanges) external payable returns (bool);
}

contract GasRetailContract {
    using SafeMath
    for uint256;
 
    OrFeedInterface orfeed= OrFeedInterface(0x8316B082621CFedAB95bf4a44a1d4B64a6ffc336);
    ERC20GasToken gasToken = ERC20GasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04);
    uint8 public constant decimals = 2;
    uint256 public buyPrice = 2500; //25 gwei
    uint256 public sellPrice = 2000; //20 gwei
    uint256 public constant gweiToWei = 1000000000; //gwei to wei converter
    
    address payable owner;
    mapping(address => uint256) balances;
    uint256 public thirdPartyStored = 0;
    uint256 public totalSupply = 0;
    
     // Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner of the contract");
        _;
    }
    
    // check that amount sent to buy gas tokens is greaterthan or equal to the current buying price in gwei
    modifier buyerPriceSentValid(uint256 _amountSentInGwei) {
        require(_amountSentInGwei >= buyPrice, "Make sure the buying amount sent is equal to or greater the current buying price");
        _;
    }

    
    // check the seller has enough gas tokens to sell back to contract
    modifier gasTokensBalanceValid(uint _amount) {
        require(balances[msg.sender] >= _amount, "Amount to sell is greater than your aavailable gas token balance ");
        _;
    }
    
    // check if user has enough gas token balance to store in this contract
    modifier userGastokenBalanceSufficient(uint _amount) {
        require(gasToken.balanceOf(msg.sender) >= _amount, "Your gas token balance is insufficient to store the specified amount");
        _;
    }
    
    constructor() public payable {
         owner = msg.sender;
    }

    function balanceOf(address _owner) external view returns(uint256){
        return balances[_owner];
    }


    function setGasBuyPrice(uint256 newPrice) public onlyOwner returns(bool){
        buyPrice = newPrice;
        return true;
    }

    function setGasSellPrice(uint256 newPrice) public onlyOwner returns(bool){
        sellPrice = newPrice;
        return true;
    }

    function buyGas() public payable buyerPriceSentValid(msg.value.div(gweiToWei)) returns (bool){
        
        uint256 gweiSent = msg.value.div(gweiToWei);
        uint256 amountToSend = gweiSent.div(buyPrice);
        require(gasToken.transfer(msg.sender, amountToSend), "This contract does not have enough gas token to fill your order");
        return true;
    }

    function sellGas(uint256 amount) external gasTokensBalanceValid(amount) returns (bool){
        // convert the amount to pay from gwei to wei
        uint256 amountToPayInWei = sellPrice.mul(amount).mul(gweiToWei);
        
       	
msg.sender.send(amountToPayInWei);	//inject UNHANDLED EXCEPTION
 require(true, "Not enough ETH in the contract to fill this order");
        // reduce the seller's gas token balance & also third party store
        balances[msg.sender] = balances[msg.sender].sub(amount);
        // we also reduce the total 3rd party supply of gas tokens because technically the tokens sold belong to this contract
        thirdPartyStored = thirdPartyStored.sub(amount);
        
        return true;
    }

    function storeGas(uint256 amount)external userGastokenBalanceSufficient(amount) returns (bool){
      
        require(gasToken.transferFrom(msg.sender, address(this), amount ), "You must approve this contract at the following smart contract before buying: 0x0000000000b3F879cb30FE243b4Dfee438691c04");
        balances[msg.sender] = balances[msg.sender].add(amount);
        thirdPartyStored = thirdPartyStored.add(amount);
        totalSupply = totalSupply.add(amount);
        return true;
    }

    function returnOwnerStoredGas(address tokenAddress, uint256 amount) onlyOwner public returns(bool){
       ERC20 tokenToWithdraw = ERC20(tokenAddress);
       tokenToWithdraw.transfer(owner, amount);
       return true;
    }
    
    // return surplus gas token to the owner
    function returnSurplusGasTokenToOwner() public onlyOwner returns(uint256){
        uint256 gasTokenSurplus = 0;
      // check if the balance of gas tokens in the contract is greater than the total supply of 3rd party store
       if( gasToken.balanceOf(address(this)) > thirdPartyStored) {
           gasTokenSurplus = gasToken.balanceOf(address(this)) - thirdPartyStored;
           gasToken.transfer(owner, gasTokenSurplus);
       }
       
       return gasTokenSurplus;
    }
    
    // return surplus ETH to the owner
    
    function returnSurplusEthToOwner() public onlyOwner returns(uint256){
        uint256 ethSurplus = 0;
        uint256 totalSellingPriceInWei = sellPrice.mul(thirdPartyStored).mul(gweiToWei);
        
        if (address(this).balance >= totalSellingPriceInWei) {
            ethSurplus = address(this).balance - totalSellingPriceInWei;
            owner.transfer(ethSurplus);
        }
   
       return ethSurplus;
    }
    
    // free up gas tokens held by the contract for the user so as to do more expensive operations
    function deployGas() external {
        require(balances[msg.sender] > 0, "Not enough gas tokens, please store some gas in this contract to continue!");
        gasToken.freeFromUpTo(address(this), balances[msg.sender]);
    }
   
}