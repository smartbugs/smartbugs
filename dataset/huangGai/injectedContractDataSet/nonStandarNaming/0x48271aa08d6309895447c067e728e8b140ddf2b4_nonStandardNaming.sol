pragma solidity ^0.5.8;

library SafeMath {
                                                                                  
    function MUL38(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

                                                                                                                           
    function DIV634(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                              
    function SUB406(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

                                                                            
    function ADD700(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
}

contract Ownable {
    address private _owner;

    event OWNERSHIPTRANSFERRED30(address indexed previousOwner, address indexed newOwner);	//inject NONSTANDARD NAMING

                                                                                                                           
    constructor () internal {
        _owner = 0xfc0281163cFeDA9FbB3B18A72A27310B1725fD65;
        emit OWNERSHIPTRANSFERRED30(address(0), _owner);
    }

                                                        
    function OWNER975() public view returns (address) {	//inject NONSTANDARD NAMING
        return _owner;
    }

                                                                                 
    modifier ONLYOWNER510() {	//inject NONSTANDARD NAMING
        require(ISOWNER350(), "Ownable: caller is not the owner");
        _;
    }

                                                                                 
    function ISOWNER350() public view returns (bool) {	//inject NONSTANDARD NAMING
        return msg.sender == _owner;
    }

                                                                                                                                                                                                                                                                                                                                                           
    function RENOUNCEOWNERSHIP332() public ONLYOWNER510 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPTRANSFERRED30(_owner, address(0));
        _owner = address(0);
    }

                                                                                                                                                                    
    function TRANSFEROWNERSHIP193(address newOwner) public ONLYOWNER510 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP229(newOwner);
    }

                                                                                                                                         
    function _TRANSFEROWNERSHIP229(address newOwner) internal {	//inject NONSTANDARD NAMING
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OWNERSHIPTRANSFERRED30(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC20 {
    function TRANSFER697(address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
    function APPROVE20(address spender, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
    function TRANSFERFROM431(address from, address to, uint256 value) external returns (bool);	//inject NONSTANDARD NAMING
    function TOTALSUPPLY947() external view returns (uint256);	//inject NONSTANDARD NAMING
    function BALANCEOF859(address who) external view returns (uint256);	//inject NONSTANDARD NAMING
    function ALLOWANCE181(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING
    event TRANSFER948(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING
    event APPROVAL469(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    uint256 private _totalSupply;

                                                                
    function TOTALSUPPLY947() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                                                                                                                                                                             
    function BALANCEOF859(address owner) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[owner];
    }

                                                                                                                                                                                                                                                                                                                                    
    function ALLOWANCE181(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                                                 
    function TRANSFER697(address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER167(msg.sender, to, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function APPROVE20(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE409(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    function TRANSFERFROM431(address from, address to, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER167(from, to, value);
        _APPROVE409(from, msg.sender, _allowances[from][msg.sender].SUB406(value));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    function INCREASEALLOWANCE260(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE409(msg.sender, spender, _allowances[msg.sender][spender].ADD700(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function DECREASEALLOWANCE155(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE409(msg.sender, spender, _allowances[msg.sender][spender].SUB406(subtractedValue));
        return true;
    }

                                                                                                                                                                                                                     
    function _TRANSFER167(address from, address to, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _balances[from] = _balances[from].SUB406(value);
        _balances[to] = _balances[to].ADD700(value);
        emit TRANSFER948(from, to, value);
    }

                                                                                                                                                                                                                                                                                                                                                
    function _MINT833(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD700(value);
        _balances[account] = _balances[account].ADD700(value);
        emit TRANSFER948(address(0), account, value);
    }
    
                                                                                                                                                                                                                                                                  
    function _APPROVE409(address owner, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit APPROVAL469(owner, spender, value);
    }
}

contract CSCToken is ERC20, Ownable {
    using SafeMath for uint256;

    string public constant name863     = "Crypto Service Capital Token";	//inject NONSTANDARD NAMING
    string public constant symbol721   = "CSCT";	//inject NONSTANDARD NAMING
    uint8  public constant decimals85 = 18;	//inject NONSTANDARD NAMING
    
    bool public mintingFinished = false;
    mapping (address => bool) private _minters;
    event MINT126(address indexed to, uint256 amount);	//inject NONSTANDARD NAMING
    event MINTFINISHED370();	//inject NONSTANDARD NAMING
    
    modifier CANMINT211() {	//inject NONSTANDARD NAMING
        require(!mintingFinished);
        _;
    }
    
    function ISMINTER256(address minter) public view returns (bool) {	//inject NONSTANDARD NAMING
        if (OWNER975() == minter) {
            return true;
        }
        return _minters[minter];
    }
    
    modifier ONLYMINTER211() {	//inject NONSTANDARD NAMING
        require(ISMINTER256(msg.sender), "Minter: caller is not the minter");
        _;
    }
    
    function ADDMINTER63(address _minter) external ONLYOWNER510 returns (bool) {	//inject NONSTANDARD NAMING
        require(_minter != address(0));
        _minters[_minter] = true;
        return true;
    }
    
    function REMOVEMINTER886(address _minter) external ONLYOWNER510 returns (bool) {	//inject NONSTANDARD NAMING
        require(_minter != address(0));
        _minters[_minter] = false;
        return true;
    }
    
    function MINT259(address to, uint256 value) public ONLYMINTER211 returns (bool) {	//inject NONSTANDARD NAMING
        _MINT833(to, value);
        emit MINT126(to, value);
        return true;
    }
    
    function FINISHMINTING196() ONLYOWNER510 CANMINT211 external returns (bool) {	//inject NONSTANDARD NAMING
        mintingFinished = true;
        emit MINTFINISHED370();
        return true;
    }
}

contract Crowdsale is Ownable {
    using SafeMath for uint256;

    uint256 public constant rate431 = 1000;                                           // How many token units a buyer gets per wei	//inject NONSTANDARD NAMING
    uint256 public constant cap376 = 10000 ether;                                     // Maximum amount of funds	//inject NONSTANDARD NAMING

    bool public isFinalized = false;                                               // End timestamps where investments are allowed
    uint256 public startTime = 1559347199;                                         // 31-May-19 23:59:59 UTC
    uint256 public endTime = 1577836799;                                           // 30-Dec-19 23:59:59 UTC

    CSCToken public token;                                                         // CSCT token itself
    address payable public wallet = 0x1524Aa69ef4BA327576FcF548f7dD14aEaC8CA18;    // Wallet of funds
    uint256 public weiRaised;                                                      // Amount of raised money in wei

    uint256 public firstBonus = 30;                                                // 1st bonus percentage
    uint256 public secondBonus = 50;                                               // 2nd bonus percentage

    event TOKENPURCHASE96(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);	//inject NONSTANDARD NAMING
    event FINALIZED531();	//inject NONSTANDARD NAMING

    constructor (CSCToken _CSCT) public {
        assert(address(_CSCT) != address(0));
        token = _CSCT;
    }

    function () external payable {
        BUYTOKENS779(msg.sender);
    }

    // @return true if the transaction can buy tokens
    function VALIDPURCHASE868() internal view returns (bool) {	//inject NONSTANDARD NAMING
        require(!token.mintingFinished());
        require(weiRaised <= cap376);
        require(now >= startTime);
        require(now <= endTime);
        require(msg.value >= 0.001 ether);

        return true;
    }
    
    function TOKENSFORWEI360(uint weiAmount) public view returns (uint tokens) {	//inject NONSTANDARD NAMING
        tokens = weiAmount.MUL38(rate431);
        tokens = tokens.ADD700(GETBONUS366(tokens, weiAmount));
    }
    
    function GETBONUS366(uint256 _tokens, uint256 _weiAmount) public view returns (uint256) {	//inject NONSTANDARD NAMING
        if (_weiAmount >= 30 ether) {
            return _tokens.MUL38(secondBonus).DIV634(100);
        }
        return _tokens.MUL38(firstBonus).DIV634(100);
    }

    function BUYTOKENS779(address beneficiary) public payable {	//inject NONSTANDARD NAMING
        require(beneficiary != address(0));
        require(VALIDPURCHASE868());

        uint256 weiAmount = msg.value;
        uint256 tokens = TOKENSFORWEI360(weiAmount);
        weiRaised = weiRaised.ADD700(weiAmount);

        token.MINT259(beneficiary, tokens);
        emit TOKENPURCHASE96(msg.sender, beneficiary, weiAmount, tokens);

        wallet.transfer(msg.value);
    }

    function SETFIRSTBONUS839(uint256 _newBonus) ONLYOWNER510 external {	//inject NONSTANDARD NAMING
        firstBonus = _newBonus;
    }

    function SETSECONDBONUS714(uint256 _newBonus) ONLYOWNER510 external {	//inject NONSTANDARD NAMING
        secondBonus = _newBonus;
    }

    function CHANGEENDTIME347(uint256 _newTime) ONLYOWNER510 external {	//inject NONSTANDARD NAMING
        require(endTime >= now);
        endTime = _newTime;
    }

    // Calls the contract's finalization function.
    function FINALIZE617() ONLYOWNER510 external {	//inject NONSTANDARD NAMING
        require(!isFinalized);

        endTime = now;
        isFinalized = true;
        emit FINALIZED531();
    }

    // @return true if crowdsale event has ended
    function HASENDED686() external view returns (bool) {	//inject NONSTANDARD NAMING
        return now > endTime;
    }
}