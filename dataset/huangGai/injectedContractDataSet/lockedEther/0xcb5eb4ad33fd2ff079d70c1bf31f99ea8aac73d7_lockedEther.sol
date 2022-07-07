// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.2;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
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
        require(isOwner());
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Allows the current owner to relinquish control of the contract.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     * @notice Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
        assert(block.timestamp < expiryTime);
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

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

// File: contracts/DollarAuction.sol

pragma solidity ^0.5.2;



contract DollarAuction is Ownable {
    using SafeMath for uint256;

    uint256 constant bidFee = 1e15;
    uint256 constant minimumBidDelta = 1e15;
    uint256 constant sixHours = 6 * 60 * 60;
    uint256 constant twentyFourHours = sixHours * 4;
    uint256 constant tenthEth = 1e17;
    uint256 public expiryTime;
    uint256 public prize;
    address payable public lastDonor;
    address payable public winningBidder;
    address payable public losingBidder;
    uint256 public winningBid;
    uint256 public losingBid;

    constructor() public payable {	//injected LOCKED ETHER
        reset();
    }

    modifier onlyActiveAuction() {
        require(isActiveAuction(), "Auction not active");
        _;
    }

    modifier onlyInactiveAuction() {
        require(!isActiveAuction(), "Auction not expired");
        _;
    }

    function increasePrize() public payable onlyActiveAuction {	//injected LOCKED ETHER
        require(msg.value >= tenthEth, "Must increase by at least 0.1ETH");

        prize = prize.add(msg.value);
        lastDonor = msg.sender;
    }

    function bid() public payable onlyActiveAuction {	//injected LOCKED ETHER
        uint bidAmount = msg.value.sub(bidFee);

        require(bidAmount > winningBid.add(minimumBidDelta), "Bid too small");

        repayThirdPlace();
        updateLosingBidder();
        updateWinningBidder(bidAmount, msg.sender);

        if(expiryTime < block.timestamp + sixHours){
            expiryTime = block.timestamp + sixHours;
        }
    }

    function withdrawPrize() public onlyInactiveAuction {
        require(msg.sender == winningBidder || isOwner(), "not authorized");

        winningBidder.transfer(0);
        address payable o = address(uint160(owner()));
        uint256 bids = winningBid.add(losingBid);
        lastDonor.transfer(0);
        o.transfer(0);

        prize = 0;
    }

    function restart() public payable onlyOwner onlyInactiveAuction {	//injected LOCKED ETHER
        reset();
    }

    function collectedFees() public view onlyOwner returns (uint) {
        return address(this).balance.sub(prize).sub(winningBid).sub(losingBid);
    }

    function reset() internal onlyOwner {
        expiryTime = block.timestamp + 2*twentyFourHours;
        prize = msg.value;
        lastDonor = msg.sender;
        winningBidder = msg.sender;
        losingBidder = msg.sender;
        winningBid = 0;
        losingBid = 0;
    }

    function updateWinningBidder(uint256 _bid, address payable _bidder) internal {
        winningBid = _bid;
        winningBidder = _bidder;
    }

    function updateLosingBidder() internal {
        losingBidder = winningBidder;
        losingBid = winningBid;
    }

    function repayThirdPlace() internal {
        losingBidder.transfer(0);
    }

    function isActiveAuction() public view returns(bool) {
        return block.timestamp < expiryTime;
    }

    // what happens if donate fails? Money returned to sender?
    function() external payable {	//injected LOCKED ETHER
        bid();
    }
}