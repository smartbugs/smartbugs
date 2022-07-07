pragma solidity ^0.5.1;

contract SC {
    address public owner;
    string public symbol;
    string public name;
    uint8 public decimals = 10;
    uint tokenSupply = 0;
    bool public paused = false;
    uint[7] milestones = [200000000000000000,700000000000000000,1300000000000000000,1600000000000000000,1800000000000000000,1900000000000000000,2000000000000000000];
    uint[7] conversion = [8125000,5078100,1103800,380800,114600,31300,15600];
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    modifier notPaused {
        require(paused == false);
        _;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Pause();
    event UnPause();
    event Burn(uint amount);
    event Mint(uint amount);

    constructor(string memory _name) public {
        owner = msg.sender;
        balances[msg.sender] = 0;
        symbol = _name;
        name = _name;

    }

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

    function burn(uint amount) public onlyOwner {
        if (balances[owner] < amount) revert();
        balances[owner] = safeSub(balances[owner], amount);
        tokenSupply = safeSub(tokenSupply, amount);
        emit Burn(amount);
    }

    function mintFromTraded(uint tradedAmount) public onlyOwner returns (uint minted) {
        uint toMint = 0;
        uint ts = tokenSupply;

        for (uint8 ml = 0; ml <= 6; ml++) {
            if (ts >= milestones[ml]) {
                continue;
            }
            if (ts + tradedAmount * conversion[ml] < milestones[ml]) {
                toMint += tradedAmount * conversion[ml];
                ts += tradedAmount * conversion[ml];
                tradedAmount = 0;
                break;
            }
            uint diff = (milestones[ml] - ts) / conversion[ml];
            tradedAmount -= diff;
            toMint += milestones[ml] - ts;
            ts = milestones[ml];
        }
        if (tradedAmount > 0) {
            toMint += tradedAmount * conversion[6];
            ts += tradedAmount * conversion[6];
        }

        tokenSupply = ts;
        balances[owner] = safeAdd(balances[owner], toMint);
        emit Mint(toMint);

        return toMint;
    }

    function totalSupply() public view returns (uint) {
        return tokenSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public notPaused returns (bool success) {
        if (tokens <= 0) revert();
        if (to == address(0)) revert();
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public notPaused returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public notPaused returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function etherBalance() public view onlyOwner returns (uint balance) {
        return address(this).balance;
    }

    function sendEther(uint amount, address payable to) public onlyOwner {
        to.transfer(amount);	//injected SHORT ADDRESS ATTACK

    }

    function pause() public notPaused onlyOwner {
        paused = true;
        emit Pause();
    }

    function unPause() public onlyOwner {
        if (paused == false) revert();
        paused = false;
        emit UnPause();
    }

    function() external payable {}
}