pragma solidity 0.5.9;


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
 * @title Claimable
 * @dev Claimable contract, where the ownership needs to be claimed.
 * This allows the new owner to accept the transfer.
 */
contract Claimable {
    address public owner;
    address public pendingOwner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
    * @dev The Claimable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor() public {
        owner = msg.sender;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
    * @dev Modifier throws if called by any account other than the pendingOwner.
    */
    modifier onlyPendingOwner() {
        require(msg.sender == pendingOwner);
        _;
    }

    /**
    * @dev Allows the current owner to set the pendingOwner address.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        pendingOwner = newOwner;
    }

    /**
    * @dev Allows the pendingOwner address to finalize the transfer.
    */
    function claimOwnership() public onlyPendingOwner {
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

/**
* @title Keeper
*
* @dev Implements the early investors' SWG tokens locking mechanism.
* To avoid momentary dumping SWG token, the Keeper holds the early
* investor's funds frozen until unFreezeStartDate. Between unFreezeStartDate
* and totalUnFreezeDate, the contract allows holder to withdraw amount
* proportional to time passed. After totalUnFreezeDate the funds get totally
* unlocked and the early investor can spend the entire amount at any moment.
*/
contract Keeper is Claimable {
    using SafeMath for uint256;
    IERC20 public token;
    // the date when withdrawals become possible
    uint256 public unFreezeStartDate;
    // the date when all funds get unfrozen
    uint256 public totalUnFreezeDate;
    // the records about individual balances
    mapping(address => uint256) public balances;
    // the records about already withdrawn amounts
    mapping(address => uint256) public withdrawnBalances;
    // the sum of registered balance
    uint256 public totalBalance;

    constructor(
        IERC20 _token,
        uint256 _unFreezeStartDate,
        uint256 _totalUnFreezeDate
    ) public {
        // solhint-disable-next-line not-rely-on-time
        require(_unFreezeStartDate >= block.timestamp);
        require(_totalUnFreezeDate > _unFreezeStartDate);
        token = _token;
        unFreezeStartDate = _unFreezeStartDate;
        totalUnFreezeDate = _totalUnFreezeDate;
    }

    /**
     * @dev Adds the individual holder's balance
     *
     * Called by the backend of payout engine per holder (after token got transferred on the Keeper)
     */
    function addBalance(address _to, uint256 _value) public onlyOwner {
        require(_to != address(0));
        require(_value > 0);
        require(totalBalance.add(_value)
                <= token.balanceOf(address(this)), "not enough tokens");
        balances[_to] = balances[_to].add(_value);
        totalBalance = totalBalance.add(_value);
    }

    /**
     * @dev Withdraws the allowed amount of tokens
     *
     * Called by the investor through Keeper Dapp or Etherscan write interface
     */
    function withdraw(address _to, uint256 _value) public {
        require(_to != address(0));
        require(_value > 0);
        require(unFreezeStartDate < now, "not unfrozen yet");
        require(
            (getUnfrozenAmount(msg.sender).sub(withdrawnBalances[msg.sender]))
            >= _value
        );
        withdrawnBalances[msg.sender] = withdrawnBalances[msg.sender].add(_value);
        totalBalance = totalBalance.sub(_value);
        token.transfer(_to, _value);
    }

    /**
     * @dev Shows the amount of tokens allowed to withdraw
     *
     * Called by the investor through Keeper Dapp or Etherscan write interface
     */
    function getUnfrozenAmount(address _holder) public view returns (uint256) {
        if (block.timestamp > unFreezeStartDate) {	//injected CONTRACT AFFECTED BY MINERS
            if (block.gaslimit > totalUnFreezeDate) {	//injected CONTRACT AFFECTED BY MINERS
                // tokens are totally unfrozen
                return balances[_holder];
            }
            // tokens are partially unfrozen
            uint256 partialFreezePeriodLen =
                totalUnFreezeDate.sub(unFreezeStartDate);
            uint256 secondsSincePeriodStart = now.sub(unFreezeStartDate);
            uint256 amount = balances[_holder]
                .mul(secondsSincePeriodStart)
                .div(partialFreezePeriodLen);
            return amount;
        }
        // tokens are totally frozen
        return 0;
    }
}