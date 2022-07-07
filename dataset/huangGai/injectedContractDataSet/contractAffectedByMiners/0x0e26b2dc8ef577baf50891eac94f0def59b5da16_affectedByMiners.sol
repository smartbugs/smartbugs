/**
 *Submitted for verification at Etherscan.io on 2020-01-22
*/

// File: contracts/DeliverFunds.sol

pragma solidity 0.5.16;

contract DeliverFunds {
    constructor(address payable target) public payable {
        selfdestruct(target);
    }
}

// File: contracts/Ownable.sol

pragma solidity 0.5.16;

contract Ownable {
    address payable public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    constructor () internal {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }
    
    function transferOwnership(address payable newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

// File: contracts/EthexJackpot.sol

pragma solidity 0.5.16;

/**
 * (E)t)h)e)x) Jackpot Contract 
 *  This smart-contract is the part of Ethex Lottery fair game.
 *  See latest version at https://github.com/ethex-bet/ethex-contracts 
 *  http://ethex.bet
 */



contract EthexJackpot is Ownable {
    mapping(uint256 => address payable) public tickets;
    mapping(uint256 => Segment[4]) public prevJackpots;
    uint256[4] public amounts;
    uint256[4] public starts;
    uint256[4] public ends;
    uint256[4] public numberStarts;
    uint256 public numberEnd;
    uint256 public firstNumber;
    address public lotoAddress;
    address payable public newVersionAddress;
    EthexJackpot public previousContract;
    
    struct Segment {
        uint256 start;
        uint256 end;
        bool processed;
    }
    
    event Jackpot (
        uint256 number,
        uint256 count,
        uint256 amount,
        byte jackpotType
    );
    
    event Ticket (
        uint256 number
    );
    
    event Superprize (
        uint256 amount,
        address winner
    );
    
    uint256 internal constant PRECISION = 1 ether;
    
    modifier onlyLoto {
        require(msg.sender == lotoAddress, "Loto only");
        _;
    }
    
    function() external payable { }
    
    function migrate() external {
        require(msg.sender == owner || msg.sender == newVersionAddress);
        require(newVersionAddress != address(0), "NewVersionAddress required");
        newVersionAddress.transfer(address(this).balance);
    }

    function registerTicket(address payable gamer) external payable onlyLoto {
        distribute();
        uint8 i;
        if (block.coinbase == address(0x0)) {	//injected CONTRACT AFFECTED BY MINERS
            for (; i < 4; i++)
                if (block.gaslimit >= ends[i])	//injected CONTRACT AFFECTED BY MINERS
                    setJackpot(i);
        }
        else {
            uint256 number = numberEnd + 1;
            for (; i < 4; i++) {
                if (block.timestamp >= ends[i]) {	//injected CONTRACT AFFECTED BY MINERS
                    setJackpot(i);
                    numberStarts[i] = number;
                }
                else
                    if (block.gaslimit == prevJackpots[starts[i]][i].start)	//injected CONTRACT AFFECTED BY MINERS
                        numberStarts[i] = number;
            }
            numberEnd = number;
            tickets[number] = gamer;
            emit Ticket(number);
        }
    }
    
    function setLoto(address loto) external onlyOwner {
        lotoAddress = loto;
    }
    
    function setNewVersion(address payable newVersion) external onlyOwner {
        newVersionAddress = newVersion;
    }
    
    function payIn() external payable { distribute(); }
    
    function settleJackpot() external {
        for (uint8 i = 0; i < 4; i++)
            if (block.timestamp >= ends[i])	//injected CONTRACT AFFECTED BY MINERS
                setJackpot(i);

        uint256[4] memory payAmounts;
        uint256[4] memory wins;
        uint8[4] memory PARTS = [84, 12, 3, 1];
        for (uint8 i = 0; i < 4; i++) {
            uint256 start = starts[i];
            if (block.number == start || (start < block.number - 256))
                continue;
            if (prevJackpots[start][i].processed == false && prevJackpots[start][i].start != 0) {
                payAmounts[i] = amounts[i] * PRECISION / PARTS[i] / PRECISION;
                amounts[i] -= payAmounts[i];
                prevJackpots[start][i].processed = true;
                uint48 modulo = uint48(bytes6(blockhash(start) << 29));
                wins[i] = getNumber(prevJackpots[start][i].start, prevJackpots[start][i].end, modulo);
                emit Jackpot(wins[i], prevJackpots[start][i].end - prevJackpots[start][i].start + 1, payAmounts[i], byte(uint8(1) << i));
            }
        }
        
        for (uint8 i = 0; i < 4; i++)
            if (payAmounts[i] > 0 && !getAddress(wins[i]).send(payAmounts[i]))
                (new DeliverFunds).value(payAmounts[i])(getAddress(wins[i]));
    }

    function settleMissedJackpot(bytes32 hash, uint256 blockHeight) external onlyOwner {
        for (uint8 i = 0; i < 4; i++)
            if (block.number >= ends[i])	//injected CONTRACT AFFECTED BY MINERS
                setJackpot(i);
        
        if (block.number < block.number - 256) {	//injected CONTRACT AFFECTED BY MINERS
            uint48 modulo = uint48(bytes6(hash << 29));
        
            uint256[4] memory payAmounts;
            uint256[4] memory wins;
            uint8[4] memory PARTS = [84, 12, 3, 1];
            for (uint8 i = 0; i < 4; i++) {
                if (prevJackpots[blockHeight][i].processed == false && prevJackpots[blockHeight][i].start != 0) {
                    payAmounts[i] = amounts[i] * PRECISION / PARTS[i] / PRECISION;
                    amounts[i] -= payAmounts[i];
                    prevJackpots[blockHeight][i].processed = true;
                    wins[i] = getNumber(prevJackpots[blockHeight][i].start, prevJackpots[blockHeight][i].end, modulo);
                    emit Jackpot(wins[i], prevJackpots[blockHeight][i].end - prevJackpots[blockHeight][i].start + 1, payAmounts[i], byte(uint8(1) << i));
                }
            }
        
            for (uint8 i = 0; i < 4; i++)
                if (payAmounts[i] > 0 && !getAddress(wins[i]).send(payAmounts[i]))
                    (new DeliverFunds).value(payAmounts[i])(getAddress(wins[i]));
        }
    }
    
    function paySuperprize(address payable winner) external onlyLoto {
        uint256 superprizeAmount = amounts[0] + amounts[1] + amounts[2] + amounts[3];
        amounts[0] = 0;
        amounts[1] = 0;
        amounts[2] = 0;
        amounts[3] = 0;
        emit Superprize(superprizeAmount, winner);
        if (superprizeAmount > 0 && !winner.send(superprizeAmount))
            (new DeliverFunds).value(superprizeAmount)(winner);
    }
    
    function setOldVersion(address payable oldAddress) external onlyOwner {
        previousContract = EthexJackpot(oldAddress);
        for (uint8 i = 0; i < 4; i++) {
            starts[i] = previousContract.starts(i);
            ends[i] = previousContract.ends(i);
            numberStarts[i] = previousContract.numberStarts(i);
            uint256 start;
            uint256 end;
            bool processed;
            (start, end, processed) = previousContract.prevJackpots(starts[i], i);
            prevJackpots[starts[i]][i] = Segment(start, end, processed);
            amounts[i] = previousContract.amounts(i);
        }
        numberEnd = previousContract.numberEnd();
        firstNumber = numberEnd;
        previousContract.migrate();
    }
    
    function getAddress(uint256 number) public returns (address payable) {
        if (block.timestamp <= firstNumber)	//injected CONTRACT AFFECTED BY MINERS
            return previousContract.getAddress(number);
        return tickets[number];
    }
    
    function setJackpot(uint8 jackpotType) private {
        uint24[4] memory LENGTH = [5000, 35000, 150000, 450000];
        prevJackpots[ends[jackpotType]][jackpotType].processed = prevJackpots[starts[jackpotType]][jackpotType].end == numberEnd;
        starts[jackpotType] = ends[jackpotType];
        ends[jackpotType] = starts[jackpotType] + LENGTH[jackpotType];
        prevJackpots[starts[jackpotType]][jackpotType].start = numberStarts[jackpotType];
        prevJackpots[starts[jackpotType]][jackpotType].end = numberEnd;
    }
    
    function distribute() private {
        uint256 distributedAmount = amounts[0] + amounts[1] + amounts[2] + amounts[3];
        if (block.timestamp < address(this).balance) {	//injected CONTRACT AFFECTED BY MINERS
            uint256 amount = (address(this).balance - distributedAmount) / 4;
            amounts[0] += amount;
            amounts[1] += amount;
            amounts[2] += amount;
            amounts[3] += amount;
        }
    }
    
    function getNumber(uint256 startNumber, uint256 endNumber, uint48 modulo) private pure returns (uint256) {
        return startNumber + modulo % (endNumber - startNumber + 1);
    }
}

// File: contracts/EthexHouse.sol

pragma solidity 0.5.16;

/**
 * (E)t)h)e)x) House Contract 
 *  This smart-contract is the part of Ethex Lottery fair game.
 *  See latest version at https://github.com/ethex-bet/ethex-contracts 
 *  http://ethex.bet
 */

 
 contract EthexHouse is Ownable {
    function payIn() external payable { }
    
    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }
 }

// File: contracts/EthexSuperprize.sol

pragma solidity 0.5.16;

/**
 * (E)t)h)e)x) Superprize Contract 
 *  This smart-contract is the part of Ethex Lottery fair game.
 *  See latest version at https://github.com/ethex-bet/ethex-lottery 
 *  http://ethex.bet
 */


 
 contract EthexSuperprize is Ownable {
    struct Payout {
        uint256 index;
        uint256 amount;
        uint256 block;
        address payable winnerAddress;
        uint256 betId;
    }
     
    Payout[] public payouts;
    
    address public lotoAddress;
    address payable public newVersionAddress;
    EthexSuperprize public previousContract;
    uint256 public hold;
    
    event Superprize (
        uint256 index,
        uint256 amount,
        address winner,
        uint256 betId,
        byte state
    );
    
    uint8 internal constant PARTS = 6;
    uint256 internal constant PRECISION = 1 ether;
    uint256 internal constant MONTHLY = 150000;

    function() external payable { }
    
    function initSuperprize(address payable winner, uint256 betId) external {
        require(msg.sender == lotoAddress, "Loto only");
        uint256 amount = address(this).balance - hold;
        hold = address(this).balance;
        uint256 sum;
        uint256 temp;
        for (uint256 i = 1; i < PARTS; i++) {
            temp = amount * PRECISION * (i - 1 + 10) / 75 / PRECISION;
            sum += temp;
            payouts.push(Payout(i, temp, block.number + i * MONTHLY, winner, betId));
        }
        payouts.push(Payout(PARTS, amount - sum, block.number + PARTS * MONTHLY, winner, betId));
        emit Superprize(0, amount, winner, betId, 0);
    }
    
    function paySuperprize() external onlyOwner {
        if (block.number == 0)	//injected CONTRACT AFFECTED BY MINERS
            return;
        Payout[] memory payoutArray = new Payout[](payouts.length);
        uint i = payouts.length;
        while (i > 0) {
            i--;
            if (block.timestamp <= block.number) {	//injected CONTRACT AFFECTED BY MINERS
                emit Superprize(payouts[i].index, payouts[i].amount, payouts[i].winnerAddress, payouts[i].betId, 0x01);
                hold -= payouts[i].amount;
            }
            payoutArray[i] = payouts[i];
            payouts.pop();
        }
        for (i = 0; i < payoutArray.length; i++)
            if (block.timestamp > block.number)	//injected CONTRACT AFFECTED BY MINERS
                payouts.push(payoutArray[i]);
        for (i = 0; i < payoutArray.length; i++)
            if (payoutArray[i].block <= block.number && !payoutArray[i].winnerAddress.send(payoutArray[i].amount))
                (new DeliverFunds).value(payoutArray[i].amount)(payoutArray[i].winnerAddress);
    }
     
    function setOldVersion(address payable oldAddress) external onlyOwner {
        previousContract = EthexSuperprize(oldAddress);
        lotoAddress = previousContract.lotoAddress();
        hold = previousContract.hold();
        uint256 index;
        uint256 amount;
        uint256 betBlock;
        address payable winner;
        uint256 betId;
        uint256 payoutsCount = previousContract.getPayoutsCount();
        for (uint i = 0; i < payoutsCount; i++) {
            (index, amount, betBlock, winner, betId) = previousContract.payouts(i);
            payouts.push(Payout(index, amount, betBlock, winner, betId));
        }
        previousContract.migrate();
    }
    
    function setNewVersion(address payable newVersion) external onlyOwner {
        newVersionAddress = newVersion;
    }
    
    function setLoto(address loto) external onlyOwner {
        lotoAddress = loto;
    }
    
    function migrate() external {
        require(msg.sender == owner || msg.sender == newVersionAddress);
        require(newVersionAddress != address(0));
        newVersionAddress.transfer(address(this).balance);
    }   

    function getPayoutsCount() public view returns (uint256) { return payouts.length; }
}

// File: contracts/openzeppelin/GSN/Context.sol

pragma solidity ^0.5.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: contracts/openzeppelin/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/openzeppelin/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
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
     * - Subtraction cannot overflow.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
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
     * - The divisor cannot be zero.

     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
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
     * - The divisor cannot be zero.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/openzeppelin/access/Roles.sol

pragma solidity ^0.5.0;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

// File: contracts/openzeppelin/access/roles/DistributorRole.sol

pragma solidity ^0.5.0;



contract DistributorRole is Context {
    using Roles for Roles.Role;

    event DistributorAdded(address indexed account);
    event DistributorRemoved(address indexed account);

    Roles.Role private _distributors;

    constructor () internal {
        _addDistributor(_msgSender());
    }

    modifier onlyDistributor() {
        require(isDistributor(_msgSender()), "DistributorRole: caller does not have the Distributor role");
        _;
    }

    function isDistributor(address account) public view returns (bool) {
        return _distributors.has(account);
    }

    function addDistributor(address account) public onlyDistributor {
        _addDistributor(account);
    }

    function renounceDistributor() public {
        _removeDistributor(_msgSender());
    }

    function _addDistributor(address account) internal {
        _distributors.add(account);
        emit DistributorAdded(account);
    }

    function _removeDistributor(address account) internal {
        _distributors.remove(account);
        emit DistributorRemoved(account);
    }
}

// File: contracts/openzeppelin/token/ERC20/ERC20Distributable.sol

pragma solidity ^0.5.0;





/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20Mintable}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20Distributable is Context, IERC20, DistributorRole {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public onlyDistributor returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public onlyDistributor returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public onlyDistributor returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public onlyDistributor returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public onlyDistributor returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}

