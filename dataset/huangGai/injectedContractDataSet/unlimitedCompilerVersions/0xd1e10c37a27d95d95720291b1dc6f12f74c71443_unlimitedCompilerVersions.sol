pragma solidity ^0.5.4;	//inject UNLIMITED COMPILER VERSIONS

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
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;       
    }       

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}

contract ERC20 {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function allowance(address owner, address spender) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Ownable {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() public {
        owner = msg.sender;
        newOwner = address(0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    modifier onlyNewOwner() {
        require(msg.sender == newOwner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0));
        newOwner = _newOwner;
    }

    function acceptOwnership() public onlyNewOwner returns(bool) {
        emit OwnershipTransferred(owner, newOwner);        
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Whitelist is Ownable {
    using SafeMath for uint256;

    mapping (address => bool) public whitelist;
    
    event AddWhiteListAddress(address indexed _address);
    event RemoveWhiteListAddress(address indexed _address);


    constructor() public {
        whitelist[owner] = true;
    }
    
    function AddWhitelist(address account) public onlyOwner returns(bool) {
        require(account != address(0));
        require(whitelist[account] == false);
        require(account != address(this));
        whitelist[account] = true;
        emit AddWhiteListAddress(account);
        return true;
    }

    function RemoveWhiltelist(address account) public onlyOwner returns(bool) {
        require(account != address(0));
        require(whitelist[account] == true);
        require(account != owner);
        whitelist[account] = false;
        emit RemoveWhiteListAddress(account);
        return true;
    }
}

contract Pausable is Ownable, Whitelist {
    event Pause();
    event Unpause();

    bool public paused = false;

    modifier whenNotPaused() {
        require(whitelist[msg.sender] == true || !paused);
        _;
    }

    modifier whenPaused() {
        require(paused);
        _;
    }

    function pause() onlyOwner whenNotPaused public {
        paused = true;
        emit Pause();
    }

    function unpause() onlyOwner whenPaused public {
        paused = false;
        emit Unpause();
    }
}

contract Blacklist is Ownable {
    using SafeMath for uint256;

    mapping (address => bool) public blacklist;
    
    event AddBlackListAddress(address indexed _address);
    event RemoveBlackListAddress(address indexed _address);


    constructor() public {
        
    }
    
    function AddBlacklist(address account) public onlyOwner returns(bool) {
        require(account != address(0));
        require(blacklist[account] == false);
        require(account != address(this));
        require(account != owner);

        blacklist[account] = true;
        emit AddBlackListAddress(account);
        return true;
    }

    function RemoveBlacklist(address account) public onlyOwner returns(bool) {
        require(account != address(0));
        require(blacklist[account] == true);
        blacklist[account] = false;
        emit RemoveBlackListAddress(account);
        return true;
    }
}

contract CosmoCoin is ERC20, Ownable, Pausable, Blacklist{
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) internal allowed;
    
    string private _name = "CosmoCoin";
    string private _symbol = "COSM";
    uint8 private _decimals = 18;
    uint256 private totalTokenSupply;
    
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, address indexed at, uint256 value);
    
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    constructor(uint256 _totalSupply) public {
        require(_totalSupply > 0);
        totalTokenSupply = _totalSupply.mul(10 ** uint(_decimals));
        balances[msg.sender] = totalTokenSupply;
        emit Transfer(address(0), msg.sender, totalTokenSupply);
    }
    
    function totalSupply() public view returns (uint256) {
        return totalTokenSupply;
    }
    
    function balanceOf(address _who) public view returns(uint256) {
        return balances[_who];
    }
    
    function transfer(address _to, uint256 _amount) public whenNotPaused returns(bool) {
        require(_to != address(0));
        require(_to != address(this));
        require(_amount > 0);
        require(_amount <= balances[msg.sender]);
        require(blacklist[msg.sender] == false);
        require(blacklist[_to] == false);

        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _amount) public whenNotPaused returns(bool) {
        require(_to != address(0));
        require(_to != address(this));
        require(_amount <= balances[_from]);
        require(_amount <= allowed[_from][msg.sender]);
        require(blacklist[_from] == false);
        require(blacklist[_to] == false);
        require(blacklist[msg.sender] == false);

        balances[_from] = balances[_from].sub(_amount);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) public returns(bool) {
        // reduce spender's allowance to 0 then set desired value after to avoid race condition
        require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns(uint256) {
        return allowed[_owner][_spender];
    }
    
    function () payable external{
        revert();
    }
    
    function burn(address _address, uint256 _value) external whenNotPaused {
        require(_value <= balances[_address]);
        require((whitelist[msg.sender] == true && _address == msg.sender) || (msg.sender == owner));
        balances[_address] = balances[_address].sub(_value);
        totalTokenSupply = totalTokenSupply.sub(_value);
        emit Burn(msg.sender, _address, _value);
        emit Transfer(_address, address(0), _value);
    }
    
    function mintTokens(address _beneficiary, uint256 _value) external onlyOwner {
        require(_beneficiary != address(0));
        require(blacklist[_beneficiary] == false);
        require(_value > 0);
        balances[_beneficiary] = balances[_beneficiary].add(_value);
        totalTokenSupply = totalTokenSupply.add(_value);
        emit Mint(_beneficiary, _value);
        emit Transfer(address(0), _beneficiary, _value);
    }
}