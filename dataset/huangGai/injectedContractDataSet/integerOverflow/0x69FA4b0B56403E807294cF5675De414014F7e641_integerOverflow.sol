/**
 *Submitted for verification at Etherscan.io on 2020-07-12
*/

// SPDX-License-Identifier: GPLv3

/**
  Note that this is contract is not under the MIT license. While this is still open source code,
  there are still limitations when using this contract.
 */

pragma solidity 0.6.11;

// This contract defines the staking functionality for use within Triatic with the Triatic native token (TRA)
// You are not authorized to use this contract with proper attribution.
// If you see this comment in another project, it means that that project has yet to request permission to use this contract.

// 2020 Triatic. All Rights Reserved.


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
        uint256 c = a + b;
        //require(c >= a, "SafeMath: addition overflow");

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
        uint256 c = a - b;

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

        uint256 c = a * b;
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
        uint256 c = a / b;
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

contract Staking {
  // THIS STAKING CONTRACT IS PART OF TRIATIC SOURCE CODE.
  // DO NOT COPY WITHOUT PROPER ATTRIBUTION.
  using SafeMath for uint256;

  mapping (address => uint256) public _StakeAmounts;
  mapping (address => uint256) public _AccoutNonce;
  mapping (address => bytes32[]) public _Hashes;
  mapping (address => mapping(bytes32 => uint256)) public _HashToTime;
  mapping (address => mapping(bytes32 => uint256)) public _HashToAmount;
  // 15P/A
  uint256 public _interestRate = 15;
  address public _owner;
  address public _TRAAddress;

  TRA public _TRAContract;

  // Constructor sets the address of the token
  constructor() public {
    _owner = msg.sender;
    _TRAAddress = address(0);
    _TRAContract = TRA(_TRAAddress);

  }
  event log(address owner,uint256 amount);
  // Changes the token contract, and sets the interface to that token contract
  function SetTRAAddress(address TRAAddress) public {
    require(msg.sender == _owner,"Only owners can change the TRA address");
    _TRAAddress = TRAAddress;
    _TRAContract = TRA(_TRAAddress);
  }

  // Stake: Transfers x amount TRA to this contract.
  // The user needs to approve this contract
  function Stake(uint256 amount) public returns(bytes32) {
    _StakeAmounts[msg.sender] = _StakeAmounts[msg.sender].add(amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

    // Get the nonce.
    uint256 nonce = _AccoutNonce[msg.sender];
    // Generate a staking hash for the user.
    bytes32 stakingHash = keccak256(abi.encode(msg.sender,nonce,amount));
    // Store the hashes in a list and amount for easy retrieval
    bytes32[] storage hashList = _Hashes[msg.sender];
    hashList.push(stakingHash);
    
    // Store all amounts for calculations.
    _HashToTime[msg.sender][stakingHash] = block.timestamp;
    _HashToAmount[msg.sender][stakingHash] = amount;
    _AccoutNonce[msg.sender] = _AccoutNonce[msg.sender].add(1);
    _TRAContract.transferFrom(msg.sender,address(this),amount);
    return stakingHash;
  }

  // GetStakes: Return all staking transactions
  function GetStakes(address account) public view returns (bytes32[] memory) {
    bytes32[] memory hashList = _Hashes[account];
    return hashList;
  }

  // Unstake: Unstake x amount TRA from this contract
  // Sends back to the user
  function UnstakeAll() public {
    uint256 _totalStaked = _StakeAmounts[msg.sender];
    _StakeAmounts[msg.sender] = 0;
    uint256 interest = CalculateInterest(msg.sender);
    
    // Empty the array
    delete _Hashes[msg.sender];

    // Interest is deducted from the staking pool's balance
    _TRAContract.transfer(msg.sender,_totalStaked.add(interest));
  }

  function GetStakingBalance(address owner) public view returns (uint256) {
    return _StakeAmounts[owner];
  }

  function CalculateInterestForStake(address owner,bytes32 stakeHash) public view returns(uint256) {
    mapping(bytes32 => uint256) storage times = _HashToTime[owner];
    mapping(bytes32 => uint256) storage amounts = _HashToAmount[owner];
    
    uint256 timeStaked = times[stakeHash];
    uint256 amountStaked = amounts[stakeHash];
    uint256 timeElapsed = block.timestamp.sub(timeStaked);
    uint256 numerator = amountStaked.mul(_interestRate).mul(timeElapsed);
    uint256 denominator = 100 * 31556952;
    uint256 interestEarned = numerator / denominator;
    return interestEarned;
  }

  function CalculateInterest(address owner) public view returns(uint256) {
    // First lets get the list of staking hashes of for the owner
    bytes32[] storage hashList = _Hashes[owner];
    mapping(bytes32 => uint256) storage times = _HashToTime[owner];
    mapping(bytes32 => uint256) storage amounts = _HashToAmount[owner];
    uint256 interest = 0;
    for(uint256 i = 0;i<hashList.length;i++) {
      // Get the time elapsed from the hash and amount associated with that transaction hash
      uint256 timeStaked = times[hashList[i]];
      uint256 amountStaked = amounts[hashList[i]];
      uint256 timeElapsed = block.timestamp.sub(timeStaked);
      uint256 numerator = amountStaked.mul(_interestRate).mul(timeElapsed);
      uint256 denominator = 100 * 31556952;
      uint256 interestEarned = numerator / denominator;
      interest = interest.add(interestEarned);
    }
    return interest;
  }
}