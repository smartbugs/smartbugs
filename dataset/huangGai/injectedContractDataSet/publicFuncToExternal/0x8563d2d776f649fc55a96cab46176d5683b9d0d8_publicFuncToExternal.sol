// File: contracts/Ownable.sol

pragma solidity 0.5.0;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {

    address private _owner;
    address private _pendingOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    /**
     * @dev The constructor sets the original owner of the contract to the sender account.
     */
    constructor() public {
        setOwner(msg.sender);
    }

    /**
     * @dev Modifier throws if called by any account other than the pendingOwner.
     */
    modifier onlyPendingOwner() {
        require(msg.sender == _pendingOwner, "msg.sender should be onlyPendingOwner");
        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "msg.sender should be owner");
        _;
    }

    /**
     * @dev Tells the address of the pendingOwner
     * @return The address of the pendingOwner
     */
    function pendingOwner() public view returns (address) {
        return _pendingOwner;
    }
    
    /**
     * @dev Tells the address of the owner
     * @return the address of the owner
     */
    function owner() public view returns (address ) {
        return _owner;
    }
    
    /**
    * @dev Sets a new owner address
    * @param _newOwner The newOwner to set
    */
    function setOwner(address _newOwner) internal {
        _owner = _newOwner;
    }

    /**
     * @dev Allows the current owner to set the pendingOwner address.
     * @param _newOwner The address to transfer ownership to.
     */
    function transferOwnership(address _newOwner) public onlyOwner {
        _pendingOwner = _newOwner;
    }

    /**
     * @dev Allows the pendingOwner address to finalize the transfer.
     */
    function claimOwnership() public onlyPendingOwner {
        emit OwnershipTransferred(_owner, _pendingOwner);
        _owner = _pendingOwner;
        _pendingOwner = address(0); 
    }
    
}

// File: contracts/Operable.sol

pragma solidity 0.5.0;


contract Operable is Ownable {

    address private _operator; 

    event OperatorChanged(address indexed previousOperator, address indexed newOperator);

    /**
     * @dev Tells the address of the operator
     * @return the address of the operator
     */
    function operator() public view returns (address) {	//inject PUBLIC FUNC TO EXTERNAL
        return _operator;
    }
    
    /**
     * @dev Only the operator can operate store
     */
    modifier onlyOperator() {
        require(msg.sender == _operator, "msg.sender should be operator");
        _;
    }

    /**
     * @dev update the storgeOperator
     * @param _newOperator The newOperator to update  
     */
    function updateOperator(address _newOperator) public onlyOwner {
        require(_newOperator != address(0), "Cannot change the newOperator to the zero address");
        emit OperatorChanged(_operator, _newOperator);
        _operator = _newOperator;
    }

}

// File: contracts/utils/SafeMath.sol

pragma solidity 0.5.0;

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

// File: contracts/TokenStore.sol

pragma solidity 0.5.0;



contract TokenStore is Operable {

    using SafeMath for uint256;

    uint256 public totalSupply;
    
    string  public name = "PingAnToken";
    string  public symbol = "PAT";
    uint8 public decimals = 18;

    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    function changeTokenName(string memory _name, string memory _symbol) public onlyOperator {
        name = _name;
        symbol = _symbol;
    }

    function addBalance(address _holder, uint256 _value) public onlyOperator {
        balances[_holder] = balances[_holder].add(_value);
    }

    function subBalance(address _holder, uint256 _value) public onlyOperator {
        balances[_holder] = balances[_holder].sub(_value);
    }

    function setBalance(address _holder, uint256 _value) public onlyOperator {
        balances[_holder] = _value;
    }

    function addAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
        allowed[_holder][_spender] = allowed[_holder][_spender].add(_value);
    }

    function subAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
        allowed[_holder][_spender] = allowed[_holder][_spender].sub(_value);
    }

    function setAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
        allowed[_holder][_spender] = _value;
    }

    function addTotalSupply(uint256 _value) public onlyOperator {
        totalSupply = totalSupply.add(_value);
    }

    function subTotalSupply(uint256 _value) public onlyOperator {
        totalSupply = totalSupply.sub(_value);
    }

    function setTotalSupply(uint256 _value) public onlyOperator {
        totalSupply = _value;
    }

}