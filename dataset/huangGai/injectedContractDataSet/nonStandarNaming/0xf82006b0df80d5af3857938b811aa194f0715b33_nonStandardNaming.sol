                                                                 

                                                                 

pragma solidity ^0.5.17;

interface IERC20 {
    function TOTALSUPPLY313() external view returns (uint);	//inject NONSTANDARD NAMING
    function BALANCEOF488(address account) external view returns (uint);	//inject NONSTANDARD NAMING
    function TRANSFER197(address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function ALLOWANCE10(address owner, address spender) external view returns (uint);	//inject NONSTANDARD NAMING
    function APPROVE847(address spender, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM795(address sender, address recipient, uint amount) external returns (bool);	//inject NONSTANDARD NAMING
    event TRANSFER740(address indexed from, address indexed to, uint value);	//inject NONSTANDARD NAMING
    event APPROVAL4(address indexed owner, address indexed spender, uint value);	//inject NONSTANDARD NAMING
}

library SafeMath {
    function ADD959(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function SUB742(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return SUB742(a, b, "SafeMath: subtraction overflow");
    }
    function SUB742(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function MUL674(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function DIV198(uint a, uint b) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        return DIV198(a, b, "SafeMath: division by zero");
    }
    function DIV198(uint a, uint b, string memory errorMessage) internal pure returns (uint) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

contract ERC20 is IERC20 {
    using SafeMath for uint;

    mapping (address => uint) private _balances;

    mapping (address => mapping (address => uint)) private _allowances;

    uint private _totalSupply;
    function TOTALSUPPLY313() public view returns (uint) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }
    function BALANCEOF488(address account) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }
    function TRANSFER197(address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER102(msg.sender, recipient, amount);
        return true;
    }
    function ALLOWANCE10(address owner, address spender) public view returns (uint) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }
    function APPROVE847(address spender, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE525(msg.sender, spender, amount);
        return true;
    }
    function TRANSFERFROM795(address sender, address recipient, uint amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER102(sender, recipient, amount);
        _APPROVE525(sender, msg.sender, _allowances[sender][msg.sender].SUB742(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function INCREASEALLOWANCE946(address spender, uint addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE525(msg.sender, spender, _allowances[msg.sender][spender].ADD959(addedValue));
        return true;
    }
    function DECREASEALLOWANCE167(address spender, uint subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE525(msg.sender, spender, _allowances[msg.sender][spender].SUB742(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _TRANSFER102(address sender, address recipient, uint amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB742(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].ADD959(amount);
        emit TRANSFER740(sender, recipient, amount);
    }
    function _MINT358(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD959(amount);
        _balances[account] = _balances[account].ADD959(amount);
        emit TRANSFER740(address(0), account, amount);
    }
    function _BURN576(address account, uint amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].SUB742(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.SUB742(amount);
        emit TRANSFER740(account, address(0), amount);
    }
    function _APPROVE525(address owner, address spender, uint amount) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit APPROVAL4(owner, spender, amount);
    }
}

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    function NAME516() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _name;
    }
    function SYMBOL328() public view returns (string memory) {	//inject NONSTANDARD NAMING
        return _symbol;
    }
    function DECIMALS972() public view returns (uint8) {	//inject NONSTANDARD NAMING
        return _decimals;
    }
}

interface BondingCurve {
    function CALCULATEPURCHASERETURN628(uint _supply,  uint _reserveBalance, uint32 _reserveRatio, uint _depositAmount) external view returns (uint);	//inject NONSTANDARD NAMING
    function CALCULATESALERETURN903(uint _supply, uint _reserveBalance, uint32 _reserveRatio, uint _sellAmount) external view returns (uint);	//inject NONSTANDARD NAMING
}

contract ContinuousToken is ERC20 {
    using SafeMath for uint;

    uint public scale = 10**18;
    uint public reserveBalance = 1*10**15;
    uint32 public reserveRatio;
    
    BondingCurve constant public curve79 = BondingCurve(0x16F6664c16beDE5d70818654dEfef11769D40983);	//inject NONSTANDARD NAMING

    function _BUY48(uint _amount) internal returns (uint _bought) {	//inject NONSTANDARD NAMING
        _bought = _CONTINUOUSMINT40(_amount);
    }

    function _SELL6(uint _amount) internal returns (uint _sold) {	//inject NONSTANDARD NAMING
        _sold = _CONTINUOUSBURN983(_amount);
    }

    function CALCULATECONTINUOUSMINTRETURN393(uint _amount) public view returns (uint mintAmount) {	//inject NONSTANDARD NAMING
        return curve79.CALCULATEPURCHASERETURN628(TOTALSUPPLY313(), reserveBalance, uint32(reserveRatio), _amount);
    }

    function CALCULATECONTINUOUSBURNRETURN418(uint _amount) public view returns (uint burnAmount) {	//inject NONSTANDARD NAMING
        return curve79.CALCULATESALERETURN903(TOTALSUPPLY313(), reserveBalance, uint32(reserveRatio), _amount);
    }

    function _CONTINUOUSMINT40(uint _deposit) internal returns (uint) {	//inject NONSTANDARD NAMING
        uint amount = CALCULATECONTINUOUSMINTRETURN393(_deposit);
        reserveBalance = reserveBalance.ADD959(_deposit);
        return amount;
    }

    function _CONTINUOUSBURN983(uint _amount) internal returns (uint) {	//inject NONSTANDARD NAMING
        uint reimburseAmount = CALCULATECONTINUOUSBURNRETURN418(_amount);
        reserveBalance = reserveBalance.SUB742(reimburseAmount);
        return reimburseAmount;
    }
}

contract EminenceCurrency is ContinuousToken, ERC20Detailed {
    mapping(address => bool) public gamemasters;
    mapping(address => bool) public npcs;
    
    event ADDGM365(address indexed newGM, address indexed gm);	//inject NONSTANDARD NAMING
    event REVOKEGM307(address indexed newGM, address indexed gm);	//inject NONSTANDARD NAMING
    event ADDNPC414(address indexed newNPC, address indexed gm);	//inject NONSTANDARD NAMING
    event REVOKENPC62(address indexed newNPC, address indexed gm);	//inject NONSTANDARD NAMING
    event CASHSHOPBUY855(address _from, uint  _amount, uint _deposit);	//inject NONSTANDARD NAMING
    event CASHSHOPSELL318(address _from, uint  _amount, uint _reimbursement);	//inject NONSTANDARD NAMING
    
    IERC20 constant public dai417 = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);	//inject NONSTANDARD NAMING
    
    constructor (string memory name, string memory symbol, uint32 _reserveRatio) public ERC20Detailed(name, symbol, 18) {
        gamemasters[msg.sender] = true;
        reserveRatio = _reserveRatio;
        _MINT358(msg.sender, 1*scale);
    }
    function ADDNPC781(address _npc) external {	//inject NONSTANDARD NAMING
        require(gamemasters[msg.sender], "!gm");
        npcs[_npc] = true;
        emit ADDNPC414(_npc, msg.sender);
    }
    function REVOKENPC754(address _npc) external {	//inject NONSTANDARD NAMING
        require(gamemasters[msg.sender], "!gm");
        npcs[_npc] = false;
        emit REVOKENPC62(_npc, msg.sender);
    }
    function ADDGM496(address _gm) external {	//inject NONSTANDARD NAMING
        require(gamemasters[msg.sender]||gamemasters[tx.origin], "!gm");
        gamemasters[_gm] = true;
        emit ADDGM365(_gm, msg.sender);
    }
    function REVOKEGM619(address _gm) external {	//inject NONSTANDARD NAMING
        require(gamemasters[msg.sender], "!gm");
        gamemasters[_gm] = false;
        emit REVOKEGM307(_gm, msg.sender);
    }
    function AWARD423(address _to, uint _amount) external {	//inject NONSTANDARD NAMING
        require(gamemasters[msg.sender], "!gm");
        _MINT358(_to, _amount);
    }
    function CLAIM181(address _from, uint _amount) external {	//inject NONSTANDARD NAMING
        require(gamemasters[msg.sender]||npcs[msg.sender], "!gm");
        _BURN576(_from, _amount);
    }
    function BUY665(uint _amount, uint _min) external returns (uint _bought) {	//inject NONSTANDARD NAMING
        _bought = _BUY48(_amount);
        require(_bought >= _min, "slippage");
        dai417.TRANSFERFROM795(msg.sender, address(this), _amount);
        _MINT358(msg.sender, _bought);
        emit CASHSHOPBUY855(msg.sender, _bought, _amount);
    }
    function SELL118(uint _amount, uint _min) external returns (uint _bought) {	//inject NONSTANDARD NAMING
        _bought = _SELL6(_amount);
        require(_bought >= _min, "slippage");
        _BURN576(msg.sender, _amount);
        dai417.TRANSFER197(msg.sender, _bought);
        emit CASHSHOPSELL318(msg.sender, _amount, _bought);
    }
}