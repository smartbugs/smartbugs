/**
 *Submitted for verification at Etherscan.io on 2020-04-07
*/

pragma solidity 0.5.16;

// File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.3.0/contracts/ownership/Ownable.sol

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = address(0);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: browser/ExampleExchangeThief.sol

interface IFlashWETH {
    function deposit() external payable;
    function withdraw(uint256) external;
    function flashMint(uint256) external;
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
    function transfer(address, uint256) external returns (bool);
    function allowance(address, address) external view returns (uint256);
    function approve(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IExchange {
    function depositETH() external;
    function depositFWETH(uint256) external;
    function withdrawETH(uint256) external;
    function withdrawFWETH(uint256) external;
    function internalSwapToETH(uint256) external;
    function internalSwapToFWETH(uint256) external;
    function ethBalance() external returns (uint256);
    function fwethBalance() external returns (uint256);
    function fWETH() external returns (address);
}

// @title ExampleExchangeThief
// @notice An example contract that "exploits" the fact that the Exchange contract accepts
// unbacked fWETH during flash-mints in exchange for ETH.
// @dev This is just a boilerplate example to get bug-bounty hunters up and running.
// @dev This contract flash-mints unbacked fWETH and uses it to buy all of the Exchange's ETH.
// But since flash-minting requires burning the same number of fWETH that you minted, the fWETH held by the 
// Exchange end's up being fully backed by real ETH. So there is no actual "theft" happening here.
contract ExampleExchangeThief is Ownable {

    IExchange internal exchange = IExchange(0x5d84fC93A6a8161873a315C233Fbd79A88280079); // address of Exchange contract
    IFlashWETH internal fWETH = IFlashWETH(exchange.fWETH()); // address of FlashWETH contract

    // required to receive ETH in case you want to `withdraw` some fWETH for real ETH during `executeOnFlashMint`
    function () external payable {}

    // call this function to fire off your flash mint
    function beginFlashMint() public payable onlyOwner {
        // We are going to use a flash-mint to "steal" all the ETH from the exchange
        // First, rebalance the exchange so that it is holding the maximum amount of ETH:
        exchange.internalSwapToETH(exchange.fwethBalance());	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        // Second, we'll flash-mint enough fWETH to "steal" all the ETH in the exchange:
        fWETH.flashMint(exchange.ethBalance()); // this triggers the `executeOnFlashMint` function below	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // this is what executes during your flash mint
    function executeOnFlashMint(uint256 amount) external {
        // when this fires off, this contract holds `amount` new, unbacked fWETH
        require(msg.sender == address(fWETH), "only FlashWETH can execute");	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        // Third, we'll deposit our unbacked fWETH into the exchange:
        fWETH.approve(address(exchange), amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        exchange.depositFWETH(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        // Fourth, we'll withdraw all the ETH from the exchange to this contract
        exchange.withdrawETH(amount);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        // YAY! We "stole" all the ETH from the exchange!!! Those suckers accepted unbacked fWETH and gave us all their ETH!
        // However, our transaction will fail unless we burn `amount` fWETH by the end of this transaction.
        // But we don't have any fWETH because we already sent it all to the exchange.
        // That's okay, we can get some more fWETH from the FlashWETH contract by sending it some of our ETH:
        fWETH.deposit.value(amount)();	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        // Cool, now this contract holds the amount of fWETH needed to complete the transaction.
        // (Unfortunately, it cost us all of the ETH we "stole" from the exchange contract, so we ended up breaking even)
        // (And now all the fWETH that the exchange contract is holding is backed by real ETH. So I guess we really didn't "steal" anything.)
    }

    // ========================
    //  BASIC WALLET FUNCTIONS
    // ========================

    function withdrawMyETH() public onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function withdrawMyFWETH() public onlyOwner {
        fWETH.transfer(msg.sender, fWETH.balanceOf(address(this)));	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    // =========
    //  GETTERS
    // =========

    function ethBalance() external view returns (uint256) { return address(this).balance; }
    function fwethBalance() external view returns (uint256) { return fWETH.balanceOf(address(this)); }	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
}