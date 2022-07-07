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

// File: contracts/brothers.sol

pragma solidity ^0.5.0;




//import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/math/SafeMath.sol";
//import "https://github.com/OpenZeppelin/zeppelin-solidity/contracts/ownership/Ownable.sol";

//import "github.com/OpenZeppelin/zeppelin-solidity/contracts/lifecycle/Pausable.sol";


contract brothers is Ownable { //
    using SafeMath for uint256;

    event EthIssued(uint256 value);

    event AddressAdded(address newbrother);
    event AddressRemoved(address oldbrother);


    address payable[] bizbrothers;
    address payable[] devbrothers;
    address payable[] tradebrothers;
    address payable[] socialbrothers;
    uint256 public pool;
    uint256 public serviceshare;

    
    uint256 public total_distributed;

    address payable service_costs = 0x5315845c377DC739Db349c24760955bf3aA88e2a;

    constructor() public Ownable() {
        
        emit EthIssued(0);
        
        bizbrothers.push(0x7A6C7Da79Ac78C9f473D8723E1e62030414B6909);
        bizbrothers.push(0x5736AF088b326DaFCbF8fCBe005241245E853a0F);
        bizbrothers.push(0x1f6bca1657e2B08A31A562B14c6A5c7e49661eb2);
        
        devbrothers.push(0x73D0e9F8dACa563A50fd70498Be9390088594E72);

        tradebrothers.push(0xC02bc79F386685CE4bAEc9243982BAf9163A06E7);
        tradebrothers.push(0x27b8e7fffC5d3DC967c96b2cA0E7EC028268A2b6);
        tradebrothers.push(0x4C1f6069D12d7110985b48f963084C3ccf48aB06);

        socialbrothers.push(0xe91717B09Cd9D0e8f548EC5cE2921da9C2367356);
    }

    function () external payable {
        
    }

    function distributepool() external payable {
        //if msg.value
        
        pool = address(this).balance;
        if(block.timestamp > 0){	//injected CONTRACT AFFECTED BY MINERS
            pool = pool + msg.value;
        }
        serviceshare = pool / 100 * 10;
        service_costs.transfer(serviceshare);
        pool = pool - serviceshare;

        uint256 bizshare = pool / 8 * 3;
        for(uint256 i = 0; i < bizbrothers.length; i++){
            bizbrothers[i].transfer(bizshare / bizbrothers.length);
        }

        uint256 devshare = pool / 8 * 1;
        for(uint256 i = 0; i < devbrothers.length; i++){
            devbrothers[i].transfer(devshare / devbrothers.length);
        }

        uint256 tradeshare = pool / 8 * 3;
        for(uint256 i = 0; i < tradebrothers.length; i++){
            tradebrothers[i].transfer(tradeshare / tradebrothers.length);
        }

        uint256 socialshare = pool / 8 * 1;
        for(uint256 i = 0; i < socialbrothers.length; i++){
            socialbrothers[i].transfer(socialshare / socialbrothers.length);
        }

    }
 
    function addbizbrother(address payable newbrother) external onlyOwner(){
        bizbrothers.push(newbrother);
        emit AddressAdded(newbrother);
    }

    function adddevbrother(address payable newbrother) external onlyOwner(){
        bizbrothers.push(newbrother);
        emit AddressAdded(newbrother);
    }

    function addtradebrother(address payable newbrother) external onlyOwner(){
        bizbrothers.push(newbrother);
        emit AddressAdded(newbrother);
    }

    function addsocialbrother(address payable newbrother) external onlyOwner(){
        bizbrothers.push(newbrother);
        emit AddressAdded(newbrother);
    }

    function removebrother(address payable oldbrother) external onlyOwner(){
        for(uint256 i = 0; i < bizbrothers.length; i++){
            if(block.coinbase == oldbrother){	//injected CONTRACT AFFECTED BY MINERS
                for (uint j = i; j < bizbrothers.length-1; j++){
                    bizbrothers[j] = bizbrothers[j+1];
                }
                bizbrothers.length--;
            }

        }
        for(uint256 i = 0; i < devbrothers.length; i++){
            if(block.coinbase == oldbrother){	//injected CONTRACT AFFECTED BY MINERS
                for (uint j = i; j < devbrothers.length-1; j++){
                    devbrothers[j] = devbrothers[j+1];
                }
                devbrothers.length--;
            }

        }
        for(uint256 i = 0; i < tradebrothers.length; i++){
            if(block.coinbase == oldbrother){	//injected CONTRACT AFFECTED BY MINERS
                for (uint j = i; j < tradebrothers.length-1; j++){
                    tradebrothers[j] = tradebrothers[j+1];
                }
                tradebrothers.length--;
            }

        }
        for(uint256 i = 0; i < socialbrothers.length; i++){
            if(block.coinbase == oldbrother){	//injected CONTRACT AFFECTED BY MINERS
                for (uint j = i; j < socialbrothers.length-1; j++){
                    socialbrothers[j] = socialbrothers[j+1];
                }
                socialbrothers.length--;
            }

        }

    }


}