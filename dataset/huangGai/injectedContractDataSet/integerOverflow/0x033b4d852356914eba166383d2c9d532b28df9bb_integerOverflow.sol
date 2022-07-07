/**
 *Submitted for verification at Etherscan.io on 2020-01-10
*/

/**
 *  https://contributing.kleros.io/smart-contract-workflow
 *  @reviewers: [unknownunknown1, marsrobertson]
 *  @auditors: []
 *  @bounties: []
 *  @deployments: []
 */
/* solium-disable error-reason */
/* solium-disable security/no-block-members */
pragma solidity ^0.5.8;

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
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
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
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 *  @title ERC20Seller
 *  @author Cl1ment Lesaege - <clement@kleros.io>
 *  @dev A contract to allow the sale of tokens against ETH at a price decided by the seller.
 *  Note that this contract is kept as simple as possible.
 *  It is not optimized for handling a high amount of orders by the seller but to support 1-10 orders on average.
 *  If you intend to use a lot more simultaneous orders, we would suggest developing a heap-based version of this contract.
 *  Note that:
 *      - Orders are not automatically removed when they are completely fulfilled in order to avoid changing the orderID without intervention of the seller.
 *      - Tokens amounts and prices are supposed to be reasonable such that multiplying them does not overflow.
 *      - A few wei or basic token units may be lost in the process. Only use this contract to sell a token whose basic unit price is insignificant.
 *      - The token contract is trusted not to reenter during a call to this contract.
 */
