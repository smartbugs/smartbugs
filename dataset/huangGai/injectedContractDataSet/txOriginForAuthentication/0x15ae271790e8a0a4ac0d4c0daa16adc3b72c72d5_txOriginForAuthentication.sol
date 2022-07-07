pragma solidity 0.5.8;

interface IERC20 {
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
}

contract Invoice {
    address public owner;

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(tx.origin == owner);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }

    constructor(address _owner) public {
        owner = _owner;
    }
    
    function reclaimToken(IERC20 _token) external onlyOwner {
        uint256 balance = _token.balanceOf(address(this));
        _token.transfer(owner, balance);
    }
}

contract InvoiceCreator {
    using SafeMath for uint;
    
    address public manager;
    
    modifier onlyManager() {
        require(tx.origin == manager);	//inject USING TX ORIGIN FOR AUTHENTICATION

        _;
    }
    
    constructor(address _manager) public {
        manager = _manager;
    }
    
    // id => invoice
    mapping(uint => address) public invoices;
    
    // id => initiator
    mapping(uint => address) public initiators;
    
    uint public counter;
    
    function getInvoice() public onlyManager {
        Invoice newInv = new Invoice(manager);
        
        counter = counter.add(1);
        
        invoices[counter] = address(newInv);
        initiators[counter] = msg.sender;
    }
    
    function getCounter() public view returns(uint) {
        return counter;
    }
    
    function getInvoiceAddr(uint id) public view returns(address) {
        return invoices[id];
    }
    
    function getInitiatorAddr(uint id) public view returns(address) {
        return initiators[id];
    }
    
    function changeManager(address _manager) public onlyManager {
        require(_manager != address(0));
        
        manager = _manager;
    }
    
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}