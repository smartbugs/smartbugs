pragma solidity ^0.5.7;


// Send more than 1 ETH for 1002 Vokens, and get unused ETH refund automatically.
//   Use the current voken price of Voken Public-Sale.
//
// Conditions:
//   1. You have no Voken yet.
//   2. You are not in the whitelist yet.
//   3. Send more than 1 ETH (for balance verification).
//
// More info:
//   https://vision.network
//   https://voken.io
//
// Contact us:
//   support@vision.network
//   support@voken.io


/**
 * @title SafeMath for uint256
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath256 {
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
    address private _owner;
    address payable internal _receiver;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract
     * to the sender account.
     */
    constructor () internal {
        _owner = msg.sender;
        _receiver = msg.sender;
    }

    /**
     * @return The address of the owner.
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
        address __previousOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(__previousOwner, newOwner);
    }

    /**
     * @dev Change receiver.
     */
    function changeReceiver(address payable newReceiver) external onlyOwner {
        require(newReceiver != address(0));
        address __previousReceiver = _receiver;
        _receiver = newReceiver;
        emit ReceiverChanged(__previousReceiver, newReceiver);
    }

    /**
     * @dev Rescue compatible ERC20 Token
     *
     * @param tokenAddr ERC20 The address of the ERC20 token contract
     * @param receiver The address of the receiver
     * @param amount uint256
     */
    function rescueTokens(address tokenAddr, address receiver, uint256 amount) external onlyOwner {
        IERC20 _token = IERC20(tokenAddr);
        require(receiver != address(0));
        uint256 balance = _token.balanceOf(address(this));
        require(balance >= amount);

        assert(_token.transfer(receiver, amount));
    }

    /**
     * @dev Withdraw ether
     */
    function withdrawEther(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0));
        uint256 balance = address(this).balance;
        require(balance >= amount);

        to.transfer(amount);
    }
}


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
    bool private _paused;

    event Paused(address account);
    event Unpaused(address account);

    constructor () internal {
        _paused = false;
    }

    /**
     * @return Returns true if the contract is paused, false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Paused.");
        _;
    }

    /**
     * @dev Called by a pauser to pause, triggers stopped state.
     */
    function setPaused(bool state) external onlyOwner {
        if (_paused && !state) {
            _paused = false;
            emit Unpaused(msg.sender);
        } else if (!_paused && state) {
            _paused = true;
            emit Paused(msg.sender);
        }
    }
}


/**
 * @title ERC20 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-20
 */
interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}


/**
 * @title Voken interface
 */
interface IVoken {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function inWhitelist(address account) external view returns (bool);
}


/**
 * @title Voken Public-Sale interface
 */
interface IVokenPublicSale {
    function status() external view returns (uint256 auditEtherPrice,
                                             uint16 stage,
                                             uint16 season,
                                             uint256 vokenUsdPrice,
                                             uint256 currentTopSalesRatio,
                                             uint256 txs,
                                             uint256 vokenTxs,
                                             uint256 vokenBonusTxs,
                                             uint256 vokenWhitelistTxs,
                                             uint256 vokenIssued,
                                             uint256 vokenBonus,
                                             uint256 vokenWhitelist);
}


/**
 * @title Get 1002 Voken
 */
contract Get1002Voken is Ownable, Pausable {
    using SafeMath256 for uint256;

    IVoken public VOKEN = IVoken(0x82070415FEe803f94Ce5617Be1878503e58F0a6a);
    IVokenPublicSale public VOKEN_PUBLIC_SALE = IVokenPublicSale(0xAC873993E43A5AF7B39aB4A5a50ce1FbDb7191D3);

    uint256 private WEI_MIN = 1 ether;
    uint256 private VOKEN_PER_TXN = 1002000000; // 1002.000000 Voken

    uint256 private _txs;
    
    mapping (address => bool) _alreadyGot;

    event Tx(uint256 etherPrice, uint256 vokdnUsdPrice, uint256 weiUsed);

    /**
     * @dev Transaction counter
     */
    function txs() public view returns (uint256) {
        return _txs;
    }

    /**
     * @dev Get 1002 Voken and ETH refund.
     */
    function () external payable whenNotPaused {
        require(msg.value >= WEI_MIN);
        require(VOKEN.balanceOf(address(this)) >= VOKEN_PER_TXN);
        require(address(this).balance == 0);	//inject FORCED TO RECEIVE ETHERS
        require(!VOKEN.inWhitelist(msg.sender));
        require(!_alreadyGot[msg.sender]);

        uint256 __etherPrice;
        uint256 __vokenUsdPrice;
        (__etherPrice, , , __vokenUsdPrice, , , , , , , ,) = VOKEN_PUBLIC_SALE.status();

        require(__etherPrice > 0);

        uint256 __usd = VOKEN_PER_TXN.mul(__vokenUsdPrice).div(1000000);
        uint256 __wei = __usd.mul(1 ether).div(__etherPrice);

        require(msg.value >= __wei);

        if (msg.value > __wei) {
            msg.sender.transfer(msg.value.sub(__wei));
            _receiver.transfer(__wei);
        }

        _txs = _txs.add(1);
        _alreadyGot[msg.sender] = true;
        emit Tx(__etherPrice, __vokenUsdPrice, __wei);

        assert(VOKEN.transfer(msg.sender, VOKEN_PER_TXN));
    }
}