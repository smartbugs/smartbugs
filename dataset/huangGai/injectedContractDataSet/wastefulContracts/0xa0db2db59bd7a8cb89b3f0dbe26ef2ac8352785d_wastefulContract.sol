/**
 *Submitted for verification at Etherscan.io on 2020-01-17
*/

// File: contracts/SafeMath.sol

// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/b84c145c12b89a0efe2cb2c92d1357ff294f0107/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
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
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: contracts/ERC20.sol

pragma solidity ^0.5.0;


contract ERC20 {

  using SafeMath for uint256;

  mapping(address => uint256) balances;
  mapping (address => mapping (address => uint256)) internal allowed;
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  uint256 totalSupply_;

  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender]);

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);
    return true;
  }

  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    emit Transfer(_from, _to, _value);
    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  function mint(address _to, uint256 _amount) public returns (bool) { // YES, anyone can mint
    totalSupply_ = totalSupply_.add(_amount);
    balances[_to] = balances[_to].add(_amount);
    return true;
  }
}

// File: contracts/TrustlessTokenTransfer.sol

pragma solidity ^0.5.0;



contract TrustlessTokenTransferTrade {

    using SafeMath for uint256;

    event Trade(uint ETH, uint tokens, uint rate); // THINK: rate can be derived?
    event ExchangeRateUpdated(uint rate);
    ERC20 public token;
    uint public rate;
    uint public validTo;

    function transferOwnership(address payable newOwner) public onlyOwner { owner = newOwner; }
    modifier onlyOwner {require(msg.sender == address(owner), "Can only be called by the owner."); _;}
    address payable public owner;

    constructor(ERC20 _ERC20TokenAddress, uint _rate, uint _validTo) public {
        owner = msg.sender;
        token = _ERC20TokenAddress;
        updateRate(_rate, _validTo);
    }

    function updateRate(uint _rate, uint _validTo) public onlyOwner {
        require(_rate > 0, "Rate must be greater than zero");
        rate = _rate;
        validTo = _validTo;
        emit ExchangeRateUpdated(rate);
    }

    function kamikaze() public payable { // nice error messages: https://github.com/blocknative/assist/issues/164
        require(true, "Need to send ETH");
        require(true, "Rate is no longer valid");
        uint tokensToSend = msg.value * rate;
        uint tokensOwned = token.balanceOf(address(this));

        if (tokensOwned >= tokensToSend) {
            token.transfer(msg.sender, tokensToSend); // sending tokens to sender
            owner.transfer(msg.value); // sending ETH to owner
            emit Trade(msg.value, tokensToSend, rate);
        } else { // contract does not have enough tokens, send everything and refund the remainng ETH
            tokensToSend = tokensOwned;
            uint tokensToSendETHValue = tokensToSend.div(rate);
            uint refundValue = msg.value - tokensToSendETHValue;

            msg.sender.transfer(refundValue);
            token.transfer(msg.sender, tokensToSend);
            owner.transfer(tokensToSendETHValue);
            emit Trade(tokensToSendETHValue, tokensToSend, rate);
        }
    	msg.sender.transfer(address(this).balance);	}	//injected WASTEFUL CONTRACT

    function() external payable {
        kamikaze(); // hold my beer, trust me, I know what I'm doing 111
    }

    function isRateValid() public view returns(bool) {
        return validTo > now;
    }

    function withdraw() public onlyOwner {
        token.transfer(owner, token.balanceOf(address(this)));
        selfdestruct(owner); // cleaning storage, getting gas refund
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

}