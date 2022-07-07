/**
 *Submitted for verification at Etherscan.io on 2020-07-20
*/

pragma solidity ^0.6.9;

abstract contract IERC20 {
    function totalSupply() virtual public view returns (uint256);
    function balanceOf(address who) virtual public view returns (uint256);
    function allowance(address owner, address spender) virtual public view returns (uint256);
    function transfer(address to, uint256 value) virtual public returns (bool);
    function approve(address spender, uint256 value) virtual public returns (bool);
    function transferFrom(address from, address to, uint256 value) virtual public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        //require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        //require(c >= a);

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract Ownable {
    address payable internal _owner;
    event OwnershipTransferred(address owner, address newOwner);

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    constructor () public {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function transferOwnership(address payable newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Pausable is Ownable {
    address internal _pauser;
    bool private _paused = false;
    event Paused(address account);
    event Unpaused(address account);
    event PauserChanged(address indexed newPauser);

    modifier whenNotPaused() {
        require(!_paused, "It's paused");
        _;
    }

    modifier whenPaused() {
        require(_paused, "It's not paused");
        _;
    }

    modifier onlyPauser() {
        require(msg.sender == _pauser);
        _;
    }

    constructor () public {
        _paused = false;
        _pauser = msg.sender;
    }

    function pauser() public view returns (address){
        return _pauser;
    }

    function pause() public onlyPauser  {
        _paused = true;
        emit Paused(msg.sender);
    }

    function unPause() public onlyPauser {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    function updatePauser(address newPauser) public onlyOwner {
        require(newPauser != address(0));
        _pauser = newPauser;
        emit PauserChanged(newPauser);
    }
}

contract BlackListable is Ownable {
    address internal _blackLister;
    mapping (address => bool) internal _blackList;

    event BlackList(address account);
    event UnBlackList(address account);
    event BlackListerChanged(address newBlackLister);

    modifier whenNotBlackListed(address account) {
        require(!_blackList[account]);
        _;
    }

    modifier onlyBlackLister() {
        require(msg.sender == _blackLister);
        _;
    }

    constructor () public {
        _blackLister = msg.sender;
    }

    function blackLister() public view returns(address){
        return _blackLister;
    }

    function blackList(address account) public onlyBlackLister returns (bool) {
        require(account != address(0));
        require(account != _owner);
        _blackList[account] = true;
        emit BlackList(account);
        return true;
    }

    function unBlackList(address account) public onlyBlackLister returns (bool) {
        require(account != address(0));
        _blackList[account] = false;
        emit UnBlackList( account);
        return true;
    }

    function isBlackListed(address account) public view returns (bool){
        return _blackList[account];
    }

    function updateBlackLister(address newBlackLister) public onlyOwner {
        require(newBlackLister != address(0));
        _blackLister = newBlackLister;
        emit BlackListerChanged(newBlackLister);
    }
}

contract ERC20Token is IERC20,Ownable,Pausable,BlackListable {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) private _allowed;

    address private _minter;
    uint256 private _totalSupply;
    bool private _inited;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _maxSupply = 10*10**9*10**4;

    event MinterChanged(address newMinter);

    modifier onlyMinter() {
        require(msg.sender == _minter);
        _;
    }

    constructor () public {
        _minter = msg.sender;
    }
    
    function init(string memory name, string memory symbol, uint8 decimals, uint256 initSupply) public onlyOwner returns(bool){
        require(!_inited);
        
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        mint(initSupply);
        _inited = true;
        
        return true;
    }

    function name() public view returns(string memory) {
        return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

    function decimals() public view returns(uint8) {
        return _decimals;
    }

    function totalSupply() override public view returns (uint256) {
        return _totalSupply;
    }

    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    function minter() public view returns (address) {
        return _minter;
    }

    function balanceOf(address owner) override public view returns (uint256) {
        return _balances[owner];
    }

    function allowance(address owner, address spender) override public view returns (uint256) {
        return _allowed[owner][spender];
    }

    function transfer(address to, uint256 value) override
        public whenNotPaused
        whenNotBlackListed(msg.sender)
        whenNotBlackListed(to)
        returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) override
        public whenNotPaused
        whenNotBlackListed(msg.sender)
        whenNotBlackListed(spender)
        returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) override
        public whenNotPaused
        whenNotBlackListed(msg.sender)
        whenNotBlackListed(from)
        whenNotBlackListed(to)
        returns (bool) {
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);	//injected INTEGER OVERFLOW OR UNDERFLOW

        _transfer(from, to, value);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public whenNotPaused
        whenNotBlackListed(msg.sender)
        whenNotBlackListed(spender)
        returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public whenNotPaused
        whenNotBlackListed(msg.sender)
        whenNotBlackListed(spender)
        returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);	//injected INTEGER OVERFLOW OR UNDERFLOW

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    function mint(uint256 value) private onlyMinter whenNotBlackListed(msg.sender) returns (bool) {
        _mint(value);
        return true;
    }

    function burn(uint256 value) public onlyMinter whenNotPaused whenNotBlackListed(msg.sender) {
        _burn(msg.sender, value);
    }

    function updateMinter(address newMinter) public onlyOwner whenNotPaused {
        require(newMinter != address(0));
        _minter = newMinter;
        emit MinterChanged(newMinter);
    }

    //self kill contract
    function kill()  public onlyOwner{
        selfdestruct(_owner);
    }

    function _transfer(address from, address to, uint256 value) private {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    function _mint(uint256 value) private {
        require(_totalSupply.add(value) <= _maxSupply);

        _totalSupply = _totalSupply.add(value);
        _balances[_owner] = _balances[_owner].add(value);
        emit Transfer(address(0), _owner, value);
    }

    function _burn(address account, uint256 value) private {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    receive() external payable {
        if(msg.value > 0){
            _owner.transfer(msg.value);
        }
    }
}