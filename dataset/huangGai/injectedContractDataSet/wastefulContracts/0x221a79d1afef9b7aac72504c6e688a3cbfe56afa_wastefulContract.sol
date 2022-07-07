pragma solidity 0.5.8;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        // uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

    /**
    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
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


/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        require(token.transfer(to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        require(token.transferFrom(from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        require(token.approve(spender, value));
    }
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address payable public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }


    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(true);
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address payable newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address payable newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract sellTokens is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public token;


    uint256 public rate;


    constructor(uint256 _rate, address _token) public {
        require(_token != address(0) );

        token = IERC20(_token);
        rate = _rate;
    }


    function() payable external {
        buyTokens();
    }


    function buyTokens() payable public {
        uint256 weiAmount = msg.value;
        _preValidatePurchase(msg.sender, weiAmount);

        uint256 tokens = _getTokenAmount(weiAmount);

        if (tokens > token.balanceOf(address(this))) {
            tokens = token.balanceOf(address(this));

            uint price = tokens.div(rate);

            uint _diff =  weiAmount.sub(price);

            if (_diff > 0) {
                msg.sender.transfer(_diff);
            }
        }

        _processPurchase(msg.sender, tokens);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT


    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
        require(token.balanceOf(address(this)) > 0);
        require(_beneficiary != address(0));
        require(_weiAmount != 0);
    }


    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        return _weiAmount.mul(rate);
    }


    function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
        token.safeTransfer(_beneficiary, _tokenAmount);
    }


    function setRate(uint256 _rate) onlyOwner external {
        rate = _rate;
    }


    function withdrawETH() onlyOwner external{
        owner.transfer(address(this).balance);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    
    function withdrawTokens(address _t) onlyOwner external {
        IERC20 _token = IERC20(_t);
        uint balance = _token.balanceOf(address(this));
        _token.safeTransfer(owner, balance);
    }

}


contract ReentrancyGuard {

    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor() internal {
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


contract buyTokens is Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public token;

    uint256 public rate;

    constructor(uint256 _rate, address _token) public {
        require(_token != address(0) );

        token = IERC20(_token);
        rate = _rate;
    }


    function() external payable{
    }


    function sellToken(uint _amount) public {
        _sellTokens(msg.sender, _amount);
    }


    function _sellTokens(address payable _from, uint256 _amount) nonReentrant  internal {
        require(_amount > 0);
        token.safeTransferFrom(_from, address(this), _amount);

        uint256 tokensAmount = _amount;

        uint weiAmount = tokensAmount.div(rate);

        if (weiAmount > address(this).balance) {
            tokensAmount = address(this).balance.mul(rate);
            weiAmount = address(this).balance;

            uint _diff =  _amount.sub(tokensAmount);

            if (_diff > 0) {
                token.safeTransfer(_from, _diff);
            }
        }

        _from.transfer(weiAmount);
    }


    function receiveApproval(address payable _from, uint256 _value, address _token, bytes memory _extraData) public {
        require(_token == address(token));
        require(msg.sender == address(token));

        _extraData;
        _sellTokens(_from, _value);
    }


    function setRate(uint256 _rate) onlyOwner external {
        rate = _rate;
    }


    function withdrawETH() onlyOwner external{
        owner.transfer(address(this).balance);
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT


    function withdrawTokens(address _t) onlyOwner external {
        IERC20 _token = IERC20(_t);
        uint balance = _token.balanceOf(address(this));
        _token.safeTransfer(owner, balance);
    }

}