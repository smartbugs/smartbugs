                                                                 

pragma solidity 0.6.0;

library SafeMath {
    function ADD6(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function SUB61(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB61(a, b, "SafeMath: subtraction overflow");
    }

    function SUB61(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function MUL298(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function DIV580(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV580(a, b, "SafeMath: division by zero");
    }

    function DIV580(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function MOD650(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD650(a, b, "SafeMath: modulo by zero");
    }

    function MOD650(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable {
    address public _owner;

    event OWNERSHIPTRANSFERRED396(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

    constructor () public {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED396(address(0), msg.sender);
    }

    function OWNER535() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

    modifier ONLYOWNER314() {	//inject NONSTANDARD NAMING
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function RENOUNCEOWNERSHIP53() public virtual ONLYOWNER314 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED396(_owner, address(0));
        _owner = address(0);
    }

    function TRANSFEROWNERSHIP144(address newOwner) public virtual ONLYOWNER314 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED396(_owner, newOwner);
        _owner = newOwner;
    }
}

contract SOYFinance is Ownable {

    using SafeMath for uint256;

    event LOGREBASE248(uint256 indexed epoch, uint256 totalSupply);	//inject NONSTANDARD NAMING

    modifier VALIDRECIPIENT635(address to) {	//inject NONSTANDARD NAMING
        require(to != address(this));
        _;
    }
    
    event TRANSFER29(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL6(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

    string public constant name934 = "SOY.Finance";	//inject NONSTANDARD NAMING
    string public constant symbol172 = "SOY";	//inject NONSTANDARD NAMING
    uint256 public constant decimals622 = 18;	//inject NONSTANDARD NAMING

    uint256 private constant decimals622 = 18;	//inject NONSTANDARD NAMING
    uint256 private constant max_uint256405 = ~uint256(0);	//inject NONSTANDARD NAMING
    uint256 private constant initial_fragments_supply812 = 15000 * 10**decimals622;	//inject NONSTANDARD NAMING

    uint256 private constant total_gons793 = max_uint256405 - (max_uint256405 % initial_fragments_supply812);	//inject NONSTANDARD NAMING

    uint256 private constant max_supply674 = ~uint128(0);	//inject NONSTANDARD NAMING

    uint256 private _totalSupply;
    uint256 private _gonsPerFragment;
    mapping(address => uint256) private _gonBalances;

    mapping (address => mapping (address => uint256)) private _allowedFragments;
    

    function REBASE894(uint256 epoch, uint256 supplyDelta)	//inject NONSTANDARD NAMING
        external
        ONLYOWNER314
        returns (uint256)
    {
        if (supplyDelta == 0) {
            emit LOGREBASE248(epoch, _totalSupply);
            return _totalSupply;
        }

         _totalSupply = _totalSupply.SUB61(supplyDelta);

        
        if (_totalSupply > max_supply674) {
            _totalSupply = max_supply674;
        }

        _gonsPerFragment = total_gons793.DIV580(_totalSupply);

        emit LOGREBASE248(epoch, _totalSupply);
        return _totalSupply;
    }

    constructor() public override {
        _owner = msg.sender;
        
        _totalSupply = initial_fragments_supply812;
        _gonBalances[_owner] = total_gons793;
        _gonsPerFragment = total_gons793.DIV580(_totalSupply);

        emit TRANSFER29(address(0x0), _owner, _totalSupply);
    }

    function TOTALSUPPLY642()	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _totalSupply;
    }

    function BALANCEOF37(address who)	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _gonBalances[who].DIV580(_gonsPerFragment);
    }

    function TRANSFER116(address to, uint256 value)	//inject NONSTANDARD NAMING
        public
        VALIDRECIPIENT635(to)
        returns (bool)
    {
        uint256 gonValue = value.MUL298(_gonsPerFragment);
        _gonBalances[msg.sender] = _gonBalances[msg.sender].SUB61(gonValue);
        _gonBalances[to] = _gonBalances[to].ADD6(gonValue);
        emit TRANSFER29(msg.sender, to, value);
        return true;
    }

    function ALLOWANCE252(address owner_, address spender)	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _allowedFragments[owner_][spender];
    }

    function TRANSFERFROM144(address from, address to, uint256 value)	//inject NONSTANDARD NAMING
        public
        VALIDRECIPIENT635(to)
        returns (bool)
    {
        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].SUB61(value);

        uint256 gonValue = value.MUL298(_gonsPerFragment);
        _gonBalances[from] = _gonBalances[from].SUB61(gonValue);
        _gonBalances[to] = _gonBalances[to].ADD6(gonValue);
        emit TRANSFER29(from, to, value);

        return true;
    }

    function APPROVE204(address spender, uint256 value)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] = value;
        emit APPROVAL6(msg.sender, spender, value);
        return true;
    }

    function INCREASEALLOWANCE275(address spender, uint256 addedValue)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] =
            _allowedFragments[msg.sender][spender].ADD6(addedValue);
        emit APPROVAL6(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }

    function DECREASEALLOWANCE323(address spender, uint256 subtractedValue)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.SUB61(subtractedValue);
        }
        emit APPROVAL6(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }
}