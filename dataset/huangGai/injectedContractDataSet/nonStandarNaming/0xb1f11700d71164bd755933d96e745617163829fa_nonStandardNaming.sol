                                                                 

pragma solidity 0.6.0;

library SafeMath {
    function ADD202(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function SUB668(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return SUB668(a, b, "SafeMath: subtraction overflow");
    }

    function SUB668(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function MUL110(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function DIV545(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return DIV545(a, b, "SafeMath: division by zero");
    }

    function DIV545(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function MOD810(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        return MOD810(a, b, "SafeMath: modulo by zero");
    }

    function MOD810(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable {
    address public _owner;

    event OWNERSHIPTRANSFERRED909(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

    constructor () public {
        _owner = msg.sender;
        emit OWNERSHIPTRANSFERRED909(address(0), msg.sender);
    }

    function OWNER102() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

    modifier ONLYOWNER738() {	//inject NONSTANDARD NAMING
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function RENOUNCEOWNERSHIP996() public virtual ONLYOWNER738 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED909(_owner, address(0));
        _owner = address(0);
    }

    function TRANSFEROWNERSHIP485(address newOwner) public virtual ONLYOWNER738 {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED909(_owner, newOwner);
        _owner = newOwner;
    }
}

contract yf12 is Ownable {

    using SafeMath for uint256;

    event LOGREBASE2(uint256 indexed epoch, uint256 totalSupply);	//inject NONSTANDARD NAMING

    modifier VALIDRECIPIENT984(address to) {	//inject NONSTANDARD NAMING
        require(to != address(this));
        _;
    }
    
    event TRANSFER951(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL27(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING

    string public constant name540 = "yf12";	//inject NONSTANDARD NAMING
    string public constant symbol317 = "yf12";	//inject NONSTANDARD NAMING
    uint256 public constant decimals461 = 18;	//inject NONSTANDARD NAMING

    uint256 private constant decimals461 = 18;	//inject NONSTANDARD NAMING
    uint256 private constant max_uint256343 = ~uint256(0);	//inject NONSTANDARD NAMING
    uint256 private constant initial_fragments_supply392 = 30000 * 10**decimals461;	//inject NONSTANDARD NAMING

    uint256 private constant total_gons797 = max_uint256343 - (max_uint256343 % initial_fragments_supply392);	//inject NONSTANDARD NAMING

    uint256 private constant max_supply952 = ~uint128(0);	//inject NONSTANDARD NAMING

    uint256 private _totalSupply;
    uint256 private _gonsPerFragment;
    mapping(address => uint256) private _gonBalances;

    mapping (address => mapping (address => uint256)) private _allowedFragments;
    

    function REBASE210(uint256 epoch, uint256 supplyDelta)	//inject NONSTANDARD NAMING
        external
        ONLYOWNER738
        returns (uint256)
    {
        if (supplyDelta == 0) {
            emit LOGREBASE2(epoch, _totalSupply);
            return _totalSupply;
        }

         _totalSupply = _totalSupply.SUB668(supplyDelta);

        
        if (_totalSupply > max_supply952) {
            _totalSupply = max_supply952;
        }

        _gonsPerFragment = total_gons797.DIV545(_totalSupply);

        emit LOGREBASE2(epoch, _totalSupply);
        return _totalSupply;
    }

    constructor() public override {
        _owner = msg.sender;
        
        _totalSupply = initial_fragments_supply392;
        _gonBalances[_owner] = total_gons797;
        _gonsPerFragment = total_gons797.DIV545(_totalSupply);

        emit TRANSFER951(address(0x0), _owner, _totalSupply);
    }

    function TOTALSUPPLY931()	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _totalSupply;
    }

    function BALANCEOF361(address who)	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _gonBalances[who].DIV545(_gonsPerFragment);
    }

    function TRANSFER213(address to, uint256 value)	//inject NONSTANDARD NAMING
        public
        VALIDRECIPIENT984(to)
        returns (bool)
    {
        uint256 gonValue = value.MUL110(_gonsPerFragment);
        _gonBalances[msg.sender] = _gonBalances[msg.sender].SUB668(gonValue);
        _gonBalances[to] = _gonBalances[to].ADD202(gonValue);
        emit TRANSFER951(msg.sender, to, value);
        return true;
    }

    function ALLOWANCE963(address owner_, address spender)	//inject NONSTANDARD NAMING
        public
        view
        returns (uint256)
    {
        return _allowedFragments[owner_][spender];
    }

    function TRANSFERFROM958(address from, address to, uint256 value)	//inject NONSTANDARD NAMING
        public
        VALIDRECIPIENT984(to)
        returns (bool)
    {
        _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].SUB668(value);

        uint256 gonValue = value.MUL110(_gonsPerFragment);
        _gonBalances[from] = _gonBalances[from].SUB668(gonValue);
        _gonBalances[to] = _gonBalances[to].ADD202(gonValue);
        emit TRANSFER951(from, to, value);

        return true;
    }

    function APPROVE411(address spender, uint256 value)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] = value;
        emit APPROVAL27(msg.sender, spender, value);
        return true;
    }

    function INCREASEALLOWANCE727(address spender, uint256 addedValue)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        _allowedFragments[msg.sender][spender] =
            _allowedFragments[msg.sender][spender].ADD202(addedValue);
        emit APPROVAL27(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }

    function DECREASEALLOWANCE466(address spender, uint256 subtractedValue)	//inject NONSTANDARD NAMING
        public
        returns (bool)
    {
        uint256 oldValue = _allowedFragments[msg.sender][spender];
        if (subtractedValue >= oldValue) {
            _allowedFragments[msg.sender][spender] = 0;
        } else {
            _allowedFragments[msg.sender][spender] = oldValue.SUB668(subtractedValue);
        }
        emit APPROVAL27(msg.sender, spender, _allowedFragments[msg.sender][spender]);
        return true;
    }
}