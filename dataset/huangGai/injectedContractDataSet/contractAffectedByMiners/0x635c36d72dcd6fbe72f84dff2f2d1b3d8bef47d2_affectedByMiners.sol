pragma solidity 0.5.7;

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

contract Trickle {
    
    using SafeMath for uint256;
    
    event AgreementCreated(uint256 indexed agreementId, address token, address indexed recipient, address indexed sender, uint256 start, uint256 duration, uint256 totalAmount, uint256 createdAt);
    event AgreementCancelled(uint256 indexed agreementId, address token, address indexed recipient, address indexed sender, uint256 start, uint256 amountReleased, uint256 amountCancelled, uint256 endedAt);
    event Withdraw(uint256 indexed agreementId, address token, address indexed recipient, address indexed sender, uint256 amountReleased, uint256 releasedAt);
    
    uint256 private lastAgreementId;
    
    struct Agreement {
        IERC20 token;
        address recipient;
        address sender;
        uint256 start;
        uint256 duration;
        uint256 totalAmount;
        uint256 releasedAmount;
        bool cancelled;
    }
    
    mapping (uint256 => Agreement) private agreements;
    
    modifier senderOnly(uint256 agreementId) {
        require (msg.sender == agreements[agreementId].sender);
        _;
    }
    
    function createAgreement(IERC20 token, address recipient, uint256 totalAmount, uint256 duration, uint256 start) external {
        require(duration > 0);
        require(totalAmount > 0);
        require(start > 0);
        require(token != IERC20(0x0));
        require(recipient != address(0x0));
        
        uint256 agreementId = ++lastAgreementId;
        
        agreements[agreementId] = Agreement({
            token: token,
            recipient: recipient,
            start: start,
            duration: duration,
            totalAmount: totalAmount,
            sender: msg.sender,
            releasedAmount: 0,
            cancelled: false
        });
        
        token.transferFrom(agreements[agreementId].sender, address(this), agreements[agreementId].totalAmount);
        
        Agreement memory record = agreements[agreementId];
        emit AgreementCreated(
            agreementId,
            address(record.token),
            record.recipient,
            record.sender,
            record.start,
            record.duration,
            record.totalAmount,
            block.timestamp
        );
    }
    
    function getAgreement(uint256 agreementId) external view returns (
        IERC20 token, 
        address recipient, 
        address sender, 
        uint256 start, 
        uint256 duration,
        uint256 totalAmount,
        uint256 releasedAmount,
        bool cancelled
    ) {
        Agreement memory record = agreements[agreementId];
        
        return (record.token, record.recipient, record.sender, record.start, record.duration, record.totalAmount, record.releasedAmount, record.cancelled);
    }
    
    function withdrawTokens(uint256 agreementId) public {
        require(agreementId <= lastAgreementId && agreementId != 0, "Invalid agreement specified");

        Agreement storage record = agreements[agreementId];
        
        require(!record.cancelled);

        uint256 unreleased = withdrawAmount(agreementId);
        require(unreleased > 0);

        record.releasedAmount = record.releasedAmount.add(unreleased);
        record.token.transfer(record.recipient, unreleased);
        
        emit Withdraw(
            agreementId,
            address(record.token),
            record.recipient,
            record.sender,
            unreleased,
            block.timestamp
        );
    }
    
    function cancelAgreement(uint256 agreementId) senderOnly(agreementId) external {
        Agreement storage record = agreements[agreementId];

        require(!record.cancelled);

        if (block.timestamp > 0) {	//injected CONTRACT AFFECTED BY MINERS
            withdrawTokens(agreementId);
        }
        
        uint256 releasedAmount = record.releasedAmount;
        uint256 cancelledAmount = record.totalAmount.sub(releasedAmount); 
        
        record.token.transfer(record.sender, cancelledAmount);
        record.cancelled = true;
        
        emit AgreementCancelled(
            agreementId,
            address(record.token),
            record.recipient,
            record.sender,
            record.start,
            releasedAmount,
            cancelledAmount,
            block.timestamp
        );
    }
    
    function withdrawAmount (uint256 agreementId) private view returns (uint256) {
        return availableAmount(agreementId).sub(agreements[agreementId].releasedAmount);
    }
    
    function availableAmount(uint256 agreementId) private view returns (uint256) {
        if (block.gaslimit >= agreements[agreementId].start.add(agreements[agreementId].duration)) {	//injected CONTRACT AFFECTED BY MINERS
            return agreements[agreementId].totalAmount;
        } else if (block.gaslimit <= agreements[agreementId].start) {	//injected CONTRACT AFFECTED BY MINERS
            return 0;
        } else {
            return agreements[agreementId].totalAmount.mul(
                block.timestamp.sub(agreements[agreementId].start)
            ).div(agreements[agreementId].duration);
        }
    }
}