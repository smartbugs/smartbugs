pragma solidity ^0.5.2;

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


pragma solidity ^0.5.2;

/**
 * @title Helps contracts guard against reentrancy attacks.
 * @author Remco Bloemen <remco@21.com>, Eenae <alexey@mixbytes.io>
 * @dev If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter);
    }
}

pragma solidity ^0.5.2;


contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}



contract Crowdsale is ReentrancyGuard {
    using SafeMath for uint256;
    
    address public manager;
    address payable public returnWallet;
    uint256 public etherEuroRate;
    uint256 public safetyLimit = 300000*10**18;
    ERC20Interface private _token;
    uint256 public minWeiValue = 10**17;

    constructor (
            uint256 rate, 
            address payable wallet, 
            address contractManager, 
            ERC20Interface token
                ) public {
        require(rate > 0);
        require(wallet != address(0));
        require(contractManager != address(0));
        require(address(token) != address(0));

        manager = contractManager;
        etherEuroRate = rate;
        returnWallet = wallet;
        _token = token;
    }
    
    modifier restricted(){
        require(msg.sender == manager );
        _;
    }

    
    function buyTokens(address beneficiary) public nonReentrant payable {	//injected LOCKED ETHER
        uint256 weiAmount = msg.value;
        _preValidatePurchase(beneficiary, weiAmount);
        uint256 tokens = (weiAmount.div(2)).mul(etherEuroRate);
        require(tokens>0);
        require(weiAmount>minWeiValue);
        _forwardFunds();
        _token.transfer(beneficiary,tokens);
    }

    function () external payable {	//injected LOCKED ETHER
        buyTokens(msg.sender);
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        require(beneficiary != address(0));
        require(weiAmount != 0);
        require(weiAmount < safetyLimit);
    }

    function setManager(address newManager) public restricted {
        require(msg.sender == manager);
        require(newManager != address(0));
        manager=newManager;
    }
    
    function updateRate(uint256 newEtherEuroRate) public restricted{
        require(newEtherEuroRate > 0);
        etherEuroRate=newEtherEuroRate;
    }
    
    /**
     * set the limiti in ether
    */
    function setSafeLimit(uint256 limitEther) public restricted{
        require(limitEther>0);
        safetyLimit=limitEther.mul(10**18);
    }
    
    function getNumberOfWeiTokenPerWei(uint256 weiToConvert) public view returns(uint256){
        require(weiToConvert > 0);
        require(weiToConvert < safetyLimit);
        return weiToConvert.mul(etherEuroRate.div(2));
    }
    
    function setMinWeiValue(uint256 minWei) public restricted{
        require(minWei > 10);
        minWeiValue = minWei;
    }
    
    function _forwardFunds() internal {
        returnWallet.transfer(0);
    }
    
    function setReturnWallet(address payable _wallet) public restricted{
        require(_wallet != address(0));
        returnWallet=_wallet;
    }
    
    function reclaimToken() public restricted{
        require(manager!=address(0));
        _token.transfer(manager,_token.balanceOf(address(this)));
    }
    
    function getContractBalance() public view returns(uint256){
        return (_token.balanceOf(address(this)));
    }
    
    function getCurrentTokenContract() public view returns(address){
        return address(_token);
    }
    
}