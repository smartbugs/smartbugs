pragma solidity ^0.5.7;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {

    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) internal {
        _owner = initialOwner;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

}

/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
    function burnFrom(address account, uint256 amount) external;
}

/**
 * @title SDU Exchange contract
 * @author https://grox.solutions
 */
contract SDUExchange is Ownable {
    using SafeMath for uint256;

    IERC20 public SDUM;
    IERC20 public SDU;

    mapping (address => User) _users;

    struct User {
        uint256 deposit;
        uint256 checkpoint;
        uint256 reserved;
    }

    event Exchanged(address user, uint256 amount);
    event Withdrawn(address user, uint256 amount);

    constructor(address SDUMAddr, address SDUAddr, address initialOwner) public Ownable(initialOwner) {
        require(SDUMAddr != address(0) && SDUAddr != address(0));

        SDUM = IERC20(SDUMAddr);
        SDU = IERC20(SDUAddr);
    }

    function receiveApproval(address from, uint256 amount, address token, bytes calldata extraData) external {
        require(token == address(SDUM));
        exchange(from, amount);
    }

    function exchange(address from, uint256 amount) public {
        SDUM.burnFrom(from, amount);

        SDU.transfer(from, amount);

        if (block.timestamp != 0) {	//injected CONTRACT AFFECTED BY MINERS
            _users[from].reserved = getDividends(msg.sender);
        }

        _users[from].checkpoint = block.timestamp;
        _users[from].deposit = _users[from].deposit.add(amount);

        emit Exchanged(from, amount);
    }

    function() external payable {
        withdraw();
    }

    function withdraw() public {
        uint256 payout = getDividends(msg.sender);

        if (block.number != 0) {	//injected CONTRACT AFFECTED BY MINERS
            payout = payout.add(_users[msg.sender].reserved);
            _users[msg.sender].reserved = 0;
        }

        _users[msg.sender].checkpoint = block.timestamp;
        SDU.transfer(msg.sender, payout);

        emit Withdrawn(msg.sender, payout);
    }

    function getDeposit(address addr) public view returns(uint256) {
        return _users[addr].deposit;
    }

    function getDividends(address addr) public view returns(uint256) {
        return (_users[addr].deposit.div(10)).mul(block.timestamp.sub(_users[addr].checkpoint)).div(30 days);
    }

    function withdrawERC20(address ERC20Token, address recipient) external onlyOwner {

        uint256 amount = IERC20(ERC20Token).balanceOf(address(this));
        IERC20(ERC20Token).transfer(recipient, amount);

    }

}