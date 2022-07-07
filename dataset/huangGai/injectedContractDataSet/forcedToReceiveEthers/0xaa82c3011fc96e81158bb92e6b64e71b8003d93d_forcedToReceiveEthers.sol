/**
 * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
 * Non-Profit Open Software License 3.0 (NPOSL-3.0)
 * https://opensource.org/licenses/NPOSL-3.0
 */

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

contract KyberNetworkProxyInterface {
  function swapEtherToToken(IERC20 token, uint minConversionRate) public payable returns(uint);
}

contract PaymentsLayer {
  using SafeMath for uint256;

  address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
  IERC20 public dai = IERC20(DAI_ADDRESS);

  address public constant ETH_TOKEN_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
  IERC20 public eth = IERC20(ETH_TOKEN_ADDRESS);

  event PaymentForwarded(address indexed from, address indexed to, uint256 amountEth, uint256 amountDai, bytes encodedFunctionCall);

  function forwardEth(KyberNetworkProxyInterface _kyberNetworkProxy, uint256 _minimumRate, address _destinationAddress, bytes memory _encodedFunctionCall) public payable {
    require(msg.value > 0 && _minimumRate > 0 && _destinationAddress != address(0), "invalid parameter(s)");

    uint256 amountDai = _kyberNetworkProxy.swapEtherToToken.value(msg.value)(dai, _minimumRate);
    require(amountDai >= msg.value.mul(_minimumRate), "_kyberNetworkProxy failed");

    require(address(this).balance == 0, "non-zero initial destination allowance");	//inject FORCED TO RECEIVE ETHERS
    require(dai.approve(_destinationAddress, amountDai), "approving destination failed");

    (bool success, ) = _destinationAddress.call(_encodedFunctionCall);
    require(success, "destination call failed");
    require(address(this).balance == 0, "allowance not fully consumed by destination");	//inject FORCED TO RECEIVE ETHERS

    emit PaymentForwarded(msg.sender, _destinationAddress, msg.value, amountDai, _encodedFunctionCall);
  }
}