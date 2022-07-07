/**
 *Submitted for verification at Etherscan.io on 2020-11-06
*/

pragma solidity 0.6.10;


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

contract LazarusCreators {
  using SafeMath for uint256;

  address payable internal owner;
  uint256 internal ethBalance;
  uint256 internal fee = 1;

  // mapping that stores credits for users.
  mapping(address => uint256) credits;

  constructor () public {
    owner = msg.sender; 
  }

  function getCredit () external payable {
    if (fee == 1) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(msg.value == 0.1 ether);
    } else if (fee == 2) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(msg.value == 0.25 ether);
    } else if (fee == 3) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(msg.value == 0.5 ether);
    } else if (fee == 4) {	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
      require(msg.value == 1 ether);
    }
    ethBalance = ethBalance.add(msg.value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    credits[msg.sender] = credits[msg.sender].add(1);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function setFee (uint256 _fee) public {
    require(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    fee = _fee;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function getUserCredits (address _user) public view returns (uint256) {
    return credits[_user];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function useCredit () public {
    require(credits[msg.sender] >= 1);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    credits[msg.sender] = credits[msg.sender].sub(1);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function withdrawETH () public {
    require(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    owner.transfer(ethBalance);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    ethBalance = 0;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }

  function transferOwnership (address payable _newOwner) public {
    require(msg.sender == owner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    owner = _newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
  }
}