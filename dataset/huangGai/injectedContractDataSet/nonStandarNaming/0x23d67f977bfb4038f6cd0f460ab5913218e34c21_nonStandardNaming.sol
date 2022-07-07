                                                                 

pragma solidity 0.5.8;

// File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol

                                                                                                                                                      
interface IERC20 {
                                                                      
    function TOTALSUPPLY82() external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                            
    function BALANCEOF530(address account) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                     
    function TRANSFER438(address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                            
    function ALLOWANCE833(address owner, address spender) external view returns (uint256);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    function APPROVE538(address spender, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                                                                                                                                                            
    function TRANSFERFROM818(address sender, address recipient, uint256 amount) external returns (bool);	//inject NONSTANDARD NAMING

                                                                                                                                                                  
    event TRANSFER722(address indexed from, address indexed to, uint256 value);	//inject NONSTANDARD NAMING

                                                                                                                                                        
    event APPROVAL422(address indexed owner, address indexed spender, uint256 value);	//inject NONSTANDARD NAMING
}

// File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
library SafeMath {
                                                                                                                                                                                                                             
    function ADD23(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

                                                                                                                                                                                                                                                                 
    function SUB764(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

                                                                                                                                                                                                                                         
    function MUL177(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DIV24(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    function MOD404(uint256 a, uint256 b) internal pure returns (uint256) {	//inject NONSTANDARD NAMING
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) internal _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

                                                     
    function TOTALSUPPLY82() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _totalSupply;
    }

                                                   
    function BALANCEOF530(address account) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _balances[account];
    }

                                                                                                                                                                                                    
    function TRANSFER438(address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER27(msg.sender, recipient, amount);
        return true;
    }

                                                   
    function ALLOWANCE833(address owner, address spender) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return _allowances[owner][spender];
    }

                                                                                                                                   
    function APPROVE538(address spender, uint256 value) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE258(msg.sender, spender, value);
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function TRANSFERFROM818(address sender, address recipient, uint256 amount) public returns (bool) {	//inject NONSTANDARD NAMING
        _TRANSFER27(sender, recipient, amount);
        _APPROVE258(sender, msg.sender, _allowances[sender][msg.sender].SUB764(amount));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                    
    function INCREASEALLOWANCE45(address spender, uint256 addedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE258(msg.sender, spender, _allowances[msg.sender][spender].ADD23(addedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    function DECREASEALLOWANCE159(address spender, uint256 subtractedValue) public returns (bool) {	//inject NONSTANDARD NAMING
        _APPROVE258(msg.sender, spender, _allowances[msg.sender][spender].SUB764(subtractedValue));
        return true;
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    function _TRANSFER27(address sender, address recipient, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].SUB764(amount);
        _balances[recipient] = _balances[recipient].ADD23(amount);
        emit TRANSFER722(sender, recipient, amount);
    }

                                                                                                                                                                                                                                                                       
    function _MINT102(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.ADD23(amount);
        _balances[account] = _balances[account].ADD23(amount);
        emit TRANSFER722(address(0), account, amount);
    }

                                                                                                                                                                                                                                                                                                                        
    function _BURN692(address account, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(account != address(0), "ERC20: burn from the zero address");

        _totalSupply = _totalSupply.SUB764(value);
        _balances[account] = _balances[account].SUB764(value);
        emit TRANSFER722(account, address(0), value);
    }

                                                                                                                                                                                                                                                                                                                                                                                                                                  
    function _APPROVE258(address owner, address spender, uint256 value) internal {	//inject NONSTANDARD NAMING
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit APPROVAL422(owner, spender, value);
    }

                                                                                                                                                                          
    function _BURNFROM631(address account, uint256 amount) internal {	//inject NONSTANDARD NAMING
        _BURN692(account, amount);
        _APPROVE258(account, msg.sender, _allowances[account][msg.sender].SUB764(amount));
    }
}

// File: J\contracts\Goodluck(LUCK).sol

contract Goodluck is ERC20 {
    string public constant name423 = "Goodluck"; 	//inject NONSTANDARD NAMING
    string public constant symbol470 = "LUCK"; 	//inject NONSTANDARD NAMING
    uint8 public constant decimals728 = 18; 	//inject NONSTANDARD NAMING
    uint256 public constant initialsupply595 = 2000000000 * (10 ** uint256(decimals728));	//inject NONSTANDARD NAMING
    
    constructor() public {
        super._MINT102(msg.sender, initialsupply595);
        owner = msg.sender;
    }

    //ownership
    address public owner;

    event OWNERSHIPRENOUNCED774(address indexed previousOwner);	//inject NONSTANDARD NAMING
    event OWNERSHIPTRANSFERRED463(	//inject NONSTANDARD NAMING
    address indexed previousOwner,
    address indexed newOwner
    );

    modifier ONLYOWNER394() {	//inject NONSTANDARD NAMING
        require(msg.sender == owner, "Not owner");
        _;
    }

                                                                                                                                                                                                                                                                   
    function RENOUNCEOWNERSHIP445() public ONLYOWNER394 {	//inject NONSTANDARD NAMING
        emit OWNERSHIPRENOUNCED774(owner);
        owner = address(0);
    }

                                                                                                                                                             
    function TRANSFEROWNERSHIP781(address _newOwner) public ONLYOWNER394 {	//inject NONSTANDARD NAMING
        _TRANSFEROWNERSHIP16(_newOwner);
    }

                                                                                                                                  
    function _TRANSFEROWNERSHIP16(address _newOwner) internal {	//inject NONSTANDARD NAMING
        require(_newOwner != address(0), "Already owner");
        emit OWNERSHIPTRANSFERRED463(owner, _newOwner);
        owner = _newOwner;
    }

    //pausable
    event PAUSE475();	//inject NONSTANDARD NAMING
    event UNPAUSE568();	//inject NONSTANDARD NAMING

    bool public paused = false;
    
                                                                                                    
    modifier WHENNOTPAUSED995() {	//inject NONSTANDARD NAMING
        require(!paused, "Paused by owner");
        _;
    }

                                                                                                
    modifier WHENPAUSED712() {	//inject NONSTANDARD NAMING
        require(paused, "Not paused now");
        _;
    }

                                                                              
    function PAUSE841() public ONLYOWNER394 WHENNOTPAUSED995 {	//inject NONSTANDARD NAMING
        paused = true;
        emit PAUSE475();
    }

                                                                                 
    function UNPAUSE13() public ONLYOWNER394 WHENPAUSED712 {	//inject NONSTANDARD NAMING
        paused = false;
        emit UNPAUSE568();
    }

    //freezable
    event FROZEN932(address target);	//inject NONSTANDARD NAMING
    event UNFROZEN285(address target);	//inject NONSTANDARD NAMING

    mapping(address => bool) internal freezes;

    modifier WHENNOTFROZEN284() {	//inject NONSTANDARD NAMING
        require(!freezes[msg.sender], "Sender account is locked.");
        _;
    }

    function FREEZE724(address _target) public ONLYOWNER394 {	//inject NONSTANDARD NAMING
        freezes[_target] = true;
        emit FROZEN932(_target);
    }

    function UNFREEZE196(address _target) public ONLYOWNER394 {	//inject NONSTANDARD NAMING
        freezes[_target] = false;
        emit UNFROZEN285(_target);
    }

    function ISFROZEN713(address _target) public view returns (bool) {	//inject NONSTANDARD NAMING
        return freezes[_target];
    }

    function TRANSFER438(	//inject NONSTANDARD NAMING
        address _to,
        uint256 _value
    )
      public
      WHENNOTFROZEN284
      WHENNOTPAUSED995
      returns (bool)
    {
        RELEASELOCK766(msg.sender);
        return super.TRANSFER438(_to, _value);
    }

    function TRANSFERFROM818(	//inject NONSTANDARD NAMING
        address _from,
        address _to,
        uint256 _value
    )
      public
      WHENNOTPAUSED995
      returns (bool)
    {
        require(!freezes[_from], "From account is locked.");
        RELEASELOCK766(_from);
        return super.TRANSFERFROM818(_from, _to, _value);
    }

    //mintable
    event MINT926(address indexed to, uint256 amount);	//inject NONSTANDARD NAMING

    function MINT957(	//inject NONSTANDARD NAMING
        address _to,
        uint256 _amount
    )
      public
      ONLYOWNER394
      returns (bool)
    {
        super._MINT102(_to, _amount);
        emit MINT926(_to, _amount);
        return true;
    }

    //burnable
    event BURN684(address indexed burner, uint256 value);	//inject NONSTANDARD NAMING

    function BURN342(address _who, uint256 _value) public ONLYOWNER394 {	//inject NONSTANDARD NAMING
        require(_value <= super.BALANCEOF530(_who), "Balance is too small.");

        _BURN692(_who, _value);
        emit BURN684(_who, _value);
    }

    //lockable
    struct LockInfo {
        uint256 releaseTime;
        uint256 balance;
    }
    mapping(address => LockInfo[]) internal lockInfo;

    event LOCK205(address indexed holder, uint256 value, uint256 releaseTime);	//inject NONSTANDARD NAMING
    event UNLOCK375(address indexed holder, uint256 value);	//inject NONSTANDARD NAMING

    function BALANCEOF530(address _holder) public view returns (uint256 balance) {	//inject NONSTANDARD NAMING
        uint256 lockedBalance = 0;
        for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
            lockedBalance = lockedBalance.ADD23(lockInfo[_holder][i].balance);
        }
        return super.BALANCEOF530(_holder).ADD23(lockedBalance);
    }

    function RELEASELOCK766(address _holder) internal {	//inject NONSTANDARD NAMING

        for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
            if (lockInfo[_holder][i].releaseTime <= now) {
                _balances[_holder] = _balances[_holder].ADD23(lockInfo[_holder][i].balance);
                emit UNLOCK375(_holder, lockInfo[_holder][i].balance);
                lockInfo[_holder][i].balance = 0;

                if (i != lockInfo[_holder].length - 1) {
                    lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
                    i--;
                }
                lockInfo[_holder].length--;

            }
        }
    }
    function LOCKCOUNT904(address _holder) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return lockInfo[_holder].length;
    }
    function LOCKSTATE154(address _holder, uint256 _idx) public view returns (uint256, uint256) {	//inject NONSTANDARD NAMING
        return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
    }

    function LOCK109(address _holder, uint256 _amount, uint256 _releaseTime) public ONLYOWNER394 {	//inject NONSTANDARD NAMING
        require(super.BALANCEOF530(_holder) >= _amount, "Balance is too small.");
        _balances[_holder] = _balances[_holder].SUB764(_amount);
        lockInfo[_holder].push(
            LockInfo(_releaseTime, _amount)
        );
        emit LOCK205(_holder, _amount, _releaseTime);
    }

    function LOCKAFTER210(address _holder, uint256 _amount, uint256 _afterTime) public ONLYOWNER394 {	//inject NONSTANDARD NAMING
        require(super.BALANCEOF530(_holder) >= _amount, "Balance is too small.");
        _balances[_holder] = _balances[_holder].SUB764(_amount);
        lockInfo[_holder].push(
            LockInfo(now + _afterTime, _amount)
        );
        emit LOCK205(_holder, _amount, now + _afterTime);
    }

    function UNLOCK592(address _holder, uint256 i) public ONLYOWNER394 {	//inject NONSTANDARD NAMING
        require(i < lockInfo[_holder].length, "No lock information.");

        _balances[_holder] = _balances[_holder].ADD23(lockInfo[_holder][i].balance);
        emit UNLOCK375(_holder, lockInfo[_holder][i].balance);
        lockInfo[_holder][i].balance = 0;

        if (i != lockInfo[_holder].length - 1) {
            lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
        }
        lockInfo[_holder].length--;
    }

    function TRANSFERWITHLOCK415(address _to, uint256 _value, uint256 _releaseTime) public ONLYOWNER394 returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0), "wrong address");
        require(_value <= super.BALANCEOF530(owner), "Not enough balance");

        _balances[owner] = _balances[owner].SUB764(_value);
        lockInfo[_to].push(
            LockInfo(_releaseTime, _value)
        );
        emit TRANSFER722(owner, _to, _value);
        emit LOCK205(_to, _value, _releaseTime);

        return true;
    }

    function TRANSFERWITHLOCKAFTER686(address _to, uint256 _value, uint256 _afterTime) public ONLYOWNER394 returns (bool) {	//inject NONSTANDARD NAMING
        require(_to != address(0), "wrong address");
        require(_value <= super.BALANCEOF530(owner), "Not enough balance");

        _balances[owner] = _balances[owner].SUB764(_value);
        lockInfo[_to].push(
            LockInfo(now + _afterTime, _value)
        );
        emit TRANSFER722(owner, _to, _value);
        emit LOCK205(_to, _value, now + _afterTime);

        return true;
    }

    function CURRENTTIME149() public view returns (uint256) {	//inject NONSTANDARD NAMING
        return now;
    }

    function AFTERTIME613(uint256 _value) public view returns (uint256) {	//inject NONSTANDARD NAMING
        return now + _value;
    }

    //airdrop
    mapping (address => uint256) public airDropHistory;
    event AIRDROP940(address _receiver, uint256 _amount);	//inject NONSTANDARD NAMING

    function DROPTOKEN612(address[] memory receivers, uint256[] memory values) ONLYOWNER394 public {	//inject NONSTANDARD NAMING
    require(receivers.length != 0);
    require(receivers.length == values.length);

    for (uint256 i = 0; i < receivers.length; i++) {
      address receiver = receivers[i];
      uint256 amount = values[i];

      TRANSFER438(receiver, amount);
      airDropHistory[receiver] += amount;

      emit AIRDROP940(receiver, amount);
    }
  }
}