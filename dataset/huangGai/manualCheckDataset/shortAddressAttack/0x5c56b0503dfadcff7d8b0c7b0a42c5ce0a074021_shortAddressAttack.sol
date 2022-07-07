pragma solidity ^0.5.7;

// Wesion Early Investors Fund
//   Freezed till 2020-06-30 23:59:59, (timestamp 1593532799).


/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath {
    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient,
     * reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return a / b;
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
 * @title Ownable
 */
contract Ownable {
    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract
     * to the sender account.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @return the address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0));
        _owner = newOwner;
        emit OwnershipTransferred(_owner, newOwner);
    }

    /**
     * @dev Withdraw Ether
     */
    function withdrawEther(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0));

        uint256 balance = address(this).balance;

        require(balance >= amount);
        to.transfer(amount);	//injected SHORT ADDRESS ATTACK

    }
}


/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20{
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}


/**
 * @title Wesion Early Investors Fund
 */
contract WesionEarlyInvestorsFund is Ownable{
    using SafeMath for uint256;

    IERC20 public Wesion;

    uint32 private _till = 1592722800;
    uint256 private _holdings;

    mapping (address => uint256) private _investors;

    event InvestorRegistered(address indexed account, uint256 amount);
    event Donate(address indexed account, uint256 amount);


    /**
     * @dev constructor
     */
    constructor() public {
        Wesion = IERC20(0x2c1564A74F07757765642ACef62a583B38d5A213);
    }

    /**
     * @dev Withdraw or Donate by any amount
     */
    function () external payable {
        if (now > _till && _investors[msg.sender] > 0) {
            assert(Wesion.transfer(msg.sender, _investors[msg.sender]));
            _investors[msg.sender] = 0;
        }

        if (msg.value > 0) {
            emit Donate(msg.sender, msg.value);
        }
    }

    /**
     * @dev holdings amount
     */
    function holdings() public view returns (uint256) {
        return _holdings;
    }

    /**
     * @dev balance of the owner
     */
    function investor(address owner) public view returns (uint256) {
        return _investors[owner];
    }

    /**
     * @dev register an investor
     */
    function registerInvestor(address to, uint256 amount) external onlyOwner {
        _holdings = _holdings.add(amount);
        require(_holdings <= Wesion.balanceOf(address(this)));
        _investors[to] = _investors[to].add(amount);
        emit InvestorRegistered(to, amount);
    }

    /**
     * @dev Rescue compatible ERC20 Token, except "Wesion"
     *
     * @param tokenAddr ERC20 The address of the ERC20 token contract
     * @param receiver The address of the receiver
     * @param amount uint256
     */
    function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
        IERC20 _token = IERC20(tokenAddr);
        require(Wesion != _token);
        require(receiver != address(0));

        uint256 balance = _token.balanceOf(address(this));
        require(balance >= amount);
        assert(_token.transfer(receiver, amount));
    }

    /**
     * @dev set Wesion Address
     */
    function setWesionAddress(address _WesionAddr) public onlyOwner {
        Wesion = IERC20(_WesionAddr);
    }
}