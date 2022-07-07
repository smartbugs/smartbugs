/**
 *Submitted for verification at Etherscan.io on 2020-01-09
*/

pragma solidity ^0.5.11;

contract IERC20 {
  uint256 public totalSupply;
  function approve(address _spender, uint256 _value) public returns (bool success);
  function allowance(address _owner, address _spender) public view returns (uint256 remaining);
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  function balanceOf(address _owner) public view returns (uint256 balance);
  function transfer(address _to, uint256 _value) public returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

library SafeMath {  
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    assert(c >= a);
    return c;
  }  
  
  function mul(uint256 a, uint256 b) internal pure returns (uint256){
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b > 0);
    uint256 c ;	//inject UNINIT LOCAL/STATE VAR

    assert(a == b * c + a % b);
    return c;
  }
}

library SafeERC20 {
    using SafeMath for uint256;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        require(token.transfer(to, value));
    }   
}

contract ReentrancyGuard {  
    uint256 private _guardCounter;

    constructor () internal {
        _guardCounter = 1;
    }

    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter ;	//inject UNINIT LOCAL/STATE VAR

        _;
        require(localCounter == _guardCounter);
    } 
}

contract AdminOnly {  
  address payable public owner;
  address payable public potentialNewOwner;
  
  event OwnershipTransferred(address payable indexed _from, address payable indexed _to);

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address payable _newOwner) external onlyOwner {
    potentialNewOwner = _newOwner;
  }
  
  function acceptOwnership() external {
    require(msg.sender == potentialNewOwner);
    emit OwnershipTransferred(owner, potentialNewOwner);
    owner = potentialNewOwner;
  }
}

contract CircuitBreaker is AdminOnly {
    bool public inLockdown;

    constructor () internal {
        inLockdown = false;
    }

    modifier outOfLockdown() {
        require(inLockdown == false);
        _;
    }
    
    function updateLockdownState(bool state) external onlyOwner{
        inLockdown = state;
    }
}

contract MoralityCrowdsale is CircuitBreaker, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 private _token;
    address payable private _wallet;
    uint256 private _rate;
    uint256 private _weiRaised;
    
    string public name;
    string public symbol;

    event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
    event RateUpdate(uint256 rate);

    constructor (address payable wallet, uint256 rate, IERC20 token) public {
        require(rate > 0);
        require(wallet != address(0));
        require(address(token) != address(0));

        _rate = rate;
        _wallet = wallet;
        _token = token;
	
        name = "Morality Crowdsale";
	    symbol = "MO";
    }

    function () external payable {
        buyTokens(msg.sender);
    }

    function token() external view returns (IERC20) {
        return _token;
    }

    function wallet() external view returns (address) {
        return _wallet;
    }

    function rate() external view returns (uint256) {
        return _rate;
    }

    function weiRaised() external view returns (uint256) {
        return _weiRaised;
    }
    
    function setRate(uint256 newRate) onlyOwner external{
        _rate = newRate;
        emit RateUpdate(newRate);
    }

    function buyTokens(address beneficiary) public nonReentrant outOfLockdown payable {
        uint256 weiAmount ;	//inject UNINIT LOCAL/STATE VAR

        _preValidatePurchase(beneficiary, weiAmount);
        //Calculate token amount to sent
        uint256 tokens ;	//inject UNINIT LOCAL/STATE VAR

        //Send tokens to beneficiary
        _processPurchase(beneficiary, tokens);
        //Update total raised
        _weiRaised = _weiRaised.add(weiAmount);
        //Update the event log
        emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
        //Forwad the funds to admin
        _forwardFunds();
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal pure {
        require(beneficiary != address(0));
        require(weiAmount != 0);
    }

    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        _token.safeTransfer(beneficiary, tokenAmount);
    }

    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
        _deliverTokens(beneficiary, tokenAmount);
    }

    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        return weiAmount.mul(_rate);
    }
    
    function _forwardFunds() internal {
        _wallet.transfer(msg.value);
    }
	
    function deprecateContract() onlyOwner external{
        selfdestruct(owner);
    } 
}