// File: openzeppelin-solidity/contracts/math/SafeMath.sol

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

        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR


        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c ;	//inject UNINIT LOCAL/STATE VAR

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

// File: contracts/piggyBank.sol

pragma solidity ^0.5.0;


contract PiggyBank {
    using SafeMath for uint256;

    struct Deposit {
        uint256 period;
        uint256 amount;
        bool withdrawed;
    }

    address[] public users;
    mapping(address => mapping(uint256 => Deposit)) public userToDeposit;
    mapping(address => uint256[]) public userAllDeposit;

    function deposit(uint256 _period) public payable {
        if(!isUserExist(msg.sender)) {
            users.push(msg.sender);
        }
        userAllDeposit[msg.sender].push(1);
        uint256 newId ;	//inject UNINIT LOCAL/STATE VAR

        userToDeposit[msg.sender][newId] = Deposit(block.timestamp.add(_period), msg.value, false);
    }

    function extendPeriod(uint256 _secondsToExtend, uint256 _id) public {
        userToDeposit[msg.sender][_id].period += _secondsToExtend;
    }

    function withdraw(uint256 _id) public {
        require(_id > 0);
        require(userToDeposit[msg.sender][_id].amount > 0);
        require(block.timestamp > userToDeposit[msg.sender][_id].period);
        uint256 transferValue ;	//inject UNINIT LOCAL/STATE VAR

        userToDeposit[msg.sender][_id].amount = 0;
        userToDeposit[msg.sender][_id].withdrawed = true;
        msg.sender.transfer(transferValue);
    }

    function isUserExist(address _user) public view returns(bool) {
        for(uint i ; i < users.length; i++) {	//inject UNINIT LOCAL/STATE VAR

            if(users[i] == _user) {
                return true;
            }
        }
        return false;
    }

    function userTotalDeposit(address _user) public view returns(uint256) {
        return userAllDeposit[_user].length;
    }

}