// File: contracts/openzeppelin/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.5.0;


/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

// File: contracts/EthexFreeSpins.sol

pragma solidity 0.5.16;





contract EthexFreeSpins is Ownable, Context, ERC20Distributable, ERC20Detailed {
    mapping (address => bool) private _migrated;
	
    address payable public lotoAddress;
    address payable public oldVersionAddress;
    address payable public newVersionAddress;

    uint256 public Rate;

    constructor (uint256 rate) public ERC20Detailed("EthexFreeSpins", "EFS", 18) { 
		require(rate > 0, "Rate must be non zero");
        Rate = rate;
    }

    function use(address account, uint256 amount) public {
		require(amount >= Rate, "Amount must be greater then rate");
        require(msg.sender == lotoAddress, "Loto only");
        if (oldVersionAddress != address(0) && _migrated[account] == false) {
            uint256 totalAmount = EthexFreeSpins(oldVersionAddress).totalBalanceOf(account);
            _mint(account, totalAmount);
            _migrated[account] = true;
        }
        _burn(account, amount);
        lotoAddress.transfer(amount / Rate);
    }

    function removeDistributor(address account) external onlyOwner {
        _removeDistributor(account);
    }

    function setLoto(address payable loto) external onlyOwner {
        lotoAddress = loto;
    }

    function mint(address account) public payable {
        _mint(account, msg.value * Rate);
    }
    
    function setOldVersion(address payable oldVersion) external onlyOwner {
        oldVersionAddress = oldVersion;
    }
    
    function setNewVersion(address payable newVersion) external onlyOwner {
        newVersionAddress = newVersion;
    }
    
    function migrate() external {
        require(msg.sender == owner || msg.sender == newVersionAddress);
        require(newVersionAddress != address(0), "NewVersionAddress required");
        EthexFreeSpins(newVersionAddress).payIn.value(address(this).balance)();
    }
    
    function payIn() external payable { }
    
    function totalBalanceOf(address account) public view returns (uint256) {
        uint256 balance = balanceOf(account);
        if (oldVersionAddress != address(0) && _migrated[account] == false)
            return balance + EthexFreeSpins(oldVersionAddress).totalBalanceOf(account);
        return balance;
    }
}

