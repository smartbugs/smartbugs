                                                                 

pragma solidity 0.6.0;

library SafeMath {
    function ADD9(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function SUB540(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB540(a, b, "SafeMath: subtraction overflow");
    }

    function SUB540(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function MUL332(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function DIV936(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV936(a, b, "SafeMath: division by zero");
    }

    function DIV936(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function MOD646(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD646(a, b, "SafeMath: modulo by zero");
    }

    function MOD646(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable {
    address public _owner;

    event OWNERSHIPTRANSFERRED351(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

    constructor () public {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED351(address(0), msg.sender);
    }

    function OWNER434() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

    modifier ONLYOWNER801() {	//inject NONSTANDARD NAMING
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function RENOUNCEOWNERSHIP444() public virtual ONLYOWNER801 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED351(_owner, address(0));
        _owner = address(0);
    }

    function TRANSFEROWNERSHIP217(address newOwner) public virtual ONLYOWNER801 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED351(_owner, newOwner);
        _owner = newOwner;
    }
}

contract BunMaker is Ownable {

    using SafeMath for uint256;

    event LOGREBASE766(uint256 indexed epoch, uint256 totalSupply);	//inject NONSTANDARD NAMING

    modifier VALIDRECIPIENT940(address to) {	//inject NONSTANDARD NAMING
        require(to != address(this));
        _;
    }
    
    event TRANSFER28(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL631(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

    string public constant name466 = "BunMaker";	//inject NONSTANDARD NAMING
    string public constant symbol199 = "BUN";	//inject NONSTANDARD NAMING
    uint256 public constant decimals570 = 18;	//inject NONSTANDARD NAMING

    uint256 private constant decimals570 = 18;	//inject NONSTANDARD NAMING
    uint256 private constant max_uint256414 = ~uint256(0);	//inject NONSTANDARD NAMING
    uint256 private constant initial_fragments_supply857 = 12000 * 10**decimals570;	//inject NONSTANDARD NAMING

    uint256 private constant total_gons112 = max_uint256414 - (max_uint256414 % initial_fragments_supply857);	//inject NONSTANDARD NAMING

    uint256 private constant max_supply579 = ~uint128(0);	//inject NONSTANDARD NAMING

    uint256 private _totalSupply;
    uint256 private _gonsPerFragment;
    mapping(address => uint256) private _gonBalances;

    mapping (address => mapping (address => uint256)) private _allowedFragments;
    

    function REBASE625(uint256 epoch, uint256 supplyDelta)	//inject NONSTANDARD NAMING
        external
        ONLYOWNER801
        returns (uint256)
    {
        if (supplyDelta == 0) {
            emit LOGREBASE766(epoch, _totalSupply);
            return _totalSupply;
        }

         _totalSupply = _totalSupply.SUB540(supplyDelta);

        
        if (_totalSupply > max_supply579) {
            _totalSupply = max_supply579;
        }

        _gonsPerFragment = total_gons112.DIV936(_totalSupply);

        emit LOGREBASE766(epoch, _totalSupply);
        return _totalSupply;
    }

    constructor() public override {
        _owner = msg.sender;
        
        _totalSupply = initial_fragments_supply857;
        _gonBalances[_owner] = total_gons112;
        _gonsPerFragment = total_gons112.DIV936(_totalSupply);

        emit TRANSFER28(address(0x0), _owner, _totalSupply);
    }

    function TOTALSUPPLY512()	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _totalSupply;
    }

    function BALANCEOF91(address who)	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _gonBalances[who].DIV936(_gonsPerFragment);
    }

    function TRANSFER839(address to, uint256 value)	//inject NONSTANDARD NAMING
        public
        VALIDRECIPIENT940(to)
        returns (bool)
    {
        uint256 gonValue = value.MUL332(_gonsPerFragment);
        _gonBalances[msg.sender] = _gonBalances[msg.sender].SUB540(gonValue);
        _gonBalances[to] = _gonBalances[to].ADD9(gonValue);
        emit TRANSFER28(msg.sender, to, value);
        return true;
    }

    function ALLOWANCE108(address owner_, address spender)	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _allowedFragments[owner_][spender];
    }

    function TRANSFERFROM75(address from, address to, uint256 value)	//inject NONSTANDARD NAMING
        public
        VALIDRECIPIENT940(to)
        returns (bool)
    {
        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].SUB540(value);

        uint256 gonValue = value.MUL332(_gonsPerFragment);
        _gonBalances[from] = _gonBalances[from].SUB540(gonValue);
        _gonBalances[to] = _gonBalances[to].ADD9(gonValue);
        emit TRANSFER28(from, to, value);

        return true;
    }

    function APPROVE139(address spender, uint256 value)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] = value;
        emit APPROVAL631(msg.sender, spender, value);
        return true;
    }

    function INCREASEALLOWANCE514(address spender, uint256 addedValue)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] =
            _allowedFragments[msg.sender][spender].ADD9(addedValue);
        emit APPROVAL631(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }

    function DECREASEALLOWANCE401(address spender, uint256 subtractedValue)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.SUB540(subtractedValue);
        }
        emit APPROVAL631(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }
}