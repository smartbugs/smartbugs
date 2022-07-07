pragma solidity ^0.5.5;

contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract WuzuStandardToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint internal _totalSupply;
    address private _owner;
    string private _uri;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event UriChanged(string previousUri, string newUri);

    constructor(string memory _symbol, uint8 _decimals, string memory _tokenUri) public {
        require(bytes(_tokenUri).length <= 255);
        symbol = _symbol;
        name = _symbol;
        decimals = _decimals;
        _totalSupply = 0;
        _owner = msg.sender;
        _uri = _tokenUri;
        emit OwnershipTransferred(address(0), _owner);
        emit UriChanged("", _uri);
    }

    function owner() public view returns (address) {
        return _owner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "new owner can't be the zero address");
        emit OwnershipTransferred(_owner, newOwner);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _owner = newOwner;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply  - balances[address(0)];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function tokenURI() external view returns (string memory) {
        return _uri;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function changeUri(string memory newUri) public onlyOwner {
        require(bytes(newUri).length <= 255);
        emit UriChanged(_uri, newUri);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _uri = newUri;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[to] = safeAdd(balances[to], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        balances[to] = safeAdd(balances[to], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
    }

    function mint(address to, uint tokens) public onlyOwner {
        balances[to] = safeAdd(balances[to], tokens);	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        _totalSupply += tokens;	//inject NONPUBLIC VAR ACCESSD BY PUBLIC FUNC
        emit Transfer(address(0), to, tokens);
    }

    function () external payable {
        revert();
    }
}