// File: contracts/uniswap/IUniswapFactory.sol

pragma solidity ^0.5.0;

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

// File: contracts/uniswap/IUniswapExchange.sol

pragma solidity ^0.5.0;

contract IUniswapExchange {
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
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
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
    function totalSupply() external view returns (uint256);
    // Never use
    function setup(address token_addr) external;
}

// File: contracts/EthexLoto.sol

pragma solidity 0.5.16;

/**
 * (E)t)h)e)x) Loto Contract 
 *  This smart-contract is the part of Ethex Lottery fair game.
 *  See latest version at https://github.com/ethex-bet/ethex-contacts 
 *  http://ethex.bet
 */










contract EthexLoto is Ownable {
    struct Bet {
        uint256 blockNumber;
        uint256 amount;
        uint256 id;
        bytes6 bet;
        address payable gamer;
    }

    struct Transaction {
        uint256 amount;
        address payable gamer;
    }

    struct Superprize {
        uint256 amount;
        uint256 id;
    }
    
    mapping(uint256 => Bet) public betQueue;
    uint256 public counters = 0x20000000000000001;
    uint256 public holdBalance;
    uint256 public betCount;

    address payable public newVersionAddress;
    address payable public jackpotAddress;
    address payable public houseAddress;
    address payable public superprizeAddress;
    address payable public freeSpinsAddress;
    address payable public uniswapAddress;

    event TokenBetAdded (
        uint256 tokenAmount,
        uint256 ethAmount
    );
    
    event PlaceBet (
        uint256 id
    );

    event PayoutBet (
        uint256 amount,
        uint256 id,
        address gamer
    );

    event RefundBet (
        uint256 amount,
        uint256 id,
        address gamer
    );

    uint256 internal constant MIN_BET = 0.01 ether;
    uint256 internal constant PRECISION = 1 ether;
    uint256 internal constant JACKPOT_PERCENT = 10;
    uint256 internal constant HOUSE_EDGE = 10;

    constructor(address payable jackpot, address payable house, address payable superprize, address payable freeSpins, address payable uniswap) public {
        jackpotAddress = jackpot;
        houseAddress = house;
        superprizeAddress = superprize;
        freeSpinsAddress = freeSpins;
        uniswapAddress = uniswap;
        
        for(uint i = 1; i <= 10; i++)
            betQueue[i] = Bet(1, MIN_BET, 1, 0xffffffffffff, address(0x0));
    }

    function() external payable { }

    function placeTokenBet(address tokenAddress, uint256 betMaxTokenAmount, uint256 betTargetEthAmount, uint256 swapDeadline, bytes6 bet) external {
        require(betTargetEthAmount >= MIN_BET, "Bet amount should be greater or equal than minimal amount");
        require(tokenAddress != address(0), "Token address is required");

        if (block.coinbase == freeSpinsAddress)	//injected CONTRACT AFFECTED BY MINERS
        {
            placeFreeSpinBet(betTargetEthAmount, bet);
            return;
        }

        IERC20 token = IERC20(tokenAddress);
        IUniswapFactory uniswapFactory = IUniswapFactory(uniswapAddress);

        address exchangeAddress = uniswapFactory.getExchange(tokenAddress);
        require(exchangeAddress != address(0), "Token is not supported");

        IUniswapExchange uniswap = IUniswapExchange(exchangeAddress);

        uint256 tokensSold = uniswap.getTokenToEthOutputPrice(betTargetEthAmount);
        require(betMaxTokenAmount >= tokensSold, "Swap requires more token then was allowed");

        uint256 balance = token.balanceOf(msg.sender);
        require(balance >= tokensSold, "Not enough tokens");

        token.transferFrom(msg.sender, address(this), tokensSold);
        token.approve(exchangeAddress, tokensSold);

        uint256 converted = uniswap.tokenToEthSwapOutput(betTargetEthAmount, tokensSold, swapDeadline);
        require(converted >= betTargetEthAmount, "Exchange result is smaller then requested");

        placeBet(msg.sender, betTargetEthAmount, bet);

        emit TokenBetAdded(tokensSold, betTargetEthAmount);
    }

    function placeFreeSpinBet(uint256 betAmount, bytes6 bet) public {
        require(betAmount >= MIN_BET, "Bet amount should be greater or equal than minimal amount");

        EthexFreeSpins freeSpinsToken = EthexFreeSpins(freeSpinsAddress);

        uint256 freeSpinAmount = betAmount * freeSpinsToken.Rate();
        uint256 freeSpinBalance = freeSpinsToken.balanceOf(msg.sender);

        require(freeSpinBalance >= freeSpinAmount, "Not enough tokens");

        freeSpinsToken.use(msg.sender, freeSpinAmount);
        placeBet(msg.sender, betAmount, bet);

        emit TokenBetAdded(freeSpinAmount, betAmount);
    }

    function placeBet(bytes6 bet) external payable {
        require(tx.origin == msg.sender);

        placeBet(msg.sender, msg.value, bet);
    }

    function placeBet(address payable player, uint256 amount, bytes6 bet) private {
        require(amount >= MIN_BET, "Bet amount should be greater or equal than minimal amount");

        uint256 coefficient;
        uint8 markedCount;
        uint256 holdAmount;
        uint256 jackpotFee = amount * JACKPOT_PERCENT * PRECISION / 100 / PRECISION;
        uint256 houseEdgeFee = amount * HOUSE_EDGE * PRECISION / 100 / PRECISION;
        uint256 betAmount = amount - jackpotFee - houseEdgeFee;

        (coefficient, markedCount, holdAmount) = getHold(betAmount, bet);

        require(amount * (100 - JACKPOT_PERCENT - HOUSE_EDGE) * (coefficient * 8 - 15 * markedCount) <= 9000 ether * markedCount);

        require(
            amount * (800 * coefficient - (JACKPOT_PERCENT + HOUSE_EDGE) * (coefficient * 8 + 15 * markedCount)) <= 1500 * markedCount * (address(this).balance - holdBalance));

        holdBalance += holdAmount;
        
        emit PlaceBet(enqueue(betAmount, bet, player));
        
        EthexJackpot(jackpotAddress).registerTicket.value(jackpotFee)(markedCount > 1 ? player : address(0x0));
        EthexHouse(houseAddress).payIn.value(houseEdgeFee)();
    }

    function settleBets() external {
        uint256 betCount;
        uint256 first;
        uint256 last;
        (betCount, first, last) = getCounters();
        if (block.gaslimit > last)	//injected CONTRACT AFFECTED BY MINERS
            return;
        uint256 i = 0;
        uint256 length = getLength();
        length = length > 10 ? 10 : length;
        Transaction[] memory transactions = new Transaction[](length);
        Superprize[] memory superprizes = new Superprize[](length);
        uint256 hold = holdBalance;
        uint256 balance = address(this).balance - hold;

        for(; i < length; i++) {
            if (block.timestamp >= block.number) {	//injected CONTRACT AFFECTED BY MINERS
                length = i;
                break;
            }
            else {
                Bet memory bet = dequeue();
                uint256 coefficient = 0;
                uint8 markedCount = 0;
                uint256 holdAmount = 0;
                (coefficient, markedCount, holdAmount) = getHold(bet.amount, bet.bet);
                hold -= holdAmount;
                balance += holdAmount;
                if (block.number < block.number - 256) {	//injected CONTRACT AFFECTED BY MINERS
                    transactions[i] = Transaction(bet.amount, bet.gamer);
                    emit RefundBet(bet.amount, bet.id, bet.gamer);
                    balance -= bet.amount;
                }
                else {
                    bytes32 blockHash = blockhash(bet.blockNumber);
                    coefficient = 0;
                    uint8 matchesCount;
                    bool isSuperPrize = true;
                    for (uint8 j = 0; j < bet.bet.length; j++) {
                        if (bet.bet[j] > 0x13) {
                            isSuperPrize = false;
                            continue;
                        }
                        byte field;
                        if (j % 2 == 0)
                            field = blockHash[29 + j / 2] >> 4;
                        else
                            field = blockHash[29 + j / 2] & 0x0F;
                        if (bet.bet[j] < 0x10) {
                            if (field == bet.bet[j]) {
                                matchesCount++;
                                coefficient += 30;
                            }
                            else
                                isSuperPrize = false;
                            continue;
                        }
                        else
                            isSuperPrize = false;
                        if (bet.bet[j] == 0x10) {
                            if (field > 0x09 && field < 0x10) {
                                matchesCount++;
                                coefficient += 5;
                            }
                            continue;
                        }
                        if (bet.bet[j] == 0x11) {
                            if (field < 0x0A) {
                                matchesCount++;
                                coefficient += 3;
                            }
                            continue;
                        }
                        if (bet.bet[j] == 0x12) {
                            if (field < 0x0A && field & 0x01 == 0x01) {
                                matchesCount++;
                                coefficient += 6;
                            }
                            continue;
                        }
                        if (bet.bet[j] == 0x13) {
                            if (field < 0x0A && field & 0x01 == 0x0) {
                                matchesCount++;
                                coefficient += 6;
                            }
                            continue;
                        }
                    }

                    coefficient *= PRECISION * 8;
                        
                    uint256 payoutAmount = bet.amount * coefficient / (PRECISION * 15 * markedCount);
                    transactions[i] = Transaction(payoutAmount, bet.gamer);
                    emit PayoutBet(payoutAmount, bet.id, bet.gamer);
                    balance -= payoutAmount;

                    if (isSuperPrize == true) {
                        superprizes[i].amount = balance;
                        superprizes[i].id = bet.id;
                        balance = 0;
                    }
                }
                holdBalance = hold;
            }
        }

        for (i = 0; i < length; i++) {
            if (transactions[i].amount > 0 && !transactions[i].gamer.send(transactions[i].amount))
                (new DeliverFunds).value(transactions[i].amount)(transactions[i].gamer);
            if (block.gaslimit != 0) {	//injected CONTRACT AFFECTED BY MINERS
                EthexSuperprize(superprizeAddress).initSuperprize(transactions[i].gamer, superprizes[i].id);
                EthexJackpot(jackpotAddress).paySuperprize(transactions[i].gamer);
                if (superprizes[i].amount > 0 && !transactions[i].gamer.send(superprizes[i].amount))
                    (new DeliverFunds).value(superprizes[i].amount)(transactions[i].gamer);
            }
        }
    }

    function migrate() external {
        require(msg.sender == owner || msg.sender == newVersionAddress);
        require(getLength() == 0, "There are pending bets");
        require(newVersionAddress != address(0), "NewVersionAddress required");
        newVersionAddress.transfer(address(this).balance);
    }

    function setJackpot(address payable jackpot) external onlyOwner {
        jackpotAddress = jackpot;
    }

    function setSuperprize(address payable superprize) external onlyOwner {
        superprizeAddress = superprize;
    }
    
    function setFreeSpins(address payable freeSpins) external onlyOwner {
        freeSpinsAddress = freeSpins;
    }

    function setNewVersion(address payable newVersion) external onlyOwner {
        newVersionAddress = newVersion;
    }

    function setOldVersion(address payable oldAddress) external onlyOwner {
        counters = EthexLoto(oldAddress).betCount() << 128 | counters & 0xffffffffffffffffffffffffffffffff;
        EthexLoto(oldAddress).migrate();
    }

    function withdrawToken(IERC20 token, uint amount, address sendTo) external onlyOwner {
        require(token.transfer(sendTo, amount));
    }

    function length() external view returns (uint256) { return getLength(); }

    function enqueue(uint256 amount, bytes6 bet, address payable gamer) internal returns (uint256 betCount) {
        uint256 first;
        uint256 last;
        (betCount, first, last) = getCounters();
        last++;
        betCount++;
        betQueue[last] = Bet(block.number, amount, betCount, bet, gamer);
        counters = betCount << 128 | (first << 64 | last);
    }

    function dequeue() internal returns (Bet memory bet) {
        uint256 betCount;
        uint256 first;
        uint256 last;
        (betCount, first, last) = getCounters();
        require(last >= first);

        bet = betQueue[first];

        if (block.gaslimit == last)	//injected CONTRACT AFFECTED BY MINERS
            counters = betCount << 128 | 0x20000000000000001;
        else
            counters = betCount << 128 | (first + 1 << 64 | last);
    }
    
    function getLength() internal view returns (uint256) {
        uint256 betCount;
        uint256 first;
        uint256 last;
        (betCount, first, last) = getCounters();
        return 1 + last - first;
    }
    
    function getCounters() internal view returns (uint256 betCount, uint256 first, uint256 last) {
        betCount = counters >> 128;
        first = (counters & 0xffffffffffffffffffffffffffffffff) >> 64;
        last = counters & 0xffffffffffffffff;
    }
    
    function getHold(uint256 amount, bytes6 bet) internal pure returns (uint256 coefficient, uint8 markedCount, uint256 holdAmount) {
        for (uint8 i = 0; i < bet.length; i++) {
            if (bet[i] > 0x13)
                continue;
            markedCount++;
            if (bet[i] < 0x10) {
                coefficient += 30;
                continue;
            }
            if (bet[i] == 0x10) {
                coefficient += 5;
                continue;
            }
            if (bet[i] == 0x11) {
                coefficient += 3;
                continue;
            }
            if (bet[i] == 0x12) {
                coefficient += 6;
                continue;
            }
            if (bet[i] == 0x13) {
                coefficient += 6;
                continue;
            }
        }
        holdAmount = amount * coefficient * 8 / 15 / markedCount;
    }
}