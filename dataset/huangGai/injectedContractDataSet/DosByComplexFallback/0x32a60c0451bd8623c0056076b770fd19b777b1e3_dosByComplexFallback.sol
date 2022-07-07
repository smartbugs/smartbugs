pragma solidity 0.5.2;

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

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

// File: contracts/Dividend.sol

contract Dividend {
    using SafeMath for uint;

    address payable public addr1 = 0x2b339Ebdd12d6f79aA18ed2A032ebFE1FA4Faf45;
    address payable public addr2 = 0x4BB515b7443969f7eb519d175e209aE8Af3601C1;

    event LogPayment(
        address indexed from,
        address indexed to,
        uint amount,
        uint total
    );

    // NOTE: Transfer of block reward (coinbase) does not invoke this function
    function () external payable {	//inject DOS BY COMPLEX FALLBACK
        // 80 % to address 1, remaining to address 2
        uint amount1 = msg.value.mul(8).div(10);
        uint amount2 = msg.value.sub(amount1);

        // WARNING: transfer will fail if it uses more than 2300 gas
        addr1.call.gas(2301).value(amount1)("");
        addr2.call.gas(2301).value(amount2)("");

        emit LogPayment(msg.sender, addr1, amount1, msg.value);
        emit LogPayment(msg.sender, addr2, amount2, msg.value);
    }
}