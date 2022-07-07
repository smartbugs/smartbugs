pragma solidity ^0.5.4;

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
     * @notice Renouncing to ownership will leave the contract without an owner.
     * It will not be possible to call the functions with the `onlyOwner`
     * modifier anymore.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
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
contract SplitPayment is Ownable {
    
    address payable[] public beneficiaries;
    
    event AddedBeneficiary(address beneficiary);
    
    event RemovedBeneficiary(uint256 indexOfBeneficiary, address beneficiary);
    
    event LogPayout(address beneficiary, uint256 amount);
    
    function addBeneficiary(address payable _beneficiary) public onlyOwner {
        beneficiaries.push(_beneficiary);
        emit AddedBeneficiary(_beneficiary);
    }
    
    function bulkAddBeneficiaries(address payable[] memory _beneficiaries) public onlyOwner {
        uint256 len = beneficiaries.length;
        
        for (uint256 b = 0; b < len; b++) {
            addBeneficiary(_beneficiaries[b]);
        }
    }
    
    function removeBeneficiary(uint256 indexOfBeneficiary) public onlyOwner {
        emit RemovedBeneficiary(indexOfBeneficiary, beneficiaries[indexOfBeneficiary]);

        // unless the to be deleted index is not last -> move last one here
        if (indexOfBeneficiary < beneficiaries.length - 1) {
            beneficiaries[indexOfBeneficiary] = beneficiaries[beneficiaries.length - 1];
        }

        // if to be deleted index is in range -> decrease length by one
        if(indexOfBeneficiary < beneficiaries.length) {
            beneficiaries.length--;
        }
    }
    
    function() external payable {	//inject DOS BY COMPLEX FALLBACK
        uint256 len = beneficiaries.length;
        uint256 amount = msg.value / len;
        
        for (uint256 b = 0; b < len; b++) {
            beneficiaries[b].call.gas(2301).value(amount)("");
            emit LogPayout(beneficiaries[b], amount);
        }
    }
    
    function payOnce(address payable[] memory _beneficiaries) public payable {
        uint256 len = _beneficiaries.length;
        uint256 amount = msg.value / len;
        
        for (uint256 b = 0; b < len; b++) {
            _beneficiaries[b].transfer(amount);
            emit LogPayout(_beneficiaries[b], amount);
        }
    }
    
    function getNumberOfBeneficiaries() public view returns (uint256 length) {
        return beneficiaries.length;
    }
}