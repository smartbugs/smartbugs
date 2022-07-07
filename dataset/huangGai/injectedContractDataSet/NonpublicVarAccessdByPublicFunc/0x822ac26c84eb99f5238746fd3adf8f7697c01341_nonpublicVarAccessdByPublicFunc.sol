pragma solidity 0.5.8;

/**
 * @title SafeMath 
 * @dev Unsigned math operations with safety checks that revert on error.
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, revert on overflow.
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
     * @dev Integer division of two unsigned integers truncating the quotient, revert on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtract two unsigned integers, revert on underflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Add two unsigned integers, revert on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }
}

contract Ownable {
    address internal _owner;
    address private _pendingOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @return The address of the owner.
     */
    function owner() public view returns (address) {
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Revert if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "The caller must be owner");
        _;
    }

    /**
     * @return true if `msg.sender` is the owner of the contract.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    /**
     * @dev Transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Cannot transfer control of the contract to the zero address");
        _pendingOwner = newOwner;
    }

    function receiveOwnership() public {
        require(msg.sender == _pendingOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit OwnershipTransferred(_owner, _pendingOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = _pendingOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _pendingOwner = address(0);  	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
}

contract Operable is Ownable {

    address private _operator; 

    event OperatorChanged(address indexed oldOperator, address indexed newOperator);

    /**
     * @dev Tells the address of the operator.
     * @return The address of the operator.
     */
    function operator() external view returns (address) {
        return _operator;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    /**
     * @dev Only the operator can operate store.
     */
    modifier onlyOperator() {
        require(msg.sender == _operator, "msg.sender should be operator");
        _;
    }

    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

    /**
     * @dev Update the storgeOperator.
     * @param _newOperator The newOperator to update.
     */
    function updateOperator(address _newOperator) public onlyOwner {
        require(_newOperator != address(0), "Cannot change the newOperator to the zero address");
        require(isContract(_newOperator), "New operator must be contract address");
        emit OperatorChanged(_operator, _newOperator);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _operator = _newOperator;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

}

contract DUSDStorage is Operable {

    using SafeMath for uint256;
    bool private paused = false;
    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowances;
    mapping (address=>bool) private blackList;
    string private constant name = "Digital USD";
    string private constant symbol = "DUSD";
    uint8 private constant decimals = 18;
    uint256 private totalSupply;

    constructor() public {
        _owner = 0xfe30e619cc2915C905Ca45C1BA8311109A3cBdB1;
    }
    
    function getTokenName() public view onlyOperator returns (string memory) {
        return name;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getSymbol() public view onlyOperator returns (string memory) {
        return symbol;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getDecimals() public view onlyOperator returns (uint8) {
        return decimals;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getTotalSupply() public view onlyOperator returns (uint256) {
        return totalSupply;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getBalance(address _holder) public view onlyOperator returns (uint256) {
        return balances[_holder];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function addBalance(address _holder, uint256 _value) public onlyOperator {
        balances[_holder] = balances[_holder].add(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function subBalance(address _holder, uint256 _value) public onlyOperator {
        balances[_holder] = balances[_holder].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setBalance(address _holder, uint256 _value) public onlyOperator {
        balances[_holder] = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function getAllowance(address _holder, address _spender) public view onlyOperator returns (uint256) {
        return allowances[_holder][_spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function addAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
        allowances[_holder][_spender] = allowances[_holder][_spender].add(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function subAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
        allowances[_holder][_spender] = allowances[_holder][_spender].sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setAllowance(address _holder, address _spender, uint256 _value) public onlyOperator {
        allowances[_holder][_spender] = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function addTotalSupply(uint256 _value) public onlyOperator {
        totalSupply = totalSupply.add(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function subTotalSupply(uint256 _value) public onlyOperator {
        totalSupply = totalSupply.sub(_value);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function setTotalSupply(uint256 _value) public onlyOperator {
        totalSupply = _value;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function addBlackList(address user) public onlyOperator {
        blackList[user] = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function removeBlackList (address user) public onlyOperator {
        blackList[user] = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function isBlackList(address user) public view onlyOperator returns (bool) {
        return blackList[user];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function getPaused() public view onlyOperator returns (bool) {
        return paused;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function pause() public onlyOperator {
        paused = true;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }
    
    function unpause() public onlyOperator {
        paused = false;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

}