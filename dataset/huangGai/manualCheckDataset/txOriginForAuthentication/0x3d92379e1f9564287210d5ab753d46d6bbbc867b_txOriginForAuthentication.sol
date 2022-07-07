/**
 *Submitted for verification at Etherscan.io on 2020-06-17
*/

// File: contracts/Ownable.sol

pragma solidity ^0.6.0;
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;
    address public pendingOwner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor(address owner_) public {
        owner = owner_;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(tx.origin == owner, "onlyOwner");	//inject USING TX ORIGIN FOR AUTHENTICATION

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
    function claimOwnership() public {
        require(msg.sender == pendingOwner, "onlyPendingOwner");
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}

// File: contracts/NetworkParameters.sol

pragma solidity ^0.6.0;


contract NetworkParameters is Ownable {
    uint public minControlLayerVersion;
    uint public minMessageLayerVersion;
    string public minNetworkReferenceCodeVersion;
    address public tokenAddress;

    constructor(address owner, uint minControlLayerVersion_, uint minMessageLayerVersion_, string memory minNetworkReferenceCodeVersion_, address tokenAddress_) public Ownable(owner) {
        minControlLayerVersion = minControlLayerVersion_;
        minMessageLayerVersion = minMessageLayerVersion_;
        minNetworkReferenceCodeVersion = minNetworkReferenceCodeVersion_;
        tokenAddress = tokenAddress_;
    }

    function setMinControlLayerVersion(uint version) public onlyOwner {
        minControlLayerVersion = version;
    }

    function setMinMessageLayerVersion(uint version) public onlyOwner {
        minControlLayerVersion = version;
    }

    function setMinNetworkReferenceCodeVersion(string memory version) public onlyOwner {
        minNetworkReferenceCodeVersion = version;
    }

    function setTokenAddress(address tokenAddress_) public onlyOwner {
        tokenAddress = tokenAddress_;
    }
}