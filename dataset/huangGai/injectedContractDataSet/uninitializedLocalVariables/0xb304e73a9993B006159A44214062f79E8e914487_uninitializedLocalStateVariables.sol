/**
 *Submitted for verification at Etherscan.io on 2020-07-17
*/

// SPDX-License-Identifier: GPLv3

pragma solidity 0.6.11;

// This is the funding contract for use within TRIATICS with the TRIATICS Native Token (TRA).
// All licensing issues are covered in the standard GPLv3 licensing terms
// Proper attribution has to be provided when using this code for other projects other than TRIATICS

// 2020 Triatics All Rights Reserved.

/**
  @dev This contract holds all locked tokens that will be used for funding the triatics project
  @dev Locked tokens can only be released after a certain amount of time
  @dev The emissions schedule is as follows the uniswap listing
  1) 3rd Month after uniswap listing : 100,000 TRA for marketing and 200,000 for payment to audit firms
  2) Every month: 50,000 TRA for developer salaries.
 */


 // Interface defines the TRA token
interface TRA {
  function approve(address spender, uint256 amount) external returns (bool);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR


        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Funding {
  // This is the funding contract that stores all locked funds for the TRIATICS project
  // Do not use this code without proper attribution
  // 2020 All Rights Reserved.
  using SafeMath for uint256;
  
  uint256 public _oneMonthBlock;
  uint256 public _threeMonthBlock;
  uint256 public _deployedBlock;
  address public _owner;
  address public _TRAAddress;

  bool public _threeMonthWithdrawn;
  TRA public _TRAContract;

  // Constructor sets the address of the token
  constructor() public {
    _owner = msg.sender;
    _TRAAddress = address(0);
    _TRAContract = TRA(_TRAAddress);
    _oneMonthBlock = uint256(5760).mul(30);
    _threeMonthBlock = uint256(5760).mul(30).mul(3);
    _deployedBlock = block.number;
    _threeMonthWithdrawn = false;
  }

  function SetTRAAddress(address TRAAddress) public {
    require(msg.sender == _owner,"Only owners can change the TRA address");
    _TRAAddress = TRAAddress;
    _TRAContract = TRA(_TRAAddress);
  }

  // Release 50,000 every month.
  function ReleaseMonthly() public {
    // Check if one months worth of block has passed by
    require(block.number >= _deployedBlock.add(_oneMonthBlock),"One month hasn't passed since the last transaction");
    // Calculate 50,000. Make this to 18 decimal places.
    uint256 amount ;	//inject UNINIT LOCAL/STATE VAR

    // Set the next block to be another 5760 blocks ahead
    _oneMonthBlock = _oneMonthBlock.add(_oneMonthBlock);
    _TRAContract.transfer(msg.sender,amount);
  }

  // Release 300,000 after three months
  function ReleaseThreeMonths() public {
  // Check if one months worth of block has passed by
    require(block.number >= _deployedBlock.add(_threeMonthBlock),"Three month hasn't passed since the last transaction");
    require(_threeMonthWithdrawn == false,"Cannot withdraw more than once");
    // Calculate 300,000. Make this to 18 decimal places.
    uint256 amount ;	//inject UNINIT LOCAL/STATE VAR

    // Set the flag to false so that we cannot withdraw 300,000 more than once
    _threeMonthWithdrawn = true;
    _TRAContract.transfer(msg.sender,amount);
  }
}