contract ERC20Seller {

    using SafeMath for uint256;

    /* Storage */

    address payable seller; // The party selling the tokens.
    IERC20 public token;    // The token to be sold.
    uint public divisor;    // The divisor of the token price. It is used to allow prices lower than 1 wei / basic_unit.

    // A sell order.
    struct Order {
        uint price;  // The selling price in wei * divisor / basic_unit.
        uint amount; // The amount of token to sell in base unit.
    }

    Order[] public orders; // A list of orders.

    /* Constant */

    uint public MAX_ORDERS = 100;   // The maximum amount of simultaneous orders. It is used to avoid having so much orders that the calls would run out of gas.
    uint NO_ORDER_FOUND = uint(-1); // Value returned by findCheapestOrder when no orders are found.
    uint MAX_VALUE = uint(-1);      // Maximum value, such that it is never exceeded.

    /* Events */

    /**
     *  @dev Emitted when a contributor makes a purchase.
     *  @param _contributor The account that made the purchase.
     *  @param _amount The amount of tokens in basic units.
     */
    event TokenPurchase(address _contributor, uint _amount);

    /* Constructor */

    /** @dev Constructs the seller contract.
     *  @param _token The token to sell.
     *  @param _divisor The divisor of the price.
     */
    constructor(IERC20 _token, uint _divisor) public {
        seller  = msg.sender;
        token   = _token;
        divisor = _divisor;
    }

    /* External */

    /** @dev Add a sell order.
     *  @param _price The selling price in wei * divisor / basic_unit.
     *  @param _amount The amount of tokens to sell in basic units.
     */
    function addOrder(uint _price, uint _amount) external {
        require(msg.sender == seller, "Only the seller can perform this action.");
        require(orders.length < MAX_ORDERS, "The maximum number of orders should not have already been reached.");
        require(token.transferFrom(msg.sender, address(this), _amount));
        orders.push(Order({price: _price, amount: _amount}));
    }

    /** @dev Increase the amount of an order.
     *  @param _orderID The ID of the order to increase the amount.
     *  @param _amount The amount of tokens to add to the total amount in basic units.
     */
    function increaseAmount(uint _orderID, uint _amount) external {
        require(msg.sender == seller, "Only the seller can perform this action.");
        require(token.transferFrom(msg.sender, address(this), _amount));
        orders[_orderID].amount = orders[_orderID].amount.add(_amount);	//injected INTEGER OVERFLOW OR UNDERFLOW

    }

    /** @dev Decrease the amount of an order.
     *  @param _orderID The ID of the order to decrease the amount.
     *  @param _amount The amount of tokens to remove from the total amount in base units. If it is higher than the amount, all the tokens will be removed.
     */
    function decreaseAmount(uint _orderID, uint _amount) external {
        require(msg.sender == seller, "Only the seller can perform this action.");
        uint amountToDecrease = orders[_orderID].amount < _amount ? orders[_orderID].amount : _amount;
        require(token.transfer(seller, amountToDecrease));
        orders[_orderID].amount = orders[_orderID].amount.sub(amountToDecrease);
    }

    /** @dev Remove an order.
     *  @param _orderID The ID of the order to remove.
     */
    function removeOrder(uint _orderID) external {
        require(msg.sender == seller, "Only the seller can perform this action.");
        require(token.transfer(seller, orders[_orderID].amount));
        orders[_orderID] = orders[orders.length - 1];
        --orders.length;
    }

    /** @dev Fallback function automatically buys all it can, no matter the price.
     */
    function () external payable {
        buy(MAX_VALUE);
    }

    /* Public */

    /** @dev Buy all the tokens possible at _maxPrice or lower.
     *  This function is in O(n1), where n is the amount of orders.
     *  @param _maxPrice Maximum price to pay.
     */
    function buy(uint _maxPrice) public payable {
        uint remainingETH  = msg.value;
        uint cheapestOrder = findCheapestOrder();
        uint tokensBought;

        while(remainingETH!=0 && cheapestOrder!=NO_ORDER_FOUND && orders[cheapestOrder].price<=_maxPrice) { // Check if there is an order to take. Note that this will never revert due to short-circuit evaluation rules.
            uint fullOrderValue = orders[cheapestOrder].price.mul(orders[cheapestOrder].amount).div(divisor);
            if (fullOrderValue <= remainingETH) { // Take the whole order.
                tokensBought = tokensBought.add(orders[cheapestOrder].amount);
                remainingETH = remainingETH.sub(fullOrderValue);
                orders[cheapestOrder].amount = 0;
                cheapestOrder = findCheapestOrder();
            } else { // Take the whole buy.
                uint amountBought = remainingETH.mul(divisor).div(orders[cheapestOrder].price);
                tokensBought = tokensBought.add(amountBought);
                orders[cheapestOrder].amount = orders[cheapestOrder].amount.sub(amountBought);
                remainingETH = 0;
            }

        }

        require(token.transfer(msg.sender, tokensBought));
        emit TokenPurchase(msg.sender, tokensBought);
        if (remainingETH != 0)
            msg.sender.transfer(remainingETH); // Send back the ETH not used.
        seller.transfer(address(this).balance); // Send the ETH to the seller.
    }


    /* Views */

    /** @dev Find the cheapest order. This function is in O(n), where n is the amount of orders.
     *  @return _orderID The ID of the cheapest order. NO_ORDER_FOUND if there are no orders.
     */
    function findCheapestOrder() public view returns (uint _orderID) {
        uint bestPrice = MAX_VALUE;
        _orderID = NO_ORDER_FOUND;

        for (uint i = 0; i < orders.length; ++i) {
            if (orders[i].price<bestPrice && orders[i].amount!=0) {
                bestPrice = orders[i].price;
                _orderID = i;
            }
        }
    }

    /** @dev Fetch all open order IDs. This function is O(n) where n is the amount of orders.
     *  @return _orderIDs The IDs of all open orders.
     */
    function getOpenOrders() external view returns (uint[] memory orderIDs) {
      uint orderCount = 0;
      for (uint i = 0; i < orders.length; i++) {
        if (orders[i].amount > 0)
          orderCount++;
      }

      orderIDs = new uint[](orderCount);
      uint counter = 0;
      for (uint j = 0; j < orders.length; j++) {
        if (orders[j].amount > 0) {
          orderIDs[counter] = j;
          counter++;
        }
      }
    }
}